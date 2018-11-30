Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9E10F2119623A
 for <linux-nvdimm@lists.01.org>; Fri, 30 Nov 2018 13:34:20 -0800 (PST)
Subject: [PATCH v5 10/12] ndctl: master phassphrase management support
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 30 Nov 2018 14:34:19 -0700
Message-ID: <154361365963.6129.2787047000564382171.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154361315118.6129.3346352930852675435.stgit@djiang5-desk3.ch.intel.com>
References: <154361315118.6129.3346352930852675435.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com, vishal.l.verma@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Adding master passphrase enabling and update to ndctl. This is a new
feature from Intel DSM v1.8.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ndctl/ndctl-enable-passphrase.txt |    7 +
 Documentation/ndctl/ndctl-update-passphrase.txt |    7 +
 ndctl/dimm.c                                    |   11 +-
 ndctl/lib/dimm.c                                |    9 ++
 ndctl/lib/keys.c                                |  125 +++++++++++++++--------
 ndctl/lib/libndctl.sym                          |    1 
 ndctl/libndctl.h                                |   12 +-
 7 files changed, 117 insertions(+), 55 deletions(-)

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
index 68443893..f487cf81 100644
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
+			param.master_pass);
 }
 
 static int action_key_update(struct ndctl_dimm *dimm,
@@ -860,7 +862,8 @@ static int action_key_update(struct ndctl_dimm *dimm,
 		return -EOPNOTSUPP;
 	}
 
-	return ndctl_dimm_update_key(dimm, param.master_key);
+	return ndctl_dimm_update_key(dimm, param.master_key,
+			param.master_pass);
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
index 903fb408..e112609b 100644
--- a/ndctl/lib/keys.c
+++ b/ndctl/lib/keys.c
@@ -21,7 +21,8 @@
 #define DESC_SIZE	128
 #define KEY_CMD_SIZE	128
 
-static int get_key_path(struct ndctl_dimm *dimm, char *path, bool old)
+static int get_key_path(struct ndctl_dimm *dimm, char *path, bool old,
+		bool master)
 {
 	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
 	char hostname[HOSTNAME_SIZE];
@@ -34,15 +35,27 @@ static int get_key_path(struct ndctl_dimm *dimm, char *path, bool old)
 	}
 
 	if (old) {
-		rc = sprintf(path, "%s/nvdimmold_%s_%s.blob",
-				ND_PASS_PATH,
-				ndctl_dimm_get_unique_id(dimm),
-				hostname);
+		if (master)
+			rc = sprintf(path, "%s/nvdimm-master-old_%s_%s.blob",
+					ND_PASS_PATH,
+					ndctl_dimm_get_unique_id(dimm),
+					hostname);
+		else
+			rc = sprintf(path, "%s/nvdimm-old_%s_%s.blob",
+					ND_PASS_PATH,
+					ndctl_dimm_get_unique_id(dimm),
+					hostname);
 	} else {
-		rc = sprintf(path, "%s/nvdimm_%s_%s.blob",
-				ND_PASS_PATH,
-				ndctl_dimm_get_unique_id(dimm),
-				hostname);
+		if (master)
+			rc = sprintf(path, "%s/nvdimm-master_%s_%s.blob",
+					ND_PASS_PATH,
+					ndctl_dimm_get_unique_id(dimm),
+					hostname);
+		else
+			rc = sprintf(path, "%s/nvdimm_%s_%s.blob",
+					ND_PASS_PATH,
+					ndctl_dimm_get_unique_id(dimm),
+					hostname);
 	}
 
 	if (rc < 0) {
@@ -53,17 +66,28 @@ static int get_key_path(struct ndctl_dimm *dimm, char *path, bool old)
 	return 0;
 }
 
-static int get_key_desc(struct ndctl_dimm *dimm, char *desc, bool old)
+static int get_key_desc(struct ndctl_dimm *dimm, char *desc, bool old,
+		bool master)
 {
 	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
 	int rc;
 
-	if (old)
-		rc = sprintf(desc, "nvdimm-old:%s",
-				ndctl_dimm_get_unique_id(dimm));
-	else
-		rc = sprintf(desc, "nvdimm:%s",
-				ndctl_dimm_get_unique_id(dimm));
+	if (old) {
+		if (master)
+			rc = sprintf(desc, "nvdimm-master-old:%s",
+					ndctl_dimm_get_unique_id(dimm));
+
+		else
+			rc = sprintf(desc, "nvdimm-old:%s",
+					ndctl_dimm_get_unique_id(dimm));
+	} else {
+		if (master)
+			rc = sprintf(desc, "nvdimm-master:%s",
+					ndctl_dimm_get_unique_id(dimm));
+		else
+			rc = sprintf(desc, "nvdimm:%s",
+					ndctl_dimm_get_unique_id(dimm));
+	}
 
 	if (rc < 0) {
 		err(ctx, "sprintf: %s\n", strerror(errno));
@@ -127,13 +151,13 @@ static char *load_key_blob(struct ndctl_ctx *ctx, const char *path, int *size)
 }
 
 static key_serial_t dimm_check_key(struct ndctl_dimm *dimm,
-		bool old)
+		bool old, bool master)
 {
 	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
 	char desc[DESC_SIZE];
 	int rc;
 
-	rc = get_key_desc(dimm, desc, old);
+	rc = get_key_desc(dimm, desc, old, master);
 	if (rc < 0) {
 		err(ctx, "sprintf: %d\n", rc);
 		return rc;
@@ -142,7 +166,8 @@ static key_serial_t dimm_check_key(struct ndctl_dimm *dimm,
 	return keyctl_search(KEY_SPEC_USER_KEYRING, "encrypted", desc, 0);
 }
 
-static key_serial_t dimm_create_key(struct ndctl_dimm *dimm, const char *master)
+static key_serial_t dimm_create_key(struct ndctl_dimm *dimm,
+		const char *master_key, bool master)
 {
 	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
 	char desc[DESC_SIZE];
@@ -162,7 +187,7 @@ static key_serial_t dimm_create_key(struct ndctl_dimm *dimm, const char *master)
 		return -EBUSY;
 	}
 
-	rc = get_key_desc(dimm, desc, false);
+	rc = get_key_desc(dimm, desc, false, master);
 	if (rc < 0)
 		return rc;
 
@@ -173,7 +198,7 @@ static key_serial_t dimm_create_key(struct ndctl_dimm *dimm, const char *master)
 		return -EAGAIN;
 	}
 
-	rc = get_key_path(dimm, path, false);
+	rc = get_key_path(dimm, path, false, master);
 	if (rc < 0)
 		return rc;
 
@@ -183,7 +208,7 @@ static key_serial_t dimm_create_key(struct ndctl_dimm *dimm, const char *master)
 		return -EAGAIN;
 	}
 
-	rc = sprintf(cmd, "new enc32 %s 32", master);
+	rc = sprintf(cmd, "new enc32 %s 32", master_key);
 	if (rc < 0) {
 		err(ctx, "sprintf: %s\n", strerror(errno));
 		return -errno;
@@ -224,7 +249,8 @@ static key_serial_t dimm_create_key(struct ndctl_dimm *dimm, const char *master)
 	 return key;
 }
 
-static key_serial_t dimm_load_key(struct ndctl_dimm *dimm, bool old)
+static key_serial_t dimm_load_key(struct ndctl_dimm *dimm, bool old,
+		bool master)
 {
 	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
 	key_serial_t key;
@@ -240,11 +266,11 @@ static key_serial_t dimm_load_key(struct ndctl_dimm *dimm, bool old)
 		return -EBUSY;
 	}
 
-	rc = get_key_desc(dimm, desc, old);
+	rc = get_key_desc(dimm, desc, old, master);
 	if (rc < 0)
 		return rc;
 
-	rc = get_key_path(dimm, path, old);
+	rc = get_key_path(dimm, path, old, master);
 	if (rc < 0)
 		return rc;
 
@@ -268,7 +294,7 @@ static key_serial_t dimm_load_key(struct ndctl_dimm *dimm, bool old)
  * blob, and then attempt to inject the key as old key into the user key
  * ring.
  */
-static key_serial_t move_key_to_old(struct ndctl_dimm *dimm)
+static key_serial_t move_key_to_old(struct ndctl_dimm *dimm, bool master)
 {
 	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
 	int rc;
@@ -282,15 +308,15 @@ static key_serial_t move_key_to_old(struct ndctl_dimm *dimm)
 		return -EBUSY;
 	}
 
-	key = dimm_check_key(dimm, false);
+	key = dimm_check_key(dimm, false, master);
 	if (key > 0)
 		keyctl_unlink(key, KEY_SPEC_USER_KEYRING);
 
-	rc = get_key_path(dimm, old_path, false);
+	rc = get_key_path(dimm, old_path, false, master);
 	if (rc < 0)
 		return rc;
 
-	rc = get_key_path(dimm, new_path, true);
+	rc = get_key_path(dimm, new_path, true, master);
 	if (rc < 0)
 		return rc;
 
@@ -298,21 +324,21 @@ static key_serial_t move_key_to_old(struct ndctl_dimm *dimm)
 	if (rc < 0)
 		return -errno;
 
-	return dimm_load_key(dimm, true);
+	return dimm_load_key(dimm, true, master);
 }
 
-static int dimm_remove_key(struct ndctl_dimm *dimm, bool old)
+static int dimm_remove_key(struct ndctl_dimm *dimm, bool old, bool master)
 {
 	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
 	key_serial_t key;
 	char path[PATH_SIZE];
 	int rc;
 
-	key = dimm_check_key(dimm, old);
+	key = dimm_check_key(dimm, old, master);
 	if (key > 0)
 		keyctl_unlink(key, KEY_SPEC_USER_KEYRING);
 
-	rc = get_key_path(dimm, path, old);
+	rc = get_key_path(dimm, path, old, master);
 	if (rc < 0) {
 		err(ctx, "get key file path failed: %d\n", rc);
 		return rc;
@@ -328,18 +354,21 @@ static int dimm_remove_key(struct ndctl_dimm *dimm, bool old)
 }
 
 NDCTL_EXPORT int ndctl_dimm_enable_key(struct ndctl_dimm *dimm,
-		const char *master)
+		const char *master_key, bool master)
 {
 	key_serial_t key;
 	int rc;
 
-	key = dimm_create_key(dimm, master);
+	key = dimm_create_key(dimm, master_key, master);
 	if (key < 0)
 		return (int)key;
 
-	rc = ndctl_dimm_update_passphrase(dimm, 0, key);
+	if (master)
+		rc = ndctl_dimm_update_master_passphrase(dimm, 0, key);
+	else
+		rc = ndctl_dimm_update_passphrase(dimm, 0, key);
 	if (rc < 0) {
-		dimm_remove_key(dimm, false);
+		dimm_remove_key(dimm, false, master);
 		return rc;
 	}
 
@@ -347,7 +376,7 @@ NDCTL_EXPORT int ndctl_dimm_enable_key(struct ndctl_dimm *dimm,
 }
 
 NDCTL_EXPORT int ndctl_dimm_update_key(struct ndctl_dimm *dimm,
-		const char *master)
+		const char *master_key, bool master)
 {
 	int rc;
 	key_serial_t old_key, new_key;
@@ -360,23 +389,27 @@ NDCTL_EXPORT int ndctl_dimm_update_key(struct ndctl_dimm *dimm,
 	 * 5. remove old key
 	 * 6. remove old key blob
 	 */
-	old_key = move_key_to_old(dimm);
+	old_key = move_key_to_old(dimm, master);
 	if (old_key < 0)
 		return old_key;
 
-	new_key = dimm_create_key(dimm, master);
+	new_key = dimm_create_key(dimm, master_key, master);
 	/* need to create new key here */
 	if (new_key < 0) {
-		new_key = dimm_load_key(dimm, false);
+		new_key = dimm_load_key(dimm, false, master);
 		if (new_key < 0)
 			return new_key;
 	}
 
-	rc = ndctl_dimm_update_passphrase(dimm, old_key, new_key);
+	if (master)
+		rc = ndctl_dimm_update_master_passphrase(dimm,
+				old_key, new_key);
+	else
+		rc = ndctl_dimm_update_passphrase(dimm, old_key, new_key);
 	if (rc < 0)
 		return rc;
 
-	rc = dimm_remove_key(dimm, true);
+	rc = dimm_remove_key(dimm, true, master);
 	if (rc < 0)
 		return rc;
 
@@ -390,9 +423,9 @@ static int check_key_run_and_discard(struct ndctl_dimm *dimm,
 	key_serial_t key;
 	int rc;
 
-	key = dimm_check_key(dimm, false);
+	key = dimm_check_key(dimm, false, false);
 	if (key < 0) {
-		key = dimm_load_key(dimm, false);
+		key = dimm_load_key(dimm, false, false);
 		if (key < 0) {
 			err(ctx, "Unable to load key\n");
 			return -ENOKEY;
@@ -406,7 +439,7 @@ static int check_key_run_and_discard(struct ndctl_dimm *dimm,
 		return rc;
 	}
 
-	rc = dimm_remove_key(dimm, false);
+	rc = dimm_remove_key(dimm, false, false);
 	if (rc < 0)
 		err(ctx, "Unable to cleanup key.\n");
 	return 0;
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
index d21e07d2..d07fbfc9 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -707,22 +707,26 @@ int ndctl_dimm_freeze_security(struct ndctl_dimm *dimm);
 int ndctl_dimm_secure_erase(struct ndctl_dimm *dimm, long key);
 int ndctl_dimm_overwrite(struct ndctl_dimm *dimm, long key);
 int ndctl_dimm_wait_for_overwrite_completion(struct ndctl_dimm *dimm);
+int ndctl_dimm_update_master_passphrase(struct ndctl_dimm *dimm,
+		long ckey, long nkey);
 
 #ifdef ENABLE_KEYUTILS
-int ndctl_dimm_enable_key(struct ndctl_dimm *dimm, const char *master);
-int ndctl_dimm_update_key(struct ndctl_dimm *dimm, const char *master);
+int ndctl_dimm_enable_key(struct ndctl_dimm *dimm, const char *master_key,
+		bool master);
+int ndctl_dimm_update_key(struct ndctl_dimm *dimm, const char *master_key,
+		bool master);
 int ndctl_dimm_disable_key(struct ndctl_dimm *dimm);
 int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm);
 int ndctl_dimm_overwrite_key(struct ndctl_dimm *dimm);
 #else
 static inline int ndctl_dimm_enable_key(struct ndctl_dimm *dimm,
-		const char *master)
+		const char *master_key, bool master)
 {
 	return -EOPNOTSUPP;
 }
 
 static inline int ndctl_dimm_update_key(struct ndctl_dimm *dimm,
-		const char *master)
+		const char *master_key, bool master)
 {
 	return -EOPNOTSUPP;
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
