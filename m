Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com
 [IPv6:2607:f8b0:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C7287211D56C7
 for <linux-nvdimm@lists.01.org>; Wed, 20 Mar 2019 08:27:56 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id c18so2433968otl.13
 for <linux-nvdimm@lists.01.org>; Wed, 20 Mar 2019 08:27:56 -0700 (PDT)
MIME-Version: 1.0
References: <155297557534.2276575.16264199708584900090.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155297558570.2276575.11731393787282486177.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1553040398.4899.149.camel@linux.ibm.com>
 <CAPcyv4heLwdJR+xKZfvx5TAvqsKr3sNCda_ovivguLKbiXhyYg@mail.gmail.com>
 <1553049331.4899.177.camel@linux.ibm.com>
 <CAPcyv4gySHayfwtp1PgxEoM-T_s_1A4RTcnXefx5iRLn9g=D5w@mail.gmail.com>
 <1553083579.4899.239.camel@linux.ibm.com>
In-Reply-To: <1553083579.4899.239.camel@linux.ibm.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 20 Mar 2019 08:27:45 -0700
Message-ID: <CAPcyv4jJMvzPnthHi=2qnXF3XanSk9j_WAMiiA2UP1tTyFJyxQ@mail.gmail.com>
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

On Wed, Mar 20, 2019 at 5:07 AM Mimi Zohar <zohar@linux.ibm.com> wrote:
>
> On Tue, 2019-03-19 at 22:48 -0700, Dan Williams wrote:
> > On Tue, Mar 19, 2019 at 7:36 PM Mimi Zohar <zohar@linux.ibm.com> wrote:
> > >
> > > On Tue, 2019-03-19 at 17:20 -0700, Dan Williams wrote:
> > > > On Tue, Mar 19, 2019 at 5:07 PM Mimi Zohar <zohar@linux.ibm.com> wrote:
> > > > >
> > > > > On Mon, 2019-03-18 at 23:06 -0700, Dan Williams wrote:
> > > > >
> > > > > < snip >
> > > > >
> > > > > > +/*
> > > > > > + * request_trusted_key - request the trusted key
> > > > > > + *
> > > > > > + * Trusted keys are sealed to PCRs and other metadata. Although userspace
> > > > > > + * manages both trusted/encrypted key-types, like the encrypted key type
> > > > > > + * data, trusted key type data is not visible decrypted from userspace.
> > > > > > + */
> > > > > > +static struct key *request_trusted_key(const char *trusted_desc,
> > > > > > +                             const u8 **master_key, size_t *master_keylen)
> > > > > > +{
> > > > > > +     struct trusted_key_payload *tpayload;
> > > > > > +     struct key_type *type;
> > > > > > +     struct key *tkey;
> > > > > > +
> > > > > > +     type = key_type_lookup("trusted");
> > > > >
> > > > > The associated key_type_put() will need to be called.
> > > >
> > > > Yes.
> > >
> > > I don't know if defining a key_type_lookup() wrapper, perhaps named
> > > is_key_type_available(), would help.  Both key_type_lookup() and
> > > key_type_put() would be called.  The existing code could then remain
> > > the same.
> > >
> >
> > Maybe, but something still needs to pin the hosting module. I think
> > this means that the first call to key_type->instantiate() pins the
> > hosting module, and the ->destroy() of the last key for the key_type
> > unpins the module. It does mean that the ->destroy() method is no
> > longer optional.
>
> This sounds like it isn't a new problem.  Both issues need to be
> addressed, but I think we should differentiate between them and
> address them separately.
>
> In terms of the original nvdimm encrypted/trusted key problem, the
> above suggestion requires the least amount of change.  For v5.2, I
> would replace it with the full updated patch set.

I believe smallest amount of change is this single patch:

https://patchwork.kernel.org/patch/10858649/
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
