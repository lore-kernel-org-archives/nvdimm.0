Return-Path: <linux-nvdimm-bounces@lists.01.org>
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
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <9cc22068-ede8-c1bc-5d8b-cf6224a7ce05@deltatee.com>
Date: Thu, 24 Nov 2016 11:11:34 -0700
MIME-Version: 1.0
In-Reply-To: <20161124164249.GD20818@obsidianresearch.com>
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



On 24/11/16 09:42 AM, Jason Gunthorpe wrote:
> There are three cases to worry about:
>  - Coherent long lived page table mirroring (RDMA ODP MR)
>  - Non-coherent long lived page table mirroring (RDMA MR)
>  - Short lived DMA mapping (everything else)
> 
> Like you say below we have to handle short lived in the usual way, and
> that covers basically every device except IB MRs, including the
> command queue on a NVMe drive.

Yes, this makes sense to me. Though I thought regular IB MRs with
regular memory currently pinned the pages (despite being long lived)
that's why we can run up against the "max locked memory" limit. It
doesn't seem so terrible if GPU memory had a similar restriction until
ODP like solutions get implemented.

>> Yeah, we've had RDMA and O_DIRECT transfers to PCIe backed ZONE_DEVICE
>> memory working for some time. I'd say it's a good fit. The main question
>> we've had is how to expose PCIe bars to userspace to be used as MRs and
>> such.

> Is there any progress on that?

Well, I guess there's some consensus building to do. The existing
options are:

* Device DAX: which could work but the problem I see with it is that it
only allows one application to do these transfers. Or there would have
to be some user-space coordination to figure which application gets what
memeroy.

* Regular DAX in the FS doesn't work at this time because the FS can
move the file you think your transfer to out from under you. Though I
understand there's been some work with XFS to solve that issue.

Though, we've been considering that the backed memory would be
non-volatile which adds some of this complexity. If the memory were
volatile the kernel would just need to do some relatively straight
forward allocation to user-space when asked. For example, with NVMe, the
kernel could give chunks of the CMB buffer to userspace via an mmap call
to /dev/nvmeX. Though I think there's been some push back against things
like that as well.

> I still don't quite get what iopmem was about.. I thought the
> objection to uncachable ZONE_DEVICE & DAX made sense, so running DAX
> over iopmem and still ending up with uncacheable mmaps still seems
> like a non-starter to me...

The latest incarnation of iopmem simply created a block device backed by
ZONE_DEVICE memory on a PCIe BAR. We then put a DAX FS on it and
user-space could mmap the files and send them to other devices to do P2P
transfers.

I don't think there was a hard objection to uncachable ZONE_DEVICE and
DAX. We did try our experimental hardware with cached ZONE_DEVICE and it
did work but the performance was beyond unusable (which may be a
hardware issue). In the end I feel the driver would have to decide the
most appropriate caching for the hardware and I don't understand why WC
or UC wouldn't work with ZONE_DEVICE.

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
