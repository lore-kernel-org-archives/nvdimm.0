Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A563018BC3B
	for <nvdimm@lists.linux.dev>; Mon,  6 Apr 2026 17:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775496788; cv=none; b=CoUhaq2RXjrKFjKB2c30zcqneauWPCj8MNNsY/GINgIbIduTx3uurJkp3v56tTFUlNRDsqY9PkNhr8XJqrnD5mmxDEK7+bY8bvSDxLIRiIGgK1kTPwE+y+iO9OJTfumUGxG9U8e+G7BbUv9VRWYfpKQ6tupwZEXh5Kh4/2HlKxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775496788; c=relaxed/simple;
	bh=Xat3i6GeNa2h8g1iKJSGubyKDCkvNdLGi8BB+HYci14=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=oZL7HgYU+AF3KULpm+0zq7Y15KvB1goTAOnxmRVvF5oCX0hMgWKZXgyETywmkerfpF57SC8trsz4jIaDftf+FFdl7sC7lpnWH+k766ottWSl8Wmji0rLIJFsQPzBH9mGs85GYKEd05+jdoqsBgEbI65YI1z+2issilH3q0kYozw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JDA45Iv2; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JDA45Iv2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775496786; x=1807032786;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=Xat3i6GeNa2h8g1iKJSGubyKDCkvNdLGi8BB+HYci14=;
  b=JDA45Iv2CdzOzjONkFlfaap+NS9zwYUGyH7JPbWhNTUFefuKXat8u9ql
   3Q+4zN0EI/b4rs3B42sXPuEIr3r/StDkB+KUNNw5Q3lh4tPW/kqQMfyOd
   6dsbc+RMxFDAUppwwIWC+cCY9w44ifAVCFNW4sDN1/cGGnEf2RYtEBa9r
   8YkW10wqllFPH+l5lTjNOXBWAFS6e7CiONwZhR6vEOYaq7CnzC8kEDZqj
   IVdNpBaDnHPOYQ+INP1bSvuYwGfl6rzbDa06Wv1nfHzxK9Jz3NrrRF6hh
   BWV2xE2LyVDwsN8pwSqDC3YZLnTS3UgLrA7+fMPiuWxjDGGrNdzhVCANK
   g==;
X-CSE-ConnectionGUID: Dukka38PRJaW6Pv2KoG49Q==
X-CSE-MsgGUID: hJcq2VLXSkeN9IfGzmZtnw==
X-IronPort-AV: E=McAfee;i="6800,10657,11751"; a="76459002"
X-IronPort-AV: E=Sophos;i="6.23,164,1770624000"; 
   d="scan'208";a="76459002"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2026 10:33:06 -0700
X-CSE-ConnectionGUID: 7kH9DbChTV61qfLTMuogng==
X-CSE-MsgGUID: zsIHiIhCR/+st67tJiJQDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,164,1770624000"; 
   d="scan'208";a="223134835"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO [10.125.108.81]) ([10.125.108.81])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2026 10:31:04 -0700
Message-ID: <d88b9334-181d-4fb6-a694-ef2618c44e1d@intel.com>
Date: Mon, 6 Apr 2026 10:31:03 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH 1/3] test/cxl-destroy-region.sh: prevent false pass
 when no decoder found
To: Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org
References: <c2eccb9b0e596820940bfc7ec839ff807f3ac613.1775265383.git.alison.schofield@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <c2eccb9b0e596820940bfc7ec839ff807f3ac613.1775265383.git.alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/3/26 6:34 PM, Alison Schofield wrote:
> The destroy-region test assumed a free decoder was available and
> silently skipped execution when none could be found. When cxl_test
> began creating an auto region on module load, it consumed the decoder
> resource the test relied on, leading to false passes all the time.
> This was recently noticed during review of test logs.
> 
> Clear all regions at test start to reclaim decoder resources. Fail
> the test if no usable decoder is found and select the first match when
> multiple decoders satisfy the query.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

For the series:

Reviewed-by: Dave Jiang <dave.jiang@intel.com>


> ---
>  test/cxl-destroy-region.sh | 37 +++++++++++++++++++++++++++++++------
>  1 file changed, 31 insertions(+), 6 deletions(-)
> 
> diff --git a/test/cxl-destroy-region.sh b/test/cxl-destroy-region.sh
> index 3952060cf3e2..f03aa67e8b0d 100644
> --- a/test/cxl-destroy-region.sh
> +++ b/test/cxl-destroy-region.sh
> @@ -16,6 +16,22 @@ modprobe -r cxl_test
>  modprobe cxl_test
>  rc=1
>  
> +assert_no_regions()
> +{
> +	regions_json="$("$CXL" list -b "$CXL_TEST_BUS" -Ri)"
> +	[[ -n "$regions_json" ]] || err "$LINENO"
> +	[[ "$(jq 'length' <<<"$regions_json")" -eq 0 ]] || err "$LINENO"
> +}
> +
> +destroy_regions()
> +{
> +	if [[ "$*" ]]; then
> +		"$CXL" destroy-region -f -b "$CXL_TEST_BUS" "$@"
> +	else
> +		"$CXL" destroy-region -f -b "$CXL_TEST_BUS" all
> +	fi
> +}
> +
>  check_destroy_ram()
>  {
>  	mem=$1
> @@ -51,8 +67,15 @@ check_destroy_devdax()
>  	"$CXL" destroy-region "$region"
>  }
>  
> +# Get clean slate, including auto region resources
> +destroy_regions
> +assert_no_regions
> +
>  # Find a memory device to create regions on to test the destroy
>  readarray -t mems < <("$CXL" list -b "$CXL_TEST_BUS" -M | jq -r '.[].memdev')
> +[[ ${#mems[@]} -eq 0 ]] && err "$LINENO"
> +
> +found=0
>  for mem in "${mems[@]}"; do
>          ramsize="$("$CXL" list -m "$mem" | jq -r '.[].ram_size')"
>          if [[ $ramsize == "null" || ! $ramsize ]]; then
> @@ -63,13 +86,15 @@ for mem in "${mems[@]}"; do
>                    select(.volatile_capable == true) |
>                    select(.nr_targets == 1) |
>                    select(.max_available_extent >= ${ramsize}) |
> -                  .decoder")"
> -        if [[ $decoder ]]; then
> -		check_destroy_ram "$mem" "$decoder"
> -		check_destroy_devdax "$mem" "$decoder"
> -                break
> -        fi
> +                  .decoder" | head -n1)"
> +	[[ -z $decoder || $decoder == "null" ]] && continue
> +
> +	check_destroy_ram "$mem" "$decoder"
> +	check_destroy_devdax "$mem" "$decoder"
> +	found=1
> +	break
>  done
> +[[ $found -eq 1 ]] || err "$LINENO"
>  
>  check_dmesg "$LINENO"
>  

