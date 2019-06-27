Return-Path: <owner-linux-mm@kvack.org>
Date: Thu, 27 Jun 2019 18:54:28 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 03/25] mm: remove hmm_devmem_add_resource
Message-ID: <20190627165428.GC10652@lst.de>
References: <20190626122724.13313-1-hch@lst.de> <20190626122724.13313-4-hch@lst.de> <20190627161813.GB9499@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190627161813.GB9499@mellanox.com>
Sender: owner-linux-mm@kvack.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Ben Skeggs <bskeggs@redhat.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>, Michal Hocko <mhocko@suse.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 27, 2019 at 04:18:22PM +0000, Jason Gunthorpe wrote:
> On Wed, Jun 26, 2019 at 02:27:02PM +0200, Christoph Hellwig wrote:
> > This function has never been used since it was first added to the kernel
> > more than a year and a half ago, and if we ever grow a consumer of the
> > MEMORY_DEVICE_PUBLIC infrastructure it can easily use devm_memremap_pages
> > directly.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
> > Reviewed-by: John Hubbard <jhubbard@nvidia.com>
> > Acked-by: Michal Hocko <mhocko@suse.com>
> > ---
> >  include/linux/hmm.h |  3 ---
> >  mm/hmm.c            | 50 ---------------------------------------------
> >  2 files changed, 53 deletions(-)
> 
> This should be squashed to the new earlier patch?

We could do that.  Do you just want to do that when you apply it?
