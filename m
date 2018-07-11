Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7D625203B99C2
 for <linux-nvdimm@lists.01.org>; Wed, 11 Jul 2018 15:34:27 -0700 (PDT)
Subject: [PATCH v3 03/11] nfit/libnvdimm: store dimm id as a member to
 struct nvdimm
From: Dave Jiang <dave.jiang@intel.com>
Date: Wed, 11 Jul 2018 15:34:05 -0700
Message-ID: <153134844522.41955.827975512500206732.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153134823290.41955.817023337662647245.stgit@djiang5-desk3.ch.intel.com>
References: <153134823290.41955.817023337662647245.stgit@djiang5-desk3.ch.intel.com>
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
 drivers/acpi/nfit/core.c   |   35 +++++++++++++++++++++++------------
 drivers/acpi/nfit/nfit.h   |    1 +
 drivers/nvdimm/dimm_devs.c |    4 +++-
 drivers/nvdimm/nd-core.h   |    1 +
 include/linux/libnvdimm.h  |    2 +-
 5 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index a3a944751e6a..dcb5f428bd9c 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -71,6 +71,9 @@ struct nfit_table_prev {
 
 static guid_t nfit_uuid[NFIT_UUID_MAX];
 
+static int acpi_nfit_get_dimm_id(struct acpi_nfit_control_region *dcr,
+		char *buf);
+
 const guid_t *to_nfit_uuid(enum nfit_uuids id)
 {
 	return &nfit_uuid[id];
@@ -1572,18 +1575,10 @@ static DEVICE_ATTR_RO(flags);
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
 
@@ -1830,6 +1825,21 @@ static void shutdown_dimm_notify(void *data)
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
@@ -1896,10 +1906,11 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
 
 		flush = nfit_mem->nfit_flush ? nfit_mem->nfit_flush->flush
 			: NULL;
+		acpi_nfit_get_dimm_id(nfit_mem->dcr, nfit_mem->id);
 		nvdimm = nvdimm_create(acpi_desc->nvdimm_bus, nfit_mem,
 				acpi_nfit_dimm_attribute_groups,
 				flags, cmd_mask, flush ? flush->hint_count : 0,
-				nfit_mem->flush_wpq);
+				nfit_mem->flush_wpq, nfit_mem->id);
 		if (!nvdimm)
 			return -ENOMEM;
 
diff --git a/drivers/acpi/nfit/nfit.h b/drivers/acpi/nfit/nfit.h
index 40b0003b1805..019549138133 100644
--- a/drivers/acpi/nfit/nfit.h
+++ b/drivers/acpi/nfit/nfit.h
@@ -195,6 +195,7 @@ struct nfit_mem {
 	int family;
 	bool has_lsr;
 	bool has_lsw;
+	char id[NVDIMM_KEY_DESC_LEN];
 };
 
 struct acpi_nfit_desc {
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 1dcbb653455b..1842c74413fa 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -440,7 +440,7 @@ EXPORT_SYMBOL_GPL(nvdimm_attribute_group);
 struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
 		const struct attribute_group **groups, unsigned long flags,
 		unsigned long cmd_mask, int num_flush,
-		struct resource *flush_wpq)
+		struct resource *flush_wpq, const char *id)
 {
 	struct nvdimm *nvdimm = kzalloc(sizeof(*nvdimm), GFP_KERNEL);
 	struct device *dev;
@@ -453,6 +453,8 @@ struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
 		kfree(nvdimm);
 		return NULL;
 	}
+
+	memcpy(nvdimm->dimm_id, id, NVDIMM_KEY_DESC_LEN);
 	nvdimm->provider_data = provider_data;
 	nvdimm->flags = flags;
 	nvdimm->cmd_mask = cmd_mask;
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 2af0f89c4010..ea9227498dac 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -42,6 +42,7 @@ struct nvdimm {
 	atomic_t busy;
 	int id, num_flush;
 	struct resource *flush_wpq;
+	char dimm_id[NVDIMM_KEY_DESC_LEN];
 };
 
 /**
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 09dd06f96f95..6d0247b95e6f 100644
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
