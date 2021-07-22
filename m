Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976E0168
	for <nvdimm@lists.linux.dev>; Thu, 22 Jul 2021 02:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=dLP+yOynOGe7mNsLIAGIVj4pAcnAp3u4c0p+GVerGOM=; b=WQ8LAhS5qjh02Hm/qXcWacXOzO
	LcmxTqKGZ6Y2w988GubYidarF5CS9CmsEmff/SEFquuoThjXph/ZZ8f3iDOM8R8fUG1iB6igk6pky
	pPuyDLYpq9n9c0n1tY18goCib6gpCTnWE1l9eSUmEoUDeN9uw+2JEPYo4rjPrNtzT/xSjUxribsJJ
	9BHG3GMl8+1ANgW/krR5J++HfZVbvlqwpodGY5MHl5m32qxxFI9j5p6laDmQV6yqNTSmuhw2BWBQp
	dGOTFzukVbTUtg5RHvUG1td9RUkABn8igkl3ZdSTShoQWQSaWdpIIbzgH4ptqR7pxp3krX8eatFEv
	PXF/bhiA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1m6OOE-009nxI-4s; Thu, 22 Jul 2021 02:24:54 +0000
Date: Thu, 22 Jul 2021 03:24:46 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joao Martins <joao.m.martins@oracle.com>, linux-mm@kvack.org,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Naoya Horiguchi <naoya.horiguchi@nec.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Jane Chu <jane.chu@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Jonathan Corbet <corbet@lwn.net>, nvdimm@lists.linux.dev,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 00/14] mm, sparse-vmemmap: Introduce compound pagemaps
Message-ID: <YPjW7tu1NU0iRaH9@casper.infradead.org>
References: <20210714193542.21857-1-joao.m.martins@oracle.com>
 <20210714144830.29f9584878b04903079ef7eb@linux-foundation.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714144830.29f9584878b04903079ef7eb@linux-foundation.org>

On Wed, Jul 14, 2021 at 02:48:30PM -0700, Andrew Morton wrote:
> On Wed, 14 Jul 2021 20:35:28 +0100 Joao Martins <joao.m.martins@oracle.com> wrote:
> 
> > This series, attempts at minimizing 'struct page' overhead by
> > pursuing a similar approach as Muchun Song series "Free some vmemmap
> > pages of hugetlb page"[0] but applied to devmap/ZONE_DEVICE which is now
> > in mmotm. 
> > 
> > [0] https://lore.kernel.org/linux-mm/20210308102807.59745-1-songmuchun@bytedance.com/
> 
> [0] is now in mainline.
> 
> This patch series looks like it'll clash significantly with the folio
> work and it is pretty thinly reviewed, so I think I'll take a pass for
> now.  Matthew, thoughts?

I had a look through it, and I don't see anything that looks like it'll
clash with the folio patches.  The folio work really touches the page
cache for now, and this seems mostly to touch the devmap paths.

It would be nice to convert the devmap code to folios too, but that
can wait.  The mess with page refcounts needs to be sorted out first.
