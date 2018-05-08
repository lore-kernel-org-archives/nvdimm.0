Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 297FF207E36C2
 for <linux-nvdimm@lists.01.org>; Tue,  8 May 2018 13:50:13 -0700 (PDT)
Date: Tue, 8 May 2018 16:50:06 -0400
From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [PATCH v4 04/14] PCI/P2PDMA: Clear ACS P2P flags for all devices
 behind switches
Message-ID: <20180508205005.GC15608@redhat.com>
References: <20180423233046.21476-5-logang@deltatee.com>
 <20180507231306.GG161390@bhelgaas-glaptop.roam.corp.google.com>
 <e58e8d27-42a5-ca69-3b68-c409a2922cd1@amd.com>
 <0b4183ef-e720-204b-9e85-b9eaf7a4136a@deltatee.com>
 <a943a92d-15cd-fb2d-21c3-5e5cfccd9eff@amd.com>
 <3584a6ac-95c7-5d23-1859-aee30605776e@deltatee.com>
 <20180508133407.57a46902@w520.home>
 <5fc9b1c1-9208-06cc-0ec5-1f54c2520494@deltatee.com>
 <20180508141331.7cd737cb@w520.home>
 <d70cf286-f7b7-99a5-1042-022506298fed@deltatee.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <d70cf286-f7b7-99a5-1042-022506298fed@deltatee.com>
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
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <helgaas@kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, May 08, 2018 at 02:19:05PM -0600, Logan Gunthorpe wrote:
> =

> =

> On 08/05/18 02:13 PM, Alex Williamson wrote:
> > Well, I'm a bit confused, this patch series is specifically disabling
> > ACS on switches, but per the spec downstream switch ports implementing
> > ACS MUST implement direct translated P2P.  So it seems the only
> > potential gap here is the endpoint, which must support ATS or else
> > there's nothing for direct translated P2P to do.  The switch port plays
> > no part in the actual translation of the request, ATS on the endpoint
> > has already cached the translation and is now attempting to use it.
> > For the switch port, this only becomes a routing decision, the request
> > is already translated, therefore ACS RR and EC can be ignored to
> > perform "normal" (direct) routing, as if ACS were not present.  It would
> > be a shame to go to all the trouble of creating this no-ACS mode to find
> > out the target hardware supports ATS and should have simply used it, or
> > we should have disabled the IOMMU altogether, which leaves ACS disabled.
> =

> Ah, ok, I didn't think it was the endpoint that had to implement ATS.
> But in that case, for our application, we need NVMe cards and RDMA NICs
> to all have ATS support and I expect that is just as unlikely. At least
> none of the endpoints on my system support it. Maybe only certain GPUs
> have this support.

I think there is confusion here, Alex properly explained the scheme
PCIE-device do a ATS request to the IOMMU which returns a valid
translation for a virtual address. Device can then use that address
directly without going through IOMMU for translation.

ATS is implemented by the IOMMU not by the device (well device implement
the client side of it). Also ATS is meaningless without something like
PASID as far as i know.

Cheers,
J=E9r=F4me
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
