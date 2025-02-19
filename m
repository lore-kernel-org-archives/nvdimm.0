Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30BCF1C173F
	for <nvdimm@lists.linux.dev>; Wed, 19 Feb 2025 18:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739988308; cv=none; b=Hm3zvoIHJa3cUZcgqMDIoDndUWBS4Zj9XLL51ZntT0ncaoXp4Gj25aPhuqBRjVeUbId15yLvxOav+9Ib5mYec5JsRaSz3Ul8aQ9WyyVqSw0v3M3JI59dm6trlaUYliW0rQnjMfkuChkyIOfiMqvufdNSBbgu08EQMH3FGRos+rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739988308; c=relaxed/simple;
	bh=xN+VCr9m1HikHO+6traRWpEGsIK9XHZqGyxMy7j+XPQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dXYsOqb2m3YIXfMeqtKs2mokhkBS01tewmKEoWaB23I6SBvbThNGg/Ml7QHTfNkixQ74XQrY6GO3y1pANzn+SwunKBQAfGjCtqkdzEMWRwPuQp51YVnQx4cKIWNSbWi20P61x3AC1SyJFp9ylCVeS+tPcyJSgMu1f0Gg+nFC6L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jmF2++hn; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jmF2++hn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739988308; x=1771524308;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xN+VCr9m1HikHO+6traRWpEGsIK9XHZqGyxMy7j+XPQ=;
  b=jmF2++hnYjHkrisWHHP6scwI101HN43F/6jSQrejnb+Nf8hvoAeqJavj
   Zeu/wEP3zgOAtF45gygO9lvOff1VlbxDBO+EtRDZSMbItAYGMhGPWIcED
   PGGVQ/LxEzFRxcenRkCG1yonrWLAnG9sL+3l6iPUqfpwTFbvYbi2xIGIT
   TmcxEs/53qGfrKpQwp/sAOCJRSijibaW93nrSf6P4ESqOkYe7RiUjuiNa
   FSoH2TM/MiINhgIQTneCwaFMm+1PXWmVtGp8x2XpG2FOvW/rpQeH+5Mb1
   6Chj6kMmVc7ZXCUJKgL6ekce0dSHQ8T4rfVbOdWIJZk/EgnBYbaKfDnu7
   w==;
X-CSE-ConnectionGUID: GX6VrR3OQQK/6uMj4Yqksw==
X-CSE-MsgGUID: TvZUz+ILTLucxp23r9rM5A==
X-IronPort-AV: E=McAfee;i="6700,10204,11350"; a="50954985"
X-IronPort-AV: E=Sophos;i="6.13,299,1732608000"; 
   d="scan'208";a="50954985"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2025 10:05:07 -0800
X-CSE-ConnectionGUID: fDyEaJUmTja90HVjyAc/MQ==
X-CSE-MsgGUID: zIJyB5m9SIOivYQZ7nbuug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="119411261"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2.lan) ([10.125.110.15])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2025 09:10:59 -0800
Date: Wed, 19 Feb 2025 09:10:53 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Donet Tom <donettom@linux.ibm.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Li Zhijian <lizhijian@fujitsu.com>, Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] ndctl: json: Region capabilities are not displayed if
 any of the BTT, PFN, or DAX are not present
Message-ID: <Z7YQnXuIMcw-wPMg@aschofie-mobl2.lan>
References: <20250219094049.5156-1-donettom@linux.ibm.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250219094049.5156-1-donettom@linux.ibm.com>

On Wed, Feb 19, 2025 at 03:40:49AM -0600, Donet Tom wrote:


Thanks Tom!

Please v2 with patch prefix and commit msg of:
[ndctl PATCH v2] ndctl/list: display region caps for any of BTT, PFN, DAX


> If any one of BTT, PFN, or DAX is not present, but the other two
> are, then the region capabilities are not displayed in the
> ndctl list -R -C command.
> 
> This is because util_region_capabilities_to_json() returns NULL
> if any one of BTT, PFN, or DAX is not present.
> 
> In this patch, we have changed the logic to display all the region
> capabilities that are present.
> 
> Test Results with CONFIG_BTT disabled
> =====================================
> Without this patch
> ------------------
>  # ./build/ndctl/ndctl  list -R -C
>  [
>   {
>     "dev":"region1",
>     "size":549755813888,
>     "align":16777216,
>     "available_size":549755813888,
>     "max_available_extent":549755813888,
>     "type":"pmem",
>     "iset_id":11510624209454722969,
>     "persistence_domain":"memory_controller"
>   },
> 
> With this patch
> ---------------
>  # ./build/ndctl/ndctl  list -R -C
>  [
>   {
>     "dev":"region1",
>     "size":549755813888,
>     "align":16777216,
>     "available_size":549755813888,
>     "max_available_extent":549755813888,
>     "type":"pmem",
>     "iset_id":11510624209454722969,
>     "capabilities":[
>       {
>         "mode":"fsdax",
>         "alignments":[
>           65536,
>           16777216
>         ]
>       },
>       {
>         "mode":"devdax",
>         "alignments":[
>           65536,
>           16777216
>         ]
>       }
>     ],
>     "persistence_domain":"memory_controller"
>   },
> 

Please add a formatted fixes tag.
Double check, but I believe this was introduced with commit 965fa02e372f,
util: Distribute 'filter' and 'json' helpers to per-tool objects
It seems we broke it in ndctl release v73.


> Signed-off-by: Donet Tom <donettom@linux.ibm.com>
> ---
>  ndctl/json.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/ndctl/json.c b/ndctl/json.c
> index 23bad7f..3df3bc4 100644
> --- a/ndctl/json.c
> +++ b/ndctl/json.c
> @@ -381,9 +381,6 @@ struct json_object *util_region_capabilities_to_json(struct ndctl_region *region
>  	struct ndctl_pfn *pfn = ndctl_region_get_pfn_seed(region);
>  	struct ndctl_dax *dax = ndctl_region_get_dax_seed(region);
>  
> -	if (!btt || !pfn || !dax)
> -		return NULL;
> -

How about a one line change that avoids getting the jcaps array
needlessly:

	if (!btt && !pfn && !dax)
		return NULL;

>  	jcaps = json_object_new_array();
>  	if (!jcaps)
>  		return NULL;
> @@ -436,7 +433,8 @@ struct json_object *util_region_capabilities_to_json(struct ndctl_region *region
>  		json_object_object_add(jcap, "alignments", jobj);
>  	}
>  
> -	return jcaps;
> +	if (btt || pfn || dax)
> +		return jcaps;
>  err:
>  	json_object_put(jcaps);
>  	return NULL;
> -- 
> 2.43.5
> 
