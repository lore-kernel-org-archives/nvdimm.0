Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C7CFB211DC092
 for <linux-nvdimm@lists.01.org>; Mon, 18 Mar 2019 23:19:04 -0700 (PDT)
Subject: [PATCH 2/6] security/keys/encrypted: Clean up request_trusted_key()
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 18 Mar 2019 23:06:25 -0700
Message-ID: <155297558570.2276575.11731393787282486177.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <155297557534.2276575.16264199708584900090.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <155297557534.2276575.16264199708584900090.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: keyrings@vger.kernel.org
Cc: linux-nvdimm@lists.01.org, James Bottomley <jejb@linux.ibm.com>, linux-kernel@vger.kernel.org, Mimi Zohar <zohar@linux.ibm.com>, David Howells <dhowells@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

Now that the trusted key type is looked up by name rather than direct
symbol there is no need to play games with detecting the build
configuration. Make request_trusted_key() a static facility internal to
the encrypted-keys implementation.

Suggested-by: James Bottomley <jejb@linux.ibm.com>
Cc: Mimi Zohar <zohar@linux.ibm.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 include/linux/key.h                              |    1 
 security/keys/encrypted-keys/Makefile            |    3 -
 security/keys/encrypted-keys/encrypted.c         |   32 +++++++++++++
 security/keys/encrypted-keys/encrypted.h         |   12 -----
 security/keys/encrypted-keys/masterkey_trusted.c |   55 ----------------------
 security/keys/internal.h                         |    2 -
 security/keys/key.c                              |    1 
 7 files changed, 34 insertions(+), 72 deletions(-)
 delete mode 100644 security/keys/encrypted-keys/masterkey_trusted.c

diff --git a/include/linux/key.h b/include/linux/key.h
index 7099985e35a9..e7bfd037d26f 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -270,6 +270,7 @@ static inline void key_ref_put(key_ref_t key_ref)
 	key_put(key_ref_to_ptr(key_ref));
 }
 
+extern struct key_type *key_type_lookup(const char *type);
 extern struct key *request_key(struct key_type *type,
 			       const char *description,
 			       const char *callout_info);
diff --git a/security/keys/encrypted-keys/Makefile b/security/keys/encrypted-keys/Makefile
index 7a44dce6f69d..d42487bb3d8a 100644
--- a/security/keys/encrypted-keys/Makefile
+++ b/security/keys/encrypted-keys/Makefile
@@ -6,6 +6,3 @@
 obj-$(CONFIG_ENCRYPTED_KEYS) += encrypted-keys.o
 
 encrypted-keys-y := encrypted.o ecryptfs_format.o
-masterkey-$(CONFIG_TRUSTED_KEYS) := masterkey_trusted.o
-masterkey-$(CONFIG_TRUSTED_KEYS)-$(CONFIG_ENCRYPTED_KEYS) := masterkey_trusted.o
-encrypted-keys-y += $(masterkey-y) $(masterkey-m-m)
diff --git a/security/keys/encrypted-keys/encrypted.c b/security/keys/encrypted-keys/encrypted.c
index 347108f660a1..06925d3b30c9 100644
--- a/security/keys/encrypted-keys/encrypted.c
+++ b/security/keys/encrypted-keys/encrypted.c
@@ -423,6 +423,37 @@ static struct skcipher_request *init_skcipher_req(const u8 *key,
 	return req;
 }
 
+/*
+ * request_trusted_key - request the trusted key
+ *
+ * Trusted keys are sealed to PCRs and other metadata. Although userspace
+ * manages both trusted/encrypted key-types, like the encrypted key type
+ * data, trusted key type data is not visible decrypted from userspace.
+ */
+static struct key *request_trusted_key(const char *trusted_desc,
+				const u8 **master_key, size_t *master_keylen)
+{
+	struct trusted_key_payload *tpayload;
+	struct key_type *type;
+	struct key *tkey;
+
+	type = key_type_lookup("trusted");
+	if (IS_ERR(type)) {
+		tkey = (struct key *)type;
+		goto error;
+	}
+	tkey = request_key(type, trusted_desc, NULL);
+	if (IS_ERR(tkey))
+		goto error;
+
+	down_read(&tkey->sem);
+	tpayload = tkey->payload.data[0];
+	*master_key = tpayload->key;
+	*master_keylen = tpayload->key_len;
+error:
+	return tkey;
+}
+
 static struct key *request_master_key(struct encrypted_key_payload *epayload,
 				      const u8 **master_key, size_t *master_keylen)
 {
@@ -1025,3 +1056,4 @@ late_initcall(init_encrypted);
 module_exit(cleanup_encrypted);
 
 MODULE_LICENSE("GPL");
+MODULE_SOFTDEP("pre: trusted");
diff --git a/security/keys/encrypted-keys/encrypted.h b/security/keys/encrypted-keys/encrypted.h
index 1809995db452..0ae67824a24a 100644
--- a/security/keys/encrypted-keys/encrypted.h
+++ b/security/keys/encrypted-keys/encrypted.h
@@ -3,18 +3,6 @@
 #define __ENCRYPTED_KEY_H
 
 #define ENCRYPTED_DEBUG 0
-#if defined(CONFIG_TRUSTED_KEYS) || \
-  (defined(CONFIG_TRUSTED_KEYS_MODULE) && defined(CONFIG_ENCRYPTED_KEYS_MODULE))
-extern struct key *request_trusted_key(const char *trusted_desc,
-				       const u8 **master_key, size_t *master_keylen);
-#else
-static inline struct key *request_trusted_key(const char *trusted_desc,
-					      const u8 **master_key,
-					      size_t *master_keylen)
-{
-	return ERR_PTR(-EOPNOTSUPP);
-}
-#endif
 
 #if ENCRYPTED_DEBUG
 static inline void dump_master_key(const u8 *master_key, size_t master_keylen)
diff --git a/security/keys/encrypted-keys/masterkey_trusted.c b/security/keys/encrypted-keys/masterkey_trusted.c
deleted file mode 100644
index 7560aea6438d..000000000000
--- a/security/keys/encrypted-keys/masterkey_trusted.c
+++ /dev/null
@@ -1,55 +0,0 @@
-/*
- * Copyright (C) 2010 IBM Corporation
- * Copyright (C) 2010 Politecnico di Torino, Italy
- *                    TORSEC group -- http://security.polito.it
- *
- * Authors:
- * Mimi Zohar <zohar@us.ibm.com>
- * Roberto Sassu <roberto.sassu@polito.it>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation, version 2 of the License.
- *
- * See Documentation/security/keys/trusted-encrypted.rst
- */
-
-#include <linux/uaccess.h>
-#include <linux/err.h>
-#include <keys/trusted-type.h>
-#include <keys/encrypted-type.h>
-#include "encrypted.h"
-#include "../internal.h"
-
-/*
- * request_trusted_key - request the trusted key
- *
- * Trusted keys are sealed to PCRs and other metadata. Although userspace
- * manages both trusted/encrypted key-types, like the encrypted key type
- * data, trusted key type data is not visible decrypted from userspace.
- */
-struct key *request_trusted_key(const char *trusted_desc,
-				const u8 **master_key, size_t *master_keylen)
-{
-	struct trusted_key_payload *tpayload;
-	struct key_type *type;
-	struct key *tkey;
-
-	type = key_type_lookup("trusted");
-	if (IS_ERR(type)) {
-		tkey = (struct key *)type;
-		goto error;
-	}
-	tkey = request_key(type, trusted_desc, NULL);
-	if (IS_ERR(tkey))
-		goto error;
-
-	down_read(&tkey->sem);
-	tpayload = tkey->payload.data[0];
-	*master_key = tpayload->key;
-	*master_keylen = tpayload->key_len;
-error:
-	return tkey;
-}
-
-MODULE_SOFTDEP("pre: trusted");
diff --git a/security/keys/internal.h b/security/keys/internal.h
index 8f533c81aa8d..ea2eb78459bf 100644
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -89,8 +89,6 @@ extern spinlock_t key_serial_lock;
 extern struct mutex key_construction_mutex;
 extern wait_queue_head_t request_key_conswq;
 
-
-extern struct key_type *key_type_lookup(const char *type);
 extern void key_type_put(struct key_type *ktype);
 
 extern int __key_link_begin(struct key *keyring,
diff --git a/security/keys/key.c b/security/keys/key.c
index 696f1c092c50..9045b62afb04 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -706,6 +706,7 @@ struct key_type *key_type_lookup(const char *type)
 found_kernel_type:
 	return ktype;
 }
+EXPORT_SYMBOL_GPL(key_type_lookup);
 
 void key_set_timeout(struct key *key, unsigned timeout)
 {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
