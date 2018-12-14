Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D53FF211A45B3
 for <linux-nvdimm@lists.01.org>; Fri, 14 Dec 2018 13:10:03 -0800 (PST)
Subject: [PATCH v6 11/12] ndctl: add master secure erase support
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 14 Dec 2018 14:10:03 -0700
Message-ID: <154482180308.65434.10384388976757339791.stgit@djiang5-desk3.ch.intel.com>
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

Intel DSM v1.8 introduced the concept of master passphrase and allowing
nvdimm to be secure erased via the master passphrase in addition to the
user passphrase. Add ndctl support to provide master passphrase secure
erase.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ndctl/ndctl-sanitize-dimm.txt |    6 +++++
 ndctl/dimm.c                                |   14 +++++++++++--
 ndctl/lib/dimm.c                            |    9 ++++++++
 ndctl/lib/keys.c                            |   30 ++++++++++++++++++++-------
 ndctl/lib/libndctl.sym                      |    1 +
 ndctl/libndctl.h                            |    7 +++++-
 6 files changed, 55 insertions(+), 12 deletions(-)

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
index c60ef96e..b2d50e28 100644
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
@@ -917,7 +923,9 @@ static int action_sanitize_dimm(struct ndctl_dimm *dimm,
 	}
 
 	if (param.crypto_erase) {
-		rc = ndctl_dimm_secure_erase_key(dimm);
+		rc = ndctl_dimm_secure_erase_key(dimm,
+				param.master_pass ?
+				ND_MASTER_KEY : ND_USER_KEY);
 		if (rc < 0)
 			return rc;
 	}
@@ -1048,7 +1056,9 @@ OPT_BOOLEAN('M', "master-passphrase", &param.master_pass, \
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
index 1d395b48..51532c7a 100644
--- a/ndctl/lib/keys.c
+++ b/ndctl/lib/keys.c
@@ -437,13 +437,14 @@ NDCTL_EXPORT int ndctl_dimm_update_key(struct ndctl_dimm *dimm,
 }
 
 static int check_key_run_and_discard(struct ndctl_dimm *dimm,
-		int (*run_op)(struct ndctl_dimm *, long), const char *name)
+		int (*run_op)(struct ndctl_dimm *, long), const char *name,
+		enum ndctl_key_type key_type)
 {
 	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
 	key_serial_t key;
 	int rc;
 
-	key = dimm_check_key(dimm, ND_USER_KEY);
+	key = dimm_check_key(dimm, key_type);
 	if (key < 0) {
 		key = dimm_load_key(dimm, ND_USER_KEY);
 		if (key < 0 && run_op != ndctl_dimm_overwrite) {
@@ -460,8 +461,12 @@ static int check_key_run_and_discard(struct ndctl_dimm *dimm,
 		return rc;
 	}
 
+	/* we do not delete the key if master secure erase */
+	if (key_type == ND_MASTER_KEY)
+		return 0;
+
 	if (key) {
-		rc = dimm_remove_key(dimm, ND_USER_KEY);
+		rc = dimm_remove_key(dimm, key_type);
 		if (rc < 0)
 			err(ctx, "Unable to cleanup key.\n");
 	}
@@ -471,17 +476,26 @@ static int check_key_run_and_discard(struct ndctl_dimm *dimm,
 NDCTL_EXPORT int ndctl_dimm_disable_key(struct ndctl_dimm *dimm)
 {
 	return check_key_run_and_discard(dimm, ndctl_dimm_disable_passphrase,
-			"disable passphrase");
+			"disable passphrase", ND_USER_KEY);
 }
 
-NDCTL_EXPORT int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm)
+NDCTL_EXPORT int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm,
+		enum ndctl_key_type key_type)
 {
-	return check_key_run_and_discard(dimm, ndctl_dimm_secure_erase,
-			"crypto erase");
+	if (key_type == ND_MASTER_KEY)
+		return check_key_run_and_discard(dimm,
+				ndctl_dimm_master_secure_erase,
+				"master crypto erase", key_type);
+	else if (key_type == ND_USER_KEY)
+		return check_key_run_and_discard(dimm,
+				ndctl_dimm_secure_erase,
+				"crypto erase", key_type);
+	else
+		return -EINVAL;
 }
 
 NDCTL_EXPORT int ndctl_dimm_overwrite_key(struct ndctl_dimm *dimm)
 {
 	return check_key_run_and_discard(dimm, ndctl_dimm_overwrite,
-			"overwrite");
+			"overwrite", ND_USER_KEY);
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
index a0b8a886..9b9fd34c 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -709,6 +709,7 @@ int ndctl_dimm_overwrite(struct ndctl_dimm *dimm, long key);
 int ndctl_dimm_wait_for_overwrite_completion(struct ndctl_dimm *dimm);
 int ndctl_dimm_update_master_passphrase(struct ndctl_dimm *dimm,
 		long ckey, long nkey);
+int ndctl_dimm_master_secure_erase(struct ndctl_dimm *dimm, long key);
 
 enum ndctl_key_type {
 	ND_USER_KEY,
@@ -723,7 +724,8 @@ int ndctl_dimm_enable_key(struct ndctl_dimm *dimm, const char *master_key,
 int ndctl_dimm_update_key(struct ndctl_dimm *dimm, const char *master_key,
 		enum ndctl_key_type key_type);
 int ndctl_dimm_disable_key(struct ndctl_dimm *dimm);
-int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm);
+int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm,
+		enum ndctl_key_type key_type);
 int ndctl_dimm_overwrite_key(struct ndctl_dimm *dimm);
 #else
 static inline int ndctl_dimm_enable_key(struct ndctl_dimm *dimm,
@@ -743,7 +745,8 @@ static inline int ndctl_dimm_disable_key(struct ndctl_dimm *dimm)
 	return -EOPNOTSUPP;
 }
 
-static inline int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm)
+static inline int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm,
+		enum ndctl_key_type key_type);
 {
 	return -EOPNOTSUPP;
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
