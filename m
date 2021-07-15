Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED3A72
	for <nvdimm@lists.linux.dev>; Thu, 15 Jul 2021 06:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=RytKYXm4KX75fZPuEx0/hV8/+9xmwDuSUAB8ht171wA=; b=mltIaCBwgrX66P0slkl+2j+B2M
	rQrOgnmLTMAs3lfTc48w2haDkZU6ODizMF0ERmJ3rMuFv0dicbWjMOJPX/JnCvz3KxRNLIeWd4lYJ
	p2k/zVvo9eyxktFhj7M7A+IB3rD/y6eYaoUCVplS4x2lsGcYtleIjrvsbUqF19Fz1rhUZ3iIo898m
	5pR0/tPZYKxv5WrYNtBOK0Y6HmGquYQ1rZo54fWqsFBUDvSURWyJSIyVljogEZAMWU3B7HrqWo/K0
	3P8MEpaaYnzPWhWoYO30Y7EfyoH0uLrNLrkKkqDc4oN7qnSoCsLQEcvD8yh41zwsc53k67cIJXoRK
	PEvqzC1A==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1m3vAy-0034Lh-O9; Thu, 15 Jul 2021 06:49:15 +0000
Date: Thu, 15 Jul 2021 07:48:52 +0100
From: Christoph Hellwig <hch@infradead.org>
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
	Jonathan Corbet <corbet@lwn.net>, nvdimm@lists.linux.dev,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 04/14] mm/memremap: add ZONE_DEVICE support for
 compound pages
Message-ID: <YO/aVLL2WlWkKXia@infradead.org>
References: <20210714193542.21857-1-joao.m.martins@oracle.com>
 <20210714193542.21857-5-joao.m.martins@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714193542.21857-5-joao.m.martins@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

> +static inline unsigned long pgmap_geometry(struct dev_pagemap *pgmap)
> +{
> +	if (!pgmap || !pgmap->geometry)
> +		return PAGE_SIZE;
> +	return pgmap->geometry;

Nit, but avoiding all the negations would make this a little easier to
read:

	if (pgmap && pgmap->geometry)
		return pgmap->geometry;
	return PAGE_SIZE

> +	if (pgmap_geometry(pgmap) > PAGE_SIZE)
> +		percpu_ref_get_many(pgmap->ref, (pfn_end(pgmap, range_id)
> +			- pfn_first(pgmap, range_id)) / pgmap_pfn_geometry(pgmap));
> +	else
> +		percpu_ref_get_many(pgmap->ref, pfn_end(pgmap, range_id)
> +				- pfn_first(pgmap, range_id));

This is a horrible undreadable mess, which is trivially fixed by a
strategically used local variable:

	refs = pfn_end(pgmap, range_id) - pfn_first(pgmap, range_id);
	if (pgmap_geometry(pgmap) > PAGE_SIZE)
		refs /= pgmap_pfn_geometry(pgmap);
	percpu_ref_get_many(pgmap->ref, refs);

