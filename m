Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5915621A00AE6
 for <linux-nvdimm@lists.01.org>; Wed,  3 Oct 2018 11:16:07 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v2 5/5] util/json: add a
 util_namespace_badblocks_to_json() helper
Date: Wed,  3 Oct 2018 12:15:06 -0600
Message-Id: <20181003181506.17682-5-vishal.l.verma@intel.com>
In-Reply-To: <20181003181506.17682-1-vishal.l.verma@intel.com>
References: <20181003181506.17682-1-vishal.l.verma@intel.com>
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
List-ID: <linux-nvdimm@lists.01.org>

When ndctl list --media-errors is invoked, we rely upon the 'region'
badblocks provided by the kernel, and reference them against the
namespace start to report namespace badblocks. This can fail for
non-root users, as the region and namespace resource information is
root-only. However the kernel also provides block-device badblocks
information in sysfs, and that is world readable. Provide a new helper
to retrieve this information, and use it as a fallback when the region
based badblocks are unavailable.

Note that when falling back to the namespace based badblocks, we are
unable to retrieve the DIMM on which the badblocks are present, since we
still need root privileges for both getting the resource information,
and for the address translation command.

Cc: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 util/json.c | 63 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 60 insertions(+), 3 deletions(-)

diff --git a/util/json.c b/util/json.c
index 702ccf4..5c3424e 100644
--- a/util/json.c
+++ b/util/json.c
@@ -509,6 +509,56 @@ struct json_object *util_region_badblocks_to_json(struct ndctl_region *region,
 	return NULL;
 }
 
+static struct json_object *util_namespace_badblocks_to_json(
+			struct ndctl_namespace *ndns,
+			unsigned int *bb_count, unsigned long flags)
+{
+	struct json_object *jbb = NULL, *jbbs = NULL, *jobj;
+	struct badblock *bb;
+	int bbs = 0;
+
+	if (flags & UTIL_JSON_MEDIA_ERRORS) {
+		jbbs = json_object_new_array();
+		if (!jbbs)
+			return NULL;
+	} else
+		return NULL;
+
+	ndctl_namespace_badblock_foreach(ndns, bb) {
+		bbs += bb->len;
+
+		/* recheck so we can still get the badblocks_count from above */
+		if (!(flags & UTIL_JSON_MEDIA_ERRORS))
+			continue;
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
+		json_object_array_add(jbbs, jbb);
+	}
+
+	*bb_count = bbs;
+
+	if (bbs)
+		return jbbs;
+
+ err:
+	json_object_put(jbb);
+ err_array:
+	json_object_put(jbbs);
+	return NULL;
+}
+
 static struct json_object *dev_badblocks_to_json(struct ndctl_region *region,
 		unsigned long long dev_begin, unsigned long long dev_size,
 		unsigned int *bb_count, unsigned long flags)
@@ -599,8 +649,11 @@ static struct json_object *util_pfn_badblocks_to_json(struct ndctl_pfn *pfn,
 	unsigned long long pfn_begin, pfn_size;
 
 	pfn_begin = ndctl_pfn_get_resource(pfn);
-	if (pfn_begin == ULLONG_MAX)
-		return NULL;
+	if (pfn_begin == ULLONG_MAX) {
+		struct ndctl_namespace *ndns = ndctl_pfn_get_namespace(pfn);
+
+		return util_namespace_badblocks_to_json(ndns, bb_count, flags);
+	}
 
 	pfn_size = ndctl_pfn_get_size(pfn);
 	if (pfn_size == ULLONG_MAX)
@@ -879,10 +932,14 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 		jbbs = util_dax_badblocks_to_json(dax, &bb_count, flags);
 	else if (btt)
 		util_btt_badblocks_to_json(btt, &bb_count);
-	else
+	else {
 		jbbs = util_region_badblocks_to_json(
 				ndctl_namespace_get_region(ndns), &bb_count,
 				flags);
+		if (!jbbs)
+			jbbs = util_namespace_badblocks_to_json(ndns, &bb_count,
+					flags);
+	}
 
 	if (bb_count) {
 		jobj = json_object_new_int(bb_count);
-- 
2.17.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
