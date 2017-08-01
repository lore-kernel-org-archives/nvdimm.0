Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 65A7D20945617
 for <linux-nvdimm@lists.01.org>; Tue,  1 Aug 2017 09:39:25 -0700 (PDT)
Subject: Re: [PATCH 5/5] libnvdimm: add DMA support for pmem blk-mq
References: <150153948477.49768.5767882242140065474.stgit@djiang5-desk3.ch.intel.com>
 <150153988620.49768.12914164179718467335.stgit@djiang5-desk3.ch.intel.com>
 <mqdy3r3zqpy.fsf@linux-x5ow.site>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <4319bf37-8e7d-28b4-db21-bc604d5dfd28@intel.com>
Date: Tue, 1 Aug 2017 09:40:47 -0700
MIME-Version: 1.0
In-Reply-To: <mqdy3r3zqpy.fsf@linux-x5ow.site>
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
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Koul, Vinod" <vinod.koul@intel.com>, "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



On 08/01/2017 12:34 AM, Johannes Thumshirn wrote:
> Dave Jiang <dave.jiang@intel.com> writes:
> 
>> Adding DMA support for pmem blk reads. This provides signficant CPU
>> reduction with large memory reads with good performance. DMAs are triggered
>> with test against bio_multiple_segment(), so the small I/Os (4k or less?)
>> are still performed by the CPU in order to reduce latency. By default
>> the pmem driver will be using blk-mq with DMA.
>>
>> Numbers below are measured against pmem simulated via DRAM using
>> memmap=NN!SS.  DMA engine used is the ioatdma on Intel Skylake Xeon
>> platform.  Keep in mind the performance for actual persistent memory
>> will differ.
>> Fio 2.21 was used.
>>
>> 64k: 1 task queuedepth=1
>> CPU Read:  7631 MB/s  99.7% CPU    DMA Read: 2415 MB/s  54% CPU
>> CPU Write: 3552 MB/s  100% CPU     DMA Write 2173 MB/s  54% CPU
>>
>> 64k: 16 tasks queuedepth=16
>> CPU Read: 36800 MB/s  1593% CPU    DMA Read:  29100 MB/s  607% CPU
>> CPU Write 20900 MB/s  1589% CPU    DMA Write: 23400 MB/s  585% CPU
>>
>> 2M: 1 task queuedepth=1
>> CPU Read:  6013 MB/s  99.3% CPU    DMA Read:  7986 MB/s  59.3% CPU
>> CPU Write: 3579 MB/s  100% CPU     DMA Write: 5211 MB/s  58.3% CPU
>>
>> 2M: 16 tasks queuedepth=16
>> CPU Read:  18100 MB/s 1588% CPU    DMA Read:  21300 MB/s 180.9% CPU
>> CPU Write: 14100 MB/s 1594% CPU    DMA Write: 20400 MB/s 446.9% CPU
>>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> ---
> 
> Hi Dave,
> 
> The above table shows that there's a performance benefit for 2M
> transfers but a regression for 64k transfers, if we forget about the CPU
> utilization for a second. Would it be beneficial to have heuristics on
> the transfer size that decide when to use dma and when not? You
> introduced this hunk:
> 
> -   rc = pmem_handle_cmd(cmd);
> +   if (cmd->chan && bio_multiple_segments(req->bio))
> +      rc = pmem_handle_cmd_dma(cmd, op_is_write(req_op(req)));
> +   else
> +       rc = pmem_handle_cmd(cmd);
> 
> Which utilizes dma for bios with multiple segments and for single
> segment bios you use the old path, maybe the single/multi segment logic
> can be amended to have something like:
> 
>     if (cmd->chan && bio_segments(req->bio) > PMEM_DMA_THRESH)
>        rc = pmem_handle_cmd_dma(cmd, op_is_write(req_op(req));
>     else
>        rc = pmem_handle_cmd(cmd);

Yes good idea. I will introduce a thresh parameter that's tune-able.

> 
> Just something woth considering IMHO.
> 
>> +	len = blk_rq_payload_bytes(req);
>> +	page = virt_to_page(pmem_addr);
>> +	off = (u64)pmem_addr & ~PAGE_MASK;
> 
> off = offset_in_page(pmem_addr); ?

Thanks. Will fix.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
