Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id 4E9B91A1F6C
 for <linux-nvdimm@lists.01.org>; Wed,  6 Apr 2016 18:08:11 -0700 (PDT)
Subject: [ndctl PATCH 4/5] ndctl, list: add a '--health' option
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 06 Apr 2016 18:07:20 -0700
Message-ID: <20160407010720.30641.60021.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20160407010659.30641.26139.stgit@dwillia2-desk3.jf.intel.com>
References: <20160407010659.30641.26139.stgit@dwillia2-desk3.jf.intel.com>
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

Dump dimm smart data in the dimm listing when '--health' is specified.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/ndctl-list.txt |   19 ++++++++
 builtin-list.c               |   11 +++++
 util/json.c                  |   97 ++++++++++++++++++++++++++++++++++++++++++
 util/json.h                  |    1 
 4 files changed, 127 insertions(+), 1 deletion(-)

diff --git a/Documentation/ndctl-list.txt b/Documentation/ndctl-list.txt
index 806548196118..36398aa34b42 100644
--- a/Documentation/ndctl-list.txt
+++ b/Documentation/ndctl-list.txt
@@ -3,7 +3,7 @@ ndctl-list(1)
 
 NAME
 ----
-ndctl-list - dump the platform nvdimm device topology in json
+ndctl-list - dump the platform nvdimm device topology and attributes in json
 
 SYNOPSIS
 --------
@@ -72,6 +72,23 @@ include::xable-region-options.txt[]
 --dimms::
 	Include dimm info in the listing
 
+-H::
+--health::
+	Include dimm health info in the listing.  For example:
+[verse]
+{
+  "dev":"nmem0",
+  "health":{
+    "health_state":"non-critical",
+    "temperature_celsius":23,
+    "spares_percentage":75,
+    "alarm_temperature":true,
+    "alarm_spares":true,
+    "life_used_percentage":5,
+    "shutdown_state":"clean"
+  }
+}
+
 -R::
 --regions::
 	Include region info in the listing
diff --git a/builtin-list.c b/builtin-list.c
index df0871ab544a..8b65767c37be 100644
--- a/builtin-list.c
+++ b/builtin-list.c
@@ -22,6 +22,7 @@ static struct {
 	bool regions;
 	bool namespaces;
 	bool idle;
+	bool health;
 } list;
 
 static struct {
@@ -200,6 +201,7 @@ int cmd_list(int argc, const char **argv)
 				"filter by region-type"),
 		OPT_BOOLEAN('B', "buses", &list.buses, "include bus info"),
 		OPT_BOOLEAN('D', "dimms", &list.dimms, "include dimm info"),
+		OPT_BOOLEAN('H', "health", &list.health, "include dimm health"),
 		OPT_BOOLEAN('R', "regions", &list.regions,
 				"include region info"),
 		OPT_BOOLEAN('N', "namespaces", &list.namespaces,
@@ -299,6 +301,15 @@ int cmd_list(int argc, const char **argv)
 				continue;
 			}
 
+			if (list.health) {
+				struct json_object *jhealth;
+
+				jhealth = util_dimm_health_to_json(dimm);
+				if (jhealth)
+					json_object_object_add(jdimm, "health",
+							jhealth);
+			}
+
 			/*
 			 * Without a bus we are collecting dimms anonymously
 			 * across the platform.
diff --git a/util/json.c b/util/json.c
index 288efee723ff..6e61372e4f69 100644
--- a/util/json.c
+++ b/util/json.c
@@ -61,6 +61,103 @@ struct json_object *util_dimm_to_json(struct ndctl_dimm *dimm)
 	return NULL;
 }
 
+struct json_object *util_dimm_health_to_json(struct ndctl_dimm *dimm)
+{
+	struct json_object *jhealth = json_object_new_object();
+	struct json_object *jobj;
+	struct ndctl_cmd *cmd;
+	unsigned int flags;
+	int rc;
+
+	if (!jhealth)
+		return NULL;
+
+	cmd = ndctl_dimm_cmd_new_smart(dimm);
+	if (!cmd)
+		goto err;
+
+	rc = ndctl_cmd_submit(cmd);
+	if (rc || ndctl_cmd_get_firmware_status(cmd))
+		goto err;
+
+	flags = ndctl_cmd_smart_get_flags(cmd);
+	if (flags & ND_SMART_HEALTH_VALID) {
+		unsigned int health = ndctl_cmd_smart_get_health(cmd);
+
+		if (health & ND_SMART_FATAL_HEALTH)
+			jobj = json_object_new_string("fatal");
+		else if (health & ND_SMART_CRITICAL_HEALTH)
+			jobj = json_object_new_string("critical");
+		else if (health & ND_SMART_NON_CRITICAL_HEALTH)
+			jobj = json_object_new_string("non-critical");
+		else
+			jobj = json_object_new_string("ok");
+		if (jobj)
+			json_object_object_add(jhealth, "health_state", jobj);
+	}
+
+	if (flags & ND_SMART_TEMP_VALID) {
+		unsigned int temp = ndctl_cmd_smart_get_temperature(cmd);
+		bool negative = !!(temp & (1 << 15));
+		double t;
+
+		temp &= ~(1 << 15);
+		t = (double) temp / 16;
+		if (negative)
+			t *= -1;
+		jobj = json_object_new_double(t);
+		if (jobj)
+			json_object_object_add(jhealth, "temperature_celsius", jobj);
+	}
+
+	if (flags & ND_SMART_SPARES_VALID) {
+		unsigned int spares = ndctl_cmd_smart_get_spares(cmd);
+
+		jobj = json_object_new_int(spares);
+		if (jobj)
+			json_object_object_add(jhealth, "spares_percentage", jobj);
+	}
+
+	if (flags & ND_SMART_ALARM_VALID) {
+		unsigned int alarm_flags = ndctl_cmd_smart_get_spares(cmd);
+		bool temp_flag = !!(alarm_flags & ND_SMART_TEMP_TRIP);
+		bool spares_flag = !!(alarm_flags & ND_SMART_SPARE_TRIP);
+
+		jobj = json_object_new_boolean(temp_flag);
+		if (jobj)
+			json_object_object_add(jhealth, "alarm_temperature", jobj);
+
+		jobj = json_object_new_boolean(spares_flag);
+		if (jobj)
+			json_object_object_add(jhealth, "alarm_spares", jobj);
+	}
+
+	if (flags & ND_SMART_USED_VALID) {
+		unsigned int life_used = ndctl_cmd_smart_get_life_used(cmd);
+
+		jobj = json_object_new_int(life_used);
+		if (jobj)
+			json_object_object_add(jhealth, "life_used_percentage", jobj);
+	}
+
+	if (flags & ND_SMART_SHUTDOWN_VALID) {
+		unsigned int shutdown = ndctl_cmd_smart_get_shutdown_state(cmd);
+
+		jobj = json_object_new_string(shutdown ? "dirty" : "clean");
+		if (jobj)
+			json_object_object_add(jhealth, "shutdown_state", jobj);
+	}
+
+	ndctl_cmd_unref(cmd);
+	return jhealth;
+ err:
+	json_object_put(jhealth);
+	if (cmd)
+		ndctl_cmd_unref(cmd);
+	return NULL;
+}
+
+
 bool util_namespace_active(struct ndctl_namespace *ndns)
 {
 	struct ndctl_btt *btt = ndctl_namespace_get_btt(ndns);
diff --git a/util/json.h b/util/json.h
index 653bbd9beef1..79962cacc35c 100644
--- a/util/json.h
+++ b/util/json.h
@@ -6,6 +6,7 @@
 bool util_namespace_active(struct ndctl_namespace *ndns);
 struct json_object *util_bus_to_json(struct ndctl_bus *bus);
 struct json_object *util_dimm_to_json(struct ndctl_dimm *dimm);
+struct json_object *util_dimm_health_to_json(struct ndctl_dimm *dimm);
 struct json_object *util_mapping_to_json(struct ndctl_mapping *mapping);
 struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns);
 #endif /* __NDCTL_JSON_H__ */

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
