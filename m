Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from CAN01-QB1-obe.outbound.protection.outlook.com
 (mail-eopbgr660131.outbound.protection.outlook.com [40.107.66.131])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C4412210F93F1
 for <linux-nvdimm@lists.01.org>; Tue, 21 Aug 2018 11:07:02 -0700 (PDT)
From: "Stephen  Bates" <sbates@raithlin.com>
Subject: Re: dmaengine support for PMEM
Date: Tue, 21 Aug 2018 18:07:00 +0000
Message-ID: <B872A754-D31F-4F13-B78F-AC91BD72E9F2@raithlin.com>
References: <A88D23C5-46BD-462D-92D7-22BF284A905C@raithlin.com>
 <8d55e740-8caf-1b4d-6507-d18f99a309e6@intel.com>
In-Reply-To: <8d55e740-8caf-1b4d-6507-d18f99a309e6@intel.com>
Content-Language: en-US
Content-ID: <BAA0A0888D25A94B9F8E80F8028AA833@CANPRD01.PROD.OUTLOOK.COM>
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
To: Dave Jiang <dave.jiang@intel.com>, Logan Gunthorpe <logang@deltatee.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

>    Here's where I left it last
>    https://git.kernel.org/pub/scm/linux/kernel/git/djiang/linux.git/log/?h=pmem_blk_dma

Thanks Dave. I'll certainly rebase these on 4.18.x and do some testing! 
    
> I do think we need to do some rework with the dmaengine in order to get
>  better efficiency as well. At some point I would like to see a call in
 > dmaengine that will take a request (similar to mq) and just operate on
 > that and submit the descriptors in a single call. I think that can
 > possibly deprecate all the host of function pointers for dmaengine. I'm
 > hoping to find some time to take a look at some of this work towards the
 > end of the year. But I'd be highly interested if you guys have ideas and
 > thoughts on this topic. And you are welcome to take my patches and run
 > with it.

OK, we were experimenting with a single PMEM driver and making decisions on DMA vs memcpy based on IO size rather than forcing the user to choose which driver to use. 

Stephen
    

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
