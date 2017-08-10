Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x22f.google.com (mail-yw0-x22f.google.com
 [IPv6:2607:f8b0:4002:c05::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 364CF21E2570C
 for <linux-nvdimm@lists.01.org>; Wed,  9 Aug 2017 19:22:04 -0700 (PDT)
Received: by mail-yw0-x22f.google.com with SMTP id s143so50799235ywg.1
 for <linux-nvdimm@lists.01.org>; Wed, 09 Aug 2017 19:24:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <150212397710.23722.415749304040796516.stgit@djiang5-desk3.ch.intel.com>
References: <150212381454.23722.1549806704988615279.stgit@djiang5-desk3.ch.intel.com>
 <150212397710.23722.415749304040796516.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 9 Aug 2017 19:24:21 -0700
Message-ID: <CAPcyv4geOpEP2Ln5DALsOPz3f52x_ZLHcfNWJuMi8dfrb02Riw@mail.gmail.com>
Subject: Re: [PATCH v4 4/8] dmaengine: add verification of DMA_MEMSET_SG in
 dmaengine
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
> DMA_MEMSET_SG is missing the verification of having the operation set and
> also a supporting function provided.
>
> Fixes: Commit 50c7cd2bd ("dmaengine: Add scatter-gathered memset")
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/dma/dmaengine.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
> index 1c424f6..d9a71f0 100644
> --- a/drivers/dma/dmaengine.c
> +++ b/drivers/dma/dmaengine.c
> @@ -935,6 +935,8 @@ int dma_async_device_register(struct dma_device *device)
>                 !device->device_prep_dma_pq_val);
>         BUG_ON(dma_has_cap(DMA_MEMSET, device->cap_mask) &&
>                 !device->device_prep_dma_memset);
> +       BUG_ON(dma_has_cap(DMA_MEMSET_SG, device->cap_mask) &&
> +               !device->device_prep_dma_memset_sg);
>         BUG_ON(dma_has_cap(DMA_INTERRUPT, device->cap_mask) &&
>                 !device->device_prep_dma_interrupt);
>         BUG_ON(dma_has_cap(DMA_SG_SG, device->cap_mask) &&
>

One of these days we might convert all of these to a WARN_ON_ONCE()
with a an error return. No need to crash dmaengine developer systems
when they make this small mistake.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
