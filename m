Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ADB11211B81A5
 for <linux-nvdimm@lists.01.org>; Thu, 24 Jan 2019 15:07:33 -0800 (PST)
Subject: [PATCH v10 05/12] ndctl: add support for sanitize dimm
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 24 Jan 2019 16:07:32 -0700
Message-ID: <154837125227.37086.9954775396836100763.stgit@djiang5-desk3.ch.intel.com>
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

Add support to secure erase to libndctl and also command line option
of "sanitize-dimm" for ndctl. This will initiate the request to crypto
erase a DIMM.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ndctl/Makefile.am             |    3 +
 Documentation/ndctl/ndctl-sanitize-dimm.txt |   34 +++++++++++++++
 ndctl/builtin.h                             |    1 
 ndctl/dimm.c                                |   29 +++++++++++++
 ndctl/lib/dimm.c                            |    8 ++++
 ndctl/lib/libndctl.sym                      |    1 
 ndctl/libndctl.h                            |    1 
 ndctl/ndctl.c                               |    1 
 ndctl/util/keys.c                           |   61 +++++++++++++++++++++++++--
 ndctl/util/keys.h                           |    6 +++
 10 files changed, 139 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/ndctl/ndctl-sanitize-dimm.txt

diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
index 0327726b..fa4a1263 100644
--- a/Documentation/ndctl/Makefile.am
+++ b/Documentation/ndctl/Makefile.am
@@ -51,7 +51,8 @@ man1_MANS = \
 	ndctl-setup-passphrase.1 \
 	ndctl-update-passphrase.1 \
 	ndctl-remove-passphrase.1 \
-	ndctl-freeze-security.1
+	ndctl-freeze-security.1 \
+	ndctl-sanitize-dimm.1
 
 CLEANFILES = $(man1_MANS)
 
diff --git a/Documentation/ndctl/ndctl-sanitize-dimm.txt b/Documentation/ndctl/ndctl-sanitize-dimm.txt
new file mode 100644
index 00000000..633498ef
--- /dev/null
+++ b/Documentation/ndctl/ndctl-sanitize-dimm.txt
@@ -0,0 +1,34 @@
+// SPDX-License-Identifier: GPL-2.0
+
+ndctl-sanitize-dimm(1)
+======================
+
+NAME
+----
+ndctl-sanitize-dimm - Perform a cryptographic destruction of the contents of the given NVDIMM(s).
+
+SYNOPSIS
+--------
+[verse]
+'ndctl sanitize-dimm' <nmem0> [<nmem1>..<nmemN>] [<options>]
+
+DESCRIPTION
+-----------
+Search the user key ring for the associated NVDIMM. If not found,
+attempt to load the key blob from the default location. The sanitize
+operation scrambles the data and info-blocks, but it does not touch
+the namespace labels. The user should expect namespaces to revert to raw mode
+after the region is next enabled following the operation. Security is disabled
+for the dimm after operation and ndctl will remove the key from the key ring
+and delete the associated key blob file.
+
+OPTIONS
+-------
+<dimm>::
+include::xable-dimm-options.txt[]
+
+include::../copyright.txt[]
+
+SEE ALSO
+--------
+https://trustedcomputinggroup.org/wp-content/uploads/TCG_SWG_SIIS_Version_1_07_Revision_1_00.pdf [Trusted Computing Group Storage Interface Interactions Specification]
diff --git a/ndctl/builtin.h b/ndctl/builtin.h
index 0f567b9b..a474ec1a 100644
--- a/ndctl/builtin.h
+++ b/ndctl/builtin.h
@@ -36,4 +36,5 @@ int cmd_passphrase_setup(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_passphrase_update(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_passphrase_remove(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_freeze_security(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_sanitize_dimm(int argc, const char **argv, struct ndctl_ctx *ctx);
 #endif /* _NDCTL_BUILTIN_H_ */
diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index 7105c539..e7872f52 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -895,6 +895,24 @@ static int action_security_freeze(struct ndctl_dimm *dimm,
 	return rc;
 }
 
+static int action_sanitize_dimm(struct ndctl_dimm *dimm,
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
+	rc = ndctl_dimm_secure_erase_key(dimm);
+	if (rc < 0)
+		return rc;
+
+	return 0;
+}
+
 static int __action_init(struct ndctl_dimm *dimm,
 		enum ndctl_namespace_version version, int chk_only)
 {
@@ -1293,3 +1311,14 @@ int cmd_freeze_security(int argc, const char **argv, void *ctx)
 			count > 1 ? "s" : "");
 	return count >= 0 ? 0 : EXIT_FAILURE;
 }
+
+int cmd_sanitize_dimm(int argc, const char **argv, void *ctx)
+{
+	int count = dimm_action(argc, argv, ctx, action_sanitize_dimm,
+			base_options,
+			"ndctl sanitize-dimm <nmem0> [<nmem1>..<nmemN>] [<options>]");
+
+	fprintf(stderr, "sanitized %d nmem%s.\n", count >= 0 ? count : 0,
+			count > 1 ? "s" : "");
+	return count >= 0 ? 0 : EXIT_FAILURE;
+}
diff --git a/ndctl/lib/dimm.c b/ndctl/lib/dimm.c
index 0a7eaaef..50650738 100644
--- a/ndctl/lib/dimm.c
+++ b/ndctl/lib/dimm.c
@@ -669,3 +669,11 @@ NDCTL_EXPORT int ndctl_dimm_freeze_security(struct ndctl_dimm *dimm)
 {
 	return write_security(dimm, "freeze");
 }
+
+NDCTL_EXPORT int ndctl_dimm_secure_erase(struct ndctl_dimm *dimm, long key)
+{
+	char buf[SYSFS_ATTR_SIZE];
+
+	sprintf(buf, "erase %ld\n", key);
+	return write_security(dimm, buf);
+}
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index d882939c..dd2dc747 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -394,4 +394,5 @@ global:
 	ndctl_dimm_update_passphrase;
 	ndctl_dimm_disable_passphrase;
 	ndctl_dimm_freeze_security;
+	ndctl_dimm_secure_erase;
 } LIBNDCTL_18;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 7afbca58..83e52b76 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -702,6 +702,7 @@ int ndctl_dimm_update_passphrase(struct ndctl_dimm *dimm,
 		long ckey, long nkey);
 int ndctl_dimm_disable_passphrase(struct ndctl_dimm *dimm, long key);
 int ndctl_dimm_freeze_security(struct ndctl_dimm *dimm);
+int ndctl_dimm_secure_erase(struct ndctl_dimm *dimm, long key);
 
 #define ND_KEY_DESC_SIZE	128
 #define ND_KEY_CMD_SIZE		128
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index 07903981..0274e9b7 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -92,6 +92,7 @@ static struct cmd_struct commands[] = {
 	{ "update-passphrase", { cmd_passphrase_update } },
 	{ "remove-passphrase", { cmd_passphrase_remove } },
 	{ "freeze-security", { cmd_freeze_security } },
+	{ "sanitize-dimm", { cmd_sanitize_dimm } },
 	{ "list", { cmd_list } },
 	{ "monitor", { cmd_monitor } },
 	{ "help", { cmd_help } },
diff --git a/ndctl/util/keys.c b/ndctl/util/keys.c
index daf8e418..4e0ac607 100644
--- a/ndctl/util/keys.c
+++ b/ndctl/util/keys.c
@@ -459,10 +459,9 @@ int ndctl_dimm_update_key(struct ndctl_dimm *dimm, const char *kek)
 	return 0;
 }
 
-int ndctl_dimm_remove_key(struct ndctl_dimm *dimm)
+static key_serial_t check_dimm_key(struct ndctl_dimm *dimm)
 {
 	key_serial_t key;
-	int rc;
 
 	key = dimm_check_key(dimm, false);
 	if (key < 0) {
@@ -473,15 +472,67 @@ int ndctl_dimm_remove_key(struct ndctl_dimm *dimm)
 		}
 	}
 
-	rc = ndctl_dimm_disable_passphrase(dimm, key);
+	return key;
+}
+
+static int run_key_op(struct ndctl_dimm *dimm,
+		key_serial_t key,
+		int (*run_op)(struct ndctl_dimm *, long), const char *name)
+{
+	int rc;
+
+	rc = run_op(dimm, key);
 	if (rc < 0) {
-		fprintf(stderr, "Failed to disable security for %s\n",
+		fprintf(stderr, "Failed %s for %s\n", name,
 				ndctl_dimm_get_devname(dimm));
 		return rc;
 	}
 
+	return 0;
+}
+
+static int discard_key(struct ndctl_dimm *dimm)
+{
+	int rc;
+
 	rc = dimm_remove_key(dimm, false);
-	if (rc < 0)
+	if (rc < 0) {
 		fprintf(stderr, "Unable to cleanup key.\n");
+		return rc;
+	}
 	return 0;
 }
+
+int ndctl_dimm_remove_key(struct ndctl_dimm *dimm)
+{
+	key_serial_t key;
+	int rc;
+
+	key = check_dimm_key(dimm);
+	if (key < 0)
+		return key;
+
+	rc = run_key_op(dimm, key, ndctl_dimm_disable_passphrase,
+			"remove passphrase");
+	if (rc < 0)
+		return rc;
+
+	return discard_key(dimm);
+}
+
+int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm)
+{
+	key_serial_t key;
+	int rc;
+
+	key = check_dimm_key(dimm);
+	if (key < 0)
+		return key;
+
+	rc = run_key_op(dimm, key, ndctl_dimm_secure_erase,
+			"crypto erase");
+	if (rc < 0)
+		return rc;
+
+	return discard_key(dimm);
+}
diff --git a/ndctl/util/keys.h b/ndctl/util/keys.h
index 1ea428ef..9b60d678 100644
--- a/ndctl/util/keys.h
+++ b/ndctl/util/keys.h
@@ -13,6 +13,7 @@ enum ndctl_key_type {
 int ndctl_dimm_setup_key(struct ndctl_dimm *dimm, const char *kek);
 int ndctl_dimm_update_key(struct ndctl_dimm *dimm, const char *kek);
 int ndctl_dimm_remove_key(struct ndctl_dimm *dimm);
+int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm);
 #else
 static inline int ndctl_dimm_setup_key(struct ndctl_dimm *dimm,
 		const char *kek)
@@ -30,6 +31,11 @@ static inline int ndctl_dimm_remove_key(struct ndctl_dimm *dimm)
 {
 	return -EOPNOTSUPP;
 }
+
+static inline int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm)
+{
+	return -EOPNOTSUPP;
+}
 #endif /* ENABLE_KEYUTILS */
 
 #endif

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
