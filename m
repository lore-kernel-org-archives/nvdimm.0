Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from CAN01-TO1-obe.outbound.protection.outlook.com
 (mail-eopbgr670139.outbound.protection.outlook.com [40.107.67.139])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BF55B2228352E
 for <linux-nvdimm@lists.01.org>; Wed, 14 Mar 2018 12:28:31 -0700 (PDT)
From: "Stephen  Bates" <sbates@raithlin.com>
Subject: Re: [PATCH v3 01/11] PCI/P2PDMA: Support peer-to-peer memory
Date: Wed, 14 Mar 2018 19:34:53 +0000
Message-ID: <AA646409-BB63-4757-A250-CE7118D4D3B8@raithlin.com>
References: <a0af83f8-2cbc-862b-6f8b-231991527cfc@deltatee.com>
 <3ea80992-a0fc-08f2-d93d-ae0ec4e3f4ce@codeaurora.org>
 <4eb6850c-df1b-fd44-3ee0-d43a50270b53@deltatee.com>
 <757fca36-dee4-e070-669e-f2788bd78e41@codeaurora.org>
 <4f761f55-4e9a-dccb-d12f-c59d2cd689db@deltatee.com>
 <BB94077B-7EB3-49C4-862D-BF77D0A692CC@raithlin.com>
 <20180313230850.GA45763@bhelgaas-glaptop.roam.corp.google.com>
 <8de5d3dd-a78f-02d5-0eea-4365364143b6@deltatee.com>
 <20180314025639.GA50067@bhelgaas-glaptop.roam.corp.google.com>
 <112493af-ccd0-455b-6600-b50764f7ab7e@deltatee.com>
 <20180314185159.GD179719@bhelgaas-glaptop.roam.corp.google.com>
 <b75e83ad-bb83-1f8d-1751-0989cc2493f1@deltatee.com>
 <CAPcyv4g-A6fqdTahxX=aONSCgp1eEvBb=ZVMzbZUWUDmqBbj7Q@mail.gmail.com>
In-Reply-To: <CAPcyv4g-A6fqdTahxX=aONSCgp1eEvBb=ZVMzbZUWUDmqBbj7Q@mail.gmail.com>
Content-Language: en-US
Content-ID: <550690715E85424587140925CC90F10E@CANPRD01.PROD.OUTLOOK.COM>
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
To: Dan Williams <dan.j.williams@intel.com>, Logan Gunthorpe <logang@deltatee.com>
Cc: Jens Axboe <axboe@kernel.dk>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Alex Williamson <alex.williamson@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Sinan Kaya <okaya@codeaurora.org>, =?utf-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <helgaas@kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Keith Busch <keith.busch@intel.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

> P2P over PCI/PCI-X is quite common in devices like raid controllers.

Hi Dan 

Do you mean between PCIe devices below the RAID controller? Isn't it pretty novel to be able to support PCIe EPs below a RAID controller (as opposed to SCSI based devices)?

> It would be useful if those configurations were not left behind so
> that Linux could feasibly deploy offload code to a controller in the
> PCI domain.
   
Agreed. I think this would be great. Kind of like the XCOPY framework that was proposed a while back for SCSI devices [1] but updated to also include NVMe devices. That is definitely a use case we would like this framework to support.

Stephen
 
[1] https://lwn.net/Articles/592094/

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
