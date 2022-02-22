Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F072B7B
	for <nvdimm@lists.linux.dev>; Tue, 22 Feb 2022 18:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645553992; x=1677089992;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0rEXS1BuAw97LDr61nE2Cke/w1FyXu3aaZfWJ2BEyvY=;
  b=X0seOzilRr79f7rk3DhZLWoLkHxzHs+hZfnBkGTFbV4zj5xjBdD08PYE
   hs6jd4nwdaC9y6LjGF6w4TuIE55YwNgv8QfcaGSmvl7gqlmjGmjYXMi57
   4qj0vOhLpwC2WcJTsh1tJ7A0WNZ7uUcnK9xxxDQb9E1T4kik/HJzwqUao
   qtfvVXCOYNMruEzUVOCP7JypQVdvQb3/zQcf+FgxHQdFqMtGZa39FbkcG
   W07g3UfrX24abQsnXk+bKJqFcOwL8qJTfRB5PTmwBBf60WR+koDLI+PYQ
   ldW5uwDusI3ZLZg386IDpSegk0xqmHPKnl+aliBCin1c828SjxixWiAce
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10266"; a="251695797"
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="251695797"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 10:19:52 -0800
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="532333094"
Received: from alison-desk.jf.intel.com (HELO localhost) ([10.54.74.41])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 10:19:51 -0800
From: alison.schofield@intel.com
To: Ben Widawsky <ben.widawsky@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH] cxl/list: Handle GET_PARTITION_INFO command as optional
Date: Tue, 22 Feb 2022 10:23:28 -0800
Message-Id: <20220222182328.1009333-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

CXL specifies GET_PARTITION_INFO mailbox command as optional. A device
may not support the command when it has no partitionable space.

Flip the order in which the command cxl-list retrieves the partition
info so that the fields reported by the IDENTIFY mailbox command are
always reported, and then the fields reported by the GET_PARTITION_INFO
mailbox command are optionally reported.

Fixes: 7581aba52da0 ("cxl: add memdev partition information to cxl-list")
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---

Vishal, I wasn't sure whether to rev the original patchset or post as a
fix. Let me know.


 cxl/json.c | 97 +++++++++++++++++++++++++++++-------------------------
 1 file changed, 52 insertions(+), 45 deletions(-)

diff --git a/cxl/json.c b/cxl/json.c
index 69671b3e7fe9..fdc6f73a86c1 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -204,48 +204,6 @@ static struct json_object *util_cxl_memdev_partition_to_json(struct cxl_memdev *
 	if (!memdev)
 		goto err_jobj;
 
-	/* Retrieve partition info in GET_PARTITION_INFO mbox cmd */
-	cmd = cxl_cmd_new_get_partition(memdev);
-	if (!cmd)
-		goto err_jobj;
-
-	rc = cxl_cmd_submit(cmd);
-	if (rc < 0)
-		goto err_cmd;
-	rc = cxl_cmd_get_mbox_status(cmd);
-	if (rc != 0)
-		goto err_cmd;
-
-	cap = cxl_cmd_partition_get_active_volatile_size(cmd);
-	if (cap != ULLONG_MAX) {
-		jobj = util_json_object_size(cap, flags);
-		if (jobj)
-			json_object_object_add(jpart,
-					"active_volatile_size", jobj);
-	}
-	cap = cxl_cmd_partition_get_active_persistent_size(cmd);
-	if (cap != ULLONG_MAX) {
-		jobj = util_json_object_size(cap, flags);
-		if (jobj)
-			json_object_object_add(jpart,
-					"active_persistent_size", jobj);
-	}
-	cap = cxl_cmd_partition_get_next_volatile_size(cmd);
-	if (cap != ULLONG_MAX) {
-		jobj = util_json_object_size(cap, flags);
-		if (jobj)
-			json_object_object_add(jpart,
-					"next_volatile_size", jobj);
-	}
-	cap = cxl_cmd_partition_get_next_persistent_size(cmd);
-	if (cap != ULLONG_MAX) {
-		jobj = util_json_object_size(cap, flags);
-		if (jobj)
-			json_object_object_add(jpart,
-					"next_persistent_size", jobj);
-	}
-	cxl_cmd_unref(cmd);
-
 	/* Retrieve partition info in the IDENTIFY mbox cmd */
 	cmd = cxl_cmd_new_identify(memdev);
 	if (!cmd)
@@ -253,10 +211,10 @@ static struct json_object *util_cxl_memdev_partition_to_json(struct cxl_memdev *
 
 	rc = cxl_cmd_submit(cmd);
 	if (rc < 0)
-		goto err_cmd;
+		goto err_identify;
 	rc = cxl_cmd_get_mbox_status(cmd);
 	if (rc != 0)
-		goto err_cmd;
+		goto err_identify;
 
 	cap = cxl_cmd_identify_get_total_size(cmd);
 	if (cap != ULLONG_MAX) {
@@ -284,10 +242,59 @@ static struct json_object *util_cxl_memdev_partition_to_json(struct cxl_memdev *
 		json_object_object_add(jpart, "partition_alignment_size", jobj);
 
 	cxl_cmd_unref(cmd);
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
 	return jpart;
 
-err_cmd:
+err_identify:
 	cxl_cmd_unref(cmd);
+
 err_jobj:
 	json_object_put(jpart);
 	return NULL;
-- 
2.31.1

