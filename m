Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CBB115AD
	for <nvdimm@lists.linux.dev>; Mon,  7 Nov 2022 20:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667853414; x=1699389414;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=EvBJMt5izJ7lXkcPxO7wLj7Ll/WOJCkwBpH8+pZJIsQ=;
  b=TP4S5H1P8rpWQRlZZSbzJwvz46IiHS6uR7f2Dla8hl6QwG5o15Q4zIwW
   GI/2hWih4dNjr2tPLLaXEIWpETk8smnUktr4AdatYICdEaEBZxYI0I0hD
   b4ZzKjyPIQRKYvLLg7L9iUejyjTfqXbF8ThFmoB6gpOw10WjIWPz7YLcI
   VMY8xgIjEVHLSCeP1IVF/0vxx7p2B/H3oRRdp5Fg56FvURhaDT9Pi1dWb
   ian+gicUiHxkZ8/o5yguau9ZpLk9UOgrX/4LutIDGJ9/q6zVl03ihJhjT
   /QlkSS6txrD95+2oEUJr45DwX7x+RK2uHkAVTx8c1JgW+T1qHS8zK1dIa
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="293887149"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="293887149"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 12:36:52 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="638517760"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="638517760"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.100.77])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 12:36:51 -0800
Date: Mon, 7 Nov 2022 12:36:49 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: vishal.l.verma@intel.com, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [ndctl PATCH 13/15] cxl/region: Default to memdev mode for
 create with no arguments
Message-ID: <Y2lsYawI3eQayact@aschofie-mobl2>
References: <166777840496.1238089.5601286140872803173.stgit@dwillia2-xfh.jf.intel.com>
 <166777848122.1238089.2150948506074701593.stgit@dwillia2-xfh.jf.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166777848122.1238089.2150948506074701593.stgit@dwillia2-xfh.jf.intel.com>

On Sun, Nov 06, 2022 at 03:48:01PM -0800, Dan Williams wrote:
> Allow for:
> 
>    cxl create-region -d decoderX.Y
> 
> ...to assume (-m -w $(count of memdevs beneath decoderX.Y))

I'm not understanding what the change is here. Poked around a bit
and still didn't get it. Help!

Leaving out the -m leads to this:
$ cxl create-region -d decoder3.3 mem0 mem1
cxl region: parse_create_options: must specify option for target object types (-m)
cxl region: cmd_create_region: created 0 regions

Leaving out the the -m and the memdevs fails because the memdev order is
not correct. 
$ cxl create-region -d decoder3.3
cxl region: create_region: region5: failed to set target0 to mem1
cxl region: cmd_create_region: created 0 regions

This still works, where I give the -m and the correct order of memdevs.
cxl create-region -m -d decoder3.3 mem0 mem1

> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  cxl/region.c |   16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/cxl/region.c b/cxl/region.c
> index aa0735194fa1..c0cf4ab350da 100644
> --- a/cxl/region.c
> +++ b/cxl/region.c
> @@ -227,10 +227,13 @@ static int parse_create_options(struct cxl_ctx *ctx, int count,
>  	}
>  
>  	/*
> -	 * For all practical purposes, -m is the default target type, but
> -	 * hold off on actively making that decision until a second target
> -	 * option is available.
> +	 * For all practical purposes, -m is the default target type, but hold
> +	 * off on actively making that decision until a second target option is
> +	 * available. Unless there are no arguments then just assume memdevs.
>  	 */
> +	if (!count)
> +		param.memdevs = true;
> +
>  	if (!param.memdevs) {
>  		log_err(&rl,
>  			"must specify option for target object types (-m)\n");
> @@ -272,11 +275,8 @@ static int parse_create_options(struct cxl_ctx *ctx, int count,
>  		p->ways = count;
>  		if (!validate_ways(p, count))
>  			return -EINVAL;
> -	} else {
> -		log_err(&rl,
> -			"couldn't determine interleave ways from options or arguments\n");
> -		return -EINVAL;
> -	}
> +	} else
> +		p->ways = p->num_memdevs;
>  
>  	if (param.granularity < INT_MAX) {
>  		if (param.granularity <= 0) {
> 
