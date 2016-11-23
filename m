Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Wed, 23 Nov 2016 12:32:28 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Message-ID: <20161123193228.GC12146@obsidianresearch.com>
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
 <CAPcyv4i_5r2RVuV4F6V3ETbpKsf8jnMyQviZ7Legz3N4-v+9Og@mail.gmail.com>
 <75a1f44f-c495-7d1e-7e1c-17e89555edba@amd.com>
 <45c6e878-bece-7987-aee7-0e940044158c@deltatee.com>
 <20161123190515.GA12146@obsidianresearch.com>
 <7bc38037-b6ab-943f-59db-6280e16901ab@amd.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <7bc38037-b6ab-943f-59db-6280e16901ab@amd.com>
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
To: Serguei Sagalovitch <serguei.sagalovitch@amd.com>
Cc: Haggai Eran <haggaie@mellanox.com>, "Bridgman, John  <John.Bridgman@amd.com>, linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Kuehling,, "Paul  <Paul.Blinzer@amd.com>, linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, Sander,, "Suravee  <Suravee.Suthikulpanit@amd.com>, linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Deucher,, "Christian  <Christian.Koenig@amd.com>, Linux-media@vger.kernel.org" <Linux-media@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Nov 23, 2016 at 02:14:40PM -0500, Serguei Sagalovitch wrote:
> 
> On 2016-11-23 02:05 PM, Jason Gunthorpe wrote:

> >As Bart says, it would be best to be combined with something like
> >Mellanox's ODP MRs, which allows a page to be evicted and then trigger
> >a CPU interrupt if a DMA is attempted so it can be brought back.

> Please note that in the general case (including  MR one) we could have
> "page fault" from the different PCIe device. So all  PCIe device must
> be synchronized.

Standard RDMA MRs require pinned pages, the DMA address cannot change
while the MR exists (there is no hardware support for this at all), so
page faulting from any other device is out of the question while they
exist. This is the same requirement as typical simple driver DMA which
requires pages pinned until the simple device completes DMA.

ODP RDMA MRs do not require that, they just page fault like the CPU or
really anything and the kernel has to make sense of concurrant page
faults from multiple sources.

The upshot is that GPU scenarios that rely on highly dynamic
virtual->physical translation cannot sanely be combined with standard
long-life RDMA MRs.

Certainly, any solution for GPUs must follow the typical page pinning
semantics, changing the DMA address of a page must be blocked while
any DMA is in progress.

> >Does HMM solve the peer-peer problem? Does it do it generically or
> >only for drivers that are mirroring translation tables?

> In current form HMM doesn't solve peer-peer problem. Currently it allow
> "mirroring" of  "malloc" memory on GPU which is not always what needed.
> Additionally  there is need to have opportunity to share VRAM allocations
> between  different processes.

Humm, so it can be removed from Alexander's list then :\

As Dan suggested, maybe we need to do both. Some kind of fix for
get_user_pages() for smaller mappings (eg ZONE_DEVICE) and a mandatory
API conversion to get_user_dma_sg() for other cases?

Jason
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
