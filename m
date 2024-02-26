Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA6F1353FB
	for <nvdimm@lists.linux.dev>; Mon, 26 Feb 2024 22:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708987155; cv=none; b=ao7OVGVFt3Uqd6fkNcgMgzMTimXofZeNG2Vu3n3Hu+Fi+3zLWhdfoHpIZvJ6JMqFyrCGxVZMMmjD785b94iEuyfg9BE6xtLUIuK/yMHRZ2x6DNBdqCFJk+TeaG6sLDIUrxds25uumMUNCZGDeQIGhKUlBpinVQQ1xoDdrn2/R3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708987155; c=relaxed/simple;
	bh=Qea889SXoKSSrCDwzRaGM8e19r2Hj1qy/kVfUGUiEWs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=qNESQsIe97YSQoTNq0jBj+3fzAp5bWXLB0bAKGHpHvb6VbhCR/ZJCRr2LkJj8gOaer8oH4xaEfHkWtkmuHpGZQ+1e61R438v43O9hZ40MUJ2kV+GnwHpuMR3a7qhvN1u7Do/KpQT7GF3kyba3Xfa2mECmrezfZQkErAtAsSaty0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c7XU4dUc; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c7XU4dUc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708987154; x=1740523154;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=Qea889SXoKSSrCDwzRaGM8e19r2Hj1qy/kVfUGUiEWs=;
  b=c7XU4dUcvly3FRYI49DAbwbotQ9n29HA+RfwJYRKGUQJPPUUHRZ5wfaF
   NO+9/jKgQFacHDMc3qNmRnhCHkIaGp+r1lUn3qO/anxidrngrAUYIwVHo
   EHiQnfeO/R/Y+rHIWvjePk02kopVXa/hJ32gBRq9NibXe6iAxa3Pcujay
   SgHN1D4ri/Y2Mgc9rgkvZUCk2qu/e98/YARscGPvLS274bhGFXjES3OhY
   zFkHOR5647Sy2r7V7jg3licPGCDsChf1ezFpa9eJipamdakH9MYZM0pqD
   d+iX2UHbr6OnqEat5SWEWsyiX707mAJgkYxZQfA0jJf8wC6V0Q2R/MxG0
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="13944541"
X-IronPort-AV: E=Sophos;i="6.06,186,1705392000"; 
   d="scan'208";a="13944541"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 14:39:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,186,1705392000"; 
   d="scan'208";a="7360773"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.246.112.4]) ([10.246.112.4])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 14:39:13 -0800
Message-ID: <199cfa4f-cf9b-45d5-8fb3-bf8e0db2d639@intel.com>
Date: Mon, 26 Feb 2024 15:39:11 -0700
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
 <677035a6578df716ff9df5cb83047498919e90ae.camel@intel.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <677035a6578df716ff9df5cb83047498919e90ae.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 2/22/24 12:59 AM, Verma, Vishal L wrote:
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
>>  	true
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
>> +
>> +		if [[ "$ram_size" != null ]]
>> +		then
>> +			((ram_qos_class == TEST_QOS_CLASS)) || err "$LINENO"
>> +		fi
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
> 
> Instead of assuming the 5th decoder, can we select based on some
> property of the decoder or its parentage? This works, but it's a bit
> sensitive to future cxl_test topology changes that will easily and
> (more importantly) silently break this part of the test (since we skip
> but still pass).

I copied it straight from cxl-topology.sh. It can be any really. All cxl_test setup should have qos_class. I would imagine cxl-topology.sh would also break if there's some future change

> 
>> +
>> +        if [[ ! $decoder ]]; then
>> +                echo "no single-port host-bridge decoder found, skipping"
>> +                return
>> +        fi
> 
> I think there's some space/tab mixing going on here.

I'll fix.

> 
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
