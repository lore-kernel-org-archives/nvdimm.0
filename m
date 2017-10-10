Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 76E4121F3C1AE
 for <linux-nvdimm@lists.01.org>; Tue, 10 Oct 2017 07:52:15 -0700 (PDT)
Subject: [PATCH v8 04/14] xfs: prepare xfs_break_layouts() for reuse with
 MAP_DIRECT
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 10 Oct 2017 07:49:17 -0700
Message-ID: <150764695771.16882.9179160793491582514.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150764693502.16882.15848797003793552156.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150764693502.16882.15848797003793552156.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-rdma@vger.kernel.org, linux-api@vger.kernel.org, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, iommu@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Move xfs_break_layouts() to its own compilation unit so that it can be
used for both pnfs layouts and MAP_DIRECT mappings.

Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/xfs/Kconfig      |    4 ++++
 fs/xfs/Makefile     |    1 +
 fs/xfs/xfs_layout.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_layout.h |   13 +++++++++++++
 fs/xfs/xfs_pnfs.c   |   30 ------------------------------
 fs/xfs/xfs_pnfs.h   |   10 ++--------
 6 files changed, 62 insertions(+), 38 deletions(-)
 create mode 100644 fs/xfs/xfs_layout.c
 create mode 100644 fs/xfs/xfs_layout.h

diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index 1b98cfa342ab..f62fc6629abb 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -109,3 +109,7 @@ config XFS_ASSERT_FATAL
 	  result in warnings.
 
 	  This behavior can be modified at runtime via sysfs.
+
+config XFS_LAYOUT
+	def_bool y
+	depends on EXPORTFS_BLOCK_OPS
diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index a6e955bfead8..d44135107490 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -135,3 +135,4 @@ xfs-$(CONFIG_XFS_POSIX_ACL)	+= xfs_acl.o
 xfs-$(CONFIG_SYSCTL)		+= xfs_sysctl.o
 xfs-$(CONFIG_COMPAT)		+= xfs_ioctl32.o
 xfs-$(CONFIG_EXPORTFS_BLOCK_OPS)	+= xfs_pnfs.o
+xfs-$(CONFIG_XFS_LAYOUT)	+= xfs_layout.o
diff --git a/fs/xfs/xfs_layout.c b/fs/xfs/xfs_layout.c
new file mode 100644
index 000000000000..71d95e1a910a
--- /dev/null
+++ b/fs/xfs/xfs_layout.c
@@ -0,0 +1,42 @@
+/*
+ * Copyright (c) 2014 Christoph Hellwig.
+ */
+#include "xfs.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_sb.h"
+#include "xfs_mount.h"
+#include "xfs_inode.h"
+
+#include <linux/fs.h>
+
+/*
+ * Ensure that we do not have any outstanding pNFS layouts that can be used by
+ * clients to directly read from or write to this inode.  This must be called
+ * before every operation that can remove blocks from the extent map.
+ * Additionally we call it during the write operation, where aren't concerned
+ * about exposing unallocated blocks but just want to provide basic
+ * synchronization between a local writer and pNFS clients.  mmap writes would
+ * also benefit from this sort of synchronization, but due to the tricky locking
+ * rules in the page fault path we don't bother.
+ */
+int
+xfs_break_layouts(
+	struct inode		*inode,
+	uint			*iolock)
+{
+	struct xfs_inode	*ip = XFS_I(inode);
+	int			error;
+
+	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL));
+
+	while ((error = break_layout(inode, false) == -EWOULDBLOCK)) {
+		xfs_iunlock(ip, *iolock);
+		error = break_layout(inode, true);
+		*iolock = XFS_IOLOCK_EXCL;
+		xfs_ilock(ip, *iolock);
+	}
+
+	return error;
+}
diff --git a/fs/xfs/xfs_layout.h b/fs/xfs/xfs_layout.h
new file mode 100644
index 000000000000..f848ee78cc93
--- /dev/null
+++ b/fs/xfs/xfs_layout.h
@@ -0,0 +1,13 @@
+#ifndef _XFS_LAYOUT_H
+#define _XFS_LAYOUT_H 1
+
+#ifdef CONFIG_XFS_LAYOUT
+int xfs_break_layouts(struct inode *inode, uint *iolock);
+#else
+static inline int
+xfs_break_layouts(struct inode *inode, uint *iolock)
+{
+	return 0;
+}
+#endif /* CONFIG_XFS_LAYOUT */
+#endif /* _XFS_LAYOUT_H */
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 2f2dc3c09ad0..8ec72220e73b 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -20,36 +20,6 @@
 #include "xfs_pnfs.h"
 
 /*
- * Ensure that we do not have any outstanding pNFS layouts that can be used by
- * clients to directly read from or write to this inode.  This must be called
- * before every operation that can remove blocks from the extent map.
- * Additionally we call it during the write operation, where aren't concerned
- * about exposing unallocated blocks but just want to provide basic
- * synchronization between a local writer and pNFS clients.  mmap writes would
- * also benefit from this sort of synchronization, but due to the tricky locking
- * rules in the page fault path we don't bother.
- */
-int
-xfs_break_layouts(
-	struct inode		*inode,
-	uint			*iolock)
-{
-	struct xfs_inode	*ip = XFS_I(inode);
-	int			error;
-
-	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL));
-
-	while ((error = break_layout(inode, false) == -EWOULDBLOCK)) {
-		xfs_iunlock(ip, *iolock);
-		error = break_layout(inode, true);
-		*iolock = XFS_IOLOCK_EXCL;
-		xfs_ilock(ip, *iolock);
-	}
-
-	return error;
-}
-
-/*
  * Get a unique ID including its location so that the client can identify
  * the exported device.
  */
diff --git a/fs/xfs/xfs_pnfs.h b/fs/xfs/xfs_pnfs.h
index b587cb99b2b7..4135b2482697 100644
--- a/fs/xfs/xfs_pnfs.h
+++ b/fs/xfs/xfs_pnfs.h
@@ -1,19 +1,13 @@
 #ifndef _XFS_PNFS_H
 #define _XFS_PNFS_H 1
 
+#include "xfs_layout.h"
+
 #ifdef CONFIG_EXPORTFS_BLOCK_OPS
 int xfs_fs_get_uuid(struct super_block *sb, u8 *buf, u32 *len, u64 *offset);
 int xfs_fs_map_blocks(struct inode *inode, loff_t offset, u64 length,
 		struct iomap *iomap, bool write, u32 *device_generation);
 int xfs_fs_commit_blocks(struct inode *inode, struct iomap *maps, int nr_maps,
 		struct iattr *iattr);
-
-int xfs_break_layouts(struct inode *inode, uint *iolock);
-#else
-static inline int
-xfs_break_layouts(struct inode *inode, uint *iolock)
-{
-	return 0;
-}
 #endif /* CONFIG_EXPORTFS_BLOCK_OPS */
 #endif /* _XFS_PNFS_H */

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
