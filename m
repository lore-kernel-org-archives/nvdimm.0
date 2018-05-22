Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6F82421BADAB2
 for <linux-nvdimm@lists.01.org>; Tue, 22 May 2018 09:29:10 -0700 (PDT)
Subject: [ndctl PATCH] ndctl: hide null uuids
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 22 May 2018 09:19:13 -0700
Message-ID: <152700595304.1878.15402579458295755554.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Clean up the namespace listing to hide the 'raw_uuid' field when it is
zero.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 util/json.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/util/json.c b/util/json.c
index 1772177a8abd..c606e1cdf770 100644
--- a/util/json.c
+++ b/util/json.c
@@ -652,10 +652,12 @@ static struct json_object *util_dax_badblocks_to_json(struct ndctl_dax *dax,
 
 static struct json_object *util_raw_uuid(struct ndctl_namespace *ndns)
 {
-	uuid_t raw_uuid;
 	char buf[40];
+	uuid_t raw_uuid;
 
 	ndctl_namespace_get_uuid(ndns, raw_uuid);
+	if (uuid_is_null(raw_uuid))
+		return NULL;
 	uuid_unparse(raw_uuid, buf);
 	return json_object_new_string(buf);
 }
@@ -734,9 +736,8 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 		json_object_object_add(jndns, "uuid", jobj);
 
 		jobj = util_raw_uuid(ndns);
-		if (!jobj)
-			goto err;
-		json_object_object_add(jndns, "raw_uuid", jobj);
+		if (jobj)
+			json_object_object_add(jndns, "raw_uuid", jobj);
 		bdev = ndctl_btt_get_block_device(btt);
 	} else if (pfn) {
 		ndctl_pfn_get_uuid(pfn, uuid);
@@ -746,9 +747,8 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 			goto err;
 		json_object_object_add(jndns, "uuid", jobj);
 		jobj = util_raw_uuid(ndns);
-		if (!jobj)
-			goto err;
-		json_object_object_add(jndns, "raw_uuid", jobj);
+		if (jobj)
+			json_object_object_add(jndns, "raw_uuid", jobj);
 		bdev = ndctl_pfn_get_block_device(pfn);
 	} else if (dax) {
 		struct daxctl_region *dax_region;
@@ -761,9 +761,8 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 			goto err;
 		json_object_object_add(jndns, "uuid", jobj);
 		jobj = util_raw_uuid(ndns);
-		if (!jobj)
-			goto err;
-		json_object_object_add(jndns, "raw_uuid", jobj);
+		if (jobj)
+			json_object_object_add(jndns, "raw_uuid", jobj);
 		if ((flags & UTIL_JSON_DAX) && dax_region) {
 			jobj = util_daxctl_region_to_json(dax_region, NULL,
 					flags);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
