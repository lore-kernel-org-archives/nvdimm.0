Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA99B3C9433
	for <nvdimm@lists.linux.dev>; Mon, 23 Mar 2026 17:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774287107; cv=none; b=DJdnWSVyfElj7J35Vkab9nr5u+2F01lvJ/3ObG4Pp0BZU8JOCmxI3YLy/jcFfJNx+H6aZOz8k7h02mthxrmYpE0zgSCCpc59JpealV8e8wQ3BnVk3/5xjEoaYI+LcQjjpPtfI/mylAGIIwtXa1x85IQOqaizvmkbvbt98vk5vH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774287107; c=relaxed/simple;
	bh=go7NgkHXgfn9/qJxOGRIORTyJcHQqG1yRjvleSKosIo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AMiXoHVhcLWxk+w3Al8VXFnwwNXGTJ3T/9Qv0WlotodG9gk4hXSmLfwUESSrD8gNTnpDJoGgTZBHZjHckxHssT8dUtspMpi0gSDZzpAG5kXTAvOb74+EFAq3KIW0AsZ5DsCZcNnymGRKVyMw0N/Oidlc8mABd3uobhL7Y1eivSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SDDC3anb; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SDDC3anb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774287106; x=1805823106;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=go7NgkHXgfn9/qJxOGRIORTyJcHQqG1yRjvleSKosIo=;
  b=SDDC3anbImPKshdbwGGD5NNkb7Qd4G9x2GtaqAOhz5wXVngN1i4ltBnE
   VtYmQQbX2u+27pZqatperrcuCVQP8y9YXMDMG3S299nW41v3Wq7RoEALk
   LP4Ttgquura1UmVeqPDzUxxM9IYljuJeYf4gl4MGB4IkMD2dSZZ/P5XWA
   f4hfMjPK8YC8UH5yWAFBEQEfdlD2DsGv1Ndl1HiFAkqPFArLyENjIWoTo
   611JqTV5ozGPU5s74IQYlPs0nmhbk9zwUIuA4aNYiRayasCzpVHQgRZhQ
   Kd5PcQpM4uqNdz8C0D2I/VWC3cDLQlvCAcdtCwd3043IcMOHJQv9wQTLU
   g==;
X-CSE-ConnectionGUID: f4jecf2qQ96lliQRg7IUjg==
X-CSE-MsgGUID: bTl4ZrAZR7azIvrUqoNiyA==
X-IronPort-AV: E=McAfee;i="6800,10657,11738"; a="92865793"
X-IronPort-AV: E=Sophos;i="6.23,137,1770624000"; 
   d="scan'208";a="92865793"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2026 10:31:45 -0700
X-CSE-ConnectionGUID: +feu5u54RyWgIHocjrb6Ew==
X-CSE-MsgGUID: LV7OoE3hR/294sFk1B+y4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,137,1770624000"; 
   d="scan'208";a="224064255"
Received: from jdoman-mobl3.amr.corp.intel.com (HELO [10.125.109.216]) ([10.125.109.216])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2026 10:31:42 -0700
Message-ID: <ac469798-0617-4cac-8766-f76302f5f7f7@intel.com>
Date: Mon, 23 Mar 2026 10:31:41 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 6/9] dax: Track all dax_region allocations under a
 global resource tree
To: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>,
 linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
 linux-pm@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
 Alison Schofield <alison.schofield@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
 Dan Williams <dan.j.williams@intel.com>,
 Jonathan Cameron <jonathan.cameron@huawei.com>,
 Yazen Ghannam <yazen.ghannam@amd.com>, Davidlohr Bueso <dave@stgolabs.net>,
 Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 "Rafael J . Wysocki" <rafael@kernel.org>, Len Brown <len.brown@intel.com>,
 Pavel Machek <pavel@kernel.org>, Li Ming <ming.li@zohomail.com>,
 Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
 Ying Huang <huang.ying.caritas@gmail.com>,
 Yao Xingtao <yaoxt.fnst@fujitsu.com>, Peter Zijlstra <peterz@infradead.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Nathan Fontenot <nathan.fontenot@amd.com>,
 Terry Bowman <terry.bowman@amd.com>, Robert Richter <rrichter@amd.com>,
 Benjamin Cheatham <benjamin.cheatham@amd.com>,
 Zhijian Li <lizhijian@fujitsu.com>, Borislav Petkov <bp@alien8.de>,
 Tomasz Wolski <tomasz.wolski@fujitsu.com>
References: <20260322195343.206900-1-Smita.KoralahalliChannabasappa@amd.com>
 <20260322195343.206900-7-Smita.KoralahalliChannabasappa@amd.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260322195343.206900-7-Smita.KoralahalliChannabasappa@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/22/26 12:53 PM, Smita Koralahalli wrote:
> Introduce a global "DAX Regions" resource root and register each
> dax_region->res under it via request_resource(). Release the resource on
> dax_region teardown.
> 
> By enforcing a single global namespace for dax_region allocations, this
> ensures only one of dax_hmem or dax_cxl can successfully register a
> dax_region for a given range.
> 
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/dax/bus.c | 20 +++++++++++++++++---
>  1 file changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index 299134c9b294..68437c05e21d 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -10,6 +10,7 @@
>  #include "dax-private.h"
>  #include "bus.h"
>  
> +static struct resource dax_regions = DEFINE_RES_MEM_NAMED(0, -1, "DAX Regions");
>  static DEFINE_MUTEX(dax_bus_lock);
>  
>  /*
> @@ -627,6 +628,7 @@ static void dax_region_unregister(void *region)
>  
>  	sysfs_remove_groups(&dax_region->dev->kobj,
>  			dax_region_attribute_groups);
> +	release_resource(&dax_region->res);
>  	dax_region_put(dax_region);
>  }
>  
> @@ -635,6 +637,7 @@ struct dax_region *alloc_dax_region(struct device *parent, int region_id,
>  		unsigned long flags)
>  {
>  	struct dax_region *dax_region;
> +	int rc;
>  
>  	/*
>  	 * The DAX core assumes that it can store its private data in
> @@ -667,14 +670,25 @@ struct dax_region *alloc_dax_region(struct device *parent, int region_id,
>  		.flags = IORESOURCE_MEM | flags,
>  	};
>  
> -	if (sysfs_create_groups(&parent->kobj, dax_region_attribute_groups)) {
> -		dax_region_put(dax_region);
> -		return NULL;
> +	rc = request_resource(&dax_regions, &dax_region->res);
> +	if (rc) {
> +		dev_dbg(parent, "dax_region resource conflict for %pR\n",
> +			&dax_region->res);
> +		goto err_res;
>  	}
>  
> +	if (sysfs_create_groups(&parent->kobj, dax_region_attribute_groups))
> +		goto err_sysfs;
> +
>  	if (devm_add_action_or_reset(parent, dax_region_unregister, dax_region))
>  		return NULL;
>  	return dax_region;
> +
> +err_sysfs:
> +	release_resource(&dax_region->res);
> +err_res:
> +	dax_region_put(dax_region);
> +	return NULL;
>  }
>  EXPORT_SYMBOL_GPL(alloc_dax_region);
>  

