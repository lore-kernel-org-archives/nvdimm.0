Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id BA02A1A1EE0
 for <linux-nvdimm@lists.01.org>; Wed, 23 Mar 2016 18:26:42 -0700 (PDT)
Subject: [PATCH 02/13] libnvdimm, pmem: kill pmem->ndns
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 23 Mar 2016 18:25:32 -0700
Message-ID: <20160324012532.21436.78937.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20160324012520.21436.22505.stgit@dwillia2-desk3.jf.intel.com>
References: <20160324012520.21436.22505.stgit@dwillia2-desk3.jf.intel.com>
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

We can derive the common namespace from other information.  We also do
not need to cache it because all the usages are in slow paths.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/blk.c  |    2 +-
 drivers/nvdimm/btt.c  |    3 +--
 drivers/nvdimm/nd.h   |    2 +-
 drivers/nvdimm/pmem.c |   40 ++++++++++++++++++++++------------------
 4 files changed, 25 insertions(+), 22 deletions(-)

diff --git a/drivers/nvdimm/blk.c b/drivers/nvdimm/blk.c
index e9ff9229d942..24649396b638 100644
--- a/drivers/nvdimm/blk.c
+++ b/drivers/nvdimm/blk.c
@@ -336,7 +336,7 @@ static int nd_blk_remove(struct device *dev)
 	struct nd_blk_device *blk_dev = dev_get_drvdata(dev);
 
 	if (is_nd_btt(dev))
-		nvdimm_namespace_detach_btt(to_nd_btt(dev)->ndns);
+		nvdimm_namespace_detach_btt(to_nd_btt(dev));
 	else
 		nd_blk_detach_disk(blk_dev);
 	kfree(blk_dev);
diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index c32cbb593600..48e036621d05 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1406,9 +1406,8 @@ int nvdimm_namespace_attach_btt(struct nd_namespace_common *ndns)
 }
 EXPORT_SYMBOL(nvdimm_namespace_attach_btt);
 
-int nvdimm_namespace_detach_btt(struct nd_namespace_common *ndns)
+int nvdimm_namespace_detach_btt(struct nd_btt *nd_btt)
 {
-	struct nd_btt *nd_btt = to_nd_btt(ndns->claim);
 	struct btt *btt = nd_btt->btt;
 
 	btt_fini(btt);
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 875c524fafb0..b0a4ab91307b 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -263,7 +263,7 @@ struct resource *nvdimm_allocate_dpa(struct nvdimm_drvdata *ndd,
 resource_size_t nvdimm_namespace_capacity(struct nd_namespace_common *ndns);
 struct nd_namespace_common *nvdimm_namespace_common_probe(struct device *dev);
 int nvdimm_namespace_attach_btt(struct nd_namespace_common *ndns);
-int nvdimm_namespace_detach_btt(struct nd_namespace_common *ndns);
+int nvdimm_namespace_detach_btt(struct nd_btt *nd_btt);
 const char *nvdimm_namespace_disk_name(struct nd_namespace_common *ndns,
 		char *name);
 void nvdimm_badblocks_populate(struct nd_region *nd_region,
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index e27a293bd9cc..b13b9095f620 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -35,7 +35,6 @@
 struct pmem_device {
 	struct request_queue	*pmem_queue;
 	struct gendisk		*pmem_disk;
-	struct nd_namespace_common *ndns;
 
 	/* One contiguous memory region per device */
 	phys_addr_t		phys_addr;
@@ -422,9 +421,8 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 	return -ENXIO;
 }
 
-static int nvdimm_namespace_detach_pfn(struct nd_namespace_common *ndns)
+static int nvdimm_namespace_detach_pfn(struct nd_pfn *nd_pfn)
 {
-	struct nd_pfn *nd_pfn = to_nd_pfn(ndns->claim);
 	struct pmem_device *pmem;
 
 	/* free pmem disk */
@@ -523,7 +521,7 @@ static int __nvdimm_namespace_attach_pfn(struct nd_pfn *nd_pfn)
 
 	return rc;
  err:
-	nvdimm_namespace_detach_pfn(ndns);
+	nvdimm_namespace_detach_pfn(nd_pfn);
 	return rc;
 
 }
@@ -559,7 +557,6 @@ static int nd_pmem_probe(struct device *dev)
 	if (IS_ERR(pmem))
 		return PTR_ERR(pmem);
 
-	pmem->ndns = ndns;
 	dev_set_drvdata(dev, pmem);
 	ndns->rw_bytes = pmem_rw_bytes;
 	if (devm_init_badblocks(dev, &pmem->bb))
@@ -593,9 +590,9 @@ static int nd_pmem_remove(struct device *dev)
 	struct pmem_device *pmem = dev_get_drvdata(dev);
 
 	if (is_nd_btt(dev))
-		nvdimm_namespace_detach_btt(pmem->ndns);
+		nvdimm_namespace_detach_btt(to_nd_btt(dev));
 	else if (is_nd_pfn(dev))
-		nvdimm_namespace_detach_pfn(pmem->ndns);
+		nvdimm_namespace_detach_pfn(to_nd_pfn(dev));
 	else
 		pmem_detach_disk(pmem);
 
@@ -604,26 +601,33 @@ static int nd_pmem_remove(struct device *dev)
 
 static void nd_pmem_notify(struct device *dev, enum nvdimm_event event)
 {
-	struct pmem_device *pmem = dev_get_drvdata(dev);
-	struct nd_namespace_common *ndns = pmem->ndns;
 	struct nd_region *nd_region = to_nd_region(dev->parent);
-	struct nd_namespace_io *nsio = to_nd_namespace_io(&ndns->dev);
-	struct resource res = {
-		.start = nsio->res.start + pmem->data_offset,
-		.end = nsio->res.end,
-	};
+	struct pmem_device *pmem = dev_get_drvdata(dev);
+	resource_size_t offset = 0, end_trunc = 0;
+	struct nd_namespace_common *ndns;
+	struct nd_namespace_io *nsio;
+	struct resource res;
 
 	if (event != NVDIMM_REVALIDATE_POISON)
 		return;
 
-	if (is_nd_pfn(dev)) {
+	if (is_nd_btt(dev)) {
+		struct nd_btt *nd_btt = to_nd_btt(dev);
+
+		ndns = nd_btt->ndns;
+	} else if (is_nd_pfn(dev)) {
 		struct nd_pfn *nd_pfn = to_nd_pfn(dev);
 		struct nd_pfn_sb *pfn_sb = nd_pfn->pfn_sb;
 
-		res.start += __le32_to_cpu(pfn_sb->start_pad);
-		res.end -= __le32_to_cpu(pfn_sb->end_trunc);
-	}
+		ndns = nd_pfn->ndns;
+		offset = pmem->data_offset + __le32_to_cpu(pfn_sb->start_pad);
+		end_trunc = __le32_to_cpu(pfn_sb->end_trunc);
+	} else
+		ndns = to_ndns(dev);
 
+	nsio = to_nd_namespace_io(&ndns->dev);
+	res.start = nsio->res.start + offset;
+	res.end = nsio->res.end - end_trunc;
 	nvdimm_badblocks_populate(nd_region, &pmem->bb, &res);
 }
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
