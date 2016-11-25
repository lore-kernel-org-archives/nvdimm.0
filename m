Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Fri, 25 Nov 2016 13:19:39 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Message-ID: <20161125201939.GJ16504@obsidianresearch.com>
References: <c2c88376-5ba7-37d1-4d3e-592383ebb00a@amd.com>
 <20161123203332.GA15062@obsidianresearch.com>
 <dd60bca8-0a35-7a3a-d3ab-b95bc3d9b973@deltatee.com>
 <20161123215510.GA16311@obsidianresearch.com>
 <91d28749-bc64-622f-56a1-26c00e6b462a@deltatee.com>
 <20161124164249.GD20818@obsidianresearch.com>
 <3f2d2db3-fb75-2422-2a18-a8497fd5d70e@amd.com>
 <7ff3cf70-b0c3-028e-fea8-c370a1185b65@amd.com>
 <20161125193410.GD16504@obsidianresearch.com>
 <80aae3e6-278e-49af-7d09-bea87ffd19e8@amd.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <80aae3e6-278e-49af-7d09-bea87ffd19e8@amd.com>
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
Cc: Haggai Eran <haggaie@mellanox.com>, "Bridgman, John  <John.Bridgman@amd.com>, linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Kuehling,, "Paul  <Paul.Blinzer@amd.com>, linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, Sander,, "Suravee  <Suravee.Suthikulpanit@amd.com>, linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "Deucher, Alexander  <Alexander.Deucher@amd.com>, Christian =?iso-8859-1?Q?K=F6nig?=" <christian.koenig@amd.com>, "Linux-media@vger.kernel.org" <Linux-media@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Nov 25, 2016 at 02:49:50PM -0500, Serguei Sagalovitch wrote:

> GPU could perfectly access all VRAM.  It is only issue for p2p without
> special interconnect and CPU access. Strictly speaking as long as we
> have "bus address"  we could have RDMA but  I agreed that for
> RDMA we could/should(?) always "request"  CPU address (I hope that we
> could forget about 32-bit application :-)).

At least on x86 if you have a bus address you have a CPU address. All
RDMAable VRAM has to be visible in the BAR.

> BTW/FYI: About CPU access: Some user-level API is mainly handle based
> so there is no need for CPU access by default.

You mean no need for the memory to be virtually mapped into the
process?

Do you expect to RDMA from this kind of API? How will that work?

Jason
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
