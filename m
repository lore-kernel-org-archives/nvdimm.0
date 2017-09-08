Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ED02421A143F5
 for <linux-nvdimm@lists.01.org>; Fri,  8 Sep 2017 15:29:26 -0700 (PDT)
Subject: [ndctl PATCH 1/2] ndctl: reduce indentation in
 util_region_badblocks_to_json / dev_badblocks_to_json
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 08 Sep 2017 15:25:55 -0700
Message-ID: <150490955511.8621.11056333479696382004.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: y-goto@jp.fujitsu.com
List-ID: <linux-nvdimm@lists.01.org>

Use a 'continue' to out-dent the badblock parsing code block.

Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 util/json.c |  108 +++++++++++++++++++++++++++++++----------------------------
 1 file changed, 57 insertions(+), 51 deletions(-)

diff --git a/util/json.c b/util/json.c
index 639f0ff043ca..1d1727c1c062 100644
--- a/util/json.c
+++ b/util/json.c
@@ -389,43 +389,46 @@ struct json_object *util_region_badblocks_to_json(struct ndctl_region *region,
 	}
 
 	ndctl_region_badblock_foreach(region, bb) {
-		if (flags & UTIL_JSON_MEDIA_ERRORS) {
-			struct ndctl_dimm *dimm = NULL;
-			unsigned long long spa;
+		struct ndctl_dimm *dimm;
+		unsigned long long addr;
+		const char *devname;
 
-			/* get start address of region */
-			spa = ndctl_region_get_resource(region);
-			if (spa == ULONG_MAX)
-				goto err_array;
+		bbs += bb->len;
 
-			/* get address of bad block */
-			spa += bb->offset << 9;
-			dimm = badblock_to_dimm(region, spa);
+		if (!(flags & UTIL_JSON_MEDIA_ERRORS))
+			continue;
 
-			jbb = json_object_new_object();
-			if (!jbb)
-				goto err_array;
+		/* get start address of region */
+		addr = ndctl_region_get_resource(region);
+		if (addr == ULONG_MAX)
+			goto err_array;
 
-			jobj = json_object_new_int64(bb->offset);
-			if (!jobj)
-				goto err;
-			json_object_object_add(jbb, "offset", jobj);
+		/* get address of bad block */
+		addr += bb->offset << 9;
+		dimm = badblock_to_dimm(region, addr);
+
+		jbb = json_object_new_object();
+		if (!jbb)
+			goto err_array;
+
+		jobj = json_object_new_int64(bb->offset);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jbb, "offset", jobj);
+
+		jobj = json_object_new_int(bb->len);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jbb, "length", jobj);
 
-			jobj = json_object_new_int(bb->len);
+		if (dimm) {
+			devname = ndctl_dimm_get_devname(dimm);
+			jobj = json_object_new_string(devname);
 			if (!jobj)
 				goto err;
-			json_object_object_add(jbb, "length", jobj);
-
-			if (dimm) {
-				jobj = json_object_new_string(ndctl_dimm_get_devname(dimm));
-				if (!jobj)
-					goto err;
-				json_object_object_add(jbb, "dimm", jobj);
-			}
-			json_object_array_add(jbbs, jbb);
+			json_object_object_add(jbb, "dimm", jobj);
 		}
-
-		bbs += bb->len;
+		json_object_array_add(jbbs, jbb);
 	}
 
 	*bb_count = bbs;
@@ -463,7 +466,8 @@ static struct json_object *dev_badblocks_to_json(struct ndctl_region *region,
 
 	ndctl_region_badblock_foreach(region, bb) {
 		unsigned long long bb_begin, bb_end, begin, end;
-		struct ndctl_dimm *dimm = NULL;
+		struct ndctl_dimm *dimm;
+		const char *devname;
 
 		bb_begin = region_begin + (bb->offset << 9);
 		bb_end = bb_begin + (bb->len << 9) - 1;
@@ -486,32 +490,34 @@ static struct json_object *dev_badblocks_to_json(struct ndctl_region *region,
 
 		dimm = badblock_to_dimm(region, begin);
 
-		if (flags & UTIL_JSON_MEDIA_ERRORS) {
-			/* add to json */
-			jbb = json_object_new_object();
-			if (!jbb)
-				goto err_array;
+		bbs += len;
+
+		if (!(flags & UTIL_JSON_MEDIA_ERRORS))
+			continue;
 
-			jobj = json_object_new_int64(offset);
-			if (!jobj)
-				goto err;
-			json_object_object_add(jbb, "offset", jobj);
+		jbb = json_object_new_object();
+		if (!jbb)
+			goto err_array;
 
-			jobj = json_object_new_int(len);
-			if (!jobj)
-				goto err;
-			json_object_object_add(jbb, "length", jobj);
+		jobj = json_object_new_int64(offset);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jbb, "offset", jobj);
 
-			if (dimm) {
-				jobj = json_object_new_string(ndctl_dimm_get_devname(dimm));
-				if (!jobj)
-					goto err;
-				json_object_object_add(jbb, "dimm", jobj);
-			}
+		jobj = json_object_new_int(len);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jbb, "length", jobj);
 
-			json_object_array_add(jbbs, jbb);
+		if (dimm) {
+			devname = ndctl_dimm_get_devname(dimm);
+			jobj = json_object_new_string(devname);
+			if (!jobj)
+				goto err;
+			json_object_object_add(jbb, "dimm", jobj);
 		}
-		bbs += len;
+
+		json_object_array_add(jbbs, jbb);
 	}
 
 	*bb_count = bbs;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
