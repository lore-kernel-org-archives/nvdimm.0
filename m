Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5EC0B2007E80E
 for <linux-nvdimm@lists.01.org>; Tue, 29 May 2018 16:15:35 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v2] ndctl, list: display the 'map' location in listings
Date: Tue, 29 May 2018 17:15:03 -0600
Message-Id: <20180529231503.31710-1-vishal.l.verma@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
Cc: Yigal Korman <yigal.korman@netapp.com>
List-ID: <linux-nvdimm@lists.01.org>

For 'fsdax' and 'devdax' namespaces, a 'map' location may be specified
for page structures storage. This can be 'mem', for system RAM, or 'dev'
for using pmem as the backing storage. Once set, there was no way of
telling using ndctl, which of the two locations a namespace was
configured for. Add this in util_namespace_to_json so that all
namespace listings contain the map location.

Reported-by: "Yigal Korman" <yigal.korman@netapp.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 util/json.c | 32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

v2: Also account for memmap=ss!nn or legacy-e820 namespaces. (Dan)

diff --git a/util/json.c b/util/json.c
index c606e1c..b020300 100644
--- a/util/json.c
+++ b/util/json.c
@@ -667,11 +667,17 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 {
 	struct json_object *jndns = json_object_new_object();
 	struct json_object *jobj, *jbbs = NULL;
+	const char *locations[] = {
+		[NDCTL_PFN_LOC_NONE] = "none",
+		[NDCTL_PFN_LOC_RAM] = "mem",
+		[NDCTL_PFN_LOC_PMEM] = "dev",
+	};
 	unsigned long long size = ULLONG_MAX;
 	unsigned int sector_size = UINT_MAX;
 	enum ndctl_namespace_mode mode;
 	const char *bdev = NULL, *name;
 	unsigned int bb_count = 0;
+	enum ndctl_pfn_loc loc;
 	struct ndctl_btt *btt;
 	struct ndctl_pfn *pfn;
 	struct ndctl_dax *dax;
@@ -693,33 +699,49 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 	mode = ndctl_namespace_get_mode(ndns);
 	switch (mode) {
 	case NDCTL_NS_MODE_MEMORY:
-		if (pfn) /* dynamic memory mode */
+		jobj = json_object_new_string("fsdax");
+		if (jobj)
+			json_object_object_add(jndns, "mode", jobj);
+		loc = ndctl_pfn_get_location(pfn);
+		if (pfn) { /* dynamic memory mode */
 			size = ndctl_pfn_get_size(pfn);
-		else /* native/static memory mode */
+			jobj = json_object_new_string(locations[loc]);
+		} else { /* native/static memory mode */
 			size = ndctl_namespace_get_size(ndns);
-		jobj = json_object_new_string("fsdax");
+			jobj = json_object_new_string("mem");
+		}
+		if (jobj)
+			json_object_object_add(jndns, "map", jobj);
 		break;
 	case NDCTL_NS_MODE_DAX:
 		if (!dax)
 			goto err;
 		size = ndctl_dax_get_size(dax);
 		jobj = json_object_new_string("devdax");
+		if (jobj)
+			json_object_object_add(jndns, "mode", jobj);
+		loc = ndctl_dax_get_location(dax);
+		jobj = json_object_new_string(locations[loc]);
+		if (jobj)
+			json_object_object_add(jndns, "map", jobj);
 		break;
 	case NDCTL_NS_MODE_SAFE:
 		if (!btt)
 			goto err;
 		jobj = json_object_new_string("sector");
+		if (jobj)
+			json_object_object_add(jndns, "mode", jobj);
 		size = ndctl_btt_get_size(btt);
 		break;
 	case NDCTL_NS_MODE_RAW:
 		size = ndctl_namespace_get_size(ndns);
 		jobj = json_object_new_string("raw");
+		if (jobj)
+			json_object_object_add(jndns, "mode", jobj);
 		break;
 	default:
 		jobj = NULL;
 	}
-	if (jobj)
-		json_object_object_add(jndns, "mode", jobj);
 
 	if (size < ULLONG_MAX) {
 		jobj = util_json_object_size(size, flags);
-- 
2.17.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
