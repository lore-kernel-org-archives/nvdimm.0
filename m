Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from CAN01-TO1-obe.outbound.protection.outlook.com
 (mail-eopbgr670095.outbound.protection.outlook.com [40.107.67.95])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4F3DC20348634
 for <linux-nvdimm@lists.01.org>; Thu, 10 May 2018 07:16:26 -0700 (PDT)
From: "Stephen  Bates" <sbates@raithlin.com>
Subject: Re: [PATCH v4 04/14] PCI/P2PDMA: Clear ACS P2P flags for all devices
 behind switches
Date: Thu, 10 May 2018 14:16:25 +0000
Message-ID: <94C8FE12-7FC3-48BD-9DCA-E6A427E71810@raithlin.com>
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
 <20180508205005.GC15608@redhat.com>
 <7FFB9603-DF9F-4441-82E9-46037CB6C0DE@raithlin.com>
 <a1a36f88-fbfb-b5ee-6dcb-5c5bb96132dd@amd.com>
 <4e0d0b96-ab02-2662-adf3-fa956efd294c@deltatee.com>
 <2fc61d29-9eb4-d168-a3e5-955c36e5d821@amd.com>
In-Reply-To: <2fc61d29-9eb4-d168-a3e5-955c36e5d821@amd.com>
Content-Language: en-US
Content-ID: <4858772BB9243E4A80EF7F3CBE813FD7@CANPRD01.PROD.OUTLOOK.COM>
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
To: =?utf-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>, Logan
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Alex Williamson <alex.williamson@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <helgaas@kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Hi Christian

> Why would a switch not identify that as a peer address? We use the PASID 
>    together with ATS to identify the address space which a transaction 
>    should use.

I think you are conflating two types of TLPs here. If the device supports ATS then it will issue a TR TLP to obtain a translated address from the IOMMU. This TR TLP will be addressed to the RP and so regardless of ACS it is going up to the Root Port. When it gets the response it gets the physical address and can use that with the TA bit set for the p2pdma. In the case of ATS support we also have more control over ACS as we can disable it just for TA addresses (as per 7.7.7.7.2 of the spec).
    
 >   If I'm not completely mistaken when you disable ACS it is perfectly 
 >   possible that a bridge identifies a transaction as belonging to a peer 
 >   address, which isn't what we want here.
   
You are right here and I think this illustrates a problem for using the IOMMU at all when P2PDMA devices do not support ATS. Let me explain:

If we want to do a P2PDMA and the DMA device does not support ATS then I think we have to disable the IOMMU (something Mike suggested earlier). The reason is that since ATS is not an option the EP must initiate the DMA using the addresses passed down to it. If the IOMMU is on then this is an IOVA that could (with some non-zero probability) point to an IO Memory address in the same PCI domain. So if we disable ACS we are in trouble as we might MemWr to the wrong place but if we enable ACS we lose much of the benefit of P2PDMA. Disabling the IOMMU removes the IOVA risk and ironically also resolves the IOMMU grouping issues.

So I think if we want to support performant P2PDMA for devices that don't have ATS (and no NVMe SSDs today support ATS) then we have to disable the IOMMU. I know this is problematic for AMDs use case so perhaps we also need to consider a mode for P2PDMA for devices that DO support ATS where we can enable the IOMMU (but in this case EPs without ATS cannot participate as P2PDMA DMA iniators).

Make sense?

Stephen
 
    
    

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
