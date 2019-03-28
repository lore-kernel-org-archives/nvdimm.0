Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 203772117AE40
 for <linux-nvdimm@lists.01.org>; Thu, 28 Mar 2019 12:07:16 -0700 (PDT)
Subject: [PATCH 2/3] ndctl: fix key blob loading for user keys
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 28 Mar 2019 12:07:14 -0700
Message-ID: <155380003495.7924.1527087606331560941.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <155380002962.7924.11109542476291499729.stgit@djiang5-desk3.ch.intel.com>
References: <155380002962.7924.11109542476291499729.stgit@djiang5-desk3.ch.intel.com>
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
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The syntax for loading user master key is different than loading a trusted
key. Fix so we can load user key properly.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 ndctl/load-keys.c |   13 +++++--------
 ndctl/util/keys.c |   20 +++++++++++++++-----
 ndctl/util/keys.h |   10 ++++++++--
 3 files changed, 28 insertions(+), 15 deletions(-)

diff --git a/ndctl/load-keys.c b/ndctl/load-keys.c
index 19380152..c0d0d743 100644
--- a/ndctl/load-keys.c
+++ b/ndctl/load-keys.c
@@ -25,12 +25,7 @@ static struct parameters {
 	const char *tpm_handle;
 } param;
 
-enum key_type {
-	KEY_USER = 0,
-	KEY_TRUSTED,
-};
-
-static const char *key_names[] = {"user", "trusted"};
+static const char *key_names[] = {"user", "trusted", "encrypted"};
 
 static struct loadkeys {
 	enum key_type key_type;
@@ -44,6 +39,7 @@ static int load_master_key(struct loadkeys *lk_ctx, const char *keypath)
 	char *blob;
 	int size, rc;
 	char path[PATH_MAX];
+	enum key_type;
 
 	rc = sprintf(path, "%s/nvdimm-master.blob", keypath);
 	if (rc < 0)
@@ -65,7 +61,8 @@ static int load_master_key(struct loadkeys *lk_ctx, const char *keypath)
 		return -errno;
 	}
 
-	blob = ndctl_load_key_blob(path, &size, param.tpm_handle, -1);
+	blob = ndctl_load_key_blob(path, &size, param.tpm_handle, -1,
+			lk_ctx->key_type);
 	if (!blob)
 		return -ENOMEM;
 
@@ -122,7 +119,7 @@ static int load_dimm_keys(struct loadkeys *lk_ctx)
 		}
 
 		blob = ndctl_load_key_blob(dent->d_name, &size, NULL,
-				lk_ctx->dirfd);
+				lk_ctx->dirfd, KEY_ENCRYPTED);
 		if (!blob) {
 			free(fname);
 			continue;
diff --git a/ndctl/util/keys.c b/ndctl/util/keys.c
index 622533d7..a621a5f5 100644
--- a/ndctl/util/keys.c
+++ b/ndctl/util/keys.c
@@ -103,13 +103,17 @@ static int get_key_desc(struct ndctl_dimm *dimm, char *desc,
 }
 
 char *ndctl_load_key_blob(const char *path, int *size, const char *postfix,
-		int dirfd)
+		int dirfd, enum key_type key_type)
 {
 	struct stat st;
 	ssize_t read_bytes = 0;
 	int rc, fd;
 	char *blob, *pl, *rdptr;
 	char prefix[] = "load ";
+	bool need_prefix = false;
+
+	if (key_type == KEY_ENCRYPTED || key_type == KEY_TRUSTED)
+		need_prefix = true;
 
 	fd = openat(dirfd, path, O_RDONLY);
 	if (fd < 0) {
@@ -133,7 +137,10 @@ char *ndctl_load_key_blob(const char *path, int *size, const char *postfix,
 		return NULL;
 	}
 
-	*size = st.st_size + sizeof(prefix) - 1;
+	*size = st.st_size;
+	if (need_prefix)
+		*size += strlen(prefix);
+
 	/*
 	 * We need to increment postfix and space.
 	 * "keyhandle=" is 10 bytes, plus null termination.
@@ -146,8 +153,11 @@ char *ndctl_load_key_blob(const char *path, int *size, const char *postfix,
 		return NULL;
 	}
 
-	memcpy(blob, prefix, sizeof(prefix) - 1);
-	pl = blob + sizeof(prefix) - 1;
+	if (need_prefix) {
+		memcpy(blob, prefix, strlen(prefix));
+		pl = blob + strlen(prefix);
+	} else
+		pl = blob;
 
 	rdptr = pl;
 	do {
@@ -300,7 +310,7 @@ static key_serial_t dimm_load_key(struct ndctl_dimm *dimm,
 	if (rc < 0)
 		return rc;
 
-	blob = ndctl_load_key_blob(path, &size, NULL, -1);
+	blob = ndctl_load_key_blob(path, &size, NULL, -1, KEY_ENCRYPTED);
 	if (!blob)
 		return -ENOMEM;
 
diff --git a/ndctl/util/keys.h b/ndctl/util/keys.h
index eab78d2f..9bc995ac 100644
--- a/ndctl/util/keys.h
+++ b/ndctl/util/keys.h
@@ -12,9 +12,15 @@ enum ndctl_key_type {
 	ND_ZERO_KEY,
 };
 
+enum key_type {
+	KEY_USER = 0,
+	KEY_TRUSTED,
+	KEY_ENCRYPTED,
+};
+
 #ifdef ENABLE_KEYUTILS
 char *ndctl_load_key_blob(const char *path, int *size, const char *postfix,
-		int dirfd);
+		int dirfd, enum key_type key_type);
 int ndctl_dimm_setup_key(struct ndctl_dimm *dimm, const char *kek,
 				enum ndctl_key_type key_type);
 int ndctl_dimm_update_key(struct ndctl_dimm *dimm, const char *kek,
@@ -25,7 +31,7 @@ int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm,
 int ndctl_dimm_overwrite_key(struct ndctl_dimm *dimm);
 #else
 char *ndctl_load_key_blob(const char *path, int *size, const char *postfix,
-		int dirfd)
+		int dirfd, enum key_type key_type)
 {
 	return NULL;
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
