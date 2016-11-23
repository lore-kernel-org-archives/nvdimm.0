Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Wed, 23 Nov 2016 12:05:15 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Message-ID: <20161123190515.GA12146@obsidianresearch.com>
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
 <CAPcyv4i_5r2RVuV4F6V3ETbpKsf8jnMyQviZ7Legz3N4-v+9Og@mail.gmail.com>
 <75a1f44f-c495-7d1e-7e1c-17e89555edba@amd.com>
 <45c6e878-bece-7987-aee7-0e940044158c@deltatee.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <45c6e878-bece-7987-aee7-0e940044158c@deltatee.com>
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
Cc: "Bridgman, John" <John.Bridgman@amd.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "Kuehling, Felix  <Felix.Kuehling@amd.com>, Serguei Sagalovitch" <serguei.sagalovitch@amd.com>, "Blinzer, Paul  <Paul.Blinzer@amd.com>, linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, Sander,, "Suravee  <Suravee.Suthikulpanit@amd.com>, linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Deucher,, "Christian  <Christian.Koenig@amd.com>, Linux-media@vger.kernel.org" <Linux-media@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Nov 23, 2016 at 10:13:03AM -0700, Logan Gunthorpe wrote:

> an MR would be very tricky. The MR may be relied upon by another host
> and the kernel would have to inform user-space the MR was invalid then
> user-space would have to tell the remote application.

As Bart says, it would be best to be combined with something like
Mellanox's ODP MRs, which allows a page to be evicted and then trigger
a CPU interrupt if a DMA is attempted so it can be brought back. This
includes the usual fencing mechanism so the CPU can block, flush, and
then evict a page coherently.

This is the general direction the industry is going in: Link PCI DMA
directly to dynamic user page tabels, including support for demand
faulting and synchronicity.

Mellanox ODP is a rough implementation of mirroring a process's page
table via the kernel, while IBM's CAPI (and CCIX, PCI ATS?) is
probably a good example of where this is ultimately headed.

CAPI allows a PCI DMA to directly target an ASID associated with a
user process and then use the usual CPU machinery to do the page
translation for the DMA. This includes page faults for evicted pages,
and obviously allows eviction and migration..

So, of all the solutions in the original list, I would discard
anything that isn't VMA focused. Emulating what CAPI does in hardware
with software is probably the best choice, or we have to do it all
again when CAPI style hardware broadly rolls out :(

DAX and GPU allocators should create VMAs and manipulate them in the
usual way to achieve migration, windowing, cache&mirror, movement or
swap of the potentially peer-peer memory pages. They would have to
respect the usual rules for a VMA, including pinning.

DMA drivers would use the usual approaches for dealing with DMA from
a VMA: short term pin or long term coherent translation mirror.

So, to my view (looking from RDMA), the main problem with peer-peer is
how do you DMA translate VMA's that point at non struct page memory?

Does HMM solve the peer-peer problem? Does it do it generically or
only for drivers that are mirroring translation tables?

>From a RDMA perspective we could use something other than
get_user_pages() to pin and DMA translate a VMA if the core community
could decide on an API. eg get_user_dma_sg() would probably be quite
usable.

Jason
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
