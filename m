Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 841A221BB2528
 for <linux-nvdimm@lists.01.org>; Mon, 12 Jun 2017 13:48:40 -0700 (PDT)
Subject: [ndctl PATCH] ndctl, create-namespace: fix uninitialized 'size_align'
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 12 Jun 2017 13:43:20 -0700
Message-ID: <149730020007.28869.12430033783348592440.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Static analysis reports that 'size_align' could be used uninitialized,
so set the default at definition time.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/namespace.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index 895e39bb8c7d..4e39975d5b6a 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -428,7 +428,7 @@ static int validate_namespace_options(struct ndctl_region *region,
 		struct ndctl_namespace *ndns, struct parsed_parameters *p)
 {
 	const char *region_name = ndctl_region_get_devname(region);
-	unsigned long long size_align, units = 1;
+	unsigned long long size_align = SZ_4K, units = 1;
 	unsigned int ways;
 	int rc = 0;
 
@@ -540,8 +540,6 @@ static int validate_namespace_options(struct ndctl_region *region,
 		if (p->mode == NDCTL_NS_MODE_MEMORY
 				|| p->mode == NDCTL_NS_MODE_DAX)
 			size_align = p->align;
-		else
-			size_align = SZ_4K;
 	}
 
 	/* (re-)validate that the size satisfies the alignment */

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
