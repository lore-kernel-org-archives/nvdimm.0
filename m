Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D551DFD8
	for <nvdimm@lists.linux.dev>; Tue,  2 Jul 2024 11:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719921117; cv=none; b=rIkM1IMyWr2X/D2TTzzv3sepugnbU8cLk+1evW6UvHrTgax2sZnYkVonPkpeFR5AXI/bMNdceHu5NAFca78V4XLQ8dnU9UQxQ96/Y2SlpwNJf+HXKWFsHyQ0BSb7IcGSK/cgW0mayU1j0GTOP3pu8a3JBXIloOBEa3lXpcFCd38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719921117; c=relaxed/simple;
	bh=FEnpvishjCAzWVQUMT7jQW/jici2ageO5mrvsiNPeQg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qZXhXDKXQwI6SUkFShiWBJwidV2fViWgDI7LyTUngP4wLTcfkK5YdsYGmuovvJ1qRP5sdZUOdndkU5wqc75i36Kr2XN+GIuEMQrb/TCUJYzss73FX27iIj19DeRAynSqoL6DXJKqLBafykPHk6Bi3EM1hI5qe6Pc846kz5vtAF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D343968AA6; Tue,  2 Jul 2024 13:51:51 +0200 (CEST)
Date: Tue, 2 Jul 2024 13:51:51 +0200
From: Christoph Hellwig <hch@lst.de>
To: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>, dan.j.williams@intel.com,
	vishal.l.verma@intel.com, dave.jiang@intel.com, logang@deltatee.com,
	bhelgaas@google.com, jack@suse.cz, jgg@ziepe.ca,
	catalin.marinas@arm.com, will@kernel.org, mpe@ellerman.id.au,
	npiggin@gmail.com, dave.hansen@linux.intel.com, ira.weiny@intel.com,
	willy@infradead.org, djwong@kernel.org, tytso@mit.edu,
	linmiaohe@huawei.com, peterx@redhat.com, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, jhubbard@nvidia.com, hch@lst.de,
	david@fromorbit.com
Subject: Re: [PATCH 07/13] huge_memory: Allow mappings of PUD sized pages
Message-ID: <20240702115151.GA16313@lst.de>
References: <cover.66009f59a7fe77320d413011386c3ae5c2ee82eb.1719386613.git-series.apopple@nvidia.com> <bd332b0d3971b03152b3541f97470817c5147b51.1719386613.git-series.apopple@nvidia.com> <cf572c69-a754-4d41-b9c4-7a079b25b3c3@redhat.com> <874j98gjfg.fsf@nvdebian.thelocal>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874j98gjfg.fsf@nvdebian.thelocal>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jul 02, 2024 at 08:19:01PM +1000, Alistair Popple wrote:
> > (B) As long as we have subpage mapcounts, this prevents vmemmap
> >     optimizations [1]. Is that only used for device-dax for now and are
> >     there no plans to make use of that for fs-dax?
> 
> I don't have any plans to. This is purely focussed on refcounting pages
> "like normal" so we can get rid of all the DAX special casing.
> 
> > (C) We managed without so far :)
> 
> Indeed, although Christoph has asked repeatedly ([1], [2] and likely
> others) that this gets fixed and I finally got sick of it coming up
> everytime I need to touch something with ZONE_DEVICE pages :)
> 
> Also it removes the need for people to understand the special DAX page
> recounting scheme and ends up removing a bunch of cruft as a bonus:
> 
>  59 files changed, 485 insertions(+), 869 deletions(-)
> 
> And that's before I clean up all the pgmap reference handling. It also
> removes the pXX_trans_huge and pXX_leaf distinction. So we managed, but
> things could be better IMHO.

Yes.  I can't wait for this series making the finish line.  There might
be more chance for cleanups and optimizations around ZONE_DEVICE, but
this alone is a huge step forward.

