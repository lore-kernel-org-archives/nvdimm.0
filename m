Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 338B820945D98
 for <linux-nvdimm@lists.01.org>; Tue,  8 May 2018 14:26:35 -0700 (PDT)
Date: Tue, 8 May 2018 15:26:31 -0600
From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH v4 04/14] PCI/P2PDMA: Clear ACS P2P flags for all
 devices behind switches
Message-ID: <20180508152631.50fd583c@w520.home>
In-Reply-To: <a524127a-3557-3dff-971c-dfe94ba5a01c@deltatee.com>
References: <20180423233046.21476-1-logang@deltatee.com>
 <20180423233046.21476-5-logang@deltatee.com>
 <20180507231306.GG161390@bhelgaas-glaptop.roam.corp.google.com>
 <e58e8d27-42a5-ca69-3b68-c409a2922cd1@amd.com>
 <0b4183ef-e720-204b-9e85-b9eaf7a4136a@deltatee.com>
 <a943a92d-15cd-fb2d-21c3-5e5cfccd9eff@amd.com>
 <3584a6ac-95c7-5d23-1859-aee30605776e@deltatee.com>
 <20180508133407.57a46902@w520.home>
 <5fc9b1c1-9208-06cc-0ec5-1f54c2520494@deltatee.com>
 <20180508141331.7cd737cb@w520.home>
 <d70cf286-f7b7-99a5-1042-022506298fed@deltatee.com>
 <20180508144341.0441b676@w520.home>
 <a524127a-3557-3dff-971c-dfe94ba5a01c@deltatee.com>
MIME-Version: 1.0
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
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?UTF-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <helgaas@kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>, Christian =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 8 May 2018 14:49:23 -0600
Logan Gunthorpe <logang@deltatee.com> wrote:

> On 08/05/18 02:43 PM, Alex Williamson wrote:
> > Yes, GPUs seem to be leading the pack in implementing ATS.  So now the
> > dumb question, why not simply turn off the IOMMU and thus ACS?  The
> > argument of using the IOMMU for security is rather diminished if we're
> > specifically enabling devices to poke one another directly and clearly
> > this isn't favorable for device assignment either.  Are there target
> > systems where this is not a simple kernel commandline option?  Thanks,  
> 
> Well, turning off the IOMMU doesn't necessarily turn off ACS. We've run
> into some bios's that set the bits on boot (which is annoying).

But it would be a much easier proposal to disable ACS when the IOMMU is
not enabled, ACS has no real purpose in that case.

> I also don't expect people will respond well to making the IOMMU and P2P
> exclusive. The IOMMU is often used for more than just security and on
> many platforms it's enabled by default. I'd much rather allow IOMMU use
> but have fewer isolation groups in much the same way as if you had PCI
> bridges that didn't support ACS.

The IOMMU and P2P are already not exclusive, we can bounce off the
IOMMU or make use of ATS as we've previously discussed.  We were
previously talking about a build time config option that you didn't
expect distros to use, so I don't think intervention for the user to
disable the IOMMU if it's enabled by default is a serious concern
either.

What you're trying to do is enabled direct peer-to-peer for endpoints
which do not support ATS when the IOMMU is enabled, which is not
something that necessarily makes sense to me.  As I mentioned in a
previous reply, the IOMMU provides us with an I/O virtual address space
for devices, ACS is meant to fill the topology based gaps in that
virtual address space, making transactions follow IOMMU compliant
routing rules to avoid aliases between the IOVA and physical address
spaces.  But this series specifically wants to leave those gaps open
for direct P2P access.

So we compromise the P2P aspect of security, still protecting RAM, but
potentially only to the extent that a device cannot hop through or
interfere with other devices to do its bidding.  Device assignment is
mostly tossed out the window because not only are bigger groups more
difficult to deal with, the IOVA space is riddled with gaps, which is
not really a solved problem.  So that leaves avoiding bounce buffers as
the remaining IOMMU feature, but we're dealing with native express
devices and relatively high end devices that are probably installed in
modern systems, so that seems like a non-issue.

Are there other uses I'm forgetting?  We can enable interrupt remapping
separate from DMA translation, so we can exclude that one.  I'm still
not seeing why it's terribly undesirable to require devices to support
ATS if they want to do direct P2P with an IOMMU enabled.  Thanks,

Alex
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
