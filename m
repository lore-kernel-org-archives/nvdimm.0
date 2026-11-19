Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.19
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795107938;
	b=jflNxr5LUmdVvNNYl+ox1x/h/9k6f913bRNB/DCOAq5O7F4cTLkJfIN7lJhm95zvxLk7
	 PW8z1HQWxVR8GjGSRpKmZDbuPLYr1vYWdwGyIzrHlLc14WFr7JM/vqJwVr+YO5YRUEqlh
	 ORATUvP6cLtVyGlh0a+q8aUZUu+Xhv+rQcPT7MYnRr5UivK5FEil71d3RQzEkyiS00erR
	 sp0c7Qiu0EXBRCTc3Nk2zWb+M17gKuVbz3BjDCzktnWRf+h9KIdz/6wDx/EuE7UHaboV+
	 ALDB/oUvmKenRvvuzoEb6tGn6DpXideeSyN7/ywke40jeoQPdObASujULdQGQkYk80g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795107938;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:References:From:Content-Language:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=6XKcrVnFYWsJxZFB9lfynZeECKfsV0UN7vPk3wRl2i4=;
	b=XgENO8Rrl9bh2RZwZhq65zQ1jQjWP4olvYZtDNkydEQsbtuegt44dqprKf6acK3D+nqN
	 zNuoYudcWUat2/S9NIwlusHvmSGkvEMSioE+y81Rd8dl9NPMAHFWTMPisrwOPCKUJ6hxw
	 /RGzBzA4HY7U5hynyqaBRSCxPwbEtDg2SzY0wx5GIsOW6Hq1UkaI3g42tJFZECPxEbjEZ
	 GHnJhrLg6GwJvsB7UFHZ+OXPS1JsD9C1V3+es1KsBEN05gONiZM1qzwvmbD11LkI6nQR9
	 b/eSnWFu36cnnv4liZvWbLNmEdm8VJ+aA+pkEbR3+r71n2xtipGTuufpkgjYMRHn2bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=euQk35j5;
	arc=none smtp.remote-ip=198.175.65.19
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5B5606A331
	for <nvdimm@lists.linux.dev>; Thu, 19 Nov 2026 17:05:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AF5B5606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=euQk35j5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795107937; x=1826643937;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=EguHJXxvL0czNPX8q0bFx+KtIVz7ozIl+FvZvVlNL6g=;
  b=euQk35j5ZDY472LZkJSbmrCjIKw6kHoD39ix8KbnD97SpONeea9kiJIu
   rXu7tQXehwjNOUbLCCpc1Qqn7NubwA5MpOq6Je2DnL0kFUfhpnd+3Ckrr
   GaUgJJZzqbRn/xABCg1tUjQNf/B+rUrnvW02JAfFk2D50azYxhQrcimJ8
   4Scxn68AnkFB0NqZjignqARqCrJjwUoBk8AqzcGpgOm/kOzL0oTBHe7vy
   xobAtIgFCer5AbV8eu6JrY70+JH625oDc+zh9OlCU02gLZ87Qud+8NRiO
   ZXdjwJIYBVrQC0KmSkNqr0haAdm3hrTtoWDBj8fH3/aLMV3HoaXb9e30Y
   g==;
X-CSE-ConnectionGUID: l8lhyO2zQWGcn+htL2zbLg==
X-CSE-MsgGUID: HjKC1/TyTbmot7aWjecCEQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11971"; a="4012286"
X-IronPort-AV: E=Sophos;i="6.27,221,1787036400"; 
   d="scan'208";a="4012286"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2026 09:04:59 -0800
X-CSE-ConnectionGUID: /vBw2213Si6QtSY4HjlBsw==
X-CSE-MsgGUID: FrxLDSm6Qsqf6RMURN8fUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,221,1787036400"; 
   d="scan'208";a="10573429"
Received: from smithj1-mobl2.amr.corp.intel.com (HELO [10.125.109.70]) ([10.125.109.70])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2026 09:04:58 -0800
Message-ID: <0fb8070d-b0fe-423e-9cea-8f58ea70a74b@intel.com>
Date: Thu, 19 Nov 2026 10:04:56 -0700
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH] test/common: make kernel version checks RC-aware
To: Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev
References: <20261119023451.165214-1-alison.schofield@intel.com>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20261119023451.165214-1-alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/18/26 7:34 PM, Alison Schofield wrote:
> check_min_kver() ignores RC numbers. When a kernel fix lands during an RC
> cycle, tests that depend on it use the next kernel release as their
> minimum. This avoids failures on earlier RCs but delays CI coverage after
> the fix is available.
> 
> Honor explicit X.Y-rcN minimums so CI can run a test starting with the
> first RC that contains the fix. A bare X.Y minimum continues to accept all
> RCs in that cycle.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
> 
> This came up recently as we have a test case for a kernel fix that is
> expected to be in 7.4-rc4. This change supports exercising that test
> case asap, rather than waiting for 7.5-rc1.
> 
> 
>  test/common | 40 ++++++++++++++++++++++++++++++++++++----
>  1 file changed, 36 insertions(+), 4 deletions(-)
> 
> diff --git a/test/common b/test/common
> index d60d9e046445..ed533cd92a42 100644
> --- a/test/common
> +++ b/test/common
> @@ -89,16 +89,48 @@ reset1()
>  }
>  
>  
> +# __kver_key
> +# $1: Kernel version in X.Y[.Z][-rcN] format, trailing text is ignored
> +# $2: RC number to use when $1 has no -rc suffix
> +#
> +# Print a fixed-width key with four digits per field and a missing Z
> +# treated as 0. Reserve RC value 9999 for final releases so they sort
> +# after their RCs. A minimum without -rcN uses 0 so it accepts every
> +# RC of that version.
> +#
> +__kver_key()
> +{
> +	local re='^([0-9]+)\.([0-9]+)(\.([0-9]+))?(-rc([0-9]+))?'
> +	local i
> +
> +	[[ "$1" =~ $re ]] || return 1
> +	for i in 1 2 4 6; do
> +		(( ${#BASH_REMATCH[i]} <= 4 )) || return 1
> +	done
> +	(( 10#${BASH_REMATCH[6]:-0} < 9999 )) || return 1
> +	printf "%04d%04d%04d%04d" \
> +		"$((10#${BASH_REMATCH[1]}))" "$((10#${BASH_REMATCH[2]}))" \
> +		"$((10#${BASH_REMATCH[4]:-0}))" "$((10#${BASH_REMATCH[6]:-$2}))"
> +}
> +
>  # check_min_kver
> -# $1: Supported kernel version. format: X.Y
> +# $1: Minimum kernel version in X.Y[.Z][-rcN] format
> +#
> +# X.Y passes from X.Y-rc1 on. Use X.Y-rcN to set a specific RC as
> +# the minimum. The argument must match the full version format above.
>  #
>  check_min_kver()
>  {
> -	local ver="$1"
> +	local want have
>  	: "${KVER:=$(uname -r)}"
>  
> -	[ -n "$ver" ] || return 1
> -	[[ "$ver" == "$(echo -e "$ver\n$KVER" | sort -V | head -1)" ]]
> +	if [[ ! "$1" =~ ^[0-9]+\.[0-9]+(\.[0-9]+)?(-rc[0-9]+)?$ ]]; then
> +		echo "test/$test_basename: invalid kernel version '$1'" >&2
> +		return 1
> +	fi
> +	want=$(__kver_key "$1" 0) || return 1
> +	have=$(__kver_key "$KVER" 9999) || return 1
> +	(( 10#$have >= 10#$want ))
>  }
>  
>  # check_eq_kver

