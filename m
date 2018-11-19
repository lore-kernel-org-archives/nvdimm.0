Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com
 [IPv6:2607:f8b0:4864:20::644])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E721521A09130
 for <linux-nvdimm@lists.01.org>; Mon, 19 Nov 2018 00:01:09 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id b22-v6so8749166pls.7
 for <linux-nvdimm@lists.01.org>; Mon, 19 Nov 2018 00:01:09 -0800 (PST)
From: Oliver O'Halloran <oohall@gmail.com>
Subject: [PATCH 2/4] ndctl/namespace: Check for seed namespaces earlier
Date: Mon, 19 Nov 2018 19:00:54 +1100
Message-Id: <20181119080056.13386-2-oohall@gmail.com>
In-Reply-To: <20181119080056.13386-1-oohall@gmail.com>
References: <20181119080056.13386-1-oohall@gmail.com>
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

When creating an fsdax or devdax namespace we need to verify that the
seed namespaces exist. This patch reworks the validation so that it's
done earlier to simplify the subsequent patches in the series.

No functional changes.

Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
---
 ndctl/namespace.c | 51 +++++++++++++++++++----------------------------
 1 file changed, 21 insertions(+), 30 deletions(-)

diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index b6f12306fe76..dc9a56609881 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -465,6 +465,8 @@ static int validate_namespace_options(struct ndctl_region *region,
 {
 	const char *region_name = ndctl_region_get_devname(region);
 	unsigned long long size_align = SZ_4K, units = 1, resource;
+	struct ndctl_pfn *pfn = NULL;
+	struct ndctl_dax *dax = NULL;
 	unsigned int ways;
 	int rc = 0;
 
@@ -521,14 +523,28 @@ static int validate_namespace_options(struct ndctl_region *region,
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
+		} else if (!pfn) {
+			error("Kernel does not support fsdax mode\n");
+			return -ENODEV;
+		}
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
-				&& (!pfn || !ndctl_pfn_has_align(pfn))) {
+				&& !ndctl_pfn_has_align(pfn)) {
 			/*
 			 * Initial pfn device support in the kernel
 			 * supported a 2M default alignment when
@@ -538,7 +554,7 @@ static int validate_namespace_options(struct ndctl_region *region,
 					region_name);
 			return -EAGAIN;
 		} else if (p->mode == NDCTL_NS_MODE_DAX
-				&& (!dax || !ndctl_dax_has_align(dax))) {
+				&& !ndctl_dax_has_align(dax)) {
 			/*
 			 * Unlike the pfn case, we require the kernel to
 			 * have 'align' support for device-dax.
@@ -705,31 +721,6 @@ static int validate_namespace_options(struct ndctl_region *region,
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
-	}
-
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
-
 	p->autolabel = param.autolabel;
 
 	return 0;
-- 
2.17.2

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
