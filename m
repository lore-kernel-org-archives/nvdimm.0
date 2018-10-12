Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6C2FE2116DFA7
 for <linux-nvdimm@lists.01.org>; Fri, 12 Oct 2018 15:28:47 -0700 (PDT)
Subject: [PATCH v4 2/7] ndctl: add update to security support
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 12 Oct 2018 15:28:46 -0700
Message-ID: <153938332661.20740.4982467030035033155.stgit@djiang5-desk3.ch.intel.com>
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

Add API call for triggering sysfs knob to update the security for a DIMM
in libndctl. Also add the ndctl "update-security" to trigger that as well.
ndctl does not actually handle the passphrase file. It only initiates the
update and expects all the necessary mechanisms are already in place.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ndctl/Makefile.am               |    3 -
 Documentation/ndctl/ndctl-update-security.txt |   56 ++++++++++
 builtin.h                                     |    1 
 configure.ac                                  |    5 +
 ndctl.spec.in                                 |    1 
 ndctl/Makefile.am                             |    3 -
 ndctl/dimm.c                                  |   90 ++++++++++++++--
 ndctl/lib/Makefile.am                         |    4 +
 ndctl/lib/dimm.c                              |   24 ++++
 ndctl/lib/keys.c                              |  139 +++++++++++++++++++++++++
 ndctl/lib/libndctl.sym                        |    3 +
 ndctl/libndctl.h                              |   14 +++
 ndctl/ndctl.c                                 |    1 
 13 files changed, 330 insertions(+), 14 deletions(-)
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
index 00000000..96d519b1
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
+<description id>:<new passphrase with padded 0 to 32bytes>:<old passphrase with padded 0
+to 32 bytes>
+
+cdab-0a-07e0-feffffff:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
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
index bb6b0332..1cfd9718 100644
--- a/configure.ac
+++ b/configure.ac
@@ -153,6 +153,11 @@ fi
 AC_SUBST([systemd_unitdir])
 AM_CONDITIONAL([ENABLE_SYSTEMD_UNITS], [test "x$with_systemd" = "xyes"])
 
+AC_CHECK_HEADERS([keyutils.h],,[
+	AC_MSG_ERROR([keyutils.h not found, consider installing
+		      keyutils-libs-devel.])
+		  ])
+
 my_CFLAGS="\
 -D DEF_CONF_FILE='\"${sysconfdir}/ndctl/monitor.conf\"' \
 -Wall \
diff --git a/ndctl.spec.in b/ndctl.spec.in
index 26396d4a..f57b4fd5 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -21,6 +21,7 @@ BuildRequires:	pkgconfig(uuid)
 BuildRequires:	pkgconfig(json-c)
 BuildRequires:	pkgconfig(bash-completion)
 BuildRequires:	pkgconfig(systemd)
+BuildRequires:	keyutils
 
 %description
 Utility library for managing the "libnvdimm" subsystem.  The "libnvdimm"
diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index 8a5e5f87..5b62251b 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -30,7 +30,8 @@ ndctl_LDADD =\
 	../libutil.a \
 	$(UUID_LIBS) \
 	$(KMOD_LIBS) \
-	$(JSON_LIBS)
+	$(JSON_LIBS) \
+	-lkeyutils
 
 if ENABLE_TEST
 ndctl_SOURCES += ../test/libndctl.c \
diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index 699ab57d..62a102b4 100644
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
@@ -824,17 +838,44 @@ static int action_update(struct ndctl_dimm *dimm, struct action_context *actx)
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
+	int rc, po_valid, pn_valid;
+	char old_payload[ND_PASSPHRASE_SIZE];
+	char new_payload[ND_PASSPHRASE_SIZE];
+	key_serial_t old_key, new_key;
+	char *po;
+
+	if (param.key_exec)
+		return execl(param.key_exec, ndctl_dimm_get_devname(dimm),
+				ndctl_dimm_get_unique_id(dimm), (char *)NULL);
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
+	 * If we are turning on security rather than updating, then
+	 * we would not have an old key.
+	 */
+	po = po_valid ? old_payload : NULL;
+	rc = ndctl_dimm_add_keys(dimm, &new_key, new_payload,
+			&old_key, po);
+	if (rc < 0)
+		return rc;
+
+	/* now do actual writing to update */
+	rc = ndctl_dimm_set_change_key(dimm, old_key, new_key);
+	if (rc < 0)
+		return rc;
+
+	return rc;
+}
 
 static int __action_init(struct ndctl_dimm *dimm,
 		enum ndctl_namespace_version version, int chk_only)
@@ -925,6 +966,12 @@ OPT_BOOLEAN('f', "force", &param.force, \
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
@@ -954,6 +1001,12 @@ static const struct option init_options[] = {
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
@@ -1024,6 +1077,11 @@ static int dimm_action(int argc, const char **argv, void *ctx,
 		}
 	}
 
+	if (action == action_key && param.key_insecure && param.key_exec) {
+			usage_with_options(u, options);
+			return -EINVAL;
+	}
+
 	if (param.verbose)
 		ndctl_set_log_priority(ctx, LOG_DEBUG);
 
@@ -1181,3 +1239,13 @@ int cmd_update_firmware(int argc, const char **argv, void *ctx)
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
index 4470d5fe..c9ef894a 100644
--- a/ndctl/lib/dimm.c
+++ b/ndctl/lib/dimm.c
@@ -599,3 +599,27 @@ NDCTL_EXPORT int ndctl_dimm_get_security_state(struct ndctl_dimm *dimm,
 
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
+	sprintf(buf, "update %d %d\n", ckey, nkey);
+	return ndctl_dimm_write_security(dimm, buf);
+}
diff --git a/ndctl/lib/keys.c b/ndctl/lib/keys.c
new file mode 100644
index 00000000..b21d11f0
--- /dev/null
+++ b/ndctl/lib/keys.c
@@ -0,0 +1,139 @@
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
+NDCTL_EXPORT int ndctl_dimm_get_key_payload(struct ndctl_dimm *dimm,
+		char *pass, int *pass_valid,
+		char *oldpass, int *oldpass_valid)
+{
+	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
+	ssize_t rc = 0;
+	static FILE *fp;
+	const char *dimm_id;
+	size_t size = 0, i;
+	char *line = NULL, *desc, *pass1, *pass2;
+	int found = 0, comment = 0;
+
+	*pass_valid = 0;
+	*oldpass_valid = 0;
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
+		/* skip comments */
+		for (i = 0; i < size; i++) {
+			if (isspace(line[i]))
+				continue;
+			if (line[i] == '#')
+				comment = 1;
+		}
+
+		if (comment) {
+			comment = 0;
+			continue;
+		}
+
+		desc = strtok(line, ":");
+		if (!desc)
+			break;
+		if (strcmp(desc, dimm_id) == 0) {
+			found = 1;
+			rc = 0;
+			break;
+		}
+	}
+
+	memset(oldpass, 0, ND_PASSPHRASE_SIZE);
+	memset(pass, 0, ND_PASSPHRASE_SIZE);
+	if (rc == 0 && found) {
+		pass1 = strtok(NULL, ":");
+		pass2 = strtok(NULL, ":");
+		if (!pass1) {
+			rc = -EINVAL;
+			goto out;
+		}
+
+		if (strlen(pass1) > ND_PASSPHRASE_SIZE)
+			pass1[ND_PASSPHRASE_SIZE] = '\0';
+
+		if (pass2 && strlen(pass2) > ND_PASSPHRASE_SIZE)
+			pass2[ND_PASSPHRASE_SIZE] = '\0';
+
+		memcpy(pass, pass1, strlen(pass1));
+		*pass_valid = 1;
+
+		if (pass2) {
+			memcpy(oldpass, pass2, strlen(pass2));
+			*oldpass_valid = 1;
+		}
+	} else
+		rc = -ENXIO;
+
+out:
+	free(line);
+	fclose(fp);
+	return rc;
+}
+
+NDCTL_EXPORT int ndctl_dimm_add_keys(struct ndctl_dimm *dimm,
+		key_serial_t *new_key, const char *payload1,
+		key_serial_t *old_key, const char *payload2)
+{
+	int rc;
+	char desc[ND_KEY_DESC_LEN + ND_KEY_DESC_PREFIX];
+	char odesc[ND_KEY_DESC_LEN + 4 + ND_KEY_DESC_PREFIX];
+	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
+
+	rc = sprintf(desc, "nvdimm:%s", ndctl_dimm_get_unique_id(dimm));
+	if (rc < 0) {
+		err(ctx, "sprintf: %s\n", strerror(errno));
+		return -errno;
+	}
+
+	rc = sprintf(odesc, "nvdimm_old:%s", ndctl_dimm_get_unique_id(dimm));
+	if (rc < 0) {
+		err(ctx, "sprintf: %s\n", strerror(errno));
+		return -errno;
+	}
+
+	*new_key = add_key("logon", desc, payload1, ND_PASSPHRASE_SIZE,
+			KEY_SPEC_USER_KEYRING);
+	if (*new_key == -1) {
+		err(ctx, "add_key: %s\n", strerror(errno));
+		return -errno;
+	}
+
+	if (payload2) {
+		*old_key = add_key("logon", odesc, payload2,
+				ND_PASSPHRASE_SIZE, KEY_SPEC_USER_KEYRING);
+		if (*old_key == -1) {
+			err(ctx, "add_key: %s\n", strerror(errno));
+			return -errno;
+		}
+	} else
+		*old_key = 0;
+
+	return 0;
+}
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index d3c1e018..a37e7389 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -389,4 +389,7 @@ global:
 LIBNDCTL_19 {
 global:
 	ndctl_dimm_get_security_state;
+	ndctl_dimm_get_key_payload;
+	ndctl_dimm_add_keys;
+	ndctl_dimm_set_change_key;
 } LIBNDCTL_18;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 29fc6603..4fee6467 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -19,6 +19,7 @@
 #include <unistd.h>
 #include <errno.h>
 #include <limits.h>
+#include <keyutils.h>
 
 #ifdef HAVE_LIBUUID
 #include <uuid/uuid.h>
@@ -680,7 +681,20 @@ unsigned long long ndctl_cmd_fw_fquery_get_fw_rev(struct ndctl_cmd *cmd);
 enum ND_FW_STATUS ndctl_cmd_fw_xlat_firmware_status(struct ndctl_cmd *cmd);
 struct ndctl_cmd *ndctl_dimm_cmd_new_ack_shutdown_count(struct ndctl_dimm *dimm);
 int ndctl_dimm_fw_update_supported(struct ndctl_dimm *dimm);
+
+#define ND_PASSPHRASE_SIZE	32
+#define PASS_PATH		"/etc/nvdimm.passwd"
+#define ND_KEY_DESC_LEN	22
+#define ND_KEY_DESC_PREFIX  7
+
 int ndctl_dimm_get_security_state(struct ndctl_dimm *dimm, char *state);
+int ndctl_dimm_set_change_key(struct ndctl_dimm *dimm, key_serial_t ckey,
+		key_serial_t nkey);
+int ndctl_dimm_get_key_payload(struct ndctl_dimm *dimm, char *pass,
+		int *pass_valid, char *oldpass, int *oldpass_valid);
+int ndctl_dimm_add_keys(struct ndctl_dimm *dimm, key_serial_t *new_key,
+		const char *new_payload, key_serial_t *old_key,
+		const char *old_payload);
 
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
