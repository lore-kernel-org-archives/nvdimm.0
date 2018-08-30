Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9A13B21107857
 for <linux-nvdimm@lists.01.org>; Thu, 30 Aug 2018 14:46:20 -0700 (PDT)
Subject: Re: [PATCH v1] libnvdimm, label: Switch to bitmap_zalloc()
References: <20180830103207.60669-1-andriy.shevchenko@linux.intel.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <c944d328-532f-c7b4-2a54-0c865e3b3e70@intel.com>
Date: Thu, 30 Aug 2018 14:46:19 -0700
MIME-Version: 1.0
In-Reply-To: <20180830103207.60669-1-andriy.shevchenko@linux.intel.com>
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
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <zwisler@kernel.org>, linux-nvdimm@lists.01.org, Vishal Verma <vishal.l.verma@intel.com>
List-ID: <linux-nvdimm@lists.01.org>



On 08/30/2018 03:32 AM, Andy Shevchenko wrote:
> Switch to bitmap_zalloc() to show clearly what we are allocating.
> Besides that it returns pointer of bitmap type instead of opaque void *.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Applied

> ---
>  drivers/nvdimm/label.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index 1d28cd656536..53159262c85d 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c
> @@ -814,8 +814,7 @@ static int __blk_label_update(struct nd_region *nd_region,
>  	victims = 0;
>  	if (old_num_resources) {
>  		/* convert old local-label-map to dimm-slot victim-map */
> -		victim_map = kcalloc(BITS_TO_LONGS(nslot), sizeof(long),
> -				GFP_KERNEL);
> +		victim_map = bitmap_zalloc(nslot, GFP_KERNEL);
>  		if (!victim_map)
>  			return -ENOMEM;
>  
> @@ -838,7 +837,7 @@ static int __blk_label_update(struct nd_region *nd_region,
>  	/* don't allow updates that consume the last label */
>  	if (nfree - alloc < 0 || nfree - alloc + victims < 1) {
>  		dev_info(&nsblk->common.dev, "insufficient label space\n");
> -		kfree(victim_map);
> +		bitmap_free(victim_map);
>  		return -ENOSPC;
>  	}
>  	/* from here on we need to abort on error */
> @@ -1010,7 +1009,7 @@ static int __blk_label_update(struct nd_region *nd_region,
>  
>   out:
>  	kfree(old_res_list);
> -	kfree(victim_map);
> +	bitmap_free(victim_map);
>  	return rc;
>  
>   abort:
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
