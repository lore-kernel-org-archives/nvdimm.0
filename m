Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym04.jp.fujitsu.com (mgwym04.jp.fujitsu.com [211.128.242.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 41CFA21E7901A
 for <linux-nvdimm@lists.01.org>; Thu, 17 Aug 2017 21:33:26 -0700 (PDT)
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
 by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id DAD51AC0158
 for <linux-nvdimm@lists.01.org>; Fri, 18 Aug 2017 13:35:48 +0900 (JST)
Date: Fri, 18 Aug 2017 13:35:26 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: [ndctl PATCH 3/4] Make interfaces to use Translate SPA.
In-Reply-To: <20170818133124.8EAB.E1E9C6FF@jp.fujitsu.com>
References: <20170818133124.8EAB.E1E9C6FF@jp.fujitsu.com>
Message-Id: <20170818133524.8EB4.E1E9C6FF@jp.fujitsu.com>
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


This patch makes 3 new interfaces :
  - to ask bus has translate SPA feature.
  - to call translate SPA.
  - to find DIMM by SPA address.


Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
---
 configure.ac                 |  19 ++++++++
 ndctl/lib/libndctl-private.h |   7 +++
 ndctl/lib/libndctl.c         | 111 +++++++++++++++++++++++++++++++++++++++++++
 ndctl/lib/libndctl.sym       |   3 ++
 ndctl/libndctl.h.in          |  23 +++++++++
 ndctl/ndctl.h                |   5 ++
 6 files changed, 168 insertions(+)

diff --git a/configure.ac b/configure.ac
index 316f5b7..31d6956 100644
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
+                       int x = NFIT_CMD_TRANSLATE_SPA;
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
index 8f10fbc..0512782 100644
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
+static const int nd_cmd_trans_spa = NFIT_CMD_TRANSLATE_SPA;
+#else
+static const int nd_cmd_trans_spa;
+#endif
+
 static inline struct ndctl_bus *cmd_to_bus(struct ndctl_cmd *cmd)
 {
 	if (cmd->dimm)
diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index b3535f0..4556067 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -1959,6 +1959,117 @@ NDCTL_EXPORT struct badblock *ndctl_region_get_first_badblock(struct ndctl_regio
 	return ndctl_region_get_next_badblock(region);
 }
 
+#ifdef HAVE_NDCTL_TRANS_SPA
+NDCTL_EXPORT int ndctl_bus_has_trans_spa(struct ndctl_bus *bus)
+{
+	if (!bus)
+		return 0;
+
+	return ndctl_bus_is_sub_cmd_supported(bus, NFIT_CMD_TRANSLATE_SPA);
+}
+
+static struct ndctl_cmd *ndctl_bus_cmd_new_trans_spa(struct ndctl_bus *bus)
+{
+	struct ndctl_cmd *cmd;
+	struct nd_cmd_pkg *pkg;
+	struct nd_cmd_trans_spa *trans_spa;
+	size_t size, spa_length;
+
+	spa_length = sizeof(struct nd_cmd_trans_spa)
+		+ sizeof(struct nd_nvdimm_device);
+	size = sizeof(*cmd) + sizeof(*pkg) + spa_length;
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
+	pkg->nd_command = NFIT_CMD_TRANSLATE_SPA;
+	pkg->nd_size_in = sizeof(unsigned long long);
+	pkg->nd_size_out = spa_length;
+	pkg->nd_fw_size = spa_length;
+	trans_spa = (struct nd_cmd_trans_spa *)&pkg->nd_payload[0];
+	cmd->firmware_status = &trans_spa->status;
+	trans_spa->trans_length = spa_length;
+
+	return cmd;
+}
+
+static int ndctl_bus_cmd_get_trans_spa(struct ndctl_cmd *cmd,
+					unsigned int *handle, unsigned long long *dpa)
+{
+	struct nd_cmd_pkg *pkg;
+	struct nd_cmd_trans_spa *trans_spa;
+
+	pkg = (struct nd_cmd_pkg *)&cmd->cmd_buf[0];
+	trans_spa = (struct nd_cmd_trans_spa *)&pkg->nd_payload[0];
+
+	if (trans_spa->status == ND_TRANS_SPA_STATUS_INVALID_SPA)
+		return -EINVAL;
+
+	/*
+	 * XXX: Currently NVDIMM mirroring is not supported.
+	 * Even if ACPI returned plural dimms due to mirroring,
+	 * this function returns just the first dimm.
+	 */
+
+	*handle = trans_spa->devices[0].nfit_device_handle;
+	*dpa = trans_spa->devices[0].dpa;
+
+	return 0;
+}
+
+NDCTL_EXPORT int ndctl_bus_cmd_trans_spa(struct ndctl_bus *bus,
+	unsigned long long addr, unsigned int *handle, unsigned long long *dpa)
+{
+
+	struct ndctl_cmd *cmd;
+	struct nd_cmd_pkg *pkg;
+	struct nd_cmd_trans_spa *trans_spa;
+	int rc;
+
+	cmd = ndctl_bus_cmd_new_trans_spa(bus);
+	if (!cmd)
+		return -ENOMEM;
+
+	pkg = (struct nd_cmd_pkg *)&cmd->cmd_buf[0];
+	trans_spa = (struct nd_cmd_trans_spa *)&pkg->nd_payload[0];
+	trans_spa->spa = addr;
+
+	rc = ndctl_cmd_submit(cmd);
+	if (rc) {
+		ndctl_cmd_unref(cmd);
+		return rc;
+	}
+
+	rc = ndctl_bus_cmd_get_trans_spa(cmd, handle, dpa);
+	ndctl_cmd_unref(cmd);
+
+	return rc;
+}
+
+NDCTL_EXPORT struct ndctl_dimm *ndctl_dimm_get_by_spa(struct ndctl_bus *bus,
+		unsigned long long spa)
+{
+	int rc;
+	unsigned int handle;
+	unsigned long long dpa;
+
+	if (!bus || !spa)
+		return NULL;
+
+	rc = ndctl_bus_cmd_trans_spa(bus, spa, &handle, &dpa);
+	if (rc)
+		return NULL;
+
+	return ndctl_dimm_get_by_handle(bus, handle);
+}
+#endif /* HAVE_NDCTL_TRANS_SPA */
+
 static struct nd_cmd_vendor_tail *to_vendor_tail(struct ndctl_cmd *cmd)
 {
 	struct nd_cmd_vendor_tail *tail = (struct nd_cmd_vendor_tail *)
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index b8ac65f..8d9b272 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -36,6 +36,9 @@ global:
 	ndctl_bus_get_provider;
 	ndctl_bus_get_ctx;
 	ndctl_bus_wait_probe;
+	ndctl_bus_has_trans_spa;
+	ndctl_bus_cmd_trans_spa;
+	ndctl_dimm_get_by_spa;
 	ndctl_dimm_get_first;
 	ndctl_dimm_get_next;
 	ndctl_dimm_get_handle;
diff --git a/ndctl/libndctl.h.in b/ndctl/libndctl.h.in
index 206c441..f85a8e7 100644
--- a/ndctl/libndctl.h.in
+++ b/ndctl/libndctl.h.in
@@ -348,6 +348,29 @@ static inline unsigned int ndctl_cmd_smart_threshold_get_spares(
 }
 #endif
 
+#if HAVE_NDCTL_TRANS_SPA == 1
+int ndctl_bus_has_trans_spa(struct ndctl_bus *bus);
+int ndctl_bus_cmd_trans_spa(struct ndctl_bus *bus,
+	unsigned long long addr, unsigned int *handle, unsigned long long *dpa);
+struct ndctl_dimm *ndctl_dimm_get_by_spa(struct ndctl_bus *bus,
+	unsigned long long spa);
+#else
+static inline int ndctl_bus_has_trans_spa(struct ndctl_bus *bus)
+{
+	return 0;
+}
+static inline int ndctl_bus_cmd_trans_spa(struct ndctl_bus *bus,
+	unsigned long long addr, unsigned int *handle, unsigned long long *dpa)
+{
+	return 0;
+}
+static inline ndctl_dimm *ndctl_dimm_get_by_spa(struct ndctl_bus *bus,
+	unsigned long long spa)
+{
+	return NULL;
+}
+#endif
+
 struct ndctl_cmd *ndctl_dimm_cmd_new_vendor_specific(struct ndctl_dimm *dimm,
 		unsigned int opcode, size_t input_size, size_t output_size);
 ssize_t ndctl_cmd_vendor_set_input(struct ndctl_cmd *cmd, void *buf,
diff --git a/ndctl/ndctl.h b/ndctl/ndctl.h
index d70b97d..0efdb3d 100644
--- a/ndctl/ndctl.h
+++ b/ndctl/ndctl.h
@@ -35,6 +35,8 @@ struct nd_cmd_smart {
 #define ND_SMART_CRITICAL_HEALTH	(1 << 1)
 #define ND_SMART_FATAL_HEALTH		(1 << 2)
 
+#define ND_TRANS_SPA_STATUS_INVALID_SPA  2
+
 struct nd_smart_payload {
 	__u32 flags;
 	__u8 reserved0[4];
@@ -191,6 +193,9 @@ enum {
 	ND_CMD_ARS_STATUS = 3,
 	ND_CMD_CLEAR_ERROR = 4,
 
+	/* bus sub commands */
+	NFIT_CMD_TRANSLATE_SPA = 5,
+
 	/* per-dimm commands */
 	ND_CMD_SMART = 1,
 	ND_CMD_SMART_THRESHOLD = 2,



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
