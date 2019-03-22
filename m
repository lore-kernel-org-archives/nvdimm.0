Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com
 [IPv6:2607:f8b0:4864:20::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2D643211E82F9
 for <linux-nvdimm@lists.01.org>; Fri, 22 Mar 2019 11:49:39 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id v7so2488288oie.8
 for <linux-nvdimm@lists.01.org>; Fri, 22 Mar 2019 11:49:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190322180139.18856-1-roberto.sassu@huawei.com>
In-Reply-To: <20190322180139.18856-1-roberto.sassu@huawei.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 22 Mar 2019 11:49:27 -0700
Message-ID: <CAPcyv4jU-TCyfJ5gxrEaZt1GDJ+b_FtYi9O8H=cqLbqOAaskuw@mail.gmail.com>
Subject: Re: [PATCH] KEYS: trusted: defer execution of TPM-specific code until
 key instantiate
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
To: Roberto Sassu <roberto.sassu@huawei.com>
Cc: Silviu Vlasceanu <silviu.vlasceanu@huawei.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, david.safford@ge.com, James Bottomley <jejb@linux.ibm.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Mimi Zohar <zohar@linux.ibm.com>, David Howells <dhowells@redhat.com>, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, stable <stable@vger.kernel.org>, linux-integrity@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Mar 22, 2019 at 11:04 AM Roberto Sassu <roberto.sassu@huawei.com> wrote:
>
> Commit 240730437deb ("KEYS: trusted: explicitly use tpm_chip structure from
> tpm_default_chip()") changed the tpm_chip argument of every TPM function
> from NULL to a pointer that is retrieved at module initialization time.
>
> Unlike before this patch, the trusted module cannot be loaded if no TPM is
> available. Unfortunately, this causes a dependency problem because the
> encrypted key type requires the 'key_type_trusted' symbol when
> CONFIG_TRUSTED_KEYS is defined.
>
> This patch fixes the issue by deferring the execution of TPM-specific code
> until a new trusted key is instantiated: init_tpm(), to obtain a tpm_chip
> pointer; init_digests(), introduced by commit 0b6cf6b97b7e ("tpm: pass an
> array of tpm_extend_digest structures to tpm_pcr_extend()"), to get random
> bytes from the TPM to lock a PCR.
>
> Cc: stable@vger.kernel.org
> Fixes: 240730437deb ("KEYS: trusted: explicitly use tpm_chip structure from tpm_default_chip()")
> Reported-by: Dan Williams <dan.j.williams@intel.com>

Tested-by: Dan Williams <dan.j.williams@intel.com>

Thanks Robert!
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
