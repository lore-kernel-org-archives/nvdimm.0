Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DB880224E692A
 for <linux-nvdimm@lists.01.org>; Thu,  1 Mar 2018 12:24:00 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id
 w21KT30S025058
 for <linux-nvdimm@lists.01.org>; Thu, 1 Mar 2018 15:30:08 -0500
Received: from e06smtp11.uk.ibm.com (e06smtp11.uk.ibm.com [195.75.94.107])
 by mx0a-001b2d01.pphosted.com with ESMTP id 2geqw31r01-1
 (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Thu, 01 Mar 2018 15:30:07 -0500
Received: from localhost
 by e06smtp11.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <benh@au1.ibm.com>;
 Thu, 1 Mar 2018 20:30:04 -0000
Subject: Re: [PATCH v2 00/10] Copy Offload in NVMe Fabrics with P2P PCI Memory
From: Benjamin Herrenschmidt <benh@au1.ibm.com>
Date: Fri, 02 Mar 2018 07:29:55 +1100
In-Reply-To: <8e808448-fc01-5da0-51e7-1a6657d5a23a@deltatee.com>
References: <20180228234006.21093-1-logang@deltatee.com>
 <1519876489.4592.3.camel@kernel.crashing.org>
 <1519876569.4592.4.camel@au1.ibm.com>
 <8e808448-fc01-5da0-51e7-1a6657d5a23a@deltatee.com>
Mime-Version: 1.0
Message-Id: <1519936195.4592.18.camel@au1.ibm.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Reply-To: benh@au1.ibm.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Logan Gunthorpe <logang@deltatee.com>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Oliver OHalloran <oliveroh@au1.ibm.com>, Alex Williamson <alex.williamson@redhat.com>, Keith Busch <keith.busch@intel.com>, =?ISO-8859-1?Q?J=E9r=F4me?= Glisse <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 2018-03-01 at 11:04 -0700, Logan Gunthorpe wrote:
> 
> On 28/02/18 08:56 PM, Benjamin Herrenschmidt wrote:
> > On Thu, 2018-03-01 at 14:54 +1100, Benjamin Herrenschmidt wrote:
> > > The problem is that acccording to him (I didn't double check the latest
> > > patches) you effectively hotplug the PCIe memory into the system when
> > > creating struct pages.
> > > 
> > > This cannot possibly work for us. First we cannot map PCIe memory as
> > > cachable. (Note that doing so is a bad idea if you are behind a PLX
> > > switch anyway since you'd ahve to manage cache coherency in SW).
> > 
> > Note: I think the above means it won't work behind a switch on x86
> > either, will it ?
> 
> This works perfectly fine on x86 behind a switch and we've tested it on 
> multiple machines. We've never had an issue of running out of virtual 
> space despite our PCI bars typically being located with an offset of 
> 56TB or more. The arch code on x86 also somehow figures out not to map 
> the memory as cachable so that's not an issue (though, at this point, 
> the CPU never accesses the memory so even if it were, it wouldn't affect 
> anything).

Oliver can you look into this ? You sais the memory was effectively
hotplug'ed into the system when creating the struct pages. That would
mean to me that it's a) mapped (which for us is cachable, maybe x86 has
tricks to avoid that) and b) potentially used to populate userspace
pages (that will definitely be cachable). Unless there's something in
there you didn't see that prevents it.

> We also had this working on ARM64 a while back but it required some out 
> of tree ZONE_DEVICE patches and some truly horrid hacks to it's arch 
> code to ioremap the memory into the page map.
> 
> You didn't mention what architecture you were trying this on.

ppc64.

> It may make sense at this point to make this feature dependent on x86 
> until more work is done to make it properly portable. Something like 
> arch functions that allow adding IO memory pages to with a specific 
> cache setting. Though, if an arch has such restrictive limits on the map 
> size it would probably need to address that too somehow.

Not fan of that approach.

So there are two issues to consider here:

 - Our MMIO space is very far away from memory (high bits set in the
address) which causes problem with things like vmmemmap, page_address,
virt_to_page etc... Do you have similar issues on arm64 ?

 - We need to ensure that the mechanism (which I'm not familiar with)
that you use to create the struct page's for the device don't end up
turning those device pages into normal "general use" pages for the
system. Oliver thinks it does, you say it doesn't, ... 

Jerome (Glisse), what's your take on this ? Smells like something that
could be covered by HMM...

Logan, the only reason you need struct page's to begin with is for the
DMA API right ? Or am I missing something here ?

Cheers,
Ben.

> Thanks,
> 
> Logan
> 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
