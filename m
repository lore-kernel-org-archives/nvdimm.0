Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4811E2C82
	for <nvdimm@lists.linux.dev>; Thu, 20 Jan 2022 13:39:16 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 906E668BEB; Thu, 20 Jan 2022 14:39:11 +0100 (CET)
Date: Thu, 20 Jan 2022 14:39:11 +0100
From: Christoph Hellwig <hch@lst.de>
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
	netdev@vger.kernel.org, linux-mm@kvack.org,
	linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org,
	nvdimm@lists.linux.dev
Subject: Re: Phyr Starter
Message-ID: <20220120133911.GA11052@lst.de>
References: <YdyKWeU0HTv8m7wD@casper.infradead.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YdyKWeU0HTv8m7wD@casper.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jan 10, 2022 at 07:34:49PM +0000, Matthew Wilcox wrote:
> TLDR: I want to introduce a new data type:
> 
> struct phyr {
>         phys_addr_t addr;
>         size_t len;
> };
> 
> and use it to replace bio_vec as well as using it to replace the array
> of struct pages used by get_user_pages() and friends.

FYI, I've done a fair amount of work (some already mainline as in all
the helpers for biovec page access), some of it still waiting (switching
more users over to these helpers and cleaning up some other mess)
to move bio_vecs into a form like that.  The difference in my plan
is to have a u32 len, both to allow for flags space on 64-bit which
we might need to support things like P2P without dev_pagemap structures.

> Finally, it may be possible to stop using scatterlist to describe the
> input to the DMA-mapping operation.  We may be able to get struct
> scatterlist down to just dma_address and dma_length, with chaining
> handled through an enclosing struct.

Yes, I have some prototype could that takes a bio_vec as input and
returns an array of

struct dma_range {
	dma_addr_t	addr;
	u32		len;
}

І need to get back to it and especially back to the question if this
needs the chaining support that the current scatterlist has.
