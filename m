Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A0036211A4593
 for <linux-nvdimm@lists.01.org>; Fri, 14 Dec 2018 13:09:58 -0800 (PST)
Subject: [PATCH v6 10/12] ndctl: master phassphrase management support
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 14 Dec 2018 14:09:57 -0700
Message-ID: <154482179753.65434.17512748045648394599.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154482154540.65434.14399161818571651882.stgit@djiang5-desk3.ch.intel.com>
References: <154482154540.65434.14399161818571651882.stgit@djiang5-desk3.ch.intel.com>
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
To: "vishal.l.verma."@intel.com, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Adding master passphrase enabling and update to ndctl. This is a new
feature from Intel DSM v1.8.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ndctl/ndctl-enable-passphrase.txt |    7 +
 Documentation/ndctl/ndctl-update-passphrase.txt |    7 +
 ndctl/dimm.c                                    |   11 ++
 ndctl/lib/dimm.c                                |    9 ++
 ndctl/lib/keys.c                                |  113 +++++++++++++++++------
 ndctl/lib/libndctl.sym                          |    1 
 ndctl/libndctl.h                                |   14 ++-
 7 files changed, 122 insertions(+), 40 deletions(-)

diff --git a/Documentation/ndctl/ndctl-enable-passphrase.txt b/Documentation/ndctl/ndctl-enable-passphrase.txt
index 8de5410c..6639ce8d 100644
--- a/Documentation/ndctl/ndctl-enable-passphrase.txt
+++ b/Documentation/ndctl/ndctl-enable-passphrase.txt
@@ -29,7 +29,12 @@ OPTIONS
 include::xable-dimm-options.txt[]
 
 -m::
---master=::
+--master-key=::
 	Key name for the master key used to seal the NVDIMM security keys.
 
+-M::
+--master-passphrase::
+	Parameter to indicate that we are managing the master passphrase
+	instead of the user passphrase.
+
 include::../copyright.txt[]
diff --git a/Documentation/ndctl/ndctl-update-passphrase.txt b/Documentation/ndctl/ndctl-update-passphrase.txt
index 9ed39cca..e2ecacf5 100644
--- a/Documentation/ndctl/ndctl-update-passphrase.txt
+++ b/Documentation/ndctl/ndctl-update-passphrase.txt
@@ -26,8 +26,13 @@ OPTIONS
 include::xable-dimm-options.txt[]
 
 -m::
---master::
+--master-key=::
 	New key name for the master key to seal the new nvdimm key, or the
 	existing master key name. i.e trusted:master-key.
 
+-M::
+--master-passphrase::
+	Parameter to indicate that we are managing the master passphrase
+	instead of the user passphrase.
+
 include::../copyright.txt[]
diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index 21ffea1e..c60ef96e 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -48,6 +48,7 @@ static struct parameters {
 	const char *master_key;
 	bool crypto_erase;
 	bool overwrite;
+	bool master_pass;
 	bool force;
 	bool json;
 	bool verbose;
@@ -848,7 +849,8 @@ static int action_key_enable(struct ndctl_dimm *dimm,
 		return -EOPNOTSUPP;
 	}
 
-	return ndctl_dimm_enable_key(dimm, param.master_key);
+	return ndctl_dimm_enable_key(dimm, param.master_key,
+			param.master_pass ? ND_MASTER_KEY : ND_USER_KEY);
 }
 
 static int action_key_update(struct ndctl_dimm *dimm,
@@ -860,7 +862,8 @@ static int action_key_update(struct ndctl_dimm *dimm,
 		return -EOPNOTSUPP;
 	}
 
-	return ndctl_dimm_update_key(dimm, param.master_key);
+	return ndctl_dimm_update_key(dimm, param.master_key,
+			param.master_pass ? ND_MASTER_KEY : ND_USER_KEY);
 }
 
 static int action_passphrase_disable(struct ndctl_dimm *dimm,
@@ -1037,7 +1040,9 @@ OPT_STRING('V', "label-version", &param.labelversion, "version-number", \
 
 #define KEY_OPTIONS() \
 OPT_STRING('m', "master-key", &param.master_key, "<key_type>:<key_name>", \
-		"master key for security")
+		"master key for security"), \
+OPT_BOOLEAN('M', "master-passphrase", &param.master_pass, \
+		"use master passphrase")
 
 #define SANITIZE_OPTIONS() \
 OPT_BOOLEAN('c', "crypto-erase", &param.crypto_erase, \
diff --git a/ndctl/lib/dimm.c b/ndctl/lib/dimm.c
index d815b9fc..07513b4b 100644
--- a/ndctl/lib/dimm.c
+++ b/ndctl/lib/dimm.c
@@ -768,3 +768,12 @@ NDCTL_EXPORT int ndctl_dimm_wait_for_overwrite_completion(
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
index fcf300bb..1d395b48 100644
--- a/ndctl/lib/keys.c
+++ b/ndctl/lib/keys.c
@@ -34,16 +34,29 @@ static int get_key_path(struct ndctl_dimm *dimm, char *path,
 		return -errno;
 	}
 
-	if (key_type == ND_USER_OLD_KEY) {
-		rc = sprintf(path, "%s/nvdimmold_%s_%s.blob",
-				ND_PASS_PATH,
-				ndctl_dimm_get_unique_id(dimm),
+	switch (key_type) {
+	case ND_USER_OLD_KEY:
+		rc = sprintf(path, "%s/nvdimm-old_%s_%s.blob",
+				ND_PASS_PATH, ndctl_dimm_get_unique_id(dimm),
 				hostname);
-	} else {
+		break;
+	case ND_USER_KEY:
 		rc = sprintf(path, "%s/nvdimm_%s_%s.blob",
-				ND_PASS_PATH,
-				ndctl_dimm_get_unique_id(dimm),
+				ND_PASS_PATH, ndctl_dimm_get_unique_id(dimm),
 				hostname);
+		break;
+	case ND_MASTER_OLD_KEY:
+		rc = sprintf(path, "%s/nvdimm-master-old_%s_%s.blob",
+				ND_PASS_PATH, ndctl_dimm_get_unique_id(dimm),
+				hostname);
+		break;
+	case ND_MASTER_KEY:
+		rc = sprintf(path, "%s/nvdimm-master_%s_%s.blob",
+				ND_PASS_PATH, ndctl_dimm_get_unique_id(dimm),
+				hostname);
+		break;
+	default:
+		return -EINVAL;
 	}
 
 	if (rc < 0) {
@@ -60,12 +73,26 @@ static int get_key_desc(struct ndctl_dimm *dimm, char *desc,
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
 		err(ctx, "sprintf: %s\n", strerror(errno));
@@ -144,7 +171,7 @@ static key_serial_t dimm_check_key(struct ndctl_dimm *dimm,
 }
 
 static key_serial_t dimm_create_key(struct ndctl_dimm *dimm,
-		const char *master)
+		const char *master_key, enum ndctl_key_type key_type)
 {
 	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
 	char desc[DESC_SIZE];
@@ -164,7 +191,7 @@ static key_serial_t dimm_create_key(struct ndctl_dimm *dimm,
 		return -EBUSY;
 	}
 
-	rc = get_key_desc(dimm, desc, ND_USER_KEY);
+	rc = get_key_desc(dimm, desc, key_type);
 	if (rc < 0)
 		return rc;
 
@@ -175,7 +202,7 @@ static key_serial_t dimm_create_key(struct ndctl_dimm *dimm,
 		return -EAGAIN;
 	}
 
-	rc = get_key_path(dimm, path, ND_USER_KEY);
+	rc = get_key_path(dimm, path, key_type);
 	if (rc < 0)
 		return rc;
 
@@ -185,7 +212,7 @@ static key_serial_t dimm_create_key(struct ndctl_dimm *dimm,
 		return -EAGAIN;
 	}
 
-	rc = sprintf(cmd, "new enc32 %s 32", master);
+	rc = sprintf(cmd, "new enc32 %s 32", master_key);
 	if (rc < 0) {
 		err(ctx, "sprintf: %s\n", strerror(errno));
 		return -errno;
@@ -271,13 +298,15 @@ static key_serial_t dimm_load_key(struct ndctl_dimm *dimm,
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
 	char old_path[PATH_SIZE];
 	char new_path[PATH_SIZE];
+	enum ndctl_key_type okey_type;
 
 	if (ndctl_dimm_is_active(dimm)) {
 		err(ctx, "regions active on %s, op failed\n",
@@ -285,15 +314,22 @@ static key_serial_t move_key_to_old(struct ndctl_dimm *dimm)
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
 
@@ -301,7 +337,7 @@ static key_serial_t move_key_to_old(struct ndctl_dimm *dimm)
 	if (rc < 0)
 		return -errno;
 
-	return dimm_load_key(dimm, ND_USER_OLD_KEY);
+	return dimm_load_key(dimm, okey_type);
 }
 
 static int dimm_remove_key(struct ndctl_dimm *dimm,
@@ -330,18 +366,21 @@ static int dimm_remove_key(struct ndctl_dimm *dimm,
 }
 
 NDCTL_EXPORT int ndctl_dimm_enable_key(struct ndctl_dimm *dimm,
-		const char *master)
+		const char *master_key, enum ndctl_key_type key_type)
 {
 	key_serial_t key;
 	int rc;
 
-	key = dimm_create_key(dimm, master);
+	key = dimm_create_key(dimm, master_key, key_type);
 	if (key < 0)
 		return (int)key;
 
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
 
@@ -349,10 +388,18 @@ NDCTL_EXPORT int ndctl_dimm_enable_key(struct ndctl_dimm *dimm,
 }
 
 NDCTL_EXPORT int ndctl_dimm_update_key(struct ndctl_dimm *dimm,
-		const char *master)
+		const char *master_key, enum ndctl_key_type key_type)
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
@@ -362,23 +409,27 @@ NDCTL_EXPORT int ndctl_dimm_update_key(struct ndctl_dimm *dimm,
 	 * 5. remove old key
 	 * 6. remove old key blob
 	 */
-	old_key = move_key_to_old(dimm);
+	old_key = move_key_to_old(dimm, key_type);
 	if (old_key < 0)
 		return old_key;
 
-	new_key = dimm_create_key(dimm, master);
+	new_key = dimm_create_key(dimm, master_key, key_type);
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
 
@@ -392,9 +443,9 @@ static int check_key_run_and_discard(struct ndctl_dimm *dimm,
 	key_serial_t key;
 	int rc;
 
-	key = dimm_check_key(dimm, false);
+	key = dimm_check_key(dimm, ND_USER_KEY);
 	if (key < 0) {
-		key = dimm_load_key(dimm, false);
+		key = dimm_load_key(dimm, ND_USER_KEY);
 		if (key < 0 && run_op != ndctl_dimm_overwrite) {
 			err(ctx, "Unable to load key\n");
 			return -ENOKEY;
@@ -410,7 +461,7 @@ static int check_key_run_and_discard(struct ndctl_dimm *dimm,
 	}
 
 	if (key) {
-		rc = dimm_remove_key(dimm, false);
+		rc = dimm_remove_key(dimm, ND_USER_KEY);
 		if (rc < 0)
 			err(ctx, "Unable to cleanup key.\n");
 	}
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 0da8b282..bd933eb2 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -401,4 +401,5 @@ global:
 	ndctl_dimm_overwrite;
 	ndctl_dimm_overwrite_key;
 	ndctl_dimm_wait_for_overwrite_completion;
+	ndctl_dimm_update_master_passphrase;
 } LIBNDCTL_18;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 5c34f2cb..a0b8a886 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -707,27 +707,33 @@ int ndctl_dimm_freeze_security(struct ndctl_dimm *dimm);
 int ndctl_dimm_secure_erase(struct ndctl_dimm *dimm, long key);
 int ndctl_dimm_overwrite(struct ndctl_dimm *dimm, long key);
 int ndctl_dimm_wait_for_overwrite_completion(struct ndctl_dimm *dimm);
+int ndctl_dimm_update_master_passphrase(struct ndctl_dimm *dimm,
+		long ckey, long nkey);
 
 enum ndctl_key_type {
 	ND_USER_KEY,
 	ND_USER_OLD_KEY,
+	ND_MASTER_KEY,
+	ND_MASTER_OLD_KEY,
 };
 
 #ifdef ENABLE_KEYUTILS
-int ndctl_dimm_enable_key(struct ndctl_dimm *dimm, const char *master);
-int ndctl_dimm_update_key(struct ndctl_dimm *dimm, const char *master);
+int ndctl_dimm_enable_key(struct ndctl_dimm *dimm, const char *master_key,
+		enum ndctl_key_type key_type);
+int ndctl_dimm_update_key(struct ndctl_dimm *dimm, const char *master_key,
+		enum ndctl_key_type key_type);
 int ndctl_dimm_disable_key(struct ndctl_dimm *dimm);
 int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm);
 int ndctl_dimm_overwrite_key(struct ndctl_dimm *dimm);
 #else
 static inline int ndctl_dimm_enable_key(struct ndctl_dimm *dimm,
-		const char *master)
+		const char *master_key, enum ndctl_key_type key_type);
 {
 	return -EOPNOTSUPP;
 }
 
 static inline int ndctl_dimm_update_key(struct ndctl_dimm *dimm,
-		const char *master)
+		const char *master_key, enum ndctl_key_type key_type);
 {
 	return -EOPNOTSUPP;
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
