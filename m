Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A3F4721954060
 for <linux-nvdimm@lists.01.org>; Tue, 25 Apr 2017 14:45:44 -0700 (PDT)
Date: Tue, 25 Apr 2017 15:44:22 -0600
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [PATCH] libnvdimm: fix phys_addr for nvdimm_clear_poison
Message-ID: <20170425214422.GB15722@omniknight.lm.intel.com>
References: <20170425211651.7640-1-toshi.kani@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170425211651.7640-1-toshi.kani@hpe.com>
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
To: Toshi Kani <toshi.kani@hpe.com>
Cc: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 04/25, Toshi Kani wrote:
> nvdimm_clear_poison() expects a physical address, not an offset.
> Fix nsio_rw_bytes() to call nvdimm_clear_poison() with a physical
> address.

Good catch!

> 
> Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  drivers/nvdimm/claim.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
> index ca6d572..0b31073 100644
> --- a/drivers/nvdimm/claim.c
> +++ b/drivers/nvdimm/claim.c
> @@ -254,7 +254,8 @@ static int nsio_rw_bytes(struct nd_namespace_common *ndns,
>  				&& (!ndns->claim || !is_nd_btt(ndns->claim))) {
>  			long cleared;
>  
> -			cleared = nvdimm_clear_poison(&ndns->dev, offset, size);
> +			cleared = nvdimm_clear_poison(&ndns->dev,
> +					nsio->res.start + offset, size);

Should we be using nsio->res.start here or nsio->addr ?

>  			if (cleared < size)
>  				rc = -EIO;
>  			if (cleared > 0 && cleared / 512) {
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
