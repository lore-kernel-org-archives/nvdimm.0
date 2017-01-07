Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2D1BC81A51
 for <linux-nvdimm@lists.01.org>; Fri,  6 Jan 2017 17:46:29 -0800 (PST)
Subject: [ndctl PATCH 3/7] ndctl, list: add option to filter namespace by mode
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 06 Jan 2017 17:42:22 -0800
Message-ID: <148375334240.38836.11254192921259549701.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <148375332631.38836.5735184615585844571.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <148375332631.38836.5735184615585844571.stgit@dwillia2-desk3.amr.corp.intel.com>
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

For example, "ndctl list -m dax" list all the namespaces that are
hosting a device-dax region.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/builtin-list.c |   33 ++++++++++++++++++++++++++++++++-
 ndctl/libndctl.h.in  |    1 +
 2 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/ndctl/builtin-list.c b/ndctl/builtin-list.c
index caafec8b8f39..b09da3057519 100644
--- a/ndctl/builtin-list.c
+++ b/ndctl/builtin-list.c
@@ -30,6 +30,7 @@ static struct {
 	const char *region;
 	const char *type;
 	const char *dimm;
+	const char *mode;
 	const char *namespace;
 } param;
 
@@ -43,6 +44,25 @@ do { \
 			VERSION, __func__, __LINE__, ##__VA_ARGS__); \
 } while (0)
 
+static enum ndctl_namespace_mode mode_to_type(const char *mode)
+{
+	if (!mode)
+		return -ENXIO;
+
+	if (strcasecmp(param.mode, "memory") == 0)
+		return NDCTL_NS_MODE_MEMORY;
+	else if (strcasecmp(param.mode, "sector") == 0)
+		return NDCTL_NS_MODE_SAFE;
+	else if (strcasecmp(param.mode, "safe") == 0)
+		return NDCTL_NS_MODE_SAFE;
+	else if (strcasecmp(param.mode, "dax") == 0)
+		return NDCTL_NS_MODE_DAX;
+	else if (strcasecmp(param.mode, "raw") == 0)
+		return NDCTL_NS_MODE_RAW;
+
+	return NDCTL_NS_MODE_UNKNOWN;
+}
+
 static struct json_object *list_namespaces(struct ndctl_region *region,
 		struct json_object *container, struct json_object *jnamespaces,
 		bool continue_array)
@@ -50,6 +70,7 @@ static struct json_object *list_namespaces(struct ndctl_region *region,
 	struct ndctl_namespace *ndns;
 
 	ndctl_namespace_foreach(region, ndns) {
+		enum ndctl_namespace_mode mode = ndctl_namespace_get_mode(ndns);
 		struct json_object *jndns;
 
 		/* are we emitting namespaces? */
@@ -59,6 +80,9 @@ static struct json_object *list_namespaces(struct ndctl_region *region,
 		if (!util_namespace_filter(ndns, param.namespace))
 			continue;
 
+		if (param.mode && mode_to_type(param.mode) != mode)
+			continue;
+
 		if (!list.idle && !util_namespace_active(ndns))
 			continue;
 
@@ -197,7 +221,9 @@ int cmd_list(int argc, const char **argv, void *ctx)
 		OPT_STRING('d', "dimm", &param.dimm, "dimm-id",
 				"filter by dimm"),
 		OPT_STRING('n', "namespace", &param.namespace, "namespace-id",
-				"filter by namespace"),
+				"filter by namespace id"),
+		OPT_STRING('m', "mode", &param.mode, "namespace-mode",
+				"filter by namespace mode"),
 		OPT_STRING('t', "type", &param.type, "region-type",
 				"filter by region-type"),
 		OPT_BOOLEAN('B', "buses", &list.buses, "include bus info"),
@@ -251,6 +277,11 @@ int cmd_list(int argc, const char **argv, void *ctx)
 			type = ND_DEVICE_REGION_BLK;
 	}
 
+	if (mode_to_type(param.mode) == NDCTL_NS_MODE_UNKNOWN) {
+		error("invalid mode: '%s'\n", param.mode);
+		return -EINVAL;
+	}
+
 	ndctl_bus_foreach(ctx, bus) {
 		struct json_object *jbus = NULL;
 		struct ndctl_region *region;
diff --git a/ndctl/libndctl.h.in b/ndctl/libndctl.h.in
index d45111775525..394d22e24c7a 100644
--- a/ndctl/libndctl.h.in
+++ b/ndctl/libndctl.h.in
@@ -475,6 +475,7 @@ enum ndctl_namespace_mode {
 	NDCTL_NS_MODE_SAFE,
 	NDCTL_NS_MODE_RAW,
 	NDCTL_NS_MODE_DAX,
+	NDCTL_NS_MODE_UNKNOWN,
 };
 enum ndctl_namespace_mode ndctl_namespace_get_mode(
 		struct ndctl_namespace *ndns);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
