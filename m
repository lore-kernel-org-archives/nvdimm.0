Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 530F481C8D
 for <linux-nvdimm@lists.01.org>; Wed,  9 Nov 2016 16:14:56 -0800 (PST)
Date: Wed, 9 Nov 2016 17:14:06 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [PATCH] libnvdimm: check and clear poison before writing to pmem
Message-ID: <20161110001405.GA26806@omniknight.lm.intel.com>
References: <147873364251.45471.9613527969861188296.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <147873364251.45471.9613527969861188296.stgit@djiang5-desk3.ch.intel.com>
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
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 11/09, Dave Jiang wrote:
> We need to clear any poison when we are writing to pmem. The granularity
> will be sector size. If it's less then we can't do anything about it
> barring corruption.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/nvdimm/claim.c |   20 ++++++++++++++++++--
>  1 file changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
> index d5dc80c..2078d25 100644
> --- a/drivers/nvdimm/claim.c
> +++ b/drivers/nvdimm/claim.c
> @@ -226,6 +226,7 @@ static int nsio_rw_bytes(struct nd_namespace_common *ndns,
>  		resource_size_t offset, void *buf, size_t size, int rw)
>  {
>  	struct nd_namespace_io *nsio = to_nd_namespace_io(&ndns->dev);
> +	unsigned int sz_align = ALIGN(size + (offset & (512 - 1)), 512);
>  
>  	if (unlikely(offset + size > nsio->size)) {
>  		dev_WARN_ONCE(&ndns->dev, 1, "request out of range\n");
> @@ -233,12 +234,27 @@ static int nsio_rw_bytes(struct nd_namespace_common *ndns,
>  	}
>  
>  	if (rw == READ) {
> -		unsigned int sz_align = ALIGN(size + (offset & (512 - 1)), 512);
> -
>  		if (unlikely(is_bad_pmem(&nsio->bb, offset / 512, sz_align)))
>  			return -EIO;
>  		return memcpy_from_pmem(buf, nsio->addr + offset, size);
>  	} else {
> +		sector_t sector = offset / 512;

Small nit, but if you move the above line to the top of the function,
you can reuse 'sector' int he rw == READ case's is_bad_pmem call too,
making it read the same as the one below.

> +
> +		if (unlikely(is_bad_pmem(&nsio->bb, sector, sz_align))) {
> +			if (IS_ALIGNED(offset, 512) &&
> +			    IS_ALIGNED(size, 512) && (size >= 512)) {

Having the size >= 512 check here feels a bit odd.. If you can refactor
this to have something near the top to simply exit out for size == 0
(that should never happen anyway), then you can simply remove this last
part of the condition. If size > 0, and if it is aligned to 512
automatically implies it will at least be 512.

> +				int rc;
> +
> +				rc = nvdimm_clear_poison(&ndns->dev, offset,
> +							 size);

nvdimm_clear_poison returns a long, rc is an int.. While at it, since
this is the only palce where 'rc' is being used, perhaps rename it to
something like 'cleared' (like in pmem_clear_poison), so that the usage
is better described.

> +				if (rc != size)
> +					return -EIO;

I'm not sure of this myself - perhaps a question to Dan - 
Is it safe to return EIO here? We have potentially cleared some poison,
and lost some data, but subsequent reads will not indicate any errors,
returning either 0s or something unpredictable. Would it be better to
simply go ahead with the write even if we weren't able to clear the
whole range?

> +
> +				badblocks_clear(&nsio->bb, sector, rc / 512);
> +			} else
> +				return -EIO;
> +		}
> +
>  		memcpy_to_pmem(nsio->addr + offset, buf, size);
>  		nvdimm_flush(to_nd_region(ndns->dev.parent));
>  	}
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
