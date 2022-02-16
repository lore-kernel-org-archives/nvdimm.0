Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 064331B69
	for <nvdimm@lists.linux.dev>; Wed, 16 Feb 2022 03:09:12 +0000 (UTC)
Received: by mail-pl1-f173.google.com with SMTP id y18so924465plb.11
        for <nvdimm@lists.linux.dev>; Tue, 15 Feb 2022 19:09:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=k7acGQ+aoEgDpTruS21+hEnSk9frdpzFJnwztD0cF2g=;
        b=hNE5p/Jo5xvwKQMU14u/yTNHol24XinfEBPd0Xnkxx8ckko4WXoFz8bpeB/FIumjPj
         vCYmfonysPB1PYbjzSO8rGqKsshAXZl+chAocxjI/LgI+ScIrFr1zVkj9o6FHx2QLqcU
         MZpp/uX3NB6q3uSF+zs0RUw8FgNRIDAvUDfBMb9xplYZ+DMkaUzDvPqkJ3DmUp4yxBpx
         YHBa7WvldPJF321ZSnrRJGCNkeQFvKbacsQoZdjjc/nCNkR0TsapOD+/7ExjAEbdD3Ow
         1+uNI99qHAm2pHuLdJuysPYCQcc2to7OVPDLrq02dFyiziZ54eFI/aIf8H3oJH307IW/
         QIIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=k7acGQ+aoEgDpTruS21+hEnSk9frdpzFJnwztD0cF2g=;
        b=1+CClNCwBFE1Pcn7SABcQa/JaSzGGF59eXzb/IdtLow5stOVoCmPTjb6QgtWlguk35
         YOTt/AwJuOg3NF9SbcBT36HHUyoUcD12WJfRwhSebfQTho1xJkGsto41kpvHktAwvrEI
         3I+99p8ZT685JbysbgkMpwbEE+M31Wx+oBSwMTxaRldwyb9xgIb7zp+flhXjTZJ+kl4Y
         IfrzzVMHNJe429Hj6viIRyBn1qm+hVWWpsEkiAdTthpBLp//QBFqVlPMZqURACG154/X
         zQJDnXZJR/CMDnC9L2nzNpQeFsSlyOUcb+Pmg5AjX5VDsQ3p+W1BIRsUZYEYqo/qOZvL
         lIGw==
X-Gm-Message-State: AOAM531P2zcqvjCeZXnLdxNWQXvj80R4DW3Bbmp165OgKvWnHu4s5YhV
	j/AZExryt5z2RcaRNiBBF3I7y7o79XBU4XRTfolP1w==
X-Google-Smtp-Source: ABdhPJxAp+sSnyv767mDuMDX/8tJW2jOYmiVjf2IgQHEv02eYqaN3IQQZHeRuIl68bmli9Ok0+bdx7i1Re2Il51WFsw=
X-Received: by 2002:a17:90a:f28d:b0:1b9:975f:1a9f with SMTP id
 fs13-20020a17090af28d00b001b9975f1a9fmr591684pjb.220.1644980952458; Tue, 15
 Feb 2022 19:09:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220127124058.1172422-1-ruansy.fnst@fujitsu.com>
 <20220127124058.1172422-10-ruansy.fnst@fujitsu.com> <CAPcyv4iTO55BX+_v2yHRBjSppPgT23JsHg-Oagb6RwHMj-W+Ug@mail.gmail.com>
 <ff0f0d8c-a4a3-6dbf-8358-67c3bb11c2d6@fujitsu.com>
In-Reply-To: <ff0f0d8c-a4a3-6dbf-8358-67c3bb11c2d6@fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 15 Feb 2022 19:09:01 -0800
Message-ID: <CAPcyv4h7zVYu7K3j2JNEd7jTHJRvVDwqhhRCBbq6ru4+QGY9Hg@mail.gmail.com>
Subject: Re: [PATCH v10 9/9] fsdax: set a CoW flag when associate reflink mappings
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Linux MM <linux-mm@kvack.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, 
	david <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, Jane Chu <jane.chu@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 15, 2022 at 6:55 PM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrot=
e:
>
>
>
> =E5=9C=A8 2022/2/16 10:09, Dan Williams =E5=86=99=E9=81=93:
> > On Thu, Jan 27, 2022 at 4:41 AM Shiyang Ruan <ruansy.fnst@fujitsu.com> =
wrote:
> >>
> >> Introduce a PAGE_MAPPING_DAX_COW flag to support association with CoW =
file
> >> mappings.  In this case, the dax-RMAP already takes the responsibility
> >> to look up for shared files by given dax page.  The page->mapping is n=
o
> >> longer to used for rmap but for marking that this dax page is shared.
> >> And to make sure disassociation works fine, we use page->index as
> >> refcount, and clear page->mapping to the initial state when page->inde=
x
> >> is decreased to 0.
> >>
> >> With the help of this new flag, it is able to distinguish normal case
> >> and CoW case, and keep the warning in normal case.
> >>
> >> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> >> ---
> >>   fs/dax.c                   | 65 ++++++++++++++++++++++++++++++++----=
--
> >>   include/linux/page-flags.h |  6 ++++
> >>   2 files changed, 62 insertions(+), 9 deletions(-)
> >>
> >> diff --git a/fs/dax.c b/fs/dax.c
> >> index 250794a5b789..88879c579c1f 100644
> >> --- a/fs/dax.c
> >> +++ b/fs/dax.c
> >> @@ -334,13 +334,46 @@ static unsigned long dax_end_pfn(void *entry)
> >>          for (pfn =3D dax_to_pfn(entry); \
> >>                          pfn < dax_end_pfn(entry); pfn++)
> >>
> >> +static inline void dax_mapping_set_cow_flag(struct address_space *map=
ping)
> >> +{
> >> +       mapping =3D (struct address_space *)PAGE_MAPPING_DAX_COW;
> >> +}
> >> +
> >> +static inline bool dax_mapping_is_cow(struct address_space *mapping)
> >> +{
> >> +       return (unsigned long)mapping =3D=3D PAGE_MAPPING_DAX_COW;
> >> +}
> >> +
> >>   /*
> >> - * TODO: for reflink+dax we need a way to associate a single page wit=
h
> >> - * multiple address_space instances at different linear_page_index()
> >> - * offsets.
> >> + * Set or Update the page->mapping with FS_DAX_MAPPING_COW flag.
> >> + * Return true if it is an Update.
> >> + */
> >> +static inline bool dax_mapping_set_cow(struct page *page)
> >> +{
> >> +       if (page->mapping) {
> >> +               /* flag already set */
> >> +               if (dax_mapping_is_cow(page->mapping))
> >> +                       return false;
> >> +
> >> +               /*
> >> +                * This page has been mapped even before it is shared,=
 just
> >> +                * need to set this FS_DAX_MAPPING_COW flag.
> >> +                */
> >> +               dax_mapping_set_cow_flag(page->mapping);
> >> +               return true;
> >> +       }
> >> +       /* Newly associate CoW mapping */
> >> +       dax_mapping_set_cow_flag(page->mapping);
> >> +       return false;
> >> +}
> >> +
> >> +/*
> >> + * When it is called in dax_insert_entry(), the cow flag will indicat=
e that
> >> + * whether this entry is shared by multiple files.  If so, set the pa=
ge->mapping
> >> + * to be FS_DAX_MAPPING_COW, and use page->index as refcount.
> >>    */
> >>   static void dax_associate_entry(void *entry, struct address_space *m=
apping,
> >> -               struct vm_area_struct *vma, unsigned long address)
> >> +               struct vm_area_struct *vma, unsigned long address, boo=
l cow)
> >>   {
> >>          unsigned long size =3D dax_entry_size(entry), pfn, index;
> >>          int i =3D 0;
> >> @@ -352,9 +385,17 @@ static void dax_associate_entry(void *entry, stru=
ct address_space *mapping,
> >>          for_each_mapped_pfn(entry, pfn) {
> >>                  struct page *page =3D pfn_to_page(pfn);
> >>
> >> -               WARN_ON_ONCE(page->mapping);
> >> -               page->mapping =3D mapping;
> >> -               page->index =3D index + i++;
> >> +               if (cow) {
> >> +                       if (dax_mapping_set_cow(page)) {
> >> +                               /* Was normal, now updated to CoW */
> >> +                               page->index =3D 2;
> >> +                       } else
> >> +                               page->index++;
> >> +               } else {
> >> +                       WARN_ON_ONCE(page->mapping);
> >> +                       page->mapping =3D mapping;
> >> +                       page->index =3D index + i++;
> >> +               }
> >>          }
> >>   }
> >>
> >> @@ -370,7 +411,12 @@ static void dax_disassociate_entry(void *entry, s=
truct address_space *mapping,
> >>                  struct page *page =3D pfn_to_page(pfn);
> >>
> >>                  WARN_ON_ONCE(trunc && page_ref_count(page) > 1);
> >> -               WARN_ON_ONCE(page->mapping && page->mapping !=3D mappi=
ng);
> >> +               if (!dax_mapping_is_cow(page->mapping)) {
> >> +                       /* keep the CoW flag if this page is still sha=
red */
> >> +                       if (page->index-- > 0)
> >> +                               continue;
> >> +               } else
> >> +                       WARN_ON_ONCE(page->mapping && page->mapping !=
=3D mapping);
> >>                  page->mapping =3D NULL;
> >>                  page->index =3D 0;
> >>          }
> >> @@ -810,7 +856,8 @@ static void *dax_insert_entry(struct xa_state *xas=
,
> >>                  void *old;
> >>
> >>                  dax_disassociate_entry(entry, mapping, false);
> >> -               dax_associate_entry(new_entry, mapping, vmf->vma, vmf-=
>address);
> >> +               dax_associate_entry(new_entry, mapping, vmf->vma, vmf-=
>address,
> >> +                               false);
> >
> > Where is the caller that passes 'true'? Also when that caller arrives
> > introduce a separate dax_associate_cow_entry() as that's easier to
> > read than dax_associate_entry(..., true) in case someone does not
> > remember what that boolean flag means.
>
> This flag is supposed to be used when CoW support is introduced.

Ok, so should this patch wait and be a part of that series? It's
otherwise confusing to introduce a new capability in a patch set and
not take advantage of it until a separate / later patch set.

> When
> it is a CoW operation, which is decided by iomap & srcmap's flag, this
> flag will be set true.
>
> I think I should describe it in detail in the commit message.

That could help, or move it to the COW support series.

> > However, it's not clear to me that this approach is a good idea given
> > that the filesystem is the source of truth for how many address_spaces
> > this page mapping might be duplicated. What about a iomap_page_ops for
> > fsdax to ask the filesystem when it is ok to clear the mapping
> > association for a page?
>
> I'll think how to implement it in this way.
>
>
> --
> Thanks,
> Ruan.
>
> >
> >>                  /*
> >>                   * Only swap our new entry into the page cache if the=
 current
> >>                   * entry is a zero page or an empty entry.  If a norm=
al PTE or
> >> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> >> index 1c3b6e5c8bfd..6370d279795a 100644
> >> --- a/include/linux/page-flags.h
> >> +++ b/include/linux/page-flags.h
> >> @@ -572,6 +572,12 @@ __PAGEFLAG(Reported, reported, PF_NO_COMPOUND)
> >>   #define PAGE_MAPPING_KSM       (PAGE_MAPPING_ANON | PAGE_MAPPING_MOV=
ABLE)
> >>   #define PAGE_MAPPING_FLAGS     (PAGE_MAPPING_ANON | PAGE_MAPPING_MOV=
ABLE)
> >>
> >> +/*
> >> + * Different with flags above, this flag is used only for fsdax mode.=
  It
> >> + * indicates that this page->mapping is now under reflink case.
> >> + */
> >> +#define PAGE_MAPPING_DAX_COW   0x1
> >> +
> >>   static __always_inline int PageMappingFlags(struct page *page)
> >>   {
> >>          return ((unsigned long)page->mapping & PAGE_MAPPING_FLAGS) !=
=3D 0;
> >> --
> >> 2.34.1
> >>
> >>
> >>
>
>
