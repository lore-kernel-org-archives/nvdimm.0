From: Roberto Sassu <roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] security/keys/trusted: Allow operation without hardware
 TPM
Date: Thu, 21 Mar 2019 18:45:47 +0100
Message-ID: <d0434a90-4010-8c76-c02e-bb1a6ec831ef@huawei.com>
References: <155295271345.1945351.6465460744078693578.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190321135451.GD4603@linux.intel.com>
 <809e827b-fdbe-fbb8-8acf-2878ae9f7777@huawei.com>
 <CAPcyv4gc_KWedC12bTcX24KwjKiBCF=yvouRNzCbJKaLrgJdDg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAPcyv4gc_KWedC12bTcX24KwjKiBCF=yvouRNzCbJKaLrgJdDg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Silviu Vlasceanu <Silviu.Vlasceanu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, James Bottomley <jejb-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mimi Zohar <zohar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On 3/21/2019 5:30 PM, Dan Williams wrote:
> On Thu, Mar 21, 2019 at 7:27 AM Roberto Sassu <roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>>
>> On 3/21/2019 2:54 PM, Jarkko Sakkinen wrote:
>>> On Mon, Mar 18, 2019 at 04:45:13PM -0700, Dan Williams wrote:
>>>> Rather than fail initialization of the trusted.ko module, arrange for
>>>> the module to load, but rely on trusted_instantiate() to fail
>>>> trusted-key operations.
>>>>
>>>> Fixes: 240730437deb ("KEYS: trusted: explicitly use tpm_chip structure...")
>>>> Cc: Roberto Sassu <roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>>> Cc: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>>>> Cc: James Bottomley <jejb-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
>>>> Cc: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>>>> Cc: Mimi Zohar <zohar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
>>>> Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>>> Signed-off-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>>
>>> It should check for chip in each function that uses TPM now that
>>> the code does not rely on default chip. Otherwise, the semantics
>>> are kind of inconsistent.
>>
>> If no other TPM function can be used before a successful key
>> instantiate, checking for a chip only in trusted_instantiate() seems
>> sufficient. Then, the same chip will be used by all TPM functions until
>> module unloading, since we incremented the reference count.
>>
>> I would suggest to move the tpm_default_chip() and init_digests() calls
>> to trusted_instantiate() to restore the old behavior of init_trusted().
>>
>> trusted_instantiate() should look like:
>> ---
>> if (!chip) {
>>          chip = tpm_default_chip();
>>          if (!chip)
>>                  return -ENODEV;
>> }
>>
>> if (!digests) {
>>          ret = init_digests();
>>          if (ret < 0)
>>                  return ret;
>> }
> 
> This patch already achieves that because tpm_find_get_ops() will fail
> and cause tpm_is_tpm2() to return NULL.

In addition, the changes I proposed would allow users to create trusted
keys if a TPM is added later. CONFIG_TRUSTED_KEYS=y and
CONFIG_TCG_TPM=m is a valid configuration.

Jarkko, Dan's patch seems sufficient to fix the issue. He could include
the changes I proposed in his patch. What is your opinion?

Thanks

Roberto

-- 
HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
Managing Director: Bo PENG, Jian LI, Yanli SHI
