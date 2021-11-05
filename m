Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94BA72C85
	for <nvdimm@lists.linux.dev>; Fri,  5 Nov 2021 00:38:29 +0000 (UTC)
Received: by mail-pj1-f54.google.com with SMTP id n36-20020a17090a5aa700b0019fa884ab85so2132948pji.5
        for <nvdimm@lists.linux.dev>; Thu, 04 Nov 2021 17:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gXZfe3XSvkmz9Zv7oXVc/KDwWDYooAVUt2M4nCNJbcc=;
        b=kn0Y9XtYZc0iLme7QWMO1kowXA7MhRt+pKJzO7g20Az1fuZ5rJ4WLvd1UZWHT4T7cS
         /gQ/l35vjzkfloXPkNISuDvmpFt5VJ0mRfrCsLd6Y45J5UfdLLQKQg6+S5B61PB9Mera
         tTOGX6vSiyIvHJ798LZGkIIp7bDuqD1kbnKXb+cwnt4cqdVfWJb38HnlJPxvNV+kM5gm
         feHMyMqq1cU0hK9c68xEiCnsiO7hofAl64CfdLLxc5Wg0qWHYBCGL9nEGCfzJSfBnuuD
         v0D5uFLyLeuJh11o/EVwSIcDC49AAnOIuDeC+nO7G7sTb+DxRxizUTwyXobdDJmzpZ6v
         YdgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gXZfe3XSvkmz9Zv7oXVc/KDwWDYooAVUt2M4nCNJbcc=;
        b=njpD+2sIvNrEi1ci2OmrWl/PYQJmp83s0SwiG9Z95zgfW212FJZ8R3RHbM8Oe50AWq
         dLgsWshEJeU9xNkbOrqeqnfhprTZcg9NgZccxRIS/A92r89LysdnIx4i06iGq8iU6ABQ
         uP7A0obaYS4plP9U1EyT9PXeKZz8rQr0hqf0q2nuAmXEaDQq9iiOxpDAVU8d9RT5JsCc
         ENjb19R/oQjMYzBNh1xjU3YRmi+9Zi2HbafyrGnzwdIGL+Nz+3lbRCvIktU5HxuYq04q
         x3aneEL9wwlArW2Arit+uDpfUDVyapqgAOh9GZFi3c+149sxdu88K+ziCkE/dZttYRPF
         iU3w==
X-Gm-Message-State: AOAM531kTTx4PE/wj+cu78KW1gaFOueVVyXFnzx3qIVgelHxcf6TcRk4
	4ZIFNQhz2RFXK+N9yZSKK7ZjEnxqMal6GaYnoTQP8w==
X-Google-Smtp-Source: ABdhPJxOY0u0oFlQSBrEPoQcgRxWjHiAZmPve42mZm7G1Upa9WD5C1B0BnCbKl6KC2SF6AsknOdKTn8ee4+tmTmcvNU=
X-Received: by 2002:a17:902:b697:b0:141:c7aa:e10f with SMTP id
 c23-20020a170902b69700b00141c7aae10fmr35230738pls.18.1636072708803; Thu, 04
 Nov 2021 17:38:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210827145819.16471-1-joao.m.martins@oracle.com> <20210827145819.16471-8-joao.m.martins@oracle.com>
In-Reply-To: <20210827145819.16471-8-joao.m.martins@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 4 Nov 2021 17:38:19 -0700
Message-ID: <CAPcyv4jqdPaLPOydb_GWvVP4d+hRkcu7CnP_Ud-CQXHcqTLWKw@mail.gmail.com>
Subject: Re: [PATCH v4 07/14] device-dax: compound devmap support
To: Joao Martins <joao.m.martins@oracle.com>
Cc: Linux MM <linux-mm@kvack.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Naoya Horiguchi <naoya.horiguchi@nec.com>, 
	Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
	Jane Chu <jane.chu@oracle.com>, Muchun Song <songmuchun@bytedance.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Doc Mailing List <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Aug 27, 2021 at 7:59 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>
> Use the newly added compound devmap facility which maps the assigned dax
> ranges as compound pages at a page size of @align. Currently, this means,
> that region/namespace bootstrap would take considerably less, given that
> you would initialize considerably less pages.
>
> On setups with 128G NVDIMMs the initialization with DRAM stored struct
> pages improves from ~268-358 ms to ~78-100 ms with 2M pages, and to less
> than a 1msec with 1G pages.
>
> dax devices are created with a fixed @align (huge page size) which is
> enforced through as well at mmap() of the device. Faults, consequently
> happen too at the specified @align specified at the creation, and those
> don't change through out dax device lifetime.

s/through out/throughout/

> MCEs poisons a whole dax huge page, as well as splits occurring at the configured page size.

A clarification here, MCEs trigger memory_failure() to *unmap* a whole
dax huge page, the poison stays limited to a single cacheline.

Otherwise the patch looks good to me.

>
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
>  drivers/dax/device.c | 56 ++++++++++++++++++++++++++++++++++----------
>  1 file changed, 43 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/dax/device.c b/drivers/dax/device.c
> index 6e348b5f9d45..5d23128f9a60 100644
> --- a/drivers/dax/device.c
> +++ b/drivers/dax/device.c
> @@ -192,6 +192,42 @@ static vm_fault_t __dev_dax_pud_fault(struct dev_dax *dev_dax,
>  }
>  #endif /* !CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
>
> +static void set_page_mapping(struct vm_fault *vmf, pfn_t pfn,
> +                            unsigned long fault_size,
> +                            struct address_space *f_mapping)
> +{
> +       unsigned long i;
> +       pgoff_t pgoff;
> +
> +       pgoff = linear_page_index(vmf->vma, ALIGN(vmf->address, fault_size));
> +
> +       for (i = 0; i < fault_size / PAGE_SIZE; i++) {
> +               struct page *page;
> +
> +               page = pfn_to_page(pfn_t_to_pfn(pfn) + i);
> +               if (page->mapping)
> +                       continue;
> +               page->mapping = f_mapping;
> +               page->index = pgoff + i;
> +       }
> +}
> +
> +static void set_compound_mapping(struct vm_fault *vmf, pfn_t pfn,
> +                                unsigned long fault_size,
> +                                struct address_space *f_mapping)
> +{
> +       struct page *head;
> +
> +       head = pfn_to_page(pfn_t_to_pfn(pfn));
> +       head = compound_head(head);
> +       if (head->mapping)
> +               return;
> +
> +       head->mapping = f_mapping;
> +       head->index = linear_page_index(vmf->vma,
> +                       ALIGN(vmf->address, fault_size));
> +}
> +
>  static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf,
>                 enum page_entry_size pe_size)
>  {
> @@ -225,8 +261,7 @@ static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf,
>         }
>
>         if (rc == VM_FAULT_NOPAGE) {
> -               unsigned long i;
> -               pgoff_t pgoff;
> +               struct dev_pagemap *pgmap = dev_dax->pgmap;
>
>                 /*
>                  * In the device-dax case the only possibility for a
> @@ -234,17 +269,10 @@ static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf,
>                  * mapped. No need to consider the zero page, or racing
>                  * conflicting mappings.
>                  */
> -               pgoff = linear_page_index(vmf->vma,
> -                               ALIGN(vmf->address, fault_size));
> -               for (i = 0; i < fault_size / PAGE_SIZE; i++) {
> -                       struct page *page;
> -
> -                       page = pfn_to_page(pfn_t_to_pfn(pfn) + i);
> -                       if (page->mapping)
> -                               continue;
> -                       page->mapping = filp->f_mapping;
> -                       page->index = pgoff + i;
> -               }
> +               if (pgmap_geometry(pgmap) > 1)
> +                       set_compound_mapping(vmf, pfn, fault_size, filp->f_mapping);
> +               else
> +                       set_page_mapping(vmf, pfn, fault_size, filp->f_mapping);
>         }
>         dax_read_unlock(id);
>
> @@ -426,6 +454,8 @@ int dev_dax_probe(struct dev_dax *dev_dax)
>         }
>
>         pgmap->type = MEMORY_DEVICE_GENERIC;
> +       if (dev_dax->align > PAGE_SIZE)
> +               pgmap->geometry = dev_dax->align >> PAGE_SHIFT;
>         dev_dax->pgmap = pgmap;
>
>         addr = devm_memremap_pages(dev, pgmap);
> --
> 2.17.1
>
