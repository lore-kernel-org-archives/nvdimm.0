Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AB808224E690C
 for <linux-nvdimm@lists.01.org>; Thu,  1 Mar 2018 15:09:29 -0800 (PST)
Date: Thu, 1 Mar 2018 17:15:36 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH v2 04/10] PCI/P2PDMA: Clear ACS P2P flags for all devices
 behind switches
Message-ID: <20180301231536.GB74737@bhelgaas-glaptop.roam.corp.google.com>
References: <20180228234006.21093-1-logang@deltatee.com>
 <20180228234006.21093-5-logang@deltatee.com>
 <20180301180257.GH13722@bhelgaas-glaptop.roam.corp.google.com>
 <0D05579B-789C-4A19-B3A2-C1A630BE31C0@raithlin.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <0D05579B-789C-4A19-B3A2-C1A630BE31C0@raithlin.com>
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

On Thu, Mar 01, 2018 at 06:54:01PM +0000, Stephen  Bates wrote:
> Thanks for the detailed review Bjorn!
> 
> >> +	  Enabling this option will also disable ACS on all ports behind
> >> +	  any PCIe switch. This effictively puts all devices behind any
> >> +	  switch into the same IOMMU group.
> 
> >  Does this really mean "all devices behind the same Root Port"?
> 
> Not necessarily. You might have a cascade of switches (i.e switches
> below a switch) to achieve a very large fan-out (in an NVMe SSD
> array for example) and we will only disable ACS on the ports below
> the relevant switch.

The question is what the relevant switch is.  We call pci_enable_acs()
on every PCI device, including Root Ports.  It looks like this relies
on get_upstream_bridge_port() to filter out some things.  I don't
think get_upstream_bridge_port() is doing the right thing, so we need
to sort that out first, I guess.

> > What does this mean in terms of device security?  I assume it means,
> > at least, that individual devices can't be assigned to separate VMs.
> 
> This was discussed during v1 [1]. Disabling ACS on all downstream
> ports of the switch means that all the EPs below it have to part of
> the same IOMMU grouping. However it was also agreed that as long as
> the ACS disable occurred at boot time (which is does in v2) then the
> virtualization layer will be aware of it and will perform the IOMMU
> group formation correctly.
>     
> > I don't mind admitting that this patch makes me pretty nervous, and I
> > don't have a clear idea of what the implications of this are, or how
> > to communicate those to end users.  "The same IOMMU group" is a pretty
> > abstract idea.
>     
> Alex gave a good overview of the implications in [1].
> 
> [1] https://marc.info/?l=linux-pci&m=151512320031739&w=2

This might be a good start, but whatever the implications are, they
need to be distilled and made clear directly in the changelog and the
Kconfig help text.

Bjorn
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
