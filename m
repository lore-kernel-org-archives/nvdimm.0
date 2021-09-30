Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21CE329CA
	for <nvdimm@lists.linux.dev>; Thu, 30 Sep 2021 21:55:26 +0000 (UTC)
Received: by mail-qk1-f180.google.com with SMTP id 72so7328331qkk.7
        for <nvdimm@lists.linux.dev>; Thu, 30 Sep 2021 14:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xlLPTltBgsawRARMq3dqSMA7AppVkc6q3Hg9ZPYjbAw=;
        b=kigY1/7+2cumybe2RwGZp/DBpGs8woG1Gb7tPGgyvIJvswSs7kjmM8EcGItZWbZBZf
         EPN5cEvGqLRYciJcHutq4reUXVydbikGfh+SB9j9H42TN8lFm6fB0knkjPHtqK5LDgMO
         trrauRNRHBbRgWiXZe3d6n5iSmHLVSfQl/rPtEn4p2Hbq6pwjLhy+QVU5wL5A/CbVoqh
         J1txs0T+PGDn8taHg1iiwl2f29Zdm5/fEylCaqEXN/b63xnHiIz2gTFP38p+3HD6goz3
         Teu+70wiGoRt++8ISlYux0LzM2vgLEC03pgnFUMnMK6CiukNCHrI7zJre6+KTFMUNTc0
         LWJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xlLPTltBgsawRARMq3dqSMA7AppVkc6q3Hg9ZPYjbAw=;
        b=xUa3rlYuv9tkULiq6qTnIdQMZZ0wh98691El/ZVNTj/Q1C4D8S4tXpy+P0MWAye050
         Z2xHkT678Sl5sTupGzJtP+KdXq9Gt+5ZkSZmT1WLkYHUqh9LWMGCVQLpPVt2AYYSwL3V
         3/8DaAXNaED3A5qYTuEmRwaufRSq9TE2wohL+3RIC/GPLnO4lXE9+kItQwgIMKbVDPU5
         Gf0w9yymsJ8G3Us3ivIFTsyWig+btSOodXFeVxjpq3K0TYF+9lWMdrftz+eFLKTG9Zq4
         cxMmiAR4Mwwky+pw/F/Qaq4uGlvhnd5/hFghwgl62dngr0lsCd/3nmv/ij7MsLfOF5ww
         1X4w==
X-Gm-Message-State: AOAM531gg+SvLuKsY3Vh5I5iV2vyBBLxki3puWliVdIbcsaVNiU0f8un
	V/qi1HXzLmgQ3vm3uEKbqWqGpw==
X-Google-Smtp-Source: ABdhPJw3tXTaP5bv1o1/CzeuvMR8jtZ0qn/U0MgBqAp1sfTIOla21609UWLlKFpLb53noQft1XyApw==
X-Received: by 2002:a37:885:: with SMTP id 127mr7226689qki.329.1633038925884;
        Thu, 30 Sep 2021 14:55:25 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id o145sm2057718qke.120.2021.09.30.14.55.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 14:55:25 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
	(envelope-from <jgg@ziepe.ca>)
	id 1mW41U-008D5d-FQ; Thu, 30 Sep 2021 18:55:24 -0300
Date: Thu, 30 Sep 2021 18:55:24 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Joao Martins <joao.m.martins@oracle.com>
Cc: Alistair Popple <apopple@nvidia.com>,
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
Message-ID: <20210930215524.GI3544071@ziepe.ca>
References: <20210827145819.16471-1-joao.m.martins@oracle.com>
 <3f35cc33-7012-5230-a771-432275e6a21e@oracle.com>
 <20210929193405.GZ3544071@ziepe.ca>
 <31536278.clc0Zd3cv0@nvdebian>
 <2ab374d1-4cc1-60a4-6663-81de7d59667b@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ab374d1-4cc1-60a4-6663-81de7d59667b@oracle.com>

On Thu, Sep 30, 2021 at 06:54:05PM +0100, Joao Martins wrote:
> On 9/30/21 04:01, Alistair Popple wrote:
> > On Thursday, 30 September 2021 5:34:05 AM AEST Jason Gunthorpe wrote:
> >> On Wed, Sep 29, 2021 at 12:50:15PM +0100, Joao Martins wrote:
> >>
> >>>> If the get_dev_pagemap has to remain then it just means we have to
> >>>> flush before changing pagemap pointers
> >>> Right -- I don't think we should need it as that discussion on the other
> >>> thread goes.
> >>>
> >>> OTOH, using @pgmap might be useful to unblock gup-fast FOLL_LONGTERM
> >>> for certain devmap types[0] (like MEMORY_DEVICE_GENERIC [device-dax]
> >>> can support it but not MEMORY_DEVICE_FSDAX [fsdax]).
> >>
> >> When looking at Logan's patches I think it is pretty clear to me that
> >> page->pgmap must never be a dangling pointer if the caller has a
> >> legitimate refcount on the page.
> >>
> >> For instance the migrate and stuff all blindly calls
> >> is_device_private_page() on the struct page expecting a valid
> >> page->pgmap.
> >>
> >> This also looks like it is happening, ie
> >>
> >> void __put_page(struct page *page)
> >> {
> >> 	if (is_zone_device_page(page)) {
> >> 		put_dev_pagemap(page->pgmap);
> >>
> >> Is indeed putting the pgmap ref back when the page becomes ungettable.
> >>
> >> This properly happens when the page refcount goes to zero and so it
> >> should fully interlock with __page_cache_add_speculative():
> >>
> >> 	if (unlikely(!page_ref_add_unless(page, count, 0))) {
> >>
> >> Thus, in gup.c, if we succeed at try_grab_compound_head() then
> >> page->pgmap is a stable pointer with a valid refcount.
> >>
> >> So, all the external pgmap stuff in gup.c is completely pointless.
> >> try_grab_compound_head() provides us with an equivalent protection at
> >> lower cost. Remember gup.c doesn't deref the pgmap at all.
> >>
> >> Dan/Alistair/Felix do you see any hole in that argument??
> > 
> > As background note that device pages are currently considered free when
> > refcount == 1 but the pgmap reference is dropped when the refcount transitions
> > 1->0. The final pgmap reference is typically dropped when a driver calls
> > memunmap_pages() and put_page() drops the last page reference:
> > 
> > void memunmap_pages(struct dev_pagemap *pgmap)
> > {
> >         unsigned long pfn;
> >         int i;
> > 
> >         dev_pagemap_kill(pgmap);
> >         for (i = 0; i < pgmap->nr_range; i++)
> >                 for_each_device_pfn(pfn, pgmap, i)
> >                         put_page(pfn_to_page(pfn));
> >         dev_pagemap_cleanup(pgmap);
> > 
> > If there are still pgmap references dev_pagemap_cleanup(pgmap) will block until
> > the final reference is dropped. So I think your argument holds at least for
> > DEVICE_PRIVATE and DEVICE_GENERIC. DEVICE_FS_DAX defines it's own pagemap
> > cleanup but I can't see why the same argument wouldn't hold there - if a page
> > has a valid refcount it must have a reference on the pagemap too.
>
> IIUC Dan's reasoning was that fsdax wasn't able to deal with
> surprise removal [1] so his patches were to ensure fsdax (or the
> pmem block device) poisons/kills the pages as a way to notify
> filesystem/dm that the page was to be kept unmapped:

Sure, but that has nothing to do with GUP, that is between the
filesytem and fsdax
 
> But if fsdax doesn't wait for all the pgmap references[*] on its
> pagemap cleanup callback then what's the pgmap ref in
> __gup_device_huge() pairs/protects us up against that is specific to
> fsdax?

It does wait for refs

It sets the pgmap.ref to:

	pmem->pgmap.ref = &q->q_usage_counter;

And that ref is incr'd by the struct page lifetime - the unincr is in
__put_page() above

fsdax_pagemap_ops does pmem_pagemap_kill() which calls
blk_freeze_queue_start() which does percpu_ref_kill(). Then the
pmem_pagemap_cleanup() eventually does blk_mq_freeze_queue_wait()
which will sleep until the prefcpu ref reaches zero.

In other words fsdax cannot pass cleanup while a struct page exists
with a non-zero refcount, which answers Alistair's question about how
fsdax's cleanup work.

Jason
