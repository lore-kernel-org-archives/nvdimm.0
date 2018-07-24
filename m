Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E9F1C21B02845
 for <linux-nvdimm@lists.01.org>; Tue, 24 Jul 2018 15:31:30 -0700 (PDT)
From: Keith Busch <keith.busch@intel.com>
Subject: [ndctl PATCHv4] ndctl: Use max_available_extent for namespace
Date: Tue, 24 Jul 2018 16:31:25 -0600
Message-Id: <20180724223125.14288-1-keith.busch@intel.com>
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
To: Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The available_size attribute returns all the unused regions, but a
memory namespace has to use contiguous free regions. This patch uses the
max_available_extent attribute, which reports the largest capacity that
can be created when determining what size to allocate.

If the attribute is available, this patch will also report the max
available extent in the region list output.

Signed-off-by: Keith Busch <keith.busch@intel.com>
---
v3 -> v4:

  Moved the symbol to the appropriate version section of the symbols
  script.

  Report the max available extent in the region list if the attribute
  exists.

 ndctl/lib/libndctl.c   | 33 +++++++++++++++++++++++++++++++++
 ndctl/lib/libndctl.sym |  1 +
 ndctl/libndctl.h       |  2 ++
 ndctl/list.c           |  9 +++++++++
 ndctl/namespace.c      |  4 +++-
 5 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 969e4aa..e911ea2 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -2107,6 +2107,39 @@ NDCTL_EXPORT unsigned long long ndctl_region_get_available_size(
 	return strtoull(buf, NULL, 0);
 }
 
+NDCTL_EXPORT unsigned long long ndctl_region_get_max_available_extent(
+		struct ndctl_region *region)
+{
+	unsigned int nstype = ndctl_region_get_nstype(region);
+	struct ndctl_ctx *ctx = ndctl_region_get_ctx(region);
+	char *path = region->region_buf;
+	int len = region->buf_len;
+	char buf[SYSFS_ATTR_SIZE];
+
+	switch (nstype) {
+	case ND_DEVICE_NAMESPACE_PMEM:
+	case ND_DEVICE_NAMESPACE_BLK:
+		break;
+	default:
+		return 0;
+	}
+
+	if (snprintf(path, len,
+		     "%s/max_available_extent", region->region_path) >= len) {
+		err(ctx, "%s: buffer too small!\n",
+				ndctl_region_get_devname(region));
+		return ULLONG_MAX;
+	}
+
+	/* fall back to legacy behavior if max extents is not exported */
+	if (sysfs_read_attr(ctx, path, buf) < 0) {
+		dbg(ctx, "max extents attribute not exported on older kernels\n");
+		return ULLONG_MAX;
+	}
+
+	return strtoull(buf, NULL, 0);
+}
+
 NDCTL_EXPORT unsigned int ndctl_region_get_range_index(struct ndctl_region *region)
 {
 	return region->range_index;
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 9b36960..2bc312d 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -375,4 +375,5 @@ global:
 	ndctl_dimm_get_flags;
 	ndctl_dimm_get_event_flags;
 	ndctl_dimm_is_flag_supported;
+	ndctl_region_get_max_available_extent;
 } LIBNDCTL_16;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 6a6bb0d..a146502 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -350,6 +350,8 @@ unsigned int ndctl_region_get_interleave_ways(struct ndctl_region *region);
 unsigned int ndctl_region_get_mappings(struct ndctl_region *region);
 unsigned long long ndctl_region_get_size(struct ndctl_region *region);
 unsigned long long ndctl_region_get_available_size(struct ndctl_region *region);
+unsigned long long ndctl_region_get_max_available_extent(
+		struct ndctl_region *region);
 unsigned int ndctl_region_get_range_index(struct ndctl_region *region);
 unsigned int ndctl_region_get_type(struct ndctl_region *region);
 struct ndctl_namespace *ndctl_region_get_namespace_seed(
diff --git a/ndctl/list.c b/ndctl/list.c
index a06edc9..82e88bb 100644
--- a/ndctl/list.c
+++ b/ndctl/list.c
@@ -72,6 +72,7 @@ static struct json_object *region_to_json(struct ndctl_region *region,
 	struct ndctl_interleave_set *iset;
 	struct ndctl_mapping *mapping;
 	unsigned int bb_count = 0;
+	unsigned long long extent;
 	enum ndctl_persistence_domain pd;
 	int numa;
 
@@ -94,6 +95,14 @@ static struct json_object *region_to_json(struct ndctl_region *region,
 		goto err;
 	json_object_object_add(jregion, "available_size", jobj);
 
+	extent = ndctl_region_get_max_available_extent(region);
+	if (extent != ULLONG_MAX) {
+		jobj = util_json_object_size(extent, flags);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jregion, "max_available_extent", jobj);
+	}
+
 	switch (ndctl_region_get_type(region)) {
 	case ND_DEVICE_REGION_PMEM:
 		jobj = json_object_new_string("pmem");
diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index fe86d82..cfe0559 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -764,7 +764,9 @@ static int namespace_create(struct ndctl_region *region)
 		return -EAGAIN;
 	}
 
-	available = ndctl_region_get_available_size(region);
+	available = ndctl_region_get_max_available_extent(region);
+	if (available == ULLONG_MAX)
+		available = ndctl_region_get_available_size(region);
 	if (!available || p.size > available) {
 		debug("%s: insufficient capacity size: %llx avail: %llx\n",
 			devname, p.size, available);
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
