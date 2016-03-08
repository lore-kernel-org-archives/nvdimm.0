Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id B4C611A1F3E
 for <linux-nvdimm@lists.01.org>; Tue,  8 Mar 2016 15:37:18 -0800 (PST)
Subject: [ndctl PATCH 2/8] ndctl: ndctl_{namespace|pfn}_get_resource
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 08 Mar 2016 15:36:38 -0800
Message-ID: <20160308233638.18628.9488.stgit@dwillia2-desk3.jf.intel.com>
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

Retrieve the physical address corresponding to sector-0 of a pmem
device.  Note that ndctl_pfn_get_resource() is only valid while the
given pfn instance is enabled.

Reported-by: Haozhong Zhang <haozhong.zhang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 lib/libndctl.c       |   36 +++++++++++++++++++++++++++++++++++-
 lib/libndctl.sym     |    3 +++
 lib/ndctl/libndctl.h |    3 +++
 3 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/lib/libndctl.c b/lib/libndctl.c
index 56838c8a2a92..91e855bf525a 100644
--- a/lib/libndctl.c
+++ b/lib/libndctl.c
@@ -246,7 +246,7 @@ struct ndctl_namespace {
 	char *bdev;
 	int type, id, buf_len, raw_mode;
 	int generation;
-	unsigned long long size;
+	unsigned long long resource, size;
 	char *alt_name;
 	uuid_t uuid;
 	struct ndctl_lbasize lbasize;
@@ -297,6 +297,7 @@ struct ndctl_pfn {
 	struct list_node list;
 	enum ndctl_pfn_loc loc;
 	unsigned long align;
+	unsigned long long resource, size;
 	char *pfn_path;
 	char *pfn_buf;
 	char *bdev;
@@ -2669,6 +2670,12 @@ static int add_namespace(void *parent, int id, const char *ndns_base)
 		goto err_read;
 	ndns->size = strtoull(buf, NULL, 0);
 
+	sprintf(path, "%s/resource", ndns_base);
+	if (sysfs_read_attr(ctx, path, buf) < 0)
+		ndns->resource = ULLONG_MAX;
+	else
+		ndns->resource = strtoull(buf, NULL, 0);
+
 	sprintf(path, "%s/force_raw", ndns_base);
 	if (sysfs_read_attr(ctx, path, buf) < 0)
 		goto err_read;
@@ -3312,6 +3319,11 @@ NDCTL_EXPORT unsigned long long ndctl_namespace_get_size(struct ndctl_namespace
 	return ndns->size;
 }
 
+NDCTL_EXPORT unsigned long long ndctl_namespace_get_resource(struct ndctl_namespace *ndns)
+{
+	return ndns->resource;
+}
+
 static int namespace_set_size(struct ndctl_namespace *ndns,
 		unsigned long long size)
 {
@@ -3853,6 +3865,18 @@ static int add_pfn(void *parent, int id, const char *pfn_base)
 	else
 		pfn->align = strtoul(buf, NULL, 0);
 
+	sprintf(path, "%s/resource", pfn_base);
+	if (sysfs_read_attr(ctx, path, buf) < 0)
+		pfn->resource = ULLONG_MAX;
+	else
+		pfn->resource = strtoull(buf, NULL, 0);
+
+	sprintf(path, "%s/size", pfn_base);
+	if (sysfs_read_attr(ctx, path, buf) < 0)
+		pfn->size = ULLONG_MAX;
+	else
+		pfn->size = strtoull(buf, NULL, 0);
+
 	free(path);
 	ndctl_pfn_foreach(region, pfn_dup)
 		if (pfn->id == pfn_dup->id) {
@@ -3924,6 +3948,16 @@ NDCTL_EXPORT void ndctl_pfn_get_uuid(struct ndctl_pfn *pfn, uuid_t uu)
 	memcpy(uu, pfn->uuid, sizeof(uuid_t));
 }
 
+NDCTL_EXPORT unsigned long long ndctl_pfn_get_size(struct ndctl_pfn *pfn)
+{
+	return pfn->size;
+}
+
+NDCTL_EXPORT unsigned long long ndctl_pfn_get_resource(struct ndctl_pfn *pfn)
+{
+	return pfn->resource;
+}
+
 NDCTL_EXPORT int ndctl_pfn_set_uuid(struct ndctl_pfn *pfn, uuid_t uu)
 {
 	struct ndctl_ctx *ctx = ndctl_pfn_get_ctx(pfn);
diff --git a/lib/libndctl.sym b/lib/libndctl.sym
index 38c588cb8864..6c74e73189f6 100644
--- a/lib/libndctl.sym
+++ b/lib/libndctl.sym
@@ -149,6 +149,7 @@ global:
 	ndctl_namespace_set_alt_name;
 	ndctl_namespace_get_size;
 	ndctl_namespace_set_size;
+	ndctl_namespace_get_resource;
 	ndctl_namespace_get_supported_sector_size;
 	ndctl_namespace_get_sector_size;
 	ndctl_namespace_get_num_sector_sizes;
@@ -197,6 +198,8 @@ global:
 	ndctl_pfn_get_location;
 	ndctl_pfn_set_location;
 	ndctl_pfn_get_align;
+	ndctl_pfn_get_size;
+	ndctl_pfn_get_resource;
 	ndctl_pfn_set_align;
 	ndctl_pfn_set_namespace;
 	ndctl_pfn_get_bus;
diff --git a/lib/ndctl/libndctl.h b/lib/ndctl/libndctl.h
index 17770f78ce01..dbe98b0f159b 100644
--- a/lib/ndctl/libndctl.h
+++ b/lib/ndctl/libndctl.h
@@ -353,6 +353,7 @@ const char *ndctl_namespace_get_alt_name(struct ndctl_namespace *ndns);
 int ndctl_namespace_set_alt_name(struct ndctl_namespace *ndns,
 		const char *alt_name);
 unsigned long long ndctl_namespace_get_size(struct ndctl_namespace *ndns);
+unsigned long long ndctl_namespace_get_resource(struct ndctl_namespace *ndns);
 int ndctl_namespace_set_size(struct ndctl_namespace *ndns,
 		unsigned long long size);
 unsigned int ndctl_namespace_get_supported_sector_size(
@@ -430,6 +431,8 @@ int ndctl_pfn_set_uuid(struct ndctl_pfn *pfn, uuid_t uu);
 void ndctl_pfn_get_uuid(struct ndctl_pfn *pfn, uuid_t uu);
 int ndctl_pfn_set_align(struct ndctl_pfn *pfn, unsigned long align);
 unsigned long ndctl_pfn_get_align(struct ndctl_pfn *pfn);
+unsigned long long ndctl_pfn_get_resource(struct ndctl_pfn *pfn);
+unsigned long long ndctl_pfn_get_size(struct ndctl_pfn *pfn);
 int ndctl_pfn_set_namespace(struct ndctl_pfn *pfn, struct ndctl_namespace *ndns);
 struct ndctl_namespace *ndctl_pfn_get_namespace(struct ndctl_pfn *pfn);
 int ndctl_pfn_enable(struct ndctl_pfn *pfn);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
