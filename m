Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EBED721E70D23
 for <linux-nvdimm@lists.01.org>; Tue, 29 Aug 2017 15:49:31 -0700 (PDT)
Date: Tue, 29 Aug 2017 16:50:06 -0600
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [PATCH] libnvdimm, btt: check memory allocation failure
Message-ID: <20170829225006.GB16374@omniknight.lm.intel.com>
References: <20170827063034.4802-1-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170827063034.4802-1-christophe.jaillet@wanadoo.fr>
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
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 08/27, Christophe JAILLET wrote:
> Check memory allocation failures and return -ENOMEM in such cases, as
> already done few lines below for another memory allocation.
> 
> This avoids NULL pointers dereference.
> 
> Fixes: 14e494542636 ("libnvdimm, btt: BTT updates for UEFI 2.7 format")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/nvdimm/btt.c | 2 ++
>  1 file changed, 2 insertions(+)

Looks good, thank you.
Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>

> 
> diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
> index 60491641a8d6..607184ebcfbf 100644
> --- a/drivers/nvdimm/btt.c
> +++ b/drivers/nvdimm/btt.c
> @@ -1431,6 +1431,8 @@ int nvdimm_namespace_attach_btt(struct nd_namespace_common *ndns)
>  	}
>  
>  	btt_sb = devm_kzalloc(&nd_btt->dev, sizeof(*btt_sb), GFP_KERNEL);
> +	if (!btt_sb)
> +		return -ENOMEM;
>  
>  	/*
>  	 * If this returns < 0, that is ok as it just means there wasn't
> -- 
> 2.11.0
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
