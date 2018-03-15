Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6C9C52253FB56
 for <linux-nvdimm@lists.01.org>; Thu, 15 Mar 2018 08:55:21 -0700 (PDT)
Subject: [PATCH v6 13/15] xfs: communicate lock drop events from
 xfs_break_layouts()
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 15 Mar 2018 08:52:39 -0700
Message-ID: <152112915950.24669.2377167541944853596.stgit@dwillia2-desk3.amr.corp.intel.com>
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

In preparation for adding a new layout type, teach xfs_break_layouts()
to return a positive number if it needed to drop locks while trying to
break leases. For all layouts to be successfully broken each layout type
needs to be able to assert that the layouts were broken with the locks
held.

The existing a xfs_break_layouts() is pushed down a level to
xfs_break_leased_layouts() and the new xfs_break_layouts() will
coordinate interpreting the return code from the low level 'break'
helpers.

Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/xfs/xfs_file.c  |   17 +++++++++++++++++
 fs/xfs/xfs_inode.h |    2 ++
 fs/xfs/xfs_ioctl.c |    1 -
 fs/xfs/xfs_iops.c  |    1 -
 fs/xfs/xfs_pnfs.c  |   15 ++++++++-------
 fs/xfs/xfs_pnfs.h  |    4 ++--
 6 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index ba969019bf26..5742d395a4e4 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -759,6 +759,23 @@ xfs_file_write_iter(
 	return ret;
 }
 
+int
+xfs_break_layouts(
+	struct inode		*inode,
+	uint			*iolock)
+{
+	struct xfs_inode	*ip = XFS_I(inode);
+	int			ret;
+
+	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL
+				| XFS_MMAPLOCK_EXCL));
+
+	ret = xfs_break_leased_layouts(inode, iolock);
+	if (ret > 0)
+		ret = 0;
+	return ret;
+}
+
 #define	XFS_FALLOC_FL_SUPPORTED						\
 		(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |		\
 		 FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE |	\
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 3e8dc990d41c..74c63f3a720f 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -447,6 +447,8 @@ int	xfs_zero_eof(struct xfs_inode *ip, xfs_off_t offset,
 		     xfs_fsize_t isize, bool *did_zeroing);
 int	xfs_zero_range(struct xfs_inode *ip, xfs_off_t pos, xfs_off_t count,
 		bool *did_zero);
+int	xfs_break_layouts(struct inode *inode, uint *iolock);
+
 
 /* from xfs_iops.c */
 extern void xfs_setup_inode(struct xfs_inode *ip);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 4151fade4bb1..d70a1919e787 100644
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
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index d23aa08426f9..78eb56d447df 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -37,7 +37,6 @@
 #include "xfs_da_btree.h"
 #include "xfs_dir2.h"
 #include "xfs_trans_space.h"
-#include "xfs_pnfs.h"
 #include "xfs_iomap.h"
 
 #include <linux/capability.h>
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 9fe661c2d59c..49784828929d 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -31,25 +31,26 @@
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
-
-	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL
-				| XFS_MMAPLOCK_EXCL));
+	int			did_unlock = 0;
 
 	while ((error = break_layout(inode, false) == -EWOULDBLOCK)) {
 		xfs_iunlock(ip, *iolock);
+		did_unlock = 1;
 		error = break_layout(inode, true);
 		*iolock &= ~XFS_IOLOCK_SHARED;
 		*iolock |= XFS_IOLOCK_EXCL;
 		xfs_ilock(ip, *iolock);
 	}
 
-	return error;
+	if (error < 0)
+		return error;
+	return did_unlock;
 }
 
 /*
@@ -122,8 +123,8 @@ xfs_fs_map_blocks(
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
