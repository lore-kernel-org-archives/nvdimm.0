Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v5 7/7] pmem, dax: have direct_access use __pmem annotation
Date: Tue, 18 Aug 2015 13:55:41 -0600
Message-Id: <1439927741-29580-8-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1439927741-29580-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1439927741-29580-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, Dan Williams <dan.j.williams@intel.com>, Christoph Hellwig <hch@lst.de>, Matthew Wilcox <matthew.r.wilcox@intel.com>, Dave Chinner <david@fromorbit.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, Alexander Viro <viro@zeniv.linux.org.uk>, Ameen Ali <ameenali023@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Boaz Harrosh <boaz@plexistor.com>, Gerald Schaefer <gerald.schaefer@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@primarydata.com>, Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Matthew Wilcox <willy@linux.intel.com>, Michael Ellerman <mpe@ellerman.id.au>, Mike Snitzer <snitzer@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>, Ming Lei <ming.lei@canonical.com>, Omar Sandoval <osandov@osandov.com>, Paul Mackerras <paulus@samba.org>, Sagi Grimberg <sagig@mellanox.com>, Shaohua Li <shli@fb.com>, Tejun Heo <tj@kernel.org>, Wolfram Sang <wsa@the-dreams.de>, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-s390@vger.kernel.org, linux390@de.ibm.com, linuxppc-dev@lists.ozlabs.org
List-ID: <linux-nvdimm@lists.01.org>

Update the annotation for the kaddr pointer returned by direct_access()
so that it is a __pmem pointer.  This is consistent with the PMEM driver
and with how this direct_access() pointer is used in the DAX code.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/filesystems/Locking |  3 ++-
 arch/powerpc/sysdev/axonram.c     |  7 ++++---
 drivers/block/brd.c               |  4 ++--
 drivers/nvdimm/pmem.c             |  4 ++--
 drivers/s390/block/dcssblk.c      | 10 ++++++----
 fs/block_dev.c                    |  2 +-
 fs/dax.c                          | 37 ++++++++++++++++++++-----------------
 include/linux/blkdev.h            |  8 ++++----
 8 files changed, 41 insertions(+), 34 deletions(-)

diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index 6a34a0f..06d4434 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -397,7 +397,8 @@ prototypes:
 	int (*release) (struct gendisk *, fmode_t);
 	int (*ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
 	int (*compat_ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
-	int (*direct_access) (struct block_device *, sector_t, void **, unsigned long *);
+	int (*direct_access) (struct block_device *, sector_t, void __pmem **,
+				unsigned long *);
 	int (*media_changed) (struct gendisk *);
 	void (*unlock_native_capacity) (struct gendisk *);
 	int (*revalidate_disk) (struct gendisk *);
diff --git a/arch/powerpc/sysdev/axonram.c b/arch/powerpc/sysdev/axonram.c
index ee90db1..a2be2a6 100644
--- a/arch/powerpc/sysdev/axonram.c
+++ b/arch/powerpc/sysdev/axonram.c
@@ -141,13 +141,14 @@ axon_ram_make_request(struct request_queue *queue, struct bio *bio)
  */
 static long
 axon_ram_direct_access(struct block_device *device, sector_t sector,
-		       void **kaddr, unsigned long *pfn, long size)
+		       void __pmem **kaddr, unsigned long *pfn, long size)
 {
 	struct axon_ram_bank *bank = device->bd_disk->private_data;
 	loff_t offset = (loff_t)sector << AXON_RAM_SECTOR_SHIFT;
+	void *addr = (void *)(bank->ph_addr + offset);
 
-	*kaddr = (void *)(bank->ph_addr + offset);
-	*pfn = virt_to_phys(*kaddr) >> PAGE_SHIFT;
+	*kaddr = (void __pmem *)addr;
+	*pfn = virt_to_phys(addr) >> PAGE_SHIFT;
 
 	return bank->size - offset;
 }
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 5750b39..2691bb6 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -371,7 +371,7 @@ static int brd_rw_page(struct block_device *bdev, sector_t sector,
 
 #ifdef CONFIG_BLK_DEV_RAM_DAX
 static long brd_direct_access(struct block_device *bdev, sector_t sector,
-			void **kaddr, unsigned long *pfn, long size)
+			void __pmem **kaddr, unsigned long *pfn, long size)
 {
 	struct brd_device *brd = bdev->bd_disk->private_data;
 	struct page *page;
@@ -381,7 +381,7 @@ static long brd_direct_access(struct block_device *bdev, sector_t sector,
 	page = brd_insert_page(brd, sector);
 	if (!page)
 		return -ENOSPC;
-	*kaddr = page_address(page);
+	*kaddr = (void __pmem *)page_address(page);
 	*pfn = page_to_pfn(page);
 
 	/*
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index eb7552d..f3b6297 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -92,7 +92,7 @@ static int pmem_rw_page(struct block_device *bdev, sector_t sector,
 }
 
 static long pmem_direct_access(struct block_device *bdev, sector_t sector,
-			      void **kaddr, unsigned long *pfn, long size)
+		      void __pmem **kaddr, unsigned long *pfn, long size)
 {
 	struct pmem_device *pmem = bdev->bd_disk->private_data;
 	size_t offset = sector << 9;
@@ -101,7 +101,7 @@ static long pmem_direct_access(struct block_device *bdev, sector_t sector,
 		return -ENODEV;
 
 	/* FIXME convert DAX to comprehend that this mapping has a lifetime */
-	*kaddr = (void __force *) pmem->virt_addr + offset;
+	*kaddr = pmem->virt_addr + offset;
 	*pfn = (pmem->phys_addr + offset) >> PAGE_SHIFT;
 
 	return pmem->size - offset;
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index da21281..2c5a397 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -29,7 +29,7 @@ static int dcssblk_open(struct block_device *bdev, fmode_t mode);
 static void dcssblk_release(struct gendisk *disk, fmode_t mode);
 static void dcssblk_make_request(struct request_queue *q, struct bio *bio);
 static long dcssblk_direct_access(struct block_device *bdev, sector_t secnum,
-				 void **kaddr, unsigned long *pfn, long size);
+			 void __pmem **kaddr, unsigned long *pfn, long size);
 
 static char dcssblk_segments[DCSSBLK_PARM_LEN] = "\0";
 
@@ -879,18 +879,20 @@ fail:
 
 static long
 dcssblk_direct_access (struct block_device *bdev, sector_t secnum,
-			void **kaddr, unsigned long *pfn, long size)
+			void __pmem **kaddr, unsigned long *pfn, long size)
 {
 	struct dcssblk_dev_info *dev_info;
 	unsigned long offset, dev_sz;
+	void *addr;
 
 	dev_info = bdev->bd_disk->private_data;
 	if (!dev_info)
 		return -ENODEV;
 	dev_sz = dev_info->end - dev_info->start;
 	offset = secnum * 512;
-	*kaddr = (void *) (dev_info->start + offset);
-	*pfn = virt_to_phys(*kaddr) >> PAGE_SHIFT;
+	addr = (void *) (dev_info->start + offset);
+	*pfn = virt_to_phys(addr) >> PAGE_SHIFT;
+	*kaddr = (void __pmem *) addr;
 
 	return dev_sz - offset;
 }
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 1982437..2345a98 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -441,7 +441,7 @@ EXPORT_SYMBOL_GPL(bdev_write_page);
  * accessible at this address.
  */
 long bdev_direct_access(struct block_device *bdev, sector_t sector,
-			void **addr, unsigned long *pfn, long size)
+			void __pmem **addr, unsigned long *pfn, long size)
 {
 	long avail;
 	const struct block_device_operations *ops = bdev->bd_disk->fops;
diff --git a/fs/dax.c b/fs/dax.c
index cb02a61..57e8867 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -36,7 +36,7 @@ int dax_clear_blocks(struct inode *inode, sector_t block, long size)
 
 	might_sleep();
 	do {
-		void *addr;
+		void __pmem *addr;
 		unsigned long pfn;
 		long count;
 
@@ -48,7 +48,7 @@ int dax_clear_blocks(struct inode *inode, sector_t block, long size)
 			unsigned pgsz = PAGE_SIZE - offset_in_page(addr);
 			if (pgsz > count)
 				pgsz = count;
-			clear_pmem((void __pmem *)addr, pgsz);
+			clear_pmem(addr, pgsz);
 			addr += pgsz;
 			size -= pgsz;
 			count -= pgsz;
@@ -63,7 +63,8 @@ int dax_clear_blocks(struct inode *inode, sector_t block, long size)
 }
 EXPORT_SYMBOL_GPL(dax_clear_blocks);
 
-static long dax_get_addr(struct buffer_head *bh, void **addr, unsigned blkbits)
+static long dax_get_addr(struct buffer_head *bh, void __pmem **addr,
+		unsigned blkbits)
 {
 	unsigned long pfn;
 	sector_t sector = bh->b_blocknr << (blkbits - 9);
@@ -71,15 +72,15 @@ static long dax_get_addr(struct buffer_head *bh, void **addr, unsigned blkbits)
 }
 
 /* the clear_pmem() calls are ordered by a wmb_pmem() in the caller */
-static void dax_new_buf(void *addr, unsigned size, unsigned first, loff_t pos,
-			loff_t end)
+static void dax_new_buf(void __pmem *addr, unsigned size, unsigned first,
+		loff_t pos, loff_t end)
 {
 	loff_t final = end - pos + first; /* The final byte of the buffer */
 
 	if (first > 0)
-		clear_pmem((void __pmem *)addr, first);
+		clear_pmem(addr, first);
 	if (final < size)
-		clear_pmem((void __pmem *)addr + final, size - final);
+		clear_pmem(addr + final, size - final);
 }
 
 static bool buffer_written(struct buffer_head *bh)
@@ -107,7 +108,7 @@ static ssize_t dax_io(struct inode *inode, struct iov_iter *iter,
 	loff_t pos = start;
 	loff_t max = start;
 	loff_t bh_max = start;
-	void *addr;
+	void __pmem *addr;
 	bool hole = false;
 	bool need_wmb = false;
 
@@ -159,11 +160,11 @@ static ssize_t dax_io(struct inode *inode, struct iov_iter *iter,
 		}
 
 		if (iov_iter_rw(iter) == WRITE) {
-			len = copy_from_iter_pmem((void __pmem *)addr,
-					max - pos, iter);
+			len = copy_from_iter_pmem(addr, max - pos, iter);
 			need_wmb = true;
 		} else if (!hole)
-			len = copy_to_iter(addr, max - pos, iter);
+			len = copy_to_iter((void __force *)addr, max - pos,
+					iter);
 		else
 			len = iov_iter_zero(max - pos, iter);
 
@@ -269,11 +270,13 @@ static int dax_load_hole(struct address_space *mapping, struct page *page,
 static int copy_user_bh(struct page *to, struct buffer_head *bh,
 			unsigned blkbits, unsigned long vaddr)
 {
-	void *vfrom, *vto;
+	void __pmem *vfrom;
+	void *vto;
+
 	if (dax_get_addr(bh, &vfrom, blkbits) < 0)
 		return -EIO;
 	vto = kmap_atomic(to);
-	copy_user_page(vto, vfrom, vaddr, to);
+	copy_user_page(vto, (void __force *)vfrom, vaddr, to);
 	kunmap_atomic(vto);
 	return 0;
 }
@@ -284,7 +287,7 @@ static int dax_insert_mapping(struct inode *inode, struct buffer_head *bh,
 	struct address_space *mapping = inode->i_mapping;
 	sector_t sector = bh->b_blocknr << (inode->i_blkbits - 9);
 	unsigned long vaddr = (unsigned long)vmf->virtual_address;
-	void *addr;
+	void __pmem *addr;
 	unsigned long pfn;
 	pgoff_t size;
 	int error;
@@ -313,7 +316,7 @@ static int dax_insert_mapping(struct inode *inode, struct buffer_head *bh,
 	}
 
 	if (buffer_unwritten(bh) || buffer_new(bh)) {
-		clear_pmem((void __pmem *)addr, PAGE_SIZE);
+		clear_pmem(addr, PAGE_SIZE);
 		wmb_pmem();
 	}
 
@@ -549,11 +552,11 @@ int dax_zero_page_range(struct inode *inode, loff_t from, unsigned length,
 	if (err < 0)
 		return err;
 	if (buffer_written(&bh)) {
-		void *addr;
+		void __pmem *addr;
 		err = dax_get_addr(&bh, &addr, inode->i_blkbits);
 		if (err < 0)
 			return err;
-		clear_pmem((void __pmem *)addr + offset, length);
+		clear_pmem(addr + offset, length);
 		wmb_pmem();
 	}
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d4068c1..c401ecd 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1555,8 +1555,8 @@ struct block_device_operations {
 	int (*rw_page)(struct block_device *, sector_t, struct page *, int rw);
 	int (*ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
 	int (*compat_ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
-	long (*direct_access)(struct block_device *, sector_t,
-					void **, unsigned long *pfn, long size);
+	long (*direct_access)(struct block_device *, sector_t, void __pmem **,
+			unsigned long *pfn, long size);
 	unsigned int (*check_events) (struct gendisk *disk,
 				      unsigned int clearing);
 	/* ->media_changed() is DEPRECATED, use ->check_events() instead */
@@ -1574,8 +1574,8 @@ extern int __blkdev_driver_ioctl(struct block_device *, fmode_t, unsigned int,
 extern int bdev_read_page(struct block_device *, sector_t, struct page *);
 extern int bdev_write_page(struct block_device *, sector_t, struct page *,
 						struct writeback_control *);
-extern long bdev_direct_access(struct block_device *, sector_t, void **addr,
-						unsigned long *pfn, long size);
+extern long bdev_direct_access(struct block_device *, sector_t,
+		void __pmem **addr, unsigned long *pfn, long size);
 #else /* CONFIG_BLOCK */
 
 struct block_device;
-- 
2.1.0

