Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 36C1F2193930C
 for <linux-nvdimm@lists.01.org>; Sat,  1 Apr 2017 12:31:54 -0700 (PDT)
Subject: [PATCH] libnvdimm: fix blk free space accounting
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 01 Apr 2017 12:26:44 -0700
Message-ID: <149107480386.16264.6044807821713048489.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Commit a1f3e4d6a0c3 "libnvdimm, region: update nd_region_available_dpa()
for multi-pmem support" reworked blk dpa (DIMM Physical Address)
accounting to comprehend multiple pmem namespace allocations aliasing
with a given blk-dpa range.

The following call trace is a result of failing to account for allocated
blk capacity.

 WARNING: CPU: 1 PID: 2433 at tools/testing/nvdimm/../../../drivers/nvdimm/names
4 size_store+0x6f3/0x930 [libnvdimm]
 nd_region region5: allocation underrun: 0x0 of 0x1000000 bytes
 [..]
 Call Trace:
  dump_stack+0x86/0xc3
  __warn+0xcb/0xf0
  warn_slowpath_fmt+0x5f/0x80
  size_store+0x6f3/0x930 [libnvdimm]
  dev_attr_store+0x18/0x30

If a given blk-dpa allocation does not alias with any pmem ranges then
the full allocation should be accounted as busy space, not the size of
the current pmem contribution to the region.

Cc: <stable@vger.kernel.org>
Fixes: a1f3e4d6a0c3 ("libnvdimm, region: update nd_region_available_dpa() for multi-pmem support").
Reported-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/dimm_devs.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 0eedc49e0d47..ba1143b1b2ca 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -510,10 +510,8 @@ static int blk_dpa_busy(struct device *dev, void *data)
 			&& info->res->end <= map_end) {
 		info->busy -= nd_mapping->start - info->res->start;
 		return 0;
-	} else {
-		info->busy -= nd_mapping->size;
-		return 0;
 	}
+	return 0;
 }
 
 /**

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
