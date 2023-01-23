Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D312F27;
	Mon, 23 Jan 2023 22:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LdoL9WInNn9g+7kuigf9617DZzkmnyUk0PPwEqtnDNs=; b=Wec3MZQ4Im+pfSZhNixMoikgQp
	dmKOI1VP02JxTetKhMElCRQohV5UlH7bhT0BzBqDbpvYyuJYJWxjXRxbgvhpmeUlzdCIQFeuKq/A0
	jCu0V4X2OYa1fc5HkzlSNF/fHViupU5ybyDv7lCZbWBVBHYVW8M+USztiscjCz+X+nAUnDTxEisH5
	71HMkc7qFGE4VRVNmLKFEizQCLLWsJX+lovKSQVkUc7p3kV9EZQljwmNOGfSh4d1U/PYToPKA1QbI
	n0eZstbbByNQIOrRWB8Kpy8kAFlH6RUnzb9MT7/zm0BKA8LENilntYWJHHi06b8R2qWJKVB4mgozr
	IbueYMUQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1pK5aM-004aMF-EK; Mon, 23 Jan 2023 22:46:42 +0000
Date: Mon, 23 Jan 2023 22:46:42 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: nvdimm@lists.linux.dev, lsf-pc@lists.linuxfoundation.org,
	linux-rdma@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>,
	dri-devel@lists.freedesktop.org, Ming Lei <ming.lei@redhat.com>,
	linux-block@vger.kernel.org, linux-mm@kvack.org,
	iommu@lists.linux.dev, netdev@vger.kernel.org,
	Joao Martins <joao.m.martins@oracle.com>,
	Jason Gunthorpe via Lsf-pc <lsf-pc@lists.linux-foundation.org>,
	Logan Gunthorpe <logang@deltatee.com>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [Lsf-pc] [LSF/MM/BPF proposal]: Physr discussion
Message-ID: <Y88OUobZeJH2ak+s@casper.infradead.org>
References: <Y8v+qVZ8OmodOCQ9@nvidia.com>
 <63cee1d3eaaef_3a36e529488@dwillia2-xfh.jf.intel.com.notmuch>
 <Y87p9i0vCZo/3Qa0@casper.infradead.org>
 <63cef32cbafc3_3a36e529465@dwillia2-xfh.jf.intel.com.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63cef32cbafc3_3a36e529465@dwillia2-xfh.jf.intel.com.notmuch>

On Mon, Jan 23, 2023 at 12:50:52PM -0800, Dan Williams wrote:
> Matthew Wilcox wrote:
> > On Mon, Jan 23, 2023 at 11:36:51AM -0800, Dan Williams wrote:
> > > Jason Gunthorpe via Lsf-pc wrote:
> > > > I would like to have a session at LSF to talk about Matthew's
> > > > physr discussion starter:
> > > > 
> > > >  https://lore.kernel.org/linux-mm/YdyKWeU0HTv8m7wD@casper.infradead.org/
> > > > 
> > > > I have become interested in this with some immediacy because of
> > > > IOMMUFD and this other discussion with Christoph:
> > > > 
> > > >  https://lore.kernel.org/kvm/4-v2-472615b3877e+28f7-vfio_dma_buf_jgg@nvidia.com/
> > > 
> > > I think this is a worthwhile discussion. My main hangup with 'struct
> > > page' elimination in general is that if anything needs to be allocated
> > 
> > You're the first one to bring up struct page elimination.  Neither Jason
> > nor I have that as our motivation.
> 
> Oh, ok, then maybe I misread the concern in the vfio discussion. I
> thought the summary there is debating the ongoing requirement for
> 'struct page' for P2PDMA?

My reading of that thread is that while it started out that way, it
became more about "So what would a good interface be for doing this".  And
Jason's right, he and I are approaching this from different directions.
My concern is from the GUP side where we start out by getting a folio
(which we know is physically contiguous) and decomposing it into pages.
Then we aggregate all those pages together which are physically contiguous
and stuff them into a bio_vec.  After that, I lose interest; I was
planning on having DMA mapping interfaces which took in an array of
phyr and spat out scatterlists.  Then we could shrink the scatterlist
by removing page_link and offset, leaving us with only dma_address,
length and maybe flags.
