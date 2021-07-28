Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E1072
	for <nvdimm@lists.linux.dev>; Wed, 28 Jul 2021 18:03:28 +0000 (UTC)
Received: by mail-pl1-f175.google.com with SMTP id t21so3612087plr.13
        for <nvdimm@lists.linux.dev>; Wed, 28 Jul 2021 11:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R1mxyscdyw51Q+xf2U4a9dfGTlTYfyhHnE9YRUiO79A=;
        b=SezFOYExPlp2dNoYE7NNWxkf9d08LcuwryvGTIgNr4enzdy1NZPbjKqzT067NwUsj+
         gEBJgxQcIlH7d1D0ySI8ZNjxmiIPC45JQWjzaiZcTsEPkE9tnOm9cV0FV3x0I5toyM81
         F+vkMTUGoa/bsDR8/raykp4tWGlhNqaJvLZwL+kAGGQqA+7dEeTq5OjXTYYk808qWzPX
         KVrhPXeps4RmHXPf5kIqT0dsEE9y6YUtcrv4slqPS73Uh7k7ohYoeAACdAy1mMW6Dsay
         G7LIFkJXfyy2iAhfCoW5ldaFu0gigb5sA8O+u8es4k7h2tXuZPZ1l1Vb9wsxRtux7m0i
         xkUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R1mxyscdyw51Q+xf2U4a9dfGTlTYfyhHnE9YRUiO79A=;
        b=jdt2e71z/w1tu33c8zyjSUvhZZ1JeNtMm2P2lm2UmenGGcyUe0g6l2msQCTrIxBzhj
         aiEuiyIyxChcuKV1KlBMCTx/H+yfdzelzmxZodH2Tp0Yrr9hS1D7ToxaIs0OrIt9mF8H
         nhKt2yMHB47izvMX07QDA6Cc3gN6Z5KSPsnHrtojZ5EuD6xJlBut9I4rsMgbpUsEhmXp
         CDHSttSKQfL9mrrp+TKhxENe7QkQ+a3bp96QIRiJ0myAh7P2xOLVh7CICkTJng44EzD3
         1ngoCzSdRXZmp48rbF+uxZrbYgfeLRFL07KRJ7+zivLW70GRRy3qHLGAHhaLxoANCOWQ
         GQoQ==
X-Gm-Message-State: AOAM532SJmZp5K7xdIGIsSdHjRvYWYc7GrNIYENd3I21KWibQTo0O0FW
	vBeFDjfLDTL+d3pByzJDLP6LmQKnRvspjHlg0gjdmQ==
X-Google-Smtp-Source: ABdhPJzYa5H9v4fabmNToov9Ab65TCi56koXLkxBg5XiPcwGw8nhQ8zvGZgpQia+SnmV+M49yjLIgI7TyF0MgjR/K/Q=
X-Received: by 2002:a17:90a:708c:: with SMTP id g12mr10908790pjk.13.1627495407682;
 Wed, 28 Jul 2021 11:03:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210714193542.21857-1-joao.m.martins@oracle.com>
 <20210714193542.21857-9-joao.m.martins@oracle.com> <CAPcyv4jPWSeP3jOKiEy0ko4Yy5SgAFmuD64ABgv=cRxHaQM7ew@mail.gmail.com>
 <131e77ec-6de4-8401-e7b0-7ff12abac04c@oracle.com>
In-Reply-To: <131e77ec-6de4-8401-e7b0-7ff12abac04c@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 28 Jul 2021 11:03:16 -0700
Message-ID: <CAPcyv4jR9atodmLqk4O+RdbM9DJDvoQvAZqH03UAgAKB71Fcdg@mail.gmail.com>
Subject: Re: [PATCH v3 08/14] mm/sparse-vmemmap: populate compound pagemaps
To: Joao Martins <joao.m.martins@oracle.com>
Cc: Linux MM <linux-mm@kvack.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Naoya Horiguchi <naoya.horiguchi@nec.com>, 
	Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
	Jane Chu <jane.chu@oracle.com>, Muchun Song <songmuchun@bytedance.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Doc Mailing List <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, Jul 28, 2021 at 8:36 AM Joao Martins <joao.m.martins@oracle.com> wrote:
[..]
> +/*
> + * For compound pages bigger than section size (e.g. x86 1G compound
> + * pages with 2M subsection size) fill the rest of sections as tail
> + * pages.
> + *
> + * Note that memremap_pages() resets @nr_range value and will increment
> + * it after each range successful onlining. Thus the value or @nr_range
> + * at section memmap populate corresponds to the in-progress range
> + * being onlined here.
> + */
> +static bool compound_section_index(unsigned long start_pfn,

Oh, I was thinking this would return the actual Nth index number for
the section within the compound page. A bool is ok too, but then the
function name would be something like:

reuse_compound_section()

...right?


[..]
> [...] And here's compound_section_tail_huge_page() (for the last patch in the series):
>
>
> @@ -690,6 +727,33 @@ static struct page * __meminit compound_section_tail_page(unsigned
> long addr)
>         return pte_page(*ptep);
>  }
>
> +static struct page * __meminit compound_section_tail_huge_page(unsigned long addr,
> +                               unsigned long offset, struct dev_pagemap *pgmap)
> +{
> +       unsigned long geometry_size = pgmap_geometry(pgmap) << PAGE_SHIFT;
> +       pmd_t *pmdp;
> +
> +       addr -= PAGE_SIZE;
> +
> +       /*
> +        * Assuming sections are populated sequentially, the previous section's
> +        * page data can be reused.
> +        */
> +       pmdp = pmd_off_k(addr);
> +       if (!pmdp)
> +               return ERR_PTR(-ENOMEM);
> +
> +       /*
> +        * Reuse the tail pages vmemmap pmd page
> +        * See layout diagram in Documentation/vm/vmemmap_dedup.rst
> +        */
> +       if (offset % geometry_size > PFN_PHYS(PAGES_PER_SECTION))
> +               return pmd_page(*pmdp);
> +
> +       /* No reusable PMD fallback to PTE tail page*/
> +       return NULL;
> +}
> +
>  static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
>                                                      unsigned long start,
>                                                      unsigned long end, int node,
> @@ -697,14 +761,22 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long
> start_pfn,
>  {
>         unsigned long offset, size, addr;
>
> -       if (compound_section_index(start_pfn, pgmap)) {
> -               struct page *page;
> +       if (compound_section_index(start_pfn, pgmap, &offset)) {
> +               struct page *page, *hpage;
> +
> +               hpage = compound_section_tail_huge_page(addr, offset);
> +               if (IS_ERR(hpage))
> +                       return -ENOMEM;
> +               else if (hpage)

No need for "else" after return... other than that these helpers and
this arrangement looks good to me.
