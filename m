Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F0929211E9593
 for <linux-nvdimm@lists.01.org>; Fri, 22 Mar 2019 16:42:51 -0700 (PDT)
Subject: [PATCH v2] ndctl: add support to allow zero key for secure erase
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 22 Mar 2019 16:42:50 -0700
Message-ID: <155329809436.64360.3502200842888668766.stgit@djiang5-desk3.ch.intel.com>
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

Providing a way for crypto-erase to pass in a key that is with 0's as
payload.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---

v2:
- Make zero key option explicit with -z parameter. Otherwise we will look
  for a key. (Dan)

 Documentation/ndctl/ndctl-sanitize-dimm.txt |    4 ++++
 ndctl/dimm.c                                |   16 +++++++++++++---
 ndctl/util/keys.c                           |   12 +++++++-----
 ndctl/util/keys.h                           |    1 +
 4 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/Documentation/ndctl/ndctl-sanitize-dimm.txt b/Documentation/ndctl/ndctl-sanitize-dimm.txt
index 7f57a115..797820dd 100644
--- a/Documentation/ndctl/ndctl-sanitize-dimm.txt
+++ b/Documentation/ndctl/ndctl-sanitize-dimm.txt
@@ -56,6 +56,10 @@ include::xable-dimm-options.txt[]
 	Indicate that we are using the master passphrase to perform the erase.
 	This only is applicable to the 'crypto-erase' option.
 
+-z::
+--zero-key::
+	Passing in a key with payload that is just 0's.
+
 --verbose::
         Emit debug messages.
 
diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index cc0bec04..b2b09b6a 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -49,6 +49,7 @@ static struct parameters {
 	const char *kek;
 	bool crypto_erase;
 	bool overwrite;
+	bool zero_key;
 	bool master_pass;
 	bool force;
 	bool json;
@@ -904,6 +905,7 @@ static int action_sanitize_dimm(struct ndctl_dimm *dimm,
 		struct action_context *actx)
 {
 	int rc;
+	enum ndctl_key_type key_type;
 
 	if (ndctl_dimm_get_security(dimm) < 0) {
 		error("%s: security operation not supported\n",
@@ -927,8 +929,14 @@ static int action_sanitize_dimm(struct ndctl_dimm *dimm,
 	}
 
 	if (param.crypto_erase) {
-		rc = ndctl_dimm_secure_erase_key(dimm, param.master_pass ?
-				ND_MASTER_KEY : ND_USER_KEY);
+		if (param.zero_key)
+			key_type = ND_ZERO_KEY;
+		else if (param.master_pass)
+			key_type = ND_MASTER_KEY;
+		else
+			key_type = ND_USER_KEY;
+
+		rc = ndctl_dimm_secure_erase_key(dimm, key_type);
 		if (rc < 0)
 			return rc;
 	}
@@ -1057,7 +1065,9 @@ OPT_STRING('k', "key-handle", &param.kek, "key-handle", \
 OPT_BOOLEAN('c', "crypto-erase", &param.crypto_erase, \
 		"crypto erase a dimm"), \
 OPT_BOOLEAN('o', "overwrite", &param.overwrite, \
-		"overwrite a dimm")
+		"overwrite a dimm"), \
+OPT_BOOLEAN('z', "zero-key", &param.zero_key, \
+		"pass in a zero key")
 
 #define MASTER_OPTIONS() \
 OPT_BOOLEAN('m', "master-passphrase", &param.master_pass, \
diff --git a/ndctl/util/keys.c b/ndctl/util/keys.c
index c1f2e843..c091cc5c 100644
--- a/ndctl/util/keys.c
+++ b/ndctl/util/keys.c
@@ -612,17 +612,19 @@ int ndctl_dimm_remove_key(struct ndctl_dimm *dimm)
 int ndctl_dimm_secure_erase_key(struct ndctl_dimm *dimm,
 		enum ndctl_key_type key_type)
 {
-	key_serial_t key;
+	key_serial_t key = 0;
 	int rc;
 
-	key = check_dimm_key(dimm, true, key_type);
-	if (key < 0)
-		return key;
+	if (key_type != ND_ZERO_KEY) {
+		key = check_dimm_key(dimm, true, key_type);
+		if (key < 0)
+			return key;
+	}
 
 	if (key_type == ND_MASTER_KEY)
 		rc = run_key_op(dimm, key, ndctl_dimm_master_secure_erase,
 				"master crypto erase");
-	else if (key_type == ND_USER_KEY)
+	else if (key_type == ND_USER_KEY || key_type == ND_ZERO_KEY)
 		rc = run_key_op(dimm, key, ndctl_dimm_secure_erase,
 				"crypto erase");
 	else
diff --git a/ndctl/util/keys.h b/ndctl/util/keys.h
index 30687a13..eab78d2f 100644
--- a/ndctl/util/keys.h
+++ b/ndctl/util/keys.h
@@ -9,6 +9,7 @@ enum ndctl_key_type {
 	ND_USER_OLD_KEY,
 	ND_MASTER_KEY,
 	ND_MASTER_OLD_KEY,
+	ND_ZERO_KEY,
 };
 
 #ifdef ENABLE_KEYUTILS

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
