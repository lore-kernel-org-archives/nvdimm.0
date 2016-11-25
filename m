Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Fri, 25 Nov 2016 14:18:46 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Message-ID: <20161125211846.GA22521@obsidianresearch.com>
References: <20161123193228.GC12146@obsidianresearch.com>
 <c2c88376-5ba7-37d1-4d3e-592383ebb00a@amd.com>
 <20161123203332.GA15062@obsidianresearch.com>
 <dd60bca8-0a35-7a3a-d3ab-b95bc3d9b973@deltatee.com>
 <20161123215510.GA16311@obsidianresearch.com>
 <91d28749-bc64-622f-56a1-26c00e6b462a@deltatee.com>
 <20161124164249.GD20818@obsidianresearch.com>
 <3f2d2db3-fb75-2422-2a18-a8497fd5d70e@amd.com>
 <20161125193252.GC16504@obsidianresearch.com>
 <a98185d9-ffb1-6469-4272-2d1222600825@vodafone.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <a98185d9-ffb1-6469-4272-2d1222600825@vodafone.de>
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
To: Christian =?iso-8859-1?Q?K=F6nig?= <deathsimple@vodafone.de>
Cc: Haggai Eran <haggaie@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "Kuehling, Felix  <Felix.Kuehling@amd.com>, Serguei Sagalovitch" <serguei.sagalovitch@amd.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, Blinzer,, "Ben  <ben.sander@amd.com>, Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "Deucher, Alexander  <Alexander.Deucher@amd.com>, Christian =?iso-8859-1?Q?K=F6nig?=" <christian.koenig@amd.com>, "Linux-media@vger.kernel.org" <Linux-media@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Nov 25, 2016 at 09:40:10PM +0100, Christian K=F6nig wrote:

> We call this "userptr" and it's just a combination of get_user_pages() on
> command submission and making sure the returned list of pages stays valid
> using a MMU notifier.

Doesn't that still pin the page?

> The "big" problem with this approach is that it is horrible slow. I mean
> seriously horrible slow so that we actually can't use it for some of the
> purposes we wanted to use it.
> =

> >The code moving the page will move it and the next GPU command that
> >needs it will refault it in the usual way, just like the CPU would.
> =

> And here comes the problem. CPU do this on a page by page basis, so they
> fault only what needed and everything else gets filled in on demand. This
> results that faulting a page is relatively light weight operation.
>
> But for GPU command submission we don't know which pages might be accessed
> beforehand, so what we do is walking all possible pages and make sure all=
 of
> them are present.

Little confused why this is slow? So you fault the entire user MM into
your page tables at start of day and keep track of it with mmu
notifiers?

> >This might be much more efficient since it optimizes for the common
> >case of unchanging translation tables.
> =

> Yeah, completely agree. It works perfectly fine as long as you don't have
> two drivers trying to mess with the same page.

Well, the idea would be to not have the GPU block the other driver
beyond hinting that the page shouldn't be swapped out.

> >This assumes the commands are fairly short lived of course, the
> >expectation of the mmu notifiers is that a flush is reasonably prompt
> =

> Correct, this is another problem. GFX command submissions usually don't t=
ake
> longer than a few milliseconds, but compute command submission can easily
> take multiple hours.

So, that won't work - you have the same issue as RDMA with work loads
like that.

If you can't somehow fence the hardware then pinning is the only
solution. Felix has the right kind of suggestion for what is needed -
globally stop the GPU, fence the DMA, fix the page tables, and start
it up again. :\

> I can easily imagine what would happen when kswapd is blocked by a GPU
> command submission for an hour or so while the system is under memory
> pressure :)

Right. The advantage of pinning is it tells the other stuff not to
touch the page and doesn't block it, MMU notifiers have to be able to
block&fence quickly.

> I'm thinking on this problem for about a year now and going in circles for
> quite a while. So if you have ideas on this even if they sound totally
> crazy, feel free to come up.

Well, it isn't a software problem. From what I've seen in this thread
the GPU application requires coherent page table mirroring, so the
only full & complete solution is going to be to actually implement
that somehow in GPU hardware.

Everything else is going to be deeply flawed somehow. Linux just
doesn't have the support for this kind of stuff - and I'm honestly not
sure something better is even possible considering the hardware
constraints....

This doesn't have to be faulting, but really anything that lets you
pause the GPU DMA and reload the page tables.

You might look at trying to use the IOMMU and/or PCI ATS in very new
hardware. IIRC the physical IOMMU hardware can do the fault and fence
and block stuff, but I'm not sure about software support for using the
IOMMU to create coherent user page table mirrors - that is something
Linux doesn't do today. But there is demand for this kind of capability..

Jason
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
