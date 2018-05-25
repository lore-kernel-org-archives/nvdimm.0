Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1A8C0203B9900
 for <linux-nvdimm@lists.01.org>; Fri, 25 May 2018 15:36:05 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] ndctl, list: display the 'map' location in listings
Date: Fri, 25 May 2018 16:35:56 -0600
Message-Id: <20180525223556.9244-1-vishal.l.verma@intel.com>
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
Cc: Yigal Korman <Yigal.Korman@netapp.com>
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
 util/json.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/util/json.c b/util/json.c
index c606e1c..17dd90c 100644
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
@@ -749,6 +755,12 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 		jobj = util_raw_uuid(ndns);
 		if (jobj)
 			json_object_object_add(jndns, "raw_uuid", jobj);
+		loc = ndctl_pfn_get_location(pfn);
+		jobj = json_object_new_string(locations[loc]);
+		if (!jobj)
+			goto err;
+		if (jobj)
+			json_object_object_add(jndns, "map", jobj);
 		bdev = ndctl_pfn_get_block_device(pfn);
 	} else if (dax) {
 		struct daxctl_region *dax_region;
@@ -763,6 +775,12 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 		jobj = util_raw_uuid(ndns);
 		if (jobj)
 			json_object_object_add(jndns, "raw_uuid", jobj);
+		loc = ndctl_dax_get_location(dax);
+		jobj = json_object_new_string(locations[loc]);
+		if (!jobj)
+			goto err;
+		if (jobj)
+			json_object_object_add(jndns, "map", jobj);
 		if ((flags & UTIL_JSON_DAX) && dax_region) {
 			jobj = util_daxctl_region_to_json(dax_region, NULL,
 					flags);
-- 
2.17.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
