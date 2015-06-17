Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Subject: [PATCH 14/15] libnvdimm: support read-only btt backing devices
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 17 Jun 2015 19:56:02 -0400
Message-ID: <20150617235602.12943.24958.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150617235209.12943.24419.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150617235209.12943.24419.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: axboe@kernel.dk, linux-nvdimm@lists.01.org
Cc: boaz@plexistor.com, toshi.kani@hp.com, linux-kernel@vger.kernel.org, hch@lst.de, linux-acpi@vger.kernel.org, linux-fsdevel@vger.kernel.org, mingo@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Upon detection of a read-only backing device arrange for the btt to
device to be read only.  Implement a catch for the BLKROSET ioctl and
only allow a btt-instance to become read-write when the backing-device
becomes read-write.  Conversely, if a backing-device becomes read-only
arrange for its parent btt to be marked read-only.  Synchronize these
changes under the bus lock.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/blk.c      |    4 +++
 drivers/nvdimm/btt.c      |   34 ++++++++++++++++++++++++++--
 drivers/nvdimm/btt_devs.c |   42 ++++++++++++++++++++++++++++++++++
 drivers/nvdimm/bus.c      |   55 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/nvdimm/nd-core.h  |   14 +++++++++++
 drivers/nvdimm/nd.h       |    4 +++
 drivers/nvdimm/pmem.c     |    4 +++
 7 files changed, 154 insertions(+), 3 deletions(-)

diff --git a/drivers/nvdimm/blk.c b/drivers/nvdimm/blk.c
index 8a65e5a500d8..adacc27f04f1 100644
--- a/drivers/nvdimm/blk.c
+++ b/drivers/nvdimm/blk.c
@@ -239,6 +239,10 @@ static int nd_blk_rw_bytes(struct gendisk *disk, resource_size_t offset,
 static const struct block_device_operations nd_blk_fops = {
 	.owner = THIS_MODULE,
 	.rw_bytes = nd_blk_rw_bytes,
+	.ioctl = nvdimm_bdev_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = nvdimm_bdev_compat_ioctl,
+#endif
 };
 
 static int nd_blk_probe(struct device *dev)
diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 67484633c322..57d3b271e451 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1248,10 +1248,29 @@ static int btt_getgeo(struct block_device *bd, struct hd_geometry *geo)
 	return 0;
 }
 
+static int btt_revalidate_disk(struct gendisk *disk)
+{
+	struct btt *btt = disk->private_data;
+	struct nd_btt *nd_btt = btt->nd_btt;
+	struct block_device *bdev = nd_btt->backing_dev;
+	char name[BDEVNAME_SIZE];
+
+	dev_dbg(&nd_btt->dev, "backing dev: %s read-%s", bdevname(bdev, name),
+			bdev_read_only(bdev) ? "only" : "write");
+	if (bdev_read_only(bdev))
+		set_disk_ro(disk, 1);
+	return 0;
+}
+
 static const struct block_device_operations btt_fops = {
 	.owner =		THIS_MODULE,
 	.rw_page =		btt_rw_page,
 	.getgeo =		btt_getgeo,
+	.ioctl =		nvdimm_bdev_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl =		nvdimm_bdev_compat_ioctl,
+#endif
+	.revalidate_disk =	btt_revalidate_disk,
 };
 
 static int btt_blk_init(struct btt *btt)
@@ -1296,6 +1315,7 @@ static int btt_blk_init(struct btt *btt)
 	}
 
 	set_capacity(btt->btt_disk, btt->nlba * btt->sector_size >> 9);
+	revalidate_disk(btt->btt_disk);
 
 	return 0;
 
@@ -1335,6 +1355,7 @@ static struct btt *btt_init(struct nd_btt *nd_btt, unsigned long long rawsize,
 	int ret;
 	struct btt *btt;
 	struct device *dev = &nd_btt->dev;
+	struct block_device *bdev = nd_btt->backing_dev;
 
 	btt = kzalloc(sizeof(struct btt), GFP_KERNEL);
 	if (!btt)
@@ -1354,7 +1375,13 @@ static struct btt *btt_init(struct nd_btt *nd_btt, unsigned long long rawsize,
 		goto out_free;
 	}
 
-	if (btt->init_state != INIT_READY) {
+	if (btt->init_state != INIT_READY && bdev_read_only(bdev)) {
+		char name[BDEVNAME_SIZE];
+
+		dev_info(dev, "%s is read-only, unable to init btt metadata\n",
+				bdevname(bdev, name));
+		goto out_free;
+	} else if (btt->init_state != INIT_READY) {
 		btt->num_arenas = (rawsize / ARENA_MAX_SIZE) +
 			((rawsize % ARENA_MAX_SIZE) ? 1 : 0);
 		dev_dbg(dev, "init: %d arenas for %llu rawsize\n",
@@ -1369,7 +1396,7 @@ static struct btt *btt_init(struct nd_btt *nd_btt, unsigned long long rawsize,
 		ret = btt_meta_init(btt);
 		if (ret) {
 			dev_err(dev, "init: error in meta_init: %d\n", ret);
-			return NULL;
+			goto out_free;
 		}
 	}
 
@@ -1481,7 +1508,10 @@ static int nd_btt_remove(struct device *dev)
 	struct nd_btt *nd_btt = to_nd_btt(dev);
 	struct btt *btt = dev_get_drvdata(dev);
 
+	nvdimm_bus_lock(dev);
 	btt_fini(btt);
+	nvdimm_bus_unlock(dev);
+
 	unlink_btt(nd_btt);
 
 	return 0;
diff --git a/drivers/nvdimm/btt_devs.c b/drivers/nvdimm/btt_devs.c
index 02e125b91e77..bcf77dca1532 100644
--- a/drivers/nvdimm/btt_devs.c
+++ b/drivers/nvdimm/btt_devs.c
@@ -122,7 +122,7 @@ static ssize_t backing_dev_show(struct device *dev,
 		return sprintf(buf, "\n");
 }
 
-static const fmode_t nd_btt_devs_mode = FMODE_READ | FMODE_WRITE | FMODE_EXCL;
+static const fmode_t nd_btt_devs_mode = FMODE_READ | FMODE_EXCL;
 
 static void nd_btt_remove_bdev(struct nd_btt *nd_btt, const char *caller)
 {
@@ -363,6 +363,46 @@ u64 nd_btt_sb_checksum(struct btt_sb *btt_sb)
 }
 EXPORT_SYMBOL(nd_btt_sb_checksum);
 
+int set_btt_ro(struct block_device *bdev, struct device *dev, int ro)
+{
+	struct nd_btt *nd_btt = to_nd_btt(dev);
+
+	if (!dev->driver)
+		return 0;
+
+	/* we can only mark a btt device rw if its backing device is rw */
+	if (bdev_read_only(nd_btt->backing_dev) && !ro)
+		return -EBUSY;
+
+	set_device_ro(bdev, ro);
+	return 0;
+}
+
+int set_btt_disk_ro(struct device *dev, void *data)
+{
+	struct block_device *bdev = data;
+	struct nd_btt *nd_btt;
+	struct btt *btt;
+
+	if (!is_nd_btt(dev))
+		return 0;
+
+	nd_btt = to_nd_btt(dev);
+	if (nd_btt->backing_dev != bdev)
+		return 0;
+
+	/*
+	 * We have the lock at this point and have flushed probing.  We
+	 * are guaranteed that the btt driver is unbound, or has
+	 * completed setup operations and is blocked from initiating
+	 * disk teardown until we are done walking these pointers.
+	 */
+	btt = dev_get_drvdata(dev);
+	if (btt && btt->btt_disk)
+		set_disk_ro(btt->btt_disk, 1);
+	return 0;
+}
+
 static struct nd_btt *__nd_btt_autodetect(struct nvdimm_bus *nvdimm_bus,
 		struct block_device *bdev, struct btt_sb *btt_sb)
 {
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index d4fbc48f5643..47260ca573e0 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -309,6 +309,61 @@ void nvdimm_bus_remove_disk(struct gendisk *disk)
 }
 EXPORT_SYMBOL(nvdimm_bus_remove_disk);
 
+static int set_namespace_ro(struct block_device *bdev,
+		struct nvdimm_bus *nvdimm_bus, int ro)
+{
+	set_device_ro(bdev, ro);
+
+	/*
+	 * It's possible to mark the backing device rw while leaving the
+	 * btt device read-only.  However, marking a backing device
+	 * read-only always marks the parent btt read-only.
+	 */
+	if (!ro)
+		return 0;
+	return device_for_each_child(&nvdimm_bus->dev, bdev, set_btt_disk_ro);
+}
+
+int nvdimm_bdev_ioctl(struct block_device *bdev, fmode_t mode,
+		unsigned int cmd, unsigned long arg)
+{
+	int rc, ro;
+	struct gendisk *disk = bdev->bd_disk;
+	struct device *dev = disk->driverfs_dev;
+	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
+
+	if (cmd != BLKROSET)
+		return -ENOTTY;
+
+	if (get_user(ro, (int __user *)(arg)))
+		return -EFAULT;
+
+	if (ro == 0 || ro == 1)
+		/* pass */;
+	else
+		return -EINVAL;
+
+	nvdimm_bus_lock(&nvdimm_bus->dev);
+	wait_nvdimm_bus_probe_idle(&nvdimm_bus->dev);
+	if (bdev_read_only(bdev) == ro)
+		rc = 0;
+	else if (is_nd_btt(dev))
+		rc = set_btt_ro(bdev, dev, ro);
+	else
+		rc = set_namespace_ro(bdev, nvdimm_bus, ro);
+	nvdimm_bus_unlock(&nvdimm_bus->dev);
+
+	return rc;
+}
+EXPORT_SYMBOL(nvdimm_bdev_ioctl);
+
+int nvdimm_bdev_compat_ioctl(struct block_device *bdev, fmode_t mode,
+		unsigned int cmd, unsigned long arg)
+{
+	return nvdimm_bdev_ioctl(bdev, mode, cmd, arg);
+}
+EXPORT_SYMBOL(nvdimm_bdev_compat_ioctl);
+
 static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
 		char *buf)
 {
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 9a90915e6fd2..ba548d248b4e 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -49,11 +49,14 @@ bool is_nvdimm(struct device *dev);
 bool is_nd_pmem(struct device *dev);
 bool is_nd_blk(struct device *dev);
 struct gendisk;
+struct block_device;
 #if IS_ENABLED(CONFIG_ND_BTT_DEVS)
 bool is_nd_btt(struct device *dev);
 struct nd_btt *nd_btt_create(struct nvdimm_bus *nvdimm_bus);
 void nd_btt_add_disk(struct nvdimm_bus *nvdimm_bus, struct gendisk *disk);
 void nd_btt_remove_disk(struct nvdimm_bus *nvdimm_bus, struct gendisk *disk);
+int set_btt_ro(struct block_device *bdev, struct device *dev, int ro);
+int set_btt_disk_ro(struct device *dev, void *data);
 #else
 static inline bool is_nd_btt(struct device *dev)
 {
@@ -74,6 +77,17 @@ static inline void nd_btt_remove_disk(struct nvdimm_bus *nvdimm_bus,
 		struct gendisk *disk)
 {
 }
+
+static inline int set_btt_ro(struct block_device *bdev, struct device *dev,
+		int ro)
+{
+	return 0;
+}
+
+static inline int set_btt_disk_ro(struct device *dev, void *data)
+{
+	return 0;
+}
 #endif
 struct nvdimm_bus *walk_to_nvdimm_bus(struct device *nd_dev);
 int __init nvdimm_bus_init(void);
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 3c4c8b6c64ec..2786eb8456ec 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -164,6 +164,10 @@ int nvdimm_bus_add_disk(struct gendisk *disk);
 int nvdimm_bus_add_integrity_disk(struct gendisk *disk, u32 lbasize,
 		sector_t size);
 void nvdimm_bus_remove_disk(struct gendisk *disk);
+int nvdimm_bdev_ioctl(struct block_device *bdev, fmode_t mode,
+		unsigned int cmd, unsigned long arg);
+int nvdimm_bdev_compat_ioctl(struct block_device *bdev, fmode_t mode,
+		unsigned int cmd, unsigned long arg);
 void nvdimm_drvdata_release(struct kref *kref);
 void put_ndd(struct nvdimm_drvdata *ndd);
 int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd);
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 3fd854a78f09..96964419b72d 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -131,6 +131,10 @@ static const struct block_device_operations pmem_fops = {
 	.rw_page =		pmem_rw_page,
 	.rw_bytes =		pmem_rw_bytes,
 	.direct_access =	pmem_direct_access,
+	.ioctl =		nvdimm_bdev_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl =		nvdimm_bdev_ioctl,
+#endif
 };
 
 static struct pmem_device *pmem_alloc(struct device *dev,

