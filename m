Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Subject: [PATCH v4 4/9] dax: fix mapping lifetime handling,
 convert to __pfn_t + kmap_atomic_pfn_t()
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 05 Jun 2015 17:19:24 -0400
Message-ID: <20150605211924.20751.434.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150605205052.20751.77149.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150605205052.20751.77149.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, boaz@plexistor.com, david@fromorbit.com, linux-arch@vger.kernel.org, arnd@arndb.de, linux-nvdimm@lists.01.org, benh@kernel.crashing.org, linux-fsdevel@vger.kernel.org, heiko.carstens@de.ibm.com, hch@lst.de, mingo@kernel.org, tj@kernel.org, paulus@samba.org, hpa@zytor.com, schwidefsky@de.ibm.com, willy@linux.intel.com, ross.zwisler@linux.intel.com, torvalds@linux-foundation.org, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

The primary source for non-page-backed page-frames to enter the system
is via the pmem driver's ->direct_access() method.  The pfns returned by
the top-level bdev_direct_access() may be passed to any other subsystem
in the kernel and those sub-systems either need to assume that the pfn
is page backed (CONFIG_DEV_PFN=n) or be prepared to handle non-page
backed case (CONFIG_DEV_PFN=y).  Currently the pfns returned by
->direct_access() are only ever used by vm_insert_mixed() which does not
care if the pfn is mapped.  As we go to add more usages of these pfns
add the type-safety of __pfn_t.

This also simplifies the calling convention of ->direct_access() by not
returning the virtual address in the same call.  This annotates cases
where the kernel is directly accessing pmem outside the driver, and
makes the valid lifetime of the reference explicit.  This property may
be useful in the future for invalidating mappings to pmem, but for now
it provides some protection against the "pmem disable vs still-in-use"
race.

Note that axon_ram_direct_access and dcssblk_direct_access were
previously making potentially incorrect assumptions about the addresses
they passed to virt_to_phys().

Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Boaz Harrosh <boaz@plexistor.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/powerpc/sysdev/axonram.c |   26 ++++++++++++-----
 drivers/block/brd.c           |    5 +--
 drivers/block/pmem.c          |   16 ++++++++---
 drivers/s390/block/dcssblk.c  |   26 ++++++++++++++---
 fs/block_dev.c                |    4 +--
 fs/dax.c                      |   62 ++++++++++++++++++++++++++++++++---------
 include/asm-generic/pfn.h     |   25 +++++++++++++++++
 include/linux/blkdev.h        |    7 ++---
 8 files changed, 132 insertions(+), 39 deletions(-)

diff --git a/arch/powerpc/sysdev/axonram.c b/arch/powerpc/sysdev/axonram.c
index e8657d3bc588..20725006592e 100644
--- a/arch/powerpc/sysdev/axonram.c
+++ b/arch/powerpc/sysdev/axonram.c
@@ -139,22 +139,23 @@ axon_ram_make_request(struct request_queue *queue, struct bio *bio)
  * axon_ram_direct_access - direct_access() method for block device
  * @device, @sector, @data: see block_device_operations method
  */
-static long
+static __maybe_unused long
 axon_ram_direct_access(struct block_device *device, sector_t sector,
-		       void **kaddr, unsigned long *pfn)
+		       __pfn_t *pfn)
 {
 	struct axon_ram_bank *bank = device->bd_disk->private_data;
 	loff_t offset = (loff_t)sector << AXON_RAM_SECTOR_SHIFT;
 
-	*kaddr = (void *)(bank->ph_addr + offset);
-	*pfn = virt_to_phys(*kaddr) >> PAGE_SHIFT;
+	*pfn = phys_to_pfn_t(bank->ph_addr + offset);
 
 	return bank->size - offset;
 }
 
 static const struct block_device_operations axon_ram_devops = {
 	.owner		= THIS_MODULE,
+#ifdef HAVE_KMAP_PFN
 	.direct_access	= axon_ram_direct_access
+#endif
 };
 
 /**
@@ -165,9 +166,13 @@ static int axon_ram_probe(struct platform_device *device)
 {
 	static int axon_ram_bank_id = -1;
 	struct axon_ram_bank *bank;
-	struct resource resource;
+	struct resource *resource;
 	int rc = 0;
 
+	resource = devm_kzalloc(&device->dev, sizeof(*resource), GFP_KERNEL);
+	if (!resource)
+		return -ENOMEM;
+
 	axon_ram_bank_id++;
 
 	dev_info(&device->dev, "Found memory controller on %s\n",
@@ -184,13 +189,13 @@ static int axon_ram_probe(struct platform_device *device)
 
 	bank->device = device;
 
-	if (of_address_to_resource(device->dev.of_node, 0, &resource) != 0) {
+	if (of_address_to_resource(device->dev.of_node, 0, resource) != 0) {
 		dev_err(&device->dev, "Cannot access device tree\n");
 		rc = -EFAULT;
 		goto failed;
 	}
 
-	bank->size = resource_size(&resource);
+	bank->size = resource_size(resource);
 
 	if (bank->size == 0) {
 		dev_err(&device->dev, "No DDR2 memory found for %s%d\n",
@@ -202,7 +207,7 @@ static int axon_ram_probe(struct platform_device *device)
 	dev_info(&device->dev, "Register DDR2 memory device %s%d with %luMB\n",
 			AXON_RAM_DEVICE_NAME, axon_ram_bank_id, bank->size >> 20);
 
-	bank->ph_addr = resource.start;
+	bank->ph_addr = resource->start;
 	bank->io_addr = (unsigned long) ioremap_prot(
 			bank->ph_addr, bank->size, _PAGE_NO_CACHE);
 	if (bank->io_addr == 0) {
@@ -211,6 +216,11 @@ static int axon_ram_probe(struct platform_device *device)
 		goto failed;
 	}
 
+	rc = devm_register_kmap_pfn_range(&device->dev, resource,
+			(void *) bank->io_addr);
+	if (rc)
+		goto failed;
+
 	bank->disk = alloc_disk(AXON_RAM_MINORS_PER_DISK);
 	if (bank->disk == NULL) {
 		dev_err(&device->dev, "Cannot register disk\n");
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 41528857c70d..6c4b21a4e915 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -371,7 +371,7 @@ static int brd_rw_page(struct block_device *bdev, sector_t sector,
 
 #ifdef CONFIG_BLK_DEV_RAM_DAX
 static long brd_direct_access(struct block_device *bdev, sector_t sector,
-			void **kaddr, unsigned long *pfn)
+		__pfn_t *pfn)
 {
 	struct brd_device *brd = bdev->bd_disk->private_data;
 	struct page *page;
@@ -381,8 +381,7 @@ static long brd_direct_access(struct block_device *bdev, sector_t sector,
 	page = brd_insert_page(brd, sector);
 	if (!page)
 		return -ENOSPC;
-	*kaddr = page_address(page);
-	*pfn = page_to_pfn(page);
+	*pfn = page_to_pfn_t(page);
 
 	return PAGE_SIZE;
 }
diff --git a/drivers/block/pmem.c b/drivers/block/pmem.c
index 1f5b5a6288c0..0cb66aa00b4b 100644
--- a/drivers/block/pmem.c
+++ b/drivers/block/pmem.c
@@ -23,6 +23,8 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/slab.h>
+#include <linux/highmem.h>
+#include <linux/mm.h>
 
 #define PMEM_MINORS		16
 
@@ -97,8 +99,8 @@ static int pmem_rw_page(struct block_device *bdev, sector_t sector,
 	return 0;
 }
 
-static long pmem_direct_access(struct block_device *bdev, sector_t sector,
-			      void **kaddr, unsigned long *pfn)
+static  __maybe_unused long pmem_direct_access(struct block_device *bdev,
+		sector_t sector, __pfn_t *pfn)
 {
 	struct pmem_device *pmem = bdev->bd_disk->private_data;
 	size_t offset = sector << 9;
@@ -106,8 +108,7 @@ static long pmem_direct_access(struct block_device *bdev, sector_t sector,
 	if (!pmem)
 		return -ENODEV;
 
-	*kaddr = pmem->virt_addr + offset;
-	*pfn = (pmem->phys_addr + offset) >> PAGE_SHIFT;
+	*pfn = phys_to_pfn_t(pmem->phys_addr + offset);
 
 	return pmem->size - offset;
 }
@@ -115,7 +116,9 @@ static long pmem_direct_access(struct block_device *bdev, sector_t sector,
 static const struct block_device_operations pmem_fops = {
 	.owner =		THIS_MODULE,
 	.rw_page =		pmem_rw_page,
+#ifdef HAVE_KMAP_PFN
 	.direct_access =	pmem_direct_access,
+#endif
 };
 
 static struct pmem_device *pmem_alloc(struct device *dev, struct resource *res)
@@ -147,6 +150,11 @@ static struct pmem_device *pmem_alloc(struct device *dev, struct resource *res)
 	if (!pmem->virt_addr)
 		goto out_release_region;
 
+	err = devm_register_kmap_pfn_range(dev, res, pmem->virt_addr);
+	if (err)
+		goto out_unmap;
+
+	err = -ENOMEM;
 	pmem->pmem_queue = blk_alloc_queue(GFP_KERNEL);
 	if (!pmem->pmem_queue)
 		goto out_unmap;
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index 2f1734ba0e22..a7b9743c546f 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -29,7 +29,7 @@ static int dcssblk_open(struct block_device *bdev, fmode_t mode);
 static void dcssblk_release(struct gendisk *disk, fmode_t mode);
 static void dcssblk_make_request(struct request_queue *q, struct bio *bio);
 static long dcssblk_direct_access(struct block_device *bdev, sector_t secnum,
-				 void **kaddr, unsigned long *pfn);
+		__pfn_t *pfn);
 
 static char dcssblk_segments[DCSSBLK_PARM_LEN] = "\0";
 
@@ -38,7 +38,9 @@ static const struct block_device_operations dcssblk_devops = {
 	.owner   	= THIS_MODULE,
 	.open    	= dcssblk_open,
 	.release 	= dcssblk_release,
+#ifdef HAVE_KMAP_PFN
 	.direct_access 	= dcssblk_direct_access,
+#endif
 };
 
 struct dcssblk_dev_info {
@@ -520,12 +522,18 @@ static const struct attribute_group *dcssblk_dev_attr_groups[] = {
 static ssize_t
 dcssblk_add_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
 {
+	struct resource *res = devm_kzalloc(dev, sizeof(*res), GFP_KERNEL);
 	int rc, i, j, num_of_segments;
 	struct dcssblk_dev_info *dev_info;
 	struct segment_info *seg_info, *temp;
 	char *local_buf;
 	unsigned long seg_byte_size;
 
+	if (!res) {
+		rc = -ENOMEM;
+		goto out_nobuf;
+	}
+
 	dev_info = NULL;
 	seg_info = NULL;
 	if (dev != dcssblk_root_dev) {
@@ -652,6 +660,13 @@ dcssblk_add_store(struct device *dev, struct device_attribute *attr, const char
 	if (rc)
 		goto put_dev;
 
+	res->start = dev_info->start;
+	res->end = dev_info->end - 1;
+	rc = devm_register_kmap_pfn_range(&dev_info->dev, res,
+			(void *) dev_info->start);
+	if (rc)
+		goto put_dev;
+
 	get_device(&dev_info->dev);
 	add_disk(dev_info->gd);
 
@@ -699,6 +714,8 @@ seg_list_del:
 out:
 	kfree(local_buf);
 out_nobuf:
+	if (res)
+		devm_kfree(dev, res);
 	return rc;
 }
 
@@ -877,9 +894,9 @@ fail:
 	bio_io_error(bio);
 }
 
-static long
+static __maybe_unused long
 dcssblk_direct_access (struct block_device *bdev, sector_t secnum,
-			void **kaddr, unsigned long *pfn)
+		__pfn_t *pfn)
 {
 	struct dcssblk_dev_info *dev_info;
 	unsigned long offset, dev_sz;
@@ -889,8 +906,7 @@ dcssblk_direct_access (struct block_device *bdev, sector_t secnum,
 		return -ENODEV;
 	dev_sz = dev_info->end - dev_info->start;
 	offset = secnum * 512;
-	*kaddr = (void *) (dev_info->start + offset);
-	*pfn = virt_to_phys(*kaddr) >> PAGE_SHIFT;
+	*pfn = phys_to_pfn_t(dev_info->start + offset);
 
 	return dev_sz - offset;
 }
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 19750f058495..0f05b33b924f 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -438,7 +438,7 @@ EXPORT_SYMBOL_GPL(bdev_write_page);
  * accessible at this address.
  */
 long bdev_direct_access(struct block_device *bdev, sector_t sector,
-			void **addr, unsigned long *pfn, long size)
+			__pfn_t *pfn, long size)
 {
 	long avail;
 	const struct block_device_operations *ops = bdev->bd_disk->fops;
@@ -453,7 +453,7 @@ long bdev_direct_access(struct block_device *bdev, sector_t sector,
 	sector += get_start_sect(bdev);
 	if (sector % (PAGE_SIZE / 512))
 		return -EINVAL;
-	avail = ops->direct_access(bdev, sector, addr, pfn);
+	avail = ops->direct_access(bdev, sector, pfn);
 	if (!avail)
 		return -ERANGE;
 	return min(avail, size);
diff --git a/fs/dax.c b/fs/dax.c
index 6f65f00e58ec..7d302bfff48a 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -35,13 +35,16 @@ int dax_clear_blocks(struct inode *inode, sector_t block, long size)
 	might_sleep();
 	do {
 		void *addr;
-		unsigned long pfn;
+		__pfn_t pfn;
 		long count;
 
-		count = bdev_direct_access(bdev, sector, &addr, &pfn, size);
+		count = bdev_direct_access(bdev, sector, &pfn, size);
 		if (count < 0)
 			return count;
 		BUG_ON(size < count);
+		addr = kmap_atomic_pfn_t(pfn);
+		if (!addr)
+			return -EIO;
 		while (count > 0) {
 			unsigned pgsz = PAGE_SIZE - offset_in_page(addr);
 			if (pgsz > count)
@@ -57,17 +60,17 @@ int dax_clear_blocks(struct inode *inode, sector_t block, long size)
 			sector += pgsz / 512;
 			cond_resched();
 		}
+		kunmap_atomic_pfn_t(addr);
 	} while (size);
 
 	return 0;
 }
 EXPORT_SYMBOL_GPL(dax_clear_blocks);
 
-static long dax_get_addr(struct buffer_head *bh, void **addr, unsigned blkbits)
+static long dax_get_pfn(struct buffer_head *bh, __pfn_t *pfn, unsigned blkbits)
 {
-	unsigned long pfn;
 	sector_t sector = bh->b_blocknr << (blkbits - 9);
-	return bdev_direct_access(bh->b_bdev, sector, addr, &pfn, bh->b_size);
+	return bdev_direct_access(bh->b_bdev, sector, pfn, bh->b_size);
 }
 
 static void dax_new_buf(void *addr, unsigned size, unsigned first, loff_t pos,
@@ -106,7 +109,8 @@ static ssize_t dax_io(struct inode *inode, struct iov_iter *iter,
 	loff_t pos = start;
 	loff_t max = start;
 	loff_t bh_max = start;
-	void *addr;
+	void *addr = NULL, *kmap = NULL;
+	__pfn_t pfn;
 	bool hole = false;
 
 	if (iov_iter_rw(iter) != WRITE)
@@ -142,9 +146,19 @@ static ssize_t dax_io(struct inode *inode, struct iov_iter *iter,
 				addr = NULL;
 				size = bh->b_size - first;
 			} else {
-				retval = dax_get_addr(bh, &addr, blkbits);
+				if (kmap) {
+					kunmap_atomic_pfn_t(kmap);
+					kmap = NULL;
+				}
+				retval = dax_get_pfn(bh, &pfn, blkbits);
 				if (retval < 0)
 					break;
+				kmap = kmap_atomic_pfn_t(pfn);
+				if (!kmap) {
+					retval = -EIO;
+					break;
+				}
+				addr = kmap;
 				if (buffer_unwritten(bh) || buffer_new(bh))
 					dax_new_buf(addr, retval, first, pos,
 									end);
@@ -168,6 +182,9 @@ static ssize_t dax_io(struct inode *inode, struct iov_iter *iter,
 		addr += len;
 	}
 
+	if (kmap)
+		kunmap_atomic_pfn_t(kmap);
+
 	return (pos == start) ? retval : pos - start;
 }
 
@@ -259,11 +276,17 @@ static int copy_user_bh(struct page *to, struct buffer_head *bh,
 			unsigned blkbits, unsigned long vaddr)
 {
 	void *vfrom, *vto;
-	if (dax_get_addr(bh, &vfrom, blkbits) < 0)
+	__pfn_t pfn;
+
+	if (dax_get_pfn(bh, &pfn, blkbits) < 0)
+		return -EIO;
+	vfrom = kmap_atomic_pfn_t(pfn);
+	if (!vfrom)
 		return -EIO;
 	vto = kmap_atomic(to);
 	copy_user_page(vto, vfrom, vaddr, to);
 	kunmap_atomic(vto);
+	kunmap_atomic_pfn_t(vfrom);
 	return 0;
 }
 
@@ -274,7 +297,7 @@ static int dax_insert_mapping(struct inode *inode, struct buffer_head *bh,
 	sector_t sector = bh->b_blocknr << (inode->i_blkbits - 9);
 	unsigned long vaddr = (unsigned long)vmf->virtual_address;
 	void *addr;
-	unsigned long pfn;
+	__pfn_t pfn;
 	pgoff_t size;
 	int error;
 
@@ -293,7 +316,7 @@ static int dax_insert_mapping(struct inode *inode, struct buffer_head *bh,
 		goto out;
 	}
 
-	error = bdev_direct_access(bh->b_bdev, sector, &addr, &pfn, bh->b_size);
+	error = bdev_direct_access(bh->b_bdev, sector, &pfn, bh->b_size);
 	if (error < 0)
 		goto out;
 	if (error < PAGE_SIZE) {
@@ -301,10 +324,17 @@ static int dax_insert_mapping(struct inode *inode, struct buffer_head *bh,
 		goto out;
 	}
 
-	if (buffer_unwritten(bh) || buffer_new(bh))
+	if (buffer_unwritten(bh) || buffer_new(bh)) {
+		addr = kmap_atomic_pfn_t(pfn);
+		if (!addr) {
+			error = -EIO;
+			goto out;
+		}
 		clear_page(addr);
+		kunmap_atomic_pfn_t(addr);
+	}
 
-	error = vm_insert_mixed(vma, vaddr, pfn);
+	error = vm_insert_mixed(vma, vaddr, __pfn_t_to_pfn(pfn));
 
  out:
 	i_mmap_unlock_read(mapping);
@@ -517,10 +547,16 @@ int dax_zero_page_range(struct inode *inode, loff_t from, unsigned length,
 		return err;
 	if (buffer_written(&bh)) {
 		void *addr;
-		err = dax_get_addr(&bh, &addr, inode->i_blkbits);
+		__pfn_t pfn;
+
+		err = dax_get_pfn(&bh, &pfn, inode->i_blkbits);
 		if (err < 0)
 			return err;
+		addr = kmap_atomic_pfn_t(pfn);
+		if (!addr)
+			return -EIO;
 		memset(addr + offset, 0, length);
+		kunmap_atomic_pfn_t(addr);
 	}
 
 	return 0;
diff --git a/include/asm-generic/pfn.h b/include/asm-generic/pfn.h
index 2f4ae40dc6a7..e9fed20d606a 100644
--- a/include/asm-generic/pfn.h
+++ b/include/asm-generic/pfn.h
@@ -49,7 +49,32 @@ static inline bool __pfn_t_has_page(__pfn_t pfn)
 	return (pfn.data & PFN_MASK) == 0;
 }
 
+static inline __pfn_t pfn_to_pfn_t(unsigned long pfn)
+{
+	__pfn_t pfn_t = { .data = (pfn << PFN_SHIFT) | PFN_DEV };
+
+	return pfn_t;
+}
+
+static inline __pfn_t phys_to_pfn_t(dma_addr_t addr)
+{
+	return pfn_to_pfn_t(addr >> PAGE_SHIFT);
+}
 #else
+static inline __pfn_t phys_to_pfn_t(dma_addr_t addr)
+{
+	__pfn_t pfn_t = { .data = 0 };
+
+	/*
+	 * With CONFIG_DEV_PFN=n the kernel expects every __pfn_t to
+	 * have a corresponding entry in the kernel linear address map
+	 * (struct page).
+	 */
+	BUG();
+
+	return pfn_t;
+}
+
 static inline bool __pfn_t_has_page(__pfn_t pfn)
 {
 	return true;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 535b82f790a6..35e404d598b2 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1552,8 +1552,7 @@ struct block_device_operations {
 	int (*rw_page)(struct block_device *, sector_t, struct page *, int rw);
 	int (*ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
 	int (*compat_ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
-	long (*direct_access)(struct block_device *, sector_t,
-					void **, unsigned long *pfn);
+	long (*direct_access)(struct block_device *, sector_t, __pfn_t *pfn);
 	unsigned int (*check_events) (struct gendisk *disk,
 				      unsigned int clearing);
 	/* ->media_changed() is DEPRECATED, use ->check_events() instead */
@@ -1571,8 +1570,8 @@ extern int __blkdev_driver_ioctl(struct block_device *, fmode_t, unsigned int,
 extern int bdev_read_page(struct block_device *, sector_t, struct page *);
 extern int bdev_write_page(struct block_device *, sector_t, struct page *,
 						struct writeback_control *);
-extern long bdev_direct_access(struct block_device *, sector_t, void **addr,
-						unsigned long *pfn, long size);
+extern long bdev_direct_access(struct block_device *, sector_t,
+		__pfn_t *pfn, long size);
 #else /* CONFIG_BLOCK */
 
 struct block_device;

