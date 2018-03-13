Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from CAN01-QB1-obe.outbound.protection.outlook.com
 (mail-eopbgr660114.outbound.protection.outlook.com [40.107.66.114])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0353521E87995
 for <linux-nvdimm@lists.01.org>; Tue, 13 Mar 2018 15:39:21 -0700 (PDT)
From: "Stephen  Bates" <sbates@raithlin.com>
Subject: Re: [PATCH v3 01/11] PCI/P2PDMA: Support peer-to-peer memory
Date: Tue, 13 Mar 2018 22:45:41 +0000
Message-ID: <47F026DE-AFD0-4F63-8D39-375D3684C7B1@raithlin.com>
References: <20180312193525.2855-1-logang@deltatee.com>
 <20180312193525.2855-2-logang@deltatee.com>
 <59fd2f5d-177f-334a-a9c4-0f8a6ec7c303@codeaurora.org>
 <24d8e5c2-065d-8bde-3f5d-7f158be9c578@deltatee.com>
 <52cbbbc4-c488-f83f-8d02-14d455b4efd7@codeaurora.org>
 <3e738f95-d73c-4182-2fa1-8664aafb1ab7@deltatee.com>
 <703aa92c-0c1c-4852-5887-6f6e6ccde0fb@codeaurora.org>
 <a0af83f8-2cbc-862b-6f8b-231991527cfc@deltatee.com>
 <3ea80992-a0fc-08f2-d93d-ae0ec4e3f4ce@codeaurora.org>
 <4eb6850c-df1b-fd44-3ee0-d43a50270b53@deltatee.com>
 <757fca36-dee4-e070-669e-f2788bd78e41@codeaurora.org>
 <4f761f55-4e9a-dccb-d12f-c59d2cd689db@deltatee.com>
 <016dc910-f96a-8a60-4bda-fa24eea98ea5@codeaurora.org>
In-Reply-To: <016dc910-f96a-8a60-4bda-fa24eea98ea5@codeaurora.org>
Content-Language: en-US
Content-ID: <CBB285235DCCC44AADEE04E9322EF6A5@CANPRD01.PROD.OUTLOOK.COM>
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
To: Sinan Kaya <okaya@codeaurora.org>, Logan Gunthorpe <logang@deltatee.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>, Keith Busch <keith.busch@intel.com>, =?utf-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Hi Sinan

>    If hardware doesn't support it, blacklisting should have been the right
>    path and I still think that you should remove all switch business from the code.
>    I did not hear enough justification for having a switch requirement
>    for P2P.
  
We disagree. As does the community based on feedback on previous version of this patch set.
  
> You are also saying that root ports have issues not because of functionality but
> because of performance. 

I have seen both.  Some systems fail in entirety to route TLPs across route ports. Others do route but with poor performance. Having a requirement for a switch is therefore a reasonable and sensible minimum criteria for enabling p2p.
    
> If you know what is bad, create a list and keep adding it. You can't assume
> universally that all root ports are broken/ have bad performance.

I actually wanted to do a blacklist originally but that idea was not accepted by the community. 
    
>    What if I come up with a very cheap/crappy switch (something like used in data
>    mining)?
> What guarantees that P2P will work with this device? You are making an
> assumption here that all switches have good performance.

A switch must support P2P or it is in violation of the PCIe specification.
    
>    I have been doing my best to provide feedback. It feels like you are throwing
>    them over the wall to be honest.

I think one issue Sinan is that a lot of your ideas have been discussed in previous versions of the series. So you are asking us to make changes which, in some cases, we know are not acceptable to others in the community. The input is welcome but it flies in the face of other input we have received. 

However if other developers feel strongly about the blacklist/whitelist and switch criteria please speak up! ;-)

Stephen

    

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
