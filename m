Return-Path: <linux-nvdimm-bounces@lists.01.org>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
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
 <20161125193252.GC16504@obsidianresearch.com>
From: Haggai Eran <haggaie@mellanox.com>
Message-ID: <383d4a9c-b8ce-bb00-74c5-fdcf231513ff@mellanox.com>
Date: Sun, 27 Nov 2016 10:16:19 +0200
MIME-Version: 1.0
In-Reply-To: <20161125193252.GC16504@obsidianresearch.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Cc: "Bridgman, John" <John.Bridgman@amd.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "Kuehling, Felix  <Felix.Kuehling@amd.com>, Serguei Sagalovitch" <serguei.sagalovitch@amd.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, Blinzer,, "Suravee  <Suravee.Suthikulpanit@amd.com>, linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Deucher,, "Ben  <ben.sander@amd.com>, Linux-media@vger.kernel.org" <Linux-media@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On 11/25/2016 9:32 PM, Jason Gunthorpe wrote:
> On Fri, Nov 25, 2016 at 02:22:17PM +0100, Christian K=F6nig wrote:
> =

>>> Like you say below we have to handle short lived in the usual way, and
>>> that covers basically every device except IB MRs, including the
>>> command queue on a NVMe drive.
>>
>> Well a problem which wasn't mentioned so far is that while GPUs do have a
>> page table to mirror the CPU page table, they usually can't recover from
>> page faults.
> =

>> So what we do is making sure that all memory accessed by the GPU Jobs st=
ays
>> in place while those jobs run (pretty much the same pinning you do for t=
he
>> DMA).
> =

> Yes, it is DMA, so this is a valid approach.
> =

> But, you don't need page faults from the GPU to do proper coherent
> page table mirroring. Basically when the driver submits the work to
> the GPU it 'faults' the pages into the CPU and mirror translation
> table (instead of pinning).
> =

> Like in ODP, MMU notifiers/HMM are used to monitor for translation
> changes. If a change comes in the GPU driver checks if an executing
> command is touching those pages and blocks the MMU notifier until the
> command flushes, then unfaults the page (blocking future commands) and
> unblocks the mmu notifier.
I think blocking mmu notifiers against something that is basically
controlled by user-space can be problematic. This can block things like
memory reclaim. If you have user-space access to the device's queues,
user-space can block the mmu notifier forever.

On PeerDirect, we have some kind of a middle-ground solution for pinning
GPU memory. We create a non-ODP MR pointing to VRAM but rely on
user-space and the GPU not to migrate it. If they do, the MR gets
destroyed immediately. This should work on legacy devices without ODP
support, and allows the system to safely terminate a process that
misbehaves. The downside of course is that it cannot transparently
migrate memory but I think for user-space RDMA doing that transparently
requires hardware support for paging, via something like HMM.

...

> I'm hearing most people say ZONE_DEVICE is the way to handle this,
> which means the missing remaing piece for RDMA is some kind of DMA
> core support for p2p address translation..

Yes, this is definitely something we need. I think Will Davis's patches
are a good start.

Another thing I think is that while HMM is good for user-space
applications, for kernel p2p use there is no need for that. Using
ZONE_DEVICE with or without something like DMA-BUF to pin and unpin
pages for the short duration as you wrote above could work fine for
kernel uses in which we can guarantee they are short.

Haggai
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
