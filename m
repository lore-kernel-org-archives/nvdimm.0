Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com
 [IPv6:2607:f8b0:4864:20::342])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A2DDB211DF22E
 for <linux-nvdimm@lists.01.org>; Tue, 19 Mar 2019 18:56:10 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id c16so713057otn.4
 for <linux-nvdimm@lists.01.org>; Tue, 19 Mar 2019 18:56:10 -0700 (PDT)
MIME-Version: 1.0
References: <155295271345.1945351.6465460744078693578.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1552955080.2785.26.camel@linux.ibm.com>
 <CAA9_cmcOD2zPaaNbkYAaH5DRDRAebPkW+hwPA0zPKY4kU8R-rg@mail.gmail.com>
 <1552956989.2785.31.camel@linux.ibm.com>
In-Reply-To: <1552956989.2785.31.camel@linux.ibm.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 19 Mar 2019 18:55:59 -0700
Message-ID: <CAPcyv4hXKQcdLnKG6rPNOJr2wjq31uCCr+16S5Yu6S5A_5UGrA@mail.gmail.com>
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

On Mon, Mar 18, 2019 at 5:56 PM James Bottomley <jejb@linux.ibm.com> wrote:
>
> On Mon, 2019-03-18 at 17:30 -0700, Dan Williams wrote:
> > On Mon, Mar 18, 2019 at 5:24 PM James Bottomley <jejb@linux.ibm.com>
> > wrote:
> > >
> > > On Mon, 2019-03-18 at 16:45 -0700, Dan Williams wrote:
> > > > Rather than fail initialization of the trusted.ko module, arrange
> > > > for the module to load, but rely on trusted_instantiate() to fail
> > > > trusted-key operations.
> > >
> > > What actual problem is this fixing?  To me it would seem like an
> > > enhancement to make the trusted module fail at load time if there's
> > > no TPM rather than waiting until first use to find out it can never
> > > work. Is there some piece of user code that depends on the
> > > successful insertion of trusted.ko?
> >
> > The module dependency chain relies on it. If that can be broken that
> > would also be an acceptable fix.
> >
> > I found this through the following dependency chain: libnvdimm.ko ->
> > encrypted_keys.ko -> trusted.ko.
> >
> > "key_type_trusted" is the symbol that encrypted_keys needs regardless
> > of whether the tpm is present.
>
> That's a nasty dependency caused by every key type module exporting a
> symbol for its key type.  It really seems that key types should be
> looked up by name not symbol to prevent more of these dependency issues
> from spreading.  Something like this (untested and definitely won't
> work without doing an EXPORT_SYMBOL on key_type_lookup).
>
> If it does look acceptable we can also disentangle the nasty module
> dependencies in the encrypted key code around masterkey which alone
> should be a huge improvement because that code is too hacky to live.
>
> James
>
> ---
> diff --git a/security/keys/encrypted-keys/masterkey_trusted.c b/security/keys/encrypted-keys/masterkey_trusted.c
> index dc3d18cae642..b98416f091e2 100644
> --- a/security/keys/encrypted-keys/masterkey_trusted.c
> +++ b/security/keys/encrypted-keys/masterkey_trusted.c
> @@ -19,6 +19,7 @@
>  #include <keys/trusted-type.h>
>  #include <keys/encrypted-type.h>
>  #include "encrypted.h"
> +#include "../internal.h"
>
>  /*
>   * request_trusted_key - request the trusted key
> @@ -32,8 +33,14 @@ struct key *request_trusted_key(const char *trusted_desc,
>  {
>         struct trusted_key_payload *tpayload;
>         struct key *tkey;
> +       struct key_type *type;
>
> -       tkey = request_key(&key_type_trusted, trusted_desc, NULL);
> +       type = key_type_lookup("trusted");
> +       if (IS_ERR(type)) {
> +               tkey = (struct key *)type;
> +               goto error;
> +       }
> +       tkey = request_key(type, trusted_desc, NULL);
>         if (IS_ERR(tkey))
>                 goto error;


This falls over with the need to pin the module while any key that
needs service from the hosting key_type operations might be live in
the system.

I could hang a "struct module *" off of the key_type so the host
module can be pinned, but that requires teaching all consumers of the
key_type module lifetime. Not impossible, but I think too big for a
fix, and I'd rather go with this local fixup to drop the dependency on
tpm_default_chip() successfully enumerating a TPM.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
