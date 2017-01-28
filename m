Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8855182017
 for <linux-nvdimm@lists.01.org>; Sat, 28 Jan 2017 00:41:36 -0800 (PST)
Subject: [RFC PATCH 16/17] fs,
 dax: convert filesystem-dax to bdev_dax_direct_access
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 28 Jan 2017 00:37:30 -0800
Message-ID: <148559265054.11180.12194923365649055233.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <148559256378.11180.8957776806175202312.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <148559256378.11180.8957776806175202312.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: snitzer@redhat.com, mawilcox@microsoft.com, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Now that a dax_inode is plumbed through all dax-capable drivers we can
switch from block_device_operations to dax_operations for invoking
->direct_access.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/dax.c            |  143 +++++++++++++++++++++++++++------------------------
 fs/iomap.c          |    3 +
 include/linux/dax.h |    6 +-
 3 files changed, 82 insertions(+), 70 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index a990211c8a3d..07b36a26db06 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -51,32 +51,6 @@ static int __init init_dax_wait_table(void)
 }
 fs_initcall(init_dax_wait_table);
 
-static long dax_map_atomic(struct block_device *bdev, struct blk_dax_ctl *dax)
-{
-	struct request_queue *q = bdev->bd_queue;
-	long rc = -EIO;
-
-	dax->addr = ERR_PTR(-EIO);
-	if (blk_queue_enter(q, true) != 0)
-		return rc;
-
-	rc = bdev_direct_access(bdev, dax);
-	if (rc < 0) {
-		dax->addr = ERR_PTR(rc);
-		blk_queue_exit(q);
-		return rc;
-	}
-	return rc;
-}
-
-static void dax_unmap_atomic(struct block_device *bdev,
-		const struct blk_dax_ctl *dax)
-{
-	if (IS_ERR(dax->addr))
-		return;
-	blk_queue_exit(bdev->bd_queue);
-}
-
 static int dax_is_pmd_entry(void *entry)
 {
 	return (unsigned long)entry & RADIX_DAX_PMD;
@@ -549,21 +523,28 @@ static int dax_load_hole(struct address_space *mapping, void **entry,
 	return ret;
 }
 
-static int copy_user_dax(struct block_device *bdev, sector_t sector, size_t size,
-		struct page *to, unsigned long vaddr)
+static int copy_user_dax(struct block_device *bdev, struct dax_inode *dax_inode,
+		sector_t sector, size_t size, struct page *to,
+		unsigned long vaddr)
 {
 	struct blk_dax_ctl dax = {
 		.sector = sector,
 		.size = size,
 	};
 	void *vto;
+	long rc;
+	int id;
 
-	if (dax_map_atomic(bdev, &dax) < 0)
-		return PTR_ERR(dax.addr);
+	id = dax_read_lock();
+	rc = bdev_dax_direct_access(bdev, dax_inode, &dax);
+	if (rc < 0) {
+		dax_read_unlock(id);
+		return rc;
+	}
 	vto = kmap_atomic(to);
 	copy_user_page(vto, (void __force *)dax.addr, vaddr, to);
 	kunmap_atomic(vto);
-	dax_unmap_atomic(bdev, &dax);
+	dax_read_unlock(id);
 	return 0;
 }
 
@@ -731,12 +712,13 @@ static void dax_mapping_entry_mkclean(struct address_space *mapping,
 }
 
 static int dax_writeback_one(struct block_device *bdev,
-		struct address_space *mapping, pgoff_t index, void *entry)
+		struct dax_inode *dax_inode, struct address_space *mapping,
+		pgoff_t index, void *entry)
 {
 	struct radix_tree_root *page_tree = &mapping->page_tree;
 	struct blk_dax_ctl dax;
 	void *entry2, **slot;
-	int ret = 0;
+	int ret = 0, id;
 
 	/*
 	 * A page got tagged dirty in DAX mapping? Something is seriously
@@ -789,18 +771,20 @@ static int dax_writeback_one(struct block_device *bdev,
 	dax.size = PAGE_SIZE << dax_radix_order(entry);
 
 	/*
-	 * We cannot hold tree_lock while calling dax_map_atomic() because it
-	 * eventually calls cond_resched().
+	 * bdev_dax_direct_access() may sleep, so cannot hold tree_lock
+	 * over its invocation.
 	 */
-	ret = dax_map_atomic(bdev, &dax);
+	id = dax_read_lock();
+	ret = bdev_dax_direct_access(bdev, dax_inode, &dax);
 	if (ret < 0) {
+		dax_read_unlock(id);
 		put_locked_mapping_entry(mapping, index, entry);
 		return ret;
 	}
 
 	if (WARN_ON_ONCE(ret < dax.size)) {
 		ret = -EIO;
-		goto unmap;
+		goto dax_unlock;
 	}
 
 	dax_mapping_entry_mkclean(mapping, index, pfn_t_to_pfn(dax.pfn));
@@ -814,8 +798,8 @@ static int dax_writeback_one(struct block_device *bdev,
 	spin_lock_irq(&mapping->tree_lock);
 	radix_tree_tag_clear(page_tree, index, PAGECACHE_TAG_DIRTY);
 	spin_unlock_irq(&mapping->tree_lock);
- unmap:
-	dax_unmap_atomic(bdev, &dax);
+ dax_unlock:
+	dax_read_unlock(id);
 	put_locked_mapping_entry(mapping, index, entry);
 	return ret;
 
@@ -836,6 +820,7 @@ int dax_writeback_mapping_range(struct address_space *mapping,
 	struct inode *inode = mapping->host;
 	pgoff_t start_index, end_index;
 	pgoff_t indices[PAGEVEC_SIZE];
+	struct dax_inode *dax_inode;
 	struct pagevec pvec;
 	bool done = false;
 	int i, ret = 0;
@@ -846,6 +831,10 @@ int dax_writeback_mapping_range(struct address_space *mapping,
 	if (!mapping->nrexceptional || wbc->sync_mode != WB_SYNC_ALL)
 		return 0;
 
+	dax_inode = dax_get_by_host(bdev->bd_disk->disk_name);
+	if (!dax_inode)
+		return -EIO;
+
 	start_index = wbc->range_start >> PAGE_SHIFT;
 	end_index = wbc->range_end >> PAGE_SHIFT;
 
@@ -866,19 +855,23 @@ int dax_writeback_mapping_range(struct address_space *mapping,
 				break;
 			}
 
-			ret = dax_writeback_one(bdev, mapping, indices[i],
-					pvec.pages[i]);
-			if (ret < 0)
+			ret = dax_writeback_one(bdev, dax_inode, mapping,
+					indices[i], pvec.pages[i]);
+			if (ret < 0) {
+				put_dax_inode(dax_inode);
 				return ret;
+			}
 		}
 	}
+	put_dax_inode(dax_inode);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(dax_writeback_mapping_range);
 
 static int dax_insert_mapping(struct address_space *mapping,
-		struct block_device *bdev, sector_t sector, size_t size,
-		void **entryp, struct vm_area_struct *vma, struct vm_fault *vmf)
+		struct block_device *bdev, struct dax_inode *dax_inode,
+		sector_t sector, size_t size, void **entryp,
+		struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	unsigned long vaddr = vmf->address;
 	struct blk_dax_ctl dax = {
@@ -887,10 +880,15 @@ static int dax_insert_mapping(struct address_space *mapping,
 	};
 	void *ret;
 	void *entry = *entryp;
+	int id, rc;
 
-	if (dax_map_atomic(bdev, &dax) < 0)
-		return PTR_ERR(dax.addr);
-	dax_unmap_atomic(bdev, &dax);
+	id = dax_read_lock();
+	rc = bdev_dax_direct_access(bdev, dax_inode, &dax);
+	if (rc < 0) {
+		dax_read_unlock(id);
+		return rc;
+	}
+	dax_read_unlock(id);
 
 	ret = dax_insert_mapping_entry(mapping, vmf, entry, dax.sector, 0);
 	if (IS_ERR(ret))
@@ -947,7 +945,8 @@ static bool dax_range_is_aligned(struct block_device *bdev,
 	return true;
 }
 
-int __dax_zero_page_range(struct block_device *bdev, sector_t sector,
+int __dax_zero_page_range(struct block_device *bdev,
+		struct dax_inode *dax_inode, sector_t sector,
 		unsigned int offset, unsigned int length)
 {
 	struct blk_dax_ctl dax = {
@@ -961,10 +960,16 @@ int __dax_zero_page_range(struct block_device *bdev, sector_t sector,
 		return blkdev_issue_zeroout(bdev, start_sector,
 				length >> 9, GFP_NOFS, true);
 	} else {
-		if (dax_map_atomic(bdev, &dax) < 0)
-			return PTR_ERR(dax.addr);
+		int rc, id;
+
+		id = dax_read_lock();
+		rc = bdev_dax_direct_access(bdev, dax_inode, &dax);
+		if (rc < 0) {
+			dax_read_unlock(id);
+			return rc;
+		}
 		clear_pmem(dax.addr + offset, length);
-		dax_unmap_atomic(bdev, &dax);
+		dax_read_unlock(id);
 	}
 	return 0;
 }
@@ -983,6 +988,7 @@ dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 	struct iov_iter *iter = data;
 	loff_t end = pos + length, done = 0;
 	ssize_t ret = 0;
+	int id;
 
 	if (iov_iter_rw(iter) == READ) {
 		end = min(end, i_size_read(inode));
@@ -1007,6 +1013,7 @@ dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 					      (end - 1) >> PAGE_SHIFT);
 	}
 
+	id = dax_read_lock();
 	while (pos < end) {
 		unsigned offset = pos & (PAGE_SIZE - 1);
 		struct blk_dax_ctl dax = { 0 };
@@ -1014,7 +1021,8 @@ dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 
 		dax.sector = dax_iomap_sector(iomap, pos);
 		dax.size = (length + offset + PAGE_SIZE - 1) & PAGE_MASK;
-		map_len = dax_map_atomic(iomap->bdev, &dax);
+		map_len = bdev_dax_direct_access(iomap->bdev, iomap->dax_inode,
+				&dax);
 		if (map_len < 0) {
 			ret = map_len;
 			break;
@@ -1029,7 +1037,6 @@ dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 			map_len = copy_from_iter_pmem(dax.addr, map_len, iter);
 		else
 			map_len = copy_to_iter(dax.addr, map_len, iter);
-		dax_unmap_atomic(iomap->bdev, &dax);
 		if (map_len <= 0) {
 			ret = map_len ? map_len : -EFAULT;
 			break;
@@ -1039,6 +1046,7 @@ dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 		length -= map_len;
 		done += map_len;
 	}
+	dax_read_unlock(id);
 
 	return done ? done : ret;
 }
@@ -1151,8 +1159,8 @@ int dax_iomap_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 			clear_user_highpage(vmf->cow_page, vaddr);
 			break;
 		case IOMAP_MAPPED:
-			error = copy_user_dax(iomap.bdev, sector, PAGE_SIZE,
-					vmf->cow_page, vaddr);
+			error = copy_user_dax(iomap.bdev, iomap.dax_inode,
+					sector, PAGE_SIZE, vmf->cow_page, vaddr);
 			break;
 		default:
 			WARN_ON_ONCE(1);
@@ -1177,8 +1185,8 @@ int dax_iomap_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 			mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
 			major = VM_FAULT_MAJOR;
 		}
-		error = dax_insert_mapping(mapping, iomap.bdev, sector,
-				PAGE_SIZE, &entry, vma, vmf);
+		error = dax_insert_mapping(mapping, iomap.bdev, iomap.dax_inode,
+				sector, PAGE_SIZE, &entry, vma, vmf);
 		/* -EBUSY is fine, somebody else faulted on the same PTE */
 		if (error == -EBUSY)
 			error = 0;
@@ -1231,23 +1239,24 @@ static int dax_pmd_insert_mapping(struct vm_area_struct *vma, pmd_t *pmd,
 {
 	struct address_space *mapping = vma->vm_file->f_mapping;
 	struct block_device *bdev = iomap->bdev;
+	struct dax_inode *dax_inode = iomap->dax_inode;
 	struct blk_dax_ctl dax = {
 		.sector = dax_iomap_sector(iomap, pos),
 		.size = PMD_SIZE,
 	};
-	long length = dax_map_atomic(bdev, &dax);
+	long length;
 	void *ret;
+	int id;
 
-	if (length < 0) /* dax_map_atomic() failed */
-		return VM_FAULT_FALLBACK;
+	id = dax_read_lock();
+	length = bdev_dax_direct_access(bdev, dax_inode, &dax);
 	if (length < PMD_SIZE)
-		goto unmap_fallback;
+		goto unlock_fallback;
 	if (pfn_t_to_pfn(dax.pfn) & PG_PMD_COLOUR)
-		goto unmap_fallback;
+		goto unlock_fallback;
 	if (!pfn_t_devmap(dax.pfn))
-		goto unmap_fallback;
-
-	dax_unmap_atomic(bdev, &dax);
+		goto unlock_fallback;
+	dax_read_unlock(id);
 
 	ret = dax_insert_mapping_entry(mapping, vmf, *entryp, dax.sector,
 			RADIX_DAX_PMD);
@@ -1257,8 +1266,8 @@ static int dax_pmd_insert_mapping(struct vm_area_struct *vma, pmd_t *pmd,
 
 	return vmf_insert_pfn_pmd(vma, address, pmd, dax.pfn, write);
 
- unmap_fallback:
-	dax_unmap_atomic(bdev, &dax);
+ unlock_fallback:
+	dax_read_unlock(id);
 	return VM_FAULT_FALLBACK;
 }
 
diff --git a/fs/iomap.c b/fs/iomap.c
index 354a123f170e..279d18cc1cb6 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -355,7 +355,8 @@ static int iomap_dax_zero(loff_t pos, unsigned offset, unsigned bytes,
 	sector_t sector = iomap->blkno +
 		(((pos & ~(PAGE_SIZE - 1)) - iomap->offset) >> 9);
 
-	return __dax_zero_page_range(iomap->bdev, sector, offset, bytes);
+	return __dax_zero_page_range(iomap->bdev, iomap->dax_inode, sector,
+			offset, bytes);
 }
 
 static loff_t
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 10b742af3d56..b8e8e7896452 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -65,11 +65,13 @@ void dax_wake_mapping_entry_waiter(struct address_space *mapping,
 		pgoff_t index, void *entry, bool wake_all);
 
 #ifdef CONFIG_FS_DAX
-int __dax_zero_page_range(struct block_device *bdev, sector_t sector,
+int __dax_zero_page_range(struct block_device *bdev,
+		struct dax_inode *dax_inode, sector_t sector,
 		unsigned int offset, unsigned int length);
 #else
 static inline int __dax_zero_page_range(struct block_device *bdev,
-		sector_t sector, unsigned int offset, unsigned int length)
+		struct dax_inode *dax_inode, sector_t sector,
+		unsigned int offset, unsigned int length)
 {
 	return -ENXIO;
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
