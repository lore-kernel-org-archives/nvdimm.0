Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 02D4121131DDB
 for <linux-nvdimm@lists.01.org>; Mon,  4 Jun 2018 16:33:27 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v3] ndctl, list: display the 'map' location in listings
Date: Mon,  4 Jun 2018 17:33:19 -0600
Message-Id: <20180604233319.10015-1-vishal.l.verma@intel.com>
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
 util/json.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

v3: Further clean up by only setting 'loc' in the switch statement, and
creating the 'jobj' for 'map' later (Dan)

diff --git a/util/json.c b/util/json.c
index c606e1c..94ed948 100644
--- a/util/json.c
+++ b/util/json.c
@@ -666,7 +666,13 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 		unsigned long flags)
 {
 	struct json_object *jndns = json_object_new_object();
+	enum ndctl_pfn_loc loc = NDCTL_PFN_LOC_NONE;
 	struct json_object *jobj, *jbbs = NULL;
+	const char *locations[] = {
+		[NDCTL_PFN_LOC_NONE] = "none",
+		[NDCTL_PFN_LOC_RAM] = "mem",
+		[NDCTL_PFN_LOC_PMEM] = "dev",
+	};
 	unsigned long long size = ULLONG_MAX;
 	unsigned int sector_size = UINT_MAX;
 	enum ndctl_namespace_mode mode;
@@ -693,10 +699,13 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 	mode = ndctl_namespace_get_mode(ndns);
 	switch (mode) {
 	case NDCTL_NS_MODE_MEMORY:
-		if (pfn) /* dynamic memory mode */
+		if (pfn) { /* dynamic memory mode */
 			size = ndctl_pfn_get_size(pfn);
-		else /* native/static memory mode */
+			loc = ndctl_pfn_get_location(pfn);
+		} else { /* native/static memory mode */
 			size = ndctl_namespace_get_size(ndns);
+			loc = NDCTL_PFN_LOC_RAM;
+		}
 		jobj = json_object_new_string("fsdax");
 		break;
 	case NDCTL_NS_MODE_DAX:
@@ -704,6 +713,7 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 			goto err;
 		size = ndctl_dax_get_size(dax);
 		jobj = json_object_new_string("devdax");
+		loc = ndctl_dax_get_location(dax);
 		break;
 	case NDCTL_NS_MODE_SAFE:
 		if (!btt)
@@ -721,6 +731,12 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 	if (jobj)
 		json_object_object_add(jndns, "mode", jobj);
 
+	if ((mode != NDCTL_NS_MODE_SAFE) && (mode != NDCTL_NS_MODE_RAW)) {
+		jobj = json_object_new_string(locations[loc]);
+		if (jobj)
+			json_object_object_add(jndns, "map", jobj);
+	}
+
 	if (size < ULLONG_MAX) {
 		jobj = util_json_object_size(size, flags);
 		if (jobj)
-- 
2.17.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
