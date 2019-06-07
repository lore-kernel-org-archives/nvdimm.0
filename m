Return-Path: <owner-linux-mm@kvack.org>
Date: Fri, 7 Jun 2019 15:50:19 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH RFC 00/10] RDMA/FS DAX truncate proposal
Message-ID: <20190607185019.GP14802@ziepe.ca>
References: <20190606014544.8339-1-ira.weiny@intel.com>
 <20190606104203.GF7433@quack2.suse.cz>
 <20190606220329.GA11698@iweiny-DESK2.sc.intel.com>
 <20190607110426.GB12765@quack2.suse.cz>
 <20190607182534.GC14559@iweiny-DESK2.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190607182534.GC14559@iweiny-DESK2.sc.intel.com>
Sender: owner-linux-mm@kvack.org
To: Ira Weiny <ira.weiny@intel.com>
Cc: Jan Kara <jack@suse.cz>, Dan Williams <dan.j.williams@intel.com>, Theodore Ts'o <tytso@mit.edu>, Jeff Layton <jlayton@kernel.org>, Dave Chinner <david@fromorbit.com>, Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, John Hubbard <jhubbard@nvidia.com>, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-rdma@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 07, 2019 at 11:25:35AM -0700, Ira Weiny wrote:

> And I think this is related to what Christoph Hellwig is doing with bio_vec and
> dma.  Really we want drivers out of the page processing business.

At least for RDMA, and a few other places I've noticed, I'd really
like to get totally out of the handling struct pages game.

We are DMA based and really only want DMA addresses for the target
device. I know other places need CPU pages or more complicated
things.. But I also know there are other drivers like RDMA..

So I think it would be very helpful to have a driver API something
like:

int get_user_mem_for_dma(struct device *dma_device,
                void __user *mem, size_t length,
                struct gup_handle *res,
                struct 'bio dma list' *dma_list,
                const struct dma_params *params);
void put_user_mem_for_dma(struct gup_handle *res, 
                 struct 'bio dma list' *dma_list);

And we could hope to put in there all the specialty logic we want to
have for this flow:
 - The weird HMM stuff in hmm_range_dma_map()
 - Interaction with DAX
 - Interaction with DMA BUF
 - Holding file leases
 - PCI peer 2 peer features
 - Optimizations for huge pages
 - Handling page dirtying from DMA
 - etc

I think Matthew was suggesting something like this at LS/MM, so +1
from here..

When Christoph sends his BIO dma work I was thinking of investigating
this avenue, as we already have something quite similiar in RDMA that
could perhaps be hoisted out for re-use into mm/

Jason
