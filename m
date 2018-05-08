Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2ECC5203BEA4A
 for <linux-nvdimm@lists.01.org>; Tue,  8 May 2018 12:46:13 -0700 (PDT)
References: <20180423233046.21476-1-logang@deltatee.com>
 <20180423233046.21476-5-logang@deltatee.com>
 <20180507231306.GG161390@bhelgaas-glaptop.roam.corp.google.com>
 <e58e8d27-42a5-ca69-3b68-c409a2922cd1@amd.com>
 <0b4183ef-e720-204b-9e85-b9eaf7a4136a@deltatee.com>
 <a943a92d-15cd-fb2d-21c3-5e5cfccd9eff@amd.com>
 <3584a6ac-95c7-5d23-1859-aee30605776e@deltatee.com>
 <20180508133407.57a46902@w520.home>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <5fc9b1c1-9208-06cc-0ec5-1f54c2520494@deltatee.com>
Date: Tue, 8 May 2018 13:45:50 -0600
MIME-Version: 1.0
In-Reply-To: <20180508133407.57a46902@w520.home>
Content-Language: en-US
Subject: Re: [PATCH v4 04/14] PCI/P2PDMA: Clear ACS P2P flags for all devices
 behind switches
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
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <helgaas@kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
List-ID: <linux-nvdimm@lists.01.org>



On 08/05/18 01:34 PM, Alex Williamson wrote:
> They are not so unrelated, see the ACS Direct Translated P2P
> capability, which in fact must be implemented by switch downstream
> ports implementing ACS and works specifically with ATS.  This appears to
> be the way the PCI SIG would intend for P2P to occur within an IOMMU
> managed topology, routing pre-translated DMA directly between peer
> devices while requiring non-translated requests to bounce through the
> IOMMU.  Really, what's the value of having an I/O virtual address space
> provided by an IOMMU if we're going to allow physical DMA between
> downstream devices, couldn't we just turn off the IOMMU altogether?  Of
> course ATS is not without holes itself, basically that we trust the
> endpoint's implementation of ATS implicitly.  Thanks,

I agree that this is what the SIG intends, but I don't think hardware
fully supports this methodology yet. The Direct Translated capability
just requires switches to forward packets that have the AT request type
set. It does not require them to do the translation or to support ATS
such that P2P requests can be translated by the IOMMU. I expect this is
so that an downstream device can implement ATS and not get messed up by
an upstream switch that doesn't support it.

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
