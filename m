Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2353.austin.hpe.com (g2t2353.austin.hpe.com [15.233.44.26])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 95C6E1A1E4C
 for <linux-nvdimm@lists.01.org>; Tue, 13 Sep 2016 10:43:56 -0700 (PDT)
From: Brian Boylston <brian.boylston@hpe.com>
Subject: [ndctl PATCH v2 1/4] libndctl: introduce ndctl_smart_ops
Date: Tue, 13 Sep 2016 12:41:37 -0500
Message-Id: <20160913174140.10810-2-brian.boylston@hpe.com>
In-Reply-To: <20160913174140.10810-1-brian.boylston@hpe.com>
References: <20160913174140.10810-1-brian.boylston@hpe.com>
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

Add a layer of indirection for the ndctl_cmd_smart*() family of
interfaces.  This will allow the underlying implementation to be
switched based on the DSM family supported by the DIMM.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Brian Boylston <brian.boylston@hpe.com>
---
 ndctl/lib/libndctl-private.h |  21 ++++++++
 ndctl/lib/libndctl-smart.c   | 111 ++++++++++++++++++++++++++++++++++---------
 ndctl/lib/libndctl.c         |   8 ++++
 ndctl/libndctl.h.in          |   1 +
 4 files changed, 118 insertions(+), 23 deletions(-)

diff --git a/ndctl/lib/libndctl-private.h b/ndctl/lib/libndctl-private.h
index 65ef86d..8d2ebfc 100644
--- a/ndctl/lib/libndctl-private.h
+++ b/ndctl/lib/libndctl-private.h
@@ -201,6 +201,27 @@ struct ndctl_cmd {
 	};
 };
 
+struct ndctl_smart_ops {
+	struct ndctl_cmd *(*new_smart)(struct ndctl_dimm *);
+	unsigned int (*smart_get_flags)(struct ndctl_cmd *);
+	unsigned int (*smart_get_health)(struct ndctl_cmd *);
+	unsigned int (*smart_get_temperature)(struct ndctl_cmd *);
+	unsigned int (*smart_get_spares)(struct ndctl_cmd *);
+	unsigned int (*smart_get_alarm_flags)(struct ndctl_cmd *);
+	unsigned int (*smart_get_life_used)(struct ndctl_cmd *);
+	unsigned int (*smart_get_shutdown_state)(struct ndctl_cmd *);
+	unsigned int (*smart_get_vendor_size)(struct ndctl_cmd *);
+	unsigned char *(*smart_get_vendor_data)(struct ndctl_cmd *);
+	struct ndctl_cmd *(*new_smart_threshold)(struct ndctl_dimm *);
+	unsigned int (*smart_threshold_get_alarm_control)(struct ndctl_cmd *);
+	unsigned int (*smart_threshold_get_temperature)(struct ndctl_cmd *);
+	unsigned int (*smart_threshold_get_spares)(struct ndctl_cmd *);
+};
+
+#if HAS_SMART == 1
+struct ndctl_smart_ops intel_smart_ops;
+#endif
+
 /* internal library helpers for conditionally defined command numbers */
 #ifdef HAVE_NDCTL_ARS
 static const int nd_cmd_ars_status = ND_CMD_ARS_STATUS;
diff --git a/ndctl/lib/libndctl-smart.c b/ndctl/lib/libndctl-smart.c
index cba1e9d..a172541 100644
--- a/ndctl/lib/libndctl-smart.c
+++ b/ndctl/lib/libndctl-smart.c
@@ -16,7 +16,55 @@
 #include <ndctl/libndctl.h>
 #include "libndctl-private.h"
 
-NDCTL_EXPORT struct ndctl_cmd *ndctl_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
+/*
+ * The smart_dimm_op() and smart_cmd_op() macros are used here to
+ * define the wrappers around the ndctl_smart_ops:
+ */
+
+#define smart_dimm_op(name, op) \
+NDCTL_EXPORT struct ndctl_cmd *name( \
+		struct ndctl_dimm *dimm) \
+{ \
+	struct ndctl_smart_ops *ops = ndctl_dimm_get_smart_ops(dimm); \
+	if (ops && ops->op) \
+		return ops->op(dimm); \
+	else \
+		return NULL; \
+}
+
+smart_dimm_op(ndctl_dimm_cmd_new_smart, new_smart)
+smart_dimm_op(ndctl_dimm_cmd_new_smart_threshold, new_smart_threshold)
+
+#define smart_cmd_op(name, op, rettype, defretvalue) \
+NDCTL_EXPORT rettype name(struct ndctl_cmd *cmd) \
+{ \
+	if (cmd->dimm) { \
+		struct ndctl_smart_ops *ops = ndctl_dimm_get_smart_ops(cmd->dimm); \
+		if (ops && ops->op) \
+			return ops->op(cmd); \
+	} \
+	return defretvalue; \
+}
+
+smart_cmd_op(ndctl_cmd_smart_get_flags, smart_get_flags, unsigned int, 0)
+smart_cmd_op(ndctl_cmd_smart_get_health, smart_get_health, unsigned int, 0)
+smart_cmd_op(ndctl_cmd_smart_get_temperature, smart_get_temperature, unsigned int, 0)
+smart_cmd_op(ndctl_cmd_smart_get_spares, smart_get_spares, unsigned int, 0)
+smart_cmd_op(ndctl_cmd_smart_get_alarm_flags, smart_get_alarm_flags, unsigned int, 0)
+smart_cmd_op(ndctl_cmd_smart_get_life_used, smart_get_life_used, unsigned int, 0)
+smart_cmd_op(ndctl_cmd_smart_get_shutdown_state, smart_get_shutdown_state, unsigned int, 0)
+smart_cmd_op(ndctl_cmd_smart_get_vendor_size, smart_get_vendor_size, unsigned int, 0)
+smart_cmd_op(ndctl_cmd_smart_get_vendor_data, smart_get_vendor_data, unsigned char *, NULL)
+smart_cmd_op(ndctl_cmd_smart_threshold_get_alarm_control, smart_threshold_get_alarm_control, unsigned int, 0)
+smart_cmd_op(ndctl_cmd_smart_threshold_get_temperature, smart_threshold_get_temperature, unsigned int, 0)
+smart_cmd_op(ndctl_cmd_smart_threshold_get_spares, smart_threshold_get_spares, unsigned int, 0)
+
+/*
+ * The following intel_dimm_*() and intel_smart_*() functions implement
+ * the ndctl_smart_ops for the Intel DSM family (NVDIMM_FAMILY_INTEL):
+ */
+
+static struct ndctl_cmd *intel_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
 {
 	struct ndctl_bus *bus = ndctl_dimm_get_bus(dimm);
 	struct ndctl_ctx *ctx = ndctl_bus_get_ctx(bus);
@@ -45,66 +93,66 @@ NDCTL_EXPORT struct ndctl_cmd *ndctl_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
 	return cmd;
 }
 
-static int smart_valid(struct ndctl_cmd *cmd)
+static int intel_smart_valid(struct ndctl_cmd *cmd)
 {
 	if (cmd->type != ND_CMD_SMART || cmd->status != 0)
 		return cmd->status < 0 ? cmd->status : -EINVAL;
 	return 0;
 }
 
-#define smart_get_field(cmd, field) \
-NDCTL_EXPORT unsigned int ndctl_cmd_smart_get_##field(struct ndctl_cmd *cmd) \
+#define intel_smart_get_field(cmd, field) \
+static unsigned int intel_cmd_smart_get_##field(struct ndctl_cmd *cmd) \
 { \
 	struct nd_smart_payload *smart_data; \
-	if (smart_valid(cmd) < 0) \
+	if (intel_smart_valid(cmd) < 0) \
 		return UINT_MAX; \
 	smart_data = (struct nd_smart_payload *) cmd->smart->data; \
 	return smart_data->field; \
 }
 
-smart_get_field(cmd, flags)
-smart_get_field(cmd, health)
-smart_get_field(cmd, temperature)
-smart_get_field(cmd, spares)
-smart_get_field(cmd, alarm_flags)
-smart_get_field(cmd, life_used)
-smart_get_field(cmd, shutdown_state)
-smart_get_field(cmd, vendor_size)
+intel_smart_get_field(cmd, flags)
+intel_smart_get_field(cmd, health)
+intel_smart_get_field(cmd, temperature)
+intel_smart_get_field(cmd, spares)
+intel_smart_get_field(cmd, alarm_flags)
+intel_smart_get_field(cmd, life_used)
+intel_smart_get_field(cmd, shutdown_state)
+intel_smart_get_field(cmd, vendor_size)
 
-NDCTL_EXPORT unsigned char *ndctl_cmd_smart_get_vendor_data(struct ndctl_cmd *cmd)
+static unsigned char *intel_cmd_smart_get_vendor_data(struct ndctl_cmd *cmd)
 {
 	struct nd_smart_payload *smart_data;
 
-	if (smart_valid(cmd) < 0)
+	if (intel_smart_valid(cmd) < 0)
 		return NULL;
 	smart_data = (struct nd_smart_payload *) cmd->smart->data;
 	return (unsigned char *) smart_data->vendor_data;
 }
 
-static int smart_threshold_valid(struct ndctl_cmd *cmd)
+static int intel_smart_threshold_valid(struct ndctl_cmd *cmd)
 {
 	if (cmd->type != ND_CMD_SMART_THRESHOLD || cmd->status != 0)
 		return cmd->status < 0 ? cmd->status : -EINVAL;
 	return 0;
 }
 
-#define smart_threshold_get_field(cmd, field) \
-NDCTL_EXPORT unsigned int ndctl_cmd_smart_threshold_get_##field( \
+#define intel_smart_threshold_get_field(cmd, field) \
+static unsigned int intel_cmd_smart_threshold_get_##field( \
 			struct ndctl_cmd *cmd) \
 { \
 	struct nd_smart_threshold_payload *smart_t_data; \
-	if (smart_threshold_valid(cmd) < 0) \
+	if (intel_smart_threshold_valid(cmd) < 0) \
 		return UINT_MAX; \
 	smart_t_data = (struct nd_smart_threshold_payload *) \
 			cmd->smart_t->data; \
 	return smart_t_data->field; \
 }
 
-smart_threshold_get_field(cmd, alarm_control)
-smart_threshold_get_field(cmd, temperature)
-smart_threshold_get_field(cmd, spares)
+intel_smart_threshold_get_field(cmd, alarm_control)
+intel_smart_threshold_get_field(cmd, temperature)
+intel_smart_threshold_get_field(cmd, spares)
 
-NDCTL_EXPORT struct ndctl_cmd *ndctl_dimm_cmd_new_smart_threshold(
+static struct ndctl_cmd *intel_dimm_cmd_new_smart_threshold(
 		struct ndctl_dimm *dimm)
 {
 	struct ndctl_bus *bus = ndctl_dimm_get_bus(dimm);
@@ -133,3 +181,20 @@ NDCTL_EXPORT struct ndctl_cmd *ndctl_dimm_cmd_new_smart_threshold(
 
 	return cmd;
 }
+
+struct ndctl_smart_ops intel_smart_ops = {
+	.new_smart = intel_dimm_cmd_new_smart,
+	.smart_get_flags = intel_cmd_smart_get_flags,
+	.smart_get_health = intel_cmd_smart_get_health,
+	.smart_get_temperature = intel_cmd_smart_get_temperature,
+	.smart_get_spares = intel_cmd_smart_get_spares,
+	.smart_get_alarm_flags = intel_cmd_smart_get_alarm_flags,
+	.smart_get_life_used = intel_cmd_smart_get_life_used,
+	.smart_get_shutdown_state = intel_cmd_smart_get_shutdown_state,
+	.smart_get_vendor_size = intel_cmd_smart_get_vendor_size,
+	.smart_get_vendor_data = intel_cmd_smart_get_vendor_data,
+	.new_smart_threshold = intel_dimm_cmd_new_smart_threshold,
+	.smart_threshold_get_alarm_control = intel_cmd_smart_threshold_get_alarm_control,
+	.smart_threshold_get_temperature = intel_cmd_smart_threshold_get_temperature,
+	.smart_threshold_get_spares = intel_cmd_smart_threshold_get_spares,
+};
diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 93f79f7..9a9dc74 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -125,6 +125,7 @@ struct ndctl_bus {
 struct ndctl_dimm {
 	struct kmod_module *module;
 	struct ndctl_bus *bus;
+	struct ndctl_smart_ops *smart_ops;
 	unsigned int handle, major, minor, serial;
 	unsigned short phys_id;
 	unsigned short vendor_id;
@@ -1149,6 +1150,8 @@ static int add_dimm(void *parent, int id, const char *dimm_base)
 		goto err_read;
 	dimm->dsm_mask = parse_commands(buf, 1);
 
+	dimm->smart_ops = &intel_smart_ops;
+
 	dimm->dimm_buf = calloc(1, strlen(dimm_base) + 50);
 	if (!dimm->dimm_buf)
 		goto err_read;
@@ -1459,6 +1462,11 @@ NDCTL_EXPORT struct ndctl_bus *ndctl_dimm_get_bus(struct ndctl_dimm *dimm)
 	return dimm->bus;
 }
 
+NDCTL_EXPORT struct ndctl_smart_ops *ndctl_dimm_get_smart_ops(struct ndctl_dimm *dimm)
+{
+	return dimm->smart_ops;
+}
+
 NDCTL_EXPORT struct ndctl_ctx *ndctl_dimm_get_ctx(struct ndctl_dimm *dimm)
 {
 	return dimm->bus->ctx;
diff --git a/ndctl/libndctl.h.in b/ndctl/libndctl.h.in
index 451466a..679225c 100644
--- a/ndctl/libndctl.h.in
+++ b/ndctl/libndctl.h.in
@@ -150,6 +150,7 @@ unsigned int ndctl_dimm_handle_get_channel(struct ndctl_dimm *dimm);
 unsigned int ndctl_dimm_handle_get_dimm(struct ndctl_dimm *dimm);
 const char *ndctl_dimm_get_devname(struct ndctl_dimm *dimm);
 struct ndctl_bus *ndctl_dimm_get_bus(struct ndctl_dimm *dimm);
+struct ndctl_smart_ops *ndctl_dimm_get_smart_ops(struct ndctl_dimm *dimm);
 struct ndctl_ctx *ndctl_dimm_get_ctx(struct ndctl_dimm *dimm);
 struct ndctl_dimm *ndctl_dimm_get_by_handle(struct ndctl_bus *bus,
 		unsigned int handle);
-- 
2.8.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
