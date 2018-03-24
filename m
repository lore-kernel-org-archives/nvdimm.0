Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D79F22210D9D8
 for <linux-nvdimm@lists.01.org>; Fri, 23 Mar 2018 20:43:16 -0700 (PDT)
Date: Fri, 23 Mar 2018 22:49:47 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH v3 01/11] PCI/P2PDMA: Support peer-to-peer memory
Message-ID: <20180324034947.GE210003@bhelgaas-glaptop.roam.corp.google.com>
References: <a0af83f8-2cbc-862b-6f8b-231991527cfc@deltatee.com>
 <3ea80992-a0fc-08f2-d93d-ae0ec4e3f4ce@codeaurora.org>
 <4eb6850c-df1b-fd44-3ee0-d43a50270b53@deltatee.com>
 <757fca36-dee4-e070-669e-f2788bd78e41@codeaurora.org>
 <4f761f55-4e9a-dccb-d12f-c59d2cd689db@deltatee.com>
 <BB94077B-7EB3-49C4-862D-BF77D0A692CC@raithlin.com>
 <20180313230850.GA45763@bhelgaas-glaptop.roam.corp.google.com>
 <C90AA66C-FFC6-4CCA-B959-7BBECA65509C@raithlin.com>
 <20180323215046.GC210003@bhelgaas-glaptop.roam.corp.google.com>
 <dc414fa5-1af9-0ba7-e12e-4cd9df313119@deltatee.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <dc414fa5-1af9-0ba7-e12e-4cd9df313119@deltatee.com>
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

On Fri, Mar 23, 2018 at 03:59:14PM -0600, Logan Gunthorpe wrote:
> On 23/03/18 03:50 PM, Bjorn Helgaas wrote:
> > Popping way up the stack, my original point was that I'm trying to
> > remove restrictions on what devices can participate in
> > peer-to-peer DMA.  I think it's fairly clear that in conventional
> > PCI, any devices in the same PCI hierarchy, i.e., below the same
> > host-to-PCI bridge, should be able to DMA to each other.
> 
> Yup, we are working on this.
> 
> > The routing behavior of PCIe is supposed to be compatible with
> > conventional PCI, and I would argue that this effectively requires
> > multi-function PCIe devices to have the internal routing required
> > to avoid the route-to-self issue.
> 
> That would be very nice but many devices do not support the internal
> route. We've had to work around this in the past and as I mentioned
> earlier that NVMe devices have a flag indicating support. However,
> if a device wants to be involved in P2P it must support it and we
> can exclude devices that don't support it by simply not enabling
> their drivers.

Do you think these devices that don't support internal DMA between
functions are within spec, or should we handle them as exceptions,
e.g., via quirks?

If NVMe defines a flag indicating peer-to-peer support, that would
suggest to me that these devices are within spec.

I looked up the CMBSZ register you mentioned (NVMe 1.3a, sec 3.1.12).
You must be referring to the WDS, RDS, LISTS, CQS, and SQS bits.  If
WDS is set, the controller supports having Write-related data and
metadata in the Controller Memory Buffer.  That would mean the driver
could put certain queues in controller memory instead of in host
memory.  The controller could then read the queue from its own
internal memory rather than issuing a PCIe transaction to read it from
host memory.

That makes sense to me, but I don't see the connection to
peer-to-peer.  There's no multi-function device in this picture, so
it's not about internal DMA between functions.

WDS, etc., tell us about capabilities of the controller.  If WDS is
set, the CPU (or a peer PCIe device) can write things to controller
memory.  If it is clear, neither the CPU nor a peer device can put
things there.  So it doesn't seem to tell us anything about
peer-to-peer specifically.  It looks like information needed by the
NVMe driver, but not by the PCI core.

Bjorn
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
