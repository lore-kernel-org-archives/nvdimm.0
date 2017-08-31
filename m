Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym02.jp.fujitsu.com (mgwym02.jp.fujitsu.com [211.128.242.41])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4210C2095E01F
 for <linux-nvdimm@lists.01.org>; Wed, 30 Aug 2017 18:29:59 -0700 (PDT)
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
 by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 1E93FAC00BF
 for <linux-nvdimm@lists.01.org>; Thu, 31 Aug 2017 10:31:07 +0900 (JST)
Date: Thu, 31 Aug 2017 10:30:54 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: [ndctl PATCH 5/5] show bad dimm's name by ndctl list command.
In-Reply-To: <20170831102101.DA2C.E1E9C6FF@jp.fujitsu.com>
References: <20170831102101.DA2C.E1E9C6FF@jp.fujitsu.com>
Message-Id: <20170831103051.DA3E.E1E9C6FF@jp.fujitsu.com>
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


Show dimm's name which has badblock by ndctl list command.
This patch uses translate SPA interface to get bad dimm info.


Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
---
 util/json.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/util/json.c b/util/json.c
index 98165b7..dbeb7ef 100644
--- a/util/json.c
+++ b/util/json.c
@@ -27,6 +27,8 @@
 #include <ndctl.h>
 #endif
 
+#include <ndctl/lib/libndctl-nfit.h>
+
 /* adapted from mdadm::human_size_brief() */
 static int display_size(struct json_object *jobj, struct printbuf *pbuf,
 		int level, int flags)
@@ -366,6 +368,15 @@ struct json_object *util_daxctl_region_to_json(struct daxctl_region *region,
 	return NULL;
 }
 
+static struct ndctl_dimm *badblock_to_dimm(struct ndctl_region *region,
+		unsigned long long spa)
+{
+	struct ndctl_bus *bus;
+
+	bus = ndctl_region_get_bus(region);
+	return ndctl_dimm_get_by_spa(bus, spa);
+}
+
 struct json_object *util_region_badblocks_to_json(struct ndctl_region *region,
 		unsigned int *bb_count, unsigned long flags)
 {
@@ -381,6 +392,18 @@ struct json_object *util_region_badblocks_to_json(struct ndctl_region *region,
 
 	ndctl_region_badblock_foreach(region, bb) {
 		if (flags & UTIL_JSON_MEDIA_ERRORS) {
+			struct ndctl_dimm *dimm = NULL;
+			unsigned long long spa;
+
+			/* get start address of region */
+			spa = ndctl_region_get_resource(region);
+			if (spa == ULONG_MAX)
+				goto err_array;
+
+			/* get address of bad block */
+			spa += bb->offset << 9;
+			dimm = badblock_to_dimm(region, spa);
+
 			jbb = json_object_new_object();
 			if (!jbb)
 				goto err_array;
@@ -395,6 +418,12 @@ struct json_object *util_region_badblocks_to_json(struct ndctl_region *region,
 				goto err;
 			json_object_object_add(jbb, "length", jobj);
 
+			if (dimm) {
+				jobj = json_object_new_string(ndctl_dimm_get_devname(dimm));
+				if (!jobj)
+					goto err;
+				json_object_object_add(jbb, "dimm", jobj);
+			}
 			json_object_array_add(jbbs, jbb);
 		}
 
@@ -436,6 +465,7 @@ static struct json_object *dev_badblocks_to_json(struct ndctl_region *region,
 
 	ndctl_region_badblock_foreach(region, bb) {
 		unsigned long long bb_begin, bb_end, begin, end;
+		struct ndctl_dimm *dimm = NULL;
 
 		bb_begin = region_begin + (bb->offset << 9);
 		bb_end = bb_begin + (bb->len << 9) - 1;
@@ -456,6 +486,8 @@ static struct json_object *dev_badblocks_to_json(struct ndctl_region *region,
 		offset = (begin - dev_begin) >> 9;
 		len = (end - begin + 1) >> 9;
 
+		dimm = badblock_to_dimm(region, begin);
+
 		if (flags & UTIL_JSON_MEDIA_ERRORS) {
 			/* add to json */
 			jbb = json_object_new_object();
@@ -472,6 +504,13 @@ static struct json_object *dev_badblocks_to_json(struct ndctl_region *region,
 				goto err;
 			json_object_object_add(jbb, "length", jobj);
 
+			if (dimm) {
+				jobj = json_object_new_string(ndctl_dimm_get_devname(dimm));
+				if (!jobj)
+					goto err;
+				json_object_object_add(jbb, "dimm", jobj);
+			}
+
 			json_object_array_add(jbbs, jbb);
 		}
 		bbs += len;



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
