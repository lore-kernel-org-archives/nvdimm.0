Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864EF14C5A3
	for <nvdimm@lists.linux.dev>; Tue, 20 Aug 2024 19:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724183975; cv=none; b=YPekPaK194YiQnnFVmS5HEiG3WLA0O5mjBoIw/FKzwJ0a194awfP7AF5yz1qSCYrSvfVE6JBOyueYnUDaEv5T+Grtfj2vYAxUUidHyMirFoZIGKjE/T/9bTpWr4wlWcN8TnYMh1D81umUgjj65RuyE2zYJI2vW3woDCR2+T4TLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724183975; c=relaxed/simple;
	bh=3oMX+jBTcy/3jvMpCmhqpUpaqzvG3Xj/4TYYqZLdm2U=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=B6i7Bc4nMkoOTionJRtjVJPhko/CQROT5v4qADA0srF/18sgS/hkajYWKrqbKAh2N2sNfxOE4zLQfBLF4SBnR4nzZ3+jtZ4b26k7ys6Zg6NN8OoWTj+PFu14TjSSZR0vCxLT68q3v3STOuQNyPGrD3NCT0jRfV/NQ/QRuyGbs9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iPhhNHvZ; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iPhhNHvZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724183973; x=1755719973;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=3oMX+jBTcy/3jvMpCmhqpUpaqzvG3Xj/4TYYqZLdm2U=;
  b=iPhhNHvZ63MsSz+kwh9n3pCOIlagZrf9rWc1W/aYkyDGOFnFyCgSbUUA
   ZJ5Bu1UNl63Ccf5AuJXaZ1GFQXw+Ol8asTCxU4NM9QrRwLHfqxK2ZTm6+
   /qfsbUNWayrxLr4Yi6XyXOEOq4eWMQsLPcVnO1ZCgzlVd4Ap4BhHpkchW
   ddlN+JFE9b39bE4VcHqKdtY535xYzct4d7ecpKPTAk/BmO9JkEohvFWeK
   ocR7/OHsIN9jj1m0Aa/HOqbPJNj8gT0fYl/VwaaCXS4rueC0oJ7up9Yjl
   Cd40QCQoVXbkCF/0YDqVNWuWrFRVFiOlO1JfnxrkM9u17QvEs6JgLHke7
   w==;
X-CSE-ConnectionGUID: N8JKxDXZTgqZsFW4fxalAQ==
X-CSE-MsgGUID: bFR3+FnBQHSxsUScAS3iew==
X-IronPort-AV: E=McAfee;i="6700,10204,11170"; a="40023865"
X-IronPort-AV: E=Sophos;i="6.10,162,1719903600"; 
   d="scan'208";a="40023865"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2024 12:59:33 -0700
X-CSE-ConnectionGUID: iWL6wFjFSJ2reh+CSqyM+g==
X-CSE-MsgGUID: arQVbxPsSMCHvl+KRdcCJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,162,1719903600"; 
   d="scan'208";a="65199088"
Received: from cdpresto-mobl2.amr.corp.intel.com.amr.corp.intel.com (HELO [10.125.108.88]) ([10.125.108.88])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2024 12:59:32 -0700
Message-ID: <6404b0eb-1ac9-4e96-9865-a51f5db4d3c4@intel.com>
Date: Tue, 20 Aug 2024 12:59:31 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ndctl 2/2] libndctl.c: major and minor numbers are
 unsigned
To: jmoyer@redhat.com, nvdimm@lists.linux.dev
References: <20240820182705.139842-1-jmoyer@redhat.com>
 <20240820182705.139842-3-jmoyer@redhat.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20240820182705.139842-3-jmoyer@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/20/24 11:26 AM, jmoyer@redhat.com wrote:
> From: Jeff Moyer <jmoyer@redhat.com>
> 
> Static analysis points out that the cast of bus->major and bus->minor
> to a signed type in the call to parent_dev_path could result in a
> negative number.  I sincerely doubt we'll see major and minor numbers
> that large, but let's fix it.
> 
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  ndctl/lib/libndctl.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
> index ddbdd9a..f75dbd4 100644
> --- a/ndctl/lib/libndctl.c
> +++ b/ndctl/lib/libndctl.c
> @@ -710,11 +710,12 @@ NDCTL_EXPORT void ndctl_set_log_priority(struct ndctl_ctx *ctx, int priority)
>  	daxctl_set_log_priority(ctx->daxctl_ctx, priority);
>  }
>  
> -static char *__dev_path(char *type, int major, int minor, int parent)
> +static char *__dev_path(char *type, unsigned int major, unsigned int minor,
> +			int parent)
>  {
>  	char *path, *dev_path;
>  
> -	if (asprintf(&path, "/sys/dev/%s/%d:%d%s", type, major, minor,
> +	if (asprintf(&path, "/sys/dev/%s/%u:%u%s", type, major, minor,
>  				parent ? "/device" : "") < 0)
>  		return NULL;
>  
> @@ -723,7 +724,7 @@ static char *__dev_path(char *type, int major, int minor, int parent)
>  	return dev_path;
>  }
>  
> -static char *parent_dev_path(char *type, int major, int minor)
> +static char *parent_dev_path(char *type, unsigned int major, unsigned int minor)
>  {
>          return __dev_path(type, major, minor, 1);
>  }
