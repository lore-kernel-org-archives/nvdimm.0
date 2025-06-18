Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA4927EFE8
	for <nvdimm@lists.linux.dev>; Wed, 18 Jun 2025 22:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750285537; cv=none; b=RE2IBbt5MZ++pHHcgkigNOAMgBcK4HKSVYadKdczukbGPnhcO9NPVEOIUO/Rr68lYjiMcp8wywdrfjNGOoB8LJZDKw0YaCzmZyiQ83Zho6jkxYY05gjfODMOPc5f4M6QoIVoaTyeeiz9PCqgYpBKKr9YEodxzhTStg06h2t89q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750285537; c=relaxed/simple;
	bh=bqX7rpPTGt9t31Qgtry4QKtu4AQW3fB3V6o5BLK1T4Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TgNz0VSN9VR8MvnM643UC/t2edWBp3OyvArk0l1Yv5biqS9eAvgM1dkVkr8aPkIXBZsVf6Ckr/zM9FE7+1XDwCOgQH2w2pCNS7J0Jfl1rf9732hi1wJTYRyzsOi5gUMNCaJYJ92dRYy1PXf/EHpIwrIxtInf9kxvUR6sZGkvHKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OoZRi2aD; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OoZRi2aD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750285536; x=1781821536;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=bqX7rpPTGt9t31Qgtry4QKtu4AQW3fB3V6o5BLK1T4Q=;
  b=OoZRi2aDUO+oX0Wyj3Dz0+1IEYcgQdy336mV63cMiXLQianGVbSSN/mb
   TsHb93PE6eu2zAi+k6p4jLnpJfMkNjSMh6VOx8+uJVS67DNrbtuMbQvcp
   +HgLOLoXFVJqqJOHMhcWLI/AYHMljmrPBtIsJevCy47vy3MMwODY0svEP
   uD6i8OKMBL4UpoPiGejkooJl1x3Ke+jPrBmOBLp2tn9owYja8zPJPQGD2
   xP13G8V3TMbkYCoC2fmXdylFH3hQ10QHu75fOhKS3PLLAIhgaRCN9Dx6R
   3ggtsCzCfB4wLJlmSA5eMbBM8xZkLWuVxxXVYCPbXvy2IQzMi8nZaLMzG
   w==;
X-CSE-ConnectionGUID: dlqeQMv7Qyyre1s0eVb1Mg==
X-CSE-MsgGUID: 0rbbe0+gTuC0T08z+bFCFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11468"; a="52675779"
X-IronPort-AV: E=Sophos;i="6.16,246,1744095600"; 
   d="scan'208";a="52675779"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 15:25:35 -0700
X-CSE-ConnectionGUID: H18a59ICQwe2IFGVkaqBGg==
X-CSE-MsgGUID: 3xLgEdX7SoaaBak/sTTaLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,246,1744095600"; 
   d="scan'208";a="149824339"
Received: from smoticic-mobl1.ger.corp.intel.com (HELO [10.125.108.99]) ([10.125.108.99])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 15:25:34 -0700
Message-ID: <1307029c-2b4a-4fda-98ca-d75a25c7a8ef@intel.com>
Date: Wed, 18 Jun 2025 15:25:32 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH 1/5] build: Fix meson feature deprecation warnings
To: Dan Williams <dan.j.williams@intel.com>, alison.schofield@intel.com
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
References: <20250618222130.672621-1-dan.j.williams@intel.com>
 <20250618222130.672621-2-dan.j.williams@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20250618222130.672621-2-dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/18/25 3:21 PM, Dan Williams wrote:
> There are a few instances of the warning:
> 
> "meson.build: WARNING: Project does not target a minimum version but
> uses feature deprecated since '0.56.0': dependency.get_pkgconfig_variable.
> use dependency.get_variable(pkgconfig : ...) instead"
> 
> Move to the new style and mark the project as needing at least that minimum
> version.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  contrib/meson.build | 2 +-
>  meson.build         | 5 +++--
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/contrib/meson.build b/contrib/meson.build
> index 48aa7c071f92..33a409a2d7d0 100644
> --- a/contrib/meson.build
> +++ b/contrib/meson.build
> @@ -2,7 +2,7 @@ bashcompletiondir = get_option('bashcompletiondir')
>  if bashcompletiondir == ''
>    bash_completion = dependency('bash-completion', required : false)
>    if bash_completion.found()
> -      bashcompletiondir = bash_completion.get_pkgconfig_variable('completionsdir')
> +      bashcompletiondir = bash_completion.get_variable(pkgconfig : 'completionsdir')
>    else
>      bashcompletiondir = datadir / 'bash-completion/completions'
>    endif
> diff --git a/meson.build b/meson.build
> index 19808bb21db8..300eddb99235 100644
> --- a/meson.build
> +++ b/meson.build
> @@ -1,5 +1,6 @@
>  project('ndctl', 'c',
>    version : '82',
> +  meson_version: '>= 0.56.0',
>    license : [
>      'GPL-2.0',
>      'LGPL-2.1',
> @@ -159,9 +160,9 @@ endif
>  
>  if get_option('systemd').enabled()
>    systemd = dependency('systemd', required : true)
> -  systemdunitdir = systemd.get_pkgconfig_variable('systemdsystemunitdir')
> +  systemdunitdir = systemd.get_variable(pkgconfig : 'systemdsystemunitdir')
>    udev = dependency('udev', required : true)
> -  udevdir = udev.get_pkgconfig_variable('udevdir')
> +  udevdir = udev.get_variable(pkgconfig : 'udevdir')
>    udevrulesdir = udevdir / 'rules.d'
>  endif
>  

