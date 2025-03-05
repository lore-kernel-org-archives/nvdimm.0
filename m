Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B1BBA27
	for <nvdimm@lists.linux.dev>; Wed,  5 Mar 2025 16:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741192339; cv=none; b=bFCgzbHc3paul1HWx7DJoAECZSxoSn7LTK84Zj+poVlc6JBlq2dziXXkV4up5v4VjhOycmS7BD1w2x/bF6uif6TwyDHpfmiFtKMsvcusDCD7wYGgWi7VYrGjJs/vpyGgkqUrIrET4RHdNsbl0NItsyvNu/qINKlLh2clu4uLQ7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741192339; c=relaxed/simple;
	bh=DBkDjt2emHJi1nK0stNuduG6UOfV8tJH0i3BAy/rbFo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=VVS9q4bQX/UjPFxbZDmSs+dp5OuDxATh+J8Fd3Uy6AA4FbrW+P4+XeeHmn0KJtw5trXGbLEo31k5RaHjuzFf1EsW2APwuyHyLxbP/5nlfHvKBd9fKb75ujn/1gWPRBVKpkJ4/T9mzh8xG+ZgYolSejxGUmr8KH5+vUbssKzGD3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ze1IqA3U; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ze1IqA3U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741192338; x=1772728338;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=DBkDjt2emHJi1nK0stNuduG6UOfV8tJH0i3BAy/rbFo=;
  b=Ze1IqA3UuABr5VDy35yBpgwy6wsJS4Ypzqk7xRvQhXc9v28Co3mr2sxo
   t7VaU5xmfZdp9VQWzwOUm4ihyQSS+64tfrdbEXGAoawbXVPfMaY63LnKO
   AdqoCZ+gQZ9QR1xJruPr0cGngB1WgbVDDiRJsx9XID3aSEMFUaZD3Mwvy
   ziax+o5TCHn7otrLrolrluI9gwiZ6zIm4O2wWNZkMCgw7TnxqGuvf/GDa
   Ol1+3ulpp9pPY90D1UtQxg8dwTq+9dvSXi7uuXWSPkm/9iUNPVZcmi0zB
   bgssh0kg8fso7Ie1t/qwK+zVbVT4IB9519HCwP4WM3rolIFNFau95xNzh
   w==;
X-CSE-ConnectionGUID: gJ3PhYm6QiuOtvVoahwdog==
X-CSE-MsgGUID: w6+k+gldSXS2Jo8y4Re5GA==
X-IronPort-AV: E=McAfee;i="6700,10204,11363"; a="42188890"
X-IronPort-AV: E=Sophos;i="6.14,223,1736841600"; 
   d="scan'208";a="42188890"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2025 08:32:18 -0800
X-CSE-ConnectionGUID: iexS3J7jROSdKYOELzxjrw==
X-CSE-MsgGUID: QZJ9F6USQS6MtrjIUA8w9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,223,1736841600"; 
   d="scan'208";a="149499432"
Received: from dnelso2-mobl.amr.corp.intel.com (HELO [10.125.109.222]) ([10.125.109.222])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2025 08:32:17 -0800
Message-ID: <5b2a78b2-2bf8-4482-910f-d2795227ac21@intel.com>
Date: Wed, 5 Mar 2025 09:32:16 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH 2/5] ndctl/namespace: close file descriptor in
 do_xaction_namespace()
To: alison.schofield@intel.com, nvdimm@lists.linux.dev
References: <cover.1741047738.git.alison.schofield@intel.com>
 <60a9535a8ff1f14b9a251ebdbbd8f57265128260.1741047738.git.alison.schofield@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <60a9535a8ff1f14b9a251ebdbbd8f57265128260.1741047738.git.alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/3/25 5:37 PM, alison.schofield@intel.com wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> A coverity scan highlighted a resource leak caused by not freeing
> the open file descriptor upon exit of do_xaction_namespace().
> 
> Move the fclose() to a 'goto out_close' and route all returns through
> that path.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  ndctl/namespace.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/ndctl/namespace.c b/ndctl/namespace.c
> index bb0c2f2e28c7..5eb9e1e98e11 100644
> --- a/ndctl/namespace.c
> +++ b/ndctl/namespace.c
> @@ -2133,7 +2133,7 @@ static int do_xaction_namespace(const char *namespace,
>  				util_display_json_array(ri_ctx.f_out, ri_ctx.jblocks, 0);
>  			if (rc >= 0)
>  				(*processed)++;
> -			return rc;
> +			goto out_close;
>  		}
>  	}
>  
> @@ -2144,11 +2144,11 @@ static int do_xaction_namespace(const char *namespace,
>  		rc = file_write_infoblock(param.outfile);
>  		if (rc >= 0)
>  			(*processed)++;
> -		return rc;
> +		goto out_close;
>  	}
>  
>  	if (!namespace && action != ACTION_CREATE)
> -		return rc;
> +		goto out_close;
>  
>  	if (namespace && (strcmp(namespace, "all") == 0))
>  		rc = 0;
> @@ -2207,7 +2207,7 @@ static int do_xaction_namespace(const char *namespace,
>  						saved_rc = rc;
>  						continue;
>  				}
> -				return rc;
> +				goto out_close;
>  			}
>  			ndctl_namespace_foreach_safe(region, ndns, _n) {
>  				ndns_name = ndctl_namespace_get_devname(ndns);
> @@ -2286,9 +2286,6 @@ static int do_xaction_namespace(const char *namespace,
>  	if (ri_ctx.jblocks)
>  		util_display_json_array(ri_ctx.f_out, ri_ctx.jblocks, 0);
>  
> -	if (ri_ctx.f_out && ri_ctx.f_out != stdout)
> -		fclose(ri_ctx.f_out);
> -
>  	if (action == ACTION_CREATE && rc == -EAGAIN) {
>  		/*
>  		 * Namespace creation searched through all candidate
> @@ -2303,6 +2300,10 @@ static int do_xaction_namespace(const char *namespace,
>  		else
>  			rc = -ENOSPC;
>  	}
> +
> +out_close:
> +	if (ri_ctx.f_out && ri_ctx.f_out != stdout)
> +		fclose(ri_ctx.f_out);
>  	if (saved_rc)
>  		rc = saved_rc;
>  

