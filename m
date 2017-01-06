Return-Path: <linux-nvdimm-bounces@lists.01.org>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
 <20170105183927.GA5324@gmail.com>
 <20170105190113.GA12587@obsidianresearch.com>
 <20170105195424.GB2166@redhat.com>
 <20170105200719.GB31047@obsidianresearch.com>
 <20170105201935.GC2166@redhat.com>
 <20170105224215.GA3855@obsidianresearch.com>
 <20170105232352.GB6426@redhat.com>
 <20170106003034.GB4670@obsidianresearch.com>
 <20170106015831.GA2226@gmail.com>
From: Serguei Sagalovitch <serguei.sagalovitch@amd.com>
Message-ID: <f07700d5-211f-d091-2b0b-fbaf03c4a959@amd.com>
Date: Fri, 6 Jan 2017 11:56:30 -0500
MIME-Version: 1.0
In-Reply-To: <20170106015831.GA2226@gmail.com>
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
To: Jerome Glisse <j.glisse@gmail.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: david1.zhou@amd.com, qiang.yu@amd.com, "'linux-rdma@vger.kernel.org'" <linux-rdma@vger.kernel.org>, "'linux-nvdimm@lists.01.org'" <linux-nvdimm@ml01.01.org>, "Kuehling, Felix  <Felix.Kuehling@amd.com>, 'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'dri-devel@lists.freedesktop.org'" <dri-devel@lists.freedesktop.org>, Koenig,, Ben, "Suravee  <Suravee.Suthikulpanit@amd.com>, 'linux-pci@vger.kernel.org'" <linux-pci@vger.kernel.org>, Deucher,, "Paul  <Paul.Blinzer@amd.com>, 'Linux-media@vger.kernel.org'" <Linux-media@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On 2017-01-05 08:58 PM, Jerome Glisse wrote:
> On Thu, Jan 05, 2017 at 05:30:34PM -0700, Jason Gunthorpe wrote:
>> On Thu, Jan 05, 2017 at 06:23:52PM -0500, Jerome Glisse wrote:
>>
>>>> I still don't understand what you driving at - you've said in both
>>>> cases a user VMA exists.
>>> In the former case no, there is no VMA directly but if you want one than
>>> a device can provide one. But such VMA is useless as CPU access is not
>>> expected.
>> I disagree it is useless, the VMA is going to be necessary to support
>> upcoming things like CAPI, you need it to support O_DIRECT from the
>> filesystem, DPDK, etc. This is why I am opposed to any model that is
>> not VMA based for setting up RDMA - that is shorted sighted and does
>> not seem to reflect where the industry is going.
>>
>> So focus on having VMA backed by actual physical memory that covers
>> your GPU objects and ask how do we wire up the '__user *' to the DMA
>> API in the best way so the DMA API still has enough information to
>> setup IOMMUs and whatnot.
> I am talking about 2 different thing. Existing hardware and API where you
> _do not_ have a vma and you do not need one. This is just existing stuff.
I do not understand why you assume that existing API doesn't  need one.
I would say that a lot of __existing__ user level API and their support 
in kernel
(especially outside of graphics domain) assumes that we have vma and
deal with __user * pointers.
> Some close driver provide a functionality on top of this design. Question
> is do we want to do the same ? If yes and you insist on having a vma we
> could provide one but this is does not apply and is useless for where we
> are going with new hardware.
>
> With new hardware you just use malloc or mmap to allocate memory and then
> you use it directly with the device. Device driver can migrate any part of
> the process address space to device memory. In this scheme you have your
> usual VMAs but there is nothing special about them.
Assuming that the whole device memory is CPU accessible and it looks
like the direction where we are going:
- You forgot about use case when we want or need to allocate memory
directly on device (why we need to migrate anything if not needed?).
- We may want to use CPU to access such memory on device to avoid
any unnecessary migration back.
- We may have more device memory than the system one.
E.g. if you have 12 GPUs w/64GB each it will already give us ~0.7 TB
not mentioning NVDIMM cards which could also be used as memory
storage for other device access.
- We also may want/need to share GPU memory between different
processes.
> Now when you try to do get_user_page() on any page that is inside the
> device it will fails because we do not allow any device memory to be pin.
> There is various reasons for that and they are not going away in any hw
> in the planing (so for next few years).
>
> Still we do want to support peer to peer mapping. Plan is to only do so
> with ODP capable hardware. Still we need to solve the IOMMU issue and
> it needs special handling inside the RDMA device. The way it works is
> that RDMA ask for a GPU page, GPU check if it has place inside its PCI
> bar to map this page for the device, this can fail. If it succeed then
> you need the IOMMU to let the RDMA device access the GPU PCI bar.
>
> So here we have 2 orthogonal problem. First one is how to make 2 drivers
> talks to each other to setup mapping to allow peer to peer But I would assume  and second is
> about IOMMU.
>
I think that there is the third problem:  A lot of existing user level API
(MPI, IB Verbs, file i/o, etc.) deal with pointers to the buffers.
Potentially it would be ideally to support use cases when those buffers are
located in device memory avoiding any unnecessary migration / 
double-buffering.
Currently a lot of infrastructure in kernel assumes that this is the user
pointer and call "get_user_pages"  to get s/g.   What is your opinion
how it should be changed to deal with cases when "buffer" is in
device memory?



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
