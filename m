Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8AE3C5523
	for <nvdimm@lists.linux.dev>; Mon, 23 Mar 2026 17:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774285912; cv=none; b=dHzQsHA+GCJBFjgdSp6BtznM8q4bo1HS6VqI2xgRTVEZLUXNSIQqQjKUAcDj3bqWtHfWHQmzwAGqk7EErDd2lzURVdGaJG+AoTgeoKM3Y3UctKkPEl98WOn9N8fRJQO3qdvP5UcvMIqc3nhY7SN/adLh/xy3hlRfy64bwSJ+ltI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774285912; c=relaxed/simple;
	bh=WC5R3R7MjBGZGiXrO/PHhKEP3AXAJXomcLtba1rFets=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sKrUgmzoVug++d5TYV1EBjh97RuYeDdSbMVEdQZ1/npnZk11VwARoIGdo9NOman2tZS8f2GxS2xK/g4o9/6QGCLfinfYzqTN/sWSDKfEdwfaBHseYOzMLxJlbFFO5UO6Vy5+uwzpl7Ht8zwsL1qnWWX1EH79FWAXoB3IT90WtbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IsuIPKGr; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IsuIPKGr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774285910; x=1805821910;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=WC5R3R7MjBGZGiXrO/PHhKEP3AXAJXomcLtba1rFets=;
  b=IsuIPKGrZxVvNN9uHZPTKY+MH9T/VTAjsKRKwekIc5llyM1idTEsTwJk
   4u7SKWoVoBn+8hPfHDhK1SDgoryrBv2AR90UFqOD+d9mcWJPqdY1cKxDf
   aUNuxbky7c1Uez24nX44QoTEoI1wHsp6ZZiRanui+BazzevMLDIrsnhZB
   H2XPcN6IDNX7Glx6zn9HXs21wF/gcMF0JbdrpqWd3ltck2BgtL7wvFMkC
   Qn1Kv0UVVibKMPCrUyVuLKdeA9UCSIdioc+w3Ns6IOMyaZHJhRsiDdwny
   bSfApD8tGeaAFDwOgBw4hTFEE9OkR+wsKDw3av1CmkPHIHYza1iFh2QPu
   g==;
X-CSE-ConnectionGUID: jbBJ85vSS2GJJ+3nTwYDdw==
X-CSE-MsgGUID: 4S0AI1BHRZC5kp5gn0FBLA==
X-IronPort-AV: E=McAfee;i="6800,10657,11738"; a="62849094"
X-IronPort-AV: E=Sophos;i="6.23,137,1770624000"; 
   d="scan'208";a="62849094"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2026 10:11:50 -0700
X-CSE-ConnectionGUID: oVZ9NSwhQROtpb73j9ALIw==
X-CSE-MsgGUID: vAbpOXkMSseD0QwR/c7PBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,137,1770624000"; 
   d="scan'208";a="224097386"
Received: from jdoman-mobl3.amr.corp.intel.com (HELO [10.125.109.216]) ([10.125.109.216])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2026 10:11:48 -0700
Message-ID: <1f0c192d-1dae-496e-8cdd-4854d685343f@intel.com>
Date: Mon, 23 Mar 2026 10:11:47 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 1/9] dax/bus: Use dax_region_put() in
 alloc_dax_region() error path
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
 <20260322195343.206900-2-Smita.KoralahalliChannabasappa@amd.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260322195343.206900-2-Smita.KoralahalliChannabasappa@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/22/26 12:53 PM, Smita Koralahalli wrote:
> alloc_dax_region() calls kref_init() on the dax_region early in the
> function, but the error path for sysfs_create_groups() failure uses
> kfree() directly to free the dax_region. This bypasses the kref lifecycle.
> 
> Use dax_region_put() instead to handle kref lifecycle correctly.
> 
> Suggested-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/dax/bus.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index c94c09622516..299134c9b294 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -668,7 +668,7 @@ struct dax_region *alloc_dax_region(struct device *parent, int region_id,
>  	};
>  
>  	if (sysfs_create_groups(&parent->kobj, dax_region_attribute_groups)) {
> -		kfree(dax_region);
> +		dax_region_put(dax_region);
>  		return NULL;
>  	}
>  

