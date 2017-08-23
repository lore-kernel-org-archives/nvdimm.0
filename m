Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x236.google.com (mail-oi0-x236.google.com
 [IPv6:2607:f8b0:4003:c06::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3BCCF2095B9C9
 for <linux-nvdimm@lists.01.org>; Wed, 23 Aug 2017 12:55:35 -0700 (PDT)
Received: by mail-oi0-x236.google.com with SMTP id j144so11801286oib.1
 for <linux-nvdimm@lists.01.org>; Wed, 23 Aug 2017 12:58:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <cc37e79b-904e-a8a3-faae-28887ed28b0f@intel.com>
References: <150333903164.55214.3813479680626005389.stgit@djiang5-desk3.ch.intel.com>
 <150334987495.55214.5621513659334023484.stgit@djiang5-desk3.ch.intel.com>
 <CAPcyv4h5wm3C8BhQQpA8vZ3SCrcunLCW-rgrq6QCUHX74YJpgQ@mail.gmail.com>
 <cc37e79b-904e-a8a3-faae-28887ed28b0f@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 23 Aug 2017 12:58:08 -0700
Message-ID: <CAPcyv4idv6NL8B8DpjW-L2DTtMLvOFh5+M6rAE3-JSTvAkUPvg@mail.gmail.com>
Subject: Re: [PATCH v5 7/7] libnvdimm: Add blk-mq pmem driver
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Koul, Vinod  <vinod.koul@intel.com>, Christoph Hellwig <hch@infradead.org>, dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Aug 23, 2017 at 12:56 PM, Dave Jiang <dave.jiang@intel.com> wrote:
>
>
> On 08/23/2017 11:39 AM, Dan Williams wrote:
>> On Mon, Aug 21, 2017 at 2:11 PM, Dave Jiang <dave.jiang@intel.com> wrote:
>>> Adding a DMA supported blk-mq driver for pmem.
>>
>> "Add support for offloading pmem block-device I/O operations to a DMA engine."
>>
>>> This provides signficant CPU
>>
>> *significant
>>
>>> utilization reduction.
>>
>> "at the cost of some increased latency and bandwidth reduction in some cases."
>>
>>> By default the pmem driver will be using blk-mq with
>>
>> "By default the current cpu-copy based pmem driver will load, but this
>> driver can be manually selected with a modprobe configuration."
>>
>>> DMA through the dmaengine API. DMA can be turned off with use_dma=0 kernel
>>> parameter.
>>
>> Do we need the module option? It seems for debug / testing a user can
>> simply unload the ioatdma driver, otherwise we should use dma by
>> default.
>>
>>> Additional kernel parameters are provided:
>>>
>>> queue_depth: The queue depth for blk-mq. Typically in relation to what the
>>>              DMA engine can provide per queue/channel. This needs to take
>>>              into account of num_sg as well for some DMA engines. i.e.
>>>              num_sg * queue_depth < total descriptors available per queue or
>>>              channel.
>>>
>>> q_per_node: Hardware queues per node. Typically the number of channels the
>>>             DMA engine can provide per socket.
>>> num_sg: Number of scatterlist we can handle per I/O request.
>>
>> Why do these need to be configurable?
>
> The concern is with other arch/platforms that have different DMA
> engines. The configurations would be platform dependent.

...but these are answers we should be able to get from dmaengine and
the specific DMA drivers in use. An end user has no chance of guessing
the right values.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
