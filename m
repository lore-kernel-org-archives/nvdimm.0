Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id AB8B51A1E04
 for <linux-nvdimm@lists.01.org>; Wed,  3 Aug 2016 16:25:35 -0700 (PDT)
Subject: [ndctl PATCH 1/4] util: require --idle to list 0-sized device-dax
 instances
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 03 Aug 2016 16:23:11 -0700
Message-ID: <147026659169.11162.11230028300085720171.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147026658649.11162.4510254495491443980.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147026658649.11162.4510254495491443980.stgit@dwillia2-desk3.amr.corp.intel.com>
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

A 0-sized device-dax instance is an idle device-dax seed.  Hide them by
default unless we are explicitly listing idle objects.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/Makefile.am                 |    2 +-
 ndctl/builtin-list.c              |    2 +-
 ndctl/builtin-xaction-namespace.c |    2 +-
 ndctl/util/json.c                 |   14 ++++++++++----
 ndctl/util/json.h                 |    3 ++-
 5 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index 27e5182e28b5..04f3a63ff999 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -58,6 +58,7 @@ endif
 
 ndctl_LDADD =\
 	lib/libndctl.la \
+	../daxctl/lib/libdaxctl.la \
 	../libutil.a \
 	$(UUID_LIBS) \
 	$(KMOD_LIBS) \
@@ -68,7 +69,6 @@ ndctl_SOURCES += ../test/libndctl.c \
 		 ../test/dpa-alloc.c \
 		 ../test/parent-uuid.c \
 		 ../test/core.c
-ndctl_LDADD += ../daxctl/lib/libdaxctl.la
 endif
 
 
diff --git a/ndctl/builtin-list.c b/ndctl/builtin-list.c
index f7447ea1310f..0875ca95cd14 100644
--- a/ndctl/builtin-list.c
+++ b/ndctl/builtin-list.c
@@ -74,7 +74,7 @@ static struct json_object *list_namespaces(struct ndctl_region *region,
 						jnamespaces);
 		}
 
-		jndns = util_namespace_to_json(ndns);
+		jndns = util_namespace_to_json(ndns, list.idle);
 		if (!jndns) {
 			fail("\n");
 			continue;
diff --git a/ndctl/builtin-xaction-namespace.c b/ndctl/builtin-xaction-namespace.c
index cac891b13a57..8304203750d8 100644
--- a/ndctl/builtin-xaction-namespace.c
+++ b/ndctl/builtin-xaction-namespace.c
@@ -327,7 +327,7 @@ static int setup_namespace(struct ndctl_region *region,
 		error("%s: failed to enable\n",
 				ndctl_namespace_get_devname(ndns));
 	} else {
-		struct json_object *jndns = util_namespace_to_json(ndns);
+		struct json_object *jndns = util_namespace_to_json(ndns, 0);
 
 		if (jndns)
 			printf("%s\n", json_object_to_json_string_ext(jndns,
diff --git a/ndctl/util/json.c b/ndctl/util/json.c
index a9c096ce844e..64c697c1be55 100644
--- a/ndctl/util/json.c
+++ b/ndctl/util/json.c
@@ -100,7 +100,8 @@ bool util_namespace_active(struct ndctl_namespace *ndns)
 	return false;
 }
 
-static json_object *util_daxctl_region_to_json(struct daxctl_region *region)
+static json_object *util_daxctl_region_to_json(struct daxctl_region *region,
+		bool include_idle)
 {
 	struct json_object *jdaxdevs = json_object_new_array();
 	struct json_object *jobj;
@@ -111,8 +112,12 @@ static json_object *util_daxctl_region_to_json(struct daxctl_region *region)
 
 	daxctl_dev_foreach(region, dev) {
 		const char *devname = daxctl_dev_get_devname(dev);
-		struct json_object *jdev = json_object_new_object();
+		struct json_object *jdev;
 
+		if (daxctl_dev_get_size(dev) == 0 && !include_idle)
+			continue;
+
+		jdev = json_object_new_object();
 		if (!devname || !jdev)
 			continue;
 		jobj = json_object_new_string(devname);
@@ -133,7 +138,8 @@ static json_object *util_daxctl_region_to_json(struct daxctl_region *region)
 	return jdaxdevs;
 }
 
-struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns)
+struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
+		bool include_idle)
 {
 	struct json_object *jndns = json_object_new_object();
 	unsigned long long size = ULLONG_MAX;
@@ -223,7 +229,7 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns)
 			goto err;
 		json_object_object_add(jndns, "uuid", jobj);
 		dax_region = ndctl_dax_get_daxctl_region(dax);
-		jobj = util_daxctl_region_to_json(dax_region);
+		jobj = util_daxctl_region_to_json(dax_region, include_idle);
 		if (jobj)
 			json_object_object_add(jndns, "daxdevs", jobj);
 	} else if (ndctl_namespace_get_type(ndns) != ND_DEVICE_NAMESPACE_IO) {
diff --git a/ndctl/util/json.h b/ndctl/util/json.h
index f751699c9706..7492e51621a7 100644
--- a/ndctl/util/json.h
+++ b/ndctl/util/json.h
@@ -10,7 +10,8 @@ bool util_namespace_active(struct ndctl_namespace *ndns);
 struct json_object *util_bus_to_json(struct ndctl_bus *bus);
 struct json_object *util_dimm_to_json(struct ndctl_dimm *dimm);
 struct json_object *util_mapping_to_json(struct ndctl_mapping *mapping);
-struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns);
+struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
+		bool include_idle);
 #ifdef HAVE_NDCTL_SMART
 struct json_object *util_dimm_health_to_json(struct ndctl_dimm *dimm);
 #else

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
