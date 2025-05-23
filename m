Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9691F3B87
	for <nvdimm@lists.linux.dev>; Fri, 23 May 2025 21:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748035264; cv=none; b=CF5217bEKxZy5+A/bfC5qAdWX1nNio3Y1PqTgiJIowoQx18sfuJoM1/NXEadjPhY3tfMiEJ+WwydmRlsGYitcRukkS1Jvvj81Lls54b1btMwq4oQeEh4ShcWsl4zoRDPSfqUkYxTh8gekngqiD9/J5nqWyqYgAwy8KZoIIwzz+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748035264; c=relaxed/simple;
	bh=SxY5ImWL/BAEFRIn7MY2TpA1pe+cC2XJMThAAc0ui2A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lfd6Ped9uUz0jJxwvL9mFJLbaCIRnbRkVBS/2DiIqCMpHfia4xi+HAm0HllBlOTpzjbi9whtP8JNsvxkJ4Jo9rWhpfltp6BCIbH+RUwxACNj9/BAM1eTrXSBM/btp6B+rPiURmLgdNHYbzU3dpxOTrkc1IQNm021UDcGmoLlAcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K56NmCQs; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K56NmCQs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748035262; x=1779571262;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=SxY5ImWL/BAEFRIn7MY2TpA1pe+cC2XJMThAAc0ui2A=;
  b=K56NmCQsHXRhJk8gE2xNAefiWfUWseXfk/b+f/dCtC0bs0kUuSQur4LT
   /bEk51/A/dP2QB97B5/MsPNr0Ods2w4NmAUZoWOBQOOhn/jSPFoBb0rDp
   daXptV+Pjx2seJODVuAzQA2RFT8kFSjdVFNylnZffaoUAHJD1F9YATHtx
   1a8vBOgbmfSD1N7rUn58edqqv9Ki7IIZnjs8c+78UmYT7Y7fOKet0Lvqf
   obsDsphmiYz0no4IqY5f+94LaLO10WD+C5cGTm9BE60QuJazIsVMi4k33
   TZCbTdJHxs+nYNTgquARXYVmgUzqJFjXSnpCOSyJfY5wJ8vziiLTIY2S+
   w==;
X-CSE-ConnectionGUID: Efc8XkakT/uClhzgrHWSCg==
X-CSE-MsgGUID: 0NVmFJgPQG2rCido8HaHXg==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="60735740"
X-IronPort-AV: E=Sophos;i="6.15,309,1739865600"; 
   d="scan'208";a="60735740"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 14:21:01 -0700
X-CSE-ConnectionGUID: b0qfHEfWSHu6/lnUMGO83A==
X-CSE-MsgGUID: cLOeG485Q2iBy6c57y+zxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,309,1739865600"; 
   d="scan'208";a="141358962"
Received: from c02x38vbjhd2mac.jf.intel.com (HELO [10.54.75.6]) ([10.54.75.6])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 14:21:02 -0700
Message-ID: <912b25f7-95be-4933-b024-909bf6eb925f@linux.intel.com>
Date: Fri, 23 May 2025 14:20:50 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [NDCTL PATCH v9 4/4] cxl/test: Add test for cxl features device
Content-Language: en-GB
To: Dave Jiang <dave.jiang@intel.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev
Cc: alison.schofield@intel.com, Dan Williams <dan.j.williams@intel.com>
References: <20250523164641.3346251-1-dave.jiang@intel.com>
 <20250523164641.3346251-5-dave.jiang@intel.com>
From: Marc Herbert <marc.herbert@linux.intel.com>
In-Reply-To: <20250523164641.3346251-5-dave.jiang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Again, apologies for commenting so late (v9).

I reviewed only the shell script below and all these comments
could be "future improvements" post merge. Or, before merge
if there is a v10.

On 2025-05-23 09:46, Dave Jiang wrote:
> --- /dev/null
> +++ b/test/cxl-features.sh
> @@ -0,0 +1,37 @@
> +#!/bin/bash -Ex
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2025 Intel Corporation. All rights reserved.
> +
> +main()
> +{
> +    local rc=77
> +    # 237 is -ENODEV
> +    ERR_NODEV=237

Nit: local ERR_NODEV=237

> +
> +    . $(dirname "$0")/common

Mmmm... interesting, moving this too goes beyond what I recommended but
maybe it's better?

In theory, sourced files have no side-effect or barely. In practice
though...

LGTM!

> +    FEATURES="$TEST_PATH"/fwctl
> +
> +    trap 'err $LINENO' ERR
> +
> +    modprobe cxl_test
> +
> +    test -x "$FEATURES" || do_skip "no CXL Features Control"
> +
> +    rc=0
> +    "$FEATURES" || rc=$?
> +
> +    echo "error: $rc"

echo "status: $rc"

> +    if [ "$rc" -eq "$ERR_NODEV" ]; then
> +	do_skip "no CXL FWCTL char dev"
> +    elif [ "$rc" -ne 0 ]; then
> +	echo "fail: $LINENO" && exit 1
> +    fi
> +
> +    trap 'err $LINENO' ERR

I had a chat with David and he confirmed this duplicate is an oversight.

> +
> +    _cxl_cleanup
> +}
> +
> +{
> +    main "$@"; exit "$?"
> +}
