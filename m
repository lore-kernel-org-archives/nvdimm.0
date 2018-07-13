Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1F22720986ABA
 for <linux-nvdimm@lists.01.org>; Fri, 13 Jul 2018 15:45:49 -0700 (PDT)
Subject: [PATCH 2/6] ndctl: add update to security support
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 13 Jul 2018 15:45:42 -0700
Message-ID: <153152194209.6787.15980557450888985938.stgit@djiang5-desk3.ch.intel.com>
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

Add API call for triggering sysfs knob to update the security for a DIMM
in libndctl. Also add the ndctl "update-security" to trigger that as well.
ndctl does not actually handle the passphrase file. It only initiates the
update and expects all the necessary mechanisms are already in place.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ndctl/Makefile.am               |    1 +
 Documentation/ndctl/ndctl-update-security.txt |   21 +++++++++++++++++++++
 builtin.h                                     |    1 +
 ndctl/dimm.c                                  |   22 ++++++++++++++++++++++
 ndctl/lib/dimm.c                              |   20 ++++++++++++++++++++
 ndctl/lib/libndctl.sym                        |    1 +
 ndctl/libndctl.h                              |    1 +
 ndctl/ndctl.c                                 |    1 +
 8 files changed, 68 insertions(+)
 create mode 100644 Documentation/ndctl/ndctl-update-security.txt

diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
index 4fd9636f..02405c44 100644
--- a/Documentation/ndctl/Makefile.am
+++ b/Documentation/ndctl/Makefile.am
@@ -46,6 +46,7 @@ man1_MANS = \
 	ndctl-inject-error.1 \
 	ndctl-inject-smart.1 \
 	ndctl-update-firmware.1 \
+	ndctl-update-security.1 \
 	ndctl-list.1
 
 CLEANFILES = $(man1_MANS)
diff --git a/Documentation/ndctl/ndctl-update-security.txt b/Documentation/ndctl/ndctl-update-security.txt
new file mode 100644
index 00000000..38ca02fa
--- /dev/null
+++ b/Documentation/ndctl/ndctl-update-security.txt
@@ -0,0 +1,21 @@
+// SPDX-License-Identifier: GPL-2.0
+
+ndctl-update-security(1)
+========================
+
+NAME
+----
+ndctl-update-security - enabling or update the security passphrase for an NVDIMM
+
+SYNOPSIS
+--------
+[verse]
+'ndctl update-security' <dimm>
+
+DESCRIPTION
+-----------
+Provide a generic interface for enabling or updating security passphrase for
+NVDIMM. The use of this depends on support from the underlying libndctl, kernel,
+as well as the platform itself.
+
+include::../copyright.txt[]
diff --git a/builtin.h b/builtin.h
index d3cc7239..e6dc5340 100644
--- a/builtin.h
+++ b/builtin.h
@@ -47,4 +47,5 @@ int cmd_bat(int argc, const char **argv, void *ctx);
 #endif
 int cmd_update_firmware(int argc, const char **argv, void *ctx);
 int cmd_inject_smart(int argc, const char **argv, void *ctx);
+int cmd_update_security(int argc, const char **argv, void *ctx);
 #endif /* _NDCTL_BUILTIN_H_ */
diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index 97643a3c..274714d6 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -821,6 +821,18 @@ static int action_update(struct ndctl_dimm *dimm, struct action_context *actx)
 	return rc;
 }
 
+static int action_security_update(struct ndctl_dimm *dimm,
+		struct action_context *actx)
+{
+	int rc;
+
+	rc = ndctl_dimm_set_change_key(dimm);
+	if (rc < 0)
+		error("Failed to update security for %s\n",
+				ndctl_dimm_get_devname(dimm));
+	return rc;
+}
+
 static struct parameters {
 	const char *bus;
 	const char *outfile;
@@ -1178,3 +1190,13 @@ int cmd_update_firmware(int argc, const char **argv, void *ctx)
 			count > 1 ? "s" : "");
 	return count >= 0 ? 0 : EXIT_FAILURE;
 }
+
+int cmd_update_security(int argc, const char **argv, void *ctx)
+{
+	int count = dimm_action(argc, argv, ctx, action_security_update, base_options,
+			"ndctl update-security <nmem0> [<nmem1>..<nmemN>] [<options>]");
+
+	fprintf(stderr, "security updated %d nmem%s.\n", count >= 0 ? count : 0,
+			count > 1 ? "s" : "");
+	return count >= 0 ? 0 : EXIT_FAILURE;
+}
diff --git a/ndctl/lib/dimm.c b/ndctl/lib/dimm.c
index 8ed58559..ca4d439b 100644
--- a/ndctl/lib/dimm.c
+++ b/ndctl/lib/dimm.c
@@ -595,3 +595,23 @@ NDCTL_EXPORT int ndctl_dimm_get_security_state(struct ndctl_dimm *dimm,
 
 	return sysfs_read_attr(ctx, path, state);
 }
+
+static int ndctl_dimm_write_security(struct ndctl_dimm *dimm, const char *cmd)
+{
+	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
+	char *path = dimm->dimm_buf;
+	int len = dimm->buf_len;
+
+	if (snprintf(path, len, "%s/security", dimm->dimm_path) >= len) {
+		err(ctx, "%s: buffer too small!\n",
+				ndctl_dimm_get_devname(dimm));
+		return -ERANGE;
+	}
+
+	return sysfs_write_attr(ctx, path, cmd);
+}
+
+NDCTL_EXPORT int ndctl_dimm_set_change_key(struct ndctl_dimm *dimm)
+{
+	return ndctl_dimm_write_security(dimm, "update");
+}
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 8040d7de..e2a359b8 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -372,4 +372,5 @@ LIBNDCTL_17 {
 global:
 	ndctl_dimm_smart_inject_supported;
 	ndctl_dimm_get_security_state;
+	ndctl_dimm_set_change_key;
 } LIBNDCTL_16;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index d48513ce..663847b6 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -660,6 +660,7 @@ enum ND_FW_STATUS ndctl_cmd_fw_xlat_firmware_status(struct ndctl_cmd *cmd);
 struct ndctl_cmd *ndctl_dimm_cmd_new_ack_shutdown_count(struct ndctl_dimm *dimm);
 int ndctl_dimm_fw_update_supported(struct ndctl_dimm *dimm);
 int ndctl_dimm_get_security_state(struct ndctl_dimm *dimm, char *state);
+int ndctl_dimm_set_change_key(struct ndctl_dimm *dimm);
 
 #ifdef __cplusplus
 } /* extern "C" */
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index 7daadebd..81987e81 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -88,6 +88,7 @@ static struct cmd_struct commands[] = {
 	{ "inject-smart", cmd_inject_smart },
 	{ "wait-scrub", cmd_wait_scrub },
 	{ "start-scrub", cmd_start_scrub },
+	{ "update-security", cmd_update_security },
 	{ "list", cmd_list },
 	{ "help", cmd_help },
 	#ifdef ENABLE_TEST

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
