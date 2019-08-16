Return-Path: <owner-linux-mm@kvack.org>
Date: Fri, 16 Aug 2019 14:36:07 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: add a not device managed memremap_pages v2
Message-ID: <20190816123607.GA22681@lst.de>
References: <20190816065434.2129-1-hch@lst.de> <20190816123356.GE5412@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190816123356.GE5412@mellanox.com>
Sender: owner-linux-mm@kvack.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Bharata B Rao <bharata@linux.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

> > Changes since v1:
> >  - don't overload devm_request_free_mem_region
> >  - export the memremap_pages and munmap_pages as kvmppc can be a module
> 
> What tree do we want this to go through? Dan are you running a pgmap
> tree still? Do we know of any conflicts?

The last changes in this area went through the hmm tree.  There are
now known conflicts, and the kvmppc drivers that needs this already
has a dependency on the hmm tree for the migrate_vma_* changes.
