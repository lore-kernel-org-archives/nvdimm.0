Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 58F0E21959CB2
 for <linux-nvdimm@lists.01.org>; Mon, 14 Jan 2019 12:06:59 -0800 (PST)
Subject: [PATCH v8 04/12] ndctl: add support for freeze security
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 14 Jan 2019 13:06:58 -0700
Message-ID: <154749641859.63704.12807813922780466193.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154749627829.63704.2987015129166185725.stgit@djiang5-desk3.ch.intel.com>
References: <154749627829.63704.2987015129166185725.stgit@djiang5-desk3.ch.intel.com>
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
To: vishal.l.verma@intel.com, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Add support for freeze security to libndctl and also command line option
of "freeze-security" for ndctl. This will lock the ability to make changes
to the NVDIMM security.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ndctl/Makefile.am               |    3 ++-
 Documentation/ndctl/ndctl-freeze-security.txt |   20 ++++++++++++++++++
 ndctl/builtin.h                               |    1 +
 ndctl/dimm.c                                  |   28 +++++++++++++++++++++++++
 ndctl/lib/dimm.c                              |    5 ++++
 ndctl/lib/libndctl.sym                        |    1 +
 ndctl/libndctl.h                              |    1 +
 ndctl/ndctl.c                                 |    1 +
 8 files changed, 59 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/ndctl/ndctl-freeze-security.txt

diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
index 31570a77..a97f193d 100644
--- a/Documentation/ndctl/Makefile.am
+++ b/Documentation/ndctl/Makefile.am
@@ -50,7 +50,8 @@ man1_MANS = \
 	ndctl-monitor.1 \
 	ndctl-enable-passphrase.1 \
 	ndctl-update-passphrase.1 \
-	ndctl-disable-passphrase.1
+	ndctl-disable-passphrase.1 \
+	ndctl-freeze-security.1
 
 CLEANFILES = $(man1_MANS)
 
diff --git a/Documentation/ndctl/ndctl-freeze-security.txt b/Documentation/ndctl/ndctl-freeze-security.txt
new file mode 100644
index 00000000..4e9d2d61
--- /dev/null
+++ b/Documentation/ndctl/ndctl-freeze-security.txt
@@ -0,0 +1,20 @@
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
+Provide a generic interface to freeze the security for NVDIMM. Once security
+is frozen, no other security operations can succeed until reboot happens.
+
+include::../copyright.txt[]
diff --git a/ndctl/builtin.h b/ndctl/builtin.h
index 821ea690..f7469598 100644
--- a/ndctl/builtin.h
+++ b/ndctl/builtin.h
@@ -35,4 +35,5 @@ int cmd_inject_smart(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_passphrase_setup(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_passphrase_update(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_disable_passphrase(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_freeze_security(int argc, const char **argv, struct ndctl_ctx *ctx);
 #endif /* _NDCTL_BUILTIN_H_ */
diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index 4f0466a1..19301791 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -876,6 +876,24 @@ static int action_passphrase_disable(struct ndctl_dimm *dimm,
 	return ndctl_dimm_disable_key(dimm, param.key_path);
 }
 
+static int action_security_freeze(struct ndctl_dimm *dimm,
+		struct action_context *actx)
+{
+	int rc;
+
+	if (!ndctl_dimm_security_supported(dimm)) {
+		error("%s: security operation not supported\n",
+				ndctl_dimm_get_devname(dimm));
+		return -EOPNOTSUPP;
+	}
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
@@ -1285,3 +1303,13 @@ int cmd_disable_passphrase(int argc, const char **argv, void *ctx)
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
index 076ccbf6..8f0f0486 100644
--- a/ndctl/lib/dimm.c
+++ b/ndctl/lib/dimm.c
@@ -672,3 +672,8 @@ NDCTL_EXPORT int ndctl_dimm_disable_passphrase(struct ndctl_dimm *dimm,
 	sprintf(buf, "disable %ld\n", key);
 	return write_security(dimm, buf);
 }
+
+NDCTL_EXPORT int ndctl_dimm_freeze_security(struct ndctl_dimm *dimm)
+{
+	return write_security(dimm, "freeze");
+}
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 90038e75..a1c56060 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -395,4 +395,5 @@ global:
 	ndctl_dimm_update_passphrase;
 	ndctl_dimm_disable_passphrase;
 	ndctl_dimm_disable_key;
+	ndctl_dimm_freeze_security;
 } LIBNDCTL_18;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index b1192960..3862bbfd 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -702,6 +702,7 @@ bool ndctl_dimm_security_supported(struct ndctl_dimm *dimm);
 int ndctl_dimm_update_passphrase(struct ndctl_dimm *dimm,
 		long ckey, long nkey);
 int ndctl_dimm_disable_passphrase(struct ndctl_dimm *dimm, long key);
+int ndctl_dimm_freeze_security(struct ndctl_dimm *dimm);
 
 enum ndctl_key_type {
 	ND_USER_KEY,
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index 21f1b834..da8dce11 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -91,6 +91,7 @@ static struct cmd_struct commands[] = {
 	{ "enable-passphrase", { cmd_passphrase_setup } },
 	{ "update-passphrase", { cmd_passphrase_update } },
 	{ "disable-passphrase", { cmd_disable_passphrase } },
+	{ "freeze-security", { cmd_freeze_security } },
 	{ "list", { cmd_list } },
 	{ "monitor", { cmd_monitor } },
 	{ "help", { cmd_help } },

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
