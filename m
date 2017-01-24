Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A83A481EFA
 for <linux-nvdimm@lists.01.org>; Mon, 23 Jan 2017 17:29:06 -0800 (PST)
Subject: [ndctl PATCH v2] ndctl, create-namespace: add an 'align' option
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 23 Jan 2017 17:25:00 -0800
Message-ID: <148522094936.19906.16022034275569720722.stgit@dwillia2-desk3.amr.corp.intel.com>
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

When memory-mode support was added to the kernel it also included a
facility to set the alignment of the namespace. By default it is set to
2M, but 4K and 1G are also valid options. Add this support to the
utility. As Dave notes, this is prompted by the desire to add test
support for device-dax using nfit-test resources. Given the nfit_test
resources are backed by vmalloc, the only alignment nfit_test can
support is 4K.

Based on an earlier patch by Dave Jiang.

Cc: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

Changes in v2:

* fix default alignment handling, catch the default case and don't
  enforce alignment checks for older kernels or modes where it doesn't
  make sense.

* fix up / clarify code comments

 Documentation/ndctl-create-namespace.txt |   13 ++++
 ndctl/builtin-xaction-namespace.c        |   95 +++++++++++++++++++++++-------
 ndctl/lib/libndctl.c                     |    5 ++
 ndctl/lib/libndctl.sym                   |    1 
 ndctl/libndctl.h.in                      |    1 
 util/size.h                              |    1 
 6 files changed, 95 insertions(+), 21 deletions(-)

diff --git a/Documentation/ndctl-create-namespace.txt b/Documentation/ndctl-create-namespace.txt
index 5b62b959ffb4..6007214658b6 100644
--- a/Documentation/ndctl-create-namespace.txt
+++ b/Documentation/ndctl-create-namespace.txt
@@ -84,6 +84,19 @@ OPTIONS
 	suffixes "k" or "K" for KiB, "m" or "M" for MiB, "g" or "G" for
 	GiB and "t" or "T" for TiB.
 
+	For pmem namepsaces the size must be a multiple of the
+	interleave-width and the namespace alignment (see
+	below).
+
+-a::
+--align::
+	Applications that want to establish DAX memory mappings
+	with page table entries greater than 4K in size need a
+	persistent memory namespace that is sufficiently aligned. For
+	"memory" and "dax" mode this defaults to 2M. Note that "dax"
+	mode enforces all mappings to be aligned to this value,
+	i.e. fails unaligned mapping attempts.
+
 -e::
 --reconfig=::
 	Reconfigure an existing namespace (change the mode, sector size,
diff --git a/ndctl/builtin-xaction-namespace.c b/ndctl/builtin-xaction-namespace.c
index e260a87e9b1a..78f5d04aa13d 100644
--- a/ndctl/builtin-xaction-namespace.c
+++ b/ndctl/builtin-xaction-namespace.c
@@ -39,6 +39,7 @@ static bool force;
 static struct parameters {
 	bool do_scan;
 	bool mode_default;
+	bool align_default;
 	const char *bus;
 	const char *map;
 	const char *type;
@@ -49,6 +50,7 @@ static struct parameters {
 	const char *region;
 	const char *reconfig;
 	const char *sector_size;
+	const char *align;
 } param;
 
 void builtin_xaction_namespace_reset(void)
@@ -71,6 +73,7 @@ struct parsed_parameters {
 	enum ndctl_namespace_mode mode;
 	unsigned long long size;
 	unsigned long sector_size;
+	unsigned long align;
 };
 
 #define debug(fmt, ...) \
@@ -104,6 +107,8 @@ OPT_STRING('l', "sector-size", &param.sector_size, "lba-size", \
 	"specify the logical sector size in bytes"), \
 OPT_STRING('t', "type", &param.type, "type", \
 	"specify the type of namespace to create 'pmem' or 'blk'"), \
+OPT_STRING('a', "align", &param.align, "align", \
+	"specify the namespace alignment in bytes (default: 2M)"), \
 OPT_BOOLEAN('f', "force", &force, "reconfigure namespace even if currently active")
 
 static const struct option base_options[] = {
@@ -202,6 +207,15 @@ static int set_defaults(enum namespace_action mode)
 		rc = -EINVAL;
 	}
 
+	if (param.align && parse_size64(param.align) == ULLONG_MAX) {
+		error("failed to parse namespace alignment '%s'\n",
+				param.align);
+		rc = -EINVAL;
+	} else if (!param.align) {
+		param.align = "2M";
+		param.align_default = true;
+	}
+
 	if (param.uuid) {
 		uuid_t uuid;
 
@@ -319,14 +333,8 @@ static int setup_namespace(struct ndctl_region *region,
 
 		try(ndctl_pfn, set_uuid, pfn, uuid);
 		try(ndctl_pfn, set_location, pfn, p->loc);
-
-		/*
-		 * TODO: when we allow setting a non-default alignment
-		 * we'll need to check for "has_align" earlier and fail
-		 * non-default attempts on older kernels.
-		 */
 		if (ndctl_pfn_has_align(pfn))
-			try(ndctl_pfn, set_align, pfn, SZ_2M);
+			try(ndctl_pfn, set_align, pfn, p->align);
 		try(ndctl_pfn, set_namespace, pfn, ndns);
 		rc = ndctl_pfn_enable(pfn);
 	} else if (p->mode == NDCTL_NS_MODE_DAX) {
@@ -335,7 +343,7 @@ static int setup_namespace(struct ndctl_region *region,
 		try(ndctl_dax, set_uuid, dax, uuid);
 		try(ndctl_dax, set_location, dax, p->loc);
 		/* device-dax assumes 'align' attribute present */
-		try(ndctl_dax, set_align, dax, SZ_2M);
+		try(ndctl_dax, set_align, dax, p->align);
 		try(ndctl_dax, set_namespace, dax, ndns);
 		rc = ndctl_dax_enable(dax);
 	} else if (p->mode == NDCTL_NS_MODE_SAFE) {
@@ -387,13 +395,13 @@ static int is_namespace_active(struct ndctl_namespace *ndns)
 static int validate_namespace_options(struct ndctl_region *region,
 		struct ndctl_namespace *ndns, struct parsed_parameters *p)
 {
+	const char *region_name = ndctl_region_get_devname(region);
 	int rc = 0;
 
 	memset(p, 0, sizeof(*p));
 
 	if (!ndctl_region_is_enabled(region)) {
-		debug("%s: disabled, skipping...\n",
-				ndctl_region_get_devname(region));
+		debug("%s: disabled, skipping...\n", region_name);
 		return -EAGAIN;
 	}
 
@@ -435,8 +443,7 @@ static int validate_namespace_options(struct ndctl_region *region,
 		if (ndctl_region_get_type(region) != ND_DEVICE_REGION_PMEM
 				&& (p->mode == NDCTL_NS_MODE_MEMORY
 					|| p->mode == NDCTL_NS_MODE_DAX)) {
-			debug("blk %s does not support %s mode\n",
-					ndctl_region_get_devname(region),
+			debug("blk %s does not support %s mode\n", region_name,
 					p->mode == NDCTL_NS_MODE_MEMORY
 					? "memory" : "dax");
 			return -EAGAIN;
@@ -444,6 +451,55 @@ static int validate_namespace_options(struct ndctl_region *region,
 	} else if (ndns)
 		p->mode = ndctl_namespace_get_mode(ndns);
 
+	if (param.align) {
+		struct ndctl_pfn *pfn = ndctl_region_get_pfn_seed(region);
+		struct ndctl_dax *dax = ndctl_region_get_dax_seed(region);
+
+		p->align = parse_size64(param.align);
+
+		if (p->mode == NDCTL_NS_MODE_MEMORY && p->align != SZ_2M
+				&& (!pfn || !ndctl_pfn_has_align(pfn))) {
+			/*
+			 * Initial pfn device support in the kernel
+			 * supported a 2M default alignment when
+			 * ndctl_pfn_has_align() returns false.
+			 */
+			debug("%s not support 'align' for memory mode\n",
+					region_name);
+			return -EAGAIN;
+		} else if (p->mode == NDCTL_NS_MODE_DAX
+				&& (!dax || !ndctl_dax_has_align(dax))) {
+			/*
+			 * Unlike the pfn case, we require the kernel to
+			 * have 'align' support for device-dax.
+			 */
+			debug("%s not support 'align' for dax mode\n",
+					region_name);
+			return -EAGAIN;
+		} else if (!param.align_default
+				&& (p->mode == NDCTL_NS_MODE_SAFE
+					|| p->mode == NDCTL_NS_MODE_RAW)) {
+			/*
+			 * Specifying an alignment has no effect for
+			 * raw, or btt mode namespaces.
+			 */
+			error("%s mode does not support setting an alignment\n",
+					p->mode == NDCTL_NS_MODE_SAFE
+					? "sector" : "raw");
+			return -ENXIO;
+		}
+
+		switch (p->align) {
+		case SZ_4K:
+		case SZ_2M:
+		case SZ_1G:
+			break;
+		default:
+			error("unsupported align: %s\n", param.align);
+			return -ENXIO;
+		}
+	}
+
 	if (param.sector_size) {
 		struct ndctl_btt *btt;
 		int num, i;
@@ -453,7 +509,7 @@ static int validate_namespace_options(struct ndctl_region *region,
 		if (p->mode == NDCTL_NS_MODE_SAFE) {
 			if (!btt) {
 				debug("%s: does not support 'sector' mode\n",
-						ndctl_region_get_devname(region));
+						region_name);
 				return -EINVAL;
 			}
 			num = ndctl_btt_get_num_sector_sizes(btt);
@@ -463,8 +519,7 @@ static int validate_namespace_options(struct ndctl_region *region,
 					break;
 			if (i >= num) {
 				debug("%s: does not support btt sector_size %lu\n",
-						ndctl_region_get_devname(region),
-						p->sector_size);
+						region_name, p->sector_size);
 				return -EINVAL;
 			}
 		} else {
@@ -479,8 +534,7 @@ static int validate_namespace_options(struct ndctl_region *region,
 					break;
 			if (i >= num) {
 				debug("%s: does not support namespace sector_size %lu\n",
-						ndctl_region_get_devname(region),
-						p->sector_size);
+						region_name, p->sector_size);
 				return -EINVAL;
 			}
 		}
@@ -517,12 +571,11 @@ static int validate_namespace_options(struct ndctl_region *region,
 		struct ndctl_pfn *pfn = ndctl_region_get_pfn_seed(region);
 
 		if (!pfn && param.mode_default) {
-			debug("%s memory mode not available\n",
-					ndctl_region_get_devname(region));
+			debug("%s memory mode not available\n", region_name);
 			p->mode = NDCTL_NS_MODE_RAW;
 		} else if (!pfn) {
 			error("operation failed, %s memory mode not available\n",
-					ndctl_region_get_devname(region));
+					region_name);
 			return -EINVAL;
 		}
 	}
@@ -533,7 +586,7 @@ static int validate_namespace_options(struct ndctl_region *region,
 
 		if (!dax) {
 			error("operation failed, %s dax mode not available\n",
-					ndctl_region_get_devname(region));
+					region_name);
 			return -EINVAL;
 		}
 	}
diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 8240235dff5c..49e35bf0fd98 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -4477,6 +4477,11 @@ NDCTL_EXPORT unsigned long ndctl_dax_get_align(struct ndctl_dax *dax)
 	return ndctl_pfn_get_align(&dax->pfn);
 }
 
+NDCTL_EXPORT int ndctl_dax_has_align(struct ndctl_dax *dax)
+{
+	return ndctl_pfn_has_align(&dax->pfn);
+}
+
 NDCTL_EXPORT int ndctl_dax_set_align(struct ndctl_dax *dax, unsigned long align)
 {
 	return ndctl_pfn_set_align(&dax->pfn, align);
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 506bf0d67aab..be2e3680d202 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -259,6 +259,7 @@ global:
 	ndctl_dax_get_location;
 	ndctl_dax_set_location;
 	ndctl_dax_get_align;
+	ndctl_dax_has_align;
 	ndctl_dax_set_align;
 	ndctl_dax_set_namespace;
 	ndctl_dax_get_bus;
diff --git a/ndctl/libndctl.h.in b/ndctl/libndctl.h.in
index 394d22e24c7a..c27581d939c5 100644
--- a/ndctl/libndctl.h.in
+++ b/ndctl/libndctl.h.in
@@ -603,6 +603,7 @@ int ndctl_dax_set_uuid(struct ndctl_dax *dax, uuid_t uu);
 enum ndctl_pfn_loc ndctl_dax_get_location(struct ndctl_dax *dax);
 int ndctl_dax_set_location(struct ndctl_dax *dax, enum ndctl_pfn_loc loc);
 unsigned long ndctl_dax_get_align(struct ndctl_dax *dax);
+int ndctl_dax_has_align(struct ndctl_dax *dax);
 int ndctl_dax_set_align(struct ndctl_dax *dax, unsigned long align);
 int ndctl_dax_set_namespace(struct ndctl_dax *dax,
 		struct ndctl_namespace *ndns);
diff --git a/util/size.h b/util/size.h
index 50917a5cea34..634c92621bdc 100644
--- a/util/size.h
+++ b/util/size.h
@@ -2,6 +2,7 @@
 #define _NDCTL_SIZE_H_
 
 #define SZ_1K     0x00000400
+#define SZ_4K     0x00001000
 #define SZ_1M     0x00100000
 #define SZ_2M     0x00200000
 #define SZ_4M     0x00400000

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
