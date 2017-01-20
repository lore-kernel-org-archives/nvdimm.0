Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B36E481E9E
 for <linux-nvdimm@lists.01.org>; Thu, 19 Jan 2017 19:13:49 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH] ndctl: add a BTT check utility
Date: Thu, 19 Jan 2017 20:12:34 -0700
Message-Id: <20170120031234.24226-1-vishal.l.verma@intel.com>
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Add the check-namespace command to ndctl. This will check the BTT
metadata layout for the given namespace, and if requested, correct any
errors found. Not all metadata corruption is detectable or fixable.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Documentation/Makefile.am               |   1 +
 Documentation/namespace-check.txt       |   7 +
 Documentation/ndctl-check-namespace.txt |  46 ++
 Documentation/ndctl.txt                 |   1 +
 builtin.h                               |   3 +
 configure.ac                            |  10 +
 contrib/ndctl                           |   3 +
 ndctl/btt-structs.h                     | 117 ++++
 ndctl/builtin-xaction-namespace.c       | 910 +++++++++++++++++++++++++++++++-
 ndctl/ndctl.c                           |   3 +
 util/util.h                             |   8 +
 11 files changed, 1107 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/namespace-check.txt
 create mode 100644 Documentation/ndctl-check-namespace.txt
 create mode 100644 ndctl/btt-structs.h

diff --git a/Documentation/Makefile.am b/Documentation/Makefile.am
index adcc9e7..92790b6 100644
--- a/Documentation/Makefile.am
+++ b/Documentation/Makefile.am
@@ -12,6 +12,7 @@ man1_MANS = \
 	ndctl-disable-namespace.1 \
 	ndctl-create-namespace.1 \
 	ndctl-destroy-namespace.1 \
+	ndctl-check-namespace.1 \
 	ndctl-list.1
 
 CLEANFILES = $(man1_MANS)
diff --git a/Documentation/namespace-check.txt b/Documentation/namespace-check.txt
new file mode 100644
index 0000000..d304e83
--- /dev/null
+++ b/Documentation/namespace-check.txt
@@ -0,0 +1,7 @@
+DESCRIPTION
+-----------
+
+A namespace in the 'sector' mode will have metadata on it to describe
+the kernel BTT (Block Translation Table). The check-namespace command
+can be used to check the consistency of this metadata, and also attempt
+to repair it, if it has enough information to do so.
diff --git a/Documentation/ndctl-check-namespace.txt b/Documentation/ndctl-check-namespace.txt
new file mode 100644
index 0000000..18e44fc
--- /dev/null
+++ b/Documentation/ndctl-check-namespace.txt
@@ -0,0 +1,46 @@
+ndctl-check-namespace(1)
+=========================
+
+NAME
+----
+ndctl-check-namespace - check namespace metadata consistency
+
+SYNOPSIS
+--------
+[verse]
+'ndctl check-namespace' [<options>]
+
+include::namespace-check.txt[]
+
+EXAMPLES
+--------
+
+Check a BTT namespace
+[verse]
+ndctl disable-namespace namespace0.0
+ndctl check-namespace namespace0.0
+
+Check a BTT namespace, but don't actually restore/correct anything
+[verse]
+ndctl check-namespace --dry-run
+
+OPTIONS
+-------
+-n::
+--dry-run::
+	Only check the metadata for consistency, don't write anything.
+
+-v::
+--verbose::
+	Emit debug messages for the namespace creation process
+
+-r::
+--region=::
+include::xable-region-options.txt[]
+
+SEE ALSO
+--------
+linkndctl:ndctl-disable-namespace[1],
+linkndctl:ndctl-enable-namespace[1],
+http://pmem.io/documents/NVDIMM_Namespace_Spec.pdf[NVDIMM Namespace
+Specification]
diff --git a/Documentation/ndctl.txt b/Documentation/ndctl.txt
index 883a59c..c26cc2f 100644
--- a/Documentation/ndctl.txt
+++ b/Documentation/ndctl.txt
@@ -34,6 +34,7 @@ SEE ALSO
 --------
 linkndctl:ndctl-create-namespace[1],
 linkndctl:ndctl-destroy-namespace[1],
+linkndctl:ndctl-check-namespace[1],
 linkndctl:ndctl-enable-region[1],
 linkndctl:ndctl-disable-region[1],
 linkndctl:ndctl-enable-dimm[1],
diff --git a/builtin.h b/builtin.h
index 9b66196..b817ced 100644
--- a/builtin.h
+++ b/builtin.h
@@ -13,6 +13,9 @@ int cmd_enable_namespace(int argc, const char **argv, void *ctx);
 int cmd_create_namespace(int argc, const char **argv, void *ctx);
 int cmd_destroy_namespace(int argc, const char **argv, void *ctx);
 int cmd_disable_namespace(int argc, const char **argv, void *ctx);
+#ifdef ENABLE_CHECK_NAMESPACE
+int cmd_check_namespace(int argc, const char **argv, struct *ctx);
+#endif
 int cmd_enable_region(int argc, const char **argv, void *ctx);
 int cmd_disable_region(int argc, const char **argv, void *ctx);
 int cmd_enable_dimm(int argc, const char **argv, void *ctx);
diff --git a/configure.ac b/configure.ac
index e79623a..92a0f06 100644
--- a/configure.ac
+++ b/configure.ac
@@ -111,6 +111,16 @@ fi
 AC_SUBST([BASH_COMPLETION_DIR])
 AM_CONDITIONAL([ENABLE_BASH_COMPLETION],[test "x$with_bash_completion_dir" != "xno"])
 
+AC_ARG_ENABLE([check-namespace],
+        AS_HELP_STRING([--disable-check-namespace],
+		[disable the 'check namspace' command @<:@default=system@:>@]),
+	[], [enable_check_namespace=yes])
+
+AM_CONDITIONAL([ENABLE_CHECK_NAMESPACE], [test "x$enable_check_namespace" = "xyes"])
+AS_IF([test "x$enable_check_namespace" = "xyes"], [
+	AC_DEFINE([ENABLE_CHECK_NAMESPACE], [1], [check namespace support])
+])
+
 AC_ARG_ENABLE([local],
         AS_HELP_STRING([--disable-local], [build against kernel ndctl.h @<:@default=system@:>@]),
         [], [enable_local=yes])
diff --git a/contrib/ndctl b/contrib/ndctl
index ea7303c..c97adcc 100755
--- a/contrib/ndctl
+++ b/contrib/ndctl
@@ -194,6 +194,9 @@ __ndctl_comp_non_option_args()
 	destroy-namespace)
 		opts="$(__ndctl_get_ns) all"
 		;;
+	check-namespace)
+		opts="$(__ndctl_get_ns -i) all"
+		;;
 	enable-region)
 		opts="$(__ndctl_get_regions -i) all"
 		;;
diff --git a/ndctl/btt-structs.h b/ndctl/btt-structs.h
new file mode 100644
index 0000000..1329668
--- /dev/null
+++ b/ndctl/btt-structs.h
@@ -0,0 +1,117 @@
+/*
+ * Copyright (c) 2016, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#ifndef _BTT_STRUCTS_H
+#define _BTT_STRUCTS_H
+
+#include <linux/types.h>
+
+#define BTT_SIG_LEN 16
+#define BTT_SIG "BTT_ARENA_INFO\0"
+#define MAP_ENT_SIZE 4
+#define MAP_TRIM_SHIFT 31
+#define MAP_TRIM_MASK (1 << MAP_TRIM_SHIFT)
+#define MAP_ERR_SHIFT 30
+#define MAP_ERR_MASK (1 << MAP_ERR_SHIFT)
+#define MAP_LBA_MASK (~((1 << MAP_TRIM_SHIFT) | (1 << MAP_ERR_SHIFT)))
+#define MAP_ENT_NORMAL 0xC0000000
+#define LOG_ENT_SIZE sizeof(struct log_entry)
+#define ARENA_MIN_SIZE (1UL << 24)	/* 16 MB */
+#define ARENA_MAX_SIZE (1ULL << 39)	/* 512 GB */
+#define BTT_PG_SIZE 4096
+#define BTT_DEFAULT_NFREE 256
+#define LOG_SEQ_INIT 1
+
+#define IB_FLAG_ERROR 0x00000001
+#define IB_FLAG_ERROR_MASK 0x00000001
+
+struct log_entry {
+	__le32 lba;
+	__le32 old_map;
+	__le32 new_map;
+	__le32 seq;
+	__le64 padding[2];
+};
+
+struct btt_sb {
+	__u8 signature[BTT_SIG_LEN];
+	__u8 uuid[16];
+	__u8 parent_uuid[16];
+	__le32 flags;
+	__le16 version_major;
+	__le16 version_minor;
+	__le32 external_lbasize;
+	__le32 external_nlba;
+	__le32 internal_lbasize;
+	__le32 internal_nlba;
+	__le32 nfree;
+	__le32 infosize;
+	__le64 nextoff;
+	__le64 dataoff;
+	__le64 mapoff;
+	__le64 logoff;
+	__le64 info2off;
+	__u8 padding[3968];
+	__le64 checksum;
+};
+
+struct free_entry {
+	__u32 block;
+	__u8 sub;
+	__u8 seq;
+};
+
+struct arena_map {
+	struct btt_sb *info;
+	size_t info_len;
+	void *data;
+	size_t data_len;
+	__u32 *map;
+	size_t map_len;
+	struct log_entry *log;
+	size_t log_len;
+	struct btt_sb *info2;
+	size_t info2_len;
+};
+
+struct arena_info {
+	struct arena_map map;
+	__u64 size;	/* Total bytes for this arena */
+	__u64 external_lba_start;
+	__u32 internal_nlba;
+	__u32 internal_lbasize;
+	__u32 external_nlba;
+	__u32 external_lbasize;
+	__u32 nfree;
+	__u16 version_major;
+	__u16 version_minor;
+	__u64 nextoff;
+	__u64 infooff;
+	__u64 dataoff;
+	__u64 mapoff;
+	__u64 logoff;
+	__u64 info2off;
+	__u32 flags;
+	int num;
+};
+
+struct btt_chk {
+	char *path;
+	uuid_t parent_uuid;
+	unsigned long long rawsize;
+	unsigned long long nlba;
+	int num_arenas;
+	struct arena_info *arena;
+};
+
+#endif
diff --git a/ndctl/builtin-xaction-namespace.c b/ndctl/builtin-xaction-namespace.c
index 2c4f85f..499670d 100644
--- a/ndctl/builtin-xaction-namespace.c
+++ b/ndctl/builtin-xaction-namespace.c
@@ -13,20 +13,25 @@
 #include <stdio.h>
 #include <fcntl.h>
 #include <errno.h>
+#include <stdint.h>
 #include <stdlib.h>
 #include <unistd.h>
 #include <limits.h>
 #include <syslog.h>
+#include <endian.h>
+#include <sys/mman.h>
 #include <sys/stat.h>
 #include <uuid/uuid.h>
 #include <sys/types.h>
 #include <util/size.h>
 #include <util/json.h>
+#include <util/util.h>
 #include <json-c/json.h>
 #include <util/filter.h>
 #include <ndctl/libndctl.h>
 #include <util/parse-options.h>
 #include <ccan/array_size/array_size.h>
+#include "btt-structs.h"
 
 #ifdef HAVE_NDCTL_H
 #include <linux/ndctl.h>
@@ -34,8 +39,11 @@
 #include <ndctl.h>
 #endif
 
+#define SZ_4K 0x1000UL
+
 static bool verbose;
 static bool force;
+static bool dryrun;
 static struct parameters {
 	bool do_scan;
 	bool mode_default;
@@ -106,6 +114,9 @@ OPT_STRING('t', "type", &param.type, "type", \
 	"specify the type of namespace to create 'pmem' or 'blk'"), \
 OPT_BOOLEAN('f', "force", &force, "reconfigure namespace even if currently active")
 
+#define CHECK_OPTIONS() \
+OPT_BOOLEAN('n', "dry-run", &dryrun, "dry-run only, don't write anything")
+
 static const struct option base_options[] = {
 	BASE_OPTIONS(),
 	OPT_END(),
@@ -124,11 +135,18 @@ static const struct option create_options[] = {
 	OPT_END(),
 };
 
+static const struct option check_options[] = {
+	BASE_OPTIONS(),
+	CHECK_OPTIONS(),
+	OPT_END(),
+};
+
 enum namespace_action {
 	ACTION_ENABLE,
 	ACTION_DISABLE,
 	ACTION_CREATE,
 	ACTION_DESTROY,
+	ACTION_CHECK,
 };
 
 static int set_defaults(enum namespace_action mode)
@@ -253,8 +271,23 @@ static const char *parse_namespace_options(int argc, const char **argv,
 	rc = set_defaults(mode);
 
 	if (argc == 0 && mode != ACTION_CREATE) {
-		error("specify a namespace to %s, or \"all\"\n",
-				mode == ACTION_ENABLE ? "enable" : "disable");
+		char *action_string;
+
+		switch (mode) {
+			case ACTION_ENABLE:
+				action_string = "enable";
+				break;
+			case ACTION_DISABLE:
+				action_string = "disable";
+				break;
+			case ACTION_CHECK:
+				action_string = "check";
+				break;
+			default:
+				action_string = "<>";
+				break;
+		}
+		error("specify a namespace to %s, or \"all\"\n", action_string);
 		rc = -EINVAL;
 	}
 	for (i = mode == ACTION_CREATE ? 0 : 1; i < argc; i++) {
@@ -703,6 +736,854 @@ static int namespace_reconfig(struct ndctl_region *region,
 	return setup_namespace(region, ndns, &p);
 }
 
+#ifdef ENABLE_CHECK_NAMESPACE
+
+static int dryrun_msg(void)
+{
+	error("  Run without --dry-run to make the changes");
+	return 0;
+}
+
+static int btt_read_info(struct btt_chk *bttc, struct btt_sb *btt_sb, __u64 off)
+{
+	int fd, rc = 0;
+	ssize_t size;
+
+	fd = open(bttc->path, O_RDONLY);
+	if (fd < 0) {
+		error("unable to open %s: %s\n", bttc->path, strerror(errno));
+		return -errno;
+	}
+
+	size = pread(fd, btt_sb, sizeof(*btt_sb), off + SZ_4K);
+	if (size != sizeof(*btt_sb)) {
+		error("unable to read first info block: %s\n", strerror(errno));
+		rc = -errno;
+	}
+	close(fd);
+	return rc;
+}
+
+static int btt_write_info(struct btt_chk *bttc, struct btt_sb *btt_sb, __u64 off)
+{
+	int fd, rc = 0;
+	ssize_t size;
+
+	if (dryrun) {
+		error("BTT info block at offset %#llx needs to be restored\n", off);
+		dryrun_msg();
+		return -1;
+	}
+	printf("Restoring BTT info block at offset %#llx\n", off);
+
+	fd = open(bttc->path, O_RDWR);
+	if (fd < 0) {
+		error("unable to open %s: %s\n", bttc->path, strerror(errno));
+		return -errno;
+	}
+
+	size = pwrite(fd, btt_sb, sizeof(*btt_sb), off + SZ_4K);
+	if (size != sizeof(*btt_sb)) {
+		error("unable to write the info block: %s\n", strerror(errno));
+		rc = -errno;
+	}
+	close(fd);
+	return rc;
+}
+
+static int btt_copy_to_info2(struct arena_info *a)
+{
+	if (dryrun) {
+		error("Arena %d: BTT info2 needs to be restored\n", a->num);
+		return dryrun_msg();
+	}
+	printf("Arena %d: Restoring BTT info2\n", a->num);
+	memcpy(a->map.info2, a->map.info, BTT_PG_SIZE);
+	return 0;
+}
+static int btt_map_read(struct arena_info *a, __u32 lba, __u32 *mapping,
+			int *trim, int *error)
+{
+	__u32 raw_mapping, postmap, ze, z_flag, e_flag;
+
+	raw_mapping = le32toh(a->map.map[lba]);
+	z_flag = (raw_mapping & MAP_TRIM_MASK) >> MAP_TRIM_SHIFT;
+	e_flag = (raw_mapping & MAP_ERR_MASK) >> MAP_ERR_SHIFT;
+	ze = (z_flag << 1) + e_flag;
+	postmap = raw_mapping & MAP_LBA_MASK;
+
+	/* Reuse the {z,e}_flag variables for *trim and *error */
+	z_flag = 0;
+	e_flag = 0;
+
+	switch (ze) {
+	case 0:
+		/* Initial state. Return postmap = premap */
+		*mapping = lba;
+		break;
+	case 1:
+		*mapping = postmap;
+		e_flag = 1;
+		break;
+	case 2:
+		*mapping = postmap;
+		z_flag = 1;
+		break;
+	case 3:
+		*mapping = postmap;
+		break;
+	default:
+		return -EIO;
+	}
+
+	if (trim)
+		*trim = z_flag;
+	if (error)
+		*error = e_flag;
+
+	return 0;
+}
+
+static int btt_map_write(struct arena_info *a, __u32 lba, __u32 mapping,
+			__u32 z_flag, __u32 e_flag)
+{
+	__u32 ze;
+
+	/*
+	 * This 'mapping' is supposed to be just the LBA mapping, without
+	 * any flags set, so strip the flag bits.
+	 */
+	mapping &= MAP_LBA_MASK;
+
+	if (dryrun) {
+		error("Arena %d: map[%#x] needs to be updated to %#x\n",
+			a->num, lba, mapping);
+		return dryrun_msg();
+	}
+	printf("Arena %d: Updating map[%#x] to %#x\n", a->num, lba, mapping);
+
+	ze = (z_flag << 1) + e_flag;
+	switch (ze) {
+	case 0:
+		/*
+		 * We want to set neither of the Z or E flags, and
+		 * in the actual layout, this means setting the bit
+		 * positions of both to '1' to indicate a 'normal'
+		 * map entry
+		 */
+		mapping |= MAP_ENT_NORMAL;
+		break;
+	case 1:
+		mapping |= (1 << MAP_ERR_SHIFT);
+		break;
+	case 2:
+		mapping |= (1 << MAP_TRIM_SHIFT);
+		break;
+	default:
+		/*
+		 * The case where Z and E are both sent in as '1' could be
+		 * construed as a valid 'normal' case, but we decide not to,
+		 * to avoid confusion
+		 */
+		error("%s: Invalid use of Z and E flags\n", __func__);
+		return -ENXIO;
+	}
+
+	a->map.map[lba] = htole32(mapping);
+	if (msync((void *)rounddown((__u64)&a->map.map[lba], BTT_PG_SIZE),
+		BTT_PG_SIZE, MS_SYNC) < 0)
+		return errno;
+
+	return 0;
+}
+
+static void btt_log_read_pair(struct arena_info *a, __u32 lane,
+			struct log_entry *ent)
+{
+	memcpy(ent, &a->map.log[lane * 2], 2 * sizeof(struct log_entry));
+}
+
+/*
+ * This function accepts two log entries, and uses the sequence number to
+ * find the 'older' entry. The return value indicates which of the two was
+ * the 'old' entry
+ */
+static int btt_log_get_old(struct log_entry *ent)
+{
+	int old;
+
+	if (ent[0].seq == 0) {
+		ent[0].seq = htole32(1);
+		return 0;
+	}
+
+	if (le32toh(ent[0].seq) < le32toh(ent[1].seq)) {
+		if (le32toh(ent[1].seq) - le32toh(ent[0].seq) == 1)
+			old = 0;
+		else
+			old = 1;
+	} else {
+		if (le32toh(ent[0].seq) - le32toh(ent[1].seq) == 1)
+			old = 1;
+		else
+			old = 0;
+	}
+
+	return old;
+}
+
+static int btt_log_read(struct arena_info *a, __u32 lane, struct log_entry *ent)
+{
+	int new_ent;
+	struct log_entry log[2];
+
+	if (ent == NULL)
+		return -EINVAL;
+	btt_log_read_pair(a, lane, log);
+	new_ent = 1 - btt_log_get_old(log);
+	memcpy(ent, &log[new_ent], sizeof(struct log_entry));
+	return 0;
+}
+
+static uint64_t fletcher64(void *addr, size_t len, bool le)
+{
+	uint32_t *buf = addr;
+	uint32_t lo32 = 0;
+	uint64_t hi32 = 0;
+	unsigned int i;
+
+	for (i = 0; i < len / sizeof(uint32_t); i++) {
+		lo32 += le ? le32toh((__le32) buf[i]) : buf[i];
+		hi32 += lo32;
+	}
+
+	return ((uint64_t)(hi32 << 32)) | lo32;
+}
+
+static int btt_checksum_verify(struct btt_sb *btt_sb)
+{
+	uint64_t sum;
+	__le64 sum_save;
+
+	BUILD_BUG_ON(sizeof(struct btt_sb) != SZ_4K);
+
+	sum_save = btt_sb->checksum;
+	btt_sb->checksum = 0;
+	sum = fletcher64(btt_sb, sizeof(*btt_sb), 1);
+	if (sum != sum_save)
+		return 1;
+	/* restore the checksum in the buffer */
+	btt_sb->checksum = sum_save;
+
+	return 0;
+}
+
+/*
+ * Never pass a mmapped buffer to this as it will attempt to write to
+ * the buffer, and we want writes to only happened in a controlled fashion.
+ * In the --dry-run case, even if such a buffer is passed, the write will
+ * result in a fault due to the readonly mmap flags.
+ */
+static int btt_info_verify(struct btt_chk *bttc, struct btt_sb *btt_sb)
+{
+	if (memcmp(btt_sb->signature, BTT_SIG, BTT_SIG_LEN) != 0)
+		return -ENXIO;
+
+	if (!uuid_is_null(btt_sb->parent_uuid))
+		if (uuid_compare(bttc->parent_uuid, btt_sb->parent_uuid) != 0)
+			return -ENXIO;
+
+	if (btt_checksum_verify(btt_sb))
+		return -ENXIO;
+
+	return 0;
+}
+
+static void btt_parse_meta(struct arena_info *arena, struct btt_sb *btt_sb,
+				__u64 arena_off)
+{
+	arena->internal_nlba = le32toh(btt_sb->internal_nlba);
+	arena->internal_lbasize = le32toh(btt_sb->internal_lbasize);
+	arena->external_nlba = le32toh(btt_sb->external_nlba);
+	arena->external_lbasize = le32toh(btt_sb->external_lbasize);
+	arena->nfree = le32toh(btt_sb->nfree);
+	arena->version_major = le16toh(btt_sb->version_major);
+	arena->version_minor = le16toh(btt_sb->version_minor);
+
+	arena->nextoff = (btt_sb->nextoff == 0) ? 0 : (arena_off +
+			le64toh(btt_sb->nextoff));
+	arena->infooff = arena_off;
+	arena->dataoff = arena_off + le64toh(btt_sb->dataoff);
+	arena->mapoff = arena_off + le64toh(btt_sb->mapoff);
+	arena->logoff = arena_off + le64toh(btt_sb->logoff);
+	arena->info2off = arena_off + le64toh(btt_sb->info2off);
+
+	arena->size = (le64toh(btt_sb->nextoff) > 0)
+		? (le64toh(btt_sb->nextoff))
+		: (arena->info2off - arena->infooff + BTT_PG_SIZE);
+
+	arena->flags = le32toh(btt_sb->flags);
+}
+
+static int btt_discover_arenas(struct btt_chk *bttc)
+{
+	int ret = 0;
+	struct arena_info *arena;
+	struct btt_sb *btt_sb;
+	size_t remaining = bttc->rawsize;
+	__u64 cur_nlba = 0;
+	size_t cur_off = 0;
+	int  i = 0;
+
+	btt_sb = calloc(1, sizeof(*btt_sb));
+	if (!btt_sb)
+		return -ENOMEM;
+
+	while (remaining) {
+		/* Alloc memory for arena */
+		arena = realloc(bttc->arena, (i + 1) * sizeof(*arena));
+		if (!arena) {
+			ret = -ENOMEM;
+			goto out;
+		} else {
+			bttc->arena = arena;
+			arena = &bttc->arena[i];
+			/* zero the new memory */
+			memset(arena, 0, sizeof(*arena));
+		}
+
+		arena->infooff = cur_off;
+		ret = btt_read_info(bttc, btt_sb, cur_off);
+		if (ret)
+			goto out;
+
+		if (btt_info_verify(bttc, btt_sb) != 0) {
+			__u64 offset;
+
+			/* Try to find the backup info block */
+			if (remaining <= ARENA_MAX_SIZE)
+				offset = rounddown(bttc->rawsize, BTT_PG_SIZE) -
+					2 * BTT_PG_SIZE;
+			else
+				offset = cur_off + ARENA_MAX_SIZE - BTT_PG_SIZE;
+
+			printf("Arena %d: Attempting recover info-block using info2\n", i);
+			ret = btt_read_info(bttc, btt_sb, offset);
+			if (ret) {
+				error("Unable to read backup info block (offset %lld)\n",
+					offset);
+				goto out;
+			}
+			ret = btt_info_verify(bttc, btt_sb);
+			if (ret) {
+				error("Backup info block (offset %lld) verification failed\n",
+					offset);
+				goto out;
+			}
+			ret = btt_write_info(bttc, btt_sb, cur_off);
+		}
+
+		arena->external_lba_start = cur_nlba;
+		btt_parse_meta(arena, btt_sb, cur_off);
+
+		remaining -= arena->size;
+		cur_off += arena->size;
+		cur_nlba += arena->external_nlba;
+		arena->num = i;
+		i++;
+
+		if (arena->nextoff == 0)
+			break;
+	}
+	bttc->num_arenas = i;
+	bttc->nlba = cur_nlba;
+	printf("found %d BTT arena%s\n", bttc->num_arenas,
+		(bttc->num_arenas > 1) ? "s" : "");
+	free(btt_sb);
+	return ret;
+
+ out:
+	free(bttc->arena);
+	free(btt_sb);
+	return ret;
+}
+
+static int btt_create_mappings(struct btt_chk *bttc)
+{
+	int open_flags, mmap_flags;
+	struct arena_info *a;
+	int fd, rc = 0, i;
+
+	if (dryrun) {
+		open_flags = O_RDONLY;
+		mmap_flags = PROT_READ;
+	} else {
+		open_flags = O_RDWR|O_EXCL;
+		mmap_flags = PROT_READ|PROT_WRITE;
+	}
+
+	fd = open(bttc->path, open_flags);
+	if (fd < 0) {
+		error("unable to open %s: %s\n", bttc->path, strerror(errno));
+		return -errno;
+	}
+
+	for (i = 0; i < bttc->num_arenas; i++) {
+		a = &bttc->arena[i];
+		a->map.info_len = BTT_PG_SIZE;
+		a->map.info = mmap(NULL, a->map.info_len, mmap_flags,
+			MAP_SHARED, fd, a->infooff + SZ_4K);
+		if (a->map.info == MAP_FAILED) {
+			rc = errno;
+			error("mmap arena[%d].info [sz = %#lx, off = %#llx] failed: %d\n",
+					i, a->map.info_len, a->infooff + SZ_4K, rc);
+			goto out;
+		}
+
+		a->map.data_len = a->mapoff - a->dataoff;
+		a->map.data = mmap(NULL, a->map.data_len, mmap_flags,
+			MAP_SHARED, fd, a->dataoff + SZ_4K);
+		if (a->map.data == MAP_FAILED) {
+			rc = errno;
+			error("mmap arena[%d].data [sz = %#lx, off = %#llx] failed: %d\n",
+					i, a->map.data_len, a->dataoff + SZ_4K, rc);
+			goto out;
+		}
+
+		a->map.map_len = a->logoff - a->mapoff;
+		a->map.map = mmap(NULL, a->map.map_len, mmap_flags,
+			MAP_SHARED, fd, a->mapoff + SZ_4K);
+		if (a->map.map == MAP_FAILED) {
+			rc = errno;
+			error("mmap arena[%d].map [sz = %#lx, off = %#llx] failed: %d\n",
+					i, a->map.map_len, a->mapoff + SZ_4K, rc);
+			goto out;
+		}
+
+		a->map.log_len = a->info2off - a->logoff;
+		a->map.log = mmap(NULL, a->map.log_len, mmap_flags,
+			MAP_SHARED, fd, a->logoff + SZ_4K);
+		if (a->map.log == MAP_FAILED) {
+			rc = errno;
+			error("mmap arena[%d].log [sz = %#lx, off = %#llx] failed: %d\n",
+					i, a->map.log_len, a->logoff + SZ_4K, rc);
+			goto out;
+		}
+
+		a->map.info2_len = BTT_PG_SIZE;
+		a->map.info2 = mmap(NULL, a->map.info2_len, mmap_flags,
+			MAP_SHARED, fd, a->info2off + SZ_4K);
+		if (a->map.info2 == MAP_FAILED) {
+			rc = errno;
+			error("mmap arena[%d].info2 [sz = %#lx, off = %#llx] failed: %d\n",
+					i, a->map.info2_len, a->info2off + SZ_4K, rc);
+			goto out;
+		}
+	}
+
+ out:
+	close(fd);
+	return rc;
+}
+
+static void btt_remove_mappings(struct btt_chk *bttc)
+{
+	struct arena_info *a;
+	int i;
+
+	for (i = 0; i < bttc->num_arenas; i++) {
+		a = &bttc->arena[i];
+		if (a->map.info)
+			munmap(a->map.info, a->map.info_len);
+		if (a->map.data)
+			munmap(a->map.data, a->map.data_len);
+		if (a->map.map)
+			munmap(a->map.map, a->map.map_len);
+		if (a->map.log)
+			munmap(a->map.log, a->map.log_len);
+		if (a->map.info2)
+			munmap(a->map.info2, a->map.info2_len);
+	}
+}
+
+enum btt_errcodes {
+	BTT_OK = 0,
+	BTT_LOG_EQL_SEQ = 0x100,
+	BTT_LOG_OOB_SEQ,
+	BTT_LOG_OOB_LBA,
+	BTT_LOG_OOB_OLD,
+	BTT_LOG_OOB_NEW,
+	BTT_LOG_MAP_ERR,
+	BTT_MAP_OOB,
+};
+
+static void btt_xlat_status(struct arena_info *a, int errcode)
+{
+	switch(errcode) {
+	case BTT_OK:
+		break;
+	case BTT_LOG_EQL_SEQ:
+		error("arena %d: found a pair of log entries with the same sequence number\n",
+			a->num);
+		break;
+	case BTT_LOG_OOB_SEQ:
+		error("arena %d: found a log entry with an out of bounds sequence number\n",
+			a->num);
+		break;
+	case BTT_LOG_OOB_LBA:
+		error("arena %d: found a log entry with an out of bounds LBA\n",
+			a->num);
+		break;
+	case BTT_LOG_OOB_OLD:
+		error("arena %d: found a log entry with an out of bounds 'old' mapping\n",
+			a->num);
+		break;
+	case BTT_LOG_OOB_NEW:
+		error("arena %d: found a log entry with an out of bounds 'new' mapping\n",
+			a->num);
+		break;
+	case BTT_LOG_MAP_ERR:
+		error("arena %d: found a log entry that does not match with a map entry\n",
+			a->num);
+		break;
+	case BTT_MAP_OOB:
+		error("arena %d: found a map entry that is out of bounds\n",
+			a->num);
+		break;
+	default:
+		error("arena %d: unknown error: %d\n", a->num, errcode);
+	}
+}
+
+/* Check that log entries are self consistent */
+static int btt_check_log_entries(struct arena_info *a)
+{
+	unsigned int i;
+	int rc = 0;
+
+	/*
+	 * First, check both 'slots' for sequence numbers being distinct
+	 * and in bounds
+	 */
+	for (i = 0; i < (2 * a->nfree); i+=2) {
+		if (a->map.log[i].seq == a->map.log[i + 1].seq)
+			return BTT_LOG_EQL_SEQ;
+		if (a->map.log[i].seq > 3 || a->map.log[i + 1].seq > 3)
+			return BTT_LOG_OOB_SEQ;
+	}
+	/*
+	 * Next, check only the 'new' slot in each lane for the remaining
+	 * entries being in bounds
+	 */
+	for (i = 0; i < a->nfree; i++) {
+		struct log_entry log;
+
+		rc = btt_log_read(a, i, &log);
+		if (rc)
+			return rc;
+
+		if (log.lba >= a->external_nlba)
+			return BTT_LOG_OOB_LBA;
+		if (log.old_map >= a->internal_nlba)
+			return BTT_LOG_OOB_OLD;
+		if (log.new_map >= a->internal_nlba)
+			return BTT_LOG_OOB_NEW;
+	}
+	return rc;
+}
+
+/* Check that log entries are self consistent */
+static int btt_check_map_entries(struct arena_info *a)
+{
+	int rc = 0, z, e;
+	unsigned int i;
+	__u32 mapping;
+
+	for (i = 0; i < a->external_nlba; i++) {
+		rc = btt_map_read(a, i, &mapping, &z, &e);
+		if (rc)
+			return rc;
+		if (mapping >= a->internal_nlba)
+			return BTT_MAP_OOB;
+	}
+	return 0;
+}
+
+/* Check that each flog entry has the correct corresponding map entry */
+static int btt_check_log_map(struct arena_info *a)
+{
+	unsigned int i;
+	__u32 mapping;
+	int rc = 0;
+
+	for (i = 0; i < a->nfree; i++) {
+		struct log_entry log;
+
+		rc = btt_log_read(a, i, &log);
+		if (rc)
+			return rc;
+		rc = btt_map_read(a, log.lba, &mapping, NULL, NULL);
+		if (rc)
+			return rc;
+
+		/*
+		 * Case where the flog was written, but map couldn't be updated.
+		 * The kernel should also be able to detect and fix this condition
+		 */
+		if (log.new_map != mapping && log.old_map == mapping) {
+			error("arena %d: log[%d].new_map (%#x) doesn't match map[%#x] (%#x)",
+				a->num, i, log.new_map, log.lba, mapping);
+			rc = btt_map_write(a, log.lba, log.new_map, 0, 0);
+			if (rc)
+				return BTT_LOG_MAP_ERR;
+		}
+	}
+
+	return rc;
+}
+
+static int btt_check_info2(struct arena_info *a)
+{
+	/*
+	 * Repair info2 if needed. The main info-block can be trusted
+	 * as it has been verified during arena discovery
+	 */
+	if(memcmp(a->map.info2, a->map.info, BTT_PG_SIZE))
+		return btt_copy_to_info2(a);
+	return 0;
+}
+
+static int btt_check_arenas(struct btt_chk *bttc)
+{
+	struct arena_info *a = NULL;
+	int i, rc;
+
+	for(i = 0; i < bttc->num_arenas; i++) {
+		printf("checking arena %d\n", i);
+		a = &bttc->arena[i];
+		rc = btt_check_log_entries(a);
+		if (rc)
+			break;
+		rc = btt_check_map_entries(a);
+		if (rc)
+			break;
+		rc = btt_check_log_map(a);
+		if (rc)
+			break;
+		rc = btt_check_info2(a);
+		if (rc)
+			break;
+	}
+
+	btt_xlat_status(a, rc);
+	return rc;
+}
+
+static bool is_namespace_offline(struct ndctl_namespace *ndns)
+{
+	struct ndctl_dax *dax = ndctl_namespace_get_dax(ndns);
+	struct ndctl_btt *btt = ndctl_namespace_get_btt(ndns);
+	struct ndctl_pfn *pfn = ndctl_namespace_get_pfn(ndns);
+
+	if (ndctl_namespace_is_enabled(ndns))
+		return false;
+
+	if (dax && ndctl_dax_is_enabled(dax))
+		return false;
+
+	if (btt && ndctl_btt_is_enabled(btt))
+		return false;
+
+	if (pfn && ndctl_pfn_is_enabled(pfn))
+		return false;
+
+	return true;
+}
+
+static int btt_recover_first_sb(struct btt_chk *bttc)
+{
+	__u64 offset, remaining = bttc->rawsize;
+	int rc, est_arenas = 0;
+	struct btt_sb *btt_sb;
+
+	/* Estimate the number of arenas */
+	while (remaining) {
+		if (remaining < ARENA_MIN_SIZE && est_arenas == 0)
+			return -EINVAL;
+		if (remaining > ARENA_MAX_SIZE) {
+			remaining -= ARENA_MAX_SIZE;
+			est_arenas++;
+			continue;
+		}
+		if (remaining < ARENA_MIN_SIZE)
+			break;
+		else {
+			remaining = 0;
+			est_arenas++;
+			break;
+		}
+	}
+
+	btt_sb = malloc(2 * sizeof(*btt_sb));
+	if (btt_sb == NULL)
+		return -ENOMEM;
+	/* Read the original first info block into btt_sb[0] */
+	rc = btt_read_info(bttc, &btt_sb[0], 0);
+	if (rc)
+		goto out;
+
+	/* Attepmt 1: try recovery from expected end of the first arena */
+	/*
+	 * Offset calculation has to account for btt_read_info adding the
+	 * extra 4K, so subtract it here
+	 */
+	if (est_arenas == 1)
+		offset = rounddown(bttc->rawsize - remaining, BTT_PG_SIZE) -
+			2 * BTT_PG_SIZE;
+	else
+		offset = ARENA_MAX_SIZE - 2 * BTT_PG_SIZE;
+
+	printf("Attempting recover info-block using info2 at offset %#llx\n", offset);
+	rc = btt_read_info(bttc, &btt_sb[1], offset);
+	if (rc)
+		goto out;
+	rc = btt_info_verify(bttc, &btt_sb[1]);
+	if (rc == 0) {
+		rc = btt_write_info(bttc, &btt_sb[1], 0);
+		goto out;
+	}
+
+	/*
+	 * Attempt 2: From the very end of 'rawsize', try to copy the fields
+	 * that are constant in every arena (only valid when multiple arenas
+	 * are present)
+	 */
+	if (est_arenas > 1) {
+		offset = rounddown(bttc->rawsize - remaining, BTT_PG_SIZE) -
+			2 * BTT_PG_SIZE;
+		printf("Attempting to recover info-block from end offset %#llx\n", offset);
+		rc = btt_read_info(bttc, &btt_sb[1], offset);
+		if (rc)
+			goto out;
+		/* copy over the arena0 specific fields from btt_sb[0] */
+		btt_sb[1].flags = btt_sb[0].flags;
+		btt_sb[1].external_nlba = btt_sb[0].external_nlba;
+		btt_sb[1].internal_nlba = btt_sb[0].internal_nlba;
+		btt_sb[1].nextoff = btt_sb[0].nextoff;
+		btt_sb[1].dataoff = btt_sb[0].dataoff;
+		btt_sb[1].mapoff = btt_sb[0].mapoff;
+		btt_sb[1].logoff = btt_sb[0].logoff;
+		btt_sb[1].info2off = btt_sb[0].info2off;
+		btt_sb[1].checksum = btt_sb[0].checksum;
+		rc = btt_info_verify(bttc, &btt_sb[1]);
+		if (rc == 0) {
+			rc = btt_write_info(bttc, &btt_sb[1], 0);
+			goto out;
+		}
+	}
+
+	/*
+	 * Attempt 3: use info2off as-is, and check if we find a valid info
+	 * block at that location.
+	 */
+	 offset = le32toh(btt_sb[0].info2off);
+	 if (offset) {
+		printf("Attempting to recover info-block from info2 offset (as-is) %#llx\n", offset);
+		rc = btt_read_info(bttc, &btt_sb[1], offset);
+		if (rc)
+			goto out;
+		rc = btt_info_verify(bttc, &btt_sb[1]);
+		if (rc == 0) {
+			rc = btt_write_info(bttc, &btt_sb[1], 0);
+			goto out;
+		}
+	} else
+		rc = -ENXIO;
+ out:
+	free(btt_sb);
+	return rc;
+}
+
+static int namespace_check(struct ndctl_region *region,
+		struct ndctl_namespace *ndns)
+{
+	const char *devname = ndctl_namespace_get_devname(ndns);
+	struct btt_chk *bttc;
+	struct btt_sb *btt_sb;
+	int raw_mode, rc;
+	char path[50];
+
+	printf("checking %s\n", devname);
+	if (!is_namespace_offline(ndns)) {
+		error("%s: check aborted, namespace online\n", devname);
+		return -EBUSY;
+	}
+
+	raw_mode = ndctl_namespace_get_raw_mode(ndns);
+	ndctl_namespace_set_raw_mode(ndns, 1);
+	rc = ndctl_namespace_enable(ndns);
+	if (rc != 0)
+		error("%s: failed to enable raw mode\n", devname);
+	ndctl_namespace_set_raw_mode(ndns, raw_mode);
+	sprintf(path, "/dev/%s", ndctl_namespace_get_block_device(ndns));
+
+	btt_sb = malloc(sizeof(*btt_sb));
+	if (btt_sb == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	bttc = calloc(1, sizeof(*bttc));
+	if (bttc == NULL) {
+		rc = -ENOMEM;
+		goto out_sb;
+	}
+	bttc->path = path;
+	bttc->rawsize = ndctl_namespace_get_size(ndns);
+	ndctl_namespace_get_uuid(ndns, bttc->parent_uuid);
+
+	rc = btt_read_info(bttc, btt_sb, 0);
+	if (rc)
+		goto out_bttc;
+	rc = btt_info_verify(bttc, btt_sb);
+	if (rc) {
+		rc = btt_recover_first_sb(bttc);
+		if (rc) {
+			error("Unable to recover any BTT info blocks, aborting\n");
+			goto out_bttc;
+		}
+		rc = btt_read_info(bttc, btt_sb, 0);
+		if (rc)
+			goto out_bttc;
+	}
+	rc = btt_discover_arenas(bttc);
+	if (rc)
+		goto out_bttc;
+
+	rc = btt_create_mappings(bttc);
+	if (rc)
+		goto out_bttc;
+
+	rc = btt_check_arenas(bttc);
+
+ out_bttc:
+	btt_remove_mappings(bttc);
+	free(bttc);
+ out_sb:
+	free(btt_sb);
+ out:
+	ndctl_namespace_disable(ndns);
+	return rc;
+}
+
+#else
+static int namespace_check(struct ndctl_region *region,
+		struct ndctl_namespace *ndns)
+{
+	return -ENOTTY;
+}
+#endif
+
 static int do_xaction_namespace(const char *namespace,
 		enum namespace_action action, struct ndctl_ctx *ctx)
 {
@@ -765,6 +1646,9 @@ static int do_xaction_namespace(const char *namespace,
 				case ACTION_DESTROY:
 					rc = namespace_destroy(region, ndns);
 					break;
+				case ACTION_CHECK:
+					rc = namespace_check(region, ndns);
+					break;
 				case ACTION_CREATE:
 					rc = namespace_reconfig(region, ndns);
 					if (rc < 0)
@@ -873,3 +1757,25 @@ int cmd_destroy_namespace(int argc , const char **argv, void *ctx)
 		return 0;
 	}
 }
+
+int cmd_check_namespace(int argc , const char **argv, struct ndctl_ctx *ctx)
+{
+	char *xable_usage = "ndctl check-namespace <namespace> [<options>]";
+	const char *namespace = parse_namespace_options(argc, argv,
+			ACTION_CHECK, check_options, xable_usage);
+	int checked;
+
+	checked = do_xaction_namespace(namespace, ACTION_CHECK, ctx);
+	if (checked < 0) {
+		fprintf(stderr, "error checking namespaces: %s\n",
+				strerror(-checked));
+		return checked;
+	} else if (checked == 0) {
+		fprintf(stderr, "checked 0 namespaces\n");
+		return 0;
+	} else {
+		fprintf(stderr, "checked %d namespace%s\n", checked,
+				checked > 1 ? "s" : "");
+		return 0;
+	}
+}
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index 80a0491..ec018c7 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -57,6 +57,9 @@ static struct cmd_struct commands[] = {
 	{ "disable-namespace", cmd_disable_namespace },
 	{ "create-namespace", cmd_create_namespace },
 	{ "destroy-namespace", cmd_destroy_namespace },
+	#ifdef ENABLE_CHECK_NAMESPACE
+	{ "check-namespace", cmd_check_namespace },
+	#endif
 	{ "enable-region", cmd_enable_region },
 	{ "disable-region", cmd_disable_region },
 	{ "enable-dimm", cmd_enable_dimm },
diff --git a/util/util.h b/util/util.h
index e0e5f26..d280d10 100644
--- a/util/util.h
+++ b/util/util.h
@@ -23,6 +23,13 @@
 
 #define alloc_nr(x) (((x)+16)*3/2)
 
+#define rounddown(x, y) (				\
+{							\
+	typeof(x) __x = (x);				\
+	__x - (__x % (y));				\
+}							\
+)
+
 /*
  * Realloc the buffer pointed at by variable 'x' so that it can hold
  * at least 'nr' entries; the number of entries currently allocated
@@ -44,6 +51,7 @@
 #define zfree(ptr) ({ free(*ptr); *ptr = NULL; })
 
 #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
+#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
 
 static inline const char *skip_prefix(const char *str, const char *prefix)
 {
-- 
2.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
