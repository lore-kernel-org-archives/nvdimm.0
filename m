Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AEF9F20359E80
 for <linux-nvdimm@lists.01.org>; Mon,  2 Jul 2018 16:39:24 -0700 (PDT)
Subject: [PATCH 03/11] nfit/libnvdimm: store dimm id as a member to struct
 nvdimm
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 02 Jul 2018 16:39:23 -0700
Message-ID: <153057476366.38125.8727725325138198236.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153057423804.38125.15912575101400055843.stgit@djiang5-desk3.ch.intel.com>
References: <153057423804.38125.15912575101400055843.stgit@djiang5-desk3.ch.intel.com>
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
Cc: dhowells@redhat.com, alison.schofield@intel.com, keyrings@vger.kernel.org, keescook@chromium.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The generated dimm id is needed for the sysfs attribute as well as being
used as the identifier/description for the security key. Since it's
constant and should never change, store it as a member of struct nvdimm.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/acpi/nfit/core.c   |   33 ++++++++++++++++++++++-----------
 drivers/nvdimm/dimm_devs.c |    4 +++-
 drivers/nvdimm/nd-core.h   |    1 +
 include/linux/libnvdimm.h  |    2 +-
 4 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 70351b610b3d..a6fb336da79d 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -70,6 +70,9 @@ struct nfit_table_prev {
 
 static guid_t nfit_uuid[NFIT_UUID_MAX];
 
+static int acpi_nfit_get_dimm_id(struct acpi_nfit_control_region *dcr,
+		char *buf);
+
 const guid_t *to_nfit_uuid(enum nfit_uuids id)
 {
 	return &nfit_uuid[id];
@@ -1571,16 +1574,7 @@ static ssize_t id_show(struct device *dev,
 {
 	struct acpi_nfit_control_region *dcr = to_nfit_dcr(dev);
 
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
+	return acpi_nfit_get_dimm_id(dcr, buf);
 }
 static DEVICE_ATTR_RO(id);
 
@@ -1827,6 +1821,21 @@ static void shutdown_dimm_notify(void *data)
 	mutex_unlock(&acpi_desc->init_mutex);
 }
 
+static int acpi_nfit_get_dimm_id(struct acpi_nfit_control_region *dcr,
+		char *buf)
+{
+	if (dcr->valid_fields & ACPI_NFIT_CONTROL_MFG_INFO_VALID)
+		return sprintf(buf, "%04x-%02x-%04x-%08x",
+				be16_to_cpu(dcr->vendor_id),
+				dcr->manufacturing_location,
+				be16_to_cpu(dcr->manufacturing_date),
+				be32_to_cpu(dcr->serial_number));
+	else
+		return sprintf(buf, "%04x-%08x",
+				be16_to_cpu(dcr->vendor_id),
+				be32_to_cpu(dcr->serial_number));
+}
+
 static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
 {
 	struct nfit_mem *nfit_mem;
@@ -1839,6 +1848,7 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
 		struct nfit_memdev *nfit_memdev;
 		u32 device_handle;
 		u16 mem_flags;
+		char dimm_id[32];
 
 		device_handle = __to_nfit_memdev(nfit_mem)->device_handle;
 		nvdimm = acpi_nfit_dimm_by_handle(acpi_desc, device_handle);
@@ -1893,10 +1903,11 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
 
 		flush = nfit_mem->nfit_flush ? nfit_mem->nfit_flush->flush
 			: NULL;
+		acpi_nfit_get_dimm_id(nfit_mem->dcr, dimm_id);
 		nvdimm = nvdimm_create(acpi_desc->nvdimm_bus, nfit_mem,
 				acpi_nfit_dimm_attribute_groups,
 				flags, cmd_mask, flush ? flush->hint_count : 0,
-				nfit_mem->flush_wpq);
+				nfit_mem->flush_wpq, dimm_id);
 		if (!nvdimm)
 			return -ENOMEM;
 
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 8d348b22ba45..0ab06fd87992 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -398,7 +398,7 @@ EXPORT_SYMBOL_GPL(nvdimm_attribute_group);
 struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
 		const struct attribute_group **groups, unsigned long flags,
 		unsigned long cmd_mask, int num_flush,
-		struct resource *flush_wpq)
+		struct resource *flush_wpq, const char *id)
 {
 	struct nvdimm *nvdimm = kzalloc(sizeof(*nvdimm), GFP_KERNEL);
 	struct device *dev;
@@ -411,6 +411,8 @@ struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
 		kfree(nvdimm);
 		return NULL;
 	}
+
+	memcpy(nvdimm->dimm_id, id, NVDIMM_DEFAULT_DESC_LEN);
 	nvdimm->provider_data = provider_data;
 	nvdimm->flags = flags;
 	nvdimm->cmd_mask = cmd_mask;
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 79274ead54fb..0e9c4fd1234f 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -42,6 +42,7 @@ struct nvdimm {
 	atomic_t busy;
 	int id, num_flush;
 	struct resource *flush_wpq;
+	char dimm_id[NVDIMM_DEFAULT_DESC_LEN];
 };
 
 /**
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index a250ff2a30df..74c6fb315bf0 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -183,7 +183,7 @@ void *nvdimm_provider_data(struct nvdimm *nvdimm);
 struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
 		const struct attribute_group **groups, unsigned long flags,
 		unsigned long cmd_mask, int num_flush,
-		struct resource *flush_wpq);
+		struct resource *flush_wpq, const char *dimm_id);
 const struct nd_cmd_desc *nd_cmd_dimm_desc(int cmd);
 const struct nd_cmd_desc *nd_cmd_bus_desc(int cmd);
 u32 nd_cmd_in_size(struct nvdimm *nvdimm, int cmd,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
