Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH 15/15] libnvdimm, nfit: handle acpi_nfit_memory_map flags
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 17 Jun 2015 19:56:08 -0400
Message-ID: <20150617235608.12943.82647.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150617235209.12943.24419.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150617235209.12943.24419.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, linux-nvdimm@lists.01.org
Cc: boaz@plexistor.com, toshi.kani@hp.com, linux-kernel@vger.kernel.org, hch@lst.de, linux-acpi@vger.kernel.org, linux-fsdevel@vger.kernel.org, mingo@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The flags in this NFIT sub-structure indicate the state of the data on
the nvdimm relative to its energy source or last "flush to persistence".
For the most part there is nothing the driver can do but advertise the
state of these flags in sysfs and emit a message if firmware indicates
that the contents of the device may be corrupted.  However, for the case
of ACPI_NFIT_MEM_ARMED, the driver can arrange for the block devices
incorporating that nvdimm to be marked read-only.  This is a safe
default as the data is still available and new writes are held off until
the administrator either forces read-write mode, or the energy source
becomes armed.

A module parameter "force_rw" is added to allow the default to be
overridden.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit.c              |   35 +++++++++++++++++++++++++++++++++++
 drivers/acpi/nfit.h              |    3 +++
 drivers/nvdimm/blk.c             |    1 +
 drivers/nvdimm/bus.c             |   27 +++++++++++++++++++++++++++
 drivers/nvdimm/nd-core.h         |    1 +
 drivers/nvdimm/nd.h              |    1 +
 drivers/nvdimm/pmem.c            |    1 +
 drivers/nvdimm/region_devs.c     |   13 +++++++++++++
 include/linux/libnvdimm.h        |    2 ++
 tools/testing/nvdimm/test/nfit.c |    3 +++
 10 files changed, 87 insertions(+)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index 9363e4b0e6a7..5f645823d7d7 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -27,6 +27,10 @@ static bool force_enable_dimms;
 module_param(force_enable_dimms, bool, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(force_enable_dimms, "Ignore _STA (ACPI DIMM device) status");
 
+static bool force_rw;
+module_param(force_rw, bool, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(force_rw, "Enable writes to DIMMs that failed to arm");
+
 static u8 nfit_uuid[NFIT_UUID_MAX][16];
 
 const u8 *to_nfit_uuid(enum nfit_uuids id)
@@ -664,6 +668,20 @@ static ssize_t serial_show(struct device *dev,
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
@@ -672,6 +690,7 @@ static struct attribute *acpi_nfit_dimm_attributes[] = {
 	&dev_attr_format.attr,
 	&dev_attr_serial.attr,
 	&dev_attr_rev_id.attr,
+	&dev_attr_flags.attr,
 	NULL,
 };
 
@@ -764,6 +783,7 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
 		struct nvdimm *nvdimm;
 		unsigned long flags = 0;
 		u32 device_handle;
+		u16 mem_flags;
 		int rc;
 
 		device_handle = __to_nfit_memdev(nfit_mem)->device_handle;
@@ -781,6 +801,10 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
 		if (nfit_mem->bdw && nfit_mem->memdev_pmem)
 			flags |= NDD_ALIASING;
 
+		mem_flags = __to_nfit_memdev(nfit_mem)->flags;
+		if ((mem_flags & ACPI_NFIT_MEM_ARMED) && !force_rw)
+			flags |= NDD_UNARMED;
+
 		rc = acpi_nfit_add_dimm(acpi_desc, nfit_mem, device_handle);
 		if (rc)
 			continue;
@@ -793,6 +817,17 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
 
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
index adacc27f04f1..0b359cb8aa9f 100644
--- a/drivers/nvdimm/blk.c
+++ b/drivers/nvdimm/blk.c
@@ -243,6 +243,7 @@ static const struct block_device_operations nd_blk_fops = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = nvdimm_bdev_compat_ioctl,
 #endif
+	.revalidate_disk = nvdimm_revalidate_disk,
 };
 
 static int nd_blk_probe(struct device *dev)
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 47260ca573e0..67525f995859 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -243,6 +243,32 @@ int __nd_driver_register(struct nd_device_driver *nd_drv, struct module *owner,
 }
 EXPORT_SYMBOL(__nd_driver_register);
 
+int nvdimm_revalidate_disk(struct gendisk *disk)
+{
+	int i;
+	struct device *dev = disk->driverfs_dev;
+	struct nd_region *nd_region = walk_to_nd_region(dev);
+
+	if (!nd_region)
+		return 0;
+
+	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+		struct nvdimm *nvdimm = nd_mapping->nvdimm;
+
+		if ((nvdimm->flags & NDD_UNARMED) && !get_disk_ro(disk)) {
+			dev_dbg(dev, "%s: unarmed, marking disk %s ro\n",
+					dev_name(&nvdimm->dev),
+					dev_name(disk_to_dev(disk)));
+			set_disk_ro(disk, 1);
+			break;
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(nvdimm_revalidate_disk);
+
 int nvdimm_bus_add_integrity_disk(struct gendisk *disk, u32 lbasize,
 		sector_t size)
 {
@@ -265,6 +291,7 @@ int nvdimm_bus_add_integrity_disk(struct gendisk *disk, u32 lbasize,
 	rc = nd_integrity_init(disk, lbasize);
 	if (size)
 		set_capacity(disk, size);
+	revalidate_disk(disk);
 	nd_btt_add_disk(nvdimm_bus, disk);
 	nvdimm_bus_unlock(&nvdimm_bus->dev);
 
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index ba548d248b4e..0cac05aca8f5 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -110,6 +110,7 @@ bool nd_is_uuid_unique(struct device *dev, u8 *uuid);
 struct nd_region;
 struct nvdimm_drvdata;
 struct nd_mapping;
+struct nd_region *walk_to_nd_region(struct device *nd_dev);
 resource_size_t nd_pmem_available_dpa(struct nd_region *nd_region,
 		struct nd_mapping *nd_mapping, resource_size_t *overlap);
 resource_size_t nd_blk_available_dpa(struct nd_mapping *nd_mapping);
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 2786eb8456ec..011d7c51b5da 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -168,6 +168,7 @@ int nvdimm_bdev_ioctl(struct block_device *bdev, fmode_t mode,
 		unsigned int cmd, unsigned long arg);
 int nvdimm_bdev_compat_ioctl(struct block_device *bdev, fmode_t mode,
 		unsigned int cmd, unsigned long arg);
+int nvdimm_revalidate_disk(struct gendisk *disk);
 void nvdimm_drvdata_release(struct kref *kref);
 void put_ndd(struct nvdimm_drvdata *ndd);
 int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd);
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 96964419b72d..b69278424dff 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -135,6 +135,7 @@ static const struct block_device_operations pmem_fops = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl =		nvdimm_bdev_ioctl,
 #endif
+	.revalidate_disk =	nvdimm_revalidate_disk,
 };
 
 static struct pmem_device *pmem_alloc(struct device *dev,
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index b16ec20dbba2..bb9f329c3b9f 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -83,6 +83,19 @@ struct nd_blk_region *to_nd_blk_region(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(to_nd_blk_region);
 
+struct nd_region *walk_to_nd_region(struct device *nd_dev)
+{
+	struct device *dev;
+
+	for (dev = nd_dev; dev; dev = dev->parent)
+		if (dev->type->release == nd_region_release)
+			break;
+	dev_WARN_ONCE(nd_dev, !dev, "invalid dev, not an nd_region descendant\n");
+	if (dev)
+		return to_nd_region(dev);
+	return NULL;
+}
+
 void *nd_region_provider_data(struct nd_region *nd_region)
 {
 	return nd_region->provider_data;
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
index 416f8fbf9881..c57ecb4e421d 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -873,6 +873,9 @@ static void nfit_test1_setup(struct nfit_test *t)
 	memdev->address = 0;
 	memdev->interleave_index = 0;
 	memdev->interleave_ways = 1;
+	memdev->flags = ACPI_NFIT_MEM_SAVE_FAILED | ACPI_NFIT_MEM_RESTORE_FAILED
+		| ACPI_NFIT_MEM_FLUSH_FAILED | ACPI_NFIT_MEM_HEALTH_OBSERVED
+		| ACPI_NFIT_MEM_ARMED;
 
 	offset += sizeof(*memdev);
 	/* dcr-descriptor0 */

