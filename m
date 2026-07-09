Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA5F357CFD;
	Thu,  9 Jul 2026 18:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783621830; cv=none; b=IJ7RI7gBiOp0jwE4FssUTM2jV0zqrIPyEPtIprt/F69TydgDlTNVeEeVtLd8wMA7i9UNOA8iqqG5/kJ6DMsFKh9a4ZVPcfUVii4Vz8gKYC6Eht1lkSVNE43MNLukGllYa02tllaftZVZoat8AOSv0ciFb9bkNEUuvLgngMV7evc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783621830; c=relaxed/simple;
	bh=sJrITh55upt9+7i4xO8v5KWYgInW0gtqD9Qlj0C5gCY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=slY2YupNo2MLpeV1OXZL2TMVX6COScwIwdNvI2m1Ysu4+Tcw2wLPiff1X8C3/Dakjm7rDqTwLmtlC3uESwmtzm3nE7ITfOmSjYi8e8nVOs9BW2DmdJGHbhiXaFmzEdv1ZGRze8dqh0ZPEOnWbn1VX4F1hjhdBpcmAHIB9BN4f80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jOzwTZsM; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jOzwTZsM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783621827; x=1815157827;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=sJrITh55upt9+7i4xO8v5KWYgInW0gtqD9Qlj0C5gCY=;
  b=jOzwTZsMeZzDN1W64ahfbX6+rhyHQVD2ThXdLkQa9Twq/BmS+7V329qV
   JrYZeU/TEZgiSV20b+UjXeqjDP+6jL0/AaSSHLSZJa/LrLwxWqzsf+9Zy
   wp9krvGZzcgjeO5dMHLC+iB7gPnF/676Zf7RQk/VXU8RjyUrxs16Y/ru+
   kgeNDCOR3AS5pJApFVhqRrew1O0osjKnc2QBscl2bE4+S4mm8aoky6Sul
   v+4SJux9PYuJQcp/avpD+JILq20fxZMdzibNh1qcCDDt8e7i5vSua12dR
   6IdelnEG9JiokhEFffQQq0mLejc30WxIcI0mMSdwJegsps6FZMkQWgTkB
   A==;
X-CSE-ConnectionGUID: 5WsynPTkQnC2kQVWDawZFQ==
X-CSE-MsgGUID: uZK6fC/tQc2Hte0gmNOqgw==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="88232217"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="88232217"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 11:30:27 -0700
X-CSE-ConnectionGUID: CreSit38SEqhU34F5Ejwog==
X-CSE-MsgGUID: GyVfq50gT2Gw6mAARUjGdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="256580746"
Received: from bradocaj-mobl.ger.corp.intel.com (HELO [10.125.111.142]) ([10.125.111.142])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 11:30:24 -0700
Message-ID: <6cc4354f-c494-4198-b1ad-a8b538aa1a77@intel.com>
Date: Thu, 9 Jul 2026 11:30:23 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 04/10] mm/memory_hotplug: export
 mhp_get_default_online_type
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev,
 linux-kselftest@vger.kernel.org, kernel-team@meta.com, david@kernel.org,
 osalvador@suse.de, gregkh@linuxfoundation.org, rafael@kernel.org,
 dakr@kernel.org, djbw@kernel.org, vishal.l.verma@intel.com,
 alison.schofield@intel.com, akpm@linux-foundation.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org, iweiny@kernel.org,
 Smita.KoralahalliChannabasappa@amd.com, apopple@nvidia.com
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-5-gourry@gourry.net>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260630211842.2252800-5-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/30/26 2:18 PM, Gregory Price wrote:
> Drivers which may pass hotplug policy down to DAX need MMOP_ symbols
> and the mhp_get_default_online_type function for hotplug use cases.
> 
> Some drivers (cxl) co-mingle their hotplug and devdax use-cases into
> the same driver code, and chose the dax_kmem path as the default driver
> path - making it difficult to require hotplug as a predicate to building
> the overall driver (it may break other non-hotplug use-cases).
> 
> Export mhp_get_default_online_type function to allow these drivers to
> build when hotplug is disabled and still use the DAX use case.
> 
> In the built-out case we simply return MMOP_OFFLINE as it's
> non-destructive.  The internal function can never return -1 either,
> so we choose this to allow for defining the function with 'enum mmop'.
> 
> Signed-off-by: Gregory Price <gourry@gourry.net>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  include/linux/memory_hotplug.h | 2 ++
>  mm/memory_hotplug.c            | 1 +
>  2 files changed, 3 insertions(+)
> 
> diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
> index 5d4b628c4a1f..4d51fcb93a37 100644
> --- a/include/linux/memory_hotplug.h
> +++ b/include/linux/memory_hotplug.h
> @@ -317,6 +317,8 @@ extern struct zone *zone_for_pfn_range(enum mmop online_type,
>  extern int arch_create_linear_mapping(int nid, u64 start, u64 size,
>  				      struct mhp_params *params);
>  void arch_remove_linear_mapping(u64 start, u64 size);
> +#else
> +static inline enum mmop mhp_get_default_online_type(void) { return MMOP_OFFLINE; }
>  #endif /* CONFIG_MEMORY_HOTPLUG */
>  
>  #endif /* __LINUX_MEMORY_HOTPLUG_H */
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 6833208cc17c..494257054095 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -239,6 +239,7 @@ enum mmop mhp_get_default_online_type(void)
>  
>  	return mhp_default_online_type;
>  }
> +EXPORT_SYMBOL_GPL(mhp_get_default_online_type);
>  
>  void mhp_set_default_online_type(enum mmop online_type)
>  {

