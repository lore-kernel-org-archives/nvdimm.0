Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED377A
	for <nvdimm@lists.linux.dev>; Thu, 24 Feb 2022 15:35:18 +0000 (UTC)
Received: by mail-pj1-f51.google.com with SMTP id gl14-20020a17090b120e00b001bc2182c3d5so5715077pjb.1
        for <nvdimm@lists.linux.dev>; Thu, 24 Feb 2022 07:35:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lsQgiVzP1TKRqYLV4++jxmoh8slLiUxtFgCPxjFlY0c=;
        b=vEh5lqRz8JWat204RnHZ/0ZhBBj0V+2xuqju6dJaXTJmcEU99tB7WTFV9jdSqDPAn+
         tska+3AyjJRJRI+jhKV2x/sV72O5+p6Zs8H4KUG2vxu7GI6BVa3KejeE7YrqTldlBF0N
         ZzwAf2Rh7ozrziYm/WgYsbv6B7VQEK/q4u6bqzbcKz+VmqkhLNztedKcnh+GrLeIVP71
         J/XhJYV7fOc80WRJBoQ6Z/2b6XVPXEcytOzncFT4/MBL9q9aHA4sc1Bm9tSU95ZZnR2j
         gwAXPzPQPh7PsqhBbPbcSKzp5zTlfI4J59MuA4wNPiHsEMErZm2p6Kb8uHT51tEbfEp2
         Lcyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lsQgiVzP1TKRqYLV4++jxmoh8slLiUxtFgCPxjFlY0c=;
        b=hyEx+xSNspq5tTBDsd5PoXdeCFWjE1cvjNN/qiU/DZW6a6tu+pP+GWB4Ce3TNEuf84
         vLvdCP6sTJCujR4y0cSCxUtf80tRjbIOEuAW6E73H/KwTa1dt5Fj77WVUDHgyJ64mVtp
         58cYz21THDd25VbFCDzQ2VrNzaKrkGF81nPsUNB1uDD6gWeSqREXkhOX5F4CpJp09oIh
         p+ddmiGKW3JnTvVfmWTtBtyARChmwjppPAXx3vKCbsN+j6f5w4Kjrbaa0F8AtFqxwMlW
         D7CMbH7HiyBggCXgV88HO7ALhRfEpgbJk2F+j7sGcFmTmeszb4cXLlO41Br2cg91UtgZ
         oHBA==
X-Gm-Message-State: AOAM533Jf++mPavtwFkiYUEKJAQVfo21JiNVF/W/51rRp8uDlS2IGY0m
	HyuMXnakcAFXZNlAlFjqGK0JwE1FhxZJFk5GbJCGcQ==
X-Google-Smtp-Source: ABdhPJy7tyw1CeQ6MqBWdqbcfJjWOEGOR64u7KAmeKWWG3aNdoFJVgpLnp9Qs8KNuOg3ROktAH6g5gTrP3v4ENNzOcg=
X-Received: by 2002:a17:902:a404:b0:14b:1100:aebc with SMTP id
 p4-20020a170902a40400b0014b1100aebcmr2988122plq.133.1645716917764; Thu, 24
 Feb 2022 07:35:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220223194807.12070-1-joao.m.martins@oracle.com>
 <20220223194807.12070-5-joao.m.martins@oracle.com> <CAMZfGtXm5pLbTnzMCrWPg8Vm3gykB8XEg5DHFm0z1p1x2fhySQ@mail.gmail.com>
 <25983812-c876-ae82-0125-515500959696@oracle.com>
In-Reply-To: <25983812-c876-ae82-0125-515500959696@oracle.com>
From: Muchun Song <songmuchun@bytedance.com>
Date: Thu, 24 Feb 2022 23:34:41 +0800
Message-ID: <CAMZfGtUFFT2fKCR8jUZkZxVDrh7tLSBhkCFUgifE-EmPvn=iBg@mail.gmail.com>
Subject: Re: [PATCH v6 4/5] mm/sparse-vmemmap: improve memory savings for
 compound devmaps
To: Joao Martins <joao.m.martins@oracle.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Matthew Wilcox <willy@infradead.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jane Chu <jane.chu@oracle.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, nvdimm@lists.linux.dev, 
	Linux Doc Mailing List <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Feb 24, 2022 at 7:47 PM Joao Martins <joao.m.martins@oracle.com> wrote:
>
> On 2/24/22 05:54, Muchun Song wrote:
> > On Thu, Feb 24, 2022 at 3:48 AM Joao Martins <joao.m.martins@oracle.com> wrote:
> >> diff --git a/include/linux/mm.h b/include/linux/mm.h
> >> index 5f549cf6a4e8..b0798b9c6a6a 100644
> >> --- a/include/linux/mm.h
> >> +++ b/include/linux/mm.h
> >> @@ -3118,7 +3118,7 @@ p4d_t *vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node);
> >>  pud_t *vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node);
> >>  pmd_t *vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node);
> >>  pte_t *vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
> >> -                           struct vmem_altmap *altmap);
> >> +                           struct vmem_altmap *altmap, struct page *block);
> >
> > Have forgotten to update @block to @reuse here.
> >
>
> Fixed.
>
> > [...]
> >> +
> >> +static int __meminit vmemmap_populate_range(unsigned long start,
> >> +                                           unsigned long end,
> >> +                                           int node, struct page *page)
> >
> > All of the users are passing a valid parameter of @page. This function
> > will populate the vmemmap with the @page
>
> Yeap.
>
> > and without memory
> > allocations. So the @node parameter seems to be unnecessary.
> >
> I am a little bit afraid of making this logic more fragile by removing node.
> When we populate the the tail vmemmap pages, we *may need* to populate a new PMD page
> . And we need the @node for those or anything preceeding that (even though it's highly
> unlikely). It's just the PTE reuse that doesn't need node :(

Agree. So I suggest adding @altmap to vmemmap_populate_range() like
you have done as follows.

>
> > If you want to make this function more generic like
> > vmemmap_populate_address() to handle memory allocations
> > (the case of @page == NULL). I think vmemmap_populate_range()
> > should add another parameter of `struct vmem_altmap *altmap`.
>
> Oh, that's a nice cleanup/suggestion. I've moved vmemmap_populate_range() to be
> used by vmemmap_populate_basepages(), and delete the duplication. I'll
> adjust the second patch for this cleanup, to avoid moving the same code
> over again between the two patches. I'll keep your Rb in the second patch, this is
> the diff to this version:
>
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index 44cb77523003..1b30a82f285e 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -637,8 +637,9 @@ static pte_t * __meminit vmemmap_populate_address(unsigned long addr,
> int node,
>         return pte;
>  }
>
> -int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
> -                                        int node, struct vmem_altmap *altmap)
> +static int __meminit vmemmap_populate_range(unsigned long start,
> +                                           unsigned long end, int node,
> +                                           struct vmem_altmap *altmap)
>  {
>         unsigned long addr = start;
>         pte_t *pte;
> @@ -652,6 +653,12 @@ int __meminit vmemmap_populate_basepages(unsigned long start,
> unsigned long end,
>         return 0;
>  }
>
> +int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
> +                                        int node, struct vmem_altmap *altmap)
> +{
> +       return vmemmap_populate_range(start, end, node, altmap);
> +}
> +
>  struct page * __meminit __populate_section_memmap(unsigned long pfn,
>                 unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
>                 struct dev_pagemap *pgmap)
>
> Meanwhile I'll adjust the other callers of vmemmap_populate_range() in this patch.

LGTM.

>
> > Otherwise, is it better to remove @node and rename @page to @reuse?
>
> I've kept the @node for now, due to the concern explained earlier, but
> renamed vmemmap_populate_range() to have its new argument be named @reuse.

Make sense.
