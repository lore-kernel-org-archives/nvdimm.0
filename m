Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2AFAD211F8886
 for <linux-nvdimm@lists.01.org>; Fri, 29 Jun 2018 16:39:55 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [ndctl PATCH 3/3] ndctl list: always output array without --human
Date: Fri, 29 Jun 2018 17:39:27 -0600
Message-Id: <20180629233927.6232-3-ross.zwisler@linux.intel.com>
In-Reply-To: <20180629233927.6232-1-ross.zwisler@linux.intel.com>
References: <20180629233927.6232-1-ross.zwisler@linux.intel.com>
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
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, "Kani, Toshi" <toshi.kani@hpe.com>, Vishal Verma <vishal.l.verma@intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

If "ndctl list" is only printing a single object it currently does not
print it in an array.  When printing multiple objects, though, an array is
used.  This simplifies the output for single objects when a human is
looking at it but it creates complications for parsers like jq.  jq
wants to know whether it is trying to parse an object or an array of
objects.

For example, here's how you print just the mode of a single namespace:

 # ndctl list -n namespace1.0 | jq ".mode"
 "raw"

This works on a single object.  If you have multiple objects in a JSON
array you do this:

  # ndctl list | jq -r '(.[]) | .mode'
  raw
  raw

If you want to write a generic script that works in both cases you have to
do something quite complicated like:

  # ndctl list | jq -r '((. | arrays | .[]), . | objects | .mode)'
  raw
  raw

Instead of pushing the burden on the user, have ndctl output consistently be
an array even if there is only one element.  This allows the parsing code
to be simpler and only worry about one case.

If the user specifies the --human or -u flags we will assume that a person
is looking at the output and not a script and will continue to output a
single element which is not part of an array.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 daxctl/list.c        | 11 +++++++----
 ndctl/bus.c          |  2 +-
 ndctl/dimm.c         |  2 +-
 ndctl/inject-smart.c |  2 +-
 ndctl/list.c         |  8 ++++----
 util/json.c          |  5 +++--
 util/json.h          |  3 ++-
 7 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/daxctl/list.c b/daxctl/list.c
index ed9e76c..58c35fa 100644
--- a/daxctl/list.c
+++ b/daxctl/list.c
@@ -83,6 +83,7 @@ int cmd_list(int argc, const char **argv, void *ctx)
 	struct json_object *jregions = NULL;
 	struct json_object *jdevs = NULL;
 	struct daxctl_region *region;
+	unsigned long list_flags;
 	int i;
 
         argc = parse_options(argc, argv, options, u, 0);
@@ -100,6 +101,8 @@ int cmd_list(int argc, const char **argv, void *ctx)
 	if (num_list_flags() == 0)
 		list.devs = true;
 
+	list_flags = listopts_to_flags();
+
 	daxctl_region_foreach(ctx, region) {
 		struct json_object *jregion = NULL;
 
@@ -117,7 +120,7 @@ int cmd_list(int argc, const char **argv, void *ctx)
 			}
 
 			jregion = util_daxctl_region_to_json(region,
-					param.dev, listopts_to_flags());
+					param.dev, list_flags);
 			if (!jregion) {
 				fail("\n");
 				continue;
@@ -125,13 +128,13 @@ int cmd_list(int argc, const char **argv, void *ctx)
 			json_object_array_add(jregions, jregion);
 		} else if (list.devs)
 			jdevs = util_daxctl_devs_to_list(region, jdevs,
-					param.dev, listopts_to_flags());
+					param.dev, list_flags);
 	}
 
 	if (jregions)
-		util_display_json_array(stdout, jregions);
+		util_display_json_array(stdout, jregions, list_flags);
 	else if (jdevs)
-		util_display_json_array(stdout, jdevs);
+		util_display_json_array(stdout, jdevs, list_flags);
 
 	if (did_fail)
 		return -ENOMEM;
diff --git a/ndctl/bus.c b/ndctl/bus.c
index b7b7d65..bcb8c71 100644
--- a/ndctl/bus.c
+++ b/ndctl/bus.c
@@ -88,7 +88,7 @@ static int bus_action(int argc, const char **argv, const char *usage,
 	}
 
 	if (success)
-		util_display_json_array(stdout, jbuses);
+		util_display_json_array(stdout, jbuses, 0);
 	else
 		json_object_put(jbuses);
 
diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index 6964c5e..97643a3 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -1081,7 +1081,7 @@ static int dimm_action(int argc, const char **argv, void *ctx,
 	}
 
 	if (actx.jdimms)
-		util_display_json_array(actx.f_out, actx.jdimms);
+		util_display_json_array(actx.f_out, actx.jdimms, 0);
 
 	if (actx.f_out != stdout)
 		fclose(actx.f_out);
diff --git a/ndctl/inject-smart.c b/ndctl/inject-smart.c
index 2e62c89..8da893c 100644
--- a/ndctl/inject-smart.c
+++ b/ndctl/inject-smart.c
@@ -375,7 +375,7 @@ static int dimm_inject_smart(struct ndctl_dimm *dimm)
 		jhealth = util_dimm_health_to_json(dimm);
 		if (jhealth) {
 			json_object_object_add(jdimm, "health", jhealth);
-			util_display_json_array(stdout, jdimms);
+			util_display_json_array(stdout, jdimms, sctx.flags);
 		}
 	}
 out:
diff --git a/ndctl/list.c b/ndctl/list.c
index 32f679b..5d173d7 100644
--- a/ndctl/list.c
+++ b/ndctl/list.c
@@ -366,7 +366,7 @@ static int list_display(struct list_filter_arg *lfa)
 	struct json_object *jbuses = lfa->jbuses;
 
 	if (jbuses)
-		util_display_json_array(stdout, jbuses);
+		util_display_json_array(stdout, jbuses, list_flags);
 	else if ((!!jdimms + !!jregions + !!jnamespaces) > 1) {
 		struct json_object *jplatform = json_object_new_object();
 
@@ -386,11 +386,11 @@ static int list_display(struct list_filter_arg *lfa)
 					JSON_C_TO_STRING_PRETTY));
 		json_object_put(jplatform);
 	} else if (jdimms)
-		util_display_json_array(stdout, jdimms);
+		util_display_json_array(stdout, jdimms, list_flags);
 	else if (jregions)
-		util_display_json_array(stdout, jregions);
+		util_display_json_array(stdout, jregions, list_flags);
 	else if (jnamespaces)
-		util_display_json_array(stdout, jnamespaces);
+		util_display_json_array(stdout, jnamespaces, list_flags);
 	return 0;
 }
 
diff --git a/util/json.c b/util/json.c
index ff894c7..1332458 100644
--- a/util/json.c
+++ b/util/json.c
@@ -105,12 +105,13 @@ struct json_object *util_json_object_hex(unsigned long long val,
 	return jobj;
 }
 
-void util_display_json_array(FILE *f_out, struct json_object *jarray)
+void util_display_json_array(FILE *f_out, struct json_object *jarray,
+		unsigned long flags)
 {
 	int len = json_object_array_length(jarray);
 	int jflag = JSON_C_TO_STRING_PRETTY;
 
-	if (json_object_array_length(jarray) > 1)
+	if (json_object_array_length(jarray) > 1 || !(flags & UTIL_JSON_HUMAN))
 		fprintf(f_out, "%s\n", json_object_to_json_string_ext(jarray, jflag));
 	else if (len) {
 		struct json_object *jobj;
diff --git a/util/json.h b/util/json.h
index d0167cf..aa2e976 100644
--- a/util/json.h
+++ b/util/json.h
@@ -26,7 +26,8 @@ enum util_json_flags {
 };
 
 struct json_object;
-void util_display_json_array(FILE *f_out, struct json_object *jarray);
+void util_display_json_array(FILE *f_out, struct json_object *jarray,
+		unsigned long flags);
 struct json_object *util_bus_to_json(struct ndctl_bus *bus);
 struct json_object *util_dimm_to_json(struct ndctl_dimm *dimm,
 		unsigned long flags);
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
