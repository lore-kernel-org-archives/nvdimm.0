Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v3 17/21] libnd: infrastructure for btt devices
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 20 May 2015 16:57:43 -0400
Message-ID: <20150520205743.32249.1439.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150520205536.32249.89779.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150520205536.32249.89779.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-nvdimm@lists.01.org, neilb@suse.de, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, mingo@kernel.org, linux-acpi@vger.kernel.org, jmoyer@redhat.com, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Block devices from an nd bus, in addition to accepting "struct bio"
based requests, also have the capability to perform byte-aligned
accesses.  By default only the bio/block interface is used.  However, if
another driver can make effective use of the byte-aligned capability it
can claim/disable the block interface and use the byte-aligned "nd_io"
interface.

The BTT driver is the initial first consumer of this mechanism to allow
layering atomic sector update guarantees on top of nd_io capable
libnd-block-devices, or their partitions.

Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/block/nd/Kconfig      |    3 
 drivers/block/nd/Makefile     |    1 
 drivers/block/nd/btt.h        |   45 ++++
 drivers/block/nd/btt_devs.c   |  442 +++++++++++++++++++++++++++++++++++++++++
 drivers/block/nd/bus.c        |  128 ++++++++++++
 drivers/block/nd/core.c       |   79 +++++++
 drivers/block/nd/nd-private.h |   28 +++
 drivers/block/nd/nd.h         |   94 +++++++++
 drivers/block/nd/pmem.c       |   29 +++
 include/uapi/linux/ndctl.h    |    2 
 10 files changed, 847 insertions(+), 4 deletions(-)
 create mode 100644 drivers/block/nd/btt.h
 create mode 100644 drivers/block/nd/btt_devs.c

diff --git a/drivers/block/nd/Kconfig b/drivers/block/nd/Kconfig
index 03f572f0e3d0..00d9afe9475e 100644
--- a/drivers/block/nd/Kconfig
+++ b/drivers/block/nd/Kconfig
@@ -34,4 +34,7 @@ config BLK_DEV_PMEM
 
 	  Say Y if you want to use a NVDIMM described by NFIT
 
+config ND_BTT_DEVS
+	def_bool y
+
 endif
diff --git a/drivers/block/nd/Makefile b/drivers/block/nd/Makefile
index 8d14510559e1..9866669d7738 100644
--- a/drivers/block/nd/Makefile
+++ b/drivers/block/nd/Makefile
@@ -11,3 +11,4 @@ libnd-y += region_devs.o
 libnd-y += region.o
 libnd-y += namespace_devs.o
 libnd-y += label.o
+libnd-$(CONFIG_ND_BTT_DEVS) += btt_devs.o
diff --git a/drivers/block/nd/btt.h b/drivers/block/nd/btt.h
new file mode 100644
index 000000000000..e8f6d8e0ddd3
--- /dev/null
+++ b/drivers/block/nd/btt.h
@@ -0,0 +1,45 @@
+/*
+ * Block Translation Table library
+ * Copyright (c) 2014-2015, Intel Corporation.
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
+#ifndef _LINUX_BTT_H
+#define _LINUX_BTT_H
+
+#include <linux/types.h>
+
+#define BTT_SIG_LEN 16
+#define BTT_SIG "BTT_ARENA_INFO\0"
+
+struct btt_sb {
+	u8 signature[BTT_SIG_LEN];
+	u8 uuid[16];
+	u8 parent_uuid[16];
+	__le32 flags;
+	__le16 version_major;
+	__le16 version_minor;
+	__le32 external_lbasize;
+	__le32 external_nlba;
+	__le32 internal_lbasize;
+	__le32 internal_nlba;
+	__le32 nfree;
+	__le32 infosize;
+	__le64 nextoff;
+	__le64 dataoff;
+	__le64 mapoff;
+	__le64 logoff;
+	__le64 info2off;
+	u8 padding[3968];
+	__le64 checksum;
+};
+
+#endif
diff --git a/drivers/block/nd/btt_devs.c b/drivers/block/nd/btt_devs.c
new file mode 100644
index 000000000000..b3b813288092
--- /dev/null
+++ b/drivers/block/nd/btt_devs.c
@@ -0,0 +1,442 @@
+/*
+ * Copyright(c) 2013-2015 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#include <linux/device.h>
+#include <linux/genhd.h>
+#include <linux/sizes.h>
+#include <linux/slab.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include "nd-private.h"
+#include "btt.h"
+#include "nd.h"
+
+static DEFINE_IDA(btt_ida);
+
+static void nd_btt_release(struct device *dev)
+{
+	struct nd_btt *nd_btt = to_nd_btt(dev);
+
+	dev_dbg(dev, "%s\n", __func__);
+	WARN_ON(nd_btt->backing_dev);
+	ndio_del_claim(nd_btt->ndio_claim);
+	ida_simple_remove(&btt_ida, nd_btt->id);
+	kfree(nd_btt->uuid);
+	kfree(nd_btt);
+}
+
+static struct device_type nd_btt_device_type = {
+	.name = "nd_btt",
+	.release = nd_btt_release,
+};
+
+bool is_nd_btt(struct device *dev)
+{
+	return dev->type == &nd_btt_device_type;
+}
+
+struct nd_btt *to_nd_btt(struct device *dev)
+{
+	struct nd_btt *nd_btt = container_of(dev, struct nd_btt, dev);
+
+	WARN_ON(!is_nd_btt(dev));
+	return nd_btt;
+}
+EXPORT_SYMBOL(to_nd_btt);
+
+static const unsigned long btt_lbasize_supported[] = { 512, 4096, 0 };
+
+static ssize_t sector_size_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nd_btt *nd_btt = to_nd_btt(dev);
+
+	return nd_sector_size_show(nd_btt->lbasize, btt_lbasize_supported, buf);
+}
+
+static ssize_t sector_size_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t len)
+{
+	struct nd_btt *nd_btt = to_nd_btt(dev);
+	ssize_t rc;
+
+	device_lock(dev);
+	nd_bus_lock(dev);
+	rc = nd_sector_size_store(dev, buf, &nd_btt->lbasize,
+			btt_lbasize_supported);
+	dev_dbg(dev, "%s: result: %zd wrote: %s%s", __func__,
+			rc, buf, buf[len - 1] == '\n' ? "" : "\n");
+	nd_bus_unlock(dev);
+	device_unlock(dev);
+
+	return rc ? rc : len;
+}
+static DEVICE_ATTR_RW(sector_size);
+
+static ssize_t uuid_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nd_btt *nd_btt = to_nd_btt(dev);
+
+	if (nd_btt->uuid)
+		return sprintf(buf, "%pUb\n", nd_btt->uuid);
+	return sprintf(buf, "\n");
+}
+
+static ssize_t uuid_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t len)
+{
+	struct nd_btt *nd_btt = to_nd_btt(dev);
+	ssize_t rc;
+
+	device_lock(dev);
+	rc = nd_uuid_store(dev, &nd_btt->uuid, buf, len);
+	dev_dbg(dev, "%s: result: %zd wrote: %s%s", __func__,
+			rc, buf, buf[len - 1] == '\n' ? "" : "\n");
+	device_unlock(dev);
+
+	return rc ? rc : len;
+}
+static DEVICE_ATTR_RW(uuid);
+
+static ssize_t backing_dev_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nd_btt *nd_btt = to_nd_btt(dev);
+	char name[BDEVNAME_SIZE];
+
+	if (nd_btt->backing_dev)
+		return sprintf(buf, "/dev/%s\n",
+				bdevname(nd_btt->backing_dev, name));
+	else
+		return sprintf(buf, "\n");
+}
+
+static const fmode_t nd_btt_devs_mode = FMODE_READ | FMODE_WRITE | FMODE_EXCL;
+
+static void nd_btt_ndio_notify_remove(struct nd_io_claim *ndio_claim)
+{
+	char bdev_name[BDEVNAME_SIZE];
+	struct nd_btt *nd_btt;
+
+	if (!ndio_claim || !ndio_claim->holder)
+		return;
+
+	nd_btt = to_nd_btt(ndio_claim->holder);
+	WARN_ON_ONCE(!is_nd_bus_locked(&nd_btt->dev));
+	dev_dbg(&nd_btt->dev, "%pf: %s: release /dev/%s\n",
+			__builtin_return_address(0), __func__,
+			bdevname(nd_btt->backing_dev, bdev_name));
+	blkdev_put(nd_btt->backing_dev, nd_btt_devs_mode);
+	nd_btt->backing_dev = NULL;
+
+	/*
+	 * Once we've had our backing device removed we need to be fully
+	 * reconfigured.  The bus will have already created a new seed
+	 * for this purpose, so now is a good time to clean up this
+	 * stale nd_btt instance.
+	 */
+	if (nd_btt->dev.driver)
+		nd_device_unregister(&nd_btt->dev, ND_ASYNC);
+	else {
+		ndio_del_claim(ndio_claim);
+		nd_btt->ndio_claim = NULL;
+	}
+}
+
+static ssize_t __backing_dev_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t len)
+{
+	struct nd_bus *nd_bus = walk_to_nd_bus(dev);
+	struct nd_btt *nd_btt = to_nd_btt(dev);
+	char bdev_name[BDEVNAME_SIZE];
+	struct block_device *bdev;
+	struct nd_io *ndio;
+	char *path;
+
+	if (dev->driver) {
+		dev_dbg(dev, "%s: -EBUSY\n", __func__);
+		return -EBUSY;
+	}
+
+	path = kstrndup(buf, len, GFP_KERNEL);
+	if (!path)
+		return -ENOMEM;
+
+	/* detach the backing device */
+	if (strcmp(strim(path), "") == 0) {
+		if (!nd_btt->backing_dev)
+			goto out;
+		nd_btt_ndio_notify_remove(nd_btt->ndio_claim);
+		goto out;
+	} else if (nd_btt->backing_dev) {
+		dev_dbg(dev, "backing_dev already set\n");
+		len = -EBUSY;
+		goto out;
+	}
+
+	bdev = blkdev_get_by_path(strim(path), nd_btt_devs_mode, nd_btt);
+	if (IS_ERR(bdev)) {
+		dev_dbg(dev, "open '%s' failed: %ld\n", strim(path),
+				PTR_ERR(bdev));
+		len = PTR_ERR(bdev);
+		goto out;
+	}
+
+	if (get_capacity(bdev->bd_disk) < SZ_16M / 512) {
+		blkdev_put(bdev, nd_btt_devs_mode);
+		len = -ENXIO;
+		goto out;
+	}
+
+	ndio = ndio_lookup(nd_bus, bdevname(bdev->bd_contains, bdev_name));
+	if (!ndio) {
+		dev_dbg(dev, "%s does not have an ndio interface\n",
+				strim(path));
+		blkdev_put(bdev, nd_btt_devs_mode);
+		len = -ENXIO;
+		goto out;
+	}
+
+	nd_btt->ndio_claim = ndio_add_claim(ndio, &nd_btt->dev,
+			nd_btt_ndio_notify_remove);
+	if (!nd_btt->ndio_claim) {
+		blkdev_put(bdev, nd_btt_devs_mode);
+		len = -ENOMEM;
+		goto out;
+	}
+
+	WARN_ON_ONCE(!is_nd_bus_locked(&nd_btt->dev));
+	nd_btt->backing_dev = bdev;
+
+ out:
+	kfree(path);
+	return len;
+}
+
+static ssize_t backing_dev_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t len)
+{
+	ssize_t rc;
+
+	nd_bus_lock(dev);
+	device_lock(dev);
+	rc = __backing_dev_store(dev, attr, buf, len);
+	dev_dbg(dev, "%s: result: %zd wrote: %s%s", __func__,
+			rc, buf, buf[len - 1] == '\n' ? "" : "\n");
+	device_unlock(dev);
+	nd_bus_unlock(dev);
+
+	return rc;
+}
+static DEVICE_ATTR_RW(backing_dev);
+
+static bool is_nd_btt_idle(struct device *dev)
+{
+	struct nd_bus *nd_bus = walk_to_nd_bus(dev);
+	struct nd_btt *nd_btt = to_nd_btt(dev);
+
+	if (nd_bus->nd_btt == nd_btt || dev->driver || nd_btt->backing_dev)
+		return false;
+	return true;
+}
+
+static ssize_t delete_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	/* return 1 if can be deleted */
+	return sprintf(buf, "%d\n", is_nd_btt_idle(dev));
+}
+
+static ssize_t delete_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t len)
+{
+	unsigned long val;
+
+	/* write 1 to delete */
+	if (kstrtoul(buf, 0, &val) != 0 || val != 1)
+		return -EINVAL;
+
+	/* prevent deletion while this btt is active, or is the current seed */
+	if (!is_nd_btt_idle(dev))
+		return -EBUSY;
+
+	/*
+	 * userspace raced itself if device goes active here and it gets
+	 * to keep the pieces
+	 */
+	nd_device_unregister(dev, ND_ASYNC);
+
+	return len;
+}
+static DEVICE_ATTR_RW(delete);
+
+static struct attribute *nd_btt_attributes[] = {
+	&dev_attr_sector_size.attr,
+	&dev_attr_backing_dev.attr,
+	&dev_attr_delete.attr,
+	&dev_attr_uuid.attr,
+	NULL,
+};
+
+static struct attribute_group nd_btt_attribute_group = {
+	.attrs = nd_btt_attributes,
+};
+
+static const struct attribute_group *nd_btt_attribute_groups[] = {
+	&nd_btt_attribute_group,
+	&nd_device_attribute_group,
+	NULL,
+};
+
+static struct nd_btt *__nd_btt_create(struct nd_bus *nd_bus,
+		unsigned long lbasize, u8 *uuid)
+{
+	struct nd_btt *nd_btt = kzalloc(sizeof(*nd_btt), GFP_KERNEL);
+	struct device *dev;
+
+	if (!nd_btt)
+		return NULL;
+	nd_btt->id = ida_simple_get(&btt_ida, 0, 0, GFP_KERNEL);
+	if (nd_btt->id < 0) {
+		kfree(nd_btt);
+		return NULL;
+	}
+
+	nd_btt->lbasize = lbasize;
+	if (uuid)
+		uuid = kmemdup(uuid, 16, GFP_KERNEL);
+	nd_btt->uuid = uuid;
+	dev = &nd_btt->dev;
+	dev_set_name(dev, "btt%d", nd_btt->id);
+	dev->parent = &nd_bus->dev;
+	dev->type = &nd_btt_device_type;
+	dev->groups = nd_btt_attribute_groups;
+	return nd_btt;
+}
+
+struct nd_btt *nd_btt_create(struct nd_bus *nd_bus)
+{
+	struct nd_btt *nd_btt = __nd_btt_create(nd_bus, 0, NULL);
+
+	if (!nd_btt)
+		return NULL;
+	nd_device_register(&nd_btt->dev);
+	return nd_btt;
+}
+
+/*
+ * nd_btt_sb_checksum: compute checksum for btt info block
+ *
+ * Returns a fletcher64 checksum of everything in the given info block
+ * except the last field (since that's where the checksum lives).
+ */
+u64 nd_btt_sb_checksum(struct btt_sb *btt_sb)
+{
+	u64 sum, sum_save;
+
+	sum_save = btt_sb->checksum;
+	btt_sb->checksum = 0;
+	sum = nd_fletcher64(btt_sb, sizeof(*btt_sb), 1);
+	btt_sb->checksum = sum_save;
+	return sum;
+}
+EXPORT_SYMBOL(nd_btt_sb_checksum);
+
+static int nd_btt_autodetect(struct nd_bus *nd_bus, struct nd_io *ndio,
+		struct block_device *bdev)
+{
+	char name[BDEVNAME_SIZE];
+	struct nd_btt *nd_btt;
+	struct btt_sb *btt_sb;
+	u64 offset, checksum;
+	u32 lbasize;
+	u8 *uuid;
+	int rc;
+
+	btt_sb = kzalloc(sizeof(*btt_sb), GFP_KERNEL);
+	if (!btt_sb)
+		return -ENODEV;
+
+	offset = nd_partition_offset(bdev);
+	rc = ndio->rw_bytes(ndio, btt_sb, offset + SZ_4K, sizeof(*btt_sb), READ);
+	if (rc)
+		goto out_free_sb;
+
+	if (get_capacity(bdev->bd_disk) < SZ_16M / 512)
+		goto out_free_sb;
+
+	if (memcmp(btt_sb->signature, BTT_SIG, BTT_SIG_LEN) != 0)
+		goto out_free_sb;
+
+	checksum = le64_to_cpu(btt_sb->checksum);
+	btt_sb->checksum = 0;
+	if (checksum != nd_btt_sb_checksum(btt_sb))
+		goto out_free_sb;
+	btt_sb->checksum = cpu_to_le64(checksum);
+
+	uuid = kmemdup(btt_sb->uuid, 16, GFP_KERNEL);
+	if (!uuid)
+		goto out_free_sb;
+
+	lbasize = le32_to_cpu(btt_sb->external_lbasize);
+	nd_btt = __nd_btt_create(nd_bus, lbasize, uuid);
+	if (!nd_btt)
+		goto out_free_uuid;
+
+	device_initialize(&nd_btt->dev);
+	nd_btt->ndio_claim = ndio_add_claim(ndio, &nd_btt->dev,
+			nd_btt_ndio_notify_remove);
+	if (!nd_btt->ndio_claim)
+		goto out_free_btt;
+
+	nd_btt->backing_dev = bdev;
+	dev_dbg(&nd_btt->dev, "%s: activate %s\n", __func__,
+			bdevname(bdev, name));
+	__nd_device_register(&nd_btt->dev);
+	kfree(btt_sb);
+	return 0;
+
+ out_free_btt:
+	kfree(nd_btt);
+ out_free_uuid:
+	kfree(uuid);
+ out_free_sb:
+	kfree(btt_sb);
+
+	return -ENODEV;
+}
+
+void nd_btt_notify_ndio(struct nd_bus *nd_bus, struct nd_io *ndio)
+{
+	struct disk_part_iter piter;
+	struct hd_struct *part;
+
+	disk_part_iter_init(&piter, ndio->disk, DISK_PITER_INCL_PART0);
+	while ((part = disk_part_iter_next(&piter))) {
+		struct block_device *bdev;
+		int rc;
+
+		bdev = bdget_disk(ndio->disk, part->partno);
+		if (!bdev)
+			continue;
+		if (blkdev_get(bdev, nd_btt_devs_mode, nd_bus) != 0)
+			continue;
+		rc = nd_btt_autodetect(nd_bus, ndio, bdev);
+		if (rc)
+			blkdev_put(bdev, nd_btt_devs_mode);
+		/* no need to scan further in the case of whole disk btt */
+		if (rc == 0 && part->partno == 0)
+			break;
+	}
+	disk_part_iter_exit(&piter);
+}
diff --git a/drivers/block/nd/bus.c b/drivers/block/nd/bus.c
index 4a2185a99bd7..dc69ccfae53a 100644
--- a/drivers/block/nd/bus.c
+++ b/drivers/block/nd/bus.c
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/fcntl.h>
 #include <linux/async.h>
+#include <linux/genhd.h>
 #include <linux/ndctl.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
@@ -40,6 +41,8 @@ static int to_nd_device_type(struct device *dev)
 		return ND_DEVICE_REGION_BLK;
 	else if (is_nd_pmem(dev->parent) || is_nd_blk(dev->parent))
 		return nd_region_to_namespace_type(to_nd_region(dev->parent));
+	else if (is_nd_btt(dev))
+		return ND_DEVICE_BTT;
 
 	return 0;
 }
@@ -84,6 +87,21 @@ static int nd_bus_probe(struct device *dev)
 
 	dev_dbg(&nd_bus->dev, "%s.probe(%s) = %d\n", dev->driver->name,
 			dev_name(dev), rc);
+
+	/* check if our btt-seed has sprouted, and plant another */
+	if (rc == 0 && is_nd_btt(dev) && dev == &nd_bus->nd_btt->dev) {
+		const char *sep = "", *name = "", *status = "failed";
+
+		nd_bus->nd_btt = nd_btt_create(nd_bus);
+		if (nd_bus->nd_btt) {
+			status = "succeeded";
+			sep = ": ";
+			name = dev_name(&nd_bus->nd_btt->dev);
+		}
+		dev_dbg(&nd_bus->dev, "btt seed creation %s%s%s\n",
+				status, sep, name);
+	}
+
 	if (rc != 0)
 		module_put(provider);
 	return rc;
@@ -144,14 +162,19 @@ static void nd_async_device_unregister(void *d, async_cookie_t cookie)
 	put_device(dev);
 }
 
-void nd_device_register(struct device *dev)
+void __nd_device_register(struct device *dev)
 {
 	dev->bus = &nd_bus_type;
-	device_initialize(dev);
 	get_device(dev);
 	async_schedule_domain(nd_async_device_register, dev,
 			&nd_async_domain);
 }
+
+void nd_device_register(struct device *dev)
+{
+	device_initialize(dev);
+	__nd_device_register(dev);
+}
 EXPORT_SYMBOL(nd_device_register);
 
 void nd_device_unregister(struct device *dev, enum nd_async_mode mode)
@@ -200,6 +223,107 @@ int __nd_driver_register(struct nd_device_driver *nd_drv, struct module *owner,
 }
 EXPORT_SYMBOL(__nd_driver_register);
 
+/**
+ * nd_register_ndio() - register byte-aligned access capability for an nd-bdev
+ * @disk: child gendisk of the ndio namepace device
+ * @ndio: initialized ndio instance to register
+ *
+ * LOCKING: hold nd_bus_lock() over the creation of ndio->disk and the
+ * subsequent nd_region_ndio event
+ */
+int nd_register_ndio(struct nd_io *ndio)
+{
+	struct nd_bus *nd_bus;
+	struct device *dev;
+
+	if (!ndio || !ndio->dev || !ndio->disk || !list_empty(&ndio->list)
+			|| !ndio->rw_bytes || !list_empty(&ndio->claims)) {
+		pr_debug("%s bad parameters from %pf\n", __func__,
+				__builtin_return_address(0));
+		return -EINVAL;
+	}
+
+	dev = ndio->dev;
+	nd_bus = walk_to_nd_bus(dev);
+	if (!nd_bus)
+		return -EINVAL;
+
+	WARN_ON_ONCE(!is_nd_bus_locked(&nd_bus->dev));
+	list_add(&ndio->list, &nd_bus->ndios);
+
+	/* TODO: generic infrastructure for 3rd party ndio claimers */
+	nd_btt_notify_ndio(nd_bus, ndio);
+
+	return 0;
+}
+EXPORT_SYMBOL(nd_register_ndio);
+
+/**
+ * __nd_unregister_ndio() - try to remove an ndio interface
+ * @ndio: interface to remove
+ */
+static int __nd_unregister_ndio(struct nd_io *ndio)
+{
+	struct nd_io_claim *ndio_claim, *_n;
+	struct nd_bus *nd_bus;
+	LIST_HEAD(claims);
+
+	nd_bus = walk_to_nd_bus(ndio->dev);
+	if (!nd_bus || list_empty(&ndio->list))
+		return -ENXIO;
+
+	spin_lock(&ndio->lock);
+	list_splice_init(&ndio->claims, &claims);
+	spin_unlock(&ndio->lock);
+
+	list_for_each_entry_safe(ndio_claim, _n, &claims, list)
+		ndio_claim->notify_remove(ndio_claim);
+
+	list_del_init(&ndio->list);
+
+	return 0;
+}
+
+int nd_unregister_ndio(struct nd_io *ndio)
+{
+	struct device *dev = ndio->dev;
+	int rc;
+
+	nd_bus_lock(dev);
+	rc = __nd_unregister_ndio(ndio);
+	nd_bus_unlock(dev);
+
+	/*
+	 * Flush in case ->notify_remove() kicked off asynchronous device
+	 * unregistration
+	 */
+	nd_synchronize();
+
+	return rc;
+}
+EXPORT_SYMBOL(nd_unregister_ndio);
+
+static struct nd_io *__ndio_lookup(struct nd_bus *nd_bus, const char *diskname)
+{
+	struct nd_io *ndio;
+
+	list_for_each_entry(ndio, &nd_bus->ndios, list)
+		if (strcmp(diskname, ndio->disk->disk_name) == 0)
+			return ndio;
+
+	return NULL;
+}
+
+struct nd_io *ndio_lookup(struct nd_bus *nd_bus, const char *diskname)
+{
+	struct nd_io *ndio;
+
+	WARN_ON_ONCE(!is_nd_bus_locked(&nd_bus->dev));
+	ndio = __ndio_lookup(nd_bus, diskname);
+
+	return ndio;
+}
+
 static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
 		char *buf)
 {
diff --git a/drivers/block/nd/core.c b/drivers/block/nd/core.c
index b45863343a48..a0709a2e302f 100644
--- a/drivers/block/nd/core.c
+++ b/drivers/block/nd/core.c
@@ -55,6 +55,62 @@ bool is_nd_bus_locked(struct device *dev)
 }
 EXPORT_SYMBOL(is_nd_bus_locked);
 
+void nd_init_ndio(struct nd_io *ndio, nd_rw_bytes_fn rw_bytes,
+		struct device *dev, struct gendisk *disk, unsigned long align)
+{
+	memset(ndio, 0, sizeof(*ndio));
+	INIT_LIST_HEAD(&ndio->claims);
+	INIT_LIST_HEAD(&ndio->list);
+	spin_lock_init(&ndio->lock);
+	ndio->dev = dev;
+	ndio->disk = disk;
+	ndio->align = align;
+	ndio->rw_bytes = rw_bytes;
+}
+EXPORT_SYMBOL(nd_init_ndio);
+
+void ndio_del_claim(struct nd_io_claim *ndio_claim)
+{
+	struct nd_io *ndio;
+	struct device *holder;
+
+	if (!ndio_claim)
+		return;
+	ndio = ndio_claim->parent;
+	holder = ndio_claim->holder;
+
+	dev_dbg(holder, "%s: drop %s\n", __func__, dev_name(ndio->dev));
+	spin_lock(&ndio->lock);
+	list_del(&ndio_claim->list);
+	spin_unlock(&ndio->lock);
+	put_device(ndio->dev);
+	kfree(ndio_claim);
+	put_device(holder);
+}
+
+struct nd_io_claim *ndio_add_claim(struct nd_io *ndio, struct device *holder,
+		ndio_notify_remove_fn notify_remove)
+{
+	struct nd_io_claim *ndio_claim = kzalloc(sizeof(*ndio_claim), GFP_KERNEL);
+
+	if (!ndio_claim)
+		return NULL;
+
+	INIT_LIST_HEAD(&ndio_claim->list);
+	ndio_claim->parent = ndio;
+	get_device(ndio->dev);
+
+	spin_lock(&ndio->lock);
+	list_add(&ndio_claim->list, &ndio->claims);
+	spin_unlock(&ndio->lock);
+
+	ndio_claim->holder = holder;
+	ndio_claim->notify_remove = notify_remove;
+	get_device(holder);
+
+	return ndio_claim;
+}
+
 u64 nd_fletcher64(void *addr, size_t len, bool le)
 {
 	u32 *buf = addr;
@@ -75,6 +131,8 @@ static void nd_bus_release(struct device *dev)
 {
 	struct nd_bus *nd_bus = container_of(dev, struct nd_bus, dev);
 
+	WARN_ON(!list_empty(&nd_bus->ndios));
+
 	ida_simple_remove(&nd_ida, nd_bus->id);
 	kfree(nd_bus);
 }
@@ -271,10 +329,28 @@ static ssize_t wait_probe_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(wait_probe);
 
+static ssize_t btt_seed_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nd_bus *nd_bus = to_nd_bus(dev);
+	ssize_t rc;
+
+	nd_bus_lock(dev);
+	if (nd_bus->nd_btt)
+		rc = sprintf(buf, "%s\n", dev_name(&nd_bus->nd_btt->dev));
+	else
+		rc = sprintf(buf, "\n");
+	nd_bus_unlock(dev);
+
+	return rc;
+}
+static DEVICE_ATTR_RO(btt_seed);
+
 static struct attribute *nd_bus_attributes[] = {
 	&dev_attr_commands.attr,
 	&dev_attr_wait_probe.attr,
 	&dev_attr_provider.attr,
+	&dev_attr_btt_seed.attr,
 	NULL,
 };
 
@@ -291,6 +367,7 @@ struct nd_bus *__nd_bus_register(struct device *parent,
 
 	if (!nd_bus)
 		return NULL;
+	INIT_LIST_HEAD(&nd_bus->ndios);
 	INIT_LIST_HEAD(&nd_bus->list);
 	init_waitqueue_head(&nd_bus->probe_wait);
 	nd_bus->id = ida_simple_get(&nd_ida, 0, 0, GFP_KERNEL);
@@ -319,6 +396,8 @@ struct nd_bus *__nd_bus_register(struct device *parent,
 	list_add_tail(&nd_bus->list, &nd_bus_list);
 	mutex_unlock(&nd_bus_list_mutex);
 
+	nd_bus->nd_btt = nd_btt_create(nd_bus);
+
 	return nd_bus;
  err:
 	put_device(&nd_bus->dev);
diff --git a/drivers/block/nd/nd-private.h b/drivers/block/nd/nd-private.h
index fffd65436e2b..6c89695956a4 100644
--- a/drivers/block/nd/nd-private.h
+++ b/drivers/block/nd/nd-private.h
@@ -22,14 +22,21 @@ extern struct list_head nd_bus_list;
 extern struct mutex nd_bus_list_mutex;
 extern int nd_dimm_major;
 
+struct block_device;
+struct nd_io_claim;
+struct nd_btt;
+struct nd_io;
+
 struct nd_bus {
 	struct nd_bus_descriptor *nd_desc;
 	wait_queue_head_t probe_wait;
 	struct module *module;
+	struct list_head ndios;
 	struct list_head list;
 	struct device dev;
 	int id, probe_active;
 	struct mutex reconfig_mutex;
+	struct nd_btt *nd_btt;
 };
 
 struct nd_dimm {
@@ -41,9 +48,29 @@ struct nd_dimm {
 	int id;
 };
 
+struct nd_io *ndio_lookup(struct nd_bus *nd_bus, const char *diskname);
 bool is_nd_dimm(struct device *dev);
 bool is_nd_blk(struct device *dev);
 bool is_nd_pmem(struct device *dev);
+#if IS_ENABLED(CONFIG_ND_BTT_DEVS)
+bool is_nd_btt(struct device *dev);
+struct nd_btt *nd_btt_create(struct nd_bus *nd_bus);
+void nd_btt_notify_ndio(struct nd_bus *nd_bus, struct nd_io *ndio);
+#else
+static inline bool is_nd_btt(struct device *dev)
+{
+	return false;
+}
+
+static inline struct nd_btt *nd_btt_create(struct nd_bus *nd_bus)
+{
+	return NULL;
+}
+
+static inline void nd_btt_notify_ndio(struct nd_bus *nd_bus, struct nd_io *ndio)
+{
+}
+#endif
 struct nd_bus *walk_to_nd_bus(struct device *nd_dev);
 int __init nd_bus_init(void);
 void nd_bus_exit(void);
@@ -62,6 +89,7 @@ void nd_synchronize(void);
 int nd_bus_register_dimms(struct nd_bus *nd_bus);
 int nd_bus_register_regions(struct nd_bus *nd_bus);
 int nd_bus_init_interleave_sets(struct nd_bus *nd_bus);
+void __nd_device_register(struct device *dev);
 int nd_match_dimm(struct device *dev, void *data);
 struct nd_label_id;
 char *nd_label_gen_id(struct nd_label_id *label_id, u8 *uuid, u32 flags);
diff --git a/drivers/block/nd/nd.h b/drivers/block/nd/nd.h
index 24a440a23b2c..73e830785f74 100644
--- a/drivers/block/nd/nd.h
+++ b/drivers/block/nd/nd.h
@@ -12,13 +12,19 @@
  */
 #ifndef __ND_H__
 #define __ND_H__
+#include <linux/genhd.h>
 #include <linux/device.h>
 #include <linux/libnd.h>
 #include <linux/mutex.h>
 #include <linux/ndctl.h>
 #include <linux/types.h>
+#include <linux/fs.h>
 #include "label.h"
 
+enum {
+	SECTOR_SHIFT = 9,
+};
+
 struct nd_dimm_drvdata {
 	struct device *dev;
 	int nsindex_size;
@@ -111,6 +117,84 @@ static inline unsigned nd_inc_seq(unsigned seq)
 	return next[seq & 3];
 }
 
+struct nd_io;
+/**
+ * nd_rw_bytes_fn() - access bytes relative to the "whole disk" namespace device
+ * @ndio: per-namespace context
+ * @buf: source / target for the write / read
+ * @offset: offset relative to the start of the namespace device
+ * @n: num bytes to access
+ * @flags: READ, WRITE, and other REQ_* flags
+ *
+ * Note: Implementations may assume that offset + n never crosses ndio->align
+ */
+typedef int (*nd_rw_bytes_fn)(struct nd_io *ndio, void *buf, size_t offset,
+		size_t n, unsigned long flags);
+#define nd_data_dir(flags) (flags & 1)
+
+/**
+ * struct nd_io - info for byte-aligned access to nd devices
+ * @rw_bytes: operation to perform byte-aligned access
+ * @align: a single ->rw_bytes() request may not cross this alignment
+ * @gendisk: whole disk block device for the namespace
+ * @list: for the core to cache a list of "ndio"s for later association
+ * @dev: namespace device
+ * @claims: list of clients using this interface
+ * @lock: protect @claims mutation
+ */
+struct nd_io {
+	nd_rw_bytes_fn rw_bytes;
+	unsigned long align;
+	struct gendisk *disk;
+	struct list_head list;
+	struct device *dev;
+	struct list_head claims;
+	spinlock_t lock;
+};
+
+struct nd_io_claim;
+typedef void (*ndio_notify_remove_fn)(struct nd_io_claim *ndio_claim);
+
+/**
+ * struct nd_io_claim - instance of a claim on a parent ndio
+ * @notify_remove: ndio is going away, release resources
+ * @holder: object that has claimed this ndio
+ * @parent: ndio in use
+ * @holder: holder device
+ * @list: claim peers
+ *
+ * An ndio may be claimed multiple times, consider the case of a btt
+ * instance per partition on a namespace.
+ */
+struct nd_io_claim {
+	struct nd_io *parent;
+	ndio_notify_remove_fn notify_remove;
+	struct list_head list;
+	struct device *holder;
+};
+
+struct nd_btt {
+	struct device dev;
+	struct nd_io *ndio;
+	struct block_device *backing_dev;
+	unsigned long lbasize;
+	u8 *uuid;
+	u64 offset;
+	int id;
+	struct nd_io_claim *ndio_claim;
+};
+
+static inline u64 nd_partition_offset(struct block_device *bdev)
+{
+	struct hd_struct *p;
+
+	if (bdev == bdev->bd_contains)
+		return 0;
+
+	p = bdev->bd_part;
+	return ((u64) p->start_sect) << SECTOR_SHIFT;
+}
+
 enum nd_async_mode {
 	ND_SYNC,
 	ND_ASYNC,
@@ -125,12 +209,22 @@ ssize_t nd_sector_size_show(unsigned long current_lbasize,
 		const unsigned long *supported, char *buf);
 ssize_t nd_sector_size_store(struct device *dev, const char *buf,
 		unsigned long *current_lbasize, const unsigned long *supported);
+int nd_register_ndio(struct nd_io *ndio);
+int nd_unregister_ndio(struct nd_io *ndio);
+void nd_init_ndio(struct nd_io *ndio, nd_rw_bytes_fn rw_bytes,
+		struct device *dev, struct gendisk *disk, unsigned long align);
+void ndio_del_claim(struct nd_io_claim *ndio_claim);
+struct nd_io_claim *ndio_add_claim(struct nd_io *ndio, struct device *holder,
+		ndio_notify_remove_fn notify_remove);
 struct nd_dimm;
 struct nd_dimm_drvdata *to_ndd(struct nd_mapping *nd_mapping);
 int nd_dimm_init_nsarea(struct nd_dimm_drvdata *ndd);
 int nd_dimm_init_config_data(struct nd_dimm_drvdata *ndd);
 int nd_dimm_set_config_data(struct nd_dimm_drvdata *ndd, size_t offset,
 		void *buf, size_t len);
+struct nd_btt *to_nd_btt(struct device *dev);
+struct btt_sb;
+u64 nd_btt_sb_checksum(struct btt_sb *btt_sb);
 struct nd_region *to_nd_region(struct device *dev);
 int nd_region_to_namespace_type(struct nd_region *nd_region);
 int nd_region_register_namespaces(struct nd_region *nd_region, int *err);
diff --git a/drivers/block/nd/pmem.c b/drivers/block/nd/pmem.c
index bf380393da92..7b5cedf1f2a4 100644
--- a/drivers/block/nd/pmem.c
+++ b/drivers/block/nd/pmem.c
@@ -29,6 +29,7 @@
 struct pmem_device {
 	struct request_queue	*pmem_queue;
 	struct gendisk		*pmem_disk;
+	struct nd_io		ndio;
 
 	/* One contiguous memory region per device */
 	phys_addr_t		phys_addr;
@@ -96,6 +97,26 @@ static int pmem_rw_page(struct block_device *bdev, sector_t sector,
 	return 0;
 }
 
+static int pmem_rw_bytes(struct nd_io *ndio, void *buf, size_t offset,
+		size_t n, unsigned long flags)
+{
+	struct pmem_device *pmem = container_of(ndio, typeof(*pmem), ndio);
+	int rw = nd_data_dir(flags);
+
+	if (unlikely(offset + n > pmem->size)) {
+		dev_WARN_ONCE(ndio->dev, 1, "%s: request out of range\n",
+				__func__);
+		return -EFAULT;
+	}
+
+	if (rw == READ)
+		memcpy(buf, pmem->virt_addr + offset, n);
+	else
+		memcpy(pmem->virt_addr + offset, buf, n);
+
+	return 0;
+}
+
 static long pmem_direct_access(struct block_device *bdev, sector_t sector,
 			      void **kaddr, unsigned long *pfn, long size)
 {
@@ -169,8 +190,6 @@ static struct pmem_device *pmem_alloc(struct device *dev, struct resource *res,
 	set_capacity(disk, pmem->size >> 9);
 	pmem->pmem_disk = disk;
 
-	add_disk(disk);
-
 	return pmem;
 
 out_free_queue:
@@ -222,7 +241,12 @@ static int nd_pmem_probe(struct device *dev)
 	if (IS_ERR(pmem))
 		return PTR_ERR(pmem);
 
+	nd_bus_lock(dev);
+	add_disk(pmem->pmem_disk);
 	dev_set_drvdata(dev, pmem);
+	nd_init_ndio(&pmem->ndio, pmem_rw_bytes, dev, pmem->pmem_disk, 0);
+	nd_register_ndio(&pmem->ndio);
+	nd_bus_unlock(dev);
 
 	return 0;
 }
@@ -231,6 +255,7 @@ static int nd_pmem_remove(struct device *dev)
 {
 	struct pmem_device *pmem = dev_get_drvdata(dev);
 
+	nd_unregister_ndio(&pmem->ndio);
 	pmem_free(pmem);
 	return 0;
 }
diff --git a/include/uapi/linux/ndctl.h b/include/uapi/linux/ndctl.h
index 0b4dcabb248a..e595751c613d 100644
--- a/include/uapi/linux/ndctl.h
+++ b/include/uapi/linux/ndctl.h
@@ -181,6 +181,7 @@ static inline const char *nd_dimm_cmd_name(unsigned cmd)
 #define ND_DEVICE_NAMESPACE_IO 4    /* legacy persistent memory */
 #define ND_DEVICE_NAMESPACE_PMEM 5  /* persistent memory namespace (may alias) */
 #define ND_DEVICE_NAMESPACE_BLK 6   /* block-data-window namespace (may alias) */
+#define ND_DEVICE_BTT 7		    /* block-translation table device */
 
 enum nd_driver_flags {
 	ND_DRIVER_DIMM            = 1 << ND_DEVICE_DIMM,
@@ -189,6 +190,7 @@ enum nd_driver_flags {
 	ND_DRIVER_NAMESPACE_IO    = 1 << ND_DEVICE_NAMESPACE_IO,
 	ND_DRIVER_NAMESPACE_PMEM  = 1 << ND_DEVICE_NAMESPACE_PMEM,
 	ND_DRIVER_NAMESPACE_BLK   = 1 << ND_DEVICE_NAMESPACE_BLK,
+	ND_DRIVER_BTT		  = 1 << ND_DEVICE_BTT,
 };
 
 enum {

