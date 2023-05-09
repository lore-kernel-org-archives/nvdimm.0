Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B9B17ADB
	for <nvdimm@lists.linux.dev>; Tue,  9 May 2023 17:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683653621; x=1715189621;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=acyJmam4GLAlrg1eXjx3+Yd/8EeA4Ra0u9gObckkIp0=;
  b=a7nX66+6ZpEVmm9EEkJWNKZmolSLWaoB4mfYvN1foy2ykdcjflYq/ua9
   Ns/+vXD/11Etpa3NV4sVvJVvfRW1lO2wkdS3LR+7EGokMXpjXt/PAe4Ql
   gUAIlT4QZg167XwXGSkbgd+Evn4ac/c+p6mOQ13ZQunXJficDNT0Dst8q
   L5hwS87nlw78Rt+3WfxLOGneuQ5jc98RK++DvTt/F1ifGOfM4XPa1ZN67
   nI1QA5eQSFqndEkhaZuVqiwgCyLZCjvlalBkbRT5UFgCBNif8LnLCOG9B
   ckf00i83yiVnx9yOkPXHXGI3TDGW7IWp3HJ/noeP6bEWPdYmCAD9+2B+F
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="353066473"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="353066473"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 10:33:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="731825198"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="731825198"
Received: from dcovax-mobl.amr.corp.intel.com (HELO [10.212.97.226]) ([10.212.97.226])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 10:33:28 -0700
Message-ID: <dd2b7ea6-ee1d-9c49-0dc0-311269f786e6@intel.com>
Date: Tue, 9 May 2023 10:33:27 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [ndctl PATCH 3/3] cxl: fix changed function name in a comment
Content-Language: en-US
To: Minwoo Im <minwoo.im.dev@gmail.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev
Cc: Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>
References: <20230509152427.6920-1-minwoo.im.dev@gmail.com>
 <20230509152427.6920-4-minwoo.im.dev@gmail.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20230509152427.6920-4-minwoo.im.dev@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/9/23 8:24 AM, Minwoo Im wrote:
> cxl_memdev_target_find_decoder() has been renamed to
> cxl_memdev_find_decoder in Commit 21b089025178 ("cxl: add a
> 'create-region' command").  Fix function name in a comment.
> 
> Signed-off-by: Minwoo Im <minwoo.im.dev@gmail.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>   cxl/region.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/cxl/region.c b/cxl/region.c
> index 71f152d9e5a5..45f0c6a3771c 100644
> --- a/cxl/region.c
> +++ b/cxl/region.c
> @@ -676,7 +676,7 @@ static int create_region(struct cxl_ctx *ctx, int *count,
>   		}
>   		if (cxl_decoder_get_mode(ep_decoder) != p->mode) {
>   			/*
> -			 * The memdev_target_find_decoder() helper returns a free
> +			 * The cxl_memdev_find_decoder() helper returns a free
>   			 * decoder whose size has been checked for 0.
>   			 * Thus it is safe to change the mode here if needed.
>   			 */
