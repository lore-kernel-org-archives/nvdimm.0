Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 571AF2236BAB5
 for <linux-nvdimm@lists.01.org>; Mon,  8 Jan 2018 10:39:49 -0800 (PST)
References: <20180104190137.7654-1-logang@deltatee.com>
 <20180104190137.7654-7-logang@deltatee.com> <20180104192225.GS11348@ziepe.ca>
 <1f8fb3fb-e3dc-94d3-e837-0cd942cf5b87@deltatee.com>
 <20180104221337.GV11348@ziepe.ca>
 <3e8391a9-8924-be6d-8c43-162a360d75b6@deltatee.com>
 <20180105045031.GX11348@ziepe.ca> <20180108145901.GA10743@lst.de>
 <20180108180917.GF11348@ziepe.ca> <20180108183434.GA15549@lst.de>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <cffacbee-477a-fbe9-19cc-373cd2ec6fef@deltatee.com>
Date: Mon, 8 Jan 2018 11:44:41 -0700
MIME-Version: 1.0
In-Reply-To: <20180108183434.GA15549@lst.de>
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
To: Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>
List-ID: <linux-nvdimm@lists.01.org>



On 08/01/18 11:34 AM, Christoph Hellwig wrote:
> But P2P is _not_ a factor of the dma_ops implementation at all,
> it is something that happens behind the dma_map implementation.
> 
> Think about what the dma mapping routines do:
> 
>   (a) translate from host address to bus addresses
> 
> and
> 
>   (b) flush caches (in non-coherent architectures)
> 
> Both are obviously not needed for P2P transfers, as they never reach
> the host.

Isn't pci_p2pdma_map_sg doing (a)? It's just translating from a host 
address to a PCI bus address.

>> Very long term the IOMMUs under the ops will need to care about this,
>> so the wrapper is not an optimal place to put it - but I wouldn't
>> object if it gets it out of RDMA :)
> 
> Unless you have an IOMMU on your PCIe switch and not before/inside
> the root complex that is not correct.

Per the ACS discussion, in the future we might want to implement "ACS 
Direct Translated P2P" as Alex described. I expect it would be the IOMMU 
that needs to set that up. So, I think, we also have the dma_map 
implementations also doing something like:

(c) setup/manage any security permissions on mappings
Which P2P may at some point be concerned with.

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
