Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D354121196835
 for <linux-nvdimm@lists.01.org>; Tue, 11 Dec 2018 12:25:28 -0800 (PST)
Subject: [PATCH v13 02/17] acpi/nfit,
 libnvdimm: Store dimm id as a member to struct nvdimm
From: Dave Jiang <dave.jiang@intel.com>
Date: Tue, 11 Dec 2018 13:25:27 -0700
Message-ID: <154455992792.26509.18405602610928843688.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154455914081.26509.7988630204184570351.stgit@djiang5-desk3.ch.intel.com>
References: <154455914081.26509.7988630204184570351.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com
Cc: dhowells@redhat.com, zohar@linux.vnet.ibm.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The generated dimm id is needed for the sysfs attribute as well as being
used as the identifier/description for the security key. Since it's
constant and should never change, store it as a member of struct nvdimm.

As nvdimm_create() continues to grow parameters relative to NFIT driver
requirements, do not require other implementations to keep pace.
Introduce __nvdimm_create() to carry the new parameters and keep
nvdimm_create() with the long standing default api.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c   |   31 ++++++++++++++++++-------------
 drivers/acpi/nfit/nfit.h   |    3 +++
 drivers/nvdimm/dimm_devs.c |   12 +++++++-----
 drivers/nvdimm/nd-core.h   |    1 +
 include/linux/libnvdimm.h  |   17 +++++++++++++----
 5 files changed, 42 insertions(+), 22 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 68d146f8f8a6..c74f087398fb 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1592,18 +1592,10 @@ static DEVICE_ATTR_RO(flags);
 static ssize_t id_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	struct acpi_nfit_control_region *dcr = to_nfit_dcr(dev);
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
 
-	if (dcr->valid_fields & ACPI_NFIT_CONTROL_MFG_INFO_VALID)
-		return sprintf(buf, "%04x-%02x-%04x-%08x\n",
-				be16_to_cpu(dcr->vendor_id),
-				dcr->manufacturing_location,
-				be16_to_cpu(dcr->manufacturing_date),
-				be32_to_cpu(dcr->serial_number));
-	else
-		return sprintf(buf, "%04x-%08x\n",
-				be16_to_cpu(dcr->vendor_id),
-				be32_to_cpu(dcr->serial_number));
+	return sprintf(buf, "%s\n", nfit_mem->id);
 }
 static DEVICE_ATTR_RO(id);
 
@@ -1799,10 +1791,23 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
 	const guid_t *guid;
 	int i;
 	int family = -1;
+	struct acpi_nfit_control_region *dcr = nfit_mem->dcr;
 
 	/* nfit test assumes 1:1 relationship between commands and dsms */
 	nfit_mem->dsm_mask = acpi_desc->dimm_cmd_force_en;
 	nfit_mem->family = NVDIMM_FAMILY_INTEL;
+
+	if (dcr->valid_fields & ACPI_NFIT_CONTROL_MFG_INFO_VALID)
+		sprintf(nfit_mem->id, "%04x-%02x-%04x-%08x",
+				be16_to_cpu(dcr->vendor_id),
+				dcr->manufacturing_location,
+				be16_to_cpu(dcr->manufacturing_date),
+				be32_to_cpu(dcr->serial_number));
+	else
+		sprintf(nfit_mem->id, "%04x-%08x",
+				be16_to_cpu(dcr->vendor_id),
+				be32_to_cpu(dcr->serial_number));
+
 	adev = to_acpi_dev(acpi_desc);
 	if (!adev) {
 		/* unit test case */
@@ -1989,10 +1994,10 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
 
 		flush = nfit_mem->nfit_flush ? nfit_mem->nfit_flush->flush
 			: NULL;
-		nvdimm = nvdimm_create(acpi_desc->nvdimm_bus, nfit_mem,
+		nvdimm = __nvdimm_create(acpi_desc->nvdimm_bus, nfit_mem,
 				acpi_nfit_dimm_attribute_groups,
 				flags, cmd_mask, flush ? flush->hint_count : 0,
-				nfit_mem->flush_wpq);
+				nfit_mem->flush_wpq, &nfit_mem->id[0]);
 		if (!nvdimm)
 			return -ENOMEM;
 
diff --git a/drivers/acpi/nfit/nfit.h b/drivers/acpi/nfit/nfit.h
index ecde13a9199d..33691aecfcee 100644
--- a/drivers/acpi/nfit/nfit.h
+++ b/drivers/acpi/nfit/nfit.h
@@ -183,6 +183,8 @@ enum nfit_mem_flags {
 	NFIT_MEM_DIRTY_COUNT,
 };
 
+#define NFIT_DIMM_ID_LEN	22
+
 /* assembled tables for a given dimm/memory-device */
 struct nfit_mem {
 	struct nvdimm *nvdimm;
@@ -200,6 +202,7 @@ struct nfit_mem {
 	struct list_head list;
 	struct acpi_device *adev;
 	struct acpi_nfit_desc *acpi_desc;
+	char id[NFIT_DIMM_ID_LEN+1];
 	struct resource *flush_wpq;
 	unsigned long dsm_mask;
 	unsigned long flags;
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 6c3de2317390..508dd405f84f 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -383,10 +383,10 @@ struct attribute_group nvdimm_attribute_group = {
 };
 EXPORT_SYMBOL_GPL(nvdimm_attribute_group);
 
-struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
-		const struct attribute_group **groups, unsigned long flags,
-		unsigned long cmd_mask, int num_flush,
-		struct resource *flush_wpq)
+struct nvdimm *__nvdimm_create(struct nvdimm_bus *nvdimm_bus,
+		void *provider_data, const struct attribute_group **groups,
+		unsigned long flags, unsigned long cmd_mask, int num_flush,
+		struct resource *flush_wpq, const char *dimm_id)
 {
 	struct nvdimm *nvdimm = kzalloc(sizeof(*nvdimm), GFP_KERNEL);
 	struct device *dev;
@@ -399,6 +399,8 @@ struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
 		kfree(nvdimm);
 		return NULL;
 	}
+
+	nvdimm->dimm_id = dimm_id;
 	nvdimm->provider_data = provider_data;
 	nvdimm->flags = flags;
 	nvdimm->cmd_mask = cmd_mask;
@@ -415,7 +417,7 @@ struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
 
 	return nvdimm;
 }
-EXPORT_SYMBOL_GPL(nvdimm_create);
+EXPORT_SYMBOL_GPL(__nvdimm_create);
 
 int alias_dpa_busy(struct device *dev, void *data)
 {
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 182258f64417..ff26876e6ea3 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -41,6 +41,7 @@ struct nvdimm {
 	atomic_t busy;
 	int id, num_flush;
 	struct resource *flush_wpq;
+	const char *dimm_id;
 };
 
 /**
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 472171af7f60..f980046b9588 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -175,10 +175,19 @@ const char *nvdimm_name(struct nvdimm *nvdimm);
 struct kobject *nvdimm_kobj(struct nvdimm *nvdimm);
 unsigned long nvdimm_cmd_mask(struct nvdimm *nvdimm);
 void *nvdimm_provider_data(struct nvdimm *nvdimm);
-struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
-		const struct attribute_group **groups, unsigned long flags,
-		unsigned long cmd_mask, int num_flush,
-		struct resource *flush_wpq);
+struct nvdimm *__nvdimm_create(struct nvdimm_bus *nvdimm_bus,
+		void *provider_data, const struct attribute_group **groups,
+		unsigned long flags, unsigned long cmd_mask, int num_flush,
+		struct resource *flush_wpq, const char *dimm_id);
+static inline struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus,
+		void *provider_data, const struct attribute_group **groups,
+		unsigned long flags, unsigned long cmd_mask, int num_flush,
+		struct resource *flush_wpq)
+{
+	return __nvdimm_create(nvdimm_bus, provider_data, groups, flags,
+			cmd_mask, num_flush, flush_wpq, NULL);
+}
+
 const struct nd_cmd_desc *nd_cmd_dimm_desc(int cmd);
 const struct nd_cmd_desc *nd_cmd_bus_desc(int cmd);
 u32 nd_cmd_in_size(struct nvdimm *nvdimm, int cmd,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
