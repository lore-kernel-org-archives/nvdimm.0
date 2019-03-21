From: Roberto Sassu <roberto.sassu@huawei.com>
Subject: Re: [PATCH] security/keys/trusted: Allow operation without hardware
 TPM
Date: Thu, 21 Mar 2019 15:26:38 +0100
Message-ID: <809e827b-fdbe-fbb8-8acf-2878ae9f7777@huawei.com>
References: <155295271345.1945351.6465460744078693578.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190321135451.GD4603@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190321135451.GD4603@linux.intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>
Cc: James Bottomley <jejb@linux.ibm.com>, Mimi Zohar <zohar@linux.ibm.com>, David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
List-Id: linux-nvdimm@lists.01.org

On 3/21/2019 2:54 PM, Jarkko Sakkinen wrote:
> On Mon, Mar 18, 2019 at 04:45:13PM -0700, Dan Williams wrote:
>> Rather than fail initialization of the trusted.ko module, arrange for
>> the module to load, but rely on trusted_instantiate() to fail
>> trusted-key operations.
>>
>> Fixes: 240730437deb ("KEYS: trusted: explicitly use tpm_chip structure...")
>> Cc: Roberto Sassu <roberto.sassu@huawei.com>
>> Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
>> Cc: James Bottomley <jejb@linux.ibm.com>
>> Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
>> Cc: Mimi Zohar <zohar@linux.ibm.com>
>> Cc: David Howells <dhowells@redhat.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> 
> It should check for chip in each function that uses TPM now that
> the code does not rely on default chip. Otherwise, the semantics
> are kind of inconsistent.

If no other TPM function can be used before a successful key
instantiate, checking for a chip only in trusted_instantiate() seems
sufficient. Then, the same chip will be used by all TPM functions until
module unloading, since we incremented the reference count.

I would suggest to move the tpm_default_chip() and init_digests() calls
to trusted_instantiate() to restore the old behavior of init_trusted().

trusted_instantiate() should look like:
---
if (!chip) {
	chip = tpm_default_chip();
	if (!chip)
		return -ENODEV;
}

if (!digests) {
	ret = init_digests();
	if (ret < 0)
		return ret;
}
---

Roberto


> /Jarkko
> 

-- 
HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
Managing Director: Bo PENG, Jian LI, Yanli SHI
