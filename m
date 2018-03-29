Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5C68C224DD140
 for <linux-nvdimm@lists.01.org>; Thu, 29 Mar 2018 15:30:34 -0700 (PDT)
Subject: [PATCH 2/4] acpi/libnvdimm: search through BERT records and add to
 nvdimm badblocks
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 29 Mar 2018 15:37:13 -0700
Message-ID: <152236303313.35558.14974025959641773033.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <152236282506.35558.2067249639136170490.stgit@djiang5-desk3.ch.intel.com>
References: <152236282506.35558.2067249639136170490.stgit@djiang5-desk3.ch.intel.com>
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
Cc: linux-acpi@vger.kernel.org, tony.luck@intel.com, rjw@rjwysocki.net, lenb@kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

To avoid hitting bad address in nvdimm from previous boot, we will search
through the BERT records to find the matching address and add them to the
nvdimm_bus badblocks.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/acpi/nfit/core.c  |   22 ++++++++++++++++++++++
 drivers/nvdimm/core.c     |    6 ++++++
 include/linux/libnvdimm.h |    1 +
 3 files changed, 29 insertions(+)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index bbe48ad20886..3e3b95298a21 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -2639,6 +2639,15 @@ static bool nfit_spa_is_volatile(struct acpi_nfit_system_address *spa)
 		nfit_spa_type(spa) == NFIT_SPA_VOLATILE);
 }
 
+static void acpi_nfit_bert_callback(void *data, u64 addr, u64 len)
+{
+	struct nd_region *nd_region = (struct nd_region *)data;
+	struct nvdimm_bus *nvdimm_bus = nvdimm_region_to_bus(nd_region);
+
+	nvdimm_bus_add_badrange(nvdimm_bus, ALIGN(addr, L1_CACHE_BYTES), len);
+	nvdimm_region_notify(nd_region, NVDIMM_REVALIDATE_POISON);
+}
+
 static int acpi_nfit_register_region(struct acpi_nfit_desc *acpi_desc,
 		struct nfit_spa *nfit_spa)
 {
@@ -2735,6 +2744,19 @@ static int acpi_nfit_register_region(struct acpi_nfit_desc *acpi_desc,
 	if (rc)
 		dev_err(acpi_desc->dev, "failed to register spa range %d\n",
 				nfit_spa->spa->range_index);
+
+	/* If we have a region, we can check the BERT */
+	if (nfit_spa->nd_region) {
+		int count = bert_find_mem_error_record(
+				acpi_nfit_bert_callback,
+				(void *)nfit_spa->nd_region, spa->address,
+				spa->length);
+
+		if (count > 0)
+			dev_dbg(acpi_desc->dev, "%d BERT records added\n",
+					count);
+	}
+
 	return rc;
 }
 
diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
index 1dc527660637..7dbdb80e72be 100644
--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -27,6 +27,12 @@
 LIST_HEAD(nvdimm_bus_list);
 DEFINE_MUTEX(nvdimm_bus_list_mutex);
 
+struct nvdimm_bus *nvdimm_region_to_bus(struct nd_region *nd_region)
+{
+	return walk_to_nvdimm_bus(&nd_region->dev);
+}
+EXPORT_SYMBOL(nvdimm_region_to_bus);
+
 void nvdimm_bus_lock(struct device *dev)
 {
 	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index ff855ed965fb..0c3cb02e5706 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -200,6 +200,7 @@ u64 nd_fletcher64(void *addr, size_t len, bool le);
 void nvdimm_flush(struct nd_region *nd_region);
 int nvdimm_has_flush(struct nd_region *nd_region);
 int nvdimm_has_cache(struct nd_region *nd_region);
+struct nvdimm_bus *nvdimm_region_to_bus(struct nd_region *nd_region);
 
 #ifdef CONFIG_ARCH_HAS_PMEM_API
 #define ARCH_MEMREMAP_PMEM MEMREMAP_WB

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
