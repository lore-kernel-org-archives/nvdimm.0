Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com
 [IPv6:2607:f8b0:4864:20::342])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0632D2194EB70
 for <linux-nvdimm@lists.01.org>; Tue, 19 Mar 2019 18:35:07 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id c16so677746otn.4
 for <linux-nvdimm@lists.01.org>; Tue, 19 Mar 2019 18:35:07 -0700 (PDT)
MIME-Version: 1.0
References: <155297557534.2276575.16264199708584900090.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155297558570.2276575.11731393787282486177.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1553040398.4899.149.camel@linux.ibm.com>
 <CAPcyv4heLwdJR+xKZfvx5TAvqsKr3sNCda_ovivguLKbiXhyYg@mail.gmail.com>
 <1553044252.4899.165.camel@linux.ibm.com>
In-Reply-To: <1553044252.4899.165.camel@linux.ibm.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 19 Mar 2019 18:34:56 -0700
Message-ID: <CAPcyv4jB0HW8mB_wdMDQ3FO6jW-B-WdTELq2UeM4ZnSienoccQ@mail.gmail.com>
Subject: Re: [PATCH 2/6] security/keys/encrypted: Clean up
 request_trusted_key()
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
To: Mimi Zohar <zohar@linux.ibm.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, James Bottomley <jejb@linux.ibm.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Mar 19, 2019 at 6:11 PM Mimi Zohar <zohar@linux.ibm.com> wrote:
>
> On Tue, 2019-03-19 at 17:20 -0700, Dan Williams wrote:
> > On Tue, Mar 19, 2019 at 5:07 PM Mimi Zohar <zohar@linux.ibm.com> wrote:
> > > On Mon, 2019-03-18 at 23:06 -0700, Dan Williams wrote:
> >
> > > > diff --git a/security/keys/key.c b/security/keys/key.c
> > > > index 696f1c092c50..9045b62afb04 100644
> > > > --- a/security/keys/key.c
> > > > +++ b/security/keys/key.c
> > > > @@ -706,6 +706,7 @@ struct key_type *key_type_lookup(const char *type)
> > > >  found_kernel_type:
> > > >       return ktype;
> > > >  }
> > > > +EXPORT_SYMBOL_GPL(key_type_lookup);
> >
> > This needs to be moved to patch1.
> >
> > > Only the kernel is calling key_type_lookup().  Why does
> > > key_type_lookup() need to be exported?
> >
> > This patch series adds several new callers outside of keys-subsystem
> > core that need this export, the first one being encrypted-keys itself
> > in patch1.
>
> It's needed, because they could be compiled as kernel modules, not
> builtin (eg. EVM).
>

Right, but now I realize a problem. The side effect of having direct
module dependencies to the key_type_{encrypted,trusted} symbols is
that module reference counting is handled automatically.

So, I need to respin this with some explicit try_module_get() and
module_put() added otherwise the encrypted_keys facility can be
removed while active keys are instantiated.

> > drivers/nvdimm/security.c:57:   type = key_type_lookup("encrypted");
> > fs/ecryptfs/keystore.c:1627:    type = key_type_lookup("encrypted");
> > security/integrity/evm/evm_crypto.c:361:        type =
> > key_type_lookup("encrypted");
> > security/keys/encrypted-keys/encrypted.c:440:   type =
> > key_type_lookup("trusted");
> >
>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
