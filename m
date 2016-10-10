Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4B5C01A1E34
 for <linux-nvdimm@lists.01.org>; Sun,  9 Oct 2016 17:36:21 -0700 (PDT)
From: Haozhong Zhang <haozhong.zhang@intel.com>
Subject: [RFC NDCTL PATCH] ndctl: add support for Xen mode namespace
Date: Mon, 10 Oct 2016 08:36:02 +0800
Message-Id: <20161010003602.4513-1-haozhong.zhang@intel.com>
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
To: linux-nvdimm@lists.01.org, xen-devel@lists.xenproject.org
Cc: Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Add support to create the Xen mode namespace which turns the underlying
pfn device into PFN_MODE_XEN.

Signed-off-by: Haozhong Zhang <haozhong.zhang@intel.com>
---
 ndctl/builtin-xaction-namespace.c | 7 ++++++-
 ndctl/lib/libndctl.c              | 6 ++++++
 ndctl/libndctl.h.in               | 2 ++
 ndctl/util/json.c                 | 4 ++++
 4 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/ndctl/builtin-xaction-namespace.c b/ndctl/builtin-xaction-namespace.c
index 9b1702d..f60551d 100644
--- a/ndctl/builtin-xaction-namespace.c
+++ b/ndctl/builtin-xaction-namespace.c
@@ -176,6 +176,8 @@ static int set_defaults(enum namespace_action mode)
 			/* pass */;
 		else if (strcmp(param.map, "dev") == 0)
 			/* pass */;
+		else if (strcmp(param.map, "xen") == 0)
+			/* pass */;
 		else {
 			error("invalid map location '%s'\n", param.map);
 			rc = -EINVAL;
@@ -292,7 +294,8 @@ static bool do_setup_pfn(struct ndctl_namespace *ndns,
 	 * array in device memory.
 	 */
 	if (!ndns || ndctl_namespace_get_mode(ndns) != NDCTL_NS_MODE_MEMORY
-			|| p->loc == NDCTL_PFN_LOC_PMEM)
+			|| p->loc == NDCTL_PFN_LOC_PMEM
+			|| p->loc == NDCTL_PFN_LOC_XEN)
 		return true;
 
 	return false;
@@ -486,6 +489,8 @@ static int validate_namespace_options(struct ndctl_region *region,
 	if (param.map) {
 		if (!strcmp(param.map, "mem"))
 			p->loc = NDCTL_PFN_LOC_RAM;
+		else if (!strcmp(param.map, "xen"))
+			p->loc = NDCTL_PFN_LOC_XEN;
 		else
 			p->loc = NDCTL_PFN_LOC_PMEM;
 
diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 14bf217..35882db 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -3015,6 +3015,8 @@ NDCTL_EXPORT enum ndctl_namespace_mode ndctl_namespace_get_mode(
 		return NDCTL_NS_MODE_RAW;
 	if (strcmp("safe", buf) == 0)
 		return NDCTL_NS_MODE_SAFE;
+	if (strcmp("xen", buf) == 0)
+		return NDCTL_NS_MODE_XEN;
 	return -ENXIO;
 }
 
@@ -3998,6 +4000,8 @@ static int __add_pfn(struct ndctl_pfn *pfn, const char *pfn_base)
 		pfn->loc = NDCTL_PFN_LOC_RAM;
 	else if (strcmp(buf, "pmem") == 0)
 		pfn->loc = NDCTL_PFN_LOC_PMEM;
+	else if (strcmp(buf, "xen") == 0)
+		pfn->loc = NDCTL_PFN_LOC_XEN;
 	else
 		goto err_read;
 
@@ -4190,12 +4194,14 @@ NDCTL_EXPORT int ndctl_pfn_set_location(struct ndctl_pfn *pfn,
 		[NDCTL_PFN_LOC_NONE] = "none",
 		[NDCTL_PFN_LOC_RAM] = "ram",
 		[NDCTL_PFN_LOC_PMEM] = "pmem",
+		[NDCTL_PFN_LOC_XEN] = "xen",
 	};
 
 	switch (loc) {
 	case NDCTL_PFN_LOC_NONE:
 	case NDCTL_PFN_LOC_RAM:
 	case NDCTL_PFN_LOC_PMEM:
+	case NDCTL_PFN_LOC_XEN:
 		break;
 	default:
 		return -EINVAL;
diff --git a/ndctl/libndctl.h.in b/ndctl/libndctl.h.in
index 803368b..7d61e32 100644
--- a/ndctl/libndctl.h.in
+++ b/ndctl/libndctl.h.in
@@ -472,6 +472,7 @@ enum ndctl_namespace_mode {
 	NDCTL_NS_MODE_SAFE,
 	NDCTL_NS_MODE_RAW,
 	NDCTL_NS_MODE_DAX,
+	NDCTL_NS_MODE_XEN,
 };
 enum ndctl_namespace_mode ndctl_namespace_get_mode(
 		struct ndctl_namespace *ndns);
@@ -560,6 +561,7 @@ enum ndctl_pfn_loc {
 	NDCTL_PFN_LOC_NONE,
 	NDCTL_PFN_LOC_RAM,
 	NDCTL_PFN_LOC_PMEM,
+	NDCTL_PFN_LOC_XEN,
 };
 int ndctl_pfn_set_location(struct ndctl_pfn *pfn, enum ndctl_pfn_loc loc);
 enum ndctl_pfn_loc ndctl_pfn_get_location(struct ndctl_pfn *pfn);
diff --git a/ndctl/util/json.c b/ndctl/util/json.c
index 82e677c..8083219 100644
--- a/ndctl/util/json.c
+++ b/ndctl/util/json.c
@@ -188,6 +188,10 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 		size = ndctl_namespace_get_size(ndns);
 		jobj = json_object_new_string("raw");
 		break;
+	case NDCTL_NS_MODE_XEN:
+		size = ndctl_namespace_get_size(ndns);
+		jobj = json_object_new_string("xen");
+		break;
 	default:
 		jobj = NULL;
 	}
-- 
2.10.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
