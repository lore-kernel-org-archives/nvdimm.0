Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72199A460
	for <nvdimm@lists.linux.dev>; Thu,  8 Dec 2022 21:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670534956; x=1702070956;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VgxML5jp/JNmm/O7hN2KsFk45+SRMFHpMtCwachHHWU=;
  b=fC4hceSvMWGY31JVr68FXrWzEXq9zmpYS4W4yY7WtLWm6i3Auxg1CA9s
   RDIYdDHlrcxxqkJzFFbEr443uXshohK/Kz9WoAmYKZsUu2Pq6R0nw2sFm
   mPBKFaWH1a53ClslFtbfxK6l05mGLgnYOYBOtac5X59Gzols7dvuVCQIM
   lZWI7DQc71ckgbV5DpyyWdQWCoefYJT3jOjEAPO2WK1NviGRwUBkmjnlt
   o5h7j+G4cLv+r/ngu3DxbSjO5Tk67xulsydWNWoMJO9LnrBM76pGCIDak
   Hi1RYVFQD2ce+F9v2aFlqASlSwgJiKAleTuerII0iWFZTtWoSX9zjV0gb
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="304950757"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="304950757"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 13:29:16 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="649323120"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="649323120"
Received: from kputnam-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.251.25.149])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 13:29:15 -0800
Subject: [ndctl PATCH v2 13/18] cxl/region: Use cxl_filter_walk() to gather
 create-region targets
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: vishal.l.verma@intel.com, alison.schofield@intel.com,
 nvdimm@lists.linux.dev, vishal.l.verma@intel.com
Date: Thu, 08 Dec 2022 13:29:14 -0800
Message-ID: <167053495444.582963.8894875924785665365.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <167053487710.582963.17616889985000817682.stgit@dwillia2-xfh.jf.intel.com>
References: <167053487710.582963.17616889985000817682.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

The core of 'cxl list' knows, among other things, how to filter memdevs by
their connectivity to a root decoder, enabled status, and how to identify
memdevs by name, id, serial number. Use the fact that the json-c object
array returned by cxl_filter_walk() also includes the corresponding libcxl
objects to populate and validate the memdev target list for 'cxl
create-region'.

With this in place a default set of memdev targets can be derived from the
specified root decoder, and the connectivity is validated by the same logic
that prepares the hierarchical json topology. The argument list becomes as
tolerant of different id formats as 'cxl list'. For example "mem9" and "9"
are equivalent. Comma and space separated lists are also allowed, e.g.
"mem9,mem10".

Note that 'cxl list' order groups memdevs by port, later this will need to
augmented with a sort implementation that orders memdevs by a topology
compatible decode order.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 cxl/region.c |  334 +++++++++++++++++++++++++++++++++++++++-------------------
 util/util.h  |    9 ++
 2 files changed, 234 insertions(+), 109 deletions(-)

diff --git a/cxl/region.c b/cxl/region.c
index c6d7d1a973a8..36ebc8e5210f 100644
--- a/cxl/region.c
+++ b/cxl/region.c
@@ -40,8 +40,10 @@ struct parsed_params {
 	u64 ep_min_size;
 	int ways;
 	int granularity;
-	const char **targets;
-	int num_targets;
+	struct json_object *memdevs;
+	int num_memdevs;
+	int argc;
+	const char **argv;
 	struct cxl_decoder *root_decoder;
 	enum cxl_decoder_mode mode;
 };
@@ -99,16 +101,190 @@ static const struct option destroy_options[] = {
 	OPT_END(),
 };
 
-static int parse_create_options(int argc, const char **argv,
-				struct parsed_params *p)
+/*
+ * Convert an array of strings that can be a mixture of single items, a
+ * command separted list, or a space separated list, into a flattened
+ * comma-separated string. That single string can then be used as a
+ * filter argument to cxl_filter_walk(), or an ordering constraint for
+ * json_object_array_sort()
+ *
+ * On entry @count is the number of elements in the strings array, on
+ * exit, @count is the number of elements in the csv.
+ */
+static const char *to_csv(int *count, const char **strings)
 {
-	int i;
+	ssize_t len = 0, cursor = 0;
+	char *csv, *list, *save;
+	int i, new_count = 0;
+	const char *arg;
+
+	if (!*count)
+		return NULL;
+
+	for (i = 0; i < *count; i++) {
+		/*
+		 * An entry in strings may itself by a space or comma
+		 * separated list, so decompose that for the final csv
+		 */
+		list = strdup(strings[i]);
+		if (!list)
+			return NULL;
+
+		for (arg = strtok_r(list, which_sep(list), &save); arg;
+		     arg = strtok_r(NULL, which_sep(list), &save)) {
+			len += strlen(arg);
+			new_count++;
+		}
+
+		free(list);
+
+	}
+
+	len += new_count + 1;
+	csv = calloc(1, len);
+	if (!csv)
+		return NULL;
+	for (i = 0; i < *count; i++) {
+		list = strdup(strings[i]);
+		if (!list)
+			return NULL;
+
+		for (arg = strtok_r(list, which_sep(list), &save); arg;
+		     arg = strtok_r(NULL, which_sep(list), &save)) {
+			cursor += snprintf(csv + cursor, len - cursor, "%s%s",
+					   arg, i + 1 < new_count ? "," : "");
+			if (cursor >= len) {
+				csv[len] = 0;
+				break;
+			}
+		}
 
+		free(list);
+	}
+	*count = new_count;
+	return csv;
+}
+
+static struct sort_context {
+	const char *csv;
+} sort_context;
+
+static int memdev_filter_pos(struct json_object *jobj, const char *_csv)
+{
+	struct cxl_memdev *memdev = json_object_get_userdata(jobj);
+	char *csv, *save;
+	const char *arg;
+	int pos;
+
+	csv = strdup(_csv);
+	if (!csv)
+		return -1;
+
+	for (pos = 0, arg = strtok_r(csv, which_sep(csv), &save); arg;
+	     arg = strtok_r(NULL, which_sep(csv), &save), pos++)
+		if (util_cxl_memdev_filter(memdev, arg, NULL))
+			return pos;
+	free(csv);
+
+	return pos;
+}
+
+static int memdev_sort(const void *a, const void *b)
+{
+	struct json_object **a_obj, **b_obj;
+	int a_pos, b_pos;
+
+	a_obj = (struct json_object **) a;
+	b_obj = (struct json_object **) b;
+
+	a_pos = memdev_filter_pos(*a_obj, sort_context.csv);
+	b_pos = memdev_filter_pos(*b_obj, sort_context.csv);
+
+	if (a_pos < 0 || b_pos < 0)
+		return 0;
+
+	return a_pos - b_pos;
+}
+
+static struct json_object *collect_memdevs(struct cxl_ctx *ctx,
+					   const char *decoder, int *count,
+					   const char **mems)
+{
+	const char *csv = to_csv(count, mems);
+	struct cxl_filter_params filter_params = {
+		.decoder_filter = decoder,
+		.memdevs = true,
+		.memdev_filter = csv,
+	};
+	struct json_object *jmemdevs;
+
+	jmemdevs = cxl_filter_walk(ctx, &filter_params);
+
+	if (!jmemdevs) {
+		log_err(&rl, "failed to retrieve memdevs\n");
+		goto out;
+	}
+
+	if (json_object_array_length(jmemdevs) == 0) {
+		log_err(&rl,
+			"no active memdevs found: decoder: %s filter: %s\n",
+			decoder, csv ? csv : "none");
+		json_object_put(jmemdevs);
+		jmemdevs = NULL;
+		goto out;
+	}
+
+	if (csv) {
+		sort_context.csv = csv,
+		json_object_array_sort(jmemdevs, memdev_sort);
+	}
+out:
+	free((void *)csv);
+	return jmemdevs;
+}
+
+static bool validate_ways(struct parsed_params *p, int count)
+{
+	/*
+	 * Validate interleave ways against targets found in the topology. If
+	 * the targets were specified, then non-default param.ways must equal
+	 * that number of targets.
+	 */
+	if (p->ways > p->num_memdevs || (count && p->ways != p->num_memdevs)) {
+		log_err(&rl,
+			"Interleave ways %d is %s than number of memdevs %s: %d\n",
+			p->ways, p->ways > p->num_memdevs ? "greater" : "less",
+			count ? "specified" : "found", p->num_memdevs);
+		return false;
+	}
+	return true;
+}
+
+static int parse_create_options(struct cxl_ctx *ctx, int count,
+				const char **mems, struct parsed_params *p)
+{
 	if (!param.root_decoder) {
 		log_err(&rl, "no root decoder specified\n");
 		return -EINVAL;
 	}
 
+	/*
+	 * For all practical purposes, -m is the default target type, but
+	 * hold off on actively making that decision until a second target
+	 * option is available.
+	 */
+	if (!param.memdevs) {
+		log_err(&rl,
+			"must specify option for target object types (-m)\n");
+		return -EINVAL;
+	}
+
+	/* Collect the valid memdevs relative to the given root decoder */
+	p->memdevs = collect_memdevs(ctx, param.root_decoder, &count, mems);
+	if (!p->memdevs)
+		return -ENXIO;
+	p->num_memdevs = json_object_array_length(p->memdevs);
+
 	if (param.type) {
 		p->mode = cxl_decoder_mode_from_ident(param.type);
 		if (p->mode == CXL_DECODER_MODE_NONE) {
@@ -132,8 +308,12 @@ static int parse_create_options(int argc, const char **argv,
 		return -EINVAL;
 	} else if (param.ways < INT_MAX) {
 		p->ways = param.ways;
-	} else if (argc) {
-		p->ways = argc;
+		if (!validate_ways(p, count))
+			return -EINVAL;
+	} else if (count) {
+		p->ways = count;
+		if (!validate_ways(p, count))
+			return -EINVAL;
 	} else {
 		log_err(&rl,
 			"couldn't determine interleave ways from options or arguments\n");
@@ -149,19 +329,6 @@ static int parse_create_options(int argc, const char **argv,
 		p->granularity = param.granularity;
 	}
 
-	if (argc > p->ways) {
-		for (i = p->ways; i < argc; i++)
-			log_err(&rl, "extra argument: %s\n", p->targets[i]);
-		return -EINVAL;
-	}
-
-	if (argc < p->ways) {
-		log_err(&rl,
-			"too few target arguments (%d) for interleave ways (%u)\n",
-			argc, p->ways);
-		return -EINVAL;
-	}
-
 	if (p->size && p->ways) {
 		if (p->size % p->ways) {
 			log_err(&rl,
@@ -171,17 +338,6 @@ static int parse_create_options(int argc, const char **argv,
 		}
 	}
 
-	/*
-	 * For all practical purposes, -m is the default target type, but
-	 * hold off on actively making that decision until a second target
-	 * option is available.
-	 */
-	if (!param.memdevs) {
-		log_err(&rl,
-			"must specify option for target object types (-m)\n");
-		return -EINVAL;
-	}
-
 	return 0;
 }
 
@@ -196,8 +352,8 @@ static int parse_region_options(int argc, const char **argv,
 	};
 
 	argc = parse_options(argc, argv, options, u, 0);
-	p->targets = argv;
-	p->num_targets = argc;
+	p->argc = argc;
+	p->argv = argv;
 
 	if (param.debug) {
 		cxl_set_log_priority(ctx, LOG_DEBUG);
@@ -207,62 +363,27 @@ static int parse_region_options(int argc, const char **argv,
 
 	switch(action) {
 	case ACTION_CREATE:
-		return parse_create_options(argc, argv, p);
+		return parse_create_options(ctx, argc, argv, p);
 	default:
 		return 0;
 	}
 }
 
-/**
- * validate_memdev() - match memdev with the target provided,
- *                     and determine its size contribution
- * @memdev: cxl_memdev being tested for a match against the named target
- * @target: target memdev
- * @p:      params structure
- *
- * This is called for each memdev in the system, and only returns 'true' if
- * the memdev name matches the target argument being tested. Additionally,
- * it sets an ep_min_size attribute that always contains the size of the
- * smallest target in the provided list. This is used during the automatic
- * size determination later, to ensure that all targets contribute equally
- * to the region in case of unevenly sized memdevs.
- */
-static bool validate_memdev(struct cxl_memdev *memdev, const char *target,
-			    struct parsed_params *p)
-{
-	const char *devname = cxl_memdev_get_devname(memdev);
-	u64 size;
-
-	if (strcmp(devname, target) != 0)
-		return false;
-
-	size = cxl_memdev_get_pmem_size(memdev);
-	if (!p->ep_min_size)
-		p->ep_min_size = size;
-	else
-		p->ep_min_size = min(p->ep_min_size, size);
-
-	return true;
-}
-
-static int validate_config_memdevs(struct cxl_ctx *ctx, struct parsed_params *p)
+static void collect_minsize(struct cxl_ctx *ctx, struct parsed_params *p)
 {
-	int i, matched = 0;
+	int i;
 
 	for (i = 0; i < p->ways; i++) {
-		struct cxl_memdev *memdev;
+		struct json_object *jobj =
+			json_object_array_get_idx(p->memdevs, i);
+		struct cxl_memdev *memdev = json_object_get_userdata(jobj);
+		u64 size = cxl_memdev_get_pmem_size(memdev);
 
-		cxl_memdev_foreach(ctx, memdev)
-			if (validate_memdev(memdev, p->targets[i], p))
-				matched++;
-	}
-	if (matched != p->ways) {
-		log_err(&rl,
-			"one or more memdevs not found in CXL topology\n");
-		return -ENXIO;
+		if (!p->ep_min_size)
+			p->ep_min_size = size;
+		else
+			p->ep_min_size = min(p->ep_min_size, size);
 	}
-
-	return 0;
 }
 
 static int validate_decoder(struct cxl_decoder *decoder,
@@ -330,26 +451,18 @@ found:
 	if (rc)
 		return rc;
 
-	return validate_config_memdevs(ctx, p);
+	collect_minsize(ctx, p);
+	return 0;
 }
 
-static struct cxl_decoder *
-cxl_memdev_target_find_decoder(struct cxl_ctx *ctx, const char *memdev_name)
+static struct cxl_decoder *cxl_memdev_find_decoder(struct cxl_memdev *memdev)
 {
-	struct cxl_endpoint *ep = NULL;
+	const char *memdev_name = cxl_memdev_get_devname(memdev);
 	struct cxl_decoder *decoder;
-	struct cxl_memdev *memdev;
+	struct cxl_endpoint *ep;
 	struct cxl_port *port;
 
-	cxl_memdev_foreach(ctx, memdev) {
-		const char *devname = cxl_memdev_get_devname(memdev);
-
-		if (strcmp(devname, memdev_name) != 0)
-			continue;
-
-		ep = cxl_memdev_get_endpoint(memdev);
-	}
-
+	ep = cxl_memdev_get_endpoint(memdev);
 	if (!ep) {
 		log_err(&rl, "could not get an endpoint for %s\n",
 			memdev_name);
@@ -379,7 +492,7 @@ do { \
 				prefix##_get_devname(dev), \
 				strerror(abs(__rc))); \
 		rc = __rc; \
-		goto err_delete; \
+		goto out; \
 	} \
 } while (0)
 
@@ -478,7 +591,7 @@ static int create_region(struct cxl_ctx *ctx, int *count,
 
 	rc = cxl_region_determine_granularity(region, p);
 	if (rc < 0)
-		goto err_delete;
+		goto out;
 	granularity = rc;
 
 	uuid_generate(uuid);
@@ -488,12 +601,15 @@ static int create_region(struct cxl_ctx *ctx, int *count,
 	try(cxl_region, set_size, region, size);
 
 	for (i = 0; i < p->ways; i++) {
-		struct cxl_decoder *ep_decoder = NULL;
+		struct cxl_decoder *ep_decoder;
+		struct json_object *jobj =
+			json_object_array_get_idx(p->memdevs, i);
+		struct cxl_memdev *memdev = json_object_get_userdata(jobj);
 
-		ep_decoder = cxl_memdev_target_find_decoder(ctx, p->targets[i]);
+		ep_decoder = cxl_memdev_find_decoder(memdev);
 		if (!ep_decoder) {
 			rc = -ENXIO;
-			goto err_delete;
+			goto out;
 		}
 		if (cxl_decoder_get_mode(ep_decoder) != p->mode) {
 			/*
@@ -508,8 +624,8 @@ static int create_region(struct cxl_ctx *ctx, int *count,
 		rc = cxl_region_set_target(region, i, ep_decoder);
 		if (rc) {
 			log_err(&rl, "%s: failed to set target%d to %s\n",
-				devname, i, p->targets[i]);
-			goto err_delete;
+				devname, i, cxl_memdev_get_devname(memdev));
+			goto out;
 		}
 	}
 
@@ -517,14 +633,14 @@ static int create_region(struct cxl_ctx *ctx, int *count,
 	if (rc) {
 		log_err(&rl, "%s: failed to commit decode: %s\n", devname,
 			strerror(-rc));
-		goto err_delete;
+		goto out;
 	}
 
 	rc = cxl_region_enable(region);
 	if (rc) {
 		log_err(&rl, "%s: failed to enable: %s\n", devname,
 			strerror(-rc));
-		goto err_delete;
+		goto out;
 	}
 	*count = 1;
 
@@ -535,10 +651,10 @@ static int create_region(struct cxl_ctx *ctx, int *count,
 		printf("%s\n", json_object_to_json_string_ext(jregion,
 					JSON_C_TO_STRING_PRETTY));
 
-	return 0;
-
-err_delete:
-	cxl_region_delete(region);
+out:
+	json_object_put(p->memdevs);
+	if (rc)
+		cxl_region_delete(region);
 	return rc;
 }
 
@@ -630,8 +746,8 @@ static int decoder_region_action(struct parsed_params *p,
 	cxl_region_foreach_safe (decoder, region, _r) {
 		int i, match = 0;
 
-		for (i = 0; i < p->num_targets; i++) {
-			if (util_cxl_region_filter(region, p->targets[i])) {
+		for (i = 0; i < p->argc; i++) {
+			if (util_cxl_region_filter(region, p->argv[i])) {
 				match = 1;
 				break;
 			}
@@ -665,7 +781,7 @@ static int region_action(int argc, const char **argv, struct cxl_ctx *ctx,
 		return rc;
 
 	if (action == ACTION_CREATE)
-		return create_region(ctx, count, p);
+		rc = create_region(ctx, count, p);
 
 	cxl_bus_foreach(ctx, bus) {
 		struct cxl_decoder *decoder;
diff --git a/util/util.h b/util/util.h
index b2b4ae6503aa..58db06530c37 100644
--- a/util/util.h
+++ b/util/util.h
@@ -79,6 +79,15 @@ static inline const char *skip_prefix(const char *str, const char *prefix)
         return strncmp(str, prefix, len) ? NULL : str + len;
 }
 
+static inline const char *which_sep(const char *filter)
+{
+	if (strchr(filter, ' '))
+		return " ";
+	if (strchr(filter, ','))
+		return ",";
+	return " ";
+}
+
 static inline int is_absolute_path(const char *path)
 {
 	return path[0] == '/';

