Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2335B84FBD
	for <nvdimm@lists.linux.dev>; Thu,  8 Feb 2024 18:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.134.136.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707416287; cv=none; b=lwSpNgRK3SAUA2h2thr+wsz2DIlnnv4b22DsIzpD7mSVhzsD6vPkxbJUPCqZ3/5TSKzYMBDcKTvT8FndPs+P7jiXQtL8SIWChR+KzOCq1rPrkuttamIvwv/9FS6+av7v8PzViFfTFfFmiJEKCvoCKM8fT5/He92xzruMWRGf7qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707416287; c=relaxed/simple;
	bh=ez/TkWAkh28jFhrugD5Qt6GcTfab+4MkK7w8OFqyQaM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ReqRZnzCYr6lmge/SZJ0Ugl1QhtcSQv9OqOXxI5jMqNrgrWwDekJTQj8bTWcU6zPDfj6dn9/qjJ1WWz5LVhQWdjYELjXOP89rumeH2P38y3UYks1N6CXlIW6aRWPoGAiV+BEJnph+0UKG9iWVNfofhuret1/a3pM7imQQxppKtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SK2tSB6b; arc=none smtp.client-ip=134.134.136.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SK2tSB6b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707416284; x=1738952284;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ez/TkWAkh28jFhrugD5Qt6GcTfab+4MkK7w8OFqyQaM=;
  b=SK2tSB6bYTX8dAIaGp+ijlMgRr40IngAN21fqfhHWkU79J18QmxbgMIB
   7ydbq5wWFNObRNOzXfBdBFNlGl+baVNM9KvBb0CDUTVdvPRZEhq6mHT9f
   AoOQiQ9PfIkoWshKlQIu7MCJ2KWL4dmDFvgYtHsGcLnnxgPadg0O/VyAz
   wZwUEzCtMxCE9pOtYNvueD1VakkCxRFbjbNg/asNegP6j3feEPFN+mYI2
   x1EdwuHYeSIt/n4+Bjz1BWMFaWoNdQv6K9D6MomQjboYH9JoWkUtRyGu0
   9uZWbvXOFcYUmqdbb2TyXZ6zBVcpBnzdgcGqXp83yU7hc09QGJNTINp5q
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10978"; a="395699270"
X-IronPort-AV: E=Sophos;i="6.05,254,1701158400"; 
   d="scan'208";a="395699270"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2024 10:18:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,254,1701158400"; 
   d="scan'208";a="6360791"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.246.113.125]) ([10.246.113.125])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2024 10:18:02 -0800
Message-ID: <9aa5564b-d649-4fcc-aaba-a39851accb9c@intel.com>
Date: Thu, 8 Feb 2024 11:18:01 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH v7 7/7] cxl/test: add cxl-poison.sh unit test
Content-Language: en-US
To: alison.schofield@intel.com, Vishal Verma <vishal.l.verma@intel.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
References: <cover.1707351560.git.alison.schofield@intel.com>
 <855025e88e0c261ae36dd6bd70443ebd9e7e5e6f.1707351560.git.alison.schofield@intel.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <855025e88e0c261ae36dd6bd70443ebd9e7e5e6f.1707351560.git.alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2/7/24 6:01 PM, alison.schofield@intel.com wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> Exercise cxl list, libcxl, and driver pieces of the get poison list
> pathway. Inject and clear poison using debugfs and use cxl-cli to
> read the poison list by memdev and by region.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

Should circle back and use CXL CLI enabled poison injection/clear when that's available. 
> ---
>  test/cxl-poison.sh | 137 +++++++++++++++++++++++++++++++++++++++++++++
>  test/meson.build   |   2 +
>  2 files changed, 139 insertions(+)
>  create mode 100644 test/cxl-poison.sh
> 
> diff --git a/test/cxl-poison.sh b/test/cxl-poison.sh
> new file mode 100644
> index 000000000000..6fceb0f2c360
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
> +        # Find an x2 decoder
> +        decoder="$($CXL list -b "$CXL_TEST_BUS" -D -d root | jq -r ".[] |
> +		select(.pmem_capable == true) |
> +		select(.nr_targets == 2) |
> +		.decoder")"
> +
> +        # Find a memdev for each host-bridge interleave position
> +        port_dev0="$($CXL list -T -d "$decoder" | jq -r ".[] |
> +		.targets | .[] | select(.position == 0) | .target")"
> +        port_dev1="$($CXL list -T -d "$decoder" | jq -r ".[] |
> +		.targets | .[] | select(.position == 1) | .target")"
> +        mem0="$($CXL list -M -p "$port_dev0" | jq -r ".[0].memdev")"
> +        mem1="$($CXL list -M -p "$port_dev1" | jq -r ".[0].memdev")"
> +
> +	region="$($CXL create-region -d "$decoder" -m "$mem0" "$mem1" |
> +		 jq -r ".region")"
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
> index 224adaf41fcc..2706fa5d633c 100644
> --- a/test/meson.build
> +++ b/test/meson.build
> @@ -157,6 +157,7 @@ cxl_create_region = find_program('cxl-create-region.sh')
>  cxl_xor_region = find_program('cxl-xor-region.sh')
>  cxl_update_firmware = find_program('cxl-update-firmware.sh')
>  cxl_events = find_program('cxl-events.sh')
> +cxl_poison = find_program('cxl-poison.sh')
>  
>  tests = [
>    [ 'libndctl',               libndctl,		  'ndctl' ],
> @@ -186,6 +187,7 @@ tests = [
>    [ 'cxl-create-region.sh',   cxl_create_region,  'cxl'   ],
>    [ 'cxl-xor-region.sh',      cxl_xor_region,     'cxl'   ],
>    [ 'cxl-events.sh',          cxl_events,         'cxl'   ],
> +  [ 'cxl-poison.sh',          cxl_poison,         'cxl'   ],
>  ]
>  
>  if get_option('destructive').enabled()
