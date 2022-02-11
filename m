Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA762F20
	for <nvdimm@lists.linux.dev>; Fri, 11 Feb 2022 05:07:49 +0000 (UTC)
Received: by mail-yb1-f169.google.com with SMTP id bt13so21757805ybb.2
        for <nvdimm@lists.linux.dev>; Thu, 10 Feb 2022 21:07:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=33X30vxk37dYzlKfVsNBndW9y5tzzn+eqam1oXj5DfU=;
        b=K2t7CEZ+mg5lBHC6Nfm4ggzoDdrPcmY9ShGUEBWXtZTTQvZLFbbgmiiwAsXApjq/AY
         KRFAQR7JAxBB7aEXM2WuPUO/UIgyPUT/tQgHMAeoLiYmhpuj1/e8qLBM2fiqhsCDknYV
         D+d+hTQ6X2sh2NRFUlkpUYpmNGHmihDBR1FiXjy70Mz6t3nageB0Dmfg5QKNSjqCsPt4
         sBVaF1GursnStNLXh4RnDGjCKlzC5erE485WaGp0BbHyCJB3nNnVrFzZk9Gleo8YAGpP
         PijdDg9FS+yJyi5Aa6nhv97RLbRAG34Pg3vU6G2CNRrD5hw6lhV0vzYJa5CAQQad71/+
         Zb4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=33X30vxk37dYzlKfVsNBndW9y5tzzn+eqam1oXj5DfU=;
        b=U9sRekSTXz3p5IVsE57XcAcxqV6shWm6INXC2JXaJKjZD+n2hOaMtfho3L/zivrxsX
         7Ac+QN33pU8dYmnEWfX/U9PutfJlhX1WBERX57I47kq4fuqbMd2KMPbUe8P0rsCH86jZ
         r9wxdVP8SzT64pHAaxsKejphi4Fc6SDf8IfuvkEoyneYB2/4wXpaEkvToPwZYe2mHQHv
         2Pzh7fbhp+ZGmMXhLuXneTQsmwHOcdjmpg5OE9r9gWZXeCr25CwvCct8um0n2FXCtFsS
         F5n/9EWi1yYkIvdoJqbnsEf8LNiHyFvi7pEBYg/6qnFDq7XwsUwt4tzfGKQaMrHqjHhp
         5+UQ==
X-Gm-Message-State: AOAM5305R3JVPTLtXL7kSuZsOoH4wPg3r/MR4lQWB7SH6P7UmnJqgm8Q
	/m7xZya28vfREC8U/4Egkkp4cQwQaXnsOh7fTCCIrA==
X-Google-Smtp-Source: ABdhPJyxIcJRA3uyrQa6x9yxKUYyyPEjOzENFGfmwumjFTCzNfg1VvCaXqVbuX7V1DM5nDMFnV/WYvxy3qDITrJrmbc=
X-Received: by 2002:a81:ef04:: with SMTP id o4mr75353ywm.458.1644556068755;
 Thu, 10 Feb 2022 21:07:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220210193345.23628-1-joao.m.martins@oracle.com> <20220210193345.23628-6-joao.m.martins@oracle.com>
In-Reply-To: <20220210193345.23628-6-joao.m.martins@oracle.com>
From: Muchun Song <songmuchun@bytedance.com>
Date: Fri, 11 Feb 2022 13:07:11 +0800
Message-ID: <CAMZfGtXRPn3MPDpDEyFJJ98E3xTB65Q8_C+P92_XKsL-q8ah=w@mail.gmail.com>
Subject: Re: [PATCH v5 5/5] mm/page_alloc: reuse tail struct pages for
 compound devmaps
To: Joao Martins <joao.m.martins@oracle.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Matthew Wilcox <willy@infradead.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jane Chu <jane.chu@oracle.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, nvdimm@lists.linux.dev, 
	Linux Doc Mailing List <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Feb 11, 2022 at 3:34 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>
> Currently memmap_init_zone_device() ends up initializing 32768 pages
> when it only needs to initialize 128 given tail page reuse. That
> number is worse with 1GB compound pages, 262144 instead of 128. Update
> memmap_init_zone_device() to skip redundant initialization, detailed
> below.
>
> When a pgmap @vmemmap_shift is set, all pages are mapped at a given
> huge page alignment and use compound pages to describe them as opposed
> to a struct per 4K.
>
> With @vmemmap_shift > 0 and when struct pages are stored in ram
> (!altmap) most tail pages are reused. Consequently, the amount of
> unique struct pages is a lot smaller that the total amount of struct
> pages being mapped.
>
> The altmap path is left alone since it does not support memory savings
> based on compound pages devmap.
>
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
>  mm/page_alloc.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index cface1d38093..c10df2fd0ec2 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6666,6 +6666,20 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
>         }
>  }
>
> +/*
> + * With compound page geometry and when struct pages are stored in ram most
> + * tail pages are reused. Consequently, the amount of unique struct pages to
> + * initialize is a lot smaller that the total amount of struct pages being
> + * mapped. This is a paired / mild layering violation with explicit knowledge
> + * of how the sparse_vmemmap internals handle compound pages in the lack
> + * of an altmap. See vmemmap_populate_compound_pages().
> + */
> +static inline unsigned long compound_nr_pages(struct vmem_altmap *altmap,
> +                                             unsigned long nr_pages)
> +{
> +       return !altmap ? 2 * (PAGE_SIZE/sizeof(struct page)) : nr_pages;
> +}
> +

This means only the first 2 pages will be modified, the reset 6 or 4094 pages
do not.  In the HugeTLB case, those tail pages are mapped with read-only
to catch invalid usage on tail pages (e.g. write operations). Quick question:
should we also do similar things on DAX?

Thanks.
