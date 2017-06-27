Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x241.google.com (mail-pf0-x241.google.com
 [IPv6:2607:f8b0:400e:c00::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4356521A143C1
 for <linux-nvdimm@lists.01.org>; Tue, 27 Jun 2017 01:14:30 -0700 (PDT)
Received: by mail-pf0-x241.google.com with SMTP id e199so3763936pfh.0
 for <linux-nvdimm@lists.01.org>; Tue, 27 Jun 2017 01:16:00 -0700 (PDT)
From: Oliver O'Halloran <oohall@gmail.com>
Subject: [PATCH 4/4] ndctl,
 create-namespace: use seed device to check alignments
Date: Tue, 27 Jun 2017 18:15:31 +1000
Message-Id: <20170627081531.7389-4-oohall@gmail.com>
In-Reply-To: <20170627081531.7389-1-oohall@gmail.com>
References: <20170627081531.7389-1-oohall@gmail.com>
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

The possible alignments for DAX and PFN regions depends on what is
supported by the current kernel. Previously we have assumed that 4K,
2M and 1G alignments are valid since those are the hardware page sizes
available on x86, but these are not universal. This patch reworks the
alignment validation so that the valid alignments are what the seed
device supports. It also uses the seed device alignment as the default
alignment since this is chosen by the kernel and should be a reasonable
default.

Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
---
 ndctl/namespace.c | 79 +++++++++++++++++++++++++++++--------------------------
 1 file changed, 42 insertions(+), 37 deletions(-)

diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index 0f402e8790a6..1900032cd362 100644
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
 
@@ -491,57 +491,62 @@ static int validate_namespace_options(struct ndctl_region *region,
 
 		p->align = parse_size64(param.align);
 
-		if (p->mode == NDCTL_NS_MODE_MEMORY && p->align != SZ_2M
-				&& (!pfn || !ndctl_pfn_has_align(pfn))) {
+		if (p->mode == NDCTL_NS_MODE_MEMORY) {
+			if (!pfn) {
+				debug("%s does not support memory mode\n",
+					region_name);
+				return -EAGAIN;
+			}
+
 			/*
 			 * Initial pfn device support in the kernel
 			 * supported a 2M default alignment when
 			 * ndctl_pfn_has_align() returns false.
 			 */
-			debug("%s not support 'align' for memory mode\n",
+			if (p->align != SZ_2M && !ndctl_pfn_has_align(pfn)) {
+				debug("%s not support 'align' for memory mode\n",
 					region_name);
-			return -EAGAIN;
-		} else if (p->mode == NDCTL_NS_MODE_DAX
-				&& (!dax || !ndctl_dax_has_align(dax))) {
+				return -EAGAIN;
+			}
+
+			if (param.align_default)
+				p->align = ndctl_pfn_get_align(pfn);
+
+			if (!ndctl_pfn_supports_align(pfn, p->align)) {
+				error("unsupported alignment for memory mode: %s\n",
+					param.align);
+				return -EINVAL;
+			}
+
+			size_align = p->align;
+		} else if (p->mode == NDCTL_NS_MODE_DAX) {
 			/*
 			 * Unlike the pfn case, we require the kernel to
 			 * have 'align' support for device-dax.
 			 */
-			debug("%s not support 'align' for dax mode\n",
-					region_name);
-			return -EAGAIN;
-		} else if (!param.align_default
-				&& (p->mode == NDCTL_NS_MODE_SAFE
-					|| p->mode == NDCTL_NS_MODE_RAW)) {
-			/*
-			 * Specifying an alignment has no effect for
-			 * raw, or btt mode namespaces.
-			 */
+			if (!dax || !ndctl_dax_has_align(dax)) {
+				debug("%s not support 'align' for dax mode\n",
+						region_name);
+				return -EAGAIN;
+			}
+
+			if (param.align_default)
+				p->align = ndctl_dax_get_align(dax);
+
+			if (!ndctl_dax_supports_align(dax, p->align)) {
+				error("unsupported alignment for dax mode: %s\n",
+					param.align);
+				return -EINVAL;
+			}
+
+			size_align = p->align;
+		} else if (!param.align_default) {
+			/* in other cases the user should not supply an alignment */
 			error("%s mode does not support setting an alignment\n",
 					p->mode == NDCTL_NS_MODE_SAFE
 					? "sector" : "raw");
 			return -ENXIO;
 		}
-
-		switch (p->align) {
-		case SZ_4K:
-		case SZ_2M:
-		case SZ_1G:
-			break;
-		default:
-			error("unsupported align: %s\n", param.align);
-			return -ENXIO;
-		}
-
-		/*
-		 * 'raw' and 'sector' mode namespaces don't support an
-		 * alignment attribute.
-		 */
-		if (p->mode == NDCTL_NS_MODE_MEMORY
-				|| p->mode == NDCTL_NS_MODE_DAX)
-			size_align = p->align;
-		else
-			size_align = SZ_4K;
 	}
 
 	/* (re-)validate that the size satisfies the alignment */
-- 
2.9.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
