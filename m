Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 82E7821ED1C42
 for <linux-nvdimm@lists.01.org>; Fri,  9 Mar 2018 22:58:30 -0800 (PST)
Subject: [PATCH v5 10/11] xfs: prepare xfs_break_layouts() for another
 layout type
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 09 Mar 2018 22:55:42 -0800
Message-ID: <152066494277.40260.7360641938196726871.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152066488891.40260.14605734226832760468.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152066488891.40260.14605734226832760468.stgit@dwillia2-desk3.amr.corp.intel.com>
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

XFS_BREAK_REMOTE and XFS_BREAK_MAPS are introduced as flags to control
the layouts that need to be broken by xfs_break_layouts(). While
XFS_BREAK_REMOTE is invoked in all calls to the new xfs_break_layouts(),
XFS_BREAK_MAPS only needs to specified when extents may be unmapped,
i.e. xfs_file_fallocate() and xfs_ioc_space(). XFS_BREAK_MAPS also
imposes the additional locking constraint of breaking (awaiting) pinned
dax mappings while holding XFS_MMAPLOCK_EXCL.

There is a small functional change in this rework. For the cases where
XFS_BREAK_MAPS is specified to xfs_break_layouts(), the
XFS_MMAPLOCK_EXCL ilock is held over the break_layouts() loop in
xfs_break_leased_layouts().

Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Reported-by: Dave Chinner <david@fromorbit.com>
Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/xfs/xfs_file.c  |   32 ++++++++++++++++++++++++++------
 fs/xfs/xfs_inode.h |    9 +++++++++
 fs/xfs/xfs_ioctl.c |    9 +++------
 fs/xfs/xfs_iops.c  |   12 +++++++-----
 fs/xfs/xfs_pnfs.c  |    8 +++-----
 fs/xfs/xfs_pnfs.h  |    4 ++--
 6 files changed, 50 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 9ea08326f876..f914f0628dc2 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -350,7 +350,7 @@ xfs_file_aio_write_checks(
 	if (error <= 0)
 		return error;
 
-	error = xfs_break_layouts(inode, iolock);
+	error = xfs_break_layouts(inode, iolock, XFS_BREAK_REMOTE);
 	if (error)
 		return error;
 
@@ -752,6 +752,28 @@ xfs_file_write_iter(
 	return ret;
 }
 
+int
+xfs_break_layouts(
+	struct inode		*inode,
+	uint			*iolock,
+	unsigned long		flags)
+{
+	struct xfs_inode	*ip = XFS_I(inode);
+	uint			iolock_assert = 0;
+	int			ret = 0;
+
+	if (flags & XFS_BREAK_REMOTE)
+		iolock_assert |= XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL;
+	if (flags & XFS_BREAK_MAPS)
+		iolock_assert |= XFS_MMAPLOCK_EXCL;
+
+	ASSERT(xfs_isilocked(ip, iolock_assert));
+
+	if (flags & XFS_BREAK_REMOTE)
+		ret = xfs_break_leased_layouts(inode, iolock);
+	return ret;
+}
+
 #define	XFS_FALLOC_FL_SUPPORTED						\
 		(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |		\
 		 FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE |	\
@@ -768,7 +790,7 @@ xfs_file_fallocate(
 	struct xfs_inode	*ip = XFS_I(inode);
 	long			error;
 	enum xfs_prealloc_flags	flags = 0;
-	uint			iolock = XFS_IOLOCK_EXCL;
+	uint			iolock = XFS_IOLOCK_EXCL|XFS_MMAPLOCK_EXCL;
 	loff_t			new_size = 0;
 	bool			do_file_insert = false;
 
@@ -778,13 +800,11 @@ xfs_file_fallocate(
 		return -EOPNOTSUPP;
 
 	xfs_ilock(ip, iolock);
-	error = xfs_break_layouts(inode, &iolock);
+	error = xfs_break_layouts(inode, &iolock,
+			XFS_BREAK_REMOTE | XFS_BREAK_MAPS);
 	if (error)
 		goto out_unlock;
 
-	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
-	iolock |= XFS_MMAPLOCK_EXCL;
-
 	if (mode & FALLOC_FL_PUNCH_HOLE) {
 		error = xfs_free_file_space(ip, offset, len);
 		if (error)
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 3e8dc990d41c..9b73ceb09cb1 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -379,6 +379,12 @@ static inline void xfs_ifunlock(struct xfs_inode *ip)
 					>> XFS_ILOCK_SHIFT)
 
 /*
+ * Flags for layout breaks
+ */
+#define XFS_BREAK_REMOTE (1<<0) /* break remote layout leases */
+#define XFS_BREAK_MAPS   (1<<1) /* break local direct (dax) mappings */
+
+/*
  * For multiple groups support: if S_ISGID bit is set in the parent
  * directory, group of new file is set to that of the parent, and
  * new subdirectory gets S_ISGID bit from parent.
@@ -447,6 +453,9 @@ int	xfs_zero_eof(struct xfs_inode *ip, xfs_off_t offset,
 		     xfs_fsize_t isize, bool *did_zeroing);
 int	xfs_zero_range(struct xfs_inode *ip, xfs_off_t pos, xfs_off_t count,
 		bool *did_zero);
+int	xfs_break_layouts(struct inode *inode, uint *iolock,
+		unsigned long flags);
+
 
 /* from xfs_iops.c */
 extern void xfs_setup_inode(struct xfs_inode *ip);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 89fb1eb80aae..31288d900c8a 100644
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
@@ -614,7 +613,7 @@ xfs_ioc_space(
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct iattr		iattr;
 	enum xfs_prealloc_flags	flags = 0;
-	uint			iolock = XFS_IOLOCK_EXCL;
+	uint			iolock = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
 	int			error;
 
 	/*
@@ -644,13 +643,11 @@ xfs_ioc_space(
 		return error;
 
 	xfs_ilock(ip, iolock);
-	error = xfs_break_layouts(inode, &iolock);
+	error = xfs_break_layouts(inode, &iolock,
+			XFS_BREAK_REMOTE | XFS_BREAK_MAPS);
 	if (error)
 		goto out_unlock;
 
-	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
-	iolock |= XFS_MMAPLOCK_EXCL;
-
 	switch (bf->l_whence) {
 	case 0: /*SEEK_SET*/
 		break;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 951e84df5576..15a1c7c874d9 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -37,7 +37,6 @@
 #include "xfs_da_btree.h"
 #include "xfs_dir2.h"
 #include "xfs_trans_space.h"
-#include "xfs_pnfs.h"
 #include "xfs_iomap.h"
 
 #include <linux/capability.h>
@@ -1030,11 +1029,14 @@ xfs_vn_setattr(
 		struct xfs_inode	*ip = XFS_I(d_inode(dentry));
 		uint			iolock = XFS_IOLOCK_EXCL;
 
-		error = xfs_break_layouts(d_inode(dentry), &iolock);
-		if (error)
-			return error;
-
 		xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
+		error = xfs_break_layouts(d_inode(dentry), &iolock,
+				XFS_BREAK_REMOTE | XFS_BREAK_MAPS);
+
+		if (error) {
+			xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
+			return error;
+		}
 		error = xfs_vn_setattr_size(dentry, iattr);
 		xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
 	} else {
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index aa6c5c193f45..ed13c9baffff 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -31,15 +31,13 @@
  * rules in the page fault path we don't bother.
  */
 int
-xfs_break_layouts(
+xfs_break_leased_layouts(
 	struct inode		*inode,
 	uint			*iolock)
 {
 	struct xfs_inode	*ip = XFS_I(inode);
 	int			error;
 
-	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL));
-
 	while ((error = break_layout(inode, false) == -EWOULDBLOCK)) {
 		xfs_iunlock(ip, *iolock);
 		error = break_layout(inode, true);
@@ -120,8 +118,8 @@ xfs_fs_map_blocks(
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
index bf45951e28fe..12f46fe6d902 100644
--- a/fs/xfs/xfs_pnfs.h
+++ b/fs/xfs/xfs_pnfs.h
@@ -9,10 +9,10 @@ int xfs_fs_map_blocks(struct inode *inode, loff_t offset, u64 length,
 int xfs_fs_commit_blocks(struct inode *inode, struct iomap *maps, int nr_maps,
 		struct iattr *iattr);
 
-int xfs_break_layouts(struct inode *inode, uint *iolock);
+int xfs_break_leased_layouts(struct inode *inode, uint *iolock);
 #else
 static inline int
-xfs_break_layouts(struct inode *inode, uint *iolock)
+xfs_break_leased_layouts(struct inode *inode, uint *iolock)
 {
 	return 0;
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
