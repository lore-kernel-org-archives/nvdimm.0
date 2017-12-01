Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4B76021A10961
 for <linux-nvdimm@lists.01.org>; Fri,  1 Dec 2017 15:28:44 -0800 (PST)
Subject: [ndctl PATCH 05/17] ndctl: remove support for compiling against the
 kernel ndctl.h header
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 01 Dec 2017 15:24:56 -0800
Message-ID: <151217069657.28402.9732226972129099055.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151217066885.28402.7962437173336388439.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151217066885.28402.7962437173336388439.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Building against the local copy of ndctl.h has been the default for
almost 2 years (commit df5a175efe6b "ndctl: make --enable-local the
default"). Now that SMART definitions are moving from ndctl.h to
libndctl.h remove the ability to build against local kernel headers, and
update the local ND_SMART_*_VALID flags to include CTEMP (controller
temperature), AIT_STATUS, and PTEMP (pmic temperature).

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 configure.ac            |  120 -------------------------------
 ndctl.spec.in           |    4 +
 ndctl/Makefile.am       |    5 -
 ndctl/check.c           |    7 --
 ndctl/inject-error.c    |    6 --
 ndctl/lib/Makefile.am   |   23 ++----
 ndctl/lib/ars.c         |    9 --
 ndctl/lib/intel.c       |    8 ++
 ndctl/lib/libndctl.c    |   21 +----
 ndctl/lib/private.h     |   30 --------
 ndctl/libndctl.h        |  181 ++++++-----------------------------------------
 ndctl/list.c            |    5 -
 ndctl/namespace.c       |    9 +-
 ndctl/ndctl.h           |   59 ---------------
 ndctl/util/json-smart.c |    7 --
 test/blk_namespaces.c   |    7 --
 test/daxdev-errors.c    |    6 --
 test/dpa-alloc.c        |    7 --
 test/dsm-fail.c         |    4 -
 test/libndctl.c         |   49 +++++--------
 test/multi-pmem.c       |    5 -
 test/pmem_namespaces.c  |    5 -
 util/json.c             |    5 -
 util/json.h             |    8 --
 24 files changed, 73 insertions(+), 517 deletions(-)
 rename ndctl/{libndctl.h.in => libndctl.h} (88%)

diff --git a/configure.ac b/configure.ac
index 5b103813ee6f..70ba36028eea 100644
--- a/configure.ac
+++ b/configure.ac
@@ -126,126 +126,6 @@ AC_ARG_ENABLE([local],
         AS_HELP_STRING([--disable-local], [build against kernel ndctl.h @<:@default=system@:>@]),
         [], [enable_local=yes])
 
-AS_IF([test "x$enable_local" = "xyes"], [], [
-	AC_CHECK_HEADER([linux/ndctl.h], [
-		AC_DEFINE([HAVE_NDCTL_H], [1],
-			[Define to 1 if you have <linux/ndctl.h>.])
-		], [])
-	]
-)
-
-# when building against kernel headers check version specific features
-AC_MSG_CHECKING([for ARS support])
-AC_LANG(C)
-AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[
-			#ifdef HAVE_NDCTL_H
-			#include <linux/ndctl.h>
-			#else
-			#include "ndctl/ndctl.h"
-			#endif
-			]], [[
-			int x = ARS_STATUS_MASK;
-			]]
-		)], [AC_MSG_RESULT([yes])
-		     enable_ars=yes
-		     AC_DEFINE([HAVE_NDCTL_ARS], [1],
-				[Define to 1 if ndctl.h has ARS support.])
-		], [AC_MSG_RESULT([no])]
-)
-AM_CONDITIONAL([ENABLE_ARS], [test "x$enable_ars" = "xyes"])
-
-AC_MSG_CHECKING([for CLEAR ERR support])
-AC_LANG(C)
-AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[
-			#ifdef HAVE_NDCTL_H
-			#include <linux/ndctl.h>
-			#else
-			#include "ndctl/ndctl.h"
-			#endif
-			]], [[
-			int x = ND_CMD_CLEAR_ERROR;
-			]]
-		)], [AC_MSG_RESULT([yes])
-		     enable_clear_err=yes
-		     AC_DEFINE([HAVE_NDCTL_CLEAR_ERROR], [1],
-				[Define to 1 if ndctl.h has CLEAR ERR support.])
-		], [AC_MSG_RESULT([no])]
-)
-AM_CONDITIONAL([ENABLE_CLEAR_ERROR], [test "x$enable_clear_err" = "xyes"])
-
-AC_MSG_CHECKING([for device DAX support])
-AC_LANG(C)
-AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[
-			#ifdef HAVE_NDCTL_H
-			#include <linux/ndctl.h>
-			#else
-			#include "ndctl/ndctl.h"
-			#endif
-			]], [[
-			int x = ND_DEVICE_DAX_PMEM;
-			]]
-		)], [AC_MSG_RESULT([yes])
-		     enable_dev_dax=yes
-		     AC_DEFINE([HAVE_NDCTL_DEVICE_DAX], [1],
-				[Define to 1 if ndctl.h has device DAX support.])
-		], [AC_MSG_RESULT([no])]
-)
-AM_CONDITIONAL([ENABLE_DEV_DAX], [test "x$enable_dev_dax" = "xyes"])
-
-AC_MSG_CHECKING([for SMART support])
-AC_LANG(C)
-AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[
-			#ifdef HAVE_NDCTL_H
-			#include <linux/ndctl.h>
-			#else
-			#include "ndctl/ndctl.h"
-			#endif
-			]], [[
-			int x = ND_SMART_HEALTH_VALID;
-			]]
-		)], [AC_MSG_RESULT([yes])
-		     enable_smart=yes
-		     AC_DEFINE([HAVE_NDCTL_SMART], [1],
-				[Define to 1 if ndctl.h has SMART support.])
-		], [AC_MSG_RESULT([no])]
-)
-AM_CONDITIONAL([ENABLE_SMART], [test "x$enable_smart" = "xyes"])
-
-AC_CONFIG_COMMANDS([gen-libndctl.h],
-		[[
-		if test "x$enable_ars" = "xyes"; then
-			enable_ars=1
-		else
-			enable_ars=0
-		fi
-		if test "x$enable_smart" = "xyes"; then
-			enable_smart=1
-		else
-			enable_smart=0
-		fi
-		if test "x$enable_clear_err" = "xyes"; then
-			enable_clear_err=1
-		else
-			enable_clear_err=0
-		fi
-		if test "x$enable_dev_dax" = "xyes"; then
-			enable_dev_dax=1
-		else
-			enable_dev_dax=0
-		fi
-		sed -e s/HAVE_NDCTL_ARS/$enable_ars/ \
-		    -e s/HAVE_NDCTL_SMART/$enable_smart/ \
-		    -e s/HAVE_NDCTL_CLEAR_ERROR/$enable_clear_err/ \
-		    -e s/HAVE_NDCTL_DEV_DAX/$enable_dev_dax/ \
-		< ndctl/libndctl.h.in > ndctl/libndctl.h
-		]],
-		[[
-		enable_ars=$enable_ars
-		enable_smart=$enable_smart
-		enable_clear_err=$enable_clear_err
-		enable_dev_dax=$enable_dev_dax
-		]])
-
 AC_CHECK_HEADERS_ONCE([linux/version.h])
 
 AC_CHECK_FUNCS([ \
diff --git a/ndctl.spec.in b/ndctl.spec.in
index fa60518e43a9..3a5edc37ca7c 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -94,9 +94,9 @@ control API for these devices.
 echo %{version} > version
 ./autogen.sh
 %ifarch x86_64
-%configure --disable-static --enable-local --disable-silent-rules --with-libpmem
+%configure --disable-static --disable-silent-rules --with-libpmem
 %else
-%configure --disable-static --enable-local --disable-silent-rules
+%configure --disable-static --disable-silent-rules
 %endif
 make %{?_smp_mflags}
 
diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index a0cf500ac87c..6677607ba6b3 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -12,12 +12,9 @@ ndctl_SOURCES = ndctl.c \
 		list.c \
 		test.c \
 		../util/json.c \
+		util/json-smart.c \
 		inject-error.c
 
-if ENABLE_SMART
-ndctl_SOURCES += util/json-smart.c
-endif
-
 if ENABLE_DESTRUCTIVE
 ndctl_SOURCES += ../test/blk_namespaces.c \
 		 ../test/pmem_namespaces.c
diff --git a/ndctl/check.c b/ndctl/check.c
index 3d58f8930fcf..bb60dffe8308 100644
--- a/ndctl/check.c
+++ b/ndctl/check.c
@@ -18,6 +18,7 @@
 #include <stdint.h>
 #include <stdlib.h>
 #include <unistd.h>
+#include <ndctl.h>
 #include <limits.h>
 #include <stdbool.h>
 #include <sys/mman.h>
@@ -36,12 +37,6 @@
 #include <ccan/array_size/array_size.h>
 #include <ccan/short_types/short_types.h>
 
-#ifdef HAVE_NDCTL_H
-#include <linux/ndctl.h>
-#else
-#include <ndctl.h>
-#endif
-
 struct check_opts {
 	bool verbose;
 	bool force;
diff --git a/ndctl/inject-error.c b/ndctl/inject-error.c
index 4c4590229df4..374ae0bde4ce 100644
--- a/ndctl/inject-error.c
+++ b/ndctl/inject-error.c
@@ -22,6 +22,7 @@
 #include <sys/types.h>
 #include <sys/ioctl.h>
 
+#include <ndctl.h>
 #include <util/log.h>
 #include <util/size.h>
 #include <util/json.h>
@@ -31,11 +32,6 @@
 #include <util/parse-options.h>
 #include <ccan/array_size/array_size.h>
 #include <ccan/short_types/short_types.h>
-#ifdef HAVE_NDCTL_H
-#include <linux/ndctl.h>
-#else
-#include <ndctl.h>
-#endif
 
 #include "private.h"
 #include <builtin.h>
diff --git a/ndctl/lib/Makefile.am b/ndctl/lib/Makefile.am
index 3a51e799afa1..5e10fde53a51 100644
--- a/ndctl/lib/Makefile.am
+++ b/ndctl/lib/Makefile.am
@@ -1,9 +1,5 @@
 include $(top_srcdir)/Makefile.am.in
 
-BUILT_SOURCES = ../libndctl.h
-../libndctl.h: ../libndctl.h.in
-	touch $(top_srcdir)/version.m4
-
 %.pc: %.pc.in Makefile
 	$(SED_PROCESS)
 
@@ -19,6 +15,12 @@ libndctl_la_SOURCES =\
 	../../util/sysfs.h \
 	dimm.c \
 	inject.c \
+	nfit.c \
+	smart.c \
+	intel.c \
+	hpe1.c \
+	msft.c \
+	ars.c \
 	libndctl.c
 
 libndctl_la_LIBADD =\
@@ -27,19 +29,6 @@ libndctl_la_LIBADD =\
 	$(UUID_LIBS) \
 	$(KMOD_LIBS)
 
-if ENABLE_ARS
-libndctl_la_SOURCES += ars.c
-endif
-
-if ENABLE_SMART
-libndctl_la_SOURCES += smart.c
-libndctl_la_SOURCES += intel.c
-libndctl_la_SOURCES += hpe1.c
-libndctl_la_SOURCES += msft.c
-endif
-
-libndctl_la_SOURCES += nfit.c
-
 EXTRA_DIST += libndctl.sym
 
 libndctl_la_LDFLAGS = $(AM_LDFLAGS) \
diff --git a/ndctl/lib/ars.c b/ndctl/lib/ars.c
index 735c1457a3ec..d53d89857bce 100644
--- a/ndctl/lib/ars.c
+++ b/ndctl/lib/ars.c
@@ -43,7 +43,6 @@ NDCTL_EXPORT struct ndctl_cmd *ndctl_bus_cmd_new_ars_cap(struct ndctl_bus *bus,
 	return cmd;
 }
 
-#ifdef HAVE_NDCTL_CLEAR_ERROR
 static bool is_power_of_2(unsigned int v)
 {
 	return v && ((v & (v - 1)) == 0);
@@ -55,12 +54,6 @@ static bool validate_clear_error(struct ndctl_cmd *ars_cap)
 		return false;
 	return true;
 }
-#else
-static bool validate_clear_error(struct ndctl_cmd *ars_cap)
-{
-	return true;
-}
-#endif
 
 static bool __validate_ars_cap(struct ndctl_cmd *ars_cap)
 {
@@ -253,7 +246,6 @@ NDCTL_EXPORT unsigned long long ndctl_cmd_ars_get_record_len(
 	return 0;
 }
 
-#ifdef HAVE_NDCTL_CLEAR_ERROR
 NDCTL_EXPORT struct ndctl_cmd *ndctl_bus_cmd_new_clear_error(
 		unsigned long long address, unsigned long long len,
 		struct ndctl_cmd *ars_cap)
@@ -314,4 +306,3 @@ NDCTL_EXPORT unsigned long long ndctl_cmd_clear_error_get_cleared(
 	dbg(ctx, "invalid clear_err\n");
 	return 0;
 }
-#endif
diff --git a/ndctl/lib/intel.c b/ndctl/lib/intel.c
index 5aad8c24f00c..478f379324f5 100644
--- a/ndctl/lib/intel.c
+++ b/ndctl/lib/intel.c
@@ -107,9 +107,15 @@ static unsigned int intel_cmd_smart_get_flags(struct ndctl_cmd *cmd)
 	if (intel_flags & ND_INTEL_SMART_USED_VALID)
 		flags |= ND_SMART_USED_VALID;
 	if (intel_flags & ND_INTEL_SMART_MTEMP_VALID)
-		flags |= ND_SMART_TEMP_VALID;
+		flags |= ND_SMART_MTEMP_VALID;
+	if (intel_flags & ND_INTEL_SMART_CTEMP_VALID)
+		flags |= ND_SMART_CTEMP_VALID;
 	if (intel_flags & ND_INTEL_SMART_SHUTDOWN_COUNT_VALID)
 		flags |= ND_SMART_SHUTDOWN_COUNT_VALID;
+	if (intel_flags & ND_INTEL_SMART_AIT_STATUS_VALID)
+		flags |= ND_SMART_AIT_STATUS_VALID;
+	if (intel_flags & ND_INTEL_SMART_PTEMP_VALID)
+		flags |= ND_SMART_PTEMP_VALID;
 	if (intel_flags & ND_INTEL_SMART_ALARM_VALID)
 		flags |= ND_SMART_ALARM_VALID;
 	if (intel_flags & ND_INTEL_SMART_SHUTDOWN_VALID)
diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 26d1a1705397..47ba2807495e 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -30,12 +30,7 @@
 #include <ccan/array_size/array_size.h>
 #include <ccan/build_assert/build_assert.h>
 
-#ifdef HAVE_NDCTL_H
-#include <linux/ndctl.h>
-#else
 #include <ndctl.h>
-#endif
-
 #include <util/sysfs.h>
 #include <ndctl/libndctl.h>
 #include <ndctl/namespace.h>
@@ -631,9 +626,9 @@ static int to_cmd_index(const char *name, int dimm)
 		end_cmd = ND_CMD_CALL;
 		cmd_name_fn = nvdimm_cmd_name;
 	} else {
-		end_cmd = nd_cmd_clear_error;
+		end_cmd = ND_CMD_CLEAR_ERROR;
 		if (!end_cmd)
-			end_cmd = nd_cmd_ars_status;
+			end_cmd = ND_CMD_ARS_STATUS;
 		cmd_name_fn = nvdimm_bus_cmd_name;
 	}
 
@@ -1944,9 +1939,7 @@ static const char *ndctl_device_type_name(int type)
 	case ND_DEVICE_NAMESPACE_IO:   return "namespace_io";
 	case ND_DEVICE_NAMESPACE_PMEM: return "namespace_pmem";
 	case ND_DEVICE_NAMESPACE_BLK:  return "namespace_blk";
-#ifdef HAVE_NDCTL_DEVICE_DAX
 	case ND_DEVICE_DAX_PMEM:       return "dax_pmem";
-#endif
 	default:                       return "unknown";
 	}
 }
@@ -2360,23 +2353,17 @@ static int to_ioctl_cmd(int cmd, int dimm)
 {
 	if (!dimm) {
 		switch (cmd) {
-#ifdef HAVE_NDCTL_ARS
 		case ND_CMD_ARS_CAP:         return ND_IOCTL_ARS_CAP;
 		case ND_CMD_ARS_START:       return ND_IOCTL_ARS_START;
 		case ND_CMD_ARS_STATUS:      return ND_IOCTL_ARS_STATUS;
-#endif
-#ifdef HAVE_NDCTL_CLEAR_ERROR
 		case ND_CMD_CLEAR_ERROR:     return ND_IOCTL_CLEAR_ERROR;
-#endif
 		case ND_CMD_CALL:            return ND_IOCTL_CALL;
 		default:
-						       return 0;
+					     return 0;
 		};
 	}
 
 	switch (cmd) {
-	case ND_CMD_SMART:                  return ND_IOCTL_SMART;
-	case ND_CMD_SMART_THRESHOLD:        return ND_IOCTL_SMART_THRESHOLD;
 	case ND_CMD_DIMM_FLAGS:             return ND_IOCTL_DIMM_FLAGS;
 	case ND_CMD_GET_CONFIG_SIZE:        return ND_IOCTL_GET_CONFIG_SIZE;
 	case ND_CMD_GET_CONFIG_DATA:        return ND_IOCTL_GET_CONFIG_DATA;
@@ -2386,7 +2373,7 @@ static int to_ioctl_cmd(int cmd, int dimm)
 	case ND_CMD_VENDOR_EFFECT_LOG_SIZE:
 	case ND_CMD_VENDOR_EFFECT_LOG:
 	default:
-					      return 0;
+					    return 0;
 	}
 }
 
diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
index 08e60af95e9e..1b365ae96bfc 100644
--- a/ndctl/lib/private.h
+++ b/ndctl/lib/private.h
@@ -23,11 +23,8 @@
 #include <uuid/uuid.h>
 #include <ccan/list/list.h>
 #include <ccan/array_size/array_size.h>
-#ifdef HAVE_NDCTL_H
-#include <linux/ndctl.h>
-#else
+
 #include <ndctl.h>
-#endif
 #include <ndctl/libndctl.h>
 #include <ccan/endian/endian.h>
 #include <ccan/short_types/short_types.h>
@@ -259,14 +256,10 @@ struct ndctl_cmd {
 	} iter;
 	struct ndctl_cmd *source;
 	union {
-#ifdef HAVE_NDCTL_ARS
 		struct nd_cmd_ars_cap ars_cap[0];
 		struct nd_cmd_ars_start ars_start[0];
 		struct nd_cmd_ars_status ars_status[0];
-#endif
-#ifdef HAVE_NDCTL_CLEAR_ERROR
 		struct nd_cmd_clear_error clear_err[0];
-#endif
 		struct ndn_pkg_hpe1 hpe1[0];
 		struct ndn_pkg_msft msft[0];
 		struct nd_pkg_intel intel[0];
@@ -302,30 +295,9 @@ struct ndctl_smart_ops {
 	unsigned int (*smart_threshold_get_spares)(struct ndctl_cmd *);
 };
 
-#if HAS_SMART == 1
 struct ndctl_smart_ops * const intel_smart_ops;
 struct ndctl_smart_ops * const hpe1_smart_ops;
 struct ndctl_smart_ops * const msft_smart_ops;
-#else
-static struct ndctl_smart_ops * const intel_smart_ops = NULL;
-static struct ndctl_smart_ops * const hpe1_smart_ops = NULL;
-static struct ndctl_smart_ops * const msft_smart_ops = NULL;
-#endif
-
-/* internal library helpers for conditionally defined command numbers */
-#ifdef HAVE_NDCTL_ARS
-static const int nd_cmd_ars_status = ND_CMD_ARS_STATUS;
-static const int nd_cmd_ars_cap = ND_CMD_ARS_CAP;
-#else
-static const int nd_cmd_ars_status;
-static const int nd_cmd_ars_cap;
-#endif
-
-#ifdef HAVE_NDCTL_CLEAR_ERROR
-static const int nd_cmd_clear_error = ND_CMD_CLEAR_ERROR;
-#else
-static const int nd_cmd_clear_error;
-#endif
 
 static inline struct ndctl_bus *cmd_to_bus(struct ndctl_cmd *cmd)
 {
diff --git a/ndctl/libndctl.h.in b/ndctl/libndctl.h
similarity index 88%
rename from ndctl/libndctl.h.in
rename to ndctl/libndctl.h
index 298adff476c7..a2b3148dbb27 100644
--- a/ndctl/libndctl.h.in
+++ b/ndctl/libndctl.h
@@ -174,8 +174,6 @@ int ndctl_dimm_disable(struct ndctl_dimm *dimm);
 int ndctl_dimm_enable(struct ndctl_dimm *dimm);
 
 struct ndctl_cmd;
-#define HAS_ARS HAVE_NDCTL_ARS
-#if HAS_ARS == 1
 struct ndctl_cmd *ndctl_bus_cmd_new_ars_cap(struct ndctl_bus *bus,
 		unsigned long long address, unsigned long long len);
 struct ndctl_cmd *ndctl_bus_cmd_new_ars_start(struct ndctl_cmd *ars_cap, int type);
@@ -193,95 +191,40 @@ unsigned long long ndctl_cmd_ars_get_record_addr(struct ndctl_cmd *ars_stat,
 		unsigned int rec_index);
 unsigned long long ndctl_cmd_ars_get_record_len(struct ndctl_cmd *ars_stat,
 		unsigned int rec_index);
-
-#define HAS_CLEAR_ERROR HAVE_NDCTL_CLEAR_ERROR
-#if HAS_CLEAR_ERROR == 1
-/*
- * clear_error requires ars_cap, so we require HAS_CLEAR_ERROR to export
- * the clear_error capability
- */
 struct ndctl_cmd *ndctl_bus_cmd_new_clear_error(unsigned long long address,
 		unsigned long long len, struct ndctl_cmd *ars_cap);
 unsigned long long ndctl_cmd_clear_error_get_cleared(
 		struct ndctl_cmd *clear_err);
-#endif
-#else /* HAS_ARS == 0 */
-static inline struct ndctl_cmd *ndctl_bus_cmd_new_ars_cap(struct ndctl_bus *bus,
-		unsigned long long address, unsigned long long len)
-{
-	return NULL;
-}
-
-static inline struct ndctl_cmd *ndctl_bus_cmd_new_ars_start(
-		struct ndctl_cmd *ars_cap, int type)
-{
-	return NULL;
-}
-
-static inline struct ndctl_cmd *ndctl_bus_cmd_new_ars_status(
-		struct ndctl_cmd *ars_cap)
-{
-	return NULL;
-}
-
-static inline unsigned int ndctl_cmd_ars_cap_get_size(struct ndctl_cmd *ars_cap)
-{
-	return 0;
-}
-
-struct ndctl_range;
-static inline int ndctl_cmd_ars_cap_get_range(struct ndctl_cmd *ars_cap,
-		struct ndctl_range *range)
-{
-	return -ENXIO;
-}
-
-static inline unsigned int ndctl_cmd_ars_in_progress(struct ndctl_cmd *ars_status)
-{
-	return 0;
-}
-
-static inline unsigned int ndctl_cmd_ars_num_records(struct ndctl_cmd *ars_stat)
-{
-	return 0;
-}
-
-static inline unsigned long long ndctl_cmd_ars_get_record_addr(
-		struct ndctl_cmd *ars_stat, unsigned int rec_index)
-{
-	return 0;
-}
-
-static inline unsigned long long ndctl_cmd_ars_get_record_len(
-		struct ndctl_cmd *ars_stat, unsigned int rec_index)
-{
-	return 0;
-}
-#define HAS_CLEAR_ERROR 0
-#endif /* HAS_ARS */
-
-#if HAS_CLEAR_ERROR == 0
-static inline struct ndctl_cmd *ndctl_bus_cmd_new_clear_error(
-		unsigned long long address, unsigned long long len,
-		struct ndctl_cmd *ars_cap)
-{
-	return NULL;
-}
-
-static inline unsigned long long ndctl_cmd_clear_error_get_cleared(
-		struct ndctl_cmd *clear_err)
-{
-	return 0;
-}
-#endif
 
 /*
  * Note: ndctl_cmd_smart_get_temperature is an alias for
  * ndctl_cmd_smart_get_temperature
  */
 
-#define HAS_SMART HAVE_NDCTL_SMART
-#if HAS_SMART == 1
+/*
+ * the ndctl.h definition of these are deprecated, libndctl.h is the
+ * authoritative defintion.
+ */
+#define ND_SMART_HEALTH_VALID	(1 << 0)
+#define ND_SMART_SPARES_VALID	(1 << 1)
+#define ND_SMART_USED_VALID	(1 << 2)
+#define ND_SMART_MTEMP_VALID 	(1 << 3)
+#define ND_SMART_TEMP_VALID 	ND_SMART_MTEMP_VALID
+#define ND_SMART_CTEMP_VALID 	(1 << 4)
+#define ND_SMART_SHUTDOWN_COUNT_VALID	(1 << 5)
+#define ND_SMART_AIT_STATUS_VALID (1 << 6)
+#define ND_SMART_PTEMP_VALID	(1 << 7)
+#define ND_SMART_ALARM_VALID	(1 << 9)
+#define ND_SMART_SHUTDOWN_VALID	(1 << 10)
+#define ND_SMART_VENDOR_VALID	(1 << 11)
+#define ND_SMART_SPARE_TRIP	(1 << 0)
+#define ND_SMART_MTEMP_TRIP	(1 << 1)
+#define ND_SMART_TEMP_TRIP	ND_SMART_MTEMP_TRIP
+#define ND_SMART_CTEMP_TRIP	(1 << 2)
+#define ND_SMART_NON_CRITICAL_HEALTH	(1 << 0)
+#define ND_SMART_CRITICAL_HEALTH	(1 << 1)
+#define ND_SMART_FATAL_HEALTH		(1 << 2)
+
 struct ndctl_cmd *ndctl_dimm_cmd_new_smart(struct ndctl_dimm *dimm);
 unsigned int ndctl_cmd_smart_get_flags(struct ndctl_cmd *cmd);
 unsigned int ndctl_cmd_smart_get_health(struct ndctl_cmd *cmd);
@@ -299,82 +242,6 @@ unsigned int ndctl_cmd_smart_threshold_get_alarm_control(struct ndctl_cmd *cmd);
 unsigned int ndctl_cmd_smart_threshold_get_temperature(struct ndctl_cmd *cmd);
 unsigned int ndctl_cmd_smart_threshold_get_media_temperature(struct ndctl_cmd *cmd);
 unsigned int ndctl_cmd_smart_threshold_get_spares(struct ndctl_cmd *cmd);
-#else
-static inline struct ndctl_cmd *ndctl_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
-{
-	return NULL;
-}
-static inline unsigned int ndctl_cmd_smart_get_flags(struct ndctl_cmd *cmd)
-{
-	return 0;
-}
-static inline unsigned int ndctl_cmd_smart_get_health(struct ndctl_cmd *cmd)
-{
-	return 0;
-}
-static inline unsigned int ndctl_cmd_smart_get_temperature(struct ndctl_cmd *cmd)
-{
-	return 0;
-}
-static inline unsigned int ndctl_cmd_smart_get_media_temperature(
-		struct ndctl_cmd *cmd)
-{
-	return 0;
-}
-static inline unsigned int ndctl_cmd_smart_get_spares(struct ndctl_cmd *cmd)
-{
-	return 0;
-}
-static inline unsigned int ndctl_cmd_smart_get_alarm_flags(struct ndctl_cmd *cmd)
-{
-	return 0;
-}
-static inline unsigned int ndctl_cmd_smart_get_life_used(struct ndctl_cmd *cmd)
-{
-	return 0;
-}
-static inline unsigned int ndctl_cmd_smart_get_shutdown_state(struct ndctl_cmd *cmd)
-{
-	return 0;
-}
-static inline unsigned int ndctl_cmd_smart_get_shutdown_count(struct ndctl_cmd *cmd)
-{
-	return 0;
-}
-static inline unsigned int ndctl_cmd_smart_get_vendor_size(struct ndctl_cmd *cmd)
-{
-	return 0;
-}
-static inline unsigned char *ndctl_cmd_smart_get_vendor_data(struct ndctl_cmd *cmd)
-{
-	return NULL;
-}
-static inline struct ndctl_cmd *ndctl_dimm_cmd_new_smart_threshold(
-		struct ndctl_dimm *dimm)
-{
-	return NULL;
-}
-static inline unsigned int ndctl_cmd_smart_threshold_get_alarm_control(
-		struct ndctl_cmd *cmd)
-{
-	return 0;
-}
-static inline unsigned int ndctl_cmd_smart_threshold_get_temperature(
-		struct ndctl_cmd *cmd)
-{
-	return 0;
-}
-static inline unsigned int ndctl_cmd_smart_threshold_get_media_temperature(
-		struct ndctl_cmd *cmd)
-{
-	return 0;
-}
-static inline unsigned int ndctl_cmd_smart_threshold_get_spares(
-		struct ndctl_cmd *cmd)
-{
-	return 0;
-}
-#endif
 
 struct ndctl_cmd *ndctl_dimm_cmd_new_vendor_specific(struct ndctl_dimm *dimm,
 		unsigned int opcode, size_t input_size, size_t output_size);
diff --git a/ndctl/list.c b/ndctl/list.c
index 1960e9f8d7b5..d6e49b03a265 100644
--- a/ndctl/list.c
+++ b/ndctl/list.c
@@ -15,6 +15,7 @@
 #include <stdlib.h>
 #include <unistd.h>
 #include <limits.h>
+
 #include <util/json.h>
 #include <util/filter.h>
 #include <json-c/json.h>
@@ -22,11 +23,7 @@
 #include <util/parse-options.h>
 #include <ccan/array_size/array_size.h>
 
-#ifdef HAVE_NDCTL_H
-#include <linux/ndctl.h>
-#else
 #include <ndctl.h>
-#endif
 
 static struct {
 	bool buses;
diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index d31244b71c37..c47867d38a0c 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -17,6 +17,8 @@
 #include <unistd.h>
 #include <limits.h>
 #include <syslog.h>
+
+#include <ndctl.h>
 #include "action.h"
 #include <sys/stat.h>
 #include <uuid/uuid.h>
@@ -28,13 +30,6 @@
 #include <ndctl/libndctl.h>
 #include <util/parse-options.h>
 #include <ccan/minmax/minmax.h>
-#include <ccan/array_size/array_size.h>
-
-#ifdef HAVE_NDCTL_H
-#include <linux/ndctl.h>
-#else
-#include <ndctl.h>
-#endif
 
 static bool verbose;
 static bool force;
diff --git a/ndctl/ndctl.h b/ndctl/ndctl.h
index 7f5b120492cf..4cf373b2a5d4 100644
--- a/ndctl/ndctl.h
+++ b/ndctl/ndctl.h
@@ -13,60 +13,9 @@
 #ifndef __NDCTL_H__
 #define __NDCTL_H__
 
+#include <ccan/array_size/array_size.h>
 #include <linux/types.h>
 
-struct nd_cmd_smart {
-	__u32 status;
-	__u8 data[128];
-} __attribute__((packed));
-
-#define ND_SMART_HEALTH_VALID	(1 << 0)
-#define ND_SMART_SPARES_VALID	(1 << 1)
-#define ND_SMART_USED_VALID	(1 << 2)
-#define ND_SMART_TEMP_VALID 	(1 << 3)
-#define ND_SMART_CTEMP_VALID 	(1 << 4)
-#define ND_SMART_SHUTDOWN_COUNT_VALID	(1 << 5)
-#define ND_SMART_ALARM_VALID	(1 << 9)
-#define ND_SMART_SHUTDOWN_VALID	(1 << 10)
-#define ND_SMART_VENDOR_VALID	(1 << 11)
-#define ND_SMART_SPARE_TRIP	(1 << 0)
-#define ND_SMART_TEMP_TRIP	(1 << 1)
-#define ND_SMART_CTEMP_TRIP	(1 << 2)
-#define ND_SMART_NON_CRITICAL_HEALTH	(1 << 0)
-#define ND_SMART_CRITICAL_HEALTH	(1 << 1)
-#define ND_SMART_FATAL_HEALTH		(1 << 2)
-
-struct nd_smart_payload {
-	__u32 flags;
-	__u8 reserved0[4];
-	__u8 health;
-	__u8 spares;
-	__u8 life_used;
-	__u8 alarm_flags;
-	__u16 temperature;
-	__u16 ctrl_temperature;
-	__u32 shutdown_count;
-	__u8 ait_status;
-	__u16 pmic_temperature;
-	__u8 reserved1[8];
-	__u8 shutdown_state;
-	__u32 vendor_size;
-	__u8 vendor_data[92];
-} __attribute__((packed));
-
-struct nd_cmd_smart_threshold {
-	__u32 status;
-	__u8 data[8];
-} __attribute__((packed));
-
-struct nd_smart_threshold_payload {
-	__u8 alarm_control;
-	__u8 reserved0;
-	__u16 temperature;
-	__u8 spares;
-	__u8 reserved[3];
-} __attribute__((packed));
-
 struct nd_cmd_dimm_flags {
 	__u32 status;
 	__u32 flags;
@@ -215,12 +164,6 @@ static __inline__ const char *nvdimm_cmd_name(unsigned cmd)
 
 #define ND_IOCTL 'N'
 
-#define ND_IOCTL_SMART			_IOWR(ND_IOCTL, ND_CMD_SMART,\
-					struct nd_cmd_smart)
-
-#define ND_IOCTL_SMART_THRESHOLD	_IOWR(ND_IOCTL, ND_CMD_SMART_THRESHOLD,\
-					struct nd_cmd_smart_threshold)
-
 #define ND_IOCTL_DIMM_FLAGS		_IOWR(ND_IOCTL, ND_CMD_DIMM_FLAGS,\
 					struct nd_cmd_dimm_flags)
 
diff --git a/ndctl/util/json-smart.c b/ndctl/util/json-smart.c
index b2bd3ae885fb..7aabf4f3aebe 100644
--- a/ndctl/util/json-smart.c
+++ b/ndctl/util/json-smart.c
@@ -16,12 +16,7 @@
 #include <json-c/json.h>
 #include <ndctl/libndctl.h>
 #include <ccan/array_size/array_size.h>
-
-#ifdef HAVE_NDCTL_H
-#include <linux/ndctl.h>
-#else
 #include <ndctl.h>
-#endif
 
 static double parse_smart_temperature(unsigned int temp)
 {
@@ -96,8 +91,6 @@ struct json_object *util_dimm_health_to_json(struct ndctl_dimm *dimm)
 
 	rc = ndctl_cmd_submit(cmd);
 	if (rc || ndctl_cmd_get_firmware_status(cmd)) {
-		if (!ndctl_dimm_is_cmd_supported(dimm, ND_CMD_SMART))
-			goto err;
 		jobj = json_object_new_string("unknown");
 		if (jobj)
 			json_object_object_add(jhealth, "health_state", jobj);
diff --git a/test/blk_namespaces.c b/test/blk_namespaces.c
index 178f73cacb16..7b33bfd0528b 100644
--- a/test/blk_namespaces.c
+++ b/test/blk_namespaces.c
@@ -23,6 +23,7 @@
 #include <syslog.h>
 #include <sys/stat.h>
 #include <sys/types.h>
+#include <ndctl.h>
 #include <unistd.h>
 #include <uuid/uuid.h>
 #include <linux/version.h>
@@ -30,12 +31,6 @@
 #include <libkmod.h>
 #include <ccan/array_size/array_size.h>
 
-#ifdef HAVE_NDCTL_H
-#include <linux/ndctl.h>
-#else
-#include <ndctl.h>
-#endif
-
 /* The purpose of this test is to verify that we can successfully do I/O to
  * multiple nd_blk namespaces that have discontiguous segments.  It first
  * sets up two namespaces, each 1/2 the total size of the NVDIMM and each with
diff --git a/test/daxdev-errors.c b/test/daxdev-errors.c
index ba89b0c047a7..94fbebec4e33 100644
--- a/test/daxdev-errors.c
+++ b/test/daxdev-errors.c
@@ -30,14 +30,10 @@
 
 #include <util/log.h>
 #include <util/sysfs.h>
+#include <daxctl/libdaxctl.h>
 #include <ccan/array_size/array_size.h>
 #include <ndctl/libndctl.h>
-#include <daxctl/libdaxctl.h>
-#ifdef HAVE_NDCTL_H
-#include <linux/ndctl.h>
-#else
 #include <ndctl.h>
-#endif
 
 #define fail() fprintf(stderr, "%s: failed at: %d\n", __func__, __LINE__)
 
diff --git a/test/dpa-alloc.c b/test/dpa-alloc.c
index d13cf5dde66f..9ab10f90293a 100644
--- a/test/dpa-alloc.c
+++ b/test/dpa-alloc.c
@@ -24,16 +24,11 @@
 #include <uuid/uuid.h>
 
 #include <test.h>
+#include <ndctl.h>
 #include <linux/version.h>
 #include <ndctl/libndctl.h>
 #include <ccan/array_size/array_size.h>
 
-#ifdef HAVE_NDCTL_H
-#include <linux/ndctl.h>
-#else
-#include <ndctl.h>
-#endif
-
 static const char *NFIT_PROVIDER0 = "nfit_test.0";
 static const char *NFIT_PROVIDER1 = "nfit_test.1";
 #define SZ_4K 0x1000UL
diff --git a/test/dsm-fail.c b/test/dsm-fail.c
index 22ec94451146..b363decc29c8 100644
--- a/test/dsm-fail.c
+++ b/test/dsm-fail.c
@@ -24,11 +24,7 @@
 
 #include <ccan/array_size/array_size.h>
 #include <ndctl/libndctl.h>
-#ifdef HAVE_NDCTL_H
-#include <linux/ndctl.h>
-#else
 #include <ndctl.h>
-#endif
 #include <test.h>
 
 #define DIMM_PATH "/sys/devices/platform/nfit_test.0/nfit_test_dimm/test_dimm0"
diff --git a/test/libndctl.c b/test/libndctl.c
index 770171919b6c..5189f7886481 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -31,11 +31,7 @@
 #include <ccan/array_size/array_size.h>
 #include <ndctl/libndctl.h>
 #include <daxctl/libdaxctl.h>
-#ifdef HAVE_NDCTL_H
-#include <linux/ndctl.h>
-#else
 #include <ndctl.h>
-#endif
 #include <test.h>
 
 #define BLKROGET _IO(0x12,94) /* get read-only status (0 = read_write) */
@@ -409,18 +405,10 @@ static unsigned long dimm_commands0 = 1UL << ND_CMD_GET_CONFIG_SIZE
 		| 1UL << ND_CMD_SET_CONFIG_DATA | 1UL << ND_CMD_SMART
 		| 1UL << ND_CMD_SMART_THRESHOLD;
 
-#ifdef HAVE_NDCTL_CLEAR_ERROR
 #define CLEAR_ERROR_CMDS (1UL << ND_CMD_CLEAR_ERROR)
-#else
-#define CLEAR_ERROR_CMDS 0
-#endif
 
-#ifdef HAVE_NDCTL_ARS
 #define ARS_CMDS (1UL << ND_CMD_ARS_CAP | 1UL << ND_CMD_ARS_START \
 		| 1UL << ND_CMD_ARS_STATUS)
-#else
-#define ARS_CMDS 0
-#endif
 
 static unsigned long bus_commands0 = CLEAR_ERROR_CMDS | ARS_CMDS;
 
@@ -2132,7 +2120,6 @@ static int check_set_config_data(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 	return 0;
 }
 
-#ifdef HAVE_NDCTL_SMART
 #define __check_smart(dimm, cmd, field) ({ \
 	if (ndctl_cmd_smart_get_##field(cmd) != smart_data.field) { \
 		fprintf(stderr, "%s dimm: %#x expected field %#x got: %#x\n", \
@@ -2144,10 +2131,19 @@ static int check_set_config_data(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 	} \
 })
 
+/*
+ * Note, this is not a command payload, this is just a namespace for
+ * smart parameters.
+ */
+struct smart {
+	unsigned int flags, health, temperature, spares, alarm_flags,
+		     life_used, shutdown_state, vendor_size;
+};
+
 static int check_smart(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 		struct check_cmd *check)
 {
-	static const struct nd_smart_payload smart_data = {
+	static const struct smart smart_data = {
 		.flags = ND_SMART_HEALTH_VALID | ND_SMART_TEMP_VALID
 			| ND_SMART_SPARES_VALID | ND_SMART_ALARM_VALID
 			| ND_SMART_USED_VALID | ND_SMART_SHUTDOWN_VALID,
@@ -2200,10 +2196,18 @@ static int check_smart(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 	} \
 })
 
+/*
+ * Note, this is not a command payload, this is just a namespace for
+ * smart_threshold parameters.
+ */
+struct smart_threshold {
+	unsigned int alarm_control, temperature, spares;
+};
+
 static int check_smart_threshold(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 		struct check_cmd *check)
 {
-	static const struct nd_smart_threshold_payload smart_t_data = {
+	static const struct smart_threshold smart_t_data = {
 		.alarm_control = ND_SMART_SPARE_TRIP | ND_SMART_TEMP_TRIP,
 		.temperature = 40 * 16,
 		.spares = 5,
@@ -2277,21 +2281,6 @@ static int check_smart_threshold(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 	ndctl_cmd_unref(cmd);
 	return 0;
 }
-#else
-static int check_smart(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
-		struct check_cmd *check)
-{
-	fprintf(stderr, "%s: HAVE_NDCTL_SMART disabled, skipping\n", __func__);
-	return 0;
-}
-
-static int check_smart_threshold(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
-		struct check_cmd *check)
-{
-	fprintf(stderr, "%s: HAVE_NDCTL_SMART disabled, skipping\n", __func__);
-	return 0;
-}
-#endif
 
 #define BITS_PER_LONG 32
 static int check_commands(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
diff --git a/test/multi-pmem.c b/test/multi-pmem.c
index 3e3c1037e016..b3054f44b5dd 100644
--- a/test/multi-pmem.c
+++ b/test/multi-pmem.c
@@ -28,12 +28,7 @@
 #include <ndctl/libndctl.h>
 #include <ccan/array_size/array_size.h>
 
-#ifdef HAVE_NDCTL_H
-#include <linux/ndctl.h>
-#else
 #include <ndctl.h>
-#endif
-
 #include <builtin.h>
 #include <test.h>
 
diff --git a/test/pmem_namespaces.c b/test/pmem_namespaces.c
index 94a5986955b3..69e87abc592f 100644
--- a/test/pmem_namespaces.c
+++ b/test/pmem_namespaces.c
@@ -30,12 +30,7 @@
 #include <test.h>
 
 #include <ccan/array_size/array_size.h>
-
-#ifdef HAVE_NDCTL_H
-#include <linux/ndctl.h>
-#else
 #include <ndctl.h>
-#endif
 
 #define err(msg)\
 	fprintf(stderr, "%s:%d: %s (%s)\n", __func__, __LINE__, msg, strerror(errno))
diff --git a/util/json.c b/util/json.c
index f49921236823..95beaa2efd38 100644
--- a/util/json.c
+++ b/util/json.c
@@ -21,12 +21,7 @@
 #include <daxctl/libdaxctl.h>
 #include <ccan/array_size/array_size.h>
 #include <ccan/short_types/short_types.h>
-
-#ifdef HAVE_NDCTL_H
-#include <linux/ndctl.h>
-#else
 #include <ndctl.h>
-#endif
 
 /* adapted from mdadm::human_size_brief() */
 static int display_size(struct json_object *jobj, struct printbuf *pbuf,
diff --git a/util/json.h b/util/json.h
index de55127168c9..96634756c19f 100644
--- a/util/json.h
+++ b/util/json.h
@@ -51,13 +51,5 @@ struct json_object *util_json_object_size(unsigned long long size,
 		unsigned long flags);
 struct json_object *util_json_object_hex(unsigned long long val,
 		unsigned long flags);
-#ifdef HAVE_NDCTL_SMART
 struct json_object *util_dimm_health_to_json(struct ndctl_dimm *dimm);
-#else
-static inline struct json_object *util_dimm_health_to_json(
-		struct ndctl_dimm *dimm)
-{
-	return NULL;
-}
-#endif
 #endif /* __NDCTL_JSON_H__ */

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
