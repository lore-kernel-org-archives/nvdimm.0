Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 964702118B65E
 for <linux-nvdimm@lists.01.org>; Wed,  6 Jun 2018 09:45:17 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v3 2/4] libnvdimm: unconditionally deep flush on *sync
Date: Wed,  6 Jun 2018 10:45:13 -0600
Message-Id: <20180606164515.25677-2-ross.zwisler@linux.intel.com>
In-Reply-To: <20180606164515.25677-1-ross.zwisler@linux.intel.com>
References: <20180606164515.25677-1-ross.zwisler@linux.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-kernel@vger.kernel.org
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Prior to this commit we would only do a "deep flush" (have nvdimm_flush()
write to each of the flush hints for a region) in response to an
msync/fsync/sync call if the nvdimm_has_cache() returned true at the time
we were setting up the request queue.  This happens due to the write cache
value passed in to blk_queue_write_cache(), which then causes the block
layer to send down BIOs with REQ_FUA and REQ_PREFLUSH set.  We do have a
"write_cache" sysfs entry for namespaces, i.e.:

  /sys/bus/nd/devices/pfn0.1/block/pmem0/dax/write_cache

which can be used to control whether or not the kernel thinks a given
namespace has a write cache, but this didn't modify the deep flush behavior
that we set up when the driver was initialized.  Instead, it only modified
whether or not DAX would flush CPU caches via dax_flush() in response to
*sync calls.

Simplify this by making the *sync deep flush always happen, regardless of
the write cache setting of a namespace.  The DAX CPU cache flushing will
still be controlled the write_cache setting of the namespace.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Suggested-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pmem.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 252adfab1e47..97b4c39a9267 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -294,7 +294,7 @@ static int pmem_attach_disk(struct device *dev,
 {
 	struct nd_namespace_io *nsio = to_nd_namespace_io(&ndns->dev);
 	struct nd_region *nd_region = to_nd_region(dev->parent);
-	int nid = dev_to_node(dev), fua, wbc;
+	int nid = dev_to_node(dev), fua;
 	struct resource *res = &nsio->res;
 	struct resource bb_res;
 	struct nd_pfn *nd_pfn = NULL;
@@ -330,7 +330,6 @@ static int pmem_attach_disk(struct device *dev,
 		dev_warn(dev, "unable to guarantee persistence of writes\n");
 		fua = 0;
 	}
-	wbc = nvdimm_has_cache(nd_region);
 
 	if (!devm_request_mem_region(dev, res->start, resource_size(res),
 				dev_name(&ndns->dev))) {
@@ -377,7 +376,7 @@ static int pmem_attach_disk(struct device *dev,
 		return PTR_ERR(addr);
 	pmem->virt_addr = addr;
 
-	blk_queue_write_cache(q, wbc, fua);
+	blk_queue_write_cache(q, true, fua);
 	blk_queue_make_request(q, pmem_make_request);
 	blk_queue_physical_block_size(q, PAGE_SIZE);
 	blk_queue_logical_block_size(q, pmem_sector_size(ndns));
@@ -408,7 +407,7 @@ static int pmem_attach_disk(struct device *dev,
 		put_disk(disk);
 		return -ENOMEM;
 	}
-	dax_write_cache(dax_dev, wbc);
+	dax_write_cache(dax_dev, nvdimm_has_cache(nd_region));
 	pmem->dax_dev = dax_dev;
 
 	gendev = disk_to_dev(disk);
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
