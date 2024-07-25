Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E4B3224
	for <nvdimm@lists.linux.dev>; Thu, 25 Jul 2024 20:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721938538; cv=none; b=aEhAQF6EWK/y4W3tN008jysjMhnt9bnhv/laYhdfoXi7yqqUoEp79U/quVYrbdYddzsZpaSui+t7qZoTBXHY4CQOHt+IZUNGpXWqfdloa7GTfLWORFKwNbPrTggBBc0KtOF+V0ru7Ia1kJ8hQAEuJ/7sU7sG0wrSp+POBNRUqnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721938538; c=relaxed/simple;
	bh=Hh/HkPyGDOjX7U5SfwlDgHuJTyUQUXXI9h4fV/zSzc4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T2qRwvSs6aB6lW2kgWaE9G1aDk2Z4Ytv6ePR+mwX0Eq9mv65wupndm65mt2LCRjpfYBJe9fIV2+DLijx/cPtdmmIz53WWpNyqky6RDbWvI4y9H8cv+oPMa6t4y/ewaQ1cm71raP6MNX2qlLGvIqPe4Is0RvcyE/m+4VhzZp5YVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ro9uQE2z; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ro9uQE2z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721938537; x=1753474537;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Hh/HkPyGDOjX7U5SfwlDgHuJTyUQUXXI9h4fV/zSzc4=;
  b=Ro9uQE2znbsM5b0/dkM0UTBGrq0M8y+6G0YXfoGRXjhiT+9P/rngE++G
   JKOvXUkZ40ealsQhPbzHn/mKqBSBLa0R8nCkiB+qZrBjT20PJG7BktdZQ
   oHIEG/2mr6LAPYOcCbcXh5+7E7tVfMapPVbC6BaGj6fsbYBiJ/0TrPWAw
   nhymDV49TPwNjn694tWJklLvGjZb4SC+43iCmKE8Oo5Rd1f6rxhTRQORC
   yS20bBoUGpdEX+5ZwvXJ3G5D4JzWfjYiWFTIk16nnDatsiVAD/lomaSlE
   vl0hnbAC6b4hu1TbuRKzFwt5utvCtY7cJmKcd8+72Z2SRuSLdVOiCo1FC
   A==;
X-CSE-ConnectionGUID: Jq8gpvOlRKWmeCT4zrix1w==
X-CSE-MsgGUID: wdQXY43uQs+0daZCOu8oEQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11144"; a="19668899"
X-IronPort-AV: E=Sophos;i="6.09,236,1716274800"; 
   d="scan'208";a="19668899"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2024 13:15:37 -0700
X-CSE-ConnectionGUID: fy6c6UjcR3qqqhkCG0HOag==
X-CSE-MsgGUID: W6j3iL25T2eizBZO82DXbw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,236,1716274800"; 
   d="scan'208";a="53282220"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.125.111.91]) ([10.125.111.91])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2024 13:15:35 -0700
Message-ID: <67d14b15-fd3d-48b8-b9c2-fdd6379cd0ff@intel.com>
Date: Thu, 25 Jul 2024 13:15:35 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH] cxl/list: add firmware_version to default memdev
 listing
To: alison.schofield@intel.com, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>
References: <20240725073050.219952-1-alison.schofield@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20240725073050.219952-1-alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/25/24 12:30 AM, alison.schofield@intel.com wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> cxl list users may discover the firmware revision of a memory
> device by using the -F option to cxl list. That option uses
> the CXL GET_FW_INFO command and emits this json:
> 
> "firmware":{
>       "num_slots":2,
>       "active_slot":1,
>       "staged_slot":1,
>       "online_activate_capable":false,
>       "slot_1_version":"BWFW VERSION 0",
>       "fw_update_in_progress":false
>     }
> 
> Since device support for GET_FW_INFO is optional, the above method
> is not guaranteed. However, the IDENTIFY command is mandatory and
> provides the current firmware revision.
> 
> Accessors already exist for retrieval from sysfs so simply add
> the new json member to the default memdev listing.
> 
> This means users of the -F option will get the same info twice if
> GET_FW_INFO is supported.
> 
> [
>   {
>     "memdev":"mem9",
>     "pmem_size":268435456,
>     "serial":0,
>     "host":"0000:c0:00.0"
>     "firmware_version":"BWFW VERSION 00",
>   }
> ]
> 
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  cxl/json.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/cxl/json.c b/cxl/json.c
> index 0c27abaea0bd..0b0b186a2594 100644
> --- a/cxl/json.c
> +++ b/cxl/json.c
> @@ -577,6 +577,7 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
>  	const char *devname = cxl_memdev_get_devname(memdev);
>  	struct json_object *jdev, *jobj;
>  	unsigned long long serial, size;
> +	const char *fw_version;
>  	int numa_node;
>  	int qos_class;
>  
> @@ -646,6 +647,13 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
>  	if (jobj)
>  		json_object_object_add(jdev, "host", jobj);
>  
> +	fw_version = cxl_memdev_get_firmware_version(memdev);
> +	if (fw_version) {
> +		jobj = json_object_new_string(fw_version);
> +		if (jobj)
> +			json_object_object_add(jdev, "firmware_version", jobj);
> +	}
> +
>  	if (!cxl_memdev_is_enabled(memdev)) {
>  		jobj = json_object_new_string("disabled");
>  		if (jobj)
