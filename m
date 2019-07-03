Return-Path: <owner-linux-mm@kvack.org>
Date: Wed, 3 Jul 2019 20:05:25 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 20/22] mm: move hmm_vma_fault to nouveau
Message-ID: <20190703180525.GA13703@lst.de>
References: <20190701062020.19239-21-hch@lst.de> <20190703180356.GB18673@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190703180356.GB18673@ziepe.ca>
Sender: owner-linux-mm@kvack.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Christoph Hellwig <hch@lst.de>, AlexDeucher <alexander.deucher@amd.com>, Dan Williams <dan.j.williams@intel.com>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Ben Skeggs <bskeggs@redhat.com>, Ira Weiny <ira.weiny@intel.com>, linux-mm@kvack.org, nouveau@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-nvdimm@lists.01.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jul 03, 2019 at 03:03:56PM -0300, Jason Gunthorpe wrote:
> I was thinking about doing exactly this too, but amdgpu started using
> this already obsolete API in their latest driver :(
> 
> So, we now need to get both drivers to move to the modern API.

Actually the AMD folks fixed this up after we pointed it out to them,
so even in linux-next it just is nouveau that needs fixing.
