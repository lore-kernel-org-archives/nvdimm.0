Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 471A21A1E3E
 for <linux-nvdimm@lists.01.org>; Sat, 24 Sep 2016 15:35:39 -0700 (PDT)
Subject: [PATCH] libnvdimm, region: fix flush hint table thinko
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 24 Sep 2016 15:32:36 -0700
Message-ID: <147475635614.31367.9667458544760285217.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The definition of the flush hint table as:

	void __iomem *flush_wpq[0][0];

...passed the unit test, but is broken as flush_wpq[0][1] and
flush_wpq[1][0] refer to the same entry.  Fix this to use a helper that
calculates a slot in the table based on the geometry of flush hints in
the region.  This is important to get right since virtualization
solutions use this mechanism to trigger hypervisor flushes to platform
persistence.

Reported-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/nd.h          |   22 ++++++++++++++++++++--
 drivers/nvdimm/region_devs.c |   20 ++++++++++++--------
 2 files changed, 32 insertions(+), 10 deletions(-)

diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 8024a0ef86d3..0b78a8211f4a 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -52,10 +52,28 @@ struct nvdimm_drvdata {
 struct nd_region_data {
 	int ns_count;
 	int ns_active;
-	unsigned int flush_mask;
-	void __iomem *flush_wpq[0][0];
+	unsigned int hints_shift;
+	void __iomem *flush_wpq[0];
 };
 
+static inline void __iomem *ndrd_get_flush_wpq(struct nd_region_data *ndrd,
+		int dimm, int hint)
+{
+	unsigned int num = 1 << ndrd->hints_shift;
+	unsigned int mask = num - 1;
+
+	return ndrd->flush_wpq[dimm * num + (hint & mask)];
+}
+
+static inline void ndrd_set_flush_wpq(struct nd_region_data *ndrd, int dimm,
+		int hint, void __iomem *flush)
+{
+	unsigned int num = 1 << ndrd->hints_shift;
+	unsigned int mask = num - 1;
+
+	ndrd->flush_wpq[dimm * num + (hint & mask)] = flush;
+}
+
 static inline struct nd_namespace_index *to_namespace_index(
 		struct nvdimm_drvdata *ndd, int i)
 {
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 4eef88eb5144..4c0ac4abb629 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -38,7 +38,7 @@ static int nvdimm_map_flush(struct device *dev, struct nvdimm *nvdimm, int dimm,
 
 	dev_dbg(dev, "%s: map %d flush address%s\n", nvdimm_name(nvdimm),
 			nvdimm->num_flush, nvdimm->num_flush == 1 ? "" : "es");
-	for (i = 0; i < nvdimm->num_flush; i++) {
+	for (i = 0; i < (1 << ndrd->hints_shift); i++) {
 		struct resource *res = &nvdimm->flush_wpq[i];
 		unsigned long pfn = PHYS_PFN(res->start);
 		void __iomem *flush_page;
@@ -54,14 +54,15 @@ static int nvdimm_map_flush(struct device *dev, struct nvdimm *nvdimm, int dimm,
 
 		if (j < i)
 			flush_page = (void __iomem *) ((unsigned long)
-					ndrd->flush_wpq[dimm][j] & PAGE_MASK);
+					ndrd_get_flush_wpq(ndrd, dimm, j)
+					& PAGE_MASK);
 		else
 			flush_page = devm_nvdimm_ioremap(dev,
 					PFN_PHYS(pfn), PAGE_SIZE);
 		if (!flush_page)
 			return -ENXIO;
-		ndrd->flush_wpq[dimm][i] = flush_page
-			+ (res->start & ~PAGE_MASK);
+		ndrd_set_flush_wpq(ndrd, dimm, i, flush_page
+				+ (res->start & ~PAGE_MASK));
 	}
 
 	return 0;
@@ -93,7 +94,10 @@ int nd_region_activate(struct nd_region *nd_region)
 		return -ENOMEM;
 	dev_set_drvdata(dev, ndrd);
 
-	ndrd->flush_mask = (1 << ilog2(num_flush)) - 1;
+	if (!num_flush)
+		return 0;
+
+	ndrd->hints_shift = ilog2(num_flush);
 	for (i = 0; i < nd_region->ndr_mappings; i++) {
 		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
 		struct nvdimm *nvdimm = nd_mapping->nvdimm;
@@ -900,8 +904,8 @@ void nvdimm_flush(struct nd_region *nd_region)
 	 */
 	wmb();
 	for (i = 0; i < nd_region->ndr_mappings; i++)
-		if (ndrd->flush_wpq[i][0])
-			writeq(1, ndrd->flush_wpq[i][idx & ndrd->flush_mask]);
+		if (ndrd_get_flush_wpq(ndrd, i, 0))
+			writeq(1, ndrd_get_flush_wpq(ndrd, i, idx));
 	wmb();
 }
 EXPORT_SYMBOL_GPL(nvdimm_flush);
@@ -925,7 +929,7 @@ int nvdimm_has_flush(struct nd_region *nd_region)
 
 	for (i = 0; i < nd_region->ndr_mappings; i++)
 		/* flush hints present, flushing required */
-		if (ndrd->flush_wpq[i][0])
+		if (ndrd_get_flush_wpq(ndrd, i, 0))
 			return 1;
 
 	/*

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
