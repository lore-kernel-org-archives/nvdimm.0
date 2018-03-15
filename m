Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 58B9F20954B8A
 for <linux-nvdimm@lists.01.org>; Thu, 15 Mar 2018 08:55:43 -0700 (PDT)
Subject: [PATCH v6 14/15] xfs: prepare xfs_break_layouts() for another
 layout type
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 15 Mar 2018 08:52:45 -0700
Message-ID: <152112916514.24669.8643877835071945330.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152112908134.24669.10222746224538377035.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152112908134.24669.10222746224538377035.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: jack@suse.cz, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

When xfs is operating as the back-end of a pNFS block server, it prevents
collisions between local and remote operations by requiring a lease to
be held for remotely accessed blocks. Local filesystem operations break
those leases before writing or mutating the extent map of the file.

A similar mechanism is needed to prevent operations on pinned dax
mappings, like device-DMA, from colliding with extent unmap operations.

BREAK_WRITE and BREAK_TRUNCATE are introduced as two distinct levels of
layout breaking.

Layouts are broken in the BREAK_WRITE case to ensure that layout-holders
do not collide with local writes. Additionally, layouts are broken in
the BREAK_TRUNCATE case to make sure the layout-holder has a consistent
view of the file's extent map. While BREAK_WRITE breaks can be satisfied
be recalling FL_LAYOUT leases, BREAK_TRUNCATE breaks additionally
require waiting for busy dax-pages to go idle.

Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Reported-by: Dave Chinner <david@fromorbit.com>
Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/xfs/xfs_file.c  |   23 +++++++++++++++++------
 fs/xfs/xfs_inode.h |   18 ++++++++++++++++--
 fs/xfs/xfs_ioctl.c |    2 +-
 fs/xfs/xfs_iops.c  |    5 +++--
 4 files changed, 37 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 5742d395a4e4..399c5221f101 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -352,7 +352,7 @@ xfs_file_aio_write_checks(
 
 	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
 	*iolock |= XFS_MMAPLOCK_EXCL;
-	error = xfs_break_layouts(inode, iolock);
+	error = xfs_break_layouts(inode, iolock, BREAK_WRITE);
 	if (error) {
 		*iolock &= ~XFS_MMAPLOCK_EXCL;
 		xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
@@ -762,7 +762,8 @@ xfs_file_write_iter(
 int
 xfs_break_layouts(
 	struct inode		*inode,
-	uint			*iolock)
+	uint			*iolock,
+	enum layout_break_reason reason)
 {
 	struct xfs_inode	*ip = XFS_I(inode);
 	int			ret;
@@ -770,9 +771,19 @@ xfs_break_layouts(
 	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL
 				| XFS_MMAPLOCK_EXCL));
 
-	ret = xfs_break_leased_layouts(inode, iolock);
-	if (ret > 0)
-		ret = 0;
+	switch (reason) {
+	case BREAK_TRUNCATE:
+		/* fall through */
+	case BREAK_WRITE:
+		ret = xfs_break_leased_layouts(inode, iolock);
+		if (ret > 0)
+			ret = 0;
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
 	return ret;
 }
 
@@ -802,7 +813,7 @@ xfs_file_fallocate(
 		return -EOPNOTSUPP;
 
 	xfs_ilock(ip, iolock);
-	error = xfs_break_layouts(inode, &iolock);
+	error = xfs_break_layouts(inode, &iolock, BREAK_TRUNCATE);
 	if (error)
 		goto out_unlock;
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 74c63f3a720f..1a66c7afcf45 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -379,6 +379,20 @@ static inline void xfs_ifunlock(struct xfs_inode *ip)
 					>> XFS_ILOCK_SHIFT)
 
 /*
+ * Layouts are broken in the BREAK_WRITE case to ensure that
+ * layout-holders do not collide with local writes. Additionally,
+ * layouts are broken in the BREAK_TRUNCATE case to make sure the
+ * layout-holder has a consistent view of the file's extent map. While
+ * BREAK_WRITE breaks can be satisfied be recalling FL_LAYOUT leases,
+ * BREAK_TRUNCATE breaks additionally require waiting for busy dax-pages
+ * to go idle.
+ */
+enum layout_break_reason {
+        BREAK_WRITE,
+        BREAK_TRUNCATE,
+};
+
+/*
  * For multiple groups support: if S_ISGID bit is set in the parent
  * directory, group of new file is set to that of the parent, and
  * new subdirectory gets S_ISGID bit from parent.
@@ -447,8 +461,8 @@ int	xfs_zero_eof(struct xfs_inode *ip, xfs_off_t offset,
 		     xfs_fsize_t isize, bool *did_zeroing);
 int	xfs_zero_range(struct xfs_inode *ip, xfs_off_t pos, xfs_off_t count,
 		bool *did_zero);
-int	xfs_break_layouts(struct inode *inode, uint *iolock);
-
+int	xfs_break_layouts(struct inode *inode, uint *iolock,
+		enum layout_break_reason reason);
 
 /* from xfs_iops.c */
 extern void xfs_setup_inode(struct xfs_inode *ip);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index d70a1919e787..847a67186d95 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -643,7 +643,7 @@ xfs_ioc_space(
 		return error;
 
 	xfs_ilock(ip, iolock);
-	error = xfs_break_layouts(inode, &iolock);
+	error = xfs_break_layouts(inode, &iolock, BREAK_TRUNCATE);
 	if (error)
 		goto out_unlock;
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 78eb56d447df..f9fcadb5b555 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1026,13 +1026,14 @@ xfs_vn_setattr(
 	int			error;
 
 	if (iattr->ia_valid & ATTR_SIZE) {
-		struct xfs_inode	*ip = XFS_I(d_inode(dentry));
+		struct inode		*inode = d_inode(dentry);
+		struct xfs_inode	*ip = XFS_I(inode);
 		uint			iolock;
 
 		xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
 		iolock = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
 
-		error = xfs_break_layouts(d_inode(dentry), &iolock);
+		error = xfs_break_layouts(inode, &iolock, BREAK_TRUNCATE);
 		if (error) {
 			xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
 			return error;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
