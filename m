Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E0AF7211B81A5
 for <linux-nvdimm@lists.01.org>; Thu, 24 Jan 2019 15:07:27 -0800 (PST)
Subject: [PATCH v10 04/12] ndctl: add support for freeze security
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 24 Jan 2019 16:07:26 -0700
Message-ID: <154837124676.37086.14569414098343817192.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154837084784.37086.4597479371733088393.stgit@djiang5-desk3.ch.intel.com>
References: <154837084784.37086.4597479371733088393.stgit@djiang5-desk3.ch.intel.com>
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
 Documentation/ndctl/Makefile.am               |    3 +
 Documentation/ndctl/ndctl-freeze-security.txt |   58 +++++++++++++++++++++++++
 ndctl/builtin.h                               |    1 
 ndctl/dimm.c                                  |   28 ++++++++++++
 ndctl/lib/dimm.c                              |    5 ++
 ndctl/lib/libndctl.sym                        |    1 
 ndctl/libndctl.h                              |    1 
 ndctl/ndctl.c                                 |    1 
 8 files changed, 97 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/ndctl/ndctl-freeze-security.txt

diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
index 3b543216..0327726b 100644
--- a/Documentation/ndctl/Makefile.am
+++ b/Documentation/ndctl/Makefile.am
@@ -50,7 +50,8 @@ man1_MANS = \
 	ndctl-monitor.1 \
 	ndctl-setup-passphrase.1 \
 	ndctl-update-passphrase.1 \
-	ndctl-remove-passphrase.1
+	ndctl-remove-passphrase.1 \
+	ndctl-freeze-security.1
 
 CLEANFILES = $(man1_MANS)
 
diff --git a/Documentation/ndctl/ndctl-freeze-security.txt b/Documentation/ndctl/ndctl-freeze-security.txt
new file mode 100644
index 00000000..d14b8a39
--- /dev/null
+++ b/Documentation/ndctl/ndctl-freeze-security.txt
@@ -0,0 +1,58 @@
+// SPDX-License-Identifier: GPL-2.0
+
+ndctl-freeze-security(1)
+========================
+
+NAME
+----
+ndctl-freeze-security - Set the given DIMM(s) to reject future security operations
+
+SYNOPSIS
+--------
+[verse]
+'ndctl freeze-security' <nmem0> [<nmem1>..<nmemN>] [<options>]
+
+DESCRIPTION
+-----------
+Prevent any further security operations on the given DIMMs until the
+next reboot. This is used in scenarios where the administrator has
+taken all expected security actions for the current boot and wants the
+DIMM to enforce / lock the current state.
+
+EXAMPLES
+--------
+
+[verse]
+ndctl list -d nmem0
+[
+  {
+    "dev":"nmem0",
+    "id":"cdab-0a-07e0-ffffffff",
+    "handle":0,
+    "phys_id":0,
+    "security":"unlocked"
+  }
+]
+
+[verse]
+ndctl freeze-security  nmem0
+security freezed 1 nmem.
+
+[verse]
+ndctl list -d nmem0
+[
+  {
+    "dev":"nmem0",
+    "id":"cdab-0a-07e0-ffffffff",
+    "handle":0,
+    "phys_id":0,
+    "security":"frozen"
+  }
+]
+
+OPTIONS
+-------
+<dimm>::
+include::xable-dimm-options.txt[]
+
+include::../copyright.txt[]
diff --git a/ndctl/builtin.h b/ndctl/builtin.h
index 9deb175b..0f567b9b 100644
--- a/ndctl/builtin.h
+++ b/ndctl/builtin.h
@@ -35,4 +35,5 @@ int cmd_inject_smart(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_passphrase_setup(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_passphrase_update(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_passphrase_remove(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_freeze_security(int argc, const char **argv, struct ndctl_ctx *ctx);
 #endif /* _NDCTL_BUILTIN_H_ */
diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index 045f9408..7105c539 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -877,6 +877,24 @@ static int action_passphrase_remove(struct ndctl_dimm *dimm,
 	return ndctl_dimm_remove_key(dimm);
 }
 
+static int action_security_freeze(struct ndctl_dimm *dimm,
+		struct action_context *actx)
+{
+	int rc;
+
+	if (ndctl_dimm_get_security(dimm) < 0) {
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
@@ -1265,3 +1283,13 @@ int cmd_passphrase_remove(int argc, const char **argv, void *ctx)
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
index a944c9af..0a7eaaef 100644
--- a/ndctl/lib/dimm.c
+++ b/ndctl/lib/dimm.c
@@ -664,3 +664,8 @@ NDCTL_EXPORT int ndctl_dimm_disable_passphrase(struct ndctl_dimm *dimm,
 	sprintf(buf, "disable %ld\n", key);
 	return write_security(dimm, buf);
 }
+
+NDCTL_EXPORT int ndctl_dimm_freeze_security(struct ndctl_dimm *dimm)
+{
+	return write_security(dimm, "freeze");
+}
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 79b7f9e1..d882939c 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -393,4 +393,5 @@ global:
 	ndctl_dimm_get_security;
 	ndctl_dimm_update_passphrase;
 	ndctl_dimm_disable_passphrase;
+	ndctl_dimm_freeze_security;
 } LIBNDCTL_18;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 0253abf5..7afbca58 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -701,6 +701,7 @@ enum ndctl_security_state ndctl_dimm_get_security(struct ndctl_dimm *dimm);
 int ndctl_dimm_update_passphrase(struct ndctl_dimm *dimm,
 		long ckey, long nkey);
 int ndctl_dimm_disable_passphrase(struct ndctl_dimm *dimm, long key);
+int ndctl_dimm_freeze_security(struct ndctl_dimm *dimm);
 
 #define ND_KEY_DESC_SIZE	128
 #define ND_KEY_CMD_SIZE		128
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index 9f4ab234..07903981 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -91,6 +91,7 @@ static struct cmd_struct commands[] = {
 	{ "setup-passphrase", { cmd_passphrase_setup } },
 	{ "update-passphrase", { cmd_passphrase_update } },
 	{ "remove-passphrase", { cmd_passphrase_remove } },
+	{ "freeze-security", { cmd_freeze_security } },
 	{ "list", { cmd_list } },
 	{ "monitor", { cmd_monitor } },
 	{ "help", { cmd_help } },

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
