Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 07B9E22364885
 for <linux-nvdimm@lists.01.org>; Tue, 30 Jan 2018 16:15:48 -0800 (PST)
Subject: [PATCH v4 1/4] acpi: nfit: Add support for detect platform CPU
 cache flush on power loss
From: Dave Jiang <dave.jiang@intel.com>
Date: Tue, 30 Jan 2018 17:21:22 -0700
Message-ID: <151735808257.47256.5047417413654029439.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <151735800899.47256.2204307128644539213.stgit@djiang5-desk3.ch.intel.com>
References: <151735800899.47256.2204307128644539213.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com, ross.zwisler@linux.intel.com
Cc: linux-acpi@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

In ACPI 6.2a the platform capability structure has been added to the NFIT
tables. That provides software the ability to determine whether a system
supports the auto flushing of CPU caches on power loss. If the capability
is supported, we do not need to do dax_flush(). Plumbing the path to set the
property on per region from the NFIT tables.

This patch depends on the ACPI NFIT 6.2a platform capabilities support code
in include/acpi/actbl1.h.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 drivers/acpi/nfit/core.c  |   20 ++++++++++++++++++++
 drivers/acpi/nfit/nfit.h  |    1 +
 drivers/nvdimm/pmem.c     |    4 +++-
 include/linux/libnvdimm.h |    5 +++++
 4 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index ff2580e7611d..bcf52bb93b65 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -838,6 +838,18 @@ static bool add_flush(struct acpi_nfit_desc *acpi_desc,
 	return true;
 }
 
+static bool add_platform_cap(struct acpi_nfit_desc *acpi_desc,
+		struct acpi_nfit_capabilities *pcap)
+{
+	struct device *dev = acpi_desc->dev;
+	u32 mask;
+
+	mask = (1 << (pcap->highest_capability + 1)) - 1;
+	acpi_desc->platform_cap = pcap->capabilities & mask;
+	dev_dbg(dev, "%s: cap: %#x\n", __func__, acpi_desc->platform_cap);
+	return true;
+}
+
 static void *add_table(struct acpi_nfit_desc *acpi_desc,
 		struct nfit_table_prev *prev, void *table, const void *end)
 {
@@ -883,6 +895,10 @@ static void *add_table(struct acpi_nfit_desc *acpi_desc,
 	case ACPI_NFIT_TYPE_SMBIOS:
 		dev_dbg(dev, "%s: smbios\n", __func__);
 		break;
+	case ACPI_NFIT_TYPE_CAPABILITIES:
+		if (!add_platform_cap(acpi_desc, table))
+			return err;
+		break;
 	default:
 		dev_err(dev, "unknown table '%d' parsing nfit\n", hdr->type);
 		break;
@@ -2649,6 +2665,9 @@ static int acpi_nfit_register_region(struct acpi_nfit_desc *acpi_desc,
 	else
 		ndr_desc->numa_node = NUMA_NO_NODE;
 
+	if(acpi_desc->platform_cap & ACPI_NFIT_CAPABILITY_CACHE_FLUSH)
+		set_bit(ND_REGION_PERSIST_CACHE, &ndr_desc->flags);
+
 	list_for_each_entry(nfit_memdev, &acpi_desc->memdevs, list) {
 		struct acpi_nfit_memory_map *memdev = nfit_memdev->memdev;
 		struct nd_mapping_desc *mapping;
@@ -3457,6 +3476,7 @@ static __init int nfit_init(void)
 	BUILD_BUG_ON(sizeof(struct acpi_nfit_smbios) != 9);
 	BUILD_BUG_ON(sizeof(struct acpi_nfit_control_region) != 80);
 	BUILD_BUG_ON(sizeof(struct acpi_nfit_data_region) != 40);
+	BUILD_BUG_ON(sizeof(struct acpi_nfit_capabilities) != 16);
 
 	guid_parse(UUID_VOLATILE_MEMORY, &nfit_uuid[NFIT_SPA_VOLATILE]);
 	guid_parse(UUID_PERSISTENT_MEMORY, &nfit_uuid[NFIT_SPA_PM]);
diff --git a/drivers/acpi/nfit/nfit.h b/drivers/acpi/nfit/nfit.h
index f0cf18b2da8b..50d36e166d70 100644
--- a/drivers/acpi/nfit/nfit.h
+++ b/drivers/acpi/nfit/nfit.h
@@ -202,6 +202,7 @@ struct acpi_nfit_desc {
 	unsigned long dimm_cmd_force_en;
 	unsigned long bus_cmd_force_en;
 	unsigned long bus_nfit_cmd_force_en;
+	unsigned int platform_cap;
 	int (*blk_do_io)(struct nd_blk_region *ndbr, resource_size_t dpa,
 			void *iobuf, u64 len, int rw);
 };
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 7fbc5c5dc8e1..8aa542398db4 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -35,6 +35,7 @@
 #include "pmem.h"
 #include "pfn.h"
 #include "nd.h"
+#include "nd-core.h"
 
 static struct device *to_dev(struct pmem_device *pmem)
 {
@@ -334,7 +335,8 @@ static int pmem_attach_disk(struct device *dev,
 		dev_warn(dev, "unable to guarantee persistence of writes\n");
 		fua = 0;
 	}
-	wbc = nvdimm_has_cache(nd_region);
+	wbc = nvdimm_has_cache(nd_region) &&
+		!test_bit(ND_REGION_PERSIST_CACHE, &nd_region->flags);
 
 	if (!devm_request_mem_region(dev, res->start, resource_size(res),
 				dev_name(&ndns->dev))) {
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index f8109ddb5ef1..f2fc0da4da04 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -47,6 +47,11 @@ enum {
 
 	/* region flag indicating to direct-map persistent memory by default */
 	ND_REGION_PAGEMAP = 0,
+	/*
+	 * Platform ensures entire CPU store data path is flushed to pmem on
+	 * system power loss.
+	 */
+	ND_REGION_PERSIST_CACHE = 1,
 
 	/* mark newly adjusted resources as requiring a label update */
 	DPA_RESOURCE_ADJUSTED = 1 << 0,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
