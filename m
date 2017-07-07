Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 96EA021CF25AC
 for <linux-nvdimm@lists.01.org>; Fri,  7 Jul 2017 13:42:05 -0700 (PDT)
Subject: [ndctl PATCH 2/2] ndctl, daxctl,
 list: make terminal output human readable by default
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 07 Jul 2017 13:37:19 -0700
Message-ID: <149945983929.8106.4272492236620642213.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149945982889.8106.13607379131149182964.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149945982889.8106.13607379131149182964.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
List-ID: <linux-nvdimm@lists.01.org>

The json output format of the 'list' commands is meant to make it easy
to ingest the data into other tools. However, for direct administrator
use of the utility it now offers human friendly formatting by default.

    Before:
    # ndctl list --region=7
    {
      "dev":"region7",
      "size":67108864,
      "available_size":67108864,
      "type":"pmem",
      "iset_id":-6382611090938810793,
      "badblock_count":8
    }

    After:
    # ndctl list --region=7
    {
      "dev":"region7",
      "size":"64.00 MiB",
      "available_size":"64.00 MiB",
      "type":"pmem",
      "iset_id":"0xa76c6907811fae57",
      "badblock_count":8
    }

The old behavior is still the default when stdout is a pipe and the
output can be forced into that mode with the --format=machine option.

Reported-by: Linda Knippers <linda.knippers@hpe.com>
Reported-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/daxctl/daxctl-list.txt |   21 +++++++
 Documentation/ndctl/ndctl-list.txt   |   30 +++++++++
 daxctl/list.c                        |   19 ++++++
 ndctl/list.c                         |   34 +++++++++--
 ndctl/namespace.c                    |    7 ++
 util/json.c                          |  108 +++++++++++++++++++++++++++++++---
 util/json.h                          |   11 +++
 7 files changed, 211 insertions(+), 19 deletions(-)

diff --git a/Documentation/daxctl/daxctl-list.txt b/Documentation/daxctl/daxctl-list.txt
index 6de8d828de27..8cae0cd050fe 100644
--- a/Documentation/daxctl/daxctl-list.txt
+++ b/Documentation/daxctl/daxctl-list.txt
@@ -72,6 +72,27 @@ OPTIONS
 -i::
 --idle::
 	Include idle (not enabled / zero-sized) devices in the listing
+-f::
+--format=::
+	By default 'daxctl list' will detect if it is being run
+	interactively (stdout is a tty) and convert some JSON integer
+	values to more human readable strings. The --format=machine
+	option overrides that default and prints the raw decimal values
+	for all numbers, as would be the case if stdout was a pipe.
+	Specifying --format=human allow piping human friendly output to
+	a file.  Example:
+
+[verse]
+# daxctl list
+{
+  "chardev":"dax1.0",
+  "size":"30.57 GiB"
+}
+# daxctl list --format=machine
+{
+  "chardev":"dax1.0",
+  "size":32828817408
+}
 
 COPYRIGHT
 ---------
diff --git a/Documentation/ndctl/ndctl-list.txt b/Documentation/ndctl/ndctl-list.txt
index fd67d2b3e0ba..e9e9bcee54a8 100644
--- a/Documentation/ndctl/ndctl-list.txt
+++ b/Documentation/ndctl/ndctl-list.txt
@@ -180,6 +180,36 @@ include::xable-region-options.txt[]
   ]
 }
 
+-f::
+--format=::
+	By default 'ndctl list' will detect if it is being run
+	interactively (stdout is a tty) and convert some JSON integer
+	values to more human readable strings. The --format=machine
+	option overrides that default and prints the raw decimal values
+	for all numbers, as would be the case if stdout was a pipe.
+	Specifying --format=human allows piping human friendly output to
+	a file.  Example:
+
+[verse]
+# ndctl list --region=7
+{
+  "dev":"region7",
+  "size":"64.00 MiB",
+  "available_size":"64.00 MiB",
+  "type":"pmem",
+  "iset_id":"0xa76c6907811fae57",
+  "badblock_count":8
+}
+# ndctl list --format=machine --region=7
+{
+  "dev":"region7",
+  "size":67108864,
+  "available_size":67108864,
+  "type":"pmem",
+  "iset_id":-6382611090938810793,
+  "badblock_count":8
+}
+
 COPYRIGHT
 ---------
 Copyright (c) 2016 - 2017, Intel Corporation. License GPLv2: GNU GPL
diff --git a/daxctl/list.c b/daxctl/list.c
index e213df138f07..5db216def63d 100644
--- a/daxctl/list.c
+++ b/daxctl/list.c
@@ -26,6 +26,7 @@ static struct {
 	bool devs;
 	bool regions;
 	bool idle;
+	bool tty;
 } list;
 
 static unsigned long listopts_to_flags(void)
@@ -36,14 +37,18 @@ static unsigned long listopts_to_flags(void)
 		flags |= UTIL_JSON_DAX;
 	if (list.idle)
 		flags |= UTIL_JSON_IDLE;
+	if (list.tty)
+		flags |= UTIL_JSON_TTY;
 	return flags;
 }
 
 static struct {
 	const char *dev;
+	const char *format;
 	int region_id;
 } param = {
 	.region_id = -1,
+	.format = "auto",
 };
 
 static int did_fail;
@@ -70,6 +75,9 @@ int cmd_list(int argc, const char **argv, void *ctx)
 		OPT_BOOLEAN('D', "devices", &list.devs, "include dax device info"),
 		OPT_BOOLEAN('R', "regions", &list.regions, "include dax region info"),
 		OPT_BOOLEAN('i', "idle", &list.idle, "include idle devices"),
+		OPT_STRING('f', "format", &param.format, "format-mode",
+				"select \'human\' vs \'machine\' friendly number formats "
+				" (default: \'auto\')"),
 		OPT_END(),
 	};
 	const char * const u[] = {
@@ -96,6 +104,17 @@ int cmd_list(int argc, const char **argv, void *ctx)
 	if (num_list_flags() == 0)
 		list.devs = true;
 
+	if (strcmp(param.format, "auto") == 0)
+		list.tty = isatty(1);
+	else if (strcmp(param.format, "human") == 0)
+		list.tty = true;
+	else if (strcmp(param.format, "machine") == 0)
+		list.tty = false;
+	else {
+		error("unknown format type \"%s\"\n", param.format);
+		usage_with_options(u, options);
+	}
+
 	daxctl_region_foreach(ctx, region) {
 		struct json_object *jregion = NULL;
 
diff --git a/ndctl/list.c b/ndctl/list.c
index 7ecfcc91b0ec..fe1bed3c3a24 100644
--- a/ndctl/list.c
+++ b/ndctl/list.c
@@ -37,6 +37,7 @@ static struct {
 	bool health;
 	bool dax;
 	bool media_errors;
+	bool tty;
 } list;
 
 static unsigned long listopts_to_flags(void)
@@ -49,6 +50,8 @@ static unsigned long listopts_to_flags(void)
 		flags |= UTIL_JSON_MEDIA_ERRORS;
 	if (list.dax)
 		flags |= UTIL_JSON_DAX;
+	if (list.tty)
+		flags |= UTIL_JSON_TTY;
 	return flags;
 }
 
@@ -59,7 +62,10 @@ static struct {
 	const char *dimm;
 	const char *mode;
 	const char *namespace;
-} param;
+	const char *format;
+} param = {
+	.format = "auto",
+};
 
 static int did_fail;
 static int jflag = JSON_C_TO_STRING_PRETTY;
@@ -160,12 +166,13 @@ static struct json_object *region_to_json(struct ndctl_region *region,
 		goto err;
 	json_object_object_add(jregion, "dev", jobj);
 
-	jobj = json_object_new_int64(ndctl_region_get_size(region));
+	jobj = util_json_object_size(ndctl_region_get_size(region), flags);
 	if (!jobj)
 		goto err;
 	json_object_object_add(jregion, "size", jobj);
 
-	jobj = json_object_new_int64(ndctl_region_get_available_size(region));
+	jobj = util_json_object_size(ndctl_region_get_available_size(region),
+			flags);
 	if (!jobj)
 		goto err;
 	json_object_object_add(jregion, "available_size", jobj);
@@ -186,8 +193,8 @@ static struct json_object *region_to_json(struct ndctl_region *region,
 
 	iset = ndctl_region_get_interleave_set(region);
 	if (iset) {
-		jobj = json_object_new_int64(
-				ndctl_interleave_set_get_cookie(iset));
+		jobj = util_json_object_hex(
+				ndctl_interleave_set_get_cookie(iset), flags);
 		if (!jobj)
 			fail("\n");
 		else
@@ -216,7 +223,7 @@ static struct json_object *region_to_json(struct ndctl_region *region,
 			json_object_object_add(jregion, "mappings", jmappings);
 		}
 
-		jmapping = util_mapping_to_json(mapping);
+		jmapping = util_mapping_to_json(mapping, listopts_to_flags());
 		if (!jmapping) {
 			fail("\n");
 			continue;
@@ -282,6 +289,9 @@ int cmd_list(int argc, const char **argv, void *ctx)
 		OPT_BOOLEAN('i', "idle", &list.idle, "include idle devices"),
 		OPT_BOOLEAN('M', "media-errors", &list.media_errors,
 				"include media errors"),
+		OPT_STRING('f', "format", &param.format, "format-mode",
+				"select \'human\' vs \'machine\' friendly number formats "
+				" (default: \'auto\')"),
 		OPT_END(),
 	};
 	const char * const u[] = {
@@ -332,6 +342,18 @@ int cmd_list(int argc, const char **argv, void *ctx)
 		return -EINVAL;
 	}
 
+	if (strcmp(param.format, "auto") == 0)
+		list.tty = isatty(1);
+	else if (strcmp(param.format, "human") == 0)
+		list.tty = true;
+	else if (strcmp(param.format, "machine") == 0)
+		list.tty = false;
+	else {
+		error("unknown format type \"%s\"\n", param.format);
+		usage_with_options(u, options);
+	}
+
+
 	ndctl_bus_foreach(ctx, bus) {
 		struct json_object *jbus = NULL;
 		struct ndctl_region *region;
diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index b28936cfd3ec..a0c2b95e7d38 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -397,9 +397,12 @@ static int setup_namespace(struct ndctl_region *region,
 		error("%s: failed to enable\n",
 				ndctl_namespace_get_devname(ndns));
 	} else {
-		struct json_object *jndns = util_namespace_to_json(ndns,
-				UTIL_JSON_DAX);
+		unsigned long flags = UTIL_JSON_DAX;
+		struct json_object *jndns;
 
+		if (isatty(1))
+			flags |= UTIL_JSON_TTY;
+		jndns = util_namespace_to_json(ndns, flags);
 		if (jndns)
 			printf("%s\n", json_object_to_json_string_ext(jndns,
 						JSON_C_TO_STRING_PRETTY));
diff --git a/util/json.c b/util/json.c
index 1863bca10121..0a2053e1d1eb 100644
--- a/util/json.c
+++ b/util/json.c
@@ -11,10 +11,12 @@
  * General Public License for more details.
  */
 #include <limits.h>
+#include <string.h>
 #include <util/json.h>
 #include <util/filter.h>
 #include <uuid/uuid.h>
 #include <json-c/json.h>
+#include <json-c/printbuf.h>
 #include <ndctl/libndctl.h>
 #include <daxctl/libdaxctl.h>
 #include <ccan/array_size/array_size.h>
@@ -25,6 +27,92 @@
 #include <ndctl.h>
 #endif
 
+enum {
+	IEC,
+	JEDEC,
+};
+
+/* stolen from mdadm::human_size_brief() */
+static int display_size(struct json_object *jobj, struct printbuf *pbuf,
+		int level, int flags)
+{
+	unsigned long long bytes = json_object_get_int64(jobj);
+	static const int prefix = IEC;
+	static char buf[32];
+
+	/*
+	 * We convert bytes to either centi-M{ega,ibi}bytes or
+	 * centi-G{igi,ibi}bytes, with appropriate rounding, and then print
+	 * 1/100th of those as a decimal.  We allow upto 2048Megabytes before
+	 * converting to gigabytes, as that shows more precision and isn't too
+	 * large a number.  Terabytes are not yet handled.
+	 *
+	 * If prefix == IEC, we mean prefixes like kibi,mebi,gibi etc.
+	 * If prefix == JEDEC, we mean prefixes like kilo,mega,giga etc.
+	 */
+
+	if (bytes < 5000*1024)
+		snprintf(buf, sizeof(buf), "%lld", bytes);
+	else if (prefix == IEC) {
+		if (bytes < 2*1024LL*1024LL*1024LL) {
+			long cMiB = (bytes * 200LL / (1LL<<20) +1) /2;
+
+			snprintf(buf, sizeof(buf), "\"%ld.%02ld MiB\"",
+					cMiB/100 , cMiB % 100);
+		} else {
+			long cGiB = (bytes * 200LL / (1LL<<30) +1) /2;
+
+			snprintf(buf, sizeof(buf), "\"%ld.%02ld GiB\"",
+					cGiB/100 , cGiB % 100);
+		}
+	} else if (prefix == JEDEC) {
+		if (bytes < 2*1024LL*1024LL*1024LL) {
+			long cMB  = (bytes / (1000000LL / 200LL) + 1) / 2;
+
+			snprintf(buf, sizeof(buf), "\"%ld.%02ld MB\"",
+					cMB/100, cMB % 100);
+		} else {
+			long cGB  = (bytes / (1000000000LL/200LL) + 1) / 2;
+
+			snprintf(buf, sizeof(buf), "\"%ld.%02ld GB\"",
+					cGB/100 , cGB % 100);
+		}
+	} else
+		buf[0] = 0;
+
+	return printbuf_memappend(pbuf, buf, strlen(buf));
+}
+
+static int display_hex(struct json_object *jobj, struct printbuf *pbuf,
+		int level, int flags)
+{
+	unsigned long long val = json_object_get_int64(jobj);
+	static char buf[32];
+
+	snprintf(buf, sizeof(buf), "\"%#llx\"", val);
+	return printbuf_memappend(pbuf, buf, strlen(buf));
+}
+
+struct json_object *util_json_object_size(unsigned long long size,
+		unsigned long flags)
+{
+	struct json_object *jobj = json_object_new_int64(size);
+
+	if (jobj && (flags & UTIL_JSON_TTY))
+		json_object_set_serializer(jobj, display_size, NULL, NULL);
+	return jobj;
+}
+
+struct json_object *util_json_object_hex(unsigned long long val,
+		unsigned long flags)
+{
+	struct json_object *jobj = json_object_new_int64(val);
+
+	if (jobj && (flags & UTIL_JSON_TTY))
+		json_object_set_serializer(jobj, display_hex, NULL, NULL);
+	return jobj;
+}
+
 void util_display_json_array(FILE *f_out, struct json_object *jarray, int jflag)
 {
 	int len = json_object_array_length(jarray);
@@ -140,7 +228,8 @@ struct json_object *util_dimm_to_json(struct ndctl_dimm *dimm)
 	return NULL;
 }
 
-struct json_object *util_daxctl_dev_to_json(struct daxctl_dev *dev)
+struct json_object *util_daxctl_dev_to_json(struct daxctl_dev *dev,
+		unsigned long flags)
 {
 	const char *devname = daxctl_dev_get_devname(dev);
 	struct json_object *jdev, *jobj;
@@ -153,7 +242,7 @@ struct json_object *util_daxctl_dev_to_json(struct daxctl_dev *dev)
 	if (jobj)
 		json_object_object_add(jdev, "chardev", jobj);
 
-	jobj = json_object_new_int64(daxctl_dev_get_size(dev));
+	jobj = util_json_object_size(daxctl_dev_get_size(dev), flags);
 	if (jobj)
 		json_object_object_add(jdev, "size", jobj);
 
@@ -181,7 +270,7 @@ struct json_object *util_daxctl_devs_to_list(struct daxctl_region *region,
 				return NULL;
 		}
 
-		jdev = util_daxctl_dev_to_json(dev);
+		jdev = util_daxctl_dev_to_json(dev, flags);
 		if (!jdev) {
 			json_object_put(jdevs);
 			return NULL;
@@ -211,7 +300,7 @@ struct json_object *util_daxctl_region_to_json(struct daxctl_region *region,
 
 	size = daxctl_region_get_size(region);
 	if (size < ULLONG_MAX) {
-		jobj = json_object_new_int64(size);
+		jobj = util_json_object_size(size, flags);
 		if (!jobj)
 			goto err;
 		json_object_object_add(jregion, "size", jobj);
@@ -219,7 +308,7 @@ struct json_object *util_daxctl_region_to_json(struct daxctl_region *region,
 
 	available_size = daxctl_region_get_available_size(region);
 	if (available_size) {
-		jobj = json_object_new_int64(available_size);
+		jobj = util_json_object_size(available_size, flags);
 		if (!jobj)
 			goto err;
 		json_object_object_add(jregion, "available_size", jobj);
@@ -490,7 +579,7 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 		json_object_object_add(jndns, "mode", jobj);
 
 	if (size < ULLONG_MAX) {
-		jobj = json_object_new_int64(size);
+		jobj = util_json_object_size(size, flags);
 		if (jobj)
 			json_object_object_add(jndns, "size", jobj);
 	}
@@ -604,7 +693,8 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 	return NULL;
 }
 
-struct json_object *util_mapping_to_json(struct ndctl_mapping *mapping)
+struct json_object *util_mapping_to_json(struct ndctl_mapping *mapping,
+		unsigned long flags)
 {
 	struct json_object *jmapping = json_object_new_object();
 	struct ndctl_dimm *dimm = ndctl_mapping_get_dimm(mapping);
@@ -618,12 +708,12 @@ struct json_object *util_mapping_to_json(struct ndctl_mapping *mapping)
 		goto err;
 	json_object_object_add(jmapping, "dimm", jobj);
 
-	jobj = json_object_new_int64(ndctl_mapping_get_offset(mapping));
+	jobj = util_json_object_hex(ndctl_mapping_get_offset(mapping), flags);
 	if (!jobj)
 		goto err;
 	json_object_object_add(jmapping, "offset", jobj);
 
-	jobj = json_object_new_int64(ndctl_mapping_get_length(mapping));
+	jobj = util_json_object_hex(ndctl_mapping_get_length(mapping), flags);
 	if (!jobj)
 		goto err;
 	json_object_object_add(jmapping, "length", jobj);
diff --git a/util/json.h b/util/json.h
index 19d5ffc4376e..a46ac4fa92ce 100644
--- a/util/json.h
+++ b/util/json.h
@@ -20,13 +20,15 @@ enum util_json_flags {
 	UTIL_JSON_IDLE = (1 << 0),
 	UTIL_JSON_MEDIA_ERRORS = (1 << 1),
 	UTIL_JSON_DAX = (1 << 2),
+	UTIL_JSON_TTY = (1 << 3),
 };
 
 struct json_object;
 void util_display_json_array(FILE *f_out, struct json_object *jarray, int jflag);
 struct json_object *util_bus_to_json(struct ndctl_bus *bus);
 struct json_object *util_dimm_to_json(struct ndctl_dimm *dimm);
-struct json_object *util_mapping_to_json(struct ndctl_mapping *mapping);
+struct json_object *util_mapping_to_json(struct ndctl_mapping *mapping,
+		unsigned long flags);
 struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 		unsigned long flags);
 struct daxctl_region;
@@ -35,10 +37,15 @@ struct json_object *util_region_badblocks_to_json(struct ndctl_region *region,
 		unsigned int *bb_count, unsigned long flags);
 struct json_object *util_daxctl_region_to_json(struct daxctl_region *region,
 		const char *ident, unsigned long flags);
-struct json_object *util_daxctl_dev_to_json(struct daxctl_dev *dev);
+struct json_object *util_daxctl_dev_to_json(struct daxctl_dev *dev,
+		unsigned long flags);
 struct json_object *util_daxctl_devs_to_list(struct daxctl_region *region,
 		struct json_object *jdevs, const char *ident,
 		unsigned long flags);
+struct json_object *util_json_object_size(unsigned long long size,
+		unsigned long flags);
+struct json_object *util_json_object_hex(unsigned long long val,
+		unsigned long flags);
 #ifdef HAVE_NDCTL_SMART
 struct json_object *util_dimm_health_to_json(struct ndctl_dimm *dimm);
 #else

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
