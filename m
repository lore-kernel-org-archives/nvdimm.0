Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH v2 2/3] ACPI/NFIT: Add NVDIMM ID "id" under sysfs
Date: Mon, 22 Feb 2016 14:55:29 -0700
Message-Id: <1456178130-26468-3-git-send-email-toshi.kani@hpe.com>
In-Reply-To: <1456178130-26468-1-git-send-email-toshi.kani@hpe.com>
References: <1456178130-26468-1-git-send-email-toshi.kani@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: rjw@rjwysocki.net, dan.j.williams@intel.com
Cc: robert.moore@intel.com, lv.zheng@intel.com, elliott@hpe.com, linux-nvdimm@lists.01.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, devel@acpica.org, Toshi Kani <toshi.kani@hpe.com>
List-ID: <linux-nvdimm@lists.01.org>

ACPI 6.1, section 5.2.25.9, defines an identifier for an NVDIMM.

Change the NFIT driver to create read-only "id" file under NVDIMM's
nfit directory of sysfs, which shows the NVDIMM ID.

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Robert Elliott <elliott@hpe.com>
---
 drivers/acpi/nfit.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index 4982a18..677cf89 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -781,6 +781,26 @@ static ssize_t flags_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(flags);
 
+static ssize_t id_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct acpi_nfit_control_region *dcr = to_nfit_dcr(dev);
+
+	if (dcr->valid_fields & ACPI_NFIT_CONTROL_MFG_INFO_VALID)
+		return sprintf(buf, "%02x%02x-%02x-%02x%02x-%02x%02x%02x%02x\n",
+			dcr->vendor_id[0], dcr->vendor_id[1],
+			dcr->manufacturing_location,
+			dcr->manufacturing_date[0], dcr->manufacturing_date[1],
+			dcr->serial_number[0], dcr->serial_number[1],
+			dcr->serial_number[2], dcr->serial_number[3]);
+	else
+		return sprintf(buf, "%02x%02x-%02x%02x%02x%02x\n",
+			dcr->vendor_id[0], dcr->vendor_id[1],
+			dcr->serial_number[0], dcr->serial_number[1],
+			dcr->serial_number[2], dcr->serial_number[3]);
+}
+static DEVICE_ATTR_RO(id);
+
 static struct attribute *acpi_nfit_dimm_attributes[] = {
 	&dev_attr_handle.attr,
 	&dev_attr_phys_id.attr,
@@ -790,6 +810,7 @@ static struct attribute *acpi_nfit_dimm_attributes[] = {
 	&dev_attr_serial.attr,
 	&dev_attr_rev_id.attr,
 	&dev_attr_flags.attr,
+	&dev_attr_id.attr,
 	NULL,
 };
 
