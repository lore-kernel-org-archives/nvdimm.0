Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8620281E9E
 for <linux-nvdimm@lists.01.org>; Thu, 19 Jan 2017 19:54:30 -0800 (PST)
Subject: [PATCH 02/13] block, dax: introduce dax_operations
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 19 Jan 2017 19:50:24 -0800
Message-ID: <148488422405.37913.13366670089124790849.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <148488421301.37913.12835362165895864897.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <148488421301.37913.12835362165895864897.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, Jens Axboe <axboe@fb.com>, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Prepare for the removal of memcpy_to_pmem() and copy_from_iter_pmem() by
introducing dax_ops. This allows for driver specific overrides for the
routines that transfer data to a dax capable block device.

Cc: <dm-devel@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@fb.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/powerpc/sysdev/axonram.c |    6 +++++-
 drivers/block/brd.c           |    6 +++++-
 drivers/md/dm.c               |    6 +++++-
 drivers/nvdimm/pmem.c         |    6 +++++-
 drivers/s390/block/dcssblk.c  |    6 +++++-
 fs/block_dev.c                |    6 ++++--
 include/linux/blkdev.h        |    8 ++++++--
 7 files changed, 35 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/sysdev/axonram.c b/arch/powerpc/sysdev/axonram.c
index ada29eaed6e2..d4f318e7e6f3 100644
--- a/arch/powerpc/sysdev/axonram.c
+++ b/arch/powerpc/sysdev/axonram.c
@@ -153,9 +153,13 @@ axon_ram_direct_access(struct block_device *device, sector_t sector,
 	return bank->size - offset;
 }
 
+static const struct dax_operations axon_ram_dax_ops = {
+	.direct_access	= axon_ram_direct_access,
+};
+
 static const struct block_device_operations axon_ram_devops = {
 	.owner		= THIS_MODULE,
-	.direct_access	= axon_ram_direct_access
+	.dax_ops	= &axon_ram_dax_ops,
 };
 
 /**
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 3adc32a3153b..9d06e5da2ab2 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -395,10 +395,14 @@ static long brd_direct_access(struct block_device *bdev, sector_t sector,
 #define brd_direct_access NULL
 #endif
 
+static const struct dax_operations brd_dax_ops = {
+	.direct_access = 	brd_direct_access,
+};
+
 static const struct block_device_operations brd_fops = {
 	.owner =		THIS_MODULE,
 	.rw_page =		brd_rw_page,
-	.direct_access =	brd_direct_access,
+	.dax_ops =		&brd_dax_ops,
 };
 
 /*
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 3086da5664f3..87920a379d20 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2725,13 +2725,17 @@ static const struct pr_ops dm_pr_ops = {
 	.pr_clear	= dm_pr_clear,
 };
 
+static const struct dax_operations dm_dax_ops = {
+	.direct_access = dm_blk_direct_access,
+};
+
 static const struct block_device_operations dm_blk_dops = {
 	.open = dm_blk_open,
 	.release = dm_blk_close,
 	.ioctl = dm_blk_ioctl,
-	.direct_access = dm_blk_direct_access,
 	.getgeo = dm_blk_getgeo,
 	.pr_ops = &dm_pr_ops,
+	.dax_ops = &dm_dax_ops,
 	.owner = THIS_MODULE
 };
 
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 0d7779384a9f..6e5442174245 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -217,11 +217,15 @@ __weak long pmem_direct_access(struct block_device *bdev, sector_t sector,
 	return pmem->size - pmem->pfn_pad - offset;
 }
 
+static const struct dax_operations pmem_dax_ops = {
+	.direct_access = pmem_direct_access,
+};
+
 static const struct block_device_operations pmem_fops = {
 	.owner =		THIS_MODULE,
 	.rw_page =		pmem_rw_page,
-	.direct_access =	pmem_direct_access,
 	.revalidate_disk =	nvdimm_revalidate_disk,
+	.dax_ops =		&pmem_dax_ops,
 };
 
 static void pmem_release_queue(void *q)
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index 9d66b4fb174b..6acebe4a47f3 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -36,11 +36,15 @@ static long dcssblk_direct_access(struct block_device *bdev, sector_t secnum,
 static char dcssblk_segments[DCSSBLK_PARM_LEN] = "\0";
 
 static int dcssblk_major;
+
+static const struct dax_operations dcssblk_dax_ops = {
+	.direct_access 	= dcssblk_direct_access,
+};
+
 static const struct block_device_operations dcssblk_devops = {
 	.owner   	= THIS_MODULE,
 	.open    	= dcssblk_open,
 	.release 	= dcssblk_release,
-	.direct_access 	= dcssblk_direct_access,
 };
 
 struct dcssblk_dev_info {
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 5db5d1340d69..1acfc7d25768 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -736,6 +736,7 @@ long bdev_direct_access(struct block_device *bdev, struct blk_dax_ctl *dax)
 	sector_t sector = dax->sector;
 	long avail, size = dax->size;
 	const struct block_device_operations *ops = bdev->bd_disk->fops;
+	const struct dax_operations *dax_ops = ops->dax_ops;
 
 	/*
 	 * The device driver is allowed to sleep, in order to make the
@@ -745,7 +746,8 @@ long bdev_direct_access(struct block_device *bdev, struct blk_dax_ctl *dax)
 
 	if (size < 0)
 		return size;
-	if (!blk_queue_dax(bdev_get_queue(bdev)) || !ops->direct_access)
+	if (!blk_queue_dax(bdev_get_queue(bdev)) || !dax_ops
+			|| !dax_ops->direct_access)
 		return -EOPNOTSUPP;
 	if ((sector + DIV_ROUND_UP(size, 512)) >
 					part_nr_sects_read(bdev->bd_part))
@@ -753,7 +755,7 @@ long bdev_direct_access(struct block_device *bdev, struct blk_dax_ctl *dax)
 	sector += get_start_sect(bdev);
 	if (sector % (PAGE_SIZE / 512))
 		return -EINVAL;
-	avail = ops->direct_access(bdev, sector, &dax->addr, &dax->pfn, size);
+	avail = dax_ops->direct_access(bdev, sector, &dax->addr, &dax->pfn, size);
 	if (!avail)
 		return -ERANGE;
 	if (avail > 0 && avail & ~PAGE_MASK)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 83695641bd5e..8afce34823f5 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1863,14 +1863,17 @@ struct blk_dax_ctl {
 	pfn_t pfn;
 };
 
+struct dax_operations {
+	long (*direct_access)(struct block_device *, sector_t, void **, pfn_t *,
+			long);
+};
+
 struct block_device_operations {
 	int (*open) (struct block_device *, fmode_t);
 	void (*release) (struct gendisk *, fmode_t);
 	int (*rw_page)(struct block_device *, sector_t, struct page *, bool);
 	int (*ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
 	int (*compat_ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
-	long (*direct_access)(struct block_device *, sector_t, void **, pfn_t *,
-			long);
 	unsigned int (*check_events) (struct gendisk *disk,
 				      unsigned int clearing);
 	/* ->media_changed() is DEPRECATED, use ->check_events() instead */
@@ -1882,6 +1885,7 @@ struct block_device_operations {
 	void (*swap_slot_free_notify) (struct block_device *, unsigned long);
 	struct module *owner;
 	const struct pr_ops *pr_ops;
+	const struct dax_operations *dax_ops;
 };
 
 extern int __blkdev_driver_ioctl(struct block_device *, fmode_t, unsigned int,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
