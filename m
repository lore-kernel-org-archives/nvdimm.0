Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1ED7D20082E7E
 for <linux-nvdimm@lists.01.org>; Fri,  9 Jun 2017 13:30:24 -0700 (PDT)
Subject: [PATCH v3 14/14] libnvdimm,
 pmem: disable dax flushing when pmem is fronting a volatile region
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 09 Jun 2017 13:25:01 -0700
Message-ID: <149703990158.20620.16257541455791191783.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149703982465.20620.14881139332926778446.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149703982465.20620.14881139332926778446.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, x86@kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, hch@lst.de
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
 drivers/nvdimm/pmem.c        |   13 ++++++++-----
 drivers/nvdimm/region_devs.c |    6 ++++++
 include/linux/libnvdimm.h    |    1 +
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 06f6c27ec1e9..5cac9fb39db8 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -279,10 +279,10 @@ static int pmem_attach_disk(struct device *dev,
 	struct nd_namespace_io *nsio = to_nd_namespace_io(&ndns->dev);
 	struct nd_region *nd_region = to_nd_region(dev->parent);
 	struct vmem_altmap __altmap, *altmap = NULL;
+	int nid = dev_to_node(dev), fua, wbc;
 	struct resource *res = &nsio->res;
 	struct nd_pfn *nd_pfn = NULL;
 	struct dax_device *dax_dev;
-	int nid = dev_to_node(dev);
 	struct nd_pfn_sb *pfn_sb;
 	struct pmem_device *pmem;
 	struct resource pfn_res;
@@ -308,9 +308,12 @@ static int pmem_attach_disk(struct device *dev,
 	dev_set_drvdata(dev, pmem);
 	pmem->phys_addr = res->start;
 	pmem->size = resource_size(res);
-	if (!IS_ENABLED(CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE)
-			|| nvdimm_has_flush(nd_region) < 0)
-		dev_warn(dev, "unable to guarantee persistence of writes\n");
+	fua = nvdimm_has_flush(nd_region);
+	if (!IS_ENABLED(CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE) || fua < 0)
+		dev_warn(dev, "unable to guarantee persistence of writes\n"); {
+		fua = 0;
+	}
+	wbc = nvdimm_has_cache(nd_region);
 
 	if (!devm_request_mem_region(dev, res->start, resource_size(res),
 				dev_name(&ndns->dev))) {
@@ -354,7 +357,7 @@ static int pmem_attach_disk(struct device *dev,
 		return PTR_ERR(addr);
 	pmem->virt_addr = addr;
 
-	blk_queue_write_cache(q, true, true);
+	blk_queue_write_cache(q, wbc, fua);
 	blk_queue_make_request(q, pmem_make_request);
 	blk_queue_physical_block_size(q, PAGE_SIZE);
 	blk_queue_max_hw_sectors(q, UINT_MAX);
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 53a64a16aba4..0c3b089b280a 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -1060,6 +1060,12 @@ int nvdimm_has_flush(struct nd_region *nd_region)
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
index b2f659bd661d..a8ee1d0afd70 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -165,4 +165,5 @@ void nd_region_release_lane(struct nd_region *nd_region, unsigned int lane);
 u64 nd_fletcher64(void *addr, size_t len, bool le);
 void nvdimm_flush(struct nd_region *nd_region);
 int nvdimm_has_flush(struct nd_region *nd_region);
+int nvdimm_has_cache(struct nd_region *nd_region);
 #endif /* __LIBNVDIMM_H__ */

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
