Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym01.jp.fujitsu.com (mgwym01.jp.fujitsu.com [211.128.242.40])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 13DAD21D19933
 for <linux-nvdimm@lists.01.org>; Fri,  4 Aug 2017 02:10:18 -0700 (PDT)
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
 by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 04D34AC016F
 for <linux-nvdimm@lists.01.org>; Fri,  4 Aug 2017 18:12:28 +0900 (JST)
Date: Fri, 04 Aug 2017 18:12:25 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: [RFC/Patch 4/5] libndctl Make interfaces to use Translate SPA
In-Reply-To: <20170804180231.27BC.E1E9C6FF@jp.fujitsu.com>
References: <20170804180231.27BC.E1E9C6FF@jp.fujitsu.com>
Message-Id: <20170804181223.27CC.E1E9C6FF@jp.fujitsu.com>
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
To: NVDIMM-ML <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

ndctl:libndctl Make interfaces to use Translate SPA.

This patch makes 3 new interfaces :
  - to ask bus has translate SPA feature.
  - to call translate SPA.
  - to find DIMM by SPA address.


Note) I'm not sure how many buffer should be prepared, because
      it depends on max # of mirroring way.
      This patch assume maxmum # is 4 way.


Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>

---
 configure.ac                 |  19 ++++++++
 ndctl/lib/libndctl-private.h |   7 +++
 ndctl/lib/libndctl.c         | 103 ++++++++++++++++++++++++++++++++++++++++++-
 ndctl/lib/libndctl.sym       |   3 ++
 ndctl/libndctl.h.in          |  23 ++++++++++
 ndctl/ndctl.h                |   8 ++++
 6 files changed, 162 insertions(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 316f5b7..653fde0 100644
--- a/configure.ac
+++ b/configure.ac
@@ -162,6 +162,25 @@ AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[
 )
 AM_CONDITIONAL([ENABLE_CLEAR_ERROR], [test "x$enable_clear_err" = "xyes"])
 
+AC_MSG_CHECKING([for TRANSLATE SPA support])
+AC_LANG(C)
+AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[
+                       #ifdef HAVE_NDCTL_H
+                       #include <linux/ndctl.h>
+                       #else
+                       #include "ndctl/ndctl.h"
+                       #endif
+                       ]], [[
+                       int x = ND_CMD_TRANS_SPA;
+                       ]]
+               )], [AC_MSG_RESULT([yes])
+                    enable_trans_spa=yes
+                    AC_DEFINE([HAVE_NDCTL_TRANS_SPA], [1],
+                               [Define to 1 if ndctl.h has TRANSLATE SPA support.])
+               ], [AC_MSG_RESULT([no])]
+)
+AM_CONDITIONAL([ENABLE_TRANS_SPA], [test "x$enable_trans_spa" = "xyes"])
+
 AC_MSG_CHECKING([for device DAX support])
 AC_LANG(C)
 AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[
diff --git a/ndctl/lib/libndctl-private.h b/ndctl/lib/libndctl-private.h
index 8f10fbc..a1fcd2f 100644
--- a/ndctl/lib/libndctl-private.h
+++ b/ndctl/lib/libndctl-private.h
@@ -196,6 +196,7 @@ struct ndctl_cmd {
 #ifdef HAVE_NDCTL_CLEAR_ERROR
 		struct nd_cmd_clear_error clear_err[0];
 #endif
+		struct nd_cmd_trans_spa trans_spa[0];
 		struct ndn_pkg_hpe1 hpe1[0];
 		struct ndn_pkg_msft msft[0];
 		struct nd_cmd_smart smart[0];
@@ -250,6 +251,12 @@ static const int nd_cmd_clear_error = ND_CMD_CLEAR_ERROR;
 static const int nd_cmd_clear_error;
 #endif
 
+#ifdef HAVE_NDCTL_TRANS_SPA
+static const int nd_cmd_trans_spa = ND_CMD_TRANS_SPA;
+#else
+static const int nd_cmd_trans_spa;
+#endif
+
 static inline struct ndctl_bus *cmd_to_bus(struct ndctl_cmd *cmd)
 {
 	if (cmd->dimm)
diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 68d8064..5ebcc45 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -744,7 +744,9 @@ static int to_dsm_index(const char *name, int dimm)
 		end_cmd = ND_CMD_CALL;
 		cmd_name_fn = nvdimm_cmd_name;
 	} else {
-		end_cmd = nd_cmd_clear_error;
+		end_cmd = nd_cmd_trans_spa;
+		if (!end_cmd)
+			end_cmd = nd_cmd_clear_error;
 		if (!end_cmd)
 			end_cmd = nd_cmd_ars_status;
 		cmd_name_fn = nvdimm_bus_cmd_name;
@@ -1943,6 +1945,102 @@ NDCTL_EXPORT struct badblock *ndctl_region_get_first_badblock(struct ndctl_regio
 	return ndctl_region_get_next_badblock(region);
 }
 
+#ifdef HAVE_NDCTL_TRANS_SPA
+NDCTL_EXPORT int ndctl_bus_has_trans_spa(struct ndctl_bus *bus)
+{
+	if (!bus)
+		return 0;
+
+	return ndctl_bus_is_cmd_supported(bus, ND_CMD_TRANS_SPA);
+}
+
+static struct ndctl_cmd *ndctl_bus_cmd_new_trans_spa(struct ndctl_bus *bus)
+{
+	struct ndctl_cmd *cmd;
+	size_t size, spa_length;
+
+	spa_length = sizeof(struct nd_cmd_trans_spa)
+		+ sizeof(struct nd_nvdimm_device) * ND_MIRROR_MAX_WAY;
+	size = sizeof(*cmd) + spa_length;
+	cmd = calloc(1, size);
+	if (!cmd)
+		return NULL;
+
+	cmd->bus = bus;
+	ndctl_cmd_ref(cmd);
+	cmd->type = ND_CMD_TRANS_SPA;
+	cmd->size = size;
+	cmd->status = 1;
+	cmd->firmware_status = &cmd->trans_spa->status;
+	cmd->trans_spa->trans_length = spa_length;
+
+	return cmd;
+}
+
+static int ndctl_bus_cmd_get_trans_spa(struct ndctl_cmd *cmd,
+					unsigned int *handles, unsigned long long *dpas)
+{
+	int i;
+	int num_nvdimms;
+
+	if (cmd->trans_spa->status == ND_TRANS_SPA_STATUS_INVALID_SPA)
+		return -EINVAL;
+
+	num_nvdimms = cmd->trans_spa->num_nvdimms;
+	for (i = 0; i < num_nvdimms; i++) {
+		handles[i] = cmd->trans_spa->devices[i].nfit_device_handle;
+		dpas[i] = cmd->trans_spa->devices[i].dpa;
+	}
+
+	ndctl_cmd_unref(cmd);
+	return 0;
+}
+
+NDCTL_EXPORT int ndctl_bus_cmd_trans_spa(struct ndctl_bus *bus,
+	unsigned long long addr, unsigned int *handles, unsigned long long *dpas)
+{
+
+	struct ndctl_cmd *cmd;
+	int rc;
+
+	cmd = ndctl_bus_cmd_new_trans_spa(bus);
+	cmd->trans_spa->spa = addr;
+
+	rc = ndctl_cmd_submit(cmd);
+	if (rc) {
+		ndctl_cmd_unref(cmd);
+		return rc;
+	}
+
+	rc = ndctl_bus_cmd_get_trans_spa(cmd, handles, dpas);
+
+	return rc;
+}
+
+NDCTL_EXPORT int ndctl_dimms_get_by_spa(struct ndctl_bus *bus, unsigned long long spa,
+				struct ndctl_dimm **dimms)
+{
+	int i, rc;
+	unsigned int handles[ND_MIRROR_MAX_WAY];
+	unsigned long long dpas[ND_MIRROR_MAX_WAY];
+
+	if (!bus || !spa || !dimms)
+		return -EINVAL;
+
+	memset(handles, 0, sizeof(handles));
+	memset(dpas, 0, sizeof(dpas));
+
+	rc = ndctl_bus_cmd_trans_spa(bus, spa, &handles[0], &dpas[0]);
+	if (rc)
+		return rc;
+
+	for (i = 0; i < ND_MIRROR_MAX_WAY && handles[i]; i++)
+		dimms[i] = ndctl_dimm_get_by_handle(bus, handles[i]);
+
+	return 0;
+}
+#endif /* HAVE_NDCTL_TRANS_SPA */
+
 static struct nd_cmd_vendor_tail *to_vendor_tail(struct ndctl_cmd *cmd)
 {
 	struct nd_cmd_vendor_tail *tail = (struct nd_cmd_vendor_tail *)
@@ -2314,6 +2412,9 @@ static int to_ioctl_cmd(int cmd, int dimm)
 #ifdef HAVE_NDCTL_CLEAR_ERROR
 		case ND_CMD_CLEAR_ERROR:     return ND_IOCTL_CLEAR_ERROR;
 #endif
+#ifdef HAVE_NDCTL_TRANS_SPA
+		case ND_CMD_TRANS_SPA:       return ND_CMD_TRANS_SPA;
+#endif
 		default:
 						       return 0;
 		};
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 0e59243..6846f20 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -36,6 +36,9 @@ global:
 	ndctl_bus_get_provider;
 	ndctl_bus_get_ctx;
 	ndctl_bus_wait_probe;
+	ndctl_bus_has_trans_spa;
+	ndctl_bus_cmd_trans_spa;
+	ndctl_dimms_get_by_spa;
 	ndctl_dimm_get_first;
 	ndctl_dimm_get_next;
 	ndctl_dimm_get_handle;
diff --git a/ndctl/libndctl.h.in b/ndctl/libndctl.h.in
index 200c5cf..3a6256b 100644
--- a/ndctl/libndctl.h.in
+++ b/ndctl/libndctl.h.in
@@ -347,6 +347,29 @@ static inline unsigned int ndctl_cmd_smart_threshold_get_spares(
 }
 #endif
 
+#if HAVE_NDCTL_TRANS_SPA == 1
+int ndctl_bus_has_trans_spa(struct ndctl_bus *bus);
+int ndctl_bus_cmd_trans_spa(struct ndctl_bus *bus,
+	unsigned long long addr, unsigned int *handles, unsigned long long *dpas);
+int ndctl_dimms_get_by_spa(struct ndctl_bus *bus,
+	unsigned long long spa, struct ndctl_dimm **dimms);
+#else
+static inline int ndctl_bus_has_trans_spa(struct ndctl_bus *bus)
+{
+	return 0;
+}
+static inline int ndctl_bus_cmd_trans_spa(struct ndctl_bus *bus,
+	unsigned long long addr, unsigned int *handles, unsigned long long *dpas)
+{
+	return 0;
+}
+static inline int ndctl_dimms_get_by_spa(struct ndctl_bus *bus,
+	unsigned long long spa, struct ndctl_dimm **dimms)
+{
+	return 0;
+}
+#endif
+
 struct ndctl_cmd *ndctl_dimm_cmd_new_vendor_specific(struct ndctl_dimm *dimm,
 		unsigned int opcode, size_t input_size, size_t output_size);
 ssize_t ndctl_cmd_vendor_set_input(struct ndctl_cmd *cmd, void *buf,
diff --git a/ndctl/ndctl.h b/ndctl/ndctl.h
index d70b97d..add0d58 100644
--- a/ndctl/ndctl.h
+++ b/ndctl/ndctl.h
@@ -35,6 +35,9 @@ struct nd_cmd_smart {
 #define ND_SMART_CRITICAL_HEALTH	(1 << 1)
 #define ND_SMART_FATAL_HEALTH		(1 << 2)
 
+#define ND_MIRROR_MAX_WAY 4 /* XXX: assume max mirroring way */
+#define ND_TRANS_SPA_STATUS_INVALID_SPA  2
+
 struct nd_smart_payload {
 	__u32 flags;
 	__u8 reserved0[4];
@@ -190,6 +193,7 @@ enum {
 	ND_CMD_ARS_START = 2,
 	ND_CMD_ARS_STATUS = 3,
 	ND_CMD_CLEAR_ERROR = 4,
+	ND_CMD_TRANS_SPA = 5,
 
 	/* per-dimm commands */
 	ND_CMD_SMART = 1,
@@ -217,6 +221,7 @@ static __inline__ const char *nvdimm_bus_cmd_name(unsigned cmd)
 		[ND_CMD_ARS_START] = "ars_start",
 		[ND_CMD_ARS_STATUS] = "ars_status",
 		[ND_CMD_CLEAR_ERROR] = "clear_error",
+		[ND_CMD_TRANS_SPA] = "trans_spa",
 		[ND_CMD_CALL] = "cmd_call",
 	};
 
@@ -280,6 +285,9 @@ static __inline__ const char *nvdimm_cmd_name(unsigned cmd)
 #define ND_IOCTL_CLEAR_ERROR		_IOWR(ND_IOCTL, ND_CMD_CLEAR_ERROR,\
 					struct nd_cmd_clear_error)
 
+#define ND_IOCTL_TRANS_SPA 		_IOWR(ND_IOCTL, ND_CMD_TRANS_SPA,\
+					struct nd_cmd_trans_spa)
+
 #define ND_DEVICE_DIMM 1            /* nd_dimm: container for "config data" */
 #define ND_DEVICE_REGION_PMEM 2     /* nd_region: (parent of PMEM namespaces) */
 #define ND_DEVICE_REGION_BLK 3      /* nd_region: (parent of BLK namespaces) */



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
