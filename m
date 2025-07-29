Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0431B2110E
	for <nvdimm@lists.linux.dev>; Tue, 29 Jul 2025 15:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753802365; cv=none; b=OuYSLA0XB6cA0VUnFoy5KYvzOnedfkzALvFNpakze+9HLFzLzhl74wHbfoRFD2bIgbTvpEYAImhKjFtQ1kLQB5pf1gzebpwCFx4CAW62HIRPpWrkC/OPIOPzT3Zx3BluhzcXTdpX8DtEj8Tibtu0GH0wHTAUtYTJOF8qrN+Iqxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753802365; c=relaxed/simple;
	bh=uaXfbJZTf9te81pz8wJyvsYwYqdcHegH9D4CBkyG3eA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=LyVMflCg8K8YyyiHFF4Es2KZyehtHLNo/y96lG2sqyvGDB/LoJ3aeEMRy+BgUeqdJpZ4GevKIz2LYTQy/od6Q3Tn0NomtkZ793xsiNtlXd9jZ00i9wnxn2RMg28Lm5tblJ+x9S3ErGlvl5L7RBYquzj8vs9pLIApcnY9Uey8P0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YN7IF3r3; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YN7IF3r3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753802364; x=1785338364;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=uaXfbJZTf9te81pz8wJyvsYwYqdcHegH9D4CBkyG3eA=;
  b=YN7IF3r3zxrzFbBwgxuigmdfmCpftcQcqLTa9x0VCDcHHtH+pcaAijf/
   niyQCqDguPqgV2Ryi8bAbkzdLqRWhUZN0XxWYeXVinRW/RMyyiwS5mObj
   ZJu16BI7xqDXJPRSms73kFwc+iAn0qMrKnVqrweQbCk84dKGaUMMgGTew
   o6DulgsAIfOPkUTNjYrT4ycxqnPqqcXF5eQ+/Gk5o6DTT8xerysRdBoec
   q1cbADU+YmGgi882jGi5ikEn2j5cM4acfffEJK/ajBOI6Fh2cZTtZqL5F
   U2ORTWQAD0JAH2BvDZJKkS7enJrbO09A+nUfQaFj540YAvxpUrN8XHZhh
   g==;
X-CSE-ConnectionGUID: LaU8xrvbR7+Njq7dOWGqBA==
X-CSE-MsgGUID: IczOyZTtR6WybdzPt+RHnQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11506"; a="56153523"
X-IronPort-AV: E=Sophos;i="6.16,349,1744095600"; 
   d="scan'208";a="56153523"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2025 08:19:24 -0700
X-CSE-ConnectionGUID: pAgfAyZRRkmfxvllf1L8xQ==
X-CSE-MsgGUID: U2oLkLuRQvSeLehyodQz4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,349,1744095600"; 
   d="scan'208";a="161999418"
Received: from bvivekan-mobl2.gar.corp.intel.com (HELO [10.247.118.247]) ([10.247.118.247])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2025 08:19:20 -0700
Message-ID: <3ee61bb6-0f54-4a62-9c31-0d803a7f667e@intel.com>
Date: Tue, 29 Jul 2025 08:19:15 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH 3/3] test/common: stop relying on bash $SECONDS in
 check_dmesg()
To: marc.herbert@linux.intel.com, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, alison.schofield@intel.com, dan.j.williams@intel.com
References: <20250724221323.365191-1-marc.herbert@linux.intel.com>
 <20250724221323.365191-4-marc.herbert@linux.intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20250724221323.365191-4-marc.herbert@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/24/25 3:00 PM, marc.herbert@linux.intel.com wrote:
> From: Marc Herbert <marc.herbert@linux.intel.com>
> 
> Stop relying on the imprecise bash $SECONDS variable as a test start
> timestamp when scanning the logs for issues.
> 
> $SECONDS was convenient because it came "for free" and did not require
> any time_init(). But it was not fine-grained enough and its rounding
> process is not even documented. Keep using $SECONDS in log messages
> where it is easy to use and more user-friendly than bare timestamps, but
> switch the critical journalctl scan to a new, absolute NDTEST_START
> timestamp initialized when test/common is sourced. Use a SECONDS-based,
> rough sanity check in time_init() to make sure test/common is always
> sourced early.
> 
> Signed-off-by: Marc Herbert <marc.herbert@linux.intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

Looks ok to me, but I'm not great with bash scripting or journalctl. 

> ---
>  test/common | 52 ++++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 50 insertions(+), 2 deletions(-)
> 
> diff --git a/test/common b/test/common
> index 2d076402ef7c..0214c6aaed5f 100644
> --- a/test/common
> +++ b/test/common
> @@ -15,6 +15,25 @@ err()
>  	exit "$rc"
>  }
>  
> +# Initialize the NDTEST_START timestamp used to scan the logs.
> +# Insert an anchor/bookmark in the logs to quickly locate the start of any test.
> +time_init()
> +{
> +	# Refuse to run if anything lasted for too long before this point
> +	# because that would make NDTEST_START incorrect.
> +	test "$SECONDS" -le 1 || err 'test/common must be included first!'
> +
> +	NDTEST_START=$(LC_TIME=C date '+%F %T.%3N')
> +
> +	# Log anchor, especially useful when running tests back to back
> +	printf "<5>%s@%ds: sourcing test/common: NDTEST_START=%s\n" \
> +		"$test_basename" "$SECONDS" "$NDTEST_START" > /dev/kmsg
> +
> +	# Default value, can be overridden by the environment
> +	: "${NDTEST_LOG_DBG:=false}"
> +}
> +time_init
> +
>  # Global variables
>  
>  # NDCTL
> @@ -147,11 +166,40 @@ json2var()
>  # $1: line number where this is called
>  check_dmesg()
>  {
> +	if "$NDTEST_LOG_DBG"; then
> +		# Keep a record of which log lines we scanned
> +		journalctl -q -b --since "$NDTEST_START" \
> +			-o short-precise > journal-"$(basename "$0")".log
> +	fi
> +	# After enabling with `NDTEST_LOG_DBG=true meson test`, inspect with:
> +	#    head -n 7 $(ls -1t build/journal-*.log | tac)
> +	#    journalctl --since='- 5 min' -o short-precise -g 'test/common'
> +
>  	# validate no WARN or lockdep report during the run
> -	sleep 1
> -	log=$(journalctl -r -k --since "-$((SECONDS+1))s")
> +	log=$(journalctl -r -k --since "$NDTEST_START")
>  	grep -q "Call Trace" <<< "$log" && err "$1"
>  	true
> +
> +	# Log anchor, especially useful when running tests back to back
> +	printf "<5>%s@%ds: test/common: check_dmesg() OK\n" "$test_basename" "$SECONDS" > /dev/kmsg
> +
> +	if "$NDTEST_LOG_DBG"; then
> +	    log_stress from_check_dmesg
> +	fi
> +}
> +
> +# While they should, many tests don't use check_dmesg(). So double down here. Also, this
> +# runs later which is better.
> +# Before enabling NDTEST_LOG_DBG=true, make sure no test started defining its own
> +# EXIT trap.
> +if "$NDTEST_LOG_DBG"; then
> +    trap 'log_stress from_trap' EXIT
> +fi
> +
> +log_stress()
> +{
> +	printf '<3>%s@%ds: NDTEST_LOG_DBG Call Trace; trying to break the next check_dmesg() %s\n' \
> +		"$test_basename" "$SECONDS" "$1" > /dev/kmsg
>  }
>  
>  # CXL COMMON

