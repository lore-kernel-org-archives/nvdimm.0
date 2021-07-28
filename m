Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F6E70
	for <nvdimm@lists.linux.dev>; Wed, 28 Jul 2021 06:05:08 +0000 (UTC)
Received: by mail-pj1-f45.google.com with SMTP id b1-20020a17090a8001b029017700de3903so5138510pjn.1
        for <nvdimm@lists.linux.dev>; Tue, 27 Jul 2021 23:05:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S7De9cl6rnz9ISdIKsf2YW99C7Ty4jqzN9gqFoe2Kdc=;
        b=WrVtdYQO4ThTm8MRttwaCgaeAvU8yh35FxPt21mtICHGTQMVjYUMbeCck/xGO7vHp3
         DVvrq+BntGXqkffGd7wIoY2ktRw8HmuWoFvULqJkxiHPcqbPconQfN+PplhAqjz9toRY
         UCnn1Cg8YbrGWdVq6ZpIm+HjTXVXTj2wSoEEHhw8GTUJA+eeozsUY8RnPtER2+qKAPj/
         oUtCkMBuAYsxC3wjUJV9kbYHtLDprlDwxd2uWCLTuY36+ZoY19Urn6sHz5QBUMU3sYuJ
         vtWrjsrPq/yiVU8yiBQvvubQ8df6swkqWrhVdK+qKQEyJnJsQDLxdoDMvT+ZzTlJSZuz
         OpTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S7De9cl6rnz9ISdIKsf2YW99C7Ty4jqzN9gqFoe2Kdc=;
        b=m+Q/V1ZlnfiIJnia6zKBXYOdxV9IaxuZmT31P+z47E4hOoSs3jaMZalGMSdG/UKuyT
         ADF/Vu1MvFMyZ1bexzJj7j2K2tn0fuK6titPN2mZa7CQe17A1fjOVpJ1Ru1yZTPShvfw
         7imOIRmpcOYR8Uxa68SAcHif3aMPTmpNeEsree6T7HawGKrUvBTPc85gO00pvSJPaOKe
         hnrLjKIww505Dn6WhPSJ3iL7qrWXvi0mOABOS2ixboGhT0iDo/X95DXLeGvjjtiZdaiO
         z1jp3NenHRoPXUvEVhwYanBgBgzGLvmDXQM4lNqy43gK54R+jqKj/ICrzc4efzVNrVo6
         BcyA==
X-Gm-Message-State: AOAM532s59NLM6fmQ0TMnsWoE3Jc2cWtnLItilNWLoRzBX0U0akwXpfr
	4jhwl1OY4TS9PnR3UJ7immdGZpn4ntXlJByXcc6SXA==
X-Google-Smtp-Source: ABdhPJwKAAossYI2q6UvsYvBLJL1fq+DZe/6tRo+YtbetwmSSE8kD/eIiedXsRYc1dv063oIth4g/rKmDYv1ItVMW4g=
X-Received: by 2002:a65:6248:: with SMTP id q8mr27652152pgv.279.1627452308333;
 Tue, 27 Jul 2021 23:05:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210714193542.21857-1-joao.m.martins@oracle.com> <20210714193542.21857-7-joao.m.martins@oracle.com>
In-Reply-To: <20210714193542.21857-7-joao.m.martins@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 27 Jul 2021 23:04:57 -0700
Message-ID: <CAPcyv4j=gqdkj-hT1dD5jyndG=P9DogUH7Ptr-aDeAk7uacpCQ@mail.gmail.com>
Subject: Re: [PATCH v3 06/14] mm/sparse-vmemmap: refactor core of
 vmemmap_populate_basepages() to helper
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
> In preparation for describing a memmap with compound pages, move the
> actual pte population logic into a separate function
> vmemmap_populate_address() and have vmemmap_populate_basepages() walk
> through all base pages it needs to populate.
>
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
>  mm/sparse-vmemmap.c | 44 ++++++++++++++++++++++++++------------------
>  1 file changed, 26 insertions(+), 18 deletions(-)
>
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index 80d3ba30d345..76f4158f6301 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -570,33 +570,41 @@ pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
>         return pgd;
>  }
>
> -int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
> -                                        int node, struct vmem_altmap *altmap)
> +static int __meminit vmemmap_populate_address(unsigned long addr, int node,
> +                                             struct vmem_altmap *altmap)
>  {
> -       unsigned long addr = start;
>         pgd_t *pgd;
>         p4d_t *p4d;
>         pud_t *pud;
>         pmd_t *pmd;
>         pte_t *pte;
>
> +       pgd = vmemmap_pgd_populate(addr, node);
> +       if (!pgd)
> +               return -ENOMEM;
> +       p4d = vmemmap_p4d_populate(pgd, addr, node);
> +       if (!p4d)
> +               return -ENOMEM;
> +       pud = vmemmap_pud_populate(p4d, addr, node);
> +       if (!pud)
> +               return -ENOMEM;
> +       pmd = vmemmap_pmd_populate(pud, addr, node);
> +       if (!pmd)
> +               return -ENOMEM;
> +       pte = vmemmap_pte_populate(pmd, addr, node, altmap);
> +       if (!pte)
> +               return -ENOMEM;
> +       vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);

Missing a return here:

mm/sparse-vmemmap.c:598:1: error: control reaches end of non-void
function [-Werror=return-type]

Yes, it's fixed up in a later patch, but might as well not leave the
bisect breakage lying around, and the kbuild robot would gripe about
this eventually as well.


> +}
> +
> +int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
> +                                        int node, struct vmem_altmap *altmap)
> +{
> +       unsigned long addr = start;
> +
>         for (; addr < end; addr += PAGE_SIZE) {
> -               pgd = vmemmap_pgd_populate(addr, node);
> -               if (!pgd)
> -                       return -ENOMEM;
> -               p4d = vmemmap_p4d_populate(pgd, addr, node);
> -               if (!p4d)
> -                       return -ENOMEM;
> -               pud = vmemmap_pud_populate(p4d, addr, node);
> -               if (!pud)
> -                       return -ENOMEM;
> -               pmd = vmemmap_pmd_populate(pud, addr, node);
> -               if (!pmd)
> -                       return -ENOMEM;
> -               pte = vmemmap_pte_populate(pmd, addr, node, altmap);
> -               if (!pte)
> +               if (vmemmap_populate_address(addr, node, altmap))
>                         return -ENOMEM;

I'd prefer:

rc = vmemmap_populate_address(addr, node, altmap);
if (rc)
    return rc;

...in case future refactoring adds different error codes to pass up.


> -               vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
>         }
>
>         return 0;
> --
> 2.17.1
>
