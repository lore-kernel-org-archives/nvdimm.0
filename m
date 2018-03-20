Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E4615224BBC5A
 for <linux-nvdimm@lists.01.org>; Tue, 20 Mar 2018 14:44:01 -0700 (PDT)
Subject: [PATCH v3] ndctl: Add support for get bus and region persistence
 domain
From: Dave Jiang <dave.jiang@intel.com>
Date: Tue, 20 Mar 2018 14:50:27 -0700
Message-ID: <152158255868.52915.9362618183529367890.stgit@djiang5-desk3.ch.intel.com>
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

v3:
- fixed up return types per Ross's comments
- removed persistence_domain for bus and calculate on the fly per Dan's comment

v2:
- Simplied scanning of persistence domain from Ross's comments.

 ndctl/lib/libndctl.c   |   85 ++++++++++++++++++++++++++++++++++++++++++++++++
 ndctl/lib/libndctl.sym |    2 +
 ndctl/libndctl.h       |   11 ++++++
 ndctl/list.c           |   16 +++++++++
 4 files changed, 114 insertions(+)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index a165e697..bd2afa01 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -180,6 +180,7 @@ struct ndctl_region {
 	} iset;
 	FILE *badblocks;
 	struct badblock bb;
+	enum ndctl_persistence persistence_domain;
 };
 
 /**
@@ -916,6 +917,22 @@ NDCTL_EXPORT struct ndctl_bus *ndctl_bus_get_by_provider(struct ndctl_ctx *ctx,
 	return NULL;
 }
 
+NDCTL_EXPORT enum ndctl_persistence
+ndctl_bus_get_persistence_domain(struct ndctl_bus *bus)
+{
+	struct ndctl_region *region;
+	enum ndctl_persistence pd = PERSISTENCE_UNKNOWN;
+
+	/* iterate through region to get the region persistence domain */
+	ndctl_region_foreach(bus, region) {
+		/* we are looking for the least persistence domain */
+		if (pd > region->persistence_domain)
+			pd = region->persistence_domain;
+	}
+
+	return pd;
+}
+
 NDCTL_EXPORT struct ndctl_btt *ndctl_region_get_btt_seed(struct ndctl_region *region)
 {
 	struct ndctl_ctx *ctx = ndctl_region_get_ctx(region);
@@ -1755,6 +1772,62 @@ static int region_set_type(struct ndctl_region *region, char *path)
 	return 0;
 }
 
+static enum ndctl_persistence region_get_pd_type(char *name)
+{
+	if (strncmp("cpu_cache", name, 9) == 0)
+		return PERSISTENCE_CPU_CACHE;
+	else if (strncmp("memory_controller", name, 17) == 0)
+		return PERSISTENCE_MEM_CTRL;
+	else
+		return PERSISTENCE_UNKNOWN;
+}
+
+static int region_persistence_scan(struct ndctl_region *region)
+{
+	struct ndctl_ctx *ctx = ndctl_region_get_ctx(region);
+	char *pd_path;
+	FILE *pf;
+	char buf[64];
+	int rc = 0;
+	enum ndctl_persistence pd = PERSISTENCE_NONE;
+
+	region->persistence_domain = PERSISTENCE_NONE;
+	if (asprintf(&pd_path, "%s/persistence_domain",
+				region->region_path) < 0) {
+		rc = -errno;
+		err(ctx, "region persist domain path allocation failure\n");
+		return rc;
+	}
+
+	pf = fopen(pd_path, "re");
+	if (!pf) {
+		rc = -errno;
+		free(pd_path);
+		return rc;
+	}
+
+	do {
+		rc = fscanf(pf, "%s", buf);
+		if (rc == EOF) {
+			if (ferror(pf)) {
+				rc = -errno;
+				goto out;
+			}
+		} else if (rc == 1)
+			pd = region_get_pd_type(buf);
+
+		if (region->persistence_domain < pd)
+			region->persistence_domain = pd;
+	} while (rc != EOF);
+
+	rc = 0;
+
+out:
+	fclose(pf);
+	free(pd_path);
+	return rc;
+}
+
 static void *add_region(void *parent, int id, const char *region_base)
 {
 	char buf[SYSFS_ATTR_SIZE];
@@ -1831,6 +1904,12 @@ static void *add_region(void *parent, int id, const char *region_base)
 	list_add(&bus->regions, &region->list);
 
 	free(path);
+
+	/* get the persistence domain attribs */
+	if (region_persistence_scan(region) < 0)
+		err(ctx, "%s: region persistence scan failed\n",
+				ndctl_region_get_devname(region));
+
 	return region;
 
  err_read:
@@ -2093,6 +2172,12 @@ NDCTL_EXPORT struct badblock *ndctl_region_get_first_badblock(struct ndctl_regio
 	return ndctl_region_get_next_badblock(region);
 }
 
+NDCTL_EXPORT enum ndctl_persistence
+ndctl_region_get_persistence_domain(struct ndctl_region *region)
+{
+	return region->persistence_domain;
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
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index f3a27411..84f441ef 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -115,6 +115,7 @@ int ndctl_bus_is_cmd_supported(struct ndctl_bus *bus, int cmd);
 unsigned int ndctl_bus_get_revision(struct ndctl_bus *bus);
 unsigned int ndctl_bus_get_id(struct ndctl_bus *bus);
 const char *ndctl_bus_get_provider(struct ndctl_bus *bus);
+enum ndctl_persistence ndctl_bus_get_persistence_domain(struct ndctl_bus *bus);
 int ndctl_bus_wait_probe(struct ndctl_bus *bus);
 int ndctl_bus_wait_for_scrub_completion(struct ndctl_bus *bus);
 unsigned int ndctl_bus_get_scrub_count(struct ndctl_bus *bus);
@@ -305,6 +306,14 @@ struct badblock {
 	unsigned long long offset;
 	unsigned int len;
 };
+
+enum ndctl_persistence {
+	PERSISTENCE_NONE = 0,
+	PERSISTENCE_MEM_CTRL,
+	PERSISTENCE_CPU_CACHE,
+	PERSISTENCE_UNKNOWN,
+};
+
 struct ndctl_region;
 struct ndctl_region *ndctl_region_get_first(struct ndctl_bus *bus);
 struct ndctl_region *ndctl_region_get_next(struct ndctl_region *region);
@@ -347,6 +356,8 @@ struct ndctl_region *ndctl_bus_get_region_by_physical_address(struct ndctl_bus *
         for (dimm = ndctl_region_get_first_dimm(region); \
              dimm != NULL; \
              dimm = ndctl_region_get_next_dimm(region, dimm))
+enum ndctl_persistence ndctl_region_get_persistence_domain(
+		struct ndctl_region *region);
 int ndctl_region_is_enabled(struct ndctl_region *region);
 int ndctl_region_enable(struct ndctl_region *region);
 int ndctl_region_disable_invalidate(struct ndctl_region *region);
diff --git a/ndctl/list.c b/ndctl/list.c
index fe8036ea..59efa31d 100644
--- a/ndctl/list.c
+++ b/ndctl/list.c
@@ -73,6 +73,7 @@ static struct json_object *region_to_json(struct ndctl_region *region,
 	struct ndctl_interleave_set *iset;
 	struct ndctl_mapping *mapping;
 	unsigned int bb_count = 0;
+	enum ndctl_persistence pd;
 	int numa;
 
 	if (!jregion)
@@ -174,6 +175,21 @@ static struct json_object *region_to_json(struct ndctl_region *region,
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
