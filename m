Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com
 [IPv6:2607:f8b0:4864:20::444])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4C599211B7F66
 for <linux-nvdimm@lists.01.org>; Wed, 16 Jan 2019 01:49:33 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id u6so2813629pfh.11
 for <linux-nvdimm@lists.01.org>; Wed, 16 Jan 2019 01:49:33 -0800 (PST)
From: Oliver O'Halloran <oohall@gmail.com>
Subject: [PATCH v3 6/6] ndctl: Add supported_alignments to the JSON output
Date: Wed, 16 Jan 2019 20:49:09 +1100
Message-Id: <20190116094909.23112-6-oohall@gmail.com>
In-Reply-To: <20190116094909.23112-1-oohall@gmail.com>
References: <20190116094909.23112-1-oohall@gmail.com>
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

Add the list of supported alignemnts to PFN and DAX namespaces. Also add the
list of supported sector sizes to BTT namespaces.

Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
---
Not sure the namespace JSON blob are the best place to put these. The
region might be better, but slightly less accessable to users.
---
 util/json.c | 48 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 47 insertions(+), 1 deletion(-)

diff --git a/util/json.c b/util/json.c
index 77c96fb53c27..6c66033bd312 100644
--- a/util/json.c
+++ b/util/json.c
@@ -303,6 +303,38 @@ struct json_object *util_daxctl_devs_to_list(struct daxctl_region *region,
 	return jdevs;
 }
 
+#define _SZ(get_max, get_elem, type) \
+static struct json_object *type##_build_size_array(struct type *arg)	\
+{								\
+	struct json_object *arr = json_object_new_array();	\
+	int i;							\
+								\
+	if (!arr)						\
+		return NULL;					\
+								\
+	for (i = 0; i < get_max(arg); i++) {			\
+		struct json_object *jobj;			\
+		int64_t align;					\
+								\
+		align = get_elem(arg, i);			\
+		jobj = json_object_new_int64(align);		\
+		if (!jobj)					\
+			goto err;				\
+		json_object_array_add(arr, jobj);		\
+	}							\
+								\
+	return arr;						\
+err:								\
+	json_object_put(arr);					\
+	return NULL;						\
+}
+#define SZ(type, kind) _SZ(ndctl_##type##_get_num_##kind##s, \
+			   ndctl_##type##_get_supported_##kind, ndctl_##type)
+SZ(pfn, alignment)
+SZ(dax, alignment)
+SZ(btt, sector_size)
+//SZ(namespace, sector_size)
+
 struct json_object *util_daxctl_region_to_json(struct daxctl_region *region,
 		const char *ident, unsigned long flags)
 {
@@ -739,7 +771,7 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 {
 	struct json_object *jndns = json_object_new_object();
 	enum ndctl_pfn_loc loc = NDCTL_PFN_LOC_NONE;
-	struct json_object *jobj, *jbbs = NULL;
+	struct json_object *jobj, *jbbs = NULL, *size_array = NULL;
 	const char *locations[] = {
 		[NDCTL_PFN_LOC_NONE] = "none",
 		[NDCTL_PFN_LOC_RAM] = "mem",
@@ -749,6 +781,7 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 	unsigned int sector_size = UINT_MAX;
 	enum ndctl_namespace_mode mode;
 	const char *bdev = NULL, *name;
+	const char *size_array_name;
 	unsigned int bb_count = 0;
 	struct ndctl_btt *btt;
 	struct ndctl_pfn *pfn;
@@ -936,6 +969,19 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 			json_object_object_add(jndns, "numa_node", jobj);
 	}
 
+	if (pfn) {
+		size_array_name = "supported_alignments";
+		size_array = ndctl_pfn_build_size_array(pfn);
+	} else if (dax) {
+		size_array_name = "supported_alignments";
+		size_array = ndctl_dax_build_size_array(dax);
+	} else if (btt) {
+		size_array_name = "supported sector sizes";
+		size_array = ndctl_btt_build_size_array(btt);
+	}
+	if (size_array)
+		json_object_object_add(jndns, size_array_name, size_array);
+
 	if (pfn)
 		jbbs = util_pfn_badblocks_to_json(pfn, &bb_count, flags);
 	else if (dax)
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
