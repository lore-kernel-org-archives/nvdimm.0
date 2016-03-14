Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by ml01.01.org (Postfix) with ESMTP id 0D9011A1E91
 for <linux-nvdimm@lists.01.org>; Mon, 14 Mar 2016 16:39:32 -0700 (PDT)
Subject: [ndctl PATCH] ndctl: fix definition of conditional functionality
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 14 Mar 2016 16:38:45 -0700
Message-ID: <20160314233845.35672.69216.stgit@dwillia2-desk3.jf.intel.com>
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

Resolve HAVE_NDCTL_ARS and HAVE_NDCTL_CLEAR_ERROR in libndctl.h from the
results of configure.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 configure.ac            |   21 +++++++++++++++++++++
 lib/ndctl/libndctl.h.in |   20 +++++++++++---------
 2 files changed, 32 insertions(+), 9 deletions(-)
 rename lib/ndctl/{libndctl.h => libndctl.h.in} (98%)

diff --git a/configure.ac b/configure.ac
index 7e006641b197..1ab376885215 100644
--- a/configure.ac
+++ b/configure.ac
@@ -144,6 +144,27 @@ AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[
 )
 AM_CONDITIONAL([ENABLE_CLEAR_ERROR], [test "x$enable_clear_err" = "xyes"])
 
+AC_CONFIG_COMMANDS([gen-libndctl.h],
+		[[
+		if test "x$enable_ars" = "xyes"; then
+			enable_ars=1
+		else
+			enable_ars=0
+		fi
+		if test "x$enable_clear_err" = "xyes"; then
+			enable_clear_err=1
+		else
+			enable_clear_err=0
+		fi
+		sed -e s/HAVE_NDCTL_ARS/$enable_ars/ \
+		    -e s/HAVE_NDCTL_CLEAR_ERROR/$enable_clear_err/ \
+		< lib/ndctl/libndctl.h.in > lib/ndctl/libndctl.h
+		]],
+		[[
+		enable_ars=$enable_ars
+		enable_clear_err=$enable_clear_err
+		]])
+
 AC_CHECK_HEADERS_ONCE([linux/version.h])
 
 AC_CHECK_FUNCS([ \
diff --git a/lib/ndctl/libndctl.h b/lib/ndctl/libndctl.h.in
similarity index 98%
rename from lib/ndctl/libndctl.h
rename to lib/ndctl/libndctl.h.in
index 456288f66aee..b16f26dae535 100644
--- a/lib/ndctl/libndctl.h
+++ b/lib/ndctl/libndctl.h.in
@@ -148,7 +148,8 @@ int ndctl_dimm_disable(struct ndctl_dimm *dimm);
 int ndctl_dimm_enable(struct ndctl_dimm *dimm);
 
 struct ndctl_cmd;
-#ifdef HAVE_NDCTL_ARS
+#define HAS_ARS HAVE_NDCTL_ARS
+#if HAS_ARS == 1
 struct ndctl_cmd *ndctl_bus_cmd_new_ars_cap(struct ndctl_bus *bus,
 		unsigned long long address, unsigned long long len);
 struct ndctl_cmd *ndctl_bus_cmd_new_ars_start(struct ndctl_cmd *ars_cap, int type);
@@ -167,18 +168,18 @@ unsigned long long ndctl_cmd_ars_get_record_addr(struct ndctl_cmd *ars_stat,
 unsigned long long ndctl_cmd_ars_get_record_len(struct ndctl_cmd *ars_stat,
 		unsigned int rec_index);
 
-#ifdef HAVE_NDCTL_CLEAR_ERROR
+#define HAS_CLEAR_ERROR HAVE_NDCTL_CLEAR_ERROR
+#if HAS_CLEAR_ERROR == 1
 /*
- * clear_error requires ars_cap, so we require HAVE_NDCTL_ARS to export the
- * clear_error capability
+ * clear_error requires ars_cap, so we require HAS_CLEAR_ERROR to export
+ * the clear_error capability
  */
 struct ndctl_cmd *ndctl_bus_cmd_new_clear_error(unsigned long long address,
 		unsigned long long len, struct ndctl_cmd *ars_cap);
 unsigned long long ndctl_cmd_clear_error_get_cleared(
 		struct ndctl_cmd *clear_err);
-#define HAS_CLEAR_ERROR 1
 #endif
-#else /* HAVE_NDCTL_ARS */
+#else /* HAS_ARS == 0 */
 static inline struct ndctl_cmd *ndctl_bus_cmd_new_ars_cap(struct ndctl_bus *bus,
 		unsigned long long address, unsigned long long len)
 {
@@ -202,7 +203,7 @@ static inline unsigned int ndctl_cmd_ars_cap_get_size(struct ndctl_cmd *ars_cap)
 	return 0;
 }
 
-
+struct ndctl_range;
 static inline int ndctl_cmd_ars_cap_get_range(struct ndctl_cmd *ars_cap,
 		struct ndctl_range *range)
 {
@@ -230,9 +231,10 @@ static inline unsigned long long ndctl_cmd_ars_get_record_len(
 {
 	return 0;
 }
-#endif /* HAVE_NDCTL_ARS */
+#define HAS_CLEAR_ERROR 0
+#endif /* HAS_ARS */
 
-#ifndef HAS_CLEAR_ERROR
+#if HAS_CLEAR_ERROR == 0
 static inline struct ndctl_cmd *ndctl_bus_cmd_new_clear_error(
 		unsigned long long address, unsigned long long len,
 		struct ndctl_cmd *ars_cap)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
