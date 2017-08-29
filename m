Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D05362095B9C8
 for <linux-nvdimm@lists.01.org>; Tue, 29 Aug 2017 13:05:35 -0700 (PDT)
Subject: [ndctl PATCH 4/7] ndctl: consolidate namespace definitions in
 namespace.h
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 29 Aug 2017 13:01:52 -0700
Message-ID: <150403691228.8240.918388591318101224.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150403689024.8240.10207637569759874850.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150403689024.8240.10207637569759874850.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The following files all have some namespace-label and btt information:

   ndctl/dimm.c
   ndctl/check.h
   ndctl/lib/private.h

Consolidate all of this in a shared ndctl/namespace.h header.

Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/check.c        |   52 +++++++++++++++-
 ndctl/check.h        |  130 ----------------------------------------
 ndctl/dimm.c         |   50 ---------------
 ndctl/lib/libndctl.c |    6 +-
 ndctl/lib/private.h  |   90 ----------------------------
 ndctl/namespace.c    |   11 ++-
 ndctl/namespace.h    |  162 ++++++++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 222 insertions(+), 279 deletions(-)
 delete mode 100644 ndctl/check.h
 create mode 100644 ndctl/namespace.h

diff --git a/ndctl/check.c b/ndctl/check.c
index e05d1b073653..915bb9da8f5f 100644
--- a/ndctl/check.c
+++ b/ndctl/check.c
@@ -30,11 +30,11 @@
 #include <util/bitmap.h>
 #include <util/fletcher.h>
 #include <ndctl/libndctl.h>
+#include <ndctl/namespace.h>
 #include <ccan/endian/endian.h>
 #include <ccan/minmax/minmax.h>
 #include <ccan/array_size/array_size.h>
 #include <ccan/short_types/short_types.h>
-#include "check.h"
 
 #ifdef HAVE_NDCTL_H
 #include <linux/ndctl.h>
@@ -42,6 +42,48 @@
 #include <ndctl.h>
 #endif
 
+struct check_opts {
+	bool verbose;
+	bool force;
+	bool repair;
+};
+
+struct btt_chk {
+	char *path;
+	int fd;
+	uuid_t parent_uuid;
+	unsigned long long rawsize;
+	unsigned long long nlba;
+	int start_off;
+	int num_arenas;
+	long sys_page_size;
+	struct arena_info *arena;
+	struct check_opts *opts;
+	struct log_ctx ctx;
+};
+
+struct arena_info {
+	struct arena_map map;
+	u64 size;	/* Total bytes for this arena */
+	u64 external_lba_start;
+	u32 internal_nlba;
+	u32 internal_lbasize;
+	u32 external_nlba;
+	u32 external_lbasize;
+	u32 nfree;
+	u16 version_major;
+	u16 version_minor;
+	u64 nextoff;
+	u64 infooff;
+	u64 dataoff;
+	u64 mapoff;
+	u64 logoff;
+	u64 info2off;
+	u32 flags;
+	int num;
+	struct btt_chk *bttc;
+};
+
 static sigjmp_buf sj_env;
 
 static void sigbus_hdl(int sig, siginfo_t *siginfo, void *ptr)
@@ -922,9 +964,15 @@ static int btt_recover_first_sb(struct btt_chk *bttc)
 	return rc;
 }
 
-int namespace_check(struct ndctl_namespace *ndns, struct check_opts *opts)
+int namespace_check(struct ndctl_namespace *ndns, bool verbose, bool force,
+		bool repair)
 {
 	const char *devname = ndctl_namespace_get_devname(ndns);
+	struct check_opts __opts = {
+		.verbose = verbose,
+		.force = force,
+		.repair = repair,
+	}, *opts = &__opts;
 	int raw_mode, rc, disabled_flag = 0, open_flags;
 	struct btt_sb *btt_sb;
 	struct btt_chk *bttc;
diff --git a/ndctl/check.h b/ndctl/check.h
deleted file mode 100644
index 00b11b244ba0..000000000000
--- a/ndctl/check.h
+++ /dev/null
@@ -1,130 +0,0 @@
-/*
- * Copyright (c) 2016, Intel Corporation.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- */
-
-#ifndef _CHECK_H
-#define _CHECK_H
-
-#include <util/log.h>
-#include <ccan/endian/endian.h>
-#include <ccan/short_types/short_types.h>
-
-#define BTT_SIG_LEN 16
-#define BTT_SIG "BTT_ARENA_INFO\0"
-#define MAP_TRIM_SHIFT 31
-#define MAP_ERR_SHIFT 30
-#define MAP_LBA_MASK (~((1 << MAP_TRIM_SHIFT) | (1 << MAP_ERR_SHIFT)))
-#define MAP_ENT_NORMAL 0xC0000000
-#define ARENA_MIN_SIZE (1UL << 24)	/* 16 MB */
-#define ARENA_MAX_SIZE (1ULL << 39)	/* 512 GB */
-#define BTT_INFO_SIZE 4096
-#define IB_FLAG_ERROR_MASK 0x00000001
-
-#define BTT_NUM_OFFSETS 2
-#define BTT1_START_OFFSET 4096
-#define BTT2_START_OFFSET 0
-
-struct log_entry {
-	le32 lba;
-	le32 old_map;
-	le32 new_map;
-	le32 seq;
-	le64 padding[2];
-};
-
-struct btt_sb {
-	u8 signature[BTT_SIG_LEN];
-	u8 uuid[16];
-	u8 parent_uuid[16];
-	le32 flags;
-	le16 version_major;
-	le16 version_minor;
-	le32 external_lbasize;
-	le32 external_nlba;
-	le32 internal_lbasize;
-	le32 internal_nlba;
-	le32 nfree;
-	le32 infosize;
-	le64 nextoff;
-	le64 dataoff;
-	le64 mapoff;
-	le64 logoff;
-	le64 info2off;
-	u8 padding[3968];
-	le64 checksum;
-};
-
-struct free_entry {
-	u32 block;
-	u8 sub;
-	u8 seq;
-};
-
-struct arena_map {
-	struct btt_sb *info;
-	size_t info_len;
-	void *data;
-	size_t data_len;
-	u32 *map;
-	size_t map_len;
-	struct log_entry *log;
-	size_t log_len;
-	struct btt_sb *info2;
-	size_t info2_len;
-};
-
-struct check_opts {
-	bool verbose;
-	bool force;
-	bool repair;
-};
-
-struct btt_chk {
-	char *path;
-	int fd;
-	uuid_t parent_uuid;
-	unsigned long long rawsize;
-	unsigned long long nlba;
-	int start_off;
-	int num_arenas;
-	long sys_page_size;
-	struct arena_info *arena;
-	struct check_opts *opts;
-	struct log_ctx ctx;
-};
-
-
-struct arena_info {
-	struct arena_map map;
-	u64 size;	/* Total bytes for this arena */
-	u64 external_lba_start;
-	u32 internal_nlba;
-	u32 internal_lbasize;
-	u32 external_nlba;
-	u32 external_lbasize;
-	u32 nfree;
-	u16 version_major;
-	u16 version_minor;
-	u64 nextoff;
-	u64 infooff;
-	u64 dataoff;
-	u64 mapoff;
-	u64 logoff;
-	u64 info2off;
-	u32 flags;
-	int num;
-	struct btt_chk *bttc;
-};
-
-int namespace_check(struct ndctl_namespace *ndns, struct check_opts *opts);
-
-#endif
diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index ee3b9979fa8c..4a39189297a6 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -24,59 +24,11 @@
 #include <json-c/json.h>
 #include <util/fletcher.h>
 #include <ndctl/libndctl.h>
+#include <ndctl/namespace.h>
 #include <util/parse-options.h>
 #include <ccan/minmax/minmax.h>
-#include <ccan/short_types/short_types.h>
-#include <ccan/endian/endian.h>
 #include <ccan/array_size/array_size.h>
 
-enum {
-	NSINDEX_SIG_LEN = 16,
-	NSINDEX_ALIGN = 256,
-	NSINDEX_SEQ_MASK = 0x3,
-	NSLABEL_UUID_LEN = 16,
-	NSLABEL_NAME_LEN = 64,
-};
-
-struct namespace_index {
-	char sig[NSINDEX_SIG_LEN];
-	u8 flags[3];
-	u8 labelsize;
-	le32 seq;
-	le64 myoff;
-	le64 mysize;
-	le64 otheroff;
-	le64 labeloff;
-	le32 nslot;
-	le16 major;
-	le16 minor;
-	le64 checksum;
-	char free[0];
-};
-
-struct namespace_label {
-	char uuid[NSLABEL_UUID_LEN];
-	char name[NSLABEL_NAME_LEN];
-	le32 flags;
-	le16 nlabel;
-	le16 position;
-	le64 isetcookie;
-	le64 lbasize;
-	le64 dpa;
-	le64 rawsize;
-	le32 slot;
-	/*
-	 * Accessing fields past this point should be gated by a
-	 * namespace_label_has() check.
-	 */
-	u8 align;
-	u8 reserved[3];
-	char type_guid[NSLABEL_UUID_LEN];
-	char abstraction_guid[NSLABEL_UUID_LEN];
-	u8 reserved2[88];
-	le64 checksum;
-};
-
 struct nvdimm_data {
 	struct ndctl_dimm *dimm;
 	struct ndctl_cmd *cmd_read;
diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index f93ba9b8de76..86abeb6cc577 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -36,6 +36,7 @@
 
 #include <util/sysfs.h>
 #include <ndctl/libndctl.h>
+#include <ndctl/namespace.h>
 #include <daxctl/libdaxctl.h>
 #include "private.h"
 
@@ -55,7 +56,7 @@ static uuid_t null_uuid;
  */
 NDCTL_EXPORT size_t ndctl_sizeof_namespace_index(void)
 {
-	return sizeof_namespace_index();
+	return ALIGN(sizeof(struct namespace_index), NSINDEX_ALIGN);
 }
 
 /**
@@ -71,7 +72,8 @@ NDCTL_EXPORT size_t ndctl_min_namespace_size(void)
  */
 NDCTL_EXPORT size_t ndctl_sizeof_namespace_label(void)
 {
-	return sizeof(struct namespace_label);
+	/* TODO: v1.2 label support */
+	return offsetof(struct namespace_label, type_guid);
 }
 
 struct ndctl_ctx;
diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
index 12e3102150fd..64906b8123d0 100644
--- a/ndctl/lib/private.h
+++ b/ndctl/lib/private.h
@@ -91,96 +91,6 @@ struct ndctl_dimm {
 	int format[0];
 };
 
-#define SZ_16M 0x01000000
-
-enum {
-	NSINDEX_SIG_LEN = 16,
-	NSINDEX_ALIGN = 256,
-	NSLABEL_UUID_LEN = 16,
-	NSLABEL_NAMESPACE_MIN_SIZE = SZ_16M,
-	NSLABEL_NAME_LEN = 64,
-	NSLABEL_FLAG_ROLABEL = 0x1,  /* read-only label */
-	NSLABEL_FLAG_LOCAL = 0x2,    /* DIMM-local namespace */
-	NSLABEL_FLAG_BTT = 0x4,      /* namespace contains a BTT */
-	NSLABEL_FLAG_UPDATING = 0x8, /* label being updated */
-	BTT_ALIGN = 4096,            /* all btt structures */
-	BTTINFO_SIG_LEN = 16,
-	BTTINFO_UUID_LEN = 16,
-	BTTINFO_FLAG_ERROR = 0x1,    /* error state (read-only) */
-	BTTINFO_MAJOR_VERSION = 1,
-};
-
-/**
- * struct namespace_index - label set superblock
- * @sig: NAMESPACE_INDEX\0
- * @flags: placeholder
- * @seq: sequence number for this index
- * @myoff: offset of this index in label area
- * @mysize: size of this index struct
- * @otheroff: offset of other index
- * @labeloff: offset of first label slot
- * @nslot: total number of label slots
- * @major: label area major version
- * @minor: label area minor version
- * @checksum: fletcher64 of all fields
- * @free[0]: bitmap, nlabel bits
- *
- * The size of free[] is rounded up so the total struct size is a
- * multiple of NSINDEX_ALIGN bytes.  Any bits this allocates beyond
- * nlabel bits must be zero.
- */
-struct namespace_index {
-        u8 sig[NSINDEX_SIG_LEN];
-        le32 flags;
-        le32 seq;
-        le64 myoff;
-        le64 mysize;
-        le64 otheroff;
-        le64 labeloff;
-        le32 nslot;
-        le16 major;
-        le16 minor;
-        le64 checksum;
-        u8 free[0];
-};
-
-static inline size_t sizeof_namespace_index(void)
-{
-	size_t size = sizeof(struct namespace_index);
-
-	size += NSINDEX_ALIGN;
-	size &= ~(NSINDEX_ALIGN - 1);
-	return size;
-}
-
-/**
- * struct namespace_label - namespace superblock
- * @uuid: UUID per RFC 4122
- * @name: optional name (NULL-terminated)
- * @flags: see NSLABEL_FLAG_*
- * @nlabel: num labels to describe this ns
- * @position: labels position in set
- * @isetcookie: interleave set cookie
- * @lbasize: LBA size in bytes or 0 for pmem
- * @dpa: DPA of NVM range on this DIMM
- * @rawsize: size of namespace
- * @slot: slot of this label in label area
- * @unused: must be zero
- */
-struct namespace_label {
-	u8 uuid[NSLABEL_UUID_LEN];
-	u8 name[NSLABEL_NAME_LEN];
-	le32 flags;
-	le16 nlabel;
-	le16 position;
-	le64 isetcookie;
-	le64 lbasize;
-	le64 dpa;
-	le64 rawsize;
-	le32 slot;
-	le32 unused;
-};
-
 /**
  * struct ndctl_ctx - library user context to find "nd" instances
  *
diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index c4d70c39c6c4..6cfd873da248 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -28,7 +28,6 @@
 #include <util/parse-options.h>
 #include <ccan/minmax/minmax.h>
 #include <ccan/array_size/array_size.h>
-#include "check.h"
 
 #ifdef HAVE_NDCTL_H
 #include <linux/ndctl.h>
@@ -836,13 +835,15 @@ static int namespace_reconfig(struct ndctl_region *region,
 	return setup_namespace(region, ndns, &p);
 }
 
+int namespace_check(struct ndctl_namespace *ndns, bool verbose, bool force,
+		bool repair);
+
 static int do_xaction_namespace(const char *namespace,
 		enum namespace_action action, struct ndctl_ctx *ctx)
 {
 	struct ndctl_namespace *ndns, *_n;
 	int rc = -ENXIO, success = 0;
 	struct ndctl_region *region;
-	struct check_opts opts;
 	const char *ndns_name;
 	struct ndctl_bus *bus;
 
@@ -898,10 +899,8 @@ static int do_xaction_namespace(const char *namespace,
 					rc = namespace_destroy(region, ndns);
 					break;
 				case ACTION_CHECK:
-					opts.verbose = verbose;
-					opts.repair = repair;
-					opts.force = force;
-					rc = namespace_check(ndns, &opts);
+					rc = namespace_check(ndns, verbose,
+							force, repair);
 					if (rc < 0)
 						return rc;
 					break;
diff --git a/ndctl/namespace.h b/ndctl/namespace.h
new file mode 100644
index 000000000000..b466c2b96bd3
--- /dev/null
+++ b/ndctl/namespace.h
@@ -0,0 +1,162 @@
+/*
+ * Copyright (c) 2014-2017, Intel Corporation.
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
+#ifndef __NDCTL_NAMESPACE_H__
+#define __NDCTL_NAMESPACE_H__
+#include <util/size.h>
+#include <ccan/endian/endian.h>
+#include <ccan/short_types/short_types.h>
+
+enum {
+	NSINDEX_SIG_LEN = 16,
+	NSINDEX_ALIGN = 256,
+	NSINDEX_SEQ_MASK = 0x3,
+	NSLABEL_UUID_LEN = 16,
+	NSLABEL_NAMESPACE_MIN_SIZE = SZ_16M,
+	NSLABEL_NAME_LEN = 64,
+};
+
+/**
+ * struct namespace_index - label set superblock
+ * @sig: NAMESPACE_INDEX\0
+ * @flags: placeholder
+ * @seq: sequence number for this index
+ * @myoff: offset of this index in label area
+ * @mysize: size of this index struct
+ * @otheroff: offset of other index
+ * @labeloff: offset of first label slot
+ * @nslot: total number of label slots
+ * @major: label area major version
+ * @minor: label area minor version
+ * @checksum: fletcher64 of all fields
+ * @free[0]: bitmap, nlabel bits
+ *
+ * The size of free[] is rounded up so the total struct size is a
+ * multiple of NSINDEX_ALIGN bytes.  Any bits this allocates beyond
+ * nlabel bits must be zero.
+ */
+struct namespace_index {
+	char sig[NSINDEX_SIG_LEN];
+	u8 flags[3];
+	u8 labelsize;
+	le32 seq;
+	le64 myoff;
+	le64 mysize;
+	le64 otheroff;
+	le64 labeloff;
+	le32 nslot;
+	le16 major;
+	le16 minor;
+	le64 checksum;
+	char free[0];
+};
+
+/**
+ * struct namespace_label - namespace superblock
+ * @uuid: UUID per RFC 4122
+ * @name: optional name (NULL-terminated)
+ * @flags: see NSLABEL_FLAG_*
+ * @nlabel: num labels to describe this ns
+ * @position: labels position in set
+ * @isetcookie: interleave set cookie
+ * @lbasize: LBA size in bytes or 0 for pmem
+ * @dpa: DPA of NVM range on this DIMM
+ * @rawsize: size of namespace
+ * @slot: slot of this label in label area
+ */
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
+	/*
+	 * Accessing fields past this point should be gated by a
+	 * namespace_label_has() check.
+	 */
+	u8 align;
+	u8 reserved[3];
+	char type_guid[NSLABEL_UUID_LEN];
+	char abstraction_guid[NSLABEL_UUID_LEN];
+	u8 reserved2[88];
+	le64 checksum;
+};
+
+#define BTT_SIG_LEN 16
+#define BTT_SIG "BTT_ARENA_INFO\0"
+#define MAP_TRIM_SHIFT 31
+#define MAP_ERR_SHIFT 30
+#define MAP_LBA_MASK (~((1 << MAP_TRIM_SHIFT) | (1 << MAP_ERR_SHIFT)))
+#define MAP_ENT_NORMAL 0xC0000000
+#define ARENA_MIN_SIZE (1UL << 24)	/* 16 MB */
+#define ARENA_MAX_SIZE (1ULL << 39)	/* 512 GB */
+#define BTT_INFO_SIZE 4096
+#define IB_FLAG_ERROR_MASK 0x00000001
+
+#define BTT_NUM_OFFSETS 2
+#define BTT1_START_OFFSET 4096
+#define BTT2_START_OFFSET 0
+
+struct log_entry {
+	le32 lba;
+	le32 old_map;
+	le32 new_map;
+	le32 seq;
+	le64 padding[2];
+};
+
+struct btt_sb {
+	u8 signature[BTT_SIG_LEN];
+	u8 uuid[16];
+	u8 parent_uuid[16];
+	le32 flags;
+	le16 version_major;
+	le16 version_minor;
+	le32 external_lbasize;
+	le32 external_nlba;
+	le32 internal_lbasize;
+	le32 internal_nlba;
+	le32 nfree;
+	le32 infosize;
+	le64 nextoff;
+	le64 dataoff;
+	le64 mapoff;
+	le64 logoff;
+	le64 info2off;
+	u8 padding[3968];
+	le64 checksum;
+};
+
+struct free_entry {
+	u32 block;
+	u8 sub;
+	u8 seq;
+};
+
+struct arena_map {
+	struct btt_sb *info;
+	size_t info_len;
+	void *data;
+	size_t data_len;
+	u32 *map;
+	size_t map_len;
+	struct log_entry *log;
+	size_t log_len;
+	struct btt_sb *info2;
+	size_t info2_len;
+};
+#endif /* __NDCTL_NAMESPACE_H__ */

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
