Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D6ED221A143F5
 for <linux-nvdimm@lists.01.org>; Fri,  8 Sep 2017 15:29:31 -0700 (PDT)
Subject: [ndctl PATCH 2/2] ndctl: support multiple dimms when translating
 badblock ranges
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 08 Sep 2017 15:26:00 -0700
Message-ID: <150490956040.8621.9918102309170733621.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150490955511.8621.11056333479696382004.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150490955511.8621.11056333479696382004.stgit@dwillia2-desk3.amr.corp.intel.com>
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

A badblock range reported in a region may span multiple DIMMs in an
interleave set, so check every 512 bytes in the error range for a unique
dimm.

Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 util/json.c |   84 +++++++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 58 insertions(+), 26 deletions(-)

diff --git a/util/json.c b/util/json.c
index 1d1727c1c062..9b7773e1c076 100644
--- a/util/json.c
+++ b/util/json.c
@@ -366,13 +366,58 @@ struct json_object *util_daxctl_region_to_json(struct daxctl_region *region,
 	return NULL;
 }
 
-static struct ndctl_dimm *badblock_to_dimm(struct ndctl_region *region,
-		unsigned long long spa)
+static struct json_object *badblocks_to_jdimms(struct ndctl_region *region,
+		unsigned long long addr, unsigned long len)
 {
-	struct ndctl_bus *bus;
+	struct ndctl_bus *bus = ndctl_region_get_bus(region);
+	int count = ndctl_region_get_interleave_ways(region);
+	unsigned long long end = addr + len;
+	struct json_object *jdimms, *jobj;
+	struct ndctl_dimm **dimms, *dimm;
+	int found, i;
+
+	jdimms = json_object_new_array();
+	if (!jdimms)
+		return NULL;
+
+	dimms = calloc(count, sizeof(struct ndctl_dimm *));
+	if (!dimms)
+		goto err_dimms;
+
+	for (found = 0; found < count && addr < end; addr += 512) {
+		dimm = ndctl_bus_get_dimm_by_physical_address(bus, addr);
+		if (!dimm)
+			continue;
+
+		for (i = 0; i < count; i++)
+			if (dimms[i] == dimm)
+				break;
+		if (i >= count)
+			dimms[found++] = dimm;
+	}
+
+	if (!found)
+		goto err_found;
+
+	for (i = 0; i < found; i++) {
+		const char *devname = ndctl_dimm_get_devname(dimms[i]);
+
+		jobj = json_object_new_string(devname);
+		if (!jobj)
+			break;
+		json_object_array_add(jdimms, jobj);
+	}
+
+	if (!i)
+		goto err_found;
+	free(dimms);
+	return jdimms;
 
-	bus = ndctl_region_get_bus(region);
-	return ndctl_bus_get_dimm_by_physical_address(bus, spa);
+err_found:
+	free(dimms);
+err_dimms:
+	json_object_put(jdimms);
+	return NULL;
 }
 
 struct json_object *util_region_badblocks_to_json(struct ndctl_region *region,
@@ -389,9 +434,8 @@ struct json_object *util_region_badblocks_to_json(struct ndctl_region *region,
 	}
 
 	ndctl_region_badblock_foreach(region, bb) {
-		struct ndctl_dimm *dimm;
+		struct json_object *jdimms;
 		unsigned long long addr;
-		const char *devname;
 
 		bbs += bb->len;
 
@@ -405,7 +449,6 @@ struct json_object *util_region_badblocks_to_json(struct ndctl_region *region,
 
 		/* get address of bad block */
 		addr += bb->offset << 9;
-		dimm = badblock_to_dimm(region, addr);
 
 		jbb = json_object_new_object();
 		if (!jbb)
@@ -421,13 +464,9 @@ struct json_object *util_region_badblocks_to_json(struct ndctl_region *region,
 			goto err;
 		json_object_object_add(jbb, "length", jobj);
 
-		if (dimm) {
-			devname = ndctl_dimm_get_devname(dimm);
-			jobj = json_object_new_string(devname);
-			if (!jobj)
-				goto err;
-			json_object_object_add(jbb, "dimm", jobj);
-		}
+		jdimms = badblocks_to_jdimms(region, addr, bb->len << 9);
+		if (jdimms)
+			json_object_object_add(jbb, "dimms", jdimms);
 		json_object_array_add(jbbs, jbb);
 	}
 
@@ -466,8 +505,7 @@ static struct json_object *dev_badblocks_to_json(struct ndctl_region *region,
 
 	ndctl_region_badblock_foreach(region, bb) {
 		unsigned long long bb_begin, bb_end, begin, end;
-		struct ndctl_dimm *dimm;
-		const char *devname;
+		struct json_object *jdimms;
 
 		bb_begin = region_begin + (bb->offset << 9);
 		bb_end = bb_begin + (bb->len << 9) - 1;
@@ -488,8 +526,6 @@ static struct json_object *dev_badblocks_to_json(struct ndctl_region *region,
 		offset = (begin - dev_begin) >> 9;
 		len = (end - begin + 1) >> 9;
 
-		dimm = badblock_to_dimm(region, begin);
-
 		bbs += len;
 
 		if (!(flags & UTIL_JSON_MEDIA_ERRORS))
@@ -509,13 +545,9 @@ static struct json_object *dev_badblocks_to_json(struct ndctl_region *region,
 			goto err;
 		json_object_object_add(jbb, "length", jobj);
 
-		if (dimm) {
-			devname = ndctl_dimm_get_devname(dimm);
-			jobj = json_object_new_string(devname);
-			if (!jobj)
-				goto err;
-			json_object_object_add(jbb, "dimm", jobj);
-		}
+		jdimms = badblocks_to_jdimms(region, begin, len << 9);
+		if (jdimms)
+			json_object_object_add(jbb, "dimms", jdimms);
 
 		json_object_array_add(jbbs, jbb);
 	}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
