Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 79810210D8528
 for <linux-nvdimm@lists.01.org>; Fri,  3 Aug 2018 10:27:21 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] ndctl,
 inject-smart: continue in spite of errors for uninject-all
Date: Fri,  3 Aug 2018 11:27:11 -0600
Message-Id: <20180803172712.3219-1-vishal.l.verma@intel.com>
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

When the missing command submissions for ctrl-temperature were added to
inject-smart, as a side effect, uninject-all also started trying to
uninject ctrl-temperature. Since DSMs for smart injection for certain
platforms don't support ctrl-temperature injection, this failed the
command.

For the uninject-all command, add a sctx flag that allows command
submissions to continue in spite of errors. The error messages are still
printed out, so they are not lost. This way, uninject-all does a
best-effort uninjection of all fields, even if some fields are
unsupported by the given platform.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/inject-smart.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/ndctl/inject-smart.c b/ndctl/inject-smart.c
index 56c39ab..d60bbf1 100644
--- a/ndctl/inject-smart.c
+++ b/ndctl/inject-smart.c
@@ -54,6 +54,7 @@ static struct parameters {
 
 static struct smart_ctx {
 	bool alarms_present;
+	bool err_continue;
 	unsigned long op_mask;
 	unsigned long flags;
 	unsigned int media_temperature;
@@ -220,6 +221,7 @@ static int smart_init(void)
 {
 	if (param.human)
 		sctx.flags |= UTIL_JSON_HUMAN;
+	sctx.err_continue = false;
 
 	/* setup attributes and thresholds except alarm_control */
 	smart_param_setup_temps(media_temperature)
@@ -244,6 +246,7 @@ static int smart_init(void)
 		param.spares_uninject = true;
 		param.fatal_uninject = true;
 		param.unsafe_shutdown_uninject = true;
+		sctx.err_continue = true;
 	}
 	smart_param_setup_uninj(media_temperature)
 	smart_param_setup_uninj(ctrl_temperature)
@@ -337,7 +340,8 @@ out:
 		si_cmd = ndctl_dimm_cmd_new_smart_inject(dimm); \
 		if (!si_cmd) { \
 			error("%s: no smart inject command support\n", name); \
-			goto out; \
+			if (sctx.err_continue == false) \
+				goto out; \
 		} \
 		if (param.arg##_uninject) \
 			enable = false; \
@@ -345,13 +349,15 @@ out:
 		if (rc) { \
 			error("%s: smart inject %s cmd invalid: %s (%d)\n", \
 				name, #arg, strerror(abs(rc)), rc); \
-			goto out; \
+			if (sctx.err_continue == false) \
+				goto out; \
 		} \
 		rc = ndctl_cmd_submit(si_cmd); \
 		if (rc) { \
 			error("%s: smart inject %s command failed: %s (%d)\n", \
 				name, #arg, strerror(abs(rc)), rc); \
-			goto out; \
+			if (sctx.err_continue == false) \
+				goto out; \
 		} \
 		ndctl_cmd_unref(si_cmd); \
 	} \
@@ -365,7 +371,8 @@ out:
 		si_cmd = ndctl_dimm_cmd_new_smart_inject(dimm); \
 		if (!si_cmd) { \
 			error("%s: no smart inject command support\n", name); \
-			goto out; \
+			if (sctx.err_continue == false) \
+				goto out; \
 		} \
 		if (param.arg##_uninject) \
 			enable = false; \
@@ -373,13 +380,15 @@ out:
 		if (rc) { \
 			error("%s: smart inject %s cmd invalid: %s (%d)\n", \
 				name, #arg, strerror(abs(rc)), rc); \
-			goto out; \
+			if (sctx.err_continue == false) \
+				goto out; \
 		} \
 		rc = ndctl_cmd_submit(si_cmd); \
 		if (rc) { \
 			error("%s: smart inject %s command failed: %s (%d)\n", \
 				name, #arg, strerror(abs(rc)), rc); \
-			goto out; \
+			if (sctx.err_continue == false) \
+				goto out; \
 		} \
 		ndctl_cmd_unref(si_cmd); \
 	} \
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
