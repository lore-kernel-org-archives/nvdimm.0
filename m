Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EAE542117924C
 for <linux-nvdimm@lists.01.org>; Sat, 13 Oct 2018 09:35:53 -0700 (PDT)
Subject: [PATCH] libnvdimm: Provide a simplified nvdimm_create() for
 non-security enabled DIMMs
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 13 Oct 2018 09:24:05 -0700
Message-ID: <153944784534.1508664.6365625408163933467.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Michael Ellerman <mpe@ellerman.id.au>, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Do not require libnvdimm provider implementations to include security
parameters if the bus / dimm-devices do not have that support.

Cc: Oliver O'Halloran <oohall@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c   |    2 +-
 drivers/nvdimm/dimm_devs.c |    4 ++--
 include/linux/libnvdimm.h  |   11 ++++++++++-
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index a287a773012b..a0dfbcf8220d 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1992,7 +1992,7 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
 
 		flush = nfit_mem->nfit_flush ? nfit_mem->nfit_flush->flush
 			: NULL;
-		nvdimm = nvdimm_create(acpi_desc->nvdimm_bus, nfit_mem,
+		nvdimm = __nvdimm_create(acpi_desc->nvdimm_bus, nfit_mem,
 				acpi_nfit_dimm_attribute_groups,
 				flags, cmd_mask, flush ? flush->hint_count : 0,
 				nfit_mem->flush_wpq, &nfit_mem->id[0],
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index d1bfb8975b07..5d34251c4f3b 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -459,7 +459,7 @@ struct attribute_group nvdimm_attribute_group = {
 };
 EXPORT_SYMBOL_GPL(nvdimm_attribute_group);
 
-struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
+struct nvdimm *__nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
 		const struct attribute_group **groups, unsigned long flags,
 		unsigned long cmd_mask, int num_flush,
 		struct resource *flush_wpq, const char *dimm_id,
@@ -496,7 +496,7 @@ struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
 
 	return nvdimm;
 }
-EXPORT_SYMBOL_GPL(nvdimm_create);
+EXPORT_SYMBOL_GPL(__nvdimm_create);
 
 int alias_dpa_busy(struct device *dev, void *data)
 {
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index c352b8195675..1071fe12081b 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -207,11 +207,20 @@ const char *nvdimm_name(struct nvdimm *nvdimm);
 struct kobject *nvdimm_kobj(struct nvdimm *nvdimm);
 unsigned long nvdimm_cmd_mask(struct nvdimm *nvdimm);
 void *nvdimm_provider_data(struct nvdimm *nvdimm);
-struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
+struct nvdimm *__nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
 		const struct attribute_group **groups, unsigned long flags,
 		unsigned long cmd_mask, int num_flush,
 		struct resource *flush_wpq, const char *dimm_id,
 		const struct nvdimm_security_ops *sec_ops);
+static inline struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus,
+		void *provider_data, const struct attribute_group **groups,
+		unsigned long flags, unsigned long cmd_mask, int num_flush,
+		struct resource *flush_wpq)
+{
+	return __nvdimm_create(nvdimm_bus, provider_data, groups, flags,
+			cmd_mask, num_flush, flush_wpq, NULL, NULL);
+}
+
 const struct nd_cmd_desc *nd_cmd_dimm_desc(int cmd);
 const struct nd_cmd_desc *nd_cmd_bus_desc(int cmd);
 u32 nd_cmd_in_size(struct nvdimm *nvdimm, int cmd,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
