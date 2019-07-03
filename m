Return-Path: <owner-linux-mm@kvack.org>
Date: Wed, 3 Jul 2019 15:15:42 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 22/22] mm: remove the legacy hmm_pfn_* APIs
Message-ID: <20190703181542.GD18673@ziepe.ca>
References: <20190701062020.19239-1-hch@lst.de>
 <20190701062020.19239-23-hch@lst.de>
 <20190703180125.GA18673@ziepe.ca>
 <20190703180308.GA13656@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190703180308.GA13656@lst.de>
Sender: owner-linux-mm@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Ben Skeggs <bskeggs@redhat.com>, Ira Weiny <ira.weiny@intel.com>, linux-mm@kvack.org, nouveau@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-nvdimm@lists.01.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jul 03, 2019 at 08:03:08PM +0200, Christoph Hellwig wrote:
> On Wed, Jul 03, 2019 at 03:01:25PM -0300, Jason Gunthorpe wrote:
> > Christoph, I guess you didn't mean to send this branch to the mailing
> > list?
> > 
> > In any event some of these, like this one, look obvious and I could
> > still grab a few for hmm.git.
> > 
> > Let me know what you'd like please
> > 
> > Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
> 
> Thanks.  I was going to send this series out as soon as you had
> applied the previous one.  Now that it leaked I'm happy to collect
> reviews.  But while I've got your attention:  the rdma.git hmm
> branch is still at the -rc7 merge and doen't have my series, is that
> intentional?

Sorry, I rushed it too late at night to do it right apparently. Fixed.

Jason
