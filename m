Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 82C75211A2D87
 for <linux-nvdimm@lists.01.org>; Thu, 13 Dec 2018 15:48:19 -0800 (PST)
Subject: [PATCH v15 04/16] keys-encrypted: add nvdimm key format type to
 encrypted keys
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 13 Dec 2018 16:48:18 -0700
Message-ID: <154474489873.64529.17488192789733888751.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154474458351.64529.4227918957466268448.stgit@djiang5-desk3.ch.intel.com>
References: <154474458351.64529.4227918957466268448.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Adding nvdimm key format type to encrypted keys in order to limit the size
of the key to 32bytes.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Acked-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/security/keys/trusted-encrypted.rst |    6 ++++
 security/keys/encrypted-keys/encrypted.c          |   29 ++++++++++++++-------
 2 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/Documentation/security/keys/trusted-encrypted.rst b/Documentation/security/keys/trusted-encrypted.rst
index 3bb24e09a332..e8a1c35cd277 100644
--- a/Documentation/security/keys/trusted-encrypted.rst
+++ b/Documentation/security/keys/trusted-encrypted.rst
@@ -76,7 +76,7 @@ Usage::
 
 Where::
 
-	format:= 'default | ecryptfs'
+	format:= 'default | ecryptfs | enc32'
 	key-type:= 'trusted' | 'user'
 
 
@@ -173,3 +173,7 @@ are anticipated.  In particular the new format 'ecryptfs' has been defined in
 in order to use encrypted keys to mount an eCryptfs filesystem.  More details
 about the usage can be found in the file
 ``Documentation/security/keys/ecryptfs.rst``.
+
+Another new format 'enc32' has been defined in order to support encrypted keys
+with payload size of 32 bytes. This will initially be used for nvdimm security
+but may expand to other usages that require 32 bytes payload.
diff --git a/security/keys/encrypted-keys/encrypted.c b/security/keys/encrypted-keys/encrypted.c
index d92cbf9687c3..fe0aefd06f83 100644
--- a/security/keys/encrypted-keys/encrypted.c
+++ b/security/keys/encrypted-keys/encrypted.c
@@ -45,6 +45,7 @@ static const char hmac_alg[] = "hmac(sha256)";
 static const char blkcipher_alg[] = "cbc(aes)";
 static const char key_format_default[] = "default";
 static const char key_format_ecryptfs[] = "ecryptfs";
+static const char key_format_enc32[] = "enc32";
 static unsigned int ivsize;
 static int blksize;
 
@@ -54,6 +55,7 @@ static int blksize;
 #define HASH_SIZE SHA256_DIGEST_SIZE
 #define MAX_DATA_SIZE 4096
 #define MIN_DATA_SIZE  20
+#define KEY_ENC32_PAYLOAD_LEN 32
 
 static struct crypto_shash *hash_tfm;
 
@@ -62,12 +64,13 @@ enum {
 };
 
 enum {
-	Opt_error = -1, Opt_default, Opt_ecryptfs
+	Opt_error = -1, Opt_default, Opt_ecryptfs, Opt_enc32
 };
 
 static const match_table_t key_format_tokens = {
 	{Opt_default, "default"},
 	{Opt_ecryptfs, "ecryptfs"},
+	{Opt_enc32, "enc32"},
 	{Opt_error, NULL}
 };
 
@@ -195,6 +198,7 @@ static int datablob_parse(char *datablob, const char **format,
 	key_format = match_token(p, key_format_tokens, args);
 	switch (key_format) {
 	case Opt_ecryptfs:
+	case Opt_enc32:
 	case Opt_default:
 		*format = p;
 		*master_desc = strsep(&datablob, " \t");
@@ -625,15 +629,22 @@ static struct encrypted_key_payload *encrypted_key_alloc(struct key *key,
 	format_len = (!format) ? strlen(key_format_default) : strlen(format);
 	decrypted_datalen = dlen;
 	payload_datalen = decrypted_datalen;
-	if (format && !strcmp(format, key_format_ecryptfs)) {
-		if (dlen != ECRYPTFS_MAX_KEY_BYTES) {
-			pr_err("encrypted_key: keylen for the ecryptfs format "
-			       "must be equal to %d bytes\n",
-			       ECRYPTFS_MAX_KEY_BYTES);
-			return ERR_PTR(-EINVAL);
+	if (format) {
+		if (!strcmp(format, key_format_ecryptfs)) {
+			if (dlen != ECRYPTFS_MAX_KEY_BYTES) {
+				pr_err("encrypted_key: keylen for the ecryptfs format must be equal to %d bytes\n",
+					ECRYPTFS_MAX_KEY_BYTES);
+				return ERR_PTR(-EINVAL);
+			}
+			decrypted_datalen = ECRYPTFS_MAX_KEY_BYTES;
+			payload_datalen = sizeof(struct ecryptfs_auth_tok);
+		} else if (!strcmp(format, key_format_enc32)) {
+			if (decrypted_datalen != KEY_ENC32_PAYLOAD_LEN) {
+				pr_err("encrypted_key: enc32 key payload incorrect length: %d\n",
+						decrypted_datalen);
+				return ERR_PTR(-EINVAL);
+			}
 		}
-		decrypted_datalen = ECRYPTFS_MAX_KEY_BYTES;
-		payload_datalen = sizeof(struct ecryptfs_auth_tok);
 	}
 
 	encrypted_datalen = roundup(decrypted_datalen, blksize);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
