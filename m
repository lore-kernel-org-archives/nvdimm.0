Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 29E23209884B7
 for <linux-nvdimm@lists.01.org>; Wed, 25 Jul 2018 13:58:49 -0700 (PDT)
Subject: [PATCH v6 03/11] nfit/libnvdimm: store dimm id as a member to
 struct nvdimm
From: Dave Jiang <dave.jiang@intel.com>
Date: Wed, 25 Jul 2018 13:58:47 -0700
Message-ID: <153255232776.51274.12416872628534532057.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153255001863.51274.11308713958786222873.stgit@djiang5-desk3.ch.intel.com>
References: <153255001863.51274.11308713958786222873.stgit@djiang5-desk3.ch.intel.com>
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
Cc: alison.schofield@intel.com, keescook@chromium.org, ebiggers3@gmail.com, dhowells@redhat.com, keyrings@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The generated dimm id is needed for the sysfs attribute as well as being
used as the identifier/description for the security key. Since it's
constant and should never change, store it as a member of struct nvdimm.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c   |   29 +++++++++++++++++------------
 drivers/acpi/nfit/nfit.h   |    3 +++
 drivers/nvdimm/dimm_devs.c |    4 +++-
 drivers/nvdimm/nd-core.h   |    1 +
 include/linux/libnvdimm.h  |    2 +-
 5 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index a3a944751e6a..21235d555b5f 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1572,18 +1572,10 @@ static DEVICE_ATTR_RO(flags);
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
 
@@ -1712,10 +1704,23 @@ static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
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
 	if (!adev)
 		return 0;
@@ -1899,7 +1904,7 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
 		nvdimm = nvdimm_create(acpi_desc->nvdimm_bus, nfit_mem,
 				acpi_nfit_dimm_attribute_groups,
 				flags, cmd_mask, flush ? flush->hint_count : 0,
-				nfit_mem->flush_wpq);
+				nfit_mem->flush_wpq, &nfit_mem->id[0]);
 		if (!nvdimm)
 			return -ENOMEM;
 
diff --git a/drivers/acpi/nfit/nfit.h b/drivers/acpi/nfit/nfit.h
index 40b0003b1805..4048036d6ec2 100644
--- a/drivers/acpi/nfit/nfit.h
+++ b/drivers/acpi/nfit/nfit.h
@@ -173,6 +173,8 @@ struct nfit_memdev {
 	struct acpi_nfit_memory_map memdev[0];
 };
 
+#define NFIT_DIMM_ID_LEN	22
+
 /* assembled tables for a given dimm/memory-device */
 struct nfit_mem {
 	struct nvdimm *nvdimm;
@@ -195,6 +197,7 @@ struct nfit_mem {
 	int family;
 	bool has_lsr;
 	bool has_lsw;
+	char id[NFIT_DIMM_ID_LEN+1];
 };
 
 struct acpi_nfit_desc {
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 586432450c82..e753b2095402 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -401,7 +401,7 @@ EXPORT_SYMBOL_GPL(nvdimm_attribute_group);
 struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
 		const struct attribute_group **groups, unsigned long flags,
 		unsigned long cmd_mask, int num_flush,
-		struct resource *flush_wpq)
+		struct resource *flush_wpq, const char *dimm_id)
 {
 	struct nvdimm *nvdimm = kzalloc(sizeof(*nvdimm), GFP_KERNEL);
 	struct device *dev;
@@ -414,6 +414,8 @@ struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
 		kfree(nvdimm);
 		return NULL;
 	}
+
+	nvdimm->dimm_id = dimm_id;
 	nvdimm->provider_data = provider_data;
 	nvdimm->flags = flags;
 	nvdimm->cmd_mask = cmd_mask;
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 2af0f89c4010..ed650f1607d8 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -42,6 +42,7 @@ struct nvdimm {
 	atomic_t busy;
 	int id, num_flush;
 	struct resource *flush_wpq;
+	const char *dimm_id;
 };
 
 /**
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 51084043915c..3c1f18fdf76f 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -181,7 +181,7 @@ void *nvdimm_provider_data(struct nvdimm *nvdimm);
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
