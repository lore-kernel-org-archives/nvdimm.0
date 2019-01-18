Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 18B66211B63F7
 for <linux-nvdimm@lists.01.org>; Thu, 17 Jan 2019 18:39:06 -0800 (PST)
Subject: [PATCH v9 08/13] ndctl: add modprobe conf file and load-keys ndctl
 command
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 17 Jan 2019 19:39:05 -0700
Message-ID: <154777914548.42557.12179051970472720250.stgit@djiang5-desk3.ch.intel.com>
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

Add load-keys command to ndctl. This will attempt to load the master key
and the related encrypted keys for nvdimms. Also add reference config file
for modprobe.d in order to call ndctl load-keys and inject keys associated
with the nvdimms into the kernel user ring for unlock.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ndctl/Makefile.am         |    3 
 Documentation/ndctl/ndctl-load-keys.txt |   43 +++++
 Makefile.am                             |    4 
 contrib/nvdimm-security.conf            |    1 
 ndctl.spec.in                           |    1 
 ndctl/Makefile.am                       |    3 
 ndctl/builtin.h                         |    1 
 ndctl/lib/keys.c                        |   64 +++++---
 ndctl/lib/libndctl.sym                  |    1 
 ndctl/libndctl.h                        |    2 
 ndctl/load-keys.c                       |  257 +++++++++++++++++++++++++++++++
 ndctl/ndctl.c                           |    1 
 12 files changed, 357 insertions(+), 24 deletions(-)
 create mode 100644 Documentation/ndctl/ndctl-load-keys.txt
 create mode 100644 contrib/nvdimm-security.conf
 create mode 100644 ndctl/load-keys.c

diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
index 2e535940..2481361f 100644
--- a/Documentation/ndctl/Makefile.am
+++ b/Documentation/ndctl/Makefile.am
@@ -53,7 +53,8 @@ man1_MANS = \
 	ndctl-update-passphrase.1 \
 	ndctl-disable-passphrase.1 \
 	ndctl-freeze-security.1 \
-	ndctl-sanitize-dimm.1
+	ndctl-sanitize-dimm.1 \
+	ndctl-load-keys.1
 
 CLEANFILES = $(man1_MANS)
 
diff --git a/Documentation/ndctl/ndctl-load-keys.txt b/Documentation/ndctl/ndctl-load-keys.txt
new file mode 100644
index 00000000..f153e9d7
--- /dev/null
+++ b/Documentation/ndctl/ndctl-load-keys.txt
@@ -0,0 +1,43 @@
+// SPDX-License-Identifier: GPL-2.0
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
+	and the default is set to /etc/ndctl/keys.
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
index 3956d81d..0353c7e3 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -120,6 +120,7 @@ make check
 %{bashcompdir}/
 %{_unitdir}/ndctl-monitor.service
 %{_sysconfdir}/ndctl/keys/
+%{_sysconfdir}/modprobe.d/nvdimm-security.conf
 
 %config(noreplace) %{_sysconfdir}/ndctl/monitor.conf
 
diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index e412dbf7..193dea74 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -25,7 +25,8 @@ ndctl_SOURCES = ndctl.c \
 		inject-error.c \
 		inject-smart.c \
 		monitor.c \
-		kek.c
+		kek.c \
+		load-keys.c
 
 if ENABLE_DESTRUCTIVE
 ndctl_SOURCES += ../test/blk_namespaces.c \
diff --git a/ndctl/builtin.h b/ndctl/builtin.h
index 3d8f4ce7..416e4564 100644
--- a/ndctl/builtin.h
+++ b/ndctl/builtin.h
@@ -38,4 +38,5 @@ int cmd_passphrase_update(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_passphrase_remove(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_freeze_security(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_sanitize_dimm(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_load_keys(int argc, const char **argv, struct ndctl_ctx *ctx);
 #endif /* _NDCTL_BUILTIN_H_ */
diff --git a/ndctl/lib/keys.c b/ndctl/lib/keys.c
index 5353bdc4..2fb2c305 100644
--- a/ndctl/lib/keys.c
+++ b/ndctl/lib/keys.c
@@ -72,16 +72,23 @@ static int get_key_desc(struct ndctl_dimm *dimm, char *desc,
 	return 0;
 }
 
-static char *load_key_blob(struct ndctl_ctx *ctx, const char *path, int *size)
+NDCTL_EXPORT char *ndctl_load_key_blob(struct ndctl_ctx *ctx,
+		const char *path, int *size, const char *postfix, int dirfd)
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
+		err(ctx, "failed to open file %s: %s\n",
+				path, strerror(errno));
+		return NULL;
+	}
+
+	rc = fstat(fd, &st);
 	if (rc < 0) {
 		err(ctx, "stat: %s\n", strerror(errno));
 		return NULL;
@@ -97,31 +104,44 @@ static char *load_key_blob(struct ndctl_ctx *ctx, const char *path, int *size)
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
 		err(ctx, "Unable to allocate memory for blob\n");
 		return NULL;
 	}
 
-	bfile = fopen(path, "r");
-	if (!bfile) {
-		err(ctx, "Unable to open %s: %s\n", path, strerror(errno));
-		free(blob);
-		return NULL;
-	}
-
 	memcpy(blob, prefix, sizeof(prefix) - 1);
 	pl = blob + sizeof(prefix) - 1;
-	read = fread(pl, st.st_size, 1, bfile);
-	if (read < 0) {
-		err(ctx, "Failed to read from blob file: %s\n",
-				strerror(errno));
-		free(blob);
-		fclose(bfile);
-		return NULL;
+
+	rdptr = pl;
+	do {
+		rc = read(fd, rdptr, st.st_size - read_bytes);
+		if (rc < 0) {
+			err(ctx, "Failed to read from blob file: %s\n",
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
 
@@ -251,7 +271,7 @@ static key_serial_t dimm_load_key(struct ndctl_dimm *dimm,
 	if (rc < 0)
 		return rc;
 
-	blob = load_key_blob(ctx, path, &size);
+	blob = ndctl_load_key_blob(ctx, path, &size, NULL, -1);
 	if (!blob)
 		return -ENOMEM;
 
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index f4b487d4..238c2e1c 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -390,6 +390,7 @@ LIBNDCTL_19 {
 global:
 	ndctl_cmd_xlat_firmware_status;
 	ndctl_cmd_submit_xlat;
+	ndctl_load_key_blob;
 	ndctl_dimm_get_security;
 	ndctl_bus_get_kek_handle;
 	ndctl_dimm_enable_key;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 05c39e8e..83cce8c4 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -699,6 +699,8 @@ enum ndctl_security_state {
 	NDCTL_SECURITY_OVERWRITE,
 };
 
+char *ndctl_load_key_blob(struct ndctl_ctx *ctx,
+		const char *path, int *size, const char *postfix, int dirfd);
 enum ndctl_security_state ndctl_dimm_get_security(struct ndctl_dimm *dimm);
 const char *ndctl_bus_get_kek_handle(struct ndctl_bus *bus);
 int ndctl_dimm_update_passphrase(struct ndctl_dimm *dimm,
diff --git a/ndctl/load-keys.c b/ndctl/load-keys.c
new file mode 100644
index 00000000..077e520e
--- /dev/null
+++ b/ndctl/load-keys.c
@@ -0,0 +1,257 @@
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
+
+#include <util/json.h>
+#include <util/filter.h>
+#include <json-c/json.h>
+#include <ndctl/libndctl.h>
+#include <util/parse-options.h>
+#include <ccan/array_size/array_size.h>
+
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
+static int load_master_key(struct ndctl_ctx *ctx, struct loadkeys *lk_ctx,
+		const char *keypath)
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
+	blob = ndctl_load_key_blob(ctx, path, &size, param.tpm_handle, -1);
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
+static int load_dimm_keys(struct ndctl_ctx *ctx, struct loadkeys *lk_ctx)
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
+		blob = ndctl_load_key_blob(ctx, dent->d_name, &size, NULL,
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
+static int check_tpm_handle(struct ndctl_ctx *ctx, struct loadkeys *lk_ctx)
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
+static int load_keys(struct ndctl_ctx *ctx, struct loadkeys *lk_ctx,
+		const char *keypath, const char *tpmhandle)
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
+		rc = check_tpm_handle(ctx, lk_ctx);
+		if (rc < 0) {
+			rc = -errno;
+			goto erropen;
+		}
+	}
+
+	rc = load_master_key(ctx, lk_ctx, param.key_path);
+	if (rc < 0)
+		goto out;
+
+	rc = load_dimm_keys(ctx, lk_ctx);
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
+	return load_keys(ctx, &loadkey_ctx, param.key_path, param.tpm_handle);
+}
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index 283ccc33..f6d0e235 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -93,6 +93,7 @@ static struct cmd_struct commands[] = {
 	{ "remove-passphrase", { cmd_passphrase_remove } },
 	{ "freeze-security", { cmd_freeze_security } },
 	{ "sanitize-dimm", { cmd_sanitize_dimm } },
+	{ "load-keys", { cmd_load_keys } },
 	{ "list", { cmd_list } },
 	{ "monitor", { cmd_monitor } },
 	{ "install-encrypt-key", { cmd_install_kek } },

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
