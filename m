Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C3D3603DB
	for <nvdimm@lists.linux.dev>; Thu, 16 Apr 2026 21:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776373794; cv=none; b=K3N8pPuU8Y6p3RibvarbUSoG3CezMwx5kkUGA4o2WrP7lLUIWyI3I1zG1PqBN6pCUJnvM1eR7HX3YiIzTn4PDbcqwjUMTwEFrazPvitpPz5sCCvsOJUqJvmaqgkYZ2SaJZmuxT5x/veRawdmj2X6R+ydO8GBCPzrfIvPqkd040U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776373794; c=relaxed/simple;
	bh=kiyo0wxlK1eiAFp3EhfW3ekHHbsWxI7KUAJVOuYoe34=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Suai6AXEzkOg+mxmtJCy40pPbTZWtu5GWcJ78PPPegnDCVqA42UfDgvNbePU70+Lps7sdNTBZ2sojnLIRExXs+KY+BVwitvpmGgT3O6wO4rhhZoHHoI5MUoGLTMpLgtbtMU3OZiG7xZbtT1hKl3hHwrSZWW1MNlscMq0lU3L9P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=doGp7dpH; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="doGp7dpH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776373792; x=1807909792;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=kiyo0wxlK1eiAFp3EhfW3ekHHbsWxI7KUAJVOuYoe34=;
  b=doGp7dpH1CldM0gmSBhp9Ky19xlPmIdDljkUKuiHuziaGPF60GHAzX3q
   KWr0meVoc3Cyax3EFgyIwmHvtYZJ1Vr/j7JxtplGc5/lrGvzjNbkbQY6z
   N4acPuQpIlKsmRB+r+910iGF7I2yRGdPik/RLkOwRFGIHdqb3Vo/f8LXD
   CdCm3JXSm+ENUXOiUAMXxEH554Ir1gWIESjQSmUzk/RLrjkZwaFSGsmt3
   DVrdFpnsBKu0OvSttKDEOP+XR+dACwyYOl8orhLxuE6+92nZdgIwndWK7
   r5w1DH45E1PUfVqyLTT3AXo3uC417N88qCUuMk5tuiMczYj2W4/2mGDPc
   g==;
X-CSE-ConnectionGUID: KrLZDW1jShSprQY5B7sPVQ==
X-CSE-MsgGUID: cOAuAPhURGqOTAtdz+cUUg==
X-IronPort-AV: E=McAfee;i="6800,10657,11761"; a="77505370"
X-IronPort-AV: E=Sophos;i="6.23,181,1770624000"; 
   d="scan'208";a="77505370"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2026 14:09:52 -0700
X-CSE-ConnectionGUID: rcWBVMrET+KTXK6pyqv6cQ==
X-CSE-MsgGUID: a5GheA/KQpuYHdzFUjRXOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,181,1770624000"; 
   d="scan'208";a="230724181"
Received: from gabaabhi-mobl2.amr.corp.intel.com (HELO [10.125.110.139]) ([10.125.110.139])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2026 14:09:52 -0700
Message-ID: <7da11db2-94aa-4b21-847e-5a9684ae9b06@intel.com>
Date: Thu, 16 Apr 2026 14:09:51 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH 2/2] test/cxl-region-replay.sh: add test of region
 replay workflow
To: Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org
References: <8646e0b11697e3adb4fc9a83fa486e68a4b9b5c5.1773466514.git.alison.schofield@intel.com>
 <7ec630ea29675b57c052e9606b1d33177e989a2a.1773466514.git.alison.schofield@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <7ec630ea29675b57c052e9606b1d33177e989a2a.1773466514.git.alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/13/26 11:21 PM, Alison Schofield wrote:
> Add a CXL unit test that exercises the replay_regions() helpers
> introduced in test/common.
> 
> The test creates regions through the user interface, captures the
> resulting region configuration, performs a cxl_acpi driver unbind/bind
> cycle, and verifies that the regions reconstructed during enumeration
> match the original configuration.
> 
> This validates the decoder replay mechanism implemented in the kernel
> cxl_test module by replaying user-created regions as auto-discovered
> regions during driver initialization.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  test/cxl-region-replay.sh | 148 ++++++++++++++++++++++++++++++++++++++
>  test/meson.build          |   2 +
>  2 files changed, 150 insertions(+)
>  create mode 100644 test/cxl-region-replay.sh
> 
> diff --git a/test/cxl-region-replay.sh b/test/cxl-region-replay.sh
> new file mode 100644
> index 000000000000..3049ca9f34b5
> --- /dev/null
> +++ b/test/cxl-region-replay.sh
> @@ -0,0 +1,148 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2022 Intel Corporation. All rights reserved.
> +
> +. $(dirname $0)/common
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
> +# Replay support is exposed by cxl_acpi after cxl_test loads
> +if [ ! -e /sys/bus/platform/devices/cxl_acpi.0/decoder_reset_preserve_registry ]; then
> +	do_skip "test requires decoder registry replay support"
> +fi
> +
> +rc=1
> +
> +# Demonstrate and validate CXL region replay support in cxl_test.
> +#
> +# Replay helpers in test/common snapshot the current region topology,
> +# replay the configuration, and verify that the reconstructed regions
> +# match the original configuration.
> +#
> +# Tests should use the common helper:
> +#   replay_regions
> +#
> +# This test serves as both a sanity check for replay support and an
> +# example of how other cxl_test unit tests can use replay_regions().
> +
> +destroy_regions() {
> +	$CXL destroy-region -f -b cxl_test all
> +}
> +
> +create_region() {
> +	region=$($CXL create-region -d "$decoder" -m "$memdevs" |
> +		jq -r ".region")
> +
> +	if [[ ! $region ]]; then
> +		echo "create-region failed for $decoder"
> +		err "$LINENO"
> +	fi
> +}
> +
> +create_x2_pmem_region() {
> +	# Find a pmem-capable x2 decoder
> +	decoder=$($CXL list -b cxl_test -D -d root | jq -r ".[] |
> +		select(.pmem_capable == true) |
> +		select(.nr_targets == 2) |
> +		.decoder")
> +
> +	# Select one memdev for each host-bridge interleave position
> +	port_dev0=$($CXL list -T -d "$decoder" | jq -r ".[] |
> +		.targets | .[] | select(.position == 0) | .target")
> +	port_dev1=$($CXL list -T -d "$decoder" | jq -r ".[] |
> +		.targets | .[] | select(.position == 1) | .target")
> +	mem0=$($CXL list -M -p "$port_dev0" | jq -r ".[0].memdev")
> +	mem1=$($CXL list -M -p "$port_dev1" | jq -r ".[0].memdev")
> +	memdevs="$mem0 $mem1"
> +	create_region
> +}
> +
> +create_x4_ram_region() {
> +	# Find a volatile-capable x2 decoder
> +	decoder=$($CXL list -b cxl_test -D -d root | jq -r ".[] |
> +		select(.volatile_capable == true) |
> +		select(.nr_targets == 2) |
> +		.decoder")
> +
> +	# Select two memdevs for each host-bridge interleave position
> +	port_dev0=$($CXL list -T -d "$decoder" | jq -r ".[] |
> +		.targets | .[] | select(.position == 0) | .target")
> +	port_dev1=$($CXL list -T -d "$decoder" | jq -r ".[] |
> +		.targets | .[] | select(.position == 1) | .target")
> +	mem0=$($CXL list -M -p "$port_dev0" | jq -r ".[0].memdev")
> +	mem1=$($CXL list -M -p "$port_dev1" | jq -r ".[0].memdev")
> +	mem2=$($CXL list -M -p "$port_dev0" | jq -r ".[1].memdev")
> +	mem3=$($CXL list -M -p "$port_dev1" | jq -r ".[1].memdev")
> +	memdevs="$mem0 $mem1 $mem2 $mem3"
> +	create_region
> +}
> +
> +AUTO_MEMDEVS=""
> +AUTO_ROOT_DECODER=""
> +
> +capture_auto_region() {
> +	local region_json dec_json
> +
> +	region_json=$($CXL list -R --targets)
> +
> +	# Expect exactly one auto region
> +	[ "$(jq 'length' <<<"$region_json")" -eq 1 ] || err "$LINENO"
> +
> +	AUTO_MEMDEVS=$(jq -r '.[0].mappings | sort_by(.position) | .[].memdev' \
> +		<<<"$region_json" | xargs)
> +	[[ $AUTO_MEMDEVS ]] || err "$LINENO"
> +
> +	dec_json=$($CXL list -R --decoders)
> +	AUTO_ROOT_DECODER=$(jq -r '.[0]["root decoders"][0].decoder' <<<"$dec_json")
> +	[[ $AUTO_ROOT_DECODER ]] || err "$LINENO"
> +}
> +
> +create_user_region_in_auto_region_space() {
> +	decoder="$AUTO_ROOT_DECODER"
> +	memdevs="$AUTO_MEMDEVS"
> +	create_region
> +}
> +
> +# To remove the auto region, destroy and recreate in user space.
> +# With that action, there will be no 'auto' decoders and it will not be
> +# preserved across acpi rebind.
> +#
> +# This is done here as example if test wants the resources freed
> +remove_auto_region() {
> +	capture_auto_region
> +	destroy_regions
> +	create_user_region_in_auto_region_space
> +	destroy_regions
> +	replay_regions || err "$LINENO"
> +}
> +
> +# Replay the built-in auto region
> +[ "$($CXL list -R | jq 'length')" -ne 0 ] || err "$LINENO"
> +replay_regions || err "$LINENO"
> +
> +# Remove the built-in auto region to free up resources
> +remove_auto_region
> +[ "$($CXL list -R | jq 'length')" -eq 0 ] || err "$LINENO"
> +
> +# Create and replay a volatile region
> +create_x4_ram_region
> +replay_regions || err "$LINENO"
> +
> +# Add-on a pmem region
> +create_x2_pmem_region
> +
> +# Replay both the x4_ram and x2_pmem
> +replay_regions || err "$LINENO"
> +
> +check_dmesg "$LINENO"
> +
> +modprobe -r cxl_test
> diff --git a/test/meson.build b/test/meson.build
> index 8a3718d2b558..fb195e07d0ba 100644
> --- a/test/meson.build
> +++ b/test/meson.build
> @@ -169,6 +169,7 @@ cxl_destroy_region = find_program('cxl-destroy-region.sh')
>  cxl_qos_class = find_program('cxl-qos-class.sh')
>  cxl_translate = find_program('cxl-translate.sh')
>  cxl_elc = find_program('cxl-elc.sh')
> +cxl_region_replay = find_program('cxl-region-replay.sh')
>  
>  tests = [
>    [ 'libndctl',               libndctl,		  'ndctl' ],
> @@ -203,6 +204,7 @@ tests = [
>    [ 'cxl-qos-class.sh',       cxl_qos_class,      'cxl'   ],
>    [ 'cxl-translate.sh',       cxl_translate,      'cxl'   ],
>    [ 'cxl-elc.sh',             cxl_elc,            'cxl'   ],
> +  [ 'cxl-region-replay.sh',   cxl_region_replay,  'cxl'   ],
>  ]
>  
>  if get_option('destructive').enabled()

