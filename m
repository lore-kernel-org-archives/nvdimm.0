Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496BD3CF05C
	for <nvdimm@lists.linux.dev>; Wed,  1 Apr 2026 22:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775084018; cv=none; b=WdihAmDlLsEe6m9RMGpesCX4B5lnmItA0CzGGU21BbmTe+iz98lFQjy/Eos9E6kllKxQZ6cRXGAyGPLaVfyz83rSlL/LQ/zL80QTzNBscEe750JwIJkzIQ8dsOZMSJWVYjorU1eshy430i+TI5dMe4oYBKsQgYMrpwyAOyKyYB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775084018; c=relaxed/simple;
	bh=qabFFzyfL+l7VvoObyi+RClcHzCFOUCw//NsN9N413c=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=JThDcllVJ04JSZZ2sFafw5cNSAnyOaLUfvxbLv2bkVJ/AJr0tu2VoEi4MEIy/G1daC3rEO3T5M1sBOLfPVP04GmqPgC3JliMl1qDkVedA8qoalFtsXjyCIYFsuXAd4bBrZMdKkeAoqM9F+nH9+j7mn+UotF5NJPMqdHjyp8EU0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lxIt7yAr; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lxIt7yAr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775084013; x=1806620013;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=qabFFzyfL+l7VvoObyi+RClcHzCFOUCw//NsN9N413c=;
  b=lxIt7yArI2fv3p4rHVMsh7nYzw6J9IYsAkvPwZJffxN2zIlt+dDh4rjX
   uKbVQnyI1Kqqbt8rbDn7ASlTM/JQ/vj1aR1WHkGsZHScT6Gftxt6vPcNG
   SzfhbApNjXarKhmn5vw0W/zI4YsyD3TY0DlTND6VjmjMAg26Yh1IbEcoz
   pu8fUMUb/dGiWsQZRoajXwI934boJEk/WQDLoJ2KCDAtwNJE6tMLH53kb
   x+3ZJ0JXyjxx9ig+7RLUfTRjD5V+Wo/VjVB/1y/jW48xjqCcIDjjhAQgx
   EELvcYHegDEVLCaW/HsKGhZCfnJ0X3/3TbgrHNsW82WMGkRnq4bY3L8p8
   A==;
X-CSE-ConnectionGUID: 9AsnTOLaQlelmjh6InmXNQ==
X-CSE-MsgGUID: 1nJwk0SRQRWpNfCVaQA6xA==
X-IronPort-AV: E=McAfee;i="6800,10657,11746"; a="87596586"
X-IronPort-AV: E=Sophos;i="6.23,153,1770624000"; 
   d="scan'208";a="87596586"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2026 15:53:32 -0700
X-CSE-ConnectionGUID: yMuWs8vYQAilsYRWiHemdA==
X-CSE-MsgGUID: lLGvANUhSFWe8x2AwtEWPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,153,1770624000"; 
   d="scan'208";a="223517296"
Received: from aschende-mobl.amr.corp.intel.com (HELO [10.125.111.126]) ([10.125.111.126])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2026 15:53:32 -0700
Message-ID: <2b2e0fe8-d163-43f3-b1b7-71d134b86fb7@intel.com>
Date: Wed, 1 Apr 2026 15:53:30 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH 3/3] test/mmap.sh: reduce fallocate size from 1GiB
 to 256MiB
To: Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev
References: <09ef1cacb6dcb0accae1756561b0f761a764aaba.1775018517.git.alison.schofield@intel.com>
 <f2ab6877b5895a95e2f7eccaa452ab29e6bc3b9c.1775018517.git.alison.schofield@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <f2ab6877b5895a95e2f7eccaa452ab29e6bc3b9c.1775018517.git.alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/31/26 9:49 PM, Alison Schofield wrote:
> The mmap test allocates a 1 GiB file and exercises a matrix of mmap
> flag combinations across ext4+dax and xfs+dax, performing multiple
> full-range read and write passes for each case.
> 
> The coverage of this test comes from the mmap modes and access
> patterns it exercises (MAP_SHARED vs MAP_PRIVATE, MAP_POPULATE,
> mlock/munlock, and read-only mappings), not from the size of the
> mapping itself. These behaviors are not size-dependent, and no test
> assertions rely on a 1 GiB mapping.
> 
> Long CI runtimes prompted a closer look at this test, but the
> reduction stands on its own merits: a 256 MiB mapping still spans many
> PMD (2 MiB) DAX mappings and exercises the same access patterns, while
> avoiding unnecessary work in each test case.

No excercise of tests against 1GB page?

DJ


> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
>  test/mmap.sh | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/test/mmap.sh b/test/mmap.sh
> index 7d0053da0e1a..c517d5b0f50b 100755
> --- a/test/mmap.sh
> +++ b/test/mmap.sh
> @@ -59,12 +59,12 @@ rc=1
>  
>  mkfs.ext4 $DEV
>  mount $DEV $MNT -o dax
> -fallocate -l 1GiB $MNT/$FILE
> +fallocate -l 256MiB $MNT/$FILE
>  test_mmap
>  umount $MNT
>  
>  mkfs.xfs -f $DEV -m reflink=0
>  mount $DEV $MNT -o dax
> -fallocate -l 1GiB $MNT/$FILE
> +fallocate -l 256MiB $MNT/$FILE
>  test_mmap
>  umount $MNT

