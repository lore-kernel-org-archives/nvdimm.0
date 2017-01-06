Return-Path: <linux-nvdimm-bounces@lists.01.org>
MIME-Version: 1.0
In-Reply-To: <20170105190113.GA12587@obsidianresearch.com>
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
 <20170105183927.GA5324@gmail.com>
 <20170105190113.GA12587@obsidianresearch.com>
From: Henrique Almeida <hdante.lnls@gmail.com>
Date: Fri, 6 Jan 2017 12:08:22 -0300
Message-ID: <CAP_Z8cn=O5-6A=udgOj6Rd_9_phR1K+aJ0ELXG7pZ5QEyhS3TQ@mail.gmail.com>
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
Cc: david1.zhou@amd.com, qiang.yu@amd.com, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Kuehling,, "Serguei  <Serguei.Sagalovitch@amd.com>, linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, Koenig,, Alexander, "Ben  <ben.sander@amd.com>, Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Jerome Glisse <j.glisse@gmail.com>, "Blinzer, Paul" <Paul.Blinzer@amd.com>, "Linux-media@vger.kernel.org" <Linux-media@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

 Hello, I've been watching this thread not as a kernel developer, but
as an user interested in doing peer-to-peer access between network
card and GPU. I believe that merging raw direct access with vma
overcomplicates things for our use case. We'll have a very large
camera streaming data at high throughput (up to 100 Gbps) to the GPU,
which will operate in soft real time mode and write back the results
to a RDMA enabled network storage. The CPU will only arrange the
connection between GPU and network card. Having things like paging or
memory overcommit is possible, but they are not required and they
might consistently decrease the quality of the data acquisition.

 I see my use case something likely to exist for others and a strong
reason to split the implementation in two.


2017-01-05 16:01 GMT-03:00 Jason Gunthorpe <jgunthorpe@obsidianresearch.com>:
> On Thu, Jan 05, 2017 at 01:39:29PM -0500, Jerome Glisse wrote:
>
>>   1) peer-to-peer because of userspace specific API like NVidia GPU
>>     direct (AMD is pushing its own similar API i just can't remember
>>     marketing name). This does not happen through a vma, this happens
>>     through specific device driver call going through device specific
>>     ioctl on both side (GPU and RDMA). So both kernel driver are aware
>>     of each others.
>
> Today you can only do user-initiated RDMA operations in conjection
> with a VMA.
>
> We'd need a really big and strong reason to create an entirely new
> non-VMA based memory handle scheme for RDMA.
>
> So my inclination is to just completely push back on this idea. You
> need a VMA to do RMA.
>
> GPUs need to create VMAs for the memory they want to RDMA from, even
> if the VMA handle just causes SIGBUS for any CPU access.
>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
