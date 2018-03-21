Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9E08D223DB11E
 for <linux-nvdimm@lists.01.org>; Wed, 21 Mar 2018 12:48:41 -0700 (PDT)
Subject: [PATCH v7] ndctl: Add support for get bus and region persistence
 domain
From: Dave Jiang <dave.jiang@intel.com>
Date: Wed, 21 Mar 2018 12:55:11 -0700
Message-ID: <152166202957.70855.18173170834465139126.stgit@djiang5-desk3.ch.intel.com>
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
v7:
- set attrib to unknown when no attrib detected instead of none. will add
  support of none attrib in kernel at a later time.

v6:
- emit "none" when there's nothing in sysfs attrib, and "unknown" when there
  is no sysfs attrib at all.
- Use sysfs_read_attr() to retrieve domain values
- Change INT32_MAX to INT_MAX.

v5:
- space out ndctl_persistence_domain for future attributes

v4:
- change enum ndctl_persistence to enum ndctl_persistence_domain

v3:
- fixed up return types per Ross's comments
- removed persistence_domain for bus and calculate on the fly per Dan's comment

v2:
- Simplied scanning of persistence domain from Ross's comments.

 ndctl/lib/libndctl.c   |   88 ++++++++++++++++++++++++++++++++++++++++++++++++
 ndctl/lib/libndctl.sym |    2 +
 ndctl/libndctl.h       |   13 +++++++
 ndctl/list.c           |   20 +++++++++++
 4 files changed, 123 insertions(+)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index a165e697..991042df 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -180,6 +180,7 @@ struct ndctl_region {
 	} iset;
 	FILE *badblocks;
 	struct badblock bb;
+	enum ndctl_persistence_domain persistence_domain;
 };
 
 /**
@@ -916,6 +917,22 @@ NDCTL_EXPORT struct ndctl_bus *ndctl_bus_get_by_provider(struct ndctl_ctx *ctx,
 	return NULL;
 }
 
+NDCTL_EXPORT enum ndctl_persistence_domain
+ndctl_bus_get_persistence_domain(struct ndctl_bus *bus)
+{
+	struct ndctl_region *region;
+	enum ndctl_persistence_domain pd = PERSISTENCE_UNKNOWN;
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
@@ -1755,6 +1772,65 @@ static int region_set_type(struct ndctl_region *region, char *path)
 	return 0;
 }
 
+static enum ndctl_persistence_domain region_get_pd_type(char *name)
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
+	char buf[SYSFS_ATTR_SIZE], *attrib;
+	int rc = 0;
+	enum ndctl_persistence_domain pd = PERSISTENCE_NONE;
+
+	region->persistence_domain = PERSISTENCE_NONE;
+	if (asprintf(&pd_path, "%s/persistence_domain",
+				region->region_path) < 0) {
+		rc = -errno;
+		err(ctx, "region persist domain path allocation failure\n");
+		region->persistence_domain = PERSISTENCE_UNKNOWN;
+		return rc;
+	}
+
+	if (sysfs_read_attr(ctx, pd_path, buf) < 0) {
+		/* no sysfs attrib */
+		region->persistence_domain = PERSISTENCE_UNKNOWN;
+		rc = -ENXIO;
+		goto out;
+	}
+
+	attrib = strtok(buf, " ");
+	/* empty string */
+	if (!attrib) {
+		region->persistence_domain = PERSISTENCE_UNKNOWN;
+		goto out;
+	}
+
+	pd = region_get_pd_type(attrib);
+	if (region->persistence_domain < pd)
+		region->persistence_domain = pd;
+
+	do {
+		attrib = strtok(NULL, " ");
+		if (!attrib)
+			break;
+		pd = region_get_pd_type(attrib);
+		if (region->persistence_domain < pd)
+			region->persistence_domain = pd;
+	} while (attrib);
+
+out:
+	free(pd_path);
+	return rc;
+}
+
 static void *add_region(void *parent, int id, const char *region_base)
 {
 	char buf[SYSFS_ATTR_SIZE];
@@ -1831,6 +1907,12 @@ static void *add_region(void *parent, int id, const char *region_base)
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
@@ -2093,6 +2175,12 @@ NDCTL_EXPORT struct badblock *ndctl_region_get_first_badblock(struct ndctl_regio
 	return ndctl_region_get_next_badblock(region);
 }
 
+NDCTL_EXPORT enum ndctl_persistence_domain
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
index f3a27411..cf6a77fd 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -18,6 +18,7 @@
 #include <stdint.h>
 #include <unistd.h>
 #include <errno.h>
+#include <limits.h>
 
 #ifdef HAVE_LIBUUID
 #include <uuid/uuid.h>
@@ -115,6 +116,8 @@ int ndctl_bus_is_cmd_supported(struct ndctl_bus *bus, int cmd);
 unsigned int ndctl_bus_get_revision(struct ndctl_bus *bus);
 unsigned int ndctl_bus_get_id(struct ndctl_bus *bus);
 const char *ndctl_bus_get_provider(struct ndctl_bus *bus);
+enum ndctl_persistence_domain ndctl_bus_get_persistence_domain(
+		struct ndctl_bus *bus);
 int ndctl_bus_wait_probe(struct ndctl_bus *bus);
 int ndctl_bus_wait_for_scrub_completion(struct ndctl_bus *bus);
 unsigned int ndctl_bus_get_scrub_count(struct ndctl_bus *bus);
@@ -305,6 +308,14 @@ struct badblock {
 	unsigned long long offset;
 	unsigned int len;
 };
+
+enum ndctl_persistence_domain {
+	PERSISTENCE_NONE = 0,
+	PERSISTENCE_MEM_CTRL = 10,
+	PERSISTENCE_CPU_CACHE = 20,
+	PERSISTENCE_UNKNOWN = INT_MAX,
+};
+
 struct ndctl_region;
 struct ndctl_region *ndctl_region_get_first(struct ndctl_bus *bus);
 struct ndctl_region *ndctl_region_get_next(struct ndctl_region *region);
@@ -347,6 +358,8 @@ struct ndctl_region *ndctl_bus_get_region_by_physical_address(struct ndctl_bus *
         for (dimm = ndctl_region_get_first_dimm(region); \
              dimm != NULL; \
              dimm = ndctl_region_get_next_dimm(region, dimm))
+enum ndctl_persistence_domain ndctl_region_get_persistence_domain(
+		struct ndctl_region *region);
 int ndctl_region_is_enabled(struct ndctl_region *region);
 int ndctl_region_enable(struct ndctl_region *region);
 int ndctl_region_disable_invalidate(struct ndctl_region *region);
diff --git a/ndctl/list.c b/ndctl/list.c
index fe8036ea..6cf7c393 100644
--- a/ndctl/list.c
+++ b/ndctl/list.c
@@ -73,6 +73,7 @@ static struct json_object *region_to_json(struct ndctl_region *region,
 	struct ndctl_interleave_set *iset;
 	struct ndctl_mapping *mapping;
 	unsigned int bb_count = 0;
+	enum ndctl_persistence_domain pd;
 	int numa;
 
 	if (!jregion)
@@ -174,6 +175,25 @@ static struct json_object *region_to_json(struct ndctl_region *region,
 	if ((flags & UTIL_JSON_MEDIA_ERRORS) && jbbs)
 		json_object_object_add(jregion, "badblocks", jbbs);
 
+	pd = ndctl_region_get_persistence_domain(region);
+	switch (pd) {
+	case PERSISTENCE_CPU_CACHE:
+		jobj = json_object_new_string("cpu_cache");
+		break;
+	case PERSISTENCE_MEM_CTRL:
+		jobj = json_object_new_string("memory_controller");
+		break;
+	case PERSISTENCE_NONE:
+		jobj = json_object_new_string("none");
+		break;
+	default:
+		jobj = json_object_new_string("unknown");
+		break;
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
