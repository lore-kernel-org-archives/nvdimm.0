Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A565190472
	for <nvdimm@lists.linux.dev>; Wed,  5 Mar 2025 16:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741192717; cv=none; b=E/CH5RPCgHgOrudic8NlO/BR/ml+t2EsuUHvjx2DHHBxIF7n7Y7nWeMY3X7cumeQLPc4vH2+iJ6EkLe0nAaac74CO8NUqLApLLgmGTqtpo9N3bEoPqSkQowxBAWNHHn6ML3MRMU177XkQm7WMHF/masXj/iH0y/aVdbOImiyxDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741192717; c=relaxed/simple;
	bh=phAK0lMH78GJaC2IjYo+RkEz+vCWxko0RIWyB/xAWtk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Yt4RVIG+m9IQj3KJYL+ROlZcyWwlNUbcEYDzfNI83I294e3qHW90ZqF5RUkeedRW8G4ouHvBS78P55mPNANgS+oT2SUIyCzwrNxN4UoJQXAMH10KEQA/2oVS2rUf5BJhmFlkISrQ9o5V67nh/GBsewGrXw7PtETtbZWbMIxikRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cb9oKbDn; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cb9oKbDn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741192716; x=1772728716;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=phAK0lMH78GJaC2IjYo+RkEz+vCWxko0RIWyB/xAWtk=;
  b=cb9oKbDnyy1ZkOBkE3Z2ouE6IFchLSDcgoIeg0XglL3WoMMsTxOVnzEd
   JBhgaTwMYgYejLf7Bgo5QG5Mpe9OLNVO76CTaVkElI0qGs45wgaEHjgWh
   WIpTHf/5q1e8bGBJs+xKt2KCWRNBCqew2AR6z1s0QKuG5ihDNI7ZprG33
   XUWfW7tj8xVsH1rbnE0bUkIEHrMHv/Of0+NixPISnqINNjaI/hqTsY+QE
   WhzyFhZRpXfSeZ86uGaVIXAdfUziTp7Q6pI1AnVrgJRzznLI4KjfW49j9
   FcOKrtHPak5TFhmsx3X8uY3i0GnCqSWL8jtKz/6LTtt93kL5jqJekPXS4
   A==;
X-CSE-ConnectionGUID: yHU7nRskTEWQl1oWXZeNqg==
X-CSE-MsgGUID: 97YxsBW/RwWa2xgita7W0g==
X-IronPort-AV: E=McAfee;i="6700,10204,11363"; a="42295618"
X-IronPort-AV: E=Sophos;i="6.14,223,1736841600"; 
   d="scan'208";a="42295618"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2025 08:38:36 -0800
X-CSE-ConnectionGUID: yIwPLw0TRVWrf1J4q0OKVg==
X-CSE-MsgGUID: JPKzeVJfQl+rLFZWzCVymg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,223,1736841600"; 
   d="scan'208";a="119246366"
Received: from dnelso2-mobl.amr.corp.intel.com (HELO [10.125.109.222]) ([10.125.109.222])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2025 08:38:34 -0800
Message-ID: <45c58eac-422d-4c19-ac2a-483eabb8579a@intel.com>
Date: Wed, 5 Mar 2025 09:38:31 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH 3/5] ndctl/dimm: do not increment a ULLONG_MAX slot
 value
To: alison.schofield@intel.com, nvdimm@lists.linux.dev
References: <cover.1741047738.git.alison.schofield@intel.com>
 <6f3f15b368b1d2708f93f00325e009747425cef0.1741047738.git.alison.schofield@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <6f3f15b368b1d2708f93f00325e009747425cef0.1741047738.git.alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/3/25 5:37 PM, alison.schofield@intel.com wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> A coverity scan higlighted an overflow issue when the slot variable,
> an unsigned integer that is initialized to -1, is incremented and
> overflows.
> 
> Initialize slot to 0 and move the increment statement to after slot
> is evaluated. That keeps the comparison to a u32 as is and avoids
> overflow.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
>  ndctl/dimm.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/ndctl/dimm.c b/ndctl/dimm.c
> index 889b620355fc..c39c69bfa336 100644
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
> @@ -115,7 +115,6 @@ static struct json_object *dump_label_json(struct ndctl_dimm *dimm,
>  		struct json_object *jobj;
>  		char uuid[40];
>  
> -		slot++;
>  		jlabel = json_object_new_object();
>  		if (!jlabel)
>  			break;
> @@ -127,8 +126,11 @@ static struct json_object *dump_label_json(struct ndctl_dimm *dimm,
>  		if (len < 0)
>  			break;
>  
> -		if (le32_to_cpu(nslabel.slot) != slot)
> +		if (le32_to_cpu(nslabel.slot) != slot) {
> +			slot++;
>  			continue;
> +		}
> +		slot++;

Wonder if you can just increment the slot in the for() since it's not being used after this. 

>  
>  		uuid_unparse((void *) nslabel.uuid, uuid);
>  		jobj = json_object_new_string(uuid);

