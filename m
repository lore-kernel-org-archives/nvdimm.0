Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4D67521959CB2
 for <linux-nvdimm@lists.01.org>; Mon, 14 Jan 2019 12:07:39 -0800 (PST)
Subject: [PATCH v8 11/12] ndctl: add master secure erase support
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 14 Jan 2019 13:07:38 -0700
Message-ID: <154749645834.63704.14485342852418327639.stgit@djiang5-desk3.ch.intel.com>
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

Intel DSM v1.8 introduced the concept of master passphrase and allowing
nvdimm to be secure erased via the master passphrase in addition to the
user passphrase. Add ndctl support to provide master passphrase secure
erase.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ndctl/ndctl-sanitize-dimm.txt |    6 ++++++
 ndctl/dimm.c                                |   14 ++++++++++++--
 ndctl/lib/dimm.c                            |    9 +++++++++
 ndctl/lib/keys.c                            |   28 +++++++++++++++++++--------
 ndctl/lib/libndctl.sym                      |    1 +
 ndctl/libndctl.h                            |    5 +++--
 6 files changed, 51 insertions(+), 12 deletions(-)

diff --git a/Documentation/ndctl/ndctl-sanitize-dimm.txt b/Documentation/ndctl/ndctl-sanitize-dimm.txt
index a1a43bdd..3a09ae59 100644
--- a/Documentation/ndctl/ndctl-sanitize-dimm.txt
+++ b/Documentation/ndctl/ndctl-sanitize-dimm.txt
@@ -39,4 +39,10 @@ include::xable-dimm-options.txt[]
 --ovewrite::
 	Wipe the entire DIMM, including label data. Can take significant time.
 
+-M::
+--master_passphrase::
+	Parameter to indicate that we are managing the master passphrase
+	instead of the user passphrase. This only is applicable to the
+	crypto-erase option.
+
 include::../copyright.txt[]
diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index 4875e414..7f2d4873 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -908,6 +908,12 @@ static int action_sanitize_dimm(struct ndctl_dimm *dimm,
 		return -EOPNOTSUPP;
 	}
 
+	if (param.overwrite && param.master_pass) {
+		error("%s: overwrite does not support master passphrase\n",
+				ndctl_dimm_get_devname(dimm));
+		return -EINVAL;
+	}
+
 	/*
 	 * Setting crypto erase to be default. The other method will be
 	 * overwrite.
@@ -918,7 +924,9 @@ static int action_sanitize_dimm(struct ndctl_dimm *dimm,
 	}
 
 	if (param.crypto_erase) {
-		rc = ndctl_dimm_secure_erase_key(dimm, param.key_path);
+		rc = ndctl_dimm_secure_erase_key(dimm, param.key_path,
+				param.master_pass ?
+				ND_MASTER_KEY : ND_USER_KEY);
 		if (rc < 0)
 			return rc;
 	}
@@ -1053,7 +1061,9 @@ OPT_BOOLEAN('M', "master-passphrase", &param.master_pass, \
 OPT_BOOLEAN('c', "crypto-erase", &param.crypto_erase, \
 		"crypto erase a dimm"), \
 OPT_BOOLEAN('o', "overwrite", &param.overwrite, \
-		"overwrite a dimm")
+		"overwrite a dimm"), \
+OPT_BOOLEAN('M', "master-passphrase", &param.master_pass, \
+		"use master passphrase")
 
 static const struct option read_options[] = {
 	BASE_OPTIONS(),
diff --git a/ndctl/lib/dimm.c b/ndctl/lib/dimm.c
index dc945296..b9bf9cc2 100644
--- a/ndctl/lib/dimm.c
+++ b/ndctl/lib/dimm.c
@@ -780,3 +780,12 @@ NDCTL_EXPORT int ndctl_dimm_update_master_passphrase(struct ndctl_dimm *dimm,
 	sprintf(buf, "master_update %ld %ld\n", ckey, nkey);
 	return write_security(dimm, buf);
 }
+
+NDCTL_EXPORT int ndctl_dimm_master_secure_erase(struct ndctl_dimm *dimm,
+		long key)
+{
+	char buf[SYSFS_ATTR_SIZE];
+
+	sprintf(buf, "master_erase %ld\n", key);
+	return write_security(dimm, buf);
+}
diff --git a/ndctl/lib/keys.c b/ndctl/lib/keys.c
index 09ceeb57..c10dc436 100644
--- a/ndctl/lib/keys.c
+++ b/ndctl/lib/keys.c
@@ -463,13 +463,13 @@ NDCTL_EXPORT int ndctl_dimm_update_key(struct ndctl_dimm *dimm,
 
 static int check_key_run_and_discard(struct ndctl_dimm *dimm,
 		int (*run_op)(struct ndctl_dimm *, long), const char *name,
-		const char *keypath)
+		const char *keypath, enum ndctl_key_type key_type)
 {
 	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
 	key_serial_t key;
 	int rc;
 
-	key = dimm_check_key(dimm, ND_USER_KEY);
+	key = dimm_check_key(dimm, key_type);
 	if (key < 0) {
 		key = dimm_load_key(dimm, keypath, ND_USER_KEY);
 		if (key < 0 && run_op != ndctl_dimm_overwrite) {
@@ -486,8 +486,12 @@ static int check_key_run_and_discard(struct ndctl_dimm *dimm,
 		return rc;
 	}
 
+	/* we do not delete the key if master secure erase */
+	if (key_type == ND_MASTER_KEY)
+		return 0;
+
 	if (key) {
-		rc = dimm_remove_key(dimm, keypath, ND_USER_KEY);
+		rc = dimm_remove_key(dimm, keypath, key_type);
 		if (rc < 0)
 			err(ctx, "Unable to cleanup key.\n");
 	}
@@ -498,19 +502,27 @@ NDCTL_EXPORT int ndctl_dimm_disable_key(struct ndctl_dimm *dimm,
 		const char *keypath)
 {
 	return check_key_run_and_discard(dimm, ndctl_dimm_disable_passphrase,
-			"disable passphrase", keypath);
+			"disable passphrase", keypath, ND_USER_KEY);
 }
 
 NDCTL_EXPORT int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm,
-		const char *keypath)
+		const char *keypath, enum ndctl_key_type key_type)
 {
-	return check_key_run_and_discard(dimm, ndctl_dimm_secure_erase,
-			"crypto erase", keypath);
+	if (key_type == ND_MASTER_KEY)
+		return check_key_run_and_discard(dimm,
+				ndctl_dimm_master_secure_erase,
+				"master crypto erase", keypath, key_type);
+	else if (key_type == ND_USER_KEY)
+		return check_key_run_and_discard(dimm,
+				ndctl_dimm_secure_erase,
+				"crypto erase", keypath, key_type);
+	else
+		return -EINVAL;
 }
 
 NDCTL_EXPORT int ndctl_dimm_overwrite_key(struct ndctl_dimm *dimm,
 		const char *keypath)
 {
 	return check_key_run_and_discard(dimm, ndctl_dimm_overwrite,
-			"overwrite", keypath);
+			"overwrite", keypath, ND_USER_KEY);
 }
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index e4d89e06..d724f5b9 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -403,4 +403,5 @@ global:
 	ndctl_dimm_overwrite_key;
 	ndctl_dimm_wait_overwrite;
 	ndctl_dimm_update_master_passphrase;
+	ndctl_dimm_master_secure_erase;
 } LIBNDCTL_18;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 0aa0640d..17321242 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -710,6 +710,7 @@ int ndctl_dimm_overwrite(struct ndctl_dimm *dimm, long key);
 int ndctl_dimm_wait_overwrite(struct ndctl_dimm *dimm);
 int ndctl_dimm_update_master_passphrase(struct ndctl_dimm *dimm,
 		long ckey, long nkey);
+int ndctl_dimm_master_secure_erase(struct ndctl_dimm *dimm, long key);
 
 enum ndctl_key_type {
 	ND_USER_KEY,
@@ -725,7 +726,7 @@ int ndctl_dimm_update_key(struct ndctl_dimm *dimm, const char *master,
 		const char *keypath, enum ndctl_key_type key_type);
 int ndctl_dimm_disable_key(struct ndctl_dimm *dimm, const char *keypath);
 int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm,
-		const char *keypath);
+		const char *keypath, enum ndctl_key_type key_type);
 int ndctl_dimm_overwrite_key(struct ndctl_dimm *dimm, const char *keypath);
 #else
 static inline int ndctl_dimm_enable_key(struct ndctl_dimm *dimm,
@@ -749,7 +750,7 @@ static inline int ndctl_dimm_disable_key(struct ndctl_dimm *dimm,
 }
 
 static inline int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm,
-		const char *keypath)
+		const char *keypath, enum ndctl_key_type key_type)
 {
 	return -EOPNOTSUPP;
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
