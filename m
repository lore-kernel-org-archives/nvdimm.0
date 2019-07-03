Return-Path: <owner-linux-mm@kvack.org>
Date: Wed, 3 Jul 2019 15:13:28 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 20/22] mm: move hmm_vma_fault to nouveau
Message-ID: <20190703181328.GC18673@ziepe.ca>
References: <20190701062020.19239-21-hch@lst.de>
 <20190703180356.GB18673@ziepe.ca>
 <20190703180525.GA13703@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190703180525.GA13703@lst.de>
Sender: owner-linux-mm@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: AlexDeucher <alexander.deucher@amd.com>, Dan Williams <dan.j.williams@intel.com>, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Ben Skeggs <bskeggs@redhat.com>, Ira Weiny <ira.weiny@intel.com>, linux-mm@kvack.org, nouveau@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-nvdimm@lists.01.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jul 03, 2019 at 08:05:25PM +0200, Christoph Hellwig wrote:
> On Wed, Jul 03, 2019 at 03:03:56PM -0300, Jason Gunthorpe wrote:
> > I was thinking about doing exactly this too, but amdgpu started using
> > this already obsolete API in their latest driver :(
> > 
> > So, we now need to get both drivers to move to the modern API.
> 
> Actually the AMD folks fixed this up after we pointed it out to them,
> so even in linux-next it just is nouveau that needs fixing.

Oh, I looked at an older -next, my mistake. Lets do it then.

Jason
