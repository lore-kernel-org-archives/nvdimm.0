Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D342CAD
	for <nvdimm@lists.linux.dev>; Mon,  3 Jan 2022 20:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641240696; x=1672776696;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=i8nB8iLWmY3RrwAJboCr0xODBiC8RVy3LJGcIn0A/Y4=;
  b=lFnnOJxcecFlrMfGT5/Mlw6XI4qS8qe5uH10tPRoE19O8DV7C7lBqnVP
   IifmwZwoLkwiYeyG3rpDJC5cAaXTcmcrH1RMtq9/5//S4uugBq4O/k/ck
   Tq8C3otIrGbCbP4mdcjUbSzW5ch+5GGWpRa7dgXA2RcXuo/DZSTAJi0Y4
   LHKhGg/pS/+8rbN/K5nId6ComZLBoWyczmVn13KomuuYLzh5zHhElt06c
   gs6s+8wZtXUYiYzjhycxYMesubPzS3OsGR6wQg++69V6B332Xo93TZvN2
   h7esgOcG9bTxy0Ys4QZ1pbofSll79QbZHYbZwMzKfQM525l805QJDqYfb
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10216"; a="302866890"
X-IronPort-AV: E=Sophos;i="5.88,258,1635231600"; 
   d="scan'208";a="302866890"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2022 12:11:33 -0800
X-IronPort-AV: E=Sophos;i="5.88,258,1635231600"; 
   d="scan'208";a="525709400"
Received: from alison-desk.jf.intel.com (HELO localhost) ([10.54.74.41])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2022 12:11:33 -0800
From: alison.schofield@intel.com
To: Ben Widawsky <ben.widawsky@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH 4/7] cxl: add memdev partition information to cxl-list
Date: Mon,  3 Jan 2022 12:16:15 -0800
Message-Id: <78ff68a062f23cef48fb6ea1f91bcd7e11e4fa6e.1641233076.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1641233076.git.alison.schofield@intel.com>
References: <cover.1641233076.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

Add information useful for managing memdev partitions to cxl-list
output. Include all of the fields from GET_PARTITION_INFO and the
partitioning related fields from the IDENTIFY mailbox command.

    "partition":{
      "active_volatile_capacity":273535729664,
      "active_persistent_capacity":0,
      "next_volatile_capacity":0,
      "next_persistent_capacity":0,
      "total_capacity":273535729664,
      "volatile_only_capacity":0,
      "persistent_only_capacity":0,
      "partition_alignment":268435456
    }

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 Documentation/cxl/cxl-list.txt |  23 +++++++
 util/json.h                    |   1 +
 cxl/list.c                     |   5 ++
 util/json.c                    | 112 +++++++++++++++++++++++++++++++++
 4 files changed, 141 insertions(+)

diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
index c8d10fb..e65e944 100644
--- a/Documentation/cxl/cxl-list.txt
+++ b/Documentation/cxl/cxl-list.txt
@@ -85,6 +85,29 @@ OPTIONS
   }
 ]
 ----
+-P::
+--partition::
+	Include partition information in the memdev listing. Example listing:
+----
+# cxl list -m mem0 -P
+[
+  {
+    "memdev":"mem0",
+    "pmem_size":0,
+    "ram_size":273535729664,
+    "partition":{
+      "active_volatile_capacity":273535729664,
+      "active_persistent_capacity":0,
+      "next_volatile_capacity":0,
+      "next_persistent_capacity":0,
+      "total_capacity":273535729664,
+      "volatile_only_capacity":0,
+      "persistent_only_capacity":0,
+      "partition_alignment":268435456
+    }
+  }
+]
+----
 
 include::human-option.txt[]
 
diff --git a/util/json.h b/util/json.h
index ce575e6..76a8816 100644
--- a/util/json.h
+++ b/util/json.h
@@ -20,6 +20,7 @@ enum util_json_flags {
 	UTIL_JSON_FIRMWARE	= (1 << 8),
 	UTIL_JSON_DAX_MAPPINGS	= (1 << 9),
 	UTIL_JSON_HEALTH	= (1 << 10),
+	UTIL_JSON_PARTITION	= (1 << 11),
 };
 
 struct json_object;
diff --git a/cxl/list.c b/cxl/list.c
index b1468b7..368ec21 100644
--- a/cxl/list.c
+++ b/cxl/list.c
@@ -17,6 +17,7 @@ static struct {
 	bool idle;
 	bool human;
 	bool health;
+	bool partition;
 } list;
 
 static unsigned long listopts_to_flags(void)
@@ -29,6 +30,8 @@ static unsigned long listopts_to_flags(void)
 		flags |= UTIL_JSON_HUMAN;
 	if (list.health)
 		flags |= UTIL_JSON_HEALTH;
+	if (list.partition)
+		flags |= UTIL_JSON_PARTITION;
 	return flags;
 }
 
@@ -62,6 +65,8 @@ int cmd_list(int argc, const char **argv, struct cxl_ctx *ctx)
 				"use human friendly number formats "),
 		OPT_BOOLEAN('H', "health", &list.health,
 				"include memory device health information "),
+		OPT_BOOLEAN('P', "partition", &list.partition,
+				"include memory device partition information "),
 		OPT_END(),
 	};
 	const char * const u[] = {
diff --git a/util/json.c b/util/json.c
index f97cf07..4254dea 100644
--- a/util/json.c
+++ b/util/json.c
@@ -1616,6 +1616,113 @@ err_jobj:
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
+	/* Retrieve partition info in GET_PARTITION_INFO mbox cmd */
+	cmd = cxl_cmd_new_get_partition_info(memdev);
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
+	cap = cxl_cmd_get_partition_info_get_active_volatile_cap(cmd);
+	if (cap != ULLONG_MAX) {
+		jobj = util_json_object_size(cap, flags);
+		if (jobj)
+			json_object_object_add(jpart,
+					"active_volatile_capacity", jobj);
+	}
+	cap = cxl_cmd_get_partition_info_get_active_persistent_cap(cmd);
+	if (cap != ULLONG_MAX) {
+		jobj = util_json_object_size(cap, flags);
+		if (jobj)
+			json_object_object_add(jpart,
+					"active_persistent_capacity", jobj);
+	}
+	cap = cxl_cmd_get_partition_info_get_next_volatile_cap(cmd);
+	if (cap != ULLONG_MAX) {
+		jobj = util_json_object_size(cap, flags);
+		if (jobj)
+			json_object_object_add(jpart,
+					"next_volatile_capacity", jobj);
+	}
+	cap = cxl_cmd_get_partition_info_get_next_persistent_cap(cmd);
+	if (cap != ULLONG_MAX) {
+		jobj = util_json_object_size(cap, flags);
+		if (jobj)
+			json_object_object_add(jpart,
+					"next_persistent_capacity", jobj);
+	}
+	cxl_cmd_unref(cmd);
+
+	/* Retrieve partition info in the IDENTIFY mbox cmd */
+	cmd = cxl_cmd_new_identify(memdev);
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
+	cap = cxl_cmd_identify_get_total_capacity(cmd);
+	if (cap != ULLONG_MAX) {
+		jobj = util_json_object_size(cap, flags);
+		if (jobj)
+			json_object_object_add(jpart, "total_capacity", jobj);
+	}
+	cap = cxl_cmd_identify_get_volatile_only_capacity(cmd);
+	if (cap != ULLONG_MAX) {
+		jobj = util_json_object_size(cap, flags);
+		if (jobj)
+			json_object_object_add(jpart,
+					"volatile_only_capacity", jobj);
+	}
+	cap = cxl_cmd_identify_get_persistent_only_capacity(cmd);
+	if (cap != ULLONG_MAX) {
+		jobj = util_json_object_size(cap, flags);
+		if (jobj)
+			json_object_object_add(jpart,
+					"persistent_only_capacity", jobj);
+	}
+	cap = cxl_cmd_identify_get_partition_align(cmd);
+	jobj = util_json_object_size(cap, flags);
+	if (jobj)
+		json_object_object_add(jpart, "partition_alignment", jobj);
+
+	return jpart;
+
+err_cmd:
+	cxl_cmd_unref(cmd);
+err_jobj:
+	json_object_put(jpart);
+	return NULL;
+}
+
 struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
 		unsigned long flags)
 {
@@ -1643,5 +1750,10 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
 		if (jobj)
 			json_object_object_add(jdev, "health", jobj);
 	}
+	if (flags & UTIL_JSON_PARTITION) {
+		jobj = util_cxl_memdev_partition_to_json(memdev, flags);
+		if (jobj)
+			json_object_object_add(jdev, "partition", jobj);
+	}
 	return jdev;
 }
-- 
2.31.1

