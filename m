Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH 21/21] nd_blk: nfit blk driver
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 17 Apr 2015 21:37:06 -0400
Message-ID: <20150418013706.25237.474.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: Boaz Harrosh <boaz@plexistor.com>, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Jens Axboe <axboe@fb.com>, "H. Peter Anvin" <hpa@zytor.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

From: Ross Zwisler <ross.zwisler@linux.intel.com>

Block-device driver for BLK namespaces described by DCR (dimm control
region), BDW (block data window), and IDT (interleave descriptor) NFIT
structures.

The BIOS may choose to interleave multiple dimms into a given SPA
(system physical address) range, so this driver includes core nd
infrastructure for multiplexing multiple BLK namespace devices on a
single request_mem_region() + ioremap() mapping.  Note, the math and
table walking to de-interleave the memory space on each I/O may prove to
be too computationally expensive, in which case we would look to replace
it with a flat lookup implementation.

A new nd core api nd_blk_validate_namespace() is introduced to check
that the labels on the DIMM are in sync with the current set of
dpa-resources assigned to the namespace.  nd_blk_validate_namespace()
prevents enabling the namespace when they are out of sync.  Userspace
can retry the writing the labels in that scenario.

Finally, enable testing of the BLK namespace infrastructure via
nfit_test.  Provide a mock implementations of  nd_blk_do_io() to route
block-data-window accesses to an nfit_test allocation simulating BLK
storage.

Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Boaz Harrosh <boaz@plexistor.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jens Axboe <axboe@fb.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/block/nd/Kconfig          |   19 ++
 drivers/block/nd/Makefile         |    3 
 drivers/block/nd/blk.c            |  269 ++++++++++++++++++++++++++++++++
 drivers/block/nd/core.c           |   57 ++++++-
 drivers/block/nd/namespace_devs.c |   47 ++++++
 drivers/block/nd/nd-private.h     |   24 +++
 drivers/block/nd/nd.h             |   51 ++++++
 drivers/block/nd/region.c         |   11 +
 drivers/block/nd/region_devs.c    |  314 ++++++++++++++++++++++++++++++++++++-
 drivers/block/nd/test/iomap.c     |   53 ++++++
 drivers/block/nd/test/nfit.c      |    3 
 drivers/block/nd/test/nfit_test.h |   14 ++
 12 files changed, 851 insertions(+), 14 deletions(-)
 create mode 100644 drivers/block/nd/blk.c

diff --git a/drivers/block/nd/Kconfig b/drivers/block/nd/Kconfig
index 29d9f8e4eedb..72580cb0e39c 100644
--- a/drivers/block/nd/Kconfig
+++ b/drivers/block/nd/Kconfig
@@ -70,6 +70,9 @@ config NFIT_TEST
 	  load.  Kconfig does not allow for numerical value
 	  dependencies, so we can only warn at runtime.
 
+	  Enabling this option will degrade the performance of other BLK
+	  namespaces.  Do not enable for production environments.
+
 	  Say N unless you are doing development of the 'nd' subsystem.
 
 config BLK_DEV_PMEM
@@ -89,6 +92,22 @@ config BLK_DEV_PMEM
 
 	  Say Y if you want to use a NVDIMM described by NFIT
 
+config ND_BLK
+	tristate "BLK: Block data window (aperture) device support"
+	depends on ND_CORE
+	default ND_CORE
+	help
+	  This driver performs I/O using a set of DCR/BDW defined
+	  apertures.  The set of apertures will all access the one
+	  DIMM.  Multiple windows allow multiple concurrent accesses,
+	  much like tagged-command-queuing, and would likely be used
+	  by different threads or different CPUs.
+
+	  The NFIT specification defines a standard format for a Block
+	  Data Window.
+
+	  Say Y if you want to use a NVDIMM described by NFIT
+
 config ND_BTT_DEVS
 	bool
 
diff --git a/drivers/block/nd/Makefile b/drivers/block/nd/Makefile
index 2dc1ab6fdef2..df104f2123a4 100644
--- a/drivers/block/nd/Makefile
+++ b/drivers/block/nd/Makefile
@@ -12,12 +12,14 @@ ldflags-y += --wrap=ioremap_nocache
 ldflags-y += --wrap=iounmap
 ldflags-y += --wrap=__request_region
 ldflags-y += --wrap=__release_region
+ldflags-y += --wrap=nd_blk_do_io
 endif
 
 obj-$(CONFIG_ND_CORE) += nd.o
 obj-$(CONFIG_NFIT_ACPI) += nd_acpi.o
 obj-$(CONFIG_BLK_DEV_PMEM) += nd_pmem.o
 obj-$(CONFIG_ND_BTT) += nd_btt.o
+obj-$(CONFIG_ND_BLK) += nd_blk.o
 
 nd_acpi-y := acpi.o
 
@@ -34,3 +36,4 @@ nd-$(CONFIG_ND_BTT_DEVS) += btt_devs.o
 
 nd_pmem-y := pmem.o
 nd_btt-y := btt.o
+nd_blk-y := blk.o
diff --git a/drivers/block/nd/blk.c b/drivers/block/nd/blk.c
new file mode 100644
index 000000000000..9e32ae610d15
--- /dev/null
+++ b/drivers/block/nd/blk.c
@@ -0,0 +1,269 @@
+/*
+ * NVDIMM Block Window Driver
+ * Copyright (c) 2014, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#include <linux/blkdev.h>
+#include <linux/fs.h>
+#include <linux/genhd.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/nd.h>
+#include <linux/sizes.h>
+#include "nd.h"
+
+struct nd_blk_device {
+	struct request_queue *queue;
+	struct gendisk *disk;
+	struct nd_namespace_blk *nsblk;
+	struct nd_blk_window *ndbw;
+	struct nd_io ndio;
+	size_t disk_size;
+	int id;
+};
+
+static int nd_blk_major;
+static DEFINE_IDA(nd_blk_ida);
+
+static resource_size_t to_dev_offset(struct nd_namespace_blk *nsblk,
+				resource_size_t ns_offset, unsigned int len)
+{
+	int i;
+
+	for (i = 0; i < nsblk->num_resources; i++) {
+		if (ns_offset < resource_size(nsblk->res[i])) {
+			if (ns_offset + len > resource_size(nsblk->res[i])) {
+				dev_WARN_ONCE(&nsblk->dev, 1,
+					"%s: illegal request\n", __func__);
+				return SIZE_MAX;
+			}
+			return nsblk->res[i]->start + ns_offset;
+		}
+		ns_offset -= resource_size(nsblk->res[i]);
+	}
+
+	dev_WARN_ONCE(&nsblk->dev, 1, "%s: request out of range\n", __func__);
+	return SIZE_MAX;
+}
+
+static void nd_blk_make_request(struct request_queue *q, struct bio *bio)
+{
+	struct block_device *bdev = bio->bi_bdev;
+	struct gendisk *disk = bdev->bd_disk;
+	struct nd_namespace_blk *nsblk;
+	struct nd_blk_device *blk_dev;
+	struct nd_blk_window *ndbw;
+	struct bvec_iter iter;
+	struct bio_vec bvec;
+	int err = 0, rw;
+	sector_t sector;
+
+	sector = bio->bi_iter.bi_sector;
+	if (bio_end_sector(bio) > get_capacity(disk)) {
+		err = -EIO;
+		goto out;
+	}
+
+	BUG_ON(bio->bi_rw & REQ_DISCARD);
+
+	rw = bio_data_dir(bio);
+
+	blk_dev = disk->private_data;
+	nsblk = blk_dev->nsblk;
+	ndbw = blk_dev->ndbw;
+	bio_for_each_segment(bvec, bio, iter) {
+		unsigned int len = bvec.bv_len;
+		resource_size_t	dev_offset;
+		void *iobuf;
+
+		BUG_ON(len > PAGE_SIZE);
+
+		dev_offset = to_dev_offset(nsblk, sector << SECTOR_SHIFT, len);
+		if (dev_offset == SIZE_MAX) {
+			err = -EIO;
+			goto out;
+		}
+
+		iobuf = kmap_atomic(bvec.bv_page);
+		err = nd_blk_do_io(ndbw, iobuf + bvec.bv_offset, len, rw,
+				dev_offset);
+		kunmap_atomic(iobuf);
+		if (err)
+			goto out;
+
+		sector += len >> SECTOR_SHIFT;
+	}
+
+ out:
+	bio_endio(bio, err);
+}
+
+static int nd_blk_rw_bytes(struct nd_io *ndio, void *iobuf, size_t offset,
+		size_t n, unsigned long flags)
+{
+	struct nd_namespace_blk *nsblk;
+	struct nd_blk_device *blk_dev;
+	int rw = nd_data_dir(flags);
+	struct nd_blk_window *ndbw;
+	resource_size_t	dev_offset;
+
+	blk_dev = container_of(ndio, typeof(*blk_dev), ndio);
+	ndbw = blk_dev->ndbw;
+	nsblk = blk_dev->nsblk;
+	dev_offset = to_dev_offset(nsblk, offset, n);
+
+	if (unlikely(offset + n > blk_dev->disk_size)) {
+		dev_WARN_ONCE(ndio->dev, 1, "%s: request out of range\n",
+				__func__);
+		return -EFAULT;
+	}
+
+	if (dev_offset == SIZE_MAX)
+		return -EIO;
+
+	return nd_blk_do_io(ndbw, iobuf, n, rw, dev_offset);
+}
+
+static const struct block_device_operations nd_blk_fops = {
+	.owner =		THIS_MODULE,
+};
+
+static int nd_blk_probe(struct device *dev)
+{
+	struct nd_namespace_blk *nsblk = to_nd_namespace_blk(dev);
+	struct nd_blk_device *blk_dev;
+	resource_size_t disk_size;
+	struct gendisk *disk;
+	int err;
+
+	disk_size = nd_namespace_blk_validate(nsblk);
+	if (disk_size < ND_MIN_NAMESPACE_SIZE)
+		return -ENXIO;
+
+	blk_dev = kzalloc(sizeof(*blk_dev), GFP_KERNEL);
+	if (!blk_dev)
+		return -ENOMEM;
+
+	blk_dev->id = ida_simple_get(&nd_blk_ida, 0, 0, GFP_KERNEL);
+	if (blk_dev->id < 0) {
+		err = blk_dev->id;
+		goto err_ida;
+	}
+
+	blk_dev->disk_size	= disk_size;
+
+	blk_dev->queue = blk_alloc_queue(GFP_KERNEL);
+	if (!blk_dev->queue) {
+		err = -ENOMEM;
+		goto err_alloc_queue;
+	}
+
+	blk_queue_make_request(blk_dev->queue, nd_blk_make_request);
+	blk_queue_max_hw_sectors(blk_dev->queue, 1024);
+	blk_queue_bounce_limit(blk_dev->queue, BLK_BOUNCE_ANY);
+
+	disk = blk_dev->disk = alloc_disk(0);
+	if (!disk) {
+		err = -ENOMEM;
+		goto err_alloc_disk;
+	}
+
+	blk_dev->ndbw = &to_nd_region(nsblk->dev.parent)->bw;
+	blk_dev->nsblk = nsblk;
+
+	disk->driverfs_dev	= dev;
+	disk->major		= nd_blk_major;
+	disk->first_minor	= 0;
+	disk->fops		= &nd_blk_fops;
+	disk->private_data	= blk_dev;
+	disk->queue		= blk_dev->queue;
+	disk->flags		= GENHD_FL_EXT_DEVT;
+	sprintf(disk->disk_name, "nd%d", blk_dev->id);
+	set_capacity(disk, disk_size >> SECTOR_SHIFT);
+
+	nd_bus_lock(dev);
+	dev_set_drvdata(dev, blk_dev);
+
+	add_disk(disk);
+	nd_init_ndio(&blk_dev->ndio, nd_blk_rw_bytes, dev, disk, 0);
+	nd_register_ndio(&blk_dev->ndio);
+	nd_bus_unlock(dev);
+
+	return 0;
+
+ err_alloc_disk:
+	blk_cleanup_queue(blk_dev->queue);
+ err_alloc_queue:
+	ida_simple_remove(&nd_blk_ida, blk_dev->id);
+ err_ida:
+	kfree(blk_dev);
+	return err;
+}
+
+static int nd_blk_remove(struct device *dev)
+{
+	/* FIXME: eventually need to get to nd_blk_device from struct device.
+	struct nd_namespace_io *nsio = to_nd_namespace_io(dev); */
+
+	struct nd_blk_device *blk_dev = dev_get_drvdata(dev);
+
+	nd_unregister_ndio(&blk_dev->ndio);
+	del_gendisk(blk_dev->disk);
+	put_disk(blk_dev->disk);
+	blk_cleanup_queue(blk_dev->queue);
+	ida_simple_remove(&nd_blk_ida, blk_dev->id);
+	kfree(blk_dev);
+
+	return 0;
+}
+
+static struct nd_device_driver nd_blk_driver = {
+	.probe = nd_blk_probe,
+	.remove = nd_blk_remove,
+	.drv = {
+		.name = "nd_blk",
+	},
+	.type = ND_DRIVER_NAMESPACE_BLOCK,
+};
+
+static int __init nd_blk_init(void)
+{
+	int rc;
+
+	rc = nfit_test_blk_init();
+	if (rc)
+		return rc;
+
+	rc = register_blkdev(0, "nd_blk");
+	if (rc < 0)
+		return rc;
+
+	nd_blk_major = rc;
+	rc = nd_driver_register(&nd_blk_driver);
+
+	if (rc < 0)
+		unregister_blkdev(nd_blk_major, "nd_blk");
+
+	return rc;
+}
+
+static void __exit nd_blk_exit(void)
+{
+	driver_unregister(&nd_blk_driver.drv);
+	unregister_blkdev(nd_blk_major, "nd_blk");
+}
+
+MODULE_AUTHOR("Ross Zwisler <ross.zwisler@linux.intel.com>");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS_ND_DEVICE(ND_DEVICE_NAMESPACE_BLOCK);
+module_init(nd_blk_init);
+module_exit(nd_blk_exit);
diff --git a/drivers/block/nd/core.c b/drivers/block/nd/core.c
index 065ab9b5ec61..43ced72f8676 100644
--- a/drivers/block/nd/core.c
+++ b/drivers/block/nd/core.c
@@ -159,6 +159,7 @@ static void nd_bus_release(struct device *dev)
 	struct nd_mem *nd_mem, *_mem;
 	struct nd_dcr *nd_dcr, *_dcr;
 	struct nd_bdw *nd_bdw, *_bdw;
+	struct nd_idt *nd_idt, *_idt;
 
 	list_for_each_entry_safe(nd_spa, _spa, &nd_bus->spas, list) {
 		list_del_init(&nd_spa->list);
@@ -177,6 +178,10 @@ static void nd_bus_release(struct device *dev)
 		list_del_init(&nd_memdev->list);
 		kfree(nd_memdev);
 	}
+	list_for_each_entry_safe(nd_idt, _idt, &nd_bus->idts, list) {
+		list_del_init(&nd_idt->list);
+		kfree(nd_idt);
+	}
 	list_for_each_entry_safe(nd_mem, _mem, &nd_bus->dimms, list) {
 		list_del_init(&nd_mem->list);
 		kfree(nd_mem);
@@ -427,7 +432,9 @@ static void *nd_bus_new(struct device *parent,
 		return NULL;
 	INIT_LIST_HEAD(&nd_bus->spas);
 	INIT_LIST_HEAD(&nd_bus->dcrs);
+	INIT_LIST_HEAD(&nd_bus->idts);
 	INIT_LIST_HEAD(&nd_bus->bdws);
+	INIT_LIST_HEAD(&nd_bus->spa_maps);
 	INIT_LIST_HEAD(&nd_bus->memdevs);
 	INIT_LIST_HEAD(&nd_bus->dimms);
 	INIT_LIST_HEAD(&nd_bus->ndios);
@@ -436,6 +443,7 @@ static void *nd_bus_new(struct device *parent,
 	INIT_RADIX_TREE(&nd_bus->dimm_radix, GFP_KERNEL);
 	nd_bus->id = ida_simple_get(&nd_ida, 0, 0, GFP_KERNEL);
 	mutex_init(&nd_bus->reconfig_mutex);
+	mutex_init(&nd_bus->spa_map_mutex);
 	if (nd_bus->id < 0) {
 		kfree(nd_bus);
 		return NULL;
@@ -574,10 +582,21 @@ static void __iomem *add_table(struct nd_bus *nd_bus, void __iomem *table,
 				readw(&nfit_bdw->num_bdw));
 		break;
 	}
-	/* TODO */
-	case NFIT_TABLE_IDT:
-		dev_dbg(&nd_bus->dev, "%s: idt\n", __func__);
+	case NFIT_TABLE_IDT: {
+		struct nd_idt *nd_idt = kzalloc(sizeof(*nd_idt), GFP_KERNEL);
+		struct nfit_idt __iomem *nfit_idt = table;
+
+		if (!nd_idt)
+			goto err;
+		INIT_LIST_HEAD(&nd_idt->list);
+		nd_idt->nfit_idt = nfit_idt;
+		list_add_tail(&nd_idt->list, &nd_bus->idts);
+		dev_dbg(&nd_bus->dev, "%s: idt index: %d num_lines: %d\n", __func__,
+				readw(&nfit_idt->idt_index),
+				readl(&nfit_idt->num_lines));
 		break;
+	}
+	/* TODO */
 	case NFIT_TABLE_FLUSH:
 		dev_dbg(&nd_bus->dev, "%s: flush\n", __func__);
 		break;
@@ -632,8 +651,11 @@ static void nd_mem_add(struct nd_bus *nd_bus, struct nd_mem *nd_mem)
 {
 	u16 dcr_index = readw(&nd_mem->nfit_mem_dcr->dcr_index);
 	u16 spa_index = readw(&nd_mem->nfit_spa_dcr->spa_index);
+	struct nd_memdev *nd_memdev;
 	struct nd_dcr *nd_dcr;
 	struct nd_bdw *nd_bdw;
+	struct nd_idt *nd_idt;
+	u16 idt_index;
 
 	list_for_each_entry(nd_dcr, &nd_bus->dcrs, list) {
 		if (readw(&nd_dcr->nfit_dcr->dcr_index) != dcr_index)
@@ -667,6 +689,26 @@ static void nd_mem_add(struct nd_bus *nd_bus, struct nd_mem *nd_mem)
 		return;
 
 	nd_mem_find_spa_bdw(nd_bus, nd_mem);
+
+	if (!nd_mem->nfit_spa_bdw)
+		return;
+
+	spa_index = readw(&nd_mem->nfit_spa_bdw->spa_index);
+
+	list_for_each_entry(nd_memdev, &nd_bus->memdevs, list) {
+		if (readw(&nd_memdev->nfit_mem->spa_index) != spa_index ||
+		    readw(&nd_memdev->nfit_mem->dcr_index) != dcr_index)
+			continue;
+		nd_mem->nfit_mem_bdw = nd_memdev->nfit_mem;
+		idt_index = readw(&nd_memdev->nfit_mem->idt_index);
+		list_for_each_entry(nd_idt, &nd_bus->idts, list) {
+			if (readw(&nd_idt->nfit_idt->idt_index) != idt_index)
+				continue;
+			nd_mem->nfit_idt_bdw = nd_idt->nfit_idt;
+			break;
+		}
+		break;
+	}
 }
 
 static int nd_mem_cmp(void *priv, struct list_head *__a, struct list_head *__b)
@@ -700,7 +742,9 @@ static int nd_mem_init(struct nd_bus *nd_bus)
 		int type = nfit_spa_type(nd_spa->nfit_spa);
 		struct nd_mem *nd_mem, *found;
 		struct nd_memdev *nd_memdev;
+		struct nd_idt *nd_idt;
 		u16 dcr_index;
+		u16 idt_index;
 
 		if (type != NFIT_SPA_DCR)
 			continue;
@@ -726,6 +770,13 @@ static int nd_mem_init(struct nd_bus *nd_bus)
 			INIT_LIST_HEAD(&nd_mem->list);
 			nd_mem->nfit_spa_dcr = nd_spa->nfit_spa;
 			nd_mem->nfit_mem_dcr = nd_memdev->nfit_mem;
+			idt_index = readw(&nd_memdev->nfit_mem->idt_index);
+			list_for_each_entry(nd_idt, &nd_bus->idts, list) {
+				if (readw(&nd_idt->nfit_idt->idt_index) != idt_index)
+					continue;
+				nd_mem->nfit_idt_dcr = nd_idt->nfit_idt;
+				break;
+			}
 			nd_mem_add(nd_bus, nd_mem);
 		}
 	}
diff --git a/drivers/block/nd/namespace_devs.c b/drivers/block/nd/namespace_devs.c
index 8414ca21917d..3e0eb585119c 100644
--- a/drivers/block/nd/namespace_devs.c
+++ b/drivers/block/nd/namespace_devs.c
@@ -151,6 +151,53 @@ static resource_size_t nd_namespace_blk_size(struct nd_namespace_blk *nsblk)
 	return size;
 }
 
+resource_size_t nd_namespace_blk_validate(struct nd_namespace_blk *nsblk)
+{
+	struct nd_region *nd_region = to_nd_region(nsblk->dev.parent);
+	struct nd_mapping *nd_mapping = &nd_region->mapping[0];
+	struct nd_dimm_drvdata *ndd = to_ndd(nd_mapping);
+	struct nd_label_id label_id;
+	struct resource *res;
+	int count, i;
+
+	if (!nsblk->uuid || !nsblk->lbasize)
+		return 0;
+
+	count = 0;
+	nd_label_gen_id(&label_id, nsblk->uuid, NSLABEL_FLAG_LOCAL);
+	for_each_dpa_resource(ndd, res) {
+		if (strcmp(res->name, label_id.id) != 0)
+			continue;
+		/*
+		 * Resources with unacknoweldged adjustments indicate a
+		 * failure to update labels
+		 */
+		if (res->flags & DPA_RESOURCE_ADJUSTED)
+			return 0;
+		count++;
+	}
+
+	/* These values match after a successful label update */
+	if (count != nsblk->num_resources)
+		return 0;
+
+	for (i = 0; i < nsblk->num_resources; i++) {
+		struct resource *found = NULL;
+
+		for_each_dpa_resource(ndd, res)
+			if (res == nsblk->res[i]) {
+				found = res;
+				break;
+			}
+		/* stale resource */
+		if (!found)
+			return 0;
+	}
+
+	return nd_namespace_blk_size(nsblk);
+}
+EXPORT_SYMBOL(nd_namespace_blk_validate);
+
 static int nd_namespace_label_update(struct nd_region *nd_region, struct device *dev)
 {
 	dev_WARN_ONCE(dev, dev->driver,
diff --git a/drivers/block/nd/nd-private.h b/drivers/block/nd/nd-private.h
index 5f58e8e96a41..f65309780df4 100644
--- a/drivers/block/nd/nd-private.h
+++ b/drivers/block/nd/nd-private.h
@@ -46,16 +46,19 @@ struct nd_bus {
 	struct radix_tree_root dimm_radix;
 	wait_queue_head_t probe_wait;
 	struct module *module;
+	struct list_head spa_maps;
 	struct list_head memdevs;
 	struct list_head dimms;
 	struct list_head spas;
 	struct list_head dcrs;
 	struct list_head bdws;
+	struct list_head idts;
 	struct list_head ndios;
 	struct list_head list;
 	struct device dev;
 	int id, probe_active;
 	struct mutex reconfig_mutex;
+	struct mutex spa_map_mutex;
 	struct nd_btt *nd_btt;
 };
 
@@ -92,6 +95,11 @@ struct nd_bdw {
 	struct list_head list;
 };
 
+struct nd_idt {
+	struct nfit_idt __iomem *nfit_idt;
+	struct list_head list;
+};
+
 struct nd_memdev {
 	struct nfit_mem __iomem *nfit_mem;
 	struct list_head list;
@@ -100,13 +108,29 @@ struct nd_memdev {
 /* assembled tables for a given dimm */
 struct nd_mem {
 	struct nfit_mem __iomem *nfit_mem_dcr;
+	struct nfit_mem __iomem *nfit_mem_bdw;
 	struct nfit_dcr __iomem *nfit_dcr;
 	struct nfit_bdw __iomem *nfit_bdw;
 	struct nfit_spa __iomem *nfit_spa_dcr;
 	struct nfit_spa __iomem *nfit_spa_bdw;
+	struct nfit_idt __iomem *nfit_idt_dcr;
+	struct nfit_idt __iomem *nfit_idt_bdw;
+	struct list_head list;
+};
+
+struct nd_spa_mapping {
+	struct nfit_spa __iomem *nfit_spa;
 	struct list_head list;
+	struct nd_bus *nd_bus;
+	struct kref kref;
+	void *spa;
 };
 
+static inline struct nd_spa_mapping *to_spa_map(struct kref *kref)
+{
+	return container_of(kref, struct nd_spa_mapping, kref);
+}
+
 struct nd_io *ndio_lookup(struct nd_bus *nd_bus, const char *diskname);
 const char *spa_type_name(u16 type);
 int nfit_spa_type(struct nfit_spa __iomem *nfit_spa);
diff --git a/drivers/block/nd/nd.h b/drivers/block/nd/nd.h
index ef77b5893628..b092253f3521 100644
--- a/drivers/block/nd/nd.h
+++ b/drivers/block/nd/nd.h
@@ -106,6 +106,11 @@ static inline struct nd_namespace_label __iomem *nd_get_label(
 	for (res = (ndd)->dpa.child, next = res ? res->sibling : NULL; \
 			res; res = next, next = next ? next->sibling : NULL)
 
+enum nd_blk_mmio_selector {
+	BDW,
+	DCR,
+};
+
 struct nd_region {
 	struct device dev;
 	struct nd_spa *nd_spa;
@@ -116,6 +121,22 @@ struct nd_region {
 	u64 ndr_start;
 	int id;
 	int num_lanes;
+	/* only valid for blk regions */
+	struct nd_blk_window {
+		struct nd_blk_mmio {
+			void *base;
+			u64 size;
+			u64 base_offset;
+			u32 line_size;
+			u32 num_lines;
+			u32 table_size;
+			struct nfit_idt __iomem *nfit_idt;
+			struct nfit_spa __iomem *nfit_spa;
+		} mmio[2];
+		u64 bdw_offset; /* post interleave offset */
+		u64 stat_offset;
+		u64 cmd_offset;
+	} bw;
 	struct nd_mapping mapping[0];
 };
 
@@ -129,6 +150,11 @@ static inline unsigned nd_inc_seq(unsigned seq)
 	return next[seq & 3];
 }
 
+static inline struct nd_region *ndbw_to_region(struct nd_blk_window *ndbw)
+{
+	return container_of(ndbw, struct nd_region, bw);
+}
+
 struct nd_io;
 /**
  * nd_rw_bytes_fn() - access bytes relative to the "whole disk" namespace device
@@ -212,6 +238,27 @@ enum nd_async_mode {
 	ND_ASYNC,
 };
 
+/*
+ * When testing BLK I/O (with CONFIG_NFIT_TEST) we override
+ * nd_blk_do_io() and optionally route it to simulated resources.  Given
+ * circular dependencies nfit_test needs to be loaded for the BLK I/O
+ * fallback path in the case of real hardware.  See
+ * __wrap_nd_blk_do_io().
+ */
+#if IS_ENABLED(CONFIG_NFIT_TEST)
+#include <linux/kmod.h>
+
+static inline int nfit_test_blk_init(void)
+{
+	return request_module("nfit_test");
+}
+#else
+static inline int nfit_test_blk_init(void)
+{
+	return 0;
+}
+#endif
+
 void wait_nd_bus_probe_idle(struct device *dev);
 void nd_device_register(struct device *dev);
 void nd_device_unregister(struct device *dev, enum nd_async_mode mode);
@@ -248,6 +295,7 @@ u64 btt_sb_checksum(struct btt_sb *btt_sb);
 struct nd_region *to_nd_region(struct device *dev);
 unsigned int nd_region_acquire_lane(struct nd_region *nd_region);
 void nd_region_release_lane(struct nd_region *nd_region, unsigned int lane);
+int nd_blk_init_region(struct nd_region *nd_region);
 int nd_region_to_namespace_type(struct nd_region *nd_region);
 int nd_region_register_namespaces(struct nd_region *nd_region, int *err);
 u64 nd_region_interleave_set_cookie(struct nd_region *nd_region);
@@ -256,4 +304,7 @@ void nd_bus_unlock(struct device *dev);
 bool is_nd_bus_locked(struct device *dev);
 int nd_label_reserve_dpa(struct nd_dimm_drvdata *ndd);
 void nd_dimm_free_dpa(struct nd_dimm_drvdata *ndd, struct resource *res);
+int nd_blk_do_io(struct nd_blk_window *ndbw, void *iobuf,
+		unsigned int len, int rw, resource_size_t dev_offset);
+resource_size_t nd_namespace_blk_validate(struct nd_namespace_blk *nsblk);
 #endif /* __ND_H__ */
diff --git a/drivers/block/nd/region.c b/drivers/block/nd/region.c
index 29019a65808e..7f484ed0528c 100644
--- a/drivers/block/nd/region.c
+++ b/drivers/block/nd/region.c
@@ -17,11 +17,18 @@
 
 static int nd_region_probe(struct device *dev)
 {
-	int err;
+	int err, rc;
 	struct nd_region_namespaces *num_ns;
 	struct nd_region *nd_region = to_nd_region(dev);
-	int rc = nd_region_register_namespaces(nd_region, &err);
 
+	rc = nd_blk_init_region(nd_region);
+	if (rc) {
+		dev_err(&nd_region->dev, "%s: failed to map block windows: %d\n",
+				__func__, rc);
+		return rc;
+	}
+
+	rc = nd_region_register_namespaces(nd_region, &err);
 	num_ns = devm_kzalloc(dev, sizeof(*num_ns), GFP_KERNEL);
 	if (!num_ns)
 		return -ENOMEM;
diff --git a/drivers/block/nd/region_devs.c b/drivers/block/nd/region_devs.c
index 0aab8bb0a982..c1a69bcc7626 100644
--- a/drivers/block/nd/region_devs.c
+++ b/drivers/block/nd/region_devs.c
@@ -11,6 +11,7 @@
  * General Public License for more details.
  */
 #include <linux/scatterlist.h>
+#include <linux/highmem.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/sort.h>
@@ -542,29 +543,148 @@ u64 nd_region_interleave_set_cookie(struct nd_region *nd_region)
 	return 0;
 }
 
+static void nd_spa_mapping_release(struct kref *kref)
+{
+	struct nd_spa_mapping *spa_map = to_spa_map(kref);
+	struct nfit_spa __iomem *nfit_spa = spa_map->nfit_spa;
+	struct nd_bus *nd_bus = spa_map->nd_bus;
+
+	WARN_ON(!mutex_is_locked(&nd_bus->spa_map_mutex));
+	dev_dbg(&nd_bus->dev, "%s: SPA%d\n", __func__,
+			readw(&nfit_spa->spa_index));
+	iounmap(spa_map->spa);
+	release_mem_region(readq(&nfit_spa->spa_base),
+			readq(&nfit_spa->spa_length));
+	list_del(&spa_map->list);
+	kfree(spa_map);
+}
+
+static struct nd_spa_mapping *find_spa_mapping(struct nd_bus *nd_bus,
+		struct nfit_spa __iomem *nfit_spa)
+{
+	struct nd_spa_mapping *spa_map;
+
+	WARN_ON(!mutex_is_locked(&nd_bus->spa_map_mutex));
+	list_for_each_entry(spa_map, &nd_bus->spa_maps, list)
+		if (spa_map->nfit_spa == nfit_spa)
+			return spa_map;
+
+	return NULL;
+}
+
+static void nd_spa_unmap(struct nd_bus *nd_bus, struct nfit_spa __iomem *nfit_spa)
+{
+	struct nd_spa_mapping *spa_map;
+
+	mutex_lock(&nd_bus->spa_map_mutex);
+	spa_map = find_spa_mapping(nd_bus, nfit_spa);
+
+	if (spa_map)
+		kref_put(&spa_map->kref, nd_spa_mapping_release);
+	mutex_unlock(&nd_bus->spa_map_mutex);
+}
+
+static void *__nd_spa_map(struct nd_bus *nd_bus, struct nfit_spa __iomem *nfit_spa)
+{
+	resource_size_t start = readq(&nfit_spa->spa_base);
+	resource_size_t n = readq(&nfit_spa->spa_length);
+	struct nd_spa_mapping *spa_map;
+	struct resource *res;
+
+	WARN_ON(!mutex_is_locked(&nd_bus->spa_map_mutex));
+
+	spa_map = find_spa_mapping(nd_bus, nfit_spa);
+	if (spa_map) {
+		kref_get(&spa_map->kref);
+		return spa_map->spa;
+	}
+
+	spa_map = kzalloc(sizeof(*spa_map), GFP_KERNEL);
+	if (!spa_map)
+		return NULL;
+
+	INIT_LIST_HEAD(&spa_map->list);
+	spa_map->nfit_spa = nfit_spa;
+	kref_init(&spa_map->kref);
+	spa_map->nd_bus = nd_bus;
+
+	res = request_mem_region(start, n, dev_name(&nd_bus->dev));
+	if (!res)
+		goto err_mem;
+
+	/* TODO: cacheability based on the spa type */
+	spa_map->spa = ioremap_nocache(start, n);
+	if (!spa_map->spa)
+		goto err_map;
+
+	list_add_tail(&spa_map->list, &nd_bus->spa_maps);
+	return spa_map->spa;
+
+ err_map:
+	release_mem_region(start, n);
+ err_mem:
+	kfree(spa_map);
+	return NULL;
+}
+
+/**
+ * nd_spa_map - nd core managed mappings of NFIT_SPA_DCR and NFIT_SPA_BDW ranges
+ * @nd_bus: NFIT-bus that provided the spa table entry
+ * @nfit_spa: spa table to map
+ *
+ * In the case where block-data-window apertures and
+ * dimm-control-regions are interleaved they will end up sharing a
+ * single request_mem_region() + ioremap() for the address range.  In
+ * the style of devm nd_spa_map() mappings are automatically dropped
+ * when all region devices referencing the same mapping are disabled /
+ * unbound.
+ */
+static void *nd_spa_map(struct nd_bus *nd_bus, struct nfit_spa __iomem *nfit_spa)
+{
+	struct nd_spa_mapping *spa_map;
+
+	mutex_lock(&nd_bus->spa_map_mutex);
+	spa_map = __nd_spa_map(nd_bus, nfit_spa);
+	mutex_unlock(&nd_bus->spa_map_mutex);
+
+	return spa_map;
+}
+
 /*
  * Upon successful probe/remove, take/release a reference on the
- * associated interleave set (if present)
+ * associated dimms in the interleave set, on successful probe of a BLK
+ * namespace check if we need a new seed, and on remove or failed probe
+ * of a BLK region drop interleaved spa mappings.
  */
 static void nd_region_notify_driver_action(struct nd_bus *nd_bus,
 		struct device *dev, int rc, bool probe)
 {
-	if (rc)
-		return;
-
 	if (is_nd_pmem(dev) || is_nd_blk(dev)) {
 		struct nd_region *nd_region = to_nd_region(dev);
+		struct nd_blk_window *ndbw = &nd_region->bw;
 		int i;
 
 		for (i = 0; i < nd_region->ndr_mappings; i++) {
 			struct nd_mapping *nd_mapping = &nd_region->mapping[i];
 			struct nd_dimm *nd_dimm = nd_mapping->nd_dimm;
 
-			if (probe)
+			if (probe && rc == 0)
 				atomic_inc(&nd_dimm->busy);
-			else
+			else if (!probe)
 				atomic_dec(&nd_dimm->busy);
 		}
+
+		if (is_nd_pmem(dev) || (probe && rc == 0))
+			return;
+
+		/* auto-free BLK spa mappings */
+		for (i = 0; i < 2; i++) {
+			struct nd_blk_mmio *mmio = &ndbw->mmio[i];
+
+			if (mmio->base)
+				nd_spa_unmap(nd_bus, mmio->nfit_spa);
+		}
+		memset(ndbw, 0, sizeof(*ndbw));
 	} else if (dev->parent && is_nd_blk(dev->parent) && probe && rc == 0) {
 		struct nd_region *nd_region = to_nd_region(dev->parent);
 
@@ -716,6 +836,188 @@ static const struct attribute_group *nd_region_attribute_groups[] = {
 	NULL,
 };
 
+static u64 to_interleave_offset(u64 offset, struct nd_blk_mmio *mmio)
+{
+	struct nfit_idt __iomem *nfit_idt = mmio->nfit_idt;
+	u32 sub_line_offset, line_index, line_offset;
+	u64 line_no, table_skip_count, table_offset;
+
+	line_no = div_u64_rem(offset, mmio->line_size, &sub_line_offset);
+	table_skip_count = div_u64_rem(line_no, mmio->num_lines, &line_index);
+	line_offset = readl(&nfit_idt->line_offset[line_index])
+		* mmio->line_size;
+	table_offset = table_skip_count * mmio->table_size;
+
+	return mmio->base_offset + line_offset + table_offset + sub_line_offset;
+}
+
+static u64 read_blk_stat(struct nd_blk_window *ndbw, unsigned int bw)
+{
+	struct nd_blk_mmio *mmio = &ndbw->mmio[DCR];
+	u64 offset = ndbw->stat_offset + mmio->size * bw;
+
+	if (mmio->num_lines)
+		offset = to_interleave_offset(offset, mmio);
+
+	return readq(mmio->base + offset);
+}
+
+static void write_blk_ctl(struct nd_blk_window *ndbw, unsigned int bw,
+		resource_size_t dpa, unsigned int len, unsigned int write)
+{
+	u64 cmd, offset;
+	struct nd_blk_mmio *mmio = &ndbw->mmio[DCR];
+
+	enum {
+		BCW_OFFSET_MASK = (1ULL << 48)-1,
+		BCW_LEN_SHIFT = 48,
+		BCW_LEN_MASK = (1ULL << 8) - 1,
+		BCW_CMD_SHIFT = 56,
+	};
+
+	cmd = (dpa >> L1_CACHE_SHIFT) & BCW_OFFSET_MASK;
+	len = len >> L1_CACHE_SHIFT;
+	cmd |= ((u64) len & BCW_LEN_MASK) << BCW_LEN_SHIFT;
+	cmd |= ((u64) write) << BCW_CMD_SHIFT;
+
+	offset = ndbw->cmd_offset + mmio->size * bw;
+	if (mmio->num_lines)
+		offset = to_interleave_offset(offset, mmio);
+
+	writeq(cmd, mmio->base + offset);
+	/* FIXME: conditionally perform read-back if mandated by firmware */
+}
+
+/* len is <= PAGE_SIZE by this point, so it can be done in a single BW I/O */
+int nd_blk_do_io(struct nd_blk_window *ndbw, void *iobuf, unsigned int len,
+		int write, resource_size_t dpa)
+{
+	struct nd_region *nd_region = ndbw_to_region(ndbw);
+	struct nd_blk_mmio *mmio = &ndbw->mmio[BDW];
+	unsigned int bw, copied = 0;
+	u64 base_offset;
+	int rc;
+
+	bw = nd_region_acquire_lane(nd_region);
+	base_offset = ndbw->bdw_offset + dpa % L1_CACHE_BYTES + bw * mmio->size;
+	/* TODO: non-temporal access, flush hints, cache management etc... */
+	write_blk_ctl(ndbw, bw, dpa, len, write);
+	while (len) {
+		unsigned int c;
+		u64 offset;
+
+		if (mmio->num_lines) {
+			u32 line_offset;
+
+			offset = to_interleave_offset(base_offset + copied,
+					mmio);
+			div_u64_rem(offset, mmio->line_size, &line_offset);
+			c = min(len, mmio->line_size - line_offset);
+		} else {
+			offset = base_offset + ndbw->bdw_offset;
+			c = len;
+		}
+
+		if (write)
+			memcpy(mmio->base + offset, iobuf + copied, c);
+		else
+			memcpy(iobuf + copied, mmio->base + offset, c);
+
+		len -= c;
+		copied += c;
+	}
+	rc = read_blk_stat(ndbw, bw) ? -EIO : 0;
+	nd_region_release_lane(nd_region, bw);
+
+	return rc;
+}
+EXPORT_SYMBOL(nd_blk_do_io);
+
+static int nd_blk_init_interleave(struct nd_blk_mmio *mmio,
+		struct nfit_idt __iomem *nfit_idt, u16 interleave_ways)
+{
+	if (nfit_idt) {
+		mmio->num_lines = readl(&nfit_idt->num_lines);
+		mmio->line_size = readl(&nfit_idt->line_size);
+		if (interleave_ways == 0)
+			return -ENXIO;
+		mmio->table_size = mmio->num_lines * interleave_ways
+			* mmio->line_size;
+	}
+
+	return 0;
+}
+
+int nd_blk_init_region(struct nd_region *nd_region)
+{
+	struct nd_bus *nd_bus = walk_to_nd_bus(&nd_region->dev);
+	struct nd_blk_window *ndbw = &nd_region->bw;
+	struct nd_mapping *nd_mapping;
+	struct nd_blk_mmio *mmio;
+	struct nd_dimm *nd_dimm;
+	struct nd_mem *nd_mem;
+	int rc;
+
+	if (!is_nd_blk(&nd_region->dev))
+		return 0;
+
+	/* FIXME: use nfit values rather than hard coded */
+	if (nd_region->ndr_mappings != 1)
+		return -ENXIO;
+
+	nd_mapping = &nd_region->mapping[0];
+	nd_dimm = nd_mapping->nd_dimm;
+	nd_mem = nd_dimm->nd_mem;
+	if (!nd_mem->nfit_dcr || !nd_mem->nfit_bdw)
+		return -ENXIO;
+
+	/* map block aperture memory */
+	ndbw->bdw_offset = readq(&nd_mem->nfit_bdw->bdw_offset);
+	mmio = &ndbw->mmio[BDW];
+	mmio->base = nd_spa_map(nd_bus, nd_mem->nfit_spa_bdw);
+	if (!mmio->base)
+		return -ENOMEM;
+	mmio->size = readq(&nd_mem->nfit_bdw->bdw_size);
+	mmio->base_offset = readq(&nd_mem->nfit_mem_bdw->region_spa_offset);
+	mmio->nfit_idt = nd_mem->nfit_idt_bdw;
+	mmio->nfit_spa = nd_mem->nfit_spa_bdw;
+	rc = nd_blk_init_interleave(mmio, nd_mem->nfit_idt_bdw,
+			readw(&nd_mem->nfit_mem_bdw->interleave_ways));
+	if (rc)
+		return rc;
+
+	/* map block control memory */
+	ndbw->cmd_offset = readq(&nd_mem->nfit_dcr->cmd_offset);
+	ndbw->stat_offset = readq(&nd_mem->nfit_dcr->status_offset);
+	mmio = &ndbw->mmio[DCR];
+	mmio->base = nd_spa_map(nd_bus, nd_mem->nfit_spa_dcr);
+	if (!mmio->base)
+		return -ENOMEM;
+	mmio->size = readq(&nd_mem->nfit_dcr->bcw_size);
+	mmio->base_offset = readq(&nd_mem->nfit_mem_dcr->region_spa_offset);
+	mmio->nfit_idt = nd_mem->nfit_idt_dcr;
+	mmio->nfit_spa = nd_mem->nfit_spa_dcr;
+	rc = nd_blk_init_interleave(mmio, nd_mem->nfit_idt_dcr,
+			readw(&nd_mem->nfit_mem_dcr->interleave_ways));
+	if (rc)
+		return rc;
+
+	if (mmio->line_size == 0)
+		return 0;
+
+	if ((u32) ndbw->cmd_offset % mmio->line_size + 8 > mmio->line_size) {
+		dev_err(&nd_region->dev,
+				"cmd_offset crosses interleave boundary\n");
+		return -ENXIO;
+	} else if ((u32) ndbw->stat_offset % mmio->line_size + 8 > mmio->line_size) {
+		dev_err(&nd_region->dev,
+				"stat_offset crosses interleave boundary\n");
+		return -ENXIO;
+	}
+
+	return 0;
+}
+
 static void nd_blk_init(struct nd_bus *nd_bus, struct nd_region *nd_region,
 		struct nd_mem *nd_mem)
 {
diff --git a/drivers/block/nd/test/iomap.c b/drivers/block/nd/test/iomap.c
index 87e6a1255237..2724e671c376 100644
--- a/drivers/block/nd/test/iomap.c
+++ b/drivers/block/nd/test/iomap.c
@@ -17,17 +17,27 @@
 #include <linux/types.h>
 #include <linux/io.h>
 #include "nfit_test.h"
+#include "../nd.h"
 
 static LIST_HEAD(iomap_head);
 
 static struct iomap_ops {
 	nfit_test_lookup_fn nfit_test_lookup;
+	nfit_test_acquire_lane_fn nfit_test_acquire_lane;
+	nfit_test_release_lane_fn nfit_test_release_lane;
+	nfit_test_blk_do_io_fn nfit_test_blk_do_io;
 	struct list_head list;
 } iomap_ops;
 
-void nfit_test_setup(nfit_test_lookup_fn lookup)
+void nfit_test_setup(nfit_test_lookup_fn lookup,
+		nfit_test_acquire_lane_fn acquire_lane,
+		nfit_test_release_lane_fn release_lane,
+		nfit_test_blk_do_io_fn blk_do_io)
 {
 	iomap_ops.nfit_test_lookup = lookup;
+	iomap_ops.nfit_test_acquire_lane = acquire_lane;
+	iomap_ops.nfit_test_release_lane = release_lane;
+	iomap_ops.nfit_test_blk_do_io = blk_do_io;
 	INIT_LIST_HEAD(&iomap_ops.list);
 	list_add_rcu(&iomap_ops.list, &iomap_head);
 }
@@ -145,4 +155,45 @@ void __wrap___release_region(struct resource *parent, resource_size_t start,
 }
 EXPORT_SYMBOL(__wrap___release_region);
 
+int __wrap_nd_blk_do_io(struct nd_blk_window *ndbw, void *iobuf,
+		unsigned int len, int rw, resource_size_t dpa)
+{
+	struct nd_region *nd_region = ndbw_to_region(ndbw);
+	struct nd_blk_mmio *mmio = &ndbw->mmio[BDW];
+	struct nfit_test_resource *nfit_res;
+	struct iomap_ops *ops;
+	int rc = 0;
+
+	rcu_read_lock();
+	ops = list_first_or_null_rcu(&iomap_head, typeof(*ops), list);
+	nfit_res = ops ? ops->nfit_test_lookup((unsigned long) mmio->base) : NULL;
+	if (nfit_res) {
+		unsigned int bw;
+
+		dev_vdbg(&nd_region->dev, "%s: base: %p offset: %pa\n",
+				__func__, mmio->base, &dpa);
+		bw = ops->nfit_test_acquire_lane(nd_region);
+		if (rw)
+			memcpy(nfit_res->buf + dpa, iobuf, len);
+		else
+			memcpy(iobuf, nfit_res->buf + dpa, len);
+		ops->nfit_test_release_lane(nd_region, bw);
+	} else if (ops) {
+		rc = ops->nfit_test_blk_do_io(ndbw, iobuf, len, rw, dpa);
+	} else {
+		/*
+		 * We can't call nd_blk_do_io() directly here as it would
+		 * create a circular dependency.  nfit_test must remain loaded
+		 * to maintain nfit_test_blk_do_io() => nd_blk_do_io().
+		 */
+		dev_WARN_ONCE(&nd_region->dev, 1,
+				"load nfit_test.ko or disable CONFIG_NFIT_TEST\n");
+		rc = -EIO;
+	}
+	rcu_read_unlock();
+
+	return rc;
+}
+EXPORT_SYMBOL(__wrap_nd_blk_do_io);
+
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/block/nd/test/nfit.c b/drivers/block/nd/test/nfit.c
index e9fb9da765b9..7218b55a9a34 100644
--- a/drivers/block/nd/test/nfit.c
+++ b/drivers/block/nd/test/nfit.c
@@ -949,7 +949,8 @@ static __init int nfit_test_init(void)
 		return -EINVAL;
 	}
 
-	nfit_test_setup(nfit_test_lookup);
+	nfit_test_setup(nfit_test_lookup, nd_region_acquire_lane,
+			nd_region_release_lane, nd_blk_do_io);
 
 	for (i = 0; i < NUM_NFITS; i++) {
 		struct nfit_test *nfit_test;
diff --git a/drivers/block/nd/test/nfit_test.h b/drivers/block/nd/test/nfit_test.h
index 8a300c51b6bc..a6978563ad4e 100644
--- a/drivers/block/nd/test/nfit_test.h
+++ b/drivers/block/nd/test/nfit_test.h
@@ -12,6 +12,7 @@
  */
 #ifndef __NFIT_TEST_H__
 #define __NFIT_TEST_H__
+#include <linux/types.h>
 
 struct nfit_test_resource {
 	struct list_head list;
@@ -20,6 +21,17 @@ struct nfit_test_resource {
 };
 
 typedef struct nfit_test_resource *(*nfit_test_lookup_fn)(resource_size_t);
-void nfit_test_setup(nfit_test_lookup_fn fn);
+struct nd_region;
+typedef unsigned int (*nfit_test_acquire_lane_fn)(struct nd_region *nd_region);
+typedef void (*nfit_test_release_lane_fn)(struct nd_region *nd_region,
+		unsigned int lane);
+struct nd_blk_window;
+struct page;
+typedef int (*nfit_test_blk_do_io_fn)(struct nd_blk_window *ndbw, void *iobuf,
+		unsigned int len, int rw, resource_size_t dpa);
+void nfit_test_setup(nfit_test_lookup_fn lookup,
+		nfit_test_acquire_lane_fn acquire_lane,
+		nfit_test_release_lane_fn release_lane,
+		nfit_test_blk_do_io_fn blk_do_io);
 void nfit_test_teardown(void);
 #endif

