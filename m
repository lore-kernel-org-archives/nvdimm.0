Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2266F21F3882D
 for <linux-nvdimm@lists.01.org>; Thu, 12 Oct 2017 17:08:47 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v2 2/6] libndctl: add error injection related interfaces
Date: Thu, 12 Oct 2017 18:10:00 -0600
Message-Id: <20171013001004.14963-3-vishal.l.verma@intel.com>
In-Reply-To: <20171013001004.14963-1-vishal.l.verma@intel.com>
References: <20171013001004.14963-1-vishal.l.verma@intel.com>
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

Add interfaces to enable error injection commands. Add nfit specific
error injection helpers in ndctl/lib/nfit.c, and generic wrappers for
them in libndctl.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/lib/Makefile.am  |   1 +
 ndctl/lib/inject.c     | 391 +++++++++++++++++++++++++++++++++++++++++++++++++
 ndctl/lib/libndctl.c   |  47 +-----
 ndctl/lib/libndctl.sym |   9 ++
 ndctl/lib/nfit.c       |  89 +++++++++++
 ndctl/lib/private.h    |  53 +++++++
 ndctl/libndctl-nfit.h  |   2 +
 ndctl/libndctl.h.in    |  23 +++
 8 files changed, 573 insertions(+), 42 deletions(-)
 create mode 100644 ndctl/lib/inject.c

diff --git a/ndctl/lib/Makefile.am b/ndctl/lib/Makefile.am
index 9a7734d..3a6024e 100644
--- a/ndctl/lib/Makefile.am
+++ b/ndctl/lib/Makefile.am
@@ -18,6 +18,7 @@ libndctl_la_SOURCES =\
 	../../util/sysfs.c \
 	../../util/sysfs.h \
 	dimm.c \
+	inject.c \
 	libndctl.c
 
 libndctl_la_LIBADD =\
diff --git a/ndctl/lib/inject.c b/ndctl/lib/inject.c
new file mode 100644
index 0000000..2660384
--- /dev/null
+++ b/ndctl/lib/inject.c
@@ -0,0 +1,391 @@
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
+#include <stdlib.h>
+#include <limits.h>
+#include <util/list.h>
+#include <util/size.h>
+#include <ndctl/libndctl.h>
+#include <ccan/list/list.h>
+#include <ndctl/libndctl-nfit.h>
+#include <ccan/short_types/short_types.h>
+#include "private.h"
+
+NDCTL_EXPORT int ndctl_bus_has_error_injection(struct ndctl_bus *bus)
+{
+	/* Currently, only nfit buses have error injection */
+	if (!bus || !ndctl_bus_has_nfit(bus))
+		return 0;
+
+	if (ndctl_bus_is_nfit_cmd_supported(bus, NFIT_CMD_ARS_INJECT_SET) &&
+		ndctl_bus_is_nfit_cmd_supported(bus, NFIT_CMD_ARS_INJECT_GET) &&
+		ndctl_bus_is_nfit_cmd_supported(bus, NFIT_CMD_ARS_INJECT_CLEAR))
+		return 1;
+
+	return 0;
+}
+
+NDCTL_EXPORT void ndctl_namespace_get_injection_bounds(
+		struct ndctl_namespace *ndns, unsigned long long *ns_offset,
+		unsigned long long *ns_size)
+{
+	struct ndctl_pfn *pfn = ndctl_namespace_get_pfn(ndns);
+	struct ndctl_dax *dax = ndctl_namespace_get_dax(ndns);
+
+	if (!ns_offset || !ns_size)
+		return;
+
+	if (pfn) {
+		*ns_offset = ndctl_pfn_get_resource(pfn);
+		*ns_size = ndctl_pfn_get_size(pfn);
+		return;
+	} else if (dax) {
+		*ns_offset = ndctl_dax_get_resource(dax);
+		*ns_size = ndctl_dax_get_size(dax);
+		return;
+	}
+	/* raw or btt */
+	*ns_offset = ndctl_namespace_get_resource(ndns);
+	*ns_size = ndctl_namespace_get_size(ndns);
+}
+
+static int block_to_spa_offset(struct ndctl_namespace *ndns,
+		unsigned long long block, unsigned long long count,
+		u64 *offset, u64 *length)
+{
+	struct ndctl_ctx *ctx = ndctl_namespace_get_ctx(ndns);
+	unsigned long long ns_offset, ns_size;
+
+	ndctl_namespace_get_injection_bounds(ndns, &ns_offset, &ns_size);
+	*offset = ns_offset + block * 512;
+	*length = count * 512;
+
+	/* check bounds */
+	if (*offset + *length > ns_offset + ns_size) {
+		dbg(ctx, "Error: block %#llx, count %#llx are out of bounds\n",
+			block, count);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int translate_status(u32 status)
+{
+	switch (status) {
+	case ND_ARS_ERR_INJ_STATUS_NOT_SUPP:
+		return -EOPNOTSUPP;
+	case ND_ARS_ERR_INJ_STATUS_INVALID_PARAM:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+NDCTL_EXPORT int ndctl_namespace_inject_error(struct ndctl_namespace *ndns,
+		unsigned long long block, unsigned long long count, bool notify)
+{
+	struct ndctl_bus *bus = ndctl_namespace_get_bus(ndns);
+	struct ndctl_ctx *ctx = ndctl_bus_get_ctx(bus);
+	struct nd_cmd_ars_err_inj *err_inj;
+	struct nd_cmd_pkg *pkg;
+	struct ndctl_cmd *cmd;
+	int rc = -EOPNOTSUPP;
+
+	if (!ndctl_bus_has_error_injection(bus))
+		return -EOPNOTSUPP;
+
+	if (ndctl_bus_has_nfit(bus)) {
+		u64 offset, length;
+
+		rc = block_to_spa_offset(ndns, block, count, &offset, &length);
+		if (rc)
+			return rc;
+		cmd = ndctl_bus_cmd_new_err_inj(bus);
+		if (!cmd)
+			return -ENOMEM;
+
+		pkg = (struct nd_cmd_pkg *)&cmd->cmd_buf[0];
+		err_inj = (struct nd_cmd_ars_err_inj *)&pkg->nd_payload[0];
+		err_inj->err_inj_spa_range_base = offset;
+		err_inj->err_inj_spa_range_length = length;
+		if (notify)
+			err_inj->err_inj_options |=
+				(1 << ND_ARS_ERR_INJ_OPT_NOTIFY);
+
+		rc = ndctl_cmd_submit(cmd);
+		if (rc) {
+			dbg(ctx, "Error submitting command: %d\n", rc);
+			goto out;
+		}
+		rc = translate_status(err_inj->status);
+ out:
+		ndctl_cmd_unref(cmd);
+	}
+	return rc;
+}
+
+NDCTL_EXPORT int ndctl_namespace_uninject_error(struct ndctl_namespace *ndns,
+		unsigned long long block, unsigned long long count)
+{
+	struct ndctl_bus *bus = ndctl_namespace_get_bus(ndns);
+	struct ndctl_ctx *ctx = ndctl_bus_get_ctx(bus);
+	struct nd_cmd_ars_err_inj_clr *err_inj_clr;
+	struct nd_cmd_pkg *pkg;
+	struct ndctl_cmd *cmd;
+	int rc = -EOPNOTSUPP;
+
+	if (!ndctl_bus_has_error_injection(bus))
+		return -EOPNOTSUPP;
+
+	if (ndctl_bus_has_nfit(bus)) {
+		u64 offset, length;
+
+		rc = block_to_spa_offset(ndns, block, count, &offset, &length);
+		if (rc)
+			return rc;
+		cmd = ndctl_bus_cmd_new_err_inj_clr(bus);
+		if (!cmd)
+			return -ENOMEM;
+
+		pkg = (struct nd_cmd_pkg *)&cmd->cmd_buf[0];
+		err_inj_clr =
+			(struct nd_cmd_ars_err_inj_clr *)&pkg->nd_payload[0];
+		err_inj_clr->err_inj_clr_spa_range_base = offset;
+		err_inj_clr->err_inj_clr_spa_range_length = length;
+
+		rc = ndctl_cmd_submit(cmd);
+		if (rc) {
+			dbg(ctx, "Error submitting command: %d\n", rc);
+			goto out;
+		}
+		rc = translate_status(err_inj_clr->status);
+ out:
+		ndctl_cmd_unref(cmd);
+	}
+	return rc;
+}
+
+static int bb_add_record(struct list_head *h, u64 block, u64 count)
+{
+	struct ndctl_bb *bb, *bb_iter, *bb_next, *bb_prev;
+	int merged = 0;
+
+	bb = calloc(1, sizeof(*bb));
+	if (bb == NULL)
+		return -ENOMEM;
+	bb->block = block;
+	bb->count = count;
+
+	if (list_empty(h)) {
+		list_add(h, &bb->list);
+		return 0;
+	}
+
+	/* add 'bb' to the list such that it remains sorted */
+	list_for_each(h, bb_iter, list) {
+		/* Find insertion point */
+		bb_prev = list_prev(h, bb_iter, list);
+		bb_next = list_next(h, bb_iter, list);
+
+		if (bb_prev == NULL) {
+			/* bb_iter is the first entry */
+			if (bb->block < bb_iter->block) {
+				list_add(h, &bb->list);
+				break;
+			}
+		}
+		if (bb_next == NULL) {
+			/*
+			 * bb_iter is the last entry. If we've reached here,
+			 * the only option is to add to the tail as the case
+			 * for "tail - 1" should have been covered by the
+			 * following checks for the previous iteration.
+			 */
+			list_add_tail(h, &bb->list);
+			break;
+		}
+		/* Add to the left of bb_iter */
+		if (bb->block <= bb_iter->block) {
+			if (bb_prev && (bb_prev->block <= bb->block)) {
+				list_add_after(h, &bb_prev->list, &bb->list);
+				break;
+			}
+		}
+		/* Add to the right of bb_iter */
+		if (bb_iter->block <= bb->block) {
+			if (bb_next && (bb->block <= bb_next->block)) {
+				list_add_after(h, &bb_iter->list, &bb->list);
+				break;
+			}
+		}
+	}
+
+	/* second pass over the list looking for mergeable entries */
+	list_for_each(h, bb_iter, list) {
+		u64 cur_end, next_end, cur_start, next_start;
+
+		/*
+		 * test for merges in a loop here because one addition can
+		 * potentially have a cascading merge effect on multiple
+		 * remaining entries
+		 */
+		do {
+			/* reset the merged flag */
+			merged = 0;
+
+			bb_next = list_next(h, bb_iter, list);
+			if (bb_next == NULL)
+				break;
+
+			cur_start = bb_iter->block;
+			next_start = bb_next->block;
+			cur_end = bb_iter->block + bb_iter->count - 1;
+			next_end = bb_next->block + bb_next->count - 1;
+
+			if (cur_end >= next_start) {
+				/* overlapping records that can be merged */
+				if (next_end > cur_end) {
+					/* next extends cur */
+					bb_iter->count =
+						next_end - cur_start + 1;
+				} else {
+					/* next is contained in cur */
+					;
+				}
+				/* next is now redundant */
+				list_del_from(h, &bb_next->list);
+				free(bb_next);
+				merged = 1;
+				continue;
+			}
+			if (next_start == cur_end + 1) {
+				/* adjoining records that can be merged */
+				bb_iter->count = next_end - cur_start + 1;
+				list_del_from(h, &bb_next->list);
+				free(bb_next);
+				merged = 1;
+				continue;
+			}
+		} while (merged);
+	}
+
+	return 0;
+}
+
+static int injection_status_to_bb(struct ndctl_namespace *ndns,
+		struct nd_cmd_ars_err_inj_stat *stat, u64 ns_spa, u64 ns_size)
+{
+	unsigned int i;
+	int rc = 0;
+
+	for (i = 0; i < stat->inj_err_rec_count; i++) {
+		u64 ns_off, rec_off, rec_len;
+		u64 block, count, start_pad;
+
+		rec_off = stat->record[i].err_inj_stat_spa_range_base;
+		rec_len = stat->record[i].err_inj_stat_spa_range_length;
+		/* discard ranges outside the provided namespace */
+		if (rec_off < ns_spa)
+			continue;
+		if (rec_off >= ns_spa + ns_size)
+			continue;
+
+		/* translate spa offset to namespace offset */
+		ns_off = rec_off - ns_spa;
+
+		block = ALIGN_DOWN(ns_off, 512)/512;
+		start_pad = ns_off - (block * 512);
+		count = ALIGN(start_pad + rec_len, 512)/512;
+		rc = bb_add_record(&ndns->injected_bb, block, count);
+		if (rc)
+			break;
+	}
+	return rc;
+}
+
+NDCTL_EXPORT int ndctl_namespace_injection_status(struct ndctl_namespace *ndns)
+{
+	struct ndctl_bus *bus = ndctl_namespace_get_bus(ndns);
+	struct ndctl_ctx *ctx = ndctl_bus_get_ctx(bus);
+	struct nd_cmd_ars_err_inj_stat *err_inj_stat;
+	unsigned long long ns_offset, ns_size;
+	int rc = -EOPNOTSUPP, buf_size;
+	struct ndctl_cmd *cmd = NULL;
+	struct nd_cmd_pkg *pkg;
+
+	if (!ndctl_bus_has_error_injection(bus))
+		return -EOPNOTSUPP;
+
+	if (ndctl_bus_has_nfit(bus)) {
+		ndctl_namespace_get_injection_bounds(ndns, &ns_offset,
+			&ns_size);
+
+		cmd = ndctl_bus_cmd_new_ars_cap(bus, ns_offset, ns_size);
+		rc = ndctl_cmd_submit(cmd);
+		if (rc) {
+			dbg(ctx, "Error submitting ars_cap: %d\n", rc);
+			goto out;
+		}
+		buf_size = ndctl_cmd_ars_cap_get_size(cmd);
+		if (buf_size == 0) {
+			dbg(ctx, "Got an invalid max_ars_out from ars_cap\n");
+			rc = -EINVAL;
+			goto out;
+		}
+		ndctl_cmd_unref(cmd);
+
+		cmd = ndctl_bus_cmd_new_err_inj_stat(bus, buf_size);
+		if (!cmd)
+			return -ENOMEM;
+
+		pkg = (struct nd_cmd_pkg *)&cmd->cmd_buf[0];
+		err_inj_stat =
+			(struct nd_cmd_ars_err_inj_stat *)&pkg->nd_payload[0];
+
+		rc = ndctl_cmd_submit(cmd);
+		if (rc) {
+			dbg(ctx, "Error submitting command: %d\n", rc);
+			goto out;
+		}
+		rc = injection_status_to_bb(ndns, err_inj_stat,
+			ns_offset, ns_size);
+	}
+
+ out:
+	ndctl_cmd_unref(cmd);
+	return rc;
+}
+
+NDCTL_EXPORT struct ndctl_bb *ndctl_namespace_injection_get_first_bb(
+		struct ndctl_namespace *ndns)
+{
+	return list_top(&ndns->injected_bb, struct ndctl_bb, list);
+}
+
+NDCTL_EXPORT struct ndctl_bb *ndctl_namespace_injection_get_next_bb(
+		struct ndctl_namespace *ndns, struct ndctl_bb *bb)
+{
+	return list_next(&ndns->injected_bb, bb, list);
+}
+
+NDCTL_EXPORT unsigned long long ndctl_bb_get_block(struct ndctl_bb *bb)
+{
+	if (bb)
+		return bb->block;
+	return ULLONG_MAX;
+}
+
+NDCTL_EXPORT unsigned long long ndctl_bb_get_count(struct ndctl_bb *bb)
+{
+	if (bb)
+		return bb->count;
+	return ULLONG_MAX;
+}
diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index c878383..511e965 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -157,48 +157,6 @@ struct ndctl_region {
 };
 
 /**
- * struct ndctl_lbasize - lbasize info for btt and blk-namespace devices
- * @select: currently selected sector_size
- * @supported: possible sector_size options
- * @num: number of entries in @supported
- */
-struct ndctl_lbasize {
-	int select;
-	unsigned int *supported;
-	int num;
-};
-
-/**
- * struct ndctl_namespace - device claimed by the nd_blk or nd_pmem driver
- * @module: kernel module
- * @type: integer nd-bus device-type
- * @type_name: 'namespace_io', 'namespace_pmem', or 'namespace_block'
- * @namespace_path: devpath for namespace device
- * @bdev: associated block_device of a namespace
- * @size: unsigned
- * @numa_node: numa node attribute
- *
- * A 'namespace' is the resulting device after region-aliasing and
- * label-parsing is resolved.
- */
-struct ndctl_namespace {
-	struct kmod_module *module;
-	struct ndctl_region *region;
-	struct list_node list;
-	char *ndns_path;
-	char *ndns_buf;
-	char *bdev;
-	int type, id, buf_len, raw_mode;
-	int generation;
-	unsigned long long resource, size;
-	enum ndctl_namespace_mode enforce_mode;
-	char *alt_name;
-	uuid_t uuid;
-	struct ndctl_lbasize lbasize;
-	int numa_node;
-};
-
-/**
  * struct ndctl_btt - stacked block device provided sector atomicity
  * @module: kernel module (nd_btt)
  * @lbasize: sector size info
@@ -391,8 +349,12 @@ NDCTL_EXPORT struct ndctl_ctx *ndctl_ref(struct ndctl_ctx *ctx)
 
 static void free_namespace(struct ndctl_namespace *ndns, struct list_head *head)
 {
+	struct ndctl_bb *bb, *next;
+
 	if (head)
 		list_del_from(head, &ndns->list);
+	list_for_each_safe(&ndns->injected_bb, bb, next, list)
+		free(bb);
 	free(ndns->lbasize.supported);
 	free(ndns->ndns_path);
 	free(ndns->ndns_buf);
@@ -2955,6 +2917,7 @@ static void *add_namespace(void *parent, int id, const char *ndns_base)
 	ndns->id = id;
 	ndns->region = region;
 	ndns->generation = region->generation;
+	list_head_init(&ndns->injected_bb);
 
 	sprintf(path, "%s/nstype", ndns_base);
 	if (sysfs_read_attr(ctx, path, buf) < 0)
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 4c22c0f..eeed947 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -288,6 +288,7 @@ global:
 	ndctl_bus_is_nfit_cmd_supported;
 	ndctl_bus_wait_for_scrub_completion;
 	ndctl_bus_get_scrub_count;
+	ndctl_bus_has_error_injection;
 	ndctl_dimm_read_labels;
 	ndctl_dimm_validate_labels;
 	ndctl_dimm_init_labels;
@@ -295,4 +296,12 @@ global:
 	ndctl_mapping_get_position;
 	ndctl_namespace_set_enforce_mode;
 	ndctl_namespace_get_enforce_mode;
+	ndctl_namespace_get_injection_bounds;
+	ndctl_namespace_inject_error;
+	ndctl_namespace_uninject_error;
+	ndctl_namespace_injection_status;
+	ndctl_namespace_injection_get_first_bb;
+	ndctl_namespace_injection_get_next_bb;
+	ndctl_bb_get_block;
+	ndctl_bb_get_count;
 } LIBNDCTL_3;
diff --git a/ndctl/lib/nfit.c b/ndctl/lib/nfit.c
index f3806a4..fb6af32 100644
--- a/ndctl/lib/nfit.c
+++ b/ndctl/lib/nfit.c
@@ -143,3 +143,92 @@ int ndctl_bus_nfit_translate_spa(struct ndctl_bus *bus,
 
 	return rc;
 }
+
+struct ndctl_cmd *ndctl_bus_cmd_new_err_inj(struct ndctl_bus *bus)
+{
+	struct nd_cmd_ars_err_inj *err_inj;
+	size_t size, cmd_length;
+	struct nd_cmd_pkg *pkg;
+	struct ndctl_cmd *cmd;
+
+	cmd_length = sizeof(struct nd_cmd_ars_err_inj);
+	size = sizeof(*cmd) + sizeof(*pkg) + cmd_length;
+	cmd = calloc(1, size);
+	if (!cmd)
+		return NULL;
+
+	cmd->bus = bus;
+	ndctl_cmd_ref(cmd);
+	cmd->type = ND_CMD_CALL;
+	cmd->size = size;
+	cmd->status = 1;
+	pkg = (struct nd_cmd_pkg *)&cmd->cmd_buf[0];
+	pkg->nd_command = NFIT_CMD_ARS_INJECT_SET;
+	pkg->nd_size_in = (2 * sizeof(u64)) + sizeof(u32);
+	pkg->nd_size_out = cmd_length;
+	pkg->nd_fw_size = cmd_length;
+	err_inj = (struct nd_cmd_ars_err_inj *)&pkg->nd_payload[0];
+	cmd->firmware_status = &err_inj->status;
+
+	return cmd;
+}
+
+struct ndctl_cmd *ndctl_bus_cmd_new_err_inj_clr(struct ndctl_bus *bus)
+{
+	struct nd_cmd_ars_err_inj_clr *err_inj_clr;
+	size_t size, cmd_length;
+	struct nd_cmd_pkg *pkg;
+	struct ndctl_cmd *cmd;
+
+	cmd_length = sizeof(struct nd_cmd_ars_err_inj_clr);
+	size = sizeof(*cmd) + sizeof(*pkg) + cmd_length;
+	cmd = calloc(1, size);
+	if (!cmd)
+		return NULL;
+
+	cmd->bus = bus;
+	ndctl_cmd_ref(cmd);
+	cmd->type = ND_CMD_CALL;
+	cmd->size = size;
+	cmd->status = 1;
+	pkg = (struct nd_cmd_pkg *)&cmd->cmd_buf[0];
+	pkg->nd_command = NFIT_CMD_ARS_INJECT_CLEAR;
+	pkg->nd_size_in = 2 * sizeof(u64);
+	pkg->nd_size_out = cmd_length;
+	pkg->nd_fw_size = cmd_length;
+	err_inj_clr = (struct nd_cmd_ars_err_inj_clr *)&pkg->nd_payload[0];
+	cmd->firmware_status = &err_inj_clr->status;
+
+	return cmd;
+}
+
+struct ndctl_cmd *ndctl_bus_cmd_new_err_inj_stat(struct ndctl_bus *bus,
+	u32 buf_size)
+{
+	struct nd_cmd_ars_err_inj_stat *err_inj_stat;
+	size_t size, cmd_length;
+	struct nd_cmd_pkg *pkg;
+	struct ndctl_cmd *cmd;
+
+
+	cmd_length = sizeof(struct nd_cmd_ars_err_inj_stat);
+	size = sizeof(*cmd) + sizeof(*pkg) + cmd_length + buf_size;
+	cmd = calloc(1, size);
+	if (!cmd)
+		return NULL;
+
+	cmd->bus = bus;
+	ndctl_cmd_ref(cmd);
+	cmd->type = ND_CMD_CALL;
+	cmd->size = size;
+	cmd->status = 1;
+	pkg = (struct nd_cmd_pkg *)&cmd->cmd_buf[0];
+	pkg->nd_command = NFIT_CMD_ARS_INJECT_GET;
+	pkg->nd_size_in = cmd_length;
+	pkg->nd_size_out = cmd_length + buf_size;
+	pkg->nd_fw_size = cmd_length + buf_size;
+	err_inj_stat = (struct nd_cmd_ars_err_inj_stat *)&pkg->nd_payload[0];
+	cmd->firmware_status = &err_inj_stat->status;
+
+	return cmd;
+}
diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
index 6b909aa..29505fd 100644
--- a/ndctl/lib/private.h
+++ b/ndctl/lib/private.h
@@ -158,6 +158,49 @@ struct ndctl_bus {
 };
 
 /**
+ * struct ndctl_lbasize - lbasize info for btt and blk-namespace devices
+ * @select: currently selected sector_size
+ * @supported: possible sector_size options
+ * @num: number of entries in @supported
+ */
+struct ndctl_lbasize {
+	int select;
+	unsigned int *supported;
+	int num;
+};
+
+/**
+ * struct ndctl_namespace - device claimed by the nd_blk or nd_pmem driver
+ * @module: kernel module
+ * @type: integer nd-bus device-type
+ * @type_name: 'namespace_io', 'namespace_pmem', or 'namespace_block'
+ * @namespace_path: devpath for namespace device
+ * @bdev: associated block_device of a namespace
+ * @size: unsigned
+ * @numa_node: numa node attribute
+ *
+ * A 'namespace' is the resulting device after region-aliasing and
+ * label-parsing is resolved.
+ */
+struct ndctl_namespace {
+	struct kmod_module *module;
+	struct ndctl_region *region;
+	struct list_node list;
+	char *ndns_path;
+	char *ndns_buf;
+	char *bdev;
+	int type, id, buf_len, raw_mode;
+	int generation;
+	unsigned long long resource, size;
+	enum ndctl_namespace_mode enforce_mode;
+	char *alt_name;
+	uuid_t uuid;
+	struct ndctl_lbasize lbasize;
+	int numa_node;
+	struct list_head injected_bb;
+};
+
+/**
  * struct ndctl_cmd - device-specific-method (_DSM ioctl) container
  * @dimm: set if the command is relative to a dimm, NULL otherwise
  * @bus: set if the command is relative to a bus (like ARS), NULL otherwise
@@ -217,6 +260,12 @@ struct ndctl_cmd {
 	};
 };
 
+struct ndctl_bb {
+	u64 block;
+	u64 count;
+	struct list_node list;
+};
+
 struct ndctl_smart_ops {
 	struct ndctl_cmd *(*new_smart)(struct ndctl_dimm *);
 	unsigned int (*smart_get_flags)(struct ndctl_cmd *);
@@ -280,5 +329,9 @@ static inline int check_kmod(struct kmod_ctx *kmod_ctx)
 
 int ndctl_bus_nfit_translate_spa(struct ndctl_bus *bus, unsigned long long addr,
 		unsigned int *handle, unsigned long long *dpa);
+struct ndctl_cmd *ndctl_bus_cmd_new_err_inj(struct ndctl_bus *bus);
+struct ndctl_cmd *ndctl_bus_cmd_new_err_inj_clr(struct ndctl_bus *bus);
+struct ndctl_cmd *ndctl_bus_cmd_new_err_inj_stat(struct ndctl_bus *bus,
+	u32 buf_size);
 
 #endif /* _LIBNDCTL_PRIVATE_H_ */
diff --git a/ndctl/libndctl-nfit.h b/ndctl/libndctl-nfit.h
index ae9e5ce..6b730aa 100644
--- a/ndctl/libndctl-nfit.h
+++ b/ndctl/libndctl-nfit.h
@@ -16,6 +16,8 @@
 #ifndef __LIBNDCTL_NFIT_H__
 #define __LIBNDCTL_NFIT_H__
 
+#include <linux/types.h>
+
 /*
  * libndctl-nfit.h : definitions for NFIT related commands/functions.
  */
diff --git a/ndctl/libndctl.h.in b/ndctl/libndctl.h.in
index a4fbe33..5ecd07b 100644
--- a/ndctl/libndctl.h.in
+++ b/ndctl/libndctl.h.in
@@ -115,6 +115,7 @@ const char *ndctl_bus_get_provider(struct ndctl_bus *bus);
 int ndctl_bus_wait_probe(struct ndctl_bus *bus);
 int ndctl_bus_wait_for_scrub_completion(struct ndctl_bus *bus);
 unsigned int ndctl_bus_get_scrub_count(struct ndctl_bus *bus);
+int ndctl_bus_has_error_injection(struct ndctl_bus *bus);
 
 struct ndctl_dimm;
 struct ndctl_dimm *ndctl_dimm_get_first(struct ndctl_bus *bus);
@@ -541,6 +542,28 @@ int ndctl_namespace_set_sector_size(struct ndctl_namespace *ndns,
 int ndctl_namespace_get_raw_mode(struct ndctl_namespace *ndns);
 int ndctl_namespace_set_raw_mode(struct ndctl_namespace *ndns, int raw_mode);
 int ndctl_namespace_get_numa_node(struct ndctl_namespace *ndns);
+void ndctl_namespace_get_injection_bounds(
+		struct ndctl_namespace *ndns, unsigned long long *ns_offset,
+		unsigned long long *ns_size);
+int ndctl_namespace_inject_error(struct ndctl_namespace *ndns,
+		unsigned long long block, unsigned long long count,
+		bool notify);
+int ndctl_namespace_uninject_error(struct ndctl_namespace *ndns,
+		unsigned long long block, unsigned long long count);
+int ndctl_namespace_injection_status(struct ndctl_namespace *ndns);
+
+struct ndctl_bb;
+unsigned long long ndctl_bb_get_block(struct ndctl_bb *bb);
+unsigned long long ndctl_bb_get_count(struct ndctl_bb *bb);
+struct ndctl_bb *ndctl_namespace_injection_get_first_bb(
+		struct ndctl_namespace *ndns);
+struct ndctl_bb *ndctl_namespace_injection_get_next_bb(
+		struct ndctl_namespace *ndns, struct ndctl_bb *bb);
+#define ndctl_namespace_bb_foreach(ndns, bb) \
+        for (bb = ndctl_namespace_injection_get_first_bb(ndns); \
+             bb != NULL; \
+             bb = ndctl_namespace_injection_get_next_bb(ndns, bb))
+
 struct ndctl_btt;
 struct ndctl_btt *ndctl_btt_get_first(struct ndctl_region *region);
 struct ndctl_btt *ndctl_btt_get_next(struct ndctl_btt *btt);
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
