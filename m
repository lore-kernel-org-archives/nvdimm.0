Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Thu, 5 Jan 2017 12:01:13 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Message-ID: <20170105190113.GA12587@obsidianresearch.com>
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
 <20170105183927.GA5324@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170105183927.GA5324@gmail.com>
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
To: Jerome Glisse <j.glisse@gmail.com>
Cc: david1.zhou@amd.com, "'linux-rdma@vger.kernel.org'" <linux-rdma@vger.kernel.org>, "'linux-nvdimm@lists.01.org'" <linux-nvdimm@ml01.01.org>, Kuehling,, "Serguei  <Serguei.Sagalovitch@amd.com>, 'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'dri-devel@lists.freedesktop.org'" <dri-devel@lists.freedesktop.org>, "Koenig, Christian  <Christian.Koenig@amd.com>, hch@infradead.org, qiang.yu@amd.com, Sander, Ben" <ben.sander@amd.com>, "Suthikulpanit, Suravee  <Suravee.Suthikulpanit@amd.com>, 'linux-pci@vger.kernel.org'" <linux-pci@vger.kernel.org>, Deucher,, "Paul  <Paul.Blinzer@amd.com>, 'Linux-media@vger.kernel.org'" <Linux-media@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jan 05, 2017 at 01:39:29PM -0500, Jerome Glisse wrote:

>   1) peer-to-peer because of userspace specific API like NVidia GPU
>     direct (AMD is pushing its own similar API i just can't remember
>     marketing name). This does not happen through a vma, this happens
>     through specific device driver call going through device specific
>     ioctl on both side (GPU and RDMA). So both kernel driver are aware
>     of each others.

Today you can only do user-initiated RDMA operations in conjection
with a VMA.

We'd need a really big and strong reason to create an entirely new
non-VMA based memory handle scheme for RDMA.

So my inclination is to just completely push back on this idea. You
need a VMA to do RMA.

GPUs need to create VMAs for the memory they want to RDMA from, even
if the VMA handle just causes SIGBUS for any CPU access.

Jason
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
