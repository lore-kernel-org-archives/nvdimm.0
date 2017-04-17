Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 73A68200820C7
 for <linux-nvdimm@lists.01.org>; Mon, 17 Apr 2017 12:17:33 -0700 (PDT)
Subject: [resend PATCH v2 33/33] libnvdimm,
 pmem: disable dax flushing when pmem is fronting a volatile region
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 17 Apr 2017 12:11:49 -0700
Message-ID: <149245630894.10206.4512506206746702195.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149245612770.10206.15496018295337908594.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149245612770.10206.15496018295337908594.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

The pmem driver attaches to both persistent and volatile memory ranges
advertised by the ACPI NFIT. When the region is volatile it is redundant
to spend cycles flushing caches at fsync(). Check if the hosting region
is volatile and do not set QUEUE_FLAG_WC if it is.

Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pmem.c        |    9 +++++++--
 drivers/nvdimm/region_devs.c |    6 ++++++
 include/linux/libnvdimm.h    |    1 +
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index b000c6db5731..42876a75dab8 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -275,6 +275,7 @@ static int pmem_attach_disk(struct device *dev,
 	struct vmem_altmap __altmap, *altmap = NULL;
 	struct resource *res = &nsio->res;
 	struct nd_pfn *nd_pfn = NULL;
+	int has_flush, fua = 0, wbc;
 	struct dax_device *dax_dev;
 	int nid = dev_to_node(dev);
 	struct nd_pfn_sb *pfn_sb;
@@ -302,8 +303,12 @@ static int pmem_attach_disk(struct device *dev,
 	dev_set_drvdata(dev, pmem);
 	pmem->phys_addr = res->start;
 	pmem->size = resource_size(res);
-	if (nvdimm_has_flush(nd_region) < 0)
+	has_flush = nvdimm_has_flush(nd_region);
+	if (has_flush < 0)
 		dev_warn(dev, "unable to guarantee persistence of writes\n");
+	else
+		fua = has_flush;
+	wbc = nvdimm_has_cache(nd_region);
 
 	if (!devm_request_mem_region(dev, res->start, resource_size(res),
 				dev_name(&ndns->dev))) {
@@ -344,7 +349,7 @@ static int pmem_attach_disk(struct device *dev,
 		return PTR_ERR(addr);
 	pmem->virt_addr = addr;
 
-	blk_queue_write_cache(q, true, true);
+	blk_queue_write_cache(q, wbc, fua);
 	blk_queue_make_request(q, pmem_make_request);
 	blk_queue_physical_block_size(q, PAGE_SIZE);
 	blk_queue_max_hw_sectors(q, UINT_MAX);
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 2df259010720..a085f7094b76 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -989,6 +989,12 @@ int nvdimm_has_flush(struct nd_region *nd_region)
 }
 EXPORT_SYMBOL_GPL(nvdimm_has_flush);
 
+int nvdimm_has_cache(struct nd_region *nd_region)
+{
+	return is_nd_pmem(&nd_region->dev);
+}
+EXPORT_SYMBOL_GPL(nvdimm_has_cache);
+
 void __exit nd_region_devs_exit(void)
 {
 	ida_destroy(&region_ida);
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index a98004745768..b733030107bb 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -162,6 +162,7 @@ void nd_region_release_lane(struct nd_region *nd_region, unsigned int lane);
 u64 nd_fletcher64(void *addr, size_t len, bool le);
 void nvdimm_flush(struct nd_region *nd_region);
 int nvdimm_has_flush(struct nd_region *nd_region);
+int nvdimm_has_cache(struct nd_region *nd_region);
 #ifdef CONFIG_ARCH_HAS_PMEM_API
 void arch_memcpy_to_pmem(void *dst, void *src, unsigned size);
 #define ARCH_MEMREMAP_PMEM MEMREMAP_WB

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
