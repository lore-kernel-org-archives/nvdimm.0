Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from CAN01-QB1-obe.outbound.protection.outlook.com
 (mail-eopbgr660114.outbound.protection.outlook.com [40.107.66.114])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9EA392210D9EB
 for <linux-nvdimm@lists.01.org>; Sat, 24 Mar 2018 08:22:10 -0700 (PDT)
From: "Stephen  Bates" <sbates@raithlin.com>
Subject: Re: [PATCH v3 01/11] PCI/P2PDMA: Support peer-to-peer memory
Date: Sat, 24 Mar 2018 15:28:43 +0000
Message-ID: <121026DC-40C7-4F4E-BE27-BDA652BDEB6A@raithlin.com>
References: <a0af83f8-2cbc-862b-6f8b-231991527cfc@deltatee.com>
 <3ea80992-a0fc-08f2-d93d-ae0ec4e3f4ce@codeaurora.org>
 <4eb6850c-df1b-fd44-3ee0-d43a50270b53@deltatee.com>
 <757fca36-dee4-e070-669e-f2788bd78e41@codeaurora.org>
 <4f761f55-4e9a-dccb-d12f-c59d2cd689db@deltatee.com>
 <BB94077B-7EB3-49C4-862D-BF77D0A692CC@raithlin.com>
 <20180313230850.GA45763@bhelgaas-glaptop.roam.corp.google.com>
 <C90AA66C-FFC6-4CCA-B959-7BBECA65509C@raithlin.com>
 <20180323215046.GC210003@bhelgaas-glaptop.roam.corp.google.com>
 <dc414fa5-1af9-0ba7-e12e-4cd9df313119@deltatee.com>
 <20180324034947.GE210003@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20180324034947.GE210003@bhelgaas-glaptop.roam.corp.google.com>
Content-Language: en-US
Content-ID: <40F4DE2D03BE0945B1840DC8069596E8@CANPRD01.PROD.OUTLOOK.COM>
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
To: Bjorn Helgaas <helgaas@kernel.org>, Logan Gunthorpe <logang@deltatee.com>
Cc: Jens Axboe <axboe@kernel.dk>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Alex Williamson <alex.williamson@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Sinan Kaya <okaya@codeaurora.org>, =?utf-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Keith Busch <keith.busch@intel.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

> That would be very nice but many devices do not support the internal
> route. 

But Logan in the NVMe case we are discussing movement within a single function (i.e. from a NVMe namespace to a NVMe CMB on the same function). Bjorn is discussing movement between two functions (PFs or VFs) in the same PCIe EP. In the case of multi-function endpoints I think the standard requires those devices to support internal DMAs for transfers between those functions (but does not require it within a function).

So I think the summary is:

1. There is no requirement for a single function to support internal DMAs but in the case of NVMe we do have a protocol specific way for a NVMe function to indicate it supports via the CMB BAR. Other protocols may also have such methods but I am not aware of them at this time.

2. For multi-function end-points I think it is a requirement that DMAs *between* functions are supported via an internal path but this can be over-ridden by ACS when supported in the EP.

3. For multi-function end-points there is no requirement to support internal DMA within each individual function (i.e. a la point 1 but extended to each function in a MF device). 

Based on my review of the specification I concur with Bjorn that p2pdma between functions in a MF end-point should be assured to be supported via the standard. However if the p2pdma involves only a single function in a MF device then we can only support NVMe CMBs for now. Let's review and see what the options are for supporting this in the next respin.

Stephen


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
