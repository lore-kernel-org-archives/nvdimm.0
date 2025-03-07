Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D4A1A8F82
	for <nvdimm@lists.linux.dev>; Fri,  7 Mar 2025 21:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741383831; cv=none; b=AilFveuRqVWLXp37MAmpvmuDWmXg+J7rbx+cpFyEYYie1wAtsbFE0Lu953/R7zbj27I4WjEN12aw/VcmCVHNDB0h20i0WTnYVesaA2KpiIvhQ4oN4IFCAKZgIDarR9jp9u0WT79zZ0bv3N6g8fIbdAw5tlwQu3CsgQxeLYHj9Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741383831; c=relaxed/simple;
	bh=hU9wOMglXK8FHR1q107J+iX5nL81avk9FziuCQK16/w=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=UEeIX8OdAnpcsoOLfk+niiEtM2jKaR/1tIfC8s+2L8hmQ0eKD/uvwVDE0rFzjsiyUSHwccFs37iS/HwRXcjrCIvRNjiHc4LGdWPoTTRI7xClKDMhwUR5UXAg3qUqmX+S1XaOdwqqniKY/HYfpXQwScqakTcw8QhAaMUHdivRSY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UhVNnB9o; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UhVNnB9o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741383830; x=1772919830;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=hU9wOMglXK8FHR1q107J+iX5nL81avk9FziuCQK16/w=;
  b=UhVNnB9oZWtYrAnyI5KMuh9AASWHcXQh8SwThE0MBhJA63/K4FSBgWcR
   rOJk/OE287UvmoVqhQW74kq6C0Y6FKY7lVZDfex4ILin2jCk3iLlFZRGC
   Ti4fNT/vvlNLXYKrH5cRtJXeHDH+EgqH2kHO7S/SXlTtsnQuAZxqC8b3T
   TfADD5tcdUpP2AEwIpEycKQewehUl2n+qdyKNQ1bVIWMuD/2ULQiv1GbV
   dQKDzE6hODiq28SYsUbXp/jeAgPPRZSu+bGOAWwaEpZe8bsbbBA+RiO5O
   p4lnFbXjfyaYwqfD/9gUW+hAtGEsuBYOZql103tv3VD0ZlEDf8cbqBvcs
   Q==;
X-CSE-ConnectionGUID: HPQHTmAkRoaMyb26h7WVBg==
X-CSE-MsgGUID: 8GHE8OHEQImW0sjwZBsBIA==
X-IronPort-AV: E=McAfee;i="6700,10204,11366"; a="42571643"
X-IronPort-AV: E=Sophos;i="6.14,230,1736841600"; 
   d="scan'208";a="42571643"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2025 13:43:50 -0800
X-CSE-ConnectionGUID: pKa4QtsYRGOhGKUoEAuWgw==
X-CSE-MsgGUID: nLfcu+WmS0mTII6sqefaKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,230,1736841600"; 
   d="scan'208";a="119180963"
Received: from jdoman-mobl3.amr.corp.intel.com (HELO [10.125.110.142]) ([10.125.110.142])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2025 13:43:49 -0800
Message-ID: <310683af-cff8-4a71-94a7-b6c61a991bc1@intel.com>
Date: Fri, 7 Mar 2025 14:43:48 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH v2 3/5] ndctl/dimm: do not increment a ULLONG_MAX
 slot value
To: alison.schofield@intel.com, nvdimm@lists.linux.dev
References: <cover.1741304303.git.alison.schofield@intel.com>
 <04880bb53cbd400d9906ca2ac5042a9dc23b925f.1741304303.git.alison.schofield@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <04880bb53cbd400d9906ca2ac5042a9dc23b925f.1741304303.git.alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/6/25 4:50 PM, alison.schofield@intel.com wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> A coverity scan higlighted an overflow issue when the slot variable,
> an unsigned integer that is initialized to -1, is incremented and
> overflows.
> 
> Initialize slot to 0 and increment slot in the for loop header. That
> keeps the comparison to a u32 as is and avoids overflow.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  ndctl/dimm.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/ndctl/dimm.c b/ndctl/dimm.c
> index 889b620355fc..aaa0abfa046c 100644
> --- a/ndctl/dimm.c
> +++ b/ndctl/dimm.c
> @@ -97,7 +97,7 @@ static struct json_object *dump_label_json(struct ndctl_dimm *dimm,
>  	struct json_object *jlabel = NULL;
>  	struct namespace_label nslabel;
>  	unsigned int nsindex_size;
> -	unsigned int slot = -1;
> +	unsigned int slot = 0;
>  	ssize_t offset;
>  
>  	if (!jarray)
> @@ -108,14 +108,13 @@ static struct json_object *dump_label_json(struct ndctl_dimm *dimm,
>  		return NULL;
>  
>  	for (offset = nsindex_size * 2; offset < size;
> -			offset += ndctl_dimm_sizeof_namespace_label(dimm)) {
> +	     offset += ndctl_dimm_sizeof_namespace_label(dimm), slot++) {
>  		ssize_t len = min_t(ssize_t,
>  				ndctl_dimm_sizeof_namespace_label(dimm),
>  				size - offset);
>  		struct json_object *jobj;
>  		char uuid[40];
>  
> -		slot++;
>  		jlabel = json_object_new_object();
>  		if (!jlabel)
>  			break;

