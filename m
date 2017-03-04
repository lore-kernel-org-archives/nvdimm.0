Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 12406802DF
 for <linux-nvdimm@lists.01.org>; Fri,  3 Mar 2017 22:14:28 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v3 6/7] ndctl: add a BTT check utility
Date: Fri,  3 Mar 2017 23:13:06 -0700
Message-Id: <20170304061307.13530-7-vishal.l.verma@intel.com>
In-Reply-To: <20170304061307.13530-1-vishal.l.verma@intel.com>
References: <20170304061307.13530-1-vishal.l.verma@intel.com>
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

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Linda Knippers <linda.knippers@hpe.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Documentation/Makefile.am               |   1 +
 Documentation/ndctl-check-namespace.txt |  64 +++
 Documentation/ndctl.txt                 |   1 +
 builtin.h                               |   1 +
 contrib/ndctl                           |   3 +
 ndctl/Makefile.am                       |   1 +
 ndctl/builtin-check.c                   | 988 ++++++++++++++++++++++++++++++++
 ndctl/builtin-xaction-namespace.c       |  66 ++-
 ndctl/check.h                           | 127 ++++
 ndctl/ndctl.c                           |   1 +
 util/util.h                             |   8 +
 11 files changed, 1259 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/ndctl-check-namespace.txt
 create mode 100644 ndctl/builtin-check.c
 create mode 100644 ndctl/check.h

diff --git a/Documentation/Makefile.am b/Documentation/Makefile.am
index 6daeb56..eea11e0 100644
--- a/Documentation/Makefile.am
+++ b/Documentation/Makefile.am
@@ -12,6 +12,7 @@ man1_MANS = \
 	ndctl-disable-namespace.1 \
 	ndctl-create-namespace.1 \
 	ndctl-destroy-namespace.1 \
+	ndctl-check-namespace.1 \
 	ndctl-list.1 \
 	daxctl-list.1
 
diff --git a/Documentation/ndctl-check-namespace.txt b/Documentation/ndctl-check-namespace.txt
new file mode 100644
index 0000000..232f22d
--- /dev/null
+++ b/Documentation/ndctl-check-namespace.txt
@@ -0,0 +1,64 @@
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
+'ndctl check-namespace' <namespace> [<options>]
+
+DESCRIPTION
+-----------
+
+A namespace in the 'sector' mode will have metadata on it to describe
+the kernel BTT (Block Translation Table). The check-namespace command
+can be used to check the consistency of this metadata, and optionally,
+also attempt to repair it, if it has enough information to do so.
+
+The namespace being checked has to be disabled before initiating a
+check on it as a precautionary measure. The --force option can override
+this.
+
+EXAMPLES
+--------
+
+Check a namespace (only report errors)
+[verse]
+ndctl disable-namespace namespace0.0
+ndctl check-namespace namespace0.0
+
+Check a namespace, and perform repairs if possible
+[verse]
+ndctl disable-namespace namespace0.0
+ndctl check-namespace --repair namespace0.0
+
+OPTIONS
+-------
+-R::
+--repair::
+	Perform metadata repairs if possible. Without this option,
+	the raw namespace contents will not be touched.
+
+-f::
+--force::
+	Unless this option is specified, a check-namespace operation
+	will fail if the namespace is presently active. Specifying
+	--force causes the namespace to be disabled before checking.
+
+-v::
+--verbose::
+	Emit debug messages for the namespace check process.
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
index 9b66196..200bd8e 100644
--- a/builtin.h
+++ b/builtin.h
@@ -13,6 +13,7 @@ int cmd_enable_namespace(int argc, const char **argv, void *ctx);
 int cmd_create_namespace(int argc, const char **argv, void *ctx);
 int cmd_destroy_namespace(int argc, const char **argv, void *ctx);
 int cmd_disable_namespace(int argc, const char **argv, void *ctx);
+int cmd_check_namespace(int argc, const char **argv, void *ctx);
 int cmd_enable_region(int argc, const char **argv, void *ctx);
 int cmd_disable_region(int argc, const char **argv, void *ctx);
 int cmd_enable_dimm(int argc, const char **argv, void *ctx);
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
diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index c563e94..f9158d9 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -5,6 +5,7 @@ bin_PROGRAMS = ndctl
 ndctl_SOURCES = ndctl.c \
 		builtin-create-nfit.c \
 		builtin-xaction-namespace.c \
+		builtin-check.c \
 		builtin-xable-region.c \
 		builtin-dimm.c \
 		 ../util/log.c \
diff --git a/ndctl/builtin-check.c b/ndctl/builtin-check.c
new file mode 100644
index 0000000..3a7e6df
--- /dev/null
+++ b/ndctl/builtin-check.c
@@ -0,0 +1,988 @@
+/*
+ * Copyright(c) 2015-2016 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#include <stdio.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <stdint.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <limits.h>
+#include <stdbool.h>
+#include <sys/mman.h>
+#include <util/log.h>
+#include <uuid/uuid.h>
+#include <sys/types.h>
+#include <util/json.h>
+#include <util/size.h>
+#include <util/util.h>
+#include <util/fletcher.h>
+#include <ndctl/libndctl.h>
+#include <ccan/bitmap/bitmap.h>
+#include <ccan/endian/endian.h>
+#include <ccan/minmax/minmax.h>
+#include <ccan/array_size/array_size.h>
+#include <ccan/short_types/short_types.h>
+#include "check.h"
+
+#ifdef HAVE_NDCTL_H
+#include <linux/ndctl.h>
+#else
+#include <ndctl.h>
+#endif
+
+static int repair_msg(struct btt_chk *bttc)
+{
+	info(bttc, "  Run with --repair to make the changes\n");
+	return 0;
+}
+
+/**
+ * btt_read_info - read an info block from a given offset
+ * @bttc:	the main btt_chk structure for this btt
+ * @btt_sb:	struct btt_sb where the info block will be copied into
+ * @offset:	offset in the raw namespace to read the info block from
+ *
+ * This will also use 'pread' to read the info block, and not mmap+loads
+ * as this is used before the mappings are set up.
+ */
+static int btt_read_info(struct btt_chk *bttc, struct btt_sb *btt_sb, u64 off)
+{
+	ssize_t size;
+
+	size = pread(bttc->fd, btt_sb, sizeof(*btt_sb), off);
+	if (size < 0) {
+		err(bttc, "unable to read first info block: %s\n",
+			strerror(errno));
+		return -errno;
+	}
+	if (size != sizeof(*btt_sb)) {
+		err(bttc, "short read of first info block: %ld\n", size);
+		return -ENXIO;
+	}
+
+	return 0;
+}
+
+/**
+ * btt_write_info - write an info block to the given offset
+ * @bttc:	the main btt_chk structure for this btt
+ * @btt_sb:	struct btt_sb where the info block will be copied from
+ * @offset:	offset in the raw namespace to write the info block to
+ *
+ * This will also use 'pwrite' to write the info block, and not mmap+stores
+ * as this is used before the mappings are set up.
+ */
+static int btt_write_info(struct btt_chk *bttc, struct btt_sb *btt_sb, u64 off)
+{
+	ssize_t size;
+	int rc;
+
+	if (!bttc->opts->repair) {
+		err(bttc, "BTT info block at offset %#lx needs to be restored\n",
+			off);
+		repair_msg(bttc);
+		return -1;
+	}
+	info(bttc, "Restoring BTT info block at offset %#lx\n", off);
+
+	size = pwrite(bttc->fd, btt_sb, sizeof(*btt_sb), off);
+	if (size < 0) {
+		err(bttc, "unable to write the info block: %s\n",
+			strerror(errno));
+		return -errno;
+	}
+	if (size != sizeof(*btt_sb)) {
+		err(bttc, "short write of the info block: %ld\n", size);
+		return -ENXIO;
+	}
+
+	rc = fsync(bttc->fd);
+	if (rc < 0)
+		return -errno;
+	return 0;
+}
+
+/**
+ * btt_copy_to_info2 - restore the backup info block using the main one
+ * @a:		the arena_info handle for this arena
+ *
+ * Called when a corrupted backup info block is detected. Copies the
+ * main info block over to the backup location. This is done using
+ * mmap + stores, and thus needs a msync.
+ */
+static int btt_copy_to_info2(struct arena_info *a)
+{
+	void *ms_align;
+	size_t ms_size;
+
+	if (!a->bttc->opts->repair) {
+		err(a->bttc, "Arena %d: BTT info2 needs to be restored\n",
+			a->num);
+		return repair_msg(a->bttc);
+	}
+	printf("Arena %d: Restoring BTT info2\n", a->num);
+	memcpy(a->map.info2, a->map.info, BTT_INFO_SIZE);
+
+	ms_align = (void *)rounddown((u64)a->map.info2, a->bttc->sys_page_size);
+	ms_size = max(BTT_INFO_SIZE, a->bttc->sys_page_size);
+	if (msync(ms_align, ms_size, MS_SYNC) < 0)
+		return errno;
+
+	return 0;
+}
+
+/*
+ * btt_map_lookup - given a pre-map Arena Block Address, return the post-map ABA
+ * @a:		the arena_info handle for this arena
+ * @lba:	the logical block address for which we are performing the lookup
+ *
+ * This will correctly account for map entries in the 'initial state'
+ */
+static u32 btt_map_lookup(struct arena_info *a, u32 lba)
+{
+	u32 raw_mapping;
+
+	raw_mapping = le32_to_cpu(a->map.map[lba]);
+	if (raw_mapping & MAP_ENT_NORMAL)
+		return raw_mapping & MAP_LBA_MASK;
+	else
+		return lba;
+}
+
+static int btt_map_write(struct arena_info *a, u32 lba, u32 mapping)
+{
+	void *ms_align;
+
+	if (!a->bttc->opts->repair) {
+		err(a->bttc,
+			"Arena %d: map[%#x] needs to be updated to %#x\n",
+			a->num, lba, mapping);
+		return repair_msg(a->bttc);
+	}
+	info(a->bttc, "Arena %d: Updating map[%#x] to %#x\n", a->num,
+		lba, mapping);
+
+	/*
+	 * We want to set neither of the Z or E flags, and in the actual
+	 * layout, this means setting the bit positions of both to '1' to
+	 * indicate a 'normal' map entry
+	 */
+	mapping |= MAP_ENT_NORMAL;
+	a->map.map[lba] = cpu_to_le32(mapping);
+
+	ms_align = (void *)rounddown((u64)&a->map.map[lba],
+		a->bttc->sys_page_size);
+	if (msync(ms_align, a->bttc->sys_page_size, MS_SYNC) < 0)
+		return errno;
+
+	return 0;
+}
+
+static void btt_log_read_pair(struct arena_info *a, u32 lane,
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
+		ent[0].seq = cpu_to_le32(1);
+		return 0;
+	}
+
+	if (le32_to_cpu(ent[0].seq) < le32_to_cpu(ent[1].seq)) {
+		if (le32_to_cpu(ent[1].seq) - le32_to_cpu(ent[0].seq) == 1)
+			old = 0;
+		else
+			old = 1;
+	} else {
+		if (le32_to_cpu(ent[0].seq) - le32_to_cpu(ent[1].seq) == 1)
+			old = 1;
+		else
+			old = 0;
+	}
+
+	return old;
+}
+
+static int btt_log_read(struct arena_info *a, u32 lane, struct log_entry *ent)
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
+static int btt_checksum_verify(struct btt_sb *btt_sb)
+{
+	uint64_t sum;
+	le64 sum_save;
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
+ * In the non --repair case, even if such a buffer is passed, the write will
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
+static int btt_info_read_verify(struct btt_chk *bttc, struct btt_sb *btt_sb,
+	u64 off)
+{
+	int rc;
+
+	rc = btt_read_info(bttc, btt_sb, off);
+	if (rc)
+		return rc;
+	rc = btt_info_verify(bttc, btt_sb);
+	if (rc)
+		return rc;
+	return 0;
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
+	BTT_BITMAP_ERROR,
+};
+
+static void btt_xlat_status(struct arena_info *a, int errcode)
+{
+	switch(errcode) {
+	case BTT_OK:
+		break;
+	case BTT_LOG_EQL_SEQ:
+		err(a->bttc,
+			"arena %d: found a pair of log entries with the same sequence number\n",
+			a->num);
+		break;
+	case BTT_LOG_OOB_SEQ:
+		err(a->bttc,
+			"arena %d: found a log entry with an out of bounds sequence number\n",
+			a->num);
+		break;
+	case BTT_LOG_OOB_LBA:
+		err(a->bttc,
+			"arena %d: found a log entry with an out of bounds LBA\n",
+			a->num);
+		break;
+	case BTT_LOG_OOB_OLD:
+		err(a->bttc,
+			"arena %d: found a log entry with an out of bounds 'old' mapping\n",
+			a->num);
+		break;
+	case BTT_LOG_OOB_NEW:
+		err(a->bttc,
+			"arena %d: found a log entry with an out of bounds 'new' mapping\n",
+			a->num);
+		break;
+	case BTT_LOG_MAP_ERR:
+		info(a->bttc,
+			"arena %d: found a log entry that does not match with a map entry\n",
+			a->num);
+		break;
+	case BTT_MAP_OOB:
+		err(a->bttc,
+			"arena %d: found a map entry that is out of bounds\n",
+			a->num);
+		break;
+	case BTT_BITMAP_ERROR:
+		err(a->bttc,
+			"arena %d: bitmap error: internal blocks are incorrectly referenced\n",
+			a->num);
+		break;
+	default:
+		err(a->bttc, "arena %d: unknown error: %d\n",
+			a->num, errcode);
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
+/* Check that map entries are self consistent */
+static int btt_check_map_entries(struct arena_info *a)
+{
+	unsigned int i;
+	u32 mapping;
+
+	for (i = 0; i < a->external_nlba; i++) {
+		mapping = btt_map_lookup(a, i);
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
+	u32 mapping;
+	int rc = 0, rc_saved = 0;
+
+	for (i = 0; i < a->nfree; i++) {
+		struct log_entry log;
+
+		rc = btt_log_read(a, i, &log);
+		if (rc)
+			return rc;
+		mapping = btt_map_lookup(a, log.lba);
+
+		/*
+		 * Case where the flog was written, but map couldn't be
+		 * updated. The kernel should also be able to detect and
+		 * fix this condition.
+		 */
+		if (log.new_map != mapping && log.old_map == mapping) {
+			info(a->bttc,
+				"arena %d: log[%d].new_map (%#x) doesn't match map[%#x] (%#x)\n",
+				a->num, i, log.new_map, log.lba, mapping);
+			rc = btt_map_write(a, log.lba, log.new_map);
+			if (rc)
+				rc_saved = rc;
+		}
+	}
+	return rc_saved ? BTT_LOG_MAP_ERR : 0;
+}
+
+static int btt_check_info2(struct arena_info *a)
+{
+	/*
+	 * Repair info2 if needed. The main info-block can be trusted
+	 * as it has been verified during arena discovery
+	 */
+	if(memcmp(a->map.info2, a->map.info, BTT_INFO_SIZE))
+		return btt_copy_to_info2(a);
+	return 0;
+}
+
+/*
+ * This will create a bitmap where each bit corresponds to an internal
+ * 'block'. Between the BTT map and flog (representing 'free' blocks),
+ * every single internal block must be represented exactly once. This
+ * check will detect cases where either one or more blocks are never
+ * referenced, or if a block is referenced more than once.
+ */
+static int btt_check_bitmap(struct arena_info *a)
+{
+	bitmap_t *bm;
+	u32 i, mapping;
+	int rc;
+
+	bm = bitmap_alloc0(a->internal_nlba);
+	if (bm == NULL)
+		return -ENOMEM;
+
+	/* map 'external_nlba' number of map entries */
+	for (i = 0; i < a->external_nlba; i++) {
+		mapping = btt_map_lookup(a, i);
+		if (bitmap_test_bit(bm, mapping)) {
+			info(a->bttc,
+				"arena %d: internal block %#x is referenced by two map entries\n",
+				a->num, mapping);
+			rc = BTT_BITMAP_ERROR;
+			goto out;
+		}
+		bitmap_set_bit(bm, mapping);
+	}
+
+	/* map 'nfree' number of flog entries */
+	for (i = 0; i < a->nfree; i++) {
+		struct log_entry log;
+
+		rc = btt_log_read(a, i, &log);
+		if (rc)
+			goto out;
+		if (bitmap_test_bit(bm, log.old_map)) {
+			info(a->bttc,
+				"arena %d: internal block %#x is referenced by two map/log entries\n",
+				a->num, log.old_map);
+			rc = BTT_BITMAP_ERROR;
+			goto out;
+		}
+		bitmap_set_bit(bm, log.old_map);
+	}
+
+	/* check that the bitmap is full */
+	if (!bitmap_full(bm, a->internal_nlba))
+		rc = BTT_BITMAP_ERROR;
+ out:
+	free(bm);
+	return rc;
+}
+
+static int btt_check_arenas(struct btt_chk *bttc)
+{
+	struct arena_info *a = NULL;
+	int i, rc;
+
+	for(i = 0; i < bttc->num_arenas; i++) {
+		info(bttc, "checking arena %d\n", i);
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
+		/*
+		 * bitmap test has to be after check_log_map so that any
+		 * pending log updates have been performed. Otherwise the
+		 * bitmap test may result in a false positive
+		 */
+		rc = btt_check_bitmap(a);
+		if (rc)
+			break;
+	}
+
+	btt_xlat_status(a, rc);
+	if (rc)
+		return -ENXIO;
+	return 0;
+}
+
+/*
+ * This copies over information from the info block to the arena_info struct.
+ * The main difference is that all the offsets (infooff, mapoff etc) were
+ * relative to the arena in the info block, but in arena_info, we use
+ * arena_off to make these offsets absolute, i.e. relative to the start of
+ * the raw namespace.
+ */
+static int btt_parse_meta(struct arena_info *arena, struct btt_sb *btt_sb,
+				u64 arena_off)
+{
+	arena->internal_nlba = le32_to_cpu(btt_sb->internal_nlba);
+	arena->internal_lbasize = le32_to_cpu(btt_sb->internal_lbasize);
+	arena->external_nlba = le32_to_cpu(btt_sb->external_nlba);
+	arena->external_lbasize = le32_to_cpu(btt_sb->external_lbasize);
+	arena->nfree = le32_to_cpu(btt_sb->nfree);
+
+	if (arena->internal_nlba - arena->external_nlba != arena->nfree)
+		return -ENXIO;
+	if (arena->internal_lbasize != arena->external_lbasize)
+		return -ENXIO;
+
+	arena->version_major = le16_to_cpu(btt_sb->version_major);
+	arena->version_minor = le16_to_cpu(btt_sb->version_minor);
+
+	arena->nextoff = (btt_sb->nextoff == 0) ? 0 : (arena_off +
+			le64_to_cpu(btt_sb->nextoff));
+	arena->infooff = arena_off;
+	arena->dataoff = arena_off + le64_to_cpu(btt_sb->dataoff);
+	arena->mapoff = arena_off + le64_to_cpu(btt_sb->mapoff);
+	arena->logoff = arena_off + le64_to_cpu(btt_sb->logoff);
+	arena->info2off = arena_off + le64_to_cpu(btt_sb->info2off);
+
+	arena->size = (le64_to_cpu(btt_sb->nextoff) > 0)
+		? (le64_to_cpu(btt_sb->nextoff))
+		: (arena->info2off - arena->infooff + BTT_INFO_SIZE);
+
+	arena->flags = le32_to_cpu(btt_sb->flags);
+	if (btt_sb->flags & IB_FLAG_ERROR_MASK) {
+		err(arena->bttc, "Info block error flag is set, aborting\n");
+		return -ENXIO;
+	}
+	return 0;
+}
+
+static int btt_discover_arenas(struct btt_chk *bttc)
+{
+	int ret = 0;
+	struct arena_info *arena;
+	struct btt_sb *btt_sb;
+	size_t remaining = bttc->rawsize;
+	size_t cur_off = bttc->start_off;
+	u64 cur_nlba = 0;
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
+			u64 offset;
+
+			/* Try to find the backup info block */
+			if (remaining <= ARENA_MAX_SIZE)
+				offset = rounddown(bttc->rawsize, SZ_4K) -
+					BTT_INFO_SIZE;
+			else
+				offset = cur_off + ARENA_MAX_SIZE -
+					BTT_INFO_SIZE;
+
+			info(bttc,
+				"Arena %d: Attempting recover info-block using info2\n", i);
+			ret = btt_read_info(bttc, btt_sb, offset);
+			if (ret) {
+				err(bttc, "Unable to read backup info block (offset %#lx)\n",
+					offset);
+				goto out;
+			}
+			ret = btt_info_verify(bttc, btt_sb);
+			if (ret) {
+				err(bttc, "Backup info block (offset %#lx) verification failed\n",
+					offset);
+				goto out;
+			}
+			ret = btt_write_info(bttc, btt_sb, cur_off);
+			if (ret) {
+				err(bttc, "Restoration of the info block failed: %d\n",
+					ret);
+				goto out;
+			}
+		}
+
+		arena->num = i;
+		arena->bttc = bttc;
+		arena->external_lba_start = cur_nlba;
+		ret = btt_parse_meta(arena, btt_sb, cur_off);
+		if (ret) {
+			err(bttc, "Problem parsing arena[%d] metadata\n", i);
+			goto out;
+		}
+		remaining -= arena->size;
+		cur_off += arena->size;
+		cur_nlba += arena->external_nlba;
+		i++;
+
+		if (arena->nextoff == 0)
+			break;
+	}
+	bttc->num_arenas = i;
+	bttc->nlba = cur_nlba;
+	info(bttc, "found %d BTT arena%s\n", bttc->num_arenas,
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
+	struct arena_info *a;
+	int mmap_flags;
+	int i;
+
+	if (!bttc->opts->repair)
+		mmap_flags = PROT_READ;
+	else
+		mmap_flags = PROT_READ|PROT_WRITE;
+
+	for (i = 0; i < bttc->num_arenas; i++) {
+		a = &bttc->arena[i];
+		a->map.info_len = BTT_INFO_SIZE;
+		a->map.info = mmap(NULL, a->map.info_len, mmap_flags,
+			MAP_SHARED, bttc->fd, a->infooff);
+		if (a->map.info == MAP_FAILED) {
+			err(bttc, "mmap arena[%d].info [sz = %#lx, off = %#lx] failed: %d\n",
+				i, a->map.info_len, a->infooff, errno);
+			return -errno;
+		}
+
+		a->map.data_len = a->mapoff - a->dataoff;
+		a->map.data = mmap(NULL, a->map.data_len, mmap_flags,
+			MAP_SHARED, bttc->fd, a->dataoff);
+		if (a->map.data == MAP_FAILED) {
+			err(bttc, "mmap arena[%d].data [sz = %#lx, off = %#lx] failed: %d\n",
+				i, a->map.data_len, a->dataoff, errno);
+			return -errno;
+		}
+
+		a->map.map_len = a->logoff - a->mapoff;
+		a->map.map = mmap(NULL, a->map.map_len, mmap_flags,
+			MAP_SHARED, bttc->fd, a->mapoff);
+		if (a->map.map == MAP_FAILED) {
+			err(bttc, "mmap arena[%d].map [sz = %#lx, off = %#lx] failed: %d\n",
+				i, a->map.map_len, a->mapoff, errno);
+			return -errno;
+		}
+
+		a->map.log_len = a->info2off - a->logoff;
+		a->map.log = mmap(NULL, a->map.log_len, mmap_flags,
+			MAP_SHARED, bttc->fd, a->logoff);
+		if (a->map.log == MAP_FAILED) {
+			err(bttc, "mmap arena[%d].log [sz = %#lx, off = %#lx] failed: %d\n",
+				i, a->map.log_len, a->logoff, errno);
+			return -errno;
+		}
+
+		a->map.info2_len = BTT_INFO_SIZE;
+		a->map.info2 = mmap(NULL, a->map.info2_len, mmap_flags,
+			MAP_SHARED, bttc->fd, a->info2off);
+		if (a->map.info2 == MAP_FAILED) {
+			err(bttc, "mmap arena[%d].info2 [sz = %#lx, off = %#lx] failed: %d\n",
+				i, a->map.info2_len, a->info2off, errno);
+			return -errno;
+		}
+	}
+
+	return 0;
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
+static int btt_recover_first_sb(struct btt_chk *bttc)
+{
+	int rc, est_arenas = 0;
+	u64 offset, remaining;
+	struct btt_sb *btt_sb;
+
+	/* Estimate the number of arenas */
+	remaining = bttc->rawsize - bttc->start_off;
+	while (remaining) {
+		if (remaining < ARENA_MIN_SIZE && est_arenas == 0)
+			return -EINVAL;
+		if (remaining > ARENA_MAX_SIZE) {
+			/* full-size arena */
+			remaining -= ARENA_MAX_SIZE;
+			est_arenas++;
+			continue;
+		}
+		if (remaining < ARENA_MIN_SIZE) {
+			/* 'remaining' was too small for another arena */
+			break;
+		} else {
+			/* last, short arena */
+			remaining = 0;
+			est_arenas++;
+			break;
+		}
+	}
+	info(bttc, "estimated arenas: %d, remaining bytes: %#lx\n",
+		est_arenas, remaining);
+
+	btt_sb = malloc(2 * sizeof(*btt_sb));
+	if (btt_sb == NULL)
+		return -ENOMEM;
+	/* Read the original first info block into btt_sb[0] */
+	rc = btt_read_info(bttc, &btt_sb[0], bttc->start_off);
+	if (rc)
+		goto out;
+
+	/* Attepmt 1: try recovery from expected end of the first arena */
+	if (est_arenas == 1)
+		offset = rounddown(bttc->rawsize - remaining, SZ_4K) -
+			BTT_INFO_SIZE;
+	else
+		offset = ARENA_MAX_SIZE - BTT_INFO_SIZE + bttc->start_off;
+
+	info(bttc, "Attempting recover info-block from end-of-arena offset %#lx\n",
+		offset);
+	rc = btt_info_read_verify(bttc, &btt_sb[1], offset);
+	if (rc == 0) {
+		rc = btt_write_info(bttc, &btt_sb[1], bttc->start_off);
+		goto out;
+	}
+
+	/*
+	 * Attempt 2: From the very end of 'rawsize', try to copy the fields
+	 * that are constant in every arena (only valid when multiple arenas
+	 * are present)
+	 */
+	if (est_arenas > 1) {
+		offset = rounddown(bttc->rawsize - remaining, SZ_4K) -
+			BTT_INFO_SIZE;
+		info(bttc, "Attempting to recover info-block from end offset %#lx\n",
+			offset);
+		rc = btt_info_read_verify(bttc, &btt_sb[1], offset);
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
+			rc = btt_write_info(bttc, &btt_sb[1], bttc->start_off);
+			goto out;
+		}
+	}
+
+	/*
+	 * Attempt 3: use info2off as-is, and check if we find a valid info
+	 * block at that location.
+	 */
+	offset = le32_to_cpu(btt_sb[0].info2off);
+	if (offset > min(bttc->rawsize - BTT_INFO_SIZE,
+			ARENA_MAX_SIZE - BTT_INFO_SIZE + bttc->start_off)) {
+		rc = -ENXIO;
+		goto out;
+	}
+	if (offset) {
+		info(bttc, "Attempting to recover info-block from info2 offset %#lx\n",
+			offset);
+		rc = btt_info_read_verify(bttc, &btt_sb[1],
+			offset + bttc->start_off);
+		if (rc == 0) {
+			rc = btt_write_info(bttc, &btt_sb[1], bttc->start_off);
+			goto out;
+		}
+	} else
+		rc = -ENXIO;
+ out:
+	free(btt_sb);
+	return rc;
+}
+
+int namespace_check(struct ndctl_namespace *ndns, struct check_opts *opts)
+{
+	const char *devname = ndctl_namespace_get_devname(ndns);
+	int raw_mode, rc, disabled_flag = 0, open_flags;
+	struct btt_sb *btt_sb;
+	struct btt_chk *bttc;
+	char path[50];
+
+	bttc = calloc(1, sizeof(*bttc));
+	if (bttc == NULL)
+		return -ENOMEM;
+
+	log_init(&bttc->ctx, devname, "NDCTL_CHECK_NAMESPACE");
+	if (opts->verbose)
+		bttc->ctx.log_priority = LOG_DEBUG;
+
+	bttc->opts = opts;
+	bttc->start_off = BTT_START_OFFSET;
+	bttc->sys_page_size = sysconf(_SC_PAGESIZE);
+	bttc->rawsize = ndctl_namespace_get_size(ndns);
+	ndctl_namespace_get_uuid(ndns, bttc->parent_uuid);
+
+	info(bttc, "checking %s\n", devname);
+	if (ndctl_namespace_is_active(ndns)) {
+		if (opts->force) {
+			rc = ndctl_namespace_disable_safe(ndns);
+			if (rc)
+				return rc;
+			disabled_flag = 1;
+		} else {
+			err(bttc, "%s: check aborted, namespace online\n",
+				devname);
+			rc = -EBUSY;
+			goto out_bttc;
+		}
+	}
+
+	/* In typical usage, the current raw_mode should be false. */
+	raw_mode = ndctl_namespace_get_raw_mode(ndns);
+
+	/*
+	 * Putting the namespace into raw mode will allow us to access
+	 * the btt metadata.
+	 */
+	rc = ndctl_namespace_set_raw_mode(ndns, 1);
+	if (rc < 0) {
+		err(bttc, "%s: failed to set the raw mode flag: %d\n",
+			devname, rc);
+		goto out_ns;
+	}
+	/*
+	 * Now enable the namespace.  This will result in a pmem device
+	 * node showing up in /dev that is in raw mode.
+	 */
+	rc = ndctl_namespace_enable(ndns);
+	if (rc != 0) {
+		err(bttc, "%s: failed to enable in raw mode: %d\n",
+			devname, rc);
+		goto out_ns;
+	}
+
+	sprintf(path, "/dev/%s", ndctl_namespace_get_block_device(ndns));
+	bttc->path = path;
+
+	btt_sb = malloc(sizeof(*btt_sb));
+	if (btt_sb == NULL) {
+		rc = -ENOMEM;
+		goto out_ns;
+	}
+
+	if (!bttc->opts->repair)
+		open_flags = O_RDONLY|O_EXCL;
+	else
+		open_flags = O_RDWR|O_EXCL;
+
+	bttc->fd = open(bttc->path, open_flags);
+	if (bttc->fd < 0) {
+		err(bttc, "unable to open %s: %s\n",
+			bttc->path, strerror(errno));
+		rc = -errno;
+		goto out_sb;
+	}
+
+	rc = btt_info_read_verify(bttc, btt_sb, bttc->start_off);
+	if (rc) {
+		rc = btt_recover_first_sb(bttc);
+		if (rc) {
+			info(bttc, "Unable to recover any BTT info blocks\n");
+			goto out_close;
+		}
+		rc = btt_info_read_verify(bttc, btt_sb, bttc->start_off);
+		if (rc)
+			goto out_close;
+	}
+	rc = btt_discover_arenas(bttc);
+	if (rc)
+		goto out_close;
+
+	rc = btt_create_mappings(bttc);
+	if (rc)
+		goto out_close;
+
+	rc = btt_check_arenas(bttc);
+
+	btt_remove_mappings(bttc);
+ out_close:
+	close(bttc->fd);
+ out_sb:
+	free(btt_sb);
+ out_ns:
+	ndctl_namespace_set_raw_mode(ndns, raw_mode);
+	ndctl_namespace_disable_invalidate(ndns);
+	if (disabled_flag)
+		if(ndctl_namespace_enable(ndns) < 0)
+			info(bttc, "%s: failed to re-enable namespace\n",
+				devname);
+ out_bttc:
+	free(bttc);
+	return rc;
+}
diff --git a/ndctl/builtin-xaction-namespace.c b/ndctl/builtin-xaction-namespace.c
index d6b0c37..8c62d14 100644
--- a/ndctl/builtin-xaction-namespace.c
+++ b/ndctl/builtin-xaction-namespace.c
@@ -28,6 +28,7 @@
 #include <util/parse-options.h>
 #include <ccan/minmax/minmax.h>
 #include <ccan/array_size/array_size.h>
+#include "check.h"
 
 #ifdef HAVE_NDCTL_H
 #include <linux/ndctl.h>
@@ -37,6 +38,7 @@
 
 static bool verbose;
 static bool force;
+static bool repair;
 static struct parameters {
 	bool do_scan;
 	bool mode_default;
@@ -112,6 +114,10 @@ OPT_STRING('a', "align", &param.align, "align", \
 	"specify the namespace alignment in bytes (default: 2M)"), \
 OPT_BOOLEAN('f', "force", &force, "reconfigure namespace even if currently active")
 
+#define CHECK_OPTIONS() \
+OPT_BOOLEAN('R', "repair", &repair, "perform metadata repairs"), \
+OPT_BOOLEAN('f', "force", &force, "check namespace even if currently active")
+
 static const struct option base_options[] = {
 	BASE_OPTIONS(),
 	OPT_END(),
@@ -130,11 +136,18 @@ static const struct option create_options[] = {
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
@@ -268,8 +281,26 @@ static const char *parse_namespace_options(int argc, const char **argv,
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
+			case ACTION_DESTROY:
+				action_string = "destroy";
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
@@ -793,6 +824,7 @@ static int do_xaction_namespace(const char *namespace,
 	struct ndctl_namespace *ndns, *_n;
 	int rc = -ENXIO, success = 0;
 	struct ndctl_region *region;
+	struct check_opts opts;
 	const char *ndns_name;
 	struct ndctl_bus *bus;
 
@@ -847,6 +879,14 @@ static int do_xaction_namespace(const char *namespace,
 				case ACTION_DESTROY:
 					rc = namespace_destroy(region, ndns);
 					break;
+				case ACTION_CHECK:
+					opts.verbose = verbose;
+					opts.repair = repair;
+					opts.force = force;
+					rc = namespace_check(ndns, &opts);
+					if (rc < 0)
+						return rc;
+					break;
 				case ACTION_CREATE:
 					rc = namespace_reconfig(region, ndns);
 					if (rc < 0)
@@ -965,3 +1005,25 @@ int cmd_destroy_namespace(int argc , const char **argv, void *ctx)
 		return 0;
 	}
 }
+
+int cmd_check_namespace(int argc , const char **argv, void *ctx)
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
diff --git a/ndctl/check.h b/ndctl/check.h
new file mode 100644
index 0000000..f0200db
--- /dev/null
+++ b/ndctl/check.h
@@ -0,0 +1,127 @@
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
+#ifndef _CHECK_H
+#define _CHECK_H
+
+#include <util/log.h>
+#include <ccan/endian/endian.h>
+#include <ccan/short_types/short_types.h>
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
+#define BTT_START_OFFSET 4096
+#define IB_FLAG_ERROR_MASK 0x00000001
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
+
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
+int namespace_check(struct ndctl_namespace *ndns, struct check_opts *opts);
+
+#endif
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index 80a0491..0678a9a 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -57,6 +57,7 @@ static struct cmd_struct commands[] = {
 	{ "disable-namespace", cmd_disable_namespace },
 	{ "create-namespace", cmd_create_namespace },
 	{ "destroy-namespace", cmd_destroy_namespace },
+	{ "check-namespace", cmd_check_namespace },
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
