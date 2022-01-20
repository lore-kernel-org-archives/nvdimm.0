Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B1F2C80
	for <nvdimm@lists.linux.dev>; Thu, 20 Jan 2022 15:29:03 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0BD2C68BEB; Thu, 20 Jan 2022 16:28:59 +0100 (CET)
Date: Thu, 20 Jan 2022 16:28:58 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@nvidia.com>,
	Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
	Joao Martins <joao.m.martins@oracle.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
	netdev@vger.kernel.org, linux-mm@kvack.org,
	linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org,
	nvdimm@lists.linux.dev
Subject: Re: Phyr Starter
Message-ID: <20220120152858.GA13263@lst.de>
References: <YdyKWeU0HTv8m7wD@casper.infradead.org> <20220111004126.GJ2328285@nvidia.com> <20220120135602.GA11223@lst.de> <20220120152736.GB383746@dhcp-10-100-145-180.wdc.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220120152736.GB383746@dhcp-10-100-145-180.wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jan 20, 2022 at 07:27:36AM -0800, Keith Busch wrote:
> It doesn't look like IOMMU page sizes are exported, or even necessarily
> consistently sized on at least one arch (power).

At the DMA API layer dma_get_merge_boundary is the API for it.
