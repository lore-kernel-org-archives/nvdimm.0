Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Thu, 24 Nov 2016 09:42:49 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Message-ID: <20161124164249.GD20818@obsidianresearch.com>
References: <75a1f44f-c495-7d1e-7e1c-17e89555edba@amd.com>
 <45c6e878-bece-7987-aee7-0e940044158c@deltatee.com>
 <20161123190515.GA12146@obsidianresearch.com>
 <7bc38037-b6ab-943f-59db-6280e16901ab@amd.com>
 <20161123193228.GC12146@obsidianresearch.com>
 <c2c88376-5ba7-37d1-4d3e-592383ebb00a@amd.com>
 <20161123203332.GA15062@obsidianresearch.com>
 <dd60bca8-0a35-7a3a-d3ab-b95bc3d9b973@deltatee.com>
 <20161123215510.GA16311@obsidianresearch.com>
 <91d28749-bc64-622f-56a1-26c00e6b462a@deltatee.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <91d28749-bc64-622f-56a1-26c00e6b462a@deltatee.com>
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
Cc: Haggai Eran <haggaie@mellanox.com>, "Bridgman, John  <John.Bridgman@amd.com>, linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "Kuehling, Felix  <Felix.Kuehling@amd.com>, Serguei Sagalovitch" <serguei.sagalovitch@amd.com>, "Blinzer, Paul  <Paul.Blinzer@amd.com>, linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, Sander,, "Suravee  <Suravee.Suthikulpanit@amd.com>, linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Deucher,, "Christian  <Christian.Koenig@amd.com>, Linux-media@vger.kernel.org" <Linux-media@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Nov 23, 2016 at 06:25:21PM -0700, Logan Gunthorpe wrote:
> 
> 
> On 23/11/16 02:55 PM, Jason Gunthorpe wrote:
> >>> Only ODP hardware allows changing the DMA address on the fly, and it
> >>> works at the page table level. We do not need special handling for
> >>> RDMA.
> >>
> >> I am aware of ODP but, noted by others, it doesn't provide a general
> >> solution to the points above.
> > 
> > How do you mean?
> 
> I was only saying it wasn't general in that it wouldn't work for IB
> hardware that doesn't support ODP or other hardware  that doesn't do
> similar things (like an NVMe drive).

There are three cases to worry about:
 - Coherent long lived page table mirroring (RDMA ODP MR)
 - Non-coherent long lived page table mirroring (RDMA MR)
 - Short lived DMA mapping (everything else)

Like you say below we have to handle short lived in the usual way, and
that covers basically every device except IB MRs, including the
command queue on a NVMe drive.

> any complex allocators (GPU or otherwise) should respect that. And that
> seems like it should be the default way most of this works -- and I
> think it wouldn't actually take too much effort to make it all work now
> as is. (Our iopmem work is actually quite small and simple.)

Yes, absolutely, some kind of page pinning like locking is a hard
requirement.

> Yeah, we've had RDMA and O_DIRECT transfers to PCIe backed ZONE_DEVICE
> memory working for some time. I'd say it's a good fit. The main question
> we've had is how to expose PCIe bars to userspace to be used as MRs and
> such.

Is there any progress on that?

I still don't quite get what iopmem was about.. I thought the
objection to uncachable ZONE_DEVICE & DAX made sense, so running DAX
over iopmem and still ending up with uncacheable mmaps still seems
like a non-starter to me...

Serguei, what is your plan in GPU land for migration? Ie if I have a
CPU mapped page and the GPU moves it to VRAM, it becomes non-cachable
- do you still allow the CPU to access it? Or do you swap it back to
cachable memory if the CPU touches it?

One approach might be to mmap the uncachable ZONE_DEVICE memory and
mark it inaccessible to the CPU - DMA could still translate. If the
CPU needs it then the kernel migrates it to system memory so it
becomes cachable. ??

Jason
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
