Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6CE14211A4593
 for <linux-nvdimm@lists.01.org>; Fri, 14 Dec 2018 13:09:31 -0800 (PST)
Subject: [PATCH v6 05/12] ndctl: add support for sanitize dimm
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 14 Dec 2018 14:09:30 -0700
Message-ID: <154482177042.65434.5169490783888782262.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154482154540.65434.14399161818571651882.stgit@djiang5-desk3.ch.intel.com>
References: <154482154540.65434.14399161818571651882.stgit@djiang5-desk3.ch.intel.com>
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
To: "vishal.l.verma."@intel.com, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Add support to secure erase to libndctl and also command line option
of "sanitize-dimm" for ndctl. This will initiate the request to crypto
erase a DIMM.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ndctl/Makefile.am             |    3 +-
 Documentation/ndctl/ndctl-sanitize-dimm.txt |   32 +++++++++++++++++
 builtin.h                                   |    1 +
 ndctl/dimm.c                                |   51 +++++++++++++++++++++++++++
 ndctl/lib/dimm.c                            |    8 ++++
 ndctl/lib/keys.c                            |   19 ++++++++--
 ndctl/lib/libndctl.sym                      |    2 +
 ndctl/libndctl.h                            |    7 ++++
 ndctl/ndctl.c                               |    1 +
 9 files changed, 120 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/ndctl/ndctl-sanitize-dimm.txt

diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
index a97f193d..bbea9674 100644
--- a/Documentation/ndctl/Makefile.am
+++ b/Documentation/ndctl/Makefile.am
@@ -51,7 +51,8 @@ man1_MANS = \
 	ndctl-enable-passphrase.1 \
 	ndctl-update-passphrase.1 \
 	ndctl-disable-passphrase.1 \
-	ndctl-freeze-security.1
+	ndctl-freeze-security.1 \
+	ndctl-sanitize-dimm.1
 
 CLEANFILES = $(man1_MANS)
 
diff --git a/Documentation/ndctl/ndctl-sanitize-dimm.txt b/Documentation/ndctl/ndctl-sanitize-dimm.txt
new file mode 100644
index 00000000..a6802d30
--- /dev/null
+++ b/Documentation/ndctl/ndctl-sanitize-dimm.txt
@@ -0,0 +1,32 @@
+// SPDX-License-Identifier: GPL-2.0
+
+ndctl-sanitize-dimm(1)
+======================
+
+NAME
+----
+ndctl-sanitize-dimm - sanitize the data on the NVDIMM
+
+SYNOPSIS
+--------
+[verse]
+'ndctl sanitize' <dimm> [<options>]
+
+DESCRIPTION
+-----------
+Provide a generic interface to crypto erase a NVDIMM.
+Ndctl will search the user key ring for the associated DIMM. If no key is
+found, it will attempt to load the key blob from the expected location. Ndctl
+will remove the key and the key blob once security is disabled.
+
+OPTIONS
+-------
+<dimm>::
+include::xable-dimm-options.txt[]
+
+-c::
+--crypto-erase::
+	Replaces encryption keys and securely erases the data. This does not
+	change label data. This is the default sanitize method.
+
+include::../copyright.txt[]
diff --git a/builtin.h b/builtin.h
index 827295da..db0f2858 100644
--- a/builtin.h
+++ b/builtin.h
@@ -52,4 +52,5 @@ int cmd_passphrase_setup(int argc, const char **argv, void *ctx);
 int cmd_passphrase_update(int argc, const char **argv, void *ctx);
 int cmd_disable_passphrase(int argc, const char **argv, void *ctx);
 int cmd_freeze_security(int argc, const char **argv, void *ctx);
+int cmd_sanitize_dimm(int argc, const char **argv, void *ctx);
 #endif /* _NDCTL_BUILTIN_H_ */
diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index 6476b6e5..ae674f78 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -46,6 +46,7 @@ static struct parameters {
 	const char *infile;
 	const char *labelversion;
 	const char *master_key;
+	bool crypto_erase;
 	bool force;
 	bool json;
 	bool verbose;
@@ -891,6 +892,35 @@ static int action_security_freeze(struct ndctl_dimm *dimm,
 	return rc;
 }
 
+static int action_sanitize_dimm(struct ndctl_dimm *dimm,
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
+	/*
+	 * Setting crypto erase to be default. The other method will be
+	 * overwrite.
+	 */
+	if (!param.crypto_erase) {
+		param.crypto_erase = true;
+		printf("No santize method passed in, default to crypto-erase\n");
+	}
+
+	if (param.crypto_erase) {
+		rc = ndctl_dimm_secure_erase_key(dimm);
+		if (rc < 0)
+			return rc;
+	}
+
+	return 0;
+}
+
 static int __action_init(struct ndctl_dimm *dimm,
 		enum ndctl_namespace_version version, int chk_only)
 {
@@ -984,6 +1014,10 @@ OPT_STRING('V', "label-version", &param.labelversion, "version-number", \
 OPT_STRING('m', "master-key", &param.master_key, "<key_type>:<key_name>", \
 		"master key for security")
 
+#define SANITIZE_OPTIONS() \
+OPT_BOOLEAN('c', "crypto-erase", &param.crypto_erase, \
+		"crypto erase a dimm")
+
 static const struct option read_options[] = {
 	BASE_OPTIONS(),
 	READ_OPTIONS(),
@@ -1019,6 +1053,12 @@ static const struct option key_options[] = {
 	OPT_END(),
 };
 
+static const struct option sanitize_options[] = {
+	BASE_OPTIONS(),
+	SANITIZE_OPTIONS(),
+	OPT_END(),
+};
+
 static int dimm_action(int argc, const char **argv, void *ctx,
 		int (*action)(struct ndctl_dimm *dimm, struct action_context *actx),
 		const struct option *options, const char *usage)
@@ -1295,3 +1335,14 @@ int cmd_freeze_security(int argc, const char **argv, void *ctx)
 			count > 1 ? "s" : "");
 	return count >= 0 ? 0 : EXIT_FAILURE;
 }
+
+int cmd_sanitize_dimm(int argc, const char **argv, void *ctx)
+{
+	int count = dimm_action(argc, argv, ctx, action_sanitize_dimm,
+			sanitize_options,
+			"ndctl sanitize-dimm <nmem0> [<nmem1>..<nmemN>] [<options>]");
+
+	fprintf(stderr, "sanitized %d nmem%s.\n", count >= 0 ? count : 0,
+			count > 1 ? "s" : "");
+	return count >= 0 ? 0 : EXIT_FAILURE;
+}
diff --git a/ndctl/lib/dimm.c b/ndctl/lib/dimm.c
index 227c7124..6da29c1e 100644
--- a/ndctl/lib/dimm.c
+++ b/ndctl/lib/dimm.c
@@ -673,3 +673,11 @@ NDCTL_EXPORT int ndctl_dimm_freeze_security(struct ndctl_dimm *dimm)
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
index 779e82af..130c29ed 100644
--- a/ndctl/lib/keys.c
+++ b/ndctl/lib/keys.c
@@ -388,7 +388,8 @@ NDCTL_EXPORT int ndctl_dimm_update_key(struct ndctl_dimm *dimm,
 	return 0;
 }
 
-NDCTL_EXPORT int ndctl_dimm_disable_key(struct ndctl_dimm *dimm)
+static int check_key_run_and_discard(struct ndctl_dimm *dimm,
+		int (*run_op)(struct ndctl_dimm *, long), const char *name)
 {
 	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
 	key_serial_t key;
@@ -403,9 +404,9 @@ NDCTL_EXPORT int ndctl_dimm_disable_key(struct ndctl_dimm *dimm)
 		}
 	}
 
-	rc = ndctl_dimm_disable_passphrase(dimm, key);
+	rc = run_op(dimm, key);
 	if (rc < 0) {
-		err(ctx, "Failed to disable security for %s\n",
+		err(ctx, "Failed %s for %s\n", name,
 				ndctl_dimm_get_devname(dimm));
 		return rc;
 	}
@@ -415,3 +416,15 @@ NDCTL_EXPORT int ndctl_dimm_disable_key(struct ndctl_dimm *dimm)
 		err(ctx, "Unable to cleanup key.\n");
 	return 0;
 }
+
+NDCTL_EXPORT int ndctl_dimm_disable_key(struct ndctl_dimm *dimm)
+{
+	return check_key_run_and_discard(dimm, ndctl_dimm_disable_passphrase,
+			"disable passphrase");
+}
+
+NDCTL_EXPORT int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm)
+{
+	return check_key_run_and_discard(dimm, ndctl_dimm_secure_erase,
+			"crypto erase");
+}
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index a1c56060..0e3aa5d9 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -396,4 +396,6 @@ global:
 	ndctl_dimm_disable_passphrase;
 	ndctl_dimm_disable_key;
 	ndctl_dimm_freeze_security;
+	ndctl_dimm_secure_erase;
+	ndctl_dimm_secure_erase_key;
 } LIBNDCTL_18;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 7bb7132c..19053a20 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -704,6 +704,7 @@ int ndctl_dimm_update_passphrase(struct ndctl_dimm *dimm,
 		long ckey, long nkey);
 int ndctl_dimm_disable_passphrase(struct ndctl_dimm *dimm, long key);
 int ndctl_dimm_freeze_security(struct ndctl_dimm *dimm);
+int ndctl_dimm_secure_erase(struct ndctl_dimm *dimm, long key);
 
 enum ndctl_key_type {
 	ND_USER_KEY,
@@ -714,6 +715,7 @@ enum ndctl_key_type {
 int ndctl_dimm_enable_key(struct ndctl_dimm *dimm, const char *master);
 int ndctl_dimm_update_key(struct ndctl_dimm *dimm, const char *master);
 int ndctl_dimm_disable_key(struct ndctl_dimm *dimm);
+int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm);
 #else
 static inline int ndctl_dimm_enable_key(struct ndctl_dimm *dimm,
 		const char *master)
@@ -731,6 +733,11 @@ static inline int ndctl_dimm_disable_key(struct ndctl_dimm *dimm)
 {
 	return -EOPNOTSUPP;
 }
+
+static inline int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 #ifdef __cplusplus
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index d08fee4d..40982f43 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -92,6 +92,7 @@ static struct cmd_struct commands[] = {
 	{ "update-passphrase", cmd_passphrase_update },
 	{ "disable-passphrase", cmd_disable_passphrase },
 	{ "freeze-security", cmd_freeze_security },
+	{ "sanitize-dimm", cmd_sanitize_dimm },
 	{ "list", cmd_list },
 	{ "monitor", cmd_monitor},
 	{ "help", cmd_help },

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
