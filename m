Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 235A121102DAE
 for <linux-nvdimm@lists.01.org>; Tue, 28 Aug 2018 15:51:57 -0700 (PDT)
Subject: [PATCH v3 2/6] ndctl: add update to security support
From: Dave Jiang <dave.jiang@intel.com>
Date: Tue, 28 Aug 2018 15:51:56 -0700
Message-ID: <153549671642.5723.4125145745863193059.stgit@djiang5-desk3.ch.intel.com>
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

Add API call for triggering sysfs knob to update the security for a DIMM
in libndctl. Also add the ndctl "update-security" to trigger that as well.
ndctl does not actually handle the passphrase file. It only initiates the
update and expects all the necessary mechanisms are already in place.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ndctl/Makefile.am               |    3 -
 Documentation/ndctl/ndctl-update-security.txt |   56 +++++++++++
 builtin.h                                     |    1 
 configure.ac                                  |    1 
 ndctl.spec.in                                 |    1 
 ndctl/dimm.c                                  |   92 ++++++++++++++++--
 ndctl/lib/Makefile.am                         |    4 +
 ndctl/lib/dimm.c                              |   24 +++++
 ndctl/lib/keys.c                              |  130 +++++++++++++++++++++++++
 ndctl/lib/libndctl.sym                        |    7 +
 ndctl/libndctl.h                              |    7 +
 ndctl/ndctl.c                                 |    1 
 12 files changed, 314 insertions(+), 13 deletions(-)
 create mode 100644 Documentation/ndctl/ndctl-update-security.txt
 create mode 100644 ndctl/lib/keys.c

diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
index a30b139b..2c064c3a 100644
--- a/Documentation/ndctl/Makefile.am
+++ b/Documentation/ndctl/Makefile.am
@@ -47,7 +47,8 @@ man1_MANS = \
 	ndctl-inject-smart.1 \
 	ndctl-update-firmware.1 \
 	ndctl-list.1 \
-	ndctl-monitor.1
+	ndctl-monitor.1 \
+	ndctl-update-security.1
 
 CLEANFILES = $(man1_MANS)
 
diff --git a/Documentation/ndctl/ndctl-update-security.txt b/Documentation/ndctl/ndctl-update-security.txt
new file mode 100644
index 00000000..cfc99656
--- /dev/null
+++ b/Documentation/ndctl/ndctl-update-security.txt
@@ -0,0 +1,56 @@
+// SPDX-License-Identifier: GPL-2.0
+
+ndctl-update-security(1)
+========================
+
+NAME
+----
+ndctl-update-security - enabling or update the security passphrase for a
+NVDIMM
+
+SYNOPSIS
+--------
+[verse]
+'ndctl update-security' <dimm> [<options>]
+
+DESCRIPTION
+-----------
+Provide a generic interface for enabling or updating security passphrase for
+NVDIMM. The use of this depends on support from the underlying libndctl,
+kernel, as well as the platform itself.
+
+For the reference passphrase setup, /etc/nvdimm.passwd is read for passphrase
+retrieval:
+
+The nvdimm.passwd is formatted as:
+<description id>:<passphrase with padded 0 to 32bytes>
+cdab-0a-07e0-feffffff:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
+
+To update a DIMM that has passphrase already enabled, the format is done as:
+<description id>:<new passphrase with padded 0 to 32bytes><old passphrase with padded 0
+to 32 bytes>
+
+cdab-0a-07e0-feffffff:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
+
+The accepted key will replace the old payload with the new payload in the
+cached key that resides in the kernel key ring.
+
+OPTIONS
+-------
+<dimm>::
+include::xable-dimm-options.txt[]
+
+-i::
+--insecure::
+	Using the default reference support to parse the nvdimm passphrase
+	file, inject the key, and initiate update operation. This is labeled
+	as insecure as it just provides a reference to how to inject keys
+	for the nvdimm. The passphrase is in clear text and is not considered
+	as secure as it can be.
+
+-e::
+--exec::
+	The external binary module that would inject the passphrase and
+	initiate the update operation. Use this or -i, not both.
+
+include::../copyright.txt[]
diff --git a/builtin.h b/builtin.h
index 675a6ce7..37404c79 100644
--- a/builtin.h
+++ b/builtin.h
@@ -48,4 +48,5 @@ int cmd_bat(int argc, const char **argv, void *ctx);
 #endif
 int cmd_update_firmware(int argc, const char **argv, void *ctx);
 int cmd_inject_smart(int argc, const char **argv, void *ctx);
+int cmd_key_update(int argc, const char **argv, void *ctx);
 #endif /* _NDCTL_BUILTIN_H_ */
diff --git a/configure.ac b/configure.ac
index 7bfe5a74..4fc6cdd9 100644
--- a/configure.ac
+++ b/configure.ac
@@ -114,6 +114,7 @@ PKG_CHECK_MODULES([KMOD], [libkmod])
 PKG_CHECK_MODULES([UDEV], [libudev])
 PKG_CHECK_MODULES([UUID], [uuid])
 PKG_CHECK_MODULES([JSON], [json-c])
+PKG_CHECK_MODULES([KEYUTILS], [keyutils])
 
 AC_ARG_WITH([bash-completion-dir],
 	AS_HELP_STRING([--with-bash-completion-dir[=PATH]],
diff --git a/ndctl.spec.in b/ndctl.spec.in
index b782aeae..c71bd581 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -21,6 +21,7 @@ BuildRequires:	pkgconfig(uuid)
 BuildRequires:	pkgconfig(json-c)
 BuildRequires:	pkgconfig(bash-completion)
 BuildRequires:	systemd
+BuildRequires:  pkgconfig(keyutils)
 
 %description
 Utility library for managing the "libnvdimm" subsystem.  The "libnvdimm"
diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index a4203f35..48d366c6 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -40,6 +40,20 @@ struct action_context {
 	struct update_context update;
 };
 
+static struct parameters {
+	const char *bus;
+	const char *outfile;
+	const char *infile;
+	const char *labelversion;
+	const char *key_exec;
+	bool force;
+	bool json;
+	bool verbose;
+	bool key_insecure;
+} param = {
+	.labelversion = "1.1",
+};
+
 static int action_disable(struct ndctl_dimm *dimm, struct action_context *actx)
 {
 	if (ndctl_dimm_is_active(dimm)) {
@@ -824,17 +838,46 @@ static int action_update(struct ndctl_dimm *dimm, struct action_context *actx)
 	return rc;
 }
 
-static struct parameters {
-	const char *bus;
-	const char *outfile;
-	const char *infile;
-	const char *labelversion;
-	bool force;
-	bool json;
-	bool verbose;
-} param = {
-	.labelversion = "1.1",
-};
+static int action_key(struct ndctl_dimm *dimm,
+		struct action_context *actx)
+{
+	int rc;
+	char payload[64];
+	int psize;
+	key_serial_t current_key, new_key;
+
+	if (ndctl_dimm_is_enabled(dimm)) {
+		fprintf(stderr, "%s: DIMM is not disabled\n",
+				ndctl_dimm_get_devname(dimm));
+		return -EACCES;
+	}
+
+	if (param.key_exec)
+		return execl(param.key_exec, ndctl_dimm_get_devname(dimm),
+				ndctl_dimm_get_unique_id(dimm), (char *)NULL);
+
+	if (!param.key_insecure)
+		return -EINVAL;
+
+	rc = ndctl_dimm_get_key_payload(dimm, payload, &psize);
+	if (rc < 0)
+		return rc;
+
+	rc = ndctl_dimm_get_current_key(dimm, &current_key);
+	if (rc < 0)
+		return rc;
+
+	rc = ndctl_dimm_add_key(dimm, payload, psize, &new_key);
+	if (rc < 0)
+		return rc;
+
+	/* now do actual writing to update */
+	rc = ndctl_dimm_set_change_key(dimm, current_key, new_key);
+	if (rc < 0)
+		return rc;
+
+	return rc;
+}
 
 static int __action_init(struct ndctl_dimm *dimm,
 		enum ndctl_namespace_version version, int chk_only)
@@ -925,6 +968,12 @@ OPT_BOOLEAN('f', "force", &param.force, \
 OPT_STRING('V', "label-version", &param.labelversion, "version-number", \
 	"namespace label specification version (default: 1.1)")
 
+#define KEY_OPTIONS() \
+OPT_BOOLEAN('i', "insecure", &param.key_insecure, \
+		"insecure reference passphrase update method"), \
+OPT_STRING('e', "exec", &param.key_exec, "external-exec", \
+		"external exec module for passphrase update")
+
 static const struct option read_options[] = {
 	BASE_OPTIONS(),
 	READ_OPTIONS(),
@@ -954,6 +1003,12 @@ static const struct option init_options[] = {
 	OPT_END(),
 };
 
+static const struct option key_options[] = {
+	BASE_OPTIONS(),
+	KEY_OPTIONS(),
+	OPT_END(),
+};
+
 static int dimm_action(int argc, const char **argv, void *ctx,
 		int (*action)(struct ndctl_dimm *dimm, struct action_context *actx),
 		const struct option *options, const char *usage)
@@ -1024,6 +1079,11 @@ static int dimm_action(int argc, const char **argv, void *ctx,
 		}
 	}
 
+	if (action == action_key && param.key_insecure && param.key_exec) {
+			usage_with_options(u, options);
+			return -EINVAL;
+	}
+
 	if (param.verbose)
 		ndctl_set_log_priority(ctx, LOG_DEBUG);
 
@@ -1181,3 +1241,13 @@ int cmd_update_firmware(int argc, const char **argv, void *ctx)
 			count > 1 ? "s" : "");
 	return count >= 0 ? 0 : EXIT_FAILURE;
 }
+
+int cmd_key_update(int argc, const char **argv, void *ctx)
+{
+	int count = dimm_action(argc, argv, ctx, action_key, key_options,
+			"ndctl update-security <nmem0> [<nmem1>..<nmemN>] [<options>]");
+
+	fprintf(stderr, "security updated for %d nmem%s.\n", count >= 0 ? count : 0,
+			count > 1 ? "s" : "");
+	return count >= 0 ? 0 : EXIT_FAILURE;
+}
diff --git a/ndctl/lib/Makefile.am b/ndctl/lib/Makefile.am
index 77970399..245b78a9 100644
--- a/ndctl/lib/Makefile.am
+++ b/ndctl/lib/Makefile.am
@@ -22,13 +22,15 @@ libndctl_la_SOURCES =\
 	msft.c \
 	ars.c \
 	firmware.c \
+	keys.c \
 	libndctl.c
 
 libndctl_la_LIBADD =\
 	../../daxctl/lib/libdaxctl.la \
 	$(UDEV_LIBS) \
 	$(UUID_LIBS) \
-	$(KMOD_LIBS)
+	$(KMOD_LIBS) \
+	$(KEYUTILS_LIBS)
 
 EXTRA_DIST += libndctl.sym
 
diff --git a/ndctl/lib/dimm.c b/ndctl/lib/dimm.c
index 8ed58559..57bbf01a 100644
--- a/ndctl/lib/dimm.c
+++ b/ndctl/lib/dimm.c
@@ -595,3 +595,27 @@ NDCTL_EXPORT int ndctl_dimm_get_security_state(struct ndctl_dimm *dimm,
 
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
+NDCTL_EXPORT int ndctl_dimm_set_change_key(struct ndctl_dimm *dimm,
+		key_serial_t ckey, key_serial_t nkey)
+{
+	char buf[SYSFS_ATTR_SIZE];
+
+	sprintf(buf, "update:%d:%d\n", ckey, nkey);
+	return ndctl_dimm_write_security(dimm, buf);
+}
diff --git a/ndctl/lib/keys.c b/ndctl/lib/keys.c
new file mode 100644
index 00000000..3fd35442
--- /dev/null
+++ b/ndctl/lib/keys.c
@@ -0,0 +1,130 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2018 Intel Corporation. All rights reserved. */
+
+#include <stdio.h>
+#include <errno.h>
+#include <string.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <sys/param.h>
+#include <keyutils.h>
+#include <syslog.h>
+
+#include <ndctl.h>
+#include <ndctl/libndctl.h>
+#include "private.h"
+
+#define PASSPHRASE_SIZE		32
+#define PASS_PATH		"/etc/nvdimm.passwd"
+#define NVDIMM_KEY_DESC_LEN	22
+#define NVDIMM_KEY_DESC_PREFIX  7
+
+NDCTL_EXPORT int ndctl_dimm_get_key_payload(struct ndctl_dimm *dimm,
+		char *pass, int *psize)
+{
+	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
+	ssize_t rc = 0;
+	static FILE *fp;
+	const char *dimm_id;
+	size_t size;
+	char *line = NULL;
+	char *tmp, *id_tok, *secret;
+	int found = 0;
+
+	dimm_id = ndctl_dimm_get_unique_id(dimm);
+	if (!dimm_id)
+		return -EINVAL;
+
+	fp = fopen(PASS_PATH, "r+");
+	if (!fp) {
+		err(ctx, "fopen: %s\n", strerror(errno));
+		return -errno;
+	}
+
+	while ((rc = getline(&line, &size, fp)) != -1) {
+		id_tok = strtok_r(line, ":", &tmp);
+		if (!id_tok)
+			break;
+		if (strcmp(id_tok, dimm_id) == 0) {
+			secret = tmp;
+			found = 1;
+			rc = 0;
+			break;
+		}
+	}
+
+	if (rc == 0 && found && secret) {
+		memset(pass, 0, PASSPHRASE_SIZE * 2 + 1);
+		size = MIN(strlen(secret), (PASSPHRASE_SIZE * 2 + 1));
+		memcpy(pass, secret, size);
+		*psize = size-1;
+	} else
+		rc = -ENXIO;
+
+	free(line);
+	fclose(fp);
+	return rc;
+}
+
+NDCTL_EXPORT int ndctl_dimm_add_key(struct ndctl_dimm *dimm,
+		const char *passphrase, int pass_size, key_serial_t *key)
+{
+	int rc;
+	char desc[NVDIMM_KEY_DESC_LEN + NVDIMM_KEY_DESC_PREFIX];
+	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
+
+	rc = sprintf(desc, "nvdimm:%s", ndctl_dimm_get_unique_id(dimm));
+	if (rc < 0) {
+		err(ctx, "sprintf: %s\n", strerror(errno));
+		return -errno;
+	}
+
+	*key = add_key("logon", desc, passphrase, pass_size,
+			KEY_SPEC_USER_KEYRING);
+	if (*key == -1) {
+		err(ctx, "add_key: %s\n", strerror(errno));
+		return -errno;
+	}
+
+	return 0;
+}
+
+static int ndctl_dimm_get_keyring(struct ndctl_dimm *dimm,
+		key_serial_t *keyring)
+{
+	*keyring = find_key_by_type_and_desc("keyring", ".nvdimm", 0);
+	if (*keyring == -1)
+		return -errno;
+	return 0;
+}
+
+NDCTL_EXPORT int ndctl_dimm_get_current_key(struct ndctl_dimm *dimm,
+		key_serial_t *key)
+{
+	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
+	key_serial_t ring;
+	char desc[NVDIMM_KEY_DESC_LEN + NVDIMM_KEY_DESC_PREFIX];
+	int rc;
+
+	rc = sprintf(desc, "nvdimm:%s", ndctl_dimm_get_unique_id(dimm));
+	if (rc < 0) {
+		err(ctx, "sprintf: %s\n", strerror(errno));
+		return -errno;
+	}
+
+	rc = ndctl_dimm_get_keyring(dimm, &ring);
+	if (rc < 0)
+		return rc;
+
+	*key = keyctl_search(ring, "logon", desc, 0);
+	if (*key == -1) {
+		if (errno == ENOKEY)
+			*key = 0;
+		else
+			return -errno;
+	}
+
+	return 0;
+}
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 062b41d3..d4764450 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -379,3 +379,10 @@ global:
 	ndctl_cmd_smart_inject_ctrl_temperature;
 	ndctl_dimm_get_security_state;
 } LIBNDCTL_16;
+LIBNDCTL_18 {
+global:
+	ndctl_dimm_get_key_payload;
+	ndctl_dimm_add_key;
+	ndctl_dimm_get_current_key;
+	ndctl_dimm_set_change_key;
+} LIBNDCTL_17;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index f23bfdee..f845b11b 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -19,6 +19,7 @@
 #include <unistd.h>
 #include <errno.h>
 #include <limits.h>
+#include <keyutils.h>
 
 #ifdef HAVE_LIBUUID
 #include <uuid/uuid.h>
@@ -674,6 +675,12 @@ enum ND_FW_STATUS ndctl_cmd_fw_xlat_firmware_status(struct ndctl_cmd *cmd);
 struct ndctl_cmd *ndctl_dimm_cmd_new_ack_shutdown_count(struct ndctl_dimm *dimm);
 int ndctl_dimm_fw_update_supported(struct ndctl_dimm *dimm);
 int ndctl_dimm_get_security_state(struct ndctl_dimm *dimm, char *state);
+int ndctl_dimm_set_change_key(struct ndctl_dimm *dimm, key_serial_t ckey,
+		key_serial_t nkey);
+int ndctl_dimm_get_key_payload(struct ndctl_dimm *dimm, char *pass, int *psize);
+int ndctl_dimm_add_key(struct ndctl_dimm *dimm, const char *passphrase,
+		int pass_size, key_serial_t *key);
+int ndctl_dimm_get_current_key(struct ndctl_dimm *dimm, key_serial_t *key);
 
 #ifdef __cplusplus
 } /* extern "C" */
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index 73dabfac..c7096dfd 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -88,6 +88,7 @@ static struct cmd_struct commands[] = {
 	{ "inject-smart", cmd_inject_smart },
 	{ "wait-scrub", cmd_wait_scrub },
 	{ "start-scrub", cmd_start_scrub },
+	{ "update-security", cmd_key_update },
 	{ "list", cmd_list },
 	{ "monitor", cmd_monitor},
 	{ "help", cmd_help },

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
