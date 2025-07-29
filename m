Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16FAD289E36
	for <nvdimm@lists.linux.dev>; Tue, 29 Jul 2025 15:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753802088; cv=none; b=QXYwX//S4lS4ZKHOjLanXNCIY19H+pdmW+D1v5ZPsSjwPTjVNdmM7+MmmUPi7TOBwCmy5dJ6KtNwehqwd8k0bRK0e/Nu9ZJJ6VNLgt31xB8Exn96tbD9PZG4HyvynM8QqFo9HFt6dfyUtquaXZcg77Q9o/O45VckZZqbU+IFAvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753802088; c=relaxed/simple;
	bh=0JBSTuaSCO33OAalP9+x1URki2+i7GL0yMijedK0tDw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=dfvLwDQWh5bTtlXqFg4M477wJDVNEEBcc9bofN0sksO/U7zzTuh972cCdyGacrQ8luc5IBs9URXBf5VweRNK+D8OHX3Z+m9AT1Gkt0RN4GKAmRy5vmrBnOFK40sbvNK2iCW7pqNb/7k78IAz+37cXoRGVaTHx/kCayIv/ep/8ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hlmNVHlQ; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hlmNVHlQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753802087; x=1785338087;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=0JBSTuaSCO33OAalP9+x1URki2+i7GL0yMijedK0tDw=;
  b=hlmNVHlQ/kUo+pa1fsK+l1iXjIZMqwYFnMW8JncsGAW2CfHFmg2rJT/O
   8mRTC2yR8CiGSBx6Tmm5obrttlM3kJHKv4JBt7gV5151sIeh6CfricVDJ
   UvwDyBF9y+hHKwk8CD/wdTttov0tHSbQ85TY1UnWSF/sVy3LNDEBLAEfJ
   NthNhrJhDG1zAqNii5nYcWa2VgwQcNibIMZ7kghDb1/dCtGQGik1jlUC6
   14OLYPjhVbNfHoXV3Qlig2M80ETBdjGVCttqMZxfbKWaS3SxfiS2uGHoq
   TV5IG/DHghgbTv7PaWBs85i/IXduwujqJGKCMxcPOx7BMjaVWjyI5RqFZ
   w==;
X-CSE-ConnectionGUID: uPXUlMd6SxyfEdcMbj9GLw==
X-CSE-MsgGUID: pHLJAxlRTImXrQ5fjLFhQQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11506"; a="43680278"
X-IronPort-AV: E=Sophos;i="6.16,349,1744095600"; 
   d="scan'208";a="43680278"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2025 08:14:46 -0700
X-CSE-ConnectionGUID: GwpW2ms7Qc+pSkczVvcYJA==
X-CSE-MsgGUID: mSt6SbDXT1OJ9EjFS267rQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,349,1744095600"; 
   d="scan'208";a="162611258"
Received: from bvivekan-mobl2.gar.corp.intel.com (HELO [10.247.118.247]) ([10.247.118.247])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2025 08:14:43 -0700
Message-ID: <880da88e-2cad-4e8b-9d9b-ad9e2fcdb56d@intel.com>
Date: Tue, 29 Jul 2025 08:14:38 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH 2/3] test/common: move err() function at the top
To: marc.herbert@linux.intel.com, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, alison.schofield@intel.com, dan.j.williams@intel.com
References: <20250724221323.365191-1-marc.herbert@linux.intel.com>
 <20250724221323.365191-3-marc.herbert@linux.intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20250724221323.365191-3-marc.herbert@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/24/25 3:00 PM, marc.herbert@linux.intel.com wrote:
> From: Marc Herbert <marc.herbert@linux.intel.com>
> 
> move err() function at the top so we can fail early. err() does not have
> any dependency so it can be first.
> 
> Signed-off-by: Marc Herbert <marc.herbert@linux.intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  test/common | 25 ++++++++++++++-----------
>  1 file changed, 14 insertions(+), 11 deletions(-)
> 
> diff --git a/test/common b/test/common
> index 2d8422f26436..2d076402ef7c 100644
> --- a/test/common
> +++ b/test/common
> @@ -1,6 +1,20 @@
>  # SPDX-License-Identifier: GPL-2.0
>  # Copyright (C) 2018, FUJITSU LIMITED. All rights reserved.
>  
> +# err
> +# $1: line number which error detected
> +# $2: cleanup function (optional)
> +#
> +
> +test_basename=$(basename "$0")
> +
> +err()
> +{
> +	echo test/"$test_basename": failed at line "$1"
> +	[ -n "$2" ] && "$2"
> +	exit "$rc"
> +}
> +
>  # Global variables
>  
>  # NDCTL
> @@ -53,17 +67,6 @@ E820_BUS="e820"
>  
>  # Functions
>  
> -# err
> -# $1: line number which error detected
> -# $2: cleanup function (optional)
> -#
> -err()
> -{
> -	echo test/$(basename $0): failed at line $1
> -	[ -n "$2" ] && "$2"
> -	exit $rc
> -}
> -
>  reset()
>  {
>  	$NDCTL disable-region -b $NFIT_TEST_BUS0 all

