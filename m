Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BDC69211B509C
 for <linux-nvdimm@lists.01.org>; Thu, 17 Jan 2019 18:39:27 -0800 (PST)
Subject: [PATCH v9 12/13] ndctl: add master secure erase support
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 17 Jan 2019 19:39:27 -0700
Message-ID: <154777916718.42557.17152295696928992092.stgit@djiang5-desk3.ch.intel.com>
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

Intel DSM v1.8 introduced the concept of master passphrase and allowing
nvdimm to be secure erased via the master passphrase in addition to the
user passphrase. Add ndctl support to provide master passphrase secure
erase.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ndctl/ndctl-sanitize-dimm.txt |    6 +++++
 ndctl/dimm.c                                |   13 ++++++++++-
 ndctl/lib/dimm.c                            |    9 ++++++++
 ndctl/lib/keys.c                            |   31 ++++++++++++++++++---------
 ndctl/lib/libndctl.sym                      |    1 +
 ndctl/libndctl.h                            |    7 ++++--
 6 files changed, 53 insertions(+), 14 deletions(-)

diff --git a/Documentation/ndctl/ndctl-sanitize-dimm.txt b/Documentation/ndctl/ndctl-sanitize-dimm.txt
index 158392bf..b01360d2 100644
--- a/Documentation/ndctl/ndctl-sanitize-dimm.txt
+++ b/Documentation/ndctl/ndctl-sanitize-dimm.txt
@@ -33,6 +33,12 @@ include::xable-dimm-options.txt[]
 --ovewrite::
 	Wipe the entire DIMM, including label data. Can take significant time.
 
+-M::
+--master_passphrase::
+	Parameter to indicate that we are managing the master passphrase
+	instead of the user passphrase. This only is applicable to the
+	crypto-erase option.
+
 include::../copyright.txt[]
 
 SEE ALSO
diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index 4a7cca8e..77dc6960 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -906,6 +906,12 @@ static int action_sanitize_dimm(struct ndctl_dimm *dimm,
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
@@ -916,7 +922,8 @@ static int action_sanitize_dimm(struct ndctl_dimm *dimm,
 	}
 
 	if (param.crypto_erase) {
-		rc = ndctl_dimm_secure_erase_key(dimm);
+		rc = ndctl_dimm_secure_erase_key(dimm, param.master_pass ?
+				ND_MASTER_KEY : ND_USER_KEY);
 		if (rc < 0)
 			return rc;
 	}
@@ -1041,7 +1048,9 @@ OPT_STRING('V', "label-version", &param.labelversion, "version-number", \
 OPT_BOOLEAN('c', "crypto-erase", &param.crypto_erase, \
 		"crypto erase a dimm"), \
 OPT_BOOLEAN('o', "overwrite", &param.overwrite, \
-		"overwrite a dimm")
+		"overwrite a dimm"), \
+OPT_BOOLEAN('M', "master-passphrase", &param.master_pass, \
+		"use master passphrase")
 
 #define MASTER_OPTIONS() \
 OPT_BOOLEAN('m', "master-passphrase", &param.master_pass, \
diff --git a/ndctl/lib/dimm.c b/ndctl/lib/dimm.c
index 5c65d171..0a4ca797 100644
--- a/ndctl/lib/dimm.c
+++ b/ndctl/lib/dimm.c
@@ -772,3 +772,12 @@ NDCTL_EXPORT int ndctl_dimm_update_master_passphrase(struct ndctl_dimm *dimm,
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
index 9abff45b..4d89074d 100644
--- a/ndctl/lib/keys.c
+++ b/ndctl/lib/keys.c
@@ -466,14 +466,15 @@ NDCTL_EXPORT int ndctl_dimm_update_key(struct ndctl_dimm *dimm,
 	return 0;
 }
 
-static key_serial_t check_dimm_key(struct ndctl_dimm *dimm, bool need_key)
+static key_serial_t check_dimm_key(struct ndctl_dimm *dimm, bool need_key,
+		enum ndctl_key_type key_type)
 {
 	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
 	key_serial_t key;
 
-	key = dimm_check_key(dimm, ND_USER_KEY);
+	key = dimm_check_key(dimm, key_type);
 	if (key < 0) {
-		key = dimm_load_key(dimm, ND_USER_KEY);
+		key = dimm_load_key(dimm, key_type);
 		if (key < 0 && need_key) {
 			err(ctx, "Unable to load key\n");
 			return -ENOKEY;
@@ -520,7 +521,7 @@ NDCTL_EXPORT int ndctl_dimm_remove_key(struct ndctl_dimm *dimm)
 	key_serial_t key;
 	int rc;
 
-	key = check_dimm_key(dimm, true);
+	key = check_dimm_key(dimm, true, ND_USER_KEY);
 	if (key < 0)
 		return key;
 
@@ -532,21 +533,31 @@ NDCTL_EXPORT int ndctl_dimm_remove_key(struct ndctl_dimm *dimm)
 	return discard_key(dimm);
 }
 
-NDCTL_EXPORT int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm)
+NDCTL_EXPORT int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm,
+		enum ndctl_key_type key_type)
 {
 	key_serial_t key;
 	int rc;
 
-	key = check_dimm_key(dimm, true);
+	key = check_dimm_key(dimm, true, key_type);
 	if (key < 0)
 		return key;
 
-	rc = run_key_op(dimm, key, ndctl_dimm_secure_erase,
-			"crypto erase");
+	if (key_type == ND_MASTER_KEY)
+		rc = run_key_op(dimm, key, ndctl_dimm_master_secure_erase,
+				"master crypto erase");
+	else if (key_type == ND_USER_KEY)
+		rc = run_key_op(dimm, key, ndctl_dimm_secure_erase,
+				"crypto erase");
+	else
+		rc = -EINVAL;
 	if (rc < 0)
 		return rc;
 
-	return discard_key(dimm);
+	if (key_type == ND_USER_KEY)
+		return discard_key(dimm);
+
+	return 0;
 }
 
 NDCTL_EXPORT int ndctl_dimm_overwrite_key(struct ndctl_dimm *dimm)
@@ -554,7 +565,7 @@ NDCTL_EXPORT int ndctl_dimm_overwrite_key(struct ndctl_dimm *dimm)
 	key_serial_t key;
 	int rc;
 
-	key = check_dimm_key(dimm, false);
+	key = check_dimm_key(dimm, false, ND_USER_KEY);
 	if (key < 0)
 		return key;
 
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index fd260aae..b4edf0e8 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -405,4 +405,5 @@ global:
 	ndctl_dimm_overwrite_key;
 	ndctl_dimm_wait_overwrite;
 	ndctl_dimm_update_master_passphrase;
+	ndctl_dimm_master_secure_erase;
 } LIBNDCTL_18;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 7a5236b8..1840c48c 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -712,6 +712,7 @@ int ndctl_dimm_overwrite(struct ndctl_dimm *dimm, long key);
 int ndctl_dimm_wait_overwrite(struct ndctl_dimm *dimm);
 int ndctl_dimm_update_master_passphrase(struct ndctl_dimm *dimm,
 		long ckey, long nkey);
+int ndctl_dimm_master_secure_erase(struct ndctl_dimm *dimm, long key);
 
 enum ndctl_key_type {
 	ND_USER_KEY,
@@ -726,7 +727,8 @@ int ndctl_dimm_enable_key(struct ndctl_dimm *dimm,
 int ndctl_dimm_update_key(struct ndctl_dimm *dimm,
 		enum ndctl_key_type key_type);
 int ndctl_dimm_remove_key(struct ndctl_dimm *dimm);
-int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm);
+int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm,
+		enum ndctl_key_type key_type);
 int ndctl_dimm_overwrite_key(struct ndctl_dimm *dimm);
 #else
 static inline int ndctl_dimm_enable_key(struct ndctl_dimm *dimm,
@@ -746,7 +748,8 @@ static inline int ndctl_dimm_remove_key(struct ndctl_dimm *dimm)
 	return -EOPNOTSUPP;
 }
 
-static inline int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm)
+static inline int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm,
+		enum ndctl_key_type key_type)
 {
 	return -EOPNOTSUPP;
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
