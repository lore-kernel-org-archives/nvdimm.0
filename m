Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4C44C222275A5
 for <linux-nvdimm@lists.01.org>; Mon,  8 Jan 2018 10:12:55 -0800 (PST)
References: <20180104190137.7654-1-logang@deltatee.com>
 <20180104190137.7654-7-logang@deltatee.com> <20180104192225.GS11348@ziepe.ca>
 <1f8fb3fb-e3dc-94d3-e837-0cd942cf5b87@deltatee.com>
 <20180104221337.GV11348@ziepe.ca>
 <3e8391a9-8924-be6d-8c43-162a360d75b6@deltatee.com>
 <20180105045031.GX11348@ziepe.ca> <20180108145901.GA10743@lst.de>
 <20180108180917.GF11348@ziepe.ca>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <3daea7fe-f64a-36a9-ca80-0cb4d9acf171@deltatee.com>
Date: Mon, 8 Jan 2018 11:17:38 -0700
MIME-Version: 1.0
In-Reply-To: <20180108180917.GF11348@ziepe.ca>
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
To: Jason Gunthorpe <jgg@ziepe.ca>, Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>
List-ID: <linux-nvdimm@lists.01.org>



On 08/01/18 11:09 AM, Jason Gunthorpe wrote:
> It could, if we had a DMA op for p2p then the drivers that provide
> their own ops can implement it appropriately or not at all.

I was thinking of doing something like this. I'll probably rough out a 
patch and send it along today or tomorrow.

>> If at all it should be in the dma_map* wrappers, but for that we'd need
>> a good identifier.  And it still would not solve the whole fake dma
>> ops issue.
> 
> Very long term the IOMMUs under the ops will need to care about this,
> so the wrapper is not an optimal place to put it - but I wouldn't
> object if it gets it out of RDMA :)

Well, creating the extra op doesn't really change anything to the RDMA 
patch in this series. The point is, for the time being, we need to track 
whether we are doing a P2P or normal mapping using a side channel as we 
don't have a good way of tracking it in the SGL at this time.

Adding an extra DMA op is just one way to allow the existing DMA 
providers to opt-in/out.

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
