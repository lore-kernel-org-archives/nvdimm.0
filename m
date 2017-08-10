Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x234.google.com (mail-yw0-x234.google.com
 [IPv6:2607:f8b0:4002:c05::234])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EBB7121E2570C
 for <linux-nvdimm@lists.01.org>; Wed,  9 Aug 2017 19:13:33 -0700 (PDT)
Received: by mail-yw0-x234.google.com with SMTP id u207so50744946ywc.3
 for <linux-nvdimm@lists.01.org>; Wed, 09 Aug 2017 19:15:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <150212396591.23722.5220984838565015159.stgit@djiang5-desk3.ch.intel.com>
References: <150212381454.23722.1549806704988615279.stgit@djiang5-desk3.ch.intel.com>
 <150212396591.23722.5220984838565015159.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 9 Aug 2017 19:15:51 -0700
Message-ID: <CAPcyv4jY-qr8EtQDQ3BfP=i5HNzfkW8Ak-0qxOLKHT4tFvcmog@mail.gmail.com>
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
Cc: Vinod Koul <vinod.koul@intel.com>, "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Aug 7, 2017 at 9:39 AM, Dave Jiang <dave.jiang@intel.com> wrote:
> In preparation of adding an API to perform SG to/from buffer for dmaengine,
> we will change DMA_SG to DMA_SG_SG in order to explicitly making clear what
> this op type is for.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  Documentation/dmaengine/provider.txt |    2 +-
>  drivers/crypto/ccp/ccp-dmaengine.c   |    2 +-
>  drivers/dma/at_hdmac.c               |    8 ++++----
>  drivers/dma/dmaengine.c              |    2 +-
>  drivers/dma/dmatest.c                |   12 ++++++------
>  drivers/dma/fsldma.c                 |    2 +-
>  drivers/dma/mv_xor.c                 |    6 +++---
>  drivers/dma/nbpfaxi.c                |    2 +-
>  drivers/dma/ste_dma40.c              |    6 +++---
>  drivers/dma/xgene-dma.c              |    4 ++--
>  drivers/dma/xilinx/zynqmp_dma.c      |    2 +-
>  include/linux/dmaengine.h            |    2 +-
>  12 files changed, 25 insertions(+), 25 deletions(-)

Given the prevalence and age of DMA_SG I think we should call the new
op DMA_SG_SINGLE, or something like that, so that we don't surprise
someone who was expecting the old command type.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
