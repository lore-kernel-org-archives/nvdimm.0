Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by ml01.01.org (Postfix) with ESMTP id 01CF11A1E10
 for <linux-nvdimm@lists.01.org>; Sat,  9 Jul 2016 20:28:54 -0700 (PDT)
Subject: [PATCH v2 17/17] pmem: kill __pmem address space
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 09 Jul 2016 20:25:59 -0700
Message-ID: <146812115987.32932.7318474941946627247.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146812106839.32932.2870621200867047059.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146812106839.32932.2870621200867047059.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-fsdevel@vger.kernel.org, linux-acpi@vger.kernel.org, hch@lst.de, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The __pmem address space was meant to annotate codepaths that touch
persistent memory and need to coordinate a call to wmb_pmem().  Now that
wmb_pmem() is gone, there is little need to keep this annotation.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/filesystems/Locking |    2 +
 arch/powerpc/sysdev/axonram.c     |    4 +-
 arch/x86/include/asm/pmem.h       |   41 +++++++++-------------
 drivers/acpi/nfit.h               |    2 +
 drivers/block/brd.c               |    4 +-
 drivers/nvdimm/pmem.c             |    6 ++-
 drivers/nvdimm/pmem.h             |    4 +-
 drivers/s390/block/dcssblk.c      |    6 ++-
 fs/dax.c                          |    6 ++-
 include/linux/blkdev.h            |    6 ++-
 include/linux/compiler.h          |    2 -
 include/linux/nd.h                |    2 +
 include/linux/pmem.h              |   70 +++++++++----------------------------
 scripts/checkpatch.pl             |    1 -
 tools/testing/nvdimm/pmem-dax.c   |    2 +
 15 files changed, 56 insertions(+), 102 deletions(-)

diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index 75eea7ce3d7c..d9c37ec4c760 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -395,7 +395,7 @@ prototypes:
 	int (*release) (struct gendisk *, fmode_t);
 	int (*ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
 	int (*compat_ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
-	int (*direct_access) (struct block_device *, sector_t, void __pmem **,
+	int (*direct_access) (struct block_device *, sector_t, void **,
 				unsigned long *);
 	int (*media_changed) (struct gendisk *);
 	void (*unlock_native_capacity) (struct gendisk *);
diff --git a/arch/powerpc/sysdev/axonram.c b/arch/powerpc/sysdev/axonram.c
index ff75d70f7285..154cd9110c08 100644
--- a/arch/powerpc/sysdev/axonram.c
+++ b/arch/powerpc/sysdev/axonram.c
@@ -143,12 +143,12 @@ axon_ram_make_request(struct request_queue *queue, struct bio *bio)
  */
 static long
 axon_ram_direct_access(struct block_device *device, sector_t sector,
-		       void __pmem **kaddr, pfn_t *pfn, long size)
+		       void **kaddr, pfn_t *pfn, long size)
 {
 	struct axon_ram_bank *bank = device->bd_disk->private_data;
 	loff_t offset = (loff_t)sector << AXON_RAM_SECTOR_SHIFT;
 
-	*kaddr = (void __pmem __force *) bank->io_addr + offset;
+	*kaddr = bank->io_addr + offset;
 	*pfn = phys_to_pfn_t(bank->ph_addr + offset, PFN_DEV);
 	return bank->size - offset;
 }
diff --git a/arch/x86/include/asm/pmem.h b/arch/x86/include/asm/pmem.h
index a8cf2a6b14d9..643eba42d620 100644
--- a/arch/x86/include/asm/pmem.h
+++ b/arch/x86/include/asm/pmem.h
@@ -28,10 +28,9 @@
  * Copy data to persistent memory media via non-temporal stores so that
  * a subsequent pmem driver flush operation will drain posted write queues.
  */
-static inline void arch_memcpy_to_pmem(void __pmem *dst, const void *src,
-		size_t n)
+static inline void arch_memcpy_to_pmem(void *dst, const void *src, size_t n)
 {
-	int unwritten;
+	int rem;
 
 	/*
 	 * We are copying between two kernel buffers, if
@@ -39,19 +38,17 @@ static inline void arch_memcpy_to_pmem(void __pmem *dst, const void *src,
 	 * fault) we would have already reported a general protection fault
 	 * before the WARN+BUG.
 	 */
-	unwritten = __copy_from_user_inatomic_nocache((void __force *) dst,
-			(void __user *) src, n);
-	if (WARN(unwritten, "%s: fault copying %p <- %p unwritten: %d\n",
-				__func__, dst, src, unwritten))
+	rem = __copy_from_user_inatomic_nocache(dst, (void __user *) src, n);
+	if (WARN(rem, "%s: fault copying %p <- %p unwritten: %d\n",
+				__func__, dst, src, rem))
 		BUG();
 }
 
-static inline int arch_memcpy_from_pmem(void *dst, const void __pmem *src,
-		size_t n)
+static inline int arch_memcpy_from_pmem(void *dst, const void *src, size_t n)
 {
 	if (static_cpu_has(X86_FEATURE_MCE_RECOVERY))
-		return memcpy_mcsafe(dst, (void __force *) src, n);
-	memcpy(dst, (void __force *) src, n);
+		return memcpy_mcsafe(dst, src, n);
+	memcpy(dst, src, n);
 	return 0;
 }
 
@@ -63,15 +60,14 @@ static inline int arch_memcpy_from_pmem(void *dst, const void __pmem *src,
  * Write back a cache range using the CLWB (cache line write back)
  * instruction.
  */
-static inline void arch_wb_cache_pmem(void __pmem *addr, size_t size)
+static inline void arch_wb_cache_pmem(void *addr, size_t size)
 {
 	u16 x86_clflush_size = boot_cpu_data.x86_clflush_size;
 	unsigned long clflush_mask = x86_clflush_size - 1;
-	void *vaddr = (void __force *)addr;
-	void *vend = vaddr + size;
+	void *vend = addr + size;
 	void *p;
 
-	for (p = (void *)((unsigned long)vaddr & ~clflush_mask);
+	for (p = (void *)((unsigned long)addr & ~clflush_mask);
 	     p < vend; p += x86_clflush_size)
 		clwb(p);
 }
@@ -93,14 +89,13 @@ static inline bool __iter_needs_pmem_wb(struct iov_iter *i)
  *
  * Copy data from the iterator 'i' to the PMEM buffer starting at 'addr'.
  */
-static inline size_t arch_copy_from_iter_pmem(void __pmem *addr, size_t bytes,
+static inline size_t arch_copy_from_iter_pmem(void *addr, size_t bytes,
 		struct iov_iter *i)
 {
-	void *vaddr = (void __force *)addr;
 	size_t len;
 
 	/* TODO: skip the write-back by always using non-temporal stores */
-	len = copy_from_iter_nocache(vaddr, bytes, i);
+	len = copy_from_iter_nocache(addr, bytes, i);
 
 	if (__iter_needs_pmem_wb(i))
 		arch_wb_cache_pmem(addr, bytes);
@@ -115,17 +110,15 @@ static inline size_t arch_copy_from_iter_pmem(void __pmem *addr, size_t bytes,
  *
  * Write zeros into the memory range starting at 'addr' for 'size' bytes.
  */
-static inline void arch_clear_pmem(void __pmem *addr, size_t size)
+static inline void arch_clear_pmem(void *addr, size_t size)
 {
-	void *vaddr = (void __force *)addr;
-
-	memset(vaddr, 0, size);
+	memset(addr, 0, size);
 	arch_wb_cache_pmem(addr, size);
 }
 
-static inline void arch_invalidate_pmem(void __pmem *addr, size_t size)
+static inline void arch_invalidate_pmem(void *addr, size_t size)
 {
-	clflush_cache_range((void __force *) addr, size);
+	clflush_cache_range(addr, size);
 }
 #endif /* CONFIG_ARCH_HAS_PMEM_API */
 #endif /* __ASM_X86_PMEM_H__ */
diff --git a/drivers/acpi/nfit.h b/drivers/acpi/nfit.h
index 9fda77cf81da..80fb2c0ac8bf 100644
--- a/drivers/acpi/nfit.h
+++ b/drivers/acpi/nfit.h
@@ -164,7 +164,7 @@ enum nd_blk_mmio_selector {
 struct nd_blk_addr {
 	union {
 		void __iomem *base;
-		void __pmem  *aperture;
+		void *aperture;
 	};
 };
 
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index c04bd9bc39fd..5f1fe4e6208d 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -381,7 +381,7 @@ static int brd_rw_page(struct block_device *bdev, sector_t sector,
 
 #ifdef CONFIG_BLK_DEV_RAM_DAX
 static long brd_direct_access(struct block_device *bdev, sector_t sector,
-			void __pmem **kaddr, pfn_t *pfn, long size)
+			void **kaddr, pfn_t *pfn, long size)
 {
 	struct brd_device *brd = bdev->bd_disk->private_data;
 	struct page *page;
@@ -391,7 +391,7 @@ static long brd_direct_access(struct block_device *bdev, sector_t sector,
 	page = brd_insert_page(brd, sector);
 	if (!page)
 		return -ENOSPC;
-	*kaddr = (void __pmem *)page_address(page);
+	*kaddr = page_address(page);
 	*pfn = page_to_pfn_t(page);
 
 	return PAGE_SIZE;
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 3f3fdb9586b9..ed1ec0afe66f 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -74,7 +74,7 @@ static int pmem_do_bvec(struct pmem_device *pmem, struct page *page,
 	bool bad_pmem = false;
 	void *mem = kmap_atomic(page);
 	phys_addr_t pmem_off = sector * 512 + pmem->data_offset;
-	void __pmem *pmem_addr = pmem->virt_addr + pmem_off;
+	void *pmem_addr = pmem->virt_addr + pmem_off;
 
 	if (unlikely(is_bad_pmem(&pmem->bb, sector, len)))
 		bad_pmem = true;
@@ -173,7 +173,7 @@ static int pmem_rw_page(struct block_device *bdev, sector_t sector,
 
 /* see "strong" declaration in tools/testing/nvdimm/pmem-dax.c */
 __weak long pmem_direct_access(struct block_device *bdev, sector_t sector,
-		      void __pmem **kaddr, pfn_t *pfn, long size)
+		      void **kaddr, pfn_t *pfn, long size)
 {
 	struct pmem_device *pmem = bdev->bd_queue->queuedata;
 	resource_size_t offset = sector * 512 + pmem->data_offset;
@@ -282,7 +282,7 @@ static int pmem_attach_disk(struct device *dev,
 
 	if (IS_ERR(addr))
 		return PTR_ERR(addr);
-	pmem->virt_addr = (void __pmem *) addr;
+	pmem->virt_addr = addr;
 
 	has_flush = nvdimm_has_flush(nd_region);
 	if (has_flush < 0)
diff --git a/drivers/nvdimm/pmem.h b/drivers/nvdimm/pmem.h
index c48d4e3aa346..b4ee4f71b4a1 100644
--- a/drivers/nvdimm/pmem.h
+++ b/drivers/nvdimm/pmem.h
@@ -6,7 +6,7 @@
 #include <linux/fs.h>
 
 long pmem_direct_access(struct block_device *bdev, sector_t sector,
-		      void __pmem **kaddr, pfn_t *pfn, long size);
+		      void **kaddr, pfn_t *pfn, long size);
 /* this definition is in it's own header for tools/testing/nvdimm to consume */
 struct pmem_device {
 	/* One contiguous memory region per device */
@@ -14,7 +14,7 @@ struct pmem_device {
 	/* when non-zero this device is hosting a 'pfn' instance */
 	phys_addr_t		data_offset;
 	u64			pfn_flags;
-	void __pmem		*virt_addr;
+	void			*virt_addr;
 	/* immutable base size of the namespace */
 	size_t			size;
 	/* trim size when namespace capacity has been section aligned */
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index bed53c46dd90..023c5c975dc0 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -31,7 +31,7 @@ static void dcssblk_release(struct gendisk *disk, fmode_t mode);
 static blk_qc_t dcssblk_make_request(struct request_queue *q,
 						struct bio *bio);
 static long dcssblk_direct_access(struct block_device *bdev, sector_t secnum,
-			 void __pmem **kaddr, pfn_t *pfn, long size);
+			 void **kaddr, pfn_t *pfn, long size);
 
 static char dcssblk_segments[DCSSBLK_PARM_LEN] = "\0";
 
@@ -884,7 +884,7 @@ fail:
 
 static long
 dcssblk_direct_access (struct block_device *bdev, sector_t secnum,
-			void __pmem **kaddr, pfn_t *pfn, long size)
+			void **kaddr, pfn_t *pfn, long size)
 {
 	struct dcssblk_dev_info *dev_info;
 	unsigned long offset, dev_sz;
@@ -894,7 +894,7 @@ dcssblk_direct_access (struct block_device *bdev, sector_t secnum,
 		return -ENODEV;
 	dev_sz = dev_info->end - dev_info->start;
 	offset = secnum * 512;
-	*kaddr = (void __pmem *) (dev_info->start + offset);
+	*kaddr = (void *) dev_info->start + offset;
 	*pfn = __pfn_to_pfn_t(PFN_DOWN(dev_info->start + offset), PFN_DEV);
 
 	return dev_sz - offset;
diff --git a/fs/dax.c b/fs/dax.c
index 434f421da660..c8312f6441bc 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -75,13 +75,13 @@ static long dax_map_atomic(struct block_device *bdev, struct blk_dax_ctl *dax)
 	struct request_queue *q = bdev->bd_queue;
 	long rc = -EIO;
 
-	dax->addr = (void __pmem *) ERR_PTR(-EIO);
+	dax->addr = ERR_PTR(-EIO);
 	if (blk_queue_enter(q, true) != 0)
 		return rc;
 
 	rc = bdev_direct_access(bdev, dax);
 	if (rc < 0) {
-		dax->addr = (void __pmem *) ERR_PTR(rc);
+		dax->addr = ERR_PTR(rc);
 		blk_queue_exit(q);
 		return rc;
 	}
@@ -152,7 +152,7 @@ static ssize_t dax_io(struct inode *inode, struct iov_iter *iter,
 	int rw = iov_iter_rw(iter), rc;
 	long map_len = 0;
 	struct blk_dax_ctl dax = {
-		.addr = (void __pmem *) ERR_PTR(-EIO),
+		.addr = ERR_PTR(-EIO),
 	};
 	unsigned blkbits = inode->i_blkbits;
 	sector_t file_blks = (i_size_read(inode) + (1 << blkbits) - 1)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 3d9cf326574f..fde908b2836b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1659,7 +1659,7 @@ static inline bool integrity_req_gap_front_merge(struct request *req,
  */
 struct blk_dax_ctl {
 	sector_t sector;
-	void __pmem *addr;
+	void *addr;
 	long size;
 	pfn_t pfn;
 };
@@ -1670,8 +1670,8 @@ struct block_device_operations {
 	int (*rw_page)(struct block_device *, sector_t, struct page *, int rw);
 	int (*ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
 	int (*compat_ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
-	long (*direct_access)(struct block_device *, sector_t, void __pmem **,
-			pfn_t *, long);
+	long (*direct_access)(struct block_device *, sector_t, void **, pfn_t *,
+			long);
 	unsigned int (*check_events) (struct gendisk *disk,
 				      unsigned int clearing);
 	/* ->media_changed() is DEPRECATED, use ->check_events() instead */
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 793c0829e3a3..b966974938ed 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -17,7 +17,6 @@
 # define __release(x)	__context__(x,-1)
 # define __cond_lock(x,c)	((c) ? ({ __acquire(x); 1; }) : 0)
 # define __percpu	__attribute__((noderef, address_space(3)))
-# define __pmem		__attribute__((noderef, address_space(5)))
 #ifdef CONFIG_SPARSE_RCU_POINTER
 # define __rcu		__attribute__((noderef, address_space(4)))
 #else /* CONFIG_SPARSE_RCU_POINTER */
@@ -45,7 +44,6 @@ extern void __chk_io_ptr(const volatile void __iomem *);
 # define __cond_lock(x,c) (c)
 # define __percpu
 # define __rcu
-# define __pmem
 # define __private
 # define ACCESS_PRIVATE(p, member) ((p)->member)
 #endif /* __CHECKER__ */
diff --git a/include/linux/nd.h b/include/linux/nd.h
index 1ecd64643512..f1ea426d6a5e 100644
--- a/include/linux/nd.h
+++ b/include/linux/nd.h
@@ -68,7 +68,7 @@ struct nd_namespace_io {
 	struct nd_namespace_common common;
 	struct resource res;
 	resource_size_t size;
-	void __pmem *addr;
+	void *addr;
 	struct badblocks bb;
 };
 
diff --git a/include/linux/pmem.h b/include/linux/pmem.h
index 9e3ea94b8157..e856c2cb0fe8 100644
--- a/include/linux/pmem.h
+++ b/include/linux/pmem.h
@@ -26,37 +26,35 @@
  * calling these symbols with arch_has_pmem_api() and redirect to the
  * implementation in asm/pmem.h.
  */
-static inline void arch_memcpy_to_pmem(void __pmem *dst, const void *src,
-		size_t n)
+static inline void arch_memcpy_to_pmem(void *dst, const void *src, size_t n)
 {
 	BUG();
 }
 
-static inline int arch_memcpy_from_pmem(void *dst, const void __pmem *src,
-		size_t n)
+static inline int arch_memcpy_from_pmem(void *dst, const void *src, size_t n)
 {
 	BUG();
 	return -EFAULT;
 }
 
-static inline size_t arch_copy_from_iter_pmem(void __pmem *addr, size_t bytes,
+static inline size_t arch_copy_from_iter_pmem(void *addr, size_t bytes,
 		struct iov_iter *i)
 {
 	BUG();
 	return 0;
 }
 
-static inline void arch_clear_pmem(void __pmem *addr, size_t size)
+static inline void arch_clear_pmem(void *addr, size_t size)
 {
 	BUG();
 }
 
-static inline void arch_wb_cache_pmem(void __pmem *addr, size_t size)
+static inline void arch_wb_cache_pmem(void *addr, size_t size)
 {
 	BUG();
 }
 
-static inline void arch_invalidate_pmem(void __pmem *addr, size_t size)
+static inline void arch_invalidate_pmem(void *addr, size_t size)
 {
 	BUG();
 }
@@ -67,13 +65,6 @@ static inline bool arch_has_pmem_api(void)
 	return IS_ENABLED(CONFIG_ARCH_HAS_PMEM_API);
 }
 
-static inline int default_memcpy_from_pmem(void *dst, void __pmem const *src,
-		size_t size)
-{
-	memcpy(dst, (void __force *) src, size);
-	return 0;
-}
-
 /*
  * memcpy_from_pmem - read from persistent memory with error handling
  * @dst: destination buffer
@@ -82,40 +73,13 @@ static inline int default_memcpy_from_pmem(void *dst, void __pmem const *src,
  *
  * Returns 0 on success negative error code on failure.
  */
-static inline int memcpy_from_pmem(void *dst, void __pmem const *src,
-		size_t size)
+static inline int memcpy_from_pmem(void *dst, void const *src, size_t size)
 {
 	if (arch_has_pmem_api())
 		return arch_memcpy_from_pmem(dst, src, size);
 	else
-		return default_memcpy_from_pmem(dst, src, size);
-}
-
-/*
- * These defaults seek to offer decent performance and minimize the
- * window between i/o completion and writes being durable on media.
- * However, it is undefined / architecture specific whether
- * ARCH_MEMREMAP_PMEM + default_memcpy_to_pmem is sufficient for
- * making data durable relative to i/o completion.
- */
-static inline void default_memcpy_to_pmem(void __pmem *dst, const void *src,
-		size_t size)
-{
-	memcpy((void __force *) dst, src, size);
-}
-
-static inline size_t default_copy_from_iter_pmem(void __pmem *addr,
-		size_t bytes, struct iov_iter *i)
-{
-	return copy_from_iter_nocache((void __force *)addr, bytes, i);
-}
-
-static inline void default_clear_pmem(void __pmem *addr, size_t size)
-{
-	if (size == PAGE_SIZE && ((unsigned long)addr & ~PAGE_MASK) == 0)
-		clear_page((void __force *)addr);
-	else
-		memset((void __force *)addr, 0, size);
+		memcpy(dst, src, size);
+	return 0;
 }
 
 /**
@@ -130,12 +94,12 @@ static inline void default_clear_pmem(void __pmem *addr, size_t size)
  * data may still reside in cpu or platform buffers, so this operation
  * must be followed by a blkdev_issue_flush() on the pmem block device.
  */
-static inline void memcpy_to_pmem(void __pmem *dst, const void *src, size_t n)
+static inline void memcpy_to_pmem(void *dst, const void *src, size_t n)
 {
 	if (arch_has_pmem_api())
 		arch_memcpy_to_pmem(dst, src, n);
 	else
-		default_memcpy_to_pmem(dst, src, n);
+		memcpy(dst, src, n);
 }
 
 /**
@@ -147,12 +111,12 @@ static inline void memcpy_to_pmem(void __pmem *dst, const void *src, size_t n)
  * Copy data from the iterator 'i' to the PMEM buffer starting at 'addr'.
  * See blkdev_issue_flush() note for memcpy_to_pmem().
  */
-static inline size_t copy_from_iter_pmem(void __pmem *addr, size_t bytes,
+static inline size_t copy_from_iter_pmem(void *addr, size_t bytes,
 		struct iov_iter *i)
 {
 	if (arch_has_pmem_api())
 		return arch_copy_from_iter_pmem(addr, bytes, i);
-	return default_copy_from_iter_pmem(addr, bytes, i);
+	return copy_from_iter_nocache(addr, bytes, i);
 }
 
 /**
@@ -163,12 +127,12 @@ static inline size_t copy_from_iter_pmem(void __pmem *addr, size_t bytes,
  * Write zeros into the memory range starting at 'addr' for 'size' bytes.
  * See blkdev_issue_flush() note for memcpy_to_pmem().
  */
-static inline void clear_pmem(void __pmem *addr, size_t size)
+static inline void clear_pmem(void *addr, size_t size)
 {
 	if (arch_has_pmem_api())
 		arch_clear_pmem(addr, size);
 	else
-		default_clear_pmem(addr, size);
+		memset(addr, 0, size);
 }
 
 /**
@@ -179,7 +143,7 @@ static inline void clear_pmem(void __pmem *addr, size_t size)
  * For platforms that support clearing poison this flushes any poisoned
  * ranges out of the cache
  */
-static inline void invalidate_pmem(void __pmem *addr, size_t size)
+static inline void invalidate_pmem(void *addr, size_t size)
 {
 	if (arch_has_pmem_api())
 		arch_invalidate_pmem(addr, size);
@@ -193,7 +157,7 @@ static inline void invalidate_pmem(void __pmem *addr, size_t size)
  * Write back the processor cache range starting at 'addr' for 'size' bytes.
  * See blkdev_issue_flush() note for memcpy_to_pmem().
  */
-static inline void wb_cache_pmem(void __pmem *addr, size_t size)
+static inline void wb_cache_pmem(void *addr, size_t size)
 {
 	if (arch_has_pmem_api())
 		arch_wb_cache_pmem(addr, size);
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 4904ced676d4..24a08363995a 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -313,7 +313,6 @@ our $Sparse	= qr{
 			__kernel|
 			__force|
 			__iomem|
-			__pmem|
 			__must_check|
 			__init_refok|
 			__kprobes|
diff --git a/tools/testing/nvdimm/pmem-dax.c b/tools/testing/nvdimm/pmem-dax.c
index 1e0218ce6a8b..c9b8c48f85fc 100644
--- a/tools/testing/nvdimm/pmem-dax.c
+++ b/tools/testing/nvdimm/pmem-dax.c
@@ -16,7 +16,7 @@
 #include <nd.h>
 
 long pmem_direct_access(struct block_device *bdev, sector_t sector,
-		void __pmem **kaddr, pfn_t *pfn, long size)
+		void **kaddr, pfn_t *pfn, long size)
 {
 	struct pmem_device *pmem = bdev->bd_queue->queuedata;
 	resource_size_t offset = sector * 512 + pmem->data_offset;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
