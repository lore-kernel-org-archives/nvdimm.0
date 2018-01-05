Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C0A5021F833C5
 for <linux-nvdimm@lists.01.org>; Fri,  5 Jan 2018 10:14:31 -0800 (PST)
References: <20180104190137.7654-1-logang@deltatee.com>
 <20180104190137.7654-10-logang@deltatee.com>
 <20180105181152.GA10657@localhost.localdomain>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <6c89e4b4-1854-c251-a5ec-7e54bc8085fc@deltatee.com>
Date: Fri, 5 Jan 2018 11:19:28 -0700
MIME-Version: 1.0
In-Reply-To: <20180105181152.GA10657@localhost.localdomain>
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



On 05/01/18 11:11 AM, Keith Busch wrote:
> On Thu, Jan 04, 2018 at 12:01:34PM -0700, Logan Gunthorpe wrote:
>> Register the CMB buffer as p2pmem and use the appropriate allocation
>> functions to create and destroy the IO SQ.
>>
>> If the CMB supports WDS and RDS, publish it for use as p2p memory
>> by other devices.
> 
> <>
> 
>> +	if (qid && dev->cmb_use_sqes) {
>> +		nvmeq->sq_cmds = pci_alloc_p2pmem(pdev, SQ_SIZE(depth));
> 
>> +		nvmeq->sq_dma_addr = pci_p2pmem_virt_to_bus(pdev,
>> +							    nvmeq->sq_cmds);
>> +		nvmeq->sq_cmds_is_io = true;
>> +	}
> 
> This gets into some spec type trouble for creating an IO submission
> queue. We use the sq_dma_addr as the PRP entry to the Create I/O
> SQ command, which has some requirements:
> 
>    "the PRP Entry shall have an offset of 0h."
> 
> So this has to be 4k aligned, but pci_alloc_p2pmem doesn't guarantee
> that. I doubt the spec's intention was to require such alignment for
> CMB SQs, but there may be controllers enforcing the rule as written.

Although it is not explicitly stated anywhere, pci_alloc_p2pmem() should 
always be at least 4k aligned. This is because the gen_pool that 
implements it is created with PAGE_SHIFT for its min_alloc_order.

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
