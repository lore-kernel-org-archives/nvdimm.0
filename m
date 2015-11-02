Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v3 14/15] dax: dirty extent notification
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 01 Nov 2015 23:30:58 -0500
Message-ID: <20151102043058.6610.15559.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20151102042941.6610.27784.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20151102042941.6610.27784.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@fb.com
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, david@fromorbit.com, linux-kernel@vger.kernel.org, ross.zwisler@linux.intel.com, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

DAX-enabled block device drivers can use hints from fs/dax.c to
optimize their internal tracking of potentially dirty cpu cache lines.
If a DAX mapping is being used for synchronous operations, dax_do_io(),
a dax-enabled block-driver knows that fs/dax.c will handle immediate
flushing.  For asynchronous mappings, i.e.  returned to userspace via
mmap, the driver can track active extents of the media for flushing.

We can later extend the DAX paths to indicate when an async mapping is
"closed" allowing the active extents to be marked clean.

Because this capability requires adding two new parameters to
->direct_access ('size' and 'flags') convert the function to a control
parameter block.  As a result this cleans up dax_map_atomic() usage as
there is no longer a need to have a separate __dax_map_atomic, and the
return value can match bdev_direct_access().

No functional change results from this patch, just code movement to the
new parameter scheme.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/powerpc/sysdev/axonram.c |    9 +-
 drivers/block/brd.c           |   10 +-
 drivers/nvdimm/pmem.c         |   10 +-
 drivers/s390/block/dcssblk.c  |    9 +-
 fs/block_dev.c                |   17 ++--
 fs/dax.c                      |  167 ++++++++++++++++++++++-------------------
 include/linux/blkdev.h        |   24 +++++-
 7 files changed, 136 insertions(+), 110 deletions(-)

diff --git a/arch/powerpc/sysdev/axonram.c b/arch/powerpc/sysdev/axonram.c
index 59ca4c0ab529..11aeb47a6540 100644
--- a/arch/powerpc/sysdev/axonram.c
+++ b/arch/powerpc/sysdev/axonram.c
@@ -140,14 +140,13 @@ axon_ram_make_request(struct request_queue *queue, struct bio *bio)
  * @device, @sector, @data: see block_device_operations method
  */
 static long
-axon_ram_direct_access(struct block_device *device, sector_t sector,
-		       void __pmem **kaddr, pfn_t *pfn)
+axon_ram_direct_access(struct block_device *device, struct blk_dax_ctl *dax)
 {
 	struct axon_ram_bank *bank = device->bd_disk->private_data;
-	loff_t offset = (loff_t)sector << AXON_RAM_SECTOR_SHIFT;
+	loff_t offset = (loff_t)dax->sector << AXON_RAM_SECTOR_SHIFT;
 
-	*kaddr = (void __pmem __force *) bank->io_addr + offset;
-	*pfn = phys_to_pfn_t(bank->ph_addr + offset, PFN_DEV);
+	dax->addr = (void __pmem __force *) bank->io_addr + offset;
+	dax->pfn = phys_to_pfn_t(bank->ph_addr + offset, PFN_DEV);
 	return bank->size - offset;
 }
 
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 0bbc60463779..686e1e7a5973 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -373,19 +373,19 @@ static int brd_rw_page(struct block_device *bdev, sector_t sector,
 }
 
 #ifdef CONFIG_BLK_DEV_RAM_DAX
-static long brd_direct_access(struct block_device *bdev, sector_t sector,
-			void __pmem **kaddr, pfn_t *pfn)
+static long brd_direct_access(struct block_device *bdev,
+		struct blk_dax_ctl *dax)
 {
 	struct brd_device *brd = bdev->bd_disk->private_data;
 	struct page *page;
 
 	if (!brd)
 		return -ENODEV;
-	page = brd_insert_page(brd, sector);
+	page = brd_insert_page(brd, dax->sector);
 	if (!page)
 		return -ENOSPC;
-	*kaddr = (void __pmem *)page_address(page);
-	*pfn = page_to_pfn_t(page);
+	dax->addr = (void __pmem *)page_address(page);
+	dax->pfn = page_to_pfn_t(page);
 
 	return PAGE_SIZE;
 }
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index aa2f1292120a..3d83f3079602 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -103,14 +103,14 @@ static int pmem_rw_page(struct block_device *bdev, sector_t sector,
 	return 0;
 }
 
-static long pmem_direct_access(struct block_device *bdev, sector_t sector,
-		      void __pmem **kaddr, pfn_t *pfn)
+static long pmem_direct_access(struct block_device *bdev,
+		struct blk_dax_ctl *dax)
 {
 	struct pmem_device *pmem = bdev->bd_disk->private_data;
-	resource_size_t offset = sector * 512 + pmem->data_offset;
+	resource_size_t offset = dax->sector * 512 + pmem->data_offset;
 
-	*kaddr = pmem->virt_addr + offset;
-	*pfn = phys_to_pfn_t(pmem->phys_addr + offset, pmem->pfn_flags);
+	dax->addr = pmem->virt_addr + offset;
+	dax->pfn = phys_to_pfn_t(pmem->phys_addr + offset, pmem->pfn_flags);
 
 	return pmem->size - offset;
 }
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index e2b2839e4de5..6b01f56373e0 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -880,8 +880,7 @@ fail:
 }
 
 static long
-dcssblk_direct_access (struct block_device *bdev, sector_t secnum,
-			void __pmem **kaddr, pfn_t *pfn)
+dcssblk_direct_access (struct block_device *bdev, struct blk_dax_ctl *dax)
 {
 	struct dcssblk_dev_info *dev_info;
 	unsigned long offset, dev_sz;
@@ -890,9 +889,9 @@ dcssblk_direct_access (struct block_device *bdev, sector_t secnum,
 	if (!dev_info)
 		return -ENODEV;
 	dev_sz = dev_info->end - dev_info->start;
-	offset = secnum * 512;
-	*kaddr = (void __pmem *) (dev_info->start + offset);
-	*pfn = phys_to_pfn_t(dev_info->start + offset, PFN_DEV);
+	offset = dax->sector * 512;
+	dax->addr = (void __pmem *) (dev_info->start + offset);
+	dax->pfn = phys_to_pfn_t(dev_info->start + offset, PFN_DEV);
 
 	return dev_sz - offset;
 }
diff --git a/fs/block_dev.c b/fs/block_dev.c
index ee34a31e6fa4..d1b0bbf00bd3 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -453,10 +453,7 @@ EXPORT_SYMBOL_GPL(bdev_write_page);
 /**
  * bdev_direct_access() - Get the address for directly-accessibly memory
  * @bdev: The device containing the memory
- * @sector: The offset within the device
- * @addr: Where to put the address of the memory
- * @pfn: The Page Frame Number for the memory
- * @size: The number of bytes requested
+ * @ctl: control and output parameters for ->direct_access
  *
  * If a block device is made up of directly addressable memory, this function
  * will tell the caller the PFN and the address of the memory.  The address
@@ -467,10 +464,10 @@ EXPORT_SYMBOL_GPL(bdev_write_page);
  * Return: negative errno if an error occurs, otherwise the number of bytes
  * accessible at this address.
  */
-long bdev_direct_access(struct block_device *bdev, sector_t sector,
-			void __pmem **addr, pfn_t *pfn, long size)
+long bdev_direct_access(struct block_device *bdev, struct blk_dax_ctl *ctl)
 {
-	long avail;
+	sector_t sector, save;
+	long avail, size = ctl->size;
 	const struct block_device_operations *ops = bdev->bd_disk->fops;
 
 	/*
@@ -479,6 +476,8 @@ long bdev_direct_access(struct block_device *bdev, sector_t sector,
 	 */
 	might_sleep();
 
+	save = ctl->sector;
+	sector = ctl->sector;
 	if (size < 0)
 		return size;
 	if (!ops->direct_access)
@@ -489,7 +488,9 @@ long bdev_direct_access(struct block_device *bdev, sector_t sector,
 	sector += get_start_sect(bdev);
 	if (sector % (PAGE_SIZE / 512))
 		return -EINVAL;
-	avail = ops->direct_access(bdev, sector, addr, pfn);
+	ctl->sector = sector;
+	avail = ops->direct_access(bdev, ctl);
+	ctl->sector = save;
 	if (!avail)
 		return -ERANGE;
 	return min(avail, size);
diff --git a/fs/dax.c b/fs/dax.c
index ac8992e86779..f5835c4a7e1f 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -30,36 +30,28 @@
 #include <linux/vmstat.h>
 #include <linux/sizes.h>
 
-static void __pmem *__dax_map_atomic(struct block_device *bdev, sector_t sector,
-		long size, pfn_t *pfn, long *len)
+static long dax_map_atomic(struct block_device *bdev, struct blk_dax_ctl *dax)
 {
-	long rc;
-	void __pmem *addr;
 	struct request_queue *q = bdev->bd_queue;
+	long rc = -EIO;
 
+	dax->addr = (void __pmem *) ERR_PTR(-EIO);
 	if (blk_queue_enter(q, GFP_NOWAIT) != 0)
-		return (void __pmem *) ERR_PTR(-EIO);
-	rc = bdev_direct_access(bdev, sector, &addr, pfn, size);
-	if (len)
-		*len = rc;
+		return rc;
+
+	rc = bdev_direct_access(bdev, dax);
 	if (rc < 0) {
+		dax->addr = (void __pmem *) ERR_PTR(rc);
 		blk_queue_exit(q);
-		return (void __pmem *) ERR_PTR(rc);
+		return rc;
 	}
-	return addr;
-}
-
-static void __pmem *dax_map_atomic(struct block_device *bdev, sector_t sector,
-		long size)
-{
-	pfn_t pfn;
-
-	return __dax_map_atomic(bdev, sector, size, &pfn, NULL);
+	return rc;
 }
 
-static void dax_unmap_atomic(struct block_device *bdev, void __pmem *addr)
+static void dax_unmap_atomic(struct block_device *bdev,
+		const struct blk_dax_ctl *dax)
 {
-	if (IS_ERR(addr))
+	if (IS_ERR(dax->addr))
 		return;
 	blk_queue_exit(bdev->bd_queue);
 }
@@ -67,28 +59,29 @@ static void dax_unmap_atomic(struct block_device *bdev, void __pmem *addr)
 int dax_clear_blocks(struct inode *inode, sector_t block, long size)
 {
 	struct block_device *bdev = inode->i_sb->s_bdev;
-	sector_t sector = block << (inode->i_blkbits - 9);
+	struct blk_dax_ctl dax;
 
 	might_sleep();
+	dax.sector = block << (inode->i_blkbits - 9),
+	dax.flags = 0;
+	dax.size = size;
 	do {
-		void __pmem *addr;
 		long count, sz;
-		pfn_t pfn;
 
 		sz = min_t(long, size, SZ_1M);
-		addr = __dax_map_atomic(bdev, sector, size, &pfn, &count);
-		if (IS_ERR(addr))
-			return PTR_ERR(addr);
+		count = dax_map_atomic(bdev, &dax);
+		if (count < 0)
+			return count;
 		if (count < sz)
 			sz = count;
-		clear_pmem(addr, sz);
-		addr += sz;
-		size -= sz;
+		clear_pmem(dax.addr, sz);
+		dax_unmap_atomic(bdev, &dax);
+		dax.addr += sz;
+		dax.size -= sz;
 		BUG_ON(sz & 511);
-		sector += sz / 512;
-		dax_unmap_atomic(bdev, addr);
+		dax.sector += sz / 512;
 		cond_resched();
-	} while (size);
+	} while (dax.size);
 
 	wmb_pmem();
 	return 0;
@@ -141,9 +134,11 @@ static ssize_t dax_io(struct inode *inode, struct iov_iter *iter,
 	struct block_device *bdev = NULL;
 	int rw = iov_iter_rw(iter), rc;
 	long map_len = 0;
-	pfn_t pfn;
 	void __pmem *addr = NULL;
-	void __pmem *kmap = (void __pmem *) ERR_PTR(-EIO);
+	struct blk_dax_ctl dax = {
+		.addr = (void __pmem *) ERR_PTR(-EIO),
+		.flags = 0,
+	};
 	bool hole = false;
 	bool need_wmb = false;
 
@@ -181,15 +176,15 @@ static ssize_t dax_io(struct inode *inode, struct iov_iter *iter,
 				addr = NULL;
 				size = bh->b_size - first;
 			} else {
-				dax_unmap_atomic(bdev, kmap);
-				kmap = __dax_map_atomic(bdev,
-						to_sector(bh, inode),
-						bh->b_size, &pfn, &map_len);
-				if (IS_ERR(kmap)) {
-					rc = PTR_ERR(kmap);
+				dax_unmap_atomic(bdev, &dax);
+				dax.sector = to_sector(bh, inode);
+				dax.size = bh->b_size;
+				map_len = dax_map_atomic(bdev, &dax);
+				if (map_len < 0) {
+					rc = map_len;
 					break;
 				}
-				addr = kmap;
+				addr = dax.addr;
 				if (buffer_unwritten(bh) || buffer_new(bh)) {
 					dax_new_buf(addr, map_len, first, pos,
 							end);
@@ -219,7 +214,7 @@ static ssize_t dax_io(struct inode *inode, struct iov_iter *iter,
 
 	if (need_wmb)
 		wmb_pmem();
-	dax_unmap_atomic(bdev, kmap);
+	dax_unmap_atomic(bdev, &dax);
 
 	return (pos == start) ? rc : pos - start;
 }
@@ -313,17 +308,20 @@ static int dax_load_hole(struct address_space *mapping, struct page *page,
 static int copy_user_bh(struct page *to, struct inode *inode,
 		struct buffer_head *bh, unsigned long vaddr)
 {
+	struct blk_dax_ctl dax = {
+		.sector = to_sector(bh, inode),
+		.size = bh->b_size,
+		.flags = 0,
+	};
 	struct block_device *bdev = bh->b_bdev;
-	void __pmem *vfrom;
 	void *vto;
 
-	vfrom = dax_map_atomic(bdev, to_sector(bh, inode), bh->b_size);
-	if (IS_ERR(vfrom))
-		return PTR_ERR(vfrom);
+	if (dax_map_atomic(bdev, &dax) < 0)
+		return PTR_ERR(dax.addr);
 	vto = kmap_atomic(to);
-	copy_user_page(vto, (void __force *)vfrom, vaddr, to);
+	copy_user_page(vto, (void __force *)dax.addr, vaddr, to);
 	kunmap_atomic(vto);
-	dax_unmap_atomic(bdev, vfrom);
+	dax_unmap_atomic(bdev, &dax);
 	return 0;
 }
 
@@ -344,15 +342,25 @@ static void dax_account_mapping(struct block_device *bdev, pfn_t pfn,
 	}
 }
 
+static unsigned long vm_fault_to_dax_flags(struct vm_fault *vmf)
+{
+	if (vmf->flags & (FAULT_FLAG_WRITE | FAULT_FLAG_MKWRITE))
+		return BLKDAX_F_DIRTY;
+	return 0;
+}
+
 static int dax_insert_mapping(struct inode *inode, struct buffer_head *bh,
 			struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	unsigned long vaddr = (unsigned long)vmf->virtual_address;
 	struct address_space *mapping = inode->i_mapping;
 	struct block_device *bdev = bh->b_bdev;
-	void __pmem *addr;
+	struct blk_dax_ctl dax = {
+		.sector = to_sector(bh, inode),
+		.size = bh->b_size,
+		.flags = vm_fault_to_dax_flags(vmf),
+	};
 	pgoff_t size;
-	pfn_t pfn;
 	int error;
 
 	i_mmap_lock_read(mapping);
@@ -370,22 +378,20 @@ static int dax_insert_mapping(struct inode *inode, struct buffer_head *bh,
 		goto out;
 	}
 
-	addr = __dax_map_atomic(bdev, to_sector(bh, inode), bh->b_size,
-			&pfn, NULL);
-	if (IS_ERR(addr)) {
-		error = PTR_ERR(addr);
+	if (dax_map_atomic(bdev, &dax) < 0) {
+		error = PTR_ERR(dax.addr);
 		goto out;
 	}
 
 	if (buffer_unwritten(bh) || buffer_new(bh)) {
-		clear_pmem(addr, PAGE_SIZE);
+		clear_pmem(dax.addr, PAGE_SIZE);
 		wmb_pmem();
 	}
 
-	dax_account_mapping(bdev, pfn, mapping);
-	dax_unmap_atomic(bdev, addr);
+	dax_account_mapping(bdev, dax.pfn, mapping);
+	dax_unmap_atomic(bdev, &dax);
 
-	error = vm_insert_mixed(vma, vaddr, pfn_t_to_pfn(pfn));
+	error = vm_insert_mixed(vma, vaddr, pfn_t_to_pfn(dax.pfn));
 
  out:
 	i_mmap_unlock_read(mapping);
@@ -674,33 +680,35 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 		result = VM_FAULT_NOPAGE;
 		spin_unlock(ptl);
 	} else {
-		pfn_t pfn;
-		long length;
-		void __pmem *kaddr = __dax_map_atomic(bdev,
-				to_sector(&bh, inode), HPAGE_SIZE, &pfn,
-				&length);
-
-		if (IS_ERR(kaddr)) {
+		struct blk_dax_ctl dax = {
+			.sector = to_sector(&bh, inode),
+			.size = HPAGE_SIZE,
+			.flags = flags,
+		};
+		long length = dax_map_atomic(bdev, &dax);
+
+		if (length < 0) {
 			result = VM_FAULT_SIGBUS;
 			goto out;
 		}
-		if ((length < PMD_SIZE) || (pfn_t_to_pfn(pfn) & PG_PMD_COLOUR)) {
-			dax_unmap_atomic(bdev, kaddr);
+		if ((length < HPAGE_SIZE)
+				|| (pfn_t_to_pfn(dax.pfn) & PG_PMD_COLOUR)) {
+			dax_unmap_atomic(bdev, &dax);
 			goto fallback;
 		}
 
 		if (buffer_unwritten(&bh) || buffer_new(&bh)) {
-			clear_pmem(kaddr, HPAGE_SIZE);
+			clear_pmem(dax.addr, HPAGE_SIZE);
 			wmb_pmem();
 			count_vm_event(PGMAJFAULT);
 			mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
 			result |= VM_FAULT_MAJOR;
 		}
-		dax_account_mapping(bdev, pfn, mapping);
-		dax_unmap_atomic(bdev, kaddr);
+		dax_account_mapping(bdev, dax.pfn, mapping);
+		dax_unmap_atomic(bdev, &dax);
 
 		result |= vmf_insert_pfn_pmd(vma, address, pmd,
-				pfn_t_to_pfn(pfn), write);
+				pfn_t_to_pfn(dax.pfn), write);
 	}
 
  out:
@@ -803,14 +811,17 @@ int dax_zero_page_range(struct inode *inode, loff_t from, unsigned length,
 		return err;
 	if (buffer_written(&bh)) {
 		struct block_device *bdev = bh.b_bdev;
-		void __pmem *addr = dax_map_atomic(bdev, to_sector(&bh, inode),
-				PAGE_CACHE_SIZE);
-
-		if (IS_ERR(addr))
-			return PTR_ERR(addr);
-		clear_pmem(addr + offset, length);
+		struct blk_dax_ctl dax = {
+			.sector = to_sector(&bh, inode),
+			.size = PAGE_CACHE_SIZE,
+			.flags = 0,
+		};
+
+		if (dax_map_atomic(bdev, &dax) < 0)
+			return PTR_ERR(dax.addr);
+		clear_pmem(dax.addr + offset, length);
 		wmb_pmem();
-		dax_unmap_atomic(bdev, addr);
+		dax_unmap_atomic(bdev, &dax);
 	}
 
 	return 0;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index e121e5e0c6ac..663e9974820f 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1615,14 +1615,31 @@ static inline bool integrity_req_gap_front_merge(struct request *req,
 
 #endif /* CONFIG_BLK_DEV_INTEGRITY */
 
+#define BLKDAX_F_DIRTY (1UL << 0) /* range is mapped writable to userspace */
+
+/**
+ * struct blk_dax_ctl - control and output parameters for ->direct_access
+ * @sector: (input) offset relative to a block_device
+ * @addr: (output) kernel virtual address for @sector populated by driver
+ * @flags: (input) BLKDAX_F_*
+ * @pfn: (output) page frame number for @addr populated by driver
+ * @size: (input) number of bytes requested
+ */
+struct blk_dax_ctl {
+	sector_t sector;
+	void __pmem *addr;
+	unsigned long flags;
+	long size;
+	pfn_t pfn;
+};
+
 struct block_device_operations {
 	int (*open) (struct block_device *, fmode_t);
 	void (*release) (struct gendisk *, fmode_t);
 	int (*rw_page)(struct block_device *, sector_t, struct page *, int rw);
 	int (*ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
 	int (*compat_ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
-	long (*direct_access)(struct block_device *, sector_t, void __pmem **,
-			pfn_t *);
+	long (*direct_access)(struct block_device *, struct blk_dax_ctl *);
 	unsigned int (*check_events) (struct gendisk *disk,
 				      unsigned int clearing);
 	/* ->media_changed() is DEPRECATED, use ->check_events() instead */
@@ -1640,8 +1657,7 @@ extern int __blkdev_driver_ioctl(struct block_device *, fmode_t, unsigned int,
 extern int bdev_read_page(struct block_device *, sector_t, struct page *);
 extern int bdev_write_page(struct block_device *, sector_t, struct page *,
 						struct writeback_control *);
-extern long bdev_direct_access(struct block_device *, sector_t,
-		void __pmem **addr, pfn_t *pfn, long size);
+extern long bdev_direct_access(struct block_device *, struct blk_dax_ctl *);
 #else /* CONFIG_BLOCK */
 
 struct block_device;

