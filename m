Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9B559224E6926
 for <linux-nvdimm@lists.01.org>; Thu,  1 Mar 2018 13:15:50 -0800 (PST)
Date: Thu, 1 Mar 2018 14:21:55 -0700
From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH v2 04/10] PCI/P2PDMA: Clear ACS P2P flags for all
 devices behind switches
Message-ID: <20180301142155.5966c4c0@w520.home>
In-Reply-To: <0D05579B-789C-4A19-B3A2-C1A630BE31C0@raithlin.com>
References: <20180228234006.21093-1-logang@deltatee.com>
 <20180228234006.21093-5-logang@deltatee.com>
 <20180301180257.GH13722@bhelgaas-glaptop.roam.corp.google.com>
 <0D05579B-789C-4A19-B3A2-C1A630BE31C0@raithlin.com>
MIME-Version: 1.0
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
To: Stephen  Bates <sbates@raithlin.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, =?UTF-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <helgaas@kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 1 Mar 2018 18:54:01 +0000
"Stephen  Bates" <sbates@raithlin.com> wrote:

> Thanks for the detailed review Bjorn!
> 
> >>  
> >> +	  Enabling this option will also disable ACS on all ports behind
> >> +	  any PCIe switch. This effictively puts all devices behind any
> >> +	  switch into the same IOMMU group.  
> 
> >
> >  Does this really mean "all devices behind the same Root Port"?  
> 
> Not necessarily. You might have a cascade of switches (i.e switches below a switch) to achieve a very large fan-out (in an NVMe SSD array for example) and we will only disable ACS on the ports below the relevant switch.
> 
> > What does this mean in terms of device security?  I assume it means,
> > at least, that individual devices can't be assigned to separate VMs.  
> 
> This was discussed during v1 [1]. Disabling ACS on all downstream ports of the switch means that all the EPs below it have to part of the same IOMMU grouping. However it was also agreed that as long as the ACS disable occurred at boot time (which is does in v2) then the virtualization layer will be aware of it and will perform the IOMMU group formation correctly.

This is still a pretty terrible solution though, your kernel provider
needs to decide whether they favor device assignment or p2p, because we
can't do both, unless there's a patch I haven't seen yet that allows
boot time rather than compile time configuration.  There are absolutely
supported device assignment cases of switches proving isolation between
devices allowing the downstream EPs to be used independently.  I think
this is a non-starter for distribution support without boot time or
dynamic configuration.  I could imagine dynamic configuration through
sysfs that might trigger a soft remove and rescan of the affected
devices in order to rebuild the IOMMU group.  The hard part might be
determining which points to allow that to guarantee correctness.  For
instance, upstream switch ports don't actually support ACS, but they'd
otherwise be an obvious concentration point to trigger a
reconfiguration.  Thanks,

Alex
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
