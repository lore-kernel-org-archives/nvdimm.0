Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917CF20EA
	for <nvdimm@lists.linux.dev>; Fri, 15 Jul 2022 06:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657866371; x=1689402371;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VScp0z0ULQqc/XnWR0snJ26/sWE9rhYK9NXAVkcwxTw=;
  b=bCNJbAFzXCaYKigN4D4vk/95cKxV/P639oztz32qv50EsmmsJ8v5DEIh
   ZZEOC1ybGeziN3aFbE4qBcSiy3IG3ELVkD2T6tLeTAzsTQ2JDiozEY+tT
   YIDTAp7IBh6leKlONI+ff0TUsX2F+YGEoFEVKYPnNRlAjEmRgRzLVss2Z
   7yRDgRm8zmFSEF7nwb/1EXTRbXMXCKb+1Vz0t2cEDX2qi7346sLinLfSa
   LZ5zqxPiyuD1KFuhC9exbIl5dYvXPb5qkq0a+MetovuI850BsMiSB2Tal
   xUL21hF1gbltqx5ySoCo5mkx+MxlICwytFI+2RRMuKXcJDJttJJLUZhfY
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="266125538"
X-IronPort-AV: E=Sophos;i="5.92,273,1650956400"; 
   d="scan'208";a="266125538"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 23:26:10 -0700
X-IronPort-AV: E=Sophos;i="5.92,273,1650956400"; 
   d="scan'208";a="546544617"
Received: from saseiper-mobl.amr.corp.intel.com (HELO vverma7-desk1.intel.com) ([10.212.71.32])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 23:26:10 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-cxl@vger.kernel.org>
Cc: <nvdimm@lists.linux.dev>,
	Dan Williams <dan.j.williams@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 4/8] cxl-cli: add region listing support
Date: Fri, 15 Jul 2022 00:25:46 -0600
Message-Id: <20220715062550.789736-5-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220715062550.789736-1-vishal.l.verma@intel.com>
References: <20220715062550.789736-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=16100; h=from:subject; bh=VScp0z0ULQqc/XnWR0snJ26/sWE9rhYK9NXAVkcwxTw=; b=owGbwMvMwCXGf25diOft7jLG02pJDEkXOfLeWYvvteVQv3Vwy/HUfUyZXzbvfbg5pMepZcGy8ikN Kg+0OkpZGMS4GGTFFFn+7vnIeExuez5PYIIjzBxWJpAhDFycAjAR6zWMDP8s5CJtY9dy7hCU8E1SX9 HJfsPXYBK3ybrlpwJ57y+V2cPI8OYNk9EJCa+LsceXxtlPmMPy0XdGYknhzmKn+lP8f7YJsAIA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Add cxl_region -> json and cxl_mapping -> json emitter helpers, and
teach cxl_filter_walk about cxl_regions. With these in place, 'cxl-list'
can now emit json objects for CXL regions. They can be top-level objects
if requested by themselves, or nested under root-decoders, if listed
along with decoders. Allow a plain 'cxl list' command to imply
'--regions'.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Documentation/cxl/cxl-list.txt |  13 +++-
 cxl/filter.h                   |   4 ++
 cxl/json.h                     |   5 ++
 cxl/filter.c                   | 121 +++++++++++++++++++++++++++++---
 cxl/json.c                     | 123 +++++++++++++++++++++++++++++++++
 cxl/list.c                     |  25 ++++---
 6 files changed, 265 insertions(+), 26 deletions(-)

diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
index f6aba0c..2906c2f 100644
--- a/Documentation/cxl/cxl-list.txt
+++ b/Documentation/cxl/cxl-list.txt
@@ -309,8 +309,9 @@ OPTIONS
 
 -T::
 --targets::
-	Extend decoder listings with downstream port target information, and /
-	or port and bus listings with the downstream port information.
+	Extend decoder listings with downstream port target information, port
+	and bus listings with the downstream port information, and / or regions
+	with mapping information.
 ----
 # cxl list -BTu -b ACPI.CXL
 {
@@ -327,6 +328,14 @@ OPTIONS
 }
 ----
 
+-R::
+--regions::
+	Include region objects in the listing.
+
+-r::
+--region::
+	Specify the region name to filter the emitted regions.
+
 --debug::
 	If the cxl tool was built with debug enabled, turn on debug
 	messages.
diff --git a/cxl/filter.h b/cxl/filter.h
index c913daf..609433c 100644
--- a/cxl/filter.h
+++ b/cxl/filter.h
@@ -13,9 +13,11 @@ struct cxl_filter_params {
 	const char *port_filter;
 	const char *endpoint_filter;
 	const char *decoder_filter;
+	const char *region_filter;
 	bool single;
 	bool endpoints;
 	bool decoders;
+	bool regions;
 	bool targets;
 	bool memdevs;
 	bool ports;
@@ -33,6 +35,8 @@ struct cxl_memdev *util_cxl_memdev_filter(struct cxl_memdev *memdev,
 struct cxl_port *util_cxl_port_filter_by_memdev(struct cxl_port *port,
 						const char *ident,
 						const char *serial);
+struct cxl_region *util_cxl_region_filter(struct cxl_region *region,
+					    const char *__ident);
 
 enum cxl_port_filter_mode {
 	CXL_PF_SINGLE,
diff --git a/cxl/json.h b/cxl/json.h
index 9a5a845..eb7572b 100644
--- a/cxl/json.h
+++ b/cxl/json.h
@@ -15,6 +15,11 @@ struct json_object *util_cxl_endpoint_to_json(struct cxl_endpoint *endpoint,
 					      unsigned long flags);
 struct json_object *util_cxl_decoder_to_json(struct cxl_decoder *decoder,
 					     unsigned long flags);
+struct json_object *util_cxl_region_to_json(struct cxl_region *region,
+					     unsigned long flags);
+void util_cxl_mappings_append_json(struct json_object *jregion,
+				  struct cxl_region *region,
+				  unsigned long flags);
 void util_cxl_targets_append_json(struct json_object *jdecoder,
 				  struct cxl_decoder *decoder,
 				  const char *ident, const char *serial,
diff --git a/cxl/filter.c b/cxl/filter.c
index e5fab19..ae95e2e 100644
--- a/cxl/filter.c
+++ b/cxl/filter.c
@@ -585,6 +585,41 @@ util_cxl_memdev_filter_by_port(struct cxl_memdev *memdev, const char *bus_ident,
 	return NULL;
 }
 
+struct cxl_region *util_cxl_region_filter(struct cxl_region *region,
+					    const char *__ident)
+{
+	char *ident, *save;
+	const char *name;
+	int id;
+
+	if (!__ident)
+		return region;
+
+	ident = strdup(__ident);
+	if (!ident)
+		return NULL;
+
+	for (name = strtok_r(ident, which_sep(__ident), &save); name;
+	     name = strtok_r(NULL, which_sep(__ident), &save)) {
+		if (strcmp(name, "all") == 0)
+			break;
+
+		if ((sscanf(name, "%d", &id) == 1 ||
+		     sscanf(name, "region%d", &id) == 1) &&
+		    cxl_region_get_id(region) == id)
+			break;
+
+		if (strcmp(name, cxl_region_get_devname(region)) == 0)
+			break;
+	}
+
+	free(ident);
+	if (name)
+		return region;
+	return NULL;
+
+}
+
 static unsigned long params_to_flags(struct cxl_filter_params *param)
 {
 	unsigned long flags = 0;
@@ -672,37 +707,79 @@ static struct json_object *pick_array(struct json_object *child,
 	return NULL;
 }
 
+static void walk_regions(struct cxl_decoder *decoder,
+			 struct json_object *jregions,
+			 struct cxl_filter_params *p,
+			 unsigned long flags)
+{
+	struct json_object *jregion;
+	struct cxl_region *region;
+
+	cxl_region_foreach(decoder, region) {
+		if (!util_cxl_region_filter(region, p->region_filter))
+			continue;
+		if (!p->idle && !cxl_region_is_enabled(region))
+			continue;
+		jregion = util_cxl_region_to_json(region, flags);
+		if (!jregion)
+			continue;
+		json_object_array_add(jregions, jregion);
+	}
+
+	return;
+}
+
 static void walk_decoders(struct cxl_port *port, struct cxl_filter_params *p,
-			  struct json_object *jdecoders, unsigned long flags)
+			  struct json_object *jdecoders,
+			  struct json_object *jregions, unsigned long flags)
 {
 	struct cxl_decoder *decoder;
 
 	cxl_decoder_foreach(port, decoder) {
+		const char *devname = cxl_decoder_get_devname(decoder);
+		struct json_object *jchildregions = NULL;
 		struct json_object *jdecoder;
 
+		if (p->regions && p->decoders) {
+			jchildregions = json_object_new_array();
+			if (!jchildregions) {
+				err(p, "failed to allocate region object\n");
+				return;
+			}
+		}
+
+		if (p->regions && cxl_port_is_root(port))
+			walk_regions(decoder,
+				     pick_array(jchildregions, jregions),
+				     p, flags);
 		if (!p->decoders)
-			continue;
+			goto put_continue;
 		if (!util_cxl_decoder_filter(decoder, p->decoder_filter))
-			continue;
+			goto put_continue;
 		if (!util_cxl_decoder_filter_by_bus(decoder, p->bus_filter))
-			continue;
+			goto put_continue;
 		if (!util_cxl_decoder_filter_by_port(decoder, p->port_filter,
 						     pf_mode(p)))
-			continue;
+			goto put_continue;
 		if (!util_cxl_decoder_filter_by_memdev(
 			    decoder, p->memdev_filter, p->serial_filter))
-			continue;
+			goto put_continue;
 		if (!p->idle && cxl_decoder_get_size(decoder) == 0)
-			continue;
+			goto put_continue;
 		jdecoder = util_cxl_decoder_to_json(decoder, flags);
 		if (!decoder) {
 			dbg(p, "decoder object allocation failure\n");
-			continue;
+			goto put_continue;
 		}
 		util_cxl_targets_append_json(jdecoder, decoder,
 					     p->memdev_filter, p->serial_filter,
 					     flags);
+		cond_add_put_array_suffix(jdecoder, "regions", devname,
+					  jchildregions);
 		json_object_array_add(jdecoders, jdecoder);
+		continue;
+put_continue:
+		json_object_put(jchildregions);
 	}
 }
 
@@ -782,7 +859,7 @@ static void walk_endpoints(struct cxl_port *port, struct cxl_filter_params *p,
 		if (!p->decoders)
 			continue;
 		walk_decoders(cxl_endpoint_get_port(endpoint), p,
-			      pick_array(jchilddecoders, jdecoders), flags);
+			      pick_array(jchilddecoders, jdecoders), NULL, flags);
 		cond_add_put_array_suffix(jendpoint, "decoders", devname,
 					  jchilddecoders);
 	}
@@ -869,7 +946,8 @@ walk_children:
 				       flags);
 
 		walk_decoders(port, p,
-			      pick_array(jchilddecoders, jportdecoders), flags);
+			      pick_array(jchilddecoders, jportdecoders), NULL,
+			      flags);
 		walk_child_ports(port, p, pick_array(jchildports, jports),
 				 pick_array(jchilddecoders, jportdecoders),
 				 pick_array(jchildeps, jeps),
@@ -894,6 +972,7 @@ int cxl_filter_walk(struct cxl_ctx *ctx, struct cxl_filter_params *p)
 	struct json_object *jbusdecoders = NULL;
 	struct json_object *jepdecoders = NULL;
 	struct json_object *janondevs = NULL;
+	struct json_object *jregions = NULL;
 	struct json_object *jeps = NULL;
 	struct cxl_memdev *memdev;
 	int top_level_objs = 0;
@@ -936,6 +1015,10 @@ int cxl_filter_walk(struct cxl_ctx *ctx, struct cxl_filter_params *p)
 	if (!jepdecoders)
 		goto err;
 
+	jregions = json_object_new_array();
+	if (!jregions)
+		goto err;
+
 	dbg(p, "walk memdevs\n");
 	cxl_memdev_foreach(ctx, memdev) {
 		struct json_object *janondev;
@@ -964,6 +1047,7 @@ int cxl_filter_walk(struct cxl_ctx *ctx, struct cxl_filter_params *p)
 		struct json_object *jchildports = NULL;
 		struct json_object *jchilddevs = NULL;
 		struct json_object *jchildeps = NULL;
+		struct json_object *jchildregions = NULL;
 		struct cxl_port *port = cxl_bus_get_port(bus);
 		const char *devname = cxl_bus_get_devname(bus);
 
@@ -1021,11 +1105,20 @@ int cxl_filter_walk(struct cxl_ctx *ctx, struct cxl_filter_params *p)
 					continue;
 				}
 			}
+			if (p->regions && !p->decoders) {
+				jchildregions = json_object_new_array();
+				if (!jchildregions) {
+					err(p,
+					    "%s: failed to enumerate child regions\n",
+					    devname);
+					continue;
+				}
+			}
 		}
 walk_children:
 		dbg(p, "walk decoders\n");
 		walk_decoders(port, p, pick_array(jchilddecoders, jbusdecoders),
-			      flags);
+			      pick_array(jchildregions, jregions), flags);
 
 		dbg(p, "walk ports\n");
 		walk_child_ports(port, p, pick_array(jchildports, jports),
@@ -1038,6 +1131,8 @@ walk_children:
 					  jchildeps);
 		cond_add_put_array_suffix(jbus, "decoders", devname,
 					  jchilddecoders);
+		cond_add_put_array_suffix(jbus, "regions", devname,
+					  jchildregions);
 		cond_add_put_array_suffix(jbus, "memdevs", devname, jchilddevs);
 	}
 
@@ -1057,6 +1152,8 @@ walk_children:
 		top_level_objs++;
 	if (json_object_array_length(jepdecoders))
 		top_level_objs++;
+	if (json_object_array_length(jregions))
+		top_level_objs++;
 
 	splice_array(p, janondevs, jplatform, "anon memdevs", top_level_objs > 1);
 	splice_array(p, jbuses, jplatform, "buses", top_level_objs > 1);
@@ -1069,6 +1166,7 @@ walk_children:
 		     top_level_objs > 1);
 	splice_array(p, jepdecoders, jplatform, "endpoint decoders",
 		     top_level_objs > 1);
+	splice_array(p, jregions, jplatform, "regions", top_level_objs > 1);
 
 	util_display_json_array(stdout, jplatform, flags);
 
@@ -1082,6 +1180,7 @@ err:
 	json_object_put(jbusdecoders);
 	json_object_put(jportdecoders);
 	json_object_put(jepdecoders);
+	json_object_put(jregions);
 	json_object_put(jplatform);
 	return -ENOMEM;
 }
diff --git a/cxl/json.c b/cxl/json.c
index ae9c812..1508338 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -524,6 +524,129 @@ struct json_object *util_cxl_decoder_to_json(struct cxl_decoder *decoder,
 	return jdecoder;
 }
 
+void util_cxl_mappings_append_json(struct json_object *jregion,
+				  struct cxl_region *region,
+				  unsigned long flags)
+{
+	struct json_object *jobj, *jmappings;
+	struct cxl_memdev_mapping *mapping;
+	unsigned int val, nr_mappings;
+	const char *devname;
+
+	nr_mappings = cxl_region_get_interleave_ways(region);
+	if (!nr_mappings || (nr_mappings == UINT_MAX))
+		return;
+
+	if (!(flags & UTIL_JSON_TARGETS))
+		return;
+
+	jmappings = json_object_new_array();
+	if (!jmappings)
+		return;
+
+	cxl_mapping_foreach(region, mapping) {
+		struct json_object *jmapping;
+		struct cxl_decoder *decoder;
+		struct cxl_memdev *memdev;
+
+		jmapping = json_object_new_object();
+		if (!jmapping)
+			continue;
+
+		val = cxl_mapping_get_position(mapping);
+		if (val < UINT_MAX) {
+			jobj = json_object_new_int(val);
+			if (jobj)
+				json_object_object_add(jmapping, "position",
+						       jobj);
+		}
+
+		decoder = cxl_mapping_get_decoder(mapping);
+		if (!decoder)
+			continue;
+
+		memdev = cxl_ep_decoder_get_memdev(decoder);
+		if (memdev) {
+			devname = cxl_memdev_get_devname(memdev);
+			jobj = json_object_new_string(devname);
+			if (jobj)
+				json_object_object_add(jmapping, "memdev", jobj);
+		}
+
+		devname = cxl_decoder_get_devname(decoder);
+		jobj = json_object_new_string(devname);
+		if (jobj)
+			json_object_object_add(jmapping, "decoder", jobj);
+
+		json_object_array_add(jmappings, jmapping);
+	}
+
+	json_object_object_add(jregion, "mappings", jmappings);
+}
+
+struct json_object *util_cxl_region_to_json(struct cxl_region *region,
+					     unsigned long flags)
+{
+	const char *devname = cxl_region_get_devname(region);
+	struct json_object *jregion, *jobj;
+	u64 val;
+
+	jregion = json_object_new_object();
+	if (!jregion)
+		return NULL;
+
+	jobj = json_object_new_string(devname);
+	if (jobj)
+		json_object_object_add(jregion, "region", jobj);
+
+	val = cxl_region_get_resource(region);
+	if (val < ULLONG_MAX) {
+		jobj = util_json_object_hex(val, flags);
+		if (jobj)
+			json_object_object_add(jregion, "resource", jobj);
+	}
+
+	val = cxl_region_get_size(region);
+	if (val < ULLONG_MAX) {
+		jobj = util_json_object_size(val, flags);
+		if (jobj)
+			json_object_object_add(jregion, "size", jobj);
+	}
+
+	val = cxl_region_get_interleave_ways(region);
+	if (val < INT_MAX) {
+		jobj = json_object_new_int(val);
+		if (jobj)
+			json_object_object_add(jregion,
+					       "interleave_ways", jobj);
+	}
+
+	val = cxl_region_get_interleave_granularity(region);
+	if (val < INT_MAX) {
+		jobj = json_object_new_int(val);
+		if (jobj)
+			json_object_object_add(jregion,
+					       "interleave_granularity", jobj);
+	}
+
+	if (cxl_region_is_committed(region))
+		jobj = json_object_new_boolean(true);
+	else
+		jobj = json_object_new_boolean(false);
+	if (jobj)
+		json_object_object_add(jregion, "committed", jobj);
+
+	if (!cxl_region_is_enabled(region)) {
+		jobj = json_object_new_string("disabled");
+		if (jobj)
+			json_object_object_add(jregion, "state", jobj);
+	}
+
+	util_cxl_mappings_append_json(jregion, region, flags);
+
+	return jregion;
+}
+
 void util_cxl_targets_append_json(struct json_object *jdecoder,
 				  struct cxl_decoder *decoder,
 				  const char *ident, const char *serial,
diff --git a/cxl/list.c b/cxl/list.c
index 1b5f583..88ca9d9 100644
--- a/cxl/list.c
+++ b/cxl/list.c
@@ -41,7 +41,10 @@ static const struct option options[] = {
 	OPT_BOOLEAN('D', "decoders", &param.decoders,
 		    "include CXL decoder info"),
 	OPT_BOOLEAN('T', "targets", &param.targets,
-		    "include CXL target data with decoders or ports"),
+		    "include CXL target data with decoders, ports, or regions"),
+	OPT_STRING('r', "region", &param.region_filter, "region name",
+		   "filter by CXL region name(s)"),
+	OPT_BOOLEAN('R', "regions", &param.regions, "include CXL regions"),
 	OPT_BOOLEAN('i', "idle", &param.idle, "include disabled devices"),
 	OPT_BOOLEAN('u', "human", &param.human,
 		    "use human friendly number formats"),
@@ -58,7 +61,7 @@ static const struct option options[] = {
 static int num_list_flags(void)
 {
 	return !!param.memdevs + !!param.buses + !!param.ports +
-	       !!param.endpoints + !!param.decoders;
+	       !!param.endpoints + !!param.decoders + !!param.regions;
 }
 
 int cmd_list(int argc, const char **argv, struct cxl_ctx *ctx)
@@ -92,18 +95,14 @@ int cmd_list(int argc, const char **argv, struct cxl_ctx *ctx)
 			param.endpoints = true;
 		if (param.decoder_filter)
 			param.decoders = true;
-		if (num_list_flags() == 0) {
-			/*
-			 * TODO: We likely want to list regions by default if
-			 * nothing was explicitly asked for. But until we have
-			 * region support, print this error asking for devices
-			 * explicitly.  Once region support is added, this TODO
-			 * can be removed.
-			 */
-			error("please specify entities to list, e.g. using -m/-M\n");
-			usage_with_options(u, options);
-		}
 		param.single = true;
+		if (param.region_filter)
+			param.regions = true;
+	}
+
+	/* List regions by default */
+	if (num_list_flags() == 0) {
+		param.regions = true;
 	}
 
 	log_init(&param.ctx, "cxl list", "CXL_LIST_LOG");
-- 
2.36.1

