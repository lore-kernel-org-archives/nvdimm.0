Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AFEF42194EB78
 for <linux-nvdimm@lists.01.org>; Mon, 15 Apr 2019 01:24:05 -0700 (PDT)
From: Yi Zhang <yi.zhang@redhat.com>
Subject: [PATCH ndctl] ndctl, region: return the rc value in region_action
Date: Mon, 15 Apr 2019 16:23:57 +0800
Message-Id: <20190415082357.31127-1-yi.zhang@redhat.com>
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
To: dave.jiang@intel.com, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

if region_action failed, return the rc valude instead of 0

Signed-off-by: Yi Zhang <yi.zhang@redhat.com>
---
 ndctl/region.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ndctl/region.c b/ndctl/region.c
index 993b3f8..7945007 100644
--- a/ndctl/region.c
+++ b/ndctl/region.c
@@ -89,7 +89,7 @@ static int region_action(struct ndctl_region *region, enum device_action mode)
 		break;
 	}
 
-	return 0;
+	return rc;
 }
 
 static int do_xable_region(const char *region_arg, enum device_action mode,
-- 
2.17.2

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
