Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v2 13/17] libnvdimm, nfit: handle unarmed dimms,
 mark namespaces read-only
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 25 Jun 2015 05:37:28 -0400
Message-ID: <20150625093728.40066.21539.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20150625090554.40066.69562.stgit@dwillia2-desk3.jf.intel.com>
References: <20150625090554.40066.69562.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: axboe@kernel.dk, boaz@plexistor.com, toshi.kani@hp.com, linux-kernel@vger.kernel.org, hch@lst.de, linux-acpi@vger.kernel.org, linux-fsdevel@vger.kernel.org, mingo@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Upon detection of an unarmed dimm in a region, arrange for descendant
BTT, PMEM, or BLK instances to be read-only.  A dimm is primarily marked
"unarmed" via flags passed by platform firmware (NFIT).

The flags in the NFIT memory device sub-structure indicate the state of
the data on the nvdimm relative to its energy source or last "flush to
persistence".  For the most part there is nothing the driver can do but
advertise the state of these flags in sysfs and emit a message if
firmware indicates that the contents of the device may be corrupted.
However, for the case of ACPI_NFIT_MEM_ARMED, the driver can arrange for
the block devices incorporating that nvdimm to be marked read-only.
This is a safe default as the data is still available and new writes are
held off until the administrator either forces read-write mode, or the
energy source becomes armed.

A 'read_only' attribute is added to REGION devices to allow for
overriding the default read-only policy of all descendant block devices.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit.c              |   31 +++++++++++++++++++++++++++++++
 drivers/acpi/nfit.h              |    3 +++
 drivers/nvdimm/blk.c             |    2 ++
 drivers/nvdimm/btt.c             |   10 ++++++++--
 drivers/nvdimm/bus.c             |   18 ++++++++++++++++++
 drivers/nvdimm/nd.h              |    3 ++-
 drivers/nvdimm/pmem.c            |    2 ++
 drivers/nvdimm/region_devs.c     |   29 +++++++++++++++++++++++++++++
 include/linux/libnvdimm.h        |    2 ++
 tools/testing/nvdimm/test/nfit.c |    3 +++
 10 files changed, 100 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index 07d630e9f4ae..1f6f1b1a54f4 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -668,6 +668,20 @@ static ssize_t serial_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(serial);
 
+static ssize_t flags_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	u16 flags = to_nfit_memdev(dev)->flags;
+
+	return sprintf(buf, "%s%s%s%s%s\n",
+			flags & ACPI_NFIT_MEM_SAVE_FAILED ? "save " : "",
+			flags & ACPI_NFIT_MEM_RESTORE_FAILED ? "restore " : "",
+			flags & ACPI_NFIT_MEM_FLUSH_FAILED ? "flush " : "",
+			flags & ACPI_NFIT_MEM_ARMED ? "arm " : "",
+			flags & ACPI_NFIT_MEM_HEALTH_OBSERVED ? "smart " : "");
+}
+static DEVICE_ATTR_RO(flags);
+
 static struct attribute *acpi_nfit_dimm_attributes[] = {
 	&dev_attr_handle.attr,
 	&dev_attr_phys_id.attr,
@@ -676,6 +690,7 @@ static struct attribute *acpi_nfit_dimm_attributes[] = {
 	&dev_attr_format.attr,
 	&dev_attr_serial.attr,
 	&dev_attr_rev_id.attr,
+	&dev_attr_flags.attr,
 	NULL,
 };
 
@@ -768,6 +783,7 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
 		struct nvdimm *nvdimm;
 		unsigned long flags = 0;
 		u32 device_handle;
+		u16 mem_flags;
 		int rc;
 
 		device_handle = __to_nfit_memdev(nfit_mem)->device_handle;
@@ -785,6 +801,10 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
 		if (nfit_mem->bdw && nfit_mem->memdev_pmem)
 			flags |= NDD_ALIASING;
 
+		mem_flags = __to_nfit_memdev(nfit_mem)->flags;
+		if (mem_flags & ACPI_NFIT_MEM_ARMED)
+			flags |= NDD_UNARMED;
+
 		rc = acpi_nfit_add_dimm(acpi_desc, nfit_mem, device_handle);
 		if (rc)
 			continue;
@@ -797,6 +817,17 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
 
 		nfit_mem->nvdimm = nvdimm;
 		dimm_count++;
+
+		if ((mem_flags & ACPI_NFIT_MEM_FAILED_MASK) == 0)
+			continue;
+
+		dev_info(acpi_desc->dev, "%s: failed: %s%s%s%s\n",
+				nvdimm_name(nvdimm),
+			mem_flags & ACPI_NFIT_MEM_SAVE_FAILED ? "save " : "",
+			mem_flags & ACPI_NFIT_MEM_RESTORE_FAILED ? "restore " : "",
+			mem_flags & ACPI_NFIT_MEM_FLUSH_FAILED ? "flush " : "",
+			mem_flags & ACPI_NFIT_MEM_ARMED ? "arm " : "");
+
 	}
 
 	return nvdimm_bus_check_dimm_count(acpi_desc->nvdimm_bus, dimm_count);
diff --git a/drivers/acpi/nfit.h b/drivers/acpi/nfit.h
index c62fffea8423..81f2e8c5a79c 100644
--- a/drivers/acpi/nfit.h
+++ b/drivers/acpi/nfit.h
@@ -22,6 +22,9 @@
 
 #define UUID_NFIT_BUS "2f10e7a4-9e91-11e4-89d3-123b93f75cba"
 #define UUID_NFIT_DIMM "4309ac30-0d11-11e4-9191-0800200c9a66"
+#define ACPI_NFIT_MEM_FAILED_MASK (ACPI_NFIT_MEM_SAVE_FAILED \
+		| ACPI_NFIT_MEM_RESTORE_FAILED | ACPI_NFIT_MEM_FLUSH_FAILED \
+		| ACPI_NFIT_MEM_ARMED)
 
 enum nfit_uuids {
 	NFIT_SPA_VOLATILE,
diff --git a/drivers/nvdimm/blk.c b/drivers/nvdimm/blk.c
index 96ef38ceeceb..4f97b248c236 100644
--- a/drivers/nvdimm/blk.c
+++ b/drivers/nvdimm/blk.c
@@ -232,6 +232,7 @@ static int nd_blk_rw_bytes(struct nd_namespace_common *ndns,
 
 static const struct block_device_operations nd_blk_fops = {
 	.owner = THIS_MODULE,
+	.revalidate_disk = nvdimm_revalidate_disk,
 };
 
 static int nd_blk_attach_disk(struct nd_namespace_common *ndns,
@@ -283,6 +284,7 @@ static int nd_blk_attach_disk(struct nd_namespace_common *ndns,
 	}
 
 	set_capacity(disk, available_disk_size >> SECTOR_SHIFT);
+	revalidate_disk(disk);
 	return 0;
 }
 
diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index c02065aed03d..411c7b2bb37a 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1245,6 +1245,7 @@ static const struct block_device_operations btt_fops = {
 	.owner =		THIS_MODULE,
 	.rw_page =		btt_rw_page,
 	.getgeo =		btt_getgeo,
+	.revalidate_disk =	nvdimm_revalidate_disk,
 };
 
 static int btt_blk_init(struct btt *btt)
@@ -1292,6 +1293,7 @@ static int btt_blk_init(struct btt *btt)
 		}
 	}
 	set_capacity(btt->btt_disk, btt->nlba * btt->sector_size >> 9);
+	revalidate_disk(btt->btt_disk);
 
 	return 0;
 }
@@ -1346,7 +1348,11 @@ static struct btt *btt_init(struct nd_btt *nd_btt, unsigned long long rawsize,
 		goto out_free;
 	}
 
-	if (btt->init_state != INIT_READY) {
+	if (btt->init_state != INIT_READY && nd_region->ro) {
+		dev_info(dev, "%s is read-only, unable to init btt metadata\n",
+				dev_name(&nd_region->dev));
+		goto out_free;
+	} else if (btt->init_state != INIT_READY) {
 		btt->num_arenas = (rawsize / ARENA_MAX_SIZE) +
 			((rawsize % ARENA_MAX_SIZE) ? 1 : 0);
 		dev_dbg(dev, "init: %d arenas for %llu rawsize\n",
@@ -1361,7 +1367,7 @@ static struct btt *btt_init(struct nd_btt *nd_btt, unsigned long long rawsize,
 		ret = btt_meta_init(btt);
 		if (ret) {
 			dev_err(dev, "init: error in meta_init: %d\n", ret);
-			return NULL;
+			goto out_free;
 		}
 	}
 
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index dd12f38397db..ec59f1f26d95 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -227,6 +227,24 @@ int __nd_driver_register(struct nd_device_driver *nd_drv, struct module *owner,
 }
 EXPORT_SYMBOL(__nd_driver_register);
 
+int nvdimm_revalidate_disk(struct gendisk *disk)
+{
+	struct device *dev = disk->driverfs_dev;
+	struct nd_region *nd_region = to_nd_region(dev->parent);
+	const char *pol = nd_region->ro ? "only" : "write";
+
+	if (nd_region->ro == get_disk_ro(disk))
+		return 0;
+
+	dev_info(dev, "%s read-%s, marking %s read-%s\n",
+			dev_name(&nd_region->dev), pol, disk->disk_name, pol);
+	set_disk_ro(disk, nd_region->ro);
+
+	return 0;
+
+}
+EXPORT_SYMBOL(nvdimm_revalidate_disk);
+
 static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
 		char *buf)
 {
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index cf6849b72c4f..b870de9add79 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -96,7 +96,7 @@ struct nd_region {
 	u16 ndr_mappings;
 	u64 ndr_size;
 	u64 ndr_start;
-	int id, num_lanes;
+	int id, num_lanes, ro;
 	void *provider_data;
 	struct nd_interleave_set *nd_set;
 	struct nd_percpu_lane __percpu *lane;
@@ -188,6 +188,7 @@ u64 nd_region_interleave_set_cookie(struct nd_region *nd_region);
 void nvdimm_bus_lock(struct device *dev);
 void nvdimm_bus_unlock(struct device *dev);
 bool is_nvdimm_bus_locked(struct device *dev);
+int nvdimm_revalidate_disk(struct gendisk *disk);
 void nvdimm_drvdata_release(struct kref *kref);
 void put_ndd(struct nvdimm_drvdata *ndd);
 int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd);
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index a9709db0704c..42b766f33e59 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -104,6 +104,7 @@ static const struct block_device_operations pmem_fops = {
 	.owner =		THIS_MODULE,
 	.rw_page =		pmem_rw_page,
 	.direct_access =	pmem_direct_access,
+	.revalidate_disk =	nvdimm_revalidate_disk,
 };
 
 static struct pmem_device *pmem_alloc(struct device *dev,
@@ -178,6 +179,7 @@ static int pmem_attach_disk(struct nd_namespace_common *ndns,
 	pmem->pmem_disk = disk;
 
 	add_disk(disk);
+	revalidate_disk(disk);
 
 	return 0;
 }
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index fb35d451016f..8f8c7ea485f1 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -345,11 +345,35 @@ static ssize_t btt_seed_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(btt_seed);
 
+static ssize_t read_only_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nd_region *nd_region = to_nd_region(dev);
+
+	return sprintf(buf, "%d\n", nd_region->ro);
+}
+
+static ssize_t read_only_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t len)
+{
+	bool ro;
+	int rc = strtobool(buf, &ro);
+	struct nd_region *nd_region = to_nd_region(dev);
+
+	if (rc)
+		return rc;
+
+	nd_region->ro = ro;
+	return len;
+}
+static DEVICE_ATTR_RW(read_only);
+
 static struct attribute *nd_region_attributes[] = {
 	&dev_attr_size.attr,
 	&dev_attr_nstype.attr,
 	&dev_attr_mappings.attr,
 	&dev_attr_btt_seed.attr,
+	&dev_attr_read_only.attr,
 	&dev_attr_set_cookie.attr,
 	&dev_attr_available_size.attr,
 	&dev_attr_namespace_seed.attr,
@@ -641,6 +665,7 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
 	struct device *dev;
 	void *region_buf;
 	unsigned int i;
+	int ro = 0;
 
 	for (i = 0; i < ndr_desc->num_mappings; i++) {
 		struct nd_mapping *nd_mapping = &ndr_desc->nd_mapping[i];
@@ -652,6 +677,9 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
 
 			return NULL;
 		}
+
+		if (nvdimm->flags & NDD_UNARMED)
+			ro = 1;
 	}
 
 	if (dev_type == &nd_blk_device_type) {
@@ -707,6 +735,7 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
 	nd_region->provider_data = ndr_desc->provider_data;
 	nd_region->nd_set = ndr_desc->nd_set;
 	nd_region->num_lanes = ndr_desc->num_lanes;
+	nd_region->ro = ro;
 	ida_init(&nd_region->ns_ida);
 	dev = &nd_region->dev;
 	dev_set_name(dev, "region%d", nd_region->id);
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 7fc1b25bdb5d..dc799a29ed1a 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -21,6 +21,8 @@
 enum {
 	/* when a dimm supports both PMEM and BLK access a label is required */
 	NDD_ALIASING = 1 << 0,
+	/* unarmed memory devices may not persist writes */
+	NDD_UNARMED = 1 << 1,
 
 	/* need to set a limit somewhere, but yes, this is likely overkill */
 	ND_IOCTL_MAX_BUFLEN = SZ_4M,
diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index 7a4a5a5edbe4..4b69b8368de0 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -874,6 +874,9 @@ static void nfit_test1_setup(struct nfit_test *t)
 	memdev->address = 0;
 	memdev->interleave_index = 0;
 	memdev->interleave_ways = 1;
+	memdev->flags = ACPI_NFIT_MEM_SAVE_FAILED | ACPI_NFIT_MEM_RESTORE_FAILED
+		| ACPI_NFIT_MEM_FLUSH_FAILED | ACPI_NFIT_MEM_HEALTH_OBSERVED
+		| ACPI_NFIT_MEM_ARMED;
 
 	offset += sizeof(*memdev);
 	/* dcr-descriptor0 */

