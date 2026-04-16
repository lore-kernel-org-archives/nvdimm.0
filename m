Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF222DECCB
	for <nvdimm@lists.linux.dev>; Thu, 16 Apr 2026 21:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776373707; cv=none; b=i1+iSQsQrLT/ZzZHIFr4Arng7zc/cYKUTNk9zpDrISp/gvjYXk17vH365mgTtS4z/+Ok8Eu2bToj90V51ChtEZJ7cSqy+KEX+8xY8Gz3RVoqTBmD6JvzMfojrGtV4Y/akdZs97JPIynA2gjdFKLy60u19ZgzO6+PS5yqLAu0mEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776373707; c=relaxed/simple;
	bh=W3p2UhPa+WCf8euWWtADln3YFtCQ4Q18xjJ0cW1mSZ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=iybbRVzsjdcqO67S5pDC6TvfHikfSMK6R4bmZ/Ez0iAalkXgXt2ToIrmtQdX29ZxJSVWJ/qDxAJR9H+/V53OhuCLaOb9Fl6EkxRhmTMcni8Frh83PyNYteT3TdgQnoKMomjXIAkqykVQxrRGQOhzb8faJfAK/q7dTzcP7ltc1XE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Xjee3u6L; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Xjee3u6L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776373705; x=1807909705;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=W3p2UhPa+WCf8euWWtADln3YFtCQ4Q18xjJ0cW1mSZ0=;
  b=Xjee3u6Loz7gbvXEXxDE5jYTU0ZvZ78jZUe5D7d/H4LPfUWLswCYaArw
   QEpCaFpifjYVxJ1BkNN29rBbMadMLwvkQTuf1ZzbL7Qhw6PycsDHOTS56
   GjU8huPz7cAyF2zUnZ+KJzcEy/U5wTsQ6Fy8APpCJpMWw1RcPmFR8dIaC
   RrkYBVw9OILHCh6Ulyfv+cZsKeEkY3ZnRwBlyHTSDDmY33QxB6rhoHuii
   zGzXjBJHH3GFSQFaMankgehqwUzRyCnPgpRDrU3xMh6pBEX2C7UzcJWuK
   zlp7dTStZ3plM2soP2/sgTzVfgwjPrbyagLjiQWBsZaxGHV3CrCktmQHg
   g==;
X-CSE-ConnectionGUID: upCPChKHS5iSwGRCJBvyXg==
X-CSE-MsgGUID: LwH/GJ/gT5mrKt20DiQPbg==
X-IronPort-AV: E=McAfee;i="6800,10657,11761"; a="77505127"
X-IronPort-AV: E=Sophos;i="6.23,181,1770624000"; 
   d="scan'208";a="77505127"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2026 14:08:24 -0700
X-CSE-ConnectionGUID: 88AGrHILSRSvFdkR4YRSYQ==
X-CSE-MsgGUID: JRUjHPcZSs+KuoUUaeIhEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,181,1770624000"; 
   d="scan'208";a="230723927"
Received: from gabaabhi-mobl2.amr.corp.intel.com (HELO [10.125.110.139]) ([10.125.110.139])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2026 14:08:24 -0700
Message-ID: <97a4d9ff-dda7-41e2-81f3-3cf94243e3aa@intel.com>
Date: Thu, 16 Apr 2026 14:08:23 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH 1/2] test/common: add helpers for CXL region replay
 testing
To: Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org
References: <8646e0b11697e3adb4fc9a83fa486e68a4b9b5c5.1773466514.git.alison.schofield@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <8646e0b11697e3adb4fc9a83fa486e68a4b9b5c5.1773466514.git.alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/13/26 11:21 PM, Alison Schofield wrote:
> Add replay_regions() and supporting helpers to the CXL test common
> library. The helpers capture the current region configuration, trigger
> a region replay by unbinding and rebinding the cxl_acpi driver, and
> verify that the regions reconstructed during enumeration match the
> original configuration.
> 
> Replay is enabled by instructing the cxl_test module to preserve its
> decoder registry across the driver unbind/bind cycle. This allows the
> decoder programming associated with user-created regions to survive
> topology teardown so that the regions are reconstructed during driver
> initialization as auto-discovered regions.
> 
> Region signatures are derived from region attributes and memdev serial
> numbers so that the replayed configuration can be compared independent
> of topology enumeration order and device numbering.
> 
> These helpers provide a reusable mechanism for CXL tests that need to
> exercise region replay behavior. A unit test, cxl-region-replay.sh, is
> posted in a follow-on patch and demonstrates the workflow.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Not that I'm great at bash and jq but it looks ok to me. 

Reviewed-by: Dave Jiang <dave.jiang@intel.com>


> ---
>  test/common | 109 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 109 insertions(+)
> 
> diff --git a/test/common b/test/common
> index 2eb11b7396d0..048f9680f277 100644
> --- a/test/common
> +++ b/test/common
> @@ -168,3 +168,112 @@ check_dmesg()
>  
>  # CXL COMMON
>  CXL_TEST_QOS_CLASS=42
> +
> +# CXL region replay helpers
> +#
> +# replay_regions() snapshots the current region configuration, performs
> +# a cxl_acpi driver unbind/bind cycle to trigger region replay, and
> +# verifies that the regions reconstructed during enumeration match the
> +# original configuration.
> +#
> +# This allows tests to create regions through the user interface and
> +# then replay them as auto-discovered regions during driver
> +# initialization.
> +#
> +# See example usage in test/cxl-region-replay.sh.
> +
> +CXL_EXPECTED_REGION_SIGS=""
> +
> +cxl_get_memdev_serial()
> +{
> +	local memdev="$1"
> +
> +	"$CXL" list -m "$memdev" | jq -r '.[0].serial'
> +}
> +
> +cxl_emit_region_signature()
> +{
> +	local region="$1"
> +	local region_json size type ways gran state
> +	local entry pos memdev serial sig
> +
> +	region_json=$("$CXL" list -R --targets -r "$region")
> +	[[ -n "$region_json" && "$region_json" != "[]" ]] || return 1
> +
> +	size=$(jq -r '.[0].size' <<<"$region_json")
> +	type=$(jq -r '.[0].type' <<<"$region_json")
> +	ways=$(jq -r '.[0].interleave_ways' <<<"$region_json")
> +	gran=$(jq -r '.[0].interleave_granularity' <<<"$region_json")
> +	state=$(jq -r '.[0].decode_state' <<<"$region_json")
> +
> +	sig="size=$size type=$type ways=$ways gran=$gran"
> +
> +	while IFS= read -r entry; do
> +		pos=$(jq -r '.position' <<<"$entry")
> +		memdev=$(jq -r '.memdev' <<<"$entry")
> +		serial=$(cxl_get_memdev_serial "$memdev") || return 1
> +		[[ -n "$serial" && "$serial" != "null" ]] || return 1
> +		sig="$sig pos=$pos serial=$serial"
> +	done < <(jq -c '.[0].mappings | sort_by(.position)[]' <<<"$region_json")
> +
> +	echo "$sig state=$state"
> +}
> +
> +cxl_collect_region_signatures()
> +{
> +	local region
> +	local -a regions=()
> +
> +	mapfile -t regions < <("$CXL" list -Ri | jq -r '.[].region' | sort) || return 1
> +
> +	for region in "${regions[@]}"; do
> +		cxl_emit_region_signature "$region" || return 1
> +	done | sort
> +}
> +
> +cxl_capture_expected_region_signatures()
> +{
> +	CXL_EXPECTED_REGION_SIGS=$(cxl_collect_region_signatures) || return 1
> +}
> +
> +cxl_verify_replayed_regions()
> +{
> +	local actual_region_sigs
> +	local -a expected_lines=()
> +	local -a actual_lines=()
> +	local i
> +	local expected_line actual_line
> +	local expected_struct actual_struct
> +	local expected_state actual_state
> +
> +	actual_region_sigs=$(cxl_collect_region_signatures) || return 1
> +
> +	mapfile -t expected_lines < <(printf '%s\n' "$CXL_EXPECTED_REGION_SIGS" | sed '/^$/d')
> +	mapfile -t actual_lines < <(printf '%s\n' "$actual_region_sigs" | sed '/^$/d')
> +
> +	[ "${#expected_lines[@]}" -eq "${#actual_lines[@]}" ] || return 1
> +
> +	for ((i = 0; i < ${#expected_lines[@]}; i++)); do
> +		expected_line=${expected_lines[i]}
> +		actual_line=${actual_lines[i]}
> +
> +		expected_struct=${expected_line% state=*}
> +		expected_state=${expected_line##* state=}
> +		actual_struct=${actual_line% state=*}
> +		actual_state=${actual_line##* state=}
> +
> +		[ "$expected_struct" = "$actual_struct" ] || return 1
> +		[ "$expected_state" != "commit" ] || [ "$actual_state" = "commit" ] || return 1
> +	done
> +}
> +
> +replay_regions()
> +{
> +	echo "replaying existing regions"
> +	cxl_capture_expected_region_signatures || return 1
> +	echo 1 > /sys/bus/platform/devices/cxl_acpi.0/decoder_reset_preserve_registry
> +	echo cxl_acpi.0 > /sys/bus/platform/drivers/cxl_acpi/unbind
> +	echo cxl_acpi.0 > /sys/bus/platform/drivers/cxl_acpi/bind
> +	echo 0 > /sys/bus/platform/devices/cxl_acpi.0/decoder_reset_preserve_registry
> +	cxl_verify_replayed_regions || return 1
> +}
> 
> base-commit: d6f32b0afba6c36fbde2aae67230b71f9e70cb07

