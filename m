Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Thu, 5 Jan 2017 13:39:29 -0500
From: Jerome Glisse <j.glisse@gmail.com>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Message-ID: <20170105183927.GA5324@gmail.com>
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'linux-rdma@vger.kernel.org'" <linux-rdma@vger.kernel.org>, "'linux-nvdimm@lists.01.org'" <linux-nvdimm@lists.01.org>, "'Linux-media@vger.kernel.org'" <Linux-media@vger.kernel.org>, "'dri-devel@lists.freedesktop.org'" <dri-devel@lists.freedesktop.org>, "'linux-pci@vger.kernel.org'" <linux-pci@vger.kernel.org>, "Kuehling, Felix" <Felix.Kuehling@amd.com>, "Sagalovitch, Serguei" <Serguei.Sagalovitch@amd.com>, "Blinzer, Paul" <Paul.Blinzer@amd.com>, "Koenig, Christian" <Christian.Koenig@amd.com>, "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>, "Sander, Ben" <ben.sander@amd.com>, hch@infradead.org, jgunthorpe@obsidianresearch.com, david1.zhou@amd.com, qiang.yu@amd.com
List-ID: <linux-nvdimm@lists.01.org>

Sorry to revive this thread but it fells through my filters and i
miss it. I have been going through it and i think the discussion
has been hinder by the fact that distinct problems were merge while
they should be address separately.

First for peer-to-peer we need to be clear on how this happens. Two
cases here :
  1) peer-to-peer because of userspace specific API like NVidia GPU
    direct (AMD is pushing its own similar API i just can't remember
    marketing name). This does not happen through a vma, this happens
    through specific device driver call going through device specific
    ioctl on both side (GPU and RDMA). So both kernel driver are aware
    of each others.
  2) peer-to-peer because RDMA/device is trying to access a regular
    vma (ie non special either private anonymous or share memory or
    mmap of a regular file not a device file).

For 1) there is no need to over complicate thing. Device driver must
have a back-channel between them and must be able to invalidate their
respective mapping (ie GPU must be able to ask RDMA device to kill/
stop its MR).

So remaining issue for 1) is how to enable effective peer-to-peer
mapping given that it might not work reliably on all platform. Here
Alex was listing existing proposal:
  A P2P DMA DMA-API/PCI map_peer_resource support for peer-to-peer
    http://www.spinics.net/lists/linux-pci/msg44560.html
  B ZONE_DEVICE IO irect I/O and DMA for persistent memory
    https://lwn.net/Articles/672457/
  C DMA-BUF RDMA subsystem DMA-BUF support
    http://www.spinics.net/lists/linux-rdma/msg38748.html
  D iopmem iopmem : A block device for PCIe memory
    https://lwn.net/Articles/703895/
  E HMM (not interesting for case 1)
  F Something new

Of the above D is ill suited for for GPU as we do not want to pin
GPU memory and D is design with long live object that do not move.
Also i do not think that exposing device PCIe bar through a new
/dev/somefilename is a good idea for GPU. So i think this should
be discarded.

HMM should be discard in respect of case 1 too. It is useful for
case 2. I don't think dma-buf is the right path either.

So we i think there is only A and B that make sense. Now for use
case 1 i think A is the best solution. No need to have struct page
and it require explicit knowlegde for device driver that it is
mapping another device memory which is a given in usecase 1.


If we look at case 2 the situation is bit more complex. Here RDMA
is just trying to access a regular VMA but it might happens that
some memory inside that VMA reside inside a device memory. When
that happens we would like to avoid to move that memory back to
system memory assuming that a peer mapping is doable.

Usecase 2 assume that the GPU is either on platform with CAPI or
CCTX (or something similar) in which case it is easy as device
memory will have struct page and is always accessible by CPU and
transparent from device to device access (AFAICT).

So we left with platform that do not have proper support for
device memory (ie CPU can not access it the same as DDR or as
limited access). Which apply to x86 for the foreseeable future.

This is the problem HMM address, allowing to transparently use
device memory inside a process even if direct CPU access are not
permited. I have plan to support peer-to-peer with HMM because
it is an important usecase. The idea is to have the device driver
fault against ZONE_DEVICE page and communicate through common API
to establish mapping. HMM will only handle keeping track of device
to device mapping and allowing to invalidate such mapping at any
time to allow memory to be migrated.

I do not intend to solve the IOMMU side of the problem or even
the PCI hierarchy issue where you can't peer-to-peer between device
accross some PCI bridge. I believe this is an orthogonal problem
and that it is best solve inside the DMA API ie with solution A.


I do not think we should try to solve all the problems with a
common solutions. They are too disparate from capabilities (what
the hardware can and can't do).

>From my point of view there is few take aways:
  - device should only access regular vma
  - device should never try to access vma that point to another
    device (mmap of any file in /dev)
  - peer to peer access through dedicated userspace API must
    involve dedicated API between kernel driver taking part into
    the peer to peer access
  - peer to peer of regular vma must involve a common API for
    drivers to interact so no driver can block the other


So i think the DMA-API proposal is the one to pursue and others
problem relating to handling GPU memory and how to use it is a
different kind of problem. One with either an hardware solution
(CAPI, CCTX, ...) or a software solution (HMM so far).

I don't think we should conflict the 2 problems into one. Anyway
i think this should be something worth discussing face to face
with interested party to flesh out a solution (can be at LSF/MM
or in another forum).

Cheers,
J�r�me
