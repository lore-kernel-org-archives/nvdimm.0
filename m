Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 29FB081EA1
 for <linux-nvdimm@lists.01.org>; Thu, 19 Jan 2017 19:55:24 -0800 (PST)
Subject: [PATCH 12/13] libnvdimm,
 pmem: disable dax flushing when pmem is fronting a volatile region
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 19 Jan 2017 19:51:17 -0800
Message-ID: <148488427774.37913.13035450429562766439.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <148488421301.37913.12835362165895864897.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <148488421301.37913.12835362165895864897.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

The pmem driver attaches to both persistent and volatile memory ranges
advertised by the ACPI NFIT. When the region is volatile it is redundant
to spend cycles flushing caches at fsync(). Check if the hosting region
is volatile and do not publish a ->flush() dax method if so.

Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pmem.c        |   31 ++++++++++++++++++++++++++-----
 drivers/nvdimm/region_devs.c |    8 ++++++--
 2 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 47392c4f22b9..53b7e4eb9d92 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -229,6 +229,17 @@ static const struct block_device_operations pmem_fops = {
 	.dax_ops =		&pmem_dax_ops,
 };
 
+static const struct dax_operations vmem_dax_ops = {
+	.direct_access = pmem_direct_access,
+};
+
+static const struct block_device_operations vmem_fops = {
+	.owner =		THIS_MODULE,
+	.rw_page =		pmem_rw_page,
+	.revalidate_disk =	nvdimm_revalidate_disk,
+	.dax_ops =		&vmem_dax_ops,
+};
+
 static void pmem_release_queue(void *q)
 {
 	blk_cleanup_queue(q);
@@ -254,6 +265,7 @@ static int pmem_attach_disk(struct device *dev,
 	struct resource pfn_res;
 	struct request_queue *q;
 	struct gendisk *disk;
+	int has_flush;
 	void *addr;
 
 	/* while nsio_rw_bytes is active, parse a pfn info block if present */
@@ -274,7 +286,8 @@ static int pmem_attach_disk(struct device *dev,
 	dev_set_drvdata(dev, pmem);
 	pmem->phys_addr = res->start;
 	pmem->size = resource_size(res);
-	if (nvdimm_has_flush(nd_region) < 0)
+	has_flush = nvdimm_has_flush(nd_region);
+	if (has_flush == -ENXIO)
 		dev_warn(dev, "unable to guarantee persistence of writes\n");
 
 	if (!devm_request_mem_region(dev, res->start, resource_size(res),
@@ -316,7 +329,12 @@ static int pmem_attach_disk(struct device *dev,
 		return PTR_ERR(addr);
 	pmem->virt_addr = addr;
 
-	blk_queue_write_cache(q, true, true);
+	/*
+	 * If the region is !volatile request that the upper layers send
+	 * flush requests to trigger fencing and wpq flushing
+	 */
+	if (has_flush != -EINVAL)
+		blk_queue_write_cache(q, true, true);
 	blk_queue_make_request(q, pmem_make_request);
 	blk_queue_physical_block_size(q, PAGE_SIZE);
 	blk_queue_max_hw_sectors(q, UINT_MAX);
@@ -329,9 +347,12 @@ static int pmem_attach_disk(struct device *dev,
 	if (!disk)
 		return -ENOMEM;
 
-	disk->fops		= &pmem_fops;
-	disk->queue		= q;
-	disk->flags		= GENHD_FL_EXT_DEVT;
+	if (has_flush == -EINVAL)
+		disk->fops = &vmem_fops;
+	else
+		disk->fops = &pmem_fops;
+	disk->queue = q;
+	disk->flags = GENHD_FL_EXT_DEVT;
 	nvdimm_namespace_disk_name(ndns, disk->disk_name);
 	set_capacity(disk, (pmem->size - pmem->pfn_pad - pmem->data_offset)
 			/ 512);
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 6945df8a3367..ef32b938023e 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -953,15 +953,19 @@ EXPORT_SYMBOL_GPL(nvdimm_flush);
  * nvdimm_has_flush - determine write flushing requirements
  * @nd_region: blk or interleaved pmem region
  *
- * Returns 1 if writes require flushing
- * Returns 0 if writes do not require flushing
+ * Returns 1 if writes require wpq flushing
+ * Returns 0 if writes do not require wpq flushing
  * Returns -ENXIO if flushing capability can not be determined
+ * Returns -EINVAL if neither wpq nor cache flushing is required
  */
 int nvdimm_has_flush(struct nd_region *nd_region)
 {
 	struct nd_region_data *ndrd = dev_get_drvdata(&nd_region->dev);
 	int i;
 
+	if (is_nd_volatile(&nd_region->dev))
+		return -EINVAL;
+
 	/* no nvdimm or pmem api == flushing capability unknown */
 	if (nd_region->ndr_mappings == 0
 			|| !IS_ENABLED(CONFIG_ARCH_HAS_PMEM_API))

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
