Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2837122146758
 for <linux-nvdimm@lists.01.org>; Wed, 21 Mar 2018 16:01:00 -0700 (PDT)
Subject: [PATCH v7 13/14] xfs: prepare xfs_break_layouts() for another
 layout type
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 21 Mar 2018 15:58:25 -0700
Message-ID: <152167310580.5268.18270880990191450094.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152167302988.5268.4370226749268662682.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152167302988.5268.4370226749268662682.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: jack@suse.cz, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

When xfs is operating as the back-end of a pNFS block server, it
prevents collisions between local and remote operations by requiring a
lease to be held for remotely accessed blocks. Local filesystem
operations break those leases before writing or mutating the extent map
of the file.

A similar mechanism is needed to prevent operations on pinned dax
mappings, like device-DMA, from colliding with extent unmap operations.

BREAK_WRITE and BREAK_UNMAPI are introduced as two distinct levels of
layout breaking.

Layouts are broken in the BREAK_WRITE case to ensure that layout-holders
do not collide with local writes. Additionally, layouts are broken in
the BREAK_UNMAPI case to make sure the layout-holder has a consistent
view of the file's extent map. While BREAK_WRITE breaks can be satisfied
be recalling FL_LAYOUT leases, BREAK_UNMAPI breaks additionally require
waiting for busy dax-pages to go idle while holding XFS_MMAPLOCK_EXCL.

After this refactoring xfs_break_layouts() becomes the entry point for
coordinating both types of breaks. Finally, xfs_break_leased_layouts()
becomes just the BREAK_WRITE handler.

Note that the unlock tracking is needed in a follow on change. That will
coordinate retrying either break handler until both successfully test
for a lease break while maintaining the lock state.

Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Reported-by: Dave Chinner <david@fromorbit.com>
Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/xfs/xfs_file.c  |   32 ++++++++++++++++++++++++++++++--
 fs/xfs/xfs_inode.h |   16 ++++++++++++++++
 fs/xfs/xfs_ioctl.c |    3 +--
 fs/xfs/xfs_iops.c  |    6 +++---
 fs/xfs/xfs_pnfs.c  |   13 +++++++------
 fs/xfs/xfs_pnfs.h  |    6 ++++--
 6 files changed, 61 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 18edf04811d0..7f37fadf007e 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -350,7 +350,7 @@ xfs_file_aio_write_checks(
 	if (error <= 0)
 		return error;
 
-	error = xfs_break_layouts(inode, iolock);
+	error = xfs_break_layouts(inode, iolock, BREAK_WRITE);
 	if (error)
 		return error;
 
@@ -752,6 +752,34 @@ xfs_file_write_iter(
 	return ret;
 }
 
+int
+xfs_break_layouts(
+	struct inode		*inode,
+	uint			*iolock,
+	enum layout_break_reason reason)
+{
+	struct xfs_inode	*ip = XFS_I(inode);
+	bool			did_unlock = false;
+	int			error = 0;
+
+	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL
+				| (reason == BREAK_UNMAPI
+					? XFS_MMAPLOCK_EXCL : 0)));
+
+	switch (reason) {
+	case BREAK_UNMAPI:
+		/* fall through */
+	case BREAK_WRITE:
+		error = xfs_break_leased_layouts(inode, iolock, &did_unlock);
+		break;
+	default:
+		error = -EINVAL;
+		break;
+	}
+
+	return error;
+}
+
 #define	XFS_FALLOC_FL_SUPPORTED						\
 		(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |		\
 		 FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE |	\
@@ -778,7 +806,7 @@ xfs_file_fallocate(
 		return -EOPNOTSUPP;
 
 	xfs_ilock(ip, iolock);
-	error = xfs_break_layouts(inode, &iolock);
+	error = xfs_break_layouts(inode, &iolock, BREAK_UNMAPI);
 	if (error)
 		goto out_unlock;
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 3e8dc990d41c..6951d57aae71 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -379,6 +379,20 @@ static inline void xfs_ifunlock(struct xfs_inode *ip)
 					>> XFS_ILOCK_SHIFT)
 
 /*
+ * Layouts are broken in the BREAK_WRITE case to ensure that
+ * layout-holders do not collide with local writes. Additionally,
+ * layouts are broken in the BREAK_UNMAPI case to make sure the
+ * layout-holder has a consistent view of the file's extent map. While
+ * BREAK_WRITE breaks can be satisfied be recalling FL_LAYOUT leases,
+ * BREAK_UNMAPI breaks additionally require waiting for busy dax-pages
+ * to go idle.
+ */
+enum layout_break_reason {
+        BREAK_WRITE,
+        BREAK_UNMAPI,
+};
+
+/*
  * For multiple groups support: if S_ISGID bit is set in the parent
  * directory, group of new file is set to that of the parent, and
  * new subdirectory gets S_ISGID bit from parent.
@@ -447,6 +461,8 @@ int	xfs_zero_eof(struct xfs_inode *ip, xfs_off_t offset,
 		     xfs_fsize_t isize, bool *did_zeroing);
 int	xfs_zero_range(struct xfs_inode *ip, xfs_off_t pos, xfs_off_t count,
 		bool *did_zero);
+int	xfs_break_layouts(struct inode *inode, uint *iolock,
+		enum layout_break_reason reason);
 
 /* from xfs_iops.c */
 extern void xfs_setup_inode(struct xfs_inode *ip);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 4151fade4bb1..967be496b052 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -39,7 +39,6 @@
 #include "xfs_icache.h"
 #include "xfs_symlink.h"
 #include "xfs_trans.h"
-#include "xfs_pnfs.h"
 #include "xfs_acl.h"
 #include "xfs_btree.h"
 #include <linux/fsmap.h>
@@ -644,7 +643,7 @@ xfs_ioc_space(
 		return error;
 
 	xfs_ilock(ip, iolock);
-	error = xfs_break_layouts(inode, &iolock);
+	error = xfs_break_layouts(inode, &iolock, BREAK_UNMAPI);
 	if (error)
 		goto out_unlock;
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index d23aa08426f9..7364474347d1 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -37,7 +37,6 @@
 #include "xfs_da_btree.h"
 #include "xfs_dir2.h"
 #include "xfs_trans_space.h"
-#include "xfs_pnfs.h"
 #include "xfs_iomap.h"
 
 #include <linux/capability.h>
@@ -1027,13 +1026,14 @@ xfs_vn_setattr(
 	int			error;
 
 	if (iattr->ia_valid & ATTR_SIZE) {
-		struct xfs_inode	*ip = XFS_I(d_inode(dentry));
+		struct inode		*inode = d_inode(dentry);
+		struct xfs_inode	*ip = XFS_I(inode);
 		uint			iolock;
 
 		xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
 		iolock = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
 
-		error = xfs_break_layouts(d_inode(dentry), &iolock);
+		error = xfs_break_layouts(inode, &iolock, BREAK_UNMAPI);
 		if (error) {
 			xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
 			return error;
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 6ea7b0b55d02..40e69edb7e2e 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -31,17 +31,18 @@
  * rules in the page fault path we don't bother.
  */
 int
-xfs_break_layouts(
+xfs_break_leased_layouts(
 	struct inode		*inode,
-	uint			*iolock)
+	uint			*iolock,
+	bool			*did_unlock)
 {
 	struct xfs_inode	*ip = XFS_I(inode);
 	int			error;
 
-	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL));
-
+	*did_unlock = false;
 	while ((error = break_layout(inode, false) == -EWOULDBLOCK)) {
 		xfs_iunlock(ip, *iolock);
+		*did_unlock = true;
 		error = break_layout(inode, true);
 		*iolock &= ~XFS_IOLOCK_SHARED;
 		*iolock |= XFS_IOLOCK_EXCL;
@@ -121,8 +122,8 @@ xfs_fs_map_blocks(
 	 * Lock out any other I/O before we flush and invalidate the pagecache,
 	 * and then hand out a layout to the remote system.  This is very
 	 * similar to direct I/O, except that the synchronization is much more
-	 * complicated.  See the comment near xfs_break_layouts for a detailed
-	 * explanation.
+	 * complicated.  See the comment near xfs_break_leased_layouts
+	 * for a detailed explanation.
 	 */
 	xfs_ilock(ip, XFS_IOLOCK_EXCL);
 
diff --git a/fs/xfs/xfs_pnfs.h b/fs/xfs/xfs_pnfs.h
index bf45951e28fe..0f2f51037064 100644
--- a/fs/xfs/xfs_pnfs.h
+++ b/fs/xfs/xfs_pnfs.h
@@ -9,11 +9,13 @@ int xfs_fs_map_blocks(struct inode *inode, loff_t offset, u64 length,
 int xfs_fs_commit_blocks(struct inode *inode, struct iomap *maps, int nr_maps,
 		struct iattr *iattr);
 
-int xfs_break_layouts(struct inode *inode, uint *iolock);
+int xfs_break_leased_layouts(struct inode *inode, uint *iolock,
+		bool *did_unlock);
 #else
 static inline int
-xfs_break_layouts(struct inode *inode, uint *iolock)
+xfs_break_leased_layouts(struct inode *inode, uint *iolock, bool *did_unlock)
 {
+	*did_unlock = false;
 	return 0;
 }
 #endif /* CONFIG_EXPORTFS_BLOCK_OPS */

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
