Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA5F26FA73
	for <nvdimm@lists.linux.dev>; Thu,  8 May 2025 19:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746730986; cv=none; b=joADs/m6/s3Yc1oGKK/oaDDEA0YFLy6rw5+17w8+oAy0B3ITxlI0MKP8Rs45xRnLFBYvKYu7EvSKx38uXebMVpqeqOdXQOVgr7PhcwAsH0LVvNHhy0U92Ln6Ro/Y5VSsaOWxbPODdlPaE2jHCuGxYf/ejjH/Oky6Vrpkq8zM/HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746730986; c=relaxed/simple;
	bh=cj3skfgFXtE4YTBJ0L4NU+yRL33UbzMipP2aJaAC19A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HUO2Mgi6jCzp8eLKhkJ84UFYZ16Sc0k6pZuyVhQmay/yeqkasXflLFvh6PFtSperBpzVpjS9bXY+QZGDMZVV2hwW6f2V0RsOzOuf92kx0kupGui5HF1QIH/d7FbE9NpPszegxRw3pfPLbv5jUrm+RyyQMEFTUja1Q3gYGgaDpsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gOFw138x; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gOFw138x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746730984; x=1778266984;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=cj3skfgFXtE4YTBJ0L4NU+yRL33UbzMipP2aJaAC19A=;
  b=gOFw138xMC0N2yNkbTEAjbss14SKbFA9UWU5X9DfZZe6Y1vWVOq5Fho4
   nX8w2B6G8rgbDvdlN/KQzqmPL1ZIo3Yhe8mumEE+ySM2vb2fxzouk/Vvd
   r8mE+s8DJOzghmIIZuRJdwbksi5JAJ6Y80Hsl38uNs7p3Gn89G88O+tTa
   KL9tP6REyin10vQ4384jiK0ZCUepsZ07inXi+IEPF4b+/PAP4Dil/nXKq
   x63oQrPhkX3mY/QUGyUKfy0gOLjG15uvKnQeD8tA8y9xGg52JQO4RR1r4
   rcpQBGfBuzkclgjqIWgyuCNpmj0DxsvzpE1X/nYunht3IWspVqjr8ANm0
   g==;
X-CSE-ConnectionGUID: 6yG8jJQiRp+XN5uqfqVE9w==
X-CSE-MsgGUID: XCN0Ju4CSJqQO6+r6XFzbA==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="48405884"
X-IronPort-AV: E=Sophos;i="6.15,273,1739865600"; 
   d="scan'208";a="48405884"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 12:03:03 -0700
X-CSE-ConnectionGUID: MGopYwafRWeEDHxp5w6uvg==
X-CSE-MsgGUID: rWRS7kZeQg6g46RsoO8XLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,273,1739865600"; 
   d="scan'208";a="140425841"
Received: from vverma7-desk1.amr.corp.intel.com (HELO [10.125.108.128]) ([10.125.108.128])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 12:03:02 -0700
Message-ID: <86ddbf3f-4528-41c7-80f5-44ac68097ae0@intel.com>
Date: Thu, 8 May 2025 12:03:01 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [NDCTL PATCH] cxl: Change cxl-topology.sh assumption on host
 bridge validation
To: "Verma, Vishal L" <vishal.l.verma@intel.com>,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Cc: "Schofield, Alison" <alison.schofield@intel.com>
References: <20250507164618.635320-1-dave.jiang@intel.com>
 <ffac09c7154f4c4bc9dff6524a02d8a707ad8b0c.camel@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <ffac09c7154f4c4bc9dff6524a02d8a707ad8b0c.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 5/7/25 11:48 PM, Verma, Vishal L wrote:
> On Wed, 2025-05-07 at 09:46 -0700, Dave Jiang wrote:
>> Current host bridge validation in cxl-topology.sh assumes that the
>> decoder enumeration is in order and therefore the port numbers can
>> be used as a sorting key. With delayed port enumeration, this
>> assumption is no longer true. Change the sorting to by number
>> of children ports for each host bridge as the test code expects
>> the first 2 host bridges to have 2 children and the third to only
>> have 1.
>>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> ---
>>  test/cxl-topology.sh | 10 ++++++----
>>  1 file changed, 6 insertions(+), 4 deletions(-)
>>
>> diff --git a/test/cxl-topology.sh b/test/cxl-topology.sh
>> index 90b9c98273db..41d6f052394d 100644
>> --- a/test/cxl-topology.sh
>> +++ b/test/cxl-topology.sh
>> @@ -37,15 +37,16 @@ root=$(jq -r ".[] | .bus" <<< $json)
>>  
>>  
>>  # validate 2 or 3 host bridges under a root port
>> -port_sort="sort_by(.port | .[4:] | tonumber)"
>>  json=$($CXL list -b cxl_test -BP)
>>  count=$(jq ".[] | .[\"ports:$root\"] | length" <<< $json)
>>  ((count == 2)) || ((count == 3)) || err "$LINENO"
>>  bridges=$count
>>  
>> -bridge[0]=$(jq -r ".[] | .[\"ports:$root\"] | $port_sort | .[0].port" <<< $json)
>> -bridge[1]=$(jq -r ".[] | .[\"ports:$root\"] | $port_sort | .[1].port" <<< $json)
>> -((bridges > 2)) && bridge[2]=$(jq -r ".[] | .[\"ports:$root\"] | $port_sort | .[2].port" <<< $json)
>> +bridge[0]=$(jq -r --arg key "$root" '.[] | select(has("ports:" + $key)) | .["ports:" + $key] | map({full: ., length: (.["ports:" + .port] | length)}) | sort_by(-.length) | map(.full) | .[0].port' <<< "$json")
>> +
>> +bridge[1]=$(jq -r --arg key "$root" '.[] | select(has("ports:" + $key)) | .["ports:" + $key] | map({full: ., length: (.["ports:" + .port] | length)}) | sort_by(-.length) | map(.full) | .[1].port' <<< "$json")
>> +
>> +((bridges > 2)) && bridge[2]=$(jq -r --arg key "$root" '.[] | select(has("ports:" + $key)) | .["ports:" + $key] | map({full: ., length: (.["ports:" + .port] | length)}) | sort_by(-.length) | map(.full) | .[2].port' <<< "$json")
>>  
> 
> The jq filtering looks reasonable, but the long lines are definitely a
> bit unsightly, not to mention hard to follow/edit in the future.
> 
> How about this incremental patch (It passes the test for me with the
> delayed port enumeration series):

LGTM

DJ

> 
> -->8--
> 
> From 996610fac0a751acc5d68a56ff7d6746348a80c4 Mon Sep 17 00:00:00 2001
> From: Vishal Verma <vishal.l.verma@intel.com>
> Date: Thu, 8 May 2025 00:46:27 -0600
> Subject: [ndctl PATCH] test: Cleanup long lines in cxl-topology.sh
> 
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  test/cxl-topology.sh | 27 ++++++++++++++++++++++++---
>  1 file changed, 24 insertions(+), 3 deletions(-)
> 
> diff --git a/test/cxl-topology.sh b/test/cxl-topology.sh
> index f4ba7374..b68cb8b2 100644
> --- a/test/cxl-topology.sh
> +++ b/test/cxl-topology.sh
> @@ -42,11 +42,32 @@ count=$(jq ".[] | .[\"ports:$root\"] | length" <<< $json)
>  ((count == 2)) || ((count == 3)) || err "$LINENO"
>  bridges=$count
>  
> -bridge[0]=$(jq -r --arg key "$root" '.[] | select(has("ports:" + $key)) | .["ports:" + $key] | map({full: ., length: (.["ports:" + .port] | length)}) | sort_by(-.length) | map(.full) | .[0].port' <<< "$json")
> +bridge_filter()
> +{
> +	local br_num="$1"
>  
> -bridge[1]=$(jq -r --arg key "$root" '.[] | select(has("ports:" + $key)) | .["ports:" + $key] | map({full: ., length: (.["ports:" + .port] | length)}) | sort_by(-.length) | map(.full) | .[1].port' <<< "$json")
> +	jq -r \
> +		--arg key "$root" \
> +		--argjson br_num "$br_num" \
> +		'.[] |
> +		  select(has("ports:" + $key)) |
> +		  .["ports:" + $key] |
> +		  map(
> +		    {
> +		      full: .,
> +		      length: (.["ports:" + .port] | length)
> +		    }
> +		  ) |
> +		  sort_by(-.length) |
> +		  map(.full) |
> +		  .[$br_num].port'
> +}
>  
> -((bridges > 2)) && bridge[2]=$(jq -r --arg key "$root" '.[] | select(has("ports:" + $key)) | .["ports:" + $key] | map({full: ., length: (.["ports:" + .port] | length)}) | sort_by(-.length) | map(.full) | .[2].port' <<< "$json")
> +# $count has already been sanitized for acceptable values, so
> +# just collect $count bridges here.
> +for i in $(seq 0 $((count - 1))); do
> +	bridge[$i]="$(bridge_filter "$i" <<< "$json")"
> +done
>  
>  # validate root ports per host bridge
>  check_host_bridge()
> 
> base-commit: 92d5203077553bfc9f7bf1c219563db0fc28e660
> prerequisite-patch-id: f17261693e3ac38880b7701a94a469bb513b4078

