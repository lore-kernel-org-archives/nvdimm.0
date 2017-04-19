From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC 0/8] Copy Offload with Peer-to-Peer PCI Memory
Date: Wed, 19 Apr 2017 11:44:20 -0700
Message-ID: <CAPcyv4iGBT4hKrg1aSpC8ZxoXQjsC4afB4UcJu+06o954jGGAA@mail.gmail.com>
References: <20170418164557.GA7181@obsidianresearch.com> <cce00131-1f28-27b3-40ab-04f8783f1e5a@deltatee.com>
 <20170418190138.GH7181@obsidianresearch.com> <df1351d8-b86c-2e21-1948-4688ece5dc2b@deltatee.com>
 <CAPcyv4gScx6A7vG9VEHpNF41GOy1Nxst7QQ3QC3uZ54bWoxbMg@mail.gmail.com>
 <20170418210339.GA24257@obsidianresearch.com> <1492564806.25766.124.camel@kernel.crashing.org>
 <20170419155557.GA8497@obsidianresearch.com> <4899b011-bdfb-18d8-ef00-33a1516216a6@deltatee.com>
 <CAPcyv4iJ9H8Ykwnjqa2R_D1qG6PsSQmi=QxYH-rKLF_ihrsWyw@mail.gmail.com>
 <20170419173225.GA11255@redhat.com> <CAPcyv4gxBgVsbSez7_dZYkZojUWU0X0txs7FxiJ+Z3xsMt6TqQ@mail.gmail.com>
 <c75b6f6e-2814-1be3-d044-e153849263ce@deltatee.com> <99a22044-8f15-f381-19ee-e239e9d2da29@deltatee.com>
 <CAPcyv4hPT3hEWC+q+DvQ_1o3rjeXsKmcRZT4GdKj9wFFVhdFpg@mail.gmail.com> <f24888ac-00b8-1830-36f2-edd9587b0e58@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <f24888ac-00b8-1830-36f2-edd9587b0e58@deltatee.com>
Sender: linux-pci-owner@vger.kernel.org
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Jerome Glisse <jglisse@redhat.com>, Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-rdma@vger.kernel.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Steve Wise <swise@opengridcomputing.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-nvme@lists.infradead.org, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Bjorn Helgaas <helgaas@kernel.org>, linux-pci@vger.kernel.org, linux-nvdimm <linux-nvdimm@ml01.01.org>, Max Gurtovoy <maxg@mellanox.com>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-nvdimm@lists.01.org

On Wed, Apr 19, 2017 at 11:41 AM, Logan Gunthorpe <logang@deltatee.com> wrote:
>
>
> On 19/04/17 12:30 PM, Dan Williams wrote:
>> Letting others users do the container_of() arrangement means that
>> struct page_map needs to become public and move into struct
>> dev_pagemap directly.
>
> Ah, yes, I got a bit turned around by that and failed to notice that
> page_map and dev_pagemap are different. Why is it that dev_pagemap
> contains pretty much the exact same information as page_map? The only
> thing gained that I can see is that the struct resource gains const
> protection...
>
>> ...I think that encapsulation loss is worth it for the gain of clearly
>> separating the HMM-case from the base case.
>
> Agreed.
>

Yeah, I forgot that dev_pagemap grew those fields, so we don't have
any real encapsulation today. So this would just be a pure cleanup to
kill struct page_map.
