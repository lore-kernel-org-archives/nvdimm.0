Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 by ml01.01.org (Postfix) with ESMTP id A05071A1F7F
 for <linux-nvdimm@lists.01.org>; Tue, 10 May 2016 11:49:38 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v6 2/5] dax: enable dax in the presence of known media errors
 (badblocks)
Date: Tue, 10 May 2016 12:49:13 -0600
Message-Id: <1462906156-22303-3-git-send-email-vishal.l.verma@intel.com>
In-Reply-To: <1462906156-22303-1-git-send-email-vishal.l.verma@intel.com>
References: <1462906156-22303-1-git-send-email-vishal.l.verma@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
Cc: Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-block@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

From: Dan Williams <dan.j.williams@intel.com>

1/ If a mapping overlaps a bad sector fail the request.

2/ Do not opportunistically report more dax-capable capacity than is
   requested when errors present.

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
[vishal: fix a conflict with system RAM collision patches]
[vishal: add a 'size' parameter to ->direct_access]
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 arch/powerpc/sysdev/axonram.c |  2 +-
 block/ioctl.c                 |  9 ---------
 drivers/block/brd.c           |  2 +-
 drivers/nvdimm/pmem.c         | 10 +++++++++-
 drivers/s390/block/dcssblk.c  |  2 +-
 fs/block_dev.c                |  2 +-
 include/linux/blkdev.h        |  2 +-
 7 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/arch/powerpc/sysdev/axonram.c b/arch/powerpc/sysdev/axonram.c
index 0d112b9..ff75d70 100644
--- a/arch/powerpc/sysdev/axonram.c
+++ b/arch/powerpc/sysdev/axonram.c
@@ -143,7 +143,7 @@ axon_ram_make_request(struct request_queue *queue, struct bio *bio)
  */
 static long
 axon_ram_direct_access(struct block_device *device, sector_t sector,
-		       void __pmem **kaddr, pfn_t *pfn)
+		       void __pmem **kaddr, pfn_t *pfn, long size)
 {
 	struct axon_ram_bank *bank = device->bd_disk->private_data;
 	loff_t offset = (loff_t)sector << AXON_RAM_SECTOR_SHIFT;
diff --git a/block/ioctl.c b/block/ioctl.c
index 4ff1f92..bf80bfd 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -423,15 +423,6 @@ bool blkdev_dax_capable(struct block_device *bdev)
 			|| (bdev->bd_part->nr_sects % (PAGE_SIZE / 512)))
 		return false;
 
-	/*
-	 * If the device has known bad blocks, force all I/O through the
-	 * driver / page cache.
-	 *
-	 * TODO: support finer grained dax error handling
-	 */
-	if (disk->bb && disk->bb->count)
-		return false;
-
 	return true;
 }
 #endif
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 51a071e..c04bd9b 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -381,7 +381,7 @@ static int brd_rw_page(struct block_device *bdev, sector_t sector,
 
 #ifdef CONFIG_BLK_DEV_RAM_DAX
 static long brd_direct_access(struct block_device *bdev, sector_t sector,
-			void __pmem **kaddr, pfn_t *pfn)
+			void __pmem **kaddr, pfn_t *pfn, long size)
 {
 	struct brd_device *brd = bdev->bd_disk->private_data;
 	struct page *page;
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index f798899..c447579 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -182,14 +182,22 @@ static int pmem_rw_page(struct block_device *bdev, sector_t sector,
 }
 
 static long pmem_direct_access(struct block_device *bdev, sector_t sector,
-		      void __pmem **kaddr, pfn_t *pfn)
+		      void __pmem **kaddr, pfn_t *pfn, long size)
 {
 	struct pmem_device *pmem = bdev->bd_disk->private_data;
 	resource_size_t offset = sector * 512 + pmem->data_offset;
 
+	if (unlikely(is_bad_pmem(&pmem->bb, sector, size)))
+		return -EIO;
 	*kaddr = pmem->virt_addr + offset;
 	*pfn = phys_to_pfn_t(pmem->phys_addr + offset, pmem->pfn_flags);
 
+	/*
+	 * If badblocks are present, limit known good range to the
+	 * requested range.
+	 */
+	if (unlikely(pmem->bb.count))
+		return size;
 	return pmem->size - pmem->pfn_pad - offset;
 }
 
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index b839086..c45d538 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -884,7 +884,7 @@ fail:
 
 static long
 dcssblk_direct_access (struct block_device *bdev, sector_t secnum,
-			void __pmem **kaddr, pfn_t *pfn)
+			void __pmem **kaddr, pfn_t *pfn, long size)
 {
 	struct dcssblk_dev_info *dev_info;
 	unsigned long offset, dev_sz;
diff --git a/fs/block_dev.c b/fs/block_dev.c
index b25bb23..02c68c4 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -488,7 +488,7 @@ long bdev_direct_access(struct block_device *bdev, struct blk_dax_ctl *dax)
 	sector += get_start_sect(bdev);
 	if (sector % (PAGE_SIZE / 512))
 		return -EINVAL;
-	avail = ops->direct_access(bdev, sector, &dax->addr, &dax->pfn);
+	avail = ops->direct_access(bdev, sector, &dax->addr, &dax->pfn, size);
 	if (!avail)
 		return -ERANGE;
 	if (avail > 0 && avail & ~PAGE_MASK)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 669e419..55ed530 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1657,7 +1657,7 @@ struct block_device_operations {
 	int (*ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
 	int (*compat_ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
 	long (*direct_access)(struct block_device *, sector_t, void __pmem **,
-			pfn_t *);
+			pfn_t *, long);
 	unsigned int (*check_events) (struct gendisk *disk,
 				      unsigned int clearing);
 	/* ->media_changed() is DEPRECATED, use ->check_events() instead */
-- 
2.5.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
