Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6959C211A4593
 for <linux-nvdimm@lists.01.org>; Fri, 14 Dec 2018 13:09:47 -0800 (PST)
Subject: [PATCH v6 08/12] ndctl: add overwrite operation support
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 14 Dec 2018 14:09:46 -0700
Message-ID: <154482178670.65434.16971982916281125854.stgit@djiang5-desk3.ch.intel.com>
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

Add support for overwrite to libndctl. The operation will be triggered
by the sanitize-dimm command with -o switch. This will initiate the request
to wipe the entire nvdimm. Success return of the command only indicate
overwrite has started and does not indicate completion of overwrite.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ndctl/ndctl-sanitize-dimm.txt |    4 ++++
 ndctl/dimm.c                                |   21 ++++++++++++++++----
 ndctl/lib/dimm.c                            |    8 ++++++++
 ndctl/lib/keys.c                            |   28 ++++++++++++++++-----------
 ndctl/lib/libndctl.sym                      |    2 ++
 ndctl/libndctl.h                            |    7 +++++++
 6 files changed, 55 insertions(+), 15 deletions(-)

diff --git a/Documentation/ndctl/ndctl-sanitize-dimm.txt b/Documentation/ndctl/ndctl-sanitize-dimm.txt
index a6802d30..beb4b2f9 100644
--- a/Documentation/ndctl/ndctl-sanitize-dimm.txt
+++ b/Documentation/ndctl/ndctl-sanitize-dimm.txt
@@ -29,4 +29,8 @@ include::xable-dimm-options.txt[]
 	Replaces encryption keys and securely erases the data. This does not
 	change label data. This is the default sanitize method.
 
+-o::
+--ovewrite::
+	Wipe the entire DIMM, including label data. Can take significant time.
+
 include::../copyright.txt[]
diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index ae674f78..6b1ee47f 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -47,6 +47,7 @@ static struct parameters {
 	const char *labelversion;
 	const char *master_key;
 	bool crypto_erase;
+	bool overwrite;
 	bool force;
 	bool json;
 	bool verbose;
@@ -907,7 +908,7 @@ static int action_sanitize_dimm(struct ndctl_dimm *dimm,
 	 * Setting crypto erase to be default. The other method will be
 	 * overwrite.
 	 */
-	if (!param.crypto_erase) {
+	if (!param.crypto_erase && !param.overwrite) {
 		param.crypto_erase = true;
 		printf("No santize method passed in, default to crypto-erase\n");
 	}
@@ -918,6 +919,12 @@ static int action_sanitize_dimm(struct ndctl_dimm *dimm,
 			return rc;
 	}
 
+	if (param.overwrite) {
+		rc = ndctl_dimm_overwrite_key(dimm);
+		if (rc < 0)
+			return rc;
+	}
+
 	return 0;
 }
 
@@ -1016,7 +1023,9 @@ OPT_STRING('m', "master-key", &param.master_key, "<key_type>:<key_name>", \
 
 #define SANITIZE_OPTIONS() \
 OPT_BOOLEAN('c', "crypto-erase", &param.crypto_erase, \
-		"crypto erase a dimm")
+		"crypto erase a dimm"), \
+OPT_BOOLEAN('o', "overwrite", &param.overwrite, \
+		"overwrite a dimm")
 
 static const struct option read_options[] = {
 	BASE_OPTIONS(),
@@ -1342,7 +1351,11 @@ int cmd_sanitize_dimm(int argc, const char **argv, void *ctx)
 			sanitize_options,
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
index 6da29c1e..2dff80f0 100644
--- a/ndctl/lib/dimm.c
+++ b/ndctl/lib/dimm.c
@@ -681,3 +681,11 @@ NDCTL_EXPORT int ndctl_dimm_secure_erase(struct ndctl_dimm *dimm, long key)
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
index 130c29ed..fcf300bb 100644
--- a/ndctl/lib/keys.c
+++ b/ndctl/lib/keys.c
@@ -85,10 +85,9 @@ static char *load_key_blob(struct ndctl_ctx *ctx, const char *path, int *size)
 	char prefix[] = "load ";
 
 	rc = stat(path, &st);
-	if (rc < 0) {
-		err(ctx, "stat: %s\n", strerror(errno));
+	if (rc < 0)
 		return NULL;
-	}
+
 	if ((st.st_mode & S_IFMT) != S_IFREG) {
 		err(ctx, "%s not a regular file\n", path);
 		return NULL;
@@ -324,10 +323,8 @@ static int dimm_remove_key(struct ndctl_dimm *dimm,
 	}
 
 	rc = unlink(path);
-	if (rc < 0) {
-		err(ctx, "unlink: %s\n", strerror(errno));
+	if (rc < 0)
 		return -errno;
-	}
 
 	return 0;
 }
@@ -398,10 +395,11 @@ static int check_key_run_and_discard(struct ndctl_dimm *dimm,
 	key = dimm_check_key(dimm, false);
 	if (key < 0) {
 		key = dimm_load_key(dimm, false);
-		if (key < 0) {
+		if (key < 0 && run_op != ndctl_dimm_overwrite) {
 			err(ctx, "Unable to load key\n");
 			return -ENOKEY;
-		}
+		} else
+			key = 0;
 	}
 
 	rc = run_op(dimm, key);
@@ -411,9 +409,11 @@ static int check_key_run_and_discard(struct ndctl_dimm *dimm,
 		return rc;
 	}
 
-	rc = dimm_remove_key(dimm, false);
-	if (rc < 0)
-		err(ctx, "Unable to cleanup key.\n");
+	if (key) {
+		rc = dimm_remove_key(dimm, false);
+		if (rc < 0)
+			err(ctx, "Unable to cleanup key.\n");
+	}
 	return 0;
 }
 
@@ -428,3 +428,9 @@ NDCTL_EXPORT int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm)
 	return check_key_run_and_discard(dimm, ndctl_dimm_secure_erase,
 			"crypto erase");
 }
+
+NDCTL_EXPORT int ndctl_dimm_overwrite_key(struct ndctl_dimm *dimm)
+{
+	return check_key_run_and_discard(dimm, ndctl_dimm_overwrite,
+			"overwrite");
+}
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 0e3aa5d9..0fedae1a 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -398,4 +398,6 @@ global:
 	ndctl_dimm_freeze_security;
 	ndctl_dimm_secure_erase;
 	ndctl_dimm_secure_erase_key;
+	ndctl_dimm_overwrite;
+	ndctl_dimm_overwrite_key;
 } LIBNDCTL_18;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 19053a20..fee35db7 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -705,6 +705,7 @@ int ndctl_dimm_update_passphrase(struct ndctl_dimm *dimm,
 int ndctl_dimm_disable_passphrase(struct ndctl_dimm *dimm, long key);
 int ndctl_dimm_freeze_security(struct ndctl_dimm *dimm);
 int ndctl_dimm_secure_erase(struct ndctl_dimm *dimm, long key);
+int ndctl_dimm_overwrite(struct ndctl_dimm *dimm, long key);
 
 enum ndctl_key_type {
 	ND_USER_KEY,
@@ -716,6 +717,7 @@ int ndctl_dimm_enable_key(struct ndctl_dimm *dimm, const char *master);
 int ndctl_dimm_update_key(struct ndctl_dimm *dimm, const char *master);
 int ndctl_dimm_disable_key(struct ndctl_dimm *dimm);
 int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm);
+int ndctl_dimm_overwrite_key(struct ndctl_dimm *dimm);
 #else
 static inline int ndctl_dimm_enable_key(struct ndctl_dimm *dimm,
 		const char *master)
@@ -738,6 +740,11 @@ static inline int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm)
 {
 	return -EOPNOTSUPP;
 }
+
+int ndctl_dimm_overwrite_key(struct ndctl_dimm *dimm)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 #ifdef __cplusplus

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
