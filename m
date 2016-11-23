Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Wed, 23 Nov 2016 14:55:10 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Message-ID: <20161123215510.GA16311@obsidianresearch.com>
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
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <dd60bca8-0a35-7a3a-d3ab-b95bc3d9b973@deltatee.com>
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

On Wed, Nov 23, 2016 at 02:11:29PM -0700, Logan Gunthorpe wrote:
> > As I said, there is no possible special handling. Standard IB hardware
> > does not support changing the DMA address once a MR is created. Forget
> > about doing that.
> 
> Yeah, that's essentially the point I was trying to make. Not to mention
> all the other unrelated hardware that can't DMA to an address that might
> disappear mid-transfer.

Right, it is impossible to ask for generic page migration with ongoing
DMA. That is simply not supported by any of the hardware at all.

> > Only ODP hardware allows changing the DMA address on the fly, and it
> > works at the page table level. We do not need special handling for
> > RDMA.
> 
> I am aware of ODP but, noted by others, it doesn't provide a general
> solution to the points above.

How do you mean?

Perhaps I am not following what Serguei is asking for, but I
understood the desire was for a complex GPU allocator that could
migrate pages between GPU and CPU memory under control of the GPU
driver, among other things. The desire is for DMA to continue to work
even after these migrations happen.

Page table mirroring *is* the general solution for this problem. The
GPU driver controls the VMA and the DMA driver mirrors that VMA.

Do you know of another option that doesn't just degenerate to page
table mirroring??

Remember, there are two facets to the RDMA ODP implementation, I feel
there is some confusion here..

The crucial part for this discussion is the ability to fence and block
DMA for a specific range. This is the hardware capability that lets
page migration happen: fence&block DMA, migrate page, update page
table in HCA, unblock DMA.

Without that hardware support the DMA address must be unchanging, and
there is nothing we can do about it. This is why standard IB hardware
must have fixed MRs - it lacks the fence&block capability.

The other part is the page faulting implementation, but that is not
required, and to Serguei's point, is not desired for GPU anyhow.

> > To me this means at least items #1 and #3 should be removed from
> > Alexander's list.
> 
> It's also worth noting that #4 makes use of ZONE_DEVICE (#2) so they are
> really the same option. iopmem is really just one way to get BAR
> addresses to user-space while inside the kernel it's ZONE_DEVICE.

Seems fine for RDMA?

Didn't we just strike off everything on the list except #2? :\

Jason
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
