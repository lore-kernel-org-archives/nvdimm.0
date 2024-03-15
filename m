Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9634CB3D
	for <nvdimm@lists.linux.dev>; Fri, 15 Mar 2024 17:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710522233; cv=none; b=Rnl5nCSVLhCCti4++nBlLvB+9iz4XAAJQanp8GwoA7ZrlgVJBjBMH+g37oJoubYRypCHqSbftTNjuEvJA/1HBD2YdURNMObmcUGEHaeEG+wN181e24NpYDE3rg8Mfx0lqzLhY+PfUmolx8jJbU38OGAHG4M/6rMbItEqpjv0Klo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710522233; c=relaxed/simple;
	bh=exzj0R21fp2h+26a16KmShW4O8IRsX1QWszwOKuXZ1w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kcmqCGWzvoIOE2pu8rSWUNDxi4B/hHLiKiGG5JnOIg8yc+EZ+87EkNf6FG4iOSvzTyoD6R4tUf55bvVmQVGJaE8rYb1e/Fj88gXxkbe+eLlt/x/nfLj02FORiKG3jQGLdDxMtkyAzohTvzspsGUZ4NKutjqB6jtDPNOYb1Qrjm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JE0HKThD; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JE0HKThD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710522231; x=1742058231;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=exzj0R21fp2h+26a16KmShW4O8IRsX1QWszwOKuXZ1w=;
  b=JE0HKThDy+JCkufcq49zKI/S4l2onWpz4pP1N0HLmBW8uJ7SF2QYs2bG
   UsWMBTVTbqZzpr5H0cIXGHB3pvnISk2itVvcGvWGZtiL0N5SsdmLTB+fV
   1EwIY/aM6mop0Q3sOx3eKoPnH41dGmMcQ8NiCahJ1wxFe7srkWbUWwNvP
   Oobbxeg0raFyG6yHONdCE+B5HHuK5Xo62F0gZlh4sdRgR2ggUkakZvdSl
   MU0oWCf3cfOJrlPAJabDcDEUhWFt9uNVD+sqkvzAK65vpQlRjYpS80/RN
   0KXoauT2fmgDwk04U86rwpkudpW4XhmH9sZSfaNJmdikBlxdH6C5BG2vz
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11014"; a="5611181"
X-IronPort-AV: E=Sophos;i="6.07,128,1708416000"; 
   d="scan'208";a="5611181"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2024 10:03:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,128,1708416000"; 
   d="scan'208";a="17426245"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.213.163.132]) ([10.213.163.132])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2024 10:03:50 -0700
Message-ID: <c8d35b80-13ae-4510-a953-535c9aaec72b@intel.com>
Date: Fri, 15 Mar 2024 10:03:49 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH v11 7/7] cxl/test: add cxl-poison.sh unit test
Content-Language: en-US
To: alison.schofield@intel.com, Vishal Verma <vishal.l.verma@intel.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
References: <cover.1710386468.git.alison.schofield@intel.com>
 <24c1f2ec413f92e8e6e8817b3d4d55f5bb142849.1710386468.git.alison.schofield@intel.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <24c1f2ec413f92e8e6e8817b3d4d55f5bb142849.1710386468.git.alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/13/24 9:05 PM, alison.schofield@intel.com wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> Exercise cxl list, libcxl, and driver pieces of the get poison list
> pathway. Inject and clear poison using debugfs and use cxl-cli to
> read the poison list by memdev and by region.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  test/cxl-poison.sh | 137 +++++++++++++++++++++++++++++++++++++++++++++
>  test/meson.build   |   2 +
>  2 files changed, 139 insertions(+)
>  create mode 100644 test/cxl-poison.sh
> 
> diff --git a/test/cxl-poison.sh b/test/cxl-poison.sh
> new file mode 100644
> index 000000000000..af2e9dcd1a11
> --- /dev/null
> +++ b/test/cxl-poison.sh
> @@ -0,0 +1,137 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2023 Intel Corporation. All rights reserved.
> +
> +. "$(dirname "$0")"/common
> +
> +rc=77
> +
> +set -ex
> +
> +trap 'err $LINENO' ERR
> +
> +check_prereq "jq"
> +
> +modprobe -r cxl_test
> +modprobe cxl_test
> +
> +rc=1
> +
> +# THEORY OF OPERATION: Exercise cxl-cli and cxl driver ability to
> +# inject, clear, and get the poison list. Do it by memdev and by region.
> +
> +find_memdev()
> +{
> +	readarray -t capable_mems < <("$CXL" list -b "$CXL_TEST_BUS" -M |
> +		jq -r ".[] | select(.pmem_size != null) |
> +		select(.ram_size != null) | .memdev")
> +
> +	if [ ${#capable_mems[@]} == 0 ]; then
> +		echo "no memdevs found for test"
> +		err "$LINENO"
> +	fi
> +
> +	memdev=${capable_mems[0]}
> +}
> +
> +create_x2_region()
> +{
> +	# Find an x2 decoder
> +	decoder="$($CXL list -b "$CXL_TEST_BUS" -D -d root | jq -r ".[] |
> +		select(.pmem_capable == true) |
> +		select(.nr_targets == 2) |
> +		.decoder")"
> +
> +	# Find a memdev for each host-bridge interleave position
> +	port_dev0="$($CXL list -T -d "$decoder" | jq -r ".[] |
> +		.targets | .[] | select(.position == 0) | .target")"
> +	port_dev1="$($CXL list -T -d "$decoder" | jq -r ".[] |
> +		.targets | .[] | select(.position == 1) | .target")"
> +	mem0="$($CXL list -M -p "$port_dev0" | jq -r ".[0].memdev")"
> +	mem1="$($CXL list -M -p "$port_dev1" | jq -r ".[0].memdev")"
> +
> +	region="$($CXL create-region -d "$decoder" -m "$mem0" "$mem1" |
> +		jq -r ".region")"
> +	if [[ ! $region ]]; then
> +		echo "create-region failed for $decoder"
> +		err "$LINENO"
> +	fi
> +	echo "$region"
> +}
> +
> +# When cxl-cli support for inject and clear arrives, replace
> +# the writes to /sys/kernel/debug with the new cxl commands.
> +
> +inject_poison_sysfs()
> +{
> +	memdev="$1"
> +	addr="$2"
> +
> +	echo "$addr" > /sys/kernel/debug/cxl/"$memdev"/inject_poison
> +}
> +
> +clear_poison_sysfs()
> +{
> +	memdev="$1"
> +	addr="$2"
> +
> +	echo "$addr" > /sys/kernel/debug/cxl/"$memdev"/clear_poison
> +}
> +
> +validate_poison_found()
> +{
> +	list_by="$1"
> +	nr_expect="$2"
> +
> +	poison_list="$($CXL list "$list_by" --media-errors |
> +		jq -r '.[].media_errors')"
> +	if [[ ! $poison_list ]]; then
> +		nr_found=0
> +	else
> +		nr_found=$(jq "length" <<< "$poison_list")
> +	fi
> +	if [ "$nr_found" -ne "$nr_expect" ]; then
> +		echo "$nr_expect poison records expected, $nr_found found"
> +		err "$LINENO"
> +	fi
> +}
> +
> +test_poison_by_memdev()
> +{
> +	find_memdev
> +	inject_poison_sysfs "$memdev" "0x40000000"
> +	inject_poison_sysfs "$memdev" "0x40001000"
> +	inject_poison_sysfs "$memdev" "0x600"
> +	inject_poison_sysfs "$memdev" "0x0"
> +	validate_poison_found "-m $memdev" 4
> +
> +	clear_poison_sysfs "$memdev" "0x40000000"
> +	clear_poison_sysfs "$memdev" "0x40001000"
> +	clear_poison_sysfs "$memdev" "0x600"
> +	clear_poison_sysfs "$memdev" "0x0"
> +	validate_poison_found "-m $memdev" 0
> +}
> +
> +test_poison_by_region()
> +{
> +	create_x2_region
> +	inject_poison_sysfs "$mem0" "0x40000000"
> +	inject_poison_sysfs "$mem1" "0x40000000"
> +	validate_poison_found "-r $region" 2
> +
> +	clear_poison_sysfs "$mem0" "0x40000000"
> +	clear_poison_sysfs "$mem1" "0x40000000"
> +	validate_poison_found "-r $region" 0
> +}
> +
> +# Turn tracing on. Note that 'cxl list --poison' does toggle the tracing.
> +# Turning it on here allows the test user to also view inject and clear
> +# trace events.
> +echo 1 > /sys/kernel/tracing/events/cxl/cxl_poison/enable
> +
> +test_poison_by_memdev
> +test_poison_by_region
> +
> +check_dmesg "$LINENO"
> +
> +modprobe -r cxl-test
> diff --git a/test/meson.build b/test/meson.build
> index a965a79fd6cb..d871e28e17ce 100644
> --- a/test/meson.build
> +++ b/test/meson.build
> @@ -160,6 +160,7 @@ cxl_events = find_program('cxl-events.sh')
>  cxl_sanitize = find_program('cxl-sanitize.sh')
>  cxl_destroy_region = find_program('cxl-destroy-region.sh')
>  cxl_qos_class = find_program('cxl-qos-class.sh')
> +cxl_poison = find_program('cxl-poison.sh')
>  
>  tests = [
>    [ 'libndctl',               libndctl,		  'ndctl' ],
> @@ -192,6 +193,7 @@ tests = [
>    [ 'cxl-sanitize.sh',        cxl_sanitize,       'cxl'   ],
>    [ 'cxl-destroy-region.sh',  cxl_destroy_region, 'cxl'   ],
>    [ 'cxl-qos-class.sh',       cxl_qos_class,      'cxl'   ],
> +  [ 'cxl-poison.sh',          cxl_poison,         'cxl'   ],
>  ]
>  
>  if get_option('destructive').enabled()
