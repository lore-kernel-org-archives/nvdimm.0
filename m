Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7126920954B85
 for <linux-nvdimm@lists.01.org>; Wed, 14 Mar 2018 16:19:00 -0700 (PDT)
Subject: [PATCH] ndctl: Add support for region persistent domain
From: Dave Jiang <dave.jiang@intel.com>
Date: Wed, 14 Mar 2018 16:25:22 -0700
Message-ID: <152106992276.3651.11460547310766381879.stgit@djiang5-desk3.ch.intel.com>
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
To: vishal.l.verma@intel.com, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Adding helper functions to iterate through sysfs region persistence domain
attribute. The region will display the domain with the most persistence for the
region.  The bus will display the domain attribute with the least persistence
amongst all the regions. ndctl_bus_get_persistence_domain() and
ndctl_region_get_persistence_domain are exported. ndctl list will also display
the region persistence domain as well.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 0 files changed

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index a165e697..94a1dbcd 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -180,6 +180,8 @@ struct ndctl_region {
 	} iset;
 	FILE *badblocks;
 	struct badblock bb;
+	FILE *persist_fp;
+	unsigned int persist_domain;
 };
 
 /**
@@ -916,6 +918,17 @@ NDCTL_EXPORT struct ndctl_bus *ndctl_bus_get_by_provider(struct ndctl_ctx *ctx,
 	return NULL;
 }
 
+NDCTL_EXPORT unsigned int
+ndctl_bus_get_persistence_domain(struct ndctl_bus *bus)
+{
+	struct ndctl_region *region;
+
+	/* iterate through region to get the region persist domain */
+	ndctl_region_foreach(bus, region) {}
+
+	return bus->persist_domain;
+}
+
 NDCTL_EXPORT struct ndctl_btt *ndctl_region_get_btt_seed(struct ndctl_region *region)
 {
 	struct ndctl_ctx *ctx = ndctl_region_get_ctx(region);
@@ -1755,6 +1768,79 @@ static int region_set_type(struct ndctl_region *region, char *path)
 	return 0;
 }
 
+#define region_pd_foreach(region, pd) \
+	for (pd = region_get_first_pd(region); \
+		pd != PERSISTENCE_NONE; \
+		pd = region_get_next_pd(region))
+
+static unsigned int region_get_pd_type(char *name)
+{
+	if (strncmp("cpu_cache", name, 9) == 0)
+		return PERSISTENCE_CPU_CACHE;
+	else if (strncmp("memory_controller", name, 17) == 0)
+		return PERSISTENCE_MEM_CTRL;
+	else
+		return PERSISTENCE_NONE;
+}
+
+static int region_persistence_init(struct ndctl_region *region)
+{
+	struct ndctl_ctx *ctx = ndctl_region_get_ctx(region);
+	char *pd_path;
+	int rc = 0;
+
+	if (region->persist_fp) {
+		fclose(region->persist_fp);
+		region->persist_fp = NULL;
+	}
+
+	if (asprintf(&pd_path, "%s/persistence_domain",
+				region->region_path) < 0) {
+		rc = -errno;
+		err(ctx, "region persist domain path allocation failure\n");
+		return rc;
+	}
+
+	region->persist_fp = fopen(pd_path, "re");
+	if (!region->persist_fp) {
+		rc = -errno;
+		free(pd_path);
+		return rc;
+	}
+
+	free(pd_path);
+	return rc;
+}
+
+static unsigned int region_get_next_pd(struct ndctl_region *region)
+{
+	int rc;
+	char buf[32];
+
+	if (!region->persist_fp)
+		return PERSISTENCE_NONE;
+
+	rc = fscanf(region->persist_fp, "%s", buf);
+	if (rc != 1) {
+		fclose(region->persist_fp);
+		region->persist_fp = NULL;
+		return PERSISTENCE_NONE;
+	}
+
+	return region_get_pd_type(buf);
+}
+
+static unsigned int region_get_first_pd(struct ndctl_region *region)
+{
+	int rc;
+
+	rc = region_persistence_init(region);
+	if (rc < 0)
+		return PERSISTENCE_NONE;
+
+	return region_get_next_pd(region);
+}
+
 static void *add_region(void *parent, int id, const char *region_base)
 {
 	char buf[SYSFS_ATTR_SIZE];
@@ -1762,6 +1848,7 @@ static void *add_region(void *parent, int id, const char *region_base)
 	struct ndctl_bus *bus = parent;
 	struct ndctl_ctx *ctx = bus->ctx;
 	char *path = calloc(1, strlen(region_base) + 100);
+	unsigned int pd = 0;
 
 	if (!path)
 		return NULL;
@@ -1831,6 +1918,19 @@ static void *add_region(void *parent, int id, const char *region_base)
 	list_add(&bus->regions, &region->list);
 
 	free(path);
+
+	/* get the persistence domain attribs */
+	region_pd_foreach(region, pd) {
+		if (region->persist_domain == 0 || region->persist_domain > pd)
+			region->persist_domain = pd;
+	}
+	pd = region->persist_domain;
+
+	/* we are looking for the least persistence domain */
+	if (region->bus->persist_domain == 0 ||
+			region->bus->persist_domain < pd)
+		region->bus->persist_domain = pd;
+
 	return region;
 
  err_read:
@@ -2093,6 +2193,12 @@ NDCTL_EXPORT struct badblock *ndctl_region_get_first_badblock(struct ndctl_regio
 	return ndctl_region_get_next_badblock(region);
 }
 
+NDCTL_EXPORT unsigned int
+ndctl_region_get_persistence_domain(struct ndctl_region *region)
+{
+	return region->persist_domain;
+}
+
 static struct nd_cmd_vendor_tail *to_vendor_tail(struct ndctl_cmd *cmd)
 {
 	struct nd_cmd_vendor_tail *tail = (struct nd_cmd_vendor_tail *)
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 21276614..3209aefe 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -350,4 +350,6 @@ global:
 	ndctl_dimm_cmd_new_ack_shutdown_count;
 	ndctl_region_get_numa_node;
 	ndctl_dimm_fw_update_supported;
+	ndctl_region_get_persistence_domain;
+	ndctl_bus_get_persistence_domain;
 } LIBNDCTL_14;
diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
index 1cad06b7..6394c50c 100644
--- a/ndctl/lib/private.h
+++ b/ndctl/lib/private.h
@@ -171,6 +171,7 @@ struct ndctl_bus {
 	char *scrub_path;
 	unsigned long cmd_mask;
 	unsigned long nfit_dsm_mask;
+	unsigned int persist_domain;
 };
 
 /**
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index f3a27411..be5b196c 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -115,6 +115,7 @@ int ndctl_bus_is_cmd_supported(struct ndctl_bus *bus, int cmd);
 unsigned int ndctl_bus_get_revision(struct ndctl_bus *bus);
 unsigned int ndctl_bus_get_id(struct ndctl_bus *bus);
 const char *ndctl_bus_get_provider(struct ndctl_bus *bus);
+unsigned int ndctl_bus_get_persistence_domain(struct ndctl_bus *bus);
 int ndctl_bus_wait_probe(struct ndctl_bus *bus);
 int ndctl_bus_wait_for_scrub_completion(struct ndctl_bus *bus);
 unsigned int ndctl_bus_get_scrub_count(struct ndctl_bus *bus);
@@ -305,6 +306,14 @@ struct badblock {
 	unsigned long long offset;
 	unsigned int len;
 };
+
+enum {
+	PERSISTENCE_NONE = 0,
+/* order these in distance to CPU persistence domain */
+	PERSISTENCE_CPU_CACHE,
+	PERSISTENCE_MEM_CTRL,
+};
+
 struct ndctl_region;
 struct ndctl_region *ndctl_region_get_first(struct ndctl_bus *bus);
 struct ndctl_region *ndctl_region_get_next(struct ndctl_region *region);
@@ -318,6 +327,7 @@ struct badblock *ndctl_region_get_next_badblock(struct ndctl_region *region);
         for (badblock = ndctl_region_get_first_badblock(region); \
              badblock != NULL; \
              badblock = ndctl_region_get_next_badblock(region))
+
 unsigned int ndctl_region_get_id(struct ndctl_region *region);
 const char *ndctl_region_get_devname(struct ndctl_region *region);
 unsigned int ndctl_region_get_interleave_ways(struct ndctl_region *region);
@@ -347,6 +357,7 @@ struct ndctl_region *ndctl_bus_get_region_by_physical_address(struct ndctl_bus *
         for (dimm = ndctl_region_get_first_dimm(region); \
              dimm != NULL; \
              dimm = ndctl_region_get_next_dimm(region, dimm))
+unsigned int ndctl_region_get_persistence_domain(struct ndctl_region *region);
 int ndctl_region_is_enabled(struct ndctl_region *region);
 int ndctl_region_enable(struct ndctl_region *region);
 int ndctl_region_disable_invalidate(struct ndctl_region *region);
diff --git a/ndctl/list.c b/ndctl/list.c
index 0ca5b6de..87326544 100644
--- a/ndctl/list.c
+++ b/ndctl/list.c
@@ -72,7 +72,7 @@ static struct json_object *region_to_json(struct ndctl_region *region,
 	struct json_object *jobj, *jbbs, *jmappings = NULL;
 	struct ndctl_interleave_set *iset;
 	struct ndctl_mapping *mapping;
-	unsigned int bb_count = 0;
+	unsigned int bb_count = 0, pd;
 	int numa;
 
 	if (!jregion)
@@ -174,6 +174,21 @@ static struct json_object *region_to_json(struct ndctl_region *region,
 	if ((flags & UTIL_JSON_MEDIA_ERRORS) && jbbs)
 		json_object_object_add(jregion, "badblocks", jbbs);
 
+	pd = ndctl_region_get_persistence_domain(region);
+	switch (pd) {
+		case PERSISTENCE_CPU_CACHE:
+			jobj = json_object_new_string("cpu_cache");
+			break;
+		case PERSISTENCE_MEM_CTRL:
+			jobj = json_object_new_string("memory_controller");
+			break;
+		default:
+			jobj = NULL;
+	}
+
+	if (jobj)
+		json_object_object_add(jregion, "persistence_domain", jobj);
+
 	return jregion;
  err:
 	fail("\n");

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
