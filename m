Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 434DC211B85DE
 for <linux-nvdimm@lists.01.org>; Thu, 17 Jan 2019 18:39:22 -0800 (PST)
Subject: [PATCH v9 11/13] ndctl: master phassphrase management support
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 17 Jan 2019 19:39:21 -0700
Message-ID: <154777916164.42557.14308829457460197858.stgit@djiang5-desk3.ch.intel.com>
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

Adding master passphrase enabling and update to ndctl. This is a new
feature from Intel DSM v1.8.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ndctl/ndctl-setup-passphrase.txt  |    5 +
 Documentation/ndctl/ndctl-update-passphrase.txt |    5 +
 ndctl/dimm.c                                    |   21 ++++
 ndctl/lib/dimm.c                                |    9 ++
 ndctl/lib/keys.c                                |  110 ++++++++++++++++++-----
 ndctl/lib/libndctl.sym                          |    1 
 ndctl/libndctl.h                                |   16 +++
 7 files changed, 133 insertions(+), 34 deletions(-)

diff --git a/Documentation/ndctl/ndctl-setup-passphrase.txt b/Documentation/ndctl/ndctl-setup-passphrase.txt
index 7d8a1abb..044e9deb 100644
--- a/Documentation/ndctl/ndctl-setup-passphrase.txt
+++ b/Documentation/ndctl/ndctl-setup-passphrase.txt
@@ -31,4 +31,9 @@ OPTIONS
 <dimm>::
 include::xable-dimm-options.txt[]
 
+-m::
+--master-passphrase::
+	Indicates that we are managing the master passphrase instead of the
+	user passphrase.
+
 include::../copyright.txt[]
diff --git a/Documentation/ndctl/ndctl-update-passphrase.txt b/Documentation/ndctl/ndctl-update-passphrase.txt
index ff49ae2d..09e69832 100644
--- a/Documentation/ndctl/ndctl-update-passphrase.txt
+++ b/Documentation/ndctl/ndctl-update-passphrase.txt
@@ -29,6 +29,11 @@ OPTIONS
 <dimm>::
 include::xable-dimm-options.txt[]
 
+-m::
+--master-passphrase::
+	Parameter to indicate that we are managing the master passphrase
+	instead of the user passphrase.
+
 include::../copyright.txt[]
 
 SEE ALSO:
diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index df0c187c..4a7cca8e 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -47,6 +47,7 @@ static struct parameters {
 	const char *labelversion;
 	bool crypto_erase;
 	bool overwrite;
+	bool master_pass;
 	bool force;
 	bool json;
 	bool verbose;
@@ -847,7 +848,8 @@ static int action_key_enable(struct ndctl_dimm *dimm,
 		return -EOPNOTSUPP;
 	}
 
-	return ndctl_dimm_enable_key(dimm);
+	return ndctl_dimm_enable_key(dimm,
+			param.master_pass ? ND_MASTER_KEY : ND_USER_KEY);
 }
 
 static int action_key_update(struct ndctl_dimm *dimm,
@@ -859,7 +861,8 @@ static int action_key_update(struct ndctl_dimm *dimm,
 		return -EOPNOTSUPP;
 	}
 
-	return ndctl_dimm_update_key(dimm);
+	return ndctl_dimm_update_key(dimm,
+			param.master_pass ? ND_MASTER_KEY : ND_USER_KEY);
 }
 
 static int action_passphrase_remove(struct ndctl_dimm *dimm,
@@ -1040,6 +1043,10 @@ OPT_BOOLEAN('c', "crypto-erase", &param.crypto_erase, \
 OPT_BOOLEAN('o', "overwrite", &param.overwrite, \
 		"overwrite a dimm")
 
+#define MASTER_OPTIONS() \
+OPT_BOOLEAN('m', "master-passphrase", &param.master_pass, \
+		"use master passphrase")
+
 static const struct option read_options[] = {
 	BASE_OPTIONS(),
 	READ_OPTIONS(),
@@ -1069,9 +1076,15 @@ static const struct option init_options[] = {
 	OPT_END(),
 };
 
+static const struct option master_options[] = {
+	BASE_OPTIONS(),
+	MASTER_OPTIONS(),
+};
+
 static const struct option sanitize_options[] = {
 	BASE_OPTIONS(),
 	SANITIZE_OPTIONS(),
+	MASTER_OPTIONS(),
 	OPT_END(),
 };
 
@@ -1306,7 +1319,7 @@ int cmd_update_firmware(int argc, const char **argv, struct ndctl_ctx *ctx)
 int cmd_passphrase_update(int argc, const char **argv, struct ndctl_ctx *ctx)
 {
 	int count = dimm_action(argc, argv, ctx, action_key_update,
-			base_options,
+			master_options,
 			"ndctl update-passphrase <nmem0> [<nmem1>..<nmemN>] [<options>]");
 
 	fprintf(stderr, "passphrase updated for %d nmem%s.\n", count >= 0 ? count : 0,
@@ -1317,7 +1330,7 @@ int cmd_passphrase_update(int argc, const char **argv, struct ndctl_ctx *ctx)
 int cmd_passphrase_setup(int argc, const char **argv, struct ndctl_ctx *ctx)
 {
 	int count = dimm_action(argc, argv, ctx, action_key_enable,
-			base_options,
+			master_options,
 			"ndctl setup-passphrase <nmem0> [<nmem1>..<nmemN>] [<options>]");
 
 	fprintf(stderr, "passphrase enabled for %d nmem%s.\n", count >= 0 ? count : 0,
diff --git a/ndctl/lib/dimm.c b/ndctl/lib/dimm.c
index 150e337a..5c65d171 100644
--- a/ndctl/lib/dimm.c
+++ b/ndctl/lib/dimm.c
@@ -763,3 +763,12 @@ NDCTL_EXPORT int ndctl_dimm_wait_overwrite(struct ndctl_dimm *dimm)
 	close(fd);
 	return rc;
 }
+
+NDCTL_EXPORT int ndctl_dimm_update_master_passphrase(struct ndctl_dimm *dimm,
+		long ckey, long nkey)
+{
+	char buf[SYSFS_ATTR_SIZE];
+
+	sprintf(buf, "master_update %ld %ld\n", ckey, nkey);
+	return write_security(dimm, buf);
+}
diff --git a/ndctl/lib/keys.c b/ndctl/lib/keys.c
index 50784284..9abff45b 100644
--- a/ndctl/lib/keys.c
+++ b/ndctl/lib/keys.c
@@ -30,16 +30,33 @@ static int get_key_path(struct ndctl_dimm *dimm, char *path,
 		return -errno;
 	}
 
-	if (key_type == ND_USER_OLD_KEY) {
-		rc = sprintf(path, "%s/nvdimmold_%s_%s.blob",
+	switch (key_type) {
+	case ND_USER_OLD_KEY:
+		rc = sprintf(path, "%s/nvdimm-old_%s_%s.blob",
 				NDCTL_KEYS_DIR,
 				ndctl_dimm_get_unique_id(dimm),
 				hostname);
-	} else {
+		break;
+	case ND_USER_KEY:
 		rc = sprintf(path, "%s/nvdimm_%s_%s.blob",
 				NDCTL_KEYS_DIR,
 				ndctl_dimm_get_unique_id(dimm),
 				hostname);
+		break;
+	case ND_MASTER_OLD_KEY:
+		rc = sprintf(path, "%s/nvdimm-master-old_%s_%s.blob",
+				NDCTL_KEYS_DIR,
+				ndctl_dimm_get_unique_id(dimm),
+				hostname);
+		break;
+	case ND_MASTER_KEY:
+		rc = sprintf(path, "%s/nvdimm-master_%s_%s.blob",
+				NDCTL_KEYS_DIR,
+				ndctl_dimm_get_unique_id(dimm),
+				hostname);
+		break;
+	default:
+		return -EINVAL;
 	}
 
 	if (rc < 0) {
@@ -56,12 +73,26 @@ static int get_key_desc(struct ndctl_dimm *dimm, char *desc,
 	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
 	int rc;
 
-	if (key_type == ND_USER_OLD_KEY)
+	switch (key_type) {
+	case ND_USER_OLD_KEY:
 		rc = sprintf(desc, "nvdimm-old:%s",
 				ndctl_dimm_get_unique_id(dimm));
-	else
+		break;
+	case ND_USER_KEY:
 		rc = sprintf(desc, "nvdimm:%s",
 				ndctl_dimm_get_unique_id(dimm));
+		break;
+	case ND_MASTER_OLD_KEY:
+		rc = sprintf(desc, "nvdimm-master-old:%s",
+				ndctl_dimm_get_unique_id(dimm));
+		break;
+	case ND_MASTER_KEY:
+		rc = sprintf(desc, "nvdimm-master:%s",
+				ndctl_dimm_get_unique_id(dimm));
+		break;
+	default:
+		return -EINVAL;
+	}
 
 	if (rc < 0) {
 		err(ctx, "error setting key description: %s\n",
@@ -159,7 +190,8 @@ static key_serial_t dimm_check_key(struct ndctl_dimm *dimm,
 	return keyctl_search(KEY_SPEC_USER_KEYRING, "encrypted", desc, 0);
 }
 
-static key_serial_t dimm_create_key(struct ndctl_dimm *dimm)
+static key_serial_t dimm_create_key(struct ndctl_dimm *dimm,
+		enum ndctl_key_type key_type)
 {
 	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
 	char desc[ND_KEY_DESC_SIZE];
@@ -179,7 +211,7 @@ static key_serial_t dimm_create_key(struct ndctl_dimm *dimm)
 		return -EBUSY;
 	}
 
-	rc = get_key_desc(dimm, desc, ND_USER_KEY);
+	rc = get_key_desc(dimm, desc, key_type);
 	if (rc < 0)
 		return rc;
 
@@ -190,7 +222,7 @@ static key_serial_t dimm_create_key(struct ndctl_dimm *dimm)
 		return -EEXIST;
 	}
 
-	rc = get_key_path(dimm, path, ND_USER_KEY);
+	rc = get_key_path(dimm, path, key_type);
 	if (rc < 0)
 		return rc;
 
@@ -292,13 +324,15 @@ static key_serial_t dimm_load_key(struct ndctl_dimm *dimm,
  * blob, and then attempt to inject the key as old key into the user key
  * ring.
  */
-static key_serial_t move_key_to_old(struct ndctl_dimm *dimm)
+static key_serial_t move_key_to_old(struct ndctl_dimm *dimm,
+		enum ndctl_key_type key_type)
 {
 	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
 	int rc;
 	key_serial_t key;
 	char old_path[PATH_MAX];
 	char new_path[PATH_MAX];
+	enum ndctl_key_type okey_type;
 
 	if (ndctl_dimm_is_active(dimm)) {
 		err(ctx, "regions active on %s, op failed\n",
@@ -306,15 +340,22 @@ static key_serial_t move_key_to_old(struct ndctl_dimm *dimm)
 		return -EBUSY;
 	}
 
-	key = dimm_check_key(dimm, ND_USER_KEY);
+	key = dimm_check_key(dimm, key_type);
 	if (key > 0)
 		keyctl_unlink(key, KEY_SPEC_USER_KEYRING);
 
-	rc = get_key_path(dimm, old_path, ND_USER_KEY);
+	if (key_type == ND_USER_KEY)
+		okey_type = ND_USER_OLD_KEY;
+	else if (key_type == ND_MASTER_KEY)
+		okey_type = ND_MASTER_OLD_KEY;
+	else
+		return -EINVAL;
+
+	rc = get_key_path(dimm, old_path, key_type);
 	if (rc < 0)
 		return rc;
 
-	rc = get_key_path(dimm, new_path, ND_USER_OLD_KEY);
+	rc = get_key_path(dimm, new_path, okey_type);
 	if (rc < 0)
 		return rc;
 
@@ -325,7 +366,7 @@ static key_serial_t move_key_to_old(struct ndctl_dimm *dimm)
 		return -errno;
 	}
 
-	return dimm_load_key(dimm, ND_USER_OLD_KEY);
+	return dimm_load_key(dimm, okey_type);
 }
 
 static int dimm_remove_key(struct ndctl_dimm *dimm,
@@ -354,28 +395,41 @@ static int dimm_remove_key(struct ndctl_dimm *dimm,
 	return 0;
 }
 
-NDCTL_EXPORT int ndctl_dimm_enable_key(struct ndctl_dimm *dimm)
+NDCTL_EXPORT int ndctl_dimm_enable_key(struct ndctl_dimm *dimm,
+		enum ndctl_key_type key_type)
 {
 	key_serial_t key;
 	int rc;
 
-	key = dimm_create_key(dimm);
+	key = dimm_create_key(dimm, key_type);
 	if (key < 0)
 		return key;
 
-	rc = ndctl_dimm_update_passphrase(dimm, 0, key);
+	if (key_type == ND_MASTER_KEY)
+		rc = ndctl_dimm_update_master_passphrase(dimm, 0, key);
+	else
+		rc = ndctl_dimm_update_passphrase(dimm, 0, key);
 	if (rc < 0) {
-		dimm_remove_key(dimm, ND_USER_KEY);
+		dimm_remove_key(dimm, key_type);
 		return rc;
 	}
 
 	return 0;
 }
 
-NDCTL_EXPORT int ndctl_dimm_update_key(struct ndctl_dimm *dimm)
+NDCTL_EXPORT int ndctl_dimm_update_key(struct ndctl_dimm *dimm,
+		enum ndctl_key_type key_type)
 {
 	int rc;
 	key_serial_t old_key, new_key;
+	enum ndctl_key_type okey_type;
+
+	if (key_type == ND_USER_KEY)
+		okey_type = ND_USER_OLD_KEY;
+	else if (key_type == ND_MASTER_KEY)
+		okey_type = ND_MASTER_OLD_KEY;
+	else
+		return -EINVAL;
 
 	/*
 	 * 1. check if current key is loaded and remove
@@ -385,23 +439,27 @@ NDCTL_EXPORT int ndctl_dimm_update_key(struct ndctl_dimm *dimm)
 	 * 5. remove old key
 	 * 6. remove old key blob
 	 */
-	old_key = move_key_to_old(dimm);
+	old_key = move_key_to_old(dimm, key_type);
 	if (old_key < 0)
 		return old_key;
 
-	new_key = dimm_create_key(dimm);
+	new_key = dimm_create_key(dimm, key_type);
 	/* need to create new key here */
 	if (new_key < 0) {
-		new_key = dimm_load_key(dimm, ND_USER_KEY);
+		new_key = dimm_load_key(dimm, key_type);
 		if (new_key < 0)
 			return new_key;
 	}
 
-	rc = ndctl_dimm_update_passphrase(dimm, old_key, new_key);
+	if (key_type == ND_MASTER_KEY)
+		rc = ndctl_dimm_update_master_passphrase(dimm,
+				old_key, new_key);
+	else
+		rc = ndctl_dimm_update_passphrase(dimm, old_key, new_key);
 	if (rc < 0)
 		return rc;
 
-	rc = dimm_remove_key(dimm, ND_USER_OLD_KEY);
+	rc = dimm_remove_key(dimm, okey_type);
 	if (rc < 0)
 		return rc;
 
@@ -413,9 +471,9 @@ static key_serial_t check_dimm_key(struct ndctl_dimm *dimm, bool need_key)
 	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
 	key_serial_t key;
 
-	key = dimm_check_key(dimm, false);
+	key = dimm_check_key(dimm, ND_USER_KEY);
 	if (key < 0) {
-		key = dimm_load_key(dimm, false);
+		key = dimm_load_key(dimm, ND_USER_KEY);
 		if (key < 0 && need_key) {
 			err(ctx, "Unable to load key\n");
 			return -ENOKEY;
@@ -448,7 +506,7 @@ static int discard_key(struct ndctl_dimm *dimm)
 	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
 	int rc;
 
-	rc = dimm_remove_key(dimm, false);
+	rc = dimm_remove_key(dimm, ND_USER_KEY);
 	if (rc < 0) {
 		err(ctx, "Unable to cleanup key.\n");
 		return rc;
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 9550537c..fd260aae 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -404,4 +404,5 @@ global:
 	ndctl_dimm_overwrite;
 	ndctl_dimm_overwrite_key;
 	ndctl_dimm_wait_overwrite;
+	ndctl_dimm_update_master_passphrase;
 } LIBNDCTL_18;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 09225df9..7a5236b8 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -710,25 +710,33 @@ int ndctl_dimm_freeze_security(struct ndctl_dimm *dimm);
 int ndctl_dimm_secure_erase(struct ndctl_dimm *dimm, long key);
 int ndctl_dimm_overwrite(struct ndctl_dimm *dimm, long key);
 int ndctl_dimm_wait_overwrite(struct ndctl_dimm *dimm);
+int ndctl_dimm_update_master_passphrase(struct ndctl_dimm *dimm,
+		long ckey, long nkey);
 
 enum ndctl_key_type {
 	ND_USER_KEY,
 	ND_USER_OLD_KEY,
+	ND_MASTER_KEY,
+	ND_MASTER_OLD_KEY,
 };
 
 #ifdef ENABLE_KEYUTILS
-int ndctl_dimm_enable_key(struct ndctl_dimm *dimm);
-int ndctl_dimm_update_key(struct ndctl_dimm *dimm);
+int ndctl_dimm_enable_key(struct ndctl_dimm *dimm,
+		enum ndctl_key_type key_type);
+int ndctl_dimm_update_key(struct ndctl_dimm *dimm,
+		enum ndctl_key_type key_type);
 int ndctl_dimm_remove_key(struct ndctl_dimm *dimm);
 int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm);
 int ndctl_dimm_overwrite_key(struct ndctl_dimm *dimm);
 #else
-static inline int ndctl_dimm_enable_key(struct ndctl_dimm *dimm)
+static inline int ndctl_dimm_enable_key(struct ndctl_dimm *dimm,
+		enum ndctl_key_type key_type);
 {
 	return -EOPNOTSUPP;
 }
 
-static inline int ndctl_dimm_update_key(struct ndctl_dimm *dimm)
+static inline int ndctl_dimm_update_key(struct ndctl_dimm *dimm,
+		enum ndctl_key_type key_type)
 {
 	return -EOPNOTSUPP;
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
