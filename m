Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id 878281A1F89
 for <linux-nvdimm@lists.01.org>; Fri, 29 Apr 2016 16:30:18 -0700 (PDT)
Subject: [PATCH] nfit: export subsystem ids as attributes
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 29 Apr 2016 16:29:29 -0700
Message-ID: <146197256983.7472.9730965818719498272.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Ryon Jensen <ryon.jensen@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Similar to pci-sysfs export the subsystem information available in the
NFIT.  ACPI 6.1 clarifies that this data is copied as an array of bytes
from the DIMM SPD data.

Reported-by: Ryon Jensen <ryon.jensen@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit.c |   33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index 5a7199db2e06..0a1ba3d2e39a 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -847,6 +847,34 @@ static ssize_t format_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(format);
 
+static ssize_t subsystem_vendor_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct acpi_nfit_control_region *dcr = to_nfit_dcr(dev);
+
+	return sprintf(buf, "0x%04x\n", be16_to_cpu(dcr->subsystem_vendor_id));
+}
+static DEVICE_ATTR_RO(subsystem_vendor);
+
+static ssize_t subsystem_rev_id_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct acpi_nfit_control_region *dcr = to_nfit_dcr(dev);
+
+	return sprintf(buf, "0x%04x\n",
+			be16_to_cpu(dcr->subsystem_revision_id));
+}
+static DEVICE_ATTR_RO(subsystem_rev_id);
+
+static ssize_t subsystem_device_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct acpi_nfit_control_region *dcr = to_nfit_dcr(dev);
+
+	return sprintf(buf, "0x%04x\n", be16_to_cpu(dcr->subsystem_device_id));
+}
+static DEVICE_ATTR_RO(subsystem_device);
+
 static ssize_t serial_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -893,9 +921,12 @@ static struct attribute *acpi_nfit_dimm_attributes[] = {
 	&dev_attr_phys_id.attr,
 	&dev_attr_vendor.attr,
 	&dev_attr_device.attr,
+	&dev_attr_rev_id.attr,
+	&dev_attr_subsystem_vendor.attr,
+	&dev_attr_subsystem_device.attr,
+	&dev_attr_subsystem_rev_id.attr,
 	&dev_attr_format.attr,
 	&dev_attr_serial.attr,
-	&dev_attr_rev_id.attr,
 	&dev_attr_flags.attr,
 	&dev_attr_id.attr,
 	NULL,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
