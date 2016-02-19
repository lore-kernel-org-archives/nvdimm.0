Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH 1/2] ACPI/NFIT: Update Control Region Structure per ACPI 6.1
Date: Fri, 19 Feb 2016 16:08:52 -0700
Message-Id: <1455923333-13629-2-git-send-email-toshi.kani@hpe.com>
In-Reply-To: <1455923333-13629-1-git-send-email-toshi.kani@hpe.com>
References: <1455923333-13629-1-git-send-email-toshi.kani@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: rjw@rjwysocki.net, dan.j.williams@intel.com
Cc: robert.moore@intel.com, elliott@hpe.com, linux-nvdimm@lists.01.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, devel@acpica.org, Toshi Kani <toshi.kani@hpe.com>
List-ID: <linux-nvdimm@lists.01.org>

ACPI 6.1, Table 5-133, updates NVDIMM Control Region Structure
as follows.
 - Valid Fields, Manufacturing Location, and Manufacturing Date
   are added from reserved range.  No change in the structure size.
 - IDs defined as SPD values are arrays of bytes.  The spec
   clarified that they need to be represented as arrays of bytes
   as well.

This patch makes the following changes to support this update.
 - Change 'struct acpi_nfit_control_region' to reflect the update.
   SPD IDs are defined as arrays of bytes, so that they can be
   treated in the same way regardless of CPU endianness and are
   not miss-treated as little-endian numeric values.
 - Change the NFIT driver to show SPD ID values as array of bytes
   in sysfs.
 - Change the NFIT driver to show Manufacturing Location and
   Manufacturing Date when they are valid.
 - Change the NFIT driver to show an NVDIMM unique ID as defined
   in section 5.2.25.9 of the spec.
 - Change sprintf format to use "0x" instead of "#" since "%#02x"
   does not prepend '0' in some reason.

link: http://www.uefi.org/sites/default/files/resources/ACPI_6_1.pdf
Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Robert Moore <robert.moore@intel.com>
Cc: Robert Elliott <elliott@hpe.com>
Cc: <devel@acpica.org>
---
 drivers/acpi/nfit.c   |   75 ++++++++++++++++++++++++++++++++++++++++++-------
 include/acpi/actbl1.h |   24 ++++++++++------
 2 files changed, 80 insertions(+), 19 deletions(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index ad6d8c6..06677d9 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -722,7 +722,8 @@ static ssize_t vendor_show(struct device *dev,
 {
 	struct acpi_nfit_control_region *dcr = to_nfit_dcr(dev);
 
-	return sprintf(buf, "%#x\n", dcr->vendor_id);
+	return sprintf(buf, "0x%02x%02x\n",
+				dcr->vendor_id[0], dcr->vendor_id[1]);
 }
 static DEVICE_ATTR_RO(vendor);
 
@@ -731,7 +732,8 @@ static ssize_t rev_id_show(struct device *dev,
 {
 	struct acpi_nfit_control_region *dcr = to_nfit_dcr(dev);
 
-	return sprintf(buf, "%#x\n", dcr->revision_id);
+	return sprintf(buf, "0x%02x%02x\n",
+				dcr->revision_id[0], dcr->revision_id[1]);
 }
 static DEVICE_ATTR_RO(rev_id);
 
@@ -740,7 +742,8 @@ static ssize_t device_show(struct device *dev,
 {
 	struct acpi_nfit_control_region *dcr = to_nfit_dcr(dev);
 
-	return sprintf(buf, "%#x\n", dcr->device_id);
+	return sprintf(buf, "0x%02x%02x\n",
+				dcr->device_id[0], dcr->device_id[1]);
 }
 static DEVICE_ATTR_RO(device);
 
@@ -749,7 +752,7 @@ static ssize_t format_show(struct device *dev,
 {
 	struct acpi_nfit_control_region *dcr = to_nfit_dcr(dev);
 
-	return sprintf(buf, "%#x\n", dcr->code);
+	return sprintf(buf, "0x%02x%02x\n", dcr->code[0], dcr->code[1]);
 }
 static DEVICE_ATTR_RO(format);
 
@@ -758,7 +761,9 @@ static ssize_t serial_show(struct device *dev,
 {
 	struct acpi_nfit_control_region *dcr = to_nfit_dcr(dev);
 
-	return sprintf(buf, "%#x\n", dcr->serial_number);
+	return sprintf(buf, "0x%02x%02x%02x%02x\n",
+			dcr->serial_number[0], dcr->serial_number[1],
+			dcr->serial_number[2], dcr->serial_number[3]);
 }
 static DEVICE_ATTR_RO(serial);
 
@@ -776,6 +781,45 @@ static ssize_t flags_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(flags);
 
+static ssize_t mfg_location_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct acpi_nfit_control_region *dcr = to_nfit_dcr(dev);
+
+	return sprintf(buf, "0x%02x\n", dcr->manufacturing_location);
+}
+static DEVICE_ATTR_RO(mfg_location);
+
+static ssize_t mfg_date_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct acpi_nfit_control_region *dcr = to_nfit_dcr(dev);
+
+	return sprintf(buf, "0x%02x%02x\n",
+			dcr->manufacturing_date[0], dcr->manufacturing_date[1]);
+}
+static DEVICE_ATTR_RO(mfg_date);
+
+static ssize_t unique_id_show(struct device *dev,
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
+static DEVICE_ATTR_RO(unique_id);
+
 static struct attribute *acpi_nfit_dimm_attributes[] = {
 	&dev_attr_handle.attr,
 	&dev_attr_phys_id.attr,
@@ -785,6 +829,9 @@ static struct attribute *acpi_nfit_dimm_attributes[] = {
 	&dev_attr_serial.attr,
 	&dev_attr_rev_id.attr,
 	&dev_attr_flags.attr,
+	&dev_attr_mfg_location.attr,
+	&dev_attr_mfg_date.attr,
+	&dev_attr_unique_id.attr,
 	NULL,
 };
 
@@ -792,11 +839,18 @@ static umode_t acpi_nfit_dimm_attr_visible(struct kobject *kobj,
 		struct attribute *a, int n)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
+	struct acpi_nfit_control_region *dcr = to_nfit_dcr(dev);
 
-	if (to_nfit_dcr(dev))
-		return a->mode;
-	else
+	if (dcr) {
+		if (!(dcr->valid_fields & ACPI_NFIT_CONTROL_MFG_INFO_VALID) &&
+		    (a == &dev_attr_mfg_location.attr ||
+		     a == &dev_attr_mfg_date.attr))
+			return 0;
+		else
+			return a->mode;
+	} else {
 		return 0;
+	}
 }
 
 static struct attribute_group acpi_nfit_dimm_attribute_group = {
@@ -956,7 +1010,7 @@ static const struct attribute_group *acpi_nfit_region_attribute_groups[] = {
 struct nfit_set_info {
 	struct nfit_set_info_map {
 		u64 region_offset;
-		u32 serial_number;
+		u8 serial_number[4];
 		u32 pad;
 	} mapping[0];
 };
@@ -1025,7 +1079,8 @@ static int acpi_nfit_init_interleave_set(struct acpi_nfit_desc *acpi_desc,
 		}
 
 		map->region_offset = memdev->region_offset;
-		map->serial_number = nfit_mem->dcr->serial_number;
+		memcpy(map->serial_number, nfit_mem->dcr->serial_number,
+				sizeof(map->serial_number));
 	}
 
 	sort(&info->mapping[0], nr, sizeof(struct nfit_set_info_map),
diff --git a/include/acpi/actbl1.h b/include/acpi/actbl1.h
index 16e0136..d8df62c 100644
--- a/include/acpi/actbl1.h
+++ b/include/acpi/actbl1.h
@@ -1040,15 +1040,18 @@ struct acpi_nfit_smbios {
 struct acpi_nfit_control_region {
 	struct acpi_nfit_header header;
 	u16 region_index;
-	u16 vendor_id;
-	u16 device_id;
-	u16 revision_id;
-	u16 subsystem_vendor_id;
-	u16 subsystem_device_id;
-	u16 subsystem_revision_id;
-	u8 reserved[6];		/* Reserved, must be zero */
-	u32 serial_number;
-	u16 code;
+	u8 vendor_id[2];
+	u8 device_id[2];
+	u8 revision_id[2];
+	u8 subsystem_vendor_id[2];
+	u8 subsystem_device_id[2];
+	u8 subsystem_revision_id[2];
+	u8 valid_fields;
+	u8 manufacturing_location;
+	u8 manufacturing_date[2];
+	u8 reserved[2];		/* Reserved, must be zero */
+	u8 serial_number[4];
+	u8 code[2];
 	u16 windows;
 	u64 window_size;
 	u64 command_offset;
@@ -1059,6 +1062,9 @@ struct acpi_nfit_control_region {
 	u8 reserved1[6];	/* Reserved, must be zero */
 };
 
+/* Valid Fields */
+#define ACPI_NFIT_CONTROL_MFG_INFO_VALID (1)	/* Manufacturing fields are valid */
+
 /* Flags */
 
 #define ACPI_NFIT_CONTROL_BUFFERED      (1)	/* Block Data Windows implementation is buffered */
