Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Subject: [PATCH v2 09/10] dax: convert to __pfn_t
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 06 May 2015 16:05:44 -0400
Message-ID: <20150506200544.40425.62413.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150506200219.40425.74411.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150506200219.40425.74411.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, Boaz Harrosh <boaz@plexistor.com>, riel@redhat.com, akpm@linux-foundation.org, linux-nvdimm@lists.01.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, mingo@kernel.org, linux-fsdevel@vger.kernel.org, Paul Mackerras <paulus@samba.org>, mgorman@suse.de, Martin Schwidefsky <schwidefsky@de.ibm.com>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

The primary source for non-page-backed page-frames to enter the system
is via the pmem driver's ->direct_access() method.  The pfns returned by
the top-level bdev_direct_access() may be passed to any other subsystem
in the kernel and those sub-systems either need to assume that the pfn
is page backed (CONFIG_PMEM_IO=n) or be prepared to handle non-page
backed case (CONFIG_PMEM_IO=y).  Currently the pfns returned by
->direct_access() are only ever used by vm_insert_mixed() which does not
care if the pfn is mapped.  As we go to add more usages of these pfns
add the type-safety of __pfn_t.

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
 arch/powerpc/sysdev/axonram.c |    4 ++--
 drivers/block/brd.c           |    4 ++--
 drivers/block/pmem.c          |    8 +++++---
 drivers/s390/block/dcssblk.c  |    6 +++---
 fs/block_dev.c                |    2 +-
 fs/dax.c                      |    9 +++++----
 include/asm-generic/pfn.h     |    7 +++++++
 include/linux/blkdev.h        |    4 ++--
 8 files changed, 27 insertions(+), 17 deletions(-)

diff --git a/arch/powerpc/sysdev/axonram.c b/arch/powerpc/sysdev/axonram.c
index 9bb5da7f2c0c..069cb5285f18 100644
--- a/arch/powerpc/sysdev/axonram.c
+++ b/arch/powerpc/sysdev/axonram.c
@@ -141,13 +141,13 @@ axon_ram_make_request(struct request_queue *queue, struct bio *bio)
  */
 static long
 axon_ram_direct_access(struct block_device *device, sector_t sector,
-		       void **kaddr, unsigned long *pfn, long size)
+		       void **kaddr, __pfn_t *pfn, long size)
 {
 	struct axon_ram_bank *bank = device->bd_disk->private_data;
 	loff_t offset = (loff_t)sector << AXON_RAM_SECTOR_SHIFT;
 
 	*kaddr = (void *)(bank->ph_addr + offset);
-	*pfn = virt_to_phys(*kaddr) >> PAGE_SHIFT;
+	*pfn = phys_to_pfn_t(virt_to_phys(*kaddr));
 
 	return bank->size - offset;
 }
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 115c6cf9cb43..57f4cd787ea2 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -371,7 +371,7 @@ static int brd_rw_page(struct block_device *bdev, sector_t sector,
 
 #ifdef CONFIG_BLK_DEV_RAM_DAX
 static long brd_direct_access(struct block_device *bdev, sector_t sector,
-			void **kaddr, unsigned long *pfn, long size)
+			void **kaddr, __pfn_t *pfn, long size)
 {
 	struct brd_device *brd = bdev->bd_disk->private_data;
 	struct page *page;
@@ -382,7 +382,7 @@ static long brd_direct_access(struct block_device *bdev, sector_t sector,
 	if (!page)
 		return -ENOSPC;
 	*kaddr = page_address(page);
-	*pfn = page_to_pfn(page);
+	*pfn = page_to_pfn_t(page);
 
 	/*
 	 * TODO: If size > PAGE_SIZE, we could look to see if the next page in
diff --git a/drivers/block/pmem.c b/drivers/block/pmem.c
index 2a847651f8de..18edb48e405e 100644
--- a/drivers/block/pmem.c
+++ b/drivers/block/pmem.c
@@ -98,8 +98,8 @@ static int pmem_rw_page(struct block_device *bdev, sector_t sector,
 	return 0;
 }
 
-static long pmem_direct_access(struct block_device *bdev, sector_t sector,
-			      void **kaddr, unsigned long *pfn, long size)
+static long __maybe_unused pmem_direct_access(struct block_device *bdev,
+		sector_t sector, void **kaddr, __pfn_t *pfn, long size)
 {
 	struct pmem_device *pmem = bdev->bd_disk->private_data;
 	size_t offset = sector << 9;
@@ -108,7 +108,7 @@ static long pmem_direct_access(struct block_device *bdev, sector_t sector,
 		return -ENODEV;
 
 	*kaddr = pmem->virt_addr + offset;
-	*pfn = (pmem->phys_addr + offset) >> PAGE_SHIFT;
+	*pfn = phys_to_pfn_t(pmem->phys_addr + offset);
 
 	return pmem->size - offset;
 }
@@ -116,7 +116,9 @@ static long pmem_direct_access(struct block_device *bdev, sector_t sector,
 static const struct block_device_operations pmem_fops = {
 	.owner =		THIS_MODULE,
 	.rw_page =		pmem_rw_page,
+#if IS_ENABLED(CONFIG_PMEM_IO)
 	.direct_access =	pmem_direct_access,
+#endif
 };
 
 static struct pmem_device *pmem_alloc(struct device *dev, struct resource *res)
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index 5da8515b8fb9..8616c1d33786 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -29,7 +29,7 @@ static int dcssblk_open(struct block_device *bdev, fmode_t mode);
 static void dcssblk_release(struct gendisk *disk, fmode_t mode);
 static void dcssblk_make_request(struct request_queue *q, struct bio *bio);
 static long dcssblk_direct_access(struct block_device *bdev, sector_t secnum,
-				 void **kaddr, unsigned long *pfn, long size);
+				 void **kaddr, __pfn_t *pfn, long size);
 
 static char dcssblk_segments[DCSSBLK_PARM_LEN] = "\0";
 
@@ -879,7 +879,7 @@ fail:
 
 static long
 dcssblk_direct_access (struct block_device *bdev, sector_t secnum,
-			void **kaddr, unsigned long *pfn, long size)
+			void **kaddr, __pfn_t *pfn, long size)
 {
 	struct dcssblk_dev_info *dev_info;
 	unsigned long offset, dev_sz;
@@ -890,7 +890,7 @@ dcssblk_direct_access (struct block_device *bdev, sector_t secnum,
 	dev_sz = dev_info->end - dev_info->start;
 	offset = secnum * 512;
 	*kaddr = (void *) (dev_info->start + offset);
-	*pfn = virt_to_phys(*kaddr) >> PAGE_SHIFT;
+	*pfn = phys_to_pfn_t(virt_to_phys(*kaddr));
 
 	return dev_sz - offset;
 }
diff --git a/fs/block_dev.c b/fs/block_dev.c
index c7e4163ede87..7285c31f7e30 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -437,7 +437,7 @@ EXPORT_SYMBOL_GPL(bdev_write_page);
  * accessible at this address.
  */
 long bdev_direct_access(struct block_device *bdev, sector_t sector,
-			void **addr, unsigned long *pfn, long size)
+			void **addr, __pfn_t *pfn, long size)
 {
 	long avail;
 	const struct block_device_operations *ops = bdev->bd_disk->fops;
diff --git a/fs/dax.c b/fs/dax.c
index 6f65f00e58ec..198bd0e4b5ae 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -35,7 +35,7 @@ int dax_clear_blocks(struct inode *inode, sector_t block, long size)
 	might_sleep();
 	do {
 		void *addr;
-		unsigned long pfn;
+		__pfn_t pfn;
 		long count;
 
 		count = bdev_direct_access(bdev, sector, &addr, &pfn, size);
@@ -65,7 +65,8 @@ EXPORT_SYMBOL_GPL(dax_clear_blocks);
 
 static long dax_get_addr(struct buffer_head *bh, void **addr, unsigned blkbits)
 {
-	unsigned long pfn;
+	__pfn_t pfn;
+
 	sector_t sector = bh->b_blocknr << (blkbits - 9);
 	return bdev_direct_access(bh->b_bdev, sector, addr, &pfn, bh->b_size);
 }
@@ -274,7 +275,7 @@ static int dax_insert_mapping(struct inode *inode, struct buffer_head *bh,
 	sector_t sector = bh->b_blocknr << (inode->i_blkbits - 9);
 	unsigned long vaddr = (unsigned long)vmf->virtual_address;
 	void *addr;
-	unsigned long pfn;
+	__pfn_t pfn;
 	pgoff_t size;
 	int error;
 
@@ -304,7 +305,7 @@ static int dax_insert_mapping(struct inode *inode, struct buffer_head *bh,
 	if (buffer_unwritten(bh) || buffer_new(bh))
 		clear_page(addr);
 
-	error = vm_insert_mixed(vma, vaddr, pfn);
+	error = vm_insert_mixed(vma, vaddr, __pfn_t_to_pfn(pfn));
 
  out:
 	i_mmap_unlock_read(mapping);
diff --git a/include/asm-generic/pfn.h b/include/asm-generic/pfn.h
index c1fdf41fb726..af219dc96792 100644
--- a/include/asm-generic/pfn.h
+++ b/include/asm-generic/pfn.h
@@ -49,6 +49,13 @@ static inline __pfn_t page_to_pfn_t(struct page *page)
 	return pfn;
 }
 
+static inline __pfn_t phys_to_pfn_t(phys_addr_t addr)
+{
+	__pfn_t pfn = { .pfn = addr >> PAGE_SHIFT };
+
+	return pfn;
+}
+
 static inline unsigned long __pfn_t_to_pfn(__pfn_t pfn)
 {
 #if IS_ENABLED(CONFIG_PMEM_IO)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 7f9a516f24de..2692d3936f5f 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1605,7 +1605,7 @@ struct block_device_operations {
 	int (*ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
 	int (*compat_ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
 	long (*direct_access)(struct block_device *, sector_t,
-					void **, unsigned long *pfn, long size);
+					void **, __pfn_t *pfn, long size);
 	unsigned int (*check_events) (struct gendisk *disk,
 				      unsigned int clearing);
 	/* ->media_changed() is DEPRECATED, use ->check_events() instead */
@@ -1624,7 +1624,7 @@ extern int bdev_read_page(struct block_device *, sector_t, struct page *);
 extern int bdev_write_page(struct block_device *, sector_t, struct page *,
 						struct writeback_control *);
 extern long bdev_direct_access(struct block_device *, sector_t, void **addr,
-						unsigned long *pfn, long size);
+						__pfn_t *pfn, long size);
 #else /* CONFIG_BLOCK */
 
 struct block_device;

