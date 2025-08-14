Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D63125A0
	for <nvdimm@lists.linux.dev>; Thu, 14 Aug 2025 01:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755133369; cv=none; b=l/s5Q5ru4DPHrrKziSE7Fsmja7XvQtrSPUzLwCFCZ0DYkdOw8YTV9f5YjngNM1BABl95SD3VitVZ9PmZU4QnJTo0dapfGurXGEvuRHyoh5bei8urf4WIGNqDSVlXGtRXmDt3TKsh5vJE4m6g6cG8aT1NKnLjFf0xlfzx247cMh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755133369; c=relaxed/simple;
	bh=vGpvQ0XxAjHUmW5Efzt3PpNL/cb1AGgKYMbCK+CXRLA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=L0D4KE1CkbTMfBIbrDjaOxNN9TjXQQh4ycpFgAST8s/F63tkG59uuZ0AQrShLp5wjeIGvdJNYGfV9HKkG3dz6PSUriTML/mW2x7cF8wycWlVGqm8kCbOGeWomYHXchKw7zVnG/nQY62saOJMbWtFUMTWrK9HsqbdOlj1+7VEZjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q+fV4JFd; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q+fV4JFd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755133369; x=1786669369;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=vGpvQ0XxAjHUmW5Efzt3PpNL/cb1AGgKYMbCK+CXRLA=;
  b=Q+fV4JFdIPpHNeUwarGbSmiQ9CnZu0CiSH4LLayda/lViS3IQtKvuWhI
   iL2HytuL3U+XW+CjweDwMsrj3dzpWzcZxK2v7mv/m7vRj6OUCnz87IV6l
   OPqn6khgJfco/h0toJsFOQEapM+wah2FdoYO7DBlMGVkNM6ia6MbNini1
   hyGjwYSfF2+Lsv1g1ywTYgFBbfgkUjIPfx/WKRixVSgkg6VFfimiTCOPl
   565AiwAJsdOxhPJkCVsWnc7S1lXh9C4uf9TcGjQcub5VMMxcgRvmoBCRY
   5G3dlV+8C0soX4sRFhZPEAUG7149gfQkBr4v+otTVWoj8TDbQoUUKqts0
   Q==;
X-CSE-ConnectionGUID: Uy0IBPdGSC2i1ACgTi5PcQ==
X-CSE-MsgGUID: d+Z/WXMHTB+vnGPO2c1ccQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="68896913"
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="68896913"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 18:02:46 -0700
X-CSE-ConnectionGUID: v6mzb3MTSp+BV6OCoKdQ1A==
X-CSE-MsgGUID: zf7pvjUoRyiBsUB4emmxqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="203801336"
Received: from c02x38vbjhd2mac.jf.intel.com (HELO [10.54.75.17]) ([10.54.75.17])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 18:02:46 -0700
Message-ID: <5dc34767-7104-4184-b18f-44f9d3b9f483@linux.intel.com>
Date: Wed, 13 Aug 2025 18:02:39 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH v2] test/cxl-poison.sh: test inject and clear poison
 by region offset
Content-Language: en-GB
To: alison.schofield@intel.com, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org
References: <20250804081403.2590033-1-alison.schofield@intel.com>
From: Marc Herbert <marc.herbert@linux.intel.com>
In-Reply-To: <20250804081403.2590033-1-alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Reviewing only the shell language part of this, not the CXL logic.

On 2025-08-04 01:14, alison.schofield@intel.com wrote:
>  
>  inject_poison_sysfs()
>  {
> -	memdev="$1"
> +	dev="$1"
>  	addr="$2"
> +	expect_fail="$3"

You can make expect_fail and maybe others "local" instead of global
(the default).

  
> -	echo "$addr" > /sys/kernel/debug/cxl/"$memdev"/inject_poison
> +	if [[ "$expect_fail" == "true" ]]; then

It looks like this script has full control over $expect_fail, never
affected by any outside input. So you can trust it and simplify this to:

        local expect_fail=${3-:false}

        ...

        if "$expect_fail"; then


> +		if echo "$addr" > /sys/kernel/debug/cxl/"$dev"/inject_poison 2>/dev/null; then

Is it expected that this particular /sys may not exist in some test
conditions? If not, then there's no reason to discard stderr.

stderr is generally just for "totally unexpected" issues and should
almost never discarded. Especially not in test code where you really
want to get all the information possible when something totally
unexpected happens. Even more so when this happens in some distant CI
system few people have direct access to for reproduction.

In the extremely rare cases where stderr should be discarded, there
needs to be comment with a convincing rationale for it.


> +			echo "Expected inject_poison to fail for $addr"
> +			err "$LINENO"
> +		fi
> +	else
> +		echo "$addr" > /sys/kernel/debug/cxl/"$dev"/inject_poison
> +	fi
>  }
>  
>  clear_poison_sysfs()
>  {

Same as above. In fact there seems to be only word difference between
these two functions, which begs for something like this:

inject_poison_sysfs()
{
   _do_poison_sysfs 'inject' "$@"
}

clear_poison_sysfs()
{
   _do_poison_sysfs 'clear' "$@"
}



> -	memdev="$1"
> +	dev="$1"
>  	addr="$2"
> +	expect_fail="$3"
>  
> -	echo "$addr" > /sys/kernel/debug/cxl/"$memdev"/clear_poison
> +	if [[ "$expect_fail" == "true" ]]; then
> +		if echo "$addr" > /sys/kernel/debug/cxl/"$dev"/clear_poison 2>/dev/null; then
> +			echo "Expected clear_poison to fail for $addr"
> +			err "$LINENO"
> +		fi
> +	else
> +		echo "$addr" > /sys/kernel/debug/cxl/"$dev"/clear_poison
> +	fi
> +}
> +
> +check_trace_entry()
> +{
> +	expected_region="$1"
> +	expected_hpa="$2"
> +	trace_line=$(grep "cxl_poison" /sys/kernel/tracing/trace | tail -n 1)

Probably "local" (but don't forget SC2155)

Nit: you can save one process and one pipe with awk:

    local trace_line; trace_line=$( awk '/cxl_poison' { L=$0 } END { print L }' /sys/kernel/tracing/trace )


> +	if [[ -z "$trace_line" ]]; then
> +		echo "No cxl_poison trace event found"
> +		err "$LINENO"
> +	fi
> +
> +	trace_region=$(echo "$trace_line" | grep -o 'region=[^ ]*' | cut -d= -f2)

I think sed is more typical for this sort of stuff but whatever works.


> -# Turn tracing on. Note that 'cxl list --media-errors' toggles the tracing.
> -# Turning it on here allows the test user to also view inject and clear
> -# trace events.
> +test_poison_by_region_offset()
> +{
> +	base=$(cat /sys/bus/cxl/devices/"$region"/resource)
> +	gran=$(cat /sys/bus/cxl/devices/"$region"/interleave_granularity)

local if that makes sense.

