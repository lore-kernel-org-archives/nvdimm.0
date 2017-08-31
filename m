Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9517120958BF8
 for <linux-nvdimm@lists.01.org>; Thu, 31 Aug 2017 16:35:09 -0700 (PDT)
Subject: Re: [PATCH v7 9/9] libnvdimm: Add DMA based blk-mq pmem driver
References: <150412628764.69288.12074115435918322858.stgit@djiang5-desk3.ch.intel.com>
 <150412658373.69288.2856155675209269488.stgit@djiang5-desk3.ch.intel.com>
 <1504216996.2042.182.camel@hpe.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <388c38a5-e933-c939-0559-d8724b975f00@intel.com>
Date: Thu, 31 Aug 2017 16:37:51 -0700
MIME-Version: 1.0
In-Reply-To: <1504216996.2042.182.camel@hpe.com>
Content-Language: en-US
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
To: "Kani, Toshimitsu" <toshi.kani@hpe.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Koul, Vinod" <vinod.koul@intel.com>
Cc: "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



On 08/31/2017 03:13 PM, Kani, Toshimitsu wrote:
> On Wed, 2017-08-30 at 13:56 -0700, Dave Jiang wrote:
>  :
> +static int pmem_attach_disk(struct device *dev,
>> +struct nd_namespace_common *ndns)
>> +{
>> +struct pmem_device *pmem;
>> +int rc;
>> +struct dma_chan *chan = NULL;
>> +int has_dma;
>> +
>> +pmem = pmem_core_setup_pmem(dev, ndns);
>> +if (!pmem)
>> +return -ENXIO;
>> +
>> +chan = dma_find_channel(DMA_MEMCPY_SG);
>> +if (!chan)
>> +dev_warn(dev, "Forced back to CPU, no DMA\n");
> 
> I just tested this series on a Haswell system.  The above warning
> messages was shown during boot-up (is this expected?), but it did not
> appear to switch back to CPU.  Initial IO requests to pmem (mkfs) hit
> the WARN_ON_ONCE() below.  pmem->sg_allocated is zero since it was not
> initialized (has_dma was set to 0).
> 
> [  897.147527] WARNING: CPU: 23 PID: 707 at
> drivers/nvdimm/pmem_dma.c:171 pmem_handle_cmd_dma+0x675/0x710
> 
> It then displayed seemed-forever-repeated error messages below.
> 
>  ioatdma 0000:80:04.7: ioat_timer_event: Channel halted (1)
>  ioatdma 0000:80:04.7: Errors:
>  ioatdma 0000:80:04.7: Err(0): DMA Transfer Source Address Error
>  ioatdma 0000:80:04.7: Reset channel...
>  ioatdma 0000:80:04.7: Restart channel...
>  ioatdma 0000:80:04.7: ioat_timer_event: Channel halted (1000)
>  ioatdma 0000:80:04.7: Errors:
>  ioatdma 0000:80:04.7: Err(12): Completion Address Error
>  ioatdma 0000:80:04.7: Reset channel...
>  ioatdma 0000:80:04.7: Restart channel...
>  ioatdma 0000:80:04.7: ioat_timer_event: Channel halted (1000)
>    :
> 
> Any thoughts?  Also, how do I choose the mode between CPU and DMA?
> Thanks!
> -Toshi
> 
Toshi,
I may have broken the no DMA path when I was doing some reformatting the
past revision. Let me do some debugging and I'll get back to you. To run
it without DMA, you just make sure ioatdma is blacklisted or rmmoded.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
