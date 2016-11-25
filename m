Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Fri, 25 Nov 2016 12:32:52 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Message-ID: <20161125193252.GC16504@obsidianresearch.com>
References: <20161123190515.GA12146@obsidianresearch.com>
 <7bc38037-b6ab-943f-59db-6280e16901ab@amd.com>
 <20161123193228.GC12146@obsidianresearch.com>
 <c2c88376-5ba7-37d1-4d3e-592383ebb00a@amd.com>
 <20161123203332.GA15062@obsidianresearch.com>
 <dd60bca8-0a35-7a3a-d3ab-b95bc3d9b973@deltatee.com>
 <20161123215510.GA16311@obsidianresearch.com>
 <91d28749-bc64-622f-56a1-26c00e6b462a@deltatee.com>
 <20161124164249.GD20818@obsidianresearch.com>
 <3f2d2db3-fb75-2422-2a18-a8497fd5d70e@amd.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <3f2d2db3-fb75-2422-2a18-a8497fd5d70e@amd.com>
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
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Haggai Eran <haggaie@mellanox.com>, "Bridgman, John  <John.Bridgman@amd.com>, linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "Kuehling, Felix  <Felix.Kuehling@amd.com>, Serguei Sagalovitch" <serguei.sagalovitch@amd.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, Blinzer,, "Suravee  <Suravee.Suthikulpanit@amd.com>, linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Deucher,, "Ben  <ben.sander@amd.com>, Linux-media@vger.kernel.org" <Linux-media@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Nov 25, 2016 at 02:22:17PM +0100, Christian K=F6nig wrote:

> >Like you say below we have to handle short lived in the usual way, and
> >that covers basically every device except IB MRs, including the
> >command queue on a NVMe drive.
> =

> Well a problem which wasn't mentioned so far is that while GPUs do have a
> page table to mirror the CPU page table, they usually can't recover from
> page faults.

> So what we do is making sure that all memory accessed by the GPU Jobs sta=
ys
> in place while those jobs run (pretty much the same pinning you do for the
> DMA).

Yes, it is DMA, so this is a valid approach.

But, you don't need page faults from the GPU to do proper coherent
page table mirroring. Basically when the driver submits the work to
the GPU it 'faults' the pages into the CPU and mirror translation
table (instead of pinning).

Like in ODP, MMU notifiers/HMM are used to monitor for translation
changes. If a change comes in the GPU driver checks if an executing
command is touching those pages and blocks the MMU notifier until the
command flushes, then unfaults the page (blocking future commands) and
unblocks the mmu notifier.

The code moving the page will move it and the next GPU command that
needs it will refault it in the usual way, just like the CPU would.

This might be much more efficient since it optimizes for the common
case of unchanging translation tables.

This assumes the commands are fairly short lived of course, the
expectation of the mmu notifiers is that a flush is reasonably prompt
..

> >Serguei, what is your plan in GPU land for migration? Ie if I have a
> >CPU mapped page and the GPU moves it to VRAM, it becomes non-cachable
> >- do you still allow the CPU to access it? Or do you swap it back to
> >cachable memory if the CPU touches it?
> =

> Depends on the policy in command, but currently it's the other way around
> most of the time.
> =

> E.g. we allocate memory in VRAM, the CPU writes to it WC and avoids readi=
ng
> because that is slow, the GPU in turn can access it with full speed.
> =

> When we run out of VRAM we move those allocations to system memory and
> update both the CPU as well as the GPU page tables.
> =

> So that move is transparent for both userspace as well as shaders running=
 on
> the GPU.

That makes sense to me, but the objection that came back for
non-cachable CPU mappings is that it basically breaks too much stuff
subtly, eg atomics, unaligned accesses, the CPU threading memory
model, all change on various architectures and break when caching is
disabled.

IMHO that is OK for specialty things like the GPU where the mmap comes
in via drm or something and apps know to handle that buffer specially.

But it is certainly not OK for DAX where the application is coded for
normal file open()/mmap() is not prepared for a mmap where (eg)
unaligned read accesses or atomics don't work depending on how the
filesystem is setup.

Which is why I think iopmem is still problematic..

At the very least I think a mmap flag or open flag should be needed to
opt into this behavior and by default non-cachebale DAX mmaps should
be paged into system ram when the CPU accesses them.

I'm hearing most people say ZONE_DEVICE is the way to handle this,
which means the missing remaing piece for RDMA is some kind of DMA
core support for p2p address translation..

Jason
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
