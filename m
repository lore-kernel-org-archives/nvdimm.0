Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x22f.google.com (mail-yw0-x22f.google.com
 [IPv6:2607:f8b0:4002:c05::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B5734208F7A18
 for <linux-nvdimm@lists.01.org>; Thu, 10 Aug 2017 13:07:25 -0700 (PDT)
Received: by mail-yw0-x22f.google.com with SMTP id u207so11380289ywc.3
 for <linux-nvdimm@lists.01.org>; Thu, 10 Aug 2017 13:09:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <444e8ea7-ce3f-d595-a8df-23f85b3e70a4@intel.com>
References: <150212381454.23722.1549806704988615279.stgit@djiang5-desk3.ch.intel.com>
 <150212396591.23722.5220984838565015159.stgit@djiang5-desk3.ch.intel.com>
 <CAPcyv4jY-qr8EtQDQ3BfP=i5HNzfkW8Ak-0qxOLKHT4tFvcmog@mail.gmail.com>
 <CAPcyv4jzy-gK392PMNkecajK8iDGFPv=oJOhMPV=39_OkY=S1w@mail.gmail.com>
 <768daa66-ce83-da37-419f-37e0afcda468@intel.com>
 <CAPcyv4iqPf5L=KLSFoMYpd-tNYP6fZBSLjfStJ1_ypyux=gKOA@mail.gmail.com>
 <444e8ea7-ce3f-d595-a8df-23f85b3e70a4@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 10 Aug 2017 13:09:44 -0700
Message-ID: <CAPcyv4gx_fPDKASzvxsfCQDHYB8As1DYjyTG66zpGNBHQ030yw@mail.gmail.com>
Subject: Re: [PATCH v4 2/8] dmaengine: change transaction type DMA_SG to
 DMA_SG_SG
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
Cc: "Koul, Vinod" <vinod.koul@intel.com>, "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 10, 2017 at 12:44 PM, Dave Jiang <dave.jiang@intel.com> wrote:
>
>
> On 08/10/2017 12:05 PM, Dan Williams wrote:
>> On Thu, Aug 10, 2017 at 9:22 AM, Dave Jiang <dave.jiang@intel.com> wrote:
>>>
>>>
>>> On 08/09/2017 07:20 PM, Dan Williams wrote:
>>>> On Wed, Aug 9, 2017 at 7:15 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>>>>> On Mon, Aug 7, 2017 at 9:39 AM, Dave Jiang <dave.jiang@intel.com> wrote:
>>>>>> In preparation of adding an API to perform SG to/from buffer for dmaengine,
>>>>>> we will change DMA_SG to DMA_SG_SG in order to explicitly making clear what
>>>>>> this op type is for.
>>>>>>
>>>>>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>>>>>> ---
>>>>>>  Documentation/dmaengine/provider.txt |    2 +-
>>>>>>  drivers/crypto/ccp/ccp-dmaengine.c   |    2 +-
>>>>>>  drivers/dma/at_hdmac.c               |    8 ++++----
>>>>>>  drivers/dma/dmaengine.c              |    2 +-
>>>>>>  drivers/dma/dmatest.c                |   12 ++++++------
>>>>>>  drivers/dma/fsldma.c                 |    2 +-
>>>>>>  drivers/dma/mv_xor.c                 |    6 +++---
>>>>>>  drivers/dma/nbpfaxi.c                |    2 +-
>>>>>>  drivers/dma/ste_dma40.c              |    6 +++---
>>>>>>  drivers/dma/xgene-dma.c              |    4 ++--
>>>>>>  drivers/dma/xilinx/zynqmp_dma.c      |    2 +-
>>>>>>  include/linux/dmaengine.h            |    2 +-
>>>>>>  12 files changed, 25 insertions(+), 25 deletions(-)
>>>>>
>>>>> Given the prevalence and age of DMA_SG I think we should call the new
>>>>> op DMA_SG_SINGLE, or something like that, so that we don't surprise
>>>>> someone who was expecting the old command type.
>>>>
>>>> Oh wait, you already call the new op DMA_MEMCPY_SG, so why does the
>>>> old one need to change? ...and thinking about it further why do we
>>>> need a new op at all? Couldn't we just pass in a single entry
>>>> scatterlist that was setup on the stack with memcpy target address?
>>>
>>> That would probably work if we can do dma_map_sg() before submit and
>>> dma_unmap_page() on completion since we'll lose the sg entry. I also
>>> have concerns with the DMA_SG function provided in the ioatdma driver
>>> since it really doesn't do scatter gather and it's all software
>>> abstracted. It's not a big deal to support a single entry SG, but it
>>> wouldn't be supporting real SG to SG setup without more complex code. I
>>> worry about the overhead and messiness of it. Of course if you are ok
>>> with providing a DMA_SG function that really doesn't do exactly what
>>> it's advertised to do and only cater to pmem usage.
>>
>> I'm fishing for a way to not to make the dmaengine operation-type
>> proliferation problem worse. The sg-to-sg operation is odd in that
>> typical usages of a scatterlist have a contiguous buffer as the source
>> or destination. A change that gets us closer to that typical model is
>> what I'm looking for and not adding baggage that we need to unwind
>> later since everyone seems to agree that this "->prep_X() +
>> ->submit()" model is broken. I'd like to revisit whether we actually
>> need sg-to-sg vs that typical sg-to-buf model, and once we have the
>> typical model can we refactor all commands to use a single entry point
>> to the driver that takes a single scattler list parameter (similar to
>> scsi, usb, etc).
>
> Looking through the kernel it does not look like there's an actual in
> kernel consumer for DMA_SG. That makes it rather difficult to determine
> what it's used for. I have a feeling its usage is out of tree and thus
> explain the deviation from typical kernel usages. I'm wondering if we
> should to introduce DMA_SG_MEMCPY to set that as the standard and then
> deprecate DMA_SG eventually.

If there are no in-tree consumers of DMA_SG we can deprecate it
immediately. This is standard process
(Documentation/process/stable-api-nonsense.rst). When / if someone
notices this missing, they can work to get their use case upstream.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
