Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Subject: [PATCH v6 15/15] xfs, dax: introduce xfs_break_dax_layouts()
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 15 Mar 2018 08:52:50 -0700
Message-ID: <152112917064.24669.8101553386217458496.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152112908134.24669.10222746224538377035.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152112908134.24669.10222746224538377035.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.orgjack@suse.czross.zwisler@linux.intel.comhch@lst.de, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

xfs_break_dax_layouts(), similar to xfs_break_leased_layouts(), scans
for busy / pinned dax pages and waits for those pages to go idle before
any potential extent unmap operation.

dax_layout_busy_page() handles synchronizing against new page-busy
events (get_user_pages). It invalidates all mappings to trigger the
get_user_pages slow path which will eventually block on the xfs inode
log held in XFS_MMAPLOCK_EXCL mode. If dax_layout_busy_page() finds a
busy page it returns it for xfs to wait for the page-idle event that
will fire when the page reference count reaches 1 (recall ZONE_DEVICE
pages are idle at count 1).

While waiting, the XFS_MMAPLOCK_EXCL lock is dropped in order to not
deadlock the process that might be trying to elevate the page count of
more pages before arranging for any of them to go idle. I.e. the typical
case of submitting I/O is that iov_iter_get_pages() elevates the
reference count of all pages in the I/O before starting I/O on the first
page.

Cc: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/xfs/xfs_file.c |   67 +++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 54 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 399c5221f101..2ccdbb19e31a 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -759,6 +759,38 @@ xfs_file_write_iter(
 	return ret;
 }
 
+static void
+xfs_wait_var_event(
+	struct inode		*inode,
+	uint			iolock)
+{
+	struct xfs_inode        *ip = XFS_I(inode);
+
+	xfs_iunlock(ip, iolock);
+	schedule();
+	xfs_ilock(ip, iolock);
+}
+
+static int
+xfs_break_dax_layouts(
+	struct inode		*inode,
+	uint			iolock)
+{
+	struct page		*page;
+	int			ret;
+
+	page = dax_layout_busy_page(inode->i_mapping);
+	if (!page)
+		return 0;
+
+	ret = ___wait_var_event(&page->_refcount,
+			atomic_read(&page->_refcount) == 1, TASK_INTERRUPTIBLE,
+			0, 0, xfs_wait_var_event(inode, iolock));
+	if (ret < 0)
+		return ret;
+	return 1;
+}
+
 int
 xfs_break_layouts(
 	struct inode		*inode,
@@ -766,23 +798,32 @@ xfs_break_layouts(
 	enum layout_break_reason reason)
 {
 	struct xfs_inode	*ip = XFS_I(inode);
-	int			ret;
+	int			ret = 0;
 
 	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL
 				| XFS_MMAPLOCK_EXCL));
 
-	switch (reason) {
-	case BREAK_TRUNCATE:
-		/* fall through */
-	case BREAK_WRITE:
-		ret = xfs_break_leased_layouts(inode, iolock);
-		if (ret > 0)
-			ret = 0;
-		break;
-	default:
-		ret = -EINVAL;
-		break;
-	}
+	do {
+		switch (reason) {
+		case BREAK_TRUNCATE:
+			ret = xfs_break_dax_layouts(inode, *iolock);
+			/* fall through */
+		case BREAK_WRITE:
+			if (ret != 0)
+				break;
+			ret = xfs_break_leased_layouts(inode, iolock);
+			break;
+		default:
+			ret = -EINVAL;
+			break;
+		}
+		/*
+		 * This loop terminates when either layout break attempt
+		 * returns an error, or both layout break attempts
+		 * return 0, i.e. layouts are verified broken while
+		 * holding all required locks.
+		 */
+	} while (ret > 0);
 
 	return ret;
 }
