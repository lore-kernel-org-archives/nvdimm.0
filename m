Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from CAN01-TO1-obe.outbound.protection.outlook.com
 (mail-eopbgr670114.outbound.protection.outlook.com [40.107.67.114])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 713F9207E53E6
 for <linux-nvdimm@lists.01.org>; Tue,  8 May 2018 15:25:08 -0700 (PDT)
From: "Stephen  Bates" <sbates@raithlin.com>
Subject: Re: [PATCH v4 04/14] PCI/P2PDMA: Clear ACS P2P flags for all devices
 behind switches
Date: Tue, 8 May 2018 22:25:06 +0000
Message-ID: <C3CEE4DB-A001-4E4C-B9B9-4B160E4C5367@raithlin.com>
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
 <354F7407-0DC7-470C-B9AA-74FDF9C46B08@raithlin.com>
 <20180508160336.0935ddde@w520.home>
 <20905682-9440-7d4b-0260-99d3dc794c3d@deltatee.com>
In-Reply-To: <20905682-9440-7d4b-0260-99d3dc794c3d@deltatee.com>
Content-Language: en-US
Content-ID: <D47BEDBD514959418998B2F27B79E08B@CANPRD01.PROD.OUTLOOK.COM>
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
To: Logan Gunthorpe <logang@deltatee.com>, Alex Williamson <alex.williamson@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Christoph Hellwig <hch@lst.de>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, =?utf-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <helgaas@kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, =?utf-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>
List-ID: <linux-nvdimm@lists.01.org>

>    Yeah, so based on the discussion I'm leaning toward just having a
>    command line option that takes a list of BDFs and disables ACS for them.
>    (Essentially as Dan has suggested.) This avoids the shotgun.

I concur that this seems to be where the conversation is taking us.

@Alex - Before we go do this can you provide input on the approach? I don't want to re-spin only to find we are still not converging on the ACS issue....

Thanks

Stephen
    

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
