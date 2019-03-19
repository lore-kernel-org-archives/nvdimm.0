Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 388D2211DC092
 for <linux-nvdimm@lists.01.org>; Mon, 18 Mar 2019 23:19:00 -0700 (PDT)
Subject: [PATCH 1/6] security/keys/encrypted: Allow operation without
 trusted.ko
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 18 Mar 2019 23:06:20 -0700
Message-ID: <155297558061.2276575.9485856950730059730.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-nvdimm@lists.01.org, James Bottomley <jejb@linux.ibm.com>, Roberto Sassu <roberto.sassu@huawei.com>, linux-kernel@vger.kernel.org, Mimi Zohar <zohar@linux.ibm.com>, David Howells <dhowells@redhat.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

The trusted.ko module may fail to load. In the common case this failure
is simply due to the platform missing a TPM. Teach the encrypted_keys
implementation to lookup the key type by name rather than having a
module dependency.

Fixes: 240730437deb ("KEYS: trusted: explicitly use tpm_chip structure...")
Suggested-by: James Bottomley <jejb@linux.ibm.com>
Cc: Roberto Sassu <roberto.sassu@huawei.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Mimi Zohar <zohar@linux.ibm.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 security/keys/encrypted-keys/masterkey_trusted.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/security/keys/encrypted-keys/masterkey_trusted.c b/security/keys/encrypted-keys/masterkey_trusted.c
index dc3d18cae642..7560aea6438d 100644
--- a/security/keys/encrypted-keys/masterkey_trusted.c
+++ b/security/keys/encrypted-keys/masterkey_trusted.c
@@ -19,6 +19,7 @@
 #include <keys/trusted-type.h>
 #include <keys/encrypted-type.h>
 #include "encrypted.h"
+#include "../internal.h"
 
 /*
  * request_trusted_key - request the trusted key
@@ -31,9 +32,15 @@ struct key *request_trusted_key(const char *trusted_desc,
 				const u8 **master_key, size_t *master_keylen)
 {
 	struct trusted_key_payload *tpayload;
+	struct key_type *type;
 	struct key *tkey;
 
-	tkey = request_key(&key_type_trusted, trusted_desc, NULL);
+	type = key_type_lookup("trusted");
+	if (IS_ERR(type)) {
+		tkey = (struct key *)type;
+		goto error;
+	}
+	tkey = request_key(type, trusted_desc, NULL);
 	if (IS_ERR(tkey))
 		goto error;
 
@@ -44,3 +51,5 @@ struct key *request_trusted_key(const char *trusted_desc,
 error:
 	return tkey;
 }
+
+MODULE_SOFTDEP("pre: trusted");

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
