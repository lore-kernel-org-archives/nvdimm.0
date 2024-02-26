Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC96B1350CF
	for <nvdimm@lists.linux.dev>; Mon, 26 Feb 2024 23:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708988973; cv=none; b=R+6uP5rlz6fEtz10XgCcfP22oiTSAkGwrGkCaQ37c3GWd4Fom+ST/7B6LfjtNv1NpjCzCVRXwpX37vVtKXi8+bPUKfV2hKMDmt5he2RZcY5RV1gJjXwbHf3hq+oEmne6rtVvdKqnK1Tt6fB5hFyoefqkgZYGkrR7wgp/VA3CcWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708988973; c=relaxed/simple;
	bh=kSpCpCK55HHFLjMPPvJHK8oKRqg8XtG9/mi1Zez8pD0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=EUwCiea3IigcStT/Th9SoInGEz1bsicXVh5KzksVks4F3/Qm1AHYPlFfbQfA4Px85DCrdXtPACdBeVzcOTO/8LZBCC/u8SicxcsDlNPPInhuvPy4DsbdZxFqBbB0SJBFnZ4vz6QBHldRB6FGu1zUgrRw1IBqSmZYb9m5U4B4mAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X+n0kM6l; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X+n0kM6l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708988972; x=1740524972;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=kSpCpCK55HHFLjMPPvJHK8oKRqg8XtG9/mi1Zez8pD0=;
  b=X+n0kM6lPKWOyt/3pnqIOH4Dtb/YZMAM8GtfWgt/UCZrKYDZBb2lyRj3
   jrVANFZOZhM8x464tXxeND20OCieDYwgvJmgXTdVbO7oQkx82hRKQQDzd
   bPG7zt+svezSHxQGFId8Av67MjIx78AxEmA+41TWoxWTijm9mK17ZljSy
   Liafn/ZSinQYGA7kJyWc9YB31rQF+2eaLS3qMZQsSUy1gRtyFD3UmuqRp
   WtO89EmC4/twtsAr5a9uzFc39KRokEdglCzpaAPN3ChQ77i/irbk8s6CF
   DySVIfPtipHjsAhoAEzN+cWE1exsYEem4cy5h3+1yK3dUDhZF1ICqVYlD
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="3435724"
X-IronPort-AV: E=Sophos;i="6.06,186,1705392000"; 
   d="scan'208";a="3435724"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 15:09:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,186,1705392000"; 
   d="scan'208";a="6710125"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.246.112.4]) ([10.246.112.4])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 15:09:30 -0800
Message-ID: <50b74500-25e8-4c05-847b-598937471ac4@intel.com>
Date: Mon, 26 Feb 2024 16:09:29 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [NDCTL PATCH v7 4/4] ndctl: add test for qos_class in CXL test
 suite
Content-Language: en-US
To: "Verma, Vishal L" <vishal.l.verma@intel.com>,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
References: <20240208201435.2081583-1-dave.jiang@intel.com>
 <20240208201435.2081583-5-dave.jiang@intel.com>
 <fab7eaa31a7211bc62f17afb5aea47c2cc8dfe87.camel@intel.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <fab7eaa31a7211bc62f17afb5aea47c2cc8dfe87.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 2/23/24 3:07 PM, Verma, Vishal L wrote:
> On Thu, 2024-02-08 at 13:11 -0700, Dave Jiang wrote:
>> Add tests in cxl-qos-class.sh to verify qos_class are set with the fake
>> qos_class create by the kernel.  Root decoders should have qos_class
>> attribute set. Memory devices should have ram_qos_class or pmem_qos_class
>> set depending on which partitions are valid.
>>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> ---
>> v7:
>> - Add create_region -Q testing (Vishal)
>> ---
>>  test/common           |   4 ++
>>  test/cxl-qos-class.sh | 102 ++++++++++++++++++++++++++++++++++++++++++
>>  test/meson.build      |   2 +
>>  3 files changed, 108 insertions(+)
>>  create mode 100755 test/cxl-qos-class.sh
>>
>> diff --git a/test/common b/test/common
>> index f1023ef20f7e..5694820c7adc 100644
>> --- a/test/common
>> +++ b/test/common
>> @@ -150,3 +150,7 @@ check_dmesg()
>>  	grep -q "Call Trace" <<< $log && err $1
>>  	true`
>>  }
>> +
>> +
>> +# CXL COMMON
>> +TEST_QOS_CLASS=42
>> diff --git a/test/cxl-qos-class.sh b/test/cxl-qos-class.sh
>> new file mode 100755
>> index 000000000000..145df6134685
>> --- /dev/null
>> +++ b/test/cxl-qos-class.sh
>> @@ -0,0 +1,102 @@
>> +#!/bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (C) 2024 Intel Corporation. All rights reserved.
>> +
>> +. $(dirname $0)/common
>> +
>> +rc=77
>> +
>> +set -ex
>> +
>> +trap 'err $LINENO' ERR
>> +
>> +check_prereq "jq"
>> +
>> +modprobe -r cxl_test
>> +modprobe cxl_test
>> +rc=1
>> +
>> +check_qos_decoders () {
>> +	# check root decoders have expected fake qos_class
>> +	# also make sure the number of root decoders equal to the number
>> +	# with qos_class found
>> +	json=$($CXL list -b cxl_test -D -d root)
>> +	decoders=$(echo "$json" | jq length)
>> +	count=0
>> +	while read -r qos_class
>> +	do
> 
> For consistency, the script based tests all have the while..do,
> for..do, if..then bits on the same line. Would be nice not to break
> that precedent.

Will fix. BTW, cxl-topology.sh also deviates.

> 
>> +		((qos_class == TEST_QOS_CLASS)) || err "$LINENO"
>> +		count=$((count+1))
>> +	done <<< "$(echo "$json" | jq -r '.[] | .qos_class')"
>> +
>> +	((count == decoders)) || err "$LINENO";
>> +}
>> +
>> +check_qos_memdevs () {
>> +	# Check that memdevs that expose ram_qos_class or pmem_qos_class have
>> +	# expected fake value programmed.
>> +	json=$(cxl list -b cxl_test -M)
>> +	readarray -t lines < <(jq ".[] | .ram_size, .pmem_size, .ram_qos_class, .pmem_qos_class" <<<"$json")
>> +	for (( i = 0; i < ${#lines[@]}; i += 4 ))
>> +	do
>> +		ram_size=${lines[i]}
>> +		pmem_size=${lines[i+1]}
>> +		ram_qos_class=${lines[i+2]}
>> +		pmem_qos_class=${lines[i+3]}
> 
> Hm instead of splitting into lines, and then looping through them, why
> not just invoke jq for each?
> 
> ram_size=$(jq ".[] | .ram_size" <<< $json)
> pmem_size=$(jq ".[] | .pmem_size" <<< $json)
> ...etc
> 

ok

>> +
>> +		if [[ "$ram_size" != null ]]
>> +		then
>> +			((ram_qos_class == TEST_QOS_CLASS)) || err "$LINENO"
>> +		fi
> 
> This might be a bit more readable as:
> 
> if [[ "$ram_size" != null ]] && ((ram_qos_class != TEST_QOS_CLASS)); then
> 	err "$LINENO"
> fi

ok

DJ

> 
>> +		if [[ "$pmem_size" != null ]]
>> +		then
>> +			((pmem_qos_class == TEST_QOS_CLASS)) || err "$LINENO"
>> +		fi
>> +	done
>> +}
>> +
>> +# Based on cxl-create-region.sh create_single()
>> +destroy_regions()
>> +{
>> +	if [[ "$*" ]]; then
>> +		$CXL destroy-region -f -b cxl_test "$@"
>> +	else
>> +		$CXL destroy-region -f -b cxl_test all
>> +	fi
>> +}
>> +
>> +create_region_check_qos()
>> +{
>> +	# the 5th cxl_test decoder is expected to target a single-port
>> +	# host-bridge. Older cxl_test implementations may not define it,
>> +	# so skip the test in that case.
>> +	decoder=$($CXL list -b cxl_test -D -d root |
>> +		  jq -r ".[4] |
>> +		  select(.pmem_capable == true) |
>> +		  select(.nr_targets == 1) |
>> +		  .decoder")
>> +
>> +        if [[ ! $decoder ]]; then
>> +                echo "no single-port host-bridge decoder found, skipping"
>> +                return
>> +        fi
>> +
>> +	# Send create-region with -Q to enforce qos_class matching
>> +	region=$($CXL create-region -Q -d "$decoder" | jq -r ".region")
>> +	if [[ ! $region ]]; then
>> +		echo "failed to create single-port host-bridge region"
>> +		err "$LINENO"
>> +	fi
>> +
>> +	destroy_regions "$region"
>> +}
>> +
>> +check_qos_decoders
>> +
>> +check_qos_memdevs
>> +
>> +create_region_check_qos
>> +
>> +check_dmesg "$LINEO"
>> +
>> +modprobe -r cxl_test
>> diff --git a/test/meson.build b/test/meson.build
>> index 5eb35749a95b..4892df11119f 100644
>> --- a/test/meson.build
>> +++ b/test/meson.build
>> @@ -160,6 +160,7 @@ cxl_events = find_program('cxl-events.sh')
>>  cxl_poison = find_program('cxl-poison.sh')
>>  cxl_sanitize = find_program('cxl-sanitize.sh')
>>  cxl_destroy_region = find_program('cxl-destroy-region.sh')
>> +cxl_qos_class = find_program('cxl-qos-class.sh')
>>  
>>  tests = [
>>    [ 'libndctl',               libndctl,		  'ndctl' ],
>> @@ -192,6 +193,7 @@ tests = [
>>    [ 'cxl-poison.sh',          cxl_poison,         'cxl'   ],
>>    [ 'cxl-sanitize.sh',        cxl_sanitize,       'cxl'   ],
>>    [ 'cxl-destroy-region.sh',  cxl_destroy_region, 'cxl'   ],
>> +  [ 'cxl-qos-class.sh',       cxl_qos_class,      'cxl'   ],
>>  ]
>>  
>>  if get_option('destructive').enabled()
> 
