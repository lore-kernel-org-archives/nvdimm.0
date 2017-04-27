Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DDA082195406C
 for <linux-nvdimm@lists.01.org>; Thu, 27 Apr 2017 15:16:03 -0700 (PDT)
Subject: [PATCH] libnvdimm, pmem: fix badblocks notification crash
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 27 Apr 2017 15:10:11 -0700
Message-ID: <149333101097.4714.1923436715100717938.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The nd_pmem_notify() routine is called whenever an ARS
(address-range-scrub) completes to communicate results to the
per-namespace badblocks instances.

When the namespace is in btt mode we crash because we do not allocate a
struct pmem_device instance in that case. Resulting in the following
crash signature:

 BUG: unable to handle kernel NULL pointer dereference at 0000000000000030
 IP: nd_pmem_notify+0x30/0xf0 [nd_pmem]
 Call Trace:
  nd_device_notify+0x40/0x50
  child_notify+0x10/0x20
  device_for_each_child+0x50/0x90
  nd_region_notify+0x20/0x30
  nd_device_notify+0x40/0x50
  nvdimm_region_notify+0x27/0x30
  acpi_nfit_scrub+0x341/0x590 [nfit]
  process_one_work+0x197/0x450
  worker_thread+0x4e/0x4a0
  kthread+0x109/0x140

Given that we don't even populate the btt badblocks instance, just
return early and skip the device to region lookup.

This is a simpler version of the original fix by Toshi [1].

[1]: https://patchwork.kernel.org/patch/9700055/

Cc: Vishal Verma <vishal.l.verma@intel.com>
Reported-by: Toshi Kani <toshi.kani@hpe.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pmem.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 5b536be5a12e..ee6cd31dafcf 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -388,21 +388,21 @@ static void nd_pmem_shutdown(struct device *dev)
 
 static void nd_pmem_notify(struct device *dev, enum nvdimm_event event)
 {
-	struct pmem_device *pmem = dev_get_drvdata(dev);
-	struct nd_region *nd_region = to_region(pmem);
 	resource_size_t offset = 0, end_trunc = 0;
 	struct nd_namespace_common *ndns;
 	struct nd_namespace_io *nsio;
+	struct nd_region *nd_region;
+	struct pmem_device *pmem;
 	struct resource res;
 
 	if (event != NVDIMM_REVALIDATE_POISON)
 		return;
 
-	if (is_nd_btt(dev)) {
-		struct nd_btt *nd_btt = to_nd_btt(dev);
+	/* no badblocks instance to update in the btt case */
+	if (is_nd_btt(dev))
+		return;
 
-		ndns = nd_btt->ndns;
-	} else if (is_nd_pfn(dev)) {
+	if (is_nd_pfn(dev)) {
 		struct nd_pfn *nd_pfn = to_nd_pfn(dev);
 		struct nd_pfn_sb *pfn_sb = nd_pfn->pfn_sb;
 
@@ -415,6 +415,8 @@ static void nd_pmem_notify(struct device *dev, enum nvdimm_event event)
 	nsio = to_nd_namespace_io(&ndns->dev);
 	res.start = nsio->res.start + offset;
 	res.end = nsio->res.end - end_trunc;
+	pmem = dev_get_drvdata(dev);
+	nd_region = to_region(pmem);
 	nvdimm_badblocks_populate(nd_region, &pmem->bb, &res);
 }
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
