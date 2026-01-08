Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CCC029B20D
	for <nvdimm@lists.linux.dev>; Thu,  8 Jan 2026 17:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767891783; cv=none; b=GxNrx7XpEVpdFdoml5pTOIQRccXMkI/avs/SInHQJA0aSHQFb67irZEjFQoMfeJRfyW0OyORSMoz7Vn8uB3pHlg2i/DsH8GB/cJJRohZUX22RODzOjtNxtjoGcG18RBsP/I3FWTEXbcFk6Ddjh+ZWT7B9aSvN3kFZvwtOY8nrjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767891783; c=relaxed/simple;
	bh=WHPBXYeZlq5Q/Kk8b3l++WpMMMrIXIZ3JlbIyb3U9jQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fb68QPV/CbhhnPz1gRsrAlWiO2gQSeWsoKMYl8FbNE9NRY9LClY8I3PkWnBJm97ChoQytJIAicKuIUknqdML9hHOOtiWAQxr/fCVGjYVQjRyLdd9QIAuQEtGr+TXEtSTtFYh3joWi9I5GtAJ1GLhbQXdvQFTMbNEEmQtXgnGwmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MeBtvh1e; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MeBtvh1e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767891781; x=1799427781;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=WHPBXYeZlq5Q/Kk8b3l++WpMMMrIXIZ3JlbIyb3U9jQ=;
  b=MeBtvh1ehlTePHw5SjejU9CJpdaeUIds4VLdxmi/0qhyCcoOnWiR94Tf
   K74vEW1UGAtOjebO1VF7EMJ4Rf03/nhmuvJP/to5qD9w6mAfyjlhxLD0M
   w8ba/OXXTlKEPK6aW6VNFvKEZ3TbsA0WHK2o5MW7gdQGo/a2WfZhvJ9zM
   iKxMuCaExvh+gmp5HRsB+FPLMhzi7WiGBaTfP7BucBsVImEpntqqWJjXC
   n/o/XHL53UHX9YRD3EH9ejqzrmvVCWKyoEtx5ZSeH95khqt5m0B4iqqau
   dNYNivt2fLblBUFm5PZTv5uURMjrk4G3eeGtuDJTVMmRr/6cotoN6TdlA
   w==;
X-CSE-ConnectionGUID: OsW8tNGTTDytm+09/1rMgg==
X-CSE-MsgGUID: bzzT2afKTsiC7hTdeIurcQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11665"; a="69348111"
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="69348111"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 09:03:00 -0800
X-CSE-ConnectionGUID: NoVBh6fSTsCbitvW98NIlw==
X-CSE-MsgGUID: WNvN9D+VSHStJfxDQSgcHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="203269005"
Received: from rchatre-mobl4.amr.corp.intel.com (HELO [10.125.109.207]) ([10.125.109.207])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 09:02:59 -0800
Message-ID: <e2608021-a3bc-4598-bb98-2a8a885b9f8d@intel.com>
Date: Thu, 8 Jan 2026 10:02:58 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH] test/cxl-topology.sh: test switch port target
To: Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org
References: <20260108052552.395896-1-alison.schofield@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260108052552.395896-1-alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/7/26 10:25 PM, Alison Schofield wrote:
> Add a test case to validate that all switch port decoders sharing
> downstream ports, dports, have target lists properly enumerated.
> 
> This test catches the regression fixed by a recent kernel patch[1]
> where only one decoder per switch port has targets populated while
> others have nr_targets=0, even when dports are available.
> 
> This test is based on the current cxl_test topology which provides
> multiple switch ports with 8 decoders each. Like other testcases in
> cxl-topology.sh, if the cxl_test topology changes (number of switches,
> decoders per port, or hierarchy), this test will need corresponding
> updates.
> 
> This new case is quietly skipped with kernel version 6.18 where it
> is known broken.
> 
> [1] https://lore.kernel.org/linux-cxl/20260107100356.389490-1-rrichter@amd.com/
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
> 
>  test/common          | 12 +++++++++++
>  test/cxl-topology.sh | 51 ++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 63 insertions(+)
> 
> diff --git a/test/common b/test/common
> index 2d076402ef7c..2eb11b7396d0 100644
> --- a/test/common
> +++ b/test/common
> @@ -101,6 +101,18 @@ check_min_kver()
>  	[[ "$ver" == "$(echo -e "$ver\n$KVER" | sort -V | head -1)" ]]
>  }
>  
> +# check_eq_kver
> +# $1: Kernel version to match. format: X.Y
> +#
> +check_eq_kver()
> +{
> +        local ver="$1"
> +        : "${KVER:=$(uname -r)}"
> +
> +        [ -n "$ver" ] || return 1
> +        [[ "$KVER" == "$ver"* ]]
> +}
> +
>  # do_skip
>  # $1: Skip message
>  #
> diff --git a/test/cxl-topology.sh b/test/cxl-topology.sh
> index b68cb8b262b6..d9475b1bae9c 100644
> --- a/test/cxl-topology.sh
> +++ b/test/cxl-topology.sh
> @@ -151,6 +151,57 @@ count=$(jq "map(select(.pmem_size == $pmem_size)) | length" <<< $json)
>  ((bridges == 2 && count == 8 || bridges == 3 && count == 10 ||
>    bridges == 4 && count == 11)) || err "$LINENO"
>  
> +# Test that switch port decoders have complete target list enumeration
> +# Validates a fix for multiple decoders sharing the same dport.
> +# Based on the cxl_test topology expectation of switch ports at depth 2
> +# with 8 decoders each. Adjust if that expectation changes.
> +test_switch_decoder_target_enumeration() {
> +
> +	# Get verbose output to see targets arrays
> +	json=$($CXL list -b cxl_test -vvv)
> +
> +	switch_port_issues=$(jq '
> +	# Find all switch ports (depth 2)
> +	[.. | objects | select(.depth == 2 and has("decoders:" + .port))] |
> +
> +	# For each switch port, analyze its decoder target pattern
> +	map({
> +		port: .port,
> +		nr_dports: .nr_dports,
> +
> +		# Count non-endpoint decoders (no "mode" field)
> +		total: ([to_entries[] | select(.key | startswith("decoders:"))
> +			| .value[] | select(has("mode") == false)] |
> +			length),
> +
> +		# Count how many have targets
> +		with_targets: ([to_entries[] | select(.key |
> +			startswith("decoders:")) | .value[] |
> +			select(has("mode") == false and .nr_targets > 0)] |
> +			length),
> +
> +		# Count how many explicitly have no targets
> +		without_targets: ([to_entries[] | select(.key |
> +			startswith("decoders:")) | .value[] |
> +			select(has("mode") == false and .nr_targets == 0)] |
> +			length)
> +		}) |
> +
> +		# Filter for the expected pattern and count them
> +		map(select(.nr_dports > 0 and
> +			   .with_targets == 1 and
> +			   .without_targets >= 7)) |
> +			   length
> +	' <<<"$json")
> +
> +	((switch_port_issues == 0)) || {
> +		echo "Found $switch_port_issues switch ports with incomplete target enumeration"
> +		echo "Only 1 decoder has targets while 7+ have nr_targets=0"
> +		err "$LINENO"
> +	}
> +}
> +# Skip the target enumeration test where known broken
> +check_eq_kver 6.18 || test_switch_decoder_target_enumeration

6.19 I believe?

DJ

>  
>  # check that switch ports disappear after all of their memdevs have been
>  # disabled, and return when the memdevs are enabled.

