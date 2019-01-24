Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5E23B211B81A5
 for <linux-nvdimm@lists.01.org>; Thu, 24 Jan 2019 15:07:44 -0800 (PST)
Subject: [PATCH v10 07/12] ndctl: add modprobe conf file and load-keys ndctl
 command
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 24 Jan 2019 16:07:43 -0700
Message-ID: <154837126335.37086.2736147926414652351.stgit@djiang5-desk3.ch.intel.com>
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

Add load-keys command to ndctl. This will attempt to load the master key
and the related encrypted keys for nvdimms. Also add reference config file
for modprobe.d in order to call ndctl load-keys and inject keys associated
with the nvdimms into the kernel user ring for unlock.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ndctl/Makefile.am         |    3 
 Documentation/ndctl/ndctl-load-keys.txt |   45 +++++
 Makefile.am                             |    4 
 contrib/nvdimm-security.conf            |    1 
 ndctl.spec.in                           |    1 
 ndctl/Makefile.am                       |    3 
 ndctl/builtin.h                         |    1 
 ndctl/load-keys.c                       |  256 +++++++++++++++++++++++++++++++
 ndctl/ndctl.c                           |    1 
 ndctl/util/keys.c                       |   65 +++++---
 ndctl/util/keys.h                       |    7 +
 test/security.sh                        |    2 
 12 files changed, 363 insertions(+), 26 deletions(-)
 create mode 100644 Documentation/ndctl/ndctl-load-keys.txt
 create mode 100644 contrib/nvdimm-security.conf
 create mode 100644 ndctl/load-keys.c

diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
index fa4a1263..f64619b0 100644
--- a/Documentation/ndctl/Makefile.am
+++ b/Documentation/ndctl/Makefile.am
@@ -52,7 +52,8 @@ man1_MANS = \
 	ndctl-update-passphrase.1 \
 	ndctl-remove-passphrase.1 \
 	ndctl-freeze-security.1 \
-	ndctl-sanitize-dimm.1
+	ndctl-sanitize-dimm.1 \
+	ndctl-load-keys.1
 
 CLEANFILES = $(man1_MANS)
 
diff --git a/Documentation/ndctl/ndctl-load-keys.txt b/Documentation/ndctl/ndctl-load-keys.txt
new file mode 100644
index 00000000..d0221c4c
--- /dev/null
+++ b/Documentation/ndctl/ndctl-load-keys.txt
@@ -0,0 +1,45 @@
+// SPDX-License-Identifier: GPL-2.0
+
+include::attrs.adoc[]
+
+ndctl-load-keys(1)
+==================
+
+NAME
+----
+ndctl-load-keys - load encrypted keys with security passphrases for NVDIMM
+
+SYNOPSIS
+--------
+[verse]
+'ndctl load-keys' [<options>]
+
+DESCRIPTION
+-----------
+Provide a command to load the master key and the nvdimm encrypted keys for
+NVDIMM security operations. This command is expected to be called during
+initialization and before the libnvdimm kernel module is loaded. This works
+in conjunction with the provided module config file.
+
+NOTE: All nvdimm keys files are expected to be in format of:
+nvdimm_<id>_hostname
+The char '_' is used to deliminate the components in the file name. The char
+'_' can be used for any purpose starting with the hostname component and after.
+
+This command is typically never called directly by a user. It is only run via
+modprobe during early init.
+
+OPTIONS
+-------
+-p::
+--key-path=::
+	Path to where key related files reside. This parameter is optional
+	and the default is set to {ndctl_keysdir}.
+
+-t::
+--tpm-handle=::
+	Provide the TPM handle (should be a string such as 0x81000001) can
+	be optional if the key path contains a file called tpm.handle which
+	has the handle.
+
+include::../copyright.txt[]
diff --git a/Makefile.am b/Makefile.am
index e0c463a3..df8797ef 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -42,6 +42,10 @@ bashcompletiondir = $(BASH_COMPLETION_DIR)
 dist_bashcompletion_DATA = contrib/ndctl
 endif
 
+modprobe_file = contrib/nvdimm-security.conf
+modprobedir = $(sysconfdir)/modprobe.d/
+modprobe_DATA = $(modprobe_file)
+
 noinst_LIBRARIES = libccan.a
 libccan_a_SOURCES = \
 	ccan/str/str.h \
diff --git a/contrib/nvdimm-security.conf b/contrib/nvdimm-security.conf
new file mode 100644
index 00000000..e2bb7c0a
--- /dev/null
+++ b/contrib/nvdimm-security.conf
@@ -0,0 +1 @@
+install libnvdimm /usr/bin/ndctl load-keys ; /sbin/modprobe --ignore-install libnvdimm $CMDLINE_OPTS
diff --git a/ndctl.spec.in b/ndctl.spec.in
index c075a0a0..0c8d6b40 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -120,6 +120,7 @@ make check
 %{bashcompdir}/
 %{_unitdir}/ndctl-monitor.service
 %{_sysconfdir}/ndctl/keys/
+%{_sysconfdir}/modprobe.d/nvdimm-security.conf
 
 %config(noreplace) %{_sysconfdir}/ndctl/monitor.conf
 
diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index 28b4e09b..cd3312ba 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -27,7 +27,8 @@ ndctl_SOURCES = ndctl.c \
 		monitor.c
 
 if ENABLE_KEYUTILS
-ndctl_SOURCES += util/keys.c
+ndctl_SOURCES += util/keys.c \
+		load-keys.c
 endif
 
 if ENABLE_DESTRUCTIVE
diff --git a/ndctl/builtin.h b/ndctl/builtin.h
index a474ec1a..733f41a5 100644
--- a/ndctl/builtin.h
+++ b/ndctl/builtin.h
@@ -37,4 +37,5 @@ int cmd_passphrase_update(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_passphrase_remove(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_freeze_security(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_sanitize_dimm(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_load_keys(int argc, const char **argv, struct ndctl_ctx *ctx);
 #endif /* _NDCTL_BUILTIN_H_ */
diff --git a/ndctl/load-keys.c b/ndctl/load-keys.c
new file mode 100644
index 00000000..184fa2dd
--- /dev/null
+++ b/ndctl/load-keys.c
@@ -0,0 +1,256 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2019 Intel Corporation. All rights reserved. */
+
+#include <stdio.h>
+#include <errno.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <limits.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <dirent.h>
+#include <fcntl.h>
+#include <keyutils.h>
+#include <util/json.h>
+#include <util/filter.h>
+#include <json-c/json.h>
+#include <ndctl/libndctl.h>
+#include <util/parse-options.h>
+#include <ccan/array_size/array_size.h>
+#include <util/keys.h>
+#include <ndctl.h>
+
+static struct parameters {
+	const char *key_path;
+	const char *tpm_handle;
+} param;
+
+enum key_type {
+	KEY_USER = 0,
+	KEY_TRUSTED,
+};
+
+static const char *key_names[] = {"user", "trusted"};
+
+static struct loadkeys {
+	enum key_type key_type;
+	DIR *dir;
+	int dirfd;
+} loadkey_ctx;
+
+static int load_master_key(struct loadkeys *lk_ctx, const char *keypath)
+{
+	key_serial_t key;
+	char *blob;
+	int size, rc;
+	char path[PATH_MAX];
+
+	rc = sprintf(path, "%s/nvdimm-master.blob", keypath);
+	if (rc < 0)
+		return -errno;
+
+	if (param.tpm_handle)
+		lk_ctx->key_type = KEY_TRUSTED;
+	else
+		lk_ctx->key_type = KEY_USER;
+
+	key = keyctl_search(KEY_SPEC_USER_KEYRING,
+			key_names[lk_ctx->key_type], "nvdimm-master", 0);
+	if (key > 0)	/* check to see if key already loaded */
+		return 0;
+
+	if (key < 0 && errno != ENOKEY) {
+		fprintf(stderr, "keyctl_search() failed: %s\n",
+				strerror(errno));
+		return -errno;
+	}
+
+	blob = ndctl_load_key_blob(path, &size, param.tpm_handle, -1);
+	if (!blob)
+		return -ENOMEM;
+
+	key = add_key(key_names[lk_ctx->key_type], "nvdimm-master",
+			blob, size, KEY_SPEC_USER_KEYRING);
+	free(blob);
+	if (key < 0) {
+		fprintf(stderr, "add_key failed: %s\n", strerror(errno));
+		return -errno;
+	}
+
+	printf("nvdimm master key loaded.\n");
+
+	return 0;
+}
+
+static int load_dimm_keys(struct loadkeys *lk_ctx)
+{
+	int rc;
+	struct dirent *dent;
+	char *fname, *id, *blob;
+	char desc[ND_KEY_DESC_SIZE];
+	int size, count = 0;
+	key_serial_t key;
+
+	while ((dent = readdir(lk_ctx->dir)) != NULL) {
+		if (dent->d_type != DT_REG)
+			continue;
+
+		fname = strdup(dent->d_name);
+		if (!fname) {
+			fprintf(stderr, "Unable to strdup %s\n",
+					dent->d_name);
+			return -ENOMEM;
+		}
+
+		/*
+		 * We want to pick up the second member of the file name
+		 * as the nvdimm id.
+		 */
+		id = strtok(fname, "_");
+		if (!id)
+			continue;
+		if (strcmp(id, "nvdimm") != 0)
+			continue;
+		id = strtok(NULL, "_");
+		if (!id)
+			continue;
+
+		blob = ndctl_load_key_blob(dent->d_name, &size, NULL,
+				lk_ctx->dirfd);
+		if (!blob) {
+			free(fname);
+			continue;
+		}
+
+		rc = sprintf(desc, "nvdimm:%s", id);
+		if (rc < 0) {
+			free(fname);
+			free(blob);
+			continue;
+		}
+
+		key = add_key("encrypted", desc, blob, size,
+				KEY_SPEC_USER_KEYRING);
+		if (key < 0)
+			fprintf(stderr, "add_key failed: %s\n",
+					strerror(errno));
+		else
+			count++;
+		free(fname);
+		free(blob);
+	}
+
+	printf("%d nvdimm keys loaded\n", count);
+
+	return 0;
+}
+
+static int check_tpm_handle(struct loadkeys *lk_ctx)
+{
+	int fd, rc;
+	FILE *fs;
+	char *buf;
+
+	fd = openat(lk_ctx->dirfd, "tpm.handle", O_RDONLY);
+	if (fd < 0)
+		return -errno;
+
+	fs = fdopen(fd, "r");
+	if (!fs) {
+		fprintf(stderr, "Failed to open file stream: %s\n",
+				strerror(errno));
+		return -errno;
+	}
+
+	rc = fscanf(fs, "%ms", &buf);
+	if (rc < 0) {
+		rc = -errno;
+		fprintf(stderr, "Failed to read file: %s\n", strerror(errno));
+		fclose(fs);
+		return rc;
+	}
+
+	param.tpm_handle = buf;
+	fclose(fs);
+	return 0;
+}
+
+static int load_keys(struct loadkeys *lk_ctx, const char *keypath,
+		const char *tpmhandle)
+{
+	int rc;
+
+	rc = chdir(keypath);
+	if (rc < 0) {
+		rc = -errno;
+		fprintf(stderr, "Change current work dir to %s failed: %s\n",
+				param.key_path, strerror(errno));
+		rc = -errno;
+		goto erropen;
+	}
+
+	lk_ctx->dir = opendir(param.key_path);
+	if (!lk_ctx->dir) {
+		fprintf(stderr, "Unable to open dir %s: %s\n",
+				param.key_path, strerror(errno));
+		rc = -errno;
+		goto erropen;
+	}
+
+	lk_ctx->dirfd = open(param.key_path, O_DIRECTORY);
+	if (lk_ctx->dirfd < 0) {
+		fprintf(stderr, "Unable to open dir %s: %s\n",
+				param.key_path, strerror(errno));
+		rc = -errno;
+		goto erropen;
+	}
+
+	if (!tpmhandle) {
+		rc = check_tpm_handle(lk_ctx);
+		if (rc < 0) {
+			rc = -errno;
+			goto erropen;
+		}
+	}
+
+	rc = load_master_key(lk_ctx, param.key_path);
+	if (rc < 0)
+		goto out;
+
+	rc = load_dimm_keys(lk_ctx);
+	if (rc < 0)
+		goto out;
+
+     out:
+	close(lk_ctx->dirfd);
+ erropen:
+	closedir(lk_ctx->dir);
+	return rc;
+}
+
+int cmd_load_keys(int argc, const char **argv, struct ndctl_ctx *ctx)
+{
+	const struct option options[] = {
+		OPT_FILENAME('p', "key-path", &param.key_path, "key-path",
+				"override the default key path"),
+		OPT_STRING('t', "tpm-handle", &param.tpm_handle, "tpm-handle",
+				"TPM handle for trusted key"),
+		OPT_END(),
+	};
+	const char *const u[] = {
+		"ndctl load-keys [<options>]",
+		NULL
+	};
+	int i;
+
+	argc = parse_options(argc, argv, options, u, 0);
+	for (i = 0; i < argc; i++)
+		error("unknown parameter \"%s\"\n", argv[i]);
+	if (argc)
+		usage_with_options(u, options);
+
+	if (!param.key_path)
+		param.key_path = strdup(NDCTL_KEYS_DIR);
+
+	return load_keys(&loadkey_ctx, param.key_path, param.tpm_handle);
+}
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index 0274e9b7..041f66be 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -93,6 +93,7 @@ static struct cmd_struct commands[] = {
 	{ "remove-passphrase", { cmd_passphrase_remove } },
 	{ "freeze-security", { cmd_freeze_security } },
 	{ "sanitize-dimm", { cmd_sanitize_dimm } },
+	{ "load-keys", { cmd_load_keys } },
 	{ "list", { cmd_list } },
 	{ "monitor", { cmd_monitor } },
 	{ "help", { cmd_help } },
diff --git a/ndctl/util/keys.c b/ndctl/util/keys.c
index 4e0ac607..6f3d0830 100644
--- a/ndctl/util/keys.c
+++ b/ndctl/util/keys.c
@@ -8,6 +8,7 @@
 #include <unistd.h>
 #include <sys/stat.h>
 #include <sys/types.h>
+#include <fcntl.h>
 #include <sys/param.h>
 #include <keyutils.h>
 #include <syslog.h>
@@ -70,16 +71,23 @@ static int get_key_desc(struct ndctl_dimm *dimm, char *desc,
 	return 0;
 }
 
-static char *load_key_blob(const char *path, int *size)
+char *ndctl_load_key_blob(const char *path, int *size, const char *postfix,
+		int dirfd)
 {
 	struct stat st;
-	FILE *bfile = NULL;
-	ssize_t read;
-	int rc;
-	char *blob, *pl;
+	ssize_t read_bytes = 0;
+	int rc, fd;
+	char *blob, *pl, *rdptr;
 	char prefix[] = "load ";
 
-	rc = stat(path, &st);
+	fd = openat(dirfd, path, O_RDONLY);
+	if (fd < 0) {
+		fprintf(stderr, "failed to open file %s: %s\n",
+				path, strerror(errno));
+		return NULL;
+	}
+
+	rc = fstat(fd, &st);
 	if (rc < 0) {
 		fprintf(stderr, "stat: %s\n", strerror(errno));
 		return NULL;
@@ -95,31 +103,44 @@ static char *load_key_blob(const char *path, int *size)
 	}
 
 	*size = st.st_size + sizeof(prefix) - 1;
+	/*
+	 * We need to increment postfix and space.
+	 * "keyhandle=" is 10 bytes, plus null termination.
+	 */
+	if (postfix)
+		*size += strlen(postfix) + 10 + 1;
 	blob = malloc(*size);
 	if (!blob) {
 		fprintf(stderr, "Unable to allocate memory for blob\n");
 		return NULL;
 	}
 
-	bfile = fopen(path, "r");
-	if (!bfile) {
-		fprintf(stderr, "Unable to open %s: %s\n", path, strerror(errno));
-		free(blob);
-		return NULL;
-	}
-
 	memcpy(blob, prefix, sizeof(prefix) - 1);
 	pl = blob + sizeof(prefix) - 1;
-	read = fread(pl, st.st_size, 1, bfile);
-	if (read < 0) {
-		fprintf(stderr, "Failed to read from blob file: %s\n",
-				strerror(errno));
-		free(blob);
-		fclose(bfile);
-		return NULL;
+
+	rdptr = pl;
+	do {
+		rc = read(fd, rdptr, st.st_size - read_bytes);
+		if (rc < 0) {
+			fprintf(stderr, "Failed to read from blob file: %s\n",
+					strerror(errno));
+			free(blob);
+			close(fd);
+			return NULL;
+		}
+		read_bytes += rc;
+		rdptr += rc;
+	} while (read_bytes != st.st_size);
+
+	close(fd);
+
+	if (postfix) {
+		pl += read_bytes;
+		*pl = ' ';
+		pl++;
+		rc = sprintf(pl, "keyhandle=%s", postfix);
 	}
 
-	fclose(bfile);
 	return blob;
 }
 
@@ -247,7 +268,7 @@ static key_serial_t dimm_load_key(struct ndctl_dimm *dimm,
 	if (rc < 0)
 		return rc;
 
-	blob = load_key_blob(path, &size);
+	blob = ndctl_load_key_blob(path, &size, NULL, -1);
 	if (!blob)
 		return -ENOMEM;
 
diff --git a/ndctl/util/keys.h b/ndctl/util/keys.h
index 9b60d678..86bd2270 100644
--- a/ndctl/util/keys.h
+++ b/ndctl/util/keys.h
@@ -10,11 +10,18 @@ enum ndctl_key_type {
 };
 
 #ifdef ENABLE_KEYUTILS
+char *ndctl_load_key_blob(const char *path, int *size, const char *postfix,
+		int dirfd);
 int ndctl_dimm_setup_key(struct ndctl_dimm *dimm, const char *kek);
 int ndctl_dimm_update_key(struct ndctl_dimm *dimm, const char *kek);
 int ndctl_dimm_remove_key(struct ndctl_dimm *dimm);
 int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm);
 #else
+char *ndctl_load_key_blob(const char *path, int *size, const char *postfix,
+		int dirfd)
+{
+	return NULL;
+}
 static inline int ndctl_dimm_setup_key(struct ndctl_dimm *dimm,
 		const char *kek)
 {
diff --git a/test/security.sh b/test/security.sh
index 38b21183..abe948d5 100755
--- a/test/security.sh
+++ b/test/security.sh
@@ -53,8 +53,6 @@ test_cleanup()
 	if [ -f $masterpath ]; then
 		rm -f "$masterpath"
 	fi
-
-	rm -f "$keypath"/"$NFIT_TEST_BUS0".kek
 }
 
 lock_dimm()

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
