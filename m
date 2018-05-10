Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 702292096AEF0
 for <linux-nvdimm@lists.01.org>; Thu, 10 May 2018 07:41:42 -0700 (PDT)
Date: Thu, 10 May 2018 10:41:37 -0400
From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [PATCH v4 04/14] PCI/P2PDMA: Clear ACS P2P flags for all devices
 behind switches
Message-ID: <20180510144137.GA3652@redhat.com>
References: <20180508133407.57a46902@w520.home>
 <5fc9b1c1-9208-06cc-0ec5-1f54c2520494@deltatee.com>
 <20180508141331.7cd737cb@w520.home>
 <d70cf286-f7b7-99a5-1042-022506298fed@deltatee.com>
 <20180508205005.GC15608@redhat.com>
 <7FFB9603-DF9F-4441-82E9-46037CB6C0DE@raithlin.com>
 <a1a36f88-fbfb-b5ee-6dcb-5c5bb96132dd@amd.com>
 <4e0d0b96-ab02-2662-adf3-fa956efd294c@deltatee.com>
 <2fc61d29-9eb4-d168-a3e5-955c36e5d821@amd.com>
 <94C8FE12-7FC3-48BD-9DCA-E6A427E71810@raithlin.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <94C8FE12-7FC3-48BD-9DCA-E6A427E71810@raithlin.com>
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
To: Stephen Bates <sbates@raithlin.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Christoph Hellwig <hch@lst.de>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Alex Williamson <alex.williamson@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <helgaas@kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 10, 2018 at 02:16:25PM +0000, Stephen  Bates wrote:
> Hi Christian
> =

> > Why would a switch not identify that as a peer address? We use the PASI=
D =

> >    together with ATS to identify the address space which a transaction =

> >    should use.
> =

> I think you are conflating two types of TLPs here. If the device supports=
 ATS then it will issue a TR TLP to obtain a translated address from the IO=
MMU. This TR TLP will be addressed to the RP and so regardless of ACS it is=
 going up to the Root Port. When it gets the response it gets the physical =
address and can use that with the TA bit set for the p2pdma. In the case of=
 ATS support we also have more control over ACS as we can disable it just f=
or TA addresses (as per 7.7.7.7.2 of the spec).
>     =

>  >   If I'm not completely mistaken when you disable ACS it is perfectly =

>  >   possible that a bridge identifies a transaction as belonging to a pe=
er =

>  >   address, which isn't what we want here.
>    =

> You are right here and I think this illustrates a problem for using the I=
OMMU at all when P2PDMA devices do not support ATS. Let me explain:
> =

> If we want to do a P2PDMA and the DMA device does not support ATS then I =
think we have to disable the IOMMU (something Mike suggested earlier). The =
reason is that since ATS is not an option the EP must initiate the DMA usin=
g the addresses passed down to it. If the IOMMU is on then this is an IOVA =
that could (with some non-zero probability) point to an IO Memory address i=
n the same PCI domain. So if we disable ACS we are in trouble as we might M=
emWr to the wrong place but if we enable ACS we lose much of the benefit of=
 P2PDMA. Disabling the IOMMU removes the IOVA risk and ironically also reso=
lves the IOMMU grouping issues.
> =

> So I think if we want to support performant P2PDMA for devices that don't=
 have ATS (and no NVMe SSDs today support ATS) then we have to disable the =
IOMMU. I know this is problematic for AMDs use case so perhaps we also need=
 to consider a mode for P2PDMA for devices that DO support ATS where we can=
 enable the IOMMU (but in this case EPs without ATS cannot participate as P=
2PDMA DMA iniators).
> =

> Make sense?
> =


Note on GPU we do would not rely on ATS for peer to peer. Some part
of the GPU (DMA engines) do not necessarily support ATS. Yet those
are the part likely to be use in peer to peer.

However here this is a distinction in objective that i believe is lost.
We (ake GPU people aka the good guys ;)) do no want to do peer to peer
for performance reasons ie we do not care having our transaction going
to the root complex and back down the destination. At least in use case
i am working on this is fine.

Reasons is that GPU are giving up on PCIe (see all specialize link like
NVlink that are popping up in GPU space). So for fast GPU inter-connect
we have this new links. Yet for legacy and inter-operability we would
like to do peer to peer with other devices like RDMA ... going through
the root complex would be fine from performance point of view. Worst
case is that it is slower than existing design where system memory is
use as bounce buffer.

Also the IOMMU isolation do matter a lot to us. Think someone using this
peer to peer to gain control of a server in the cloud.

Cheers,
J=E9r=F4me
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
