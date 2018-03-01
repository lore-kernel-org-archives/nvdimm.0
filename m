Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4678921FD73F4
 for <linux-nvdimm@lists.01.org>; Thu,  1 Mar 2018 12:49:46 -0800 (PST)
Date: Thu, 1 Mar 2018 15:55:49 -0500
From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [PATCH v2 00/10] Copy Offload in NVMe Fabrics with P2P PCI Memory
Message-ID: <20180301205548.GA6742@redhat.com>
References: <20180228234006.21093-1-logang@deltatee.com>
 <1519876489.4592.3.camel@kernel.crashing.org>
 <1519876569.4592.4.camel@au1.ibm.com>
 <8e808448-fc01-5da0-51e7-1a6657d5a23a@deltatee.com>
 <1519936195.4592.18.camel@au1.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1519936195.4592.18.camel@au1.ibm.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Benjamin Herrenschmidt <benh@au1.ibm.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Oliver OHalloran <oliveroh@au1.ibm.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Mar 02, 2018 at 07:29:55AM +1100, Benjamin Herrenschmidt wrote:
> On Thu, 2018-03-01 at 11:04 -0700, Logan Gunthorpe wrote:
> > =

> > On 28/02/18 08:56 PM, Benjamin Herrenschmidt wrote:
> > > On Thu, 2018-03-01 at 14:54 +1100, Benjamin Herrenschmidt wrote:
> > > > The problem is that acccording to him (I didn't double check the la=
test
> > > > patches) you effectively hotplug the PCIe memory into the system wh=
en
> > > > creating struct pages.
> > > > =

> > > > This cannot possibly work for us. First we cannot map PCIe memory as
> > > > cachable. (Note that doing so is a bad idea if you are behind a PLX
> > > > switch anyway since you'd ahve to manage cache coherency in SW).
> > > =

> > > Note: I think the above means it won't work behind a switch on x86
> > > either, will it ?
> > =

> > This works perfectly fine on x86 behind a switch and we've tested it on =

> > multiple machines. We've never had an issue of running out of virtual =

> > space despite our PCI bars typically being located with an offset of =

> > 56TB or more. The arch code on x86 also somehow figures out not to map =

> > the memory as cachable so that's not an issue (though, at this point, =

> > the CPU never accesses the memory so even if it were, it wouldn't affec=
t =

> > anything).
> =

> Oliver can you look into this ? You sais the memory was effectively
> hotplug'ed into the system when creating the struct pages. That would
> mean to me that it's a) mapped (which for us is cachable, maybe x86 has
> tricks to avoid that) and b) potentially used to populate userspace
> pages (that will definitely be cachable). Unless there's something in
> there you didn't see that prevents it.
> =

> > We also had this working on ARM64 a while back but it required some out =

> > of tree ZONE_DEVICE patches and some truly horrid hacks to it's arch =

> > code to ioremap the memory into the page map.
> > =

> > You didn't mention what architecture you were trying this on.
> =

> ppc64.
> =

> > It may make sense at this point to make this feature dependent on x86 =

> > until more work is done to make it properly portable. Something like =

> > arch functions that allow adding IO memory pages to with a specific =

> > cache setting. Though, if an arch has such restrictive limits on the ma=
p =

> > size it would probably need to address that too somehow.
> =

> Not fan of that approach.
> =

> So there are two issues to consider here:
> =

>  - Our MMIO space is very far away from memory (high bits set in the
> address) which causes problem with things like vmmemmap, page_address,
> virt_to_page etc... Do you have similar issues on arm64 ?

HMM private (HMM public is different) works around that by looking for
"hole" in address space and using those for hotplug (ie page_to_pfn()
!=3D physical pfn of the memory). This is ok for HMM because the memory
is never map by the CPU and we can find the physical pfn with a little
bit of math (page_to_pfn() - page->pgmap->res->start + page->pgmap->dev->
physical_base_address).

To avoid anything going bad i actually do not populate the kernel linear
mapping for the range hence definitly no CPU access at all through those
struct page. CPU can still access PCIE bar through usual mmio map.

> =

>  - We need to ensure that the mechanism (which I'm not familiar with)
> that you use to create the struct page's for the device don't end up
> turning those device pages into normal "general use" pages for the
> system. Oliver thinks it does, you say it doesn't, ... =

> =

> Jerome (Glisse), what's your take on this ? Smells like something that
> could be covered by HMM...

Well this again a new user of struct page for device memory just for
one usecase. I wanted HMM to be more versatile so that it could be use
for this kind of thing too. I guess the message didn't go through. I
will take some cycles tomorrow to look into this patchset to ascertain
how struct page is use in this context.

Note that i also want peer to peer for HMM users but with ACS and using
IOMMU ie having to populate IOMMU page table of one device to point to
bar of another device. I need to test on how many platform this work,
hardware engineer are unable/unwilling to commit on wether this work or
not.


> Logan, the only reason you need struct page's to begin with is for the
> DMA API right ? Or am I missing something here ?

If it is only needed for that this sounds like a waste of memory for
struct page. Thought i understand this allow new API to match previous
one.

Cheers,
J=E9r=F4me
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
