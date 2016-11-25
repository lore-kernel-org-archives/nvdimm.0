Return-Path: <linux-nvdimm-bounces@lists.01.org>
MIME-Version: 1.0
In-Reply-To: <20161125193410.GD16504@obsidianresearch.com>
References: <7bc38037-b6ab-943f-59db-6280e16901ab@amd.com>
 <20161123193228.GC12146@obsidianresearch.com>
 <c2c88376-5ba7-37d1-4d3e-592383ebb00a@amd.com>
 <20161123203332.GA15062@obsidianresearch.com>
 <dd60bca8-0a35-7a3a-d3ab-b95bc3d9b973@deltatee.com>
 <20161123215510.GA16311@obsidianresearch.com>
 <91d28749-bc64-622f-56a1-26c00e6b462a@deltatee.com>
 <20161124164249.GD20818@obsidianresearch.com>
 <3f2d2db3-fb75-2422-2a18-a8497fd5d70e@amd.com>
 <7ff3cf70-b0c3-028e-fea8-c370a1185b65@amd.com>
 <20161125193410.GD16504@obsidianresearch.com>
From: Alex Deucher <alexdeucher@gmail.com>
Date: Fri, 25 Nov 2016 18:41:21 -0500
Message-ID: <CADnq5_PEBzxO7MVxV3q4Jy3uZNTfKWXo-gsvZQA8BdTMOSPjmw@mail.gmail.com>
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
Cc: Haggai Eran <haggaie@mellanox.com>, "Bridgman, John  <John.Bridgman@amd.com>, linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "Kuehling, Felix  <Felix.Kuehling@amd.com>, Serguei Sagalovitch" <serguei.sagalovitch@amd.com>, "Blinzer, Paul  <Paul.Blinzer@amd.com>, linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, Sander,, "Suravee  <Suravee.Suthikulpanit@amd.com>, linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "Deucher, Alexander  <Alexander.Deucher@amd.com>, =?UTF-8?Q?Christian_K=C3=B6nig?=" <christian.koenig@amd.com>, "Linux-media@vger.kernel.org" <Linux-media@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Nov 25, 2016 at 2:34 PM, Jason Gunthorpe
<jgunthorpe@obsidianresearch.com> wrote:
> On Fri, Nov 25, 2016 at 12:16:30PM -0500, Serguei Sagalovitch wrote:
>
>> b) Allocation may not  have CPU address  at all - only GPU one.
>
> But you don't expect RDMA to work in the case, right?
>
> GPU people need to stop doing this windowed memory stuff :)
>

Blame 32 bit systems and GPUs with tons of vram :)

I think resizable bars are finally coming in a useful way so this
should go away soon.

Alex
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
