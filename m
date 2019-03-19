Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8596C211DC092
 for <linux-nvdimm@lists.01.org>; Mon, 18 Mar 2019 23:19:21 -0700 (PDT)
Subject: [PATCH 5/6] security/integrity/evm: Drop direct dependency on
 key_type_encrypted
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 18 Mar 2019 23:06:41 -0700
Message-ID: <155297560193.2276575.1761562049509563946.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, Mimi Zohar <zohar@linux.ibm.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Lookup the key type by name and protect evm from encrypted_keys.ko
module load failures.

Cc: Mimi Zohar <zohar@linux.ibm.com>
Cc: <linux-integrity@vger.kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 security/integrity/evm/evm_crypto.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
index c37d08118af5..5c65c3aef427 100644
--- a/security/integrity/evm/evm_crypto.c
+++ b/security/integrity/evm/evm_crypto.c
@@ -354,10 +354,15 @@ int evm_init_hmac(struct inode *inode, const struct xattr *lsm_xattr,
 int evm_init_key(void)
 {
 	struct key *evm_key;
+	struct key_type *type;
 	struct encrypted_key_payload *ekp;
 	int rc;
 
-	evm_key = request_key(&key_type_encrypted, EVMKEY, NULL);
+	type = key_type_lookup("encrypted");
+	if (IS_ERR(type))
+		return PTR_ERR(type);
+
+	evm_key = request_key(type, EVMKEY, NULL);
 	if (IS_ERR(evm_key))
 		return -ENOENT;
 
@@ -372,3 +377,5 @@ int evm_init_key(void)
 	key_put(evm_key);
 	return rc;
 }
+
+MODULE_SOFTDEP("pre: encrypted_keys");

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
