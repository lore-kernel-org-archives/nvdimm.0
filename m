Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6F0362115743C
 for <linux-nvdimm@lists.01.org>; Tue, 25 Sep 2018 11:46:49 -0700 (PDT)
References: <20180925162231.4354-1-logang@deltatee.com>
 <20180925162231.4354-4-logang@deltatee.com>
 <1537896805.11137.25.camel@acm.org>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <18e5d3f2-c56b-645b-ac96-f0d861d12cc2@deltatee.com>
Date: Tue, 25 Sep 2018 12:46:30 -0600
MIME-Version: 1.0
In-Reply-To: <1537896805.11137.25.camel@acm.org>
Content-Language: en-US
Subject: Re: [PATCH v7 03/13] PCI/P2PDMA: Add PCI p2pmem DMA mappings to
 adjust the bus offset
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
To: Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>



On 2018-09-25 11:33 a.m., Bart Van Assche wrote:
>> +	/*
>> +	 * p2pdma mappings are not compatible with devices that use
>> +	 * dma_virt_ops. If the upper layers do the right thing
>> +	 * this should never happen because it will be prevented
>> +	 * by the check in pci_p2pdma_add_client()
>> +	 */
>> +	if (WARN_ON_ONCE(IS_ENABLED(CONFIG_DMA_VIRT_OPS) &&
>> +			 dev->dma_ops == &dma_virt_ops))
>> +		return 0;
> 
> Are you assuming that the compiler will optimize out the dev->dma_ops
> == &dma_virt_ops test if CONFIG_DMA_VIRT_OPS=n such that no reference to the
> dma_virt_ops symbol appears in the object file? Are you sure all compilers
> and compiler versions that are used to build the Linux kernel will do that?

Hmm, I can't say for certain but I would definitely expect any sane
compiler to do so. It's a fairly obvious optimization and the kbuild
robot is happy with it.

I just did a test compile on 4.9 (which is the earliest compiler version
I have readily available) and it worked fine. The minimum gcc the kernel
supports is 4.6 right now.

I've also done a similar test on godbolt.org[1] and can't find any
compiler version that doesn't work.

Logan


[1] https://godbolt.org/z/d5Mhee
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
