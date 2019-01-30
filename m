Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com
 [IPv6:2607:f8b0:4864:20::644])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 95681211BFCC4
 for <linux-nvdimm@lists.01.org>; Wed, 30 Jan 2019 02:59:42 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id z23so10905039plo.0
 for <linux-nvdimm@lists.01.org>; Wed, 30 Jan 2019 02:59:42 -0800 (PST)
From: Oliver O'Halloran <oohall@gmail.com>
Subject: [PATCH v5 2/7] ndctl/namespace: Check for seed namespaces earlier
Date: Wed, 30 Jan 2019 21:59:22 +1100
Message-Id: <20190130105927.31901-2-oohall@gmail.com>
In-Reply-To: <20190130105927.31901-1-oohall@gmail.com>
References: <20190130105927.31901-1-oohall@gmail.com>
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

When creating an fsdax or devdax namespace we need to verify that the
seed namespaces exist. This patch reworks the validation so that it's
done earlier to simplify the subsequent patches in the series.

Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
---
No functional changes, I hope.

v3: Don't fail early if the user specifies fsdax mode without pfn
    support. Instead, if we try to validate a feature that requires
    pfn support, fail the validation at that point.
---
 ndctl/namespace.c | 48 +++++++++++++++++++++++------------------------
 1 file changed, 23 insertions(+), 25 deletions(-)

diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index b35812bd17a9..12253a96e095 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -469,6 +469,8 @@ static int validate_namespace_options(struct ndctl_region *region,
 {
 	const char *region_name = ndctl_region_get_devname(region);
 	unsigned long long size_align = SZ_4K, units = 1, resource;
+	struct ndctl_pfn *pfn = NULL;
+	struct ndctl_dax *dax = NULL;
 	unsigned int ways;
 	int rc = 0;
 
@@ -525,10 +527,24 @@ static int validate_namespace_options(struct ndctl_region *region,
 	} else if (ndns)
 		p->mode = ndctl_namespace_get_mode(ndns);
 
-	if (param.align) {
-		struct ndctl_pfn *pfn = ndctl_region_get_pfn_seed(region);
-		struct ndctl_dax *dax = ndctl_region_get_dax_seed(region);
+	if (p->mode == NDCTL_NS_MODE_MEMORY) {
+		pfn = ndctl_region_get_pfn_seed(region);
+		if (!pfn && param.mode_default) {
+			debug("%s fsdax mode not available\n", region_name);
+			p->mode = NDCTL_NS_MODE_RAW;
+		}
+		/*
+		 * NB: We only fail validation if a pfn-specific option is used
+		 */
+	} else if (p->mode == NDCTL_NS_MODE_DAX) {
+		dax = ndctl_region_get_dax_seed(region);
+		if (!dax) {
+			error("Kernel does not support devdax mode\n");
+			return -ENODEV;
+		}
+	}
 
+	if (param.align) {
 		p->align = parse_size64(param.align);
 
 		if (p->mode == NDCTL_NS_MODE_MEMORY && p->align != SZ_2M
@@ -709,30 +725,12 @@ static int validate_namespace_options(struct ndctl_region *region,
 			|| p->mode == NDCTL_NS_MODE_DAX)
 		p->loc = NDCTL_PFN_LOC_PMEM;
 
-	/* check if we need, and whether the kernel supports, pfn devices */
-	if (do_setup_pfn(ndns, p)) {
-		struct ndctl_pfn *pfn = ndctl_region_get_pfn_seed(region);
-
-		if (!pfn && param.mode_default) {
-			debug("%s fsdax mode not available\n", region_name);
-			p->mode = NDCTL_NS_MODE_RAW;
-		} else if (!pfn) {
-			error("operation failed, %s fsdax mode not available\n",
-					region_name);
-			return -EINVAL;
-		}
+	if (!pfn && do_setup_pfn(ndns, p)) {
+		error("operation failed, %s cannot support requested mode\n",
+			region_name);
+		return -EINVAL;
 	}
 
-	/* check if we need, and whether the kernel supports, dax devices */
-	if (p->mode == NDCTL_NS_MODE_DAX) {
-		struct ndctl_dax *dax = ndctl_region_get_dax_seed(region);
-
-		if (!dax) {
-			error("operation failed, %s devdax mode not available\n",
-					region_name);
-			return -EINVAL;
-		}
-	}
 
 	p->autolabel = param.autolabel;
 
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
