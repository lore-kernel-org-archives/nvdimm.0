Return-Path: <owner-linux-mm@kvack.org>
Date: Thu, 27 Jun 2019 10:51:35 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 15/25] memremap: provide an optional internal refcount
 in struct dev_pagemap
Message-ID: <20190627085135.GB11420@lst.de>
References: <20190626122724.13313-1-hch@lst.de> <20190626122724.13313-16-hch@lst.de> <20190626214750.GC8399@iweiny-DESK2.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190626214750.GC8399@iweiny-DESK2.sc.intel.com>
Sender: owner-linux-mm@kvack.org
To: Ira Weiny <ira.weiny@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Ben Skeggs <bskeggs@redhat.com>, linux-nvdimm@lists.01.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, nouveau@lists.freedesktop.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jun 26, 2019 at 02:47:50PM -0700, Ira Weiny wrote:
> > +
> > +		init_completion(&pgmap->done);
> > +		error = percpu_ref_init(&pgmap->internal_ref,
> > +				dev_pagemap_percpu_release, 0, GFP_KERNEL);
> > +		if (error)
> > +			return ERR_PTR(error);
> > +		pgmap->ref = &pgmap->internal_ref;
> > +	} else {
> > +		if (!pgmap->ops || !pgmap->ops->kill || !pgmap->ops->cleanup) {
> > +			WARN(1, "Missing reference count teardown definition\n");
> > +			return ERR_PTR(-EINVAL);
> > +		}
> 
> After this series are there any users who continue to supply their own
> reference object and these callbacks?

Yes, fsdax uses the block layer request_queue reference count.
