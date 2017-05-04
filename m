Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 671F021A134A0
 for <linux-nvdimm@lists.01.org>; Thu,  4 May 2017 14:49:02 -0700 (PDT)
Subject: [PATCH v6 1/3] ndctl: add clear-error to ndctl for device dax
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 04 May 2017 14:49:01 -0700
Message-ID: <149393454140.2642.16610436149753296619.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <149393422747.2642.5136375594842641153.stgit@djiang5-desk3.ch.intel.com>
References: <149393422747.2642.5136375594842641153.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Adding ndctl support that will allow clearing of bad blocks for a device.
Initial implementation will only support device dax devices. The ndctl
takes a device path and parameters of the starting bad block, and the number
of bad blocks to clear.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ndctl-clear-error.txt |   38 ++++++
 builtin.h                           |    1 
 ndctl/Makefile.am                   |    1 
 ndctl/clear-error.c                 |  239 +++++++++++++++++++++++++++++++++++
 ndctl/lib/libndctl.c                |   72 +++++++++++
 ndctl/lib/libndctl.sym              |    2 
 ndctl/libndctl.h.in                 |   10 +
 ndctl/ndctl.c                       |    1 
 8 files changed, 364 insertions(+)
 create mode 100644 Documentation/ndctl-clear-error.txt
 create mode 100644 ndctl/clear-error.c

diff --git a/Documentation/ndctl-clear-error.txt b/Documentation/ndctl-clear-error.txt
new file mode 100644
index 0000000..b14521a
--- /dev/null
+++ b/Documentation/ndctl-clear-error.txt
@@ -0,0 +1,38 @@
+ndctl-clear-error(1)
+====================
+
+NAME
+----
+ndctl-clear-error - clear badblocks for a device
+
+SYNOPSIS
+--------
+[verse]
+'ndctl clear-error' [<options>]
+
+EXAMPLES
+--------
+
+Clear poison (bad blocks) for the provided device
+[verse]
+ndctl clear-error -f /dev/dax0.0 -s 0 -l 8
+
+Clear poison (bad blocks) at block offset 0 for 8 blocks on device /dev/dax0.0
+
+OPTIONS
+-------
+-f::
+--file::
+	The device/file to be cleared of poison (bad blocks).
+
+-s::
+--start::
+	The offset where the poison (bad block) starts for this device.
+	Typically this is acquired from the sysfs badblocks file.
+
+-l::
+--len::
+	The number of badblocks to clear in size of 512 bytes increments. The
+	length must fit within the badblocks range. If the length exceeds the
+	badblock range or is 0, the command will fail. Not providing a len
+	will result in a single block being cleared.
diff --git a/builtin.h b/builtin.h
index a8bc848..f522d00 100644
--- a/builtin.h
+++ b/builtin.h
@@ -30,4 +30,5 @@ int cmd_test(int argc, const char **argv, void *ctx);
 #ifdef ENABLE_DESTRUCTIVE
 int cmd_bat(int argc, const char **argv, void *ctx);
 #endif
+int cmd_clear_error(int argc, const char **argv, void *ctx);
 #endif /* _NDCTL_BUILTIN_H_ */
diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index d346c04..8123169 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -11,6 +11,7 @@ ndctl_SOURCES = ndctl.c \
 		 ../util/log.c \
 		list.c \
 		test.c \
+		clear-error.c \
 		../util/json.c
 
 if ENABLE_SMART
diff --git a/ndctl/clear-error.c b/ndctl/clear-error.c
new file mode 100644
index 0000000..29cd471
--- /dev/null
+++ b/ndctl/clear-error.c
@@ -0,0 +1,239 @@
+#include <stdio.h>
+#include <errno.h>
+#include <stdlib.h>
+#include <stdint.h>
+#include <stdbool.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <unistd.h>
+#include <libgen.h>
+#include <string.h>
+#include <limits.h>
+#include <ccan/short_types/short_types.h>
+#include <ccan/array_size/array_size.h>
+#include <util/parse-options.h>
+#include <util/log.h>
+#include <ndctl/libndctl.h>
+#include <ndctl.h>
+
+struct clear_err {
+	const char *dev_name;
+	u64 bb_start;
+	unsigned int bb_len;
+	struct ndctl_cmd *ars_cap;
+	struct ndctl_cmd *clear_err;
+	struct ndctl_bus *bus;
+	struct ndctl_region *region;
+	struct ndctl_dax *dax;
+	struct ndctl_ctx *ctx;
+} clear_err = {
+	.bb_len = 1,
+};
+
+static int send_clear_error(struct ndctl_bus *bus, u64 start, u64 size)
+{
+	u64 cleared;
+	int rc;
+
+	clear_err.clear_err = ndctl_bus_cmd_new_clear_error(
+			start, size, clear_err.ars_cap);
+	if (!clear_err.clear_err) {
+		error("%s: bus: %s failed to create cmd\n",
+				__func__, ndctl_bus_get_provider(bus));
+		return -ENXIO;
+	}
+
+	rc = ndctl_cmd_submit(clear_err.clear_err);
+	if (rc) {
+		error("%s: bus: %s failed to submit cmd: %d\n",
+				__func__, ndctl_bus_get_provider(bus), rc);
+		ndctl_cmd_unref(clear_err.clear_err);
+		return rc;
+	}
+
+	cleared = ndctl_cmd_clear_error_get_cleared(clear_err.clear_err);
+	if (cleared != size) {
+		error("%s: bus: %s expected to clear: %ld actual: %ld\n",
+				__func__, ndctl_bus_get_provider(bus),
+				size, cleared);
+		return -ENXIO;
+	}
+
+	return 0;
+}
+
+static int get_ars_cap(struct ndctl_bus *bus, u64 start, u64 size)
+{
+	int rc;
+
+	clear_err.ars_cap = ndctl_bus_cmd_new_ars_cap(bus, start, size);
+	if (!clear_err.ars_cap) {
+		error("%s: bus: %s failed to create cmd\n",
+				__func__, ndctl_bus_get_provider(bus));
+		return -ENOTTY;
+	}
+
+	rc = ndctl_cmd_submit(clear_err.ars_cap);
+	if (rc) {
+		error("%s: bus: %s failed to submit cmd: %d\n",
+				__func__, ndctl_bus_get_provider(bus), rc);
+		ndctl_cmd_unref(clear_err.ars_cap);
+		return rc;
+	}
+
+	if (ndctl_cmd_ars_cap_get_size(clear_err.ars_cap) <
+			sizeof(struct nd_cmd_ars_status)){
+		error("%s: bus: %s expected size >= %zd got: %d\n",
+				__func__, ndctl_bus_get_provider(bus),
+				sizeof(struct nd_cmd_ars_status),
+				ndctl_cmd_ars_cap_get_size(clear_err.ars_cap));
+		ndctl_cmd_unref(clear_err.ars_cap);
+		return -ENXIO;
+	}
+
+	return 0;
+}
+
+static int match_dev(struct clear_err *ce, char *dev_name)
+{
+	ndctl_bus_foreach(ce->ctx, ce->bus)
+		ndctl_region_foreach(ce->bus, ce->region)
+			ndctl_dax_foreach(ce->region, ce->dax)
+				if (strncmp(basename(dev_name),
+					ndctl_dax_get_devname(ce->dax), 256)
+						== 0)
+					return 0;
+
+	return -ENODEV;
+}
+
+static int check_user_input_range(struct ndctl_dax *dax,
+		unsigned long long start, unsigned int len)
+{
+	struct ndctl_region *region = ndctl_dax_get_region(dax);
+	struct badblock *bb;
+	uint64_t rbegin;
+	uint64_t dbegin;
+	uint64_t bb_start;
+
+	rbegin = ndctl_region_get_resource(region);
+	/* physical addr of DAX begin */
+	dbegin = ndctl_dax_get_resource(dax);
+	/* badblocks start relative to region from DAX device */
+	bb_start = ((dbegin - rbegin) >> 9) + start;
+
+	/* check region */
+	ndctl_region_badblock_foreach(region, bb)
+		if (bb_start >= bb->offset &&
+				bb_start + len <= bb->offset + bb->len)
+			return 1;
+
+	return 0;
+}
+
+static int clear_error(struct clear_err *ce)
+{
+	struct stat stats;
+	int rc;
+	char dev_name[256];
+	uint64_t dev_base;
+	unsigned long long start;
+	unsigned int len;
+
+	strncpy(dev_name, ce->dev_name, 256);
+
+	rc = stat(dev_name, &stats);
+	if (rc < 0) {
+		perror("stat failed");
+		error("Unable to stat %s\n", dev_name);
+		return -1;
+	}
+
+	if (!S_ISCHR(stats.st_mode)) {
+		error("%s not DAX device\n", dev_name);
+		return -1;
+	}
+
+	rc = ndctl_new(&ce->ctx);
+	if (rc)
+		return rc;
+
+	if ((rc = match_dev(ce, dev_name)) < 0)
+		goto cleanup;
+
+	dev_base = ndctl_dax_get_resource(ce->dax);
+	if (dev_base == ULLONG_MAX) {
+		rc = -ERANGE;
+		goto cleanup;
+	}
+
+	if (check_user_input_range(ce->dax, clear_err.bb_start,
+				clear_err.bb_len) == 0) {
+		rc = -EINVAL;
+		error("Badblocks region input out of range.\n");
+		goto cleanup;
+	}
+
+	start = dev_base + clear_err.bb_start * 512;
+	len = clear_err.bb_len * 512;
+
+	rc = get_ars_cap(ce->bus, start, len);
+	if (rc) {
+		fprintf(stderr, "get_ars_cap failed\n");
+		goto cleanup;
+	}
+
+	rc = send_clear_error(ce->bus, start, len);
+	if (rc) {
+		fprintf(stderr, "send_clear_error failed\n");
+		goto cleanup;
+	}
+
+	rc = 0;
+
+cleanup:
+	ndctl_unref(ce->ctx);
+	return rc;
+}
+
+int cmd_clear_error(int argc, const char **argv, void *ctx)
+{
+	int i, rc;
+	const char * const u[] = {
+		"ndctl clear-error [<options>]",
+		NULL
+	};
+	const struct option options[] = {
+		OPT_STRING('f', "file", &clear_err.dev_name, "device-name",
+			"device/file name to be operated on"),
+		OPT_U64('s', "start", &clear_err.bb_start,
+				"badblock start"),
+		OPT_UINTEGER('l', "len", &clear_err.bb_len, "badblock length"),
+		OPT_END(),
+	};
+
+	argc = parse_options(argc, argv, options, u, 0);
+
+	for (i = 0; i < argc; i++)
+		error("Unknown parameter \"%s\"\n", argv[i]);
+
+	if (argc)
+		usage_with_options(u, options);
+
+	if (!clear_err.dev_name) {
+		error("Missing device/file name passed in\n");
+		usage_with_options(u, options);
+		return -EINVAL;
+	}
+
+	if (clear_err.bb_len == 0) {
+		error("Clearing with 0 length, failed.\n");
+		return -EINVAL;
+	}
+
+	rc = clear_error(&clear_err);
+	if (rc)
+		return rc;
+
+	return 0;
+}
diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index ac1fc63..9bf9d96 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -229,6 +229,8 @@ struct ndctl_region {
 		int state;
 		unsigned long long cookie;
 	} iset;
+	FILE *badblocks;
+	struct badblock bb;
 };
 
 /**
@@ -1867,6 +1869,76 @@ NDCTL_EXPORT struct ndctl_dimm *ndctl_region_get_next_dimm(struct ndctl_region *
 	return NULL;
 }
 
+static int regions_badblocks_init(struct ndctl_region *region)
+{
+	struct ndctl_ctx *ctx = ndctl_region_get_ctx(region);
+	char *bb_path;
+	int rc = 0;
+
+	/* if the file is already open */
+	if (region->badblocks) {
+		fclose(region->badblocks);
+		region->badblocks = NULL;
+	}
+
+	if (asprintf(&bb_path, "%s/badblocks",
+				region->region_path) < 0) {
+		rc = -errno;
+		err(ctx, "region badblocks path allocation failure\n");
+		return rc;
+	}
+
+	region->badblocks = fopen(bb_path, "r");
+	if (!region->badblocks) {
+		rc = -errno;
+		err(ctx, "region badblocks fopen failed\n");
+		return -rc;
+	}
+
+	free(bb_path);
+	return rc;
+}
+
+NDCTL_EXPORT struct badblock *ndctl_region_get_next_badblock(struct ndctl_region *region)
+{
+	int rc;
+	char *buf = NULL;
+	size_t rlen = 0;
+
+	if (!region->badblocks)
+		return NULL;
+
+	rc = getline(&buf, &rlen, region->badblocks);
+	if (rc == -1) {
+		free(buf);
+		return NULL;
+	}
+
+	rc = sscanf(buf, "%llu %u", &region->bb.offset, &region->bb.len);
+	free(buf);
+	if (rc != 2) {
+		/* end of the road, clean up */
+		fclose(region->badblocks);
+		region->badblocks = NULL;
+		region->bb.offset = 0;
+		region->bb.len = 0;
+		return NULL;
+	}
+
+	return &region->bb;
+}
+
+NDCTL_EXPORT struct badblock *ndctl_region_get_first_badblock(struct ndctl_region *region)
+{
+	int rc;
+
+	rc = regions_badblocks_init(region);
+	if (rc < 0)
+		return NULL;
+
+	return ndctl_region_get_next_badblock(region);
+}
+
 static struct nd_cmd_vendor_tail *to_vendor_tail(struct ndctl_cmd *cmd)
 {
 	struct nd_cmd_vendor_tail *tail = (struct nd_cmd_vendor_tail *)
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index b5a085c..9bc36a3 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -140,6 +140,8 @@ global:
 	ndctl_region_get_ro;
 	ndctl_region_set_ro;
 	ndctl_region_get_resource;
+	ndctl_region_get_first_badblock;
+	ndctl_region_get_next_badblock;
 	ndctl_interleave_set_get_first;
 	ndctl_interleave_set_get_next;
 	ndctl_interleave_set_is_active;
diff --git a/ndctl/libndctl.h.in b/ndctl/libndctl.h.in
index 6ee8a35..2c45d2d 100644
--- a/ndctl/libndctl.h.in
+++ b/ndctl/libndctl.h.in
@@ -372,6 +372,10 @@ int ndctl_cmd_get_status(struct ndctl_cmd *cmd);
 unsigned int ndctl_cmd_get_firmware_status(struct ndctl_cmd *cmd);
 int ndctl_cmd_submit(struct ndctl_cmd *cmd);
 
+struct badblock {
+	unsigned long long offset;
+	unsigned int len;
+};
 struct ndctl_region;
 struct ndctl_region *ndctl_region_get_first(struct ndctl_bus *bus);
 struct ndctl_region *ndctl_region_get_next(struct ndctl_region *region);
@@ -379,6 +383,12 @@ struct ndctl_region *ndctl_region_get_next(struct ndctl_region *region);
         for (region = ndctl_region_get_first(bus); \
              region != NULL; \
              region = ndctl_region_get_next(region))
+struct badblock *ndctl_region_get_first_badblock(struct ndctl_region *region);
+struct badblock *ndctl_region_get_next_badblock(struct ndctl_region *region);
+#define ndctl_region_badblock_foreach(region, badblock) \
+        for (badblock = ndctl_region_get_first_badblock(region); \
+             badblock != NULL; \
+             badblock = ndctl_region_get_next_badblock(region))
 unsigned int ndctl_region_get_id(struct ndctl_region *region);
 const char *ndctl_region_get_devname(struct ndctl_region *region);
 unsigned int ndctl_region_get_interleave_ways(struct ndctl_region *region);
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index 4b08c9b..144dc23 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -67,6 +67,7 @@ static struct cmd_struct commands[] = {
 	{ "write-labels", cmd_write_labels },
 	{ "init-labels", cmd_init_labels },
 	{ "check-labels", cmd_check_labels },
+	{ "clear-error", cmd_clear_error },
 	{ "list", cmd_list },
 	{ "help", cmd_help },
 	#ifdef ENABLE_TEST

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
