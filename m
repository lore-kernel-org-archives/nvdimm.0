Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com
 [IPv6:2607:f8b0:4864:20::541])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5F303211B7F9B
 for <linux-nvdimm@lists.01.org>; Wed, 16 Jan 2019 01:49:27 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id j10so2618311pga.1
 for <linux-nvdimm@lists.01.org>; Wed, 16 Jan 2019 01:49:27 -0800 (PST)
From: Oliver O'Halloran <oohall@gmail.com>
Subject: [PATCH v3 3/6] ndctl/namespace: Use seed alignment as the default
Date: Wed, 16 Jan 2019 20:49:06 +1100
Message-Id: <20190116094909.23112-3-oohall@gmail.com>
In-Reply-To: <20190116094909.23112-1-oohall@gmail.com>
References: <20190116094909.23112-1-oohall@gmail.com>
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

When creating a pfn or dax namespace ndctl uses a default alignment of 2MB
when the user does not explicitly supply one. This works on most systems
(x86, ARM, PPC64 with radix MMU), but it fails when the kernel does not
support a 2MB page size (PPC64 with hash MMU).

This patch makes ndctl use the alignment of the relevant seed namespace as
the default instead. The kernel will always pick a valid default alignment
so this should be a bit more portable.

Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
---
 ndctl/namespace.c | 96 +++++++++++++++++++++--------------------------
 1 file changed, 43 insertions(+), 53 deletions(-)

diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index efa8250456d9..b27cc6967a68 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -39,7 +39,6 @@ static bool logfix;
 static struct parameters {
 	bool do_scan;
 	bool mode_default;
-	bool align_default;
 	bool autolabel;
 	const char *bus;
 	const char *map;
@@ -226,9 +225,6 @@ static int set_defaults(enum device_action mode)
 		error("failed to parse namespace alignment '%s'\n",
 				param.align);
 		rc = -EINVAL;
-	} else if (!param.align) {
-		param.align = "2M";
-		param.align_default = true;
 	}
 
 	if (param.uuid) {
@@ -464,7 +460,7 @@ static int validate_namespace_options(struct ndctl_region *region,
 		struct ndctl_namespace *ndns, struct parsed_parameters *p)
 {
 	const char *region_name = ndctl_region_get_devname(region);
-	unsigned long long size_align = SZ_4K, units = 1, resource;
+	unsigned long long size_align, units = 1, resource;
 	struct ndctl_pfn *pfn = NULL;
 	struct ndctl_dax *dax = NULL;
 	unsigned int ways;
@@ -541,53 +537,15 @@ static int validate_namespace_options(struct ndctl_region *region,
 	}
 
 	if (param.align) {
-		p->align = parse_size64(param.align);
-
-		if (p->mode == NDCTL_NS_MODE_MEMORY && p->align != SZ_2M
-				&& (!pfn || !ndctl_pfn_has_align(pfn))) {
-			/*
-			 * Initial pfn device support in the kernel
-			 * supported a 2M default alignment when
-			 * ndctl_pfn_has_align() returns false.
-			 */
-			debug("%s not support 'align' for fsdax mode\n",
-					region_name);
-			return -EAGAIN;
-		} else if (p->mode == NDCTL_NS_MODE_DAX
-				&& (!dax || !ndctl_dax_has_align(dax))) {
-			/*
-			 * Unlike the pfn case, we require the kernel to
-			 * have 'align' support for device-dax.
-			 */
-			debug("%s not support 'align' for devdax mode\n",
-					region_name);
-			return -EAGAIN;
-		} else if (!param.align_default
-				&& (p->mode == NDCTL_NS_MODE_SAFE
-					|| p->mode == NDCTL_NS_MODE_RAW)) {
-			/*
-			 * Specifying an alignment has no effect for
-			 * raw, or btt mode namespaces.
-			 */
+		if (p->mode != NDCTL_NS_MODE_MEMORY &&
+		    p->mode != NDCTL_NS_MODE_DAX) {
 			error("%s mode does not support setting an alignment\n",
 					p->mode == NDCTL_NS_MODE_SAFE
 					? "sector" : "raw");
 			return -ENXIO;
 		}
 
-		/*
-		 * Fallback to a 4K default alignment if the region is
-		 * not 2MB (typical default) aligned. This mainly helps
-		 * the nfit_test use case where it is backed by vmalloc
-		 * memory.
-		 */
-		resource = ndctl_region_get_resource(region);
-		if (param.align_default && resource < ULLONG_MAX
-				&& (resource & (SZ_2M - 1))) {
-			debug("%s: falling back to a 4K alignment\n",
-					region_name);
-			p->align = SZ_4K;
-		}
+		p->align = parse_size64(param.align);
 
 		switch (p->align) {
 		case SZ_4K:
@@ -598,16 +556,48 @@ static int validate_namespace_options(struct ndctl_region *region,
 			error("unsupported align: %s\n", param.align);
 			return -ENXIO;
 		}
+	} else {
+		/*
+		 * Use the seed namespace alignment as the default if we need
+		 * one. If we don't then use PAGE_SIZE so the size_align
+		 * checking works.
+		 */
+		if (p->mode == NDCTL_NS_MODE_MEMORY) {
+			/*
+			 * The initial pfn device support in the kernel didn't
+			 * have the 'align' sysfs attribute and assumed a 2MB
+			 * alignment. Fall back to that if we don't have the
+			 * attribute.
+			 */
+			if (pfn && ndctl_pfn_has_align(pfn))
+				p->align = ndctl_pfn_get_align(pfn);
+			else
+				p->align = SZ_2M;
+		} else if (p->mode == NDCTL_NS_MODE_DAX) {
+			/*
+			 * device dax mode was added after the align attribute
+			 * so checking for it is unnecessary.
+			 */
+			p->align = ndctl_dax_get_align(dax);
+		} else {
+			p->align = sysconf(_SC_PAGE_SIZE);
+		}
 
 		/*
-		 * 'raw' and 'sector' mode namespaces don't support an
-		 * alignment attribute.
+		 * Fallback to a page alignment if the region is not aligned
+		 * to the default. This is mainly useful for the nfit_test
+		 * use case where it is backed by vmalloc memory.
 		 */
-		if (p->mode == NDCTL_NS_MODE_MEMORY
-				|| p->mode == NDCTL_NS_MODE_DAX)
-			size_align = p->align;
+		resource = ndctl_region_get_resource(region);
+		if (resource < ULLONG_MAX && (resource & (p->align - 1))) {
+			debug("%s: falling back to a page alignment\n",
+					region_name);
+			p->align = sysconf(_SC_PAGE_SIZE);
+		}
 	}
 
+	size_align = p->align;
+
 	/* (re-)validate that the size satisfies the alignment */
 	ways = ndctl_region_get_interleave_ways(region);
 	if (p->size % (size_align * ways)) {
@@ -633,8 +623,8 @@ static int validate_namespace_options(struct ndctl_region *region,
 		p->size *= size_align;
 		p->size /= units;
 		error("'--size=' must align to interleave-width: %d and alignment: %ld\n"
-				"  did you intend --size=%lld%s?\n", ways, param.align
-				? p->align : SZ_4K, p->size, suffix);
+				"  did you intend --size=%lld%s?\n", ways, p->align,
+				p->size, suffix);
 		return -EINVAL;
 	}
 
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
