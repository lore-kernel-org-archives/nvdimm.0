Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 67E47211B509C
 for <linux-nvdimm@lists.01.org>; Thu, 17 Jan 2019 18:39:11 -0800 (PST)
Subject: [PATCH v9 09/13] ndctl: add overwrite operation support
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 17 Jan 2019 19:39:10 -0700
Message-ID: <154777915082.42557.5558251214267362338.stgit@djiang5-desk3.ch.intel.com>
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

Add support for overwrite to libndctl. The operation will be triggered
by the sanitize-dimm command with -o switch. This will initiate the request
to wipe the entire nvdimm. Success return of the command only indicate
overwrite has started and does not indicate completion of overwrite.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ndctl/ndctl-sanitize-dimm.txt |   12 ++++++-
 ndctl/dimm.c                                |   47 ++++++++++++++++++++++++---
 ndctl/lib/dimm.c                            |    8 +++++
 ndctl/lib/keys.c                            |   33 ++++++++++++++++---
 ndctl/lib/libndctl.sym                      |    2 +
 ndctl/libndctl.h                            |    7 ++++
 6 files changed, 97 insertions(+), 12 deletions(-)

diff --git a/Documentation/ndctl/ndctl-sanitize-dimm.txt b/Documentation/ndctl/ndctl-sanitize-dimm.txt
index f95be28f..158392bf 100644
--- a/Documentation/ndctl/ndctl-sanitize-dimm.txt
+++ b/Documentation/ndctl/ndctl-sanitize-dimm.txt
@@ -5,7 +5,7 @@ ndctl-sanitize-dimm(1)
 
 NAME
 ----
-ndctl-sanitize-dimm - Perform a cryptographic destruction of the contents of the given NVDIMM(s).
+ndctl-sanitize-dimm - Perform a cryptographic destruction or overwrite of the contents of the given NVDIMM(s).
 
 SYNOPSIS
 --------
@@ -23,6 +23,16 @@ OPTIONS
 <dimm>::
 include::xable-dimm-options.txt[]
 
+-c::
+--crypto-erase::
+	Replace the media encryption key causing all existing data to read as
+	cipher text with the new key.  This does not
+	change label data. This is the default sanitize method.
+
+-o::
+--ovewrite::
+	Wipe the entire DIMM, including label data. Can take significant time.
+
 include::../copyright.txt[]
 
 SEE ALSO
diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index c346b7fb..2b259a4f 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -45,6 +45,8 @@ static struct parameters {
 	const char *outfile;
 	const char *infile;
 	const char *labelversion;
+	bool crypto_erase;
+	bool overwrite;
 	bool force;
 	bool json;
 	bool verbose;
@@ -901,9 +903,26 @@ static int action_sanitize_dimm(struct ndctl_dimm *dimm,
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
@@ -997,6 +1016,12 @@ OPT_BOOLEAN('f', "force", &param.force, \
 OPT_STRING('V', "label-version", &param.labelversion, "version-number", \
 	"namespace label specification version (default: 1.1)")
 
+#define SANITIZE_OPTIONS() \
+OPT_BOOLEAN('c', "crypto-erase", &param.crypto_erase, \
+		"crypto erase a dimm"), \
+OPT_BOOLEAN('o', "overwrite", &param.overwrite, \
+		"overwrite a dimm")
+
 static const struct option read_options[] = {
 	BASE_OPTIONS(),
 	READ_OPTIONS(),
@@ -1026,6 +1051,12 @@ static const struct option init_options[] = {
 	OPT_END(),
 };
 
+static const struct option sanitize_options[] = {
+	BASE_OPTIONS(),
+	SANITIZE_OPTIONS(),
+	OPT_END(),
+};
+
 static int dimm_action(int argc, const char **argv, struct ndctl_ctx *ctx,
 		int (*action)(struct ndctl_dimm *dimm, struct action_context *actx),
 		const struct option *options, const char *usage)
@@ -1300,10 +1331,14 @@ int cmd_freeze_security(int argc, const char **argv, void *ctx)
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
diff --git a/ndctl/lib/keys.c b/ndctl/lib/keys.c
index 2fb2c305..50784284 100644
--- a/ndctl/lib/keys.c
+++ b/ndctl/lib/keys.c
@@ -93,6 +93,7 @@ NDCTL_EXPORT char *ndctl_load_key_blob(struct ndctl_ctx *ctx,
 		err(ctx, "stat: %s\n", strerror(errno));
 		return NULL;
 	}
+
 	if ((st.st_mode & S_IFMT) != S_IFREG) {
 		err(ctx, "%s not a regular file\n", path);
 		return NULL;
@@ -407,7 +408,7 @@ NDCTL_EXPORT int ndctl_dimm_update_key(struct ndctl_dimm *dimm)
 	return 0;
 }
 
-static key_serial_t check_dimm_key(struct ndctl_dimm *dimm)
+static key_serial_t check_dimm_key(struct ndctl_dimm *dimm, bool need_key)
 {
 	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
 	key_serial_t key;
@@ -415,10 +416,11 @@ static key_serial_t check_dimm_key(struct ndctl_dimm *dimm)
 	key = dimm_check_key(dimm, false);
 	if (key < 0) {
 		key = dimm_load_key(dimm, false);
-		if (key < 0) {
+		if (key < 0 && need_key) {
 			err(ctx, "Unable to load key\n");
 			return -ENOKEY;
-		}
+		} else
+			key = 0;
 	}
 
 	return key;
@@ -451,6 +453,7 @@ static int discard_key(struct ndctl_dimm *dimm)
 		err(ctx, "Unable to cleanup key.\n");
 		return rc;
 	}
+
 	return 0;
 }
 
@@ -459,7 +462,7 @@ NDCTL_EXPORT int ndctl_dimm_remove_key(struct ndctl_dimm *dimm)
 	key_serial_t key;
 	int rc;
 
-	key = check_dimm_key(dimm);
+	key = check_dimm_key(dimm, true);
 	if (key < 0)
 		return key;
 
@@ -476,7 +479,7 @@ NDCTL_EXPORT int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm)
 	key_serial_t key;
 	int rc;
 
-	key = check_dimm_key(dimm);
+	key = check_dimm_key(dimm, true);
 	if (key < 0)
 		return key;
 
@@ -487,3 +490,23 @@ NDCTL_EXPORT int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm)
 
 	return discard_key(dimm);
 }
+
+NDCTL_EXPORT int ndctl_dimm_overwrite_key(struct ndctl_dimm *dimm)
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
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 238c2e1c..130bf889 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -401,4 +401,6 @@ global:
 	ndctl_dimm_freeze_security;
 	ndctl_dimm_secure_erase;
 	ndctl_dimm_secure_erase_key;
+	ndctl_dimm_overwrite;
+	ndctl_dimm_overwrite_key;
 } LIBNDCTL_18;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 83cce8c4..5826cbfb 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -708,6 +708,7 @@ int ndctl_dimm_update_passphrase(struct ndctl_dimm *dimm,
 int ndctl_dimm_disable_passphrase(struct ndctl_dimm *dimm, long key);
 int ndctl_dimm_freeze_security(struct ndctl_dimm *dimm);
 int ndctl_dimm_secure_erase(struct ndctl_dimm *dimm, long key);
+int ndctl_dimm_overwrite(struct ndctl_dimm *dimm, long key);
 
 enum ndctl_key_type {
 	ND_USER_KEY,
@@ -719,6 +720,7 @@ int ndctl_dimm_enable_key(struct ndctl_dimm *dimm);
 int ndctl_dimm_update_key(struct ndctl_dimm *dimm);
 int ndctl_dimm_remove_key(struct ndctl_dimm *dimm);
 int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm);
+int ndctl_dimm_overwrite_key(struct ndctl_dimm *dimm);
 #else
 static inline int ndctl_dimm_enable_key(struct ndctl_dimm *dimm)
 {
@@ -739,6 +741,11 @@ static inline int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm)
 {
 	return -EOPNOTSUPP;
 }
+
+static inline int ndctl_dimm_overwrite_key(struct ndctl_dimm *dimm)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 #define ND_KEY_DESC_SIZE	128

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
