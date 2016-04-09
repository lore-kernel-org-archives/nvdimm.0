Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 by ml01.01.org (Postfix) with ESMTP id C8F941A1EEC
 for <linux-nvdimm@lists.01.org>; Sat,  9 Apr 2016 12:40:36 -0700 (PDT)
Subject: [ndctl PATCH 3/4] ndctl: new 'read-labels' utility
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 09 Apr 2016 12:39:46 -0700
Message-ID: <20160409193946.2002.14881.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20160409193930.2002.71855.stgit@dwillia2-desk3.jf.intel.com>
References: <20160409193930.2002.71855.stgit@dwillia2-desk3.jf.intel.com>
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

For debug, it is useful to be able to dump the label area of a dimm.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/Makefile.am            |    5 
 Documentation/labels-description.txt |    6 
 Documentation/labels-options.txt     |   13 +
 Documentation/ndctl-read-labels.txt  |   30 ++
 Documentation/ndctl-zero-labels.txt  |   23 --
 Makefile.am                          |    1 
 builtin-list.c                       |   21 --
 builtin-read-labels.c                |  420 ++++++++++++++++++++++++++++++++++
 builtin.h                            |    1 
 ndctl.c                              |    1 
 util/json.c                          |   15 +
 util/json.h                          |    3 
 12 files changed, 501 insertions(+), 38 deletions(-)
 create mode 100644 Documentation/labels-description.txt
 create mode 100644 Documentation/labels-options.txt
 create mode 100644 Documentation/ndctl-read-labels.txt
 create mode 100644 builtin-read-labels.c

diff --git a/Documentation/Makefile.am b/Documentation/Makefile.am
index 3b3336918516..7fb49b8e4538 100644
--- a/Documentation/Makefile.am
+++ b/Documentation/Makefile.am
@@ -1,6 +1,7 @@
 man1_MANS = \
 	ndctl.1 \
 	ndctl-zero-labels.1 \
+	ndctl-read-labels.1 \
 	ndctl-enable-region.1 \
 	ndctl-disable-region.1 \
 	ndctl-enable-namespace.1 \
@@ -15,7 +16,9 @@ XML_DEPS = \
 	Makefile \
 	region-description.txt \
 	xable-region-options.txt \
-	xable-namespace-options.txt
+	xable-namespace-options.txt \
+	labels-description.txt \
+	labels-options.txt
 
 RM ?= rm -f
 
diff --git a/Documentation/labels-description.txt b/Documentation/labels-description.txt
new file mode 100644
index 000000000000..2dde3abe2935
--- /dev/null
+++ b/Documentation/labels-description.txt
@@ -0,0 +1,6 @@
+DESCRIPTION
+-----------
+The namespace label area is a small persistent partition of capacity
+available on some NVDIMM devices.  The label area is used to resolve
+aliasing between 'pmem' and 'blk' capacity by lineating namespace
+boundaries.
diff --git a/Documentation/labels-options.txt b/Documentation/labels-options.txt
new file mode 100644
index 000000000000..f39c2132178a
--- /dev/null
+++ b/Documentation/labels-options.txt
@@ -0,0 +1,13 @@
+<memory device(s)>...::
+	One or more 'nmemX' device names. The keyword 'all' can be specified to
+	operate on every dimm in the system, optionally filtered by bus id (see
+        --bus= option).
+
+-b::
+--bus=::
+	Limit operation to memory devices (dimms) that are on the given bus.
+	Where 'bus' can be a provider name or a bus id number.
+
+-v::
+	Turn on verbose debug messages in the library (if ndctl was built with
+	logging and debug enabled).
diff --git a/Documentation/ndctl-read-labels.txt b/Documentation/ndctl-read-labels.txt
new file mode 100644
index 000000000000..9c3acede8723
--- /dev/null
+++ b/Documentation/ndctl-read-labels.txt
@@ -0,0 +1,30 @@
+ndctl-read-labels(1)
+====================
+
+NAME
+----
+ndctl-read-labels - read out the label area on a dimm or set of dimms
+
+SYNOPSIS
+--------
+[verse]
+'ndctl read-labels' <nmem0> [<nmem1>..<nmemN>] [<options>]
+
+include::labels-description.txt[]
+This command dumps the raw binary data in a dimm's label area to stdout or a
+file.  In the multi-dimm case the data is concatenated.
+
+OPTIONS
+-------
+include::labels-options.txt[]
+-o::
+	output file
+-j::
+--json::
+	parse the label data into json assuming the 'NVDIMM Namespace
+	Specification' format.
+
+SEE ALSO
+--------
+http://pmem.io/documents/NVDIMM_Namespace_Spec.pdf[NVDIMM Namespace
+Specification]
diff --git a/Documentation/ndctl-zero-labels.txt b/Documentation/ndctl-zero-labels.txt
index d5865e34475f..0fb832b02219 100644
--- a/Documentation/ndctl-zero-labels.txt
+++ b/Documentation/ndctl-zero-labels.txt
@@ -10,30 +10,13 @@ SYNOPSIS
 [verse]
 'ndctl zero-labels' <nmem0> [<nmem1>..<nmemN>] [<options>]
 
-DESCRIPTION
------------
-The namespace label area is a small persistent partition of capacity
-available on some NVDIMM devices.  The label area is used to resolve
-aliasing between 'pmem' and 'blk' capacity by lineating namespace
-boundaries.  This command resets the device to its default state by
+include::labels-description.txt[]
+This command resets the device to its default state by
 deleting all labels.
 
 OPTIONS
 -------
-
-<memory device(s)>...::
-	One or more 'nmemX' device names. The keyword 'all' can be specified to
-	zero every dimm in the system, optionally filtered by bus id (see --bus=
-	option).
-
--b::
---bus=::
-	Limit zeroing to memory devices (dimms) that are on the given bus.
-	Where 'bus' can be a provider name or a bus id number.
-
--v::
-	Turn on verbose debug messages in the library (if ndctl was built with
-	logging and debug enabled).
+include::labels-options.txt[]
 
 SEE ALSO
 --------
diff --git a/Makefile.am b/Makefile.am
index 97e60f1f0cb4..98557f0fa4f8 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -99,6 +99,7 @@ ndctl_SOURCES = ndctl.c \
 		builtin-test.c \
 		builtin-help.c \
 		builtin-zero-labels.c \
+		builtin-read-labels.c \
 		util/parse-options.c \
 		util/parse-options.h \
 		util/usage.c \
diff --git a/builtin-list.c b/builtin-list.c
index 4e5f91cb5914..2080337252c8 100644
--- a/builtin-list.c
+++ b/builtin-list.c
@@ -179,19 +179,6 @@ static struct json_object *region_to_json(struct ndctl_region *region)
 	return NULL;
 }
 
-static void display_array(struct json_object *jarray)
-{
-	if (json_object_array_length(jarray) > 1)
-		printf("%s\n", json_object_to_json_string_ext(jarray, jflag));
-	else {
-		struct json_object *jobj;
-
-		jobj = json_object_array_get_idx(jarray, 0);
-		printf("%s\n", json_object_to_json_string_ext(jobj, jflag));
-	}
-	json_object_put(jarray);
-}
-
 int cmd_list(int argc, const char **argv)
 {
 	const struct option options[] = {
@@ -387,7 +374,7 @@ int cmd_list(int argc, const char **argv)
 	}
 
 	if (jbuses)
-		display_array(jbuses);
+		util_display_json_array(stdout, jbuses, jflag);
 	else if ((!!jdimms + !!jregions + !!jnamespaces) > 1) {
 		struct json_object *jplatform = json_object_new_object();
 
@@ -407,11 +394,11 @@ int cmd_list(int argc, const char **argv)
 					jflag));
 		json_object_put(jplatform);
 	} else if (jdimms)
-		display_array(jdimms);
+		util_display_json_array(stdout, jdimms, jflag);
 	else if (jregions)
-		display_array(jregions);
+		util_display_json_array(stdout, jregions, jflag);
 	else if (jnamespaces)
-		display_array(jnamespaces);
+		util_display_json_array(stdout, jnamespaces, jflag);
 
 	if (did_fail)
 		return -ENOMEM;
diff --git a/builtin-read-labels.c b/builtin-read-labels.c
new file mode 100644
index 000000000000..bea20184c7f8
--- /dev/null
+++ b/builtin-read-labels.c
@@ -0,0 +1,420 @@
+
+/*
+ * Copyright (c) 2016, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU Lesser General Public License,
+ * version 2.1, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT ANY
+ * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
+ * FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for
+ * more details.
+ */
+#include <stdio.h>
+#include <errno.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <limits.h>
+#include <syslog.h>
+#include <uuid/uuid.h>
+#include <util/filter.h>
+#include <util/json.h>
+#include <json-c/json.h>
+#include <ndctl/libndctl.h>
+#include <util/parse-options.h>
+#include <ccan/minmax/minmax.h>
+#define CCAN_SHORT_TYPES_H
+#include <ccan/endian/endian.h>
+
+enum {
+	NSINDEX_SIG_LEN = 16,
+	NSINDEX_ALIGN = 256,
+	NSINDEX_SEQ_MASK = 0x3,
+	NSLABEL_UUID_LEN = 16,
+	NSLABEL_NAME_LEN = 64,
+};
+
+struct namespace_index {
+        char sig[NSINDEX_SIG_LEN];
+        le32 flags;
+        le32 seq;
+        le64 myoff;
+        le64 mysize;
+        le64 otheroff;
+        le64 labeloff;
+        le32 nslot;
+        le16 major;
+        le16 minor;
+        le64 checksum;
+        char free[0];
+};
+
+struct namespace_label {
+	char uuid[NSLABEL_UUID_LEN];
+	char name[NSLABEL_NAME_LEN];
+	le32 flags;
+	le16 nlabel;
+	le16 position;
+	le64 isetcookie;
+	le64 lbasize;
+	le64 dpa;
+	le64 rawsize;
+	le32 slot;
+	le32 unused;
+};
+
+static struct json_object *dump_label_json(struct ndctl_cmd *cmd_read, ssize_t size)
+{
+	struct json_object *jarray = json_object_new_array();
+	struct json_object *jlabel = NULL;
+	struct namespace_label nslabel;
+	unsigned int slot = -1;
+	ssize_t offset;
+
+	if (!jarray)
+		return NULL;
+
+	for (offset = NSINDEX_ALIGN * 2; offset < size; offset += sizeof(nslabel)) {
+		ssize_t len = min_t(ssize_t, sizeof(nslabel), size - offset);
+		struct json_object *jobj;
+		char uuid[40];
+
+		slot++;
+		jlabel = json_object_new_object();
+		if (!jlabel)
+			break;
+
+		if (len < (ssize_t) sizeof(nslabel))
+			break;
+
+		len = ndctl_cmd_cfg_read_get_data(cmd_read, &nslabel, len, offset);
+		if (len < 0)
+			break;
+
+		if (le32_to_cpu(nslabel.slot) != slot)
+			continue;
+
+		uuid_unparse((void *) nslabel.uuid, uuid);
+		jobj = json_object_new_string(uuid);
+		if (!jobj)
+			break;
+		json_object_object_add(jlabel, "uuid", jobj);
+
+		nslabel.name[NSLABEL_NAME_LEN - 1] = 0;
+		jobj = json_object_new_string(nslabel.name);
+		if (!jobj)
+			break;
+		json_object_object_add(jlabel, "name", jobj);
+
+		jobj = json_object_new_int(le32_to_cpu(nslabel.slot));
+		if (!jobj)
+			break;
+		json_object_object_add(jlabel, "slot", jobj);
+
+		jobj = json_object_new_int(le16_to_cpu(nslabel.position));
+		if (!jobj)
+			break;
+		json_object_object_add(jlabel, "position", jobj);
+
+		jobj = json_object_new_int(le16_to_cpu(nslabel.nlabel));
+		if (!jobj)
+			break;
+		json_object_object_add(jlabel, "nlabel", jobj);
+
+		jobj = json_object_new_int64(le64_to_cpu(nslabel.isetcookie));
+		if (!jobj)
+			break;
+		json_object_object_add(jlabel, "isetcookie", jobj);
+
+		jobj = json_object_new_int64(le64_to_cpu(nslabel.dpa));
+		if (!jobj)
+			break;
+		json_object_object_add(jlabel, "dpa", jobj);
+
+		jobj = json_object_new_int64(le64_to_cpu(nslabel.rawsize));
+		if (!jobj)
+			break;
+		json_object_object_add(jlabel, "rawsize", jobj);
+
+		json_object_array_add(jarray, jlabel);
+	}
+
+	if (json_object_array_length(jarray) < 1) {
+		json_object_put(jarray);
+		if (jlabel)
+			json_object_put(jlabel);
+		jarray = NULL;
+	}
+
+	return jarray;
+}
+
+static struct json_object *dump_index_json(struct ndctl_cmd *cmd_read, ssize_t size)
+{
+	struct json_object *jarray = json_object_new_array();
+	struct json_object *jindex = NULL;
+	struct namespace_index nsindex;
+	ssize_t offset;
+
+	if (!jarray)
+		return NULL;
+
+	for (offset = 0; offset < NSINDEX_ALIGN * 2; offset += NSINDEX_ALIGN) {
+		ssize_t len = min_t(ssize_t, sizeof(nsindex), size - offset);
+		struct json_object *jobj;
+
+		jindex = json_object_new_object();
+		if (!jindex)
+			break;
+
+		if (len < (ssize_t) sizeof(nsindex))
+			break;
+
+		len = ndctl_cmd_cfg_read_get_data(cmd_read, &nsindex, len, offset);
+		if (len < 0)
+			break;
+
+		nsindex.sig[NSINDEX_SIG_LEN - 1] = 0;
+		jobj = json_object_new_string(nsindex.sig);
+		if (!jobj)
+			break;
+		json_object_object_add(jindex, "signature", jobj);
+
+		jobj = json_object_new_int(le32_to_cpu(nsindex.seq));
+		if (!jobj)
+			break;
+		json_object_object_add(jindex, "seq", jobj);
+
+		jobj = json_object_new_int(le32_to_cpu(nsindex.nslot));
+		if (!jobj)
+			break;
+		json_object_object_add(jindex, "nslot", jobj);
+
+		json_object_array_add(jarray, jindex);
+	}
+
+	if (json_object_array_length(jarray) < 1) {
+		json_object_put(jarray);
+		if (jindex)
+			json_object_put(jindex);
+		jarray = NULL;
+	}
+
+	return jarray;
+}
+
+static struct json_object *dump_json(struct ndctl_dimm *dimm,
+		struct ndctl_cmd *cmd_read, ssize_t size)
+{
+	struct json_object *jdimm = json_object_new_object();
+	struct json_object *jlabel, *jobj, *jindex;
+
+	if (!jdimm)
+		return NULL;
+	jindex = dump_index_json(cmd_read, size);
+	if (!jindex)
+		goto err_jindex;
+	jlabel = dump_label_json(cmd_read, size);
+	if (!jlabel)
+		goto err_jlabel;
+
+	jobj = json_object_new_string(ndctl_dimm_get_devname(dimm));
+	if (!jobj)
+		goto err_jobj;
+
+	json_object_object_add(jdimm, "dev", jobj);
+	json_object_object_add(jdimm, "index", jindex);
+	json_object_object_add(jdimm, "label", jlabel);
+	return jdimm;
+
+ err_jobj:
+	json_object_put(jlabel);
+ err_jlabel:
+	json_object_put(jindex);
+ err_jindex:
+	json_object_put(jdimm);
+	return NULL;
+}
+
+static int dump_bin(FILE *f_out, struct ndctl_cmd *cmd_read, ssize_t size)
+{
+	char buf[4096];
+	ssize_t offset;
+
+	for (offset = 0; offset < size; offset += sizeof(buf)) {
+		ssize_t len = min_t(ssize_t, sizeof(buf), size - offset), rc;
+
+		len = ndctl_cmd_cfg_read_get_data(cmd_read, buf, len, offset);
+		if (len < 0)
+			return len;
+		rc = fwrite(buf, 1, len, f_out);
+		if (rc != len)
+			return -ENXIO;
+		fflush(f_out);
+	}
+
+	return 0;
+}
+
+static int do_read_dimm(FILE *f_out, struct ndctl_dimm *dimm, const char **argv,
+		int argc, bool verbose, struct json_object *jdimms)
+{
+	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
+	struct ndctl_bus *bus = ndctl_dimm_get_bus(dimm);
+	struct ndctl_cmd *cmd_size, *cmd_read;
+	ssize_t size;
+	int i, rc, log;
+
+	for (i = 0; i < argc; i++)
+		if (util_dimm_filter(dimm, argv[i]))
+			break;
+	if (i >= argc)
+		return -ENODEV;
+
+	log = ndctl_get_log_priority(ctx);
+	if (verbose)
+		ndctl_set_log_priority(ctx, LOG_DEBUG);
+
+	rc = ndctl_bus_wait_probe(bus);
+	if (rc < 0)
+		goto out;
+
+	cmd_size = ndctl_dimm_cmd_new_cfg_size(dimm);
+	if (!cmd_size)
+		return -ENOTTY;
+	rc = ndctl_cmd_submit(cmd_size);
+	if (rc || ndctl_cmd_get_firmware_status(cmd_size))
+		goto out_size;
+
+	cmd_read = ndctl_dimm_cmd_new_cfg_read(cmd_size);
+	if (!cmd_read) {
+		rc = -ENOTTY;
+		goto out_size;
+	}
+	rc = ndctl_cmd_submit(cmd_read);
+	if (rc || ndctl_cmd_get_firmware_status(cmd_read))
+		goto out_read;
+
+	size = ndctl_cmd_cfg_size_get_size(cmd_size);
+	if (jdimms) {
+		struct json_object *jdimm = dump_json(dimm, cmd_read, size);
+		if (!jdimm)
+			return -ENOMEM;
+		json_object_array_add(jdimms, jdimm);
+	} else
+		rc = dump_bin(f_out, cmd_read, size);
+
+ out_read:
+	ndctl_cmd_unref(cmd_read);
+ out_size:
+	ndctl_cmd_unref(cmd_size);
+ out:
+	ndctl_set_log_priority(ctx, log);
+
+	return rc;
+}
+
+int cmd_read_labels(int argc, const char **argv)
+{
+	const char *nmem_bus = NULL, *output = NULL;
+	bool verbose = false, json = false;
+	const struct option nmem_options[] = {
+		OPT_STRING('b', "bus", &nmem_bus, "bus-id",
+				"<nmem> must be on a bus with an id/provider of <bus-id>"),
+		OPT_STRING('o', NULL, &output, "output-file",
+				"filename to write label area contents"),
+		OPT_BOOLEAN('j', "json", &json, "parse label data into json"),
+		OPT_BOOLEAN('v',"verbose", &verbose, "turn on debug"),
+		OPT_END(),
+	};
+	const char * const u[] = {
+		"ndctl read-labels <nmem0> [<nmem1>..<nmemN>] [-o <filename>]",
+		NULL
+	};
+	struct json_object *jdimms = NULL;
+	struct ndctl_dimm *dimm;
+	struct ndctl_ctx *ctx;
+	struct ndctl_bus *bus;
+	int i, rc, count, err = 0;
+	FILE *f_out = NULL;
+
+        argc = parse_options(argc, argv, nmem_options, u, 0);
+
+	if (argc == 0)
+		usage_with_options(u, nmem_options);
+	for (i = 0; i < argc; i++) {
+		unsigned long id;
+
+		if (strcmp(argv[i], "all") == 0)
+			continue;
+		if (sscanf(argv[i], "nmem%lu", &id) != 1) {
+			fprintf(stderr, "unknown extra parameter \"%s\"\n",
+					argv[i]);
+			usage_with_options(u, nmem_options);
+		}
+	}
+
+	if (json) {
+		jdimms = json_object_new_array();
+		if (!jdimms)
+			return -ENOMEM;
+	}
+
+	if (!output)
+		f_out = stdout;
+	else {
+		f_out = fopen(output, "w+");
+		if (!f_out) {
+			fprintf(stderr, "failed to open: %s: (%s)\n",
+					output, strerror(errno));
+			rc = -errno;
+			goto out;
+		}
+	}
+
+	rc = ndctl_new(&ctx);
+	if (rc < 0)
+		goto out;
+
+	count = 0;
+        ndctl_bus_foreach(ctx, bus) {
+		if (!util_bus_filter(bus, nmem_bus))
+			continue;
+
+		ndctl_dimm_foreach(bus, dimm) {
+			rc = do_read_dimm(f_out, dimm, argv, argc, verbose,
+					jdimms);
+			if (rc == 0)
+				count++;
+			else if (rc && !err)
+				err = rc;
+		}
+	}
+	rc = err;
+
+	if (jdimms)
+
+	fprintf(stderr, "read %d nmem%s\n", count, count > 1 ? "s" : "");
+
+	ndctl_unref(ctx);
+
+ out:
+	if (jdimms) {
+		util_display_json_array(f_out, jdimms, JSON_C_TO_STRING_PRETTY);
+		json_object_put(jdimms);
+	}
+
+	if (f_out != stdout)
+		fclose(f_out);
+
+	/*
+	 * 0 if all dimms zeroed, count if at least 1 dimm zeroed, < 0
+	 * if all errors
+	 */
+	if (rc == 0)
+		return 0;
+	if (count)
+		return count;
+	return rc;
+}
diff --git a/builtin.h b/builtin.h
index bec95556a524..9c207552b254 100644
--- a/builtin.h
+++ b/builtin.h
@@ -15,6 +15,7 @@ int cmd_disable_namespace(int argc, const char **argv);
 int cmd_enable_region(int argc, const char **argv);
 int cmd_disable_region(int argc, const char **argv);
 int cmd_zero_labels(int argc, const char **argv);
+int cmd_read_labels(int argc, const char **argv);
 int cmd_help(int argc, const char **argv);
 int cmd_list(int argc, const char **argv);
 #ifdef ENABLE_TEST
diff --git a/ndctl.c b/ndctl.c
index 18b5dc692872..bed194979cc0 100644
--- a/ndctl.c
+++ b/ndctl.c
@@ -31,6 +31,7 @@ static struct cmd_struct commands[] = {
 	{ "enable-region", cmd_enable_region },
 	{ "disable-region", cmd_disable_region },
 	{ "zero-labels", cmd_zero_labels },
+	{ "read-labels", cmd_read_labels },
 	{ "list", cmd_list },
 	{ "help", cmd_help },
 	#ifdef ENABLE_TEST
diff --git a/util/json.c b/util/json.c
index 288efee723ff..4e2d902a183e 100644
--- a/util/json.c
+++ b/util/json.c
@@ -11,6 +11,21 @@
 #include <ndctl.h>
 #endif
 
+void util_display_json_array(FILE *f_out, struct json_object *jarray, int jflag)
+{
+	int len = json_object_array_length(jarray);
+
+	if (json_object_array_length(jarray) > 1)
+		fprintf(f_out, "%s\n", json_object_to_json_string_ext(jarray, jflag));
+	else if (len) {
+		struct json_object *jobj;
+
+		jobj = json_object_array_get_idx(jarray, 0);
+		fprintf(f_out, "%s\n", json_object_to_json_string_ext(jobj, jflag));
+	}
+	json_object_put(jarray);
+}
+
 struct json_object *util_bus_to_json(struct ndctl_bus *bus)
 {
 	struct json_object *jbus = json_object_new_object();
diff --git a/util/json.h b/util/json.h
index 2a264cd0e21c..f751699c9706 100644
--- a/util/json.h
+++ b/util/json.h
@@ -1,8 +1,11 @@
 #ifndef __NDCTL_JSON_H__
 #define __NDCTL_JSON_H__
+#include <stdio.h>
 #include <stdbool.h>
 #include <ndctl/libndctl.h>
 
+struct json_object;
+void util_display_json_array(FILE *f_out, struct json_object *jarray, int jflag);
 bool util_namespace_active(struct ndctl_namespace *ndns);
 struct json_object *util_bus_to_json(struct ndctl_bus *bus);
 struct json_object *util_dimm_to_json(struct ndctl_dimm *dimm);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
