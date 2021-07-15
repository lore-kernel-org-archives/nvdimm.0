Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8862D72
	for <nvdimm@lists.linux.dev>; Thu, 15 Jul 2021 13:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zEE2nfRfHuUPirbJkDMcOoVwEDE+zjPwjDDORrIirKk=; b=BL8T/G9GnAZDrpcJeud1pe4uRj
	ATOguswZSWPE75WODgr2IDqJni49D1lvCTSeg9hW/z0Xj6gzwQAgLvXAAYjvMpygC3FxToq3Q+WHA
	GMrzHIZAWzIo9qdQg8jOCST9EbAsV2K1p4GAzxuEaV7w9LrRHHFZ8XmykgTmNtOFKWm7fXo6svmKT
	M0PgRf7DueoCNHiY8CwwBvOpRKNxYhaNHbwIVoVIZ/jA1Hbl59Cu9jLN4pp2YrceTUydr8TBDrCZ7
	kvBOxWKwbqslJy9MBupzFMOB1N0abOaT880jjZ9KGlnj7uRq0SyOeq5TsCq4X2rzqaKE1iW7qIlR0
	lTHqb1BQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1m40xF-003MIx-3g; Thu, 15 Jul 2021 12:59:13 +0000
Date: Thu, 15 Jul 2021 13:59:05 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Joao Martins <joao.m.martins@oracle.com>, Linux MM <linux-mm@kvack.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Naoya Horiguchi <naoya.horiguchi@nec.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Jane Chu <jane.chu@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v3 04/14] mm/memremap: add ZONE_DEVICE support for
 compound pages
Message-ID: <YPAxGcVa9QkSd7E7@infradead.org>
References: <20210714193542.21857-1-joao.m.martins@oracle.com>
 <20210714193542.21857-5-joao.m.martins@oracle.com>
 <CAPcyv4jwd_dzTH1H+cbiKqfK5=Xaa9JY=EVKHhPbjicVZA-URQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4jwd_dzTH1H+cbiKqfK5=Xaa9JY=EVKHhPbjicVZA-URQ@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jul 14, 2021 at 06:08:14PM -0700, Dan Williams wrote:
> > +static inline unsigned long pgmap_geometry(struct dev_pagemap *pgmap)
> > +{
> > +       if (!pgmap || !pgmap->geometry)
> > +               return PAGE_SIZE;
> > +       return pgmap->geometry;
> > +}
> > +
> > +static inline unsigned long pgmap_pfn_geometry(struct dev_pagemap *pgmap)
> > +{
> > +       return PHYS_PFN(pgmap_geometry(pgmap));
> > +}
> 
> Are both needed? Maybe just have ->geometry natively be in nr_pages
> units directly, because pgmap_pfn_geometry() makes it confusing
> whether it's a geometry of the pfn or the geometry of the pgmap.

Actually - do we need non-power of two sizes here?  Otherwise a shift
for the pfns would be really nice as that simplifies a lot of the
calculations.
