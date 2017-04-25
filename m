Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3427.houston.hpe.com (g4t3427.houston.hpe.com
 [15.241.140.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9F15321951C94
 for <linux-nvdimm@lists.01.org>; Tue, 25 Apr 2017 16:04:47 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH] pmem: fix a NULL pointer BUG in nd_pmem_notify
Date: Tue, 25 Apr 2017 17:04:13 -0600
Message-Id: <20170425230413.363-1-toshi.kani@hpe.com>
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
To: dan.j.williams@intel.com
Cc: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The following BUG was observed when nd_pmem_notify() was called
for a BTT device.  The use of a pmem_device pointer is not valid
with BTT.

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

Fix nd_pmem_notify() by setting nd_region and badblocks pointers
properly for BTT.

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/nvdimm/pmem.c |   37 +++++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 12 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 5b536be..0fc1826 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -388,12 +388,12 @@ static void nd_pmem_shutdown(struct device *dev)
 
 static void nd_pmem_notify(struct device *dev, enum nvdimm_event event)
 {
-	struct pmem_device *pmem = dev_get_drvdata(dev);
-	struct nd_region *nd_region = to_region(pmem);
+	struct nd_region *nd_region;
 	resource_size_t offset = 0, end_trunc = 0;
 	struct nd_namespace_common *ndns;
 	struct nd_namespace_io *nsio;
 	struct resource res;
+	struct badblocks *bb;
 
 	if (event != NVDIMM_REVALIDATE_POISON)
 		return;
@@ -402,20 +402,33 @@ static void nd_pmem_notify(struct device *dev, enum nvdimm_event event)
 		struct nd_btt *nd_btt = to_nd_btt(dev);
 
 		ndns = nd_btt->ndns;
-	} else if (is_nd_pfn(dev)) {
-		struct nd_pfn *nd_pfn = to_nd_pfn(dev);
-		struct nd_pfn_sb *pfn_sb = nd_pfn->pfn_sb;
+		nd_region = to_nd_region(ndns->dev.parent);
+		nsio = to_nd_namespace_io(&ndns->dev);
+		bb = &nsio->bb;
+	} else {
+		struct pmem_device *pmem = dev_get_drvdata(dev);
 
-		ndns = nd_pfn->ndns;
-		offset = pmem->data_offset + __le32_to_cpu(pfn_sb->start_pad);
-		end_trunc = __le32_to_cpu(pfn_sb->end_trunc);
-	} else
-		ndns = to_ndns(dev);
+		nd_region = to_region(pmem);
+		bb = &pmem->bb;
+
+		if (is_nd_pfn(dev)) {
+			struct nd_pfn *nd_pfn = to_nd_pfn(dev);
+			struct nd_pfn_sb *pfn_sb = nd_pfn->pfn_sb;
+
+			ndns = nd_pfn->ndns;
+			offset = pmem->data_offset +
+					__le32_to_cpu(pfn_sb->start_pad);
+			end_trunc = __le32_to_cpu(pfn_sb->end_trunc);
+		} else {
+			ndns = to_ndns(dev);
+		}
+
+		nsio = to_nd_namespace_io(&ndns->dev);
+	}
 
-	nsio = to_nd_namespace_io(&ndns->dev);
 	res.start = nsio->res.start + offset;
 	res.end = nsio->res.end - end_trunc;
-	nvdimm_badblocks_populate(nd_region, &pmem->bb, &res);
+	nvdimm_badblocks_populate(nd_region, bb, &res);
 }
 
 MODULE_ALIAS("pmem");
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
