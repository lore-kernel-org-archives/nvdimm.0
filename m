Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F190E21290D2B
 for <linux-nvdimm@lists.01.org>; Wed,  5 Jun 2019 18:45:25 -0700 (PDT)
From: ira.weiny@intel.com
Subject: [PATCH RFC 09/10] fs/xfs: Fail truncate if pages are GUP pinned
Date: Wed,  5 Jun 2019 18:45:42 -0700
Message-Id: <20190606014544.8339-10-ira.weiny@intel.com>
In-Reply-To: <20190606014544.8339-1-ira.weiny@intel.com>
References: <20190606014544.8339-1-ira.weiny@intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>, Jeff Layton <jlayton@kernel.org>, Dave Chinner <david@fromorbit.com>
Cc: linux-nvdimm@lists.01.org, John Hubbard <jhubbard@nvidia.com>, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

From: Ira Weiny <ira.weiny@intel.com>

If pages are actively gup pinned fail the truncate operation.  To
support an application who wishes to removing a pin upon SIGIO reception
we must change the order of breaking layout leases with respect to DAX
layout leases.

Check for a GUP pin on the page being truncated and return ETXTBSY if it
is GUP pinned.

Change the order of XFS break leased layouts and break DAX layouts.

Select EXPORT_BLOCK_OPS for FS_DAX to ensure that
xfs_break_lease_layouts() is defined for FS_DAX as well as pNFS.

Update comment for xfs_break_lease_layouts()

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 fs/Kconfig        |  1 +
 fs/xfs/xfs_file.c |  8 ++++++--
 fs/xfs/xfs_pnfs.c | 14 +++++++-------
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index f1046cf6ad85..c54b0b88abbf 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -49,6 +49,7 @@ config FS_DAX
 	select DEV_PAGEMAP_OPS if (ZONE_DEVICE && !FS_DAX_LIMITED)
 	select FS_IOMAP
 	select DAX
+	select EXPORTFS_BLOCK_OPS
 	help
 	  Direct Access (DAX) can be used on memory-backed block devices.
 	  If the block device supports DAX and the filesystem supports DAX,
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 350eb5546d36..1dc61c98f7cd 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -756,6 +756,9 @@ xfs_break_dax_layouts(
 	if (!page)
 		return 0;
 
+	if (page_gup_pinned(page))
+		return -ETXTBSY;
+
 	*retry = true;
 	return ___wait_var_event(&page->_refcount,
 			atomic_read(&page->_refcount) == 1, TASK_INTERRUPTIBLE,
@@ -779,10 +782,11 @@ xfs_break_layouts(
 		retry = false;
 		switch (reason) {
 		case BREAK_UNMAP:
-			error = xfs_break_dax_layouts(inode, &retry, off, len);
+			error = xfs_break_leased_layouts(inode, iolock, &retry);
 			if (error || retry)
 				break;
-			/* fall through */
+			error = xfs_break_dax_layouts(inode, &retry, off, len);
+			break;
 		case BREAK_WRITE:
 			error = xfs_break_leased_layouts(inode, iolock, &retry);
 			break;
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index bde2c9f56a46..e70d24d12cbf 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -21,14 +21,14 @@
 #include "xfs_pnfs.h"
 
 /*
- * Ensure that we do not have any outstanding pNFS layouts that can be used by
- * clients to directly read from or write to this inode.  This must be called
- * before every operation that can remove blocks from the extent map.
- * Additionally we call it during the write operation, where aren't concerned
- * about exposing unallocated blocks but just want to provide basic
+ * Ensure that we do not have any outstanding pNFS or longterm GUP layouts that
+ * can be used by clients to directly read from or write to this inode.  This
+ * must be called before every operation that can remove blocks from the extent
+ * map.  Additionally we call it during the write operation, where aren't
+ * concerned about exposing unallocated blocks but just want to provide basic
  * synchronization between a local writer and pNFS clients.  mmap writes would
- * also benefit from this sort of synchronization, but due to the tricky locking
- * rules in the page fault path we don't bother.
+ * also benefit from this sort of synchronization, but due to the tricky
+ * locking rules in the page fault path we don't bother.
  */
 int
 xfs_break_leased_layouts(
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
