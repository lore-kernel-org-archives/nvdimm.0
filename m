Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 27CA721A04811
 for <linux-nvdimm@lists.01.org>; Fri, 14 Apr 2017 01:35:20 -0700 (PDT)
Date: Fri, 14 Apr 2017 10:35:18 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 01/22] scatterlist: Introduce sg_map helper functions
Message-ID: <20170414083518.GA25471@lst.de>
References: <1492121135-4437-1-git-send-email-logang@deltatee.com>
 <1492121135-4437-2-git-send-email-logang@deltatee.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1492121135-4437-2-git-send-email-logang@deltatee.com>
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
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Steve Wise <swise@opengridcomputing.com>, linux-nvme@lists.infradead.org, target-devel@vger.kernel.org, Sumit Semwal <sumit.semwal@linaro.org>, devel@driverdev.osuosl.org, rds-devel@oss.oracle.com, linux-scsi@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, linux-rdma@vger.kernel.org, Christoph Hellwig <hch@lst.de>, fcoe-devel@open-fcoe.org, open-iscsi@googlegroups.com, linux-media@vger.kernel.org, Ming Lin <ming.l@ssi.samsung.com>, intel-gfx@lists.freedesktop.org, sparmaintainer@unisys.com, linux-raid@vger.kernel.org, dri-devel@lists.freedesktop.org, megaraidlinux.pdl@broadcom.com, Jens Axboe <axboe@kernel.dk>, linaro-mm-sig@lists.linaro.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-nvdimm@lists.01.org, linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, netdev@vger.kernel.org, Tejun Heo <tj@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index 0007b79..b95934b 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -37,6 +37,9 @@
>  
>  #include <uapi/linux/dma-buf.h>
>  
> +/* Prevent the highmem.h macro from aliasing ops->kunmap_atomic */
> +#undef kunmap_atomic
> +
>  static inline int is_dma_buf_file(struct file *);
>  
>  struct dma_buf_list {

I think the right fix here is to rename the operation to unmap_atomic
and send out a little patch for that ASAP.

> + *   Flags can be any of:
> + *	* SG_KMAP	 - Use kmap to create the mapping
> + *	* SG_KMAP_ATOMIC - Use kmap_atomic to map the page atommically.
> + *			   Thus, the rules of that function apply: the cpu
> + *			   may not sleep until it is unmaped.
> + *
> + *   Also, consider carefully whether this function is appropriate. It is
> + *   largely not recommended for new code and if the sgl came from another
> + *   subsystem and you don't know what kind of memory might be in the list
> + *   then you definitely should not call it. Non-mappable memory may be in
> + *   the sgl and thus this function may fail unexpectedly.
> + **/
> +static inline void *sg_map_offset(struct scatterlist *sg, size_t offset,
> +				   int flags)

I'd rather have separate functions for kmap vs kmap_atomic instead of
the flags parameter.  And while you're at it just always pass the 0
offset parameter instead of adding a wrapper..

Otherwise this looks good to me.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
