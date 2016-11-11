Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A7E9381E69
 for <linux-nvdimm@lists.01.org>; Fri, 11 Nov 2016 11:41:53 -0800 (PST)
Date: Fri, 11 Nov 2016 12:41:04 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [PATCH v3] libnvdimm: check and clear poison before writing to
 pmem
Message-ID: <20161111194103.GF26806@omniknight.lm.intel.com>
References: <147889305624.162244.5399670205091896834.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <147889305624.162244.5399670205091896834.stgit@djiang5-desk3.ch.intel.com>
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

On 11/11, Dave Jiang wrote:
> We need to clear any poison when we are writing to pmem. The granularity
> will be sector size. If it's less then we can't do anything about it
> barring corruption.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/nvdimm/claim.c |   30 ++++++++++++++++++++++++++----
>  1 file changed, 26 insertions(+), 4 deletions(-)

Looks good!

Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>

> 
> diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
> index d5dc80c..494536c 100644
> --- a/drivers/nvdimm/claim.c
> +++ b/drivers/nvdimm/claim.c
> @@ -226,6 +226,12 @@ static int nsio_rw_bytes(struct nd_namespace_common *ndns,
>  		resource_size_t offset, void *buf, size_t size, int rw)
>  {
>  	struct nd_namespace_io *nsio = to_nd_namespace_io(&ndns->dev);
> +	unsigned int sz_align = ALIGN(size + (offset & (512 - 1)), 512);
> +	sector_t sector = offset >> 9;
> +	int rc = 0;
> +
> +	if (unlikely(!size))
> +		return -EINVAL;
>  
>  	if (unlikely(offset + size > nsio->size)) {
>  		dev_WARN_ONCE(&ndns->dev, 1, "request out of range\n");
> @@ -233,17 +239,33 @@ static int nsio_rw_bytes(struct nd_namespace_common *ndns,
>  	}
>  
>  	if (rw == READ) {
> -		unsigned int sz_align = ALIGN(size + (offset & (512 - 1)), 512);
> -
> -		if (unlikely(is_bad_pmem(&nsio->bb, offset / 512, sz_align)))
> +		if (unlikely(is_bad_pmem(&nsio->bb, sector, sz_align)))
>  			return -EIO;
>  		return memcpy_from_pmem(buf, nsio->addr + offset, size);
>  	} else {
> +
> +		if (unlikely(is_bad_pmem(&nsio->bb, sector, sz_align))) {
> +			if (IS_ALIGNED(offset, 512) && IS_ALIGNED(size, 512)) {
> +				long cleared;
> +
> +				cleared = nvdimm_clear_poison(&ndns->dev,
> +							      offset, size);
> +				if (cleared != size) {
> +					size = cleared;
> +					rc = -EIO;
> +				}
> +
> +				badblocks_clear(&nsio->bb, sector,
> +						cleared >> 9);
> +			} else
> +				rc = -EIO;
> +		}
> +
>  		memcpy_to_pmem(nsio->addr + offset, buf, size);
>  		nvdimm_flush(to_nd_region(ndns->dev.parent));
>  	}
>  
> -	return 0;
> +	return rc;
>  }
>  
>  int devm_nsio_enable(struct device *dev, struct nd_namespace_io *nsio)
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
