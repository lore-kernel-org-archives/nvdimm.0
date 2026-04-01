Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401F93CA4A6
	for <nvdimm@lists.linux.dev>; Wed,  1 Apr 2026 22:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775083736; cv=none; b=fGLTy4DEDR8Oy/XPDcCfbtJgH60Fcyn6U6/D3mCXPrBtwe53soIyA3X7tT1Pv62JHP1mMGZloCl73HZ0sLIYiJasvmYj+CUAX5CwU9d6vBw186NguAabgSu0j65+a8hoWGHNL1+2tq/NMaFSNs8xho9gcG6MUU+V/tMf6FuFv3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775083736; c=relaxed/simple;
	bh=xYSVGb2lyHKcGTVEVmINWf43W7U2EZuo4lGSBPgtGBg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=XPEhBjCiXFte9nqcVGgO9FPYqiyJCfbNpkZrM+ld5+3cF7Aw7/mDWRptuu487uDKKAKs0zxRsaBbxrPqLpyMBKZI7LQ+List1tIeUJPaEWOIJjJtV9MdPBTIIfUNJCNxxEfBtItB+A8gpCC/MmdVXCgJNRAkfRvB762jHUozHHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RypnXuqU; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RypnXuqU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775083734; x=1806619734;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=xYSVGb2lyHKcGTVEVmINWf43W7U2EZuo4lGSBPgtGBg=;
  b=RypnXuqUMrSSSbVK5tfAgkKv1cn6Ug5lQN/9jcbIxA9KvxDsje5ygzSZ
   5rdPiWhrMZRw9CGw4cXCDwlgsfw5XLrDqYpElyB8RqTDY4eLC5WdCijAh
   mMJMVlGLk8pVuB/98DL2D3nV+JfzHCjJObbG3SEq2UdtdzcbhQDhcO9n6
   N6wDxZIz1my+O3gDEdmTzTbTd/ZydOr/8tbZ5fTdF7LmMnzh2X7nwHLVD
   K5ILQSl0JRBD2dF1gedG2onWvuFCXUpX3pq6b4j2HJaySioxF8xIAT8F5
   P/LhEVIRFZBNBLSSwVl4cH7m0A1KbXqM8xsfMoQv4b5gYbwVpMk+xevFG
   g==;
X-CSE-ConnectionGUID: USsh4U+wTl20gv0fN0nCxg==
X-CSE-MsgGUID: 8q26+VN/THeVJ60lcxNnxQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11746"; a="98751413"
X-IronPort-AV: E=Sophos;i="6.23,153,1770624000"; 
   d="scan'208";a="98751413"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2026 15:48:53 -0700
X-CSE-ConnectionGUID: qpPZZ01NTg6MGaR/ajASwg==
X-CSE-MsgGUID: iTdBdPsTR2aHGkjcQkE81A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,153,1770624000"; 
   d="scan'208";a="221959812"
Received: from aschende-mobl.amr.corp.intel.com (HELO [10.125.111.126]) ([10.125.111.126])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2026 15:48:51 -0700
Message-ID: <3f34556e-c3b2-40af-afe8-0a907c00c428@intel.com>
Date: Wed, 1 Apr 2026 15:48:50 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH 1/3] test/mmap.c: check mmap() result against
 MAP_FAILED
To: Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev
References: <09ef1cacb6dcb0accae1756561b0f761a764aaba.1775018517.git.alison.schofield@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <09ef1cacb6dcb0accae1756561b0f761a764aaba.1775018517.git.alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/31/26 9:49 PM, Alison Schofield wrote:
> The mmap test currently checks for failure by comparing the return
> value of mmap() against NULL. However, mmap() indicates failure by
> returning MAP_FAILED, not NULL. This means a failure would go
> undetected and the test would proceed with an invalid pointer.
> 
> Update the check to compare against MAP_FAILED.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  test/mmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/test/mmap.c b/test/mmap.c
> index 0a66967a25f6..98b85fe8453e 100644
> --- a/test/mmap.c
> +++ b/test/mmap.c
> @@ -155,7 +155,7 @@ int main(int argc, char **argv)
>  
>  	printf("> mmap mprot 0x%x flags 0x%x\n", mprot, mflags);
>  	p = mmap(mptr, size, mprot, mflags, fd, 0x0);
> -	if (!p) {
> +	if (p == MAP_FAILED) {
>  		perror("mmap failed");
>  		return EXIT_FAILURE;
>  	}
> 
> base-commit: 8ad90e54f0ff4f7291e7f21d44d769d10f24e2b6

