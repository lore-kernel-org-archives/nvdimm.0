Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A378A21159902
 for <linux-nvdimm@lists.01.org>; Wed, 26 Sep 2018 21:37:46 -0700 (PDT)
Subject: [PATCH 2/3] acpi, nfit: Collect shutdown status
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 26 Sep 2018 21:24:31 -0700
Message-ID: <153802227150.833068.16202031710309659911.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <153802226065.833068.11943510429252969385.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <153802226065.833068.11943510429252969385.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Some NVDIMMs, in addition to providing an indication of whether the
previous shutdown was clean, also provide a running count of lifetime
dirty-shutdown events for the device. In anticipation of this
functionality appearing on more devices arrange for the nfit driver to
retrieve / cache this data at DIMM discovery time, and export it via
sysfs.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c              |   76 +++++++++++++++++++++++++++++++++
 drivers/acpi/nfit/intel.h             |   34 +++++++++++++++
 drivers/acpi/nfit/nfit.h              |    3 +
 tools/testing/nvdimm/test/nfit_test.h |   24 ----------
 4 files changed, 112 insertions(+), 25 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index f6944f9011fd..c28b4d0dbe51 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1560,7 +1560,12 @@ static DEVICE_ATTR_RO(dsm_mask);
 static ssize_t flags_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	u16 flags = to_nfit_memdev(dev)->flags;
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
+	u16 flags = __to_nfit_memdev(nfit_mem)->flags;
+
+	if (test_bit(NFIT_MEM_DIRTY, &nfit_mem->flags))
+		flags |= ACPI_NFIT_MEM_FLUSH_FAILED;
 
 	return sprintf(buf, "%s%s%s%s%s%s%s\n",
 		flags & ACPI_NFIT_MEM_SAVE_FAILED ? "save_fail " : "",
@@ -1583,6 +1588,16 @@ static ssize_t id_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(id);
 
+static ssize_t dirty_shutdown_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
+
+	return sprintf(buf, "%d\n", nfit_mem->dirty_shutdown);
+}
+static DEVICE_ATTR_RO(dirty_shutdown);
+
 static struct attribute *acpi_nfit_dimm_attributes[] = {
 	&dev_attr_handle.attr,
 	&dev_attr_phys_id.attr,
@@ -1600,6 +1615,7 @@ static struct attribute *acpi_nfit_dimm_attributes[] = {
 	&dev_attr_id.attr,
 	&dev_attr_family.attr,
 	&dev_attr_dsm_mask.attr,
+	&dev_attr_dirty_shutdown.attr,
 	NULL,
 };
 
@@ -1608,6 +1624,7 @@ static umode_t acpi_nfit_dimm_attr_visible(struct kobject *kobj,
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
 	struct nvdimm *nvdimm = to_nvdimm(dev);
+	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
 
 	if (!to_nfit_dcr(dev)) {
 		/* Without a dcr only the memdev attributes can be surfaced */
@@ -1621,6 +1638,11 @@ static umode_t acpi_nfit_dimm_attr_visible(struct kobject *kobj,
 
 	if (a == &dev_attr_format1.attr && num_nvdimm_formats(nvdimm) <= 1)
 		return 0;
+
+	if (!test_bit(NFIT_MEM_DIRTY_COUNT, &nfit_mem->flags)
+			&& a == &dev_attr_dirty_shutdown.attr)
+		return 0;
+
 	return a->mode;
 }
 
@@ -1699,6 +1721,56 @@ static bool acpi_nvdimm_has_method(struct acpi_device *adev, char *method)
 	return false;
 }
 
+static void nfit_intel_shutdown_status(struct nfit_mem *nfit_mem)
+{
+	struct nd_intel_smart smart = { 0 };
+	union acpi_object in_buf = {
+		.type = ACPI_TYPE_BUFFER,
+		.buffer.pointer = (char *) &smart,
+		.buffer.length = sizeof(smart),
+	};
+	union acpi_object in_obj = {
+		.type = ACPI_TYPE_PACKAGE,
+		.package.count = 1,
+		.package.elements = &in_buf,
+	};
+	const u8 func = ND_INTEL_SMART;
+	const guid_t *guid = to_nfit_uuid(nfit_mem->family);
+	u8 revid = nfit_dsm_revid(nfit_mem->family, func);
+	struct acpi_device *adev = nfit_mem->adev;
+	acpi_handle handle = adev->handle;
+	union acpi_object *out_obj;
+
+	if ((nfit_mem->dsm_mask & (1 << func)) == 0)
+		return;
+
+	out_obj = acpi_evaluate_dsm(handle, guid, revid, func, &in_obj);
+	if (!out_obj)
+		return;
+
+	if (smart.flags & ND_INTEL_SMART_SHUTDOWN_VALID) {
+		if (smart.shutdown_state)
+			set_bit(NFIT_MEM_DIRTY, &nfit_mem->flags);
+	}
+
+	if (smart.flags & ND_INTEL_SMART_SHUTDOWN_COUNT_VALID) {
+		set_bit(NFIT_MEM_DIRTY_COUNT, &nfit_mem->flags);
+		nfit_mem->dirty_shutdown = smart.shutdown_count;
+	}
+	ACPI_FREE(out_obj);
+}
+
+static void populate_shutdown_status(struct nfit_mem *nfit_mem)
+{
+	/*
+	 * For DIMMs that provide a dynamic facility to retrieve a
+	 * dirty-shutdown status and/or a dirty-shutdown count, cache
+	 * these values in nfit_mem.
+	 */
+	if (nfit_mem->family == NVDIMM_FAMILY_INTEL)
+		nfit_intel_shutdown_status(nfit_mem);
+}
+
 static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
 		struct nfit_mem *nfit_mem, u32 device_handle)
 {
@@ -1811,6 +1883,8 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
 		set_bit(NFIT_MEM_LSW, &nfit_mem->flags);
 	}
 
+	populate_shutdown_status(nfit_mem);
+
 	return 0;
 }
 
diff --git a/drivers/acpi/nfit/intel.h b/drivers/acpi/nfit/intel.h
index f831084f95fa..ca454a422aa3 100644
--- a/drivers/acpi/nfit/intel.h
+++ b/drivers/acpi/nfit/intel.h
@@ -6,6 +6,40 @@
 #ifndef _NFIT_INTEL_H_
 #define _NFIT_INTEL_H_
 
+/*
+ * While the security ops require CONFIG_X86 due to the need to
+ * coordinate cache management, the ND_INTEL_SMART command could be
+ * generically supported on any arch.
+ */
+#define ND_INTEL_SMART 1
+
+#define ND_INTEL_SMART_SHUTDOWN_COUNT_VALID     (1 << 5)
+#define ND_INTEL_SMART_SHUTDOWN_VALID           (1 << 10)
+
+struct nd_intel_smart {
+        u32 status;
+        union {
+                struct {
+                        u32 flags;
+                        u8 reserved0[4];
+                        u8 health;
+                        u8 spares;
+                        u8 life_used;
+                        u8 alarm_flags;
+                        u16 media_temperature;
+                        u16 ctrl_temperature;
+                        u32 shutdown_count;
+                        u8 ait_status;
+                        u16 pmic_temperature;
+                        u8 reserved1[8];
+                        u8 shutdown_state;
+                        u32 vendor_size;
+                        u8 vendor_data[92];
+                } __packed;
+                u8 data[128];
+        };
+} __packed;
+
 #ifdef CONFIG_X86
 
 extern const struct nvdimm_security_ops *intel_security_ops;
diff --git a/drivers/acpi/nfit/nfit.h b/drivers/acpi/nfit/nfit.h
index 74706d1821df..8c1af38a5dee 100644
--- a/drivers/acpi/nfit/nfit.h
+++ b/drivers/acpi/nfit/nfit.h
@@ -177,6 +177,8 @@ struct nfit_memdev {
 enum nfit_mem_flags {
 	NFIT_MEM_LSR,
 	NFIT_MEM_LSW,
+	NFIT_MEM_DIRTY,
+	NFIT_MEM_DIRTY_COUNT,
 };
 
 #define NFIT_DIMM_ID_LEN	22
@@ -201,6 +203,7 @@ struct nfit_mem {
 	struct resource *flush_wpq;
 	unsigned long dsm_mask;
 	unsigned long flags;
+	u32 dirty_shutdown;
 	int family;
 	char id[NFIT_DIMM_ID_LEN+1];
 };
diff --git a/tools/testing/nvdimm/test/nfit_test.h b/tools/testing/nvdimm/test/nfit_test.h
index 33752e06ff8d..ade14fe3837e 100644
--- a/tools/testing/nvdimm/test/nfit_test.h
+++ b/tools/testing/nvdimm/test/nfit_test.h
@@ -117,30 +117,6 @@ struct nd_cmd_ars_err_inj_stat {
 #define ND_INTEL_SMART_INJECT_FATAL		(1 << 2)
 #define ND_INTEL_SMART_INJECT_SHUTDOWN		(1 << 3)
 
-struct nd_intel_smart {
-	__u32 status;
-	union {
-		struct {
-			__u32 flags;
-			__u8 reserved0[4];
-			__u8 health;
-			__u8 spares;
-			__u8 life_used;
-			__u8 alarm_flags;
-			__u16 media_temperature;
-			__u16 ctrl_temperature;
-			__u32 shutdown_count;
-			__u8 ait_status;
-			__u16 pmic_temperature;
-			__u8 reserved1[8];
-			__u8 shutdown_state;
-			__u32 vendor_size;
-			__u8 vendor_data[92];
-		} __packed;
-		__u8 data[128];
-	};
-} __packed;
-
 struct nd_intel_smart_threshold {
 	__u32 status;
 	union {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
