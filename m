Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 00D8120954B9E
 for <linux-nvdimm@lists.01.org>; Wed, 14 Mar 2018 11:45:38 -0700 (PDT)
Date: Wed, 14 Mar 2018 13:51:59 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH v3 01/11] PCI/P2PDMA: Support peer-to-peer memory
Message-ID: <20180314185159.GD179719@bhelgaas-glaptop.roam.corp.google.com>
References: <a0af83f8-2cbc-862b-6f8b-231991527cfc@deltatee.com>
 <3ea80992-a0fc-08f2-d93d-ae0ec4e3f4ce@codeaurora.org>
 <4eb6850c-df1b-fd44-3ee0-d43a50270b53@deltatee.com>
 <757fca36-dee4-e070-669e-f2788bd78e41@codeaurora.org>
 <4f761f55-4e9a-dccb-d12f-c59d2cd689db@deltatee.com>
 <BB94077B-7EB3-49C4-862D-BF77D0A692CC@raithlin.com>
 <20180313230850.GA45763@bhelgaas-glaptop.roam.corp.google.com>
 <8de5d3dd-a78f-02d5-0eea-4365364143b6@deltatee.com>
 <20180314025639.GA50067@bhelgaas-glaptop.roam.corp.google.com>
 <112493af-ccd0-455b-6600-b50764f7ab7e@deltatee.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <112493af-ccd0-455b-6600-b50764f7ab7e@deltatee.com>
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

On Wed, Mar 14, 2018 at 10:17:34AM -0600, Logan Gunthorpe wrote:
> On 13/03/18 08:56 PM, Bjorn Helgaas wrote:
> > I agree that peers need to have a common upstream bridge.  I think
> > you're saying peers need to have *two* common upstream bridges.  If I
> > understand correctly, requiring two common bridges is a way to ensure
> > that peers directly below Root Ports don't try to DMA to each other.
> 
> No, I don't get where you think we need to have two common upstream
> bridges. I'm not sure when such a case would ever happen. But you seem
> to understand based on what you wrote below.

Sorry, I phrased that wrong.  You don't require two common upstream
bridges; you require two upstream bridges, with the upper one being
common, i.e.,

  static struct pci_dev *get_upstream_bridge_port(struct pci_dev *pdev)
  {
    struct pci_dev *up1, *up2;

    up1 = pci_dev_get(pci_upstream_bridge(pdev));
    up2 = pci_dev_get(pci_upstream_bridge(up1));
    return up2;
  }

So if you're starting with pdev, up1 is the immediately upstream
bridge and up2 is the second upstream bridge.  If this is PCIe, up1
may be a Root Port and there is no up2, or up1 and up2 are in a
switch.

This is more restrictive than the spec requires.  As long as there is
a single common upstream bridge, peer-to-peer DMA should work.  In
fact, in conventional PCI, I think the upstream bridge could even be
the host bridge (not a PCI-to-PCI bridge).

You are focused on PCIe systems, and in those systems, most topologies
do have an upstream switch, which means two upstream bridges.  I'm
trying to remove that assumption because I don't think there's a
requirement for it in the spec.  Enforcing this assumption complicates
the code and makes it harder to understand because the reader says
"huh, I know peer-to-peer DMA should work inside any PCI hierarchy*,
so why do we need these two bridges?"

[*] For conventional PCI, this means anything below the same host
bridge.  Two devices on a conventional PCI root bus should be able to
DMA to each other, even though there's no PCI-to-PCI bridge above
them.  For PCIe, it means a "hierarchy domain" as used in PCIe r4.0,
sec 1.3.1, i.e., anything below the same Root Port.

> > So I guess the first order of business is to nail down whether peers
> > below a Root Port are prohibited from DMAing to each other.  My
> > assumption, based on 6.12.1.2 and the fact that I haven't yet found
> > a prohibition, is that they can.
> 
> If you have a multifunction device designed to DMA to itself below a
> root port, it can. But determining this is on a device by device basis,
> just as determining whether a root complex can do peer to peer is on a
> per device basis. So I'd say we don't want to allow it by default and
> let someone who has such a device figure out what's necessary if and
> when one comes along.

It's not the job of this infrastructure to answer the device-dependent
question of whether DMA initiators or targets support peer-to-peer
DMA.

All we want to do here is figure out whether the PCI topology supports
it, using the mechanisms guaranteed by the spec.  We can derive that
from the basic rules about how PCI bridges work, i.e., from the
PCI-to-PCI Bridge spec r1.2, sec 4.3:

  A bridge forwards PCI memory transactions from its primary interface
  to its secondary interface (downstream) if a memory address is in
  the range defined by the Memory Base and Memory Limit registers
  (when the base is less than or equal to the limit) as illustrated in
  Figure 4-3. Conversely, a memory transaction on the secondary
  interface that is within this address range will not be forwarded
  upstream to the primary interface. Any memory transactions on the
  secondary interface that are outside this address range will be
  forwarded upstream to the primary interface (provided they are not
  in the address range defined by the prefetchable memory address
  range registers).

This works for either PCI or PCIe.  The only wrinkle PCIe adds is that
the very top of the hierarchy is a Root Port, and we can't rely on it
to route traffic to other Root Ports.  I also doubt Root Complex
Integrated Endpoints can participate in peer-to-peer DMA.

Thanks for your patience in working through all this.  I know it
sometimes feels like being bounced around in all directions.  It's
just a normal consequence of trying to add complex functionality to an
already complex system, with interest and expertise spread unevenly
across a crowd of people.

Bjorn
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
