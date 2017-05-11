Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3B37921A16E28
 for <linux-nvdimm@lists.01.org>; Thu, 11 May 2017 15:07:27 -0700 (PDT)
Subject: [ndctl PATCH 2/4] ndctl,
 list: clarify dev_badblocks_to_json() usage with btt and documentation
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 11 May 2017 15:01:35 -0700
Message-ID: <149454009571.30857.13396023187046049358.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149454009049.30857.6643219237076670086.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149454009049.30857.6643219237076670086.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Rather than pass include_media_errors through to dev_badblocks_to_json()
in the btt case only to throw it away, just tell dev_badblocks_to_json()
not to bother. The commentary about why we do not support badblocks
listing is moved internal to the util_btt_badblocks_to_json() helper.

This also takes the opportunity to s/jobj2/jbbs/ for readability, and
s/include_media_err/include_media_errors/ for consistency.

Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Toshi Kani <toshi.kani@hpe.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/ndctl-list.txt |   12 +++++++--
 ndctl/list.c                 |   12 ++++-----
 util/json.c                  |   57 ++++++++++++++++++++----------------------
 3 files changed, 42 insertions(+), 39 deletions(-)

diff --git a/Documentation/ndctl-list.txt b/Documentation/ndctl-list.txt
index 0ac08a8024c0..da90860e061f 100644
--- a/Documentation/ndctl-list.txt
+++ b/Documentation/ndctl-list.txt
@@ -148,9 +148,15 @@ include::xable-region-options.txt[]
 
 -M::
 --media-errors::
-	Include media errors (badblocks) in the listing. badblocks_count
-	may count blocks that are not in the data space of the namespace
-	for sector mode.
+	Include media errors (badblocks) in the listing. Note that the
+	'badblock_count' property is included in the listing by default
+	when the count is non-zero, otherwise it is hidden. Also, if the
+	namespace is in 'sector' mode the 'badblocks' listing is not
+	included and 'badblock_count' property may include blocks that are
+	located in metadata, or unused capacity in the namespace. Convert
+	a 'sector' namespace into 'raw' mode to list precise 'badblocks'
+	offsets.
+
 [verse]
 {
   "dev":"namespace7.0",
diff --git a/ndctl/list.c b/ndctl/list.c
index 8d912e654476..cf26d8c08183 100644
--- a/ndctl/list.c
+++ b/ndctl/list.c
@@ -120,10 +120,10 @@ static struct json_object *list_namespaces(struct ndctl_region *region,
 }
 
 static struct json_object *region_to_json(struct ndctl_region *region,
-		bool include_media_err)
+		bool include_media_errors)
 {
 	struct json_object *jregion = json_object_new_object();
-	struct json_object *jobj, *jobj2, *jmappings = NULL;
+	struct json_object *jobj, *jbbs, *jmappings = NULL;
 	struct ndctl_interleave_set *iset;
 	struct ndctl_mapping *mapping;
 	unsigned int bb_count;
@@ -207,16 +207,16 @@ static struct json_object *region_to_json(struct ndctl_region *region,
 		json_object_object_add(jregion, "state", jobj);
 	}
 
-	jobj2 = util_region_badblocks_to_json(region, include_media_err,
+	jbbs = util_region_badblocks_to_json(region, include_media_errors,
 			&bb_count);
 	jobj = json_object_new_int(bb_count);
 	if (!jobj) {
-		json_object_put(jobj2);
+		json_object_put(jbbs);
 		goto err;
 	}
 	json_object_object_add(jregion, "badblock_count", jobj);
-	if (include_media_err && jobj2)
-		json_object_object_add(jregion, "badblocks", jobj2);
+	if (include_media_errors && jbbs)
+		json_object_object_add(jregion, "badblocks", jbbs);
 
 	list_namespaces(region, jregion, NULL, false);
 	return jregion;
diff --git a/util/json.c b/util/json.c
index b2c84181cadb..f72ffca910ae 100644
--- a/util/json.c
+++ b/util/json.c
@@ -374,8 +374,8 @@ static struct json_object *util_pfn_badblocks_to_json(struct ndctl_pfn *pfn,
 			include_media_errors, bb_count);
 }
 
-static struct json_object *util_btt_badblocks_to_json(struct ndctl_btt *btt,
-		bool include_media_errors, unsigned int *bb_count)
+static void util_btt_badblocks_to_json(struct ndctl_btt *btt,
+		unsigned int *bb_count)
 {
 	struct ndctl_region *region = ndctl_btt_get_region(btt);
 	struct ndctl_namespace *ndns = ndctl_btt_get_namespace(btt);
@@ -383,14 +383,22 @@ static struct json_object *util_btt_badblocks_to_json(struct ndctl_btt *btt,
 
 	btt_begin = ndctl_namespace_get_resource(ndns);
 	if (btt_begin == ULLONG_MAX)
-		return NULL;
+		return;
 
 	btt_size = ndctl_btt_get_size(btt);
 	if (btt_size == ULLONG_MAX)
-		return NULL;
-
-	return dev_badblocks_to_json(region, btt_begin, btt_size,
-			include_media_errors, bb_count);
+		return;
+
+	/*
+	 * The dev_badblocks_to_json() for BTT is not accurate with
+	 * respect to data vs metadata badblocks, and is only useful for
+	 * a potential bb_count.
+	 *
+	 * FIXME: switch to native BTT badblocks representation
+	 * when / if the kernel provides it.
+	 */
+	dev_badblocks_to_json(region, btt_begin, btt_size,
+			false, bb_count);
 }
 
 static struct json_object *util_dax_badblocks_to_json(struct ndctl_dax *dax,
@@ -416,16 +424,16 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 		bool include_media_errors)
 {
 	struct json_object *jndns = json_object_new_object();
+	struct json_object *jobj, *jbbs = NULL;
 	unsigned long long size = ULLONG_MAX;
 	enum ndctl_namespace_mode mode;
-	struct json_object *jobj, *jobj2;
 	const char *bdev = NULL;
+	unsigned int bb_count;
 	struct ndctl_btt *btt;
 	struct ndctl_pfn *pfn;
 	struct ndctl_dax *dax;
 	char buf[40];
 	uuid_t uuid;
-	unsigned int bb_count;
 
 	if (!jndns)
 		return NULL;
@@ -549,38 +557,27 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 	}
 
 	if (pfn)
-		jobj2 = util_pfn_badblocks_to_json(pfn, include_media_errors,
+		jbbs = util_pfn_badblocks_to_json(pfn, include_media_errors,
 				&bb_count);
 	else if (dax)
-		jobj2 = util_dax_badblocks_to_json(dax, include_media_errors,
+		jbbs = util_dax_badblocks_to_json(dax, include_media_errors,
 				&bb_count);
-	else if (btt) {
-		jobj2 = util_btt_badblocks_to_json(btt, include_media_errors,
-				&bb_count);
-		/*
-		 * Discard the jobj2, the badblocks for BTT is not,
-		 * accurate and there will be a good method to caculate
-		 * them later. We just want a bb count and not the specifics
-		 * for now.
-		 */
-		jobj2 = NULL;
-	} else {
-		struct ndctl_region *region =
-			ndctl_namespace_get_region(ndns);
-
-		jobj2 = util_region_badblocks_to_json(region,
+	else if (btt)
+		util_btt_badblocks_to_json(btt, &bb_count);
+	else
+		jbbs = util_region_badblocks_to_json(
+				ndctl_namespace_get_region(ndns),
 				include_media_errors, &bb_count);
-	}
 
 	jobj = json_object_new_int(bb_count);
 	if (!jobj) {
-		json_object_put(jobj2);
+		json_object_put(jbbs);
 		goto err;
 	}
 
 	json_object_object_add(jndns, "badblock_count", jobj);
-	if (include_media_errors && jobj2)
-			json_object_object_add(jndns, "badblocks", jobj2);
+	if (include_media_errors && jbbs)
+			json_object_object_add(jndns, "badblocks", jbbs);
 
 	return jndns;
  err:

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
