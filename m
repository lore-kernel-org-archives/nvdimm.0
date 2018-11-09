Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4DD6D21184E66
 for <linux-nvdimm@lists.01.org>; Fri,  9 Nov 2018 14:13:52 -0800 (PST)
Subject: [PATCH 01/11] keys-encrypted: add nvdimm key format type to
 encrypted keys
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 09 Nov 2018 15:13:51 -0700
Message-ID: <154180163107.70506.6894134402057805078.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154180093865.70506.6858789591063128903.stgit@djiang5-desk3.ch.intel.com>
References: <154180093865.70506.6858789591063128903.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com, zohar@linux.vnet.ibm.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Adding nvdimm key format type to encrypted keys in order to limit the size
of the key to 32bytes.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 security/keys/encrypted-keys/encrypted.c |   29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/security/keys/encrypted-keys/encrypted.c b/security/keys/encrypted-keys/encrypted.c
index d92cbf9687c3..182b4f136bdf 100644
--- a/security/keys/encrypted-keys/encrypted.c
+++ b/security/keys/encrypted-keys/encrypted.c
@@ -45,6 +45,7 @@ static const char hmac_alg[] = "hmac(sha256)";
 static const char blkcipher_alg[] = "cbc(aes)";
 static const char key_format_default[] = "default";
 static const char key_format_ecryptfs[] = "ecryptfs";
+static const char key_format_nvdimm[] = "nvdimm";
 static unsigned int ivsize;
 static int blksize;
 
@@ -54,6 +55,7 @@ static int blksize;
 #define HASH_SIZE SHA256_DIGEST_SIZE
 #define MAX_DATA_SIZE 4096
 #define MIN_DATA_SIZE  20
+#define KEY_NVDIMM_PAYLOAD_LEN 32
 
 static struct crypto_shash *hash_tfm;
 
@@ -62,12 +64,13 @@ enum {
 };
 
 enum {
-	Opt_error = -1, Opt_default, Opt_ecryptfs
+	Opt_error = -1, Opt_default, Opt_ecryptfs, Opt_nvdimm
 };
 
 static const match_table_t key_format_tokens = {
 	{Opt_default, "default"},
 	{Opt_ecryptfs, "ecryptfs"},
+	{Opt_nvdimm, "nvdimm"},
 	{Opt_error, NULL}
 };
 
@@ -195,6 +198,7 @@ static int datablob_parse(char *datablob, const char **format,
 	key_format = match_token(p, key_format_tokens, args);
 	switch (key_format) {
 	case Opt_ecryptfs:
+	case Opt_nvdimm:
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
+		} else if (!strcmp(format, key_format_nvdimm)) {
+			if (decrypted_datalen != KEY_NVDIMM_PAYLOAD_LEN) {
+				pr_err("encrypted_key: nvdimm key payload incorrect length: %d\n",
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
