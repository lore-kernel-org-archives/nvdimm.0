Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6F97B21B02822
 for <linux-nvdimm@lists.01.org>; Mon, 18 Mar 2019 16:57:53 -0700 (PDT)
Subject: [PATCH] security/keys/trusted: Allow operation without hardware TPM
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 18 Mar 2019 16:45:13 -0700
Message-ID: <155295271345.1945351.6465460744078693578.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: jarkko.sakkinen@linux.intel.com
Cc: linux-nvdimm@lists.01.org, James Bottomley <jejb@linux.ibm.com>, Roberto Sassu <roberto.sassu@huawei.com>, linux-kernel@vger.kernel.org, Mimi Zohar <zohar@linux.ibm.com>, David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Rather than fail initialization of the trusted.ko module, arrange for
the module to load, but rely on trusted_instantiate() to fail
trusted-key operations.

Fixes: 240730437deb ("KEYS: trusted: explicitly use tpm_chip structure...")
Cc: Roberto Sassu <roberto.sassu@huawei.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: James Bottomley <jejb@linux.ibm.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Mimi Zohar <zohar@linux.ibm.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 security/keys/trusted.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/security/keys/trusted.c b/security/keys/trusted.c
index bcc9c6ead7fd..d959597a688e 100644
--- a/security/keys/trusted.c
+++ b/security/keys/trusted.c
@@ -45,6 +45,13 @@ struct sdesc {
 static struct crypto_shash *hashalg;
 static struct crypto_shash *hmacalg;
 
+static struct device *chip_dev(struct tpm_chip *chip)
+{
+	if (chip)
+		return &chip->dev;
+	return NULL;
+}
+
 static struct sdesc *init_sdesc(struct crypto_shash *alg)
 {
 	struct sdesc *sdesc;
@@ -1224,6 +1231,14 @@ static int __init init_digests(void)
 	int ret;
 	int i;
 
+	/*
+	 * Hardware tpm operations are disabled, but allow the software
+	 * module to initialize, and depend on trusted_instantiate() to
+	 * fail any attempts to access the missing hardware.
+	 */
+	if (!chip)
+		return 0;
+
 	ret = tpm_get_random(chip, digest, TPM_MAX_DIGEST_SIZE);
 	if (ret < 0)
 		return ret;
@@ -1246,8 +1261,6 @@ static int __init init_trusted(void)
 	int ret;
 
 	chip = tpm_default_chip();
-	if (!chip)
-		return -ENOENT;
 	ret = init_digests();
 	if (ret < 0)
 		goto err_put;
@@ -1263,13 +1276,13 @@ static int __init init_trusted(void)
 err_free:
 	kfree(digests);
 err_put:
-	put_device(&chip->dev);
+	put_device(chip_dev(chip));
 	return ret;
 }
 
 static void __exit cleanup_trusted(void)
 {
-	put_device(&chip->dev);
+	put_device(chip_dev(chip));
 	kfree(digests);
 	trusted_shash_release();
 	unregister_key_type(&key_type_trusted);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
