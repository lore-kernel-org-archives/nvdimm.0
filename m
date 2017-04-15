Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ADAA82194EB6B
 for <linux-nvdimm@lists.01.org>; Fri, 14 Apr 2017 19:40:11 -0700 (PDT)
Subject: [PATCH v2 15/33] filesystem-dax: convert to dax_direct_access()
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 14 Apr 2017 19:34:27 -0700
Message-ID: <149222366749.32363.12950570201970933579.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149222358726.32363.15876405696577002849.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149222358726.32363.15876405696577002849.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Now that a dax_device is plumbed through all dax-capable drivers we can
switch from block_device_operations to dax_operations for invoking
->direct_access.

This also lets us kill off some usages of struct blk_dax_ctl on the way
to its eventual removal.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/dax.c            |  277 +++++++++++++++++++++++++++++----------------------
 fs/iomap.c          |    3 -
 include/linux/dax.h |    6 +
 3 files changed, 162 insertions(+), 124 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index b78a6947c4f5..ce9dc9c3e829 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -55,32 +55,6 @@ static int __init init_dax_wait_table(void)
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
@@ -553,21 +527,30 @@ static int dax_load_hole(struct address_space *mapping, void **entry,
 	return ret;
 }
 
-static int copy_user_dax(struct block_device *bdev, sector_t sector, size_t size,
-		struct page *to, unsigned long vaddr)
+static int copy_user_dax(struct block_device *bdev, struct dax_device *dax_dev,
+		sector_t sector, size_t size, struct page *to,
+		unsigned long vaddr)
 {
-	struct blk_dax_ctl dax = {
-		.sector = sector,
-		.size = size,
-	};
-	void *vto;
-
-	if (dax_map_atomic(bdev, &dax) < 0)
-		return PTR_ERR(dax.addr);
+	void *vto, *kaddr;
+	pgoff_t pgoff;
+	pfn_t pfn;
+	long rc;
+	int id;
+
+	rc = bdev_dax_pgoff(bdev, sector, size, &pgoff);
+	if (rc)
+		return rc;
+
+	id = dax_read_lock();
+	rc = dax_direct_access(dax_dev, pgoff, PHYS_PFN(size), &kaddr, &pfn);
+	if (rc < 0) {
+		dax_read_unlock(id);
+		return rc;
+	}
 	vto = kmap_atomic(to);
-	copy_user_page(vto, (void __force *)dax.addr, vaddr, to);
+	copy_user_page(vto, (void __force *)kaddr, vaddr, to);
 	kunmap_atomic(vto);
-	dax_unmap_atomic(bdev, &dax);
+	dax_read_unlock(id);
 	return 0;
 }
 
@@ -735,12 +718,16 @@ static void dax_mapping_entry_mkclean(struct address_space *mapping,
 }
 
 static int dax_writeback_one(struct block_device *bdev,
-		struct address_space *mapping, pgoff_t index, void *entry)
+		struct dax_device *dax_dev, struct address_space *mapping,
+		pgoff_t index, void *entry)
 {
 	struct radix_tree_root *page_tree = &mapping->page_tree;
-	struct blk_dax_ctl dax;
-	void *entry2, **slot;
-	int ret = 0;
+	void *entry2, **slot, *kaddr;
+	long ret = 0, id;
+	sector_t sector;
+	pgoff_t pgoff;
+	size_t size;
+	pfn_t pfn;
 
 	/*
 	 * A page got tagged dirty in DAX mapping? Something is seriously
@@ -789,26 +776,29 @@ static int dax_writeback_one(struct block_device *bdev,
 	 * 'entry'.  This allows us to flush for PMD_SIZE and not have to
 	 * worry about partial PMD writebacks.
 	 */
-	dax.sector = dax_radix_sector(entry);
-	dax.size = PAGE_SIZE << dax_radix_order(entry);
+	sector = dax_radix_sector(entry);
+	size = PAGE_SIZE << dax_radix_order(entry);
+
+	id = dax_read_lock();
+	ret = bdev_dax_pgoff(bdev, sector, size, &pgoff);
+	if (ret)
+		goto dax_unlock;
 
 	/*
-	 * We cannot hold tree_lock while calling dax_map_atomic() because it
-	 * eventually calls cond_resched().
+	 * dax_direct_access() may sleep, so cannot hold tree_lock over
+	 * its invocation.
 	 */
-	ret = dax_map_atomic(bdev, &dax);
-	if (ret < 0) {
-		put_locked_mapping_entry(mapping, index, entry);
-		return ret;
-	}
+	ret = dax_direct_access(dax_dev, pgoff, size / PAGE_SIZE, &kaddr, &pfn);
+	if (ret < 0)
+		goto dax_unlock;
 
-	if (WARN_ON_ONCE(ret < dax.size)) {
+	if (WARN_ON_ONCE(ret < size / PAGE_SIZE)) {
 		ret = -EIO;
-		goto unmap;
+		goto dax_unlock;
 	}
 
-	dax_mapping_entry_mkclean(mapping, index, pfn_t_to_pfn(dax.pfn));
-	wb_cache_pmem(dax.addr, dax.size);
+	dax_mapping_entry_mkclean(mapping, index, pfn_t_to_pfn(pfn));
+	wb_cache_pmem(kaddr, size);
 	/*
 	 * After we have flushed the cache, we can clear the dirty tag. There
 	 * cannot be new dirty data in the pfn after the flush has completed as
@@ -818,8 +808,8 @@ static int dax_writeback_one(struct block_device *bdev,
 	spin_lock_irq(&mapping->tree_lock);
 	radix_tree_tag_clear(page_tree, index, PAGECACHE_TAG_DIRTY);
 	spin_unlock_irq(&mapping->tree_lock);
- unmap:
-	dax_unmap_atomic(bdev, &dax);
+ dax_unlock:
+	dax_read_unlock(id);
 	put_locked_mapping_entry(mapping, index, entry);
 	return ret;
 
@@ -840,6 +830,7 @@ int dax_writeback_mapping_range(struct address_space *mapping,
 	struct inode *inode = mapping->host;
 	pgoff_t start_index, end_index;
 	pgoff_t indices[PAGEVEC_SIZE];
+	struct dax_device *dax_dev;
 	struct pagevec pvec;
 	bool done = false;
 	int i, ret = 0;
@@ -850,6 +841,10 @@ int dax_writeback_mapping_range(struct address_space *mapping,
 	if (!mapping->nrexceptional || wbc->sync_mode != WB_SYNC_ALL)
 		return 0;
 
+	dax_dev = dax_get_by_host(bdev->bd_disk->disk_name);
+	if (!dax_dev)
+		return -EIO;
+
 	start_index = wbc->range_start >> PAGE_SHIFT;
 	end_index = wbc->range_end >> PAGE_SHIFT;
 
@@ -870,38 +865,49 @@ int dax_writeback_mapping_range(struct address_space *mapping,
 				break;
 			}
 
-			ret = dax_writeback_one(bdev, mapping, indices[i],
-					pvec.pages[i]);
-			if (ret < 0)
+			ret = dax_writeback_one(bdev, dax_dev, mapping,
+					indices[i], pvec.pages[i]);
+			if (ret < 0) {
+				put_dax(dax_dev);
 				return ret;
+			}
 		}
 	}
+	put_dax(dax_dev);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(dax_writeback_mapping_range);
 
 static int dax_insert_mapping(struct address_space *mapping,
-		struct block_device *bdev, sector_t sector, size_t size,
-		void **entryp, struct vm_area_struct *vma, struct vm_fault *vmf)
+		struct block_device *bdev, struct dax_device *dax_dev,
+		sector_t sector, size_t size, void **entryp,
+		struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	unsigned long vaddr = vmf->address;
-	struct blk_dax_ctl dax = {
-		.sector = sector,
-		.size = size,
-	};
-	void *ret;
 	void *entry = *entryp;
+	void *ret, *kaddr;
+	pgoff_t pgoff;
+	int id, rc;
+	pfn_t pfn;
 
-	if (dax_map_atomic(bdev, &dax) < 0)
-		return PTR_ERR(dax.addr);
-	dax_unmap_atomic(bdev, &dax);
+	rc = bdev_dax_pgoff(bdev, sector, size, &pgoff);
+	if (rc)
+		return rc;
 
-	ret = dax_insert_mapping_entry(mapping, vmf, entry, dax.sector, 0);
+	id = dax_read_lock();
+	rc = dax_direct_access(dax_dev, pgoff, PHYS_PFN(size), &kaddr, &pfn);
+	if (rc < 0) {
+		dax_read_unlock(id);
+		return rc;
+	}
+	dax_read_unlock(id);
+
+	ret = dax_insert_mapping_entry(mapping, vmf, entry, sector, 0);
 	if (IS_ERR(ret))
 		return PTR_ERR(ret);
 	*entryp = ret;
 
-	return vm_insert_mixed(vma, vaddr, dax.pfn);
+	return vm_insert_mixed(vma, vaddr, pfn);
 }
 
 /**
@@ -950,24 +956,34 @@ static bool dax_range_is_aligned(struct block_device *bdev,
 	return true;
 }
 
-int __dax_zero_page_range(struct block_device *bdev, sector_t sector,
-		unsigned int offset, unsigned int length)
+int __dax_zero_page_range(struct block_device *bdev,
+		struct dax_device *dax_dev, sector_t sector,
+		unsigned int offset, unsigned int size)
 {
-	struct blk_dax_ctl dax = {
-		.sector		= sector,
-		.size		= PAGE_SIZE,
-	};
-
-	if (dax_range_is_aligned(bdev, offset, length)) {
-		sector_t start_sector = dax.sector + (offset >> 9);
+	if (dax_range_is_aligned(bdev, offset, size)) {
+		sector_t start_sector = sector + (offset >> 9);
 
 		return blkdev_issue_zeroout(bdev, start_sector,
-				length >> 9, GFP_NOFS, true);
+				size >> 9, GFP_NOFS, true);
 	} else {
-		if (dax_map_atomic(bdev, &dax) < 0)
-			return PTR_ERR(dax.addr);
-		clear_pmem(dax.addr + offset, length);
-		dax_unmap_atomic(bdev, &dax);
+		pgoff_t pgoff;
+		long rc, id;
+		void *kaddr;
+		pfn_t pfn;
+
+		rc = bdev_dax_pgoff(bdev, sector, size, &pgoff);
+		if (rc)
+			return rc;
+
+		id = dax_read_lock();
+		rc = dax_direct_access(dax_dev, pgoff, PHYS_PFN(size), &kaddr,
+				&pfn);
+		if (rc < 0) {
+			dax_read_unlock(id);
+			return rc;
+		}
+		clear_pmem(kaddr + offset, size);
+		dax_read_unlock(id);
 	}
 	return 0;
 }
@@ -982,9 +998,12 @@ static loff_t
 dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 		struct iomap *iomap)
 {
+	struct block_device *bdev = iomap->bdev;
+	struct dax_device *dax_dev = iomap->dax_dev;
 	struct iov_iter *iter = data;
 	loff_t end = pos + length, done = 0;
 	ssize_t ret = 0;
+	int id;
 
 	if (iov_iter_rw(iter) == READ) {
 		end = min(end, i_size_read(inode));
@@ -1009,34 +1028,42 @@ dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 					      (end - 1) >> PAGE_SHIFT);
 	}
 
+	id = dax_read_lock();
 	while (pos < end) {
 		unsigned offset = pos & (PAGE_SIZE - 1);
-		struct blk_dax_ctl dax = { 0 };
+		const size_t size = ALIGN(length + offset, PAGE_SIZE);
+		const sector_t sector = dax_iomap_sector(iomap, pos);
 		ssize_t map_len;
+		pgoff_t pgoff;
+		void *kaddr;
+		pfn_t pfn;
 
 		if (fatal_signal_pending(current)) {
 			ret = -EINTR;
 			break;
 		}
 
-		dax.sector = dax_iomap_sector(iomap, pos);
-		dax.size = (length + offset + PAGE_SIZE - 1) & PAGE_MASK;
-		map_len = dax_map_atomic(iomap->bdev, &dax);
+		ret = bdev_dax_pgoff(bdev, sector, size, &pgoff);
+		if (ret)
+			break;
+
+		map_len = dax_direct_access(dax_dev, pgoff, PHYS_PFN(size),
+				&kaddr, &pfn);
 		if (map_len < 0) {
 			ret = map_len;
 			break;
 		}
 
-		dax.addr += offset;
+		map_len = PFN_PHYS(map_len);
+		kaddr += offset;
 		map_len -= offset;
 		if (map_len > end - pos)
 			map_len = end - pos;
 
 		if (iov_iter_rw(iter) == WRITE)
-			map_len = copy_from_iter_pmem(dax.addr, map_len, iter);
+			map_len = copy_from_iter_pmem(kaddr, map_len, iter);
 		else
-			map_len = copy_to_iter(dax.addr, map_len, iter);
-		dax_unmap_atomic(iomap->bdev, &dax);
+			map_len = copy_to_iter(kaddr, map_len, iter);
 		if (map_len <= 0) {
 			ret = map_len ? map_len : -EFAULT;
 			break;
@@ -1046,6 +1073,7 @@ dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 		length -= map_len;
 		done += map_len;
 	}
+	dax_read_unlock(id);
 
 	return done ? done : ret;
 }
@@ -1152,8 +1180,8 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf,
 			clear_user_highpage(vmf->cow_page, vaddr);
 			break;
 		case IOMAP_MAPPED:
-			error = copy_user_dax(iomap.bdev, sector, PAGE_SIZE,
-					vmf->cow_page, vaddr);
+			error = copy_user_dax(iomap.bdev, iomap.dax_dev,
+					sector, PAGE_SIZE, vmf->cow_page, vaddr);
 			break;
 		default:
 			WARN_ON_ONCE(1);
@@ -1178,8 +1206,8 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf,
 			mem_cgroup_count_vm_event(vmf->vma->vm_mm, PGMAJFAULT);
 			major = VM_FAULT_MAJOR;
 		}
-		error = dax_insert_mapping(mapping, iomap.bdev, sector,
-				PAGE_SIZE, &entry, vmf->vma, vmf);
+		error = dax_insert_mapping(mapping, iomap.bdev, iomap.dax_dev,
+				sector, PAGE_SIZE, &entry, vmf->vma, vmf);
 		/* -EBUSY is fine, somebody else faulted on the same PTE */
 		if (error == -EBUSY)
 			error = 0;
@@ -1229,41 +1257,48 @@ static int dax_pmd_insert_mapping(struct vm_fault *vmf, struct iomap *iomap,
 		loff_t pos, void **entryp)
 {
 	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
+	const sector_t sector = dax_iomap_sector(iomap, pos);
+	struct dax_device *dax_dev = iomap->dax_dev;
 	struct block_device *bdev = iomap->bdev;
 	struct inode *inode = mapping->host;
-	struct blk_dax_ctl dax = {
-		.sector = dax_iomap_sector(iomap, pos),
-		.size = PMD_SIZE,
-	};
-	long length = dax_map_atomic(bdev, &dax);
-	void *ret = NULL;
-
-	if (length < 0) /* dax_map_atomic() failed */
+	const size_t size = PMD_SIZE;
+	void *ret = NULL, *kaddr;
+	long length = 0;
+	pgoff_t pgoff;
+	pfn_t pfn;
+	int id;
+
+	if (bdev_dax_pgoff(bdev, sector, size, &pgoff) != 0)
 		goto fallback;
-	if (length < PMD_SIZE)
-		goto unmap_fallback;
-	if (pfn_t_to_pfn(dax.pfn) & PG_PMD_COLOUR)
-		goto unmap_fallback;
-	if (!pfn_t_devmap(dax.pfn))
-		goto unmap_fallback;
-
-	dax_unmap_atomic(bdev, &dax);
 
-	ret = dax_insert_mapping_entry(mapping, vmf, *entryp, dax.sector,
+	id = dax_read_lock();
+	length = dax_direct_access(dax_dev, pgoff, PHYS_PFN(size), &kaddr, &pfn);
+	if (length < 0)
+		goto unlock_fallback;
+	length = PFN_PHYS(length);
+
+	if (length < size)
+		goto unlock_fallback;
+	if (pfn_t_to_pfn(pfn) & PG_PMD_COLOUR)
+		goto unlock_fallback;
+	if (!pfn_t_devmap(pfn))
+		goto unlock_fallback;
+	dax_read_unlock(id);
+
+	ret = dax_insert_mapping_entry(mapping, vmf, *entryp, sector,
 			RADIX_DAX_PMD);
 	if (IS_ERR(ret))
 		goto fallback;
 	*entryp = ret;
 
-	trace_dax_pmd_insert_mapping(inode, vmf, length, dax.pfn, ret);
+	trace_dax_pmd_insert_mapping(inode, vmf, length, pfn, ret);
 	return vmf_insert_pfn_pmd(vmf->vma, vmf->address, vmf->pmd,
-			dax.pfn, vmf->flags & FAULT_FLAG_WRITE);
+			pfn, vmf->flags & FAULT_FLAG_WRITE);
 
- unmap_fallback:
-	dax_unmap_atomic(bdev, &dax);
+unlock_fallback:
+	dax_read_unlock(id);
 fallback:
-	trace_dax_pmd_insert_mapping_fallback(inode, vmf, length,
-			dax.pfn, ret);
+	trace_dax_pmd_insert_mapping_fallback(inode, vmf, length, pfn, ret);
 	return VM_FAULT_FALLBACK;
 }
 
diff --git a/fs/iomap.c b/fs/iomap.c
index 141c3cd55a8b..4ec0d6ac8bc1 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -360,7 +360,8 @@ static int iomap_dax_zero(loff_t pos, unsigned offset, unsigned bytes,
 	sector_t sector = iomap->blkno +
 		(((pos & ~(PAGE_SIZE - 1)) - iomap->offset) >> 9);
 
-	return __dax_zero_page_range(iomap->bdev, sector, offset, bytes);
+	return __dax_zero_page_range(iomap->bdev, iomap->dax_dev, sector,
+			offset, bytes);
 }
 
 static loff_t
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 0d0d890f9186..d3158e74a59e 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -70,11 +70,13 @@ void dax_wake_mapping_entry_waiter(struct address_space *mapping,
 		pgoff_t index, void *entry, bool wake_all);
 
 #ifdef CONFIG_FS_DAX
-int __dax_zero_page_range(struct block_device *bdev, sector_t sector,
+int __dax_zero_page_range(struct block_device *bdev,
+		struct dax_device *dax_dev, sector_t sector,
 		unsigned int offset, unsigned int length);
 #else
 static inline int __dax_zero_page_range(struct block_device *bdev,
-		sector_t sector, unsigned int offset, unsigned int length)
+		struct dax_device *dax_dev, sector_t sector,
+		unsigned int offset, unsigned int length)
 {
 	return -ENXIO;
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
