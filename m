Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ua0-x236.google.com (mail-ua0-x236.google.com
 [IPv6:2607:f8b0:400c:c08::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3D82B2095DBAC
 for <linux-nvdimm@lists.01.org>; Tue,  1 Aug 2017 10:41:23 -0700 (PDT)
Received: by mail-ua0-x236.google.com with SMTP id w45so10221638uac.5
 for <linux-nvdimm@lists.01.org>; Tue, 01 Aug 2017 10:43:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <mqdy3r3zqpy.fsf@linux-x5ow.site>
References: <150153948477.49768.5767882242140065474.stgit@djiang5-desk3.ch.intel.com>
 <150153988620.49768.12914164179718467335.stgit@djiang5-desk3.ch.intel.com>
 <mqdy3r3zqpy.fsf@linux-x5ow.site>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 1 Aug 2017 10:43:30 -0700
Message-ID: <CAPcyv4hvY4swcyijRaSR8QpMEv1w=g52udpW7F9Qs-1oS0bskQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] libnvdimm: add DMA support for pmem blk-mq
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
Cc: Vinod Koul <vinod.koul@intel.com>, "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Aug 1, 2017 at 12:34 AM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
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
> utilization for a second.

I don't think we can forget about cpu utilization, and I would expect
most users would value cpu over small bandwidth increases. Especially
when those numbers show efficiency like this

+160% cpu +26% read bandwidth
+171% cpu -10% write bandwidth

> Would it be beneficial to have heuristics on
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
>
> Just something woth considering IMHO.

The thing we want to avoid most is having the cpu stall doing nothing
waiting for memory access, so I think once the efficiency of adding
more cpu goes non-linear it's better to let the dma engine handle
that. The current heuristic seems to achieve that, but the worry is
does it over-select the cpu for cases where requests could be merged
into a bulkier i/o that is more suitable for dma.

I'm not sure we want another tunable vs predictable / efficient
behavior by default.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
