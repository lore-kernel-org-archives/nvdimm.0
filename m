Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DD33A21102DAE
 for <linux-nvdimm@lists.01.org>; Tue, 28 Aug 2018 15:52:24 -0700 (PDT)
Subject: [PATCH v3 4/6] ndctl: add support for freeze security
From: Dave Jiang <dave.jiang@intel.com>
Date: Tue, 28 Aug 2018 15:52:07 -0700
Message-ID: <153549672736.5723.6409645443443463937.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153549661384.5723.4757814248604794802.stgit@djiang5-desk3.ch.intel.com>
References: <153549661384.5723.4757814248604794802.stgit@djiang5-desk3.ch.intel.com>
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
Cc: dhowells@redhat.com, alison.schofield@intel.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Add support for freeze security to libndctl and also command line option
of "freeze-security" for ndctl. This will lock the ability to make changes
to the NVDIMM security.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ndctl/Makefile.am               |    3 ++-
 Documentation/ndctl/ndctl-freeze-security.txt |   21 +++++++++++++++++++++
 builtin.h                                     |    1 +
 ndctl/dimm.c                                  |   22 ++++++++++++++++++++++
 ndctl/lib/dimm.c                              |    5 +++++
 ndctl/lib/libndctl.sym                        |    1 +
 ndctl/libndctl.h                              |    1 +
 ndctl/ndctl.c                                 |    1 +
 8 files changed, 54 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/ndctl/ndctl-freeze-security.txt

diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
index faeb0d9b..3a761ba0 100644
--- a/Documentation/ndctl/Makefile.am
+++ b/Documentation/ndctl/Makefile.am
@@ -49,7 +49,8 @@ man1_MANS = \
 	ndctl-list.1 \
 	ndctl-monitor.1 \
 	ndctl-update-security.1 \
-	ndctl-disable-security.1
+	ndctl-disable-security.1 \
+	ndctl-freeze-security.1
 
 CLEANFILES = $(man1_MANS)
 
diff --git a/Documentation/ndctl/ndctl-freeze-security.txt b/Documentation/ndctl/ndctl-freeze-security.txt
new file mode 100644
index 00000000..343bb019
--- /dev/null
+++ b/Documentation/ndctl/ndctl-freeze-security.txt
@@ -0,0 +1,21 @@
+// SPDX-License-Identifier: GPL-2.0
+
+ndctl-freeze-security(1)
+========================
+
+NAME
+----
+ndctl-freeze-security - enabling or freeze the security for an NVDIMM
+
+SYNOPSIS
+--------
+[verse]
+'ndctl freeze-security' <dimm>
+
+DESCRIPTION
+-----------
+Provide a generic interface to freeze the security for NVDIMM. The use of this
+depends on support from the underlying libndctl, kernel, as well as the
+platform itself.
+
+include::../copyright.txt[]
diff --git a/builtin.h b/builtin.h
index 39e4e38d..7b970e10 100644
--- a/builtin.h
+++ b/builtin.h
@@ -50,4 +50,5 @@ int cmd_update_firmware(int argc, const char **argv, void *ctx);
 int cmd_inject_smart(int argc, const char **argv, void *ctx);
 int cmd_key_update(int argc, const char **argv, void *ctx);
 int cmd_disable_security(int argc, const char **argv, void *ctx);
+int cmd_freeze_security(int argc, const char **argv, void *ctx);
 #endif /* _NDCTL_BUILTIN_H_ */
diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index 96733ff6..432ead74 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -891,6 +891,18 @@ static int action_security_disable(struct ndctl_dimm *dimm,
 	return rc;
 }
 
+static int action_security_freeze(struct ndctl_dimm *dimm,
+		struct action_context *actx)
+{
+	int rc;
+
+	rc = ndctl_dimm_freeze_security(dimm);
+	if (rc < 0)
+		error("Failed to freeze security for %s\n",
+				ndctl_dimm_get_devname(dimm));
+	return rc;
+}
+
 static int __action_init(struct ndctl_dimm *dimm,
 		enum ndctl_namespace_version version, int chk_only)
 {
@@ -1273,3 +1285,13 @@ int cmd_disable_security(int argc, const char **argv, void *ctx)
 			count > 1 ? "s" : "");
 	return count >= 0 ? 0 : EXIT_FAILURE;
 }
+
+int cmd_freeze_security(int argc, const char **argv, void *ctx)
+{
+	int count = dimm_action(argc, argv, ctx, action_security_freeze, base_options,
+			"ndctl freeze-security <nmem0> [<nmem1>..<nmemN>] [<options>]");
+
+	fprintf(stderr, "security freezed %d nmem%s.\n", count >= 0 ? count : 0,
+			count > 1 ? "s" : "");
+	return count >= 0 ? 0 : EXIT_FAILURE;
+}
diff --git a/ndctl/lib/dimm.c b/ndctl/lib/dimm.c
index 53e99906..b383127c 100644
--- a/ndctl/lib/dimm.c
+++ b/ndctl/lib/dimm.c
@@ -624,3 +624,8 @@ NDCTL_EXPORT int ndctl_dimm_disable_security(struct ndctl_dimm *dimm)
 {
 	return ndctl_dimm_write_security(dimm, "disable");
 }
+
+NDCTL_EXPORT int ndctl_dimm_freeze_security(struct ndctl_dimm *dimm)
+{
+	return ndctl_dimm_write_security(dimm, "freeze");
+}
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 136f4e04..d543088f 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -386,4 +386,5 @@ global:
 	ndctl_dimm_get_current_key;
 	ndctl_dimm_set_change_key;
 	ndctl_dimm_disable_security;
+	ndctl_dimm_freeze_security;
 } LIBNDCTL_17;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index a914cfc3..75364212 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -682,6 +682,7 @@ int ndctl_dimm_add_key(struct ndctl_dimm *dimm, const char *passphrase,
 		int pass_size, key_serial_t *key);
 int ndctl_dimm_get_current_key(struct ndctl_dimm *dimm, key_serial_t *key);
 int ndctl_dimm_disable_security(struct ndctl_dimm *dimm);
+int ndctl_dimm_freeze_security(struct ndctl_dimm *dimm);
 
 #ifdef __cplusplus
 } /* extern "C" */
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index 2dab02d2..7a242aab 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -90,6 +90,7 @@ static struct cmd_struct commands[] = {
 	{ "start-scrub", cmd_start_scrub },
 	{ "update-security", cmd_key_update },
 	{ "disable-security", cmd_disable_security },
+	{ "freeze-security", cmd_freeze_security },
 	{ "list", cmd_list },
 	{ "monitor", cmd_monitor},
 	{ "help", cmd_help },

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
