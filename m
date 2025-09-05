Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE45315D37
	for <nvdimm@lists.linux.dev>; Fri,  5 Sep 2025 23:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757115289; cv=none; b=WdmST5QjKShIBOzNWz0d3ck4w9NVQ3jRERr2ky94OCVdUJBEYblNcnuMNbken7Kdxy/gw30zM9rEcPU9wLi13KQYgTNUVtgm2lRVLB6kCqZ3fB6ELHBoN3NXk+VS37z3lBK1vo0Eh7Gi3PPj2vbKTJVdwOfnY4zCRyNYqjCK3Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757115289; c=relaxed/simple;
	bh=DT4cro1N7MYfdf5fNikymey3tQEfgPTcwFcguFiJF9o=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=tkdsOq1xragSekEcTK6GVyMHN+tsRkhYTcKKQosP+0FE7LJgPdiLyXpco0qcVAQeL2pTOlRpolAGDXaSx8zNwyt1CDoAsL/PWb+3TQBx7KJJmJ3qQu6GcAeWhwdJvHYHFtW83H4fwGrCjATYhVxUxu2zElUWi/SHYHNWZpaZHG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F8F5qyxd; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F8F5qyxd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757115288; x=1788651288;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=DT4cro1N7MYfdf5fNikymey3tQEfgPTcwFcguFiJF9o=;
  b=F8F5qyxdvvEq3xO7+SoOiDEYT0fu2wXt95DFc2NXwrT5+BgddXYtIUQ0
   7zpVVrrusVmA+OztBT2gAV9O7EjUSy6TOQiOWNU3uJ/+N3UUYj8kmmjSc
   7ZvHEPXuJcFm25/LFEohsnN8iuyXfHPeCrvtf8fdeEVatF8dqrXjzDn2w
   UV7rwAeBrqjFDVEVfiH/bNtbh/9rINRWRTDuz9WEpJhHz+39Ox6RDDF3P
   iy8tgdgyXKuhg1cQM3s16aQM69hAgvtZBP2Ijc9HgyMpAPkZ0nbX3uqup
   /F2mf6f3LnqgQ57Aidm2d2W7Xusv/yxUoXXQf/FXyj96JDz5TXwoPRQ7F
   g==;
X-CSE-ConnectionGUID: 33PF1i5yRsGei9cIzMLExA==
X-CSE-MsgGUID: T01X/aqBT7Wf3bmsFvC1fg==
X-IronPort-AV: E=McAfee;i="6800,10657,11544"; a="62099601"
X-IronPort-AV: E=Sophos;i="6.18,242,1751266800"; 
   d="scan'208";a="62099601"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2025 16:34:47 -0700
X-CSE-ConnectionGUID: PXXHzkLbSoi8cqyFYCKRoA==
X-CSE-MsgGUID: Iqix/Ed0TniA5dkOGP7aGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,242,1751266800"; 
   d="scan'208";a="177482632"
Received: from msatwood-mobl.amr.corp.intel.com (HELO [10.125.110.53]) ([10.125.110.53])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2025 16:34:47 -0700
Message-ID: <1c8b14d9-adfb-4154-8d7b-a1cd28a13048@intel.com>
Date: Fri, 5 Sep 2025 16:34:46 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH v3] test/cxl-poison.sh: test inject and clear poison
 by region offset
To: alison.schofield@intel.com, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org
References: <20250823025954.3161194-1-alison.schofield@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20250823025954.3161194-1-alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/22/25 7:59 PM, alison.schofield@intel.com wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> The CXL kernel driver recently added support to inject and clear
> poison in a region by specifying an offset. Add a test case to the
> existing cxl-poison unit test that demonstrates how to use the new
> debugfs attributes. Use the kernel trace log to validate the round
> trip address translations.
> 
> SKIP, do not fail, if the new debugfs attributes are not present.
> 
> See the kernel ABI documentation for usage:
> Documentation/ABI/testing/debugfs-cxl
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

Not bash expert, but LGTM.

> ---
> 
> Changes in v3:
> Replace string compare with boolean value for expect_fail (Marc)
> Add local declarations in new or modified funcs (Marc)
> De-duplicate clear & poison funcs (Marc)
> Remove stderr redirection (Marc)
> 
> Changes in v2:
> Add test_poison_by_region_offset_negative set of test cases
> 
> 
>  test/cxl-poison.sh | 132 +++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 117 insertions(+), 15 deletions(-)
> 
> diff --git a/test/cxl-poison.sh b/test/cxl-poison.sh
> index 6ed890bc666c..f941f3cbcffd 100644
> --- a/test/cxl-poison.sh
> +++ b/test/cxl-poison.sh
> @@ -63,20 +63,58 @@ create_x2_region()
>  # When cxl-cli support for inject and clear arrives, replace
>  # the writes to /sys/kernel/debug with the new cxl commands.
>  
> +_do_poison_sysfs()
> +{
> +	local action="$1" dev="$2" addr="$3"
> +	local expect_fail=${4:-false}
> +
> +	if "$expect_fail"; then
> +		if echo "$addr" > "/sys/kernel/debug/cxl/$dev/${action}_poison"; then
> +			echo "Expected ${action}_poison to fail for $addr"
> +			err "$LINENO"
> +		fi
> +	else
> +		echo "$addr" > "/sys/kernel/debug/cxl/$dev/${action}_poison"
> +	fi
> +}
> +
>  inject_poison_sysfs()
>  {
> -	memdev="$1"
> -	addr="$2"
> -
> -	echo "$addr" > /sys/kernel/debug/cxl/"$memdev"/inject_poison
> +	_do_poison_sysfs 'inject' "$@"
>  }
>  
>  clear_poison_sysfs()
>  {
> -	memdev="$1"
> -	addr="$2"
> +	_do_poison_sysfs 'clear' "$@"
> +}
>  
> -	echo "$addr" > /sys/kernel/debug/cxl/"$memdev"/clear_poison
> +check_trace_entry()
> +{
> +	local expected_region="$1"
> +	local expected_hpa="$2"
> +
> +	local trace_line
> +	trace_line=$(grep "cxl_poison" /sys/kernel/tracing/trace | tail -n 1)
> +	if [[ -z "$trace_line" ]]; then
> +		echo "No cxl_poison trace event found"
> +		err "$LINENO"
> +	fi
> +
> +	local trace_region trace_hpa
> +	trace_region=$(echo "$trace_line" | grep -o 'region=[^ ]*' | cut -d= -f2)
> +	trace_hpa=$(echo "$trace_line" | grep -o 'hpa=0x[0-9a-fA-F]\+' | cut -d= -f2)
> +
> +	if [[ "$trace_region" != "$expected_region" ]]; then
> +		echo "Expected region $expected_region not found in trace"
> +		echo "$trace_line"
> +		err "$LINENO"
> +	fi
> +
> +	if [[ "$trace_hpa" != "$expected_hpa" ]]; then
> +		echo "Expected HPA $expected_hpa not found in trace"
> +		echo "$trace_line"
> +		err "$LINENO"
> +	fi
>  }
>  
>  validate_poison_found()
> @@ -97,7 +135,7 @@ validate_poison_found()
>  	fi
>  }
>  
> -test_poison_by_memdev()
> +test_poison_by_memdev_by_dpa()
>  {
>  	find_memdev
>  	inject_poison_sysfs "$memdev" "0x40000000"
> @@ -113,9 +151,8 @@ test_poison_by_memdev()
>  	validate_poison_found "-m $memdev" 0
>  }
>  
> -test_poison_by_region()
> +test_poison_by_region_by_dpa()
>  {
> -	create_x2_region
>  	inject_poison_sysfs "$mem0" "0x40000000"
>  	inject_poison_sysfs "$mem1" "0x40000000"
>  	validate_poison_found "-r $region" 2
> @@ -125,13 +162,78 @@ test_poison_by_region()
>  	validate_poison_found "-r $region" 0
>  }
>  
> -# Turn tracing on. Note that 'cxl list --media-errors' toggles the tracing.
> -# Turning it on here allows the test user to also view inject and clear
> -# trace events.
> +test_poison_by_region_offset()
> +{
> +	local base gran hpa1 hpa2
> +	base=$(cat /sys/bus/cxl/devices/"$region"/resource)
> +	gran=$(cat /sys/bus/cxl/devices/"$region"/interleave_granularity)
> +
> +	# Test two HPA addresses: base and base + granularity
> +	# This hits the two memdevs in the region interleave.
> +	hpa1=$(printf "0x%x" $((base)))
> +	hpa2=$(printf "0x%x" $((base + gran)))
> +
> +	# Inject at the offset and check result using the hpa's 
> +	# ABI takes an offset, but recall the hpa to check trace event
> +
> +	inject_poison_sysfs "$region" 0
> +	check_trace_entry "$region" "$hpa1"
> +	inject_poison_sysfs "$region" "$gran"
> +	check_trace_entry "$region" "$hpa2"
> +	validate_poison_found "-r $region" 2
> +
> +	clear_poison_sysfs "$region" 0
> +	check_trace_entry "$region" "$hpa1"
> +	clear_poison_sysfs "$region" "$gran"
> +	check_trace_entry "$region" "$hpa2"
> +	validate_poison_found "-r $region" 0
> +}
> +
> +test_poison_by_region_offset_negative()
> +{
> +	local region_size cache_size cache_offset exceed_offset large_offset
> +	region_size=$(cat /sys/bus/cxl/devices/"$region"/size)
> +	cache_size=0
> +
> +	# This case is a no-op until cxl-test ELC mocking arrives
> +	# Try to get cache_size if the attribute exists
> +	if [ -f "/sys/bus/cxl/devices/$region/cache_size" ]; then
> +		cache_size=$(cat /sys/bus/cxl/devices/"$region"/cache_size)
> +	fi
> +
> +	# Offset within extended linear cache (if cache_size > 0)
> +	if [[ $cache_size -gt 0 ]]; then
> +		cache_offset=$((cache_size - 1))
> +		echo "Testing offset within cache: $cache_offset (cache_size: $cache_size)"
> +		inject_poison_sysfs "$region" "$cache_offset" true
> +		clear_poison_sysfs "$region" "$cache_offset" true
> +	else
> +		echo "Skipping cache test - cache_size is 0"
> +	fi
> +
> +	# Offset exceeds region size
> +	exceed_offset=$((region_size))
> +	inject_poison_sysfs "$region" "$exceed_offset" true
> +	clear_poison_sysfs "$region" "$exceed_offset" true
> +
> +	# Offset exceeds region size by a lot
> +	large_offset=$((region_size * 2))
> +	inject_poison_sysfs "$region" "$large_offset" true
> +	clear_poison_sysfs "$region" "$large_offset" true
> +}
> +
> +# Clear old trace events, enable cxl_poison, enable global tracing
> +echo "" > /sys/kernel/tracing/trace
>  echo 1 > /sys/kernel/tracing/events/cxl/cxl_poison/enable
> +echo 1 > /sys/kernel/tracing/tracing_on
>  
> -test_poison_by_memdev
> -test_poison_by_region
> +test_poison_by_memdev_by_dpa
> +create_x2_region
> +test_poison_by_region_by_dpa
> +[ -f "/sys/kernel/debug/cxl/$region/inject_poison" ] ||
> +       do_skip "test cases requires inject by region kernel support"
> +test_poison_by_region_offset
> +test_poison_by_region_offset_negative
>  
>  check_dmesg "$LINENO"
>  

