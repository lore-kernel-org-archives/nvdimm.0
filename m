Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871BA101C8
	for <nvdimm@lists.linux.dev>; Thu, 17 Oct 2024 01:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729126834; cv=none; b=RvV5wdYd0V2J/81b+yLE9Vq1G5SCH06+YjtDS1OCvu/RzxVuAgpQIw7lCPw8vHHMvIlyTIZit/Xqi4m1VWSrrZ1hUT5omjQunE2L2vlY0To7DA4+CAFL+JDSi7ixcpIgbm4EhIvOgahMMJOOGWOBEOTqB9bA/MUteQSHICuUMYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729126834; c=relaxed/simple;
	bh=pN9/CQhiuUjOXBkpMoSQVxnZGa5er6XeQXf/EZkXdqY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q7I3AHhHFtICtzQoEJpkm6phGcp0w+9AGstY+tmlNCBU3BU9C4wg388L9Lo9rR122FgNQrFdSON0ZaE2qV1dmI+z5kMbxugkzYmkozzvk/hygdSoE1bvBds11D28ld+Y1HlqpU3z/j3L6bu+AV1dNb2nRbf3iRlyzmaFhWF4N4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KgknBGsa; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KgknBGsa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729126832; x=1760662832;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pN9/CQhiuUjOXBkpMoSQVxnZGa5er6XeQXf/EZkXdqY=;
  b=KgknBGsa/rNAmXReTvk2OQXY/YUgT7wEGKxVtJYY3cz7fpRtSCRqlR25
   +xor76cpz4w/ZAa88mrsTLkI4Rja4uHWPXtJE5JbA189nzBSVCMoj+9Tg
   A2dvouMaBzzlGNQU8VeK4KCiQv0Fdi1KBTgm/7Wg7vpYpBbPBFwN6BFak
   C9gVXVymLKPSp2hlhiXJK70qB4nXp8Ud/BO20CIL8cdZGFNSvBDZiOy1l
   W4DAwEh/uD/b5CpwPWX7YWfXS/pl6J5dPHQ7u2eUjMQoHvDmsqbXDXeb0
   TG4DQRVIKr//lxeSZibaFv1jgV/3Wtrxu6KNjFopn8OdBTow+Cyw0eesj
   A==;
X-CSE-ConnectionGUID: M8ID2KtgRhaX4bXBD3Cmew==
X-CSE-MsgGUID: QwxQWM1nRXC9sQKLcnYWSw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="28748274"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="28748274"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2024 18:00:31 -0700
X-CSE-ConnectionGUID: Xcfw7PY3RreNJWngkNWCjQ==
X-CSE-MsgGUID: KaATVy1wRsaR105VVyxvqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,209,1725346800"; 
   d="scan'208";a="78047561"
Received: from inaky-mobl1.amr.corp.intel.com (HELO aschofie-mobl2.lan) ([10.125.108.245])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2024 18:00:22 -0700
Date: Wed, 16 Oct 2024 18:00:20 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Li Zhijian <lizhijian@fujitsu.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH v2] test/monitor.sh: Fix 2 bash syntax errors
Message-ID: <ZxBhpCc-HrzbeILd@aschofie-mobl2.lan>
References: <20241016052042.1138320-1-lizhijian@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241016052042.1138320-1-lizhijian@fujitsu.com>

On Wed, Oct 16, 2024 at 01:20:42PM +0800, Li Zhijian wrote:
> $ grep -w line build/meson-logs/testlog.txt
> test/monitor.sh: line 99: [: too many arguments
> test/monitor.sh: line 99: [: nmem0: binary operator expected
> test/monitor.sh: line 149: 40.0: syntax error: invalid arithmetic operator (error token is ".0")
> 
> - monitor_dimms could be a string with multiple *spaces*, like: "nmem0 nmem1 nmem2"
> - inject_value is a float value, like 40.0, which need to be converted to
>   integer before operation: $((inject_value + 1))
> 
> Some features have not been really verified due to these errors
> 

Good eye finding the complaints of a passing unit test!
I'm confused on why the trap on err spewed the line number but
didn't fail the test. 

While I, maybe others chew on that, thanks for the patch and
can you do more :)  ?

By quoting $monitor_dimms in the -z check ([ ! -z "$monitor_dimms" ]),
the script breaks out of the loop correctly and monitors the first region
that has DIMMs. I don't know if the test cared if it got the first or
second region of nfit_test, but the syntax is definately wrong, and it's
error prone in mulitple places in that shell script.

'$ shellcheck monitor.sh' shows the instance you found:

>> In monitor.sh line 99:
>> 		[ ! -z $monitor_dimms ] && break
>>                   ^-- SC2236: Use -n instead of ! -z.
>>                        ^------------^ SC2086: Double quote to prevent globbing and word splitting.
>> 
>> Did you mean: 
>> 		[ ! -z "$monitor_dimms" ] && break
>> 

There are a bunch more instances in need of double quotes. Can you turn
this around as a new patch that cleans it all. Note that you might not
be able to get rid of all shellcheck complaints in the boilerplate of
the script, but should be able to clean up the main body of the script
and prevent more problems like you found here.

I'll suggest turning this patch into a 2 patches:

1/1: test/monitor.sh address shellcheck bash syntax issues
2/2: test/monitor.sh convert float to integer before increment

For 2/2 it does stop the test prematurely. We never run the temperature
inject test case of test_filter_dimmevent() because of the inability
to increment the float. Please include that impact statement in the
commit log.

-- Alison

> Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
> ---
> V1:
>  V1 has a mistake which overts to integer too late.
>  Move the conversion forward before the operation
> ---
>  test/monitor.sh | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/test/monitor.sh b/test/monitor.sh
> index c5beb2c..7809a7c 100755
> --- a/test/monitor.sh
> +++ b/test/monitor.sh
> @@ -96,7 +96,7 @@ test_filter_region()
>  	while [ $i -lt $count ]; do
>  		monitor_region=$($NDCTL list -R -b $smart_supported_bus | jq -r .[$i].dev)
>  		monitor_dimms=$(get_monitor_dimm "-r $monitor_region")
> -		[ ! -z $monitor_dimms ] && break
> +		[ ! -z "$monitor_dimms" ] && break
>  		i=$((i + 1))
>  	done
>  	start_monitor "-r $monitor_region"
> @@ -146,6 +146,7 @@ test_filter_dimmevent()
>  	stop_monitor
>  
>  	inject_value=$($NDCTL list -H -d $monitor_dimms | jq -r .[]."health"."temperature_threshold")
> +	inject_value=${inject_value%.*}
>  	inject_value=$((inject_value + 1))
>  	start_monitor "-d $monitor_dimms -D dimm-media-temperature"
>  	inject_smart "-m $inject_value"
> -- 
> 2.44.0
> 
> 
