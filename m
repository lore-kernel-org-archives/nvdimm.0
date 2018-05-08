Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from CAN01-QB1-obe.outbound.protection.outlook.com
 (mail-eopbgr660120.outbound.protection.outlook.com [40.107.66.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2639420945DAD
 for <linux-nvdimm@lists.01.org>; Tue,  8 May 2018 14:42:30 -0700 (PDT)
From: "Stephen  Bates" <sbates@raithlin.com>
Subject: Re: [PATCH v4 04/14] PCI/P2PDMA: Clear ACS P2P flags for all devices
 behind switches
Date: Tue, 8 May 2018 21:42:27 +0000
Message-ID: <354F7407-0DC7-470C-B9AA-74FDF9C46B08@raithlin.com>
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
 <20180508152631.50fd583c@w520.home>
In-Reply-To: <20180508152631.50fd583c@w520.home>
Content-Language: en-US
Content-ID: <ED737D195D26F846959455EA0A690DCD@CANPRD01.PROD.OUTLOOK.COM>
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
To: Alex Williamson <alex.williamson@redhat.com>, Logan Gunthorpe <logang@deltatee.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Christoph Hellwig <hch@lst.de>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, =?utf-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <helgaas@kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, =?utf-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>
List-ID: <linux-nvdimm@lists.01.org>

Hi Alex

>    But it would be a much easier proposal to disable ACS when the IOMMU is
>    not enabled, ACS has no real purpose in that case.

I guess one issue I have with this is that it disables IOMMU groups for all Root Ports and not just the one(s) we wish to do p2pdma on. 
    
>    The IOMMU and P2P are already not exclusive, we can bounce off the
>    IOMMU or make use of ATS as we've previously discussed.  We were
>    previously talking about a build time config option that you didn't
>    expect distros to use, so I don't think intervention for the user to
>    disable the IOMMU if it's enabled by default is a serious concern
>    either.

ATS definitely makes things more interesting for the cases where the EPs support it. However I don't really have a handle on how common ATS support is going to be in the kinds of devices we have been focused on (NVMe SSDs and RDMA NICs mostly). 
    
> What you're trying to do is enabled direct peer-to-peer for endpoints
>  which do not support ATS when the IOMMU is enabled, which is not
>  something that necessarily makes sense to me. 

As above the advantage of leaving the IOMMU on is that it allows for both p2pdma PCI domains and IOMMU groupings PCI domains in the same system. It is just that these domains will be separate to each other.

>  So that leaves avoiding bounce buffers as the remaining IOMMU feature

I agree with you here that the devices we will want to use for p2p will probably not require a bounce buffer and will support 64 bit DMA addressing.
    
> I'm still not seeing why it's terribly undesirable to require devices to support
> ATS if they want to do direct P2P with an IOMMU enabled.

I think the one reason is for the use-case above. Allowing IOMMU groupings on one domain and p2pdma on another domain....
    
Stephen
    

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
