Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 18DB922146737
 for <linux-nvdimm@lists.01.org>; Wed, 21 Mar 2018 16:42:39 -0700 (PDT)
Subject: [PATCH v9] ndctl: Add support for get bus and region persistence
 domain
From: Dave Jiang <dave.jiang@intel.com>
Date: Wed, 21 Mar 2018 16:49:10 -0700
Message-ID: <152167600661.35262.16217551907257988883.stgit@djiang5-desk3.ch.intel.com>
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
attribute. The region will display the domain reported by sysfs for the
region.  The bus will display the domain attribute with the least persistence
amongst all the regions. ndctl_bus_get_persistence_domain() and
ndctl_region_get_persistence_domain are exported. ndctl list will also display
the region persistence domain as well.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
v9:
- Clean up after "libnvdimm, nfit: fix persistence domain reporting" kernel
  patch changes.

v8:
- Fix get ndctl_bus_get_persistence_domain logic

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

 ndctl/lib/libndctl.c   |   42 ++++++++++++++++++++++++++++++++++++++++++
 ndctl/lib/libndctl.sym |    2 ++
 ndctl/libndctl.h       |   14 ++++++++++++++
 ndctl/list.c           |   20 ++++++++++++++++++++
 4 files changed, 78 insertions(+)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index a165e697..2a20dd16 100644
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
+	enum ndctl_persistence_domain pd = PERSISTENCE_UNINIT;
+
+	/* iterate through region to get the region persistence domain */
+	ndctl_region_foreach(bus, region) {
+		/* we are looking for the least persistence domain */
+		if (pd < region->persistence_domain)
+			pd = region->persistence_domain;
+	}
+
+	return pd;
+}
+
 NDCTL_EXPORT struct ndctl_btt *ndctl_region_get_btt_seed(struct ndctl_region *region)
 {
 	struct ndctl_ctx *ctx = ndctl_region_get_ctx(region);
@@ -1755,6 +1772,18 @@ static int region_set_type(struct ndctl_region *region, char *path)
 	return 0;
 }
 
+static enum ndctl_persistence_domain region_get_pd_type(char *name)
+{
+	if (strncmp("cpu_cache", name, 9) == 0)
+		return PERSISTENCE_CPU_CACHE;
+	else if (strncmp("memory_controller", name, 17) == 0)
+		return PERSISTENCE_MEM_CTRL;
+	else if (strncmp("none", name, 4) == 0)
+		return PERSISTENCE_NONE;
+	else
+		return PERSISTENCE_UNKNOWN;
+}
+
 static void *add_region(void *parent, int id, const char *region_base)
 {
 	char buf[SYSFS_ATTR_SIZE];
@@ -1830,6 +1859,13 @@ static void *add_region(void *parent, int id, const char *region_base)
 
 	list_add(&bus->regions, &region->list);
 
+	/* get the persistence domain attrib */
+	sprintf(path, "%s/persistence_domain", region_base);
+	if (sysfs_read_attr(ctx, path, buf) < 0)
+		region->persistence_domain = PERSISTENCE_UNKNOWN;
+	else
+		region->persistence_domain = region_get_pd_type(buf);
+
 	free(path);
 	return region;
 
@@ -2093,6 +2129,12 @@ NDCTL_EXPORT struct badblock *ndctl_region_get_first_badblock(struct ndctl_regio
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
index f3a27411..f79e903b 100644
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
@@ -305,6 +308,15 @@ struct badblock {
 	unsigned long long offset;
 	unsigned int len;
 };
+
+enum ndctl_persistence_domain {
+	PERSISTENCE_UNINIT = -1,
+	PERSISTENCE_NONE = 0,
+	PERSISTENCE_MEM_CTRL = 10,
+	PERSISTENCE_CPU_CACHE = 20,
+	PERSISTENCE_UNKNOWN = INT_MAX,
+};
+
 struct ndctl_region;
 struct ndctl_region *ndctl_region_get_first(struct ndctl_bus *bus);
 struct ndctl_region *ndctl_region_get_next(struct ndctl_region *region);
@@ -347,6 +359,8 @@ struct ndctl_region *ndctl_bus_get_region_by_physical_address(struct ndctl_bus *
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
