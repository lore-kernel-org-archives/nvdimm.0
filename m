Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 44A1621154703
 for <linux-nvdimm@lists.01.org>; Fri, 21 Sep 2018 12:47:03 -0700 (PDT)
Date: Fri, 21 Sep 2018 14:47:00 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH v6 06/13] PCI/P2PDMA: Add P2P DMA driver writer's
 documentation
Message-ID: <20180921194700.GM224714@bhelgaas-glaptop.roam.corp.google.com>
References: <20180913001156.4115-1-logang@deltatee.com>
 <20180913001156.4115-7-logang@deltatee.com>
 <20180921164126.GI224714@bhelgaas-glaptop.roam.corp.google.com>
 <e9739430-b238-2078-a51f-d76bae5342d1@deltatee.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <e9739430-b238-2078-a51f-d76bae5342d1@deltatee.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Jens Axboe <axboe@kernel.dk>, Alex Williamson <alex.williamson@redhat.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Sep 21, 2018 at 12:03:12PM -0600, Logan Gunthorpe wrote:
> On 2018-09-21 10:41 AM, Bjorn Helgaas wrote:
> >> +away, the one returned will be chosen at random. This function returns the PCI
> > 
> > s/the one returned will be chosen at random/one will be chosen
> > arbitrarily/ ?  (I doubt it's really random)
> 
> You're the second person to ask this, but yes, we really do it randomly.
> Such that if there are multiple drivers getting resources they should be
> evenly distributed. It's not the ideal solution but if it were to do it
> arbitrarily then the code would likely return the same device all the
> time and any additional devices would not get used.

Ah, I see, I should have searched for "random" in that patch and answered
my own question :)  Sorry for the noise.

Bjorn
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
