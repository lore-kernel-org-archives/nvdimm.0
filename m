Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 75796224E6908
 for <linux-nvdimm@lists.01.org>; Thu,  1 Mar 2018 15:39:13 -0800 (PST)
Date: Thu, 1 Mar 2018 17:45:19 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH v2 01/10] PCI/P2PDMA: Support peer to peer memory
Message-ID: <20180301234519.GC74737@bhelgaas-glaptop.roam.corp.google.com>
References: <20180228234006.21093-1-logang@deltatee.com>
 <20180228234006.21093-2-logang@deltatee.com>
 <20180301173752.GE13722@bhelgaas-glaptop.roam.corp.google.com>
 <b81503c2-9f07-b5f6-df06-64d1fdc53386@deltatee.com>
 <20180301230032.GA74737@bhelgaas-glaptop.roam.corp.google.com>
 <b3121c36-4ef5-0d8e-e8ef-418b48de9589@deltatee.com>
 <9B84B347-2CCF-4250-89ED-B29892E76597@raithlin.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <9B84B347-2CCF-4250-89ED-B29892E76597@raithlin.com>
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
To: Stephen Bates <sbates@raithlin.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Alex Williamson <alex.williamson@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 01, 2018 at 11:14:46PM +0000, Stephen  Bates wrote:
> > I'm pretty sure the spec disallows routing-to-self so doing a P2P 
> > transaction in that sense isn't going to work unless the device 
> > specifically supports it and intercepts the traffic before it gets to 
> > the port.
> 
> This is correct. Unless the device intercepts the TLP before it hits
> the root-port then this would be considered a "route to self"
> violation and an error event would occur. The same holds for the
> downstream port on a PCI switch (unless route-to-self violations are
> disabled which violates the spec but which I have seen done in
> certain applications).

I agree that a function doing DMA to a sibling within the same
multi-function device would probably not generate a TLP for it (I
would be curious to read about this in the spec if you have a
pointer).

More fundamentally, is there some multi-function-specific restriction
on peer-to-peer DMA?  In conventional PCI, single-function devices on
the same bus can DMA to each other.  The transactions will appear on
the bus, but the upstream bridge will ignore them because the address
is inside the bridge's memory window.  As far as I know, the same
should happen on PCIe.

I don't know what happens with functions of a multi-function device,
either in conventional PCI or PCIe.  I don't remember a restriction on
whether they can DMA to each other, but maybe there is.

Bjorn
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
