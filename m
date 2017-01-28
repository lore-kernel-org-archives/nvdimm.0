Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 57FF682000
 for <linux-nvdimm@lists.01.org>; Sat, 28 Jan 2017 00:41:44 -0800 (PST)
Subject: [RFC PATCH 17/17] block: remove
 block_device_operations.direct_access and related infrastructure
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 28 Jan 2017 00:37:36 -0800
Message-ID: <148559265603.11180.1391403529070377939.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Now that all the producers and consumers of dax interfaces have been
converted to using dax_operations on a dax_inode, remove the block
device direct_access enabling.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/powerpc/sysdev/axonram.c |   15 --------------
 drivers/block/brd.c           |   11 ----------
 drivers/md/dm-linear.c        |   19 -----------------
 drivers/md/dm-snap.c          |    8 -------
 drivers/md/dm-stripe.c        |   24 ----------------------
 drivers/md/dm-table.c         |    2 +-
 drivers/md/dm-target.c        |    7 ------
 drivers/md/dm.c               |   19 +++--------------
 drivers/nvdimm/pmem.c         |    9 --------
 drivers/s390/block/dcssblk.c  |   16 ---------------
 fs/block_dev.c                |   45 -----------------------------------------
 include/linux/blkdev.h        |    3 ---
 include/linux/device-mapper.h |    9 --------
 13 files changed, 4 insertions(+), 183 deletions(-)

diff --git a/arch/powerpc/sysdev/axonram.c b/arch/powerpc/sysdev/axonram.c
index 4e1f58187726..1337b5829980 100644
--- a/arch/powerpc/sysdev/axonram.c
+++ b/arch/powerpc/sysdev/axonram.c
@@ -148,23 +148,8 @@ __axon_ram_direct_access(struct axon_ram_bank *bank, phys_addr_t offset,
 	return bank->size - offset;
 }
 
-/**
- * axon_ram_direct_access - direct_access() method for block device
- * @device, @sector, @data: see block_device_operations method
- */
-static long
-axon_ram_blk_direct_access(struct block_device *device, sector_t sector,
-		       void **kaddr, pfn_t *pfn, long size)
-{
-	struct axon_ram_bank *bank = device->bd_disk->private_data;
-
-	return __axon_ram_direct_access(bank, sector << AXON_RAM_SECTOR_SHIFT,
-			kaddr, pfn, size);
-}
-
 static const struct block_device_operations axon_ram_devops = {
 	.owner		= THIS_MODULE,
-	.direct_access	= axon_ram_blk_direct_access
 };
 
 static long
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 1279df4dc07c..52a1259f8ded 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -395,14 +395,6 @@ static long __brd_direct_access(struct brd_device *brd, phys_addr_t dev_addr,
 	return PAGE_SIZE;
 }
 
-static long brd_blk_direct_access(struct block_device *bdev, sector_t sector,
-			void **kaddr, pfn_t *pfn, long size)
-{
-	struct brd_device *brd = bdev->bd_disk->private_data;
-
-	return __brd_direct_access(brd, sector * 512, kaddr, pfn, size);
-}
-
 static long brd_dax_direct_access(struct dax_inode *dax_inode,
 		phys_addr_t dev_addr, void **kaddr, pfn_t *pfn, long size)
 {
@@ -414,14 +406,11 @@ static long brd_dax_direct_access(struct dax_inode *dax_inode,
 static const struct dax_operations brd_dax_ops = {
 	.direct_access = brd_dax_direct_access,
 };
-#else
-#define brd_blk_direct_access NULL
 #endif
 
 static const struct block_device_operations brd_fops = {
 	.owner =		THIS_MODULE,
 	.rw_page =		brd_rw_page,
-	.direct_access =	brd_blk_direct_access,
 };
 
 /*
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index e91ca8089333..7ec2a8eb8a14 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -141,24 +141,6 @@ static int linear_iterate_devices(struct dm_target *ti,
 	return fn(ti, lc->dev, lc->start, ti->len, data);
 }
 
-static long linear_direct_access(struct dm_target *ti, sector_t sector,
-				 void **kaddr, pfn_t *pfn, long size)
-{
-	struct linear_c *lc = ti->private;
-	struct block_device *bdev = lc->dev->bdev;
-	struct blk_dax_ctl dax = {
-		.sector = linear_map_sector(ti, sector),
-		.size = size,
-	};
-	long ret;
-
-	ret = bdev_direct_access(bdev, &dax);
-	*kaddr = dax.addr;
-	*pfn = dax.pfn;
-
-	return ret;
-}
-
 static long linear_dax_direct_access(struct dm_target *ti, phys_addr_t dev_addr,
 				     void **kaddr, pfn_t *pfn, long size)
 {
@@ -192,7 +174,6 @@ static struct target_type linear_target = {
 	.status = linear_status,
 	.prepare_ioctl = linear_prepare_ioctl,
 	.iterate_devices = linear_iterate_devices,
-	.direct_access = linear_direct_access,
 	.dax_ops = &linear_dax_ops,
 };
 
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 1990e3bd6958..1d9407633bb5 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -2302,13 +2302,6 @@ static int origin_map(struct dm_target *ti, struct bio *bio)
 	return do_origin(o->dev, bio);
 }
 
-static long origin_direct_access(struct dm_target *ti, sector_t sector,
-		void **kaddr, pfn_t *pfn, long size)
-{
-	DMWARN("device does not support dax.");
-	return -EIO;
-}
-
 static long origin_dax_direct_access(struct dm_target *ti, phys_addr_t dev_addr,
 		void **kaddr, pfn_t *pfn, long size)
 {
@@ -2379,7 +2372,6 @@ static struct target_type origin_target = {
 	.postsuspend = origin_postsuspend,
 	.status  = origin_status,
 	.iterate_devices = origin_iterate_devices,
-	.direct_access = origin_direct_access,
 	.dax_ops = &origin_dax_ops,
 };
 
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index 47fb56a6184a..229b2c543902 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -308,29 +308,6 @@ static int stripe_map(struct dm_target *ti, struct bio *bio)
 	return DM_MAPIO_REMAPPED;
 }
 
-static long stripe_direct_access(struct dm_target *ti, sector_t sector,
-				 void **kaddr, pfn_t *pfn, long size)
-{
-	struct stripe_c *sc = ti->private;
-	uint32_t stripe;
-	struct block_device *bdev;
-	struct blk_dax_ctl dax = {
-		.size = size,
-	};
-	long ret;
-
-	stripe_map_sector(sc, sector, &stripe, &dax.sector);
-
-	dax.sector += sc->stripe[stripe].physical_start;
-	bdev = sc->stripe[stripe].dev->bdev;
-
-	ret = bdev_direct_access(bdev, &dax);
-	*kaddr = dax.addr;
-	*pfn = dax.pfn;
-
-	return ret;
-}
-
 static long stripe_dax_direct_access(struct dm_target *ti, phys_addr_t dev_addr,
 		void **kaddr, pfn_t *pfn, long size)
 {
@@ -477,7 +454,6 @@ static struct target_type stripe_target = {
 	.status = stripe_status,
 	.iterate_devices = stripe_iterate_devices,
 	.io_hints = stripe_io_hints,
-	.direct_access = stripe_direct_access,
 	.dax_ops = &stripe_dax_ops,
 };
 
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 3ad16d9c9d5a..cd23be26384c 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -856,7 +856,7 @@ static bool dm_table_supports_dax(struct dm_table *t)
 	while (i < dm_table_get_num_targets(t)) {
 		ti = dm_table_get_target(t, i++);
 
-		if (!ti->type->direct_access)
+		if (!ti->type->dax_ops)
 			return false;
 
 		if (!ti->type->iterate_devices ||
diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
index ab072f53cf24..c3f55df90157 100644
--- a/drivers/md/dm-target.c
+++ b/drivers/md/dm-target.c
@@ -148,12 +148,6 @@ static void io_err_release_clone_rq(struct request *clone)
 {
 }
 
-static long io_err_direct_access(struct dm_target *ti, sector_t sector,
-				 void **kaddr, pfn_t *pfn, long size)
-{
-	return -EIO;
-}
-
 static long io_err_dax_direct_access(struct dm_target *ti, phys_addr_t dev_addr,
 				     void **kaddr, pfn_t *pfn, long size)
 {
@@ -174,7 +168,6 @@ static struct target_type error_target = {
 	.map_rq = io_err_map_rq,
 	.clone_and_map_rq = io_err_clone_and_map_rq,
 	.release_clone_rq = io_err_release_clone_rq,
-	.direct_access = io_err_direct_access,
 	.dax_ops = &err_dax_ops,
 };
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 5c5eeda0eb0a..497fb8adc660 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -910,7 +910,7 @@ int dm_set_target_max_io_len(struct dm_target *ti, sector_t len)
 EXPORT_SYMBOL_GPL(dm_set_target_max_io_len);
 
 static long __dm_direct_access(struct mapped_device *md, phys_addr_t dev_addr,
-			       void **kaddr, pfn_t *pfn, long size, bool blk)
+			       void **kaddr, pfn_t *pfn, long size)
 {
 	sector_t sector = dev_addr >> SECTOR_SHIFT;
 	struct dm_table *map;
@@ -929,9 +929,7 @@ static long __dm_direct_access(struct mapped_device *md, phys_addr_t dev_addr,
 	len = max_io_len(sector, ti) << SECTOR_SHIFT;
 	size = min(len, size);
 
-	if (blk && ti->type->direct_access)
-		ret = ti->type->direct_access(ti, sector, kaddr, pfn, size);
-	else if (ti->type->dax_ops)
+	if (ti->type->dax_ops)
 		ret = ti->type->dax_ops->dm_direct_access(ti, dev_addr, kaddr,
 				pfn, size);
 out:
@@ -939,23 +937,13 @@ static long __dm_direct_access(struct mapped_device *md, phys_addr_t dev_addr,
 	return min(ret, size);
 }
 
-static long dm_blk_direct_access(struct block_device *bdev, sector_t sector,
-				 void **kaddr, pfn_t *pfn, long size)
-{
-	struct mapped_device *md = bdev->bd_disk->private_data;
-
-	return __dm_direct_access(md, sector << SECTOR_SHIFT, kaddr, pfn, size,
-			true);
-}
-
 static long dm_dax_direct_access(struct dax_inode *dax_inode,
 				 phys_addr_t dev_addr, void **kaddr, pfn_t *pfn,
 				 long size)
 {
 	struct mapped_device *md = dax_inode_get_private(dax_inode);
 
-	return __dm_direct_access(md, dev_addr, kaddr, pfn, size,
-			false);
+	return __dm_direct_access(md, dev_addr, kaddr, pfn, size);
 }
 
 /*
@@ -2769,7 +2757,6 @@ static const struct block_device_operations dm_blk_dops = {
 	.open = dm_blk_open,
 	.release = dm_blk_close,
 	.ioctl = dm_blk_ioctl,
-	.direct_access = dm_blk_direct_access,
 	.getgeo = dm_blk_getgeo,
 	.pr_ops = &dm_pr_ops,
 	.owner = THIS_MODULE
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index d3d7de645e20..41781f853396 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -219,18 +219,9 @@ __weak long __pmem_direct_access(struct pmem_device *pmem, phys_addr_t dev_addr,
 	return pmem->size - pmem->pfn_pad - offset;
 }
 
-static long pmem_blk_direct_access(struct block_device *bdev, sector_t sector,
-		void **kaddr, pfn_t *pfn, long size)
-{
-	struct pmem_device *pmem = bdev->bd_queue->queuedata;
-
-	return __pmem_direct_access(pmem, sector * 512, kaddr, pfn, size);
-}
-
 static const struct block_device_operations pmem_fops = {
 	.owner =		THIS_MODULE,
 	.rw_page =		pmem_rw_page,
-	.direct_access =	pmem_blk_direct_access,
 	.revalidate_disk =	nvdimm_revalidate_disk,
 };
 
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index 67b0885b4d12..03140c93dbd1 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -31,8 +31,6 @@ static int dcssblk_open(struct block_device *bdev, fmode_t mode);
 static void dcssblk_release(struct gendisk *disk, fmode_t mode);
 static blk_qc_t dcssblk_make_request(struct request_queue *q,
 						struct bio *bio);
-static long dcssblk_blk_direct_access(struct block_device *bdev, sector_t secnum,
-			 void **kaddr, pfn_t *pfn, long size);
 static long dcssblk_dax_direct_access(struct dax_inode *dax_inode,
 		phys_addr_t dev_addr, void **kaddr, pfn_t *pfn, long size);
 
@@ -43,7 +41,6 @@ static const struct block_device_operations dcssblk_devops = {
 	.owner   	= THIS_MODULE,
 	.open    	= dcssblk_open,
 	.release 	= dcssblk_release,
-	.direct_access 	= dcssblk_blk_direct_access,
 };
 
 static const struct dax_operations dcssblk_dax_ops = {
@@ -914,19 +911,6 @@ __dcssblk_direct_access(struct dcssblk_dev_info *dev_info, phys_addr_t offset,
 }
 
 static long
-dcssblk_blk_direct_access(struct block_device *bdev, sector_t secnum,
-			void **kaddr, pfn_t *pfn, long size)
-{
-	struct dcssblk_dev_info *dev_info;
-
-	dev_info = bdev->bd_disk->private_data;
-	if (!dev_info)
-		return -ENODEV;
-	return __dcssblk_direct_access(dev_info, secnum * 512, kaddr, pfn,
-			size);
-}
-
-static long
 dcssblk_dax_direct_access(struct dax_inode *dax_inode, phys_addr_t dev_addr,
 			void **kaddr, pfn_t *pfn, long size)
 {
diff --git a/fs/block_dev.c b/fs/block_dev.c
index a73f2388c515..ba0252736950 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -719,51 +719,6 @@ int bdev_write_page(struct block_device *bdev, sector_t sector,
 EXPORT_SYMBOL_GPL(bdev_write_page);
 
 /**
- * bdev_direct_access() - Get the address for directly-accessibly memory
- * @bdev: The device containing the memory
- * @dax: control and output parameters for ->direct_access
- *
- * If a block device is made up of directly addressable memory, this function
- * will tell the caller the PFN and the address of the memory.  The address
- * may be directly dereferenced within the kernel without the need to call
- * ioremap(), kmap() or similar.  The PFN is suitable for inserting into
- * page tables.
- *
- * Return: negative errno if an error occurs, otherwise the number of bytes
- * accessible at this address.
- */
-long bdev_direct_access(struct block_device *bdev, struct blk_dax_ctl *dax)
-{
-	sector_t sector = dax->sector;
-	long avail, size = dax->size;
-	const struct block_device_operations *ops = bdev->bd_disk->fops;
-
-	/*
-	 * The device driver is allowed to sleep, in order to make the
-	 * memory directly accessible.
-	 */
-	might_sleep();
-
-	if (size < 0)
-		return size;
-	if (!blk_queue_dax(bdev_get_queue(bdev)) || !ops->direct_access)
-		return -EOPNOTSUPP;
-	if ((sector + DIV_ROUND_UP(size, 512)) >
-					part_nr_sects_read(bdev->bd_part))
-		return -ERANGE;
-	sector += get_start_sect(bdev);
-	if (sector % (PAGE_SIZE / 512))
-		return -EINVAL;
-	avail = ops->direct_access(bdev, sector, &dax->addr, &dax->pfn, size);
-	if (!avail)
-		return -ERANGE;
-	if (avail > 0 && avail & ~PAGE_MASK)
-		return -ENXIO;
-	return min(avail, size);
-}
-EXPORT_SYMBOL_GPL(bdev_direct_access);
-
-/**
  * bdev_dax_direct_access() - bdev-sector to pfn_t and kernel virtual address
  * @bdev: host block device for @dax_inode
  * @dax_inode: interface data and operations for a memory device
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 3b3c5ce376fd..bb87390a29b1 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1882,8 +1882,6 @@ struct block_device_operations {
 	int (*rw_page)(struct block_device *, sector_t, struct page *, bool);
 	int (*ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
 	int (*compat_ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
-	long (*direct_access)(struct block_device *, sector_t, void **, pfn_t *,
-			long);
 	unsigned int (*check_events) (struct gendisk *disk,
 				      unsigned int clearing);
 	/* ->media_changed() is DEPRECATED, use ->check_events() instead */
@@ -1902,7 +1900,6 @@ extern int __blkdev_driver_ioctl(struct block_device *, fmode_t, unsigned int,
 extern int bdev_read_page(struct block_device *, sector_t, struct page *);
 extern int bdev_write_page(struct block_device *, sector_t, struct page *,
 						struct writeback_control *);
-extern long bdev_direct_access(struct block_device *, struct blk_dax_ctl *);
 struct dax_inode;
 extern long bdev_dax_direct_access(struct block_device *bdev,
 		struct dax_inode *dax_inode, struct blk_dax_ctl *dax);
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 1b64f412bb45..6e8762f093d3 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -125,14 +125,6 @@ typedef void (*dm_io_hints_fn) (struct dm_target *ti,
  */
 typedef int (*dm_busy_fn) (struct dm_target *ti);
 
-/*
- * Returns:
- *  < 0 : error
- * >= 0 : the number of bytes accessible at the address
- */
-typedef long (*dm_direct_access_fn) (struct dm_target *ti, sector_t sector,
-				     void **kaddr, pfn_t *pfn, long size);
-
 void dm_error(const char *message);
 
 struct dm_dev {
@@ -185,7 +177,6 @@ struct target_type {
 	dm_busy_fn busy;
 	dm_iterate_devices_fn iterate_devices;
 	dm_io_hints_fn io_hints;
-	dm_direct_access_fn direct_access;
 	const struct dm_dax_operations *dax_ops;
 
 	/* For internal device-mapper use. */

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
