Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id 08D9F1A1F6E
 for <linux-nvdimm@lists.01.org>; Thu, 10 Mar 2016 16:46:08 -0800 (PST)
Subject: [ndctl PATCH 3/3] ndctl: add 'clear error' command support
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 10 Mar 2016 16:45:26 -0800
Message-ID: <20160311004526.27582.46416.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20160311004511.27582.63304.stgit@dwillia2-desk3.jf.intel.com>
References: <20160311004511.27582.63304.stgit@dwillia2-desk3.jf.intel.com>
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

Import the clear error command definition from the latest kernel, wire
it up with a new ndctl_bus_cmd_new_clear_error() api, and add an
invocation to the unit test.

Since, the unit test requires the ability to recall the range of an
ars_cap command a new ndctl_cmd_ars_cap_get_range() api is added.

Reported-by: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 configure.ac           |   19 +++++++
 lib/libndctl-ars.c     |  125 +++++++++++++++++++++++++++++++++++++++++++-----
 lib/libndctl-private.h |    5 ++
 lib/libndctl.c         |    3 +
 lib/libndctl.sym       |    3 +
 lib/ndctl/libndctl.h   |   41 +++++++++++++++-
 ndctl.h                |   13 +++++
 test/libndctl.c        |   62 +++++++++++++++++++++++-
 8 files changed, 253 insertions(+), 18 deletions(-)

diff --git a/configure.ac b/configure.ac
index 96a02d9f9972..7e006641b197 100644
--- a/configure.ac
+++ b/configure.ac
@@ -125,6 +125,25 @@ AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[
 )
 AM_CONDITIONAL([ENABLE_ARS], [test "x$enable_ars" = "xyes"])
 
+AC_MSG_CHECKING([for CLEAR ERR support])
+AC_LANG(C)
+AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[
+			#ifdef HAVE_NDCTL_H
+			#include <linux/ndctl.h>
+			#else
+			#include "ndctl.h"
+			#endif
+			]], [[
+			int x = ND_CMD_CLEAR_ERROR;
+			]]
+		)], [AC_MSG_RESULT([yes])
+		     enable_clear_err=yes
+		     AC_DEFINE([HAVE_NDCTL_CLEAR_ERROR], [1],
+				[Define to 1 if ndctl.h has CLEAR ERR support.])
+		], [AC_MSG_RESULT([no])]
+)
+AM_CONDITIONAL([ENABLE_CLEAR_ERROR], [test "x$enable_clear_err" = "xyes"])
+
 AC_CHECK_HEADERS_ONCE([linux/version.h])
 
 AC_CHECK_FUNCS([ \
diff --git a/lib/libndctl-ars.c b/lib/libndctl-ars.c
index 63d0e5544a36..b53fe4c1dd8f 100644
--- a/lib/libndctl-ars.c
+++ b/lib/libndctl-ars.c
@@ -43,6 +43,30 @@ NDCTL_EXPORT struct ndctl_cmd *ndctl_bus_cmd_new_ars_cap(struct ndctl_bus *bus,
 	return cmd;
 }
 
+static bool is_power_of_2(unsigned int v)
+{
+	return v && ((v & (v - 1)) == 0);
+}
+
+static bool __validate_ars_cap(struct ndctl_cmd *ars_cap)
+{
+	if (ars_cap->type != ND_CMD_ARS_CAP || ars_cap->status != 0)
+		return false;
+	if ((*ars_cap->firmware_status & ARS_STATUS_MASK) != 0)
+		return false;
+	if (!is_power_of_2(ars_cap->ars_cap->clear_err_unit))
+		return false;
+	return true;
+}
+
+#define validate_ars_cap(ctx, ars_cap) \
+({ \
+	bool __valid = __validate_ars_cap(ars_cap); \
+	if (!__valid) \
+		dbg(ctx, "expected sucessfully completed ars_cap command\n"); \
+	__valid; \
+})
+
 NDCTL_EXPORT struct ndctl_cmd *ndctl_bus_cmd_new_ars_start(struct ndctl_cmd *ars_cap,
 		int type)
 {
@@ -55,14 +79,10 @@ NDCTL_EXPORT struct ndctl_cmd *ndctl_bus_cmd_new_ars_start(struct ndctl_cmd *ars
 		dbg(ctx, "unsupported cmd\n");
 		return NULL;
 	}
-	if (ars_cap->type != ND_CMD_ARS_CAP || ars_cap->status != 0) {
-		dbg(ctx, "expected sucessfully completed ars_cap command\n");
-		return NULL;
-	}
-	if ((*ars_cap->firmware_status & ARS_STATUS_MASK) != 0) {
-		dbg(ctx, "expected sucessfully completed ars_cap command\n");
+
+	if (!validate_ars_cap(ctx, ars_cap))
 		return NULL;
-	}
+
 	if (!(*ars_cap->firmware_status >> ARS_EXT_STATUS_SHIFT & type)) {
 		dbg(ctx, "ars_cap does not show requested type as supported\n");
 		return NULL;
@@ -98,14 +118,10 @@ NDCTL_EXPORT struct ndctl_cmd *ndctl_bus_cmd_new_ars_status(struct ndctl_cmd *ar
 		dbg(ctx, "unsupported cmd\n");
 		return NULL;
 	}
-	if (ars_cap->type != ND_CMD_ARS_CAP || ars_cap->status != 0) {
-		dbg(ctx, "expected sucessfully completed ars_cap command\n");
-		return NULL;
-	}
-	if ((*ars_cap->firmware_status & ARS_STATUS_MASK) != 0) {
-		dbg(ctx, "expected sucessfully completed ars_cap command\n");
+
+	if (!validate_ars_cap(ctx, ars_cap))
 		return NULL;
-	}
+
 	if (ars_cap_cmd->max_ars_out == 0) {
 		dbg(ctx, "invalid ars_cap\n");
 		return NULL;
@@ -141,6 +157,24 @@ NDCTL_EXPORT unsigned int ndctl_cmd_ars_cap_get_size(struct ndctl_cmd *ars_cap)
 	return 0;
 }
 
+NDCTL_EXPORT int ndctl_cmd_ars_cap_get_range(struct ndctl_cmd *ars_cap,
+	struct ndctl_range *range)
+{
+	struct ndctl_ctx *ctx = ndctl_bus_get_ctx(cmd_to_bus(ars_cap));
+
+	if (range && ars_cap->type == ND_CMD_ARS_CAP && ars_cap->status == 0) {
+		struct nd_cmd_ars_cap *cap = ars_cap->ars_cap;
+
+		dbg(ctx, "range: %llx - %llx\n", cap->address, cap->length);
+		range->address = cap->address;
+		range->length = cap->length;
+		return 0;
+	}
+
+	dbg(ctx, "invalid ars_cap\n");
+	return -EINVAL;
+}
+
 NDCTL_EXPORT int ndctl_cmd_ars_in_progress(struct ndctl_cmd *cmd)
 {
 	struct ndctl_ctx *ctx = ndctl_bus_get_ctx(cmd_to_bus(cmd));
@@ -206,3 +240,66 @@ NDCTL_EXPORT unsigned long long ndctl_cmd_ars_get_record_len(
 	dbg(ctx, "invalid ars_status\n");
 	return 0;
 }
+
+#ifdef HAVE_NDCTL_CLEAR_ERROR
+NDCTL_EXPORT struct ndctl_cmd *ndctl_bus_cmd_new_clear_error(
+		unsigned long long address, unsigned long long len,
+		struct ndctl_cmd *ars_cap)
+{
+	size_t size;
+	unsigned int mask;
+	struct nd_cmd_ars_cap *cap;
+	struct ndctl_cmd *clear_err;
+	struct ndctl_bus *bus = ars_cap->bus;
+	struct ndctl_ctx *ctx = ndctl_bus_get_ctx(bus);
+
+	if (!ndctl_bus_is_cmd_supported(bus, ND_CMD_ARS_STATUS)) {
+		dbg(ctx, "unsupported cmd\n");
+		return NULL;
+	}
+
+	if (!validate_ars_cap(ctx, ars_cap))
+		return NULL;
+
+	cap = ars_cap->ars_cap;
+	if (address < cap->address || address > (cap->address + cap->length)
+			|| address + len > (cap->address + cap->length)) {
+		dbg(ctx, "request out of range (relative to ars_cap)\n");
+		return NULL;
+	}
+
+	mask = cap->clear_err_unit - 1;
+	if ((address | len) & mask) {
+		dbg(ctx, "request unaligned\n");
+		return NULL;
+	}
+
+	size = sizeof(*clear_err) + sizeof(struct nd_cmd_clear_error);
+	clear_err = calloc(1, size);
+	if (!clear_err)
+		return NULL;
+
+	ndctl_cmd_ref(clear_err);
+	clear_err->bus = bus;
+	clear_err->type = ND_CMD_CLEAR_ERROR;
+	clear_err->size = size;
+	clear_err->status = 1;
+	clear_err->firmware_status = &clear_err->clear_err->status;
+	clear_err->clear_err->address = address;
+	clear_err->clear_err->length = len;
+
+	return clear_err;
+}
+
+NDCTL_EXPORT unsigned long long ndctl_cmd_clear_error_get_cleared(
+		struct ndctl_cmd *clear_err)
+{
+	struct ndctl_ctx *ctx = ndctl_bus_get_ctx(cmd_to_bus(clear_err));
+
+	if (clear_err->type == ND_CMD_CLEAR_ERROR && clear_err->status == 0)
+		return clear_err->clear_err->cleared;
+
+	dbg(ctx, "invalid clear_err\n");
+	return 0;
+}
+#endif
diff --git a/lib/libndctl-private.h b/lib/libndctl-private.h
index 8111a555b957..50b03743751f 100644
--- a/lib/libndctl-private.h
+++ b/lib/libndctl-private.h
@@ -159,9 +159,14 @@ struct ndctl_cmd {
 	} iter;
 	struct ndctl_cmd *source;
 	union {
+#ifdef HAVE_NDCTL_ARS
 		struct nd_cmd_ars_cap ars_cap[0];
 		struct nd_cmd_ars_start ars_start[0];
 		struct nd_cmd_ars_status ars_status[0];
+#endif
+#ifdef HAVE_NDCTL_CLEAR_ERROR
+		struct nd_cmd_clear_error clear_err[0];
+#endif
 		struct nd_cmd_get_config_size get_size[0];
 		struct nd_cmd_get_config_data_hdr get_data[0];
 		struct nd_cmd_set_config_hdr set_data[0];
diff --git a/lib/libndctl.c b/lib/libndctl.c
index dde3ef5b72e4..6728508024b0 100644
--- a/lib/libndctl.c
+++ b/lib/libndctl.c
@@ -809,7 +809,7 @@ static int to_dsm_index(const char *name, int dimm)
 		end_cmd = ND_CMD_VENDOR;
 		cmd_name_fn = nvdimm_cmd_name;
 	} else {
-		end_cmd = ND_CMD_ARS_STATUS;
+		end_cmd = ND_CMD_CLEAR_ERROR;
 		cmd_name_fn = nvdimm_bus_cmd_name;
 	}
 
@@ -2103,6 +2103,7 @@ static int to_ioctl_cmd(int cmd, int dimm)
 		case ND_CMD_ARS_CAP:         return ND_IOCTL_ARS_CAP;
 		case ND_CMD_ARS_START:       return ND_IOCTL_ARS_START;
 		case ND_CMD_ARS_STATUS:      return ND_IOCTL_ARS_STATUS;
+		case ND_CMD_CLEAR_ERROR:     return ND_IOCTL_CLEAR_ERROR;
 		default:
 						       return 0;
 		};
diff --git a/lib/libndctl.sym b/lib/libndctl.sym
index 6c74e73189f6..25d7b982ecb1 100644
--- a/lib/libndctl.sym
+++ b/lib/libndctl.sym
@@ -69,10 +69,13 @@ global:
 	ndctl_bus_cmd_new_ars_start;
 	ndctl_bus_cmd_new_ars_status;
 	ndctl_cmd_ars_cap_get_size;
+	ndctl_cmd_ars_cap_get_range;
 	ndctl_cmd_ars_in_progress;
 	ndctl_cmd_ars_num_records;
 	ndctl_cmd_ars_get_record_addr;
 	ndctl_cmd_ars_get_record_len;
+	ndctl_bus_cmd_new_clear_error;
+	ndctl_cmd_clear_error_get_cleared;
 	ndctl_dimm_cmd_new_vendor_specific;
 	ndctl_cmd_vendor_set_input;
 	ndctl_cmd_vendor_get_output_size;
diff --git a/lib/ndctl/libndctl.h b/lib/ndctl/libndctl.h
index dbe98b0f159b..456288f66aee 100644
--- a/lib/ndctl/libndctl.h
+++ b/lib/ndctl/libndctl.h
@@ -153,7 +153,13 @@ struct ndctl_cmd *ndctl_bus_cmd_new_ars_cap(struct ndctl_bus *bus,
 		unsigned long long address, unsigned long long len);
 struct ndctl_cmd *ndctl_bus_cmd_new_ars_start(struct ndctl_cmd *ars_cap, int type);
 struct ndctl_cmd *ndctl_bus_cmd_new_ars_status(struct ndctl_cmd *ars_cap);
+struct ndctl_range {
+	unsigned long long address;
+	unsigned long long length;
+};
 unsigned int ndctl_cmd_ars_cap_get_size(struct ndctl_cmd *ars_cap);
+int ndctl_cmd_ars_cap_get_range(struct ndctl_cmd *ars_cap,
+		struct ndctl_range *range);
 int ndctl_cmd_ars_in_progress(struct ndctl_cmd *ars_status);
 unsigned int ndctl_cmd_ars_num_records(struct ndctl_cmd *ars_stat);
 unsigned long long ndctl_cmd_ars_get_record_addr(struct ndctl_cmd *ars_stat,
@@ -161,7 +167,18 @@ unsigned long long ndctl_cmd_ars_get_record_addr(struct ndctl_cmd *ars_stat,
 unsigned long long ndctl_cmd_ars_get_record_len(struct ndctl_cmd *ars_stat,
 		unsigned int rec_index);
 
-#else
+#ifdef HAVE_NDCTL_CLEAR_ERROR
+/*
+ * clear_error requires ars_cap, so we require HAVE_NDCTL_ARS to export the
+ * clear_error capability
+ */
+struct ndctl_cmd *ndctl_bus_cmd_new_clear_error(unsigned long long address,
+		unsigned long long len, struct ndctl_cmd *ars_cap);
+unsigned long long ndctl_cmd_clear_error_get_cleared(
+		struct ndctl_cmd *clear_err);
+#define HAS_CLEAR_ERROR 1
+#endif
+#else /* HAVE_NDCTL_ARS */
 static inline struct ndctl_cmd *ndctl_bus_cmd_new_ars_cap(struct ndctl_bus *bus,
 		unsigned long long address, unsigned long long len)
 {
@@ -185,6 +202,13 @@ static inline unsigned int ndctl_cmd_ars_cap_get_size(struct ndctl_cmd *ars_cap)
 	return 0;
 }
 
+
+static inline int ndctl_cmd_ars_cap_get_range(struct ndctl_cmd *ars_cap,
+		struct ndctl_range *range)
+{
+	return -ENXIO;
+}
+
 static inline unsigned int ndctl_cmd_ars_in_progress(struct ndctl_cmd *ars_status)
 {
 	return 0;
@@ -206,6 +230,21 @@ static inline unsigned long long ndctl_cmd_ars_get_record_len(
 {
 	return 0;
 }
+#endif /* HAVE_NDCTL_ARS */
+
+#ifndef HAS_CLEAR_ERROR
+static inline struct ndctl_cmd *ndctl_bus_cmd_new_clear_error(
+		unsigned long long address, unsigned long long len,
+		struct ndctl_cmd *ars_cap)
+{
+	return NULL;
+}
+
+static inline unsigned long long ndctl_cmd_clear_error_get_cleared(
+		struct ndctl_cmd *clear_err)
+{
+	return 0;
+}
 #endif
 
 struct ndctl_cmd *ndctl_dimm_cmd_new_vendor_specific(struct ndctl_dimm *dimm,
diff --git a/ndctl.h b/ndctl.h
index 0c50ff4dc3b1..11c4adf7f49c 100644
--- a/ndctl.h
+++ b/ndctl.h
@@ -98,6 +98,14 @@ struct nd_cmd_ars_status {
 	} __attribute__((packed)) records[0];
 } __attribute__((packed));
 
+struct nd_cmd_clear_error {
+	__u64 address;
+	__u64 length;
+	__u32 status;
+	__u8 reserved[4];
+	__u64 cleared;
+} __attribute__((packed));
+
 enum {
 	ND_CMD_IMPLEMENTED = 0,
 
@@ -105,6 +113,7 @@ enum {
 	ND_CMD_ARS_CAP = 1,
 	ND_CMD_ARS_START = 2,
 	ND_CMD_ARS_STATUS = 3,
+	ND_CMD_CLEAR_ERROR = 4,
 
 	/* per-dimm commands */
 	ND_CMD_SMART = 1,
@@ -129,6 +138,7 @@ static __inline__ const char *nvdimm_bus_cmd_name(unsigned cmd)
 		[ND_CMD_ARS_CAP] = "ars_cap",
 		[ND_CMD_ARS_START] = "ars_start",
 		[ND_CMD_ARS_STATUS] = "ars_status",
+		[ND_CMD_CLEAR_ERROR] = "clear_error",
 	};
 
 	if (cmd < ARRAY_SIZE(names) && names[cmd])
@@ -187,6 +197,9 @@ static __inline__ const char *nvdimm_cmd_name(unsigned cmd)
 #define ND_IOCTL_ARS_STATUS		_IOWR(ND_IOCTL, ND_CMD_ARS_STATUS,\
 					struct nd_cmd_ars_status)
 
+#define ND_IOCTL_CLEAR_ERROR		_IOWR(ND_IOCTL, ND_CMD_CLEAR_ERROR,\
+					struct nd_cmd_ars_status)
+
 #define ND_DEVICE_DIMM 1            /* nd_dimm: container for "config data" */
 #define ND_DEVICE_REGION_PMEM 2     /* nd_region: (parent of PMEM namespaces) */
 #define ND_DEVICE_REGION_BLK 3      /* nd_region: (parent of BLK namespaces) */
diff --git a/test/libndctl.c b/test/libndctl.c
index ca1d7515d406..2dd1eb6fcb0a 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -379,7 +379,8 @@ static unsigned long dimm_commands0 = 1UL << ND_CMD_GET_CONFIG_SIZE
 
 static unsigned long bus_commands0 = 1UL << ND_CMD_ARS_CAP
 		| 1UL << ND_CMD_ARS_START
-		| 1UL << ND_CMD_ARS_STATUS;
+		| 1UL << ND_CMD_ARS_STATUS
+		| 1UL << ND_CMD_CLEAR_ERROR;
 
 static struct ndctl_dimm *get_dimm_by_handle(struct ndctl_bus *bus, unsigned int handle)
 {
@@ -1596,7 +1597,7 @@ static int check_ars_cap(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 		return -ENXIO;
 	}
 
-	cmd = ndctl_bus_cmd_new_ars_cap(bus, 0, 64);
+	cmd = ndctl_bus_cmd_new_ars_cap(bus, 0, SZ_4K);
 	if (!cmd) {
 		fprintf(stderr, "%s: bus: %s failed to create cmd\n",
 				__func__, ndctl_bus_get_provider(bus));
@@ -1709,6 +1710,55 @@ static int check_ars_status(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 	check->cmd = cmd;
 	return 0;
 }
+
+static int check_clear_error(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
+		struct check_cmd *check)
+{
+	struct ndctl_cmd *ars_cap = check_cmds[ND_CMD_ARS_CAP].cmd;
+	struct ndctl_cmd *clear_err;
+	unsigned long long cleared;
+	struct ndctl_range range;
+	int rc;
+
+	if (check->cmd != NULL) {
+		fprintf(stderr, "%s: expected a NULL command, by default\n",
+				__func__);
+		return -ENXIO;
+	}
+
+	if (ndctl_cmd_ars_cap_get_range(ars_cap, &range)) {
+		fprintf(stderr, "failed to get ars_cap range\n");
+		return -ENXIO;
+	}
+
+	clear_err = ndctl_bus_cmd_new_clear_error(range.address, SZ_4K,
+			ars_cap);
+	if (!clear_err) {
+		fprintf(stderr, "%s: bus: %s failed to create cmd\n",
+				__func__, ndctl_bus_get_provider(bus));
+		return -ENOTTY;
+	}
+
+	rc = ndctl_cmd_submit(clear_err);
+	if (rc) {
+		fprintf(stderr, "%s: bus: %s failed to submit cmd: %d\n",
+				__func__, ndctl_bus_get_provider(bus), rc);
+		ndctl_cmd_unref(clear_err);
+		return rc;
+	}
+
+	cleared = ndctl_cmd_clear_error_get_cleared(clear_err);
+	if (cleared != SZ_4K) {
+		fprintf(stderr, "%s: bus: %s expected to clear: %d actual: %lld\n",
+				__func__, ndctl_bus_get_provider(bus), SZ_4K,
+				cleared);
+		return -ENXIO;
+	}
+
+	check->cmd = clear_err;
+	return 0;
+}
+
 #else
 static int check_ars_cap(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 		struct check_cmd *check)
@@ -1730,6 +1780,13 @@ static int check_ars_status(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 	fprintf(stderr, "%s: HAVE_NDCTL_ARS disabled, skipping\n", __func__);
 	return 0;
 }
+
+static int check_clear_error(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
+		struct check_cmd *check)
+{
+	fprintf(stderr, "%s: HAVE_NDCTL_ARS disabled, skipping\n", __func__);
+	return 0;
+}
 #endif
 
 #define BITS_PER_LONG 32
@@ -1755,6 +1812,7 @@ static int check_commands(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 		[ND_CMD_ARS_CAP] = { check_ars_cap },
 		[ND_CMD_ARS_START] = { check_ars_start },
 		[ND_CMD_ARS_STATUS] = { check_ars_status },
+		[ND_CMD_CLEAR_ERROR] = { check_clear_error },
 	};
 	unsigned int i, rc = 0;
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
