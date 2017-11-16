Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0BC7521B00DC4
 for <linux-nvdimm@lists.01.org>; Wed, 15 Nov 2017 18:21:34 -0800 (PST)
Subject: [ndctl PATCH 1/4] ndctl,
 create-namespace: fix --map= reconfiguration for device-dax
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 15 Nov 2017 18:17:28 -0800
Message-ID: <151079864874.25456.11655607153151633382.stgit@dwillia2-desk3.amr.corp.intel.com>
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
List-ID: <linux-nvdimm@lists.01.org>

Allow the memmap location to be changed when reconfiguring a device-dax
mode namespace.

Fixes: 3139dfda1158 ("ndctl: create namespace")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/namespace.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index 58f23ad0877a..0020be354670 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -198,7 +198,8 @@ static int set_defaults(enum device_action mode)
 		}
 
 		if (!param.reconfig && param.mode
-				&& strcmp(param.mode, "memory") != 0) {
+				&& strcmp(param.mode, "memory") != 0
+				&& strcmp(param.mode, "dax") != 0) {
 			error("--map only valid for a memory mode pmem namespace\n");
 			rc = -EINVAL;
 		}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
