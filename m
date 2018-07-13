Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0BAE420985980
 for <linux-nvdimm@lists.01.org>; Fri, 13 Jul 2018 15:45:55 -0700 (PDT)
Subject: [PATCH 4/6] ndctl: add support for freeze security
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 13 Jul 2018 15:45:53 -0700
Message-ID: <153152195302.6787.9807448079950596179.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153152170933.6787.1111990895827764695.stgit@djiang5-desk3.ch.intel.com>
References: <153152170933.6787.1111990895827764695.stgit@djiang5-desk3.ch.intel.com>
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

Add support for freeze security to libndctl and also command line option
of "freeze-security" for ndctl. This will lock the ability to make changes
to the NVDIMM security.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ndctl/Makefile.am               |    1 +
 Documentation/ndctl/ndctl-freeze-security.txt |   21 +++++++++++++++++++++
 builtin.h                                     |    1 +
 ndctl/dimm.c                                  |   22 ++++++++++++++++++++++
 ndctl/lib/dimm.c                              |    5 +++++
 ndctl/lib/libndctl.sym                        |    1 +
 ndctl/libndctl.h                              |    1 +
 ndctl/ndctl.c                                 |    1 +
 8 files changed, 53 insertions(+)
 create mode 100644 Documentation/ndctl/ndctl-freeze-security.txt

diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
index b1cb3b5b..98348178 100644
--- a/Documentation/ndctl/Makefile.am
+++ b/Documentation/ndctl/Makefile.am
@@ -48,6 +48,7 @@ man1_MANS = \
 	ndctl-update-firmware.1 \
 	ndctl-update-security.1 \
 	ndctl-disable-security.1 \
+	ndctl-freeze-security.1 \
 	ndctl-list.1
 
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
index e8ba9aee..6e6ae069 100644
--- a/builtin.h
+++ b/builtin.h
@@ -49,4 +49,5 @@ int cmd_update_firmware(int argc, const char **argv, void *ctx);
 int cmd_inject_smart(int argc, const char **argv, void *ctx);
 int cmd_update_security(int argc, const char **argv, void *ctx);
 int cmd_disable_security(int argc, const char **argv, void *ctx);
+int cmd_freeze_security(int argc, const char **argv, void *ctx);
 #endif /* _NDCTL_BUILTIN_H_ */
diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index e64f6717..49097cff 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -845,6 +845,18 @@ static int action_security_disable(struct ndctl_dimm *dimm,
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
 static struct parameters {
 	const char *bus;
 	const char *outfile;
@@ -1222,3 +1234,13 @@ int cmd_disable_security(int argc, const char **argv, void *ctx)
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
index 13c2806c..2ff68daa 100644
--- a/ndctl/lib/dimm.c
+++ b/ndctl/lib/dimm.c
@@ -620,3 +620,8 @@ NDCTL_EXPORT int ndctl_dimm_disable_security(struct ndctl_dimm *dimm)
 {
 	return ndctl_dimm_write_security(dimm, "disable");
 }
+
+NDCTL_EXPORT int ndctl_dimm_freeze_security(struct ndctl_dimm *dimm)
+{
+	return ndctl_dimm_write_security(dimm, "freeze");
+}
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 1a919567..613d9bb2 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -374,4 +374,5 @@ global:
 	ndctl_dimm_get_security_state;
 	ndctl_dimm_set_change_key;
 	ndctl_dimm_disable_security;
+	ndctl_dimm_freeze_security;
 } LIBNDCTL_16;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 1ca6cb18..4615ba09 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -662,6 +662,7 @@ int ndctl_dimm_fw_update_supported(struct ndctl_dimm *dimm);
 int ndctl_dimm_get_security_state(struct ndctl_dimm *dimm, char *state);
 int ndctl_dimm_set_change_key(struct ndctl_dimm *dimm);
 int ndctl_dimm_disable_security(struct ndctl_dimm *dimm);
+int ndctl_dimm_freeze_security(struct ndctl_dimm *dimm);
 
 #ifdef __cplusplus
 } /* extern "C" */
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index eeef41da..5a1a81e4 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -90,6 +90,7 @@ static struct cmd_struct commands[] = {
 	{ "start-scrub", cmd_start_scrub },
 	{ "update-security", cmd_update_security },
 	{ "disable-security", cmd_disable_security },
+	{ "freeze-security", cmd_freeze_security },
 	{ "list", cmd_list },
 	{ "help", cmd_help },
 	#ifdef ENABLE_TEST

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
