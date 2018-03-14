Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 88FF620954BA7
 for <linux-nvdimm@lists.01.org>; Wed, 14 Mar 2018 09:11:35 -0700 (PDT)
References: <3e738f95-d73c-4182-2fa1-8664aafb1ab7@deltatee.com>
 <703aa92c-0c1c-4852-5887-6f6e6ccde0fb@codeaurora.org>
 <a0af83f8-2cbc-862b-6f8b-231991527cfc@deltatee.com>
 <3ea80992-a0fc-08f2-d93d-ae0ec4e3f4ce@codeaurora.org>
 <4eb6850c-df1b-fd44-3ee0-d43a50270b53@deltatee.com>
 <757fca36-dee4-e070-669e-f2788bd78e41@codeaurora.org>
 <4f761f55-4e9a-dccb-d12f-c59d2cd689db@deltatee.com>
 <BB94077B-7EB3-49C4-862D-BF77D0A692CC@raithlin.com>
 <20180313230850.GA45763@bhelgaas-glaptop.roam.corp.google.com>
 <8de5d3dd-a78f-02d5-0eea-4365364143b6@deltatee.com>
 <20180314025639.GA50067@bhelgaas-glaptop.roam.corp.google.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <112493af-ccd0-455b-6600-b50764f7ab7e@deltatee.com>
Date: Wed, 14 Mar 2018 10:17:34 -0600
MIME-Version: 1.0
In-Reply-To: <20180314025639.GA50067@bhelgaas-glaptop.roam.corp.google.com>
Content-Language: en-US
Subject: Re: [PATCH v3 01/11] PCI/P2PDMA: Support peer-to-peer memory
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
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Alex Williamson <alex.williamson@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Sinan Kaya <okaya@codeaurora.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Keith Busch <keith.busch@intel.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>



On 13/03/18 08:56 PM, Bjorn Helgaas wrote:
> I assume you want to exclude Root Ports because of multi-function
> devices and the "route to self" error.  I was hoping for a reference
> to that so I could learn more about it.

I haven't been able to find where in the spec it forbids route to self.
But I was told this by developers who work know switches. Hopefully
Stephen can find the reference.

But it's a bit of a moot point. Devices can DMA to themselves if they
are designed to do so. For example, some NVMe cards can read and write
their own CMB for certain types of DMA request. There is a register in
the spec (CMBSZ) which specifies which types of requests are supported.
(See 3.1.12 in NVMe 1.3a).

> I agree that peers need to have a common upstream bridge.  I think
> you're saying peers need to have *two* common upstream bridges.  If I
> understand correctly, requiring two common bridges is a way to ensure
> that peers directly below Root Ports don't try to DMA to each other.

No, I don't get where you think we need to have two common upstream
bridges. I'm not sure when such a case would ever happen. But you seem
to understand based on what you wrote below.

> So I guess the first order of business is to nail down whether peers
> below a Root Port are prohibited from DMAing to each other.  My
> assumption, based on 6.12.1.2 and the fact that I haven't yet found
> a prohibition, is that they can.

If you have a multifunction device designed to DMA to itself below a
root port, it can. But determining this is on a device by device basis,
just as determining whether a root complex can do peer to peer is on a
per device basis. So I'd say we don't want to allow it by default and
let someone who has such a device figure out what's necessary if and
when one comes along.

> You already have upstream_bridges_match(), which takes two pci_devs.
> I think it should walk up the PCI hierarchy from the first device,
> checking whether the bridge at each level is also a parent of the
> second device.

Yes, this is what I meant when I said walking the entire tree. I've been
kicking the can down the road on implementing this as getting ref
counting right and testing it is going to be quite tricky. The single
switch approach we implemented now is just a simplification which works
for a single switch. But I guess we can look at implementing it this way
for v4.

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
