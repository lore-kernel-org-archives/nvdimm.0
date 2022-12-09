Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9197963C5
	for <nvdimm@lists.linux.dev>; Fri,  9 Dec 2022 17:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670607070; x=1702143070;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yfud0huBpFkFfK81UcoRpbIUlLAjoGz0cGt/RQa8v9I=;
  b=l0HqgXMlByVe0zNPsJZkqlidEJrtRZqB3oZO2swNyMeBiUhdq075xeMI
   PZyyMwO2BOanUGvf/r/9bhOiDlZuIf3Aimixb1eHbV8Lvvmy+G0kBfoKE
   qIJmldoemGyXF3cfFJ1VI2GSPnd1+AxTsB3tPV6U93VhXrHVL+RwKAz8c
   F1XvyZZkF+p43NlNdLYBNc1hKdlV6+LeVf9dPle9qWgAD1hnh+xvtxxIk
   F4fl/mL82NQKUaPxR0Ij2PUyMmNKL4VPWteMx2NTDAwYE10SOX+9f5+KZ
   ZEv1Xfx0RhVkchCRFJ+d/heLAiVJSIjpDfIBQ6YfSyU4Ru2Zy4D7fC0Y5
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10556"; a="344546353"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="344546353"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2022 09:31:09 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10556"; a="736280557"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="736280557"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.212.227.125])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2022 09:31:09 -0800
Date: Fri, 9 Dec 2022 09:31:07 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-cxl@vger.kernel.org, vishal.l.verma@intel.com,
	nvdimm@lists.linux.dev
Subject: Re: [ndctl PATCH v2 14/18] cxl/region: Trim region size by max
 available extent
Message-ID: <Y5Nw2z/u+OFG/nFd@aschofie-mobl2>
References: <167053487710.582963.17616889985000817682.stgit@dwillia2-xfh.jf.intel.com>
 <167053496075.582963.15276731392463349632.stgit@dwillia2-xfh.jf.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167053496075.582963.15276731392463349632.stgit@dwillia2-xfh.jf.intel.com>

On Thu, Dec 08, 2022 at 01:29:20PM -0800, Dan Williams wrote:
> When a size is not specified, limit the size to either the available DPA
> capacity, or the max available extent in the root decoder, whichever is
> smaller.

Reviewed-by: Alison Schofield <alison.schofield@intel.com>
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  cxl/region.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/cxl/region.c b/cxl/region.c
> index 36ebc8e5210f..286c358f1a34 100644
> --- a/cxl/region.c
> +++ b/cxl/region.c
> @@ -544,6 +544,7 @@ static int create_region(struct cxl_ctx *ctx, int *count,
>  	unsigned long flags = UTIL_JSON_TARGETS;
>  	struct json_object *jregion;
>  	struct cxl_region *region;
> +	bool default_size = true;
>  	int i, rc, granularity;
>  	u64 size, max_extent;
>  	const char *devname;
> @@ -555,6 +556,7 @@ static int create_region(struct cxl_ctx *ctx, int *count,
>  
>  	if (p->size) {
>  		size = p->size;
> +		default_size = false;
>  	} else if (p->ep_min_size) {
>  		size = p->ep_min_size * p->ways;
>  	} else {
> @@ -567,13 +569,16 @@ static int create_region(struct cxl_ctx *ctx, int *count,
>  			cxl_decoder_get_devname(p->root_decoder));
>  		return -EINVAL;
>  	}
> -	if (size > max_extent) {
> +	if (!default_size && size > max_extent) {
>  		log_err(&rl,
>  			"%s: region size %#lx exceeds max available space\n",
>  			cxl_decoder_get_devname(p->root_decoder), size);
>  		return -ENOSPC;
>  	}
>  
> +	if (size > max_extent)
> +		size = ALIGN_DOWN(max_extent, SZ_256M * p->ways);
> +
>  	if (p->mode == CXL_DECODER_MODE_PMEM) {
>  		region = cxl_decoder_create_pmem_region(p->root_decoder);
>  		if (!region) {
> 
