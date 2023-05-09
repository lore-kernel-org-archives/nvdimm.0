Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE6C17FE0
	for <nvdimm@lists.linux.dev>; Tue,  9 May 2023 17:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683653600; x=1715189600;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=w8AipMO1U9LQYAAbXPzQrMRS5siZPMtjqe8kugTALQI=;
  b=hEQuaO7Q1yyqlQLhsFJzNyGS8sps96/MvxeLXQZWORsmnMyX8EQwSgmx
   ze6O0UaodqXdHVTSXnyw8JuiCwrA7gAp7CsERsxKBnCJm+s441FIJLiCn
   VnxV7Y2zm1Xf2aVNpGdYmjr6XMQWQRD5QM/4X8a75f9x5u/xzuZrSckcm
   N6E2nRrP8uKC0s//dwKfMxbGaww8y2llqnuaarV5KM1UfwiJYEYJl/IOk
   taXZHQBirD4Gg07xHvaVzgE5CNoLr970sJuLB4pyzOknxfu8so65hALfb
   U5m0WEJgsrcAIqAjtpGSL64+fiU3Rshrs8siOLR/GDujoun9HEF75nT/F
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="353066127"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="353066127"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 10:32:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="731824726"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="731824726"
Received: from dcovax-mobl.amr.corp.intel.com (HELO [10.212.97.226]) ([10.212.97.226])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 10:32:31 -0700
Message-ID: <fa12c7b5-100b-161b-b36d-8aa0b342c24e@intel.com>
Date: Tue, 9 May 2023 10:32:30 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [ndctl PATCH 2/3] cxl: region: remove redundant func name from
 error
Content-Language: en-US
To: Minwoo Im <minwoo.im.dev@gmail.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev
Cc: Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>
References: <20230509152427.6920-1-minwoo.im.dev@gmail.com>
 <20230509152427.6920-3-minwoo.im.dev@gmail.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20230509152427.6920-3-minwoo.im.dev@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/9/23 8:24 AM, Minwoo Im wrote:
> If user does not provide `-s, --size` option and there's no ep_min_size
> configured, it prints error log like the following.  This patch removes
> redundant repeated function name from the log.
> 
> Before:
> 
>    root@vm:~/work# cxl create-region -m -d decoder0.0 -w 1 -g 1024 mem0
>    cxl region: create_region: create_region: unable to determine region size
>    cxl region: cmd_create_region: created 0 regions
> 
> After:
>    root@vm:~/work# cxl create-region -m -d decoder0.0 -w 1 -g 1024 mem0
>    cxl region: create_region: unable to determine region size
>    cxl region: cmd_create_region: created 0 regions
> 
> Signed-off-by: Minwoo Im <minwoo.im.dev@gmail.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>   cxl/region.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/cxl/region.c b/cxl/region.c
> index 07ce4a319fd0..71f152d9e5a5 100644
> --- a/cxl/region.c
> +++ b/cxl/region.c
> @@ -607,7 +607,8 @@ static int create_region(struct cxl_ctx *ctx, int *count,
>   	} else if (p->ep_min_size) {
>   		size = p->ep_min_size * p->ways;
>   	} else {
> -		log_err(&rl, "%s: unable to determine region size\n", __func__);
> +		log_err(&rl, "unable to determine region size\n");
> +
>   		return -ENXIO;
>   	}
>   	max_extent = cxl_decoder_get_max_available_extent(p->root_decoder);
