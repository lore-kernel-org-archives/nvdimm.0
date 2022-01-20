Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5818F2C82
	for <nvdimm@lists.linux.dev>; Thu, 20 Jan 2022 14:03:44 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4A34668BEB; Thu, 20 Jan 2022 15:03:40 +0100 (CET)
Date: Thu, 20 Jan 2022 15:03:40 +0100
From: Christoph Hellwig <hch@lst.de>
To: Matthew Wilcox <willy@infradead.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Joao Martins <joao.m.martins@oracle.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
	netdev@vger.kernel.org, linux-mm@kvack.org,
	linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org,
	nvdimm@lists.linux.dev
Subject: Re: Phyr Starter
Message-ID: <20220120140340.GC11223@lst.de>
References: <YdyKWeU0HTv8m7wD@casper.infradead.org> <20220111004126.GJ2328285@nvidia.com> <Yd0IeK5s/E0fuWqn@casper.infradead.org> <20220111150142.GL2328285@nvidia.com> <Yd3Nle3YN063ZFVY@casper.infradead.org> <20220111202159.GO2328285@nvidia.com> <Yd311C45gpQ3LqaW@casper.infradead.org> <20220111225306.GR2328285@nvidia.com> <Yd8fz4bY/aMMk24h@casper.infradead.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yd8fz4bY/aMMk24h@casper.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jan 12, 2022 at 06:37:03PM +0000, Matthew Wilcox wrote:
> But let's go further than that (which only brings us to 32 bytes per
> range).  For the systems you care about which use an identity mapping,
> and have sizeof(dma_addr_t) == sizeof(phys_addr_t), we can simply
> point the dma_range pointer to the same memory as the phyr.  We just
> have to not free it too early.  That gets us down to 16 bytes per range,
> a saving of 33%.

Even without an IOMMU the dma_addr_t can have offsets vs the actual
physical address.  Not on x86 except for a weirdo SOC, but just about
everywhere else.
