Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF2F3FB05A
	for <nvdimm@lists.linux.dev>; Mon, 18 May 2026 15:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779119037; cv=none; b=s6/wyssJGvNNQfbe9ob/w5gc87svwxpcWBWnrENII0cgZ8NTXgglwf/b19nDNgNqUi1X7QhpyfQ9Ki5gqYoldkL5LSBYU4j1DsLiADlCzzz2ReVpLHYn3wcmsZ8GawUI2hjnwGw9omHT7GgOvP5PvzEgr/ZAGsurnbwcCQStwHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779119037; c=relaxed/simple;
	bh=2ezjglnevhAB4I3slsDsPspjCGwAS8DII5WYJikxgB8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=YrDsvjpyD7ntj5ptQepwQpxrUNLbD/IAwq4mUqV0rTd5Y0pyuU7WCpat++PyYzdTMGa1QXegjnwECln0uY+FCWX3n2ZyP0NhkBFj/GG4jhiofIa4OoCTaGvQreOjW6HvEPHezA0S07Z8azJX0+0MC5p8EQM3J9IxUB8TNgninMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Cb9YgKLg; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Cb9YgKLg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779119036; x=1810655036;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=2ezjglnevhAB4I3slsDsPspjCGwAS8DII5WYJikxgB8=;
  b=Cb9YgKLgW3jxD6jePQUx7rztArMRbHBQBN85E+nTBVNnZbbgJNCbggSb
   rvSC0CPtQDkAMMEzFg4r23j8p8vqZIIoDexA0nHWiFkzzMLiqsnFtbMGe
   Za8QTUazJsrCBJIGYqzGtEK9OthYomFCP9Zljfd0yk/Cqseh2XzBZ31pl
   BKZU2fgUioikKf7MeWFkl9bpn2e4W8yzU2ZGrbqBdDlABggoHsC6FU2X9
   wpeTwpDGvapTAGUx3p39i8ImfiibFDJVyMyIRvQeprImzo3tk08GJEGBf
   zNPhYYkYFC1tu/yfh+arbkA7ANRYE71Ye6XdWY9viXNkWEBCt5YpLPcwT
   g==;
X-CSE-ConnectionGUID: TnZWgAetQduz05hmwJsAcQ==
X-CSE-MsgGUID: e3aDaLzVSWSvCBJ2E+pdSA==
X-IronPort-AV: E=McAfee;i="6800,10657,11790"; a="78996542"
X-IronPort-AV: E=Sophos;i="6.23,242,1770624000"; 
   d="scan'208";a="78996542"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2026 08:43:55 -0700
X-CSE-ConnectionGUID: EEACSAm2R0qyrLMoGuhueA==
X-CSE-MsgGUID: lgboBeC3QhCvX9oafKgSOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,242,1770624000"; 
   d="scan'208";a="241282368"
Received: from aschende-mobl.amr.corp.intel.com (HELO [10.125.109.65]) ([10.125.109.65])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2026 08:43:55 -0700
Message-ID: <3d2755da-d94d-4db8-895d-1c591545ef66@intel.com>
Date: Mon, 18 May 2026 08:43:53 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: nvdimm: Include maintainer profile
To: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
 Ira Weiny <ira.weiny@intel.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, nvdimm@lists.linux.dev,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260518104306.39289-2-krzysztof.kozlowski@oss.qualcomm.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260518104306.39289-2-krzysztof.kozlowski@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/18/26 3:43 AM, Krzysztof Kozlowski wrote:
> No dedicated NVDIMM maintainers are returned by get_maintainers.pl for
> the subsystem maintainer profile, thus patches changing that file miss
> the actual owners of the file.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Acked-by: Dave Jiang <dave.jiang@intel.com>


> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7a65b220d93f..294909f6d488 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -14751,6 +14751,7 @@ S:	Supported
>  Q:	https://patchwork.kernel.org/project/linux-nvdimm/list/
>  P:	Documentation/nvdimm/maintainer-entry-profile.rst
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git
> +F:	Documentation/nvdimm/maintainer-entry-profile.rst
>  F:	drivers/acpi/nfit/*
>  F:	drivers/nvdimm/*
>  F:	include/linux/libnvdimm.h

