Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id 9B8091A1EE2
 for <linux-nvdimm@lists.01.org>; Wed, 23 Mar 2016 18:27:11 -0700 (PDT)
Subject: [PATCH 09/13] libnvdimm,
 pmem: use devm_add_action to release bdev resources
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 23 Mar 2016 18:26:08 -0700
Message-ID: <20160324012608.21436.8940.stgit@dwillia2-desk3.jf.intel.com>
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

Register a callback to clean up the request_queue and put the gendisk at
driver disable time.

Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pmem.c |   88 ++++++++++++++++++++++---------------------------
 1 file changed, 39 insertions(+), 49 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index ff336dd26064..97bc91b944b7 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -184,6 +184,17 @@ static const struct block_device_operations pmem_fops = {
 	.revalidate_disk =	nvdimm_revalidate_disk,
 };
 
+static void pmem_release_queue(void *q)
+{
+	blk_cleanup_queue(q);
+}
+
+void pmem_release_disk(void *disk)
+{
+	del_gendisk(disk);
+	put_disk(disk);
+}
+
 static struct pmem_device *pmem_alloc(struct device *dev,
 		struct resource *res, int id)
 {
@@ -220,25 +231,22 @@ static struct pmem_device *pmem_alloc(struct device *dev,
 				pmem->phys_addr, pmem->size,
 				ARCH_MEMREMAP_PMEM);
 
-	if (IS_ERR(pmem->virt_addr)) {
+	/*
+	 * At release time the queue must be dead before
+	 * devm_memremap_pages is unwound
+	 */
+	if (devm_add_action(dev, pmem_release_queue, q)) {
 		blk_cleanup_queue(q);
-		return (void __force *) pmem->virt_addr;
+		return ERR_PTR(-ENOMEM);
 	}
 
+	if (IS_ERR(pmem->virt_addr))
+		return (void __force *) pmem->virt_addr;
+
 	pmem->pmem_queue = q;
 	return pmem;
 }
 
-static void pmem_detach_disk(struct pmem_device *pmem)
-{
-	if (!pmem->pmem_disk)
-		return;
-
-	del_gendisk(pmem->pmem_disk);
-	put_disk(pmem->pmem_disk);
-	blk_cleanup_queue(pmem->pmem_queue);
-}
-
 static int pmem_attach_disk(struct device *dev,
 		struct nd_namespace_common *ndns, struct pmem_device *pmem)
 {
@@ -255,8 +263,10 @@ static int pmem_attach_disk(struct device *dev,
 	pmem->pmem_queue->queuedata = pmem;
 
 	disk = alloc_disk_node(0, nid);
-	if (!disk) {
-		blk_cleanup_queue(pmem->pmem_queue);
+	if (!disk)
+		return -ENOMEM;
+	if (devm_add_action(dev, pmem_release_disk, disk)) {
+		put_disk(disk);
 		return -ENOMEM;
 	}
 
@@ -413,15 +423,6 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 	return nvdimm_write_bytes(ndns, SZ_4K, pfn_sb, sizeof(*pfn_sb));
 }
 
-static void nvdimm_namespace_detach_pfn(struct nd_pfn *nd_pfn)
-{
-	struct pmem_device *pmem;
-
-	/* free pmem disk */
-	pmem = dev_get_drvdata(&nd_pfn->dev);
-	pmem_detach_disk(pmem);
-}
-
 /*
  * We hotplug memory at section granularity, pad the reserved area from
  * the previous section base to the namespace base address.
@@ -444,7 +445,6 @@ static unsigned long init_altmap_reserve(resource_size_t base)
 
 static int __nvdimm_namespace_attach_pfn(struct nd_pfn *nd_pfn)
 {
-	int rc;
 	struct resource res;
 	struct request_queue *q;
 	struct pmem_device *pmem;
@@ -481,35 +481,33 @@ static int __nvdimm_namespace_attach_pfn(struct nd_pfn *nd_pfn)
 		altmap = & __altmap;
 		altmap->free = PHYS_PFN(pmem->data_offset - SZ_8K);
 		altmap->alloc = 0;
-	} else {
-		rc = -ENXIO;
-		goto err;
-	}
+	} else
+		return -ENXIO;
 
 	/* establish pfn range for lookup, and switch to direct map */
 	q = pmem->pmem_queue;
 	memcpy(&res, &nsio->res, sizeof(res));
 	res.start += start_pad;
 	res.end -= end_trunc;
+	devm_remove_action(dev, pmem_release_queue, q);
 	devm_memunmap(dev, (void __force *) pmem->virt_addr);
 	pmem->virt_addr = (void __pmem *) devm_memremap_pages(dev, &res,
 			&q->q_usage_counter, altmap);
 	pmem->pfn_flags |= PFN_MAP;
-	if (IS_ERR(pmem->virt_addr)) {
-		rc = PTR_ERR(pmem->virt_addr);
-		goto err;
+
+	/*
+	 * At release time the queue must be dead before
+	 * devm_memremap_pages is unwound
+	 */
+	if (devm_add_action(dev, pmem_release_queue, q)) {
+		blk_cleanup_queue(q);
+		return -ENOMEM;
 	}
+	if (IS_ERR(pmem->virt_addr))
+		return PTR_ERR(pmem->virt_addr);
 
 	/* attach pmem disk in "pfn-mode" */
-	rc = pmem_attach_disk(dev, ndns, pmem);
-	if (rc)
-		goto err;
-
-	return rc;
- err:
-	nvdimm_namespace_detach_pfn(nd_pfn);
-	return rc;
-
+	return pmem_attach_disk(dev, ndns, pmem);
 }
 
 static int nvdimm_namespace_attach_pfn(struct nd_namespace_common *ndns)
@@ -551,8 +549,8 @@ static int nd_pmem_probe(struct device *dev)
 
 	if (is_nd_btt(dev)) {
 		/* btt allocates its own request_queue */
+		devm_remove_action(dev, pmem_release_queue, pmem->pmem_queue);
 		blk_cleanup_queue(pmem->pmem_queue);
-		pmem->pmem_queue = NULL;
 		return nvdimm_namespace_attach_btt(ndns);
 	}
 
@@ -565,7 +563,6 @@ static int nd_pmem_probe(struct device *dev)
 		 * We'll come back as either btt-pmem, or pfn-pmem, so
 		 * drop the queue allocation for now.
 		 */
-		blk_cleanup_queue(pmem->pmem_queue);
 		return -ENXIO;
 	}
 
@@ -574,15 +571,8 @@ static int nd_pmem_probe(struct device *dev)
 
 static int nd_pmem_remove(struct device *dev)
 {
-	struct pmem_device *pmem = dev_get_drvdata(dev);
-
 	if (is_nd_btt(dev))
 		nvdimm_namespace_detach_btt(to_nd_btt(dev));
-	else if (is_nd_pfn(dev))
-		nvdimm_namespace_detach_pfn(to_nd_pfn(dev));
-	else
-		pmem_detach_disk(pmem);
-
 	return 0;
 }
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
