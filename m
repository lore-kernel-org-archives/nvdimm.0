Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6530B68
	for <nvdimm@lists.linux.dev>; Thu, 25 Nov 2021 06:11:36 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0B8A268B05; Thu, 25 Nov 2021 07:11:31 +0100 (CET)
Date: Thu, 25 Nov 2021 07:11:30 +0100
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
Subject: Re: [PATCH v6 04/10] mm/memremap: add ZONE_DEVICE support for
 compound pages
Message-ID: <20211125061130.GA682@lst.de>
References: <20211124191005.20783-1-joao.m.martins@oracle.com> <20211124191005.20783-5-joao.m.martins@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211124191005.20783-5-joao.m.martins@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Nov 24, 2021 at 07:09:59PM +0000, Joao Martins wrote:
> Add a new @vmemmap_shift property for struct dev_pagemap which specifies that a
> devmap is composed of a set of compound pages of order @vmemmap_shift, instead of
> base pages. When a compound page devmap is requested, all but the first
> page are initialised as tail pages instead of order-0 pages.

Please wrap commit log lines after 73 characters.

>  #define for_each_device_pfn(pfn, map, i) \
> -	for (pfn = pfn_first(map, i); pfn < pfn_end(map, i); pfn = pfn_next(pfn))
> +	for (pfn = pfn_first(map, i); pfn < pfn_end(map, i); pfn = pfn_next(map, pfn))

It would be nice to fix up this long line while you're at it.

>  static void dev_pagemap_kill(struct dev_pagemap *pgmap)
>  {
> @@ -315,8 +315,8 @@ static int pagemap_range(struct dev_pagemap *pgmap, struct mhp_params *params,
>  	memmap_init_zone_device(&NODE_DATA(nid)->node_zones[ZONE_DEVICE],
>  				PHYS_PFN(range->start),
>  				PHYS_PFN(range_len(range)), pgmap);
> -	percpu_ref_get_many(pgmap->ref, pfn_end(pgmap, range_id)
> -			- pfn_first(pgmap, range_id));
> +	percpu_ref_get_many(pgmap->ref, (pfn_end(pgmap, range_id)
> +			- pfn_first(pgmap, range_id)) >> pgmap->vmemmap_shift);

In the Linux coding style the - goes ointo the first line.

But it would be really nice to clean this up with a helper ala pfn_len
anyway:

	percpu_ref_get_many(pgmap->ref,
			    pfn_len(pgmap, range_id) >> pgmap->vmemmap_shift);
