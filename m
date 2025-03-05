Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87F9192B95
	for <nvdimm@lists.linux.dev>; Wed,  5 Mar 2025 16:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741193038; cv=none; b=BdgypS9WsApM+1UrDR6ymEOn6eowqh7CIFtPNEj0F2ZfHIjuMfqo0zJLAzwygc4+OKrptmKAmxuqPd3dB2Bl3bHaSCgH9QhNHQHkgdrDuvNPnzl7t50FOVKSNqztwkVr2KrfpmVwHVr2gOXjDNKbhYnE59XUm+ha7iPAIhRetSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741193038; c=relaxed/simple;
	bh=TweHk3yX7Fuy6pyJ/WVwO+n1PW4iSDuUnsIdCJc+9tw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=gyCyJ8klSAdHXL3L0e/oIgfXFe1jbZdQGbez42DUa5f2l+q94uz5OaCNncq1FBqibiHunpQz3r4I/Ebt1emqWy2/WcFQEGC0Se5d32gr1sIKy4uswEjN//1QA1NEP+LcjLMi1vhHiew3BANOzeVaNXXQPVqe6G5TI53qbpm8cYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=joVz64C9; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="joVz64C9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741193037; x=1772729037;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=TweHk3yX7Fuy6pyJ/WVwO+n1PW4iSDuUnsIdCJc+9tw=;
  b=joVz64C9Rsvhh79jSz4rn9sRjCpdBL4PbxRQJSX6ouE4DkuceZJL3eeM
   YjIf/pl+QdHyNty0nxHJZT7cCF9aZsydGvimMUZRZAHjrrGKXs+Z9bUv5
   y/0CdW5ctNg6g7AH41n47EwcPxSsZmtARpgL5M+XvimkPuGryIkurhhyv
   h3R8PNgK9AlsdOp1ZmslvPOdoScRz7qeAWLGNqNOsDLyStwrfkOSOU2fF
   Un7DJ9/3No7RXdV1U0VzsxCBZc47Mf9SzTqFwSX8641TqgkMmrKnAyUKv
   IKYyeGVDE1KgPlONAspN/xAjxY1Nc5bnVRC8etVmfNknUGJlyYSDT3yYE
   Q==;
X-CSE-ConnectionGUID: Nas5JVwtSzi3ExOLbH94eA==
X-CSE-MsgGUID: 42g9s6w1Ti28feG71c3tEQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11363"; a="42190322"
X-IronPort-AV: E=Sophos;i="6.14,223,1736841600"; 
   d="scan'208";a="42190322"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2025 08:43:57 -0800
X-CSE-ConnectionGUID: vRbjZoYkR1WXmo+6MTlr6A==
X-CSE-MsgGUID: A6D8naz3Rnm4lfdfn0y90w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="118667429"
Received: from dnelso2-mobl.amr.corp.intel.com (HELO [10.125.109.222]) ([10.125.109.222])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2025 08:43:56 -0800
Message-ID: <f7b756a5-2af5-4571-af36-dc46992de9cd@intel.com>
Date: Wed, 5 Mar 2025 09:43:53 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH 5/5] ndctl/namespace: protect against
 under|over-flow w bad param.align
To: alison.schofield@intel.com, nvdimm@lists.linux.dev
References: <cover.1741047738.git.alison.schofield@intel.com>
 <3692da31440104c890e59b8450e4a6472f3eded8.1741047738.git.alison.schofield@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <3692da31440104c890e59b8450e4a6472f3eded8.1741047738.git.alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/3/25 5:37 PM, alison.schofield@intel.com wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> A coverity scan highlighted an integer underflow when param.align
> is 0, and an integer overflow when the parsing of param.align fails
> and returns ULLONG_MAX.
> 
> Add explicit checks for both values.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  ndctl/namespace.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/ndctl/namespace.c b/ndctl/namespace.c
> index 40bcf4ca65ac..3224c9ff4444 100644
> --- a/ndctl/namespace.c
> +++ b/ndctl/namespace.c
> @@ -2086,7 +2086,11 @@ static int namespace_rw_infoblock(struct ndctl_namespace *ndns,
>  			unsigned long long size = parse_size64(param.size);
>  			align = parse_size64(param.align);
>  
> -			if (align < ULLONG_MAX && !IS_ALIGNED(size, align)) {
> +			if (align == 0 || align == ULLONG_MAX) {
> +				error("invalid alignment:%s\n", param.align);
> +				rc = -EINVAL;
> +			}
> +			if (!IS_ALIGNED(size, align)) {
>  				error("--size=%s not aligned to %s\n", param.size,
>  					param.align);
>  

