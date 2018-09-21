Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4F59221154139
 for <linux-nvdimm@lists.01.org>; Fri, 21 Sep 2018 09:48:14 -0700 (PDT)
Date: Fri, 21 Sep 2018 11:48:13 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH v6 03/13] PCI/P2PDMA: Add PCI p2pmem DMA mappings to
 adjust the bus offset
Message-ID: <20180921164813.GJ224714@bhelgaas-glaptop.roam.corp.google.com>
References: <20180913001156.4115-1-logang@deltatee.com>
 <20180913001156.4115-4-logang@deltatee.com>
 <20180921131550.GG224714@bhelgaas-glaptop.roam.corp.google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180921131550.GG224714@bhelgaas-glaptop.roam.corp.google.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, Alex Williamson <alex.williamson@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Sep 21, 2018 at 08:15:50AM -0500, Bjorn Helgaas wrote:
> On Wed, Sep 12, 2018 at 06:11:46PM -0600, Logan Gunthorpe wrote:
> > The DMA address used when mapping PCI P2P memory must be the PCI bus
> > address. Thus, introduce pci_p2pmem_map_sg() to map the correct
> > addresses when using P2P memory. Memory mapped in this way does not
> > need to be unmapped.
> 
> I think the use of "map" in this context is slightly confusing because the
> general expectation is that map/unmap must be balanced.
> 
> I assume it's because the "mapping" consumes no resources, e.g., requires
> no page table entries.  Possibly there's a better verb than "map", e.g.,
> "convert", "convert_to_p2pdma", etc?
> 
> If you keep "map", maybe add a sentence or two about why there's no
> corresponding unmap?

Another wrinkle is that "map" usually takes an A and gives you back a
B.  Now the caller has both A and B and both are still valid.

Here we pass in an SGL and the SGL is transformed, so the caller only
has B and A has been destroyed, i.e., the SGL can no longer be used as
it was before, and there's no way to get A back.

Maybe this is pointless bikeshedding, so if your color is the best,
don't change anything.

Bjorn
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
