Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0B54821A10961
 for <linux-nvdimm@lists.01.org>; Fri,  1 Dec 2017 15:29:10 -0800 (PST)
Subject: [ndctl PATCH 10/17] ndctl: support set smart alarm/threshold
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 01 Dec 2017 15:25:23 -0800
Message-ID: <151217072298.28402.6161097504506303620.stgit@dwillia2-desk3.amr.corp.intel.com>
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

libndctl and test support for the ND_INTEL_SMART_SET_THRESHOLD command.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/lib/intel.c      |   83 +++++++++++++++++++++++++++++++++++++++++++++++-
 ndctl/lib/intel.h      |   10 ++++++
 ndctl/lib/libndctl.sym |    9 +++++
 ndctl/lib/private.h    |    8 +++++
 ndctl/lib/smart.c      |   39 +++++++++++++++++++++++
 ndctl/libndctl.h       |   14 ++++++++
 test/libndctl.c        |   59 +++++++++++++++++++++++++++++-----
 7 files changed, 213 insertions(+), 9 deletions(-)

diff --git a/ndctl/lib/intel.c b/ndctl/lib/intel.c
index 478f379324f5..e9da565dd57d 100644
--- a/ndctl/lib/intel.c
+++ b/ndctl/lib/intel.c
@@ -143,6 +143,7 @@ static unsigned int intel_cmd_smart_get_health(struct ndctl_cmd *cmd)
 }
 
 intel_smart_get_field(cmd, media_temperature)
+intel_smart_get_field(cmd, ctrl_temperature)
 intel_smart_get_field(cmd, spares)
 intel_smart_get_field(cmd, alarm_flags)
 intel_smart_get_field(cmd, life_used)
@@ -198,6 +199,7 @@ static unsigned int intel_cmd_smart_threshold_get_alarm_control(
 }
 
 intel_smart_threshold_get_field(cmd, media_temperature)
+intel_smart_threshold_get_field(cmd, ctrl_temperature)
 intel_smart_threshold_get_field(cmd, spares)
 
 static struct ndctl_cmd *intel_dimm_cmd_new_smart_threshold(
@@ -216,11 +218,77 @@ static struct ndctl_cmd *intel_dimm_cmd_new_smart_threshold(
 	return cmd;
 }
 
+static struct ndctl_cmd *intel_dimm_cmd_new_smart_set_threshold(
+		struct ndctl_cmd *cmd_thresh)
+{
+	struct ndctl_cmd *cmd;
+	struct nd_intel_smart_threshold *thresh;
+	struct nd_intel_smart_set_threshold *set_thresh;
+
+	BUILD_ASSERT(sizeof(struct nd_intel_smart_set_threshold) == 11);
+
+	if (intel_smart_threshold_valid(cmd_thresh) < 0)
+		return NULL;
+
+	cmd = alloc_intel_cmd(cmd_thresh->dimm, ND_INTEL_SMART_SET_THRESHOLD,
+			offsetof(typeof(*set_thresh), status), 4);
+	if (!cmd)
+		return NULL;
+
+	cmd->source = cmd_thresh;
+	ndctl_cmd_ref(cmd_thresh);
+	set_thresh = &cmd->intel->set_thresh;
+	thresh = &cmd_thresh->intel->thresh;
+	set_thresh->alarm_control = thresh->alarm_control;
+	set_thresh->spares = thresh->spares;
+	set_thresh->media_temperature = thresh->media_temperature;
+	set_thresh->ctrl_temperature = thresh->ctrl_temperature;
+	cmd->firmware_status = &set_thresh->status;
+
+	return cmd;
+}
+
+static int intel_smart_set_threshold_valid(struct ndctl_cmd *cmd)
+{
+	struct nd_pkg_intel *pkg = cmd->intel;
+
+	if (cmd->type != ND_CMD_CALL || cmd->status != 1
+			|| pkg->gen.nd_family != NVDIMM_FAMILY_INTEL
+			|| pkg->gen.nd_command != ND_INTEL_SMART_SET_THRESHOLD)
+		return -EINVAL;
+	return 0;
+}
+
+#define intel_smart_set_threshold_field(field) \
+static int intel_cmd_smart_threshold_set_##field( \
+			struct ndctl_cmd *cmd, unsigned int val) \
+{ \
+	if (intel_smart_set_threshold_valid(cmd) < 0) \
+		return -EINVAL; \
+	cmd->intel->set_thresh.field = val; \
+	return 0; \
+}
+
+static unsigned int intel_cmd_smart_threshold_get_supported_alarms(
+		struct ndctl_cmd *cmd)
+{
+	if (intel_smart_set_threshold_valid(cmd) < 0)
+		return 0;
+	return ND_SMART_SPARE_TRIP | ND_SMART_MTEMP_TRIP
+		| ND_SMART_CTEMP_TRIP;
+}
+
+intel_smart_set_threshold_field(alarm_control)
+intel_smart_set_threshold_field(spares)
+intel_smart_set_threshold_field(media_temperature)
+intel_smart_set_threshold_field(ctrl_temperature)
+
 struct ndctl_smart_ops * const intel_smart_ops = &(struct ndctl_smart_ops) {
 	.new_smart = intel_dimm_cmd_new_smart,
 	.smart_get_flags = intel_cmd_smart_get_flags,
 	.smart_get_health = intel_cmd_smart_get_health,
 	.smart_get_media_temperature = intel_cmd_smart_get_media_temperature,
+	.smart_get_ctrl_temperature = intel_cmd_smart_get_ctrl_temperature,
 	.smart_get_spares = intel_cmd_smart_get_spares,
 	.smart_get_alarm_flags = intel_cmd_smart_get_alarm_flags,
 	.smart_get_life_used = intel_cmd_smart_get_life_used,
@@ -229,8 +297,21 @@ struct ndctl_smart_ops * const intel_smart_ops = &(struct ndctl_smart_ops) {
 	.smart_get_vendor_size = intel_cmd_smart_get_vendor_size,
 	.smart_get_vendor_data = intel_cmd_smart_get_vendor_data,
 	.new_smart_threshold = intel_dimm_cmd_new_smart_threshold,
-	.smart_threshold_get_alarm_control = intel_cmd_smart_threshold_get_alarm_control,
+	.smart_threshold_get_alarm_control
+		= intel_cmd_smart_threshold_get_alarm_control,
 	.smart_threshold_get_media_temperature
 		= intel_cmd_smart_threshold_get_media_temperature,
+	.smart_threshold_get_ctrl_temperature
+		= intel_cmd_smart_threshold_get_ctrl_temperature,
 	.smart_threshold_get_spares = intel_cmd_smart_threshold_get_spares,
+	.new_smart_set_threshold = intel_dimm_cmd_new_smart_set_threshold,
+	.smart_threshold_get_supported_alarms
+		= intel_cmd_smart_threshold_get_supported_alarms,
+	.smart_threshold_set_alarm_control
+		= intel_cmd_smart_threshold_set_alarm_control,
+	.smart_threshold_set_media_temperature
+		= intel_cmd_smart_threshold_set_media_temperature,
+	.smart_threshold_set_ctrl_temperature
+		= intel_cmd_smart_threshold_set_ctrl_temperature,
+	.smart_threshold_set_spares = intel_cmd_smart_threshold_set_spares,
 };
diff --git a/ndctl/lib/intel.h b/ndctl/lib/intel.h
index 8cecc02f9ae6..9e6398501531 100644
--- a/ndctl/lib/intel.h
+++ b/ndctl/lib/intel.h
@@ -5,6 +5,7 @@
 #define __INTEL_H__
 #define ND_INTEL_SMART 1
 #define ND_INTEL_SMART_THRESHOLD 2
+#define ND_INTEL_SMART_SET_THRESHOLD 17
 
 #define ND_INTEL_SMART_HEALTH_VALID             (1 << 0)
 #define ND_INTEL_SMART_SPARES_VALID             (1 << 1)
@@ -62,11 +63,20 @@ struct nd_intel_smart_threshold {
 	};
 } __attribute__((packed));
 
+struct nd_intel_smart_set_threshold {
+	__u16 alarm_control;
+	__u8 spares;
+	__u16 media_temperature;
+	__u16 ctrl_temperature;
+	__u32 status;
+} __attribute__((packed));
+
 struct nd_pkg_intel {
 	struct nd_cmd_pkg gen;
 	union {
 		struct nd_intel_smart smart;
 		struct nd_intel_smart_threshold	thresh;
+		struct nd_intel_smart_set_threshold set_thresh;
 	};
 };
 #endif /* __INTEL_H__ */
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index b3fab6232df6..6d9a04282c7d 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -312,4 +312,13 @@ global:
 	ndctl_bb_get_count;
 	ndctl_cmd_smart_get_media_temperature;
 	ndctl_cmd_smart_threshold_get_media_temperature;
+	ndctl_cmd_smart_get_ctrl_temperature;
+	ndctl_cmd_smart_threshold_get_ctrl_temperature;
+	ndctl_dimm_cmd_new_smart_set_threshold;
+	ndctl_cmd_smart_threshold_get_supported_alarms;
+	ndctl_cmd_smart_threshold_set_alarm_control;
+	ndctl_cmd_smart_threshold_set_temperature;
+	ndctl_cmd_smart_threshold_set_media_temperature;
+	ndctl_cmd_smart_threshold_set_ctrl_temperature;
+	ndctl_cmd_smart_threshold_set_spares;
 } LIBNDCTL_13;
diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
index 1b365ae96bfc..5e9f24f2b3c5 100644
--- a/ndctl/lib/private.h
+++ b/ndctl/lib/private.h
@@ -282,6 +282,7 @@ struct ndctl_smart_ops {
 	unsigned int (*smart_get_flags)(struct ndctl_cmd *);
 	unsigned int (*smart_get_health)(struct ndctl_cmd *);
 	unsigned int (*smart_get_media_temperature)(struct ndctl_cmd *);
+	unsigned int (*smart_get_ctrl_temperature)(struct ndctl_cmd *);
 	unsigned int (*smart_get_spares)(struct ndctl_cmd *);
 	unsigned int (*smart_get_alarm_flags)(struct ndctl_cmd *);
 	unsigned int (*smart_get_life_used)(struct ndctl_cmd *);
@@ -292,7 +293,14 @@ struct ndctl_smart_ops {
 	struct ndctl_cmd *(*new_smart_threshold)(struct ndctl_dimm *);
 	unsigned int (*smart_threshold_get_alarm_control)(struct ndctl_cmd *);
 	unsigned int (*smart_threshold_get_media_temperature)(struct ndctl_cmd *);
+	unsigned int (*smart_threshold_get_ctrl_temperature)(struct ndctl_cmd *);
 	unsigned int (*smart_threshold_get_spares)(struct ndctl_cmd *);
+	struct ndctl_cmd *(*new_smart_set_threshold)(struct ndctl_cmd *);
+	unsigned int (*smart_threshold_get_supported_alarms)(struct ndctl_cmd *);
+	int (*smart_threshold_set_alarm_control)(struct ndctl_cmd *, unsigned int);
+	int (*smart_threshold_set_media_temperature)(struct ndctl_cmd *, unsigned int);
+	int (*smart_threshold_set_ctrl_temperature)(struct ndctl_cmd *, unsigned int);
+	int (*smart_threshold_set_spares)(struct ndctl_cmd *, unsigned int);
 };
 
 struct ndctl_smart_ops * const intel_smart_ops;
diff --git a/ndctl/lib/smart.c b/ndctl/lib/smart.c
index 90c45a1a002e..58a6f4bb28ad 100644
--- a/ndctl/lib/smart.c
+++ b/ndctl/lib/smart.c
@@ -40,6 +40,25 @@ NDCTL_EXPORT struct ndctl_cmd *ndctl_dimm_cmd_new_smart_threshold(
 		return NULL;
 }
 
+/*
+ * smart_set_threshold is a read-modify-write command it depends on a
+ * successfully completed smart_threshold command for its defaults.
+ */
+NDCTL_EXPORT struct ndctl_cmd *ndctl_dimm_cmd_new_smart_set_threshold(
+		struct ndctl_cmd *cmd)
+{
+	struct ndctl_smart_ops *ops;
+
+	if (!cmd || !cmd->dimm)
+		return NULL;
+	ops = ndctl_dimm_get_smart_ops(cmd->dimm);
+
+	if (ops && ops->new_smart_set_threshold)
+		return ops->new_smart_set_threshold(cmd);
+	else
+		return NULL;
+}
+
 #define smart_cmd_op(op, rettype, defretvalue) \
 NDCTL_EXPORT rettype ndctl_cmd_##op(struct ndctl_cmd *cmd) \
 { \
@@ -54,6 +73,7 @@ NDCTL_EXPORT rettype ndctl_cmd_##op(struct ndctl_cmd *cmd) \
 smart_cmd_op(smart_get_flags, unsigned int, 0)
 smart_cmd_op(smart_get_health, unsigned int, 0)
 smart_cmd_op(smart_get_media_temperature, unsigned int, 0)
+smart_cmd_op(smart_get_ctrl_temperature, unsigned int, 0)
 smart_cmd_op(smart_get_spares, unsigned int, 0)
 smart_cmd_op(smart_get_alarm_flags, unsigned int, 0)
 smart_cmd_op(smart_get_life_used, unsigned int, 0)
@@ -63,6 +83,7 @@ smart_cmd_op(smart_get_vendor_size, unsigned int, 0)
 smart_cmd_op(smart_get_vendor_data, unsigned char *, NULL)
 smart_cmd_op(smart_threshold_get_alarm_control, unsigned int, 0)
 smart_cmd_op(smart_threshold_get_media_temperature, unsigned int, 0)
+smart_cmd_op(smart_threshold_get_ctrl_temperature, unsigned int, 0)
 smart_cmd_op(smart_threshold_get_spares, unsigned int, 0)
 
 NDCTL_EXPORT unsigned int ndctl_cmd_smart_get_temperature(struct ndctl_cmd *cmd)
@@ -75,3 +96,21 @@ NDCTL_EXPORT unsigned int ndctl_cmd_smart_threshold_get_temperature(
 {
 	return ndctl_cmd_smart_threshold_get_media_temperature(cmd);
 }
+
+smart_cmd_op(smart_threshold_get_supported_alarms, unsigned int, 0);
+
+#define smart_cmd_set_op(op) \
+NDCTL_EXPORT int ndctl_cmd_##op(struct ndctl_cmd *cmd, unsigned int val) \
+{ \
+	if (cmd->dimm) { \
+		struct ndctl_smart_ops *ops = ndctl_dimm_get_smart_ops(cmd->dimm); \
+		if (ops && ops->op) \
+			return ops->op(cmd, val); \
+	} \
+	return -ENXIO; \
+}
+
+smart_cmd_set_op(smart_threshold_set_alarm_control)
+smart_cmd_set_op(smart_threshold_set_media_temperature)
+smart_cmd_set_op(smart_threshold_set_ctrl_temperature)
+smart_cmd_set_op(smart_threshold_set_spares)
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index a2b3148dbb27..69333443ee78 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -230,6 +230,7 @@ unsigned int ndctl_cmd_smart_get_flags(struct ndctl_cmd *cmd);
 unsigned int ndctl_cmd_smart_get_health(struct ndctl_cmd *cmd);
 unsigned int ndctl_cmd_smart_get_temperature(struct ndctl_cmd *cmd);
 unsigned int ndctl_cmd_smart_get_media_temperature(struct ndctl_cmd *cmd);
+unsigned int ndctl_cmd_smart_get_ctrl_temperature(struct ndctl_cmd *cmd);
 unsigned int ndctl_cmd_smart_get_spares(struct ndctl_cmd *cmd);
 unsigned int ndctl_cmd_smart_get_alarm_flags(struct ndctl_cmd *cmd);
 unsigned int ndctl_cmd_smart_get_life_used(struct ndctl_cmd *cmd);
@@ -241,7 +242,20 @@ struct ndctl_cmd *ndctl_dimm_cmd_new_smart_threshold(struct ndctl_dimm *dimm);
 unsigned int ndctl_cmd_smart_threshold_get_alarm_control(struct ndctl_cmd *cmd);
 unsigned int ndctl_cmd_smart_threshold_get_temperature(struct ndctl_cmd *cmd);
 unsigned int ndctl_cmd_smart_threshold_get_media_temperature(struct ndctl_cmd *cmd);
+unsigned int ndctl_cmd_smart_threshold_get_ctrl_temperature(struct ndctl_cmd *cmd);
 unsigned int ndctl_cmd_smart_threshold_get_spares(struct ndctl_cmd *cmd);
+struct ndctl_cmd *ndctl_dimm_cmd_new_smart_set_threshold(struct ndctl_cmd *cmd);
+unsigned int ndctl_cmd_smart_threshold_get_supported_alarms(struct ndctl_cmd *cmd);
+int ndctl_cmd_smart_threshold_set_alarm_control(struct ndctl_cmd *cmd,
+		unsigned int val);
+int ndctl_cmd_smart_threshold_set_temperature(struct ndctl_cmd *cmd,
+		unsigned int val);
+int ndctl_cmd_smart_threshold_set_media_temperature(struct ndctl_cmd *cmd,
+		unsigned int val);
+int ndctl_cmd_smart_threshold_set_ctrl_temperature(struct ndctl_cmd *cmd,
+		unsigned int val);
+int ndctl_cmd_smart_threshold_set_spares(struct ndctl_cmd *cmd,
+		unsigned int val);
 
 struct ndctl_cmd *ndctl_dimm_cmd_new_vendor_specific(struct ndctl_dimm *dimm,
 		unsigned int opcode, size_t input_size, size_t output_size);
diff --git a/test/libndctl.c b/test/libndctl.c
index b10142ebdee4..27de24baca88 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -2182,7 +2182,7 @@ static int check_smart(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 	__check_smart(dimm, cmd, shutdown_state);
 	__check_smart(dimm, cmd, vendor_size);
 
-	ndctl_cmd_unref(cmd);
+	check->cmd = cmd;
 	return 0;
 }
 
@@ -2203,7 +2203,7 @@ static int check_smart(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
  * smart_threshold parameters.
  */
 struct smart_threshold {
-	unsigned int alarm_control, temperature, spares;
+	unsigned int alarm_control, media_temperature, ctrl_temperature, spares;
 };
 
 static int check_smart_threshold(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
@@ -2211,10 +2211,13 @@ static int check_smart_threshold(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 {
 	static const struct smart_threshold smart_t_data = {
 		.alarm_control = ND_SMART_SPARE_TRIP | ND_SMART_TEMP_TRIP,
-		.temperature = 40 * 16,
+		.media_temperature = 40 * 16,
+		.ctrl_temperature = 30 * 16,
 		.spares = 5,
 	};
 	struct ndctl_cmd *cmd = ndctl_dimm_cmd_new_smart_threshold(dimm);
+	struct ndctl_cmd *cmd_smart = check_cmds[ND_CMD_SMART].cmd;
+	struct ndctl_cmd *cmd_set;
 	struct timeval tm;
 	char buf[4096];
 	fd_set fds;
@@ -2249,7 +2252,7 @@ static int check_smart_threshold(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 		if (pid == 0) {
 			FD_ZERO(&fds);
 			FD_SET(fd, &fds);
-			tm.tv_sec = 1;
+			tm.tv_sec = 5;
 			tm.tv_usec = 0;
 			rc = select(fd + 1, NULL, NULL, &fds, &tm);
 			if (rc != 1 || !FD_ISSET(fd, &fds))
@@ -2267,6 +2270,50 @@ static int check_smart_threshold(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 		return rc;
 	}
 
+	__check_smart_threshold(dimm, cmd, alarm_control);
+	__check_smart_threshold(dimm, cmd, media_temperature);
+	__check_smart_threshold(dimm, cmd, ctrl_temperature);
+	__check_smart_threshold(dimm, cmd, spares);
+
+	/*
+	 * The same kernel change that adds nfit_test support for this
+	 * command is the same change that moves notifications to
+	 * require set_threshold. If we fail to get a command, but the
+	 * notification fires then we are on an old kernel, otherwise
+	 * whether old kernel or new kernel the notification should
+	 * fire.
+	 */
+	cmd_set = ndctl_dimm_cmd_new_smart_set_threshold(cmd);
+	if (cmd_set) {
+		/*
+		 * Set all thresholds to match current values and set
+		 * all alarms.
+		 */
+		rc = ndctl_cmd_smart_threshold_set_alarm_control(cmd_set,
+				ndctl_cmd_smart_threshold_get_supported_alarms(cmd_set));
+		rc |= ndctl_cmd_smart_threshold_set_media_temperature(cmd_set,
+				ndctl_cmd_smart_get_media_temperature(cmd_smart));
+		rc |= ndctl_cmd_smart_threshold_set_ctrl_temperature(cmd_set,
+				ndctl_cmd_smart_get_ctrl_temperature(cmd_smart));
+		rc |= ndctl_cmd_smart_threshold_set_spares(cmd_set,
+				ndctl_cmd_smart_get_spares(cmd_smart));
+		if (rc) {
+			fprintf(stderr, "%s: failed set threshold parameters\n",
+					__func__);
+			ndctl_cmd_unref(cmd_set);
+			return -ENXIO;
+		}
+
+		rc = ndctl_cmd_submit(cmd_set);
+		if (rc) {
+			fprintf(stderr, "%s: dimm: %#x failed to submit cmd_set: %d\n",
+					__func__, ndctl_dimm_get_handle(dimm), rc);
+			ndctl_cmd_unref(cmd_set);
+			return rc;
+		}
+		ndctl_cmd_unref(cmd_set);
+	}
+
 	if (ndctl_test_attempt(check->test, KERNEL_VERSION(4, 9, 0))) {
 		wait(&rc);
 		if (WEXITSTATUS(rc) == EXIT_FAILURE) {
@@ -2276,10 +2323,6 @@ static int check_smart_threshold(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 		}
 	}
 
-	__check_smart_threshold(dimm, cmd, alarm_control);
-	__check_smart_threshold(dimm, cmd, temperature);
-	__check_smart_threshold(dimm, cmd, spares);
-
 	ndctl_cmd_unref(cmd);
 	return 0;
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
