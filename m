Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9E95921B02BB0
 for <linux-nvdimm@lists.01.org>; Fri, 30 Jun 2017 17:33:06 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH] libnvdimm: fix the clear-error check in nsio_rw_bytes
Date: Fri, 30 Jun 2017 18:32:52 -0600
Message-Id: <20170701003252.13171-2-vishal.l.verma@intel.com>
In-Reply-To: <20170701003252.13171-1-vishal.l.verma@intel.com>
References: <20170701003252.13171-1-vishal.l.verma@intel.com>
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

A leftover from the 'bandaid' fix that disabled BTT error clearing in
rw_bytes resulted in an incorrect check. After we converted these checks
over to use the NVDIMM_IO_ATOMIC flag, the ndns->claim check was both
redundant, and incorrect. Remove it.

Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/nvdimm/claim.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
index 8d23f68..f8ad92b 100644
--- a/drivers/nvdimm/claim.c
+++ b/drivers/nvdimm/claim.c
@@ -289,8 +289,7 @@ static int nsio_rw_bytes(struct nd_namespace_common *ndns,
 		 * work around this collision.
 		 */
 		if (IS_ALIGNED(offset, 512) && IS_ALIGNED(size, 512)
-				&& !(flags & NVDIMM_IO_ATOMIC)
-				&& !ndns->claim) {
+				&& !(flags & NVDIMM_IO_ATOMIC)) {
 			long cleared;
 
 			cleared = nvdimm_clear_poison(&ndns->dev,
-- 
2.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
