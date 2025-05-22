Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40047083A
	for <nvdimm@lists.linux.dev>; Thu, 22 May 2025 17:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747936006; cv=none; b=ALry7xJmdqY4Q8PabgfR3j5+4Pd4a7MfKOGpVksKt8HUPpJLqAwCnQJY6bBu71/DCCHPl+Tt6NyUGo9jFG6cXdrCdTW2IifKLKPr5NaToG0+sLSQtTsVdDQkiMC1+avKckmA54YqhalqmBj8S6NSE9NBSB6yuMWvdMMtlXa+ukI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747936006; c=relaxed/simple;
	bh=GtRx7cMCA48zwGKavyTe7XHclHwjcUl6APkQp9JEpzk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZZZDVnqRgGkshbxTfuAawSt2SuUDDSS56XiTkZlly0KME6mzdJVVc0A9PdJN+SqxRngt5/iblycVoZTKKsQYBNrsErJgQJK7AqQ7tHUZKgsCRuihgbFdNCZtvfTRRsrqft0intZJvt6bN3AbRFHDa5Qt2cjytIiGUNVdGVG6tMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TOgz3hDc; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TOgz3hDc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747936005; x=1779472005;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=GtRx7cMCA48zwGKavyTe7XHclHwjcUl6APkQp9JEpzk=;
  b=TOgz3hDc5yJ8h7OP6r8L740U+1IiB0QNJgVl6lFyMOXSloUdaEwc2I5C
   IgPGh5PEy11ZXuJbgoB6LyH0NeNQtHTj22JvJ80vR4Gu/raeT5qjM0DOV
   OBm9ei0AkzZYNBGqVTlHknZM8++Xw+1m6oWtdU25E1OTzLY3W2zy8Qb+K
   QjJk8JFcigtO3hclyfii5p2BRLlRaE1P13hel00s17DElijKS/LR23Qyc
   gj17m4yIbS9KS6yF4iUnKaMI6mriWfS5L6jB/ZsYQsaaScam9GoBKwmkQ
   JPYPCHVGBuL7PoNlJC3aB3G3JBA3a2f255bmEmMFGL+X2VXR2OYvyo2vS
   A==;
X-CSE-ConnectionGUID: xWNpl/FIRQyrs6l0daAj0A==
X-CSE-MsgGUID: 62zFnYAPR2CwKyn+FPhg7g==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="52606119"
X-IronPort-AV: E=Sophos;i="6.15,306,1739865600"; 
   d="scan'208";a="52606119"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 10:46:28 -0700
X-CSE-ConnectionGUID: Q/IBYLElSRK9HzwT1Nd0Rg==
X-CSE-MsgGUID: LNDnXgTPS5CZ/UIiRayM6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,306,1739865600"; 
   d="scan'208";a="140506158"
Received: from adavare-mobl.amr.corp.intel.com (HELO [10.125.186.118]) ([10.125.186.118])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 10:46:28 -0700
Message-ID: <b1043cc3-c3be-45a3-b093-7ffba9f5d204@linux.intel.com>
Date: Thu, 22 May 2025 10:46:25 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [NDCTL PATCH v8 4/4] cxl/test: Add test for cxl features device
Content-Language: en-GB
To: Dave Jiang <dave.jiang@intel.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev
Cc: alison.schofield@intel.com, Dan Williams <dan.j.williams@intel.com>
References: <20250522155653.1346768-1-dave.jiang@intel.com>
 <20250522155653.1346768-5-dave.jiang@intel.com>
From: Marc Herbert <Marc.Herbert@linux.intel.com>
In-Reply-To: <20250522155653.1346768-5-dave.jiang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

[Sorry for commenting for the first time on v8]

Could you move all the cxl-features.sh code to a
main() function and then call main "$@" at the end?

It's a pretty standard practice and has many benefits listed here:
https://github.com/thesofproject/sof-test/issues/740

More inline

On 2025-05-22 08:56, Dave Jiang wrote:

> diff --git a/test/cxl-features.sh b/test/cxl-features.sh
> new file mode 100755
> index 000000000000..a730310ec7b0
> --- /dev/null
> +++ b/test/cxl-features.sh
> @@ -0,0 +1,31 @@
> +#!/bin/bash -Ex
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2025 Intel Corporation. All rights reserved.
> +
> +rc=77

Once this is a function:

 local rc=77


> +# 237 is -ENODEV
> +ERR_NODEV=237
> +
> +. $(dirname $0)/common
> +FEATURES="$TEST_PATH"/fwctl
> +
> +trap 'err $LINENO' ERR
> +
> +modprobe cxl_test
> +
> +test -x "$FEATURES" || do_skip "no CXL Features Control"
> +# disable trap
> +trap - $(compgen -A signal)

ALL of them? Is that really necessary? Or just ERR maybe?
A comment maybe?
traps are usually the reserved domain of test/common.

If this just for ERR, then you shouldn't need to change
traps at all:

rc=0
"$FEATURES" || rc=$?

|| and friends turn off "set -e" and "trap ERR" temporarily
(otherwise they would be incompatible with each other)
    

> +"$FEATURES"
> +rc=$?
> +
> +echo "error: $rc"
> +if [ "$rc" -eq "$ERR_NODEV" ]; then
> +	do_skip "no CXL FWCTL char dev"
> +elif [ "$rc" -ne 0 ]; then
> +	echo "fail: $LINENO" && exit 1
> +fi
> +
> +trap 'err $LINENO' ERR

In a distant future this should live in test/common...

> +
> +_cxl_cleanup

