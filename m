Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 51E5C211B81A5
 for <linux-nvdimm@lists.01.org>; Thu, 24 Jan 2019 15:07:55 -0800 (PST)
Subject: [PATCH v10 08/12] ndctl: add overwrite operation support
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 24 Jan 2019 16:07:48 -0700
Message-ID: <154837126880.37086.14119056413058289612.stgit@djiang5-desk3.ch.intel.com>
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

Add support for overwrite to libndctl. The operation will be triggered
by the sanitize-dimm command with -o switch. This will initiate the request
to wipe the entire nvdimm. Success return of the command only indicate
overwrite has started and does not indicate completion of overwrite.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ndctl/ndctl-sanitize-dimm.txt |   26 +++++++++++----
 ndctl/dimm.c                                |   46 +++++++++++++++++++++++----
 ndctl/lib/dimm.c                            |    8 +++++
 ndctl/lib/libndctl.sym                      |    1 +
 ndctl/libndctl.h                            |    1 +
 ndctl/util/keys.c                           |   33 ++++++++++++++++---
 ndctl/util/keys.h                           |    6 ++++
 7 files changed, 101 insertions(+), 20 deletions(-)

diff --git a/Documentation/ndctl/ndctl-sanitize-dimm.txt b/Documentation/ndctl/ndctl-sanitize-dimm.txt
index 633498ef..b0b1ae21 100644
--- a/Documentation/ndctl/ndctl-sanitize-dimm.txt
+++ b/Documentation/ndctl/ndctl-sanitize-dimm.txt
@@ -5,7 +5,7 @@ ndctl-sanitize-dimm(1)
 
 NAME
 ----
-ndctl-sanitize-dimm - Perform a cryptographic destruction of the contents of the given NVDIMM(s).
+ndctl-sanitize-dimm - Perform a cryptographic destruction or overwrite of the contents of the given NVDIMM(s).
 
 SYNOPSIS
 --------
@@ -14,19 +14,29 @@ SYNOPSIS
 
 DESCRIPTION
 -----------
-Search the user key ring for the associated NVDIMM. If not found,
-attempt to load the key blob from the default location. The sanitize
-operation scrambles the data and info-blocks, but it does not touch
-the namespace labels. The user should expect namespaces to revert to raw mode
-after the region is next enabled following the operation. Security is disabled
-for the dimm after operation and ndctl will remove the key from the key ring
-and delete the associated key blob file.
+Two different sanitize methods are supported. One is the crypto-erase, which
+is the default method, and the other is overwrite the NVDIMM. ndctl will
+search the user key ring for the associated NVDIMM. If not found,
+attempt to load the key blob from the default location.
+Security is disabled for the dimm after operation and ndctl will remove
+the key from the key ring and delete the associated key blob file.
 
 OPTIONS
 -------
 <dimm>::
 include::xable-dimm-options.txt[]
 
+-c::
+--crypto-erase::
+	Replace the media encryption key causing all existing data to read as
+	cipher text with the new key. This does not change label data.
+	The user should expect namespaces to revert to raw mode
+	after the region is next enabled following the operation.
+
+-o::
+--ovewrite::
+	Wipe the entire DIMM, including label data. Can take significant time.
+
 include::../copyright.txt[]
 
 SEE ALSO
diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index e7872f52..da940843 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -47,6 +47,8 @@ static struct parameters {
 	const char *infile;
 	const char *labelversion;
 	const char *kek;
+	bool crypto_erase;
+	bool overwrite;
 	bool force;
 	bool json;
 	bool verbose;
@@ -906,9 +908,26 @@ static int action_sanitize_dimm(struct ndctl_dimm *dimm,
 		return -EOPNOTSUPP;
 	}
 
-	rc = ndctl_dimm_secure_erase_key(dimm);
-	if (rc < 0)
-		return rc;
+	/*
+	 * Setting crypto erase to be default. The other method will be
+	 * overwrite.
+	 */
+	if (!param.crypto_erase && !param.overwrite) {
+		param.crypto_erase = true;
+		printf("No santize method passed in, default to crypto-erase\n");
+	}
+
+	if (param.crypto_erase) {
+		rc = ndctl_dimm_secure_erase_key(dimm);
+		if (rc < 0)
+			return rc;
+	}
+
+	if (param.overwrite) {
+		rc = ndctl_dimm_overwrite_key(dimm);
+		if (rc < 0)
+			return rc;
+	}
 
 	return 0;
 }
@@ -1006,6 +1025,12 @@ OPT_STRING('V', "label-version", &param.labelversion, "version-number", \
 OPT_STRING('k', "key-handle", &param.kek, "key-handle", \
 		"master encryption key handle")
 
+#define SANITIZE_OPTIONS() \
+OPT_BOOLEAN('c', "crypto-erase", &param.crypto_erase, \
+		"crypto erase a dimm"), \
+OPT_BOOLEAN('o', "overwrite", &param.overwrite, \
+		"overwrite a dimm")
+
 static const struct option read_options[] = {
 	BASE_OPTIONS(),
 	READ_OPTIONS(),
@@ -1038,6 +1063,11 @@ static const struct option init_options[] = {
 static const struct option key_options[] = {
 	BASE_OPTIONS(),
 	KEY_OPTIONS(),
+};
+
+static const struct option sanitize_options[] = {
+	BASE_OPTIONS(),
+	SANITIZE_OPTIONS(),
 	OPT_END(),
 };
 
@@ -1315,10 +1345,14 @@ int cmd_freeze_security(int argc, const char **argv, void *ctx)
 int cmd_sanitize_dimm(int argc, const char **argv, void *ctx)
 {
 	int count = dimm_action(argc, argv, ctx, action_sanitize_dimm,
-			base_options,
+			sanitize_options,
 			"ndctl sanitize-dimm <nmem0> [<nmem1>..<nmemN>] [<options>]");
 
-	fprintf(stderr, "sanitized %d nmem%s.\n", count >= 0 ? count : 0,
-			count > 1 ? "s" : "");
+	if (param.overwrite)
+		fprintf(stderr, "overwrite issued for %d nmem%s.\n",
+				count >= 0 ? count : 0, count > 1 ? "s" : "");
+	else
+		fprintf(stderr, "sanitized %d nmem%s.\n",
+				count >= 0 ? count : 0, count > 1 ? "s" : "");
 	return count >= 0 ? 0 : EXIT_FAILURE;
 }
diff --git a/ndctl/lib/dimm.c b/ndctl/lib/dimm.c
index 50650738..d7b70ebf 100644
--- a/ndctl/lib/dimm.c
+++ b/ndctl/lib/dimm.c
@@ -677,3 +677,11 @@ NDCTL_EXPORT int ndctl_dimm_secure_erase(struct ndctl_dimm *dimm, long key)
 	sprintf(buf, "erase %ld\n", key);
 	return write_security(dimm, buf);
 }
+
+NDCTL_EXPORT int ndctl_dimm_overwrite(struct ndctl_dimm *dimm, long key)
+{
+	char buf[SYSFS_ATTR_SIZE];
+
+	sprintf(buf, "overwrite %ld\n", key);
+	return write_security(dimm, buf);
+}
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index dd2dc747..732c621e 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -395,4 +395,5 @@ global:
 	ndctl_dimm_disable_passphrase;
 	ndctl_dimm_freeze_security;
 	ndctl_dimm_secure_erase;
+	ndctl_dimm_overwrite;
 } LIBNDCTL_18;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 83e52b76..b191ad4a 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -703,6 +703,7 @@ int ndctl_dimm_update_passphrase(struct ndctl_dimm *dimm,
 int ndctl_dimm_disable_passphrase(struct ndctl_dimm *dimm, long key);
 int ndctl_dimm_freeze_security(struct ndctl_dimm *dimm);
 int ndctl_dimm_secure_erase(struct ndctl_dimm *dimm, long key);
+int ndctl_dimm_overwrite(struct ndctl_dimm *dimm, long key);
 
 #define ND_KEY_DESC_SIZE	128
 #define ND_KEY_CMD_SIZE		128
diff --git a/ndctl/util/keys.c b/ndctl/util/keys.c
index 6f3d0830..2f0d8861 100644
--- a/ndctl/util/keys.c
+++ b/ndctl/util/keys.c
@@ -480,19 +480,19 @@ int ndctl_dimm_update_key(struct ndctl_dimm *dimm, const char *kek)
 	return 0;
 }
 
-static key_serial_t check_dimm_key(struct ndctl_dimm *dimm)
+static key_serial_t check_dimm_key(struct ndctl_dimm *dimm, bool need_key)
 {
 	key_serial_t key;
 
 	key = dimm_check_key(dimm, false);
 	if (key < 0) {
 		key = dimm_load_key(dimm, false);
-		if (key < 0) {
+		if (key < 0 && need_key) {
 			fprintf(stderr, "Unable to load key\n");
 			return -ENOKEY;
-		}
+		} else
+			key = 0;
 	}
-
 	return key;
 }
 
@@ -521,6 +521,7 @@ static int discard_key(struct ndctl_dimm *dimm)
 		fprintf(stderr, "Unable to cleanup key.\n");
 		return rc;
 	}
+
 	return 0;
 }
 
@@ -529,7 +530,7 @@ int ndctl_dimm_remove_key(struct ndctl_dimm *dimm)
 	key_serial_t key;
 	int rc;
 
-	key = check_dimm_key(dimm);
+	key = check_dimm_key(dimm, true);
 	if (key < 0)
 		return key;
 
@@ -546,7 +547,7 @@ int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm)
 	key_serial_t key;
 	int rc;
 
-	key = check_dimm_key(dimm);
+	key = check_dimm_key(dimm, true);
 	if (key < 0)
 		return key;
 
@@ -557,3 +558,23 @@ int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm)
 
 	return discard_key(dimm);
 }
+
+int ndctl_dimm_overwrite_key(struct ndctl_dimm *dimm)
+{
+	key_serial_t key;
+	int rc;
+
+	key = check_dimm_key(dimm, false);
+	if (key < 0)
+		return key;
+
+	rc = run_key_op(dimm, key, ndctl_dimm_overwrite,
+			"overwrite");
+	if (rc < 0)
+		return rc;
+
+	if (key > 0)
+		return discard_key(dimm);
+
+	return 0;
+}
diff --git a/ndctl/util/keys.h b/ndctl/util/keys.h
index 86bd2270..bdb9d6d7 100644
--- a/ndctl/util/keys.h
+++ b/ndctl/util/keys.h
@@ -16,6 +16,7 @@ int ndctl_dimm_setup_key(struct ndctl_dimm *dimm, const char *kek);
 int ndctl_dimm_update_key(struct ndctl_dimm *dimm, const char *kek);
 int ndctl_dimm_remove_key(struct ndctl_dimm *dimm);
 int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm);
+int ndctl_dimm_overwrite_key(struct ndctl_dimm *dimm);
 #else
 char *ndctl_load_key_blob(const char *path, int *size, const char *postfix,
 		int dirfd)
@@ -43,6 +44,11 @@ static inline int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm)
 {
 	return -EOPNOTSUPP;
 }
+
+static inline int ndctl_dimm_overwrite_key(struct ndctl_dimm *dimm)
+{
+	return -EOPNOTSUPP;
+}
 #endif /* ENABLE_KEYUTILS */
 
 #endif

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
