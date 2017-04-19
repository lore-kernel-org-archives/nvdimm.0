From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: [RFC 0/8] Copy Offload with Peer-to-Peer PCI Memory
Date: Wed, 19 Apr 2017 12:11:28 -0600
Message-ID: <c75b6f6e-2814-1be3-d044-e153849263ce@deltatee.com>
References: <20170418164557.GA7181@obsidianresearch.com>
 <cce00131-1f28-27b3-40ab-04f8783f1e5a@deltatee.com>
 <20170418190138.GH7181@obsidianresearch.com>
 <df1351d8-b86c-2e21-1948-4688ece5dc2b@deltatee.com>
 <CAPcyv4gScx6A7vG9VEHpNF41GOy1Nxst7QQ3QC3uZ54bWoxbMg@mail.gmail.com>
 <20170418210339.GA24257@obsidianresearch.com>
 <1492564806.25766.124.camel@kernel.crashing.org>
 <20170419155557.GA8497@obsidianresearch.com>
 <4899b011-bdfb-18d8-ef00-33a1516216a6@deltatee.com>
 <CAPcyv4iJ9H8Ykwnjqa2R_D1qG6PsSQmi=QxYH-rKLF_ihrsWyw@mail.gmail.com>
 <20170419173225.GA11255@redhat.com>
 <CAPcyv4gxBgVsbSez7_dZYkZojUWU0X0txs7FxiJ+Z3xsMt6TqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <CAPcyv4gxBgVsbSez7_dZYkZojUWU0X0txs7FxiJ+Z3xsMt6TqQ@mail.gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, Jerome Glisse <jglisse@redhat.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <helgaas@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Steve Wise <swise@opengridcomputing.com>, Stephen Bates <sbates@raithlin.com>, Max Gurtovoy <maxg@mellanox.com>, Keith Busch <keith.busch@intel.com>, linux-pci@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm <linux-nvdimm@ml01.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-nvdimm@lists.01.org



On 19/04/17 11:41 AM, Dan Williams wrote:
> No, not quite ;-). I still don't think we should require the non-HMM
> to pass NULL for all the HMM arguments. What I like about Logan's
> proposal is to have a separate create and register steps dev_pagemap.
> That way call paths that don't care about HMM specifics can just turn
> around and register the vanilla dev_pagemap.

Would you necessarily even need a create step? I was thinking more along
the lines that struct dev_pagemap _could_ just be a member in another
structure. The caller would set the attributes they needed and pass it
to devm_memremap. (Similar to how we commonly do things with struct
device, et al). Potentially, that could also get rid of the need for the
*data pointer HMM is using to get back the struct hmm_devmem seeing
container_of could be used instead.

>> Note i won't make any change now on that front but if it make sense
>> i am happy to do it as separate patchset on top of HMM.
>>
>> Also i don't want p2pmem to be an exclusive or with HMM, we will want
>> GPU to do peer to peer DMA and thus HMM ZONE_DEVICE pages to support
>> this too.
> 
> Yes, this makes sense I think we really just want to distinguish host
> memory or not in terms of the dev_pagemap type.

That depends though. If unaddressable memory needs different steps to
get to the DMA address (ie if it has to setup a gpu window) then we may
still need a way to distinguish the two types of non-host memory.

Logan
