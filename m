Return-Path: <owner-linux-mm@kvack.org>
Date: Wed, 3 Jul 2019 15:01:25 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 22/22] mm: remove the legacy hmm_pfn_* APIs
Message-ID: <20190703180125.GA18673@ziepe.ca>
References: <20190701062020.19239-1-hch@lst.de>
 <20190701062020.19239-23-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190701062020.19239-23-hch@lst.de>
Sender: owner-linux-mm@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Ben Skeggs <bskeggs@redhat.com>, Ira Weiny <ira.weiny@intel.com>, linux-mm@kvack.org, nouveau@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-nvdimm@lists.01.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jul 01, 2019 at 08:20:20AM +0200, Christoph Hellwig wrote:
> Switch the one remaining user in nouveau over to its replacement,
> and remove all the wrappers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>  drivers/gpu/drm/nouveau/nouveau_dmem.c |  2 +-
>  include/linux/hmm.h                    | 36 --------------------------
>  2 files changed, 1 insertion(+), 37 deletions(-)

Christoph, I guess you didn't mean to send this branch to the mailing
list?

In any event some of these, like this one, look obvious and I could
still grab a few for hmm.git.

Let me know what you'd like please

Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>

Thanks,
Jason
