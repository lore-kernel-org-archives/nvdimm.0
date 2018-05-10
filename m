Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5FF6021BADAB3
 for <linux-nvdimm@lists.01.org>; Thu, 10 May 2018 07:59:51 -0700 (PDT)
Date: Thu, 10 May 2018 10:59:46 -0400
From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [PATCH v4 04/14] PCI/P2PDMA: Clear ACS P2P flags for all devices
 behind switches
Message-ID: <20180510145946.GB3652@redhat.com>
References: <d70cf286-f7b7-99a5-1042-022506298fed@deltatee.com>
 <20180508205005.GC15608@redhat.com>
 <7FFB9603-DF9F-4441-82E9-46037CB6C0DE@raithlin.com>
 <a1a36f88-fbfb-b5ee-6dcb-5c5bb96132dd@amd.com>
 <1775CC56-4651-422F-953A-18E024D3717C@raithlin.com>
 <20180509160722.GB4140@redhat.com>
 <366A8132-B88A-40F7-BDE3-DA542E45FC0C@raithlin.com>
 <20180509174952.GC4140@redhat.com>
 <405531AE-8315-4A4F-9B0C-8DBE49BFCAB4@raithlin.com>
 <73b6a454-bf84-1640-0b5e-137d03c0ad8c@amd.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <73b6a454-bf84-1640-0b5e-137d03c0ad8c@amd.com>
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
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Alex Williamson <alex.williamson@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <helgaas@kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 10, 2018 at 04:29:44PM +0200, Christian K=F6nig wrote:
> Am 10.05.2018 um 16:20 schrieb Stephen Bates:
> > Hi Jerome
> > =

> > > As it is tie to PASID this is done using IOMMU so looks for caller
> > > of amd_iommu_bind_pasid() or intel_svm_bind_mm() in GPU the existing
> > >   user is the AMD GPU driver see:
> > Ah thanks. This cleared things up for me. A quick search shows there ar=
e still no users of intel_svm_bind_mm() but I see the AMD version used in t=
hat GPU driver.
> =

> Just FYI: There is also another effort ongoing to give both the AMD, Intel
> as well as ARM IOMMUs a common interface so that drivers can use whatever
> the platform offers fro SVM support.
> =

> > One thing I could not grok from the code how the GPU driver indicates w=
hich DMA events require ATS translations and which do not. I am assuming th=
e driver implements someway of indicating that and its not just a global ON=
 or OFF for all DMAs? The reason I ask is that I looking at if NVMe was to =
support ATS what would need to be added in the NVMe spec above and beyond w=
hat we have in PCI ATS to support efficient use of ATS (for example would w=
e need a flag in the submission queue entries to indicate a particular IO's=
 SGL/PRP should undergo ATS).
> =

> Oh, well that is complicated at best.
> =

> On very old hardware it wasn't a window, but instead you had to use speci=
al
> commands in your shader which indicated that you want to use an ATS
> transaction instead of a normal PCIe transaction for your read/write/atom=
ic.
> =

> As Jerome explained on most hardware we have a window inside the internal
> GPU address space which when accessed issues a ATS transaction with a
> configurable PASID.
> =

> But on very newer hardware that window became a bit in the GPUVM page
> tables, so in theory we now can control it on a 4K granularity basis for =
the
> internal 48bit GPU address space.
> =


To complete this a 50 lines primer on GPU:

GPUVA - GPU virtual address
GPUPA - GPU physical address

GPU run programs very much like CPU program expect a program will have
many thousands of threads running concurrently. There is a hierarchy of
groups for a given program ie threads are grouped together, the lowest
hierarchy level have a group size in <=3D 64 threads on most GPUs.

Those programs (call shader for graphic program think OpenGL, Vulkan
or compute for GPGPU think OpenCL CUDA) are submited by the userspace
against a given address space. In the "old" days (couple years back
when dinausor were still roaming the earth) this address space was
specific to the GPU and each user space program could create multiple
GPU address space. All the memory operation done by the program was
against this address space. Hence all PCIE transactions are spawn from
a program + address space.

GPU use page table + window aperture (the window aperture is going away
so you can focus on page table). To translate GPU virtual address into
a physical address. The physical address can point to GPU local memory
or to system memory or to another PCIE device memory (ie some PCIE BAR).

So all PCIE transaction are spawn through this process of GPUVA to GPUPA
then GPUPA is handled by the GPU mmu unit that either spawn a PCIE
transaction for non local GPUPA or access local memory otherwise.


So per say the kernel driver does not configure which transaction is
using ATS or peer to peer. Userspace program create a GPU virtual address
space and bind object into it. This object can be system memory or some
other PCIE device memory in which case we would to do a peer to peer.


So you won't find any logic in the kernel. What you find is creating
virtual address space and binding object.


Above i talk about the old days, nowadays we want the GPU virtual address
space to be exactly the same as the CPU virtual address space as the
process which initiate the GPU program is using. This is where we use the
PASID and ATS. So here userspace create a special "GPU context" that says
that the GPU virtual address space will be the same as the program that
create the GPU context. A process ID is then allocated and the mm_struct
is bind to this process ID in the IOMMU driver. Then all program executed
on the GPU use the process ID to identify the address space against which
they are running.


All of the above i did not talk about DMA engine which are on the "side"
of the GPU to copy memory around. GPU have multiple DMA engines with
different capabilities, some of those DMA engine use the same GPU address
space as describe above, other use directly GPUPA.


Hopes this helps understanding the big picture. I over simplify thing and
devils is in the details.

Cheers,
J=E9r=F4me
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
