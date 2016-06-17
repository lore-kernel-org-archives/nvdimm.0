Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by ml01.01.org (Postfix) with ESMTP id 7933F1A1E40
 for <linux-nvdimm@lists.01.org>; Fri, 17 Jun 2016 09:35:56 -0700 (PDT)
Subject: [PATCH v3 2/3] block: convert to device_add_disk()
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 17 Jun 2016 09:34:44 -0700
Message-ID: <146618128465.31030.12159307386730181867.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146618127395.31030.11800447312061202344.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146618127395.31030.11800447312061202344.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-block@vger.kernel.org
Cc: axboe@fb.com, Ulf Hansson <ulf.hansson@linaro.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Michael S. Tsirkin" <mst@redhat.com>, David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-nvdimm@lists.01.org, Keith Busch <keith.busch@intel.com>, "David S. Miller" <davem@davemloft.net>
List-ID: <linux-nvdimm@lists.01.org>

For block drivers that specify a parent device, convert them to use
device_add_disk().

This conversion was done with the following semantic patch:

    @@
    struct gendisk *disk;
    expression E;
    @@

    - disk->driverfs_dev = E;
    ...
    - add_disk(disk);
    + device_add_disk(E, disk);

    @@
    struct gendisk *disk;
    expression E1, E2;
    @@

    - disk->driverfs_dev = E1;
    ...
    E2 = disk;
    ...
    - add_disk(E2);
    + device_add_disk(E1, E2);

...plus some manual fixups for a few missed conversions.

Cc: Jens Axboe <axboe@fb.com>
Cc: Keith Busch <keith.busch@intel.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/powerpc/sysdev/axonram.c       |    3 +--
 arch/um/drivers/ubd_kern.c          |    3 +--
 drivers/block/cciss.c               |    3 +--
 drivers/block/floppy.c              |    3 +--
 drivers/block/mtip32xx/mtip32xx.c   |    5 ++---
 drivers/block/ps3disk.c             |    3 +--
 drivers/block/ps3vram.c             |    3 +--
 drivers/block/rsxx/dev.c            |    4 +---
 drivers/block/skd_main.c            |    8 +++-----
 drivers/block/sunvdc.c              |    3 +--
 drivers/block/virtio_blk.c          |    3 +--
 drivers/block/xen-blkfront.c        |    3 +--
 drivers/ide/ide-cd.c                |    3 +--
 drivers/ide/ide-gd.c                |    3 +--
 drivers/memstick/core/ms_block.c    |    3 +--
 drivers/memstick/core/mspro_block.c |    3 +--
 drivers/mmc/card/block.c            |    3 +--
 drivers/mtd/mtd_blkdevs.c           |    4 +---
 drivers/nvdimm/blk.c                |    3 +--
 drivers/nvdimm/btt.c                |    3 +--
 drivers/nvdimm/pmem.c               |    3 +--
 drivers/nvme/host/core.c            |    3 +--
 drivers/s390/block/dasd_genhd.c     |    3 +--
 drivers/s390/block/dcssblk.c        |    3 +--
 drivers/s390/block/scm_blk.c        |    3 +--
 drivers/scsi/sd.c                   |    3 +--
 drivers/scsi/sr.c                   |    3 +--
 27 files changed, 30 insertions(+), 60 deletions(-)

diff --git a/arch/powerpc/sysdev/axonram.c b/arch/powerpc/sysdev/axonram.c
index ff75d70f7285..f9af6461521a 100644
--- a/arch/powerpc/sysdev/axonram.c
+++ b/arch/powerpc/sysdev/axonram.c
@@ -223,7 +223,6 @@ static int axon_ram_probe(struct platform_device *device)
 	bank->disk->first_minor = azfs_minor;
 	bank->disk->fops = &axon_ram_devops;
 	bank->disk->private_data = bank;
-	bank->disk->driverfs_dev = &device->dev;
 
 	sprintf(bank->disk->disk_name, "%s%d",
 			AXON_RAM_DEVICE_NAME, axon_ram_bank_id);
@@ -238,7 +237,7 @@ static int axon_ram_probe(struct platform_device *device)
 	set_capacity(bank->disk, bank->size >> AXON_RAM_SECTOR_SHIFT);
 	blk_queue_make_request(bank->disk->queue, axon_ram_make_request);
 	blk_queue_logical_block_size(bank->disk->queue, AXON_RAM_SECTOR_SIZE);
-	add_disk(bank->disk);
+	device_add_disk(&device->dev, bank->disk);
 
 	bank->irq_id = irq_of_parse_and_map(device->dev.of_node, 0);
 	if (bank->irq_id == NO_IRQ) {
diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index ef6b4d960bad..4e7cb5df8e43 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -823,12 +823,11 @@ static int ubd_disk_register(int major, u64 size, int unit,
 		ubd_devs[unit].pdev.dev.release = ubd_device_release;
 		dev_set_drvdata(&ubd_devs[unit].pdev.dev, &ubd_devs[unit]);
 		platform_device_register(&ubd_devs[unit].pdev);
-		disk->driverfs_dev = &ubd_devs[unit].pdev.dev;
 	}
 
 	disk->private_data = &ubd_devs[unit];
 	disk->queue = ubd_devs[unit].queue;
-	add_disk(disk);
+	device_add_disk(&ubd_devs[unit].pdev.dev, disk);
 
 	*disk_out = disk;
 	return 0;
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 63c2064689f8..db9d6bb6352d 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1951,7 +1951,6 @@ static int cciss_add_disk(ctlr_info_t *h, struct gendisk *disk,
 	if (cciss_create_ld_sysfs_entry(h, drv_index))
 		goto cleanup_queue;
 	disk->private_data = h->drv[drv_index];
-	disk->driverfs_dev = &h->drv[drv_index]->dev;
 
 	/* Set up queue information */
 	blk_queue_bounce_limit(disk->queue, h->pdev->dma_mask);
@@ -1973,7 +1972,7 @@ static int cciss_add_disk(ctlr_info_t *h, struct gendisk *disk,
 	/* allows the interrupt handler to start the queue */
 	wmb();
 	h->drv[drv_index]->queue = disk->queue;
-	add_disk(disk);
+	device_add_disk(&h->drv[drv_index]->dev, disk);
 	return 0;
 
 cleanup_queue:
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index f9bfecd733a8..c557057fe8ae 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4350,8 +4350,7 @@ static int __init do_floppy_init(void)
 		/* to be cleaned up... */
 		disks[drive]->private_data = (void *)(long)drive;
 		disks[drive]->flags |= GENHD_FL_REMOVABLE;
-		disks[drive]->driverfs_dev = &floppy_device[drive].dev;
-		add_disk(disks[drive]);
+		device_add_disk(&floppy_device[drive].dev, disks[drive]);
 	}
 
 	return 0;
diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 8e3e708cb9ee..2aca98e8e427 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -3956,7 +3956,6 @@ static int mtip_block_initialize(struct driver_data *dd)
 	if (rv)
 		goto disk_index_error;
 
-	dd->disk->driverfs_dev	= &dd->pdev->dev;
 	dd->disk->major		= dd->major;
 	dd->disk->first_minor	= index * MTIP_MAX_MINORS;
 	dd->disk->minors 	= MTIP_MAX_MINORS;
@@ -4008,7 +4007,7 @@ skip_create_disk:
 
 	/*
 	 * if rebuild pending, start the service thread, and delay the block
-	 * queue creation and add_disk()
+	 * queue creation and device_add_disk()
 	 */
 	if (wait_for_rebuild == MTIP_FTL_REBUILD_MAGIC)
 		goto start_service_thread;
@@ -4042,7 +4041,7 @@ skip_create_disk:
 	set_capacity(dd->disk, capacity);
 
 	/* Enable the block device and add it to /dev */
-	add_disk(dd->disk);
+	device_add_disk(&dd->pdev->dev, dd->disk);
 
 	dd->bdev = bdget_disk(dd->disk, 0);
 	/*
diff --git a/drivers/block/ps3disk.c b/drivers/block/ps3disk.c
index acb44529c05e..76f33c84ce3d 100644
--- a/drivers/block/ps3disk.c
+++ b/drivers/block/ps3disk.c
@@ -487,7 +487,6 @@ static int ps3disk_probe(struct ps3_system_bus_device *_dev)
 	gendisk->fops = &ps3disk_fops;
 	gendisk->queue = queue;
 	gendisk->private_data = dev;
-	gendisk->driverfs_dev = &dev->sbd.core;
 	snprintf(gendisk->disk_name, sizeof(gendisk->disk_name), PS3DISK_NAME,
 		 devidx+'a');
 	priv->blocking_factor = dev->blk_size >> 9;
@@ -499,7 +498,7 @@ static int ps3disk_probe(struct ps3_system_bus_device *_dev)
 		 gendisk->disk_name, priv->model, priv->raw_capacity >> 11,
 		 get_capacity(gendisk) >> 11);
 
-	add_disk(gendisk);
+	device_add_disk(&dev->sbd.core, gendisk);
 	return 0;
 
 fail_cleanup_queue:
diff --git a/drivers/block/ps3vram.c b/drivers/block/ps3vram.c
index 56847fcda086..456b4fe21559 100644
--- a/drivers/block/ps3vram.c
+++ b/drivers/block/ps3vram.c
@@ -773,14 +773,13 @@ static int ps3vram_probe(struct ps3_system_bus_device *dev)
 	gendisk->fops = &ps3vram_fops;
 	gendisk->queue = queue;
 	gendisk->private_data = dev;
-	gendisk->driverfs_dev = &dev->core;
 	strlcpy(gendisk->disk_name, DEVICE_NAME, sizeof(gendisk->disk_name));
 	set_capacity(gendisk, priv->size >> 9);
 
 	dev_info(&dev->core, "%s: Using %lu MiB of GPU memory\n",
 		 gendisk->disk_name, get_capacity(gendisk) >> 11);
 
-	add_disk(gendisk);
+	device_add_disk(&dev->core, gendisk);
 	return 0;
 
 fail_cleanup_queue:
diff --git a/drivers/block/rsxx/dev.c b/drivers/block/rsxx/dev.c
index e1b8b7061d2f..eb41641ee952 100644
--- a/drivers/block/rsxx/dev.c
+++ b/drivers/block/rsxx/dev.c
@@ -230,8 +230,7 @@ int rsxx_attach_dev(struct rsxx_cardinfo *card)
 			set_capacity(card->gendisk, card->size8 >> 9);
 		else
 			set_capacity(card->gendisk, 0);
-		add_disk(card->gendisk);
-
+		device_add_disk(&card->dev->dev, card->gendisk);
 		card->bdev_attached = 1;
 	}
 
@@ -308,7 +307,6 @@ int rsxx_setup_dev(struct rsxx_cardinfo *card)
 
 	snprintf(card->gendisk->disk_name, sizeof(card->gendisk->disk_name),
 		 "rsxx%d", card->disk_id);
-	card->gendisk->driverfs_dev = &card->dev->dev;
 	card->gendisk->major = card->major;
 	card->gendisk->first_minor = 0;
 	card->gendisk->fops = &rsxx_fops;
diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index 5c07a23e2ada..3822eae102db 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -4690,10 +4690,10 @@ static int skd_bdev_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 	return -EIO;
 }
 
-static int skd_bdev_attach(struct skd_device *skdev)
+static int skd_bdev_attach(struct device *parent, struct skd_device *skdev)
 {
 	pr_debug("%s:%s:%d add_disk\n", skdev->name, __func__, __LINE__);
-	add_disk(skdev->disk);
+	device_add_disk(parent, skdev->disk);
 	return 0;
 }
 
@@ -4812,8 +4812,6 @@ static int skd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	pci_set_drvdata(pdev, skdev);
 
-	skdev->disk->driverfs_dev = &pdev->dev;
-
 	for (i = 0; i < SKD_MAX_BARS; i++) {
 		skdev->mem_phys[i] = pci_resource_start(pdev, i);
 		skdev->mem_size[i] = (u32)pci_resource_len(pdev, i);
@@ -4851,7 +4849,7 @@ static int skd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 					      (SKD_START_WAIT_SECONDS * HZ));
 	if (skdev->gendisk_on > 0) {
 		/* device came on-line after reset */
-		skd_bdev_attach(skdev);
+		skd_bdev_attach(&pdev->dev, skdev);
 		rc = 0;
 	} else {
 		/* we timed out, something is wrong with the device,
diff --git a/drivers/block/sunvdc.c b/drivers/block/sunvdc.c
index 4b911ed96ea3..cab157331c4e 100644
--- a/drivers/block/sunvdc.c
+++ b/drivers/block/sunvdc.c
@@ -804,7 +804,6 @@ static int probe_disk(struct vdc_port *port)
 	g->fops = &vdc_fops;
 	g->queue = q;
 	g->private_data = port;
-	g->driverfs_dev = &port->vio.vdev->dev;
 
 	set_capacity(g, port->vdisk_size);
 
@@ -835,7 +834,7 @@ static int probe_disk(struct vdc_port *port)
 	       port->vdisk_size, (port->vdisk_size >> (20 - 9)),
 	       port->vio.ver.major, port->vio.ver.minor);
 
-	add_disk(g);
+	device_add_disk(&port->vio.vdev->dev, g);
 
 	return 0;
 }
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 18e4069dd24b..5fd2e0ac2711 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -656,7 +656,6 @@ static int virtblk_probe(struct virtio_device *vdev)
 	vblk->disk->first_minor = index_to_minor(index);
 	vblk->disk->private_data = vblk;
 	vblk->disk->fops = &virtblk_fops;
-	vblk->disk->driverfs_dev = &vdev->dev;
 	vblk->disk->flags |= GENHD_FL_EXT_DEVT;
 	vblk->index = index;
 
@@ -733,7 +732,7 @@ static int virtblk_probe(struct virtio_device *vdev)
 
 	virtio_device_ready(vdev);
 
-	add_disk(vblk->disk);
+	device_add_disk(&vdev->dev, vblk->disk);
 	err = device_create_file(disk_to_dev(vblk->disk), &dev_attr_serial);
 	if (err)
 		goto out_del_disk;
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 10711292da2c..89525d10d1a7 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1137,7 +1137,6 @@ static int xlvbd_alloc_gendisk(blkif_sector_t capacity,
 	gd->first_minor = minor;
 	gd->fops = &xlvbd_block_fops;
 	gd->private_data = info;
-	gd->driverfs_dev = &(info->xbdev->dev);
 	set_capacity(gd, capacity);
 
 	if (xlvbd_init_blk_queue(gd, sector_size, physical_sector_size,
@@ -2463,7 +2462,7 @@ static void blkfront_connect(struct blkfront_info *info)
 	for (i = 0; i < info->nr_rings; i++)
 		kick_pending_request_queues(&info->rinfo[i]);
 
-	add_disk(info->gd);
+	device_add_disk(&info->xbdev->dev, info->gd);
 
 	info->is_ready = 1;
 }
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index ef907fd5ba98..bf9a2ad296ed 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1770,7 +1770,6 @@ static int ide_cd_probe(ide_drive_t *drive)
 	drive->driver_data = info;
 
 	g->minors = 1;
-	g->driverfs_dev = &drive->gendev;
 	g->flags = GENHD_FL_CD | GENHD_FL_REMOVABLE;
 	if (ide_cdrom_setup(drive)) {
 		put_device(&info->dev);
@@ -1780,7 +1779,7 @@ static int ide_cd_probe(ide_drive_t *drive)
 	ide_cd_read_toc(drive, &sense);
 	g->fops = &idecd_ops;
 	g->flags |= GENHD_FL_REMOVABLE | GENHD_FL_BLOCK_EVENTS_ON_EXCL_WRITE;
-	add_disk(g);
+	device_add_disk(&drive->gendev, g);
 	return 0;
 
 out_free_disk:
diff --git a/drivers/ide/ide-gd.c b/drivers/ide/ide-gd.c
index 838996a0039e..e823394ed543 100644
--- a/drivers/ide/ide-gd.c
+++ b/drivers/ide/ide-gd.c
@@ -412,12 +412,11 @@ static int ide_gd_probe(ide_drive_t *drive)
 	set_capacity(g, ide_gd_capacity(drive));
 
 	g->minors = IDE_DISK_MINORS;
-	g->driverfs_dev = &drive->gendev;
 	g->flags |= GENHD_FL_EXT_DEVT;
 	if (drive->dev_flags & IDE_DFLAG_REMOVABLE)
 		g->flags = GENHD_FL_REMOVABLE;
 	g->fops = &ide_gd_ops;
-	add_disk(g);
+	device_add_disk(&drive->gendev, g);
 	return 0;
 
 out_free_disk:
diff --git a/drivers/memstick/core/ms_block.c b/drivers/memstick/core/ms_block.c
index 3cd68152ddf8..0fc43c7cc93c 100644
--- a/drivers/memstick/core/ms_block.c
+++ b/drivers/memstick/core/ms_block.c
@@ -2146,7 +2146,6 @@ static int msb_init_disk(struct memstick_dev *card)
 	msb->disk->fops = &msb_bdops;
 	msb->disk->private_data = msb;
 	msb->disk->queue = msb->queue;
-	msb->disk->driverfs_dev = &card->dev;
 	msb->disk->flags |= GENHD_FL_EXT_DEVT;
 
 	capacity = msb->pages_in_block * msb->logical_block_count;
@@ -2163,7 +2162,7 @@ static int msb_init_disk(struct memstick_dev *card)
 		set_disk_ro(msb->disk, 1);
 
 	msb_start(card);
-	add_disk(msb->disk);
+	device_add_disk(&card->dev, msb->disk);
 	dbg("Disk added");
 	return 0;
 
diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index 0fb27d338811..25b66c540457 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -1243,7 +1243,6 @@ static int mspro_block_init_disk(struct memstick_dev *card)
 	msb->usage_count = 1;
 	msb->disk->private_data = msb;
 	msb->disk->queue = msb->queue;
-	msb->disk->driverfs_dev = &card->dev;
 
 	sprintf(msb->disk->disk_name, "mspblk%d", disk_id);
 
@@ -1255,7 +1254,7 @@ static int mspro_block_init_disk(struct memstick_dev *card)
 	set_capacity(msb->disk, capacity);
 	dev_dbg(&card->dev, "capacity set %ld\n", capacity);
 
-	add_disk(msb->disk);
+	device_add_disk(&card->dev, msb->disk);
 	msb->active = 1;
 	return 0;
 
diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 383184743f9a..6df54cca7dcc 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -2270,7 +2270,6 @@ again:
 	md->disk->fops = &mmc_bdops;
 	md->disk->private_data = md;
 	md->disk->queue = md->queue.queue;
-	md->disk->driverfs_dev = parent;
 	set_disk_ro(md->disk, md->read_only || default_ro);
 	md->disk->flags = GENHD_FL_EXT_DEVT;
 	if (area_type & (MMC_BLK_DATA_AREA_RPMB | MMC_BLK_DATA_AREA_BOOT))
@@ -2458,7 +2457,7 @@ static int mmc_add_disk(struct mmc_blk_data *md)
 	int ret;
 	struct mmc_card *card = md->queue.card;
 
-	add_disk(md->disk);
+	device_add_disk(&card->dev, md->disk);
 	md->force_ro.show = force_ro_show;
 	md->force_ro.store = force_ro_store;
 	sysfs_attr_init(&md->force_ro.attr);
diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index 78b3eb45faf6..8d58acf33021 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -431,12 +431,10 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
 		goto error4;
 	INIT_WORK(&new->work, mtd_blktrans_work);
 
-	gd->driverfs_dev = &new->mtd->dev;
-
 	if (new->readonly)
 		set_disk_ro(gd, 1);
 
-	add_disk(gd);
+	device_add_disk(&new->mtd->dev, gd);
 
 	if (new->disk_attributes) {
 		ret = sysfs_create_group(&disk_to_dev(gd)->kobj,
diff --git a/drivers/nvdimm/blk.c b/drivers/nvdimm/blk.c
index 495e06d9f7e7..7e262ef06ede 100644
--- a/drivers/nvdimm/blk.c
+++ b/drivers/nvdimm/blk.c
@@ -287,14 +287,13 @@ static int nsblk_attach_disk(struct nd_namespace_blk *nsblk)
 		return -ENOMEM;
 	}
 
-	disk->driverfs_dev	= dev;
 	disk->first_minor	= 0;
 	disk->fops		= &nd_blk_fops;
 	disk->queue		= q;
 	disk->flags		= GENHD_FL_EXT_DEVT;
 	nvdimm_namespace_disk_name(&nsblk->common, disk->disk_name);
 	set_capacity(disk, 0);
-	add_disk(disk);
+	device_add_disk(dev, disk);
 
 	if (nsblk_meta_size(nsblk)) {
 		int rc = nd_integrity_init(disk, nsblk_meta_size(nsblk));
diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 68a7c3c1eed9..9dce03f420eb 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1243,7 +1243,6 @@ static int btt_blk_init(struct btt *btt)
 	}
 
 	nvdimm_namespace_disk_name(ndns, btt->btt_disk->disk_name);
-	btt->btt_disk->driverfs_dev = &btt->nd_btt->dev;
 	btt->btt_disk->first_minor = 0;
 	btt->btt_disk->fops = &btt_fops;
 	btt->btt_disk->private_data = btt;
@@ -1258,7 +1257,7 @@ static int btt_blk_init(struct btt *btt)
 	btt->btt_queue->queuedata = btt;
 
 	set_capacity(btt->btt_disk, 0);
-	add_disk(btt->btt_disk);
+	device_add_disk(&btt->nd_btt->dev, btt->btt_disk);
 	if (btt_meta_size(btt)) {
 		int rc = nd_integrity_init(btt->btt_disk, btt_meta_size(btt));
 
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 608fc4464574..066e07d9330f 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -297,14 +297,13 @@ static int pmem_attach_disk(struct device *dev,
 	disk->queue		= q;
 	disk->flags		= GENHD_FL_EXT_DEVT;
 	nvdimm_namespace_disk_name(ndns, disk->disk_name);
-	disk->driverfs_dev = dev;
 	set_capacity(disk, (pmem->size - pmem->pfn_pad - pmem->data_offset)
 			/ 512);
 	if (devm_init_badblocks(dev, &pmem->bb))
 		return -ENOMEM;
 	nvdimm_badblocks_populate(to_nd_region(dev->parent), &pmem->bb, res);
 	disk->bb = &pmem->bb;
-	add_disk(disk);
+	device_add_disk(dev, disk);
 	revalidate_disk(disk);
 
 	return 0;
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 9d7cee463fd6..959173bfe9f0 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1480,7 +1480,6 @@ static void nvme_alloc_ns(struct nvme_ctrl *ctrl, unsigned nsid)
 	disk->fops = &nvme_fops;
 	disk->private_data = ns;
 	disk->queue = ns->queue;
-	disk->driverfs_dev = ctrl->device;
 	disk->flags = GENHD_FL_EXT_DEVT;
 	sprintf(disk->disk_name, "nvme%dn%d", ctrl->instance, ns->instance);
 
@@ -1492,7 +1491,7 @@ static void nvme_alloc_ns(struct nvme_ctrl *ctrl, unsigned nsid)
 	if (ns->type == NVME_NS_LIGHTNVM)
 		return;
 
-	add_disk(ns->disk);
+	device_add_disk(ctrl->device, ns->disk);
 	if (sysfs_create_group(&disk_to_dev(ns->disk)->kobj,
 					&nvme_ns_attr_group))
 		pr_warn("%s: failed to create sysfs group for identification\n",
diff --git a/drivers/s390/block/dasd_genhd.c b/drivers/s390/block/dasd_genhd.c
index 31d544a87ba9..e2fa759bf2ad 100644
--- a/drivers/s390/block/dasd_genhd.c
+++ b/drivers/s390/block/dasd_genhd.c
@@ -45,7 +45,6 @@ int dasd_gendisk_alloc(struct dasd_block *block)
 	gdp->major = DASD_MAJOR;
 	gdp->first_minor = base->devindex << DASD_PARTN_BITS;
 	gdp->fops = &dasd_device_operations;
-	gdp->driverfs_dev = &base->cdev->dev;
 
 	/*
 	 * Set device name.
@@ -76,7 +75,7 @@ int dasd_gendisk_alloc(struct dasd_block *block)
 	gdp->queue = block->request_queue;
 	block->gdp = gdp;
 	set_capacity(block->gdp, 0);
-	add_disk(block->gdp);
+	device_add_disk(&base->cdev->dev, block->gdp);
 	return 0;
 }
 
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index bed53c46dd90..2f056b2662f6 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -615,7 +615,6 @@ dcssblk_add_store(struct device *dev, struct device_attribute *attr, const char
 	dev_info->dcssblk_queue = blk_alloc_queue(GFP_KERNEL);
 	dev_info->gd->queue = dev_info->dcssblk_queue;
 	dev_info->gd->private_data = dev_info;
-	dev_info->gd->driverfs_dev = &dev_info->dev;
 	blk_queue_make_request(dev_info->dcssblk_queue, dcssblk_make_request);
 	blk_queue_logical_block_size(dev_info->dcssblk_queue, 4096);
 
@@ -655,7 +654,7 @@ dcssblk_add_store(struct device *dev, struct device_attribute *attr, const char
 		goto put_dev;
 
 	get_device(&dev_info->dev);
-	add_disk(dev_info->gd);
+	device_add_disk(&dev_info->dev, dev_info->gd);
 
 	switch (dev_info->segment_type) {
 		case SEG_TYPE_SR:
diff --git a/drivers/s390/block/scm_blk.c b/drivers/s390/block/scm_blk.c
index e6f54d3b8969..9f16ea6964ec 100644
--- a/drivers/s390/block/scm_blk.c
+++ b/drivers/s390/block/scm_blk.c
@@ -512,7 +512,6 @@ int scm_blk_dev_setup(struct scm_blk_dev *bdev, struct scm_device *scmdev)
 		goto out_queue;
 
 	rq->queuedata = scmdev;
-	bdev->gendisk->driverfs_dev = &scmdev->dev;
 	bdev->gendisk->private_data = scmdev;
 	bdev->gendisk->fops = &scm_blk_devops;
 	bdev->gendisk->queue = rq;
@@ -531,7 +530,7 @@ int scm_blk_dev_setup(struct scm_blk_dev *bdev, struct scm_device *scmdev)
 
 	/* 512 byte sectors */
 	set_capacity(bdev->gendisk, scmdev->size >> 9);
-	add_disk(bdev->gendisk);
+	device_add_disk(&scmdev->dev, bdev->gendisk);
 	return 0;
 
 out_queue:
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 5a9db0fe1ee0..c830eb69ba50 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2994,7 +2994,6 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 
 	sd_revalidate_disk(gd);
 
-	gd->driverfs_dev = &sdp->sdev_gendev;
 	gd->flags = GENHD_FL_EXT_DEVT;
 	if (sdp->removable) {
 		gd->flags |= GENHD_FL_REMOVABLE;
@@ -3002,7 +3001,7 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 	}
 
 	blk_pm_runtime_init(sdp->request_queue, dev);
-	add_disk(gd);
+	device_add_disk(&sdp->sdev_gendev, gd);
 	if (sdkp->capacity)
 		sd_dif_config_host(sdkp);
 
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 64c867405ad4..ed179348de80 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -713,7 +713,6 @@ static int sr_probe(struct device *dev)
 	get_capabilities(cd);
 	sr_vendor_init(cd);
 
-	disk->driverfs_dev = &sdev->sdev_gendev;
 	set_capacity(disk, cd->capacity);
 	disk->private_data = &cd->driver;
 	disk->queue = sdev->request_queue;
@@ -730,7 +729,7 @@ static int sr_probe(struct device *dev)
 
 	dev_set_drvdata(dev, cd);
 	disk->flags |= GENHD_FL_REMOVABLE;
-	add_disk(disk);
+	device_add_disk(&sdev->sdev_gendev, disk);
 
 	sdev_printk(KERN_DEBUG, sdev,
 		    "Attached scsi CD-ROM %s\n", cd->cdi.name);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
