Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from CAN01-QB1-obe.outbound.protection.outlook.com
 (mail-eopbgr660129.outbound.protection.outlook.com [40.107.66.129])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 157CA220C2A42
 for <linux-nvdimm@lists.01.org>; Thu, 22 Mar 2018 15:51:02 -0700 (PDT)
From: "Stephen  Bates" <sbates@raithlin.com>
Subject: Re: [PATCH v3 01/11] PCI/P2PDMA: Support peer-to-peer memory
Date: Thu, 22 Mar 2018 22:57:32 +0000
Message-ID: <C90AA66C-FFC6-4CCA-B959-7BBECA65509C@raithlin.com>
References: <24d8e5c2-065d-8bde-3f5d-7f158be9c578@deltatee.com>
 <52cbbbc4-c488-f83f-8d02-14d455b4efd7@codeaurora.org>
 <3e738f95-d73c-4182-2fa1-8664aafb1ab7@deltatee.com>
 <703aa92c-0c1c-4852-5887-6f6e6ccde0fb@codeaurora.org>
 <a0af83f8-2cbc-862b-6f8b-231991527cfc@deltatee.com>
 <3ea80992-a0fc-08f2-d93d-ae0ec4e3f4ce@codeaurora.org>
 <4eb6850c-df1b-fd44-3ee0-d43a50270b53@deltatee.com>
 <757fca36-dee4-e070-669e-f2788bd78e41@codeaurora.org>
 <4f761f55-4e9a-dccb-d12f-c59d2cd689db@deltatee.com>
 <BB94077B-7EB3-49C4-862D-BF77D0A692CC@raithlin.com>
 <20180313230850.GA45763@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20180313230850.GA45763@bhelgaas-glaptop.roam.corp.google.com>
Content-Language: en-US
Content-ID: <C230FA4F71874149A1702A62C570C193@CANPRD01.PROD.OUTLOOK.COM>
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
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Alex Williamson <alex.williamson@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Sinan Kaya <okaya@codeaurora.org>, =?utf-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Keith Busch <keith.busch@intel.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

>  I've seen the response that peers directly below a Root Port could not
> DMA to each other through the Root Port because of the "route to self"
> issue, and I'm not disputing that.  

Bjorn 

You asked me for a reference to RTS in the PCIe specification. As luck would have it I ended up in an Irish bar with Peter Onufryk this week at OCP Summit. We discussed the topic. It is not explicitly referred to as "Route to Self" and it's certainly not explicit (or obvious) but r6.2.8.1 of the PCIe 4.0 specification discusses error conditions for virtual PCI bridges. One of these conditions (given in the very first bullet in that section) applies to a request that is destined for the same port it came in on. When this occurs the request must be terminated as a UR.

Stephen


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
