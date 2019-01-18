Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7524D211B509C
 for <linux-nvdimm@lists.01.org>; Thu, 17 Jan 2019 18:38:55 -0800 (PST)
Subject: [PATCH v9 06/13] ndctl: add support for sanitize dimm
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 17 Jan 2019 19:38:54 -0700
Message-ID: <154777913484.42557.3265935108352455334.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154777861562.42557.12388414625709189905.stgit@djiang5-desk3.ch.intel.com>
References: <154777861562.42557.12388414625709189905.stgit@djiang5-desk3.ch.intel.com>
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
 Documentation/ndctl/ndctl-sanitize-dimm.txt |   30 +++++++++++++
 ndctl/builtin.h                             |    1 
 ndctl/dimm.c                                |   29 ++++++++++++
 ndctl/lib/dimm.c                            |    8 +++
 ndctl/lib/keys.c                            |   63 +++++++++++++++++++++++++--
 ndctl/lib/libndctl.sym                      |    2 +
 ndctl/libndctl.h                            |    7 +++
 ndctl/ndctl.c                               |    1 
 9 files changed, 138 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/ndctl/ndctl-sanitize-dimm.txt

diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
index f4230ead..2e535940 100644
--- a/Documentation/ndctl/Makefile.am
+++ b/Documentation/ndctl/Makefile.am
@@ -52,7 +52,8 @@ man1_MANS = \
 	ndctl-setup-passphrase.1 \
 	ndctl-update-passphrase.1 \
 	ndctl-disable-passphrase.1 \
-	ndctl-freeze-security.1
+	ndctl-freeze-security.1 \
+	ndctl-sanitize-dimm.1
 
 CLEANFILES = $(man1_MANS)
 
diff --git a/Documentation/ndctl/ndctl-sanitize-dimm.txt b/Documentation/ndctl/ndctl-sanitize-dimm.txt
new file mode 100644
index 00000000..f95be28f
--- /dev/null
+++ b/Documentation/ndctl/ndctl-sanitize-dimm.txt
@@ -0,0 +1,30 @@
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
+attempt to load the key blob from the default location. After disabling
+the passphrase, remove the key and the key blob.
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
index 8434766d..3d8f4ce7 100644
--- a/ndctl/builtin.h
+++ b/ndctl/builtin.h
@@ -37,4 +37,5 @@ int cmd_passphrase_setup(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_passphrase_update(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_passphrase_remove(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_freeze_security(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_sanitize_dimm(int argc, const char **argv, struct ndctl_ctx *ctx);
 #endif /* _NDCTL_BUILTIN_H_ */
diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index 3222def6..c346b7fb 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -890,6 +890,24 @@ static int action_security_freeze(struct ndctl_dimm *dimm,
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
@@ -1278,3 +1296,14 @@ int cmd_freeze_security(int argc, const char **argv, void *ctx)
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
diff --git a/ndctl/lib/keys.c b/ndctl/lib/keys.c
index fe618870..5353bdc4 100644
--- a/ndctl/lib/keys.c
+++ b/ndctl/lib/keys.c
@@ -387,11 +387,10 @@ NDCTL_EXPORT int ndctl_dimm_update_key(struct ndctl_dimm *dimm)
 	return 0;
 }
 
-NDCTL_EXPORT int ndctl_dimm_remove_key(struct ndctl_dimm *dimm)
+static key_serial_t check_dimm_key(struct ndctl_dimm *dimm)
 {
 	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
 	key_serial_t key;
-	int rc;
 
 	key = dimm_check_key(dimm, false);
 	if (key < 0) {
@@ -402,15 +401,69 @@ NDCTL_EXPORT int ndctl_dimm_remove_key(struct ndctl_dimm *dimm)
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
+	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
+	int rc;
+
+	rc = run_op(dimm, key);
 	if (rc < 0) {
-		err(ctx, "Failed to disable security for %s\n",
+		err(ctx, "Failed %s for %s\n", name,
 				ndctl_dimm_get_devname(dimm));
 		return rc;
 	}
 
+	return 0;
+}
+
+static int discard_key(struct ndctl_dimm *dimm)
+{
+	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
+	int rc;
+
 	rc = dimm_remove_key(dimm, false);
-	if (rc < 0)
+	if (rc < 0) {
 		err(ctx, "Unable to cleanup key.\n");
+		return rc;
+	}
 	return 0;
 }
+
+NDCTL_EXPORT int ndctl_dimm_remove_key(struct ndctl_dimm *dimm)
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
+NDCTL_EXPORT int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm)
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
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index dfcf4977..f4b487d4 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -398,4 +398,6 @@ global:
 	ndctl_dimm_disable_passphrase;
 	ndctl_dimm_remove_key;
 	ndctl_dimm_freeze_security;
+	ndctl_dimm_secure_erase;
+	ndctl_dimm_secure_erase_key;
 } LIBNDCTL_18;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 839d39f1..05c39e8e 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -705,6 +705,7 @@ int ndctl_dimm_update_passphrase(struct ndctl_dimm *dimm,
 		long ckey, long nkey);
 int ndctl_dimm_disable_passphrase(struct ndctl_dimm *dimm, long key);
 int ndctl_dimm_freeze_security(struct ndctl_dimm *dimm);
+int ndctl_dimm_secure_erase(struct ndctl_dimm *dimm, long key);
 
 enum ndctl_key_type {
 	ND_USER_KEY,
@@ -715,6 +716,7 @@ enum ndctl_key_type {
 int ndctl_dimm_enable_key(struct ndctl_dimm *dimm);
 int ndctl_dimm_update_key(struct ndctl_dimm *dimm);
 int ndctl_dimm_remove_key(struct ndctl_dimm *dimm);
+int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm);
 #else
 static inline int ndctl_dimm_enable_key(struct ndctl_dimm *dimm)
 {
@@ -730,6 +732,11 @@ static inline int ndctl_dimm_remove_key(struct ndctl_dimm *dimm)
 {
 	return -EOPNOTSUPP;
 }
+
+static inline int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 #define ND_KEY_DESC_SIZE	128
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index d3b47e26..283ccc33 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -92,6 +92,7 @@ static struct cmd_struct commands[] = {
 	{ "update-passphrase", { cmd_passphrase_update } },
 	{ "remove-passphrase", { cmd_passphrase_remove } },
 	{ "freeze-security", { cmd_freeze_security } },
+	{ "sanitize-dimm", { cmd_sanitize_dimm } },
 	{ "list", { cmd_list } },
 	{ "monitor", { cmd_monitor } },
 	{ "install-encrypt-key", { cmd_install_kek } },

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
