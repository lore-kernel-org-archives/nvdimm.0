Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Tue, 19 May 2015 09:40:52 +0530
From: Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH v3 06/11] scatterlist: support "page-less" (__pfn_t only)
 entries
Message-ID: <20150519041052.GI3140@localhost>
References: <20150512042629.11521.70356.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20150512043001.11521.3526.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1431542149.31415.10.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1431542149.31415.10.camel@intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "hch@lst.de" <hch@lst.de>, "axboe@fb.com" <axboe@fb.com>, "mingo@kernel.org" <mingo@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "j.glisse@gmail.com" <j.glisse@gmail.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "riel@redhat.com" <riel@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>, "willy@linux.intel.com" <willy@linux.intel.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "mgorman@suse.de" <mgorman@suse.de>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, "david@fromorbit.com" <david@fromorbit.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 13, 2015 at 06:35:55PM +0000, Williams, Dan J wrote:
> [ adding willy (yes, need to fix my scripts), and dmaengine folks]
> 
> Jens, Christoph,
> 
> I've rebased this patch series block/for-next.  With commit 84be456f883c
> "remove <asm/scatterlist.h>" I think we can take the next step of
> removing all references to page_link and just use __pfn_t by default.
> v4 patch below.
> 
> Jens, I'm wondering if you want to take this series(.) as patches or
> prepare a git branch to pull?
> 

> diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
> index 4d63e0d4da9a..21736afd3320 100644
> --- a/drivers/crypto/omap-sham.c
> +++ b/drivers/crypto/omap-sham.c
> @@ -582,7 +582,7 @@ static int omap_sham_xmit_dma(struct omap_sham_dev *dd, dma_addr_t dma_addr,
>  		 * the dmaengine may try to DMA the incorrect amount of data.
>  		 */
>  		sg_init_table(&ctx->sgl, 1);
> -		ctx->sgl.page_link = ctx->sg->page_link;
> +		ctx->sgl.pfn = ctx->sg->pfn;
Do you want drivers to tinker with internals of sg, I think driver should be
agnostic here, perhpas a helper to get pfn, sg_get_pfn()

>  		ctx->sgl.offset = ctx->sg->offset;
>  		sg_dma_len(&ctx->sgl) = len32;
>  		sg_dma_address(&ctx->sgl) = sg_dma_address(ctx->sg);
> diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
> index eed405976ea9..a767727bcfef 100644
> --- a/drivers/dma/imx-dma.c
> +++ b/drivers/dma/imx-dma.c
> @@ -886,7 +886,7 @@ static struct dma_async_tx_descriptor *imxdma_prep_dma_cyclic(
>  	sg_init_table(imxdmac->sg_list, periods);
>  
>  	for (i = 0; i < periods; i++) {
> -		imxdmac->sg_list[i].page_link = 0;
> +		imxdmac->sg_list[i].pfn.page = NULL;
same here, sg_set_pfn_page() ?

>  		imxdmac->sg_list[i].offset = 0;
>  		imxdmac->sg_list[i].dma_address = dma_addr;
>  		sg_dma_len(&imxdmac->sg_list[i]) = period_len;
> @@ -894,10 +894,7 @@ static struct dma_async_tx_descriptor *imxdma_prep_dma_cyclic(
>  	}
>  
>  	/* close the loop */
> -	imxdmac->sg_list[periods].offset = 0;
> -	sg_dma_len(&imxdmac->sg_list[periods]) = 0;
> -	imxdmac->sg_list[periods].page_link =
> -		((unsigned long)imxdmac->sg_list | 0x01) & ~0x02;
> +	sg_chain(imxdmac->sg_list, periods + 1, imxdmac->sg_list);
This looks right...

-- 
~Vinod
