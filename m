Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 18CFC21A16E28
 for <linux-nvdimm@lists.01.org>; Thu, 11 May 2017 15:07:38 -0700 (PDT)
Subject: [ndctl PATCH 4/4] ndctl, list: hide badblock_count by default
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 11 May 2017 15:01:46 -0700
Message-ID: <149454010604.30857.15214297566335127724.stgit@dwillia2-desk3.amr.corp.intel.com>
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

In order to keep the default listing as compact as possible, hide
badblock_count when it is zero.

Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Toshi Kani <toshi.kani@hpe.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/list.c |   12 +++++++-----
 util/json.c  |   14 ++++++++------
 2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/ndctl/list.c b/ndctl/list.c
index cf26d8c08183..befb3cfc6ffd 100644
--- a/ndctl/list.c
+++ b/ndctl/list.c
@@ -209,12 +209,14 @@ static struct json_object *region_to_json(struct ndctl_region *region,
 
 	jbbs = util_region_badblocks_to_json(region, include_media_errors,
 			&bb_count);
-	jobj = json_object_new_int(bb_count);
-	if (!jobj) {
-		json_object_put(jbbs);
-		goto err;
+	if (bb_count) {
+		jobj = json_object_new_int(bb_count);
+		if (!jobj) {
+			json_object_put(jbbs);
+			goto err;
+		}
+		json_object_object_add(jregion, "badblock_count", jobj);
 	}
-	json_object_object_add(jregion, "badblock_count", jobj);
 	if (include_media_errors && jbbs)
 		json_object_object_add(jregion, "badblocks", jbbs);
 
diff --git a/util/json.c b/util/json.c
index 17595267c34c..4ca33a628381 100644
--- a/util/json.c
+++ b/util/json.c
@@ -568,15 +568,17 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 				ndctl_namespace_get_region(ndns),
 				include_media_errors, &bb_count);
 
-	jobj = json_object_new_int(bb_count);
-	if (!jobj) {
-		json_object_put(jbbs);
-		goto err;
+	if (bb_count) {
+		jobj = json_object_new_int(bb_count);
+		if (!jobj) {
+			json_object_put(jbbs);
+			goto err;
+		}
+		json_object_object_add(jndns, "badblock_count", jobj);
 	}
 
-	json_object_object_add(jndns, "badblock_count", jobj);
 	if (include_media_errors && jbbs)
-			json_object_object_add(jndns, "badblocks", jbbs);
+		json_object_object_add(jndns, "badblocks", jbbs);
 
 	return jndns;
  err:

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
