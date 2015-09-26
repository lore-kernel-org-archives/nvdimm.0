Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH 3/3] pmem, memremap: convert to numa aware allocations
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 25 Sep 2015 21:17:53 -0400
Message-ID: <20150926011753.2848.75637.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20150926011243.2848.82422.stgit@dwillia2-desk3.jf.intel.com>
References: <20150926011243.2848.82422.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: tj@kernel.org
Cc: linux-nvdimm@lists.01.org, hch@lst.de, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Given that pmem ranges come with numa-locality hints, arrange for the
resulting driver objects to be obtained from node-local memory.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pmem.c |    5 +++--
 kernel/memremap.c     |    7 ++++---
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index b9525385c0dc..570764a7599e 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -177,9 +177,10 @@ static void pmem_detach_disk(struct pmem_device *pmem)
 static int pmem_attach_disk(struct device *dev,
 		struct nd_namespace_common *ndns, struct pmem_device *pmem)
 {
+	int nid = dev_to_node(dev);
 	struct gendisk *disk;
 
-	pmem->pmem_queue = blk_alloc_queue(GFP_KERNEL);
+	pmem->pmem_queue = blk_alloc_queue_node(GFP_KERNEL, nid);
 	if (!pmem->pmem_queue)
 		return -ENOMEM;
 
@@ -189,7 +190,7 @@ static int pmem_attach_disk(struct device *dev,
 	blk_queue_bounce_limit(pmem->pmem_queue, BLK_BOUNCE_ANY);
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, pmem->pmem_queue);
 
-	disk = alloc_disk(0);
+	disk = alloc_disk_node(0, nid);
 	if (!disk) {
 		blk_cleanup_queue(pmem->pmem_queue);
 		return -ENOMEM;
diff --git a/kernel/memremap.c b/kernel/memremap.c
index 86a5cdeb18f2..f257c4e66e60 100644
--- a/kernel/memremap.c
+++ b/kernel/memremap.c
@@ -114,7 +114,8 @@ void *devm_memremap(struct device *dev, resource_size_t offset,
 {
 	void **ptr, *addr;
 
-	ptr = devres_alloc(devm_memremap_release, sizeof(*ptr), GFP_KERNEL);
+	ptr = devres_alloc_node(devm_memremap_release, sizeof(*ptr), GFP_KERNEL,
+			dev_to_node(dev));
 	if (!ptr)
 		return NULL;
 
@@ -166,8 +167,8 @@ void *devm_memremap_pages(struct device *dev, struct resource *res)
 	if (is_ram == REGION_INTERSECTS)
 		return __va(res->start);
 
-	page_map = devres_alloc(devm_memremap_pages_release,
-			sizeof(*page_map), GFP_KERNEL);
+	page_map = devres_alloc_node(devm_memremap_pages_release,
+			sizeof(*page_map), GFP_KERNEL, dev_to_node(dev));
 	if (!page_map)
 		return ERR_PTR(-ENOMEM);
 

