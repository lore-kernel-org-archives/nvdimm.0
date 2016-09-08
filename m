Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BC5531A1E4C
 for <linux-nvdimm@lists.01.org>; Thu,  8 Sep 2016 16:33:54 -0700 (PDT)
Subject: [PATCH] libnvdimm: allow legacy (e820) pmem region to clear bad blocks
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 08 Sep 2016 16:33:28 -0700
Message-ID: <147337760801.38083.16900960834862325097.stgit@djiang5-desk3.ch.intel.com>
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
To: vishal.l.verma@intel.com, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Bad blocks can be injected via /sys/block/pmemN/badblocks. In a situation
where legacy pmem is being used or a pmem region created by using memmap
kernel parameter, the injected bad blocks are not cleared due to
nvdimm_clear_poison() failing from lack of ndctl function pointer. In
this case we need to just return as handled and allow the bad blocks to
be cleared rather than fail.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/nvdimm/bus.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 458daf9..935866f 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -185,8 +185,12 @@ long nvdimm_clear_poison(struct device *dev, phys_addr_t phys,
 		return -ENXIO;
 
 	nd_desc = nvdimm_bus->nd_desc;
+	/*
+	 * if ndctl does not exist, it's PMEM_LEGACY and
+	 * we want to just pretend everything is handled.
+	 */
 	if (!nd_desc->ndctl)
-		return -ENXIO;
+		return len;
 
 	memset(&ars_cap, 0, sizeof(ars_cap));
 	ars_cap.address = phys;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
