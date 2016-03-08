Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id 23BE81A1F36
 for <linux-nvdimm@lists.01.org>; Tue,  8 Mar 2016 15:37:29 -0800 (PST)
Subject: [ndctl PATCH 4/8] ndctl: use the pfn trimmed size for memory mode
 namespaces
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 08 Mar 2016 15:36:49 -0800
Message-ID: <20160308233649.18628.96818.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20160308233628.18628.13786.stgit@dwillia2-desk3.jf.intel.com>
References: <20160308233628.18628.13786.stgit@dwillia2-desk3.jf.intel.com>
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

If the kernel reports the size of the namespace after the memmap
allocation is removed use that value, otherwise don't emit raw namespace
size since it is not accurate.

For the btt case, the effective size is further constrained by the
sector geometry, so userspace should just use the block device size.
Otherwise, the size and base address of the namespace is useful for
hypervisors that want to establish their own host-physical-address
mappings for a guest to consume.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 util/json.c |   24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/util/json.c b/util/json.c
index b9a5e75164d8..288efee723ff 100644
--- a/util/json.c
+++ b/util/json.c
@@ -1,3 +1,4 @@
+#include <limits.h>
 #include <util/json.h>
 #include <uuid/uuid.h>
 #include <json-c/json.h>
@@ -76,6 +77,8 @@ bool util_namespace_active(struct ndctl_namespace *ndns)
 struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns)
 {
 	struct json_object *jndns = json_object_new_object();
+	unsigned long long size = ULLONG_MAX;
+	enum ndctl_namespace_mode mode;
 	struct json_object *jobj;
 	const char *bdev = NULL;
 	struct ndctl_btt *btt;
@@ -91,14 +94,22 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns)
 		goto err;
 	json_object_object_add(jndns, "dev", jobj);
 
-	switch (ndctl_namespace_get_mode(ndns)) {
+	btt = ndctl_namespace_get_btt(ndns);
+	pfn = ndctl_namespace_get_pfn(ndns);
+	mode = ndctl_namespace_get_mode(ndns);
+	switch (mode) {
 	case NDCTL_NS_MODE_MEMORY:
+		if (pfn) /* dynamic memory mode */
+			size = ndctl_pfn_get_size(pfn);
+		else /* native/static memory mode */
+			size = ndctl_namespace_get_size(ndns);
 		jobj = json_object_new_string("memory");
 		break;
 	case NDCTL_NS_MODE_SAFE:
 		jobj = json_object_new_string("sector");
 		break;
 	case NDCTL_NS_MODE_RAW:
+		size = ndctl_namespace_get_size(ndns);
 		jobj = json_object_new_string("raw");
 		break;
 	default:
@@ -107,13 +118,12 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns)
 	if (jobj)
 		json_object_object_add(jndns, "mode", jobj);
 
-	jobj = json_object_new_int64(ndctl_namespace_get_size(ndns));
-	if (!jobj)
-		goto err;
-	json_object_object_add(jndns, "size", jobj);
+	if (size < ULLONG_MAX) {
+		jobj = json_object_new_int64(size);
+		if (jobj)
+			json_object_object_add(jndns, "size", jobj);
+	}
 
-	btt = ndctl_namespace_get_btt(ndns);
-	pfn = ndctl_namespace_get_pfn(ndns);
 	if (btt) {
 		ndctl_btt_get_uuid(btt, uuid);
 		uuid_unparse(uuid, buf);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
