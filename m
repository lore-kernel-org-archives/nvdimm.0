Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8289C128395
	for <nvdimm@lists.linux.dev>; Thu, 12 Jun 2025 00:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749686564; cv=none; b=XprxfJEUkEFjVyT3DxfI8lsORI6XvP6ttiyx6vLtzxyTKCxirxn0w9BCHotyAiHrwUaUM25A6bwzSltnP03o8YCyriCKvrBl4o+u739LkgIU7n5dU5M4TH7b9HfGJ/NywfAfXQBNl1fkyZom13NiJaCpQyruJVoiYoQUxZ++iP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749686564; c=relaxed/simple;
	bh=sKMmn+PxNTsufD9WGiijbykVfxS5cY4Fhbf4nrifAOk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=IDdjcGWblXVsGQBMRo3KdJ2Vx2rTrqjxHoSiDuCLIIHB3o+udFL56HiBdVVc86Tptqu5jcqn6J+TTlRVROJJKHb9aBrMghqmFqsd/Bz1G8z74ubsok5sT5HhKBefccrxupddIr0BHrW5TCBsnawgzZo0iTo1/g02ejuCpmO2ySg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PNxbiMqP; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PNxbiMqP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749686561; x=1781222561;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=sKMmn+PxNTsufD9WGiijbykVfxS5cY4Fhbf4nrifAOk=;
  b=PNxbiMqPkJxVwjk5B8Ky5aeWWvIzR+9dcHRIJKyPuw5Ew/Vz1x4yd0Ri
   6O56dD6ZFaapKB59JAlUB2M2QvB2VvkXzH1Xcli8vOWDdYE3u49KV9Cjy
   adiROemAp24rjxLHJRN/4wRZR0YpLdFbvCpOe7ndOQ7K5JiqQqkKGufWp
   bCEwumbkJj15iQbi6Njnpwd6USUVCIAOh6H7UGSbBUnBvthC4D828QGIN
   3J0+hbhRaUeo3nFois2QU90fwFqy+CSZ0e4h5IZmPOgL9Dalxxmzb0Rft
   opYIjAcTLrPUg7QrXyD1RWABtqMhFkEPpOdO3d+kamj3R2vvnu+fzj4zT
   A==;
X-CSE-ConnectionGUID: /N/+UCIQSPKRIp/22btPgg==
X-CSE-MsgGUID: dTtiJms3QQWPmaMnPAXcDw==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="51726020"
X-IronPort-AV: E=Sophos;i="6.16,229,1744095600"; 
   d="scan'208";a="51726020"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 17:02:40 -0700
X-CSE-ConnectionGUID: Wti2ywKcS5eRujP6Nc9mkw==
X-CSE-MsgGUID: PpUBkUNNTcSTsarIOJAnUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,229,1744095600"; 
   d="scan'208";a="147840718"
Received: from spandruv-desk1.amr.corp.intel.com (HELO [10.125.111.168]) ([10.125.111.168])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 17:02:39 -0700
Message-ID: <4cd83424-c38e-4fc0-8df3-0d37b67d15b8@intel.com>
Date: Wed, 11 Jun 2025 17:02:36 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH v3] test: fail on unexpected kernel error & warning,
 not just "Call Trace"
To: marc.herbert@linux.intel.com, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, alison.schofield@intel.com, dan.j.williams@intel.com
References: <20250611235256.3866724-1-marc.herbert@linux.intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20250611235256.3866724-1-marc.herbert@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/11/25 4:44 PM, marc.herbert@linux.intel.com wrote:
> v3 changes:
> 
> - One-line fix of kmsg_no_fail_on exclusion of the warning "Extended
>   linear cache calculation failed". Fixes test failures since kernel
>   commit de7fb30a5870 ("Add extended linear cache support for CXL").
> 
> v2 major changes:
> 
> - The old $SECONDS variable is dropped from journalctl. Which allows:
> - ... dropping the very short-lived COOLDOWN proposed in version 1.
> - A new, optional NDTEST_LOG_DBG code which allows "stress testing"
>   the approach and proving that it is safe.
> 
> I tested and compared for many hours $SECONDS versus the NDTEST_START
> approach that Alison submitted a few months ago and the conclusion is
> very clear:
> - $SECONDS does require a ~1.2 cool down between every test. As it was
>   done in v1.
> - NDTEST_START requires zero cool down.
> 
> So that is why I dropped $SECONDS and the cool down.
> 
> 
>> Split them into a patchset for easier review and then I'll take a
>> look. Thanks!
> 
> There are 3 logical changes in the main commit:
> 
> A1) Dropping $SECONDS, replaced with NDTEST_START
> 
> A2) The new NDTEST_LOG_DBG which was/is critical for:
>    - proving that $SECONDS required a "cool down" (with version 1)
>    - proving NDTEST_START does _not_ require any cool down, safe
>      even without any.
> 
> B) The new, _harden_ journalctl check in check_dmesg() and its
>    kmsg_fail_if_missing and kmsg_no_fail_on. The main feature!
> 
> 
> - B) requires A1) because $SECONDS is too imprecise. With B) only, the
>   tests fail.
> 
> - The A2) test code achieves nothing without B), it cannot prove
>   anything without B).
> 
> - A1) and A2) are logically independent but their code are fairly
>   intertwined and very painful to separate. Plus, B) would have to sit
>   in the middle: A1->B->A2
> 
> Long story short:
> 
> - while they could be logically separate, these changes are tightly
> coupled with each other.
> 
> - breaking down that (relatively small) commit is theoretically
> possible but would be very labor intensive. I know because I just went
> through a similar "git action"  to compare $SECONDS versus
> NDTEST_START for COOLDOWN reasons and it was not fun at all.
> 
> 


Not bash expert, but LGTM for the series
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
