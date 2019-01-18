Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A6C03211B63F7
 for <linux-nvdimm@lists.01.org>; Thu, 17 Jan 2019 18:38:39 -0800 (PST)
Subject: [PATCH v9 03/13] ndctl: add passphrase update to ndctl
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 17 Jan 2019 19:38:38 -0700
Message-ID: <154777911867.42557.1102870234536796036.stgit@djiang5-desk3.ch.intel.com>
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

Add API call for triggering sysfs knob to update the security for a DIMM
in libndctl. Also add the ndctl "update-passphrase" to trigger the
operation.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ndctl/Makefile.am                 |    4 
 Documentation/ndctl/ndctl-setup-passphrase.txt  |   34 ++
 Documentation/ndctl/ndctl-update-passphrase.txt |   36 ++
 configure.ac                                    |   14 +
 ndctl.spec.in                                   |    2 
 ndctl/builtin.h                                 |    2 
 ndctl/dimm.c                                    |   68 +++-
 ndctl/lib/Makefile.am                           |    8 
 ndctl/lib/dimm.c                                |   24 +
 ndctl/lib/keys.c                                |  387 +++++++++++++++++++++++
 ndctl/lib/libndctl.sym                          |    3 
 ndctl/libndctl.h                                |   31 ++
 ndctl/ndctl.c                                   |    2 
 13 files changed, 603 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/ndctl/ndctl-setup-passphrase.txt
 create mode 100644 Documentation/ndctl/ndctl-update-passphrase.txt
 create mode 100644 ndctl/lib/keys.c

diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
index 7cb7bd6b..7b155d4d 100644
--- a/Documentation/ndctl/Makefile.am
+++ b/Documentation/ndctl/Makefile.am
@@ -48,7 +48,9 @@ man1_MANS = \
 	ndctl-update-firmware.1 \
 	ndctl-list.1 \
 	ndctl-monitor.1 \
-	ndctl-install-encrypt-key.1
+	ndctl-install-encrypt-key.1 \
+	ndctl-setup-passphrase.1 \
+	ndctl-update-passphrase.1
 
 CLEANFILES = $(man1_MANS)
 
diff --git a/Documentation/ndctl/ndctl-setup-passphrase.txt b/Documentation/ndctl/ndctl-setup-passphrase.txt
new file mode 100644
index 00000000..7d8a1abb
--- /dev/null
+++ b/Documentation/ndctl/ndctl-setup-passphrase.txt
@@ -0,0 +1,34 @@
+// SPDX-License-Identifier: GPL-2.0
+
+ndctl-setup-passphrase(1)
+=========================
+
+NAME
+----
+ndctl-setup-passphrase - setup and enable the security passphrase for an NVDIMM
+
+SYNOPSIS
+--------
+[verse]
+'ndctl setup-passphrase' <nmem0> [<nmem1>..<nmemN>] [<options>]
+
+DESCRIPTION
+-----------
+Enable the security passphrase for one or more NVDIMMs.
+
+Prerequisite for command to succeed:
+1. The master key has already been loaded into the user key ring.
+2. ndctl install-encrypt-key has been executed successfully.
+
+The encrypted key blobs will be created by ndctl in /etc/ndctl/keys directory
+with the file name of "nvdimm_<dimm unique id>_<hostname>.blob".
+
+The command will fail if the nvdimm key is already in the user key ring and/or
+the key blob already resides in /etc/nvdimm.
+
+OPTIONS
+-------
+<dimm>::
+include::xable-dimm-options.txt[]
+
+include::../copyright.txt[]
diff --git a/Documentation/ndctl/ndctl-update-passphrase.txt b/Documentation/ndctl/ndctl-update-passphrase.txt
new file mode 100644
index 00000000..ff49ae2d
--- /dev/null
+++ b/Documentation/ndctl/ndctl-update-passphrase.txt
@@ -0,0 +1,36 @@
+// SPDX-License-Identifier: GPL-2.0
+
+ndctl-update-passphrase(1)
+==========================
+
+NAME
+----
+ndctl-update-passphrase - update the security passphrase for an NVDIMM
+
+SYNOPSIS
+--------
+[verse]
+'ndctl update-passphrase' <nmem0> [<nmem1>..<nmemN>] [<options>]
+
+DESCRIPTION
+-----------
+Update the security passphrase for one or more NVDIMMs.
+Prerequisite for command to succeed:
+1. The master key has already been loaded into the user key ring.
+2. ndctl install-encrypt-key has been executed successfully.
+3. setup-passphrase has successfully been executed previously on the NVDIMM
+   or NVDIMM has been successfully unlocked by the kernel.
+
+The updated key blobs will be created by ndctl in /etc/ndctl/keys directory
+with the file name of "nvdimm_<dimm unique id>_<hostname>.blob".
+
+OPTIONS
+-------
+<dimm>::
+include::xable-dimm-options.txt[]
+
+include::../copyright.txt[]
+
+SEE ALSO:
+---------
+linkndctl:ndctl-setup-passphrase[1]
diff --git a/configure.ac b/configure.ac
index 61e91e0a..3c909cd0 100644
--- a/configure.ac
+++ b/configure.ac
@@ -154,11 +154,25 @@ fi
 AC_SUBST([systemd_unitdir])
 AM_CONDITIONAL([ENABLE_SYSTEMD_UNITS], [test "x$with_systemd" = "xyes"])
 
+
 ndctl_monitorconfdir=${sysconfdir}/ndctl
 ndctl_monitorconf=monitor.conf
 AC_SUBST([ndctl_monitorconfdir])
 AC_SUBST([ndctl_monitorconf])
 
+AC_ARG_WITH([keyutils],
+	    AS_HELP_STRING([--with-keyutils],
+			[Enable keyutils functionality (security).  @<:@default=yes@:>@]), [], [with_keyutils=yes])
+
+if test "x$with_keyutils" = "xyes"; then
+	AC_CHECK_HEADERS([keyutils.h],,[
+		AC_MSG_ERROR([keyutils.h not found, consider installing
+			      keyutils-libs-devel.])
+		])
+fi
+AS_IF([test "x$with_keyutils" = "xyes"],
+	[AC_DEFINE([ENABLE_KEYUTILS], [1], [Enable keyutils support])])
+AM_CONDITIONAL([ENABLE_KEYUTILS], [test "x$with_keyutils" = "xyes"])
 ndctl_keysdir=${sysconfdir}/ndctl/keys
 AC_SUBST([ndctl_keysdir])
 
diff --git a/ndctl.spec.in b/ndctl.spec.in
index bc4d65c1..3956d81d 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -21,6 +21,7 @@ BuildRequires:	pkgconfig(uuid)
 BuildRequires:	pkgconfig(json-c)
 BuildRequires:	pkgconfig(bash-completion)
 BuildRequires:	pkgconfig(systemd)
+BuildRequires:	keyutils-libs-devel
 
 %description
 Utility library for managing the "libnvdimm" subsystem.  The "libnvdimm"
@@ -118,6 +119,7 @@ make check
 %{_mandir}/man1/ndctl*
 %{bashcompdir}/
 %{_unitdir}/ndctl-monitor.service
+%{_sysconfdir}/ndctl/keys/
 
 %config(noreplace) %{_sysconfdir}/ndctl/monitor.conf
 
diff --git a/ndctl/builtin.h b/ndctl/builtin.h
index 4af34f04..33c04983 100644
--- a/ndctl/builtin.h
+++ b/ndctl/builtin.h
@@ -33,4 +33,6 @@ int cmd_bat(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_update_firmware(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_inject_smart(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_install_kek(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_passphrase_setup(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_passphrase_update(int argc, const char **argv, struct ndctl_ctx *ctx);
 #endif /* _NDCTL_BUILTIN_H_ */
diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index c717beeb..bea7cf62 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -40,6 +40,18 @@ struct action_context {
 	struct update_context update;
 };
 
+static struct parameters {
+	const char *bus;
+	const char *outfile;
+	const char *infile;
+	const char *labelversion;
+	bool force;
+	bool json;
+	bool verbose;
+} param = {
+	.labelversion = "1.1",
+};
+
 static int action_disable(struct ndctl_dimm *dimm, struct action_context *actx)
 {
 	if (ndctl_dimm_is_active(dimm)) {
@@ -824,17 +836,29 @@ static int action_update(struct ndctl_dimm *dimm, struct action_context *actx)
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
+static int action_key_enable(struct ndctl_dimm *dimm,
+		struct action_context *actx)
+{
+	if (ndctl_dimm_get_security(dimm) < 0) {
+		error("%s: security operation not supported\n",
+				ndctl_dimm_get_devname(dimm));
+		return -EOPNOTSUPP;
+	}
+
+	return ndctl_dimm_enable_key(dimm);
+}
+
+static int action_key_update(struct ndctl_dimm *dimm,
+		struct action_context *actx)
+{
+	if (ndctl_dimm_get_security(dimm) < 0) {
+		error("%s: security operation not supported\n",
+				ndctl_dimm_get_devname(dimm));
+		return -EOPNOTSUPP;
+	}
+
+	return ndctl_dimm_update_key(dimm);
+}
 
 static int __action_init(struct ndctl_dimm *dimm,
 		enum ndctl_namespace_version version, int chk_only)
@@ -1181,3 +1205,25 @@ int cmd_update_firmware(int argc, const char **argv, struct ndctl_ctx *ctx)
 			count > 1 ? "s" : "");
 	return count >= 0 ? 0 : EXIT_FAILURE;
 }
+
+int cmd_passphrase_update(int argc, const char **argv, struct ndctl_ctx *ctx)
+{
+	int count = dimm_action(argc, argv, ctx, action_key_update,
+			base_options,
+			"ndctl update-passphrase <nmem0> [<nmem1>..<nmemN>] [<options>]");
+
+	fprintf(stderr, "passphrase updated for %d nmem%s.\n", count >= 0 ? count : 0,
+			count > 1 ? "s" : "");
+	return count >= 0 ? 0 : EXIT_FAILURE;
+}
+
+int cmd_passphrase_setup(int argc, const char **argv, struct ndctl_ctx *ctx)
+{
+	int count = dimm_action(argc, argv, ctx, action_key_enable,
+			base_options,
+			"ndctl setup-passphrase <nmem0> [<nmem1>..<nmemN>] [<options>]");
+
+	fprintf(stderr, "passphrase enabled for %d nmem%s.\n", count >= 0 ? count : 0,
+			count > 1 ? "s" : "");
+	return count >= 0 ? 0 : EXIT_FAILURE;
+}
diff --git a/ndctl/lib/Makefile.am b/ndctl/lib/Makefile.am
index 77970399..6b9bde43 100644
--- a/ndctl/lib/Makefile.am
+++ b/ndctl/lib/Makefile.am
@@ -24,12 +24,20 @@ libndctl_la_SOURCES =\
 	firmware.c \
 	libndctl.c
 
+if ENABLE_KEYUTILS
+libndctl_la_SOURCES += keys.c
+endif
+
 libndctl_la_LIBADD =\
 	../../daxctl/lib/libdaxctl.la \
 	$(UDEV_LIBS) \
 	$(UUID_LIBS) \
 	$(KMOD_LIBS)
 
+if ENABLE_KEYUTILS
+libndctl_la_LIBADD += -lkeyutils
+endif
+
 EXTRA_DIST += libndctl.sym
 
 libndctl_la_LDFLAGS = $(AM_LDFLAGS) \
diff --git a/ndctl/lib/dimm.c b/ndctl/lib/dimm.c
index 712223fc..72b6f66c 100644
--- a/ndctl/lib/dimm.c
+++ b/ndctl/lib/dimm.c
@@ -631,3 +631,27 @@ NDCTL_EXPORT enum ndctl_security_state ndctl_dimm_get_security(
 
 	return NDCTL_SECURITY_INVALID;
 }
+
+static int write_security(struct ndctl_dimm *dimm, const char *cmd)
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
+NDCTL_EXPORT int ndctl_dimm_update_passphrase(struct ndctl_dimm *dimm,
+		long ckey, long nkey)
+{
+	char buf[SYSFS_ATTR_SIZE];
+
+	sprintf(buf, "update %ld %ld\n", ckey, nkey);
+	return write_security(dimm, buf);
+}
diff --git a/ndctl/lib/keys.c b/ndctl/lib/keys.c
new file mode 100644
index 00000000..1ae0ff02
--- /dev/null
+++ b/ndctl/lib/keys.c
@@ -0,0 +1,387 @@
+// SPDX-License-Identifier: GPL-2.0
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
+static int get_key_path(struct ndctl_dimm *dimm, char *path,
+		enum ndctl_key_type key_type)
+{
+	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
+	char hostname[HOST_NAME_MAX];
+	int rc;
+
+	rc = gethostname(hostname, HOST_NAME_MAX);
+	if (rc < 0) {
+		err(ctx, "gethostname: %s\n", strerror(errno));
+		return -errno;
+	}
+
+	if (key_type == ND_USER_OLD_KEY) {
+		rc = sprintf(path, "%s/nvdimmold_%s_%s.blob",
+				NDCTL_KEYS_DIR,
+				ndctl_dimm_get_unique_id(dimm),
+				hostname);
+	} else {
+		rc = sprintf(path, "%s/nvdimm_%s_%s.blob",
+				NDCTL_KEYS_DIR,
+				ndctl_dimm_get_unique_id(dimm),
+				hostname);
+	}
+
+	if (rc < 0) {
+		err(ctx, "error setting path: %s\n", strerror(errno));
+		return -errno;
+	}
+
+	return 0;
+}
+
+static int get_key_desc(struct ndctl_dimm *dimm, char *desc,
+		enum ndctl_key_type key_type)
+{
+	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
+	int rc;
+
+	if (key_type == ND_USER_OLD_KEY)
+		rc = sprintf(desc, "nvdimm-old:%s",
+				ndctl_dimm_get_unique_id(dimm));
+	else
+		rc = sprintf(desc, "nvdimm:%s",
+				ndctl_dimm_get_unique_id(dimm));
+
+	if (rc < 0) {
+		err(ctx, "error setting key description: %s\n",
+				strerror(errno));
+		return -errno;
+	}
+
+	return 0;
+}
+
+static char *load_key_blob(struct ndctl_ctx *ctx, const char *path, int *size)
+{
+	struct stat st;
+	FILE *bfile = NULL;
+	ssize_t read;
+	int rc;
+	char *blob, *pl;
+	char prefix[] = "load ";
+
+	rc = stat(path, &st);
+	if (rc < 0) {
+		err(ctx, "stat: %s\n", strerror(errno));
+		return NULL;
+	}
+	if ((st.st_mode & S_IFMT) != S_IFREG) {
+		err(ctx, "%s not a regular file\n", path);
+		return NULL;
+	}
+
+	if (st.st_size == 0 || st.st_size > 4096) {
+		err(ctx, "Invalid blob file size\n");
+		return NULL;
+	}
+
+	*size = st.st_size + sizeof(prefix) - 1;
+	blob = malloc(*size);
+	if (!blob) {
+		err(ctx, "Unable to allocate memory for blob\n");
+		return NULL;
+	}
+
+	bfile = fopen(path, "r");
+	if (!bfile) {
+		err(ctx, "Unable to open %s: %s\n", path, strerror(errno));
+		free(blob);
+		return NULL;
+	}
+
+	memcpy(blob, prefix, sizeof(prefix) - 1);
+	pl = blob + sizeof(prefix) - 1;
+	read = fread(pl, st.st_size, 1, bfile);
+	if (read < 0) {
+		err(ctx, "Failed to read from blob file: %s\n",
+				strerror(errno));
+		free(blob);
+		fclose(bfile);
+		return NULL;
+	}
+
+	fclose(bfile);
+	return blob;
+}
+
+static key_serial_t dimm_check_key(struct ndctl_dimm *dimm,
+		enum ndctl_key_type key_type)
+{
+	char desc[ND_KEY_DESC_SIZE];
+	int rc;
+
+	rc = get_key_desc(dimm, desc, key_type);
+	if (rc < 0)
+		return rc;
+
+	return keyctl_search(KEY_SPEC_USER_KEYRING, "encrypted", desc, 0);
+}
+
+static key_serial_t dimm_create_key(struct ndctl_dimm *dimm)
+{
+	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
+	char desc[ND_KEY_DESC_SIZE];
+	char path[PATH_MAX];
+	char cmd[ND_KEY_CMD_SIZE];
+	key_serial_t key;
+	void *buffer;
+	int rc;
+	ssize_t size;
+	FILE *fp;
+	ssize_t wrote;
+	struct stat st;
+
+	if (ndctl_dimm_is_active(dimm)) {
+		err(ctx, "regions active on %s, op failed\n",
+				ndctl_dimm_get_devname(dimm));
+		return -EBUSY;
+	}
+
+	rc = get_key_desc(dimm, desc, ND_USER_KEY);
+	if (rc < 0)
+		return rc;
+
+	/* make sure it's not already in the key ring */
+	key = keyctl_search(KEY_SPEC_USER_KEYRING, "encrypted", desc, 0);
+	if (key > 0) {
+		err(ctx, "Error: key already present in user keyring\n");
+		return -EEXIST;
+	}
+
+	rc = get_key_path(dimm, path, ND_USER_KEY);
+	if (rc < 0)
+		return rc;
+
+	rc = stat(path, &st);
+	if (rc == 0) {
+		err(ctx, "%s already exists!\n", path);
+		return -EEXIST;
+	}
+
+	rc = sprintf(cmd, "new enc32 %s 32",
+			ndctl_bus_get_kek_handle(ndctl_dimm_get_bus(dimm)));
+	if (rc < 0) {
+		err(ctx, "sprintf: %s\n", strerror(errno));
+		return -errno;
+	}
+
+	key = add_key("encrypted", desc, cmd, strlen(cmd),
+			KEY_SPEC_USER_KEYRING);
+	if (key < 0) {
+		err(ctx, "add_key failed: %s\n", strerror(errno));
+		return -errno;
+	}
+
+	size = keyctl_read_alloc(key, &buffer);
+	if (size < 0) {
+		err(ctx, "keyctl_read_alloc failed: %s\n", strerror(errno));
+		keyctl_unlink(key, KEY_SPEC_USER_KEYRING);
+		return rc;
+	}
+
+	fp = fopen(path, "w");
+	if (!fp) {
+		rc = -errno;
+		err(ctx, "Unable to open file %s: %s\n",
+				path, strerror(errno));
+		free(buffer);
+		return rc;
+	}
+
+	 wrote = fwrite(buffer, 1, size, fp);
+	 if (wrote != size) {
+		 if (wrote == -1)
+			 rc = -errno;
+		 else
+			 rc = -EIO;
+		 err(ctx, "Failed to write to %s: %s\n",
+				 path, strerror(-rc));
+		 free(buffer);
+		 return rc;
+	 }
+
+	 fclose(fp);
+	 free(buffer);
+	 return key;
+}
+
+static key_serial_t dimm_load_key(struct ndctl_dimm *dimm,
+		enum ndctl_key_type key_type)
+{
+	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
+	key_serial_t key;
+	char desc[ND_KEY_DESC_SIZE];
+	char path[PATH_MAX];
+	int rc;
+	char *blob;
+	int size;
+
+	if (ndctl_dimm_is_active(dimm)) {
+		err(ctx, "regions active on %s, op failed\n",
+				ndctl_dimm_get_devname(dimm));
+		return -EBUSY;
+	}
+
+	rc = get_key_desc(dimm, desc, key_type);
+	if (rc < 0)
+		return rc;
+
+	rc = get_key_path(dimm, path, key_type);
+	if (rc < 0)
+		return rc;
+
+	blob = load_key_blob(ctx, path, &size);
+	if (!blob)
+		return -ENOMEM;
+
+	key = add_key("encrypted", desc, blob, size, KEY_SPEC_USER_KEYRING);
+	free(blob);
+	if (key < 0) {
+		err(ctx, "add_key failed: %s\n", strerror(errno));
+		return -errno;
+	}
+
+	return key;
+}
+
+/*
+ * The function will check to see if the existing key is there and remove
+ * from user key ring if it is. Rename the existing key blob to old key
+ * blob, and then attempt to inject the key as old key into the user key
+ * ring.
+ */
+static key_serial_t move_key_to_old(struct ndctl_dimm *dimm)
+{
+	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
+	int rc;
+	key_serial_t key;
+	char old_path[PATH_MAX];
+	char new_path[PATH_MAX];
+
+	if (ndctl_dimm_is_active(dimm)) {
+		err(ctx, "regions active on %s, op failed\n",
+				ndctl_dimm_get_devname(dimm));
+		return -EBUSY;
+	}
+
+	key = dimm_check_key(dimm, ND_USER_KEY);
+	if (key > 0)
+		keyctl_unlink(key, KEY_SPEC_USER_KEYRING);
+
+	rc = get_key_path(dimm, old_path, ND_USER_KEY);
+	if (rc < 0)
+		return rc;
+
+	rc = get_key_path(dimm, new_path, ND_USER_OLD_KEY);
+	if (rc < 0)
+		return rc;
+
+	rc = rename(old_path, new_path);
+	if (rc < 0) {
+		err(ctx, "rename failed from %s to %s: %s\n",
+				old_path, new_path, strerror(errno));
+		return -errno;
+	}
+
+	return dimm_load_key(dimm, ND_USER_OLD_KEY);
+}
+
+static int dimm_remove_key(struct ndctl_dimm *dimm,
+		enum ndctl_key_type key_type)
+{
+	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
+	key_serial_t key;
+	char path[PATH_MAX];
+	int rc;
+
+	key = dimm_check_key(dimm, key_type);
+	if (key > 0)
+		keyctl_unlink(key, KEY_SPEC_USER_KEYRING);
+
+	rc = get_key_path(dimm, path, key_type);
+	if (rc < 0)
+		return rc;
+
+	rc = unlink(path);
+	if (rc < 0) {
+		err(ctx, "delete file %s failed: %s\n",
+				path, strerror(errno));
+		return -errno;
+	}
+
+	return 0;
+}
+
+NDCTL_EXPORT int ndctl_dimm_enable_key(struct ndctl_dimm *dimm)
+{
+	key_serial_t key;
+	int rc;
+
+	key = dimm_create_key(dimm);
+	if (key < 0)
+		return key;
+
+	rc = ndctl_dimm_update_passphrase(dimm, 0, key);
+	if (rc < 0) {
+		dimm_remove_key(dimm, ND_USER_KEY);
+		return rc;
+	}
+
+	return 0;
+}
+
+NDCTL_EXPORT int ndctl_dimm_update_key(struct ndctl_dimm *dimm)
+{
+	int rc;
+	key_serial_t old_key, new_key;
+
+	/*
+	 * 1. check if current key is loaded and remove
+	 * 2. move current key blob to old key blob
+	 * 3. load old key blob
+	 * 4. trigger change key with old and new key
+	 * 5. remove old key
+	 * 6. remove old key blob
+	 */
+	old_key = move_key_to_old(dimm);
+	if (old_key < 0)
+		return old_key;
+
+	new_key = dimm_create_key(dimm);
+	/* need to create new key here */
+	if (new_key < 0) {
+		new_key = dimm_load_key(dimm, ND_USER_KEY);
+		if (new_key < 0)
+			return new_key;
+	}
+
+	rc = ndctl_dimm_update_passphrase(dimm, old_key, new_key);
+	if (rc < 0)
+		return rc;
+
+	rc = dimm_remove_key(dimm, ND_USER_OLD_KEY);
+	if (rc < 0)
+		return rc;
+
+	return 0;
+}
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 6d5e6606..ce05d604 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -392,4 +392,7 @@ global:
 	ndctl_cmd_submit_xlat;
 	ndctl_dimm_get_security;
 	ndctl_bus_get_kek_handle;
+	ndctl_dimm_enable_key;
+	ndctl_dimm_update_key;
+	ndctl_dimm_update_passphrase;
 } LIBNDCTL_18;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index b0cc4543..727dedcf 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -19,6 +19,7 @@
 #include <unistd.h>
 #include <errno.h>
 #include <limits.h>
+#include <keyutils.h>
 
 #ifdef HAVE_UUID
 #include <uuid/uuid.h>
@@ -681,9 +682,14 @@ enum ND_FW_STATUS ndctl_cmd_fw_xlat_firmware_status(struct ndctl_cmd *cmd);
 struct ndctl_cmd *ndctl_dimm_cmd_new_ack_shutdown_count(struct ndctl_dimm *dimm);
 int ndctl_dimm_fw_update_supported(struct ndctl_dimm *dimm);
 
+
 int ndctl_cmd_xlat_firmware_status(struct ndctl_cmd *cmd);
 int ndctl_cmd_submit_xlat(struct ndctl_cmd *cmd);
 
+#define ND_PASSPHRASE_SIZE	32
+#define ND_KEY_DESC_LEN	22
+#define ND_KEY_DESC_PREFIX  7
+
 enum ndctl_security_state {
 	NDCTL_SECURITY_INVALID = -1,
 	NDCTL_SECURITY_DISABLED = 0,
@@ -695,6 +701,31 @@ enum ndctl_security_state {
 
 enum ndctl_security_state ndctl_dimm_get_security(struct ndctl_dimm *dimm);
 const char *ndctl_bus_get_kek_handle(struct ndctl_bus *bus);
+int ndctl_dimm_update_passphrase(struct ndctl_dimm *dimm,
+		long ckey, long nkey);
+
+enum ndctl_key_type {
+	ND_USER_KEY,
+	ND_USER_OLD_KEY,
+};
+
+#ifdef ENABLE_KEYUTILS
+int ndctl_dimm_enable_key(struct ndctl_dimm *dimm);
+int ndctl_dimm_update_key(struct ndctl_dimm *dimm);
+#else
+static inline int ndctl_dimm_enable_key(struct ndctl_dimm *dimm)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int ndctl_dimm_update_key(struct ndctl_dimm *dimm)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
+#define ND_KEY_DESC_SIZE	128
+#define ND_KEY_CMD_SIZE		128
 
 #ifdef __cplusplus
 } /* extern "C" */
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index bd11ec03..a715f69a 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -88,6 +88,8 @@ static struct cmd_struct commands[] = {
 	{ "inject-smart", { cmd_inject_smart } },
 	{ "wait-scrub", { cmd_wait_scrub } },
 	{ "start-scrub", { cmd_start_scrub } },
+	{ "setup-passphrase", { cmd_passphrase_setup } },
+	{ "update-passphrase", { cmd_passphrase_update } },
 	{ "list", { cmd_list } },
 	{ "monitor", { cmd_monitor } },
 	{ "install-encrypt-key", { cmd_install_kek } },

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
