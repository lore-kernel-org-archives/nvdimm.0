Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id E1DBB1A2266
 for <linux-nvdimm@lists.01.org>; Thu, 14 Apr 2016 19:41:32 -0700 (PDT)
Subject: [PATCH] libnvdimm, btt: add btt startup debug
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 14 Apr 2016 19:40:42 -0700
Message-ID: <146068804238.24085.7095431982077468731.stgit@dwillia2-desk3.jf.intel.com>
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
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Report the reason for btt probe failures when debug is enabled.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/btt.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index cc9fafed9362..68a7c3c1eed9 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1383,11 +1383,15 @@ int nvdimm_namespace_attach_btt(struct nd_namespace_common *ndns)
 	struct btt *btt;
 	size_t rawsize;
 
-	if (!nd_btt->uuid || !nd_btt->ndns || !nd_btt->lbasize)
+	if (!nd_btt->uuid || !nd_btt->ndns || !nd_btt->lbasize) {
+		dev_dbg(&nd_btt->dev, "incomplete btt configuration\n");
 		return -ENODEV;
+	}
 
 	rawsize = nvdimm_namespace_capacity(ndns) - SZ_4K;
 	if (rawsize < ARENA_MIN_SIZE) {
+		dev_dbg(&nd_btt->dev, "%s must be at least %ld bytes\n",
+				dev_name(&ndns->dev), ARENA_MIN_SIZE + SZ_4K);
 		return -ENXIO;
 	}
 	nd_region = to_nd_region(nd_btt->dev.parent);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
