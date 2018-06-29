Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 841CF211F8886
 for <linux-nvdimm@lists.01.org>; Fri, 29 Jun 2018 16:39:34 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [ndctl PATCH 1/3] ndctl: simplify JSON print flag handling
Date: Fri, 29 Jun 2018 17:39:25 -0600
Message-Id: <20180629233927.6232-1-ross.zwisler@linux.intel.com>
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

json_object_to_json_string_ext()'s second argument is a flags field which
we always want to be JSON_C_TO_STRING_PRETTY.  We were going to a lot of
trouble for this, though.  We had multiple variables set to be this one
flag and util_display_json_array() took it as an argument, even though it
never varied.

Instead, just pass in the necessary flag when calling
json_object_to_json_string_ext(), removing the local variables and the extra
argument to util_display_json_array().

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 daxctl/list.c        |  5 ++---
 ndctl/bus.c          |  3 +--
 ndctl/dimm.c         |  3 +--
 ndctl/inject-smart.c |  3 +--
 ndctl/list.c         | 11 +++++------
 util/json.c          |  3 ++-
 util/json.h          |  2 +-
 7 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/daxctl/list.c b/daxctl/list.c
index 254f0ac..ed9e76c 100644
--- a/daxctl/list.c
+++ b/daxctl/list.c
@@ -50,7 +50,6 @@ static struct {
 };
 
 static int did_fail;
-static int jflag = JSON_C_TO_STRING_PRETTY;
 
 #define fail(fmt, ...) \
 do { \
@@ -130,9 +129,9 @@ int cmd_list(int argc, const char **argv, void *ctx)
 	}
 
 	if (jregions)
-		util_display_json_array(stdout, jregions, jflag);
+		util_display_json_array(stdout, jregions);
 	else if (jdevs)
-		util_display_json_array(stdout, jdevs, jflag);
+		util_display_json_array(stdout, jdevs);
 
 	if (did_fail)
 		return -ENOMEM;
diff --git a/ndctl/bus.c b/ndctl/bus.c
index fc31d06..b7b7d65 100644
--- a/ndctl/bus.c
+++ b/ndctl/bus.c
@@ -88,8 +88,7 @@ static int bus_action(int argc, const char **argv, const char *usage,
 	}
 
 	if (success)
-		util_display_json_array(stdout, jbuses,
-				JSON_C_TO_STRING_PRETTY);
+		util_display_json_array(stdout, jbuses);
 	else
 		json_object_put(jbuses);
 
diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index 1c16899..6964c5e 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -1081,8 +1081,7 @@ static int dimm_action(int argc, const char **argv, void *ctx,
 	}
 
 	if (actx.jdimms)
-		util_display_json_array(actx.f_out, actx.jdimms,
-				JSON_C_TO_STRING_PRETTY);
+		util_display_json_array(actx.f_out, actx.jdimms);
 
 	if (actx.f_out != stdout)
 		fclose(actx.f_out);
diff --git a/ndctl/inject-smart.c b/ndctl/inject-smart.c
index 60de9fe..2e62c89 100644
--- a/ndctl/inject-smart.c
+++ b/ndctl/inject-smart.c
@@ -375,8 +375,7 @@ static int dimm_inject_smart(struct ndctl_dimm *dimm)
 		jhealth = util_dimm_health_to_json(dimm);
 		if (jhealth) {
 			json_object_object_add(jdimm, "health", jhealth);
-			util_display_json_array(stdout, jdimms,
-				JSON_C_TO_STRING_PRETTY);
+			util_display_json_array(stdout, jdimms);
 		}
 	}
 out:
diff --git a/ndctl/list.c b/ndctl/list.c
index 6cf7c39..030d73f 100644
--- a/ndctl/list.c
+++ b/ndctl/list.c
@@ -56,7 +56,6 @@ static unsigned long listopts_to_flags(void)
 struct util_filter_params param;
 
 static int did_fail;
-static int jflag = JSON_C_TO_STRING_PRETTY;
 
 #define fail(fmt, ...) \
 do { \
@@ -380,7 +379,7 @@ static int list_display(struct list_filter_arg *lfa)
 	struct json_object *jbuses = lfa->jbuses;
 
 	if (jbuses)
-		util_display_json_array(stdout, jbuses, jflag);
+		util_display_json_array(stdout, jbuses);
 	else if ((!!jdimms + !!jregions + !!jnamespaces) > 1) {
 		struct json_object *jplatform = json_object_new_object();
 
@@ -397,14 +396,14 @@ static int list_display(struct list_filter_arg *lfa)
 			json_object_object_add(jplatform, "namespaces",
 					jnamespaces);
 		printf("%s\n", json_object_to_json_string_ext(jplatform,
-					jflag));
+					JSON_C_TO_STRING_PRETTY));
 		json_object_put(jplatform);
 	} else if (jdimms)
-		util_display_json_array(stdout, jdimms, jflag);
+		util_display_json_array(stdout, jdimms);
 	else if (jregions)
-		util_display_json_array(stdout, jregions, jflag);
+		util_display_json_array(stdout, jregions);
 	else if (jnamespaces)
-		util_display_json_array(stdout, jnamespaces, jflag);
+		util_display_json_array(stdout, jnamespaces);
 	return 0;
 }
 
diff --git a/util/json.c b/util/json.c
index 94ed948..ff894c7 100644
--- a/util/json.c
+++ b/util/json.c
@@ -105,9 +105,10 @@ struct json_object *util_json_object_hex(unsigned long long val,
 	return jobj;
 }
 
-void util_display_json_array(FILE *f_out, struct json_object *jarray, int jflag)
+void util_display_json_array(FILE *f_out, struct json_object *jarray)
 {
 	int len = json_object_array_length(jarray);
+	int jflag = JSON_C_TO_STRING_PRETTY;
 
 	if (json_object_array_length(jarray) > 1)
 		fprintf(f_out, "%s\n", json_object_to_json_string_ext(jarray, jflag));
diff --git a/util/json.h b/util/json.h
index c5d1603..d0167cf 100644
--- a/util/json.h
+++ b/util/json.h
@@ -26,7 +26,7 @@ enum util_json_flags {
 };
 
 struct json_object;
-void util_display_json_array(FILE *f_out, struct json_object *jarray, int jflag);
+void util_display_json_array(FILE *f_out, struct json_object *jarray);
 struct json_object *util_bus_to_json(struct ndctl_bus *bus);
 struct json_object *util_dimm_to_json(struct ndctl_dimm *dimm,
 		unsigned long flags);
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
