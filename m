Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7297E8
	for <nvdimm@lists.linux.dev>; Fri,  9 Dec 2022 04:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670558940; x=1702094940;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1/zYcSV/SMbQgnbbBHrn4JHR89TJfYNUO6XHr1AbNac=;
  b=A1DYi0KQ7xdfh7Fr4DpoMT3H4MiGhBOtFHvahCIgBivqJxna3YCj/97T
   SRisr2oGrQ1ya0z0SxPO9LIX+/eKrRbC1oojaHmSMpR9//mWmSnxOa9Vf
   OLrEEpGs8imaoqKmOQA2I1ga4dg2dqx788blD9klAutIjdc1QxZWJpz+g
   osBBnlYdwe1rtADGqo+tRzZcMIwDmeCagD6Pk9m7ZkR5QZesONM/Zq9hh
   DGcS50GkQH9G7ljsqMqwWgdnR88WhoQ1cA0ISqogcm9noDcW8xGk/RiJU
   AHxReRqD5No0m6YhtDE2kyVsOYRM/6NmOLdErHzHIQIQF/u7sEuAJ+tAW
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="381681526"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="381681526"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 20:08:59 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="892517663"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="892517663"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.212.199.197])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 20:08:59 -0800
Date: Thu, 8 Dec 2022 20:08:57 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-cxl@vger.kernel.org, vishal.l.verma@intel.com,
	nvdimm@lists.linux.dev
Subject: Re: [ndctl PATCH v2 16/18] cxl/region: Autoselect memdevs for
 create-region
Message-ID: <Y5K02d+nKhySs49Z@aschofie-mobl2>
References: <167053487710.582963.17616889985000817682.stgit@dwillia2-xfh.jf.intel.com>
 <167053497261.582963.1274754281124548404.stgit@dwillia2-xfh.jf.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167053497261.582963.1274754281124548404.stgit@dwillia2-xfh.jf.intel.com>

On Thu, Dec 08, 2022 at 01:29:32PM -0800, Dan Williams wrote:
> Now that parse_create_region() uses cxl_filter_walk() to gather memdevs
> use that as the target list in case no target list is provided. In other
> words the result of "cxl list -M -d $decoder" returns all the potential
> memdevs that can comprise a region under $decoder, so just go ahead and
> try to use that as the target list by default.
> 
> Note though that the order of devices returned by cxl_filter_walk() may
> not be a suitable region creation order. So this porcelain helps for
> simple topologies, but needs a follow-on patch to sort the memdevs by
> valid region order, and/or discover cases where deviceA or deviceB can
> be in the region, but not both.
> 
> Outside of those cases:
> 
>    cxl create-region -d decoderX.Y
> 
> ...is sufficient to create a region.
> 

Reviewed-by: Alison Schofield <alison.schofield@intel.com>

> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  Documentation/cxl/cxl-create-region.txt |   10 ++++++----
>  cxl/region.c                            |   16 ++++++++--------
>  2 files changed, 14 insertions(+), 12 deletions(-)
> 
> diff --git a/Documentation/cxl/cxl-create-region.txt b/Documentation/cxl/cxl-create-region.txt
> index e0e6818cfdd1..286779eff9ed 100644
> --- a/Documentation/cxl/cxl-create-region.txt
> +++ b/Documentation/cxl/cxl-create-region.txt
> @@ -53,16 +53,18 @@ OPTIONS
>  -------
>  <target(s)>::
>  The CXL targets that should be used to form the region. The number of
> -'target' arguments must match the '--ways' option (if provided). The
> -targets are memdev names such as 'mem0', 'mem1' etc.
> +'target' arguments must match the '--ways' option (if provided).
>  
>  include::bus-option.txt[]
>  
>  -m::
>  --memdevs::
>  	Indicate that the non-option arguments for 'target(s)' refer to memdev
> -	names. Currently this is the only option supported, and must be
> -	specified.
> +	device names. If this option is omitted and no targets are specified
> +	then create-region uses the equivalent of 'cxl list -M -d $decoder'
> +	internally as the target list. Note that depending on the topology, for
> +	example with switches, the automatic target list ordering may not be
> +	valid and manual specification of the target list is required.
>  
>  -s::
>  --size=::
> diff --git a/cxl/region.c b/cxl/region.c
> index 286c358f1a34..15cac64a158c 100644
> --- a/cxl/region.c
> +++ b/cxl/region.c
> @@ -269,10 +269,13 @@ static int parse_create_options(struct cxl_ctx *ctx, int count,
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
> @@ -314,11 +317,8 @@ static int parse_create_options(struct cxl_ctx *ctx, int count,
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
