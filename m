Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E4DE720986AD0
 for <linux-nvdimm@lists.01.org>; Fri, 27 Jul 2018 14:39:48 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] ndctl inject-smart: add an option to uninject smart
 fields
Date: Fri, 27 Jul 2018 15:39:43 -0600
Message-Id: <20180727213943.6571-1-vishal.l.verma@intel.com>
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

The smart injection command in ndctl was missing an option to uninject
the different inject-able fields. The APIs in libndctl already allow for
this by setting the 'enable' flag to false. Add a *-uninject argument
for each of the injectable fields that sets this flag and disables
injected values. Also add an "uninject-all" option to uninject all
fields.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Documentation/ndctl/ndctl-inject-smart.txt | 20 ++++++++++
 ndctl/inject-smart.c                       | 61 ++++++++++++++++++++++++++++--
 2 files changed, 78 insertions(+), 3 deletions(-)

diff --git a/Documentation/ndctl/ndctl-inject-smart.txt b/Documentation/ndctl/ndctl-inject-smart.txt
index 20a1621..d28be46 100644
--- a/Documentation/ndctl/ndctl-inject-smart.txt
+++ b/Documentation/ndctl/ndctl-inject-smart.txt
@@ -54,6 +54,9 @@ OPTIONS
 	Enable or disable the smart media temperature alarm. Options are
 	'on' or 'off'.
 
+--media-temperature-uninject::
+	Uninject any media temperature previously injected.
+
 -c::
 --ctrl-temperature=::
 	Inject <value> for the controller temperature smart attribute.
@@ -66,6 +69,9 @@ OPTIONS
 	Enable or disable the smart controller temperature alarm. Options are
 	'on' or 'off'.
 
+--ctrl-temperature-uninject::
+	Uninject any controller temperature previously injected.
+
 -s::
 --spares=::
 	Inject <value> for the spares smart attribute.
@@ -77,14 +83,28 @@ OPTIONS
 --spares-alarm=::
 	Enable or disable the smart spares alarm. Options are 'on' or 'off'.
 
+--spares-uninject::
+	Uninject any spare percentage previously injected.
+
 -f::
 --fatal::
 	Set the flag to spoof fatal health status.
 
+--fatal-uninject::
+	Uninject the fatal health status flag.
+
 -U::
 --unsafe-shutdown::
 	Set the flag to spoof an unsafe shutdown on the next power down.
 
+--unsafe-shutdown-uninject::
+	Uninject the unsafe shutdown flag.
+
+-N::
+--uninject-all::
+	Uninject all possible smart fields/values irrespective of whether
+	they have been previously injected or not.
+
 -v::
 --verbose::
 	Emit debug messages for the error injection process
diff --git a/ndctl/inject-smart.c b/ndctl/inject-smart.c
index edb87e1..f5a3a6f 100644
--- a/ndctl/inject-smart.c
+++ b/ndctl/inject-smart.c
@@ -44,6 +44,12 @@ static struct parameters {
 	const char *spares_alarm;
 	bool fatal;
 	bool unsafe_shutdown;
+	bool media_temperature_uninject;
+	bool ctrl_temperature_uninject;
+	bool spares_uninject;
+	bool fatal_uninject;
+	bool unsafe_shutdown_uninject;
+	bool uninject_all;
 } param;
 
 static struct smart_ctx {
@@ -76,6 +82,8 @@ OPT_STRING('M', "media-temperature-threshold", \
 OPT_STRING('\0', "media-temperature-alarm", &param.media_temperature_alarm, \
 	"smart media temperature alarm", \
 	"enable or disable the smart media temperature alarm"), \
+OPT_BOOLEAN('\0', "media-temperature-uninject", \
+	&param.media_temperature_uninject, "uninject media temperature"), \
 OPT_STRING('c', "ctrl-temperature", &param.ctrl_temperature, \
 	"smart controller temperature attribute", \
 	"inject a value for smart controller temperature"), \
@@ -86,6 +94,8 @@ OPT_STRING('C', "ctrl-temperature-threshold", \
 OPT_STRING('\0', "ctrl-temperature-alarm", &param.ctrl_temperature_alarm, \
 	"smart controller temperature alarm", \
 	"enable or disable the smart controller temperature alarm"), \
+OPT_BOOLEAN('\0', "ctrl-temperature-uninject", \
+	&param.ctrl_temperature_uninject, "uninject controller temperature"), \
 OPT_STRING('s', "spares", &param.spares, \
 	"smart spares attribute", \
 	"inject a value for smart spares"), \
@@ -95,9 +105,17 @@ OPT_STRING('S', "spares-threshold", &param.spares_threshold, \
 OPT_STRING('\0', "spares-alarm", &param.spares_alarm, \
 	"smart spares alarm", \
 	"enable or disable the smart spares alarm"), \
+OPT_BOOLEAN('\0', "spares-uninject", \
+	&param.spares_uninject, "uninject spare percentage"), \
 OPT_BOOLEAN('f', "fatal", &param.fatal, "inject fatal smart health status"), \
+OPT_BOOLEAN('F', "fatal-uninject", \
+	&param.fatal_uninject, "uninject fatal health condition"), \
 OPT_BOOLEAN('U', "unsafe-shutdown", &param.unsafe_shutdown, \
-	"inject smart unsafe shutdown status")
+	"inject smart unsafe shutdown status"), \
+OPT_BOOLEAN('\0', "unsafe-shutdown-uninject", \
+	&param.unsafe_shutdown_uninject, "uninject unsafe shutdown status"), \
+OPT_BOOLEAN('N', "uninject-all", \
+	&param.uninject_all, "uninject all possible fields")
 
 
 static const struct option smart_opts[] = {
@@ -183,6 +201,21 @@ static inline void enable_inject(void)
 	} \
 }
 
+#define smart_param_setup_uninj(arg) \
+{ \
+	if (param.arg##_uninject) { \
+		/* Ensure user didn't set inject and uninject together */ \
+		if (param.arg) { \
+			error("Cannot use %s inject and uninject together\n", \
+				#arg); \
+			return -EINVAL; \
+		} \
+		/* Then set the inject flag so this can be accounted for */ \
+		param.arg = "0"; \
+		enable_inject(); \
+	} \
+}
+
 static int smart_init(void)
 {
 	if (param.human)
@@ -204,6 +237,20 @@ static int smart_init(void)
 	if (param.fatal || param.unsafe_shutdown)
 		enable_inject();
 
+	/* setup uninjections */
+	if (param.uninject_all) {
+		param.media_temperature_uninject = true;
+		param.ctrl_temperature_uninject = true;
+		param.spares_uninject = true;
+		param.fatal_uninject = true;
+		param.unsafe_shutdown_uninject = true;
+	}
+	smart_param_setup_uninj(media_temperature)
+	smart_param_setup_uninj(ctrl_temperature)
+	smart_param_setup_uninj(spares)
+	smart_param_setup_uninj(fatal)
+	smart_param_setup_uninj(unsafe_shutdown)
+
 	if (sctx.op_mask == 0) {
 		error("No valid operation specified\n");
 		return -EINVAL;
@@ -285,12 +332,16 @@ out:
 #define send_inject_val(arg) \
 { \
 	if (param.arg) { \
+		bool enable = true; \
+		\
 		si_cmd = ndctl_dimm_cmd_new_smart_inject(dimm); \
 		if (!si_cmd) { \
 			error("%s: no smart inject command support\n", name); \
 			goto out; \
 		} \
-		rc = ndctl_cmd_smart_inject_##arg(si_cmd, true, sctx.arg); \
+		if (param.arg##_uninject) \
+			enable = false; \
+		rc = ndctl_cmd_smart_inject_##arg(si_cmd, enable, sctx.arg); \
 		if (rc) { \
 			error("%s: smart inject %s cmd invalid: %s (%d)\n", \
 				name, #arg, strerror(abs(rc)), rc); \
@@ -309,12 +360,16 @@ out:
 #define send_inject_bool(arg) \
 { \
 	if (param.arg) { \
+		bool enable = true; \
+		\
 		si_cmd = ndctl_dimm_cmd_new_smart_inject(dimm); \
 		if (!si_cmd) { \
 			error("%s: no smart inject command support\n", name); \
 			goto out; \
 		} \
-		rc = ndctl_cmd_smart_inject_##arg(si_cmd, true); \
+		if (param.arg##_uninject) \
+			enable = false; \
+		rc = ndctl_cmd_smart_inject_##arg(si_cmd, enable); \
 		if (rc) { \
 			error("%s: smart inject %s cmd invalid: %s (%d)\n", \
 				name, #arg, strerror(abs(rc)), rc); \
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
