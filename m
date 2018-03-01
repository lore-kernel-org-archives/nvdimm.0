Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A30C9224E6937
 for <linux-nvdimm@lists.01.org>; Thu,  1 Mar 2018 10:50:05 -0800 (PST)
References: <20180228234006.21093-1-logang@deltatee.com>
 <20180228234006.21093-2-logang@deltatee.com>
 <20180301173752.GE13722@bhelgaas-glaptop.roam.corp.google.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <b81503c2-9f07-b5f6-df06-64d1fdc53386@deltatee.com>
Date: Thu, 1 Mar 2018 11:55:51 -0700
MIME-Version: 1.0
In-Reply-To: <20180301173752.GE13722@bhelgaas-glaptop.roam.corp.google.com>
Content-Language: en-US
Subject: Re: [PATCH v2 01/10] PCI/P2PDMA: Support peer to peer memory
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
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Alex Williamson <alex.williamson@redhat.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Hi Bjorn,

Thanks for the review. I'll correct all the nits for the next version.

On 01/03/18 10:37 AM, Bjorn Helgaas wrote:
> On Wed, Feb 28, 2018 at 04:39:57PM -0700, Logan Gunthorpe wrote:
>> Some PCI devices may have memory mapped in a BAR space that's
>> intended for use in Peer-to-Peer transactions. In order to enable
>> such transactions the memory must be registered with ZONE_DEVICE pages
>> so it can be used by DMA interfaces in existing drivers.

> Is there anything about this memory that makes it specifically
> intended for peer-to-peer transactions?  I assume the device can't
> really tell whether a transaction is from a CPU or a peer.

No there's nothing special about the memory and it can still be accessed 
by the CPU. This is just the intended purpose. You could use this PCI 
memory as regular DMA buffers or regular memory but I'm not sure why you 
would. It would probably be pretty bad performance-wise.


> BTW, maybe there could be some kind of guide for device driver writers
> in Documentation/PCI/?
Makes sense we can look at writing something for the next iteration.

> I think it would be clearer and sufficient to simply say that we have
> no way to know whether peer-to-peer routing between PCIe Root Ports is
> supported (PCIe r4.0, sec 1.3.1).

Fair enough.

> The fact that you use the PCIe term "switch" suggests that a PCIe
> Switch is required, but isn't it sufficient for the peers to be below
> the same "PCI bridge", which would include PCIe Root Ports, PCIe
> Switch Downstream Ports, and conventional PCI bridges?
> The comments at get_upstream_bridge_port() suggest that this isn't
> enough, and the peers actually do have to be below the same PCIe
> Switch, but I don't know why.

I do mean Switch as we do need to keep the traffic off the root complex. 
Seeing, as stated above, we don't know if it actually support it. (While 
we can be certain any PCI switch does). So we specifically want to 
exclude PCIe Root ports and I'm not sure about the support of PCI 
bridges but I can't imagine anyone wanting to do P2P around them so I'd 
rather be safe than sorry and exclude them.


>> +	addr = devm_memremap_pages(&pdev->dev, pgmap);
>> +	if (IS_ERR(addr))
> 
> Free pgmap here?  And in the other error case below?  Or maybe this
> happens via the devm_* magic?  If so, when would that actually happen?
> Would pgmap be effectively leaked until the pdev is destroyed?

Yes, it happens via the devm magic as that's the way the 
devm_memremap_pages() interface was designed. If I remember correctly, 
in my testing, it would be de-allocated when the driver gets unbound.

>> +		return PTR_ERR(addr);
>> +
>> +	error = gen_pool_add_virt(pdev->p2pdma->pool, (uintptr_t)addr,
>> +			pci_bus_address(pdev, bar) + offset,
>> +			resource_size(&pgmap->res), dev_to_node(&pdev->dev));
>> +	if (error)
>> +		return error;
>> +
>> +	error = devm_add_action_or_reset(&pdev->dev, pci_p2pdma_percpu_kill,
>> +					  &pdev->p2pdma->devmap_ref);
>> +	if (error)
>> +		return error;
>> +
>> +	dev_info(&pdev->dev, "added peer-to-peer DMA memory %pR\n",
>> +		 &pgmap->res);
> 
> s/dev_info/pci_info/ (also similar usages below, except for the one or
> two cases where you don't have a pci_dev).

Oh, nice, I didn't notice that was added.

> This whole thing is confusing to me.  Why do you want to reject peers
> directly connected to the same root port?  Why do you require the same
> Switch Upstream Port?  You don't exclude conventional PCI, but it
> looks like you would require peers to share *two* upstream PCI-to-PCI
> bridges?  I would think a single shared upstream bridge (conventional,
> PCIe Switch Downstream Port, or PCIe Root Port) would be sufficient?

Hmm, yes, this may just be laziness on my part. Finding the shared 
upstream bridge is a bit more tricky than just showing that they are on 
the same switch. So as coded, a fabric of switches with peers on 
different legs of the fabric are not supported. But yes, maybe they just 
need to be two devices with a single shared upstream bridge that is not 
the root port. Again, we need to reject the root port because we can't 
know if the root complex can support P2P traffic.

> Since "pci_p2pdma_add_client()" includes "pci_" in its name, it seems
> sort of weird that callers supply a non-PCI device and then we look up
> a PCI device here.  I assume you have some reason for this; if you
> added a writeup in Documentation/PCI, that would be a good place to
> elaborate on that, maybe with a one-line clue here.

Well yes, but this is much more convenient for callers which don't need 
to care if the device they are attempting to add (which in the NVMe 
target case, could be a random block device) is a pci device or not. 
Especially seeing find_parent_pci_dev() is non-trivial.

>> +void *pci_alloc_p2pmem(struct pci_dev *pdev, size_t size)
>> +{
>> +	void *ret;
>> +
>> +	if (unlikely(!pdev->p2pdma))
> 
> Is this a hot path?  I'm not sure it's worth cluttering
> non-performance paths with likely/unlikely.

I'd say it can be pretty hot given that we need to allocate and free 
buffers at multiple GB/s for the NVMe target case. I don't exactly have 
benchmarks or anything to show this though...

>> +		return NULL;
>> +
>> +	if (unlikely(!percpu_ref_tryget_live(&pdev->p2pdma->devmap_ref)))
>> +		return NULL;
>> +
>> +	ret = (void *)(uintptr_t)gen_pool_alloc(pdev->p2pdma->pool, size);
> 
> Why the double cast?  Wouldn't "(void *)" be sufficient?

Oh, hmm, I can't remember now. I suspect I added it to fix a kbuild test 
robot error. I'll check and see if it can be removed.


> In v4.6-rc1, gen_pool_free() takes "unsigned long addr".  I know this
> is based on -rc3; is this something that changed between -rc1 and
> -rc3?

Yes, I think it's taken an unsigned long for a while now. Per the above, 
I can't remember exactly why I casted it this way and I'll take a look 
again.

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
