Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A54940FDAA
	for <nvdimm@lists.linux.dev>; Thu, 30 Apr 2026 16:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777566459; cv=none; b=SnOtuFYlSYLGl9l0576gE22wtEXCasRveSsX+tdNPCKRDNN0ASbEIQaGPhkxGI9HU1HX+0utec8/PrMrJH+CKCQa3dbFiPGLuGnnM1vBB8Yn5cbJy26hFXSDrvWIxekDLAdRg5hZEcDuF6nafd0aLZeJqBHO8JnBJHhYY8A5rds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777566459; c=relaxed/simple;
	bh=uezNAyhjmVVspEdD8tGsCWa9DKOdDNzui3ju7FSTsVU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DNqeOd16skb+Ml9BR9rX+XNBhfyiFAdotEaClkde+AaVtwpoZ7lG5JJqx7/u+d6toJtMTLBi3A52n06nys7mGVd6ie4e5xxH2e63GOOh3eW0CxZrdshlMgs3jczBkvSs99zC21b1bv61G3VxQDPBblpnniq2QxI7LtFUeIZE48A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Zb6wuH2I; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Zb6wuH2I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777566455; x=1809102455;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=uezNAyhjmVVspEdD8tGsCWa9DKOdDNzui3ju7FSTsVU=;
  b=Zb6wuH2Ij4Bbg2R30ShZ1rV0YBTGNtjj/bDLjDFCQWxwjz7VDh5H+1MQ
   Qh1d2icTKWq9nk6s7fSNjRwlCRod4AtxdZN4nJWXk/ZwalR1ra5Z282Aq
   mLOprxiLqUspByzKAIV3VVLx8jWBy0UU8Y7m+uUgy2w+Yc4dO8pnwWt4Q
   8VciGTj/m6ucWro+ZctZtGFBDXD/sFEKMlCsgG9eWixV/q8e/NJgrkneV
   Pm7J8ZwQfWMZBX6L6ohZU6RPM6hbkl7ZjJ1lay2UaZ6aZTVmIABKZhC8m
   peaTspDiZH7gXMZvvhdp87/FxL+cUptUnFRnvyqX4LYJQd3D8TpOXMddV
   Q==;
X-CSE-ConnectionGUID: t4tGKNHHTruJNGo+fhY3fw==
X-CSE-MsgGUID: RffIQTc+Q5CYyKQ+gEB2lw==
X-IronPort-AV: E=McAfee;i="6800,10657,11772"; a="78420374"
X-IronPort-AV: E=Sophos;i="6.23,208,1770624000"; 
   d="scan'208";a="78420374"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2026 09:27:34 -0700
X-CSE-ConnectionGUID: qOJJWOfJRmufsOUNJlKVIg==
X-CSE-MsgGUID: OKc8Jhl9TSebYGDGMAYElw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,208,1770624000"; 
   d="scan'208";a="272735053"
Received: from aschende-mobl.amr.corp.intel.com (HELO [10.125.109.99]) ([10.125.109.99])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2026 09:27:33 -0700
Message-ID: <1e7e9b08-1985-4917-a2f2-f0ef78d8b591@intel.com>
Date: Thu, 30 Apr 2026 09:27:31 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V5 2/2] Add test/daxctl-famfs.sh to test famfs mode
 transitions:
To: John Groves <john@jagalactic.com>, John Groves <John@Groves.net>,
 John Groves <jgroves@fastmail.com>, Dan Williams <djbw@kernel.org>,
 Alison Schofield <alison.schofield@intel.com>
Cc: John Groves <jgroves@micron.com>, Vishal Verma
 <vishal.l.verma@intel.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>,
 "venkataravis@micron.com" <venkataravis@micron.com>,
 "dev.srinivasulu@gmail.com" <dev.srinivasulu@gmail.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
References: <0100019ddf064477-8322b695-f2d8-481c-9fcd-8b16fc97ad4d-000000@email.amazonses.com>
 <20260430153413.84181-1-john@jagalactic.com>
 <0100019ddf06ce8f-c323d9cd-333b-4076-9717-7c80dbed7620-000000@email.amazonses.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <0100019ddf06ce8f-c323d9cd-333b-4076-9717-7c80dbed7620-000000@email.amazonses.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/30/26 8:34 AM, John Groves wrote:
> From: John Groves <John@Groves.net>
> 
> - devdax <-> famfs mode switches
> - Verify famfs -> system-ram is rejected (must go via devdax)
> - Test JSON output shows correct mode
> - Test error handling for invalid modes
> 
> Signed-off-by: John Groves <john@groves.net>
> ---
>  test/daxctl-famfs.sh | 253 +++++++++++++++++++++++++++++++++++++++++++
>  test/meson.build     |   2 +
>  2 files changed, 255 insertions(+)
>  create mode 100755 test/daxctl-famfs.sh
> 
> diff --git a/test/daxctl-famfs.sh b/test/daxctl-famfs.sh
> new file mode 100755
> index 0000000..12fbfef
> --- /dev/null
> +++ b/test/daxctl-famfs.sh
> @@ -0,0 +1,253 @@
> +#!/bin/bash -Ex
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2025 Micron Technology, Inc. All rights reserved.
> +#
> +# Test daxctl famfs mode transitions and mode detection
> +
> +rc=77
> +. $(dirname $0)/common
> +
> +trap 'cleanup $LINENO' ERR
> +
> +daxdev=""
> +original_mode=""
> +
> +cleanup()
> +{
> +	printf "Error at line %d\n" "$1"
> +	# Try to restore to original mode if we know it
> +	if [[ $daxdev && $original_mode ]]; then
> +		"$DAXCTL" reconfigure-device -f -m "$original_mode" "$daxdev" 2>/dev/null || true
> +	fi
> +	exit $rc
> +}
> +
> +# Check if fsdev_dax module is available
> +check_fsdev_dax()
> +{
> +	if modinfo fsdev_dax &>/dev/null; then
> +		return 0
> +	fi
> +	if grep -qF "fsdev_dax" "/lib/modules/$(uname -r)/modules.builtin" 2>/dev/null; then
> +		return 0
> +	fi
> +	printf "fsdev_dax module not available, skipping\n"
> +	exit 77
> +}
> +
> +# Check if kmem module is available (needed for system-ram mode tests)
> +check_kmem()
> +{
> +	if modinfo kmem &>/dev/null; then
> +		return 0
> +	fi
> +	if grep -qF "kmem" "/lib/modules/$(uname -r)/modules.builtin" 2>/dev/null; then
> +		return 0
> +	fi
> +	printf "kmem module not available, skipping system-ram tests\n"
> +	return 1
> +}
> +
> +# Find an existing dax device to test with
> +find_daxdev()
> +{
> +	# Look for any available dax device
> +	daxdev=$("$DAXCTL" list | jq -er '.[0].chardev // empty' 2>/dev/null) || true
> +
> +	if [[ ! $daxdev ]]; then
> +		printf "No dax device found, skipping\n"
> +		exit 77

Can you use 'do_skip' here?

DJ

> +	fi
> +
> +	# Save the original mode so we can restore it
> +	original_mode=$("$DAXCTL" list -d "$daxdev" | jq -er '.[].mode')
> +
> +	printf "Found dax device: %s (current mode: %s)\n" "$daxdev" "$original_mode"
> +}
> +
> +daxctl_get_mode()
> +{
> +	"$DAXCTL" list -d "$1" | jq -er '.[].mode'
> +}
> +
> +# Ensure device is in devdax mode for testing
> +ensure_devdax_mode()
> +{
> +	local mode
> +	mode=$(daxctl_get_mode "$daxdev")
> +
> +	if [[ "$mode" == "devdax" ]]; then
> +		return 0
> +	fi
> +
> +	if [[ "$mode" == "system-ram" ]]; then
> +		printf "Device is in system-ram mode, attempting to convert to devdax...\n"
> +		"$DAXCTL" reconfigure-device -f -m devdax "$daxdev"
> +	elif [[ "$mode" == "famfs" ]]; then
> +		printf "Device is in famfs mode, converting to devdax...\n"
> +		"$DAXCTL" reconfigure-device -m devdax "$daxdev"
> +	else
> +		printf "Device is in unknown mode: %s\n" "$mode"
> +		return 1
> +	fi
> +
> +	[[ $(daxctl_get_mode "$daxdev") == "devdax" ]]
> +}
> +
> +#
> +# Test basic mode transitions involving famfs
> +#
> +test_famfs_mode_transitions()
> +{
> +	printf "\n=== Testing famfs mode transitions ===\n"
> +
> +	# Ensure starting in devdax mode
> +	ensure_devdax_mode
> +	[[ $(daxctl_get_mode "$daxdev") == "devdax" ]]
> +	printf "Initial mode: devdax - OK\n"
> +
> +	# Test: devdax -> famfs
> +	printf "Testing devdax -> famfs... "
> +	"$DAXCTL" reconfigure-device -m famfs "$daxdev"
> +	[[ $(daxctl_get_mode "$daxdev") == "famfs" ]]
> +	printf "OK\n"
> +
> +	# Test: famfs -> famfs (re-enable in same mode)
> +	printf "Testing famfs -> famfs (re-enable)... "
> +	"$DAXCTL" reconfigure-device -m famfs "$daxdev"
> +	[[ $(daxctl_get_mode "$daxdev") == "famfs" ]]
> +	printf "OK\n"
> +
> +	# Test: famfs -> devdax
> +	printf "Testing famfs -> devdax... "
> +	"$DAXCTL" reconfigure-device -m devdax "$daxdev"
> +	[[ $(daxctl_get_mode "$daxdev") == "devdax" ]]
> +	printf "OK\n"
> +
> +	# Test: devdax -> devdax (re-enable in same mode)
> +	printf "Testing devdax -> devdax (re-enable)... "
> +	"$DAXCTL" reconfigure-device -m devdax "$daxdev"
> +	[[ $(daxctl_get_mode "$daxdev") == "devdax" ]]
> +	printf "OK\n"
> +}
> +
> +#
> +# Test mode transitions with system-ram (requires kmem)
> +#
> +test_system_ram_transitions()
> +{
> +	printf "\n=== Testing system-ram transitions with famfs ===\n"
> +
> +	# Ensure we start in devdax mode
> +	ensure_devdax_mode
> +	[[ $(daxctl_get_mode "$daxdev") == "devdax" ]]
> +
> +	# Test: devdax -> system-ram
> +	printf "Testing devdax -> system-ram... "
> +	"$DAXCTL" reconfigure-device -N -m system-ram "$daxdev"
> +	[[ $(daxctl_get_mode "$daxdev") == "system-ram" ]]
> +	printf "OK\n"
> +
> +	# Test: system-ram -> famfs should fail
> +	printf "Testing system-ram -> famfs (should fail)... "
> +	if "$DAXCTL" reconfigure-device -m famfs "$daxdev" 2>/dev/null; then
> +		printf "FAILED - should have been rejected\n"
> +		return 1
> +	fi
> +	printf "OK (correctly rejected)\n"
> +
> +	# Test: system-ram -> devdax -> famfs (proper path)
> +	printf "Testing system-ram -> devdax -> famfs... "
> +	"$DAXCTL" reconfigure-device -f -m devdax "$daxdev"
> +	[[ $(daxctl_get_mode "$daxdev") == "devdax" ]]
> +	"$DAXCTL" reconfigure-device -m famfs "$daxdev"
> +	[[ $(daxctl_get_mode "$daxdev") == "famfs" ]]
> +	printf "OK\n"
> +
> +	# Restore to devdax for subsequent tests
> +	"$DAXCTL" reconfigure-device -m devdax "$daxdev"
> +}
> +
> +#
> +# Test JSON output shows correct mode
> +#
> +test_json_output()
> +{
> +	printf "\n=== Testing JSON output for mode field ===\n"
> +
> +	# Test devdax mode in JSON
> +	ensure_devdax_mode
> +	printf "Testing JSON output for devdax mode... "
> +	mode=$("$DAXCTL" list -d "$daxdev" | jq -er '.[].mode')
> +	[[ "$mode" == "devdax" ]]
> +	printf "OK\n"
> +
> +	# Test famfs mode in JSON
> +	"$DAXCTL" reconfigure-device -m famfs "$daxdev"
> +	printf "Testing JSON output for famfs mode... "
> +	mode=$("$DAXCTL" list -d "$daxdev" | jq -er '.[].mode')
> +	[[ "$mode" == "famfs" ]]
> +	printf "OK\n"
> +
> +	# Restore to devdax
> +	"$DAXCTL" reconfigure-device -m devdax "$daxdev"
> +}
> +
> +#
> +# Test error messages for invalid transitions
> +#
> +test_error_handling()
> +{
> +	printf "\n=== Testing error handling ===\n"
> +
> +	# Ensure we're in famfs mode
> +	"$DAXCTL" reconfigure-device -m famfs "$daxdev"
> +
> +	# Test that invalid mode is rejected
> +	printf "Testing invalid mode rejection... "
> +	if "$DAXCTL" reconfigure-device -m invalidmode "$daxdev" 2>/dev/null; then
> +		printf "FAILED - invalid mode should be rejected\n"
> +		return 1
> +	fi
> +	printf "OK (correctly rejected)\n"
> +
> +	# Restore to devdax
> +	"$DAXCTL" reconfigure-device -m devdax "$daxdev"
> +}
> +
> +#
> +# Main test sequence
> +#
> +main()
> +{
> +	check_fsdev_dax
> +	find_daxdev
> +
> +	rc=1  # From here on, failures are real failures
> +
> +	test_famfs_mode_transitions
> +	test_json_output
> +	test_error_handling
> +
> +	# System-ram tests require kmem module
> +	if check_kmem; then
> +		# Save and disable online policy for system-ram tests
> +		saved_policy="$(cat /sys/devices/system/memory/auto_online_blocks)"
> +		echo "offline" > /sys/devices/system/memory/auto_online_blocks
> +
> +		test_system_ram_transitions
> +
> +		# Restore online policy
> +		echo "$saved_policy" > /sys/devices/system/memory/auto_online_blocks
> +	fi
> +
> +	# Restore original mode
> +	printf "\nRestoring device to original mode: %s\n" "$original_mode"
> +	"$DAXCTL" reconfigure-device -f -m "$original_mode" "$daxdev"
> +
> +	printf "\n=== All famfs tests passed ===\n"
> +
> +	exit 0
> +}
> +
> +main
> diff --git a/test/meson.build b/test/meson.build
> index 8a3718d..5b75c07 100644
> --- a/test/meson.build
> +++ b/test/meson.build
> @@ -213,6 +213,7 @@ if get_option('destructive').enabled()
>    device_dax_fio = find_program('device-dax-fio.sh')
>    daxctl_devices = find_program('daxctl-devices.sh')
>    daxctl_create = find_program('daxctl-create.sh')
> +  daxctl_famfs = find_program('daxctl-famfs.sh')
>    dm = find_program('dm.sh')
>    mmap_test = find_program('mmap.sh')
>  
> @@ -230,6 +231,7 @@ if get_option('destructive').enabled()
>      [ 'device-dax-fio.sh', device_dax_fio, 'dax'   ],
>      [ 'daxctl-devices.sh', daxctl_devices, 'dax'   ],
>      [ 'daxctl-create.sh',  daxctl_create,  'dax'   ],
> +    [ 'daxctl-famfs.sh',   daxctl_famfs,   'dax'   ],
>      [ 'dm.sh',             dm,		   'dax'   ],
>      [ 'mmap.sh',           mmap_test,	   'dax'   ],
>    ]

