Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DA2AC21D49103
 for <linux-nvdimm@lists.01.org>; Thu, 10 Aug 2017 23:43:53 -0700 (PDT)
Subject: [PATCH v3 6/6] mm,
 xfs: protect swapfile contents with immutable + unwritten extents
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 10 Aug 2017 23:39:49 -0700
Message-ID: <150243358949.8777.17308615269167142735.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150243355681.8777.14902834768886160223.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150243355681.8777.14902834768886160223.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: darrick.wong@oracle.com
Cc: linux-nvdimm@lists.01.org, linux-api@vger.kernel.org, Trond Myklebust <trond.myklebust@primarydata.com>, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, luto@kernel.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Anna Schumaker <anna.schumaker@netapp.com>
List-ID: <linux-nvdimm@lists.01.org>

    On Jun 22, 2017, Darrick wrote:
    > On Jun 22, 2017, Dave wrote:
    >> Hmmm, I disagree on the unwritten state here.  We want swap files to
    >> be able to use unwritten extents - it means we can preallocate the
    >> swap file and hand it straight to swapon without having to zero it
    >> (i.e. no I/O needed to demand allocate more swap space when memory
    >> is very low).  Also, anyone who tries to read the swap file from
    >> userspace will be reading unwritten extents, which will always
    >> return zeros rather than whatever is in the swap file...
    >
    > Now I've twisted all the way around to thinking that swap files
    > should be /totally/ unwritten, except for the file header. :)

This explicitly requires swapon(8) to be modified to seal the block-map
of the file before activating swap.

We could seal and activate swap in one step, but that's likely to
surprise legacy userspace that does not expect the file to take on
iomap-immutable semantics in response to swapon(2). However, a potential
follow on is a new flag to swapon(2) that specifies sealing the
block-map at ->swap_activate() time.

Cc: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Anna Schumaker <anna.schumaker@netapp.com>
Cc: Trond Myklebust <trond.myklebust@primarydata.com>
Suggested-by: Dave Chinner <david@fromorbit.com>
Suggested-by: "Darrick J. Wong" <darrick.wong@oracle.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/nfs/file.c            |    7 +++++-
 fs/xfs/libxfs/xfs_bmap.c |    3 ++-
 fs/xfs/libxfs/xfs_bmap.h |   12 +++++++++-
 fs/xfs/xfs_aops.c        |   54 ++++++++++++++++++++++++++++++++++++++++++++++
 mm/page_io.c             |    1 +
 mm/swapfile.c            |   20 ++++++-----------
 6 files changed, 81 insertions(+), 16 deletions(-)

diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index 5713eb32a45e..a786161f8580 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -489,10 +489,15 @@ static int nfs_swap_activate(struct swap_info_struct *sis, struct file *file,
 						sector_t *span)
 {
 	struct rpc_clnt *clnt = NFS_CLIENT(file->f_mapping->host);
+	int rc;
 
 	*span = sis->pages;
 
-	return rpc_clnt_swap_activate(clnt);
+	rc = rpc_clnt_swap_activate(clnt);
+	if (rc)
+		return rc;
+	sis->flags |= SWP_FILE;
+	return add_swap_extent(sis, 0, sis->max, 0);
 }
 
 static void nfs_swap_deactivate(struct file *file)
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 0535a7f34d2a..3e2e604a6642 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4483,7 +4483,8 @@ xfs_bmapi_write(
 
 	/* fail any attempts to mutate data extents */
 	if (IS_IOMAP_IMMUTABLE(VFS_I(ip))
-			&& !(flags & (XFS_BMAPI_METADATA | XFS_BMAPI_ATTRFORK)))
+			&& !(flags & (XFS_BMAPI_METADATA | XFS_BMAPI_ATTRFORK
+					| XFS_BMAPI_FORCE)))
 		return -ETXTBSY;
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 851982a5dfbc..a0f099289520 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -113,6 +113,15 @@ struct xfs_extent_free_item
 /* Only convert delalloc space, don't allocate entirely new extents */
 #define XFS_BMAPI_DELALLOC	0x400
 
+/*
+ * Permit extent manipulations even if S_IOMAP_IMMUTABLE is set on the
+ * inode. This is only expected to be used in the swapfile activation
+ * case where we want to mark all swap space as unwritten so that reads
+ * return zero and writes fail with ETXTBSY. Storage access in this
+ * state can only occur via swap operations.
+ */
+#define XFS_BMAPI_FORCE		0x800
+
 #define XFS_BMAPI_FLAGS \
 	{ XFS_BMAPI_ENTIRE,	"ENTIRE" }, \
 	{ XFS_BMAPI_METADATA,	"METADATA" }, \
@@ -124,7 +133,8 @@ struct xfs_extent_free_item
 	{ XFS_BMAPI_ZERO,	"ZERO" }, \
 	{ XFS_BMAPI_REMAP,	"REMAP" }, \
 	{ XFS_BMAPI_COWFORK,	"COWFORK" }, \
-	{ XFS_BMAPI_DELALLOC,	"DELALLOC" }
+	{ XFS_BMAPI_DELALLOC,	"DELALLOC" }, \
+	{ XFS_BMAPI_FORCE,	"FORCE" }
 
 
 static inline int xfs_bmapi_aflag(int w)
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 6bf120bb1a17..066708175168 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1418,6 +1418,58 @@ xfs_vm_set_page_dirty(
 	return newly_dirty;
 }
 
+STATIC void
+xfs_vm_swap_deactivate(
+	struct file		*file)
+{
+	struct inode		*inode = file->f_mapping->host;
+	struct xfs_inode	*ip = XFS_I(inode);
+	int			error = 0;
+
+	xfs_ilock(ip, XFS_IOLOCK_EXCL);
+	if (IS_IOMAP_IMMUTABLE(inode))
+		error = xfs_alloc_file_space(ip, PAGE_SIZE,
+				i_size_read(inode) - PAGE_SIZE,
+				XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO
+				| XFS_BMAPI_FORCE);
+	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+
+	WARN(error, "%s failed to restore block map (%d)\n", __func__, error);
+}
+
+STATIC int
+xfs_vm_swap_activate(
+	struct swap_info_struct	*sis,
+	struct file		*file,
+	sector_t		*span)
+{
+	struct inode		*inode = file->f_mapping->host;
+	struct xfs_inode	*ip = XFS_I(inode);
+	int			error = 0, nr_extents;
+
+	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
+
+	nr_extents = generic_swapfile_activate(sis, file, span);
+	if (nr_extents < 0)
+		return nr_extents;
+
+	/*
+	 * If the file is already immutable take this opportunity to
+	 * mark all extents as unwritten.  This arranges for all reads
+	 * to return 0 and all writes to fail with ETXTBSY since they
+	 * would attempt extent conversion to the 'written' state. The
+	 * swap header (PAGE_SIZE) is left alone.
+	 */
+	if (IS_IOMAP_IMMUTABLE(inode))
+		error = xfs_alloc_file_space(ip, PAGE_SIZE,
+				i_size_read(inode) - PAGE_SIZE,
+				XFS_BMAPI_PREALLOC | XFS_BMAPI_CONVERT
+				| XFS_BMAPI_FORCE);
+	if (error)
+		nr_extents = error;
+	return nr_extents;
+}
+
 const struct address_space_operations xfs_address_space_operations = {
 	.readpage		= xfs_vm_readpage,
 	.readpages		= xfs_vm_readpages,
@@ -1427,6 +1479,8 @@ const struct address_space_operations xfs_address_space_operations = {
 	.releasepage		= xfs_vm_releasepage,
 	.invalidatepage		= xfs_vm_invalidatepage,
 	.bmap			= xfs_vm_bmap,
+	.swap_activate		= xfs_vm_swap_activate,
+	.swap_deactivate	= xfs_vm_swap_deactivate,
 	.direct_IO		= xfs_vm_direct_IO,
 	.migratepage		= buffer_migrate_page,
 	.is_partially_uptodate  = block_is_partially_uptodate,
diff --git a/mm/page_io.c b/mm/page_io.c
index b6c4ac388209..301e4f778ebf 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -231,6 +231,7 @@ int generic_swapfile_activate(struct swap_info_struct *sis,
 	ret = -EINVAL;
 	goto out;
 }
+EXPORT_SYMBOL_GPL(generic_swapfile_activate);
 
 /*
  * We may have stale swap cache pages in memory: notice
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 6ba4aab2db0b..6d43a392757f 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2105,6 +2105,9 @@ sector_t map_swap_page(struct page *page, struct block_device **bdev)
  */
 static void destroy_swap_extents(struct swap_info_struct *sis)
 {
+	struct file *swap_file = sis->swap_file;
+	struct address_space *mapping = swap_file->f_mapping;
+
 	while (!list_empty(&sis->first_swap_extent.list)) {
 		struct swap_extent *se;
 
@@ -2114,10 +2117,7 @@ static void destroy_swap_extents(struct swap_info_struct *sis)
 		kfree(se);
 	}
 
-	if (sis->flags & SWP_FILE) {
-		struct file *swap_file = sis->swap_file;
-		struct address_space *mapping = swap_file->f_mapping;
-
+	if (mapping->a_ops->swap_deactivate) {
 		sis->flags &= ~SWP_FILE;
 		mapping->a_ops->swap_deactivate(swap_file);
 	}
@@ -2168,6 +2168,7 @@ add_swap_extent(struct swap_info_struct *sis, unsigned long start_page,
 	list_add_tail(&new_se->list, &sis->first_swap_extent.list);
 	return 1;
 }
+EXPORT_SYMBOL_GPL(add_swap_extent);
 
 /*
  * A `swap extent' is a simple thing which maps a contiguous range of pages
@@ -2213,15 +2214,8 @@ static int setup_swap_extents(struct swap_info_struct *sis, sector_t *span)
 		return ret;
 	}
 
-	if (mapping->a_ops->swap_activate) {
-		ret = mapping->a_ops->swap_activate(sis, swap_file, span);
-		if (!ret) {
-			sis->flags |= SWP_FILE;
-			ret = add_swap_extent(sis, 0, sis->max, 0);
-			*span = sis->pages;
-		}
-		return ret;
-	}
+	if (mapping->a_ops->swap_activate)
+		return mapping->a_ops->swap_activate(sis, swap_file, span);
 
 	return generic_swapfile_activate(sis, swap_file, span);
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
