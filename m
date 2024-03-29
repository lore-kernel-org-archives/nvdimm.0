Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9841C0DEF
	for <nvdimm@lists.linux.dev>; Fri, 29 Mar 2024 15:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711726741; cv=none; b=t83HZhfYiaLMkxzTZFeMQDiQ+p/XDxKB4tLbeGStO5BFbYyKQ/Aki1ZDOoA6+U+qQkTidBVdiFu/XaJ3kpyDvNooZ8lGYOcMQhUfN1ug03DgPtmZ0g5Ebrn+dYKOPourhouKmLKfwXG/cOXadQgu6XmsHUaSzgbx8+T+MPKqnn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711726741; c=relaxed/simple;
	bh=Yoeu+yPvWcr7mJFMnMj9r7kyoeVhlg19SNCTjudoBQQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=itmI0u9LCqGLZS69UzcCMj15DFPh/sRCyemUBJabIv1H6aHS/LvmFzOIK0OpfcWRK0NOS7NpjjX5LuiIhP8FgZCIFr9jWsue/7l5ED7N8a23FaKcRhxZBe/e6Ea9TsvwLJhTMtcirpSmFSVyXfTrQYtZtAeCKuzVVGiIVjKwB4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HL8bSpm6; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HL8bSpm6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711726740; x=1743262740;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Yoeu+yPvWcr7mJFMnMj9r7kyoeVhlg19SNCTjudoBQQ=;
  b=HL8bSpm62NkTk8dHNCRE78NPAcv2REOG7ngVf05wO5sVZoZuGuLWCpcn
   gQULpRvVg276Db+MalRxCgm2GYmEJlunviZhQnhLgl8PeOkW7krYP685L
   NpPf8G/wGnpeSfNrJpl9Ue8r56jKTJVHdHwEIwYVib84RWKaK6EQbIdsZ
   rXHaj2TAB4sGAnPVo61lDDewyzDY8TB18Fux1KguNeo3xhycQQoZOVfsh
   fyDoxa+CHYDxiWQZw9SuVcG4PZRY6Tene8ZJj2NW9CQoDqByrbNu6LANN
   yXg3UnXw5lellHHfKQ0e4w0AvaW3zLXCEWago5IsywmLDcnzUBtsiRwP+
   g==;
X-CSE-ConnectionGUID: spRjSjIlTU6U/wIedG5abQ==
X-CSE-MsgGUID: 5c5lK/6CTV2yy6YVtqTw3w==
X-IronPort-AV: E=McAfee;i="6600,9927,11028"; a="10727581"
X-IronPort-AV: E=Sophos;i="6.07,165,1708416000"; 
   d="scan'208";a="10727581"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2024 08:38:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,165,1708416000"; 
   d="scan'208";a="21714104"
Received: from mjhill-mobl2.amr.corp.intel.com (HELO [10.212.98.214]) ([10.212.98.214])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2024 08:38:59 -0700
Message-ID: <e3f7bb27-6bcc-41d3-bf77-8458591d1fe6@intel.com>
Date: Fri, 29 Mar 2024 08:38:58 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH] cxl/test: Add test case for region info to
 cxl-events.sh
Content-Language: en-US
To: alison.schofield@intel.com, Vishal Verma <vishal.l.verma@intel.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
References: <20240328043727.2186722-1-alison.schofield@intel.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20240328043727.2186722-1-alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/27/24 9:37 PM, alison.schofield@intel.com wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> Events cxl_general_media and cxl_dram both report DPAs that may
> be mapped in a region. If the DPA is mapped, the trace event will
> include the HPA translation, region name and region uuid in the
> trace event.
> 
> Add a test case that triggers these events with DPAs that map
> into a region. Verify the region is included in the trace event.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  test/cxl-events.sh | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/test/cxl-events.sh b/test/cxl-events.sh
> index fe702bf98ad4..ff4f3fdff1d8 100644
> --- a/test/cxl-events.sh
> +++ b/test/cxl-events.sh
> @@ -23,6 +23,26 @@ modprobe cxl_test
>  rc=1
>  
>  dev_path="/sys/bus/platform/devices"
> +trace_path="/sys/kernel/tracing"
> +
> +test_region_info()
> +{
> +	# Trigger a memdev in the cxl_test autodiscovered region
> +	region=$($CXL list  -R | jq -r ".[] | .region")
> +	memdev=$($CXL list -r "$region" --targets |
> +		jq -r '.[].mappings' |
> +		jq -r '.[0].memdev')
> +	host=$($CXL list -m "$memdev" | jq -r '.[].host')
> +
> +	echo 1 > "$dev_path"/"$host"/event_trigger
> +
> +	if ! grep "cxl_general_media.*$region" "$trace_path"/trace; then
> +		err "$LINENO"
> +	fi
> +	if ! grep "cxl_dram.*$region" "$trace_path"/trace; then
> +		err "$LINENO"
> +	fi
> +}
>  
>  test_cxl_events()
>  {
> @@ -74,6 +94,10 @@ if [ "$num_info" -ne $num_info_expected ]; then
>  	err "$LINENO"
>  fi
>  
> +echo 1 > /sys/kernel/tracing/tracing_on
> +test_region_info
> +echo 0 > /sys/kernel/tracing/tracing_on
> +
>  check_dmesg "$LINENO"
>  
>  modprobe -r cxl_test
