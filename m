Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC091538A
	for <nvdimm@lists.linux.dev>; Mon, 15 Aug 2022 19:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660591342; x=1692127342;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LRIDiwWAjYsy+li9ACjyVd56pQaTOROh0GT8Bp+3jig=;
  b=icGvjDz0S0p4H+RwCn+J5GUO7OldvisHDNP1a+eJSuSri6d45CN4QpVr
   EL9gCip6QM6RAK55HOosVKlmjnrpyCfOQU7tWX1T86MQVPnPlgJ4l0oDv
   xLi7wV0kisUl9BDHNPtDLwiZNc/oMbj23zZ1J4zaFpwJc2wSP+k0eXAT2
   /QBe+bflDAKT0AeazBYcZpyR0WmhVlnVSeAzVJzcpNS0loLHpJ4QvM4Wf
   yxoA7P35T28WX+PkAD27leDX6Vz0oMaXbZtjV3UAYmOlicsMjsqdtYegd
   YHG9Jn1cFab7ANt6cqS7ScoydBhUJ9dKXqA4ZX5v9UAK+kGwpf9sh4nN0
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10440"; a="292038715"
X-IronPort-AV: E=Sophos;i="5.93,239,1654585200"; 
   d="scan'208";a="292038715"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 12:22:20 -0700
X-IronPort-AV: E=Sophos;i="5.93,239,1654585200"; 
   d="scan'208";a="606758252"
Received: from smadiset-mobl1.amr.corp.intel.com (HELO vverma7-desk1.intel.com) ([10.209.5.99])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 12:22:19 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-cxl@vger.kernel.org>
Cc: <nvdimm@lists.linux.dev>,
	Dan Williams <dan.j.williams@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v3 05/11] cxl-cli: add region listing support
Date: Mon, 15 Aug 2022 13:22:08 -0600
Message-Id: <20220815192214.545800-6-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220815192214.545800-1-vishal.l.verma@intel.com>
References: <20220815192214.545800-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=17004; h=from:subject; bh=LRIDiwWAjYsy+li9ACjyVd56pQaTOROh0GT8Bp+3jig=; b=owGbwMvMwCXGf25diOft7jLG02pJDEm/5jzNU/sQr5nTE67O4DZ/U5Zvv79rq1Llm2lq27r+hhpr fTfsKGVhEONikBVTZPm75yPjMbnt+TyBCY4wc1iZQIYwcHEKwETuTWJkmNWr++SQxCLOWQdKhdZ/UX hf4lblnqzt1WtzasYVNfUYXkaG9ZuUKuSO3WoJf529OK6/X6vhpJizm/rFLJvQiwnHozpYAA==
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Add cxl_region -> json and cxl_mapping -> json emitter helpers, and
teach cxl_filter_walk about cxl_regions. With these in place, 'cxl-list'
can now emit json objects for CXL regions. They can be top-level objects
if requested by themselves, or nested under root-decoders, if listed
along with decoders. Allow a plain 'cxl list' command to imply
'--regions'.

Cc: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Documentation/cxl/cxl-list.txt |  13 ++-
 cxl/filter.h                   |   4 +
 cxl/json.h                     |   5 ++
 cxl/filter.c                   | 158 +++++++++++++++++++++++++++++++--
 cxl/json.c                     | 114 ++++++++++++++++++++++++
 cxl/list.c                     |  25 +++---
 6 files changed, 295 insertions(+), 24 deletions(-)

diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
index f6aba0c..f952e4d 100644
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
+	Specify CXL region device name(s), or device id(s), to filter the listing.
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
index e5fab19..38ece55 100644
--- a/cxl/filter.c
+++ b/cxl/filter.c
@@ -585,6 +585,73 @@ util_cxl_memdev_filter_by_port(struct cxl_memdev *memdev, const char *bus_ident,
 	return NULL;
 }
 
+static struct cxl_region *
+util_cxl_region_filter_by_bus(struct cxl_region *region, const char *__ident)
+{
+	struct cxl_decoder *decoder = cxl_region_get_decoder(region);
+
+	if (!util_cxl_decoder_filter_by_bus(decoder, __ident))
+		return NULL;
+	return region;
+}
+
+static struct cxl_region *
+util_cxl_region_filter_by_port(struct cxl_region *region, const char *__ident)
+{
+	struct cxl_decoder *decoder = cxl_region_get_decoder(region);
+	struct cxl_port *port = cxl_decoder_get_port(decoder);
+
+	if (!util_cxl_port_filter(port, __ident ,CXL_PF_ANCESTRY))
+		return NULL;
+	return region;
+}
+
+static struct cxl_region *
+util_cxl_region_filter_by_decoder(struct cxl_region *region,
+				  const char *__ident)
+{
+	struct cxl_decoder *decoder = cxl_region_get_decoder(region);
+
+	if (!util_cxl_decoder_filter(decoder, __ident))
+		return NULL;
+	return region;
+}
+
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
@@ -672,26 +739,57 @@ static struct json_object *pick_array(struct json_object *child,
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
+		if (!util_cxl_region_filter_by_bus(region, p->bus_filter))
+			continue;
+		if (!util_cxl_region_filter_by_port(region, p->port_filter))
+			continue;
+		if (!util_cxl_region_filter_by_decoder(region, p->decoder_filter))
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
 
 		if (!p->decoders)
-			continue;
+			goto walk_children;
 		if (!util_cxl_decoder_filter(decoder, p->decoder_filter))
-			continue;
+			goto walk_children;
 		if (!util_cxl_decoder_filter_by_bus(decoder, p->bus_filter))
-			continue;
+			goto walk_children;
 		if (!util_cxl_decoder_filter_by_port(decoder, p->port_filter,
 						     pf_mode(p)))
-			continue;
+			goto walk_children;
 		if (!util_cxl_decoder_filter_by_memdev(
 			    decoder, p->memdev_filter, p->serial_filter))
-			continue;
+			goto walk_children;
 		if (!p->idle && cxl_decoder_get_size(decoder) == 0)
 			continue;
 		jdecoder = util_cxl_decoder_to_json(decoder, flags);
@@ -702,7 +800,27 @@ static void walk_decoders(struct cxl_port *port, struct cxl_filter_params *p,
 		util_cxl_targets_append_json(jdecoder, decoder,
 					     p->memdev_filter, p->serial_filter,
 					     flags);
+
+		if (p->regions) {
+			jchildregions = json_object_new_array();
+			if (!jchildregions) {
+				err(p, "failed to allocate region object\n");
+				return;
+			}
+		}
+
 		json_object_array_add(jdecoders, jdecoder);
+
+walk_children:
+		if (!p->regions)
+			continue;
+		if (!cxl_port_is_root(port))
+			continue;
+		walk_regions(decoder,
+			     pick_array(jchildregions, jregions),
+			     p, flags);
+		cond_add_put_array_suffix(jdecoder, "regions", devname,
+					  jchildregions);
 	}
 }
 
@@ -782,7 +900,7 @@ static void walk_endpoints(struct cxl_port *port, struct cxl_filter_params *p,
 		if (!p->decoders)
 			continue;
 		walk_decoders(cxl_endpoint_get_port(endpoint), p,
-			      pick_array(jchilddecoders, jdecoders), flags);
+			      pick_array(jchilddecoders, jdecoders), NULL, flags);
 		cond_add_put_array_suffix(jendpoint, "decoders", devname,
 					  jchilddecoders);
 	}
@@ -869,7 +987,8 @@ walk_children:
 				       flags);
 
 		walk_decoders(port, p,
-			      pick_array(jchilddecoders, jportdecoders), flags);
+			      pick_array(jchilddecoders, jportdecoders), NULL,
+			      flags);
 		walk_child_ports(port, p, pick_array(jchildports, jports),
 				 pick_array(jchilddecoders, jportdecoders),
 				 pick_array(jchildeps, jeps),
@@ -894,6 +1013,7 @@ int cxl_filter_walk(struct cxl_ctx *ctx, struct cxl_filter_params *p)
 	struct json_object *jbusdecoders = NULL;
 	struct json_object *jepdecoders = NULL;
 	struct json_object *janondevs = NULL;
+	struct json_object *jregions = NULL;
 	struct json_object *jeps = NULL;
 	struct cxl_memdev *memdev;
 	int top_level_objs = 0;
@@ -936,6 +1056,10 @@ int cxl_filter_walk(struct cxl_ctx *ctx, struct cxl_filter_params *p)
 	if (!jepdecoders)
 		goto err;
 
+	jregions = json_object_new_array();
+	if (!jregions)
+		goto err;
+
 	dbg(p, "walk memdevs\n");
 	cxl_memdev_foreach(ctx, memdev) {
 		struct json_object *janondev;
@@ -964,6 +1088,7 @@ int cxl_filter_walk(struct cxl_ctx *ctx, struct cxl_filter_params *p)
 		struct json_object *jchildports = NULL;
 		struct json_object *jchilddevs = NULL;
 		struct json_object *jchildeps = NULL;
+		struct json_object *jchildregions = NULL;
 		struct cxl_port *port = cxl_bus_get_port(bus);
 		const char *devname = cxl_bus_get_devname(bus);
 
@@ -1021,11 +1146,20 @@ int cxl_filter_walk(struct cxl_ctx *ctx, struct cxl_filter_params *p)
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
@@ -1038,6 +1172,8 @@ walk_children:
 					  jchildeps);
 		cond_add_put_array_suffix(jbus, "decoders", devname,
 					  jchilddecoders);
+		cond_add_put_array_suffix(jbus, "regions", devname,
+					  jchildregions);
 		cond_add_put_array_suffix(jbus, "memdevs", devname, jchilddevs);
 	}
 
@@ -1057,6 +1193,8 @@ walk_children:
 		top_level_objs++;
 	if (json_object_array_length(jepdecoders))
 		top_level_objs++;
+	if (json_object_array_length(jregions))
+		top_level_objs++;
 
 	splice_array(p, janondevs, jplatform, "anon memdevs", top_level_objs > 1);
 	splice_array(p, jbuses, jplatform, "buses", top_level_objs > 1);
@@ -1069,6 +1207,7 @@ walk_children:
 		     top_level_objs > 1);
 	splice_array(p, jepdecoders, jplatform, "endpoint decoders",
 		     top_level_objs > 1);
+	splice_array(p, jregions, jplatform, "regions", top_level_objs > 1);
 
 	util_display_json_array(stdout, jplatform, flags);
 
@@ -1082,6 +1221,7 @@ err:
 	json_object_put(jbusdecoders);
 	json_object_put(jportdecoders);
 	json_object_put(jepdecoders);
+	json_object_put(jregions);
 	json_object_put(jplatform);
 	return -ENOMEM;
 }
diff --git a/cxl/json.c b/cxl/json.c
index ae9c812..70cf286 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -524,6 +524,120 @@ struct json_object *util_cxl_decoder_to_json(struct cxl_decoder *decoder,
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
+	if (cxl_region_decode_is_committed(region))
+		jobj = json_object_new_string("commit");
+	else
+		jobj = json_object_new_string("reset");
+	if (jobj)
+		json_object_object_add(jregion, "decode_state", jobj);
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
2.37.1

