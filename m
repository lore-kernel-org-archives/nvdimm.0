Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 809AD81A50
 for <linux-nvdimm@lists.01.org>; Fri,  6 Jan 2017 17:46:34 -0800 (PST)
Subject: [ndctl PATCH 4/7] ndctl, list: add '--device-dax' option
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 06 Jan 2017 17:42:27 -0800
Message-ID: <148375334767.38836.3212498203274864340.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Only include dax region and sub-device info when requested by this new
option to ndctl list. If '--device-dax' is the only option then the
listing will only include namespaces in device-dax mode.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/builtin-list.c              |    7 ++++++-
 ndctl/builtin-xaction-namespace.c |    2 +-
 util/json.c                       |   12 +++++++-----
 util/json.h                       |    2 +-
 4 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/ndctl/builtin-list.c b/ndctl/builtin-list.c
index b09da3057519..ed4edf6f0249 100644
--- a/ndctl/builtin-list.c
+++ b/ndctl/builtin-list.c
@@ -23,6 +23,7 @@ static struct {
 	bool namespaces;
 	bool idle;
 	bool health;
+	bool dax;
 } list;
 
 static struct {
@@ -98,7 +99,7 @@ static struct json_object *list_namespaces(struct ndctl_region *region,
 						jnamespaces);
 		}
 
-		jndns = util_namespace_to_json(ndns, list.idle);
+		jndns = util_namespace_to_json(ndns, list.idle, list.dax);
 		if (!jndns) {
 			fail("\n");
 			continue;
@@ -233,6 +234,8 @@ int cmd_list(int argc, const char **argv, void *ctx)
 				"include region info"),
 		OPT_BOOLEAN('N', "namespaces", &list.namespaces,
 				"include namespace info (default)"),
+		OPT_BOOLEAN('X', "device-dax", &list.dax,
+				"include device-dax info"),
 		OPT_BOOLEAN('i', "idle", &list.idle, "include idle devices"),
 		OPT_END(),
 	};
@@ -265,6 +268,8 @@ int cmd_list(int argc, const char **argv, void *ctx)
 		list.buses = !!param.bus;
 		list.regions = !!param.region;
 		list.dimms = !!param.dimm;
+		if (list.dax && !param.mode)
+			param.mode = "dax";
 	}
 
 	if (num_list_flags() == 0)
diff --git a/ndctl/builtin-xaction-namespace.c b/ndctl/builtin-xaction-namespace.c
index f7a4e5b74a16..2c4f85f5e4ac 100644
--- a/ndctl/builtin-xaction-namespace.c
+++ b/ndctl/builtin-xaction-namespace.c
@@ -352,7 +352,7 @@ static int setup_namespace(struct ndctl_region *region,
 		error("%s: failed to enable\n",
 				ndctl_namespace_get_devname(ndns));
 	} else {
-		struct json_object *jndns = util_namespace_to_json(ndns, 0);
+		struct json_object *jndns = util_namespace_to_json(ndns, 0, 0);
 
 		if (jndns)
 			printf("%s\n", json_object_to_json_string_ext(jndns,
diff --git a/util/json.c b/util/json.c
index 82e677c2c7a7..299c1b5782ee 100644
--- a/util/json.c
+++ b/util/json.c
@@ -139,7 +139,7 @@ static json_object *util_daxctl_region_to_json(struct daxctl_region *region,
 }
 
 struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
-		bool include_idle)
+		bool include_idle, bool include_dax)
 {
 	struct json_object *jndns = json_object_new_object();
 	unsigned long long size = ULLONG_MAX;
@@ -231,10 +231,12 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 		if (!jobj)
 			goto err;
 		json_object_object_add(jndns, "uuid", jobj);
-		dax_region = ndctl_dax_get_daxctl_region(dax);
-		jobj = util_daxctl_region_to_json(dax_region, include_idle);
-		if (jobj)
-			json_object_object_add(jndns, "daxdevs", jobj);
+		if (include_dax) {
+			dax_region = ndctl_dax_get_daxctl_region(dax);
+			jobj = util_daxctl_region_to_json(dax_region, include_idle);
+			if (jobj)
+				json_object_object_add(jndns, "daxdevs", jobj);
+		}
 	} else if (ndctl_namespace_get_type(ndns) != ND_DEVICE_NAMESPACE_IO) {
 		const char *name;
 
diff --git a/util/json.h b/util/json.h
index 7492e51621a7..b8fc00f57ea8 100644
--- a/util/json.h
+++ b/util/json.h
@@ -11,7 +11,7 @@ struct json_object *util_bus_to_json(struct ndctl_bus *bus);
 struct json_object *util_dimm_to_json(struct ndctl_dimm *dimm);
 struct json_object *util_mapping_to_json(struct ndctl_mapping *mapping);
 struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
-		bool include_idle);
+		bool include_idle, bool include_dax);
 #ifdef HAVE_NDCTL_SMART
 struct json_object *util_dimm_health_to_json(struct ndctl_dimm *dimm);
 #else

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
