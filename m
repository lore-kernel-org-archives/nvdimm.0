Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it1-x141.google.com (mail-it1-x141.google.com
 [IPv6:2607:f8b0:4864:20::141])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AFAF7211DF22F
 for <linux-nvdimm@lists.01.org>; Mon, 18 Mar 2019 17:30:34 -0700 (PDT)
Received: by mail-it1-x141.google.com with SMTP id l139so24307754ita.5
 for <linux-nvdimm@lists.01.org>; Mon, 18 Mar 2019 17:30:34 -0700 (PDT)
MIME-Version: 1.0
References: <155295271345.1945351.6465460744078693578.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1552955080.2785.26.camel@linux.ibm.com>
In-Reply-To: <1552955080.2785.26.camel@linux.ibm.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 18 Mar 2019 17:30:22 -0700
Message-ID: <CAA9_cmcOD2zPaaNbkYAaH5DRDRAebPkW+hwPA0zPKY4kU8R-rg@mail.gmail.com>
Subject: Re: [PATCH] security/keys/trusted: Allow operation without hardware
 TPM
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
To: James Bottomley <jejb@linux.ibm.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Roberto Sassu <roberto.sassu@huawei.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Mimi Zohar <zohar@linux.ibm.com>, David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Mar 18, 2019 at 5:24 PM James Bottomley <jejb@linux.ibm.com> wrote:
>
> On Mon, 2019-03-18 at 16:45 -0700, Dan Williams wrote:
> > Rather than fail initialization of the trusted.ko module, arrange for
> > the module to load, but rely on trusted_instantiate() to fail
> > trusted-key operations.
>
> What actual problem is this fixing?  To me it would seem like an
> enhancement to make the trusted module fail at load time if there's no
> TPM rather than waiting until first use to find out it can never work.
> Is there some piece of user code that depends on the successful
> insertion of trusted.ko?

The module dependency chain relies on it. If that can be broken that
would also be an acceptable fix.

I found this through the following dependency chain: libnvdimm.ko ->
encrypted_keys.ko -> trusted.ko.

"key_type_trusted" is the symbol that encrypted_keys needs regardless
of whether the tpm is present.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
