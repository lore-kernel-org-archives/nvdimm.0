Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25DFD2C89
	for <nvdimm@lists.linux.dev>; Mon, 18 Oct 2021 18:36:30 +0000 (UTC)
Received: by mail-qk1-f170.google.com with SMTP id b15so7021162qkl.10
        for <nvdimm@lists.linux.dev>; Mon, 18 Oct 2021 11:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sTUgwvzk5rBLdhIf8DaS7J5sGbd2IBWKO4C29AYu/xc=;
        b=eOxhZyJgnih5XmJTiUkqPchjr0GxPdMGTZWIOrKKBnbd5oIycmMn5R+gGA2sn3LkLK
         8B5YnTnSH3n9NgDYusHw9PUwNsH//Okzwm4qTKGVc2c7MvJHV07z9MsRaF+X9nNusxjD
         Yb0grXjEMIpSTl4VGTSaQ3iI8fXwYmRb57jc4vhGUbIbYT72PrcbqfY3R8MNDShnqyYr
         ilFrKr09XfgBn481Ei+z6rbmJ8MirnyiEJDkYvopmpMs3+VzGVgPAR90YeYZjvrqPmsF
         DGN+7sqiBax8sZV/x9u99m04iC7V65j6dSsg+qoYNVK/JvhIJiSTlZsa1sZ0D3JDmRF6
         pxEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sTUgwvzk5rBLdhIf8DaS7J5sGbd2IBWKO4C29AYu/xc=;
        b=wounPxpTvfHuXY+MIeCDJuCRIe4zgl+T5P8JLVsoya6+crYQIjc4QxCF8aXur+lxZq
         NCUkphf0CmTIyCeKfORngKsKWtYG0SG+X/PxQkvjiU7KI4qUurbzWEaL1MtFrAixfi3j
         bfsiEykGfES0FQoTzPIxtBc7folmQl2VAE8/eJCainPMGuCE0tNDz+gAtCBf6y1eJrgU
         ISrgBTCNOMXst9QnZ9RxKm5zWNJV/POElwkDsns5aTCsnobF8IcLYLb8DlV9bpSU88xZ
         +4ceJc6A4MUuUVMH4E6H/CqloSzzzgzhSteoGBP6/qu1nIfdqDHKezpFk5RuMRL8p45h
         Fj3g==
X-Gm-Message-State: AOAM531nBtFTucjMYWrhE3483UPLO+SUvCwll+xNj/uI6w+cPpYlnIW2
	Yxg9Sf3rQlemSQQM0ok2DwDkxg==
X-Google-Smtp-Source: ABdhPJxOGqr4Dm+0wgcW0Qag4P+r6KIDtarTX9sViv/hQASfXUhZKkzCDtmh5gP+QfOaJGfe1TWiVQ==
X-Received: by 2002:a05:620a:288f:: with SMTP id j15mr23613311qkp.280.1634582189080;
        Mon, 18 Oct 2021 11:36:29 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id m68sm6924782qkb.105.2021.10.18.11.36.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 11:36:28 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
	(envelope-from <jgg@ziepe.ca>)
	id 1mcXUp-00GLtu-LR; Mon, 18 Oct 2021 15:36:27 -0300
Date: Mon, 18 Oct 2021 15:36:27 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alistair Popple <apopple@nvidia.com>
Cc: Joao Martins <joao.m.martins@oracle.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>, linux-mm@kvack.org,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Naoya Horiguchi <naoya.horiguchi@nec.com>,
	Matthew Wilcox <willy@infradead.org>,
	John Hubbard <jhubbard@nvidia.com>, Jane Chu <jane.chu@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>,
	nvdimm@lists.linux.dev, linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 08/14] mm/gup: grab head page refcount once for group
 of subpages
Message-ID: <20211018183627.GD3686969@ziepe.ca>
References: <20210827145819.16471-1-joao.m.martins@oracle.com>
 <3f35cc33-7012-5230-a771-432275e6a21e@oracle.com>
 <20210929193405.GZ3544071@ziepe.ca>
 <31536278.clc0Zd3cv0@nvdebian>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31536278.clc0Zd3cv0@nvdebian>

On Thu, Sep 30, 2021 at 01:01:14PM +1000, Alistair Popple wrote:
> On Thursday, 30 September 2021 5:34:05 AM AEST Jason Gunthorpe wrote:
> > On Wed, Sep 29, 2021 at 12:50:15PM +0100, Joao Martins wrote:
> > 
> > > > If the get_dev_pagemap has to remain then it just means we have to
> > > > flush before changing pagemap pointers
> > > Right -- I don't think we should need it as that discussion on the other
> > > thread goes.
> > > 
> > > OTOH, using @pgmap might be useful to unblock gup-fast FOLL_LONGTERM
> > > for certain devmap types[0] (like MEMORY_DEVICE_GENERIC [device-dax]
> > > can support it but not MEMORY_DEVICE_FSDAX [fsdax]).
> > 
> > When looking at Logan's patches I think it is pretty clear to me that
> > page->pgmap must never be a dangling pointer if the caller has a
> > legitimate refcount on the page.
> > 
> > For instance the migrate and stuff all blindly calls
> > is_device_private_page() on the struct page expecting a valid
> > page->pgmap.
> > 
> > This also looks like it is happening, ie
> > 
> > void __put_page(struct page *page)
> > {
> > 	if (is_zone_device_page(page)) {
> > 		put_dev_pagemap(page->pgmap);
> > 
> > Is indeed putting the pgmap ref back when the page becomes ungettable.
> > 
> > This properly happens when the page refcount goes to zero and so it
> > should fully interlock with __page_cache_add_speculative():
> > 
> > 	if (unlikely(!page_ref_add_unless(page, count, 0))) {
> > 
> > Thus, in gup.c, if we succeed at try_grab_compound_head() then
> > page->pgmap is a stable pointer with a valid refcount.
> > 
> > So, all the external pgmap stuff in gup.c is completely pointless.
> > try_grab_compound_head() provides us with an equivalent protection at
> > lower cost. Remember gup.c doesn't deref the pgmap at all.
> > 
> > Dan/Alistair/Felix do you see any hole in that argument??
> 
> As background note that device pages are currently considered free when
> refcount == 1 but the pgmap reference is dropped when the refcount transitions
> 1->0. The final pgmap reference is typically dropped when a driver calls
> memunmap_pages() and put_page() drops the last page reference:
> 
> void memunmap_pages(struct dev_pagemap *pgmap)
> {
>         unsigned long pfn;
>         int i;
> 
>         dev_pagemap_kill(pgmap);
>         for (i = 0; i < pgmap->nr_range; i++)
>                 for_each_device_pfn(pfn, pgmap, i)
>                         put_page(pfn_to_page(pfn));
>         dev_pagemap_cleanup(pgmap);
> 
> If there are still pgmap references dev_pagemap_cleanup(pgmap) will block until
> the final reference is dropped. So I think your argument holds at least for
> DEVICE_PRIVATE and DEVICE_GENERIC. DEVICE_FS_DAX defines it's own pagemap
> cleanup but I can't see why the same argument wouldn't hold there - if a page
> has a valid refcount it must have a reference on the pagemap too.

To close this circle - the issue is use after free on the struct page
* entry while it has a zero ref.

memunmap_pages() does wait for the refcount to go to zero, but it then
goes on to free the memory under the struct pages.

However there are possibly still untracked references to this memory
in the page tables.

This is the bug Dan has been working on - to shootdown page table
mappings before getting to memunmap_pages()

Getting the page map ref will make the use-after-free never crash,
just be a silent security problem. :(

Jason
