Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 07EE82194EB64
 for <linux-nvdimm@lists.01.org>; Fri, 14 Apr 2017 15:02:55 -0700 (PDT)
Subject: [PATCH v2 1/7] Revert "libnvdimm: band aid btt vs clear poison
 locking"
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 14 Apr 2017 14:57:11 -0700
Message-ID: <149220703105.36563.1290518071230049126.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149220702552.36563.10552898152402020832.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149220702552.36563.10552898152402020832.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

This reverts commit 4aa5615e080a "libnvdimm: band aid btt vs clear
poison locking".

Now that poison list locking has been converted to a spinlock and poison
list entry allocation during i/o has been converted to GFP_NOWAIT,
revert the band-aid that disabled error clearing from btt i/o.

Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/claim.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
index ca6d572c48fc..b3323c0697f6 100644
--- a/drivers/nvdimm/claim.c
+++ b/drivers/nvdimm/claim.c
@@ -243,15 +243,7 @@ static int nsio_rw_bytes(struct nd_namespace_common *ndns,
 	}
 
 	if (unlikely(is_bad_pmem(&nsio->bb, sector, sz_align))) {
-		/*
-		 * FIXME: nsio_rw_bytes() may be called from atomic
-		 * context in the btt case and nvdimm_clear_poison()
-		 * takes a sleeping lock. Until the locking can be
-		 * reworked this capability requires that the namespace
-		 * is not claimed by btt.
-		 */
-		if (IS_ALIGNED(offset, 512) && IS_ALIGNED(size, 512)
-				&& (!ndns->claim || !is_nd_btt(ndns->claim))) {
+		if (IS_ALIGNED(offset, 512) && IS_ALIGNED(size, 512)) {
 			long cleared;
 
 			cleared = nvdimm_clear_poison(&ndns->dev, offset, size);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
