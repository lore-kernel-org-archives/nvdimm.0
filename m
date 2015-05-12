Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Subject: [PATCH v3 10/11] dax: convert to __pfn_t
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 12 May 2015 00:30:23 -0400
Message-ID: <20150512043022.11521.85490.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150512042629.11521.70356.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150512042629.11521.70356.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, Boaz Harrosh <boaz@plexistor.com>, riel@redhat.com, akpm@linux-foundation.org, j.glisse@gmail.com, linux-nvdimm@lists.01.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, hch@lst.de, linux-fsdevel@vger.kernel.org, Paul Mackerras <paulus@samba.org>, mgorman@suse.de, david@fromorbit.com, linux-arch@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, mingo@kernel.org
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
 arch/powerpc/sysdev/axonram.c |   11 +++++--
 drivers/block/brd.c           |    5 +--
 drivers/block/pmem.c          |   11 +++++--
 drivers/s390/block/dcssblk.c  |   13 ++++++---
 fs/block_dev.c                |    4 +--
 fs/dax.c                      |   62 ++++++++++++++++++++++++++++++++---------
 include/asm-generic/pfn.h     |   11 +++++++
 include/linux/blkdev.h        |    7 ++---
 8 files changed, 91 insertions(+), 33 deletions(-)

diff --git a/arch/powerpc/sysdev/axonram.c b/arch/powerpc/sysdev/axonram.c
index 9bb5da7f2c0c..91c40a300797 100644
--- a/arch/powerpc/sysdev/axonram.c
+++ b/arch/powerpc/sysdev/axonram.c
@@ -139,22 +139,27 @@ axon_ram_make_request(struct request_queue *queue, struct bio *bio)
  * axon_ram_direct_access - direct_access() method for block device
  * @device, @sector, @data: see block_device_operations method
  */
+#ifdef CONFIG_DEV_PFN
 static long
 axon_ram_direct_access(struct block_device *device, sector_t sector,
-		       void **kaddr, unsigned long *pfn, long size)
+		__pfn_t *pfn, long size)
 {
 	struct axon_ram_bank *bank = device->bd_disk->private_data;
 	loff_t offset = (loff_t)sector << AXON_RAM_SECTOR_SHIFT;
+	void *kaddr;
 
-	*kaddr = (void *)(bank->ph_addr + offset);
-	*pfn = virt_to_phys(*kaddr) >> PAGE_SHIFT;
+	kaddr = (void *)(bank->ph_addr + offset);
+	*pfn = phys_to_pfn_t(virt_to_phys(*kaddr));
 
 	return bank->size - offset;
 }
+#endif
 
 static const struct block_device_operations axon_ram_devops = {
 	.owner		= THIS_MODULE,
+#ifdef CONFIG_DEV_PFN
 	.direct_access	= axon_ram_direct_access
+#endif
 };
 
 /**
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 115c6cf9cb43..3be31a2aed20 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -371,7 +371,7 @@ static int brd_rw_page(struct block_device *bdev, sector_t sector,
 
 #ifdef CONFIG_BLK_DEV_RAM_DAX
 static long brd_direct_access(struct block_device *bdev, sector_t sector,
-			void **kaddr, unsigned long *pfn, long size)
+		__pfn_t *pfn, long size)
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
 
 	/*
 	 * TODO: If size > PAGE_SIZE, we could look to see if the next page in
diff --git a/drivers/block/pmem.c b/drivers/block/pmem.c
index 2a847651f8de..0cf34fba308c 100644
--- a/drivers/block/pmem.c
+++ b/drivers/block/pmem.c
@@ -98,8 +98,9 @@ static int pmem_rw_page(struct block_device *bdev, sector_t sector,
 	return 0;
 }
 
-static long pmem_direct_access(struct block_device *bdev, sector_t sector,
-			      void **kaddr, unsigned long *pfn, long size)
+#ifdef CONFIG_DEV_PFN
+static long pmem_direct_access(struct block_device *bdev,
+		sector_t sector, __pfn_t *pfn, long size)
 {
 	struct pmem_device *pmem = bdev->bd_disk->private_data;
 	size_t offset = sector << 9;
@@ -107,16 +108,18 @@ static long pmem_direct_access(struct block_device *bdev, sector_t sector,
 	if (!pmem)
 		return -ENODEV;
 
-	*kaddr = pmem->virt_addr + offset;
-	*pfn = (pmem->phys_addr + offset) >> PAGE_SHIFT;
+	*pfn = phys_to_pfn_t(pmem->phys_addr + offset);
 
 	return pmem->size - offset;
 }
+#endif
 
 static const struct block_device_operations pmem_fops = {
 	.owner =		THIS_MODULE,
 	.rw_page =		pmem_rw_page,
+#ifdef CONFIG_DEV_PFN
 	.direct_access =	pmem_direct_access,
+#endif
 };
 
 static struct pmem_device *pmem_alloc(struct device *dev, struct resource *res)
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index 5da8515b8fb9..41031e715152 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -29,7 +29,7 @@ static int dcssblk_open(struct block_device *bdev, fmode_t mode);
 static void dcssblk_release(struct gendisk *disk, fmode_t mode);
 static void dcssblk_make_request(struct request_queue *q, struct bio *bio);
 static long dcssblk_direct_access(struct block_device *bdev, sector_t secnum,
-				 void **kaddr, unsigned long *pfn, long size);
+		__pfn_t *pfn, long size);
 
 static char dcssblk_segments[DCSSBLK_PARM_LEN] = "\0";
 
@@ -38,7 +38,9 @@ static const struct block_device_operations dcssblk_devops = {
 	.owner   	= THIS_MODULE,
 	.open    	= dcssblk_open,
 	.release 	= dcssblk_release,
+#ifdef CONFIG_DEV_PFN
 	.direct_access 	= dcssblk_direct_access,
+#endif
 };
 
 struct dcssblk_dev_info {
@@ -877,23 +879,26 @@ fail:
 	bio_io_error(bio);
 }
 
+#ifdef CONFIG_DEV_PFN
 static long
 dcssblk_direct_access (struct block_device *bdev, sector_t secnum,
-			void **kaddr, unsigned long *pfn, long size)
+		__pfn_t *pfn, long size)
 {
 	struct dcssblk_dev_info *dev_info;
 	unsigned long offset, dev_sz;
+	void *kaddr;
 
 	dev_info = bdev->bd_disk->private_data;
 	if (!dev_info)
 		return -ENODEV;
 	dev_sz = dev_info->end - dev_info->start;
 	offset = secnum * 512;
-	*kaddr = (void *) (dev_info->start + offset);
-	*pfn = virt_to_phys(*kaddr) >> PAGE_SHIFT;
+	kaddr = (void *) (dev_info->start + offset);
+	*pfn = phys_to_pfn_t(virt_to_phys(*kaddr));
 
 	return dev_sz - offset;
 }
+#endif
 
 static void
 dcssblk_check_params(void)
diff --git a/fs/block_dev.c b/fs/block_dev.c
index c7e4163ede87..100749b51524 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -437,7 +437,7 @@ EXPORT_SYMBOL_GPL(bdev_write_page);
  * accessible at this address.
  */
 long bdev_direct_access(struct block_device *bdev, sector_t sector,
-			void **addr, unsigned long *pfn, long size)
+			__pfn_t *pfn, long size)
 {
 	long avail;
 	const struct block_device_operations *ops = bdev->bd_disk->fops;
@@ -452,7 +452,7 @@ long bdev_direct_access(struct block_device *bdev, sector_t sector,
 	sector += get_start_sect(bdev);
 	if (sector % (PAGE_SIZE / 512))
 		return -EINVAL;
-	avail = ops->direct_access(bdev, sector, addr, pfn, size);
+	avail = ops->direct_access(bdev, sector, pfn, size);
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
index ee1363e3c67c..78ec84282334 100644
--- a/include/asm-generic/pfn.h
+++ b/include/asm-generic/pfn.h
@@ -47,6 +47,17 @@ static inline bool __pfn_t_has_page(__pfn_t pfn)
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
 static inline bool __pfn_t_has_page(__pfn_t pfn)
 {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 7f9a516f24de..42bcaf2b9311 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1604,8 +1604,7 @@ struct block_device_operations {
 	int (*rw_page)(struct block_device *, sector_t, struct page *, int rw);
 	int (*ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
 	int (*compat_ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
-	long (*direct_access)(struct block_device *, sector_t,
-					void **, unsigned long *pfn, long size);
+	long (*direct_access)(struct block_device *, sector_t, __pfn_t *pfn, long size);
 	unsigned int (*check_events) (struct gendisk *disk,
 				      unsigned int clearing);
 	/* ->media_changed() is DEPRECATED, use ->check_events() instead */
@@ -1623,8 +1622,8 @@ extern int __blkdev_driver_ioctl(struct block_device *, fmode_t, unsigned int,
 extern int bdev_read_page(struct block_device *, sector_t, struct page *);
 extern int bdev_write_page(struct block_device *, sector_t, struct page *,
 						struct writeback_control *);
-extern long bdev_direct_access(struct block_device *, sector_t, void **addr,
-						unsigned long *pfn, long size);
+extern long bdev_direct_access(struct block_device *, sector_t,
+		__pfn_t *pfn, long size);
 #else /* CONFIG_BLOCK */
 
 struct block_device;

