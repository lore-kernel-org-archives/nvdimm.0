Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 28C86211C3F5C
 for <linux-nvdimm@lists.01.org>; Thu, 31 Jan 2019 15:25:11 -0800 (PST)
Subject: [PATCH] ndctl: make command be the same as function names for
 security functions
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 31 Jan 2019 16:25:10 -0700
Message-ID: <154897711044.51306.8448938775272102034.stgit@djiang5-desk3.ch.intel.com>
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
To: vishal.l.verma@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Fix a few inconsistencies in the ndctl command name versus the function name.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 ndctl/builtin.h |    6 +++---
 ndctl/dimm.c    |   18 +++++++++---------
 ndctl/ndctl.c   |    6 +++---
 3 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/ndctl/builtin.h b/ndctl/builtin.h
index 60c3623f..681a69ff 100644
--- a/ndctl/builtin.h
+++ b/ndctl/builtin.h
@@ -32,9 +32,9 @@ int cmd_bat(int argc, const char **argv, struct ndctl_ctx *ctx);
 #endif
 int cmd_update_firmware(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_inject_smart(int argc, const char **argv, struct ndctl_ctx *ctx);
-int cmd_passphrase_setup(int argc, const char **argv, struct ndctl_ctx *ctx);
-int cmd_passphrase_update(int argc, const char **argv, struct ndctl_ctx *ctx);
-int cmd_passphrase_remove(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_setup_passphrase(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_update_passphrase(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_remove_passphrase(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_freeze_security(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_sanitize_dimm(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_load_keys(int argc, const char **argv, struct ndctl_ctx *ctx);
diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index d4e2090f..35e3190e 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -841,7 +841,7 @@ static int action_update(struct ndctl_dimm *dimm, struct action_context *actx)
 	return rc;
 }
 
-static int action_passphrase_setup(struct ndctl_dimm *dimm,
+static int action_setup_passphrase(struct ndctl_dimm *dimm,
 		struct action_context *actx)
 {
 	if (ndctl_dimm_get_security(dimm) < 0) {
@@ -857,7 +857,7 @@ static int action_passphrase_setup(struct ndctl_dimm *dimm,
 			param.master_pass ? ND_MASTER_KEY : ND_USER_KEY);
 }
 
-static int action_passphrase_update(struct ndctl_dimm *dimm,
+static int action_update_passphrase(struct ndctl_dimm *dimm,
 		struct action_context *actx)
 {
 	if (ndctl_dimm_get_security(dimm) < 0) {
@@ -870,7 +870,7 @@ static int action_passphrase_update(struct ndctl_dimm *dimm,
 			param.master_pass ? ND_MASTER_KEY : ND_USER_KEY);
 }
 
-static int action_passphrase_remove(struct ndctl_dimm *dimm,
+static int action_remove_passphrase(struct ndctl_dimm *dimm,
 		struct action_context *actx)
 {
 	if (ndctl_dimm_get_security(dimm) < 0) {
@@ -1335,9 +1335,9 @@ int cmd_update_firmware(int argc, const char **argv, struct ndctl_ctx *ctx)
 	return count >= 0 ? 0 : EXIT_FAILURE;
 }
 
-int cmd_passphrase_update(int argc, const char **argv, struct ndctl_ctx *ctx)
+int cmd_update_passphrase(int argc, const char **argv, struct ndctl_ctx *ctx)
 {
-	int count = dimm_action(argc, argv, ctx, action_passphrase_update,
+	int count = dimm_action(argc, argv, ctx, action_update_passphrase,
 			key_options,
 			"ndctl update-passphrase <nmem0> [<nmem1>..<nmemN>] [<options>]");
 
@@ -1346,9 +1346,9 @@ int cmd_passphrase_update(int argc, const char **argv, struct ndctl_ctx *ctx)
 	return count >= 0 ? 0 : EXIT_FAILURE;
 }
 
-int cmd_passphrase_setup(int argc, const char **argv, struct ndctl_ctx *ctx)
+int cmd_setup_passphrase(int argc, const char **argv, struct ndctl_ctx *ctx)
 {
-	int count = dimm_action(argc, argv, ctx, action_passphrase_setup,
+	int count = dimm_action(argc, argv, ctx, action_setup_passphrase,
 			key_options,
 			"ndctl setup-passphrase <nmem0> [<nmem1>..<nmemN>] [<options>]");
 
@@ -1357,9 +1357,9 @@ int cmd_passphrase_setup(int argc, const char **argv, struct ndctl_ctx *ctx)
 	return count >= 0 ? 0 : EXIT_FAILURE;
 }
 
-int cmd_passphrase_remove(int argc, const char **argv, void *ctx)
+int cmd_remove_passphrase(int argc, const char **argv, void *ctx)
 {
-	int count = dimm_action(argc, argv, ctx, action_passphrase_remove,
+	int count = dimm_action(argc, argv, ctx, action_remove_passphrase,
 			base_options,
 			"ndctl remove-passphrase <nmem0> [<nmem1>..<nmemN>] [<options>]");
 
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index 04bf56d6..b5c3bf88 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -88,9 +88,9 @@ static struct cmd_struct commands[] = {
 	{ "inject-smart", { cmd_inject_smart } },
 	{ "wait-scrub", { cmd_wait_scrub } },
 	{ "start-scrub", { cmd_start_scrub } },
-	{ "setup-passphrase", { cmd_passphrase_setup } },
-	{ "update-passphrase", { cmd_passphrase_update } },
-	{ "remove-passphrase", { cmd_passphrase_remove } },
+	{ "setup-passphrase", { cmd_setup_passphrase } },
+	{ "update-passphrase", { cmd_update_passphrase } },
+	{ "remove-passphrase", { cmd_remove_passphrase } },
 	{ "freeze-security", { cmd_freeze_security } },
 	{ "sanitize-dimm", { cmd_sanitize_dimm } },
 	{ "load-keys", { cmd_load_keys } },

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
