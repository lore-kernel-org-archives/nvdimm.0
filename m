Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Subject: [PATCH 02/15] libnvdimm: infrastructure for btt devices
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 17 Jun 2015 19:54:58 -0400
Message-ID: <20150617235458.12943.23425.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150617235209.12943.24419.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150617235209.12943.24419.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: axboe@kernel.dk, linux-nvdimm@lists.01.org
Cc: boaz@plexistor.com, toshi.kani@hp.com, Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, mingo@kernel.org, linux-acpi@vger.kernel.org, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Block devices from an nd bus, in addition to accepting "struct bio"
based requests, also have the capability to perform byte-aligned
accesses.  By default only the bio/block interface is used.  However, if
another driver can make effective use of the byte-aligned capability it
can claim the block interface and use the byte-aligned ->rw_bytes()
interface.

The BTT driver is the initial first consumer of this mechanism to allow
layering atomic sector update guarantees on top of ->rw_bytes() capable
libnvdimm-block-devices, or their partitions.

Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/Kconfig     |    3 
 drivers/nvdimm/Makefile    |    1 
 drivers/nvdimm/btt.h       |   45 +++++
 drivers/nvdimm/btt_devs.c  |  431 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/nvdimm/bus.c       |   82 ++++++++
 drivers/nvdimm/core.c      |   20 ++
 drivers/nvdimm/nd-core.h   |   34 +++
 drivers/nvdimm/nd.h        |   19 ++
 drivers/nvdimm/pmem.c      |    6 -
 include/uapi/linux/ndctl.h |    2 
 10 files changed, 637 insertions(+), 6 deletions(-)
 create mode 100644 drivers/nvdimm/btt.h
 create mode 100644 drivers/nvdimm/btt_devs.c

diff --git a/drivers/nvdimm/Kconfig b/drivers/nvdimm/Kconfig
index 07a29113b870..f16ba9d14740 100644
--- a/drivers/nvdimm/Kconfig
+++ b/drivers/nvdimm/Kconfig
@@ -33,4 +33,7 @@ config BLK_DEV_PMEM
 
 	  Say Y if you want to use an NVDIMM
 
+config ND_BTT_DEVS
+	def_bool y
+
 endif
diff --git a/drivers/nvdimm/Makefile b/drivers/nvdimm/Makefile
index abce98f87f16..eb1bbce86592 100644
--- a/drivers/nvdimm/Makefile
+++ b/drivers/nvdimm/Makefile
@@ -11,3 +11,4 @@ libnvdimm-y += region_devs.o
 libnvdimm-y += region.o
 libnvdimm-y += namespace_devs.o
 libnvdimm-y += label.o
+libnvdimm-$(CONFIG_ND_BTT_DEVS) += btt_devs.o
diff --git a/drivers/nvdimm/btt.h b/drivers/nvdimm/btt.h
new file mode 100644
index 000000000000..e8f6d8e0ddd3
--- /dev/null
+++ b/drivers/nvdimm/btt.h
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
diff --git a/drivers/nvdimm/btt_devs.c b/drivers/nvdimm/btt_devs.c
new file mode 100644
index 000000000000..2148fd8f535b
--- /dev/null
+++ b/drivers/nvdimm/btt_devs.c
@@ -0,0 +1,431 @@
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
+#include <linux/blkdev.h>
+#include <linux/device.h>
+#include <linux/genhd.h>
+#include <linux/sizes.h>
+#include <linux/slab.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include "nd-core.h"
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
+	nvdimm_bus_lock(dev);
+	rc = nd_sector_size_store(dev, buf, &nd_btt->lbasize,
+			btt_lbasize_supported);
+	dev_dbg(dev, "%s: result: %zd wrote: %s%s", __func__,
+			rc, buf, buf[len - 1] == '\n' ? "" : "\n");
+	nvdimm_bus_unlock(dev);
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
+static void nd_btt_remove_bdev(struct nd_btt *nd_btt, const char *caller)
+{
+	struct block_device *bdev = nd_btt->backing_dev;
+	char bdev_name[BDEVNAME_SIZE];
+
+	if (!nd_btt->backing_dev)
+		return;
+
+	WARN_ON_ONCE(!is_nvdimm_bus_locked(&nd_btt->dev));
+	dev_dbg(&nd_btt->dev, "%s: %s: release %s\n", caller, __func__,
+			bdevname(bdev, bdev_name));
+	blkdev_put(bdev, nd_btt_devs_mode);
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
+}
+
+static int __nd_btt_remove_disk(struct device *dev, void *data)
+{
+	struct gendisk *disk = data;
+	struct block_device *bdev;
+	struct nd_btt *nd_btt;
+
+	if (!is_nd_btt(dev))
+		return 0;
+
+	nd_btt = to_nd_btt(dev);
+	bdev = nd_btt->backing_dev;
+	if (bdev && bdev->bd_disk == disk)
+		nd_btt_remove_bdev(nd_btt, __func__);
+	return 0;
+}
+
+void nd_btt_remove_disk(struct nvdimm_bus *nvdimm_bus, struct gendisk *disk)
+{
+	device_for_each_child(&nvdimm_bus->dev, disk, __nd_btt_remove_disk);
+}
+
+static ssize_t __backing_dev_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t len)
+{
+	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
+	const struct block_device_operations *ops;
+	struct nd_btt *nd_btt = to_nd_btt(dev);
+	struct block_device *bdev;
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
+	strim(path);
+
+	/* detach the backing device */
+	if (strcmp(path, "") == 0) {
+		nd_btt_remove_bdev(nd_btt, __func__);
+		goto out;
+	} else if (nd_btt->backing_dev) {
+		dev_dbg(dev, "backing_dev already set\n");
+		len = -EBUSY;
+		goto out;
+	}
+
+	bdev = blkdev_get_by_path(path, nd_btt_devs_mode, nd_btt);
+	if (IS_ERR(bdev)) {
+		dev_dbg(dev, "open '%s' failed: %ld\n", path, PTR_ERR(bdev));
+		len = PTR_ERR(bdev);
+		goto out;
+	}
+
+	if (nvdimm_bus != walk_to_nvdimm_bus(disk_to_dev(bdev->bd_disk))) {
+		dev_dbg(dev, "%s not a descendant of %s\n", path,
+				dev_name(&nvdimm_bus->dev));
+		blkdev_put(bdev, nd_btt_devs_mode);
+		len = -EINVAL;
+		goto out;
+	}
+
+	if (get_capacity(bdev->bd_disk) < SZ_16M / 512) {
+		dev_dbg(dev, "%s too small to host btt\n", path);
+		blkdev_put(bdev, nd_btt_devs_mode);
+		len = -ENXIO;
+		goto out;
+	}
+
+	ops = bdev->bd_disk->fops;
+	if (!ops->rw_bytes) {
+		dev_dbg(dev, "%s does not implement ->rw_bytes()\n", path);
+		blkdev_put(bdev, nd_btt_devs_mode);
+		len = -EINVAL;
+		goto out;
+	}
+
+	WARN_ON_ONCE(!is_nvdimm_bus_locked(&nd_btt->dev));
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
+	nvdimm_bus_lock(dev);
+	device_lock(dev);
+	rc = __backing_dev_store(dev, attr, buf, len);
+	dev_dbg(dev, "%s: result: %zd wrote: %s%s", __func__,
+			rc, buf, buf[len - 1] == '\n' ? "" : "\n");
+	device_unlock(dev);
+	nvdimm_bus_unlock(dev);
+
+	return rc;
+}
+static DEVICE_ATTR_RW(backing_dev);
+
+static bool is_nd_btt_idle(struct device *dev)
+{
+	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
+	struct nd_btt *nd_btt = to_nd_btt(dev);
+
+	if (nvdimm_bus->nd_btt == nd_btt || dev->driver || nd_btt->backing_dev)
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
+static struct nd_btt *__nd_btt_create(struct nvdimm_bus *nvdimm_bus,
+		unsigned long lbasize, u8 *uuid, struct block_device *bdev)
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
+	nd_btt->backing_dev = bdev;
+	dev = &nd_btt->dev;
+	dev_set_name(dev, "btt%d", nd_btt->id);
+	dev->parent = &nvdimm_bus->dev;
+	dev->type = &nd_btt_device_type;
+	dev->groups = nd_btt_attribute_groups;
+	nd_device_register(&nd_btt->dev);
+	return nd_btt;
+}
+
+struct nd_btt *nd_btt_create(struct nvdimm_bus *nvdimm_bus)
+{
+	return __nd_btt_create(nvdimm_bus, 0, NULL, NULL);
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
+static struct nd_btt *__nd_btt_autodetect(struct nvdimm_bus *nvdimm_bus,
+		struct block_device *bdev, struct btt_sb *btt_sb)
+{
+	u64 checksum;
+	u32 lbasize;
+
+	if (!btt_sb || !bdev || !nvdimm_bus)
+		return NULL;
+
+	if (bdev_read_bytes(bdev, SZ_4K, btt_sb, sizeof(*btt_sb)))
+		return NULL;
+
+	if (get_capacity(bdev->bd_disk) < SZ_16M / 512)
+		return NULL;
+
+	if (memcmp(btt_sb->signature, BTT_SIG, BTT_SIG_LEN) != 0)
+		return NULL;
+
+	checksum = le64_to_cpu(btt_sb->checksum);
+	btt_sb->checksum = 0;
+	if (checksum != nd_btt_sb_checksum(btt_sb))
+		return NULL;
+	btt_sb->checksum = cpu_to_le64(checksum);
+
+	lbasize = le32_to_cpu(btt_sb->external_lbasize);
+	return __nd_btt_create(nvdimm_bus, lbasize, btt_sb->uuid, bdev);
+}
+
+static int nd_btt_autodetect(struct nvdimm_bus *nvdimm_bus,
+		struct block_device *bdev)
+{
+	char name[BDEVNAME_SIZE];
+	struct nd_btt *nd_btt;
+	struct btt_sb *btt_sb;
+
+	btt_sb = kzalloc(sizeof(*btt_sb), GFP_KERNEL);
+	nd_btt = __nd_btt_autodetect(nvdimm_bus, bdev, btt_sb);
+	kfree(btt_sb);
+	dev_dbg(&nvdimm_bus->dev, "%s: %s btt: %s\n", __func__,
+			bdevname(bdev, name), nd_btt
+			? dev_name(&nd_btt->dev) : "<none>");
+	return nd_btt ? 0 : -ENODEV;
+}
+
+void nd_btt_add_disk(struct nvdimm_bus *nvdimm_bus, struct gendisk *disk)
+{
+	struct disk_part_iter piter;
+	struct hd_struct *part;
+
+	disk_part_iter_init(&piter, disk, DISK_PITER_INCL_PART0);
+	while ((part = disk_part_iter_next(&piter))) {
+		struct block_device *bdev;
+		int rc;
+
+		bdev = bdget_disk(disk, part->partno);
+		if (!bdev)
+			continue;
+		if (blkdev_get(bdev, nd_btt_devs_mode, nvdimm_bus) != 0)
+			continue;
+		rc = nd_btt_autodetect(nvdimm_bus, bdev);
+		if (rc)
+			blkdev_put(bdev, nd_btt_devs_mode);
+		/* no need to scan further in the case of whole disk btt */
+		if (rc == 0 && part->partno == 0)
+			break;
+	}
+	disk_part_iter_exit(&piter);
+}
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index ca802702440e..3c14fee5aff4 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -14,8 +14,10 @@
 #include <linux/vmalloc.h>
 #include <linux/uaccess.h>
 #include <linux/module.h>
+#include <linux/blkdev.h>
 #include <linux/fcntl.h>
 #include <linux/async.h>
+#include <linux/genhd.h>
 #include <linux/ndctl.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
@@ -40,6 +42,8 @@ static int to_nd_device_type(struct device *dev)
 		return ND_DEVICE_REGION_BLK;
 	else if (is_nd_pmem(dev->parent) || is_nd_blk(dev->parent))
 		return nd_region_to_nstype(to_nd_region(dev->parent));
+	else if (is_nd_btt(dev))
+		return ND_DEVICE_BTT;
 
 	return 0;
 }
@@ -103,6 +107,21 @@ static int nvdimm_bus_probe(struct device *dev)
 
 	dev_dbg(&nvdimm_bus->dev, "%s.probe(%s) = %d\n", dev->driver->name,
 			dev_name(dev), rc);
+
+	/* check if our btt-seed has sprouted, and plant another */
+	if (rc == 0 && is_nd_btt(dev) && dev == &nvdimm_bus->nd_btt->dev) {
+		const char *sep = "", *name = "", *status = "failed";
+
+		nvdimm_bus->nd_btt = nd_btt_create(nvdimm_bus);
+		if (nvdimm_bus->nd_btt) {
+			status = "succeeded";
+			sep = ": ";
+			name = dev_name(&nvdimm_bus->nd_btt->dev);
+		}
+		dev_dbg(&nvdimm_bus->dev, "btt seed creation %s%s%s\n",
+				status, sep, name);
+	}
+
 	if (rc != 0)
 		module_put(provider);
 	return rc;
@@ -163,14 +182,19 @@ static void nd_async_device_unregister(void *d, async_cookie_t cookie)
 	put_device(dev);
 }
 
-void nd_device_register(struct device *dev)
+void __nd_device_register(struct device *dev)
 {
 	dev->bus = &nvdimm_bus_type;
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
@@ -219,6 +243,60 @@ int __nd_driver_register(struct nd_device_driver *nd_drv, struct module *owner,
 }
 EXPORT_SYMBOL(__nd_driver_register);
 
+/**
+ * nvdimm_bus_add_disk() - attach and run actions on an nvdimm block device
+ * @disk: disk device being registered
+ *
+ * Note, that @disk must be a descendant of an nvdimm_bus
+ */
+int nvdimm_bus_add_disk(struct gendisk *disk)
+{
+	const struct block_device_operations *ops = disk->fops;
+	struct device *dev = disk->driverfs_dev;
+	struct nvdimm_bus *nvdimm_bus;
+
+	nvdimm_bus = walk_to_nvdimm_bus(dev);
+	if (!nvdimm_bus || !ops->rw_bytes)
+		return -EINVAL;
+
+	/*
+	 * Take the bus lock here to prevent userspace racing to
+	 * initiate actions on the newly availble block device while
+	 * autodetect scanning is still in flight.
+	 */
+	nvdimm_bus_lock(&nvdimm_bus->dev);
+	add_disk(disk);
+	nd_btt_add_disk(nvdimm_bus, disk);
+	nvdimm_bus_unlock(&nvdimm_bus->dev);
+
+	return 0;
+}
+EXPORT_SYMBOL(nvdimm_bus_add_disk);
+
+void nvdimm_bus_remove_disk(struct gendisk *disk)
+{
+	struct device *dev = disk_to_dev(disk);
+	struct nvdimm_bus *nvdimm_bus;
+
+	nvdimm_bus = walk_to_nvdimm_bus(dev);
+	if (!nvdimm_bus)
+		return;
+
+	nvdimm_bus_lock(&nvdimm_bus->dev);
+	nd_btt_remove_disk(nvdimm_bus, disk);
+	nvdimm_bus_unlock(&nvdimm_bus->dev);
+
+	/*
+	 * Flush in case *_notify_remove() kicked off asynchronous
+	 * device unregistration
+	 */
+	nd_synchronize();
+
+	del_gendisk(disk);
+	put_disk(disk);
+}
+EXPORT_SYMBOL(nvdimm_bus_remove_disk);
+
 static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
 		char *buf)
 {
diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
index dd824d7c2669..0fa9b6225450 100644
--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -273,10 +273,28 @@ static ssize_t wait_probe_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(wait_probe);
 
+static ssize_t btt_seed_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nvdimm_bus *nvdimm_bus = to_nvdimm_bus(dev);
+	ssize_t rc;
+
+	nvdimm_bus_lock(dev);
+	if (nvdimm_bus->nd_btt)
+		rc = sprintf(buf, "%s\n", dev_name(&nvdimm_bus->nd_btt->dev));
+	else
+		rc = sprintf(buf, "\n");
+	nvdimm_bus_unlock(dev);
+
+	return rc;
+}
+static DEVICE_ATTR_RO(btt_seed);
+
 static struct attribute *nvdimm_bus_attributes[] = {
 	&dev_attr_commands.attr,
 	&dev_attr_wait_probe.attr,
 	&dev_attr_provider.attr,
+	&dev_attr_btt_seed.attr,
 	NULL,
 };
 
@@ -322,6 +340,8 @@ struct nvdimm_bus *__nvdimm_bus_register(struct device *parent,
 	list_add_tail(&nvdimm_bus->list, &nvdimm_bus_list);
 	mutex_unlock(&nvdimm_bus_list_mutex);
 
+	nvdimm_bus->nd_btt = nd_btt_create(nvdimm_bus);
+
 	return nvdimm_bus;
  err:
 	put_device(&nvdimm_bus->dev);
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 78d6c51f4bac..1375d30b3da5 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -23,6 +23,11 @@ extern struct list_head nvdimm_bus_list;
 extern struct mutex nvdimm_bus_list_mutex;
 extern int nvdimm_major;
 
+struct block_device;
+struct nd_io_claim;
+struct nd_btt;
+struct nd_io;
+
 struct nvdimm_bus {
 	struct nvdimm_bus_descriptor *nd_desc;
 	wait_queue_head_t probe_wait;
@@ -31,6 +36,7 @@ struct nvdimm_bus {
 	struct device dev;
 	int id, probe_active;
 	struct mutex reconfig_mutex;
+	struct nd_btt *nd_btt;
 };
 
 struct nvdimm {
@@ -45,6 +51,33 @@ struct nvdimm {
 bool is_nvdimm(struct device *dev);
 bool is_nd_blk(struct device *dev);
 bool is_nd_pmem(struct device *dev);
+struct gendisk;
+#if IS_ENABLED(CONFIG_ND_BTT_DEVS)
+bool is_nd_btt(struct device *dev);
+struct nd_btt *nd_btt_create(struct nvdimm_bus *nvdimm_bus);
+void nd_btt_add_disk(struct nvdimm_bus *nvdimm_bus, struct gendisk *disk);
+void nd_btt_remove_disk(struct nvdimm_bus *nvdimm_bus, struct gendisk *disk);
+#else
+static inline bool is_nd_btt(struct device *dev)
+{
+	return false;
+}
+
+static inline struct nd_btt *nd_btt_create(struct nvdimm_bus *nvdimm_bus)
+{
+	return NULL;
+}
+
+static inline void nd_btt_add_disk(struct nvdimm_bus *nvdimm_bus,
+		struct gendisk *disk)
+{
+}
+
+static inline void nd_btt_remove_disk(struct nvdimm_bus *nvdimm_bus,
+		struct gendisk *disk)
+{
+}
+#endif
 struct nvdimm_bus *walk_to_nvdimm_bus(struct device *nd_dev);
 int __init nvdimm_bus_init(void);
 void nvdimm_bus_exit(void);
@@ -58,6 +91,7 @@ void nd_synchronize(void);
 int nvdimm_bus_register_dimms(struct nvdimm_bus *nvdimm_bus);
 int nvdimm_bus_register_regions(struct nvdimm_bus *nvdimm_bus);
 int nvdimm_bus_init_interleave_sets(struct nvdimm_bus *nvdimm_bus);
+void __nd_device_register(struct device *dev);
 int nd_match_dimm(struct device *dev, void *data);
 struct nd_label_id;
 char *nd_label_gen_id(struct nd_label_id *label_id, u8 *uuid, u32 flags);
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index bfa849617358..3bd8d650340e 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -14,11 +14,17 @@
 #define __ND_H__
 #include <linux/libnvdimm.h>
 #include <linux/device.h>
+#include <linux/genhd.h>
 #include <linux/mutex.h>
 #include <linux/ndctl.h>
 #include <linux/types.h>
+#include <linux/fs.h>
 #include "label.h"
 
+enum {
+	SECTOR_SHIFT = 9,
+};
+
 struct nvdimm_drvdata {
 	struct device *dev;
 	int nsindex_size;
@@ -94,6 +100,14 @@ static inline unsigned nd_inc_seq(unsigned seq)
 	return next[seq & 3];
 }
 
+struct nd_btt {
+	struct device dev;
+	struct block_device *backing_dev;
+	unsigned long lbasize;
+	u8 *uuid;
+	int id;
+};
+
 enum nd_async_mode {
 	ND_SYNC,
 	ND_ASYNC,
@@ -118,6 +132,9 @@ int nvdimm_init_nsarea(struct nvdimm_drvdata *ndd);
 int nvdimm_init_config_data(struct nvdimm_drvdata *ndd);
 int nvdimm_set_config_data(struct nvdimm_drvdata *ndd, size_t offset,
 		void *buf, size_t len);
+struct nd_btt *to_nd_btt(struct device *dev);
+struct btt_sb;
+u64 nd_btt_sb_checksum(struct btt_sb *btt_sb);
 struct nd_region *to_nd_region(struct device *dev);
 int nd_region_to_nstype(struct nd_region *nd_region);
 int nd_region_register_namespaces(struct nd_region *nd_region, int *err);
@@ -125,6 +142,8 @@ u64 nd_region_interleave_set_cookie(struct nd_region *nd_region);
 void nvdimm_bus_lock(struct device *dev);
 void nvdimm_bus_unlock(struct device *dev);
 bool is_nvdimm_bus_locked(struct device *dev);
+int nvdimm_bus_add_disk(struct gendisk *disk);
+void nvdimm_bus_remove_disk(struct gendisk *disk);
 void nvdimm_drvdata_release(struct kref *kref);
 void put_ndd(struct nvdimm_drvdata *ndd);
 int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd);
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index efa2cde7f6b6..1f4767150975 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -190,8 +190,6 @@ static struct pmem_device *pmem_alloc(struct device *dev,
 	set_capacity(disk, pmem->size >> 9);
 	pmem->pmem_disk = disk;
 
-	add_disk(disk);
-
 	return pmem;
 
 out_free_queue:
@@ -208,8 +206,7 @@ out:
 
 static void pmem_free(struct pmem_device *pmem)
 {
-	del_gendisk(pmem->pmem_disk);
-	put_disk(pmem->pmem_disk);
+	nvdimm_bus_remove_disk(pmem->pmem_disk);
 	blk_cleanup_queue(pmem->pmem_queue);
 	iounmap(pmem->virt_addr);
 	release_mem_region(pmem->phys_addr, pmem->size);
@@ -244,6 +241,7 @@ static int nd_pmem_probe(struct device *dev)
 		return PTR_ERR(pmem);
 
 	dev_set_drvdata(dev, pmem);
+	nvdimm_bus_add_disk(pmem->pmem_disk);
 
 	return 0;
 }
diff --git a/include/uapi/linux/ndctl.h b/include/uapi/linux/ndctl.h
index 2b94ea2287bb..4c2e3ff374b2 100644
--- a/include/uapi/linux/ndctl.h
+++ b/include/uapi/linux/ndctl.h
@@ -181,6 +181,7 @@ static inline const char *nvdimm_cmd_name(unsigned cmd)
 #define ND_DEVICE_NAMESPACE_IO 4    /* legacy persistent memory */
 #define ND_DEVICE_NAMESPACE_PMEM 5  /* PMEM namespace (may alias with BLK) */
 #define ND_DEVICE_NAMESPACE_BLK 6   /* BLK namespace (may alias with PMEM) */
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

