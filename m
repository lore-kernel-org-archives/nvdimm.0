Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C799D2095DB92
 for <linux-nvdimm@lists.01.org>; Thu,  3 Aug 2017 09:10:49 -0700 (PDT)
Subject: Re: [PATCH 5/5] libnvdimm: add DMA support for pmem blk-mq
References: <150153948477.49768.5767882242140065474.stgit@djiang5-desk3.ch.intel.com>
 <150153988620.49768.12914164179718467335.stgit@djiang5-desk3.ch.intel.com>
 <mqdy3r3zqpy.fsf@linux-x5ow.site>
 <CAPcyv4hvY4swcyijRaSR8QpMEv1w=g52udpW7F9Qs-1oS0bskQ@mail.gmail.com>
 <20170803080615.GB4333@linux-x5ow.site>
 <CAPcyv4ibnZ8xPLyL3AUUvZrhyU7-dT9hk5aA-eF=E3cxYinATw@mail.gmail.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <2dc39cda-ba3f-7b5f-6f96-69ee4fd71a25@intel.com>
Date: Thu, 3 Aug 2017 09:12:57 -0700
MIME-Version: 1.0
In-Reply-To: <CAPcyv4ibnZ8xPLyL3AUUvZrhyU7-dT9hk5aA-eF=E3cxYinATw@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>, Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Koul, Vinod" <vinod.koul@intel.com>, "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



On 08/03/2017 08:41 AM, Dan Williams wrote:
> On Thu, Aug 3, 2017 at 1:06 AM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
>> On Tue, Aug 01, 2017 at 10:43:30AM -0700, Dan Williams wrote:
>>> On Tue, Aug 1, 2017 at 12:34 AM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
>>>> Dave Jiang <dave.jiang@intel.com> writes:
>>>>
>>>>> Adding DMA support for pmem blk reads. This provides signficant CPU
>>>>> reduction with large memory reads with good performance. DMAs are triggered
>>>>> with test against bio_multiple_segment(), so the small I/Os (4k or less?)
>>>>> are still performed by the CPU in order to reduce latency. By default
>>>>> the pmem driver will be using blk-mq with DMA.
>>>>>
>>>>> Numbers below are measured against pmem simulated via DRAM using
>>>>> memmap=NN!SS.  DMA engine used is the ioatdma on Intel Skylake Xeon
>>>>> platform.  Keep in mind the performance for actual persistent memory
>>>>> will differ.
>>>>> Fio 2.21 was used.
>>>>>
>>>>> 64k: 1 task queuedepth=1
>>>>> CPU Read:  7631 MB/s  99.7% CPU    DMA Read: 2415 MB/s  54% CPU
>>>>> CPU Write: 3552 MB/s  100% CPU     DMA Write 2173 MB/s  54% CPU
>>>>>
>>>>> 64k: 16 tasks queuedepth=16
>>>>> CPU Read: 36800 MB/s  1593% CPU    DMA Read:  29100 MB/s  607% CPU
>>>>> CPU Write 20900 MB/s  1589% CPU    DMA Write: 23400 MB/s  585% CPU
>>>>>
>>>>> 2M: 1 task queuedepth=1
>>>>> CPU Read:  6013 MB/s  99.3% CPU    DMA Read:  7986 MB/s  59.3% CPU
>>>>> CPU Write: 3579 MB/s  100% CPU     DMA Write: 5211 MB/s  58.3% CPU
>>>>>
>>>>> 2M: 16 tasks queuedepth=16
>>>>> CPU Read:  18100 MB/s 1588% CPU    DMA Read:  21300 MB/s 180.9% CPU
>>>>> CPU Write: 14100 MB/s 1594% CPU    DMA Write: 20400 MB/s 446.9% CPU
>>>>>
>>>>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>>>>> ---
>>>>
>>>> Hi Dave,
>>>>
>>>> The above table shows that there's a performance benefit for 2M
>>>> transfers but a regression for 64k transfers, if we forget about the CPU
>>>> utilization for a second.
>>>
>>> I don't think we can forget about cpu utilization, and I would expect
>>> most users would value cpu over small bandwidth increases. Especially
>>> when those numbers show efficiency like this
>>>
>>> +160% cpu +26% read bandwidth
>>> +171% cpu -10% write bandwidth
>>>
>>>> Would it be beneficial to have heuristics on
>>>> the transfer size that decide when to use dma and when not? You
>>>> introduced this hunk:
>>>>
>>>> -   rc = pmem_handle_cmd(cmd);
>>>> +   if (cmd->chan && bio_multiple_segments(req->bio))
>>>> +      rc = pmem_handle_cmd_dma(cmd, op_is_write(req_op(req)));
>>>> +   else
>>>> +       rc = pmem_handle_cmd(cmd);
>>>>
>>>> Which utilizes dma for bios with multiple segments and for single
>>>> segment bios you use the old path, maybe the single/multi segment logic
>>>> can be amended to have something like:
>>>>
>>>>     if (cmd->chan && bio_segments(req->bio) > PMEM_DMA_THRESH)
>>>>        rc = pmem_handle_cmd_dma(cmd, op_is_write(req_op(req));
>>>>     else
>>>>        rc = pmem_handle_cmd(cmd);
>>>>
>>>> Just something woth considering IMHO.
>>>
>>> The thing we want to avoid most is having the cpu stall doing nothing
>>> waiting for memory access, so I think once the efficiency of adding
>>> more cpu goes non-linear it's better to let the dma engine handle
>>> that. The current heuristic seems to achieve that, but the worry is
>>> does it over-select the cpu for cases where requests could be merged
>>> into a bulkier i/o that is more suitable for dma.
>>>
>>> I'm not sure we want another tunable vs predictable / efficient
>>> behavior by default.
>>
>> Sorry for my late reply, but lots of automated performance regression CI tools
>> _will_ report errors because of the performance drop. Yes these may be false
>> positives, but it'll cost hours to resolve them. If we have a tunable it's way
>> easier to set it correctly for the use cases. And please keep in mind some
>> people don't really case about CPU utilization but maxiumum throughput.
> 
> Returning more cpu to the application may also increase bandwidth
> because we stop spinning on completion and spend more time issuing
> I/O. I'm also worried that this threshold cross-over point is workload
> and pmem media specific. The tunable should be there as an override,
> but I think we need simple/sane defaults out of the gate. A "no
> regressions whatsoever on any metric" policy effectively kills this
> effort as far as I can see. We otherwise need quite a bit more
> qualification of different workloads, these 3 fio runs is not enough.
> 

I can put in a tunable knob like Johannes suggested and leave the
default for that to what it is currently. And we can adjust as necessary
as we do more testing.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
