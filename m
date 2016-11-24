Return-Path: <linux-nvdimm-bounces@lists.01.org>
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
 <CAPcyv4i_5r2RVuV4F6V3ETbpKsf8jnMyQviZ7Legz3N4-v+9Og@mail.gmail.com>
 <75a1f44f-c495-7d1e-7e1c-17e89555edba@amd.com>
 <45c6e878-bece-7987-aee7-0e940044158c@deltatee.com>
 <20161123190515.GA12146@obsidianresearch.com>
 <7bc38037-b6ab-943f-59db-6280e16901ab@amd.com>
 <20161123193228.GC12146@obsidianresearch.com>
 <c2c88376-5ba7-37d1-4d3e-592383ebb00a@amd.com>
 <20161123203332.GA15062@obsidianresearch.com>
 <dd60bca8-0a35-7a3a-d3ab-b95bc3d9b973@deltatee.com>
 <20161123215510.GA16311@obsidianresearch.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <91d28749-bc64-622f-56a1-26c00e6b462a@deltatee.com>
Date: Wed, 23 Nov 2016 18:25:21 -0700
MIME-Version: 1.0
In-Reply-To: <20161123215510.GA16311@obsidianresearch.com>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
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
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Haggai Eran <haggaie@mellanox.com>, "Bridgman, John  <John.Bridgman@amd.com>, linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "Kuehling, Felix  <Felix.Kuehling@amd.com>, Serguei Sagalovitch" <serguei.sagalovitch@amd.com>, "Blinzer, Paul  <Paul.Blinzer@amd.com>, linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, Sander,, "Suravee  <Suravee.Suthikulpanit@amd.com>, linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Deucher,, "Christian  <Christian.Koenig@amd.com>, Linux-media@vger.kernel.org" <Linux-media@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>



On 23/11/16 02:55 PM, Jason Gunthorpe wrote:
>>> Only ODP hardware allows changing the DMA address on the fly, and it
>>> works at the page table level. We do not need special handling for
>>> RDMA.
>>
>> I am aware of ODP but, noted by others, it doesn't provide a general
>> solution to the points above.
> 
> How do you mean?

I was only saying it wasn't general in that it wouldn't work for IB
hardware that doesn't support ODP or other hardware  that doesn't do
similar things (like an NVMe drive).

It makes sense for hardware that supports ODP to allow MRs to not pin
the underlying memory and provide for migrations that the hardware can
follow. But most DMA engines will require the memory to be pinned and
any complex allocators (GPU or otherwise) should respect that. And that
seems like it should be the default way most of this works -- and I
think it wouldn't actually take too much effort to make it all work now
as is. (Our iopmem work is actually quite small and simple.)

>> It's also worth noting that #4 makes use of ZONE_DEVICE (#2) so they are
>> really the same option. iopmem is really just one way to get BAR
>> addresses to user-space while inside the kernel it's ZONE_DEVICE.
> 
> Seems fine for RDMA?

Yeah, we've had RDMA and O_DIRECT transfers to PCIe backed ZONE_DEVICE
memory working for some time. I'd say it's a good fit. The main question
we've had is how to expose PCIe bars to userspace to be used as MRs and
such.


Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
