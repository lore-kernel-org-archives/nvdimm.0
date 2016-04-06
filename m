Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id 7654B1A1F82
 for <linux-nvdimm@lists.01.org>; Tue,  5 Apr 2016 17:36:08 -0700 (PDT)
Subject: [PATCH] libnvdimm, nfit: report multiple interface codes per-dimm
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 05 Apr 2016 17:35:15 -0700
Message-ID: <20160406003515.6719.15443.stgit@dwillia2-desk3.jf.intel.com>
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
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Starting with ACPI 6.1 an NFIT table will report multiple 'NVDIMM
Control Region Structure' instances per-dimm, one for each supported
format interface.  Report that code in the following format in sysfs:

    nmemX/nfit/formats
    nmemX/nfit/format
    nmemX/nfit/format1
    nmemX/nfit/format2
    ...
    nmemX/nfit/formatN

Where format2 - formatN are theoretical as there are no known DIMMs with
support for more than two interface formats.

This layout is compatible with existing libndctl binaries that only
expect one code per-dimm as they will ignore nmemX/nfit/formats and
nmemX/nfit/formatN.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit.c |   73 +++++++++++++++++++++++++++++++++++++++++++++++++--
 drivers/acpi/nfit.h |    1 +
 2 files changed, 71 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index d0f35e63640b..239556126051 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -655,6 +655,7 @@ static int nfit_mem_dcr_init(struct acpi_nfit_desc *acpi_desc,
 			if (!nfit_mem)
 				return -ENOMEM;
 			INIT_LIST_HEAD(&nfit_mem->list);
+			nfit_mem->acpi_desc = acpi_desc;
 			list_add(&nfit_mem->list, &acpi_desc->dimms);
 		}
 
@@ -838,6 +839,18 @@ static ssize_t device_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(device);
 
+static int num_nvdimm_formats(struct nvdimm *nvdimm)
+{
+	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
+	int formats = 0;
+
+	if (nfit_mem->memdev_pmem)
+		formats++;
+	if (nfit_mem->memdev_bdw)
+		formats++;
+	return formats;
+}
+
 static ssize_t format_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -847,6 +860,56 @@ static ssize_t format_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(format);
 
+static ssize_t format1_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	u32 handle;
+	ssize_t rc = -ENXIO;
+	struct nfit_mem *nfit_mem;
+	struct nfit_memdev *nfit_memdev;
+	struct acpi_nfit_desc *acpi_desc;
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+	struct acpi_nfit_control_region *dcr = to_nfit_dcr(dev);
+
+	nfit_mem = nvdimm_provider_data(nvdimm);
+	acpi_desc = nfit_mem->acpi_desc;
+	handle = to_nfit_memdev(dev)->device_handle;
+
+	/* assumes DIMMs have at most 2 published interface codes */
+	mutex_lock(&acpi_desc->init_mutex);
+	list_for_each_entry(nfit_memdev, &acpi_desc->memdevs, list) {
+		struct acpi_nfit_memory_map *memdev = nfit_memdev->memdev;
+		struct nfit_dcr *nfit_dcr;
+
+		if (memdev->device_handle != handle)
+			continue;
+
+		dev_dbg(dev, "memdev: %d\n", memdev->region_index);
+		list_for_each_entry(nfit_dcr, &acpi_desc->dcrs, list) {
+			if (nfit_dcr->dcr->region_index != memdev->region_index)
+				continue;
+			if (nfit_dcr->dcr->code == dcr->code)
+				continue;
+			rc = sprintf(buf, "%#x\n", nfit_dcr->dcr->code);
+			break;
+		}
+		if (rc != ENXIO)
+			break;
+	}
+	mutex_unlock(&acpi_desc->init_mutex);
+	return rc;
+}
+static DEVICE_ATTR_RO(format1);
+
+static ssize_t formats_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+
+	return sprintf(buf, "%d\n", num_nvdimm_formats(nvdimm));
+}
+static DEVICE_ATTR_RO(formats);
+
 static ssize_t serial_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -876,6 +939,8 @@ static struct attribute *acpi_nfit_dimm_attributes[] = {
 	&dev_attr_vendor.attr,
 	&dev_attr_device.attr,
 	&dev_attr_format.attr,
+	&dev_attr_formats.attr,
+	&dev_attr_format1.attr,
 	&dev_attr_serial.attr,
 	&dev_attr_rev_id.attr,
 	&dev_attr_flags.attr,
@@ -886,11 +951,13 @@ static umode_t acpi_nfit_dimm_attr_visible(struct kobject *kobj,
 		struct attribute *a, int n)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
+	struct nvdimm *nvdimm = to_nvdimm(dev);
 
-	if (to_nfit_dcr(dev))
-		return a->mode;
-	else
+	if (!to_nfit_dcr(dev))
+		return 0;
+	if (a == &dev_attr_format1.attr && num_nvdimm_formats(nvdimm) <= 1)
 		return 0;
+	return a->mode;
 }
 
 static struct attribute_group acpi_nfit_dimm_attribute_group = {
diff --git a/drivers/acpi/nfit.h b/drivers/acpi/nfit.h
index c75576b2d50e..5201840c1147 100644
--- a/drivers/acpi/nfit.h
+++ b/drivers/acpi/nfit.h
@@ -109,6 +109,7 @@ struct nfit_mem {
 	struct nfit_flush *nfit_flush;
 	struct list_head list;
 	struct acpi_device *adev;
+	struct acpi_nfit_desc *acpi_desc;
 	unsigned long dsm_mask;
 };
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
