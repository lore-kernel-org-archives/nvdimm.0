Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A1B6F2116DFA9
 for <linux-nvdimm@lists.01.org>; Fri, 12 Oct 2018 15:29:03 -0700 (PDT)
Subject: [PATCH v4 5/7] ndctl: add support for sanitize dimm
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 12 Oct 2018 15:29:02 -0700
Message-ID: <153938334276.20740.14352246357588427406.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153938316555.20740.14314691018876178251.stgit@djiang5-desk3.ch.intel.com>
References: <153938316555.20740.14314691018876178251.stgit@djiang5-desk3.ch.intel.com>
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
of "sanitize" for ndctl. This will initiate the request to crypto
erase a DIMM. ndctl does not actually handle the verification of the
security. That is handled by the kernel and the key upcall mechanism.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ndctl/Makefile.am        |    3 +
 Documentation/ndctl/ndctl-sanitize.txt |   52 ++++++++++++++++++++++++
 builtin.h                              |    1 
 ndctl/dimm.c                           |   70 ++++++++++++++++++++++++++++++++
 ndctl/lib/dimm.c                       |    9 ++++
 ndctl/lib/libndctl.sym                 |    1 
 ndctl/libndctl.h                       |    1 
 ndctl/ndctl.c                          |    1 
 8 files changed, 137 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/ndctl/ndctl-sanitize.txt

diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
index 3a761ba0..8c171ecb 100644
--- a/Documentation/ndctl/Makefile.am
+++ b/Documentation/ndctl/Makefile.am
@@ -50,7 +50,8 @@ man1_MANS = \
 	ndctl-monitor.1 \
 	ndctl-update-security.1 \
 	ndctl-disable-security.1 \
-	ndctl-freeze-security.1
+	ndctl-freeze-security.1 \
+	ndctl-sanitize.1
 
 CLEANFILES = $(man1_MANS)
 
diff --git a/Documentation/ndctl/ndctl-sanitize.txt b/Documentation/ndctl/ndctl-sanitize.txt
new file mode 100644
index 00000000..a02b4b31
--- /dev/null
+++ b/Documentation/ndctl/ndctl-sanitize.txt
@@ -0,0 +1,52 @@
+// SPDX-License-Identifier: GPL-2.0
+
+ndctl-sanitize(1)
+=================
+
+NAME
+----
+ndctl-sanitize - sanitize the data on the NVDIMM
+
+SYNOPSIS
+--------
+[verse]
+'ndctl sanitize' <dimm> [<options>]
+
+DESCRIPTION
+-----------
+Provide a generic interface to crypto erase a NVDIMM.
+The use of this depends on support from the underlying
+libndctl, kernel, as well as the platform itself.
+
+For the reference passphrase setup, /etc/nvdimm.passwd is read for passphrase
+retrieval:
+
+The nvdimm.passwd is formatted as:
+<description id>:<passphrase with padded 0 to 32bytes>
+cdab-0a-07e0-feffffff:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
+
+OPTIONS
+-------
+<dimm>::
+include::xable-dimm-options.txt[]
+
+-m::
+--method::
+	The method for sanitizing the dimm content.
+
+	crypto-erase: replaces encryption keys. This does not change label data.
+
+-i::
+--insecure::
+	Using the default reference support to parse the nvdimm passphrase
+	file, inject the key, and initiate disable operation. This is labeled
+	as insecure as it just provides a reference to how to inject keys
+	for the nvdimm. The passphrase is in clear text and is not considered
+	as secure as it can be.
+
+-e::
+--exec::
+	The external binary module that would inject the passphrase and
+	initiate the disable operation. Use this or -i, not both.
+
+include::../copyright.txt[]
diff --git a/builtin.h b/builtin.h
index 7b970e10..f43988af 100644
--- a/builtin.h
+++ b/builtin.h
@@ -51,4 +51,5 @@ int cmd_inject_smart(int argc, const char **argv, void *ctx);
 int cmd_key_update(int argc, const char **argv, void *ctx);
 int cmd_disable_security(int argc, const char **argv, void *ctx);
 int cmd_freeze_security(int argc, const char **argv, void *ctx);
+int cmd_sanitize(int argc, const char **argv, void *ctx);
 #endif /* _NDCTL_BUILTIN_H_ */
diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index 3ab15094..e99c7dcf 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -46,6 +46,7 @@ static struct parameters {
 	const char *infile;
 	const char *labelversion;
 	const char *key_exec;
+	const char *sanitize_method;
 	bool force;
 	bool json;
 	bool verbose;
@@ -925,6 +926,54 @@ static int action_security_freeze(struct ndctl_dimm *dimm,
 	return rc;
 }
 
+static int action_sanitize(struct ndctl_dimm *dimm,
+		struct action_context *actx)
+{
+	int rc, po_valid, pn_valid;
+	char old_payload[ND_PASSPHRASE_SIZE];
+	char new_payload[ND_PASSPHRASE_SIZE];
+	key_serial_t old_key, new_key;
+
+	if (!param.sanitize_method) {
+		error("No sanitize_method passed in\n");
+		return -EINVAL;
+	}
+
+	if (param.key_exec)
+		return execl(param.key_exec, ndctl_dimm_get_devname(dimm),
+				ndctl_dimm_get_unique_id(dimm),
+				"-m ", param.sanitize_method,
+				(char *)NULL);
+
+	if (!param.key_insecure)
+		return -EINVAL;
+
+	rc = ndctl_dimm_get_key_payload(dimm, new_payload, &pn_valid,
+			old_payload, &po_valid);
+	if (rc < 0)
+		return rc;
+
+	/*
+	 * We will ignore the "old" key. The "new" key is actually the
+	 * current key, which we will pass to the kernel.
+	 */
+	rc = ndctl_dimm_add_keys(dimm, &new_key, new_payload, &old_key, NULL);
+	if (rc < 0)
+		return rc;
+
+	if (strcmp(param.sanitize_method, "crypto-erase") == 0) {
+		rc = ndctl_dimm_secure_erase(dimm, new_key);
+		if (rc < 0)
+			error("Failed to secure erase for %s\n",
+					ndctl_dimm_get_devname(dimm));
+	} else {
+		error("Incorrect sanitize method passed in.\n");
+		return -EINVAL;
+	}
+
+	return rc;
+}
+
 static int __action_init(struct ndctl_dimm *dimm,
 		enum ndctl_namespace_version version, int chk_only)
 {
@@ -1020,6 +1069,10 @@ OPT_BOOLEAN('i', "insecure", &param.key_insecure, \
 OPT_STRING('e', "exec", &param.key_exec, "external-exec", \
 		"external exec module for passphrase update")
 
+#define SANITIZE_OPTIONS() \
+OPT_STRING('m', "method", &param.sanitize_method, "sanitize-method", \
+		"method for sanitize a dimm")
+
 static const struct option read_options[] = {
 	BASE_OPTIONS(),
 	READ_OPTIONS(),
@@ -1055,6 +1108,13 @@ static const struct option key_options[] = {
 	OPT_END(),
 };
 
+static const struct option sanitize_options[] = {
+	BASE_OPTIONS(),
+	KEY_OPTIONS(),
+	SANITIZE_OPTIONS(),
+	OPT_END(),
+};
+
 static int dimm_action(int argc, const char **argv, void *ctx,
 		int (*action)(struct ndctl_dimm *dimm, struct action_context *actx),
 		const struct option *options, const char *usage)
@@ -1317,3 +1377,13 @@ int cmd_freeze_security(int argc, const char **argv, void *ctx)
 			count > 1 ? "s" : "");
 	return count >= 0 ? 0 : EXIT_FAILURE;
 }
+
+int cmd_sanitize(int argc, const char **argv, void *ctx)
+{
+	int count = dimm_action(argc, argv, ctx, action_sanitize, sanitize_options,
+			"ndctl sanitize <nmem0> [<nmem1>..<nmemN>] [<options>]");
+
+	fprintf(stderr, "sanitized %d nmem%s.\n", count >= 0 ? count : 0,
+			count > 1 ? "s" : "");
+	return count >= 0 ? 0 : EXIT_FAILURE;
+}
diff --git a/ndctl/lib/dimm.c b/ndctl/lib/dimm.c
index fc0c2e57..dcff84c8 100644
--- a/ndctl/lib/dimm.c
+++ b/ndctl/lib/dimm.c
@@ -637,3 +637,12 @@ NDCTL_EXPORT int ndctl_dimm_freeze_security(struct ndctl_dimm *dimm)
 {
 	return ndctl_dimm_write_security(dimm, "freeze");
 }
+
+NDCTL_EXPORT int ndctl_dimm_secure_erase(struct ndctl_dimm *dimm,
+		key_serial_t key)
+{
+	char buf[SYSFS_ATTR_SIZE];
+
+	sprintf(buf, "erase %d\n", key);
+	return ndctl_dimm_write_security(dimm, buf);
+}
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 6fd1d3a9..155cf3c2 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -394,4 +394,5 @@ global:
 	ndctl_dimm_set_change_key;
 	ndctl_dimm_disable_security;
 	ndctl_dimm_freeze_security;
+	ndctl_dimm_secure_erase;
 } LIBNDCTL_18;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 19c4974d..ba5af487 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -697,6 +697,7 @@ int ndctl_dimm_add_keys(struct ndctl_dimm *dimm, key_serial_t *new_key,
 		const char *old_payload);
 int ndctl_dimm_disable_security(struct ndctl_dimm *dimm, key_serial_t key);
 int ndctl_dimm_freeze_security(struct ndctl_dimm *dimm);
+int ndctl_dimm_secure_erase(struct ndctl_dimm *dimm, key_serial_t key);
 
 #ifdef __cplusplus
 } /* extern "C" */
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index 7a242aab..07af7305 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -91,6 +91,7 @@ static struct cmd_struct commands[] = {
 	{ "update-security", cmd_key_update },
 	{ "disable-security", cmd_disable_security },
 	{ "freeze-security", cmd_freeze_security },
+	{ "sanitize", cmd_sanitize },
 	{ "list", cmd_list },
 	{ "monitor", cmd_monitor},
 	{ "help", cmd_help },

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
