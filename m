Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2DB02E8B77
	for <nvdimm@lists.linux.dev>; Tue,  2 Dec 2025 23:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764718350; cv=none; b=DV0s9OMdhi4HT7PMcM2hAtYMQMdp4U7hFghBBPeDTxXUjaH7WURFIQPhkBk2J8Mf0WO5nW0U8tfjEQThkxuWxsi1hxBSQbN/zGM9VCIiyWPQ3mRCBZ0ewM5yPBtx9Y05V6busM37o+nwLKHyBghLi2ncdsU9zm09/ZAIXKw9G0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764718350; c=relaxed/simple;
	bh=FgR+dGAXoqq8Uln8w08gsGEUZzntgHCN6ndnerHSwBQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CYHnZwg9Kn+s6aZL8VIdzhziK/pzePQySjrCXBI2KHs/zOUcSU9S+vEGo2LxKuIH4E1ZBhVrLnwQ7KKehKd/+Uh9MT4nM0SjVXzZTdq1qs+cbMidh/oryHRpgF5MJAHYHUwEUNHhB0oo9NuyPJzdwaYo8JOfiuv/ldHuKKdzJ5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YkuQUBWJ; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YkuQUBWJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764718348; x=1796254348;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=FgR+dGAXoqq8Uln8w08gsGEUZzntgHCN6ndnerHSwBQ=;
  b=YkuQUBWJCy9LEV1LWkohXlVQbnkpoaBawpropZapsVDkCBc0hQcgRMQ+
   O6YZSWpDW8rXUKW9l4FOio2X49xGsxb1W/8apF2nE4bnJWTVl1gzYv0sb
   96U2tGRdKZjMqOAgwMHFxBx91n5pRRHs3fuDesJNGtl9DubaDnRJafFvP
   88RHwQISQ7NO5NlEaJ9Wjyzh+aHP2jnpktLJNoyHNiZ9vxymd1RXTwGP+
   E+m891TwPzlevQqmVnXTMcqFo9kWPjPM99vj8pQYWyuHrBs/m+/QPdGb2
   4XkharE4MLBhU1tjkcj0PfxtkNvLXmcEJBj0SDstaVMvYsJf013XadOm3
   g==;
X-CSE-ConnectionGUID: 0+w2p/MvRySlmJDCO1WIvw==
X-CSE-MsgGUID: thSLsJFNS2WURoxfmfeKsg==
X-IronPort-AV: E=McAfee;i="6800,10657,11631"; a="89356371"
X-IronPort-AV: E=Sophos;i="6.20,244,1758610800"; 
   d="scan'208";a="89356371"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 15:32:28 -0800
X-CSE-ConnectionGUID: 7Wd1OQ3LSTOYg334Vj5lKw==
X-CSE-MsgGUID: PE3hF536SX6iI9l3weR3yQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,244,1758610800"; 
   d="scan'208";a="195304298"
Received: from ldmartin-desk2.corp.intel.com (HELO [10.125.111.202]) ([10.125.111.202])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 15:32:25 -0800
Message-ID: <f35d86cd-03f8-4e0b-8373-8d8e749aaa8e@intel.com>
Date: Tue, 2 Dec 2025 16:32:24 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/9] dax/hmem: Gate Soft Reserved deferral on
 DEV_DAX_CXL
To: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>,
 linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
 linux-pm@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>,
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
 Greg KH <gregkh@linuxfoundation.org>,
 Nathan Fontenot <nathan.fontenot@amd.com>,
 Terry Bowman <terry.bowman@amd.com>, Robert Richter <rrichter@amd.com>,
 Benjamin Cheatham <benjamin.cheatham@amd.com>,
 Zhijian Li <lizhijian@fujitsu.com>, Borislav Petkov <bp@alien8.de>,
 Ard Biesheuvel <ardb@kernel.org>
References: <20251120031925.87762-1-Smita.KoralahalliChannabasappa@amd.com>
 <20251120031925.87762-4-Smita.KoralahalliChannabasappa@amd.com>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20251120031925.87762-4-Smita.KoralahalliChannabasappa@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/19/25 8:19 PM, Smita Koralahalli wrote:
> From: Dan Williams <dan.j.williams@intel.com>
> 
> Replace IS_ENABLED(CONFIG_CXL_REGION) with IS_ENABLED(CONFIG_DEV_DAX_CXL)
> so that HMEM only defers Soft Reserved ranges when CXL DAX support is
> enabled. This makes the coordination between HMEM and the CXL stack more
> precise and prevents deferral in unrelated CXL configurations.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>> ---
>  drivers/dax/hmem/hmem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/dax/hmem/hmem.c b/drivers/dax/hmem/hmem.c
> index 02e79c7adf75..c2c110b194e5 100644
> --- a/drivers/dax/hmem/hmem.c
> +++ b/drivers/dax/hmem/hmem.c
> @@ -66,7 +66,7 @@ static int hmem_register_device(struct device *host, int target_nid,
>  	long id;
>  	int rc;
>  
> -	if (IS_ENABLED(CONFIG_CXL_REGION) &&
> +	if (IS_ENABLED(CONFIG_DEV_DAX_CXL) &&
>  	    region_intersects(res->start, resource_size(res), IORESOURCE_MEM,
>  			      IORES_DESC_CXL) != REGION_DISJOINT) {
>  		dev_dbg(host, "deferring range to CXL: %pr\n", res);

