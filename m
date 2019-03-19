Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 63C43211DC092
 for <linux-nvdimm@lists.01.org>; Mon, 18 Mar 2019 23:19:16 -0700 (PDT)
Subject: [PATCH 4/6] security/keys/ecryptfs: Drop direct dependency on
 key_type_encrypted
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 18 Mar 2019 23:06:36 -0700
Message-ID: <155297559625.2276575.11539296499176067525.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-nvdimm@lists.01.org, ecryptfs@vger.kernel.org, linux-kernel@vger.kernel.org, Tyler Hicks <tyhicks@canonical.com>
List-ID: <linux-nvdimm@lists.01.org>

Lookup the key type by name and protect ecryptfs from encrypted_keys.ko
module load failures, and cleanup the configuration dependencies on the
definition of the ecryptfs_get_encrypted_key() helper.

Cc: Tyler Hicks <tyhicks@canonical.com>
Cc: <ecryptfs@vger.kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/ecryptfs/ecryptfs_kernel.h |   22 +---------------------
 fs/ecryptfs/keystore.c        |   12 ++++++++++++
 2 files changed, 13 insertions(+), 21 deletions(-)

diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
index e74cb2a0b299..3106d23d95f0 100644
--- a/fs/ecryptfs/ecryptfs_kernel.h
+++ b/fs/ecryptfs/ecryptfs_kernel.h
@@ -87,13 +87,12 @@ struct ecryptfs_page_crypt_context {
 	} param;
 };
 
-#if defined(CONFIG_ENCRYPTED_KEYS) || defined(CONFIG_ENCRYPTED_KEYS_MODULE)
 static inline struct ecryptfs_auth_tok *
 ecryptfs_get_encrypted_key_payload_data(struct key *key)
 {
 	struct encrypted_key_payload *payload;
 
-	if (key->type != &key_type_encrypted)
+	if (strcmp(key->type->name, "encrypted") != 0)
 		return NULL;
 
 	payload = key->payload.data[0];
@@ -103,25 +102,6 @@ ecryptfs_get_encrypted_key_payload_data(struct key *key)
 	return (struct ecryptfs_auth_tok *)payload->payload_data;
 }
 
-static inline struct key *ecryptfs_get_encrypted_key(char *sig)
-{
-	return request_key(&key_type_encrypted, sig, NULL);
-}
-
-#else
-static inline struct ecryptfs_auth_tok *
-ecryptfs_get_encrypted_key_payload_data(struct key *key)
-{
-	return NULL;
-}
-
-static inline struct key *ecryptfs_get_encrypted_key(char *sig)
-{
-	return ERR_PTR(-ENOKEY);
-}
-
-#endif /* CONFIG_ENCRYPTED_KEYS */
-
 static inline struct ecryptfs_auth_tok *
 ecryptfs_get_key_payload_data(struct key *key)
 {
diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
index e74fe84d0886..52a01dd57f4a 100644
--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -1619,6 +1619,17 @@ parse_tag_11_packet(unsigned char *data, unsigned char *contents,
 	return rc;
 }
 
+static struct key *ecryptfs_get_encrypted_key(char *sig)
+{
+	struct key_type *type;
+	struct key *key;
+
+	type = key_type_lookup("encrypted");
+	if (IS_ERR(type))
+		return (struct key *) type;
+	return request_key(type, sig, NULL);
+}
+
 int ecryptfs_keyring_auth_tok_for_sig(struct key **auth_tok_key,
 				      struct ecryptfs_auth_tok **auth_tok,
 				      char *sig)
@@ -2542,3 +2553,4 @@ ecryptfs_add_global_auth_tok(struct ecryptfs_mount_crypt_stat *mount_crypt_stat,
 	return 0;
 }
 
+MODULE_SOFTDEP("pre: encrypted_keys");

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
