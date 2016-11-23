Return-Path: <linux-nvdimm-bounces@lists.01.org>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
 <CAPcyv4i_5r2RVuV4F6V3ETbpKsf8jnMyQviZ7Legz3N4-v+9Og@mail.gmail.com>
 <75a1f44f-c495-7d1e-7e1c-17e89555edba@amd.com>
 <45c6e878-bece-7987-aee7-0e940044158c@deltatee.com>
 <eca737c1-415c-bcd4-80b9-628010638051@sandisk.com>
 <CAPcyv4jsgrsQaeewFedUzcD1XLSQ8vQ5Zyr8EoB_5ORUqmL4nQ@mail.gmail.com>
 <20161123191215.GB12146@obsidianresearch.com>
From: Serguei Sagalovitch <serguei.sagalovitch@amd.com>
Message-ID: <1dffffdf-55e2-0842-60f0-ffbfbd70aa2d@amd.com>
Date: Wed, 23 Nov 2016 14:24:33 -0500
MIME-Version: 1.0
In-Reply-To: <20161123191215.GB12146@obsidianresearch.com>
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
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Dan Williams <dan.j.williams@intel.com>
Cc: "Bridgman, John" <John.Bridgman@amd.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Kuehling,, "Paul  <Paul.Blinzer@amd.com>, linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, Sander,, "Suravee  <Suravee.Suthikulpanit@amd.com>, linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "Deucher, Alexander  <Alexander.Deucher@amd.com>, Bart Van Assche" <bart.vanassche@sandisk.com>, "Koenig,  Christian  <Christian.Koenig@amd.com>, Linux-media@vger.kernel.org" <Linux-media@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>



On 2016-11-23 02:12 PM, Jason Gunthorpe wrote:
> On Wed, Nov 23, 2016 at 10:40:47AM -0800, Dan Williams wrote:
>
>> I don't think that was designed for the case where the backing memory
>> is a special/static physical address range rather than anonymous
>> "System RAM", right?
> The hardware doesn't care where the memory is. ODP is just a generic
> mechanism to provide demand-fault behavior for a mirrored page table.
>
> ODP has the same issue as everything else, it needs to translate a
> page table entry into a DMA address, and we have no API to do that
> when the page table points to peer-peer memory.
>
> Jason
I would like to note that for graphics applications (especially for VR 
support) we
should  avoid ODP  case at any cost during graphics commands execution  due
to requirement to have smooth and predictable playback. We want to load 
/ "pin"
all required resources before graphics processor begin to touch them. 
This is not
so critical for compute applications. Because only graphics / compute stack
knows which resource will be in used as well as all statistics 
accordingly only graphics
stack is capable to make the correct decision when and _where_ evict as 
well
as when and _where_ to put memory back.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
