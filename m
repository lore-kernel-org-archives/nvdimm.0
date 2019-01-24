Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BE8EB211B81A5
 for <linux-nvdimm@lists.01.org>; Thu, 24 Jan 2019 15:08:03 -0800 (PST)
Subject: [PATCH v10 10/12] ndctl: master phassphrase management support
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 24 Jan 2019 16:08:02 -0700
Message-ID: <154837128293.37086.5932470737495070880.stgit@djiang5-desk3.ch.intel.com>
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

Adding master passphrase enabling and update to ndctl. This is a new
feature from Intel DSM v1.8.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ndctl/ndctl-setup-passphrase.txt  |    5 +
 Documentation/ndctl/ndctl-update-passphrase.txt |    6 +
 ndctl/dimm.c                                    |   13 ++-
 ndctl/lib/dimm.c                                |    9 ++
 ndctl/lib/libndctl.sym                          |    1 
 ndctl/libndctl.h                                |    2 
 ndctl/util/keys.c                               |  117 +++++++++++++++++------
 ndctl/util/keys.h                               |   12 ++
 8 files changed, 129 insertions(+), 36 deletions(-)

diff --git a/Documentation/ndctl/ndctl-setup-passphrase.txt b/Documentation/ndctl/ndctl-setup-passphrase.txt
index 1594f110..613e17a1 100644
--- a/Documentation/ndctl/ndctl-setup-passphrase.txt
+++ b/Documentation/ndctl/ndctl-setup-passphrase.txt
@@ -40,6 +40,11 @@ include::xable-dimm-options.txt[]
 	i.e. trusted:nvdimm-master
 	This key is expected to be loaded in the kernel's user keyring.
 
+-m::
+--master-passphrase::
+	Indicates that we are managing the master passphrase instead of the
+	user passphrase.
+
 -v::
 --verbose::
         Emit debug messages for the namespace check process.
diff --git a/Documentation/ndctl/ndctl-update-passphrase.txt b/Documentation/ndctl/ndctl-update-passphrase.txt
index 05573968..8b5fc812 100644
--- a/Documentation/ndctl/ndctl-update-passphrase.txt
+++ b/Documentation/ndctl/ndctl-update-passphrase.txt
@@ -40,10 +40,14 @@ include::xable-dimm-options.txt[]
 	This parameter is optional. If none provided, ndctl will determine
 	the current key handle from the encrypted key for the NVDIMM.
 
+-m::
+--master-passphrase::
+	Parameter to indicate that we are managing the master passphrase
+	instead of the user passphrase.
+
 -v::
 --verbose::
         Emit debug messages for the namespace check process.
-
 include::../copyright.txt[]
 
 SEE ALSO:
diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index fb16e9c8..c5c4a6cb 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -49,6 +49,7 @@ static struct parameters {
 	const char *kek;
 	bool crypto_erase;
 	bool overwrite;
+	bool master_pass;
 	bool force;
 	bool json;
 	bool verbose;
@@ -852,7 +853,8 @@ static int action_passphrase_setup(struct ndctl_dimm *dimm,
 	if (!param.kek)
 		return -EINVAL;
 
-	return ndctl_dimm_setup_key(dimm, param.kek);
+	return ndctl_dimm_setup_key(dimm, param.kek,
+			param.master_pass ? ND_MASTER_KEY : ND_USER_KEY);
 }
 
 static int action_passphrase_update(struct ndctl_dimm *dimm,
@@ -864,7 +866,8 @@ static int action_passphrase_update(struct ndctl_dimm *dimm,
 		return -EOPNOTSUPP;
 	}
 
-	return ndctl_dimm_update_key(dimm, param.kek);
+	return ndctl_dimm_update_key(dimm, param.kek,
+			param.master_pass ? ND_MASTER_KEY : ND_USER_KEY);
 }
 
 static int action_passphrase_remove(struct ndctl_dimm *dimm,
@@ -1049,6 +1052,10 @@ OPT_BOOLEAN('c', "crypto-erase", &param.crypto_erase, \
 OPT_BOOLEAN('o', "overwrite", &param.overwrite, \
 		"overwrite a dimm")
 
+#define MASTER_OPTIONS() \
+OPT_BOOLEAN('m', "master-passphrase", &param.master_pass, \
+		"use master passphrase")
+
 static const struct option read_options[] = {
 	BASE_OPTIONS(),
 	READ_OPTIONS(),
@@ -1081,11 +1088,13 @@ static const struct option init_options[] = {
 static const struct option key_options[] = {
 	BASE_OPTIONS(),
 	KEY_OPTIONS(),
+	MASTER_OPTIONS(),
 };
 
 static const struct option sanitize_options[] = {
 	BASE_OPTIONS(),
 	SANITIZE_OPTIONS(),
+	MASTER_OPTIONS(),
 	OPT_END(),
 };
 
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
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 7bd4ba59..c9e530ba 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -397,4 +397,5 @@ global:
 	ndctl_dimm_secure_erase;
 	ndctl_dimm_overwrite;
 	ndctl_dimm_wait_overwrite;
+	ndctl_dimm_update_master_passphrase;
 } LIBNDCTL_18;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index f767d637..893e92e4 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -705,6 +705,8 @@ int ndctl_dimm_freeze_security(struct ndctl_dimm *dimm);
 int ndctl_dimm_secure_erase(struct ndctl_dimm *dimm, long key);
 int ndctl_dimm_overwrite(struct ndctl_dimm *dimm, long key);
 int ndctl_dimm_wait_overwrite(struct ndctl_dimm *dimm);
+int ndctl_dimm_update_master_passphrase(struct ndctl_dimm *dimm,
+		long ckey, long nkey);
 
 #define ND_KEY_DESC_SIZE	128
 #define ND_KEY_CMD_SIZE		128
diff --git a/ndctl/util/keys.c b/ndctl/util/keys.c
index 2f0d8861..44ad0391 100644
--- a/ndctl/util/keys.c
+++ b/ndctl/util/keys.c
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
@@ -55,12 +72,26 @@ static int get_key_desc(struct ndctl_dimm *dimm, char *desc,
 {
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
 		fprintf(stderr, "error setting key description: %s\n",
@@ -158,7 +189,7 @@ static key_serial_t dimm_check_key(struct ndctl_dimm *dimm,
 }
 
 static key_serial_t dimm_create_key(struct ndctl_dimm *dimm,
-		const char *kek)
+		const char *kek, enum ndctl_key_type key_type)
 {
 	char desc[ND_KEY_DESC_SIZE];
 	char path[PATH_MAX];
@@ -177,7 +208,7 @@ static key_serial_t dimm_create_key(struct ndctl_dimm *dimm,
 		return -EBUSY;
 	}
 
-	rc = get_key_desc(dimm, desc, ND_USER_KEY);
+	rc = get_key_desc(dimm, desc, key_type);
 	if (rc < 0)
 		return rc;
 
@@ -188,7 +219,7 @@ static key_serial_t dimm_create_key(struct ndctl_dimm *dimm,
 		return -EEXIST;
 	}
 
-	rc = get_key_path(dimm, path, ND_USER_KEY);
+	rc = get_key_path(dimm, path, key_type);
 	if (rc < 0)
 		return rc;
 
@@ -288,12 +319,14 @@ static key_serial_t dimm_load_key(struct ndctl_dimm *dimm,
  * blob, and then attempt to inject the key as old key into the user key
  * ring.
  */
-static key_serial_t move_key_to_old(struct ndctl_dimm *dimm)
+static key_serial_t move_key_to_old(struct ndctl_dimm *dimm,
+		enum ndctl_key_type key_type)
 {
 	int rc;
 	key_serial_t key;
 	char old_path[PATH_MAX];
 	char new_path[PATH_MAX];
+	enum ndctl_key_type okey_type;
 
 	if (ndctl_dimm_is_active(dimm)) {
 		fprintf(stderr, "regions active on %s, op failed\n",
@@ -301,15 +334,22 @@ static key_serial_t move_key_to_old(struct ndctl_dimm *dimm)
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
 
@@ -320,7 +360,7 @@ static key_serial_t move_key_to_old(struct ndctl_dimm *dimm)
 		return -errno;
 	}
 
-	return dimm_load_key(dimm, ND_USER_OLD_KEY);
+	return dimm_load_key(dimm, okey_type);
 }
 
 static int dimm_remove_key(struct ndctl_dimm *dimm,
@@ -385,7 +425,8 @@ static int verify_kek(struct ndctl_dimm *dimm, const char *kek)
 	return 0;
 }
 
-int ndctl_dimm_setup_key(struct ndctl_dimm *dimm, const char *kek)
+int ndctl_dimm_setup_key(struct ndctl_dimm *dimm, const char *kek,
+		enum ndctl_key_type key_type)
 {
 	key_serial_t key;
 	int rc;
@@ -394,27 +435,31 @@ int ndctl_dimm_setup_key(struct ndctl_dimm *dimm, const char *kek)
 	if (rc < 0)
 		return rc;
 
-	key = dimm_create_key(dimm, kek);
+	key = dimm_create_key(dimm, kek, key_type);
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
 
-static char *get_current_kek(struct ndctl_dimm *dimm)
+static char *get_current_kek(struct ndctl_dimm *dimm,
+		enum ndctl_key_type key_type)
 {
 	key_serial_t key;
 	char *key_buf;
 	long rc;
 	char *type, *desc;
 
-	key = dimm_check_key(dimm, ND_USER_KEY);
+	key = dimm_check_key(dimm, key_type);
 	if (key < 0)
 		return NULL;
 
@@ -432,22 +477,31 @@ static char *get_current_kek(struct ndctl_dimm *dimm)
 	return desc;
 }
 
-int ndctl_dimm_update_key(struct ndctl_dimm *dimm, const char *kek)
+int ndctl_dimm_update_key(struct ndctl_dimm *dimm, const char *kek,
+		enum ndctl_key_type key_type)
 {
 	int rc;
 	key_serial_t old_key, new_key;
 	char *current_kek = NULL;
+	enum ndctl_key_type okey_type;
 
 	if (kek) {
 		rc = verify_kek(dimm, kek);
 		if (rc < 0)
 			return rc;
 	} else { /* find current kek */
-		current_kek = get_current_kek(dimm);
+		current_kek = get_current_kek(dimm, key_type);
 		if (!current_kek)
 			return -ENOKEY;
 	}
 
+	if (key_type == ND_USER_KEY)
+		okey_type = ND_USER_OLD_KEY;
+	else if (key_type == ND_MASTER_KEY)
+		okey_type = ND_MASTER_OLD_KEY;
+	else
+		return -EINVAL;
+
 	/*
 	 * 1. check if current key is loaded and remove
 	 * 2. move current key blob to old key blob
@@ -456,24 +510,29 @@ int ndctl_dimm_update_key(struct ndctl_dimm *dimm, const char *kek)
 	 * 5. remove old key
 	 * 6. remove old key blob
 	 */
-	old_key = move_key_to_old(dimm);
+	old_key = move_key_to_old(dimm, key_type);
 	if (old_key < 0)
 		return old_key;
 
-	new_key = dimm_create_key(dimm, current_kek ? current_kek : kek);
+	new_key = dimm_create_key(dimm, current_kek ? current_kek : kek,
+			key_type);
 	free(current_kek);
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
 
@@ -484,9 +543,9 @@ static key_serial_t check_dimm_key(struct ndctl_dimm *dimm, bool need_key)
 {
 	key_serial_t key;
 
-	key = dimm_check_key(dimm, false);
+	key = dimm_check_key(dimm, ND_USER_KEY);
 	if (key < 0) {
-		key = dimm_load_key(dimm, false);
+		key = dimm_load_key(dimm, ND_USER_KEY);
 		if (key < 0 && need_key) {
 			fprintf(stderr, "Unable to load key\n");
 			return -ENOKEY;
@@ -516,7 +575,7 @@ static int discard_key(struct ndctl_dimm *dimm)
 {
 	int rc;
 
-	rc = dimm_remove_key(dimm, false);
+	rc = dimm_remove_key(dimm, ND_USER_KEY);
 	if (rc < 0) {
 		fprintf(stderr, "Unable to cleanup key.\n");
 		return rc;
diff --git a/ndctl/util/keys.h b/ndctl/util/keys.h
index bdb9d6d7..e445902d 100644
--- a/ndctl/util/keys.h
+++ b/ndctl/util/keys.h
@@ -7,13 +7,17 @@
 enum ndctl_key_type {
 	ND_USER_KEY,
 	ND_USER_OLD_KEY,
+	ND_MASTER_KEY,
+	ND_MASTER_OLD_KEY,
 };
 
 #ifdef ENABLE_KEYUTILS
 char *ndctl_load_key_blob(const char *path, int *size, const char *postfix,
 		int dirfd);
-int ndctl_dimm_setup_key(struct ndctl_dimm *dimm, const char *kek);
-int ndctl_dimm_update_key(struct ndctl_dimm *dimm, const char *kek);
+int ndctl_dimm_setup_key(struct ndctl_dimm *dimm, const char *kek,
+				enum ndctl_key_type key_type);
+int ndctl_dimm_update_key(struct ndctl_dimm *dimm, const char *kek,
+				enum ndctl_key_type key_type);
 int ndctl_dimm_remove_key(struct ndctl_dimm *dimm);
 int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm);
 int ndctl_dimm_overwrite_key(struct ndctl_dimm *dimm);
@@ -24,13 +28,13 @@ char *ndctl_load_key_blob(const char *path, int *size, const char *postfix,
 	return NULL;
 }
 static inline int ndctl_dimm_setup_key(struct ndctl_dimm *dimm,
-		const char *kek)
+		const char *kek, enum ndctl_key_type key_type)
 {
 	return -EOPNOTSUPP;
 }
 
 static inline int ndctl_dimm_update_key(struct ndctl_dimm *dimm,
-		const char *kek)
+		const char *kek, enum ndctl_key_type key_type)
 {
 	return -EOPNOTSUPP;
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
