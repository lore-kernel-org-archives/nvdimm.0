Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C71CB21959CB2
 for <linux-nvdimm@lists.01.org>; Mon, 14 Jan 2019 12:07:15 -0800 (PST)
Subject: [PATCH v8 07/12] ndctl: add modprobe conf file and load-keys ndctl
 command
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 14 Jan 2019 13:07:14 -0700
Message-ID: <154749643471.63704.13896055803611551879.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154749627829.63704.2987015129166185725.stgit@djiang5-desk3.ch.intel.com>
References: <154749627829.63704.2987015129166185725.stgit@djiang5-desk3.ch.intel.com>
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
 Documentation/ndctl/Makefile.am |    3 
 Makefile.am                     |    4 +
 contrib/nvdimm-security.conf    |    1 
 ndctl.spec.in                   |    1 
 ndctl/Makefile.am               |    3 
 ndctl/builtin.h                 |    1 
 ndctl/lib/keys.c                |   60 ++++++---
 ndctl/lib/libndctl.sym          |    1 
 ndctl/libndctl.h                |    2 
 ndctl/load-keys.c               |  260 +++++++++++++++++++++++++++++++++++++++
 ndctl/ndctl.c                   |    1 
 11 files changed, 314 insertions(+), 23 deletions(-)
 create mode 100644 contrib/nvdimm-security.conf
 create mode 100644 ndctl/load-keys.c

diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
index bbea9674..0224cccd 100644
--- a/Documentation/ndctl/Makefile.am
+++ b/Documentation/ndctl/Makefile.am
@@ -52,7 +52,8 @@ man1_MANS = \
 	ndctl-update-passphrase.1 \
 	ndctl-disable-passphrase.1 \
 	ndctl-freeze-security.1 \
-	ndctl-sanitize-dimm.1
+	ndctl-sanitize-dimm.1 \
+	ndctl-load-keys.1
 
 CLEANFILES = $(man1_MANS)
 
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
index 66466db6..afed8a43 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -121,6 +121,7 @@ make check
 %{_sysconfdir}/ndctl/monitor.conf
 %{_unitdir}/ndctl-monitor.service
 %{_sysconfdir}/ndctl/keys/
+%{_sysconfdir}/modprobe.d/nvdimm-security.conf
 
 %files -n daxctl
 %defattr(-,root,root)
diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index 120941a4..eafae05d 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -16,7 +16,8 @@ ndctl_SOURCES = ndctl.c \
 		util/json-firmware.c \
 		inject-error.c \
 		inject-smart.c \
-		monitor.c
+		monitor.c \
+		load-keys.c
 
 if ENABLE_DESTRUCTIVE
 ndctl_SOURCES += ../test/blk_namespaces.c \
diff --git a/ndctl/builtin.h b/ndctl/builtin.h
index 55bee47c..2cdc0590 100644
--- a/ndctl/builtin.h
+++ b/ndctl/builtin.h
@@ -37,4 +37,5 @@ int cmd_passphrase_update(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_disable_passphrase(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_freeze_security(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_sanitize_dimm(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_load_keys(int argc, const char **argv, struct ndctl_ctx *ctx);
 #endif /* _NDCTL_BUILTIN_H_ */
diff --git a/ndctl/lib/keys.c b/ndctl/lib/keys.c
index 42281394..39c4143c 100644
--- a/ndctl/lib/keys.c
+++ b/ndctl/lib/keys.c
@@ -71,16 +71,23 @@ static int get_key_desc(struct ndctl_dimm *dimm, char *desc,
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
+	ssize_t read_bytes = 0;
+	int rc, fd;
 	char *blob, *pl;
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
@@ -96,31 +103,42 @@ static char *load_key_blob(struct ndctl_ctx *ctx, const char *path, int *size)
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
+	do {
+		rc = read(fd, pl, st.st_size);
+		if (rc < 0) {
+			err(ctx, "Failed to read from blob file: %s\n",
+					strerror(errno));
+			free(blob);
+			close(fd);
+			return NULL;
+		}
+		read_bytes += rc;
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
 
@@ -250,7 +268,7 @@ static key_serial_t dimm_load_key(struct ndctl_dimm *dimm,
 	if (rc < 0)
 		return rc;
 
-	blob = load_key_blob(ctx, path, &size);
+	blob = ndctl_load_key_blob(ctx, path, &size, NULL, -1);
 	if (!blob)
 		return -ENOMEM;
 
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 0e3aa5d9..bd85651e 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -388,6 +388,7 @@ global:
 
 LIBNDCTL_19 {
 global:
+	ndctl_load_key_blob;
 	ndctl_dimm_get_security;
 	ndctl_dimm_security_supported;
 	ndctl_dimm_enable_key;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index bb4bab85..9decc937 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -696,6 +696,8 @@ enum nd_security_state {
 	ND_SECURITY_OVERWRITE,
 };
 
+char *ndctl_load_key_blob(struct ndctl_ctx *ctx,
+		const char *path, int *size, const char *postfix, int dirfd);
 int ndctl_dimm_get_security(struct ndctl_dimm *dimm,
 		enum nd_security_state *sstate);
 bool ndctl_dimm_security_supported(struct ndctl_dimm *dimm);
diff --git a/ndctl/load-keys.c b/ndctl/load-keys.c
new file mode 100644
index 00000000..802675a2
--- /dev/null
+++ b/ndctl/load-keys.c
@@ -0,0 +1,260 @@
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
+	if (fd < 0) {
+		fprintf(stderr, "Fail to open TPM handle: %s\n",
+				strerror(errno));
+		return -errno;
+	}
+
+	fs = fdopen(fd, "r");
+	if (!fs) {
+		fprintf(stderr, "Fail to open file stream: %s\n",
+				strerror(errno));
+		return -errno;
+	}
+
+	rc = fscanf(fs, "%ms", &buf);
+	if (rc < 0) {
+		rc = -errno;
+		fprintf(stderr, "Fail to read file: %s\n", strerror(errno));
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
index 09af1317..91b080d5 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -93,6 +93,7 @@ static struct cmd_struct commands[] = {
 	{ "disable-passphrase", { cmd_disable_passphrase } },
 	{ "freeze-security", { cmd_freeze_security } },
 	{ "sanitize-dimm", { cmd_sanitize_dimm } },
+	{ "load-keys", { cmd_load_keys } },
 	{ "list", { cmd_list } },
 	{ "monitor", { cmd_monitor } },
 	{ "help", { cmd_help } },

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
