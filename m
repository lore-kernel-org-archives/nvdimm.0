Return-Path: <owner-linux-mm@kvack.org>
Date: Mon, 12 Aug 2019 17:00:12 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5/5] memremap: provide a not device managed
 memremap_pages
Message-ID: <20190812150012.GA12700@lst.de>
References: <20190811081247.22111-1-hch@lst.de> <20190811081247.22111-6-hch@lst.de> <20190812145058.GA16950@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190812145058.GA16950@in.ibm.com>
Sender: owner-linux-mm@kvack.org
To: Bharata B Rao <bharata@linux.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Jason Gunthorpe <jgg@mellanox.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Aug 12, 2019 at 08:20:58PM +0530, Bharata B Rao wrote:
> On Sun, Aug 11, 2019 at 10:12:47AM +0200, Christoph Hellwig wrote:
> > The kvmppc ultravisor code wants a device private memory pool that is
> > system wide and not attached to a device.  Instead of faking up one
> > provide a low-level memremap_pages for it.  Note that this function is
> > not exported, and doesn't have a cleanup routine associated with it to
> > discourage use from more driver like users.
> 
> The kvmppc secure pages management code will be part of kvm-hv which
> can be built as module too. So it would require memremap_pages() to be
> exported.
> 
> Additionally, non-dev version of the cleanup routine
> devm_memremap_pages_release() or equivalent would also be requried.
> With device being present, put_device() used to take care of this
> cleanup.

Oh well.  We can add them fairly easily if we really need to, but I
tried to avoid that.  Can you try to see if this works non-modular
for you for now until we hear more feedback from Dan?
