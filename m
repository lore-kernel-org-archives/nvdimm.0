Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4F679210E0FA0
 for <linux-nvdimm@lists.01.org>; Tue, 21 Aug 2018 11:13:54 -0700 (PDT)
References: <A88D23C5-46BD-462D-92D7-22BF284A905C@raithlin.com>
 <8d55e740-8caf-1b4d-6507-d18f99a309e6@intel.com>
 <B872A754-D31F-4F13-B78F-AC91BD72E9F2@raithlin.com>
 <674b145a-27e9-439f-cfdb-7179a35225ea@intel.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <41e84e28-4973-f09f-b16e-95960dea7c7c@deltatee.com>
Date: Tue, 21 Aug 2018 12:13:51 -0600
MIME-Version: 1.0
In-Reply-To: <674b145a-27e9-439f-cfdb-7179a35225ea@intel.com>
Content-Language: en-US
Subject: Re: dmaengine support for PMEM
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
To: Dave Jiang <dave.jiang@intel.com>, Stephen Bates <sbates@raithlin.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



On 21/08/18 12:11 PM, Dave Jiang wrote:
> 
> 
> On 08/21/2018 11:07 AM, Stephen  Bates wrote:
>>>    Here's where I left it last
>>>    https://git.kernel.org/pub/scm/linux/kernel/git/djiang/linux.git/log/?h=pmem_blk_dma
>>
>> Thanks Dave. I'll certainly rebase these on 4.18.x and do some testing! 
>>     
>>> I do think we need to do some rework with the dmaengine in order to get
>>>  better efficiency as well. At some point I would like to see a call in
>>  > dmaengine that will take a request (similar to mq) and just operate on
>>  > that and submit the descriptors in a single call. I think that can
>>  > possibly deprecate all the host of function pointers for dmaengine. I'm
>>  > hoping to find some time to take a look at some of this work towards the
>>  > end of the year. But I'd be highly interested if you guys have ideas and
>>  > thoughts on this topic. And you are welcome to take my patches and run
>>  > with it.
>>
>> OK, we were experimenting with a single PMEM driver and making decisions on DMA vs memcpy based on IO size rather than forcing the user to choose which driver to use. 
> 
> Oh yeah. Also I think what we discovered is that the block layer will
> not send anything larger than 4k buffers in SGs. So unless your DMA
> engine is very efficient with processing 4k you don't get great
> performance. Not sure how to get around that since existing DMA engines
> tend to prefer larger buffers to get better performance.

Yeah, that's exactly what we were running up against. Then we found your
patch set that pretty much dealt with a lot of the problems we were seeing.

>From a code perspective, I like the split modules, but I guess it puts a
burden on the user to blacklist one or the other to get DMA or not.
Which may depend on work load.

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
