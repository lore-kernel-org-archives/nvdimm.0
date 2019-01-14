Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 289B121959CB2
 for <linux-nvdimm@lists.01.org>; Mon, 14 Jan 2019 12:07:34 -0800 (PST)
Subject: [PATCH v8 10/12] ndctl: master phassphrase management support
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 14 Jan 2019 13:07:33 -0700
Message-ID: <154749645299.63704.1609491126739486573.stgit@djiang5-desk3.ch.intel.com>
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

Adding master passphrase enabling and update to ndctl. This is a new
feature from Intel DSM v1.8.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ndctl/ndctl-enable-passphrase.txt |    7 +
 Documentation/ndctl/ndctl-update-passphrase.txt |    7 +
 ndctl/dimm.c                                    |   13 +-
 ndctl/lib/dimm.c                                |    9 ++
 ndctl/lib/keys.c                                |  127 ++++++++++++++++-------
 ndctl/lib/libndctl.sym                          |    1 
 ndctl/libndctl.h                                |   14 ++-
 7 files changed, 130 insertions(+), 48 deletions(-)

diff --git a/Documentation/ndctl/ndctl-enable-passphrase.txt b/Documentation/ndctl/ndctl-enable-passphrase.txt
index c14a206c..c025b1c3 100644
--- a/Documentation/ndctl/ndctl-enable-passphrase.txt
+++ b/Documentation/ndctl/ndctl-enable-passphrase.txt
@@ -29,7 +29,7 @@ OPTIONS
 include::xable-dimm-options.txt[]
 
 -m::
---master=::
+--master-key=::
 	Key name for the master key used to seal the NVDIMM security keys.
 	The format would be <key_type>:<master_key_name>
 	i.e.: trusted:master-nvdimm
@@ -39,4 +39,9 @@ include::xable-dimm-options.txt[]
 	Path to where key related files resides. This parameter is optional
 	and the default is set to /etc/ndctl/keys.
 
+-M::
+--master-passphrase::
+	Indicates that we are managing the master passphrase instead of the
+	user passphrase.
+
 include::../copyright.txt[]
diff --git a/Documentation/ndctl/ndctl-update-passphrase.txt b/Documentation/ndctl/ndctl-update-passphrase.txt
index dd6e4e4e..8b5dfe01 100644
--- a/Documentation/ndctl/ndctl-update-passphrase.txt
+++ b/Documentation/ndctl/ndctl-update-passphrase.txt
@@ -26,7 +26,7 @@ OPTIONS
 include::xable-dimm-options.txt[]
 
 -m::
---master::
+--master-key=::
 	New key name for the master key to seal the new nvdimm key, or the
 	existing master key name. i.e trusted:master-key.
 
@@ -35,4 +35,9 @@ include::xable-dimm-options.txt[]
 	Path to where key related files resides. This parameter is optional
 	and the default is set to /etc/ndctl/keys.
 
+-M::
+--master-passphrase::
+	Parameter to indicate that we are managing the master passphrase
+	instead of the user passphrase.
+
 include::../copyright.txt[]
diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index ce477981..4875e414 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -49,6 +49,7 @@ static struct parameters {
 	const char *master_key;
 	bool crypto_erase;
 	bool overwrite;
+	bool master_pass;
 	bool force;
 	bool json;
 	bool verbose;
@@ -849,8 +850,8 @@ static int action_key_enable(struct ndctl_dimm *dimm,
 		return -EOPNOTSUPP;
 	}
 
-	return ndctl_dimm_enable_key(dimm, param.master_key,
-			param.key_path);
+	return ndctl_dimm_enable_key(dimm, param.master_key, param.key_path,
+			param.master_pass ? ND_MASTER_KEY : ND_USER_KEY);
 }
 
 static int action_key_update(struct ndctl_dimm *dimm,
@@ -862,8 +863,8 @@ static int action_key_update(struct ndctl_dimm *dimm,
 		return -EOPNOTSUPP;
 	}
 
-	return ndctl_dimm_update_key(dimm, param.master_key,
-			param.key_path);
+	return ndctl_dimm_update_key(dimm, param.master_key, param.key_path,
+			param.master_pass ? ND_MASTER_KEY : ND_USER_KEY);
 }
 
 static int action_passphrase_disable(struct ndctl_dimm *dimm,
@@ -1044,7 +1045,9 @@ OPT_FILENAME('p', "key-path", &param.key_path, "key-path", \
 
 #define KEY_OPTIONS() \
 OPT_STRING('m', "master-key", &param.master_key, "<key_type>:<key_name>", \
-		"master key for security")
+		"master key for security"), \
+OPT_BOOLEAN('M', "master-passphrase", &param.master_pass, \
+		"use master passphrase")
 
 #define SANITIZE_OPTIONS() \
 OPT_BOOLEAN('c', "crypto-erase", &param.crypto_erase, \
diff --git a/ndctl/lib/dimm.c b/ndctl/lib/dimm.c
index eb950331..dc945296 100644
--- a/ndctl/lib/dimm.c
+++ b/ndctl/lib/dimm.c
@@ -771,3 +771,12 @@ NDCTL_EXPORT int ndctl_dimm_wait_overwrite(struct ndctl_dimm *dimm)
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
index beb5ab3b..09ceeb57 100644
--- a/ndctl/lib/keys.c
+++ b/ndctl/lib/keys.c
@@ -17,7 +17,7 @@
 #include "private.h"
 
 static int get_key_path(struct ndctl_dimm *dimm, char *path,
-		enum ndctl_key_type key_type, const char *keypath)
+		const char *keypath, enum ndctl_key_type key_type)
 {
 	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
 	char hostname[HOST_NAME_MAX];
@@ -29,16 +29,29 @@ static int get_key_path(struct ndctl_dimm *dimm, char *path,
 		return -errno;
 	}
 
-	if (key_type == ND_USER_OLD_KEY) {
-		rc = sprintf(path, "%s/nvdimmold_%s_%s.blob",
-				keypath,
-				ndctl_dimm_get_unique_id(dimm),
+	switch (key_type) {
+	case ND_USER_OLD_KEY:
+		rc = sprintf(path, "%s/nvdimm-old_%s_%s.blob",
+				keypath, ndctl_dimm_get_unique_id(dimm),
 				hostname);
-	} else {
+		break;
+	case ND_USER_KEY:
 		rc = sprintf(path, "%s/nvdimm_%s_%s.blob",
-				keypath,
-				ndctl_dimm_get_unique_id(dimm),
+				keypath, ndctl_dimm_get_unique_id(dimm),
 				hostname);
+		break;
+	case ND_MASTER_OLD_KEY:
+		rc = sprintf(path, "%s/nvdimm-master-old_%s_%s.blob",
+				keypath, ndctl_dimm_get_unique_id(dimm),
+				hostname);
+		break;
+	case ND_MASTER_KEY:
+		rc = sprintf(path, "%s/nvdimm-master_%s_%s.blob",
+				keypath, ndctl_dimm_get_unique_id(dimm),
+				hostname);
+		break;
+	default:
+		return -EINVAL;
 	}
 
 	if (rc < 0) {
@@ -55,12 +68,26 @@ static int get_key_desc(struct ndctl_dimm *dimm, char *desc,
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
@@ -157,7 +184,8 @@ static key_serial_t dimm_check_key(struct ndctl_dimm *dimm,
 }
 
 static key_serial_t dimm_create_key(struct ndctl_dimm *dimm,
-		const char *master, const char *keypath)
+		const char *master_key, const char *keypath,
+		enum ndctl_key_type key_type)
 {
 	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
 	char desc[ND_KEY_DESC_SIZE];
@@ -177,7 +205,7 @@ static key_serial_t dimm_create_key(struct ndctl_dimm *dimm,
 		return -EBUSY;
 	}
 
-	rc = get_key_desc(dimm, desc, ND_USER_KEY);
+	rc = get_key_desc(dimm, desc, key_type);
 	if (rc < 0)
 		return rc;
 
@@ -188,7 +216,7 @@ static key_serial_t dimm_create_key(struct ndctl_dimm *dimm,
 		return -EEXIST;
 	}
 
-	rc = get_key_path(dimm, path, ND_USER_KEY, keypath);
+	rc = get_key_path(dimm, path, keypath, key_type);
 	if (rc < 0)
 		return rc;
 
@@ -198,7 +226,7 @@ static key_serial_t dimm_create_key(struct ndctl_dimm *dimm,
 		return -EEXIST;
 	}
 
-	rc = sprintf(cmd, "new enc32 %s 32", master);
+	rc = sprintf(cmd, "new enc32 %s 32", master_key);
 	if (rc < 0) {
 		err(ctx, "sprintf: %s\n", strerror(errno));
 		return -errno;
@@ -245,7 +273,7 @@ static key_serial_t dimm_create_key(struct ndctl_dimm *dimm,
 }
 
 static key_serial_t dimm_load_key(struct ndctl_dimm *dimm,
-		enum ndctl_key_type key_type, const char *keypath)
+		const char *keypath, enum ndctl_key_type key_type)
 {
 	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
 	key_serial_t key;
@@ -265,7 +293,7 @@ static key_serial_t dimm_load_key(struct ndctl_dimm *dimm,
 	if (rc < 0)
 		return rc;
 
-	rc = get_key_path(dimm, path, key_type, keypath);
+	rc = get_key_path(dimm, path, keypath, key_type);
 	if (rc < 0)
 		return rc;
 
@@ -290,13 +318,14 @@ static key_serial_t dimm_load_key(struct ndctl_dimm *dimm,
  * ring.
  */
 static key_serial_t move_key_to_old(struct ndctl_dimm *dimm,
-		const char *keypath)
+		const char *keypath, enum ndctl_key_type key_type)
 {
 	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
 	int rc;
 	key_serial_t key;
 	char old_path[PATH_MAX];
 	char new_path[PATH_MAX];
+	enum ndctl_key_type okey_type;
 
 	if (ndctl_dimm_is_active(dimm)) {
 		err(ctx, "regions active on %s, op failed\n",
@@ -304,15 +333,22 @@ static key_serial_t move_key_to_old(struct ndctl_dimm *dimm,
 		return -EBUSY;
 	}
 
-	key = dimm_check_key(dimm, ND_USER_KEY);
+	key = dimm_check_key(dimm, key_type);
 	if (key > 0)
 		keyctl_unlink(key, KEY_SPEC_USER_KEYRING);
 
-	rc = get_key_path(dimm, old_path, ND_USER_KEY, keypath);
+	if (key_type == ND_USER_KEY)
+		okey_type = ND_USER_OLD_KEY;
+	else if (key_type == ND_MASTER_KEY)
+		okey_type = ND_MASTER_OLD_KEY;
+	else
+		return -EINVAL;
+
+	rc = get_key_path(dimm, old_path, keypath, key_type);
 	if (rc < 0)
 		return rc;
 
-	rc = get_key_path(dimm, new_path, ND_USER_OLD_KEY, keypath);
+	rc = get_key_path(dimm, new_path, keypath, okey_type);
 	if (rc < 0)
 		return rc;
 
@@ -323,11 +359,11 @@ static key_serial_t move_key_to_old(struct ndctl_dimm *dimm,
 		return -errno;
 	}
 
-	return dimm_load_key(dimm, ND_USER_OLD_KEY, keypath);
+	return dimm_load_key(dimm, keypath, okey_type);
 }
 
-static int dimm_remove_key(struct ndctl_dimm *dimm,
-		enum ndctl_key_type key_type, const char *keypath)
+static int dimm_remove_key(struct ndctl_dimm *dimm, const char *keypath,
+		enum ndctl_key_type key_type)
 {
 	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
 	key_serial_t key;
@@ -338,7 +374,7 @@ static int dimm_remove_key(struct ndctl_dimm *dimm,
 	if (key > 0)
 		keyctl_unlink(key, KEY_SPEC_USER_KEYRING);
 
-	rc = get_key_path(dimm, path, key_type, keypath);
+	rc = get_key_path(dimm, path, keypath, key_type);
 	if (rc < 0)
 		return rc;
 
@@ -353,18 +389,22 @@ static int dimm_remove_key(struct ndctl_dimm *dimm,
 }
 
 NDCTL_EXPORT int ndctl_dimm_enable_key(struct ndctl_dimm *dimm,
-		const char *master, const char *keypath)
+		const char *master_key, const char *keypath,
+		enum ndctl_key_type key_type)
 {
 	key_serial_t key;
 	int rc;
 
-	key = dimm_create_key(dimm, master, keypath);
+	key = dimm_create_key(dimm, master_key, keypath, key_type);
 	if (key < 0)
 		return key;
 
-	rc = ndctl_dimm_update_passphrase(dimm, 0, key);
+	if (key_type == ND_MASTER_KEY)
+		rc = ndctl_dimm_update_master_passphrase(dimm, 0, key);
+	else
+		rc = ndctl_dimm_update_passphrase(dimm, 0, key);
 	if (rc < 0) {
-		dimm_remove_key(dimm, ND_USER_KEY, keypath);
+		dimm_remove_key(dimm, keypath, key_type);
 		return rc;
 	}
 
@@ -372,10 +412,19 @@ NDCTL_EXPORT int ndctl_dimm_enable_key(struct ndctl_dimm *dimm,
 }
 
 NDCTL_EXPORT int ndctl_dimm_update_key(struct ndctl_dimm *dimm,
-		const char *master, const char *keypath)
+		const char *master_key, const char *keypath,
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
@@ -385,23 +434,27 @@ NDCTL_EXPORT int ndctl_dimm_update_key(struct ndctl_dimm *dimm,
 	 * 5. remove old key
 	 * 6. remove old key blob
 	 */
-	old_key = move_key_to_old(dimm, keypath);
+	old_key = move_key_to_old(dimm, keypath, key_type);
 	if (old_key < 0)
 		return old_key;
 
-	new_key = dimm_create_key(dimm, master, keypath);
+	new_key = dimm_create_key(dimm, master_key, keypath, key_type);
 	/* need to create new key here */
 	if (new_key < 0) {
-		new_key = dimm_load_key(dimm, ND_USER_KEY, keypath);
+		new_key = dimm_load_key(dimm, keypath, key_type);
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
 
-	rc = dimm_remove_key(dimm, ND_USER_OLD_KEY, keypath);
+	rc = dimm_remove_key(dimm, keypath, okey_type);
 	if (rc < 0)
 		return rc;
 
@@ -416,9 +469,9 @@ static int check_key_run_and_discard(struct ndctl_dimm *dimm,
 	key_serial_t key;
 	int rc;
 
-	key = dimm_check_key(dimm, false);
+	key = dimm_check_key(dimm, ND_USER_KEY);
 	if (key < 0) {
-		key = dimm_load_key(dimm, false, keypath);
+		key = dimm_load_key(dimm, keypath, ND_USER_KEY);
 		if (key < 0 && run_op != ndctl_dimm_overwrite) {
 			err(ctx, "Unable to load key\n");
 			return -ENOKEY;
@@ -434,7 +487,7 @@ static int check_key_run_and_discard(struct ndctl_dimm *dimm,
 	}
 
 	if (key) {
-		rc = dimm_remove_key(dimm, false, keypath);
+		rc = dimm_remove_key(dimm, keypath, ND_USER_KEY);
 		if (rc < 0)
 			err(ctx, "Unable to cleanup key.\n");
 	}
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index d2ca19ee..e4d89e06 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -402,4 +402,5 @@ global:
 	ndctl_dimm_overwrite;
 	ndctl_dimm_overwrite_key;
 	ndctl_dimm_wait_overwrite;
+	ndctl_dimm_update_master_passphrase;
 } LIBNDCTL_18;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 9217e381..0aa0640d 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -708,30 +708,36 @@ int ndctl_dimm_freeze_security(struct ndctl_dimm *dimm);
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
 int ndctl_dimm_enable_key(struct ndctl_dimm *dimm, const char *master,
-		const char *keypath);
+		const char *keypath, enum ndctl_key_type key_type);
 int ndctl_dimm_update_key(struct ndctl_dimm *dimm, const char *master,
-		const char *keypath);
+		const char *keypath, enum ndctl_key_type key_type);
 int ndctl_dimm_disable_key(struct ndctl_dimm *dimm, const char *keypath);
 int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm,
 		const char *keypath);
 int ndctl_dimm_overwrite_key(struct ndctl_dimm *dimm, const char *keypath);
 #else
 static inline int ndctl_dimm_enable_key(struct ndctl_dimm *dimm,
-		const char *master, const char *keypath)
+		const char *master_key, const char *keypath,
+		enum ndctl_key_type key_type)
 {
 	return -EOPNOTSUPP;
 }
 
 static inline int ndctl_dimm_update_key(struct ndctl_dimm *dimm,
-		const char *master, const char *keypath)
+		const char *master_key, const char *keypath,
+		enum ndctl_key_type key_type)
 {
 	return -EOPNOTSUPP;
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
