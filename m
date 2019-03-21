Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from huawei.com (lhrrgout.huawei.com [185.176.76.210])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E231321959CB2
 for <linux-nvdimm@lists.01.org>; Thu, 21 Mar 2019 06:25:31 -0700 (PDT)
Subject: Re: [PATCH v10, RESEND 5/6] KEYS: trusted: explicitly use tpm_chip
 structure from tpm_default_chip()
References: <20190206162452.7749-1-roberto.sassu@huawei.com>
 <20190206162452.7749-6-roberto.sassu@huawei.com>
 <CAA9_cmf0j1EoyrGmbfPWCWPafgGfKWR6cyPpN8YEFZdemeg1kA@mail.gmail.com>
 <20190321131554.GB2267@linux.intel.com>
From: Roberto Sassu <roberto.sassu@huawei.com>
Message-ID: <ee9e7fb0-e3f1-4fb3-da12-84ca746989bd@huawei.com>
Date: Thu, 21 Mar 2019 14:25:26 +0100
MIME-Version: 1.0
In-Reply-To: <20190321131554.GB2267@linux.intel.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Dan Williams <dan.j.williams@gmail.com>
Cc: silviu.vlasceanu@huawei.com, linux-nvdimm <linux-nvdimm@lists.01.org>, matthewgarrett@google.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, david.safford@ge.com, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, zohar@linux.ibm.com, monty.wiseman@ge.com, linux-integrity@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On 3/21/2019 2:15 PM, Jarkko Sakkinen wrote:
> On Mon, Mar 18, 2019 at 03:35:08PM -0700, Dan Williams wrote:
>> On Wed, Feb 6, 2019 at 10:30 AM Roberto Sassu <roberto.sassu@huawei.com> wrote:
>>>
>>> When crypto agility support will be added to the TPM driver, users of the
>>> driver have to retrieve the allocated banks from chip->allocated_banks and
>>> use this information to prepare the array of tpm_digest structures to be
>>> passed to tpm_pcr_extend().
>>>
>>> This patch retrieves a tpm_chip pointer from tpm_default_chip() so that the
>>> pointer can be used to prepare the array of tpm_digest structures.
>>>
>>> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
>>> Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
>>> Tested-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
>>> ---
>>>   security/keys/trusted.c | 38 ++++++++++++++++++++++++--------------
>>>   1 file changed, 24 insertions(+), 14 deletions(-)
>>>
>>> diff --git a/security/keys/trusted.c b/security/keys/trusted.c
>>> index 4d98f4f87236..5b852263eae1 100644
>>> --- a/security/keys/trusted.c
>>> +++ b/security/keys/trusted.c
>>> @@ -34,6 +34,7 @@
>>>
>>>   static const char hmac_alg[] = "hmac(sha1)";
>>>   static const char hash_alg[] = "sha1";
>>> +static struct tpm_chip *chip;
>>>
>>>   struct sdesc {
>>>          struct shash_desc shash;
>>> @@ -362,7 +363,7 @@ int trusted_tpm_send(unsigned char *cmd, size_t buflen)
>>>          int rc;
>>>
>>>          dump_tpm_buf(cmd);
>>> -       rc = tpm_send(NULL, cmd, buflen);
>>> +       rc = tpm_send(chip, cmd, buflen);
>>>          dump_tpm_buf(cmd);
>>>          if (rc > 0)
>>>                  /* Can't return positive return codes values to keyctl */
>>> @@ -384,10 +385,10 @@ static int pcrlock(const int pcrnum)
>>>
>>>          if (!capable(CAP_SYS_ADMIN))
>>>                  return -EPERM;
>>> -       ret = tpm_get_random(NULL, hash, SHA1_DIGEST_SIZE);
>>> +       ret = tpm_get_random(chip, hash, SHA1_DIGEST_SIZE);
>>>          if (ret != SHA1_DIGEST_SIZE)
>>>                  return ret;
>>> -       return tpm_pcr_extend(NULL, pcrnum, hash) ? -EINVAL : 0;
>>> +       return tpm_pcr_extend(chip, pcrnum, hash) ? -EINVAL : 0;
>>>   }
>>>
>>>   /*
>>> @@ -400,7 +401,7 @@ static int osap(struct tpm_buf *tb, struct osapsess *s,
>>>          unsigned char ononce[TPM_NONCE_SIZE];
>>>          int ret;
>>>
>>> -       ret = tpm_get_random(NULL, ononce, TPM_NONCE_SIZE);
>>> +       ret = tpm_get_random(chip, ononce, TPM_NONCE_SIZE);
>>>          if (ret != TPM_NONCE_SIZE)
>>>                  return ret;
>>>
>>> @@ -496,7 +497,7 @@ static int tpm_seal(struct tpm_buf *tb, uint16_t keytype,
>>>          if (ret < 0)
>>>                  goto out;
>>>
>>> -       ret = tpm_get_random(NULL, td->nonceodd, TPM_NONCE_SIZE);
>>> +       ret = tpm_get_random(chip, td->nonceodd, TPM_NONCE_SIZE);
>>>          if (ret != TPM_NONCE_SIZE)
>>>                  goto out;
>>>          ordinal = htonl(TPM_ORD_SEAL);
>>> @@ -606,7 +607,7 @@ static int tpm_unseal(struct tpm_buf *tb,
>>>
>>>          ordinal = htonl(TPM_ORD_UNSEAL);
>>>          keyhndl = htonl(SRKHANDLE);
>>> -       ret = tpm_get_random(NULL, nonceodd, TPM_NONCE_SIZE);
>>> +       ret = tpm_get_random(chip, nonceodd, TPM_NONCE_SIZE);
>>>          if (ret != TPM_NONCE_SIZE) {
>>>                  pr_info("trusted_key: tpm_get_random failed (%d)\n", ret);
>>>                  return ret;
>>> @@ -751,7 +752,7 @@ static int getoptions(char *c, struct trusted_key_payload *pay,
>>>          int i;
>>>          int tpm2;
>>>
>>> -       tpm2 = tpm_is_tpm2(NULL);
>>> +       tpm2 = tpm_is_tpm2(chip);
>>>          if (tpm2 < 0)
>>>                  return tpm2;
>>>
>>> @@ -920,7 +921,7 @@ static struct trusted_key_options *trusted_options_alloc(void)
>>>          struct trusted_key_options *options;
>>>          int tpm2;
>>>
>>> -       tpm2 = tpm_is_tpm2(NULL);
>>> +       tpm2 = tpm_is_tpm2(chip);
>>>          if (tpm2 < 0)
>>>                  return NULL;
>>>
>>> @@ -970,7 +971,7 @@ static int trusted_instantiate(struct key *key,
>>>          size_t key_len;
>>>          int tpm2;
>>>
>>> -       tpm2 = tpm_is_tpm2(NULL);
>>> +       tpm2 = tpm_is_tpm2(chip);
>>>          if (tpm2 < 0)
>>>                  return tpm2;
>>>
>>> @@ -1011,7 +1012,7 @@ static int trusted_instantiate(struct key *key,
>>>          switch (key_cmd) {
>>>          case Opt_load:
>>>                  if (tpm2)
>>> -                       ret = tpm_unseal_trusted(NULL, payload, options);
>>> +                       ret = tpm_unseal_trusted(chip, payload, options);
>>>                  else
>>>                          ret = key_unseal(payload, options);
>>>                  dump_payload(payload);
>>> @@ -1021,13 +1022,13 @@ static int trusted_instantiate(struct key *key,
>>>                  break;
>>>          case Opt_new:
>>>                  key_len = payload->key_len;
>>> -               ret = tpm_get_random(NULL, payload->key, key_len);
>>> +               ret = tpm_get_random(chip, payload->key, key_len);
>>>                  if (ret != key_len) {
>>>                          pr_info("trusted_key: key_create failed (%d)\n", ret);
>>>                          goto out;
>>>                  }
>>>                  if (tpm2)
>>> -                       ret = tpm_seal_trusted(NULL, payload, options);
>>> +                       ret = tpm_seal_trusted(chip, payload, options);
>>>                  else
>>>                          ret = key_seal(payload, options);
>>>                  if (ret < 0)
>>> @@ -1225,17 +1226,26 @@ static int __init init_trusted(void)
>>>   {
>>>          int ret;
>>>
>>> +       chip = tpm_default_chip();
>>> +       if (!chip)
>>> +               return -ENOENT;
>>
>> This change causes a regression loading the encrypted_keys module on
>> systems that don't have a tpm.
>>
>> Module init functions should not have hardware dependencies.
>>
>> The effect is that the libnvdimm module, which is an encrypted_keys
>> user, fails to load, but up until this change encrypted_keys did not
>> have a hard dependency on TPM presence.
> 
> Sorry for the latency. I was in flu for couple of days.
> 
> I missed that addition in the review process albeit this patch set
> went numerous rounds. Apologies about ths. Also the return value is
> wrong. Should be -ENODEV but it doesn't matter because this needs to
> be removed anyway.
> 
> Roberto, can you submit a fix ASAP that:

Ok, I will do it now.

Roberto


> 1. Allows the module to initialize even if the chip is not found.
> 2. In the beginning of each function (before tpm_is_tpm2()) you
>     should check if chip is NULL and return -ENODEV if it is.
> 
> Add also these tags before your signed-off-by:
> 
> Cc: stable@vger.kernel.org
> Fixes: 240730437deb ("KEYS: trusted: explicitly use tpm_chip structure from tpm_default_chip()")
> Reported-by: Dan Williams <dan.j.williams@gmail.com>
> Suggested-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> 
> /Jarkko
> 

-- 
HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
Managing Director: Bo PENG, Jian LI, Yanli SHI
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
