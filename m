Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from CAN01-QB1-obe.outbound.protection.outlook.com
 (mail-eopbgr660116.outbound.protection.outlook.com [40.107.66.116])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E3F4321FD73F4
 for <linux-nvdimm@lists.01.org>; Thu,  1 Mar 2018 07:52:34 -0800 (PST)
From: "Stephen  Bates" <sbates@raithlin.com>
Subject: Re: [PATCH v2 08/10] nvme-pci: Add support for P2P memory in requests
Date: Thu, 1 Mar 2018 15:58:40 +0000
Message-ID: <1CE68E79-E5FD-4EE2-BD88-B3EE57E43ACE@raithlin.com>
References: <20180228234006.21093-1-logang@deltatee.com>
 <20180228234006.21093-9-logang@deltatee.com>
 <c6639530-48ba-4655-c772-7d88a030e37e@grimberg.me>
In-Reply-To: <c6639530-48ba-4655-c772-7d88a030e37e@grimberg.me>
Content-Language: en-US
Content-ID: <B26D9242624F7941AF546D1011EA83EC@CANPRD01.PROD.OUTLOOK.COM>
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
To: Sagi Grimberg <sagi@grimberg.me>, Logan Gunthorpe <logang@deltatee.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>, Keith Busch <keith.busch@intel.com>, =?utf-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

> Any plans adding the capability to nvme-rdma? Should be
> straight-forward... In theory, the use-case would be rdma backend
> fabric behind. Shouldn't be hard to test either...

Nice idea Sagi. Yes we have been starting to look at that. Though again we would probably want to impose the "attached to the same PCIe switch" rule which might be less common to satisfy in initiator systems. 

Down the road I would also like to discuss the best way to use this P2P framework to facilitate copies between NVMe namespaces (on both PCIe and fabric attached namespaces) without having to expose the CMB up to user space. Wasn't something like that done in the SCSI world at some point Martin?

Stephen
    

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
