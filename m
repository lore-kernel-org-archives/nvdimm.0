Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3462721F3B3E5
 for <linux-nvdimm@lists.01.org>; Mon, 30 Oct 2017 11:13:36 -0700 (PDT)
Subject: [PATCH] libnvdimm: remove used code in nd_pmem_forget_poison_check()
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 30 Oct 2017 11:17:26 -0700
Message-ID: <150938744600.18848.5814902918600734916.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com
Cc: dan.carpenter@oracle.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Dan Carpenter reported:
The patch 006358b35c73: "libnvdimm: add support for clear poison list
and badblocks for device dax" from Apr 7, 2017, leads to the
following static checker warning:

	drivers/nvdimm/bus.c:852 nd_pmem_forget_poison_check()
	warn: we tested 'nd_dax' before and it was 'false'


Remove unused code.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/nvdimm/bus.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index baf2839..c042174 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -849,13 +849,11 @@ static int nd_pmem_forget_poison_check(struct device *dev, void *data)
 	start = clear_err->address;
 	end = clear_err->address + clear_err->cleared - 1;
 
-	if (nd_btt || nd_pfn || nd_dax) {
+	if (nd_btt || nd_pfn) {
 		if (nd_btt)
 			ndns = nd_btt->ndns;
 		else if (nd_pfn)
 			ndns = nd_pfn->ndns;
-		else if (nd_dax)
-			ndns = nd_dax->nd_pfn.ndns;
 
 		if (!ndns)
 			return 0;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
