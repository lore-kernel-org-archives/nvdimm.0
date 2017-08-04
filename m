Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym01.jp.fujitsu.com (mgwym01.jp.fujitsu.com [211.128.242.40])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7467B21E1DAEC
 for <linux-nvdimm@lists.01.org>; Fri,  4 Aug 2017 02:11:49 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 7503BAC039A
 for <linux-nvdimm@lists.01.org>; Fri,  4 Aug 2017 18:13:58 +0900 (JST)
Date: Fri, 04 Aug 2017 18:13:54 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: [RFC/Patch 5/5] ndctl: show dimm's name which has badblock by ndctl
 list command.
In-Reply-To: <20170804180231.27BC.E1E9C6FF@jp.fujitsu.com>
References: <20170804180231.27BC.E1E9C6FF@jp.fujitsu.com>
Message-Id: <20170804181353.27CF.E1E9C6FF@jp.fujitsu.com>
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
To: NVDIMM-ML <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

ndctl: show dimm's name which has badblock by ndctl list command.

This patch uses translate SPA interface to get bad dimm info.

Since this patch is likely Proof of Concept,
because libnvdimm functions of this feature will change yet.
So, I don't think this patch can be merged.

However, I hope this patch is good start for discussion....



Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
---
 util/json.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/util/json.c b/util/json.c
index 2b2b5af..b791054 100644
--- a/util/json.c
+++ b/util/json.c
@@ -381,6 +381,22 @@ struct json_object *util_region_badblocks_to_json(struct ndctl_region *region,
 
 	ndctl_region_badblock_foreach(region, bb) {
 		if (flags & UTIL_JSON_MEDIA_ERRORS) {
+			struct ndctl_bus *bus;
+			struct ndctl_dimm *dimms[ND_MIRROR_MAX_WAY];
+			memset(dimms, 0, sizeof(dimms));
+			bus = ndctl_region_get_bus(region);
+			if (ndctl_bus_has_trans_spa(bus)) {
+				int rc;
+				unsigned long long spa;
+				spa = ndctl_region_get_resource(region);
+				if (spa == ULONG_MAX)
+					goto err_array;
+				spa += bb->offset << 9;
+				rc = ndctl_dimms_get_by_spa(bus, spa, dimms);
+				if (rc)
+					goto err_array;
+			}
+
 			jbb = json_object_new_object();
 			if (!jbb)
 				goto err_array;
@@ -395,6 +411,14 @@ struct json_object *util_region_badblocks_to_json(struct ndctl_region *region,
 				goto err;
 			json_object_object_add(jbb, "length", jobj);
 
+			for (int i = 0; i < ND_MIRROR_MAX_WAY; i++) {
+				if (dimms[i]) {
+					jobj = json_object_new_string(ndctl_dimm_get_devname(dimms[i]));
+					if (!jobj)
+						goto err;
+					json_object_object_add(jbb, "dimm", jobj);
+				}
+			}
 			json_object_array_add(jbbs, jbb);
 		}
 
@@ -436,6 +460,8 @@ static struct json_object *dev_badblocks_to_json(struct ndctl_region *region,
 
 	ndctl_region_badblock_foreach(region, bb) {
 		unsigned long long bb_begin, bb_end, begin, end;
+		struct ndctl_bus *bus;
+		struct ndctl_dimm *dimms[ND_MIRROR_MAX_WAY];
 
 		bb_begin = region_begin + (bb->offset << 9);
 		bb_end = bb_begin + (bb->len << 9) - 1;
@@ -453,6 +479,20 @@ static struct json_object *dev_badblocks_to_json(struct ndctl_region *region,
 		else
 			end = bb_end;
 
+		memset(dimms, 0, sizeof(dimms));
+		bus = ndctl_region_get_bus(region);
+		if (ndctl_bus_has_trans_spa(bus)) {
+			int rc;
+			unsigned long long spa;
+			spa = ndctl_region_get_resource(region);
+			if (spa == ULLONG_MAX)
+				goto err_array;
+			spa += bb->offset << 9;
+			rc = ndctl_dimms_get_by_spa(bus, spa, dimms);
+			if (rc)
+				goto err_array;
+		}
+
 		offset = (begin - dev_begin) >> 9;
 		len = (end - begin + 1) >> 9;
 
@@ -472,6 +512,15 @@ static struct json_object *dev_badblocks_to_json(struct ndctl_region *region,
 				goto err;
 			json_object_object_add(jbb, "length", jobj);
 
+			for (int i = 1; i < ND_MIRROR_MAX_WAY; i++) {
+				if (dimms[i]) {
+					jobj = json_object_new_string(ndctl_dimm_get_devname(dimms[i]));
+					if (!jobj)
+						goto err;
+					json_object_object_add(jbb, "dimm", jobj);
+				}
+			}
+
 			json_object_array_add(jbbs, jbb);
 		}
 		bbs += len;



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
