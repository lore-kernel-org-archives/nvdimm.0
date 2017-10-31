Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C47792034AB08
 for <linux-nvdimm@lists.01.org>; Tue, 31 Oct 2017 12:30:47 -0700 (PDT)
Date: Tue, 31 Oct 2017 13:32:25 -0600
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [ndctl patch] btt_check_bitmap: initialize rc
Message-ID: <20171031193225.GC5253@omniknight.lm.intel.com>
References: <x49k1zperpp.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <x49k1zperpp.fsf@segfault.boston.devel.redhat.com>
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: vishal.verma@intel.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 10/20, Jeff Moyer wrote:
> It may be possible that rc is never set before returning from
> the function.  nfree would have to be zero, and the bitmap
> would have to be full.  Fix it.
> 
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

Ah so it shouldn't ever happen in practice, but I can see how a static
checker may complain about it. The patch looks good to me.

Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>

> 
> diff --git a/ndctl/check.c b/ndctl/check.c
> index 915bb9d..dafd6a8 100644
> --- a/ndctl/check.c
> +++ b/ndctl/check.c
> @@ -508,7 +508,7 @@ static int btt_check_bitmap(struct arena_info *a)
>  {
>  	unsigned long *bm;
>  	u32 i, btt_mapping;
> -	int rc;
> +	int rc = BTT_BITMAP_ERROR;
>  
>  	bm = bitmap_alloc(a->internal_nlba);
>  	if (bm == NULL)
> @@ -521,7 +521,6 @@ static int btt_check_bitmap(struct arena_info *a)
>  			info(a->bttc,
>  				"arena %d: internal block %#x is referenced by two map entries\n",
>  				a->num, btt_mapping);
> -			rc = BTT_BITMAP_ERROR;
>  			goto out;
>  		}
>  		bitmap_set(bm, btt_mapping, 1);
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
