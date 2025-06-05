Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F4F6274FF5
	for <nvdimm@lists.linux.dev>; Thu,  5 Jun 2025 16:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749142451; cv=none; b=LVVdrTxAc7n+vVq85FbeCxOBfoDyTOaPLaNZbqrbTqnym7D1dwcUjWFI+1FCFg8l5E6z830lSeh/UF57PMcjpOHiEVkY188gG2ULVGcjGSF9DgfvO8l5LDcUPSnmwcWJ/JH8e3Q7+4vOiEfMGBNjOJPRp19GgrNPjiLBfNwADi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749142451; c=relaxed/simple;
	bh=0IMuXTNwS6W3pSr/5C3mr9qYeBQuOHsNvidzOnnNqA8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GCM8tdRYx9Z6VM/Bdjwz3Tu38wMIbEQ0frzl/x0OJ2a31MXabX98rJi/hIXkuRrLzVWHJ92dSERnqreOp+GBsPKEfVKpEgoLEYBTyFuLrnEOZ398oGyXKrnzXgc++HDDYeYjAfa2jXLYELVx/q5MkRCxUcpk0kd0EOk8QpSrucw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QnpuS/fq; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QnpuS/fq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749142450; x=1780678450;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0IMuXTNwS6W3pSr/5C3mr9qYeBQuOHsNvidzOnnNqA8=;
  b=QnpuS/fqHK8WI9yexl+MHwV9w0/2t9IEM1af3mKGbD1qS0v8yvG4C8Wr
   LH8dsW37pHdLpbgyqb7NwwZz8EA4CpeHq7/3NS1qF7IcTUbZtuFr2KKCS
   WTJXMOLnMJbwB88902F7WTcO8tDBajsT8jX0lWItpZWyw4tz1TL6CyhnJ
   fOLRRCq97zSvFHKaT1+9EQ4AEukLZAwcL+EKhB1w1EyvZdV5rtnvnqUDE
   7qZNNYEEzWKRomMkptkxgSQGx7qVXHpTYQTNjFXvDr8W3mC3harpQ8gAS
   N2f0jOwxirkutjfWJBQICPiXBrWRw7ZrxtXGa5yRPXc4kmxNs3OutlLFR
   g==;
X-CSE-ConnectionGUID: 47UYr01hRkmuhIFVocwr6Q==
X-CSE-MsgGUID: ly9JhiycQjyZGVTMn6WN/Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11455"; a="61936872"
X-IronPort-AV: E=Sophos;i="6.16,212,1744095600"; 
   d="scan'208";a="61936872"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2025 09:54:09 -0700
X-CSE-ConnectionGUID: HStFr3mNQYCWhfQsX1HCuw==
X-CSE-MsgGUID: NMpdaaTCRUio8aZe4p1KDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,212,1744095600"; 
   d="scan'208";a="182761905"
Received: from dwoodwor-mobl2.amr.corp.intel.com (HELO [10.125.111.7]) ([10.125.111.7])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2025 09:54:07 -0700
Message-ID: <f4b861fe-d10e-497e-b7d3-af4af9c58cac@intel.com>
Date: Thu, 5 Jun 2025 09:54:06 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 6/7] dax/hmem: Save the DAX HMEM platform device
 pointer
To: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>,
 linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
 linux-pm@vger.kernel.org
Cc: Davidlohr Bueso <dave@stgolabs.net>,
 Jonathan Cameron <jonathan.cameron@huawei.com>,
 Alison Schofield <alison.schofield@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
 Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox
 <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 "Rafael J . Wysocki" <rafael@kernel.org>, Len Brown <len.brown@intel.com>,
 Pavel Machek <pavel@kernel.org>, Li Ming <ming.li@zohomail.com>,
 Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
 Ying Huang <huang.ying.caritas@gmail.com>,
 Yao Xingtao <yaoxt.fnst@fujitsu.com>, Peter Zijlstra <peterz@infradead.org>,
 Greg KH <gregkh@linuxfoundation.org>,
 Nathan Fontenot <nathan.fontenot@amd.com>,
 Terry Bowman <terry.bowman@amd.com>, Robert Richter <rrichter@amd.com>,
 Benjamin Cheatham <benjamin.cheatham@amd.com>,
 PradeepVineshReddy Kodamati <PradeepVineshReddy.Kodamati@amd.com>,
 Zhijian Li <lizhijian@fujitsu.com>
References: <20250603221949.53272-1-Smita.KoralahalliChannabasappa@amd.com>
 <20250603221949.53272-7-Smita.KoralahalliChannabasappa@amd.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20250603221949.53272-7-Smita.KoralahalliChannabasappa@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/3/25 3:19 PM, Smita Koralahalli wrote:
> From: Nathan Fontenot <nathan.fontenot@amd.com>
> 
> To enable registration of HMEM devices for SOFT RESERVED regions after
> the DAX HMEM device is initialized, this patch saves a reference to the
> DAX HMEM platform device.
> 
> This saved pointer will be used in a follow-up patch to allow late
> registration of SOFT RESERVED memory ranges. It also enables
> simplification of the walk_hmem_resources() by removing the need to
> pass a struct device argument.
> 
> There are no functional changes.
> 
> Co-developed-by: Nathan Fontenot <Nathan.Fontenot@amd.com>
> Signed-off-by: Nathan Fontenot <Nathan.Fontenot@amd.com>
> Co-developed-by: Terry Bowman <terry.bowman@amd.com>
> Signed-off-by: Terry Bowman <terry.bowman@amd.com>
> Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
> ---
>  drivers/dax/hmem/device.c | 4 ++--
>  drivers/dax/hmem/hmem.c   | 9 ++++++---
>  include/linux/dax.h       | 5 ++---
>  3 files changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/dax/hmem/device.c b/drivers/dax/hmem/device.c
> index f9e1a76a04a9..59ad44761191 100644
> --- a/drivers/dax/hmem/device.c
> +++ b/drivers/dax/hmem/device.c
> @@ -17,14 +17,14 @@ static struct resource hmem_active = {
>  	.flags = IORESOURCE_MEM,
>  };
>  
> -int walk_hmem_resources(struct device *host, walk_hmem_fn fn)
> +int walk_hmem_resources(walk_hmem_fn fn)
>  {
>  	struct resource *res;
>  	int rc = 0;
>  
>  	mutex_lock(&hmem_resource_lock);
>  	for (res = hmem_active.child; res; res = res->sibling) {
> -		rc = fn(host, (int) res->desc, res);
> +		rc = fn((int) res->desc, res);
>  		if (rc)
>  			break;
>  	}
> diff --git a/drivers/dax/hmem/hmem.c b/drivers/dax/hmem/hmem.c
> index 5e7c53f18491..3aedef5f1be1 100644
> --- a/drivers/dax/hmem/hmem.c
> +++ b/drivers/dax/hmem/hmem.c
> @@ -9,6 +9,8 @@
>  static bool region_idle;
>  module_param_named(region_idle, region_idle, bool, 0644);
>  
> +static struct platform_device *dax_hmem_pdev;
> +
>  static int dax_hmem_probe(struct platform_device *pdev)
>  {
>  	unsigned long flags = IORESOURCE_DAX_KMEM;
> @@ -59,9 +61,9 @@ static void release_hmem(void *pdev)
>  	platform_device_unregister(pdev);
>  }
>  
> -static int hmem_register_device(struct device *host, int target_nid,
> -				const struct resource *res)
> +static int hmem_register_device(int target_nid, const struct resource *res)
>  {
> +	struct device *host = &dax_hmem_pdev->dev;
>  	struct platform_device *pdev;
>  	struct memregion_info info;
>  	long id;
> @@ -125,7 +127,8 @@ static int hmem_register_device(struct device *host, int target_nid,
>  
>  static int dax_hmem_platform_probe(struct platform_device *pdev)
>  {
> -	return walk_hmem_resources(&pdev->dev, hmem_register_device);
> +	dax_hmem_pdev = pdev;

Is there never more than 1 DAX HMEM platform device that can show up? The global pointer makes me nervous.

DJ

> +	return walk_hmem_resources(hmem_register_device);
>  }
>  
>  static struct platform_driver dax_hmem_platform_driver = {
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index dcc9fcdf14e4..a4ad3708ea35 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -305,7 +305,6 @@ static inline void hmem_register_resource(int target_nid, struct resource *r)
>  }
>  #endif
>  
> -typedef int (*walk_hmem_fn)(struct device *dev, int target_nid,
> -			    const struct resource *res);
> -int walk_hmem_resources(struct device *dev, walk_hmem_fn fn);
> +typedef int (*walk_hmem_fn)(int target_nid, const struct resource *res);
> +int walk_hmem_resources(walk_hmem_fn fn);
>  #endif

