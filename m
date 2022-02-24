Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6355D1373
	for <nvdimm@lists.linux.dev>; Thu, 24 Feb 2022 05:55:33 +0000 (UTC)
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-2d66f95f1d1so14038367b3.0
        for <nvdimm@lists.linux.dev>; Wed, 23 Feb 2022 21:55:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kvhU+1d1xBuiwuTvVQmOP1FBfYrMuzDuvR5ypoAEjro=;
        b=CEt6WoNPJExnK4pZ3D56UCeA564FCpoElTbHUG7guQrxewH8Ef4bcrKv615NXBRlGg
         vBtPBeEeoQNZU2567HdocwW4qpALbKec2QFSlYDInWSsnOW9/wYQI+frra60lxHZ7ej6
         KA492jINm/YiiL6pOlnXDFLQiP7GcwKeFrkBl20tJ3fcDCto8o94c472V781OracUOuN
         UBhtq3m3eMFoVLMR7ZohfgfjkR04+UvHT35hf/wePMDEOiF2kkqpub3oDeKVbp51W+Wn
         BnexbEPlDwQhzil3kFMp4DDSV2lqRwKClXc4VIDKzeyVgImJeXRENSj9cnUzXqXJnxun
         uY2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kvhU+1d1xBuiwuTvVQmOP1FBfYrMuzDuvR5ypoAEjro=;
        b=2+vSBUiQztFtf3d3rKyIOi5GKxf+ST7DVWje0Ooxse/OYFIE43Vtn+1sYWsKKe9qEK
         6lwaTchSbr7YsMhMfiUUs8xBWQWTiFMYmdc7YWiRpfMngrZuLDMKj8eUmlAnIz+mTRRc
         4Nlqjp5wJ7GGLo+XsJ0HAWYBQih7j5LoI5RauJCXAHypWKf4xluNbqnga4ri2Gl3miFh
         fTzBh4zhwdZap/dDuSwk2RxV2KYuuUqUi76NtJx2tDq82PI9ee7RlrcHya/duve1gZfe
         i1mJ4L8ra6+WyBQPsCrFQIAhSgUbvMyzg0VEqzT1fCqdYjym7fAH/VapworuiGVWhor7
         4fZw==
X-Gm-Message-State: AOAM53217esJqX+XrCIauTp/FLNJVAvK9vBdbpDRRS8noZ6sEVs5K62E
	eN+fXL0u7IXewmDSN/uqFr+P/ULQ0bK6p01Gf/wuJg==
X-Google-Smtp-Source: ABdhPJxQBX3Dc+MjzYS5ebkRBFbDibF6wIJL7Bn+424LeZUsSwel/NdC9XRIpxfLvof5dstbTtuwpAn4KzhMnTIfxz8=
X-Received: by 2002:a81:5dd6:0:b0:2d6:3041:12e0 with SMTP id
 r205-20020a815dd6000000b002d6304112e0mr976524ywb.331.1645682132153; Wed, 23
 Feb 2022 21:55:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220223194807.12070-1-joao.m.martins@oracle.com> <20220223194807.12070-5-joao.m.martins@oracle.com>
In-Reply-To: <20220223194807.12070-5-joao.m.martins@oracle.com>
From: Muchun Song <songmuchun@bytedance.com>
Date: Thu, 24 Feb 2022 13:54:54 +0800
Message-ID: <CAMZfGtXm5pLbTnzMCrWPg8Vm3gykB8XEg5DHFm0z1p1x2fhySQ@mail.gmail.com>
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

On Thu, Feb 24, 2022 at 3:48 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>
> A compound devmap is a dev_pagemap with @vmemmap_shift > 0 and it
> means that pages are mapped at a given huge page alignment and utilize
> uses compound pages as opposed to order-0 pages.
>
> Take advantage of the fact that most tail pages look the same (except
> the first two) to minimize struct page overhead. Allocate a separate
> page for the vmemmap area which contains the head page and separate for
> the next 64 pages. The rest of the subsections then reuse this tail
> vmemmap page to initialize the rest of the tail pages.
>
> Sections are arch-dependent (e.g. on x86 it's 64M, 128M or 512M) and
> when initializing compound devmap with big enough @vmemmap_shift (e.g.
> 1G PUD) it may cross multiple sections. The vmemmap code needs to
> consult @pgmap so that multiple sections that all map the same tail
> data can refer back to the first copy of that data for a given
> gigantic page.
>
> On compound devmaps with 2M align, this mechanism lets 6 pages be
> saved out of the 8 necessary PFNs necessary to set the subsection's
> 512 struct pages being mapped. On a 1G compound devmap it saves
> 4094 pages.
>
> Altmap isn't supported yet, given various restrictions in altmap pfn
> allocator, thus fallback to the already in use vmemmap_populate().  It
> is worth noting that altmap for devmap mappings was there to relieve the
> pressure of inordinate amounts of memmap space to map terabytes of pmem.
> With compound pages the motivation for altmaps for pmem gets reduced.
>
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
[...]
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 5f549cf6a4e8..b0798b9c6a6a 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3118,7 +3118,7 @@ p4d_t *vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node);
>  pud_t *vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node);
>  pmd_t *vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node);
>  pte_t *vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
> -                           struct vmem_altmap *altmap);
> +                           struct vmem_altmap *altmap, struct page *block);

Have forgotten to update @block to @reuse here.

[...]
> +
> +static int __meminit vmemmap_populate_range(unsigned long start,
> +                                           unsigned long end,
> +                                           int node, struct page *page)

All of the users are passing a valid parameter of @page. This function
will populate the vmemmap with the @page and without memory
allocations. So the @node parameter seems to be unnecessary.

If you want to make this function more generic like
vmemmap_populate_address() to handle memory allocations
(the case of @page == NULL). I think vmemmap_populate_range()
should add another parameter of `struct vmem_altmap *altmap`.
Otherwise, is it better to remove @node and rename @page to @reuse?

Thanks.
