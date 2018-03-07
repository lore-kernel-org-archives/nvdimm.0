Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8A69D21ED1C7D
 for <linux-nvdimm@lists.01.org>; Wed,  7 Mar 2018 09:56:28 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 2/3] ndctl: add numa_node support for regions
Date: Wed,  7 Mar 2018 11:02:36 -0700
Message-Id: <20180307180237.9289-2-ross.zwisler@linux.intel.com>
In-Reply-To: <20180307180237.9289-1-ross.zwisler@linux.intel.com>
References: <20180307180237.9289-1-ross.zwisler@linux.intel.com>
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
To: linux-nvdimm@lists.01.org, dan.j.williams@intel.com
List-ID: <linux-nvdimm@lists.01.org>

Add an API for getting the numa node of a given region and add a numa_node
field to the "ndctl list" region output.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 ndctl/lib/libndctl.c   | 13 +++++++++++++
 ndctl/lib/libndctl.sym |  1 +
 ndctl/libndctl.h       |  1 +
 ndctl/list.c           |  8 ++++++++
 4 files changed, 23 insertions(+)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index b7180e8..a165e69 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -132,6 +132,7 @@ struct ndctl_mapping {
  * @type_name: 'pmem' or 'block'
  * @generation: incremented everytime the region is disabled
  * @nstype: the resulting type of namespace this region produces
+ * @numa_node: numa node attribute
  *
  * A region may alias between pmem and block-window access methods.  The
  * region driver is tasked with parsing the label (if their is one) and
@@ -157,6 +158,7 @@ struct ndctl_region {
 	char *region_buf;
 	int buf_len;
 	int generation;
+	int numa_node;
 	struct list_head btts;
 	struct list_head pfns;
 	struct list_head daxs;
@@ -1808,6 +1810,12 @@ static void *add_region(void *parent, int id, const char *region_base)
 		goto err_read;
 	region->module = to_module(ctx, buf);
 
+	sprintf(path, "%s/numa_node", region_base);
+	if (sysfs_read_attr(ctx, path, buf) == 0)
+		region->numa_node = strtol(buf, NULL, 0);
+	else
+		region->numa_node = -1;
+
 	if (region_set_type(region, path) < 0)
 		goto err_read;
 
@@ -2011,6 +2019,11 @@ NDCTL_EXPORT struct ndctl_dimm *ndctl_region_get_next_dimm(struct ndctl_region *
 	return NULL;
 }
 
+NDCTL_EXPORT int ndctl_region_get_numa_node(struct ndctl_region *region)
+{
+	return region->numa_node;
+}
+
 static int regions_badblocks_init(struct ndctl_region *region)
 {
 	struct ndctl_ctx *ctx = ndctl_region_get_ctx(region);
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index af9b7d5..175a482 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -344,4 +344,5 @@ global:
 	ndctl_cmd_fw_fquery_get_fw_rev;
 	ndctl_cmd_fw_xlat_firmware_status;
 	ndctl_dimm_cmd_new_ack_shutdown_count;
+	ndctl_region_get_numa_node;
 } LIBNDCTL_13;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 9db775b..017c9cc 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -340,6 +340,7 @@ struct ndctl_ctx *ndctl_region_get_ctx(struct ndctl_region *region);
 struct ndctl_dimm *ndctl_region_get_first_dimm(struct ndctl_region *region);
 struct ndctl_dimm *ndctl_region_get_next_dimm(struct ndctl_region *region,
 		struct ndctl_dimm *dimm);
+int ndctl_region_get_numa_node(struct ndctl_region *region);
 struct ndctl_region *ndctl_bus_get_region_by_physical_address(struct ndctl_bus *bus,
 		unsigned long long address);
 #define ndctl_dimm_foreach_in_region(region, dimm) \
diff --git a/ndctl/list.c b/ndctl/list.c
index af1c024..4cb66de 100644
--- a/ndctl/list.c
+++ b/ndctl/list.c
@@ -73,6 +73,7 @@ static struct json_object *region_to_json(struct ndctl_region *region,
 	struct ndctl_interleave_set *iset;
 	struct ndctl_mapping *mapping;
 	unsigned int bb_count = 0;
+	int numa;
 
 	if (!jregion)
 		return NULL;
@@ -107,6 +108,13 @@ static struct json_object *region_to_json(struct ndctl_region *region,
 		goto err;
 	json_object_object_add(jregion, "type", jobj);
 
+	numa = ndctl_region_get_numa_node(region);
+	if (numa >= 0) {
+		jobj = json_object_new_int(numa);
+		if (jobj)
+			json_object_object_add(jregion, "numa_node", jobj);
+	}
+
 	iset = ndctl_region_get_interleave_set(region);
 	if (iset) {
 		jobj = util_json_object_hex(
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
