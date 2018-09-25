Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3FD7221A07A80
 for <linux-nvdimm@lists.01.org>; Tue, 25 Sep 2018 10:42:02 -0700 (PDT)
References: <20180925162231.4354-1-logang@deltatee.com>
 <20180925162231.4354-11-logang@deltatee.com>
 <20180925171147.GB11822@localhost.localdomain>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <3549a9bb-3604-1739-c008-4e1a95441333@deltatee.com>
Date: Tue, 25 Sep 2018 11:41:44 -0600
MIME-Version: 1.0
In-Reply-To: <20180925171147.GB11822@localhost.localdomain>
Content-Language: en-US
Subject: Re: [PATCH v7 10/13] nvme-pci: Add support for P2P memory in requests
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
To: Keith Busch <keith.busch@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, Alex Williamson <alex.williamson@redhat.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Hey,

On 2018-09-25 11:11 a.m., Keith Busch wrote:
> Sorry if this was already discussed. Is there a reason the following
> pattern is not pushed to the generic dma_map_sg_attrs?
> 
> 	if (is_pci_p2pdma_page(sg_page(sg)))
> 		pci_p2pdma_map_sg(dev, sg, nents, dma_dir);
> 
> Beyond that, series looks good.

Yes, this has been discussed. It comes down to a few reasons:

1) Intrusiveness on other systems: ie. not needing to pay the cost for
every single dma_map_sg call

2) Consistency: we can add the check to dma_map_sg, but adding similar
functionality to dma_map_page, etc is difficult seeing it's hard for the
unmap operation to detect if a dma_addr_t was P2P memory to begin with.

3) Safety for developers trying to use P2P memory: Right now developers
must be careful with P2P pages and ensure they aren't mapped using other
means (ie dma_map_page). Having them check the drivers that are handling
the pages to ensure the appropriate map function is always used is and
that P2P pages aren't being mixed with regular pages is better than
developers relying on magic in dma_map_sg() and getting things wrong.

That being said, I think in the future everyone would like to move in
that direction but it means we will have to solve some difficult
problems with the existing infrastructure.

Logan

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
