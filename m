Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8D61E211B5098
 for <linux-nvdimm@lists.01.org>; Wed,  9 Jan 2019 09:54:36 -0800 (PST)
Subject: [PATCH v7 08/12] ndctl: add overwrite operation support
From: Dave Jiang <dave.jiang@intel.com>
Date: Wed, 09 Jan 2019 10:54:35 -0700
Message-ID: <154705647591.23227.16371557710830841069.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154705633843.23227.15903675663299735878.stgit@djiang5-desk3.ch.intel.com>
References: <154705633843.23227.15903675663299735878.stgit@djiang5-desk3.ch.intel.com>
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
 Documentation/ndctl/ndctl-sanitize-dimm.txt |    4 ++++
 ndctl/dimm.c                                |   21 +++++++++++++++++----
 ndctl/lib/dimm.c                            |    8 ++++++++
 ndctl/lib/keys.c                            |   25 +++++++++++++++++--------
 ndctl/lib/libndctl.sym                      |    2 ++
 ndctl/libndctl.h                            |    8 ++++++++
 6 files changed, 56 insertions(+), 12 deletions(-)

diff --git a/Documentation/ndctl/ndctl-sanitize-dimm.txt b/Documentation/ndctl/ndctl-sanitize-dimm.txt
index a1eab8bc..d37c2a4b 100644
--- a/Documentation/ndctl/ndctl-sanitize-dimm.txt
+++ b/Documentation/ndctl/ndctl-sanitize-dimm.txt
@@ -34,4 +34,8 @@ include::xable-dimm-options.txt[]
 	Replaces encryption keys and securely erases the data. This does not
 	change label data. This is the default sanitize method.
 
+-o::
+--ovewrite::
+	Wipe the entire DIMM, including label data. Can take significant time.
+
 include::../copyright.txt[]
diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index a91b40d5..799823d6 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -48,6 +48,7 @@ static struct parameters {
 	const char *key_path;
 	const char *master_key;
 	bool crypto_erase;
+	bool overwrite;
 	bool force;
 	bool json;
 	bool verbose;
@@ -910,7 +911,7 @@ static int action_sanitize_dimm(struct ndctl_dimm *dimm,
 	 * Setting crypto erase to be default. The other method will be
 	 * overwrite.
 	 */
-	if (!param.crypto_erase) {
+	if (!param.crypto_erase && !param.overwrite) {
 		param.crypto_erase = true;
 		printf("No santize method passed in, default to crypto-erase\n");
 	}
@@ -921,6 +922,12 @@ static int action_sanitize_dimm(struct ndctl_dimm *dimm,
 			return rc;
 	}
 
+	if (param.overwrite) {
+		rc = ndctl_dimm_overwrite_key(dimm, param.key_path);
+		if (rc < 0)
+			return rc;
+	}
+
 	return 0;
 }
 
@@ -1023,7 +1030,9 @@ OPT_STRING('m', "master-key", &param.master_key, "<key_type>:<key_name>", \
 
 #define SANITIZE_OPTIONS() \
 OPT_BOOLEAN('c', "crypto-erase", &param.crypto_erase, \
-		"crypto erase a dimm")
+		"crypto erase a dimm"), \
+OPT_BOOLEAN('o', "overwrite", &param.overwrite, \
+		"overwrite a dimm")
 
 static const struct option read_options[] = {
 	BASE_OPTIONS(),
@@ -1361,7 +1370,11 @@ int cmd_sanitize_dimm(int argc, const char **argv, void *ctx)
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
index 285e09ce..f27b966c 100644
--- a/ndctl/lib/dimm.c
+++ b/ndctl/lib/dimm.c
@@ -685,3 +685,11 @@ NDCTL_EXPORT int ndctl_dimm_secure_erase(struct ndctl_dimm *dimm, long key)
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
index 95abd61a..2eb23d38 100644
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
@@ -404,10 +403,11 @@ static int check_key_run_and_discard(struct ndctl_dimm *dimm,
 	key = dimm_check_key(dimm, false);
 	if (key < 0) {
 		key = dimm_load_key(dimm, false, keypath);
-		if (key < 0) {
+		if (key < 0 && run_op != ndctl_dimm_overwrite) {
 			err(ctx, "Unable to load key\n");
 			return -ENOKEY;
-		}
+		} else
+			key = 0;
 	}
 
 	rc = run_op(dimm, key);
@@ -417,9 +417,11 @@ static int check_key_run_and_discard(struct ndctl_dimm *dimm,
 		return rc;
 	}
 
-	rc = dimm_remove_key(dimm, false, keypath);
-	if (rc < 0)
-		err(ctx, "Unable to cleanup key.\n");
+	if (key) {
+		rc = dimm_remove_key(dimm, false, keypath);
+		if (rc < 0)
+			err(ctx, "Unable to cleanup key.\n");
+	}
 	return 0;
 }
 
@@ -436,3 +438,10 @@ NDCTL_EXPORT int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm,
 	return check_key_run_and_discard(dimm, ndctl_dimm_secure_erase,
 			"crypto erase", keypath);
 }
+
+NDCTL_EXPORT int ndctl_dimm_overwrite_key(struct ndctl_dimm *dimm,
+		const char *keypath)
+{
+	return check_key_run_and_discard(dimm, ndctl_dimm_overwrite,
+			"overwrite", keypath);
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
index 772aa7bb..1fbcfff4 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -704,6 +704,7 @@ int ndctl_dimm_update_passphrase(struct ndctl_dimm *dimm,
 int ndctl_dimm_disable_passphrase(struct ndctl_dimm *dimm, long key);
 int ndctl_dimm_freeze_security(struct ndctl_dimm *dimm);
 int ndctl_dimm_secure_erase(struct ndctl_dimm *dimm, long key);
+int ndctl_dimm_overwrite(struct ndctl_dimm *dimm, long key);
 
 enum ndctl_key_type {
 	ND_USER_KEY,
@@ -718,6 +719,7 @@ int ndctl_dimm_update_key(struct ndctl_dimm *dimm, const char *master,
 int ndctl_dimm_disable_key(struct ndctl_dimm *dimm, const char *keypath);
 int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm,
 		const char *keypath);
+int ndctl_dimm_overwrite_key(struct ndctl_dimm *dimm, const char *keypath);
 #else
 static inline int ndctl_dimm_enable_key(struct ndctl_dimm *dimm,
 		const char *master, const char *keypath)
@@ -742,6 +744,12 @@ static inline int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm,
 {
 	return -EOPNOTSUPP;
 }
+
+static inline int ndctl_dimm_overwrite_key(struct ndctl_dimm *dimm,
+		const char *keypath)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 #ifdef __cplusplus

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
