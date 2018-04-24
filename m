Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8612C220E8E18
 for <linux-nvdimm@lists.01.org>; Tue, 24 Apr 2018 16:43:52 -0700 (PDT)
Subject: [PATCH v9 9/9] xfs, dax: introduce xfs_break_dax_layouts()
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 24 Apr 2018 16:33:50 -0700
Message-ID: <152461283072.17530.11313844322317294220.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152461278149.17530.2867511144531572045.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152461278149.17530.2867511144531572045.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
Cc: jack@suse.cz, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

xfs_break_dax_layouts(), similar to xfs_break_leased_layouts(), scans
for busy / pinned dax pages and waits for those pages to go idle before
any potential extent unmap operation.

dax_layout_busy_page() handles synchronizing against new page-busy
events (get_user_pages). It invalidates all mappings to trigger the
get_user_pages slow path which will eventually block on the xfs inode
lock held in XFS_MMAPLOCK_EXCL mode. If dax_layout_busy_page() finds a
busy page it returns it for xfs to wait for the page-idle event that
will fire when the page reference count reaches 1 (recall ZONE_DEVICE
pages are idle at count 1, see generic_dax_pagefree()).

While waiting, the XFS_MMAPLOCK_EXCL lock is dropped in order to not
deadlock the process that might be trying to elevate the page count of
more pages before arranging for any of them to go idle. I.e. the typical
case of submitting I/O is that iov_iter_get_pages() elevates the
reference count of all pages in the I/O before starting I/O on the first
page. The process of elevating the reference count of all pages involved
in an I/O may cause faults that need to take XFS_MMAPLOCK_EXCL.

Although XFS_MMAPLOCK_EXCL is dropped while waiting, XFS_IOLOCK_EXCL is
held while sleeping. We need this to prevent starvation of the truncate
path as continuous submission of direct-I/O could starve the truncate
path indefinitely if the lock is dropped.

Cc: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Reported-by: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/xfs/xfs_file.c |   59 +++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 48 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 1a5176b21803..4e98d0dcc035 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -718,6 +718,37 @@ xfs_file_write_iter(
 	return ret;
 }
 
+static void
+xfs_wait_dax_page(
+	struct inode		*inode,
+	bool			*did_unlock)
+{
+	struct xfs_inode        *ip = XFS_I(inode);
+
+	*did_unlock = true;
+	xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
+	schedule();
+	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
+}
+
+static int
+xfs_break_dax_layouts(
+	struct inode		*inode,
+	uint			iolock,
+	bool			*did_unlock)
+{
+	struct page		*page;
+
+	*did_unlock = false;
+	page = dax_layout_busy_page(inode->i_mapping);
+	if (!page)
+		return 0;
+
+	return ___wait_var_event(&page->_refcount,
+			atomic_read(&page->_refcount) == 1, TASK_INTERRUPTIBLE,
+			0, 0, xfs_wait_dax_page(inode, did_unlock));
+}
+
 int
 xfs_break_layouts(
 	struct inode		*inode,
@@ -729,17 +760,23 @@ xfs_break_layouts(
 
 	ASSERT(xfs_isilocked(XFS_I(inode), XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL));
 
-	switch (reason) {
-	case BREAK_UNMAP:
-		ASSERT(xfs_isilocked(XFS_I(inode), XFS_MMAPLOCK_EXCL));
-		/* fall through */
-	case BREAK_WRITE:
-		error = xfs_break_leased_layouts(inode, iolock, &retry);
-		break;
-	default:
-		WARN_ON_ONCE(1);
-		return -EINVAL;
-	}
+	do {
+		switch (reason) {
+		case BREAK_UNMAP:
+			ASSERT(xfs_isilocked(XFS_I(inode), XFS_MMAPLOCK_EXCL));
+
+			error = xfs_break_dax_layouts(inode, *iolock, &retry);
+			/* fall through */
+		case BREAK_WRITE:
+			if (error || retry)
+				break;
+			error = xfs_break_leased_layouts(inode, iolock, &retry);
+			break;
+		default:
+			WARN_ON_ONCE(1);
+			return -EINVAL;
+		}
+	} while (error == 0 && retry);
 
 	return error;
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
