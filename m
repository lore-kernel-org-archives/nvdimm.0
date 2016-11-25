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
 <3f2d2db3-fb75-2422-2a18-a8497fd5d70e@amd.com>
From: Serguei Sagalovitch <serguei.sagalovitch@amd.com>
Message-ID: <7ff3cf70-b0c3-028e-fea8-c370a1185b65@amd.com>
Date: Fri, 25 Nov 2016 12:16:30 -0500
MIME-Version: 1.0
In-Reply-To: <3f2d2db3-fb75-2422-2a18-a8497fd5d70e@amd.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Logan Gunthorpe <logang@deltatee.com>
Cc: Haggai Eran <haggaie@mellanox.com>, "Bridgman, John  <John.Bridgman@amd.com>, linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "Kuehling, Felix  <Felix.Kuehling@amd.com>, linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, Blinzer,, "Suravee  <Suravee.Suthikulpanit@amd.com>, linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Deucher,, "Ben  <ben.sander@amd.com>, Linux-media@vger.kernel.org" <Linux-media@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On 2016-11-25 08:22 AM, Christian K=F6nig wrote:
>
>> Serguei, what is your plan in GPU land for migration? Ie if I have a
>> CPU mapped page and the GPU moves it to VRAM, it becomes non-cachable
>> - do you still allow the CPU to access it? Or do you swap it back to
>> cachable memory if the CPU touches it?
>
> Depends on the policy in command, but currently it's the other way =

> around most of the time.
>
> E.g. we allocate memory in VRAM, the CPU writes to it WC and avoids =

> reading because that is slow, the GPU in turn can access it with full =

> speed.
>
> When we run out of VRAM we move those allocations to system memory and =

> update both the CPU as well as the GPU page tables.
>
> So that move is transparent for both userspace as well as shaders =

> running on the GPU.
I would like to add more in relation to  CPU access :

a) we could have CPU-accessible part of VRAM ("inside" of PCIe BAR register)
and non-CPU  accessible part.  As the result if user needs to have
CPU access than memory should be located in CPU-accessible part
of VRAM or in system memory.

Application/user mode driver could specify preference/hints of
locations based on their assumption / knowledge about access
patterns requirements, game resolution,  knowledge
about size of VRAM memory, etc.  So if CPU access performance
is critical then such memory should be allocated in system memory
as  the first (and may be only) choice.

b) Allocation may not  have CPU address  at all - only GPU one.
Also we may not be able to have CPU address/accesses for all VRAM
memory but memory may still  be migrated in any case unrelated
if we have CPU address or not.

c) " VRAM, it becomes non-cachable "
Strictly speaking VRAM is configured as WC (write-combined memory) to
provide fast CPU write access. Also it was found that sometimes if CPU
access is not critical from performance perspective it may be useful
to allocate/program system memory also as WC to  avoid needs for
extra "snooping" to synchronize with CPU caches during GPU access.
So potentially system memory could be WC too.


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
