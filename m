Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD5DD500
	for <nvdimm@lists.linux.dev>; Sun,  6 Nov 2022 23:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667778470; x=1699314470;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bzZr4dL1F6gT/wTf5l6v9YpZdVcDaTSmB6t+YqArAUo=;
  b=h3uPAYYA2i1ro2l6mQznoPqZj065AkjYQsSWztd3X5LJ13O2OAA08f7F
   ktG6p5UqMyXFXp1IKD/ZOL+cpKcQS4GQuzzsgzHvzxillmve5+I+ARSnn
   5yf/hf3GAmPBk6dWh0JRD4S+85zmCp14/hd9nSTpO6Mkofd3YF7DZBZNE
   uAg5bgaiCpWgByi6U72ofE81T8TcweIQYLJcjhsthHMXDfAPAp9M1OoPL
   ImFVirNaiN67UqGnKQtz4iX4P6v0O62G8xV4LsFL+3MQdA2cBV/bB63e2
   /19zk38ldkYChOk7FIcJqvuv3Z92GKefaE4YUVbB7mOpPFK1uns+lF9aX
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="374541117"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="374541117"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2022 15:47:50 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="704674824"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="704674824"
Received: from durgasin-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.212.240.219])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2022 15:47:49 -0800
Subject: [ndctl PATCH 11/15] cxl/region: Use cxl_filter_walk() to gather
 create-region targets
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Date: Sun, 06 Nov 2022 15:47:49 -0800
Message-ID: <166777846906.1238089.13466320510516058152.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166777840496.1238089.5601286140872803173.stgit@dwillia2-xfh.jf.intel.com>
References: <166777840496.1238089.5601286140872803173.stgit@dwillia2-xfh.jf.intel.com>
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
that prepares the hierarchical json topology. The argument list becomes
as tolerant of different id formats as 'cxl list'. For example "mem9" and
"9" are equivalent.

Comma separated lists are also allowed, e.g. "mem9,mem10". However the
sorting of memdevs by filter position falls back to the 'cxl list' order in
that case. In other words:

arg order     region position
mem9 mem10 => [0]: mem9  [1]: mem10
mem10 mem9 => [0]: mem10 [1]: mem9
mem9,mem10 => [0]: mem9  [1]: mem10
mem10,mem9 => [0]: mem9  [1]: mem10

Note that 'cxl list' order groups memdevs by port, later this will need to
augmented with a sort implementation that orders memdevs by a topology
compatible decode order.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 cxl/region.c |  274 +++++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 175 insertions(+), 99 deletions(-)

diff --git a/cxl/region.c b/cxl/region.c
index c6d7d1a973a8..e47709754447 100644
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
@@ -99,16 +101,148 @@ static const struct option destroy_options[] = {
 	OPT_END(),
 };
 
-static int parse_create_options(int argc, const char **argv,
-				struct parsed_params *p)
+/*
+ * Convert an array of strings into a single comma-separated-value
+ * string that can be passed as a single 'filter' string to
+ * cxl_filter_walk()
+ */
+static const char *to_csv(int count, const char **strings)
 {
+	ssize_t len = count + 1, cursor = 0;
+	char *csv;
 	int i;
 
+	if (!count)
+		return NULL;
+
+	for (i = 0; i < count; i++)
+		len += strlen(strings[i]);
+	csv = calloc(1, len);
+	if (!csv)
+		return NULL;
+	for (i = 0; i < count; i++) {
+		cursor += snprintf(csv + cursor, len - cursor, "%s%s",
+				   strings[i], i + 1 < count ? "," : "");
+		if (cursor >= len) {
+			csv[len] = 0;
+			break;
+		}
+	}
+	return csv;
+}
+
+static struct sort_context {
+	int count;
+	const char **sort;
+} sort_context;
+
+static int memdev_filter_pos(struct json_object *jobj, int count, const char **sort)
+{
+	struct cxl_memdev *memdev = json_object_get_userdata(jobj);
+	int pos;
+
+	for (pos = 0; pos < count; pos++)
+		if (util_cxl_memdev_filter(memdev, sort[pos], NULL))
+			return pos;
+	return count;
+}
+
+static int memdev_sort(const void *a, const void *b)
+{
+	int a_pos, b_pos, count = sort_context.count;
+	const char **sort = sort_context.sort;
+	struct json_object **a_obj, **b_obj;
+
+	a_obj = (struct json_object **) a;
+	b_obj = (struct json_object **) b;
+
+	a_pos = memdev_filter_pos(*a_obj, count, sort);
+	b_pos = memdev_filter_pos(*b_obj, count, sort);
+
+	return a_pos - b_pos;
+}
+
+static struct json_object *collect_memdevs(struct cxl_ctx *ctx,
+					   const char *decoder, int count,
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
+	sort_context = (struct sort_context){
+		.count = count,
+		.sort = mems,
+	};
+	json_object_array_sort(jmemdevs, memdev_sort);
+
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
+	p->memdevs = collect_memdevs(ctx, param.root_decoder, count, mems);
+	if (!p->memdevs)
+		return -ENXIO;
+	p->num_memdevs = json_object_array_length(p->memdevs);
+
 	if (param.type) {
 		p->mode = cxl_decoder_mode_from_ident(param.type);
 		if (p->mode == CXL_DECODER_MODE_NONE) {
@@ -132,8 +266,12 @@ static int parse_create_options(int argc, const char **argv,
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
@@ -149,19 +287,6 @@ static int parse_create_options(int argc, const char **argv,
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
@@ -171,17 +296,6 @@ static int parse_create_options(int argc, const char **argv,
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
 
@@ -196,8 +310,8 @@ static int parse_region_options(int argc, const char **argv,
 	};
 
 	argc = parse_options(argc, argv, options, u, 0);
-	p->targets = argv;
-	p->num_targets = argc;
+	p->argc = argc;
+	p->argv = argv;
 
 	if (param.debug) {
 		cxl_set_log_priority(ctx, LOG_DEBUG);
@@ -207,62 +321,27 @@ static int parse_region_options(int argc, const char **argv,
 
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
+static void collect_minsize(struct cxl_ctx *ctx, struct parsed_params *p)
 {
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
-{
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
+		if (!p->ep_min_size)
+			p->ep_min_size = size;
+		else
+			p->ep_min_size = min(p->ep_min_size, size);
 	}
-	if (matched != p->ways) {
-		log_err(&rl,
-			"one or more memdevs not found in CXL topology\n");
-		return -ENXIO;
-	}
-
-	return 0;
 }
 
 static int validate_decoder(struct cxl_decoder *decoder,
@@ -330,26 +409,18 @@ found:
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
@@ -488,9 +559,12 @@ static int create_region(struct cxl_ctx *ctx, int *count,
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
 			goto err_delete;
@@ -508,7 +582,7 @@ static int create_region(struct cxl_ctx *ctx, int *count,
 		rc = cxl_region_set_target(region, i, ep_decoder);
 		if (rc) {
 			log_err(&rl, "%s: failed to set target%d to %s\n",
-				devname, i, p->targets[i]);
+				devname, i, cxl_memdev_get_devname(memdev));
 			goto err_delete;
 		}
 	}
@@ -630,8 +704,8 @@ static int decoder_region_action(struct parsed_params *p,
 	cxl_region_foreach_safe (decoder, region, _r) {
 		int i, match = 0;
 
-		for (i = 0; i < p->num_targets; i++) {
-			if (util_cxl_region_filter(region, p->targets[i])) {
+		for (i = 0; i < p->argc; i++) {
+			if (util_cxl_region_filter(region, p->argv[i])) {
 				match = 1;
 				break;
 			}
@@ -664,8 +738,10 @@ static int region_action(int argc, const char **argv, struct cxl_ctx *ctx,
 	if (rc)
 		return rc;
 
-	if (action == ACTION_CREATE)
-		return create_region(ctx, count, p);
+	if (action == ACTION_CREATE) {
+		rc = create_region(ctx, count, p);
+		json_object_put(p->memdevs);
+	}
 
 	cxl_bus_foreach(ctx, bus) {
 		struct cxl_decoder *decoder;

