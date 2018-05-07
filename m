Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 749BC203BEA25
 for <linux-nvdimm@lists.01.org>; Mon,  7 May 2018 16:02:10 -0700 (PDT)
Date: Mon, 7 May 2018 18:02:08 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH v4 03/14] PCI/P2PDMA: Add PCI p2pmem dma mappings to
 adjust the bus offset
Message-ID: <20180507230208.GF161390@bhelgaas-glaptop.roam.corp.google.com>
References: <20180423233046.21476-1-logang@deltatee.com>
 <20180423233046.21476-4-logang@deltatee.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180423233046.21476-4-logang@deltatee.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Alex Williamson <alex.williamson@redhat.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

s/dma/DMA/ (in subject)

On Mon, Apr 23, 2018 at 05:30:35PM -0600, Logan Gunthorpe wrote:
> The DMA address used when mapping PCI P2P memory must be the PCI bus
> address. Thus, introduce pci_p2pmem_[un]map_sg() to map the correct
> addresses when using P2P memory.
> 
> For this, we assume that an SGL passed to these functions contain all
> P2P memory or no P2P memory.
> 
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
