Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0B151211AEA4E
 for <linux-nvdimm@lists.01.org>; Wed,  9 Jan 2019 09:54:03 -0800 (PST)
Subject: [PATCH v7 02/12] ndctl: add passphrase update to ndctl
From: Dave Jiang <dave.jiang@intel.com>
Date: Wed, 09 Jan 2019 10:54:03 -0700
Message-ID: <154705644300.23227.18434595874552090222.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154705633843.23227.15903675663299735878.stgit@djiang5-desk3.ch.intel.com>
References: <154705633843.23227.15903675663299735878.stgit@djiang5-desk3.ch.intel.com>
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
 Documentation/ndctl/ndctl-enable-passphrase.txt |   42 ++
 Documentation/ndctl/ndctl-update-passphrase.txt |   38 ++
 configure.ac                                    |   19 +
 ndctl.spec.in                                   |    2 
 ndctl/Makefile.am                               |    3 
 ndctl/builtin.h                                 |    2 
 ndctl/dimm.c                                    |   94 +++++
 ndctl/lib/Makefile.am                           |    8 
 ndctl/lib/dimm.c                                |   39 ++
 ndctl/lib/keys.c                                |  394 +++++++++++++++++++++++
 ndctl/lib/libndctl.sym                          |    4 
 ndctl/libndctl.h                                |   32 ++
 ndctl/ndctl.c                                   |    2 
 14 files changed, 670 insertions(+), 13 deletions(-)
 create mode 100644 Documentation/ndctl/ndctl-enable-passphrase.txt
 create mode 100644 Documentation/ndctl/ndctl-update-passphrase.txt
 create mode 100644 ndctl/lib/keys.c

diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
index a30b139b..7ad6666b 100644
--- a/Documentation/ndctl/Makefile.am
+++ b/Documentation/ndctl/Makefile.am
@@ -47,7 +47,9 @@ man1_MANS = \
 	ndctl-inject-smart.1 \
 	ndctl-update-firmware.1 \
 	ndctl-list.1 \
-	ndctl-monitor.1
+	ndctl-monitor.1 \
+	ndctl-enable-passphrase.1 \
+	ndctl-update-passphrase.1
 
 CLEANFILES = $(man1_MANS)
 
diff --git a/Documentation/ndctl/ndctl-enable-passphrase.txt b/Documentation/ndctl/ndctl-enable-passphrase.txt
new file mode 100644
index 00000000..c14a206c
--- /dev/null
+++ b/Documentation/ndctl/ndctl-enable-passphrase.txt
@@ -0,0 +1,42 @@
+// SPDX-License-Identifier: GPL-2.0
+
+ndctl-enable-passphrase(1)
+==========================
+
+NAME
+----
+ndctl-enable-passphrase - enable the security passphrase for a NVDIMM
+
+SYNOPSIS
+--------
+[verse]
+'ndctl enable-passphrase' <dimm> [<options>]
+
+DESCRIPTION
+-----------
+Provide a command to enable the security passphrase for the NVDIMM.
+It is expected that the master key has already been loaded into the user
+key ring. The encrypted key blobs will be created in /etc/nvdimm directory
+with the file name of "nvdimm-<hostname>-<dimm unique id>.blob".
+
+The command will fail if the nvdimm key is already in the user key ring and/or
+the key blob already resides in /etc/nvdimm. Do not touch the /etc/nvdimm
+directory and let ndctl manage the keys, unless you know what you are doing.
+
+OPTIONS
+-------
+<dimm>::
+include::xable-dimm-options.txt[]
+
+-m::
+--master=::
+	Key name for the master key used to seal the NVDIMM security keys.
+	The format would be <key_type>:<master_key_name>
+	i.e.: trusted:master-nvdimm
+
+-p::
+--key-path=::
+	Path to where key related files resides. This parameter is optional
+	and the default is set to /etc/ndctl/keys.
+
+include::../copyright.txt[]
diff --git a/Documentation/ndctl/ndctl-update-passphrase.txt b/Documentation/ndctl/ndctl-update-passphrase.txt
new file mode 100644
index 00000000..dd6e4e4e
--- /dev/null
+++ b/Documentation/ndctl/ndctl-update-passphrase.txt
@@ -0,0 +1,38 @@
+// SPDX-License-Identifier: GPL-2.0
+
+ndctl-update-passphrase(1)
+==========================
+
+NAME
+----
+ndctl-update-passphrase - update the security passphrase for a NVDIMM
+
+SYNOPSIS
+--------
+[verse]
+'ndctl update-passphrase' <dimm> [<options>]
+
+DESCRIPTION
+-----------
+Provide a command to update the security key for NVDIMM.
+It is expected that the current and the new (if new master key is desired)
+master key has already been loaded into the user key ring. The new encrypted
+key blobs will be created in /etc/nvdimm directory
+with the file name of "nvdimm-<hostname>-<dimm unique id>.blob".
+
+OPTIONS
+-------
+<dimm>::
+include::xable-dimm-options.txt[]
+
+-m::
+--master::
+	New key name for the master key to seal the new nvdimm key, or the
+	existing master key name. i.e trusted:master-key.
+
+-p::
+--key-path=::
+	Path to where key related files resides. This parameter is optional
+	and the default is set to /etc/ndctl/keys.
+
+include::../copyright.txt[]
diff --git a/configure.ac b/configure.ac
index aa07ec7b..22efc871 100644
--- a/configure.ac
+++ b/configure.ac
@@ -154,6 +154,7 @@ fi
 AC_SUBST([systemd_unitdir])
 AM_CONDITIONAL([ENABLE_SYSTEMD_UNITS], [test "x$with_systemd" = "xyes"])
 
+
 ndctl_monitorconfdir=${sysconfdir}/ndctl
 ndctl_monitorconf=monitor.conf
 AC_SUBST([ndctl_monitorconfdir])
@@ -161,6 +162,24 @@ AC_SUBST([ndctl_monitorconf])
 AC_DEFINE_UNQUOTED(NDCTL_CONF_FILE, ["$ndctl_monitorconfdir/$ndctl_monitorconf"],
 	[default ndctl monitor conf path])
 
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
+ndctl_keysdir=${sysconfdir}/ndctl/keys
+AC_SUBST([ndctl_keysdir])
+AC_DEFINE_UNQUOTED(NDCTL_KEYS_DIR, ["$ndctl_keysdir"],
+	[default ndctl keys path])
+
 my_CFLAGS="\
 -Wall \
 -Wchar-subscripts \
diff --git a/ndctl.spec.in b/ndctl.spec.in
index 26396d4a..66466db6 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -21,6 +21,7 @@ BuildRequires:	pkgconfig(uuid)
 BuildRequires:	pkgconfig(json-c)
 BuildRequires:	pkgconfig(bash-completion)
 BuildRequires:	pkgconfig(systemd)
+BuildRequires:	keyutils-libs-devel
 
 %description
 Utility library for managing the "libnvdimm" subsystem.  The "libnvdimm"
@@ -119,6 +120,7 @@ make check
 %{bashcompdir}/
 %{_sysconfdir}/ndctl/monitor.conf
 %{_unitdir}/ndctl-monitor.service
+%{_sysconfdir}/ndctl/keys/
 
 %files -n daxctl
 %defattr(-,root,root)
diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index ff01e068..120941a4 100644
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
diff --git a/ndctl/builtin.h b/ndctl/builtin.h
index 17300df0..231fda25 100644
--- a/ndctl/builtin.h
+++ b/ndctl/builtin.h
@@ -32,4 +32,6 @@ int cmd_bat(int argc, const char **argv, struct ndctl_ctx *ctx);
 #endif
 int cmd_update_firmware(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_inject_smart(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_passphrase_setup(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_passphrase_update(int argc, const char **argv, struct ndctl_ctx *ctx);
 #endif /* _NDCTL_BUILTIN_H_ */
diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index c717beeb..1ab6b29f 100644
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
+	const char *key_path;
+	const char *master_key;
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
@@ -824,17 +838,31 @@ static int action_update(struct ndctl_dimm *dimm, struct action_context *actx)
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
+	if (!ndctl_dimm_security_supported(dimm)) {
+		error("%s: security operation not supported\n",
+				ndctl_dimm_get_devname(dimm));
+		return -EOPNOTSUPP;
+	}
+
+	return ndctl_dimm_enable_key(dimm, param.master_key,
+			param.key_path);
+}
+
+static int action_key_update(struct ndctl_dimm *dimm,
+		struct action_context *actx)
+{
+	if (!ndctl_dimm_security_supported(dimm)) {
+		error("%s: security operation not supported\n",
+				ndctl_dimm_get_devname(dimm));
+		return -EOPNOTSUPP;
+	}
+
+	return ndctl_dimm_update_key(dimm, param.master_key,
+			param.key_path);
+}
 
 static int __action_init(struct ndctl_dimm *dimm,
 		enum ndctl_namespace_version version, int chk_only)
@@ -925,6 +953,12 @@ OPT_BOOLEAN('f', "force", &param.force, \
 OPT_STRING('V', "label-version", &param.labelversion, "version-number", \
 	"namespace label specification version (default: 1.1)")
 
+#define KEY_OPTIONS() \
+OPT_STRING('m', "master-key", &param.master_key, "<key_type>:<key_name>", \
+		"master key for security"), \
+OPT_FILENAME('p', "key-path", &param.key_path, "key-path", \
+		"override the default key path")
+
 static const struct option read_options[] = {
 	BASE_OPTIONS(),
 	READ_OPTIONS(),
@@ -954,6 +988,12 @@ static const struct option init_options[] = {
 	OPT_END(),
 };
 
+static const struct option key_options[] = {
+	BASE_OPTIONS(),
+	KEY_OPTIONS(),
+	OPT_END(),
+};
+
 static int dimm_action(int argc, const char **argv, struct ndctl_ctx *ctx,
 		int (*action)(struct ndctl_dimm *dimm, struct action_context *actx),
 		const struct option *options, const char *usage)
@@ -1024,6 +1064,13 @@ static int dimm_action(int argc, const char **argv, struct ndctl_ctx *ctx,
 		}
 	}
 
+	if (!param.master_key &&
+			(action == action_key_enable ||
+			 action == action_key_update)) {
+		usage_with_options(u, options);
+		return -EINVAL;
+	}
+
 	if (param.verbose)
 		ndctl_set_log_priority(ctx, LOG_DEBUG);
 
@@ -1042,6 +1089,9 @@ static int dimm_action(int argc, const char **argv, struct ndctl_ctx *ctx,
 		goto out;
 	}
 
+	if (!param.key_path)
+		param.key_path = strdup(NDCTL_KEYS_DIR);
+
 	rc = 0;
 	err = 0;
 	count = 0;
@@ -1181,3 +1231,25 @@ int cmd_update_firmware(int argc, const char **argv, struct ndctl_ctx *ctx)
 			count > 1 ? "s" : "");
 	return count >= 0 ? 0 : EXIT_FAILURE;
 }
+
+int cmd_passphrase_update(int argc, const char **argv, struct ndctl_ctx *ctx)
+{
+	int count = dimm_action(argc, argv, ctx, action_key_update,
+			key_options,
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
+			key_options,
+			"ndctl enable-passphrase <nmem0> [<nmem1>..<nmemN>] [<options>]");
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
index e03135d9..b64c9568 100644
--- a/ndctl/lib/dimm.c
+++ b/ndctl/lib/dimm.c
@@ -624,3 +624,42 @@ NDCTL_EXPORT int ndctl_dimm_get_security(struct ndctl_dimm *dimm,
 
 	return 0;
 }
+
+NDCTL_EXPORT bool ndctl_dimm_security_supported(struct ndctl_dimm *dimm)
+{
+	enum nd_security_state state;
+	int rc;
+
+	rc = ndctl_dimm_get_security(dimm, &state);
+	if (rc < 0)
+		return false;
+
+	if (state == ND_SECURITY_UNSUPPORTED)
+		return false;
+
+	return true;
+}
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
index 00000000..d6eb2690
--- /dev/null
+++ b/ndctl/lib/keys.c
@@ -0,0 +1,394 @@
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
+#define PATH_SIZE	512
+#define DESC_SIZE	128
+#define KEY_CMD_SIZE	128
+
+static int get_key_path(struct ndctl_dimm *dimm, char *path,
+		enum ndctl_key_type key_type, const char *keypath)
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
+				keypath,
+				ndctl_dimm_get_unique_id(dimm),
+				hostname);
+	} else {
+		rc = sprintf(path, "%s/nvdimm_%s_%s.blob",
+				keypath,
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
+	char desc[DESC_SIZE];
+	int rc;
+
+	rc = get_key_desc(dimm, desc, key_type);
+	if (rc < 0)
+		return rc;
+
+	return keyctl_search(KEY_SPEC_USER_KEYRING, "encrypted", desc, 0);
+}
+
+static key_serial_t dimm_create_key(struct ndctl_dimm *dimm,
+		const char *master, const char *keypath)
+{
+	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
+	char desc[DESC_SIZE];
+	char path[PATH_SIZE];
+	char cmd[KEY_CMD_SIZE];
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
+	rc = get_key_path(dimm, path, ND_USER_KEY, keypath);
+	if (rc < 0)
+		return rc;
+
+	rc = stat(path, &st);
+	if (rc == 0) {
+		err(ctx, "%s already exists!\n", path);
+		return -EEXIST;
+	}
+
+	rc = sprintf(cmd, "new enc32 %s 32", master);
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
+		err(ctx, "keyctl_read_alloc failed: %ld\n", size);
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
+		enum ndctl_key_type key_type, const char *keypath)
+{
+	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
+	key_serial_t key;
+	char desc[DESC_SIZE];
+	char path[PATH_SIZE];
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
+	rc = get_key_path(dimm, path, key_type, keypath);
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
+static key_serial_t move_key_to_old(struct ndctl_dimm *dimm,
+		const char *keypath)
+{
+	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
+	int rc;
+	key_serial_t key;
+	char old_path[PATH_SIZE];
+	char new_path[PATH_SIZE];
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
+	rc = get_key_path(dimm, old_path, ND_USER_KEY, keypath);
+	if (rc < 0)
+		return rc;
+
+	rc = get_key_path(dimm, new_path, ND_USER_OLD_KEY, keypath);
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
+	return dimm_load_key(dimm, ND_USER_OLD_KEY, keypath);
+}
+
+static int dimm_remove_key(struct ndctl_dimm *dimm,
+		enum ndctl_key_type key_type, const char *keypath)
+{
+	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
+	key_serial_t key;
+	char path[PATH_SIZE];
+	int rc;
+
+	key = dimm_check_key(dimm, key_type);
+	if (key > 0)
+		keyctl_unlink(key, KEY_SPEC_USER_KEYRING);
+
+	rc = get_key_path(dimm, path, key_type, keypath);
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
+NDCTL_EXPORT int ndctl_dimm_enable_key(struct ndctl_dimm *dimm,
+		const char *master, const char *keypath)
+{
+	key_serial_t key;
+	int rc;
+
+	key = dimm_create_key(dimm, master, keypath);
+	if (key < 0)
+		return key;
+
+	rc = ndctl_dimm_update_passphrase(dimm, 0, key);
+	if (rc < 0) {
+		dimm_remove_key(dimm, ND_USER_KEY, keypath);
+		return rc;
+	}
+
+	return 0;
+}
+
+NDCTL_EXPORT int ndctl_dimm_update_key(struct ndctl_dimm *dimm,
+		const char *master, const char *keypath)
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
+	old_key = move_key_to_old(dimm, keypath);
+	if (old_key < 0)
+		return old_key;
+
+	new_key = dimm_create_key(dimm, master, keypath);
+	/* need to create new key here */
+	if (new_key < 0) {
+		new_key = dimm_load_key(dimm, ND_USER_KEY, keypath);
+		if (new_key < 0)
+			return new_key;
+	}
+
+	rc = ndctl_dimm_update_passphrase(dimm, old_key, new_key);
+	if (rc < 0)
+		return rc;
+
+	rc = dimm_remove_key(dimm, ND_USER_OLD_KEY, keypath);
+	if (rc < 0)
+		return rc;
+
+	return 0;
+}
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 1bd63fa1..a790b1ea 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -389,4 +389,8 @@ global:
 LIBNDCTL_19 {
 global:
 	ndctl_dimm_get_security;
+	ndctl_dimm_security_supported;
+	ndctl_dimm_enable_key;
+	ndctl_dimm_update_key;
+	ndctl_dimm_update_passphrase;
 } LIBNDCTL_18;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 4255252c..87384f71 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -19,6 +19,7 @@
 #include <unistd.h>
 #include <errno.h>
 #include <limits.h>
+#include <keyutils.h>
 
 #ifdef HAVE_UUID
 #include <uuid/uuid.h>
@@ -681,6 +682,10 @@ enum ND_FW_STATUS ndctl_cmd_fw_xlat_firmware_status(struct ndctl_cmd *cmd);
 struct ndctl_cmd *ndctl_dimm_cmd_new_ack_shutdown_count(struct ndctl_dimm *dimm);
 int ndctl_dimm_fw_update_supported(struct ndctl_dimm *dimm);
 
+#define ND_PASSPHRASE_SIZE	32
+#define ND_KEY_DESC_LEN	22
+#define ND_KEY_DESC_PREFIX  7
+
 enum nd_security_state {
 	ND_SECURITY_INVALID = -1,
 	ND_SECURITY_UNSUPPORTED = 0,
@@ -693,6 +698,33 @@ enum nd_security_state {
 
 int ndctl_dimm_get_security(struct ndctl_dimm *dimm,
 		enum nd_security_state *sstate);
+bool ndctl_dimm_security_supported(struct ndctl_dimm *dimm);
+int ndctl_dimm_update_passphrase(struct ndctl_dimm *dimm,
+		long ckey, long nkey);
+
+enum ndctl_key_type {
+	ND_USER_KEY,
+	ND_USER_OLD_KEY,
+};
+
+#ifdef ENABLE_KEYUTILS
+int ndctl_dimm_enable_key(struct ndctl_dimm *dimm, const char *master,
+		const char *keypath);
+int ndctl_dimm_update_key(struct ndctl_dimm *dimm, const char *master,
+		const char *keypath);
+#else
+static inline int ndctl_dimm_enable_key(struct ndctl_dimm *dimm,
+		const char *master, const char *keypath)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int ndctl_dimm_update_key(struct ndctl_dimm *dimm,
+		const char *master, const char *keypath)
+{
+	return -EOPNOTSUPP;
+}
+#endif
 
 #ifdef __cplusplus
 } /* extern "C" */
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index b01594e0..9d109b34 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -88,6 +88,8 @@ static struct cmd_struct commands[] = {
 	{ "inject-smart", { cmd_inject_smart } },
 	{ "wait-scrub", { cmd_wait_scrub } },
 	{ "start-scrub", { cmd_start_scrub } },
+	{ "enable-passphrase", { cmd_passphrase_setup } },
+	{ "update-passphrase", { cmd_passphrase_update } },
 	{ "list", { cmd_list } },
 	{ "monitor", { cmd_monitor } },
 	{ "help", { cmd_help } },

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
