Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Wed, 23 Nov 2016 13:33:32 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Message-ID: <20161123203332.GA15062@obsidianresearch.com>
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
 <CAPcyv4i_5r2RVuV4F6V3ETbpKsf8jnMyQviZ7Legz3N4-v+9Og@mail.gmail.com>
 <75a1f44f-c495-7d1e-7e1c-17e89555edba@amd.com>
 <45c6e878-bece-7987-aee7-0e940044158c@deltatee.com>
 <20161123190515.GA12146@obsidianresearch.com>
 <7bc38037-b6ab-943f-59db-6280e16901ab@amd.com>
 <20161123193228.GC12146@obsidianresearch.com>
 <c2c88376-5ba7-37d1-4d3e-592383ebb00a@amd.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <c2c88376-5ba7-37d1-4d3e-592383ebb00a@amd.com>
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

On Wed, Nov 23, 2016 at 02:58:38PM -0500, Serguei Sagalovitch wrote:

>    We do not want to have "highly" dynamic translation due to
>    performance cost.  We need to support "overcommit" but would
>    like to minimize impact.  To support RDMA MRs for GPU/VRAM/PCIe
>    device memory (which is must) we need either globally force
>    pinning for the scope of "get_user_pages() / "put_pages" or have
>    special handling for RDMA MRs and similar cases.

As I said, there is no possible special handling. Standard IB hardware
does not support changing the DMA address once a MR is created. Forget
about doing that.

Only ODP hardware allows changing the DMA address on the fly, and it
works at the page table level. We do not need special handling for
RDMA.

>    Generally it could be difficult to correctly handle "DMA in
>    progress" due to the facts that (a) DMA could originate from
>    numerous PCIe devices simultaneously including requests to
>    receive network data.

We handle all of this today in kernel via the page pinning mechanism.
This needs to be copied into peer-peer memory and GPU memory schemes
as well. A pinned page means the DMA address channot be changed and
there is active non-CPU access to it.

Any hardware that does not support page table mirroring must go this
route.

> (b) in HSA case DMA could originated from user space without kernel
>    driver knowledge.  So without corresponding h/w support
>    everywhere I do not see how it could be solved effectively.

All true user triggered DMA must go through some kind of coherent page
table mirroring scheme (eg this is what CAPI does, presumably AMDs HSA
is similar). A page table mirroring scheme is basically the same as
what ODP does.

Like I said, this is the direction the industry seems to be moving in,
so any solution here should focus on VMAs/page tables as the way to link
the peer-peer devices.

To me this means at least items #1 and #3 should be removed from
Alexander's list.

Jason
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
