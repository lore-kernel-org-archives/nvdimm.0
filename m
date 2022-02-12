Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E502118
	for <nvdimm@lists.linux.dev>; Sat, 12 Feb 2022 14:50:27 +0000 (UTC)
Received: by mail-yb1-f181.google.com with SMTP id c6so33341908ybk.3
        for <nvdimm@lists.linux.dev>; Sat, 12 Feb 2022 06:50:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Su7AQ/5xwTbM+10TxtxCdpVbmI06ysx1kE8vo59J6GE=;
        b=J2RdaV7sbB5sJNP4qFBdwADQQDjK3aTvY8zLZx/JDCUvMr+p330G43ATMom+WfAOs7
         OtGAQZnlVRFBgL/RTQjKL1TIgcOSPQrVRTX7uvsDcJ7B4NcUHLR2PXUAJbs/PLZYuhaF
         Fz2H2G5tDtAT35ha9NnAh50b+YFVLk1DN272G4SEVgHuBRV+ohNZOlDsLSNyViS4sMme
         PeGfb/YCmR2ZxHNa2eaNU2RYAK7HEJHD8EM4a0NacLt2IAu5vAN/mpe+jgSArEZeIp1X
         /FnFZOeHlGxk3gTYW8kbJiM6rN/NPC6L8Aduu+PJn8n0be/u5DL0ACECJshrljToWjSS
         CCLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Su7AQ/5xwTbM+10TxtxCdpVbmI06ysx1kE8vo59J6GE=;
        b=IA4AdEU4pLr+0evROryc/e+F+4NVDQeCqo62NN5j0P+8roBJOqTx+08mwHlBu0IOeM
         /4VPUnCXZtBjln65hD/ziZ6LvVd3CemDS8PNYy0DHIoYuWhlBS9FKHVaewyTwR6p7rIq
         8E30XDmdteQFfP9v+hi/moiE401JshxsaKGxisIU+xy5NJZj2CfBt/te1lD0hCD1M/L2
         qka6qhnXb3PJqO/JWkf9bXBbk7KUIsovtdOE6Sjvd6isaQlHf4adTG4WU9Uqlay37ZNk
         mxv7CFMzCKc8mBdnTIutt12m/KI4nuHIZXKtSwVOli7/6sxGtA6j9MNBciUsgmBxWMic
         zLhw==
X-Gm-Message-State: AOAM533hGa455XxU0UYEIMG89nGj9Wv7meLfp6ykQz+DBPjoK9OKDOMc
	fqrxozgzomtZHZ7I+2kSIprqKwkDzJfyeqL8cjunuw==
X-Google-Smtp-Source: ABdhPJwDUzQBxTRtxWwNY46Xv0JADh+f52XG44YUT4SrXJT3uIPLD0F239DDRKnvV/V4eRppK/aM7bAbaAEunNnv7Sw=
X-Received: by 2002:a25:4742:: with SMTP id u63mr5594569yba.523.1644677426443;
 Sat, 12 Feb 2022 06:50:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220210193345.23628-1-joao.m.martins@oracle.com>
 <20220210193345.23628-5-joao.m.martins@oracle.com> <CAMZfGtUEaFg=CGLRJomyumsZzcyn8O0JE1+De2Vd3a5remcH6w@mail.gmail.com>
 <d258c471-1291-e0c7-f1b3-a495b4d40bb9@oracle.com> <CAMZfGtWUHRRfowwPf1o-SycKZMDzMdeGdahaR2OEJZzLhLioNg@mail.gmail.com>
In-Reply-To: <CAMZfGtWUHRRfowwPf1o-SycKZMDzMdeGdahaR2OEJZzLhLioNg@mail.gmail.com>
From: Muchun Song <songmuchun@bytedance.com>
Date: Sat, 12 Feb 2022 22:49:49 +0800
Message-ID: <CAMZfGtUSxtnrY3Vkn8gP2T2jUjWdfVXu7+zt5Ny4VBi7ZDkWAg@mail.gmail.com>
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

On Sat, Feb 12, 2022 at 6:08 PM Muchun Song <songmuchun@bytedance.com> wrote:
>
> On Fri, Feb 11, 2022 at 8:37 PM Joao Martins <joao.m.martins@oracle.com> wrote:
> >
> > On 2/11/22 07:54, Muchun Song wrote:
> > > On Fri, Feb 11, 2022 at 3:34 AM Joao Martins <joao.m.martins@oracle.com> wrote:
> > > [...]
> > >>  pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
> > >> -                                      struct vmem_altmap *altmap)
> > >> +                                      struct vmem_altmap *altmap,
> > >> +                                      struct page *block)
> > >
> > > Why not use the name of "reuse" instead of "block"?
> > > Seems like "reuse" is more clear.
> > >
> > Good idea, let me rename that to @reuse.
> >
> > >>  {
> > >>         pte_t *pte = pte_offset_kernel(pmd, addr);
> > >>         if (pte_none(*pte)) {
> > >>                 pte_t entry;
> > >>                 void *p;
> > >>
> > >> -               p = vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
> > >> -               if (!p)
> > >> -                       return NULL;
> > >> +               if (!block) {
> > >> +                       p = vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
> > >> +                       if (!p)
> > >> +                               return NULL;
> > >> +               } else {
> > >> +                       /*
> > >> +                        * When a PTE/PMD entry is freed from the init_mm
> > >> +                        * there's a a free_pages() call to this page allocated
> > >> +                        * above. Thus this get_page() is paired with the
> > >> +                        * put_page_testzero() on the freeing path.
> > >> +                        * This can only called by certain ZONE_DEVICE path,
> > >> +                        * and through vmemmap_populate_compound_pages() when
> > >> +                        * slab is available.
> > >> +                        */
> > >> +                       get_page(block);
> > >> +                       p = page_to_virt(block);
> > >> +               }
> > >>                 entry = pfn_pte(__pa(p) >> PAGE_SHIFT, PAGE_KERNEL);
> > >>                 set_pte_at(&init_mm, addr, pte, entry);
> > >>         }
> > >> @@ -609,7 +624,8 @@ pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
> > >>  }
> > >>
> > >>  static int __meminit vmemmap_populate_address(unsigned long addr, int node,
> > >> -                                             struct vmem_altmap *altmap)
> > >> +                                             struct vmem_altmap *altmap,
> > >> +                                             struct page *reuse, struct page **page)
> > >
> > > We can remove the last argument (struct page **page) if we change
> > > the return type to "pte_t *".  More simple, don't you think?
> > >
> >
> > Hmmm, perhaps it is simpler, specially provided the only error code is ENOMEM.
> >
> > Albeit perhaps what we want is a `struct page *` rather than a pte.
>
> The caller can extract `struct page` from a pte.
>
> [...]
>
> > >> -       if (vmemmap_populate(start, end, nid, altmap))
> > >> +       if (pgmap && pgmap_vmemmap_nr(pgmap) > 1 && !altmap)
> > >
> > > Should we add a judgment like "is_power_of_2(sizeof(struct page))" since
> > > this optimization is only applied when the size of the struct page does not
> > > cross page boundaries?
> >
> > Totally miss that -- let me make that adjustment.
> >
> > Can I ask which architectures/conditions this happens?
>
> E.g. arm64 when !CONFIG_MEMCG.

Plus !CONFIG_SLUB even on x86_64.

>
> Thanks.
