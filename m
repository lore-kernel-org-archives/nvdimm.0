Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149FD3E8674;
	Wed, 25 Mar 2026 16:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774455665; cv=none; b=pKrVVKAWhWvludzKBl3/SrlLlyrrjF3QnraZ4guC+NXM4F+r+yiIdlFM2RbEHEx+dxB/i1wqEMQG+qr6ABezz/jgH2dtQQRTFAUiQtOYpmZq7nAyd4SEFUD1VAE1cx3UgdCYoPL52JGILjUOPOY8AJDv17Ueab+atKz6B3o58jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774455665; c=relaxed/simple;
	bh=Mp1C8uMxxYv3PANUHWINKbqxycLFn539lBbC90jp5lM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QpmK5UnxUZoPvS4SpzTSWmfG/RwiZ2PZT8NAATP/DbQ3xd7d6aQoEq+/dqMrUtF+3ulb28dpzoTc6j1eARu3bnnFpb7VnvvrtLO9X60K0sHMBYI26CETE6EqCOmnELtYLdo4C8bpOADqmFVUgTr0DZt6gc4RLGMmwbj9y26KVCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DCx2cd6z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DCx2cd6z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44374C4CEF7;
	Wed, 25 Mar 2026 16:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774455664;
	bh=Mp1C8uMxxYv3PANUHWINKbqxycLFn539lBbC90jp5lM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DCx2cd6zdjs5WTU0Ci34/oFQ5wXmmkfSsnBz8cMDfEve+sYMCeXPhZU1jOQ/lqQ6J
	 K4fkBqOO0AYOHqX8kdOutVBupk+dZ4inVj6O/4xS800zVfx9V5aJBWzRMhP4QeyEj7
	 dFL7a0cGWZMFi7C3k11k5mMb804D14ZLSuN5c4fUUJiZDNW6RSxOstKalegopwBm1F
	 QPS9KU6uR+nSOcUitxRacDeRokQQd62w8D1jSPIPoEV6V4iHwbFPoCuFPZr0PWaKrZ
	 rzICz3Ro0D4xW72Cz4CSSfywCrOmJ1StSpNEjTTlf9N+GbSJT6ISjmIxo9uRhYdXMM
	 4GvoqkIw17B0g==
Date: Wed, 25 Mar 2026 16:20:52 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Gao Xiang <xiang@kernel.org>, 
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Tony Luck <tony.luck@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Dave Martin <Dave.Martin@arm.com>, James Morse <james.morse@arm.com>, 
	Babu Moger <babu.moger@amd.com>, Damien Le Moal <dlemoal@kernel.org>, 
	Naohiro Aota <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-mm@kvack.org, 
	ntfs3@lists.linux.dev, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/6] mm: add vma_desc_test_all() and use it
Message-ID: <ef1e4362-4922-4857-8211-fca47031b63e@lucifer.local>
References: <cover.1772704455.git.ljs@kernel.org>
 <568c8f8d6a84ff64014f997517cba7a629f7eed6.1772704455.git.ljs@kernel.org>
 <20260324161212.4b0a6f4fd5eb57ff2ffa7ea5@linux-foundation.org>
 <24163ac9-bb0d-402c-a028-d1af7f56caa1@lucifer.local>
 <20260325073054.490f2e9658cbd75312732fbd@linux-foundation.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325073054.490f2e9658cbd75312732fbd@linux-foundation.org>

On Wed, Mar 25, 2026 at 07:30:54AM -0700, Andrew Morton wrote:
> On Wed, 25 Mar 2026 07:08:22 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:
>
> > On Tue, Mar 24, 2026 at 04:12:12PM -0700, Andrew Morton wrote:
> > > On Thu,  5 Mar 2026 10:50:15 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:
> > >
> > > > erofs and zonefs are using vma_desc_test_any() twice to check whether all
> > > > of VMA_SHARED_BIT and VMA_MAYWRITE_BIT are set, this is silly, so add
> > > > vma_desc_test_all() to test all flags and update erofs and zonefs to use
> > > > it.
> > > >
> > > > While we're here, update the helper function comments to be more
> > > > consistent.
> > > >
> > > > Also add the same to the VMA test headers.
> > >
> > > fwiw, we have no review tags on this one.
> >
> > Based on the discussion we had about this previously I was under the impression
> > if submitted by a maintainer that wasn't required?
>
> Well, it's a gray area.  Obviously it's better if people's stuff is
> checked by co-maintainers or by others.

OK that contradicts the previous conversation we had where you had to
convince me that this was ok (which I ended up agreeing with), rather than
being a grey area.

We had quite a long conversation about maintainers are in a trusted role so
a co-maintainer would have called it out it was wrong and etc.

But sure it'd be nice to get review, obviously I agree with that.

>
> I'm not inclined to make a fuss about it though (hence "fwiw").  Quite
> a lot of unreviewed maintainer-authored material ends up going upstream
> and I don't think that's causing much harm.

I think you need to be a lot clearer in communicating these things while
the process remains undocumented.

In this case for instance, I took that to mean that you required review,
the 'fwiw' doesn't really make it clear that this was optional, especially
given this patch is so trivial.

>
> In a lot of cases this is pretty much unavoidable because the patch
> comes from a sole maintainer (SJ, Sergey, Ulad, Liam come to mind).
> But when the author has co-maintainers, perhaps those people could step
> up.

Right.

>
> > I'll nag people, but I'm a bit surprised if this is why you haven't moved this
> > to mm-stable, given how trivially obviously correct this patch is.
>
> https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/pc/devel-series
> shows my expected merging order.  It looks like this one will be in the
> next batch ->mm-stable.
>

I'll definietly need some decoding of that to understand where each batch
is?

To me it reads as a bunch of inscrutible #'s and file names...

Thanks, Lorenzo
