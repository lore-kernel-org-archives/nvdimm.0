Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DA6B0224E6934
 for <linux-nvdimm@lists.01.org>; Thu,  1 Mar 2018 09:58:38 -0800 (PST)
References: <20180228234006.21093-1-logang@deltatee.com>
 <1519876489.4592.3.camel@kernel.crashing.org>
 <1519876569.4592.4.camel@au1.ibm.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <8e808448-fc01-5da0-51e7-1a6657d5a23a@deltatee.com>
Date: Thu, 1 Mar 2018 11:04:32 -0700
MIME-Version: 1.0
In-Reply-To: <1519876569.4592.4.camel@au1.ibm.com>
Content-Language: en-US
Subject: Re: [PATCH v2 00/10] Copy Offload in NVMe Fabrics with P2P PCI Memory
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
To: benh@au1.ibm.com, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Oliver OHalloran <oliveroh@au1.ibm.com>, Alex Williamson <alex.williamson@redhat.com>, Keith Busch <keith.busch@intel.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>



On 28/02/18 08:56 PM, Benjamin Herrenschmidt wrote:
> On Thu, 2018-03-01 at 14:54 +1100, Benjamin Herrenschmidt wrote:
>> The problem is that acccording to him (I didn't double check the latest
>> patches) you effectively hotplug the PCIe memory into the system when
>> creating struct pages.
>>
>> This cannot possibly work for us. First we cannot map PCIe memory as
>> cachable. (Note that doing so is a bad idea if you are behind a PLX
>> switch anyway since you'd ahve to manage cache coherency in SW).
> 
> Note: I think the above means it won't work behind a switch on x86
> either, will it ?

This works perfectly fine on x86 behind a switch and we've tested it on 
multiple machines. We've never had an issue of running out of virtual 
space despite our PCI bars typically being located with an offset of 
56TB or more. The arch code on x86 also somehow figures out not to map 
the memory as cachable so that's not an issue (though, at this point, 
the CPU never accesses the memory so even if it were, it wouldn't affect 
anything).

We also had this working on ARM64 a while back but it required some out 
of tree ZONE_DEVICE patches and some truly horrid hacks to it's arch 
code to ioremap the memory into the page map.

You didn't mention what architecture you were trying this on.

It may make sense at this point to make this feature dependent on x86 
until more work is done to make it properly portable. Something like 
arch functions that allow adding IO memory pages to with a specific 
cache setting. Though, if an arch has such restrictive limits on the map 
size it would probably need to address that too somehow.

Thanks,

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
