Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6ADA257B
	for <nvdimm@lists.linux.dev>; Mon, 25 Apr 2022 15:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650899343; x=1682435343;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wQnjSWMkT1Rr15X7pNbO5/y1mdqNp9x3OoIAYE6/qS0=;
  b=gKOw274faZ4WYG7DQL8kSHW5rWw5VU57DXKqjrX37RvAQqcksmEPTqBn
   4D74PMtZJsbjWICPWbWbiVv1fEytAE+w/J6hu0nL5l3SxF4ZQ/1+BJ8/P
   d7bbI7Ia87tZxmDpHuwDxjllpChv4VF2Ww2jwa/1aj9ctclsGpqCLipZL
   1UqapTM22doV+dZ3hCNXN0wOsq7tAvvrJHty8T3ivZiEQHBno9Bc/BcmI
   7RCTLrSjnUiYVJJQ11lUy3bx05pmwZBC+/Dqg2/ujVUVNQazvcLWSsu+j
   xiZRw/wAVTwrd0fLj9wdHZkK3kv2Ogb/szHipVyFbWQ4Eisn7kW0UH2pz
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10328"; a="264122583"
X-IronPort-AV: E=Sophos;i="5.90,288,1643702400"; 
   d="scan'208";a="264122583"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2022 08:07:44 -0700
X-IronPort-AV: E=Sophos;i="5.90,288,1643702400"; 
   d="scan'208";a="729779664"
Received: from hungyuan-mobl.amr.corp.intel.com (HELO localhost) ([10.212.88.155])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2022 08:07:43 -0700
Date: Mon, 25 Apr 2022 08:07:43 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: cgel.zte@gmail.com
Cc: dan.j.williams@intel.com, vishal.l.verma@intel.com,
	dave.jiang@intel.com, ran.jianping@zte.com.cn, jane.chu@oracle.com,
	rafael.j.wysocki@intel.com, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH] tools/testing/nvdimm: remove unneeded flush_workqueue
Message-ID: <Yma5P3b7HceTyUD6@iweiny-desk3>
References: <20220424062655.3221152-1-ran.jianping@zte.com.cn>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220424062655.3221152-1-ran.jianping@zte.com.cn>

On Sun, Apr 24, 2022 at 06:26:55AM +0000, cgel.zte@gmail.com wrote:
> From: ran jianping <ran.jianping@zte.com.cn>
> 
> All work currently pending will be done first by calling destroy_workqueue,
> so there is no need to flush it explicitly.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: ran jianping <ran.jianping@zte.com.cn>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> ---
>  tools/testing/nvdimm/test/nfit.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
> index 1da76ccde448..e7e1a640e482 100644
> --- a/tools/testing/nvdimm/test/nfit.c
> +++ b/tools/testing/nvdimm/test/nfit.c
> @@ -3375,7 +3375,6 @@ static __exit void nfit_test_exit(void)
>  {
>  	int i;
>  
> -	flush_workqueue(nfit_wq);
>  	destroy_workqueue(nfit_wq);
>  	for (i = 0; i < NUM_NFITS; i++)
>  		platform_device_unregister(&instances[i]->pdev);
> -- 
> 2.25.1
> 
