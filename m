Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CCB13481
	for <nvdimm@lists.linux.dev>; Wed, 28 Jul 2021 07:28:36 +0000 (UTC)
Received: by mail-pj1-f43.google.com with SMTP id l19so3923368pjz.0
        for <nvdimm@lists.linux.dev>; Wed, 28 Jul 2021 00:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XS+VOHsvs0BDMQ7Od7Fj7wB7ploLT17zyS/Mm8uN2pI=;
        b=RBLhKPAQEl0F2Gk7RblrUV+/XCohL9gpRhVzsIVxCyc2DQdzWvvn+jvewaDvvFRanB
         vWcFL1JvXet7/7l75wRmtYp/zc4Et3/PNEzBvYmNp50wGUyvqSTdgEQGuONOUfI+KupC
         BzOYxi77TmxMxOf8FX9rJQ//sH/7NAwcBWEQjWi1ea7LbKbaTqmZr2KpAkT57AUeTcLY
         Z9FBgQKtSv7CU1syxDHaCTjmPHB2gFMVmbTMovy0nDukAB52Vs/qRIPdXhz6zDmxyfWq
         m1RqLviDyyL+TcMGX1isOUz0C3Qxrb67xq06SXpDMFgU1jn5c5eMmG5I1fdMU9ko9kMX
         uAfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XS+VOHsvs0BDMQ7Od7Fj7wB7ploLT17zyS/Mm8uN2pI=;
        b=H3nW1jAyVtRJC4KwPb6KaeYBeDGtU1XWfHhrP9J51hOLlXRddzdmLXNUHeE5CRR/fD
         Xkx9poLFH08RTL6Rzs1w1j/9jzF7A30eiqMDCpeIwFH/YcxUCmJTS+jrXgDCPQE+rCw/
         RGCMSAx9m6RVeRbnSWsH2GwL1p9M+LbICxt2rWAKn8FI4PbzM7IbRCi381SuEMg7YnoC
         d7oHqDK0k1UHb310eQ8U+/eHiRut2shMUt8RvEil3VqSRHe1aQkId9nis1qs3nbjPJIZ
         sni11fEn8RcoIEHdQKj6nQ4D5NclUo8vhC7zJPhlysd3fzl3ty3c3Gx49gffA/2hUIGA
         vWzw==
X-Gm-Message-State: AOAM533TdNy/RIjQV9O7vuGnZzkr0GY7ukxlddB/yrQENXhrTQ61DfSk
	DKrkkntB1cGyV4UEnbqSF17bXzjT5WEXtDEFvqozZg==
X-Google-Smtp-Source: ABdhPJyJtFyGQxkovKsEPZbhRVYmu725P6VFThFRtFpV9oE1g4j6NFPrbbDX1aS5MD11jQfv3A+alKdgHAyZJ9Q0EG0=
X-Received: by 2002:a05:6a00:d53:b029:32a:2db6:1be3 with SMTP id
 n19-20020a056a000d53b029032a2db61be3mr26523778pfv.71.1627457315925; Wed, 28
 Jul 2021 00:28:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210714193542.21857-1-joao.m.martins@oracle.com> <20210714193542.21857-10-joao.m.martins@oracle.com>
In-Reply-To: <20210714193542.21857-10-joao.m.martins@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 28 Jul 2021 00:28:25 -0700
Message-ID: <CAPcyv4gDndA612+1BKZcR518K_Rt3Q1gWpqK24KOqvoFp_PNGg@mail.gmail.com>
Subject: Re: [PATCH v3 09/14] mm/page_alloc: reuse tail struct pages for
 compound pagemaps
To: Joao Martins <joao.m.martins@oracle.com>
Cc: Linux MM <linux-mm@kvack.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Naoya Horiguchi <naoya.horiguchi@nec.com>, 
	Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
	Jane Chu <jane.chu@oracle.com>, Muchun Song <songmuchun@bytedance.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Doc Mailing List <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, Jul 14, 2021 at 12:36 PM Joao Martins <joao.m.martins@oracle.com> wrote:
>
> Currently memmap_init_zone_device() ends up initializing 32768 pages
> when it only needs to initialize 128 given tail page reuse. That
> number is worse with 1GB compound page geometries, 262144 instead of
> 128. Update memmap_init_zone_device() to skip redundant
> initialization, detailed below.
>
> When a pgmap @geometry is set, all pages are mapped at a given huge page
> alignment and use compound pages to describe them as opposed to a
> struct per 4K.
>
> With @geometry > PAGE_SIZE and when struct pages are stored in ram
> (!altmap) most tail pages are reused. Consequently, the amount of unique
> struct pages is a lot smaller that the total amount of struct pages
> being mapped.
>
> The altmap path is left alone since it does not support memory savings
> based on compound pagemap geometries.
>
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
>  mm/page_alloc.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 188cb5f8c308..96975edac0a8 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6600,11 +6600,23 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
>  static void __ref memmap_init_compound(struct page *page, unsigned long pfn,
>                                         unsigned long zone_idx, int nid,
>                                         struct dev_pagemap *pgmap,
> +                                       struct vmem_altmap *altmap,
>                                         unsigned long nr_pages)
>  {
>         unsigned int order_align = order_base_2(nr_pages);
>         unsigned long i;
>
> +       /*
> +        * With compound page geometry and when struct pages are stored in ram
> +        * (!altmap) most tail pages are reused. Consequently, the amount of
> +        * unique struct pages to initialize is a lot smaller that the total
> +        * amount of struct pages being mapped.
> +        * See vmemmap_populate_compound_pages().
> +        */
> +       if (!altmap)
> +               nr_pages = min_t(unsigned long, nr_pages,

What's the scenario where nr_pages is < 128? Shouldn't alignment
already be guaranteed?

> +                                2 * (PAGE_SIZE/sizeof(struct page)));


> +
>         __SetPageHead(page);
>
>         for (i = 1; i < nr_pages; i++) {
> @@ -6657,7 +6669,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
>                         continue;
>
>                 memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
> -                                    pfns_per_compound);
> +                                    altmap, pfns_per_compound);

This feels odd, memmap_init_compound() doesn't really care about
altmap, what do you think about explicitly calculating the parameters
that memmap_init_compound() needs and passing them in?

Not a strong requirement to change, but take another look at let me know.



>         }
>
>         pr_info("%s initialised %lu pages in %ums\n", __func__,
> --
> 2.17.1
>
