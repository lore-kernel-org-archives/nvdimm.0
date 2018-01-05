Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 260D821F833CD
 for <linux-nvdimm@lists.01.org>; Fri,  5 Jan 2018 10:59:15 -0800 (PST)
References: <20180104190137.7654-1-logang@deltatee.com>
 <20180104190137.7654-10-logang@deltatee.com>
 <20180105181152.GA10657@localhost.localdomain>
 <6c89e4b4-1854-c251-a5ec-7e54bc8085fc@deltatee.com>
 <20180105190135.GB10657@localhost.localdomain>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <a49489c9-b695-9105-407e-772796234256@deltatee.com>
Date: Fri, 5 Jan 2018 12:04:05 -0700
MIME-Version: 1.0
In-Reply-To: <20180105190135.GB10657@localhost.localdomain>
Content-Language: en-US
Subject: Re: [PATCH 09/12] nvme-pci: Use PCI p2pmem subsystem to manage the CMB
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
To: Keith Busch <keith.busch@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>



On 05/01/18 12:01 PM, Keith Busch wrote:
> On Fri, Jan 05, 2018 at 11:19:28AM -0700, Logan Gunthorpe wrote:
>> Although it is not explicitly stated anywhere, pci_alloc_p2pmem() should
>> always be at least 4k aligned. This is because the gen_pool that implements
>> it is created with PAGE_SHIFT for its min_alloc_order.
> 
> Ah, I see that now. Thanks for the explanation.
> 
> Does it need to be created with page sized minimum alloc order? That
> granularity makes it difficult to fit SQs in CMB on archs with larger
> pages when we only needed 4k alignment.
> 
> I was also hoping to extend this for PRP/SGL in CMB where even 4k is
> too high a granularity to make it really useful.
> 
> It looks like creating the gen pool with a smaller minimum and
> gen_pool_first_fit_order_align algo would satisfy my use cases, but I'm
> not sure if there's another reason you've set it to page alignment.

I don't see any reason why we couldn't change this at some point if it 
makes sense to. PAGE_SIZE just seemed like a suitable choice but I don't 
think anything depends on it. In the end, I guess it depends on how 
limited typical CMB buffers end up being.

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
