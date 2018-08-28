Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A9F8221102DAE
 for <linux-nvdimm@lists.01.org>; Tue, 28 Aug 2018 15:52:02 -0700 (PDT)
Subject: [PATCH v3 3/6] ndctl: add disable security support
From: Dave Jiang <dave.jiang@intel.com>
Date: Tue, 28 Aug 2018 15:52:02 -0700
Message-ID: <153549672202.5723.1082050945219792209.stgit@djiang5-desk3.ch.intel.com>
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

Add support for disable security to libndctl and also command line option
of "disable-security" for ndctl. This provides a way to disable security
on the nvdimm. ndctl does not handle the actual processing of the
passphrase. It only starts the request.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ndctl/Makefile.am                |    3 ++-
 Documentation/ndctl/ndctl-disable-security.txt |   21 +++++++++++++++++++++
 builtin.h                                      |    1 +
 ndctl/dimm.c                                   |   22 ++++++++++++++++++++++
 ndctl/lib/dimm.c                               |    5 +++++
 ndctl/lib/libndctl.sym                         |    1 +
 ndctl/libndctl.h                               |    1 +
 ndctl/ndctl.c                                  |    1 +
 8 files changed, 54 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/ndctl/ndctl-disable-security.txt

diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
index 2c064c3a..faeb0d9b 100644
--- a/Documentation/ndctl/Makefile.am
+++ b/Documentation/ndctl/Makefile.am
@@ -48,7 +48,8 @@ man1_MANS = \
 	ndctl-update-firmware.1 \
 	ndctl-list.1 \
 	ndctl-monitor.1 \
-	ndctl-update-security.1
+	ndctl-update-security.1 \
+	ndctl-disable-security.1
 
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
index 37404c79..39e4e38d 100644
--- a/builtin.h
+++ b/builtin.h
@@ -49,4 +49,5 @@ int cmd_bat(int argc, const char **argv, void *ctx);
 int cmd_update_firmware(int argc, const char **argv, void *ctx);
 int cmd_inject_smart(int argc, const char **argv, void *ctx);
 int cmd_key_update(int argc, const char **argv, void *ctx);
+int cmd_disable_security(int argc, const char **argv, void *ctx);
 #endif /* _NDCTL_BUILTIN_H_ */
diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index 48d366c6..96733ff6 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -879,6 +879,18 @@ static int action_key(struct ndctl_dimm *dimm,
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
 static int __action_init(struct ndctl_dimm *dimm,
 		enum ndctl_namespace_version version, int chk_only)
 {
@@ -1251,3 +1263,13 @@ int cmd_key_update(int argc, const char **argv, void *ctx)
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
index 57bbf01a..53e99906 100644
--- a/ndctl/lib/dimm.c
+++ b/ndctl/lib/dimm.c
@@ -619,3 +619,8 @@ NDCTL_EXPORT int ndctl_dimm_set_change_key(struct ndctl_dimm *dimm,
 	sprintf(buf, "update:%d:%d\n", ckey, nkey);
 	return ndctl_dimm_write_security(dimm, buf);
 }
+
+NDCTL_EXPORT int ndctl_dimm_disable_security(struct ndctl_dimm *dimm)
+{
+	return ndctl_dimm_write_security(dimm, "disable");
+}
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index d4764450..136f4e04 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -385,4 +385,5 @@ global:
 	ndctl_dimm_add_key;
 	ndctl_dimm_get_current_key;
 	ndctl_dimm_set_change_key;
+	ndctl_dimm_disable_security;
 } LIBNDCTL_17;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index f845b11b..a914cfc3 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -681,6 +681,7 @@ int ndctl_dimm_get_key_payload(struct ndctl_dimm *dimm, char *pass, int *psize);
 int ndctl_dimm_add_key(struct ndctl_dimm *dimm, const char *passphrase,
 		int pass_size, key_serial_t *key);
 int ndctl_dimm_get_current_key(struct ndctl_dimm *dimm, key_serial_t *key);
+int ndctl_dimm_disable_security(struct ndctl_dimm *dimm);
 
 #ifdef __cplusplus
 } /* extern "C" */
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index c7096dfd..2dab02d2 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -89,6 +89,7 @@ static struct cmd_struct commands[] = {
 	{ "wait-scrub", cmd_wait_scrub },
 	{ "start-scrub", cmd_start_scrub },
 	{ "update-security", cmd_key_update },
+	{ "disable-security", cmd_disable_security },
 	{ "list", cmd_list },
 	{ "monitor", cmd_monitor},
 	{ "help", cmd_help },

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
