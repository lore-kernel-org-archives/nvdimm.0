Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Thu, 5 Jan 2017 15:19:36 -0500
From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Message-ID: <20170105201935.GC2166@redhat.com>
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
 <20170105183927.GA5324@gmail.com>
 <20170105190113.GA12587@obsidianresearch.com>
 <20170105195424.GB2166@redhat.com>
 <20170105200719.GB31047@obsidianresearch.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170105200719.GB31047@obsidianresearch.com>
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

On Thu, Jan 05, 2017 at 01:07:19PM -0700, Jason Gunthorpe wrote:
> On Thu, Jan 05, 2017 at 02:54:24PM -0500, Jerome Glisse wrote:
> =

> > Mellanox and NVidia support peer to peer with what they market a
> > GPUDirect. It only works without IOMMU. It is probably not upstream :
> > =

> > https://www.mail-archive.com/linux-rdma@vger.kernel.org/msg21402.html
> > =

> > I thought it was but it seems it require an out of tree driver to work.
> =

> Right, it is out of tree and not under consideration for mainline.
> =

> > Wether there is a vma or not isn't important to the issue anyway. If
> > you want to enforce VMA rule for RDMA it is an RDMA specific discussion
> > in which i don't want to be involve, it is not my turf :)
> =

> Always having a VMA changes the discussion - the question is how to
> create a VMA that reprensents IO device memory, and how do DMA
> consumers extract the correct information from that VMA to pass to the
> kernel DMA API so it can setup peer-peer DMA.

Well my point is that it can't be. In HMM case inside a single VMA you
can have one page inside GPU memory at address A but next page inside
regular memory at A+4k. So handling this at the VMA level does not make
sense. So in this case you would get the device from the struct page
and you would query through common API to determine if you can do peer
to peer. If not it would trigger migration back to regular memory.
If yes then you still have to solve the IOMMU issue and hence the DMA
API changes that were propose.

In the GPUDirect case the idea is that you have a specific device vma
that you map for peer to peer. Here thing can be at vma level and not at
a page level. Expectation here is that the GPU userspace expose a special
API to allow RDMA to directly happen on GPU object allocated through
GPU specific API (ie it is not regular memory and it is not accessible
by CPU).


Both case are disjoint. Both case need to solve the IOMMU issue which
seems to be best solve at the DMA API level.


> > What matter is the back channel API between peer-to-peer device. Like
> > the above patchset points out for GPU we need to be able to invalidate
> > a mapping at any point in time. Pining is not something we want to
> > live with.
> =

> We have MMU notifiers to handle this today in RDMA. Async RDMA MR
> Invalidate like you see in the above out of tree patches is totally
> crazy and shouldn't be in mainline. Use ODP capable RDMA hardware.

Well there is still a large base of hardware that do not have such
feature and some people would like to be able to keep using those.
I believe allowing direct access to GPU object that are otherwise
hidden from regular kernel memory management is still meaningfull.

Cheers,
J=E9r=F4me

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
