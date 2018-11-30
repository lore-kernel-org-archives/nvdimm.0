Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 102D52119623A
 for <linux-nvdimm@lists.01.org>; Fri, 30 Nov 2018 13:34:26 -0800 (PST)
Subject: [PATCH v5 11/12] ndctl: add master secure erase support
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 30 Nov 2018 14:34:25 -0700
Message-ID: <154361366517.6129.1019159774163455445.stgit@djiang5-desk3.ch.intel.com>
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

Intel DSM v1.8 introduced the concept of master passphrase and allowing
nvdimm to be secure erased via the master passphrase in addition to the
user passphrase. Add ndctl support to provide master passphrase secure
erase.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ndctl/ndctl-sanitize-dimm.txt |    6 ++++++
 ndctl/dimm.c                                |   12 ++++++++++--
 ndctl/lib/dimm.c                            |    9 +++++++++
 ndctl/lib/keys.c                            |   24 ++++++++++++++++--------
 ndctl/lib/libndctl.sym                      |    1 +
 ndctl/libndctl.h                            |    3 ++-
 6 files changed, 44 insertions(+), 11 deletions(-)

diff --git a/Documentation/ndctl/ndctl-sanitize-dimm.txt b/Documentation/ndctl/ndctl-sanitize-dimm.txt
index beb4b2f9..7b036318 100644
--- a/Documentation/ndctl/ndctl-sanitize-dimm.txt
+++ b/Documentation/ndctl/ndctl-sanitize-dimm.txt
@@ -33,4 +33,10 @@ include::xable-dimm-options.txt[]
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
index f487cf81..a78f0e92 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -907,6 +907,12 @@ static int action_sanitize_dimm(struct ndctl_dimm *dimm,
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
@@ -917,7 +923,7 @@ static int action_sanitize_dimm(struct ndctl_dimm *dimm,
 	}
 
 	if (param.crypto_erase) {
-		rc = ndctl_dimm_secure_erase_key(dimm);
+		rc = ndctl_dimm_secure_erase_key(dimm, param.master_pass);
 		if (rc < 0)
 			return rc;
 	}
@@ -1048,7 +1054,9 @@ OPT_BOOLEAN('M', "master-passphrase", &param.master_pass, \
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
index 07513b4b..a8013e4b 100644
--- a/ndctl/lib/dimm.c
+++ b/ndctl/lib/dimm.c
@@ -777,3 +777,12 @@ NDCTL_EXPORT int ndctl_dimm_update_master_passphrase(struct ndctl_dimm *dimm,
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
index e112609b..03b94be7 100644
--- a/ndctl/lib/keys.c
+++ b/ndctl/lib/keys.c
@@ -417,13 +417,14 @@ NDCTL_EXPORT int ndctl_dimm_update_key(struct ndctl_dimm *dimm,
 }
 
 static int check_key_run_and_discard(struct ndctl_dimm *dimm,
-		int (*run_op)(struct ndctl_dimm *, long), const char *name)
+		int (*run_op)(struct ndctl_dimm *, long), const char *name,
+		bool master)
 {
 	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
 	key_serial_t key;
 	int rc;
 
-	key = dimm_check_key(dimm, false, false);
+	key = dimm_check_key(dimm, false, master);
 	if (key < 0) {
 		key = dimm_load_key(dimm, false, false);
 		if (key < 0) {
@@ -439,7 +440,7 @@ static int check_key_run_and_discard(struct ndctl_dimm *dimm,
 		return rc;
 	}
 
-	rc = dimm_remove_key(dimm, false, false);
+	rc = dimm_remove_key(dimm, false, master);
 	if (rc < 0)
 		err(ctx, "Unable to cleanup key.\n");
 	return 0;
@@ -448,17 +449,24 @@ static int check_key_run_and_discard(struct ndctl_dimm *dimm,
 NDCTL_EXPORT int ndctl_dimm_disable_key(struct ndctl_dimm *dimm)
 {
 	return check_key_run_and_discard(dimm, ndctl_dimm_disable_passphrase,
-			"disable passphrase");
+			"disable passphrase", false);
 }
 
-NDCTL_EXPORT int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm)
+NDCTL_EXPORT int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm,
+		bool master)
 {
-	return check_key_run_and_discard(dimm, ndctl_dimm_secure_erase,
-			"crypto erase");
+	if (master)
+		return check_key_run_and_discard(dimm,
+				ndctl_dimm_master_secure_erase,
+				"master crypto erase", master);
+	else
+		return check_key_run_and_discard(dimm,
+				ndctl_dimm_secure_erase,
+				"crypto erase", master);
 }
 
 NDCTL_EXPORT int ndctl_dimm_overwrite_key(struct ndctl_dimm *dimm)
 {
 	return check_key_run_and_discard(dimm, ndctl_dimm_overwrite,
-			"overwrite");
+			"overwrite", false);
 }
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index bd933eb2..f51f82fe 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -402,4 +402,5 @@ global:
 	ndctl_dimm_overwrite_key;
 	ndctl_dimm_wait_for_overwrite_completion;
 	ndctl_dimm_update_master_passphrase;
+	ndctl_dimm_master_secure_erase;
 } LIBNDCTL_18;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index d07fbfc9..eb654d2b 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -709,6 +709,7 @@ int ndctl_dimm_overwrite(struct ndctl_dimm *dimm, long key);
 int ndctl_dimm_wait_for_overwrite_completion(struct ndctl_dimm *dimm);
 int ndctl_dimm_update_master_passphrase(struct ndctl_dimm *dimm,
 		long ckey, long nkey);
+int ndctl_dimm_master_secure_erase(struct ndctl_dimm *dimm, long key);
 
 #ifdef ENABLE_KEYUTILS
 int ndctl_dimm_enable_key(struct ndctl_dimm *dimm, const char *master_key,
@@ -716,7 +717,7 @@ int ndctl_dimm_enable_key(struct ndctl_dimm *dimm, const char *master_key,
 int ndctl_dimm_update_key(struct ndctl_dimm *dimm, const char *master_key,
 		bool master);
 int ndctl_dimm_disable_key(struct ndctl_dimm *dimm);
-int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm);
+int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm, bool master);
 int ndctl_dimm_overwrite_key(struct ndctl_dimm *dimm);
 #else
 static inline int ndctl_dimm_enable_key(struct ndctl_dimm *dimm,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
