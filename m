Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E8A68
	for <nvdimm@lists.linux.dev>; Fri, 12 Nov 2021 21:52:49 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10166"; a="294037112"
X-IronPort-AV: E=Sophos;i="5.87,230,1631602800"; 
   d="scan'208";a="294037112"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2021 13:52:48 -0800
X-IronPort-AV: E=Sophos;i="5.87,230,1631602800"; 
   d="scan'208";a="471283861"
Received: from gjmorale-mobl.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.251.137.106])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2021 13:52:48 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-cxl@vger.kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Ben Widawsky <ben.widawsky@intel.com>,
	<nvdimm@lists.linux.dev>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v6 16/16] cxl: add health information to cxl-list
Date: Fri, 12 Nov 2021 14:52:45 -0700
Message-Id: <20211112215245.1887356-1-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211111204436.1560365-17-vishal.l.verma@intel.com>
References: <20211111204436.1560365-17-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=9561; h=from:subject; bh=8ZYI7ATPwJQglcg+9mSE51jo9xWDuD3lTULe2WQJROA=; b=owGbwMvMwCHGf25diOft7jLG02pJDIl9jxTNEn/XHV5xIDP7vP8F3/q7vN8PTPFlNqs++u79umzP LV8DOkpZGMQ4GGTFFFn+7vnIeExuez5PYIIjzBxWJpAhDFycAjCR28cY/nDxdnvL/ZkXsf2VZvTfop xLq6/2bNlq0n1EZh3vBpmfk+4x/BVvMmFN5X95ff+6hQfLZvW+5lg3bVn40fYlCxSb36+uV2cEAA==
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Add JSON output for fields from the 'GET_HEALTH_INFO' mailbox command
to memory device listings.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Documentation/cxl/cxl-list.txt |  38 +++++++
 util/json.h                    |   1 +
 cxl/list.c                     |   5 +
 util/json.c                    | 179 +++++++++++++++++++++++++++++++++
 4 files changed, 223 insertions(+)

diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
index e761cfa..d305a37 100644
--- a/Documentation/cxl/cxl-list.txt
+++ b/Documentation/cxl/cxl-list.txt
@@ -53,6 +53,44 @@ OPTIONS
 --idle::
 	Include idle (not enabled / zero-sized) devices in the listing
 
+-H::
+--health::
+	Include health information in the memdev listing. Example listing:
+----
+# cxl list -m mem0 -H
+[
+  {
+    "memdev":"mem0",
+    "pmem_size":268435456,
+    "ram_size":268435456,
+    "health":{
+      "maintenance_needed":true,
+      "performance_degraded":true,
+      "hw_replacement_needed":true,
+      "media_normal":false,
+      "media_not_ready":false,
+      "media_persistence_lost":false,
+      "media_data_lost":true,
+      "media_powerloss_persistence_loss":false,
+      "media_shutdown_persistence_loss":false,
+      "media_persistence_loss_imminent":false,
+      "media_powerloss_data_loss":false,
+      "media_shutdown_data_loss":false,
+      "media_data_loss_imminent":false,
+      "ext_life_used":"normal",
+      "ext_temperature":"critical",
+      "ext_corrected_volatile":"warning",
+      "ext_corrected_persistent":"normal",
+      "life_used_percent":15,
+      "temperature":25,
+      "dirty_shutdowns":10,
+      "volatile_errors":20,
+      "pmem_errors":30
+    }
+  }
+]
+----
+
 include::human-option.txt[]
 
 include::verbose-option.txt[]
diff --git a/util/json.h b/util/json.h
index 91918c8..ce575e6 100644
--- a/util/json.h
+++ b/util/json.h
@@ -19,6 +19,7 @@ enum util_json_flags {
 	UTIL_JSON_CONFIGURED	= (1 << 7),
 	UTIL_JSON_FIRMWARE	= (1 << 8),
 	UTIL_JSON_DAX_MAPPINGS	= (1 << 9),
+	UTIL_JSON_HEALTH	= (1 << 10),
 };
 
 struct json_object;
diff --git a/cxl/list.c b/cxl/list.c
index 7c1d2eb..931606a 100644
--- a/cxl/list.c
+++ b/cxl/list.c
@@ -16,6 +16,7 @@ static struct {
 	bool memdevs;
 	bool idle;
 	bool human;
+	bool health;
 } list;
 
 static unsigned long listopts_to_flags(void)
@@ -26,6 +27,8 @@ static unsigned long listopts_to_flags(void)
 		flags |= UTIL_JSON_IDLE;
 	if (list.human)
 		flags |= UTIL_JSON_HUMAN;
+	if (list.health)
+		flags |= UTIL_JSON_HEALTH;
 	return flags;
 }
 
@@ -57,6 +60,8 @@ int cmd_list(int argc, const char **argv, struct cxl_ctx *ctx)
 		OPT_BOOLEAN('i', "idle", &list.idle, "include idle devices"),
 		OPT_BOOLEAN('u', "human", &list.human,
 				"use human friendly number formats "),
+		OPT_BOOLEAN('H', "health", &list.health,
+				"include memory device health information "),
 		OPT_END(),
 	};
 	const char * const u[] = {
diff --git a/util/json.c b/util/json.c
index 3be3a92..f97cf07 100644
--- a/util/json.c
+++ b/util/json.c
@@ -1442,6 +1442,180 @@ struct json_object *util_badblock_rec_to_json(u64 block, u64 count,
 	return NULL;
 }
 
+static struct json_object *util_cxl_memdev_health_to_json(
+		struct cxl_memdev *memdev, unsigned long flags)
+{
+	struct json_object *jhealth;
+	struct json_object *jobj;
+	struct cxl_cmd *cmd;
+	u32 field;
+	int rc;
+
+	jhealth = json_object_new_object();
+	if (!jhealth)
+		return NULL;
+	if (!memdev)
+		goto err_jobj;
+
+	cmd = cxl_cmd_new_get_health_info(memdev);
+	if (!cmd)
+		goto err_jobj;
+
+	rc = cxl_cmd_submit(cmd);
+	if (rc < 0)
+		goto err_cmd;
+	rc = cxl_cmd_get_mbox_status(cmd);
+	if (rc != 0)
+		goto err_cmd;
+
+	/* health_status fields */
+	rc = cxl_cmd_health_info_get_maintenance_needed(cmd);
+	jobj = json_object_new_boolean(rc);
+	if (jobj)
+		json_object_object_add(jhealth, "maintenance_needed", jobj);
+
+	rc = cxl_cmd_health_info_get_performance_degraded(cmd);
+	jobj = json_object_new_boolean(rc);
+	if (jobj)
+		json_object_object_add(jhealth, "performance_degraded", jobj);
+
+	rc = cxl_cmd_health_info_get_hw_replacement_needed(cmd);
+	jobj = json_object_new_boolean(rc);
+	if (jobj)
+		json_object_object_add(jhealth, "hw_replacement_needed", jobj);
+
+	/* media_status fields */
+	rc = cxl_cmd_health_info_get_media_normal(cmd);
+	jobj = json_object_new_boolean(rc);
+	if (jobj)
+		json_object_object_add(jhealth, "media_normal", jobj);
+
+	rc = cxl_cmd_health_info_get_media_not_ready(cmd);
+	jobj = json_object_new_boolean(rc);
+	if (jobj)
+		json_object_object_add(jhealth, "media_not_ready", jobj);
+
+	rc = cxl_cmd_health_info_get_media_persistence_lost(cmd);
+	jobj = json_object_new_boolean(rc);
+	if (jobj)
+		json_object_object_add(jhealth, "media_persistence_lost", jobj);
+
+	rc = cxl_cmd_health_info_get_media_data_lost(cmd);
+	jobj = json_object_new_boolean(rc);
+	if (jobj)
+		json_object_object_add(jhealth, "media_data_lost", jobj);
+
+	rc = cxl_cmd_health_info_get_media_powerloss_persistence_loss(cmd);
+	jobj = json_object_new_boolean(rc);
+	if (jobj)
+		json_object_object_add(jhealth, "media_powerloss_persistence_loss", jobj);
+
+	rc = cxl_cmd_health_info_get_media_shutdown_persistence_loss(cmd);
+	jobj = json_object_new_boolean(rc);
+	if (jobj)
+		json_object_object_add(jhealth, "media_shutdown_persistence_loss", jobj);
+
+	rc = cxl_cmd_health_info_get_media_persistence_loss_imminent(cmd);
+	jobj = json_object_new_boolean(rc);
+	if (jobj)
+		json_object_object_add(jhealth, "media_persistence_loss_imminent", jobj);
+
+	rc = cxl_cmd_health_info_get_media_powerloss_data_loss(cmd);
+	jobj = json_object_new_boolean(rc);
+	if (jobj)
+		json_object_object_add(jhealth, "media_powerloss_data_loss", jobj);
+
+	rc = cxl_cmd_health_info_get_media_shutdown_data_loss(cmd);
+	jobj = json_object_new_boolean(rc);
+	if (jobj)
+		json_object_object_add(jhealth, "media_shutdown_data_loss", jobj);
+
+	rc = cxl_cmd_health_info_get_media_data_loss_imminent(cmd);
+	jobj = json_object_new_boolean(rc);
+	if (jobj)
+		json_object_object_add(jhealth, "media_data_loss_imminent", jobj);
+
+	/* ext_status fields */
+	if (cxl_cmd_health_info_get_ext_life_used_normal(cmd))
+		jobj = json_object_new_string("normal");
+	else if (cxl_cmd_health_info_get_ext_life_used_warning(cmd))
+		jobj = json_object_new_string("warning");
+	else if (cxl_cmd_health_info_get_ext_life_used_critical(cmd))
+		jobj = json_object_new_string("critical");
+	else
+		jobj = json_object_new_string("unknown");
+	if (jobj)
+		json_object_object_add(jhealth, "ext_life_used", jobj);
+
+	if (cxl_cmd_health_info_get_ext_temperature_normal(cmd))
+		jobj = json_object_new_string("normal");
+	else if (cxl_cmd_health_info_get_ext_temperature_warning(cmd))
+		jobj = json_object_new_string("warning");
+	else if (cxl_cmd_health_info_get_ext_temperature_critical(cmd))
+		jobj = json_object_new_string("critical");
+	else
+		jobj = json_object_new_string("unknown");
+	if (jobj)
+		json_object_object_add(jhealth, "ext_temperature", jobj);
+
+	if (cxl_cmd_health_info_get_ext_corrected_volatile_normal(cmd))
+		jobj = json_object_new_string("normal");
+	else if (cxl_cmd_health_info_get_ext_corrected_volatile_warning(cmd))
+		jobj = json_object_new_string("warning");
+	else
+		jobj = json_object_new_string("unknown");
+	if (jobj)
+		json_object_object_add(jhealth, "ext_corrected_volatile", jobj);
+
+	if (cxl_cmd_health_info_get_ext_corrected_persistent_normal(cmd))
+		jobj = json_object_new_string("normal");
+	else if (cxl_cmd_health_info_get_ext_corrected_persistent_warning(cmd))
+		jobj = json_object_new_string("warning");
+	else
+		jobj = json_object_new_string("unknown");
+	if (jobj)
+		json_object_object_add(jhealth, "ext_corrected_persistent", jobj);
+
+	/* other fields */
+	field = cxl_cmd_health_info_get_life_used(cmd);
+	if (field != 0xff) {
+		jobj = json_object_new_int(field);
+		if (jobj)
+			json_object_object_add(jhealth, "life_used_percent", jobj);
+	}
+
+	field = cxl_cmd_health_info_get_temperature(cmd);
+	if (field != 0xffff) {
+		jobj = json_object_new_int(field);
+		if (jobj)
+			json_object_object_add(jhealth, "temperature", jobj);
+	}
+
+	field = cxl_cmd_health_info_get_dirty_shutdowns(cmd);
+	jobj = json_object_new_int64(field);
+	if (jobj)
+		json_object_object_add(jhealth, "dirty_shutdowns", jobj);
+
+	field = cxl_cmd_health_info_get_volatile_errors(cmd);
+	jobj = json_object_new_int64(field);
+	if (jobj)
+		json_object_object_add(jhealth, "volatile_errors", jobj);
+
+	field = cxl_cmd_health_info_get_pmem_errors(cmd);
+	jobj = json_object_new_int64(field);
+	if (jobj)
+		json_object_object_add(jhealth, "pmem_errors", jobj);
+
+	cxl_cmd_unref(cmd);
+	return jhealth;
+
+err_cmd:
+	cxl_cmd_unref(cmd);
+err_jobj:
+	json_object_put(jhealth);
+	return NULL;
+}
+
 struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
 		unsigned long flags)
 {
@@ -1464,5 +1638,10 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
 	if (jobj)
 		json_object_object_add(jdev, "ram_size", jobj);
 
+	if (flags & UTIL_JSON_HEALTH) {
+		jobj = util_cxl_memdev_health_to_json(memdev, flags);
+		if (jobj)
+			json_object_object_add(jdev, "health", jobj);
+	}
 	return jdev;
 }
-- 
2.31.1

