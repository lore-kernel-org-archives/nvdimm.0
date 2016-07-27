Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id 355361A1E07
 for <linux-nvdimm@lists.01.org>; Tue, 26 Jul 2016 17:30:00 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] ndctl: print 'size' when creating/listing BTT namespaces
Date: Tue, 26 Jul 2016 18:29:20 -0600
Message-Id: <1469579360-30033-1-git-send-email-vishal.l.verma@intel.com>
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

Print the usable size of a BTT namespace after removing driver overhead
in the json for listing/creating a BTT namespace. This makes it
consistent with other flavors of namespaces (dax, pfn).

Cc: Dan Williams <dan.j.williams@intel.com>
Reported-by: Linda Knippers <linda.knippers@hpe.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/lib/libndctl.c   | 13 +++++++++++++
 ndctl/lib/libndctl.sym |  1 +
 ndctl/libndctl.h.in    |  1 +
 ndctl/util/json.c      |  1 +
 4 files changed, 16 insertions(+)

This is a bit of an RFC patch as I have a couple of open questions/issues:

1. If this is used with an older kernel that doesn't expose btt/size in
sysfs, and if a user uses the new API (ndctl_btt_get_size), they will
get ULLONG_MAX. Should we change this, or otherwise version the API..

2. In the json printed right after namespace creation, 'size' will show
up as zero, and subsequent listings will show the right size:
# ndctl create-namespace --mode=sector 
{
  "dev":"namespace7.0",
  "mode":"sector",
  "size":0,
  "uuid":"ae706db9-55a0-48e0-8579-ccd717a2b6c1",
  "sector_size":4096,
  "blockdev":"pmem7s"
}

# ndctl list --namespace=namespace7.0
{
  "dev":"namespace7.0",
  "mode":"sector",
  "size":32440320,
  "uuid":"ae706db9-55a0-48e0-8579-ccd717a2b6c1",
  "sector_size":4096,
  "blockdev":"pmem7s"
}

I'm not sure how to fix this - still looking into it.


diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 0722f79..ece3c4a 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -271,6 +271,7 @@ struct ndctl_namespace {
  * struct ndctl_btt - stacked block device provided sector atomicity
  * @module: kernel module (nd_btt)
  * @lbasize: sector size info
+ * @size: usable size of the btt after removing metadata etc
  * @ndns: host namespace for the btt instance
  * @region: parent region
  * @btt_path: btt devpath
@@ -284,6 +285,7 @@ struct ndctl_btt {
 	struct ndctl_namespace *ndns;
 	struct list_node list;
 	struct ndctl_lbasize lbasize;
+	unsigned long long size;
 	char *btt_path;
 	char *btt_buf;
 	char *bdev;
@@ -3614,6 +3616,12 @@ static int add_btt(void *parent, int id, const char *btt_base)
 	if (parse_lbasize_supported(ctx, devname, buf, &btt->lbasize) < 0)
 		goto err_read;
 
+	sprintf(path, "%s/size", btt_base);
+	if (sysfs_read_attr(ctx, path, buf) < 0)
+		btt->size = ULLONG_MAX;
+	else
+		btt->size = strtoull(buf, NULL, 0);
+
 	free(path);
 	ndctl_btt_foreach(region, btt_dup)
 		if (btt->id == btt_dup->id) {
@@ -3705,6 +3713,11 @@ NDCTL_EXPORT void ndctl_btt_get_uuid(struct ndctl_btt *btt, uuid_t uu)
 	memcpy(uu, btt->uuid, sizeof(uuid_t));
 }
 
+NDCTL_EXPORT unsigned long long ndctl_btt_get_size(struct ndctl_btt *btt)
+{
+	return btt->size;
+}
+
 NDCTL_EXPORT int ndctl_btt_set_uuid(struct ndctl_btt *btt, uuid_t uu)
 {
 	struct ndctl_ctx *ctx = ndctl_btt_get_ctx(btt);
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 6af267a..b5d2866 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -196,6 +196,7 @@ global:
 	ndctl_btt_get_num_sector_sizes;
 	ndctl_btt_get_namespace;
 	ndctl_btt_get_uuid;
+	ndctl_btt_get_size;
 	ndctl_btt_is_enabled;
 	ndctl_btt_is_valid;
 	ndctl_btt_get_devname;
diff --git a/ndctl/libndctl.h.in b/ndctl/libndctl.h.in
index 9e0e82a..451466a 100644
--- a/ndctl/libndctl.h.in
+++ b/ndctl/libndctl.h.in
@@ -521,6 +521,7 @@ unsigned int ndctl_btt_get_sector_size(struct ndctl_btt *btt);
 int ndctl_btt_get_num_sector_sizes(struct ndctl_btt *btt);
 struct ndctl_namespace *ndctl_btt_get_namespace(struct ndctl_btt *btt);
 void ndctl_btt_get_uuid(struct ndctl_btt *btt, uuid_t uu);
+unsigned long long ndctl_btt_get_size(struct ndctl_btt *btt);
 int ndctl_btt_is_enabled(struct ndctl_btt *btt);
 int ndctl_btt_is_valid(struct ndctl_btt *btt);
 const char *ndctl_btt_get_devname(struct ndctl_btt *btt);
diff --git a/ndctl/util/json.c b/ndctl/util/json.c
index a9c096c..c727bc2 100644
--- a/ndctl/util/json.c
+++ b/ndctl/util/json.c
@@ -174,6 +174,7 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns)
 		break;
 	case NDCTL_NS_MODE_SAFE:
 		jobj = json_object_new_string("sector");
+		size = ndctl_btt_get_size(btt);
 		break;
 	case NDCTL_NS_MODE_RAW:
 		size = ndctl_namespace_get_size(ndns);
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
