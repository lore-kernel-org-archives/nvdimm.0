Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482E512B95
	for <nvdimm@lists.linux.dev>; Fri, 19 May 2023 19:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684522836; x=1716058836;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2Xsny+yeaJKO/g3Hq8eHmUHCeHnXhfSRVCKd42VFsW8=;
  b=QvNRJkLUBlcUrQayyTp5MVmPenlN6qCq1tMWon0jjORWF+T1Elcxgwsl
   EAenXKTBP36WqgN/eTgK3lZGnSC7PrVq4G//Clo4ZXcETHOWdQlbvBFC4
   E2dCd2o++mkaY9fyoN+dmt7csqUwJpEAqYh2ZqOgT4NqhdFwabbceqnMn
   0WOGWEnIzpQK3/TZCGGv18tc3Wn/DGZA6phXU8RwXOP1Is6N9q4BEiPpF
   +/fpLwqPzsU0+cYoQl0NFYJaV3OlvV+ATADU1XZVhSzy5sYm8gs24PYIQ
   2ILBIdNkzpqIqJpooN3xzIlDAxWF2Dfbro8TysSFDNYzxlxAZLRkcwQnC
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10715"; a="418156126"
X-IronPort-AV: E=Sophos;i="6.00,177,1681196400"; 
   d="scan'208";a="418156126"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2023 12:00:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10715"; a="767712216"
X-IronPort-AV: E=Sophos;i="6.00,177,1681196400"; 
   d="scan'208";a="767712216"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.212.29.189]) ([10.212.29.189])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2023 12:00:35 -0700
Message-ID: <5babfc8a-71da-0f04-939e-3e40edfd3efc@intel.com>
Date: Fri, 19 May 2023 12:00:34 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [PATCH ndctl 5/5] test/cxl-update-firmware: add a unit test for
 firmware update
Content-Language: en-US
To: Vishal Verma <vishal.l.verma@intel.com>, linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Alison Schofield <alison.schofield@intel.com>,
 Ira Weiny <ira.weiny@intel.com>, Dan Williams <dan.j.williams@intel.com>
References: <20230405-vv-fw_update-v1-0-722a7a5baea3@intel.com>
 <20230405-vv-fw_update-v1-5-722a7a5baea3@intel.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20230405-vv-fw_update-v1-5-722a7a5baea3@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/21/23 8:10 PM, Vishal Verma wrote:
> Add a unit test to exercise the different operating modes of the
> cxl-update-firmware command. Perform an update synchronously,
> asynchronously, on multiple devices, and attempt cancellation of an
> in-progress update.
> 
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>   test/cxl-update-firmware.sh | 195 ++++++++++++++++++++++++++++++++++++++++++++
>   test/meson.build            |   2 +
>   2 files changed, 197 insertions(+)
> 
> diff --git a/test/cxl-update-firmware.sh b/test/cxl-update-firmware.sh
> new file mode 100755
> index 0000000..c6cd742
> --- /dev/null
> +++ b/test/cxl-update-firmware.sh
> @@ -0,0 +1,195 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2023 Intel Corporation. All rights reserved.
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
> +check_prereq "dd"
> +check_prereq "sha256sum"
> +
> +modprobe -r cxl_test
> +modprobe cxl_test
> +rc=1
> +
> +mk_fw_file()
> +{
> +	size="$1"
> +
> +	if [[ ! $size ]]; then
> +		err "$LINENO"
> +	fi
> +	if (( size > 64 )); then
> +		err "$LINENO"
> +	fi
> +
> +	fw_file="$(mktemp -p /tmp fw_file_XXXX)"
> +	dd if=/dev/urandom of="$fw_file" bs=1M count="$size"
> +	echo "$fw_file"
> +}
> +
> +find_memdevs()
> +{
> +	count="$1"
> +
> +	if [[ ! $count ]]; then
> +		count=1
> +	fi
> +
> +	"$CXL" list -M -b "$CXL_TEST_BUS" \
> +		| jq -r '.[] | select(.host | startswith("cxl_mem.")) | .memdev' \
> +		| head -"$count"
> +}
> +
> +do_update_fw()
> +{
> +	"$CXL" update-firmware -b "$CXL_TEST_BUS" "$@"
> +}
> +
> +wait_complete()
> +{
> +	mem="$1"  # single memdev, not a list
> +	max_wait="$2"  # in seconds
> +	waited=0
> +
> +	while true; do
> +		json="$("$CXL" list -m "$mem" -F)"
> +		in_prog="$(jq -r '.[].firmware.fw_update_in_progress' <<< "$json")"
> +		if [[ $in_prog == "true" ]]; then
> +			sleep 1
> +			waited="$((waited + 1))"
> +			continue
> +		else
> +			break
> +		fi
> +		if (( waited == max_wait )); then
> +			echo "completion timeout for $mem"
> +			err "$LINENO"
> +		fi
> +	done
> +}
> +
> +validate_json_state()
> +{
> +	json="$1"
> +	state="$2"
> +
> +	while read -r in_prog_state; do
> +		if [[ $in_prog_state == $state ]]; then
> +			continue
> +		else
> +			echo "expected fw_update_in_progress:$state"
> +			err "$LINENO"
> +		fi
> +	done < <(jq -r '.[].firmware.fw_update_in_progress' <<< "$json")
> +}
> +
> +validate_fw_update_in_progress()
> +{
> +	validate_json_state "$1" "true"
> +}
> +
> +validate_fw_update_idle()
> +{
> +	validate_json_state "$1" "false"
> +}
> +
> +validate_staged_slot()
> +{
> +	json="$1"
> +	slot="$2"
> +
> +	while read -r staged_slot; do
> +		if [[ $staged_slot == $slot ]]; then
> +			continue
> +		else
> +			echo "expected staged_slot:$slot"
> +			err "$LINENO"
> +		fi
> +	done < <(jq -r '.[].firmware.staged_slot' <<< "$json")
> +}
> +
> +check_sha()
> +{
> +	mem="$1"
> +	file="$2"
> +	csum_path="/sys/bus/platform/devices/cxl_mem.${mem#mem}/fw_buf_checksum"
> +
> +	mem_csum="$(cat "$csum_path")"
> +	file_csum="$(sha256sum "$file" | awk '{print $1}')"
> +
> +	if [[ $mem_csum != $file_csum ]]; then
> +		echo "checksum failure for mem$mem"
> +		err "$LINENO"
> +	fi
> +}
> +
> +test_blocking_update()
> +{
> +	file="$(mk_fw_file 8)"
> +	mem="$(find_memdevs 1)"
> +	json=$(do_update_fw -F "$file" --wait "$mem")
> +	validate_fw_update_idle "$json"
> +	# cxl_test's starting slot is '2', so staged should be 3
> +	validate_staged_slot "$json" 3
> +	check_sha "$mem" "$file"
> +	rm "$file"
> +}
> +
> +test_nonblocking_update()
> +{
> +	file="$(mk_fw_file 16)"
> +	mem="$(find_memdevs 1)"
> +	json=$(do_update_fw -F "$file" "$mem")
> +	validate_fw_update_in_progress "$json"
> +	wait_complete "$mem" 15
> +	validate_fw_update_idle "$("$CXL" list -m "$mem" -F)"
> +	check_sha "$mem" "$file"
> +	rm "$file"
> +}
> +
> +test_multiple_memdev()
> +{
> +	num_mems=2
> +
> +	file="$(mk_fw_file 16)"
> +	declare -a mems
> +	mems=( $(find_memdevs "$num_mems") )
> +	json="$(do_update_fw -F "$file" "${mems[@]}")"
> +	validate_fw_update_in_progress "$json"
> +	# use the in-band wait this time
> +	json="$(do_update_fw --wait "${mems[@]}")"
> +	validate_fw_update_idle "$json"
> +	for mem in ${mems[@]}; do
> +		check_sha "$mem" "$file"
> +	done
> +	rm "$file"
> +}
> +
> +test_cancel()
> +{
> +	file="$(mk_fw_file 16)"
> +	mem="$(find_memdevs 1)"
> +	json=$(do_update_fw -F "$file" "$mem")
> +	validate_fw_update_in_progress "$json"
> +	do_update_fw --cancel "$mem"
> +	# cancellation is asynchronous, and the result looks the same as idle
> +	wait_complete "$mem" 15
> +	validate_fw_update_idle "$("$CXL" list -m "$mem" -F)"
> +	# no need to check_sha
> +	rm "$file"
> +}
> +
> +test_blocking_update
> +test_nonblocking_update
> +test_multiple_memdev
> +test_cancel
> +
> +check_dmesg "$LINENO"
> +modprobe -r cxl_test
> diff --git a/test/meson.build b/test/meson.build
> index a956885..0f4d3c4 100644
> --- a/test/meson.build
> +++ b/test/meson.build
> @@ -155,6 +155,7 @@ cxl_sysfs = find_program('cxl-region-sysfs.sh')
>   cxl_labels = find_program('cxl-labels.sh')
>   cxl_create_region = find_program('cxl-create-region.sh')
>   cxl_xor_region = find_program('cxl-xor-region.sh')
> +cxl_update_firmware = find_program('cxl-update-firmware.sh')
>   
>   tests = [
>     [ 'libndctl',               libndctl,		  'ndctl' ],
> @@ -198,6 +199,7 @@ if get_option('destructive').enabled()
>   
>     tests += [
>       [ 'firmware-update.sh',     firmware_update,	  'ndctl' ],
> +    [ 'cxl-update-firmware.sh', cxl_update_firmware,      'cxl'   ],
>       [ 'pmem-ns',           pmem_ns,	   'ndctl' ],
>       [ 'sub-section.sh',    sub_section,	   'dax'   ],
>       [ 'dax-dev',           dax_dev,	   'dax'   ],
> 
