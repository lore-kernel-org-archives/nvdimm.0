Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AD83D81A52
 for <linux-nvdimm@lists.01.org>; Fri,  6 Jan 2017 17:46:43 -0800 (PST)
Subject: [ndctl PATCH 5/7] daxctl: add list command
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 06 Jan 2017 17:42:33 -0800
Message-ID: <148375335295.38836.4950992840727828323.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <148375332631.38836.5735184615585844571.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <148375332631.38836.5735184615585844571.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Similar to "ndctl list", provide a utility for generically dumping all
the device-dax regions and device instances in a system.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Makefile.am            |    2 -
 builtin.h              |    0 
 configure.ac           |    1 
 daxctl/Makefile.am     |   13 ++++++
 daxctl/daxctl.c        |   91 +++++++++++++++++++++++++++++++++++++++
 daxctl/lib/Makefile.am |    3 +
 daxctl/libdaxctl.h     |    1 
 daxctl/list.c          |  112 ++++++++++++++++++++++++++++++++++++++++++++++++
 ndctl.spec.in          |   12 +++++
 test/device-dax.c      |    2 -
 test/multi-pmem.c      |    2 -
 util/filter.c          |   21 +++++++++
 util/filter.h          |    6 ++-
 util/json.c            |  113 +++++++++++++++++++++++++++++++++++++++---------
 util/json.h            |    8 +++
 15 files changed, 360 insertions(+), 27 deletions(-)
 rename ndctl/builtin.h => builtin.h (100%)
 create mode 100644 daxctl/Makefile.am
 create mode 100644 daxctl/daxctl.c
 create mode 100644 daxctl/list.c

diff --git a/Makefile.am b/Makefile.am
index 01caca803540..06cd1b059160 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,7 +1,7 @@
 include Makefile.am.in
 
 ACLOCAL_AMFLAGS = -I m4 ${ACLOCAL_FLAGS}
-SUBDIRS = . daxctl/lib ndctl/lib ndctl
+SUBDIRS = . daxctl/lib ndctl/lib ndctl daxctl
 if ENABLE_DOCS
 SUBDIRS += Documentation
 endif
diff --git a/ndctl/builtin.h b/builtin.h
similarity index 100%
rename from ndctl/builtin.h
rename to builtin.h
diff --git a/configure.ac b/configure.ac
index 7b4af616cf2b..e79623ac1d82 100644
--- a/configure.ac
+++ b/configure.ac
@@ -263,6 +263,7 @@ AC_CONFIG_FILES([
         daxctl/lib/Makefile
         ndctl/lib/Makefile
         ndctl/Makefile
+        daxctl/Makefile
         test/Makefile
         Documentation/Makefile
 ])
diff --git a/daxctl/Makefile.am b/daxctl/Makefile.am
new file mode 100644
index 000000000000..9153c418cdaf
--- /dev/null
+++ b/daxctl/Makefile.am
@@ -0,0 +1,13 @@
+include $(top_srcdir)/Makefile.am.in
+
+bin_PROGRAMS = daxctl
+
+daxctl_SOURCES =\
+		daxctl.c \
+		list.c \
+		../util/json.c
+
+daxctl_LDADD =\
+	lib/libdaxctl.la \
+	../libutil.a \
+	$(JSON_LIBS)
diff --git a/daxctl/daxctl.c b/daxctl/daxctl.c
new file mode 100644
index 000000000000..31d230a68756
--- /dev/null
+++ b/daxctl/daxctl.c
@@ -0,0 +1,91 @@
+#include <stdio.h>
+#include <errno.h>
+#include <string.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <daxctl/libdaxctl.h>
+#include <util/parse-options.h>
+#include <ccan/array_size/array_size.h>
+
+#include <util/strbuf.h>
+#include <util/util.h>
+#include <util/main.h>
+#include <builtin.h>
+
+const char daxctl_usage_string[] = "daxctl [--version] [--help] COMMAND [ARGS]";
+const char daxctl_more_info_string[] =
+	"See 'daxctl help COMMAND' for more information on a specific command.\n"
+	" daxctl --list-cmds to see all available commands";
+
+static int cmd_version(int argc, const char **argv, void *ctx)
+{
+	printf("%s\n", VERSION);
+	return 0;
+}
+
+static int cmd_help(int argc, const char **argv, void *ctx)
+{
+	const char * const builtin_help_subcommands[] = {
+		"list", NULL,
+	};
+	struct option builtin_help_options[] = {
+		OPT_END(),
+	};
+	const char *builtin_help_usage[] = {
+		"daxctl help [command]",
+		NULL
+	};
+
+	argc = parse_options_subcommand(argc, argv, builtin_help_options,
+			builtin_help_subcommands, builtin_help_usage, 0);
+
+	if (!argv[0]) {
+		printf("\n usage: %s\n\n", daxctl_usage_string);
+		printf("\n %s\n\n", daxctl_more_info_string);
+		return 0;
+	}
+
+	return help_show_man_page(argv[0], "daxctl", "DAXCTL_MAN_VIEWER");
+}
+
+int cmd_list(int argc, const char **argv, void *ctx);
+
+static struct cmd_struct commands[] = {
+	{ "version", cmd_version },
+	{ "list", cmd_list },
+	{ "help", cmd_help },
+};
+
+int main(int argc, const char **argv)
+{
+	struct daxctl_ctx *ctx;
+	int rc;
+
+	/* Look for flags.. */
+	argv++;
+	argc--;
+	main_handle_options(&argv, &argc, daxctl_usage_string, commands,
+			ARRAY_SIZE(commands));
+
+	if (argc > 0) {
+		if (!prefixcmp(argv[0], "--"))
+			argv[0] += 2;
+	} else {
+		/* The user didn't specify a command; give them help */
+		printf("\n usage: %s\n\n", daxctl_usage_string);
+		printf("\n %s\n\n", daxctl_more_info_string);
+		goto out;
+	}
+
+	rc = daxctl_new(&ctx);
+	if (rc)
+		goto out;
+	main_handle_internal_command(argc, argv, ctx, commands,
+			ARRAY_SIZE(commands));
+	daxctl_unref(ctx);
+	fprintf(stderr, "Unknown command: '%s'\n", argv[0]);
+out:
+	return 1;
+}
diff --git a/daxctl/lib/Makefile.am b/daxctl/lib/Makefile.am
index 92783847266a..0167e3995b00 100644
--- a/daxctl/lib/Makefile.am
+++ b/daxctl/lib/Makefile.am
@@ -15,6 +15,9 @@ libdaxctl_la_SOURCES =\
 	../../util/log.h \
 	libdaxctl.c
 
+libdaxctl_la_LIBADD =\
+	$(UUID_LIBS)
+
 EXTRA_DIST += libdaxctl.sym
 
 libdaxctl_la_LDFLAGS = $(AM_LDFLAGS) \
diff --git a/daxctl/libdaxctl.h b/daxctl/libdaxctl.h
index 071cb1b17e6e..b65dc3083048 100644
--- a/daxctl/libdaxctl.h
+++ b/daxctl/libdaxctl.h
@@ -15,6 +15,7 @@
 
 #include <stdarg.h>
 #include <unistd.h>
+#include <uuid.h>
 
 #ifdef __cplusplus
 extern "C" {
diff --git a/daxctl/list.c b/daxctl/list.c
new file mode 100644
index 000000000000..9a48ad7477ff
--- /dev/null
+++ b/daxctl/list.c
@@ -0,0 +1,112 @@
+#include <stdio.h>
+#include <errno.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <limits.h>
+#include <util/json.h>
+#include <util/filter.h>
+#include <json-c/json.h>
+#include <daxctl/libdaxctl.h>
+#include <util/parse-options.h>
+#include <ccan/array_size/array_size.h>
+
+static struct {
+	bool devs;
+	bool regions;
+	bool idle;
+} list;
+
+static struct {
+	const char *dev;
+	int region_id;
+} param = {
+	.region_id = -1,
+};
+
+static int did_fail;
+static int jflag = JSON_C_TO_STRING_PRETTY;
+
+#define fail(fmt, ...) \
+do { \
+	did_fail = 1; \
+	fprintf(stderr, "daxctl-%s:%s:%d: " fmt, \
+			VERSION, __func__, __LINE__, ##__VA_ARGS__); \
+} while (0)
+
+static int num_list_flags(void)
+{
+	return list.regions + list.devs;
+}
+
+int cmd_list(int argc, const char **argv, void *ctx)
+{
+	const struct option options[] = {
+		OPT_INTEGER('r', "region", &param.region_id, "filter by region"),
+		OPT_STRING('d', "dev", &param.dev, "dev-id",
+				"filter by dax device instance name"),
+		OPT_BOOLEAN('D', "devices", &list.devs, "include dax device info"),
+		OPT_BOOLEAN('R', "regions", &list.regions, "include dax region info"),
+		OPT_BOOLEAN('i', "idle", &list.idle, "include idle devices"),
+		OPT_END(),
+	};
+	const char * const u[] = {
+		"daxctl list [<options>]",
+		NULL
+	};
+	struct json_object *jregions = NULL;
+	struct json_object *jdevs = NULL;
+	struct daxctl_region *region;
+	int i;
+
+        argc = parse_options(argc, argv, options, u, 0);
+	for (i = 0; i < argc; i++)
+		error("unknown parameter \"%s\"\n", argv[i]);
+
+	if (argc)
+		usage_with_options(u, options);
+
+	if (num_list_flags() == 0) {
+		list.regions = param.region_id >= 0;
+		list.devs = !!param.dev;
+	}
+
+	if (num_list_flags() == 0)
+		list.devs = true;
+
+	daxctl_region_foreach(ctx, region) {
+		struct json_object *jregion = NULL;
+
+		if (param.region_id >= 0 && param.region_id
+				!= daxctl_region_get_id(region))
+			continue;
+
+		if (list.regions) {
+			if (!jregions) {
+				jregions = json_object_new_array();
+				if (!jregions) {
+					fail("\n");
+					continue;
+				}
+			}
+
+			jregion = util_daxctl_region_to_json(region,
+					list.devs, param.dev, list.idle);
+			if (!jregion) {
+				fail("\n");
+				continue;
+			}
+			json_object_array_add(jregions, jregion);
+		} else if (list.devs)
+			jdevs = util_daxctl_devs_to_list(region,
+					jdevs, param.dev, list.idle);
+	}
+
+	if (jregions)
+		util_display_json_array(stdout, jregions, jflag);
+	else if (jdevs)
+		util_display_json_array(stdout, jdevs, jflag);
+
+	if (did_fail)
+		return -ENOMEM;
+	return 0;
+}
diff --git a/ndctl.spec.in b/ndctl.spec.in
index 06e0e390a17b..6453edd1954c 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -38,6 +38,18 @@ Requires:	LNAME%{?_isa} = %{version}-%{release}
 The %{name}-devel package contains libraries and header files for
 developing applications that use %{name}.
 
+%package -n daxctl
+Summary:	Manage Device-DAX instances
+License:	GPLv2
+Group:		System Environment/Base
+Requires:	DAX_LNAME%{?_isa} = %{version}-%{release}
+
+%description -n daxctl
+The daxctl utility provides enumeration and provisioning commands for
+the Linux kernel Device-DAX facility. This facility enables DAX mappings
+of performance / feature differentiated memory without need of a
+filesystem.
+
 %package -n DAX_DNAME
 Summary:	Development files for libdaxctl
 License:	LGPLv2
diff --git a/test/device-dax.c b/test/device-dax.c
index 0ace922ee55d..f5ab3898f78c 100644
--- a/test/device-dax.c
+++ b/test/device-dax.c
@@ -18,7 +18,7 @@
 #include <daxctl/libdaxctl.h>
 #include <ccan/array_size/array_size.h>
 
-#include <ndctl/builtin.h>
+#include <builtin.h>
 #include <test.h>
 
 static sigjmp_buf sj_env;
diff --git a/test/multi-pmem.c b/test/multi-pmem.c
index a7aedd9b5025..126669bda88d 100644
--- a/test/multi-pmem.c
+++ b/test/multi-pmem.c
@@ -22,7 +22,7 @@
 #include <ndctl.h>
 #endif
 
-#include <ndctl/builtin.h>
+#include <builtin.h>
 #include <test.h>
 
 #define NUM_NAMESPACES 4
diff --git a/util/filter.c b/util/filter.c
index 97f0dec3569c..9e2133430433 100644
--- a/util/filter.c
+++ b/util/filter.c
@@ -4,6 +4,7 @@
 #include <limits.h>
 #include <util/filter.h>
 #include <ndctl/libndctl.h>
+#include <daxctl/libdaxctl.h>
 
 struct ndctl_bus *util_bus_filter(struct ndctl_bus *bus, const char *ident)
 {
@@ -158,3 +159,23 @@ struct ndctl_region *util_region_filter_by_dimm(struct ndctl_region *region,
 
 	return NULL;
 }
+
+struct daxctl_dev *util_daxctl_dev_filter(struct daxctl_dev *dev,
+		const char *ident)
+{
+	struct daxctl_region *region = daxctl_dev_get_region(dev);
+	int region_id, dev_id;
+
+	if (!ident || strcmp(ident, "all") == 0)
+		return dev;
+
+	if (strcmp(ident, daxctl_dev_get_devname(dev)) == 0)
+		return dev;
+
+	if (sscanf(ident, "%d.%d", &region_id, &dev_id) == 2
+			&& daxctl_region_get_id(region) == region_id
+			&& daxctl_dev_get_id(dev) == dev_id)
+		return dev;
+
+	return NULL;
+}
diff --git a/util/filter.h b/util/filter.h
index 52be4c32d5bf..cc23bfd7bfc8 100644
--- a/util/filter.h
+++ b/util/filter.h
@@ -1,5 +1,5 @@
-#ifndef _NDCTL_FILTER_H_
-#define _NDCTL_FILTER_H_
+#ifndef _UTIL_FILTER_H_
+#define _UTIL_FILTER_H_
 struct ndctl_bus *util_bus_filter(struct ndctl_bus *bus, const char *ident);
 struct ndctl_region *util_region_filter(struct ndctl_region *region,
 		const char *ident);
@@ -10,4 +10,6 @@ struct ndctl_bus *util_bus_filter_by_dimm(struct ndctl_bus *bus,
 		const char *ident);
 struct ndctl_region *util_region_filter_by_dimm(struct ndctl_region *region,
 		const char *ident);
+struct daxctl_dev *util_daxctl_dev_filter(struct daxctl_dev *dev,
+		const char *ident);
 #endif
diff --git a/util/json.c b/util/json.c
index 299c1b5782ee..d6a8d4c899ed 100644
--- a/util/json.c
+++ b/util/json.c
@@ -1,5 +1,6 @@
 #include <limits.h>
 #include <util/json.h>
+#include <util/filter.h>
 #include <uuid/uuid.h>
 #include <json-c/json.h>
 #include <ndctl/libndctl.h>
@@ -100,42 +101,109 @@ bool util_namespace_active(struct ndctl_namespace *ndns)
 	return false;
 }
 
-static json_object *util_daxctl_region_to_json(struct daxctl_region *region,
-		bool include_idle)
+struct json_object *util_daxctl_dev_to_json(struct daxctl_dev *dev)
 {
-	struct json_object *jdaxdevs = json_object_new_array();
-	struct json_object *jobj;
-	struct daxctl_dev *dev;
+	const char *devname = daxctl_dev_get_devname(dev);
+	struct json_object *jdev, *jobj;
 
-	if (!jdaxdevs)
+	jdev = json_object_new_object();
+	if (!devname || !jdev)
 		return NULL;
 
+	jobj = json_object_new_string(devname);
+	if (jobj)
+		json_object_object_add(jdev, "chardev", jobj);
+
+	jobj = json_object_new_int64(daxctl_dev_get_size(dev));
+	if (jobj)
+		json_object_object_add(jdev, "size", jobj);
+
+	return jdev;
+}
+
+struct json_object *util_daxctl_devs_to_list(struct daxctl_region *region,
+		struct json_object *jdevs, const char *ident, bool include_idle)
+{
+	struct daxctl_dev *dev;
+
 	daxctl_dev_foreach(region, dev) {
-		const char *devname = daxctl_dev_get_devname(dev);
 		struct json_object *jdev;
 
-		if (daxctl_dev_get_size(dev) == 0 && !include_idle)
+		if (!util_daxctl_dev_filter(dev, ident))
 			continue;
 
-		jdev = json_object_new_object();
-		if (!devname || !jdev)
+		if (!include_idle && !daxctl_dev_get_size(dev))
 			continue;
-		jobj = json_object_new_string(devname);
-		if (jobj)
-			json_object_object_add(jdev, "chardev", jobj);
 
-		jobj = json_object_new_int64(daxctl_dev_get_size(dev));
-		if (jobj)
-			json_object_object_add(jdev, "size", jobj);
+		if (!jdevs) {
+			jdevs = json_object_new_array();
+			if (!jdevs)
+				return NULL;
+		}
+
+		jdev = util_daxctl_dev_to_json(dev);
+		if (!jdev) {
+			json_object_put(jdevs);
+			return NULL;
+		}
 
-		json_object_array_add(jdaxdevs, jdev);
+		json_object_array_add(jdevs, jdev);
 	}
 
-	if (json_object_array_length(jdaxdevs) < 1) {
-		json_object_put(jdaxdevs);
+	return jdevs;
+}
+
+struct json_object *util_daxctl_region_to_json(struct daxctl_region *region,
+		bool include_devs, const char *ident, bool include_idle)
+{
+	unsigned long align;
+	struct json_object *jregion, *jobj;
+	unsigned long long available_size, size;
+
+	jregion = json_object_new_object();
+	if (!jregion)
 		return NULL;
+
+	jobj = json_object_new_int(daxctl_region_get_id(region));
+	if (!jobj)
+		goto err;
+	json_object_object_add(jregion, "id", jobj);
+
+	size = daxctl_region_get_size(region);
+	if (size < ULLONG_MAX) {
+		jobj = json_object_new_int64(size);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jregion, "size", jobj);
+	}
+
+	available_size = daxctl_region_get_available_size(region);
+	if (available_size) {
+		jobj = json_object_new_int64(available_size);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jregion, "available_size", jobj);
 	}
-	return jdaxdevs;
+
+	align = daxctl_region_get_align(region);
+	if (align < ULONG_MAX) {
+		jobj = json_object_new_int64(align);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jregion, "align", jobj);
+	}
+
+	if (!include_devs)
+		return jregion;
+
+	jobj = util_daxctl_devs_to_list(region, NULL, ident, include_idle);
+	if (jobj)
+		json_object_object_add(jregion, "devices", jobj);
+
+	return jregion;
+ err:
+	json_object_put(jregion);
+	return NULL;
 }
 
 struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
@@ -233,9 +301,10 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 		json_object_object_add(jndns, "uuid", jobj);
 		if (include_dax) {
 			dax_region = ndctl_dax_get_daxctl_region(dax);
-			jobj = util_daxctl_region_to_json(dax_region, include_idle);
+			jobj = util_daxctl_region_to_json(dax_region,
+					true, NULL, include_idle);
 			if (jobj)
-				json_object_object_add(jndns, "daxdevs", jobj);
+				json_object_object_add(jndns, "daxregion", jobj);
 		}
 	} else if (ndctl_namespace_get_type(ndns) != ND_DEVICE_NAMESPACE_IO) {
 		const char *name;
diff --git a/util/json.h b/util/json.h
index b8fc00f57ea8..a9afb2d43bbe 100644
--- a/util/json.h
+++ b/util/json.h
@@ -12,6 +12,14 @@ struct json_object *util_dimm_to_json(struct ndctl_dimm *dimm);
 struct json_object *util_mapping_to_json(struct ndctl_mapping *mapping);
 struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 		bool include_idle, bool include_dax);
+struct daxctl_region;
+struct daxctl_dev;
+struct json_object *util_daxctl_region_to_json(struct daxctl_region *region,
+		bool include_devs, const char *ident, bool include_idle);
+struct json_object *util_daxctl_dev_to_json(struct daxctl_dev *dev);
+struct json_object *util_daxctl_devs_to_list(struct daxctl_region *region,
+		struct json_object *jdevs, const char *ident,
+		bool include_idle);
 #ifdef HAVE_NDCTL_SMART
 struct json_object *util_dimm_health_to_json(struct ndctl_dimm *dimm);
 #else

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
