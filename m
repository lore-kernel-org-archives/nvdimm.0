Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371283876B3;
	Thu,  9 Jul 2026 18:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783621369; cv=none; b=KWA9QOZs3CWGO1QyTJ/ECIDe3XMUVwz92WwrFk1JGOMzXCQLl/WkD4ul01q+Uszr9rfSVSbzyxfrOagqOK7aD8dchGO3nbL13MOr8QY8YsidoQGBPDF3t3Hyd2g0cNGFRYZWLFN0GEOv5GHxtZyoax5evot6xtOoMQfp/KuKZ00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783621369; c=relaxed/simple;
	bh=J2V7pKlJhKQawZoorNAwgpGNERi+fNljDDAyDSdjiqQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ngdX5l6Jm8JDBO9paJ03OwI2mSKNS7cDj8BbpNRmJ64V3TFE97M6IGY88hDIpQDDoXwAjd5FqI4Sl+JyOCnAjBz2MWk929lfqDKquWapPMt4yKJrE0eR2BMQF09KvHkKaS6F/WmVNboElevX5Bpf0M5vKftNbrfY8JGxGE13hzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WU06rnR7; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WU06rnR7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783621368; x=1815157368;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=J2V7pKlJhKQawZoorNAwgpGNERi+fNljDDAyDSdjiqQ=;
  b=WU06rnR7AQqxljZONPF7niL+SSfH5NDY/1P17Sdc3xwuGS/eFV4AUaOI
   zXrSmvq6pQkY9p4sHW0OkItUr/pUUMUjEnEyGAcc7WSr7XMP90tOff/BZ
   1V/MxQ/lA8busLvfTHyuHmvYxP/c1hZrrZTBwh3dUk9mx53jLMpdjlocw
   s503UM+FhMZlpXRmBUCEvpVNj4h6VDPuwTPcQ4Kukvt87pL4DO03kMq0w
   LDxJ4ctB7+S3KkBNxoaCX+augyn9uA99ZsxoF5GXqh+0whZRX/770O23I
   fgWCqJZyRXHPxx2WrmLGhYWikyXDOOv+JtNW/7eODGGghZ3F7cXp23ivT
   w==;
X-CSE-ConnectionGUID: Q0uMJvfUSqOiVHgf22fgeQ==
X-CSE-MsgGUID: cRz6NJm9TsOp/gY5/chy1w==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="88231508"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="88231508"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 11:22:47 -0700
X-CSE-ConnectionGUID: FjvWRgBjQ9WWQi8JEzfF4g==
X-CSE-MsgGUID: ovSS3j6bR8axoTyoJ0LHhg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="256578857"
Received: from bradocaj-mobl.ger.corp.intel.com (HELO [10.125.111.142]) ([10.125.111.142])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 11:22:45 -0700
Message-ID: <fc78da27-d642-460c-99f1-35b2fdf11913@intel.com>
Date: Thu, 9 Jul 2026 11:22:43 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 03/10] mm/memory_hotplug: pass online_type to
 online_memory_block() via arg
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev,
 linux-kselftest@vger.kernel.org, kernel-team@meta.com, david@kernel.org,
 osalvador@suse.de, gregkh@linuxfoundation.org, rafael@kernel.org,
 dakr@kernel.org, djbw@kernel.org, vishal.l.verma@intel.com,
 alison.schofield@intel.com, akpm@linux-foundation.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org, iweiny@kernel.org,
 Smita.KoralahalliChannabasappa@amd.com, apopple@nvidia.com,
 Pankaj Gupta <pankaj.gupta@amd.com>
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-4-gourry@gourry.net>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260630211842.2252800-4-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/30/26 2:18 PM, Gregory Price wrote:
> Modify online_memory_block() to accept the online type through its arg
> parameter rather than calling mhp_get_default_online_type() internally.
> 
> This prepares for allowing callers to specify explicit online types.
> 
> Update the caller in add_memory_resource() to pass the default online
> type via a local variable.
> 
> No functional change.
> 
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
> Signed-off-by: Gregory Price <gourry@gourry.net>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  mm/memory_hotplug.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 7ac19fab2263..6833208cc17c 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1337,7 +1337,9 @@ static int check_hotplug_memory_range(u64 start, u64 size)
>  
>  static int online_memory_block(struct memory_block *mem, void *arg)
>  {
> -	mem->online_type = mhp_get_default_online_type();
> +	enum mmop *online_type = arg;
> +
> +	mem->online_type = *online_type;
>  	return device_online(&mem->dev);
>  }
>  
> @@ -1494,6 +1496,7 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
>  int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
>  {
>  	struct mhp_params params = { .pgprot = pgprot_mhp(PAGE_KERNEL) };
> +	enum mmop online_type = mhp_get_default_online_type();
>  	enum memblock_flags memblock_flags = MEMBLOCK_NONE;
>  	struct memory_group *group = NULL;
>  	u64 start, size;
> @@ -1582,7 +1585,8 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
>  
>  	/* online pages if requested */
>  	if (mhp_get_default_online_type() != MMOP_OFFLINE)
> -		walk_memory_blocks(start, size, NULL, online_memory_block);
> +		walk_memory_blocks(start, size, &online_type,
> +				   online_memory_block);
>  
>  	return ret;
>  error:

