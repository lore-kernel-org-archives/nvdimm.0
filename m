Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Thu, 5 Jan 2017 20:58:31 -0500
From: Jerome Glisse <j.glisse@gmail.com>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Message-ID: <20170106015831.GA2226@gmail.com>
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
 <20170105183927.GA5324@gmail.com>
 <20170105190113.GA12587@obsidianresearch.com>
 <20170105195424.GB2166@redhat.com>
 <20170105200719.GB31047@obsidianresearch.com>
 <20170105201935.GC2166@redhat.com>
 <20170105224215.GA3855@obsidianresearch.com>
 <20170105232352.GB6426@redhat.com>
 <20170106003034.GB4670@obsidianresearch.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170106003034.GB4670@obsidianresearch.com>
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
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: david1.zhou@amd.com, qiang.yu@amd.com, "'linux-rdma@vger.kernel.org'" <linux-rdma@vger.kernel.org>, "'linux-nvdimm@lists.01.org'" <linux-nvdimm@ml01.01.org>, Kuehling,, "Serguei  <Serguei.Sagalovitch@amd.com>, 'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'dri-devel@lists.freedesktop.org'" <dri-devel@lists.freedesktop.org>, Koenig,, Ben, "Suravee  <Suravee.Suthikulpanit@amd.com>, 'linux-pci@vger.kernel.org'" <linux-pci@vger.kernel.org>, Deucher,, "Paul  <Paul.Blinzer@amd.com>, 'Linux-media@vger.kernel.org'" <Linux-media@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jan 05, 2017 at 05:30:34PM -0700, Jason Gunthorpe wrote:
> On Thu, Jan 05, 2017 at 06:23:52PM -0500, Jerome Glisse wrote:
> =

> > > I still don't understand what you driving at - you've said in both
> > > cases a user VMA exists.
> > =

> > In the former case no, there is no VMA directly but if you want one than
> > a device can provide one. But such VMA is useless as CPU access is not
> > expected.
> =

> I disagree it is useless, the VMA is going to be necessary to support
> upcoming things like CAPI, you need it to support O_DIRECT from the
> filesystem, DPDK, etc. This is why I am opposed to any model that is
> not VMA based for setting up RDMA - that is shorted sighted and does
> not seem to reflect where the industry is going.
> =

> So focus on having VMA backed by actual physical memory that covers
> your GPU objects and ask how do we wire up the '__user *' to the DMA
> API in the best way so the DMA API still has enough information to
> setup IOMMUs and whatnot.

I am talking about 2 different thing. Existing hardware and API where you
_do not_ have a vma and you do not need one. This is just existing stuff.
Some close driver provide a functionality on top of this design. Question
is do we want to do the same ? If yes and you insist on having a vma we
could provide one but this is does not apply and is useless for where we
are going with new hardware.

With new hardware you just use malloc or mmap to allocate memory and then
you use it directly with the device. Device driver can migrate any part of
the process address space to device memory. In this scheme you have your
usual VMAs but there is nothing special about them.

Now when you try to do get_user_page() on any page that is inside the
device it will fails because we do not allow any device memory to be pin.
There is various reasons for that and they are not going away in any hw
in the planing (so for next few years).

Still we do want to support peer to peer mapping. Plan is to only do so
with ODP capable hardware. Still we need to solve the IOMMU issue and
it needs special handling inside the RDMA device. The way it works is
that RDMA ask for a GPU page, GPU check if it has place inside its PCI
bar to map this page for the device, this can fail. If it succeed then
you need the IOMMU to let the RDMA device access the GPU PCI bar.

So here we have 2 orthogonal problem. First one is how to make 2 drivers
talks to each other to setup mapping to allow peer to peer and second is
about IOMMU.


> > What i was trying to get accross is that no matter what level you
> > consider in the end you still need something at the DMA API level.
> > And that the 2 different use case (device vma or regular vma) means
> > 2 differents API for the device driver.
> =

> I agree we need new stuff at the DMA API level, but I am opposed to
> the idea we need two API paths that the *driver* has to figure out.
> That is fundamentally not what I want as a driver developer.
> =

> Give me a common API to convert '__user *' to a scatter list and pin
> the pages. This needs to figure out your two cases. And Huge
> Pages. And ZONE_DIRECT.. (a better get_user_pages)

Pining is not gonna happen like i said it would hinder the GPU to the
point it would become useless.


> Give me an API to take the scatter list and DMA map it, handling all
> the stuff associated with peer-peer. (a better dma_map_sg)
> =

> Give me a notifier scheme to rework my scatter list when physical
> pages need to change (mmu notifiers)
> =

> Use the scatter list memory to convey needed information from the
> first step to the second.
> =

> Do not bother the driver with distinctions on what kind of memory is
> behind that VMA. Don't ask me to use get_user_pages or
> gpu_get_user_pages, do not ask me to use dma_map_sg or
> dma_map_sg_peer_direct. The Driver Doesn't Need To Know.

I understand you want it easy but there must be part that must be aware,
at very least the ODP logic. Creating a peer to peer mapping is a multi
step process and some of those step can fails. Fallback is always to
migrate back to system memory as a default path that can not fail, except
if we are out of memory.


> IMHO this is why GPU direct is not mergable - it creates a crazy
> parallel mini-mm subsystem inside RDMA and uses that to connect to a
> GPU driver, everything is expected to have parallel paths for GPU
> direct and normal MM. No good at all.

Existing hardware and new hardware works differently. I am trying to
explain the two different design needed for each one. You understandtably
dislike the existing hardware that has more stringent requirement and
can not be supported transparently and need dedicated communication with
the two driver.

New hardware that have a completely different API in userspace. We can
decide to only support the latter and forget about the former.


> > > So, how do you identify these GPU objects? How do you expect RDMA
> > > convert them to scatter lists? How will ODP work?
> > =

> > No ODP on those. If you want vma, the GPU device driver can provide
> =

> You said you needed invalidate, that has to be done via ODP.

Invalidate is needed for both old and new hardware. With new hardware the
mmu_notifier is good enough. But you still need special handling when trying
to establish a mapping in HMM case where not all of the GPU memory can be
accessed through the bar. So no matter what it will need special handling
but this can happen in the common infrastructure code (in ODP fault path).

Cheers,
J=E9r=F4me
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
