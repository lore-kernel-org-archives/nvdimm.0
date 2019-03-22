From: Roberto Sassu <roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] KEYS: trusted: defer execution of TPM-specific code until key
 instantiate
Date: Fri, 22 Mar 2019 19:01:39 +0100
Message-ID: <20190322180139.18856-1-roberto.sassu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, zohar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: silviu.vlasceanu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, jejb-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, Roberto Sassu <roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, david.safford-JJi787mZWgc@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-integrity-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

Commit 240730437deb ("KEYS: trusted: explicitly use tpm_chip structure from
tpm_default_chip()") changed the tpm_chip argument of every TPM function
from NULL to a pointer that is retrieved at module initialization time.

Unlike before this patch, the trusted module cannot be loaded if no TPM is
available. Unfortunately, this causes a dependency problem because the
encrypted key type requires the 'key_type_trusted' symbol when
CONFIG_TRUSTED_KEYS is defined.

This patch fixes the issue by deferring the execution of TPM-specific code
until a new trusted key is instantiated: init_tpm(), to obtain a tpm_chip
pointer; init_digests(), introduced by commit 0b6cf6b97b7e ("tpm: pass an
array of tpm_extend_digest structures to tpm_pcr_extend()"), to get random
bytes from the TPM to lock a PCR.

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Fixes: 240730437deb ("KEYS: trusted: explicitly use tpm_chip structure from tpm_default_chip()")
Reported-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Roberto Sassu <roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 security/keys/trusted.c | 89 +++++++++++++++++++++++------------------
 1 file changed, 50 insertions(+), 39 deletions(-)

diff --git a/security/keys/trusted.c b/security/keys/trusted.c
index ecec672d3a77..c5162ca9c944 100644
--- a/security/keys/trusted.c
+++ b/security/keys/trusted.c
@@ -946,6 +946,44 @@ static struct trusted_key_payload *trusted_payload_alloc(struct key *key)
 	return p;
 }
 
+static int init_tpm(void)
+{
+	if (chip)
+		return 0;
+
+	chip = tpm_default_chip();
+	if (!chip)
+		return -ENODEV;
+
+	return 0;
+}
+
+static int init_digests(void)
+{
+	u8 digest[TPM_MAX_DIGEST_SIZE];
+	int ret;
+	int i;
+
+	if (digests)
+		return 0;
+
+	ret = tpm_get_random(chip, digest, TPM_MAX_DIGEST_SIZE);
+	if (ret < 0)
+		return ret;
+	if (ret < TPM_MAX_DIGEST_SIZE)
+		return -EFAULT;
+
+	digests = kcalloc(chip->nr_allocated_banks, sizeof(*digests),
+			  GFP_KERNEL);
+	if (!digests)
+		return -ENOMEM;
+
+	for (i = 0; i < chip->nr_allocated_banks; i++)
+		memcpy(digests[i].digest, digest, TPM_MAX_DIGEST_SIZE);
+
+	return 0;
+}
+
 /*
  * trusted_instantiate - create a new trusted key
  *
@@ -967,6 +1005,14 @@ static int trusted_instantiate(struct key *key,
 	size_t key_len;
 	int tpm2;
 
+	ret = init_tpm();
+	if (ret < 0)
+		return ret;
+
+	ret = init_digests();
+	if (ret < 0)
+		return ret;
+
 	tpm2 = tpm_is_tpm2(chip);
 	if (tpm2 < 0)
 		return tpm2;
@@ -1218,58 +1264,23 @@ static int __init trusted_shash_alloc(void)
 	return ret;
 }
 
-static int __init init_digests(void)
-{
-	u8 digest[TPM_MAX_DIGEST_SIZE];
-	int ret;
-	int i;
-
-	ret = tpm_get_random(chip, digest, TPM_MAX_DIGEST_SIZE);
-	if (ret < 0)
-		return ret;
-	if (ret < TPM_MAX_DIGEST_SIZE)
-		return -EFAULT;
-
-	digests = kcalloc(chip->nr_allocated_banks, sizeof(*digests),
-			  GFP_KERNEL);
-	if (!digests)
-		return -ENOMEM;
-
-	for (i = 0; i < chip->nr_allocated_banks; i++)
-		memcpy(digests[i].digest, digest, TPM_MAX_DIGEST_SIZE);
-
-	return 0;
-}
-
 static int __init init_trusted(void)
 {
 	int ret;
 
-	chip = tpm_default_chip();
-	if (!chip)
-		return -ENOENT;
-	ret = init_digests();
-	if (ret < 0)
-		goto err_put;
 	ret = trusted_shash_alloc();
 	if (ret < 0)
-		goto err_free;
+		return ret;
 	ret = register_key_type(&key_type_trusted);
 	if (ret < 0)
-		goto err_release;
-	return 0;
-err_release:
-	trusted_shash_release();
-err_free:
-	kfree(digests);
-err_put:
-	put_device(&chip->dev);
+		trusted_shash_release();
 	return ret;
 }
 
 static void __exit cleanup_trusted(void)
 {
-	put_device(&chip->dev);
+	if (chip)
+		put_device(&chip->dev);
 	kfree(digests);
 	trusted_shash_release();
 	unregister_key_type(&key_type_trusted);
-- 
2.17.1
