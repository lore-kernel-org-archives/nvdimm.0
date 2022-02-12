Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32DA0211E
	for <nvdimm@lists.linux.dev>; Sat, 12 Feb 2022 10:09:15 +0000 (UTC)
Received: by mail-yb1-f181.google.com with SMTP id 124so3772118ybn.11
        for <nvdimm@lists.linux.dev>; Sat, 12 Feb 2022 02:09:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uY1QGZxvGJNV1jQzuanAqMu3WZtLOvsmLZnn0LbatKM=;
        b=FvtDkCYKqTsbh24ngYPII58GTtKLRiNNrwb9D+4lHh2yDSyJflk5IOHe/2Pz50gszB
         5+YhYc/POsGXJWz71gKctIlk2CC3NqaHnP+sWwAugLGyA0G/89+Fj/YxRWfL07IvADAu
         w550p0TJcrAcQHtjd4OSjbYQNY2cfsyJ1CmekQApWcmAagHnJM+CJVEvtoDG/yGkWdyh
         wr1tJAPNEXQdIgyaHbUqjNepODQHsQQrA/BlwTfTNiAg9pJw7BgLaJzx0eagMcX/Hp7g
         uemiY0fS7TobC04DACyRdjzDFvUe9+dUgJ2RnmK+tDcr2rx2uQ9Ta4tgRGY9lakN2+Kl
         c5aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uY1QGZxvGJNV1jQzuanAqMu3WZtLOvsmLZnn0LbatKM=;
        b=4DHuaUzQs086XR3hrp1r20fowo53jFsu7aVsxrXZbCwgNs3fdzIFcSKfrxt+7LV95l
         Jwi2m5pH0sqeT6ywMgYAdxgAs0pTONhQ59hh9rqEnxuJPL5J7fYQBSplW7OOWTpZlAqS
         elI+5oQdtxNUz1O7QM9aA3DPFRntF/+CAx5HgLzH3FkhsWdz9xcLD1bidp4UhDH4cVil
         eANL9gOE/pgSaMbMPh2clijyjIbO2cUE0tqvYh/2chpYNjSJgzb4sYVlLiTu0Sg87qMo
         ptQ0msoz+AdBPLWt/t8l5nD7JyeG2EkB128tr9r/RP5o/s+nACo0+lISKKgQ5/MGkgj4
         sNfA==
X-Gm-Message-State: AOAM533ggGG16dTudZRRMlRyoBi4W/Cuyu+lOYobW+/crvlX6Xf4YZHJ
	qa/hK1j7Hs3kQKoauf1tnKXBQ4a0hSdcoDrFleKg/Q==
X-Google-Smtp-Source: ABdhPJzYQpbf+Roqjp0GzTDpkzICPMdHmyElZzFdRcACcJ2hhbApUPi2w9MF5msS2pnfs6Amy4uo8UyalDQKMw0zp5Y=
X-Received: by 2002:a25:4742:: with SMTP id u63mr4863670yba.523.1644660554886;
 Sat, 12 Feb 2022 02:09:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220210193345.23628-1-joao.m.martins@oracle.com>
 <20220210193345.23628-5-joao.m.martins@oracle.com> <CAMZfGtUEaFg=CGLRJomyumsZzcyn8O0JE1+De2Vd3a5remcH6w@mail.gmail.com>
 <d258c471-1291-e0c7-f1b3-a495b4d40bb9@oracle.com>
In-Reply-To: <d258c471-1291-e0c7-f1b3-a495b4d40bb9@oracle.com>
From: Muchun Song <songmuchun@bytedance.com>
Date: Sat, 12 Feb 2022 18:08:38 +0800
Message-ID: <CAMZfGtWUHRRfowwPf1o-SycKZMDzMdeGdahaR2OEJZzLhLioNg@mail.gmail.com>
Subject: Re: [PATCH v5 4/5] mm/sparse-vmemmap: improve memory savings for
 compound devmaps
To: Joao Martins <joao.m.martins@oracle.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Matthew Wilcox <willy@infradead.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jane Chu <jane.chu@oracle.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, nvdimm@lists.linux.dev, 
	Linux Doc Mailing List <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Feb 11, 2022 at 8:37 PM Joao Martins <joao.m.martins@oracle.com> wrote:
>
> On 2/11/22 07:54, Muchun Song wrote:
> > On Fri, Feb 11, 2022 at 3:34 AM Joao Martins <joao.m.martins@oracle.com> wrote:
> > [...]
> >>  pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
> >> -                                      struct vmem_altmap *altmap)
> >> +                                      struct vmem_altmap *altmap,
> >> +                                      struct page *block)
> >
> > Why not use the name of "reuse" instead of "block"?
> > Seems like "reuse" is more clear.
> >
> Good idea, let me rename that to @reuse.
>
> >>  {
> >>         pte_t *pte = pte_offset_kernel(pmd, addr);
> >>         if (pte_none(*pte)) {
> >>                 pte_t entry;
> >>                 void *p;
> >>
> >> -               p = vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
> >> -               if (!p)
> >> -                       return NULL;
> >> +               if (!block) {
> >> +                       p = vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
> >> +                       if (!p)
> >> +                               return NULL;
> >> +               } else {
> >> +                       /*
> >> +                        * When a PTE/PMD entry is freed from the init_mm
> >> +                        * there's a a free_pages() call to this page allocated
> >> +                        * above. Thus this get_page() is paired with the
> >> +                        * put_page_testzero() on the freeing path.
> >> +                        * This can only called by certain ZONE_DEVICE path,
> >> +                        * and through vmemmap_populate_compound_pages() when
> >> +                        * slab is available.
> >> +                        */
> >> +                       get_page(block);
> >> +                       p = page_to_virt(block);
> >> +               }
> >>                 entry = pfn_pte(__pa(p) >> PAGE_SHIFT, PAGE_KERNEL);
> >>                 set_pte_at(&init_mm, addr, pte, entry);
> >>         }
> >> @@ -609,7 +624,8 @@ pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
> >>  }
> >>
> >>  static int __meminit vmemmap_populate_address(unsigned long addr, int node,
> >> -                                             struct vmem_altmap *altmap)
> >> +                                             struct vmem_altmap *altmap,
> >> +                                             struct page *reuse, struct page **page)
> >
> > We can remove the last argument (struct page **page) if we change
> > the return type to "pte_t *".  More simple, don't you think?
> >
>
> Hmmm, perhaps it is simpler, specially provided the only error code is ENOMEM.
>
> Albeit perhaps what we want is a `struct page *` rather than a pte.

The caller can extract `struct page` from a pte.

[...]

> >> -       if (vmemmap_populate(start, end, nid, altmap))
> >> +       if (pgmap && pgmap_vmemmap_nr(pgmap) > 1 && !altmap)
> >
> > Should we add a judgment like "is_power_of_2(sizeof(struct page))" since
> > this optimization is only applied when the size of the struct page does not
> > cross page boundaries?
>
> Totally miss that -- let me make that adjustment.
>
> Can I ask which architectures/conditions this happens?

E.g. arm64 when !CONFIG_MEMCG.

Thanks.
