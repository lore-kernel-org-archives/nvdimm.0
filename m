Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE4234A76E
	for <nvdimm@lists.linux.dev>; Wed, 18 Feb 2026 21:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771449303; cv=none; b=nZzNG9W19hY2ziFT9txDTUNlOloRYixls0v+gw0fqUVqr0jPcuPTtIB3DB2I2NcGbVX5EWQ1Ctxh8S/h0aB1J9wMFGlHfC8d3aoJsEzz1B9AIxeQxo5cc8eLSslJoNWSLTHGW6Z8210Lh3LXNWzHG3UO/9/4ALqivoZJZXLtxw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771449303; c=relaxed/simple;
	bh=qsXhhT9BId6yhrWp4Rpzz7my5feP1D5dD5zJOeCYP8g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=saOrrcPdQVyHYShhEpbSb9Cj655r5/Nb57Lih7v0DrGUwlUPka8+YKFPBeOK47zfEcUjc+rprv6k+6nZBcq/7cwHH4SnfE4xEMIXYqvHOU4YKu6qckybAZTspQji0NeGCIgihlfcm/KwDPHBRj0Dt2fA1R+mSagQ/6iCQHsu3ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OESQTwkn; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OESQTwkn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771449302; x=1802985302;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qsXhhT9BId6yhrWp4Rpzz7my5feP1D5dD5zJOeCYP8g=;
  b=OESQTwknW4KC124JSyNSvLkVGzvwcCgHysA8rOmwHGLhtqXq7v4gvMLz
   YFVyzaT9UMSS3jMCMP9OpN/AR/Vk+bY9CZ+42ao8lrOwMPXRRor4kp0QV
   OM4kbH0//Leww75/0UqL7iwmK2wyJefqm7/APU0oauRYwIGEtN6qQ8TDx
   ZnvCccHnm2MmbHc7+nHRrk86WHa4klWb2ULOiBwE3RLOUFnD4VE+sVBdP
   VUJnLt+AjkLNDUT7TTJonLJYIUKMSlJ1gJEvZrKJbVU/nQ+PQjbBWDQeU
   6wDyuFtYKSu9/DA+Z49uHtXZ72Gsr+qwB124jTTYOzEYIbBHzfDztXDWs
   g==;
X-CSE-ConnectionGUID: BPas2kWfQ++gjnVaiRol4w==
X-CSE-MsgGUID: pD9BgpMcStyRJgdJM3kjPg==
X-IronPort-AV: E=McAfee;i="6800,10657,11705"; a="71557491"
X-IronPort-AV: E=Sophos;i="6.21,299,1763452800"; 
   d="scan'208";a="71557491"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2026 13:15:01 -0800
X-CSE-ConnectionGUID: RDfgAn4DSf6gypsJkEZ+jQ==
X-CSE-MsgGUID: MGMguon1QSCGshk4mxFxpA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,299,1763452800"; 
   d="scan'208";a="214424658"
Received: from aduenasd-mobl5.amr.corp.intel.com (HELO [10.125.109.212]) ([10.125.109.212])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2026 13:15:01 -0800
Message-ID: <a54522e6-0351-4aa9-a049-7473b1994544@intel.com>
Date: Wed, 18 Feb 2026 14:15:00 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH v3] test/cxl-poison.sh: replace sysfs usage with
 cxl-cli cmds
To: Alison Schofield <alison.schofield@intel.com>,
 Ben Cheatham <Benjamin.Cheatham@amd.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
References: <20260218191108.1471718-1-alison.schofield@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260218191108.1471718-1-alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2/18/26 12:11 PM, Alison Schofield wrote:
> cxl-cli commands were recently added for poison inject and clear
> operations by memdev. Replace the writes to sysfs with the new
> commands in the cxl-poison unit test.
> 
> All cxl-test memdevs are created as poison_injectable, so just
> confirm that the new poison_injectable field is indeed 'true'.
> 
> Continue to use the sysfs writes for inject and clear poison
> by region offset until that support arrives in cxl-cli.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
> 
> Change in v3:
> Use new field 'poison_injectable' in memdev selection (BenC)
> Update commit log to include poison_injectable check.
> 
> Change in v2:
> Use final format of new cxl-cli cmds:
> 	inject-media-poison and clear-media-poison
> 
> 
>  test/cxl-poison.sh | 82 +++++++++++++++++++++++++---------------------
>  1 file changed, 44 insertions(+), 38 deletions(-)
> 
> diff --git a/test/cxl-poison.sh b/test/cxl-poison.sh
> index 58cf132b613b..bbd147c85a77 100644
> --- a/test/cxl-poison.sh
> +++ b/test/cxl-poison.sh
> @@ -20,7 +20,8 @@ find_memdev()
>  {
>  	readarray -t capable_mems < <("$CXL" list -b "$CXL_TEST_BUS" -M |
>  		jq -r ".[] | select(.pmem_size != null) |
> -		select(.ram_size != null) | .memdev")
> +		select(.ram_size != null) |
> +		select(.poison_injectable == true) | .memdev")
>  
>  	if [ ${#capable_mems[@]} == 0 ]; then
>  		echo "no memdevs found for test"
> @@ -41,32 +42,37 @@ find_auto_region()
>  	echo "$region"
>  }
>  
> -# When cxl-cli support for inject and clear arrives, replace
> -# the writes to /sys/kernel/debug with the new cxl commands.
> -
> -_do_poison_sysfs()
> +_do_poison()
>  {
>  	local action="$1" dev="$2" addr="$3"
>  	local expect_fail=${4:-false}
>  
> -	if "$expect_fail"; then
> -		if echo "$addr" > "/sys/kernel/debug/cxl/$dev/${action}_poison"; then
> -			echo "Expected ${action}_poison to fail for $addr"
> -			err "$LINENO"
> -		fi
> -	else
> -		echo "$addr" > "/sys/kernel/debug/cxl/$dev/${action}_poison"
> +	# Regions use sysfs, memdevs use cxl-cli commands
> +	if [[ "$dev" =~ ^region ]]; then
> +		local sysfs_path="/sys/kernel/debug/cxl/$dev/${action}_poison"
> +		"$expect_fail" && echo "$addr" > "$sysfs_path" && err "$LINENO"
> +		"$expect_fail" || echo "$addr" > "$sysfs_path"
> +		return
>  	fi
> +
> +	case "$action" in
> +	inject) local cmd=("$CXL" inject-media-poison "$dev" -a "$addr") ;;
> +	clear)	local cmd=("$CXL" clear-media-poison "$dev" -a "$addr") ;;
> +	*)	err "$LINENO" ;;
> +	esac
> +
> +	"$expect_fail" && "${cmd[@]}" && err "$LINENO"
> +	"$expect_fail" || "${cmd[@]}"
>  }
>  
> -inject_poison_sysfs()
> +inject_poison()
>  {
> -	_do_poison_sysfs 'inject' "$@"
> +	_do_poison 'inject' "$@"
>  }
>  
> -clear_poison_sysfs()
> +clear_poison()
>  {
> -	_do_poison_sysfs 'clear' "$@"
> +	_do_poison 'clear' "$@"
>  }
>  
>  check_trace_entry()
> @@ -121,27 +127,27 @@ validate_poison_found()
>  test_poison_by_memdev_by_dpa()
>  {
>  	find_memdev
> -	inject_poison_sysfs "$memdev" "0x40000000"
> -	inject_poison_sysfs "$memdev" "0x40001000"
> -	inject_poison_sysfs "$memdev" "0x600"
> -	inject_poison_sysfs "$memdev" "0x0"
> +	inject_poison "$memdev" "0x40000000"
> +	inject_poison "$memdev" "0x40001000"
> +	inject_poison "$memdev" "0x600"
> +	inject_poison "$memdev" "0x0"
>  	validate_poison_found "-m $memdev" 4
>  
> -	clear_poison_sysfs "$memdev" "0x40000000"
> -	clear_poison_sysfs "$memdev" "0x40001000"
> -	clear_poison_sysfs "$memdev" "0x600"
> -	clear_poison_sysfs "$memdev" "0x0"
> +	clear_poison "$memdev" "0x40000000"
> +	clear_poison "$memdev" "0x40001000"
> +	clear_poison "$memdev" "0x600"
> +	clear_poison "$memdev" "0x0"
>  	validate_poison_found "-m $memdev" 0
>  }
>  
>  test_poison_by_region_by_dpa()
>  {
> -	inject_poison_sysfs "$mem0" "0"
> -	inject_poison_sysfs "$mem1" "0"
> +	inject_poison "$mem0" "0"
> +	inject_poison "$mem1" "0"
>  	validate_poison_found "-r $region" 2
>  
> -	clear_poison_sysfs "$mem0" "0"
> -	clear_poison_sysfs "$mem1" "0"
> +	clear_poison "$mem0" "0"
> +	clear_poison "$mem1" "0"
>  	validate_poison_found "-r $region" 0
>  }
>  
> @@ -168,15 +174,15 @@ test_poison_by_region_offset()
>  	# Inject at the offset and check result using the hpa
>  	# ABI takes an offset, but recall the hpa to check trace event
>  
> -	inject_poison_sysfs "$region" "$cache_size"
> +	inject_poison "$region" "$cache_size"
>  	check_trace_entry "$region" "$hpa1"
> -	inject_poison_sysfs "$region" "$((gran + cache_size))"
> +	inject_poison "$region" "$((gran + cache_size))"
>  	check_trace_entry "$region" "$hpa2"
>  	validate_poison_found "-r $region" 2
>  
> -	clear_poison_sysfs "$region" "$cache_size"
> +	clear_poison "$region" "$cache_size"
>  	check_trace_entry "$region" "$hpa1"
> -	clear_poison_sysfs "$region" "$((gran + cache_size))"
> +	clear_poison "$region" "$((gran + cache_size))"
>  	check_trace_entry "$region" "$hpa2"
>  	validate_poison_found "-r $region" 0
>  }
> @@ -196,21 +202,21 @@ test_poison_by_region_offset_negative()
>  	if [[ $cache_size -gt 0 ]]; then
>  		cache_offset=$((cache_size - 1))
>  		echo "Testing offset within cache: $cache_offset (cache_size: $cache_size)"
> -		inject_poison_sysfs "$region" "$cache_offset" true
> -		clear_poison_sysfs "$region" "$cache_offset" true
> +		inject_poison "$region" "$cache_offset" true
> +		clear_poison "$region" "$cache_offset" true
>  	else
>  		echo "Skipping cache test - cache_size is 0"
>  	fi
>  
>  	# Offset exceeds region size
>  	exceed_offset=$((region_size))
> -	inject_poison_sysfs "$region" "$exceed_offset" true
> -	clear_poison_sysfs "$region" "$exceed_offset" true
> +	inject_poison "$region" "$exceed_offset" true
> +	clear_poison "$region" "$exceed_offset" true
>  
>  	# Offset exceeds region size by a lot
>  	large_offset=$((region_size * 2))
> -	inject_poison_sysfs "$region" "$large_offset" true
> -	clear_poison_sysfs "$region" "$large_offset" true
> +	inject_poison "$region" "$large_offset" true
> +	clear_poison "$region" "$large_offset" true
>  }
>  
>  is_unaligned() {

