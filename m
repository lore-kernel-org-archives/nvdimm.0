Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9EC2C82
	for <nvdimm@lists.linux.dev>; Tue, 18 Jan 2022 20:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642537251; x=1674073251;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qOTX1D+R1jhV419hdzUp4XYWbde0zFCZvBd7GlKjnas=;
  b=fIu5DK2ro0ioZohKEkcR+7rmrS15xdMvT2a9uhzh1Oh2UuYPQ9QB201Z
   SCXy5WWRNQ1ixasqih6pANsdumYVrCIB1OmSdjCNtXRHfaCywvLQTIQGD
   Yj8zlsW9JpdlQifLx/ZSsJIr5HypPW3tyXWhR/w1LjIZFEOrYZ01K/0zx
   tbcWri6DvL2sSPcK5PK+tt2Qsvcr4hqf4XmJS5dDlQCe1QSkJYR4fpcuE
   4lN0buuZ5RJy/xXTactwS28UBL+vdqDuJnE8raqalt+GycbiFd+dbL7S9
   ER2gzRQ3LDjNm4Q6f13/6cbgHdWdLFJt2ht00fmYpIILs+ZW0FD6AnuYg
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10231"; a="331259492"
X-IronPort-AV: E=Sophos;i="5.88,298,1635231600"; 
   d="scan'208";a="331259492"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2022 12:20:31 -0800
X-IronPort-AV: E=Sophos;i="5.88,298,1635231600"; 
   d="scan'208";a="671953863"
Received: from alison-desk.jf.intel.com (HELO localhost) ([10.54.74.41])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2022 12:20:31 -0800
From: alison.schofield@intel.com
To: Ben Widawsky <ben.widawsky@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v3 4/6] cxl: add memdev partition information to cxl-list
Date: Tue, 18 Jan 2022 12:25:13 -0800
Message-Id: <5c20a16be96fb402b792b0b23cc1373651cef111.1642535478.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1642535478.git.alison.schofield@intel.com>
References: <cover.1642535478.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

Users may want to check the partition information of a memory device
using the CXL command line tool. This is useful for understanding the
active, as well as creating the next, partition layout.

Add an option the 'cxl list' command to display partition information.
Include all of the fields from GET_PARTITION_INFO and the partitioning
related fields from the IDENTIFY mailbox command.

Example:
    "partition_info":{
      "active_volatile_bytes":273535729664,
      "active_persistent_bytes":0,
      "next_volatile_bytes":0,
      "next_persistent_bytes":0,
      "total_bytes":273535729664,
      "volatile_only_bytes":0,
      "persistent_only_bytes":0,
      "partition_alignment_bytes":268435456
    }

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 Documentation/cxl/cxl-list.txt |  23 +++++++
 cxl/json.c                     | 114 +++++++++++++++++++++++++++++++++
 cxl/list.c                     |   5 ++
 util/json.h                    |   1 +
 4 files changed, 143 insertions(+)

diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
index c8d10fb..912ac11 100644
--- a/Documentation/cxl/cxl-list.txt
+++ b/Documentation/cxl/cxl-list.txt
@@ -85,6 +85,29 @@ OPTIONS
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
+      "active_volatile_bytes":273535729664,
+      "active_persistent_bytes":0,
+      "next_volatile_bytes":0,
+      "next_persistent_bytes":0,
+      "total_bytes":273535729664,
+      "volatile_only_bytes":0,
+      "persistent_only_bytes":0,
+      "partition_alignment_bytes":268435456
+    }
+  }
+]
+----
 
 include::human-option.txt[]
 
diff --git a/cxl/json.c b/cxl/json.c
index e562502..e51a96e 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 // Copyright (C) 2015-2020 Intel Corporation. All rights reserved.
+#include <limits.h>
 #include <util/json.h>
 #include <uuid/uuid.h>
 #include <cxl/libcxl.h>
@@ -183,6 +184,114 @@ err_jobj:
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
+	cap = cxl_cmd_partition_info_get_active_volatile_bytes(cmd);
+	if (cap != ULLONG_MAX) {
+		jobj = util_json_object_size(cap, flags);
+		if (jobj)
+			json_object_object_add(jpart,
+					"active_volatile_bytes", jobj);
+	}
+	cap = cxl_cmd_partition_info_get_active_persistent_bytes(cmd);
+	if (cap != ULLONG_MAX) {
+		jobj = util_json_object_size(cap, flags);
+		if (jobj)
+			json_object_object_add(jpart,
+					"active_persistent_bytes", jobj);
+	}
+	cap = cxl_cmd_partition_info_get_next_volatile_bytes(cmd);
+	if (cap != ULLONG_MAX) {
+		jobj = util_json_object_size(cap, flags);
+		if (jobj)
+			json_object_object_add(jpart,
+					"next_volatile_bytes", jobj);
+	}
+	cap = cxl_cmd_partition_info_get_next_persistent_bytes(cmd);
+	if (cap != ULLONG_MAX) {
+		jobj = util_json_object_size(cap, flags);
+		if (jobj)
+			json_object_object_add(jpart,
+					"next_persistent_bytes", jobj);
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
+	cap = cxl_cmd_identify_get_total_bytes(cmd);
+	if (cap != ULLONG_MAX) {
+		jobj = util_json_object_size(cap, flags);
+		if (jobj)
+			json_object_object_add(jpart, "total_bytes", jobj);
+	}
+	cap = cxl_cmd_identify_get_volatile_only_bytes(cmd);
+	if (cap != ULLONG_MAX) {
+		jobj = util_json_object_size(cap, flags);
+		if (jobj)
+			json_object_object_add(jpart,
+					"volatile_only_bytes", jobj);
+	}
+	cap = cxl_cmd_identify_get_persistent_only_bytes(cmd);
+	if (cap != ULLONG_MAX) {
+		jobj = util_json_object_size(cap, flags);
+		if (jobj)
+			json_object_object_add(jpart,
+					"persistent_only_bytes", jobj);
+	}
+	cap = cxl_cmd_identify_get_partition_align(cmd);
+	jobj = util_json_object_size(cap, flags);
+	if (jobj)
+		json_object_object_add(jpart, "partition_alignment_bytes", jobj);
+
+	cxl_cmd_unref(cmd);
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
@@ -210,5 +319,10 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
 		if (jobj)
 			json_object_object_add(jdev, "health", jobj);
 	}
+	if (flags & UTIL_JSON_PARTITION) {
+		jobj = util_cxl_memdev_partition_to_json(memdev, flags);
+		if (jobj)
+			json_object_object_add(jdev, "partition_info", jobj);
+	}
 	return jdev;
 }
diff --git a/cxl/list.c b/cxl/list.c
index 7f7a04d..73dc390 100644
--- a/cxl/list.c
+++ b/cxl/list.c
@@ -19,6 +19,7 @@ static struct {
 	bool idle;
 	bool human;
 	bool health;
+	bool partition;
 } list;
 
 static unsigned long listopts_to_flags(void)
@@ -31,6 +32,8 @@ static unsigned long listopts_to_flags(void)
 		flags |= UTIL_JSON_HUMAN;
 	if (list.health)
 		flags |= UTIL_JSON_HEALTH;
+	if (list.partition)
+		flags |= UTIL_JSON_PARTITION;
 	return flags;
 }
 
@@ -64,6 +67,8 @@ int cmd_list(int argc, const char **argv, struct cxl_ctx *ctx)
 				"use human friendly number formats "),
 		OPT_BOOLEAN('H', "health", &list.health,
 				"include memory device health information "),
+		OPT_BOOLEAN('I', "partition", &list.partition,
+				"include memory device partition information "),
 		OPT_END(),
 	};
 	const char * const u[] = {
diff --git a/util/json.h b/util/json.h
index 4ca2c89..f198036 100644
--- a/util/json.h
+++ b/util/json.h
@@ -17,6 +17,7 @@ enum util_json_flags {
 	UTIL_JSON_FIRMWARE	= (1 << 8),
 	UTIL_JSON_DAX_MAPPINGS	= (1 << 9),
 	UTIL_JSON_HEALTH	= (1 << 10),
+	UTIL_JSON_PARTITION	= (1 << 11),
 };
 
 struct json_object;
-- 
2.31.1

