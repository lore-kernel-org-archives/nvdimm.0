Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 64757211963E1
 for <linux-nvdimm@lists.01.org>; Fri, 30 Nov 2018 13:34:09 -0800 (PST)
Subject: [PATCH v5 08/12] ndctl: add overwrite operation support
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 30 Nov 2018 14:34:08 -0700
Message-ID: <154361364878.6129.8421047191424581454.stgit@djiang5-desk3.ch.intel.com>
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

Add support for overwrite to libndctl. The operation will be triggered
by the sanitize-dimm command with -o switch. This will initiate the request
to wipe the entire nvdimm. Success return of the command only indicate
overwrite has started and does not indicate completion of overwrite.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ndctl/ndctl-sanitize-dimm.txt |    4 ++++
 ndctl/dimm.c                                |   13 +++++++++++--
 ndctl/lib/dimm.c                            |    8 ++++++++
 ndctl/lib/keys.c                            |    6 ++++++
 ndctl/lib/libndctl.sym                      |    2 ++
 ndctl/libndctl.h                            |    7 +++++++
 6 files changed, 38 insertions(+), 2 deletions(-)

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
index ae674f78..febda71a 100644
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
index 1ebb008b..903fb408 100644
--- a/ndctl/lib/keys.c
+++ b/ndctl/lib/keys.c
@@ -423,3 +423,9 @@ NDCTL_EXPORT int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm)
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
index 374b19f7..24866ef3 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -705,12 +705,14 @@ int ndctl_dimm_update_passphrase(struct ndctl_dimm *dimm,
 int ndctl_dimm_disable_passphrase(struct ndctl_dimm *dimm, long key);
 int ndctl_dimm_freeze_security(struct ndctl_dimm *dimm);
 int ndctl_dimm_secure_erase(struct ndctl_dimm *dimm, long key);
+int ndctl_dimm_overwrite(struct ndctl_dimm *dimm, long key);
 
 #ifdef ENABLE_KEYUTILS
 int ndctl_dimm_enable_key(struct ndctl_dimm *dimm, const char *master);
 int ndctl_dimm_update_key(struct ndctl_dimm *dimm, const char *master);
 int ndctl_dimm_disable_key(struct ndctl_dimm *dimm);
 int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm);
+int ndctl_dimm_overwrite_key(struct ndctl_dimm *dimm);
 #else
 static inline int ndctl_dimm_enable_key(struct ndctl_dimm *dimm,
 		const char *master)
@@ -733,6 +735,11 @@ static inline int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm)
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
