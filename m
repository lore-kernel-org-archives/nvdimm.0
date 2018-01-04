Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8759A2236BA89
 for <linux-nvdimm@lists.01.org>; Thu,  4 Jan 2018 11:47:31 -0800 (PST)
References: <20180104190137.7654-1-logang@deltatee.com>
 <20180104190137.7654-7-logang@deltatee.com> <20180104192225.GS11348@ziepe.ca>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <1f8fb3fb-e3dc-94d3-e837-0cd942cf5b87@deltatee.com>
Date: Thu, 4 Jan 2018 12:52:24 -0700
MIME-Version: 1.0
In-Reply-To: <20180104192225.GS11348@ziepe.ca>
Content-Language: en-US
Subject: Re: [PATCH 06/12] IB/core: Add optional PCI P2P flag to
 rdma_rw_ctx_[init|destroy]()
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>



On 04/01/18 12:22 PM, Jason Gunthorpe wrote:
> This seems really clunky since we are going to want to do this same
> logic all over the place.
> 
> I'd be much happier if dma_map_sg can tell the memory is P2P or not
> from the scatterlist or dir arguments and not require the callers to
> have this.

We tried things like this in an earlier iteration[1] which assumed the 
SG was homogenous (all P2P or all regular memory). This required serious 
ugliness to try and ensure SGs were in fact homogenous[2]. If you don't 
assume homogenousness you need change every DMA mapping provider or have 
a way to efficiently know if the SGL contains any P2P pages.

Unfortunately, it's hard to do any of this without significant 
improvements to the SGL code (like [3]) but I understand there's 
significant push back against such changes at this time.

> For instance adding DMA_TO_P2P_DEVICE and DMA_FROM_P2P_DEVICE, or
> adding another bit to the page flags in scatterlist.

Creating new direction flags doesn't really solve the problem you point 
out. It'd only really work in the rdma_rw_ctx_init() case because that 
function already takes the direction argument. It doesn't work in the 
similar block device case because the DMA direction isn't passed through 
the request.

Though, if there's agreement to do something like that I'm not against it.

> The signature of pci_p2pmem_map_sg also doesn't look very good, it
> should mirror the usual dma_map_sg, otherwise it needs more revision
> to extend this to do P2P through a root complex.

Generally, the feedback that I get is to not make changes that try to 
anticipate the future. It would be easy enough to add those arguments 
when the code for going through the RC is made (which I expect will be 
very involved anyway).

Logan

[1] 
https://github.com/sbates130272/linux-p2pmem/commit/af3d3742669511c343c2c5bfbbfaccc325bee80a
[2] 
https://github.com/sbates130272/linux-p2pmem/commit/61ec04fa63c79dab14570ea0e97432d9325ad127
[3] 
https://github.com/sbates130272/linux-p2pmem/commit/d8635a4de3c674b577b95653d431fd61c2504ccd
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
