Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121F27C
	for <nvdimm@lists.linux.dev>; Fri,  4 Mar 2022 03:28:42 +0000 (UTC)
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-2d6d0cb5da4so77540647b3.10
        for <nvdimm@lists.linux.dev>; Thu, 03 Mar 2022 19:28:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kFpQ2fl9BPiudhUV8y5441ZRy6sv4V6z39pXXu3M6IE=;
        b=iuDS0eFP5Jh9XEl9/iW/sOEbN7j+1eAeePQNEtM1h8cg9sNlX7dfZj5qwbU894msXH
         Un1AQ9Msv+WSsEd1CNf4qDY3N9Me4GUqh23OPciqNksbI01yz91Kgp3ArHbz7BMtY7D8
         BCgYoucT0TADOorxQThcRs0vKin0NetK1JUnuP0iOhLYo79PbcC4j87zWJbzokKhiaRY
         4V/Y2exvnoYoDZaXfQOGCiVGuNMduMd1Uyw3hmCzUi6zh4y3TriPEn8br1lI3Qj/yReG
         21vRd+okRscbW0j7KkLQ5dbJ2fFjJqCh8vOpRGF3rm2uKIKeUsgq1jtCBl2EDm+jubBi
         a+sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kFpQ2fl9BPiudhUV8y5441ZRy6sv4V6z39pXXu3M6IE=;
        b=TdOoYCxtp+6dpqBJ4PLixrSoscij2cVaZL/QWLRa7wLvZ4hCa0HtNeTEgYXaB1B1Ll
         UHwDG0cXqTcC/z5R9niohzHQJmCnwy4L8lL2cyP/JBoHiosKvsDBd0HIhw8mfzp6ce33
         YcXcv9+RCUo5eJH8laNon0gLXBfzZgIuAjXjLpx527vinb4GYkzPp/IPe6H6F+CQ7bRB
         Szl9jVNEto58+hPI5jU+hPZNPVVy7FikPMpSFe/kAaz3CHi7u9AoKEzEba5tWmfNqmmB
         4ykIAh3feFaQPVW9dv03u1BXgn5IeZDHvzKjntyYFEuI+oonpt5AOGTN9mUC+aH2wnQ3
         twRA==
X-Gm-Message-State: AOAM533PCRiTp2qSs1IuxgJ1X2qPX5seLMu9TV1TdlBBIj01MP4sLcgh
	XxQYxhQKxh6HdE43coa4laI0uXsbDikondCq3owonQ==
X-Google-Smtp-Source: ABdhPJyEC0NXplVx5MpBf9v0KQPpg3egQPFjzDCW0ID8+sJCOLBAvYTXQfQujIk6Sg/QOpINcgHxoWB6y3sH5zjtRsU=
X-Received: by 2002:a0d:f9c5:0:b0:2db:7a9a:b01a with SMTP id
 j188-20020a0df9c5000000b002db7a9ab01amr23372058ywf.458.1646364522024; Thu, 03
 Mar 2022 19:28:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220303213252.28593-1-joao.m.martins@oracle.com> <20220303213252.28593-6-joao.m.martins@oracle.com>
In-Reply-To: <20220303213252.28593-6-joao.m.martins@oracle.com>
From: Muchun Song <songmuchun@bytedance.com>
Date: Fri, 4 Mar 2022 11:27:55 +0800
Message-ID: <CAMZfGtV2-NKPDxvOjCnCzAJCwG_3D3F_CO44iNfOJuwTy3Nirw@mail.gmail.com>
Subject: Re: [PATCH v7 5/5] mm/page_alloc: reuse tail struct pages for
 compound devmaps
To: Joao Martins <joao.m.martins@oracle.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Matthew Wilcox <willy@infradead.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jane Chu <jane.chu@oracle.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, nvdimm@lists.linux.dev, 
	Linux Doc Mailing List <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Mar 4, 2022 at 5:33 AM Joao Martins <joao.m.martins@oracle.com> wrote:
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
> unique struct pages is a lot smaller than the total amount of struct
> pages being mapped.
>
> The altmap path is left alone since it does not support memory savings
> based on compound pages devmap.
>
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>

Reviewed-by: Muchun Song <songmuchun@bytedance.com>

But a nit below.

> ---
>  mm/page_alloc.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index e0c1e6bb09dd..e9282d043cca 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6653,6 +6653,21 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
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
> +       return is_power_of_2(sizeof(struct page)) &&
> +               !altmap ? 2 * (PAGE_SIZE/sizeof(struct page)) : nr_pages;

It is better to add spaces around that '/'.
