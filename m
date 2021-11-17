Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D9C2C82
	for <nvdimm@lists.linux.dev>; Wed, 17 Nov 2021 09:43:13 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 098C468C7B; Wed, 17 Nov 2021 10:43:09 +0100 (CET)
Date: Wed, 17 Nov 2021 10:43:08 +0100
From: Christoph Hellwig <hch@lst.de>
To: Joao Martins <joao.m.martins@oracle.com>
Cc: linux-mm@kvack.org, Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Naoya Horiguchi <naoya.horiguchi@nec.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Jane Chu <jane.chu@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>,
	nvdimm@lists.linux.dev, linux-doc@vger.kernel.org
Subject: Re: [PATCH v5 8/8] device-dax: compound devmap support
Message-ID: <20211117094308.GC8429@lst.de>
References: <20211112150824.11028-1-joao.m.martins@oracle.com> <20211112150824.11028-9-joao.m.martins@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211112150824.11028-9-joao.m.martins@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Nov 12, 2021 at 04:08:24PM +0100, Joao Martins wrote:
> Use the newly added compound devmap facility which maps the assigned dax
> ranges as compound pages at a page size of @align.
> 
> dax devices are created with a fixed @align (huge page size) which is
> enforced through as well at mmap() of the device. Faults, consequently
> happen too at the specified @align specified at the creation, and those
> don't change throughout dax device lifetime. MCEs unmap a whole dax
> huge page, as well as splits occurring at the configured page size.
> 
> Performance measured by gup_test improves considerably for
> unpin_user_pages() and altmap with NVDIMMs:
> 
> $ gup_test -f /dev/dax1.0 -m 16384 -r 10 -S -a -n 512 -w
> (pin_user_pages_fast 2M pages) put:~71 ms -> put:~22 ms
> [altmap]
> (pin_user_pages_fast 2M pages) get:~524ms put:~525 ms -> get: ~127ms put:~71ms
> 
>  $ gup_test -f /dev/dax1.0 -m 129022 -r 10 -S -a -n 512 -w
> (pin_user_pages_fast 2M pages) put:~513 ms -> put:~188 ms
> [altmap with -m 127004]
> (pin_user_pages_fast 2M pages) get:~4.1 secs put:~4.12 secs -> get:~1sec put:~563ms
> 
> .. as well as unpin_user_page_range_dirty_lock() being just as effective
> as THP/hugetlb[0] pages.
> 
> [0] https://lore.kernel.org/linux-mm/20210212130843.13865-5-joao.m.martins@oracle.com/
> 
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/dax/device.c | 57 ++++++++++++++++++++++++++++++++++----------
>  1 file changed, 44 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/dax/device.c b/drivers/dax/device.c
> index a65c67ab5ee0..0c2ac97d397d 100644
> --- a/drivers/dax/device.c
> +++ b/drivers/dax/device.c
> @@ -192,6 +192,42 @@ static vm_fault_t __dev_dax_pud_fault(struct dev_dax *dev_dax,
>  }
>  #endif /* !CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
>  
> +static void set_page_mapping(struct vm_fault *vmf, pfn_t pfn,
> +			     unsigned long fault_size,
> +			     struct address_space *f_mapping)
> +{
> +	unsigned long i;
> +	pgoff_t pgoff;
> +
> +	pgoff = linear_page_index(vmf->vma, ALIGN(vmf->address, fault_size));
> +
> +	for (i = 0; i < fault_size / PAGE_SIZE; i++) {
> +		struct page *page;
> +
> +		page = pfn_to_page(pfn_t_to_pfn(pfn) + i);
> +		if (page->mapping)
> +			continue;
> +		page->mapping = f_mapping;
> +		page->index = pgoff + i;
> +	}
> +}

No need to pass f_mapping here, it must be vmf->vma->vm_file->f_mapping.

> +static void set_compound_mapping(struct vm_fault *vmf, pfn_t pfn,
> +				 unsigned long fault_size,
> +				 struct address_space *f_mapping)
> +{
> +	struct page *head;
> +
> +	head = pfn_to_page(pfn_t_to_pfn(pfn));
> +	head = compound_head(head);
> +	if (head->mapping)
> +		return;
> +
> +	head->mapping = f_mapping;
> +	head->index = linear_page_index(vmf->vma,
> +			ALIGN(vmf->address, fault_size));
> +}

Same here.

>  	if (rc == VM_FAULT_NOPAGE) {
> -		unsigned long i;
> -		pgoff_t pgoff;
> +		struct dev_pagemap *pgmap = dev_dax->pgmap;

If you're touching this anyway:  why not do an early return here for
the error case to simplify the flow?
