Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Thu, 5 Jan 2017 14:54:24 -0500
From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Message-ID: <20170105195424.GB2166@redhat.com>
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
 <20170105183927.GA5324@gmail.com>
 <20170105190113.GA12587@obsidianresearch.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170105190113.GA12587@obsidianresearch.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: david1.zhou@amd.com, qiang.yu@amd.com, "'linux-rdma@vger.kernel.org'" <linux-rdma@vger.kernel.org>, "'linux-nvdimm@lists.01.org'" <linux-nvdimm@ml01.01.org>, Kuehling,, "Serguei  <Serguei.Sagalovitch@amd.com>, 'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'dri-devel@lists.freedesktop.org'" <dri-devel@lists.freedesktop.org>, Koenig,, Alexander, "Ben  <ben.sander@amd.com>, Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>, "'linux-pci@vger.kernel.org'" <linux-pci@vger.kernel.org>, Jerome Glisse <j.glisse@gmail.com>, "Blinzer, Paul" <Paul.Blinzer@amd.com>, "'Linux-media@vger.kernel.org'" <Linux-media@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jan 05, 2017 at 12:01:13PM -0700, Jason Gunthorpe wrote:
> On Thu, Jan 05, 2017 at 01:39:29PM -0500, Jerome Glisse wrote:
> =

> >   1) peer-to-peer because of userspace specific API like NVidia GPU
> >     direct (AMD is pushing its own similar API i just can't remember
> >     marketing name). This does not happen through a vma, this happens
> >     through specific device driver call going through device specific
> >     ioctl on both side (GPU and RDMA). So both kernel driver are aware
> >     of each others.
> =

> Today you can only do user-initiated RDMA operations in conjection
> with a VMA.
> =

> We'd need a really big and strong reason to create an entirely new
> non-VMA based memory handle scheme for RDMA.
> =

> So my inclination is to just completely push back on this idea. You
> need a VMA to do RMA.
> =

> GPUs need to create VMAs for the memory they want to RDMA from, even
> if the VMA handle just causes SIGBUS for any CPU access.

Mellanox and NVidia support peer to peer with what they market a
GPUDirect. It only works without IOMMU. It is probably not upstream :

https://www.mail-archive.com/linux-rdma@vger.kernel.org/msg21402.html

I thought it was but it seems it require an out of tree driver to work.

Wether there is a vma or not isn't important to the issue anyway. If
you want to enforce VMA rule for RDMA it is an RDMA specific discussion
in which i don't want to be involve, it is not my turf :)

What matter is the back channel API between peer-to-peer device. Like
the above patchset points out for GPU we need to be able to invalidate
a mapping at any point in time. Pining is not something we want to
live with.

So the VMA consideration does not change what i was saying there is
2 cases:
  1) device vma (might be restricted to specific userspace API)
  2) regular vma (!VM_MIXED and no special pte entry)

For 1) you need back channel it can be per device driver or we can agree
to some common API that can add to vm_operations_struct.

For 2) expectation is that you will have valid struct page but you still
need special handling at the dma API level.

In 1) the peer-to-peer mapping is track at vma level and mediated there.
For 2) it is per page and it is mediated at that level.

In both case on you have setup mapping you need to handle the IOMMU and
the PCI bridge restriction that might apply and i believe that the DMA
API is the place where we want to solve that second side of the problem.

Cheers,
J=E9r=F4me
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
