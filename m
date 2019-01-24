Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D003C211B85E6
 for <linux-nvdimm@lists.01.org>; Thu, 24 Jan 2019 15:07:16 -0800 (PST)
Subject: [PATCH v10 02/12] ndctl: add passphrase update to ndctl
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 24 Jan 2019 16:07:15 -0700
Message-ID: <154837123565.37086.2456954752128201392.stgit@djiang5-desk3.ch.intel.com>
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

Add API call for triggering sysfs knob to update the security for a DIMM
in libndctl. Also add the ndctl "update-passphrase" to trigger the
operation.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ndctl/Makefile.am                 |    5 
 Documentation/ndctl/ndctl-setup-passphrase.txt  |   47 ++
 Documentation/ndctl/ndctl-update-passphrase.txt |   51 +++
 configure.ac                                    |   17 +
 ndctl.spec.in                                   |    2 
 ndctl/Makefile.am                               |    5 
 ndctl/builtin.h                                 |    2 
 ndctl/dimm.c                                    |   83 ++++
 ndctl/lib/Makefile.am                           |    4 
 ndctl/lib/dimm.c                                |   24 +
 ndctl/lib/libndctl.sym                          |    1 
 ndctl/libndctl.h                                |    9 
 ndctl/ndctl.c                                   |    2 
 ndctl/util/keys.c                               |  460 +++++++++++++++++++++++
 ndctl/util/keys.h                               |   29 +
 15 files changed, 729 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/ndctl/ndctl-setup-passphrase.txt
 create mode 100644 Documentation/ndctl/ndctl-update-passphrase.txt
 create mode 100644 ndctl/util/keys.c
 create mode 100644 ndctl/util/keys.h

diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
index 7e17f206..79b12f8b 100644
--- a/Documentation/ndctl/Makefile.am
+++ b/Documentation/ndctl/Makefile.am
@@ -47,7 +47,9 @@ man1_MANS = \
 	ndctl-inject-smart.1 \
 	ndctl-update-firmware.1 \
 	ndctl-list.1 \
-	ndctl-monitor.1
+	ndctl-monitor.1 \
+	ndctl-setup-passphrase.1 \
+	ndctl-update-passphrase.1
 
 CLEANFILES = $(man1_MANS)
 
@@ -56,6 +58,7 @@ attrs.adoc: $(srcdir)/Makefile.am
 	$(AM_V_GEN) cat <<- EOF >$@
 		:ndctl_monitorconfdir: $(ndctl_monitorconfdir)
 		:ndctl_monitorconf: $(ndctl_monitorconf)
+		:ndctl_keysdir: $(ndctl_keysdir)
 		EOF
 
 XML_DEPS = \
diff --git a/Documentation/ndctl/ndctl-setup-passphrase.txt b/Documentation/ndctl/ndctl-setup-passphrase.txt
new file mode 100644
index 00000000..1594f110
--- /dev/null
+++ b/Documentation/ndctl/ndctl-setup-passphrase.txt
@@ -0,0 +1,47 @@
+// SPDX-License-Identifier: GPL-2.0
+
+include::attrs.adoc[]
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
+'ndctl setup-passphrase' <nmem0> [<nmem1>..<nmemN>] -k <key_handle> [<options>]
+
+DESCRIPTION
+-----------
+Enable the security passphrase for one or more NVDIMMs.
+
+Prerequisite for command to succeed:
+1. The master key has already been loaded into the user key ring.
+2. ndctl install-encrypt-key has been executed successfully.
+
+The encrypted key blobs will be created by ndctl in {ndctl_keysdir} directory
+with the file name of "nvdimm_<dimm unique id>_<hostname>.blob".
+
+The command will fail if the nvdimm key is already in the user key ring and/or
+the key blob already resides in {ndctl_keysdir}.
+
+OPTIONS
+-------
+<dimm>::
+include::xable-dimm-options.txt[]
+
+-k::
+--key_handle=::
+	The encryption key (master) key handle, used for sealing the DIMM
+	encrypted keys. The format is <key type>:<key description>.
+	i.e. trusted:nvdimm-master
+	This key is expected to be loaded in the kernel's user keyring.
+
+-v::
+--verbose::
+        Emit debug messages for the namespace check process.
+
+include::../copyright.txt[]
diff --git a/Documentation/ndctl/ndctl-update-passphrase.txt b/Documentation/ndctl/ndctl-update-passphrase.txt
new file mode 100644
index 00000000..05573968
--- /dev/null
+++ b/Documentation/ndctl/ndctl-update-passphrase.txt
@@ -0,0 +1,51 @@
+// SPDX-License-Identifier: GPL-2.0
+
+include::attrs.adoc[]
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
+The updated key blobs will be created by ndctl in {ndctl_keysdir} directory
+with the file name of "nvdimm_<dimm unique id>_<hostname>.blob".
+
+OPTIONS
+-------
+<dimm>::
+include::xable-dimm-options.txt[]
+
+-k::
+--key_handle=::
+	The new encryption key (master) key handle, used for sealing the DIMM
+	encrypted keys. The format is <key type>:<key description>.
+	i.e. trusted:nvdimm-master
+	This key is expected to be loaded in the kernel's user keyring.
+	This parameter is optional. If none provided, ndctl will determine
+	the current key handle from the encrypted key for the NVDIMM.
+
+-v::
+--verbose::
+        Emit debug messages for the namespace check process.
+
+include::../copyright.txt[]
+
+SEE ALSO:
+---------
+linkndctl:ndctl-setup-passphrase[1]
diff --git a/configure.ac b/configure.ac
index 5b4f1fc8..b08ddaf1 100644
--- a/configure.ac
+++ b/configure.ac
@@ -164,6 +164,23 @@ daxctl_modprobe_data=daxctl.conf
 AC_SUBST([daxctl_modprobe_datadir])
 AC_SUBST([daxctl_modprobe_data])
 
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
+
+ndctl_keysdir=${sysconfdir}/ndctl/keys
+AC_SUBST([ndctl_keysdir])
+
 my_CFLAGS="\
 -Wall \
 -Wchar-subscripts \
diff --git a/ndctl.spec.in b/ndctl.spec.in
index bc65a471..c075a0a0 100644
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
 
diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index c7c1ac6e..28b4e09b 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -8,6 +8,7 @@ config.h: $(srcdir)/Makefile.am
 	$(AM_V_GEN) echo "/* Autogenerated by ndctl/Makefile.am */" >$@ && \
 	echo '#define NDCTL_CONF_FILE \
 		"$(ndctl_monitorconfdir)/$(ndctl_monitorconf)"' >>$@
+	$(AM_V_GEN) echo '#define NDCTL_KEYS_DIR  "$(ndctl_keysdir)"' >>$@
 
 ndctl_SOURCES = ndctl.c \
 		bus.c \
@@ -25,6 +26,10 @@ ndctl_SOURCES = ndctl.c \
 		inject-smart.c \
 		monitor.c
 
+if ENABLE_KEYUTILS
+ndctl_SOURCES += util/keys.c
+endif
+
 if ENABLE_DESTRUCTIVE
 ndctl_SOURCES += ../test/blk_namespaces.c \
 		 ../test/pmem_namespaces.c
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
index c717beeb..88319b31 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -31,6 +31,7 @@
 #include <ccan/minmax/minmax.h>
 #include <ccan/array_size/array_size.h>
 #include <ndctl/firmware-update.h>
+#include <util/keys.h>
 
 struct action_context {
 	struct json_object *jdimms;
@@ -40,6 +41,19 @@ struct action_context {
 	struct update_context update;
 };
 
+static struct parameters {
+	const char *bus;
+	const char *outfile;
+	const char *infile;
+	const char *labelversion;
+	const char *kek;
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
@@ -824,17 +838,32 @@ static int action_update(struct ndctl_dimm *dimm, struct action_context *actx)
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
+static int action_passphrase_setup(struct ndctl_dimm *dimm,
+		struct action_context *actx)
+{
+	if (ndctl_dimm_get_security(dimm) < 0) {
+		error("%s: security operation not supported\n",
+				ndctl_dimm_get_devname(dimm));
+		return -EOPNOTSUPP;
+	}
+
+	if (!param.kek)
+		return -EINVAL;
+
+	return ndctl_dimm_setup_key(dimm, param.kek);
+}
+
+static int action_passphrase_update(struct ndctl_dimm *dimm,
+		struct action_context *actx)
+{
+	if (ndctl_dimm_get_security(dimm) < 0) {
+		error("%s: security operation not supported\n",
+				ndctl_dimm_get_devname(dimm));
+		return -EOPNOTSUPP;
+	}
+
+	return ndctl_dimm_update_key(dimm, param.kek);
+}
 
 static int __action_init(struct ndctl_dimm *dimm,
 		enum ndctl_namespace_version version, int chk_only)
@@ -925,6 +954,10 @@ OPT_BOOLEAN('f', "force", &param.force, \
 OPT_STRING('V', "label-version", &param.labelversion, "version-number", \
 	"namespace label specification version (default: 1.1)")
 
+#define KEY_OPTIONS() \
+OPT_STRING('k', "key-handle", &param.kek, "key-handle", \
+		"master encryption key handle")
+
 static const struct option read_options[] = {
 	BASE_OPTIONS(),
 	READ_OPTIONS(),
@@ -954,6 +987,12 @@ static const struct option init_options[] = {
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
@@ -1181,3 +1220,25 @@ int cmd_update_firmware(int argc, const char **argv, struct ndctl_ctx *ctx)
 			count > 1 ? "s" : "");
 	return count >= 0 ? 0 : EXIT_FAILURE;
 }
+
+int cmd_passphrase_update(int argc, const char **argv, struct ndctl_ctx *ctx)
+{
+	int count = dimm_action(argc, argv, ctx, action_passphrase_update,
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
+	int count = dimm_action(argc, argv, ctx, action_passphrase_setup,
+			key_options,
+			"ndctl setup-passphrase <nmem0> [<nmem1>..<nmemN>] [<options>]");
+
+	fprintf(stderr, "passphrase enabled for %d nmem%s.\n", count >= 0 ? count : 0,
+			count > 1 ? "s" : "");
+	return count >= 0 ? 0 : EXIT_FAILURE;
+}
diff --git a/ndctl/lib/Makefile.am b/ndctl/lib/Makefile.am
index 77970399..99eaae0d 100644
--- a/ndctl/lib/Makefile.am
+++ b/ndctl/lib/Makefile.am
@@ -30,6 +30,10 @@ libndctl_la_LIBADD =\
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
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 0888c824..88557710 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -391,4 +391,5 @@ global:
 	ndctl_cmd_xlat_firmware_status;
 	ndctl_cmd_submit_xlat;
 	ndctl_dimm_get_security;
+	ndctl_dimm_update_passphrase;
 } LIBNDCTL_18;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index e228c64f..85c1537a 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -684,6 +684,10 @@ int ndctl_dimm_fw_update_supported(struct ndctl_dimm *dimm);
 int ndctl_cmd_xlat_firmware_status(struct ndctl_cmd *cmd);
 int ndctl_cmd_submit_xlat(struct ndctl_cmd *cmd);
 
+#define ND_PASSPHRASE_SIZE	32
+#define ND_KEY_DESC_LEN	22
+#define ND_KEY_DESC_PREFIX  7
+
 enum ndctl_security_state {
 	NDCTL_SECURITY_INVALID = -1,
 	NDCTL_SECURITY_DISABLED = 0,
@@ -694,6 +698,11 @@ enum ndctl_security_state {
 };
 
 enum ndctl_security_state ndctl_dimm_get_security(struct ndctl_dimm *dimm);
+int ndctl_dimm_update_passphrase(struct ndctl_dimm *dimm,
+		long ckey, long nkey);
+
+#define ND_KEY_DESC_SIZE	128
+#define ND_KEY_CMD_SIZE		128
 
 #ifdef __cplusplus
 } /* extern "C" */
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index b01594e0..5cb5fa4f 100644
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
 	{ "help", { cmd_help } },
diff --git a/ndctl/util/keys.c b/ndctl/util/keys.c
new file mode 100644
index 00000000..1592ff09
--- /dev/null
+++ b/ndctl/util/keys.c
@@ -0,0 +1,460 @@
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
+#include <ndctl/config.h>
+#include <ndctl/libndctl.h>
+#include <util/keys.h>
+
+static int get_key_path(struct ndctl_dimm *dimm, char *path,
+		enum ndctl_key_type key_type)
+{
+	char hostname[HOST_NAME_MAX];
+	int rc;
+
+	rc = gethostname(hostname, HOST_NAME_MAX);
+	if (rc < 0) {
+		fprintf(stderr, "gethostname: %s\n", strerror(errno));
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
+		fprintf(stderr, "error setting path: %s\n", strerror(errno));
+		return -errno;
+	}
+
+	return 0;
+}
+
+static int get_key_desc(struct ndctl_dimm *dimm, char *desc,
+		enum ndctl_key_type key_type)
+{
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
+		fprintf(stderr, "error setting key description: %s\n",
+				strerror(errno));
+		return -errno;
+	}
+
+	return 0;
+}
+
+static char *load_key_blob(const char *path, int *size)
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
+		fprintf(stderr, "stat: %s\n", strerror(errno));
+		return NULL;
+	}
+	if ((st.st_mode & S_IFMT) != S_IFREG) {
+		fprintf(stderr, "%s not a regular file\n", path);
+		return NULL;
+	}
+
+	if (st.st_size == 0 || st.st_size > 4096) {
+		fprintf(stderr, "Invalid blob file size\n");
+		return NULL;
+	}
+
+	*size = st.st_size + sizeof(prefix) - 1;
+	blob = malloc(*size);
+	if (!blob) {
+		fprintf(stderr, "Unable to allocate memory for blob\n");
+		return NULL;
+	}
+
+	bfile = fopen(path, "r");
+	if (!bfile) {
+		fprintf(stderr, "Unable to open %s: %s\n", path, strerror(errno));
+		free(blob);
+		return NULL;
+	}
+
+	memcpy(blob, prefix, sizeof(prefix) - 1);
+	pl = blob + sizeof(prefix) - 1;
+	read = fread(pl, st.st_size, 1, bfile);
+	if (read < 0) {
+		fprintf(stderr, "Failed to read from blob file: %s\n",
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
+static key_serial_t dimm_create_key(struct ndctl_dimm *dimm,
+		const char *kek)
+{
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
+		fprintf(stderr, "regions active on %s, op failed\n",
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
+		fprintf(stderr, "Error: key already present in user keyring\n");
+		return -EEXIST;
+	}
+
+	rc = get_key_path(dimm, path, ND_USER_KEY);
+	if (rc < 0)
+		return rc;
+
+	rc = stat(path, &st);
+	if (rc == 0) {
+		fprintf(stderr, "%s already exists!\n", path);
+		return -EEXIST;
+	}
+
+	rc = sprintf(cmd, "new enc32 %s 32", kek);
+	if (rc < 0) {
+		fprintf(stderr, "sprintf: %s\n", strerror(errno));
+		return -errno;
+	}
+
+	key = add_key("encrypted", desc, cmd, strlen(cmd),
+			KEY_SPEC_USER_KEYRING);
+	if (key < 0) {
+		fprintf(stderr, "add_key failed: %s\n", strerror(errno));
+		return -errno;
+	}
+
+	size = keyctl_read_alloc(key, &buffer);
+	if (size < 0) {
+		fprintf(stderr, "keyctl_read_alloc failed: %s\n", strerror(errno));
+		keyctl_unlink(key, KEY_SPEC_USER_KEYRING);
+		return rc;
+	}
+
+	fp = fopen(path, "w");
+	if (!fp) {
+		rc = -errno;
+		fprintf(stderr, "Unable to open file %s: %s\n",
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
+		 fprintf(stderr, "Failed to write to %s: %s\n",
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
+	key_serial_t key;
+	char desc[ND_KEY_DESC_SIZE];
+	char path[PATH_MAX];
+	int rc;
+	char *blob;
+	int size;
+
+	if (ndctl_dimm_is_active(dimm)) {
+		fprintf(stderr, "regions active on %s, op failed\n",
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
+	blob = load_key_blob(path, &size);
+	if (!blob)
+		return -ENOMEM;
+
+	key = add_key("encrypted", desc, blob, size, KEY_SPEC_USER_KEYRING);
+	free(blob);
+	if (key < 0) {
+		fprintf(stderr, "add_key failed: %s\n", strerror(errno));
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
+	int rc;
+	key_serial_t key;
+	char old_path[PATH_MAX];
+	char new_path[PATH_MAX];
+
+	if (ndctl_dimm_is_active(dimm)) {
+		fprintf(stderr, "regions active on %s, op failed\n",
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
+		fprintf(stderr, "rename failed from %s to %s: %s\n",
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
+		fprintf(stderr, "delete file %s failed: %s\n",
+				path, strerror(errno));
+		return -errno;
+	}
+
+	return 0;
+}
+
+static int verify_kek(struct ndctl_dimm *dimm, const char *kek)
+{
+	char *type, *desc, *key_handle;
+	key_serial_t key;
+
+	key_handle = strdup(kek);
+	if (!key_handle)
+		return -ENOMEM;
+
+	type = strtok(key_handle, ":");
+	if (!type) {
+		fprintf(stderr, "No key type found for kek handle\n");
+		return -EINVAL;
+	}
+
+	if (strcmp(type, "trusted") != 0 &&
+			strcmp(type, "user") != 0) {
+		fprintf(stderr, "No such key type: %s", type);
+		return -EINVAL;
+	}
+
+	desc = strtok(NULL, ":");
+	if (!desc) {
+		fprintf(stderr, "No description found for kek handle\n");
+		return -EINVAL;
+	}
+
+	key = keyctl_search(KEY_SPEC_USER_KEYRING, type, desc, 0);
+	if (key < 0) {
+		fprintf(stderr, "No key encryption key found\n");
+		return key;
+	}
+
+	free(key_handle);
+	return 0;
+}
+
+int ndctl_dimm_setup_key(struct ndctl_dimm *dimm, const char *kek)
+{
+	key_serial_t key;
+	int rc;
+
+	rc = verify_kek(dimm, kek);
+	if (rc < 0)
+		return rc;
+
+	key = dimm_create_key(dimm, kek);
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
+static char *get_current_kek(struct ndctl_dimm *dimm)
+{
+	key_serial_t key;
+	char *key_buf;
+	long rc;
+	char *type, *desc;
+
+	key = dimm_check_key(dimm, ND_USER_KEY);
+	if (key < 0)
+		return NULL;
+
+	rc = keyctl_read_alloc(key, (void **)&key_buf);
+	if (rc < 0)
+		return NULL;
+
+	rc = sscanf(key_buf, "%ms %ms", &type, &desc);
+	if (rc < 0)
+		return NULL;
+
+	free(key_buf);
+	free(type);
+
+	return desc;
+}
+
+int ndctl_dimm_update_key(struct ndctl_dimm *dimm, const char *kek)
+{
+	int rc;
+	key_serial_t old_key, new_key;
+	char *current_kek = NULL;
+
+	if (kek) {
+		rc = verify_kek(dimm, kek);
+		if (rc < 0)
+			return rc;
+	} else { /* find current kek */
+		current_kek = get_current_kek(dimm);
+		if (!current_kek)
+			return -ENOKEY;
+	}
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
+	new_key = dimm_create_key(dimm, current_kek ? current_kek : kek);
+	free(current_kek);
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
diff --git a/ndctl/util/keys.h b/ndctl/util/keys.h
new file mode 100644
index 00000000..2cebdf0c
--- /dev/null
+++ b/ndctl/util/keys.h
@@ -0,0 +1,29 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2019 Intel Corporation. All rights reserved. */
+
+#ifndef _NDCTL_UTIL_KEYS_H_
+#define _NDCTL_UTIL_KEYS_H_
+
+enum ndctl_key_type {
+	ND_USER_KEY,
+	ND_USER_OLD_KEY,
+};
+
+#ifdef ENABLE_KEYUTILS
+int ndctl_dimm_setup_key(struct ndctl_dimm *dimm, const char *kek);
+int ndctl_dimm_update_key(struct ndctl_dimm *dimm, const char *kek);
+#else
+static inline int ndctl_dimm_setup_key(struct ndctl_dimm *dimm,
+		const char *kek)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int ndctl_dimm_update_key(struct ndctl_dimm *dimm,
+		const char *kek)
+{
+	return -EOPNOTSUPP;
+}
+#endif /* ENABLE_KEYUTILS */
+
+#endif

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
