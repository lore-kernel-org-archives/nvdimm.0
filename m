Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6126566DF
	for <nvdimm@lists.linux.dev>; Tue, 22 Feb 2022 19:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645559558; x=1677095558;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KmrMQTDb6cGTe/qnj9HgoX3TAd54sfcgXTDrSD8yIso=;
  b=FDN368FuV4CAJy6j9coVTF7nVNM7BS8CukdnGsHguPjOZbsIScfLHuix
   pHack3bk+LJO+QOPXS/Adz7h4hAb2hxCmxhbIuYc+MNs3zaTF+VCFuaAX
   Zv/A59q/rAEmfTnTLmNlZNsVLiVQy7ndL8znJrk22gMTxj+beTvOPHFeo
   +/arG7UtxjI7k5/eMh7aocGbzd4GrfD14ldlp7P6x2SlV+mAAIQWNwbUL
   W2tONeaPrK+AwSsrFM+dugtdIyFvoLisTXHWjG+PrpB1tTk3K+aYPygrq
   iooK31Qj16pYhWx9socTRJdG+Hu5r1NDuzayb4cqPin6QwUM1M+tAo0VR
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10266"; a="315027649"
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="315027649"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 11:52:37 -0800
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="683637815"
Received: from alison-desk.jf.intel.com (HELO localhost) ([10.54.74.41])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 11:52:37 -0800
From: alison.schofield@intel.com
To: Ben Widawsky <ben.widawsky@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v6 4/6] cxl: add memdev partition information to cxl-list
Date: Tue, 22 Feb 2022 11:56:06 -0800
Message-Id: <70cc57379d2c49692036b1daa158a122aa19c126.1645558189.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1645558189.git.alison.schofield@intel.com>
References: <cover.1645558189.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

The CXL PMEM provisioning model depends upon the values reported in
both the CXL IDENTIFY and GET_PARTITION_INFO mailbox commands when
changing the partitioning between volatile and persistent capacity.

Add an option to the 'cxl list' command to display partition information.

Include the partitioning related fields from the IDENTIFY command:
total, volatile_only, persistent_only, and partition_alignment sizes.
When the partition_alignment size is greater than zero, indicating
partitionable capacity, include the active and next size fields of
GET_PARTITION_INFO.

Example:
    "partition_info":{
      "total_size":273535729664,
      "volatile_only_size":0,
      "persistent_only_size":0,
      "partition_alignment_size":268435456
      "active_volatile_size":273535729664,
      "active_persistent_size":0,
      "next_volatile_size":0,
      "next_persistent_size":0,
    }

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/cxl/cxl-list.txt |  23 +++++++
 cxl/filter.c                   |   2 +
 cxl/filter.h                   |   1 +
 cxl/json.c                     | 120 +++++++++++++++++++++++++++++++++
 cxl/list.c                     |   2 +
 util/json.h                    |   1 +
 6 files changed, 149 insertions(+)

diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
index 90e6d9f9658b..f6aba0c5c1fa 100644
--- a/Documentation/cxl/cxl-list.txt
+++ b/Documentation/cxl/cxl-list.txt
@@ -196,6 +196,29 @@ OPTIONS
   }
 ]
 ----
+-I::
+--partition::
+	Include partition information in the memdev listing. Example listing:
+----
+# cxl list -m mem0 -I
+[
+  {
+    "memdev":"mem0",
+    "pmem_size":0,
+    "ram_size":273535729664,
+    "partition_info":{
+      "total_size":273535729664,
+      "volatile_only_size":0,
+      "persistent_only_size":0,
+      "partition_alignment_size":268435456
+      "active_volatile_size":273535729664,
+      "active_persistent_size":0,
+      "next_volatile_size":0,
+      "next_persistent_size":0,
+    }
+  }
+]
+----
 
 -B::
 --buses::
diff --git a/cxl/filter.c b/cxl/filter.c
index 925bf3a1c62d..b3396426dda8 100644
--- a/cxl/filter.c
+++ b/cxl/filter.c
@@ -581,6 +581,8 @@ static unsigned long params_to_flags(struct cxl_filter_params *param)
 		flags |= UTIL_JSON_HEALTH;
 	if (param->targets)
 		flags |= UTIL_JSON_TARGETS;
+	if (param->partition)
+		flags |= UTIL_JSON_PARTITION;
 	return flags;
 }
 
diff --git a/cxl/filter.h b/cxl/filter.h
index 5deabb3d38fe..697b7779c08e 100644
--- a/cxl/filter.h
+++ b/cxl/filter.h
@@ -23,6 +23,7 @@ struct cxl_filter_params {
 	bool idle;
 	bool human;
 	bool health;
+	bool partition;
 	struct log_ctx ctx;
 };
 
diff --git a/cxl/json.c b/cxl/json.c
index f3b536e1d4fa..fdc6f73a86c1 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -185,6 +185,121 @@ err_jobj:
 	return NULL;
 }
 
+/*
+ * Present complete view of memdev partition by presenting fields from
+ * both GET_PARTITION_INFO and IDENTIFY mailbox commands.
+ */
+static struct json_object *util_cxl_memdev_partition_to_json(struct cxl_memdev *memdev,
+		unsigned long flags)
+{
+	struct json_object *jobj = NULL;
+	struct json_object *jpart;
+	unsigned long long cap;
+	struct cxl_cmd *cmd;
+	int rc;
+
+	jpart = json_object_new_object();
+	if (!jpart)
+		return NULL;
+	if (!memdev)
+		goto err_jobj;
+
+	/* Retrieve partition info in the IDENTIFY mbox cmd */
+	cmd = cxl_cmd_new_identify(memdev);
+	if (!cmd)
+		goto err_jobj;
+
+	rc = cxl_cmd_submit(cmd);
+	if (rc < 0)
+		goto err_identify;
+	rc = cxl_cmd_get_mbox_status(cmd);
+	if (rc != 0)
+		goto err_identify;
+
+	cap = cxl_cmd_identify_get_total_size(cmd);
+	if (cap != ULLONG_MAX) {
+		jobj = util_json_object_size(cap, flags);
+		if (jobj)
+			json_object_object_add(jpart, "total_size", jobj);
+	}
+	cap = cxl_cmd_identify_get_volatile_only_size(cmd);
+	if (cap != ULLONG_MAX) {
+		jobj = util_json_object_size(cap, flags);
+		if (jobj)
+			json_object_object_add(jpart,
+					"volatile_only_size", jobj);
+	}
+	cap = cxl_cmd_identify_get_persistent_only_size(cmd);
+	if (cap != ULLONG_MAX) {
+		jobj = util_json_object_size(cap, flags);
+		if (jobj)
+			json_object_object_add(jpart,
+					"persistent_only_size", jobj);
+	}
+	cap = cxl_cmd_identify_get_partition_align(cmd);
+	jobj = util_json_object_size(cap, flags);
+	if (jobj)
+		json_object_object_add(jpart, "partition_alignment_size", jobj);
+
+	cxl_cmd_unref(cmd);
+
+	/* Return now if there is no partition info to get. */
+	if (!cap)
+		return jpart;
+
+	/* Retrieve partition info in GET_PARTITION_INFO mbox cmd */
+	cmd = cxl_cmd_new_get_partition(memdev);
+	if (!cmd)
+		return jpart;
+
+	rc = cxl_cmd_submit(cmd);
+	if (rc < 0)
+		goto err_get;
+	rc = cxl_cmd_get_mbox_status(cmd);
+	if (rc != 0)
+		goto err_get;
+
+	cap = cxl_cmd_partition_get_active_volatile_size(cmd);
+	if (cap != ULLONG_MAX) {
+		jobj = util_json_object_size(cap, flags);
+		if (jobj)
+			json_object_object_add(jpart,
+					"active_volatile_size", jobj);
+	}
+	cap = cxl_cmd_partition_get_active_persistent_size(cmd);
+	if (cap != ULLONG_MAX) {
+		jobj = util_json_object_size(cap, flags);
+		if (jobj)
+			json_object_object_add(jpart,
+					"active_persistent_size", jobj);
+	}
+	cap = cxl_cmd_partition_get_next_volatile_size(cmd);
+	if (cap != ULLONG_MAX) {
+		jobj = util_json_object_size(cap, flags);
+		if (jobj)
+			json_object_object_add(jpart,
+					"next_volatile_size", jobj);
+	}
+	cap = cxl_cmd_partition_get_next_persistent_size(cmd);
+	if (cap != ULLONG_MAX) {
+		jobj = util_json_object_size(cap, flags);
+		if (jobj)
+			json_object_object_add(jpart,
+					"next_persistent_size", jobj);
+	}
+
+err_get:
+	cxl_cmd_unref(cmd);
+	return jpart;
+
+err_identify:
+	cxl_cmd_unref(cmd);
+
+err_jobj:
+	json_object_put(jpart);
+	return NULL;
+}
+
 struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
 		unsigned long flags)
 {
@@ -239,6 +354,11 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
 			json_object_object_add(jdev, "state", jobj);
 	}
 
+	if (flags & UTIL_JSON_PARTITION) {
+		jobj = util_cxl_memdev_partition_to_json(memdev, flags);
+		if (jobj)
+			json_object_object_add(jdev, "partition_info", jobj);
+	}
 	return jdev;
 }
 
diff --git a/cxl/list.c b/cxl/list.c
index de96ff91fb5d..1e9d441190a0 100644
--- a/cxl/list.c
+++ b/cxl/list.c
@@ -48,6 +48,8 @@ static const struct option options[] = {
 		    "use human friendly number formats "),
 	OPT_BOOLEAN('H', "health", &param.health,
 		    "include memory device health information "),
+	OPT_BOOLEAN('I', "partition", &param.partition,
+		    "include memory device partition information "),
 #ifdef ENABLE_DEBUG
 	OPT_BOOLEAN(0, "debug", &debug, "debug list walk"),
 #endif
diff --git a/util/json.h b/util/json.h
index e026df1e1519..73bb9f0075cf 100644
--- a/util/json.h
+++ b/util/json.h
@@ -19,6 +19,7 @@ enum util_json_flags {
 	UTIL_JSON_DAX_MAPPINGS	= (1 << 9),
 	UTIL_JSON_HEALTH	= (1 << 10),
 	UTIL_JSON_TARGETS	= (1 << 11),
+	UTIL_JSON_PARTITION	= (1 << 12),
 };
 
 void util_display_json_array(FILE *f_out, struct json_object *jarray,
-- 
2.31.1

