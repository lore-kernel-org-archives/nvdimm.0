Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5F7346A11
	for <nvdimm@lists.linux.dev>; Thu, 11 Sep 2025 15:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757605458; cv=none; b=mzR81N5TDhu6IQ/GQnnooPvbUDzl6V1XW/J1fIR2xiLn5WVWmfUHb8wLGE91jbbCTZHZN6noGYOsUXbqoKTPOMc8pXCUOtKKoh08N7Wjob5VmSyzZv5cL0HcwRLdI0BNHmB0kNzLgnO831At8pStAC9dD/t5y4fMC9winAEbn0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757605458; c=relaxed/simple;
	bh=PTb4v61SVx1xj+hs9/M+kHL239HfqRsUymrBW2gF5CY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iqRQM2u6y3fDIa3sKOqjC9IgGsMPc6+X2oj0FMCyWNj5q1fRc3k8bstnRqisqVkiad3zjhmpq9Zo+OlK4dqEtvXY/PkiH7ol1CXj3X7pIV3HVHM8b5XM2sc1K6e7Xbxbv/axFeeyPUjKmzpPQGgZtZGsdktR94kZpOKtvToScBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DnDAgI+h; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DnDAgI+h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757605457; x=1789141457;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=PTb4v61SVx1xj+hs9/M+kHL239HfqRsUymrBW2gF5CY=;
  b=DnDAgI+hUPMfu9B1qIEoxSMMoH07l1OkHy6wnJx2qG23LrT3RXZydaY8
   HRMXntuTvA9+4xGxWo2qGLcVxFZoBi//pT0bB6iPNfyvzDBB0vPFIRDhf
   PAE+TgZKwx1N1Zz/q4txFswsoGe9o1drBvPA8gHfhTOHeE8lf11I7dEW/
   ffwXwKzy0urKtj/acT+z2xfUzf++o7rVhmYK9pvvNWgZleZLxZevWmnEq
   SLcCVjLfnRYUtODNGfK4XEnNeESywszEwJLpo4oENUpnEhWpk/v0zF4mI
   RtWe9FSQsHFOJs9/RXE0Eef1vYEJ7CKgUAlTvxcCxRJP13A4AvPoUG32y
   w==;
X-CSE-ConnectionGUID: xIr9qLc6Qdyk6z9zIUIlbg==
X-CSE-MsgGUID: 7y5oMrtETKayRLaZ0RtCSQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11549"; a="77398936"
X-IronPort-AV: E=Sophos;i="6.18,257,1751266800"; 
   d="scan'208";a="77398936"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2025 08:44:15 -0700
X-CSE-ConnectionGUID: 6PSSQhu+QA6FQGGnXcUhWA==
X-CSE-MsgGUID: iPTyE3UNTCCqNAqeQzd+mQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,257,1751266800"; 
   d="scan'208";a="178039505"
Received: from msatwood-mobl.amr.corp.intel.com (HELO [10.125.111.21]) ([10.125.111.21])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2025 08:44:15 -0700
Message-ID: <9400cf4c-6cb4-4576-be22-56d1b7d97e1e@intel.com>
Date: Thu, 11 Sep 2025 08:44:13 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH] test/dm.sh: fix incorrect script name in cleanup
 error message
To: Yi Zhang <yi.zhang@redhat.com>, nvdimm@lists.linux.dev
Cc: alison.schofield@intel.com, linux-cxl@vger.kernel.org
References: <20250911002906.806359-1-yi.zhang@redhat.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20250911002906.806359-1-yi.zhang@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/10/25 5:29 PM, Yi Zhang wrote:
> The cleanup() function was incorrectly referencing "test/sub-section.sh"
> instead of "test/dm.sh" in its error message.
> 
> Signed-off-by: Yi Zhang <yi.zhang@redhat.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  test/dm.sh | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/test/dm.sh b/test/dm.sh
> index b780a65..e68d491 100755
> --- a/test/dm.sh
> +++ b/test/dm.sh
> @@ -36,7 +36,7 @@ cleanup() {
>  	for i in $namespaces
>  	do
>  		if ! $NDCTL destroy-namespace -f $i; then
> -			echo "test/sub-section.sh: cleanup() failed to destroy $i"
> +			echo "test/dm.sh: cleanup() failed to destroy $i"
>  		fi
>  	done
>  	exit $rc

