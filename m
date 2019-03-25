Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4C3662194EB77
 for <linux-nvdimm@lists.01.org>; Mon, 25 Mar 2019 07:56:24 -0700 (PDT)
Date: Mon, 25 Mar 2019 16:56:19 +0200
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] KEYS: trusted: defer execution of TPM-specific code
 until key instantiate
Message-ID: <20190325145619.GC29989@linux.intel.com>
References: <20190322180139.18856-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190322180139.18856-1-roberto.sassu@huawei.com>
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
Cc: silviu.vlasceanu@huawei.com, linux-nvdimm@lists.01.org, jejb@linux.ibm.com, linux-kernel@vger.kernel.org, zohar@linux.ibm.com, dhowells@redhat.com, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, david.safford@ge.com, stable@vger.kernel.org, linux-integrity@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Mar 22, 2019 at 07:01:39PM +0100, Roberto Sassu wrote:
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
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>

Definitive NAK for the release. Sorting out the dependency problem is
definitely out of scope for v5.1.

/Jarkko
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
