Return-Path: <linux-nvdimm-bounces@lists.01.org>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
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
 <20161124164249.GD20818@obsidianresearch.com>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <3f2d2db3-fb75-2422-2a18-a8497fd5d70e@amd.com>
Date: Fri, 25 Nov 2016 14:22:17 +0100
MIME-Version: 1.0
In-Reply-To: <20161124164249.GD20818@obsidianresearch.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Logan Gunthorpe <logang@deltatee.com>
Cc: Haggai Eran <haggaie@mellanox.com>, "Bridgman, John  <John.Bridgman@amd.com>, linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "Kuehling, Felix  <Felix.Kuehling@amd.com>, Serguei Sagalovitch" <serguei.sagalovitch@amd.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, Blinzer,, "Suravee  <Suravee.Suthikulpanit@amd.com>, linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Deucher,, "Ben  <ben.sander@amd.com>, Linux-media@vger.kernel.org" <Linux-media@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

Am 24.11.2016 um 17:42 schrieb Jason Gunthorpe:
> On Wed, Nov 23, 2016 at 06:25:21PM -0700, Logan Gunthorpe wrote:
>>
>> On 23/11/16 02:55 PM, Jason Gunthorpe wrote:
>>>>> Only ODP hardware allows changing the DMA address on the fly, and it
>>>>> works at the page table level. We do not need special handling for
>>>>> RDMA.
>>>> I am aware of ODP but, noted by others, it doesn't provide a general
>>>> solution to the points above.
>>> How do you mean?
>> I was only saying it wasn't general in that it wouldn't work for IB
>> hardware that doesn't support ODP or other hardware  that doesn't do
>> similar things (like an NVMe drive).
> There are three cases to worry about:
>   - Coherent long lived page table mirroring (RDMA ODP MR)
>   - Non-coherent long lived page table mirroring (RDMA MR)
>   - Short lived DMA mapping (everything else)
>
> Like you say below we have to handle short lived in the usual way, and
> that covers basically every device except IB MRs, including the
> command queue on a NVMe drive.

Well a problem which wasn't mentioned so far is that while GPUs do have 
a page table to mirror the CPU page table, they usually can't recover 
from page faults.

So what we do is making sure that all memory accessed by the GPU Jobs 
stays in place while those jobs run (pretty much the same pinning you do 
for the DMA).

But since this can lock down huge amounts of memory the whole command 
submission to GPUs is bound to the memory management. So when to much 
memory would get blocked by the GPU we block further command submissions 
until the situation resolves.

>> any complex allocators (GPU or otherwise) should respect that. And that
>> seems like it should be the default way most of this works -- and I
>> think it wouldn't actually take too much effort to make it all work now
>> as is. (Our iopmem work is actually quite small and simple.)
> Yes, absolutely, some kind of page pinning like locking is a hard
> requirement.
>
>> Yeah, we've had RDMA and O_DIRECT transfers to PCIe backed ZONE_DEVICE
>> memory working for some time. I'd say it's a good fit. The main question
>> we've had is how to expose PCIe bars to userspace to be used as MRs and
>> such.
> Is there any progress on that?
>
> I still don't quite get what iopmem was about.. I thought the
> objection to uncachable ZONE_DEVICE & DAX made sense, so running DAX
> over iopmem and still ending up with uncacheable mmaps still seems
> like a non-starter to me...
>
> Serguei, what is your plan in GPU land for migration? Ie if I have a
> CPU mapped page and the GPU moves it to VRAM, it becomes non-cachable
> - do you still allow the CPU to access it? Or do you swap it back to
> cachable memory if the CPU touches it?

Depends on the policy in command, but currently it's the other way 
around most of the time.

E.g. we allocate memory in VRAM, the CPU writes to it WC and avoids 
reading because that is slow, the GPU in turn can access it with full speed.

When we run out of VRAM we move those allocations to system memory and 
update both the CPU as well as the GPU page tables.

So that move is transparent for both userspace as well as shaders 
running on the GPU.

> One approach might be to mmap the uncachable ZONE_DEVICE memory and
> mark it inaccessible to the CPU - DMA could still translate. If the
> CPU needs it then the kernel migrates it to system memory so it
> becomes cachable. ??

The whole purpose of this effort is that we can do I/O on VRAM directly 
without migrating everything back to system memory.

Allowing this, but then doing the migration by the first touch of the 
CPU is clearly not a good idea.

Regards,
Christian.

>
> Jason


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
