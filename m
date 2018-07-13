Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6725920985980
 for <linux-nvdimm@lists.01.org>; Fri, 13 Jul 2018 15:45:48 -0700 (PDT)
Subject: [PATCH 3/6] ndctl: add disable security support
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 13 Jul 2018 15:45:47 -0700
Message-ID: <153152194755.6787.15222608871888222137.stgit@djiang5-desk3.ch.intel.com>
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

Add support for disable security to libndctl and also command line option
of "disable-security" for ndctl. This provides a way to disable security
on the nvdimm. ndctl does not handle the actual processing of the
passphrase. It only starts the request.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ndctl/Makefile.am                |    1 +
 Documentation/ndctl/ndctl-disable-security.txt |   21 +++++++++++++++++++++
 builtin.h                                      |    1 +
 ndctl/dimm.c                                   |   22 ++++++++++++++++++++++
 ndctl/lib/dimm.c                               |    5 +++++
 ndctl/lib/libndctl.sym                         |    1 +
 ndctl/libndctl.h                               |    1 +
 ndctl/ndctl.c                                  |    1 +
 8 files changed, 53 insertions(+)
 create mode 100644 Documentation/ndctl/ndctl-disable-security.txt

diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
index 02405c44..b1cb3b5b 100644
--- a/Documentation/ndctl/Makefile.am
+++ b/Documentation/ndctl/Makefile.am
@@ -47,6 +47,7 @@ man1_MANS = \
 	ndctl-inject-smart.1 \
 	ndctl-update-firmware.1 \
 	ndctl-update-security.1 \
+	ndctl-disable-security.1 \
 	ndctl-list.1
 
 CLEANFILES = $(man1_MANS)
diff --git a/Documentation/ndctl/ndctl-disable-security.txt b/Documentation/ndctl/ndctl-disable-security.txt
new file mode 100644
index 00000000..651f8d03
--- /dev/null
+++ b/Documentation/ndctl/ndctl-disable-security.txt
@@ -0,0 +1,21 @@
+// SPDX-License-Identifier: GPL-2.0
+
+ndctl-disable-security(1)
+========================
+
+NAME
+----
+ndctl-disable-security - enabling or disable security for an NVDIMM
+
+SYNOPSIS
+--------
+[verse]
+'ndctl disable-security' <dimm>
+
+DESCRIPTION
+-----------
+Provide a generic interface for disabling security for NVDIMM. The use of this
+depends on support from the underlying libndctl, kernel, as well as the
+platform itself.
+
+include::../copyright.txt[]
diff --git a/builtin.h b/builtin.h
index e6dc5340..e8ba9aee 100644
--- a/builtin.h
+++ b/builtin.h
@@ -48,4 +48,5 @@ int cmd_bat(int argc, const char **argv, void *ctx);
 int cmd_update_firmware(int argc, const char **argv, void *ctx);
 int cmd_inject_smart(int argc, const char **argv, void *ctx);
 int cmd_update_security(int argc, const char **argv, void *ctx);
+int cmd_disable_security(int argc, const char **argv, void *ctx);
 #endif /* _NDCTL_BUILTIN_H_ */
diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index 274714d6..e64f6717 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -833,6 +833,18 @@ static int action_security_update(struct ndctl_dimm *dimm,
 	return rc;
 }
 
+static int action_security_disable(struct ndctl_dimm *dimm,
+		struct action_context *actx)
+{
+	int rc;
+
+	rc = ndctl_dimm_disable_security(dimm);
+	if (rc < 0)
+		error("Failed to disable security for %s\n",
+				ndctl_dimm_get_devname(dimm));
+	return rc;
+}
+
 static struct parameters {
 	const char *bus;
 	const char *outfile;
@@ -1200,3 +1212,13 @@ int cmd_update_security(int argc, const char **argv, void *ctx)
 			count > 1 ? "s" : "");
 	return count >= 0 ? 0 : EXIT_FAILURE;
 }
+
+int cmd_disable_security(int argc, const char **argv, void *ctx)
+{
+	int count = dimm_action(argc, argv, ctx, action_security_disable, base_options,
+			"ndctl disable-security <nmem0> [<nmem1>..<nmemN>] [<options>]");
+
+	fprintf(stderr, "security disabled %d nmem%s.\n", count >= 0 ? count : 0,
+			count > 1 ? "s" : "");
+	return count >= 0 ? 0 : EXIT_FAILURE;
+}
diff --git a/ndctl/lib/dimm.c b/ndctl/lib/dimm.c
index ca4d439b..13c2806c 100644
--- a/ndctl/lib/dimm.c
+++ b/ndctl/lib/dimm.c
@@ -615,3 +615,8 @@ NDCTL_EXPORT int ndctl_dimm_set_change_key(struct ndctl_dimm *dimm)
 {
 	return ndctl_dimm_write_security(dimm, "update");
 }
+
+NDCTL_EXPORT int ndctl_dimm_disable_security(struct ndctl_dimm *dimm)
+{
+	return ndctl_dimm_write_security(dimm, "disable");
+}
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index e2a359b8..1a919567 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -373,4 +373,5 @@ global:
 	ndctl_dimm_smart_inject_supported;
 	ndctl_dimm_get_security_state;
 	ndctl_dimm_set_change_key;
+	ndctl_dimm_disable_security;
 } LIBNDCTL_16;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 663847b6..1ca6cb18 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -661,6 +661,7 @@ struct ndctl_cmd *ndctl_dimm_cmd_new_ack_shutdown_count(struct ndctl_dimm *dimm)
 int ndctl_dimm_fw_update_supported(struct ndctl_dimm *dimm);
 int ndctl_dimm_get_security_state(struct ndctl_dimm *dimm, char *state);
 int ndctl_dimm_set_change_key(struct ndctl_dimm *dimm);
+int ndctl_dimm_disable_security(struct ndctl_dimm *dimm);
 
 #ifdef __cplusplus
 } /* extern "C" */
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index 81987e81..eeef41da 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -89,6 +89,7 @@ static struct cmd_struct commands[] = {
 	{ "wait-scrub", cmd_wait_scrub },
 	{ "start-scrub", cmd_start_scrub },
 	{ "update-security", cmd_update_security },
+	{ "disable-security", cmd_disable_security },
 	{ "list", cmd_list },
 	{ "help", cmd_help },
 	#ifdef ENABLE_TEST

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
