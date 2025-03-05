Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11CFE18DF7C
	for <nvdimm@lists.linux.dev>; Wed,  5 Mar 2025 16:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741191876; cv=none; b=laLPs4SEWR2YsEJ2m6biP9Ph47CAeShk00Qsq+TCLiV5VtlC/sdhhOFaCLCX5k357W13Xrj5fs2UnFaC+Tp3xzvTIe7jnF9W87ZHlqtvhFMGQEvWxlBA8mG9AJkQ2XGhuqsbZjmnXbb8D+mj+28DK2xD7vLCF9Pb67A0ivXSqkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741191876; c=relaxed/simple;
	bh=pirAw9StLNmebljUWxFgBT62cQuedBwe6pK79xQGG9s=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=CVk89eh9dHpIBwLDzc9V22b7/hIqKdx5rjNXuO6bcvVwuQXWM3OlPTroH9XU671IUc35A3s3wAtOPjbyO8cxvJvzH4X/go2AjwWl+CKrs849sawVezyxY/zjGe4i/n8ocL3dmOzXfOWb9flKN8RblSyA+Y4sxzHEDyaLiOW6LiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P8me/NHZ; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P8me/NHZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741191875; x=1772727875;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=pirAw9StLNmebljUWxFgBT62cQuedBwe6pK79xQGG9s=;
  b=P8me/NHZtGrewwesQe3GZ/ZkF6ir1dogzVKlRvyMYzh8bbubskI4sqGl
   hy0XbCGcqH0OiKapwLpA/gsH9DMnE5Vvz1eSJji4bE6Y68sdOX2Yc0Mfl
   pCYh+SgnUPceMQDRb2mvp3J/LU5sVkb82ZO4iYMdtShwwDV8rog+IqOUK
   co5enk+ESmFg7wFa7hZlZlSVARrWm1pwuIGY/M3JijKnIq3EcnkK7OvFI
   P8zchp1hI1GEiVHrwqgZz7b6iiKXGtP/Yck7jkvNmxngUcoz65lLOo3T0
   pktWz/KPNyV+MCBj+IHnm0lVerba++BZUnBxnlgleGFTXbirI/kAV9GSa
   w==;
X-CSE-ConnectionGUID: GMY/mDxpRiec0SpjfmUMjw==
X-CSE-MsgGUID: V5kfl3q6RxmxhFcjnR7pQw==
X-IronPort-AV: E=McAfee;i="6700,10204,11363"; a="52368214"
X-IronPort-AV: E=Sophos;i="6.14,223,1736841600"; 
   d="scan'208";a="52368214"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2025 08:24:35 -0800
X-CSE-ConnectionGUID: 9bKXpl11Q+WfDcRorTtz1Q==
X-CSE-MsgGUID: n/nAuKIpSFClqouYEVxGZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,223,1736841600"; 
   d="scan'208";a="123320214"
Received: from dnelso2-mobl.amr.corp.intel.com (HELO [10.125.109.222]) ([10.125.109.222])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2025 08:24:34 -0800
Message-ID: <f608800b-27b0-4333-967c-93b5338e20aa@intel.com>
Date: Wed, 5 Mar 2025 09:24:33 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH 1/5] ndctl/namespace: avoid integer overflow in
 namespace validation
To: alison.schofield@intel.com, nvdimm@lists.linux.dev
References: <cover.1741047738.git.alison.schofield@intel.com>
 <9d4b1148babc3d6e43bd5beea807729940da2404.1741047738.git.alison.schofield@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <9d4b1148babc3d6e43bd5beea807729940da2404.1741047738.git.alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/3/25 5:37 PM, alison.schofield@intel.com wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> A coverity scan highlighted an integer overflow issue when testing
> if the size and align parameters make sense together.
> 
> Before performing the multiplication, check that the result will not
> exceed the maximimum value that an unsigned long long can hold.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

nit below

> ---
>  ndctl/namespace.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/ndctl/namespace.c b/ndctl/namespace.c
> index aa8c23a50385..bb0c2f2e28c7 100644
> --- a/ndctl/namespace.c
> +++ b/ndctl/namespace.c
> @@ -865,9 +865,15 @@ static int validate_namespace_options(struct ndctl_region *region,
>  		 * option
>  		 */
>  		size_align = max(units, size_align) * ways;
> -

stray edit?
>  		p->size /= size_align;
>  		p->size++;
> +
> +		if (p->size > ULLONG_MAX / size_align) {
> +			err("size overflow: %llu * %llu exceeds ULLONG_MAX\n",
> +			    p->size, size_align);
> +			return -EINVAL;
> +		}
> +
>  		p->size *= size_align;
>  		p->size /= units;
>  		err("'--size=' must align to interleave-width: %d and alignment: %ld\n"

