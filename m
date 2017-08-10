Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5FF8D21AEB0A3
 for <linux-nvdimm@lists.01.org>; Thu, 10 Aug 2017 09:20:29 -0700 (PDT)
Subject: Re: [PATCH v4 2/8] dmaengine: change transaction type DMA_SG to
 DMA_SG_SG
References: <150212381454.23722.1549806704988615279.stgit@djiang5-desk3.ch.intel.com>
 <150212396591.23722.5220984838565015159.stgit@djiang5-desk3.ch.intel.com>
 <CAPcyv4jY-qr8EtQDQ3BfP=i5HNzfkW8Ak-0qxOLKHT4tFvcmog@mail.gmail.com>
 <CAPcyv4jzy-gK392PMNkecajK8iDGFPv=oJOhMPV=39_OkY=S1w@mail.gmail.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <768daa66-ce83-da37-419f-37e0afcda468@intel.com>
Date: Thu, 10 Aug 2017 09:22:47 -0700
MIME-Version: 1.0
In-Reply-To: <CAPcyv4jzy-gK392PMNkecajK8iDGFPv=oJOhMPV=39_OkY=S1w@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Koul, Vinod" <vinod.koul@intel.com>, "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



On 08/09/2017 07:20 PM, Dan Williams wrote:
> On Wed, Aug 9, 2017 at 7:15 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>> On Mon, Aug 7, 2017 at 9:39 AM, Dave Jiang <dave.jiang@intel.com> wrote:
>>> In preparation of adding an API to perform SG to/from buffer for dmaengine,
>>> we will change DMA_SG to DMA_SG_SG in order to explicitly making clear what
>>> this op type is for.
>>>
>>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>>> ---
>>>  Documentation/dmaengine/provider.txt |    2 +-
>>>  drivers/crypto/ccp/ccp-dmaengine.c   |    2 +-
>>>  drivers/dma/at_hdmac.c               |    8 ++++----
>>>  drivers/dma/dmaengine.c              |    2 +-
>>>  drivers/dma/dmatest.c                |   12 ++++++------
>>>  drivers/dma/fsldma.c                 |    2 +-
>>>  drivers/dma/mv_xor.c                 |    6 +++---
>>>  drivers/dma/nbpfaxi.c                |    2 +-
>>>  drivers/dma/ste_dma40.c              |    6 +++---
>>>  drivers/dma/xgene-dma.c              |    4 ++--
>>>  drivers/dma/xilinx/zynqmp_dma.c      |    2 +-
>>>  include/linux/dmaengine.h            |    2 +-
>>>  12 files changed, 25 insertions(+), 25 deletions(-)
>>
>> Given the prevalence and age of DMA_SG I think we should call the new
>> op DMA_SG_SINGLE, or something like that, so that we don't surprise
>> someone who was expecting the old command type.
> 
> Oh wait, you already call the new op DMA_MEMCPY_SG, so why does the
> old one need to change? ...and thinking about it further why do we
> need a new op at all? Couldn't we just pass in a single entry
> scatterlist that was setup on the stack with memcpy target address?

That would probably work if we can do dma_map_sg() before submit and
dma_unmap_page() on completion since we'll lose the sg entry. I also
have concerns with the DMA_SG function provided in the ioatdma driver
since it really doesn't do scatter gather and it's all software
abstracted. It's not a big deal to support a single entry SG, but it
wouldn't be supporting real SG to SG setup without more complex code. I
worry about the overhead and messiness of it. Of course if you are ok
with providing a DMA_SG function that really doesn't do exactly what
it's advertised to do and only cater to pmem usage.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
