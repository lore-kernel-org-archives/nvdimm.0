Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 803F02264D24F
 for <linux-nvdimm@lists.01.org>; Tue, 13 Mar 2018 19:50:24 -0700 (PDT)
Date: Tue, 13 Mar 2018 21:56:39 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH v3 01/11] PCI/P2PDMA: Support peer-to-peer memory
Message-ID: <20180314025639.GA50067@bhelgaas-glaptop.roam.corp.google.com>
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
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <8de5d3dd-a78f-02d5-0eea-4365364143b6@deltatee.com>
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
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Jens Axboe <axboe@kernel.dk>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Alex Williamson <alex.williamson@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Sinan Kaya <okaya@codeaurora.org>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Keith Busch <keith.busch@intel.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Mar 13, 2018 at 05:21:20PM -0600, Logan Gunthorpe wrote:
> On 13/03/18 05:08 PM, Bjorn Helgaas wrote:
> > On Tue, Mar 13, 2018 at 10:31:55PM +0000, Stephen  Bates wrote:
> > If it *is* necessary because Root Ports and devices below them behave
> > differently than in conventional PCI, I think you should include a
> > reference to the relevant section of the spec and check directly for a
> > Root Port.  I would prefer that over trying to exclude Root Ports by
> > looking for two upstream bridges.
> 
> Well we've established that we don't want to allow root ports.

I assume you want to exclude Root Ports because of multi-function
devices and the "route to self" error.  I was hoping for a reference
to that so I could learn more about it.

While I was looking for it, I found sec 6.12.1.2 (PCIe r4.0), "ACS
Functions in SR-IOV Capable and Multi-Function Devices", which seems
relevant.  It talks about "peer-to-peer Requests (between Functions of
the device)".  Thay says to me that multi-function devices can DMA
between themselves.

> But we need to, at a minimum, do two pci_upstream_bridge() calls...
> 
> Remember, we need to check that a number of devices are behind the same
> switch. So we need to find a _common_ upstream port for several devices.

I agree that peers need to have a common upstream bridge.  I think
you're saying peers need to have *two* common upstream bridges.  If I
understand correctly, requiring two common bridges is a way to ensure
that peers directly below Root Ports don't try to DMA to each other.

So I guess the first order of business is to nail down whether peers
below a Root Port are prohibited from DMAing to each other.  My
assumption, based on 6.12.1.2 and the fact that I haven't yet found
a prohibition, is that they can.

> Excluding the multifunction device case (which I don't think is
> applicable for reasons we've discussed before), this will *never* be the
> first upstream port for a given device.

If you're looking for a common upstream bridge, you don't need to make
assumptions about whether the hierarchy is conventional PCI or PCIe or
how many levels are in the hierarchy.

You already have upstream_bridges_match(), which takes two pci_devs.
I think it should walk up the PCI hierarchy from the first device,
checking whether the bridge at each level is also a parent of the
second device.

Bjorn
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
