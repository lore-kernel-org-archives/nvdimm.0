Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D5D41211DCDB8
 for <linux-nvdimm@lists.01.org>; Mon, 18 Mar 2019 23:19:26 -0700 (PDT)
Subject: [PATCH 6/6] security/keys/encrypted: Drop export of key_type_encrypted
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 18 Mar 2019 23:06:47 -0700
Message-ID: <155297560738.2276575.13044997734939158888.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org, Mimi Zohar <zohar@linux.ibm.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Now that all users lookup the key type by name, drop the export and the
direct module dependency.

Cc: Mimi Zohar <zohar@linux.ibm.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 include/keys/encrypted-type.h            |    2 --
 security/keys/encrypted-keys/encrypted.c |    3 +--
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/include/keys/encrypted-type.h b/include/keys/encrypted-type.h
index 1d4541370a64..dd509835b4a4 100644
--- a/include/keys/encrypted-type.h
+++ b/include/keys/encrypted-type.h
@@ -33,6 +33,4 @@ struct encrypted_key_payload {
 	u8 payload_data[0];	/* payload data + datablob + hmac */
 };
 
-extern struct key_type key_type_encrypted;
-
 #endif /* _KEYS_ENCRYPTED_TYPE_H */
diff --git a/security/keys/encrypted-keys/encrypted.c b/security/keys/encrypted-keys/encrypted.c
index 06925d3b30c9..c3999d5e2a19 100644
--- a/security/keys/encrypted-keys/encrypted.c
+++ b/security/keys/encrypted-keys/encrypted.c
@@ -1012,7 +1012,7 @@ static void encrypted_destroy(struct key *key)
 	kzfree(key->payload.data[0]);
 }
 
-struct key_type key_type_encrypted = {
+static struct key_type key_type_encrypted = {
 	.name = "encrypted",
 	.instantiate = encrypted_instantiate,
 	.update = encrypted_update,
@@ -1020,7 +1020,6 @@ struct key_type key_type_encrypted = {
 	.describe = user_describe,
 	.read = encrypted_read,
 };
-EXPORT_SYMBOL_GPL(key_type_encrypted);
 
 static int __init init_encrypted(void)
 {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
