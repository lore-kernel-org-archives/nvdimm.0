Return-Path: <owner-linux-mm@kvack.org>
Date: Sat, 15 Jun 2019 16:30:43 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 06/22] mm: factor out a devm_request_free_mem_region
 helper
Message-ID: <20190615143043.GA27825@lst.de>
References: <20190613094326.24093-1-hch@lst.de> <20190613094326.24093-7-hch@lst.de> <56c130b1-5ed9-7e75-41d9-c61e73874cb8@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56c130b1-5ed9-7e75-41d9-c61e73874cb8@nvidia.com>
Sender: owner-linux-mm@kvack.org
To: John Hubbard <jhubbard@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Ben Skeggs <bskeggs@redhat.com>, linux-mm@kvack.org, nouveau@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-nvdimm@lists.01.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 14, 2019 at 07:21:54PM -0700, John Hubbard wrote:
> On 6/13/19 2:43 AM, Christoph Hellwig wrote:
> > Keep the physical address allocation that hmm_add_device does with the
> > rest of the resource code, and allow future reuse of it without the hmm
> > wrapper.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  include/linux/ioport.h |  2 ++
> >  kernel/resource.c      | 39 +++++++++++++++++++++++++++++++++++++++
> >  mm/hmm.c               | 33 ++++-----------------------------
> >  3 files changed, 45 insertions(+), 29 deletions(-)
> 
> Some trivial typos noted below, but this accurately moves the code
> into a helper routine, looks good.

Thanks for the typo spotting.  These two actually were copy and pasted
from the original hmm code, but I'll gladly fix them for the next
iteration.
