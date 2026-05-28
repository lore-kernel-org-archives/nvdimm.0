Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC8B2F7EF5
	for <nvdimm@lists.linux.dev>; Thu, 28 May 2026 15:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779982637; cv=none; b=o86UJdXbyUead51MJ+0dDm0uICnmQ4Yk9OKtgiTVUEtQEbSAR1jMsoV+VgZndSSlyw8+vN3pyp2EmHKqhS4DFXmIkh7oFG0AXnMjxPvbWZKisS9fOVqJgTDi6y4UYiy77ABYE3FsX3p6jZ5YsnXfR7Kv5BcX62+zvbNbrkhq4ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779982637; c=relaxed/simple;
	bh=TEn+txG6ta+6hE/Z9Pzr+UAtGT6r145WOb+oTH7pZyQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NQn76wl0Wag0YsWt9mQMJ2A1HlKrneDbFciA9lE0Jwd8kDC+XVDq2DwkjbTe8LWamoBw0GYFygwW5XDwLHontPYzLXXhDPBrqPAoKMEBMVF177Y4G3kFs36ynYTedusYbLdGradJGTTg+UNc9bufgC1hZ6sf1zI/Aog/dibKYfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R6I2TXeR; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R6I2TXeR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779982636; x=1811518636;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=TEn+txG6ta+6hE/Z9Pzr+UAtGT6r145WOb+oTH7pZyQ=;
  b=R6I2TXeR9gqcbgC2+ctdNzsedyoOEE1tROhaSnege3VTzJmaj7K6rmEv
   7iUkr2+tJYO+r8uz1vZ1dQx03bMoVN7ZDOe4BsvCGD9sQcsRefdAsqWDR
   9cnSRvnPQ1NPPHey+gMwVv8RdRMD5DezUn+K/Arl0K04hsh9hXDzifm7c
   tdHSWK0ex4wnuYSIZ4lVlrRcJQWuBls3ph49IJWaqVYoGB1CmrIu8TEh3
   2TeX9adiKSeGpSDIjOlhFYNTBdvJabUUmQ7qaUpUjqprH1/+X4hFwj2bF
   a7vRCU1RB3JLw6Ooc4QpVpNLdcoOr6kREOWfKk2KhgCXF7lT9IzHJhkz+
   w==;
X-CSE-ConnectionGUID: BfeajG99QLezJ4uG0hDCWA==
X-CSE-MsgGUID: zQwBQPQ6R/utnI3FJ/cL+g==
X-IronPort-AV: E=McAfee;i="6800,10657,11800"; a="80819349"
X-IronPort-AV: E=Sophos;i="6.24,173,1774335600"; 
   d="scan'208";a="80819349"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 08:37:16 -0700
X-CSE-ConnectionGUID: HIrujNteQKyG5fD0QnT/Pw==
X-CSE-MsgGUID: Thpjl90iQ4K+psZL8Y+37g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,173,1774335600"; 
   d="scan'208";a="272915069"
Received: from aduenasd-mobl5.amr.corp.intel.com (HELO [10.125.111.91]) ([10.125.111.91])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 08:37:10 -0700
Message-ID: <97fc27c6-6cda-4a78-9847-fc2aa17ce057@intel.com>
Date: Thu, 28 May 2026 08:37:08 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] dax/bus: Upgrade resource conflict message to
 dev_err() in alloc_dax_region()
To: Tomasz Wolski <tomasz.wolski@fujitsu.com>,
 smita.koralahallichannabasappa@amd.com, alison.schofield@intel.com,
 dan.j.williams@intel.com
Cc: icheng@nvidia.com, linux-cxl@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-pm@vger.kernel.org, nvdimm@lists.linux.dev, ardb@kernel.org,
 benjamin.cheatham@amd.com, jonathan.cameron@huawei.com
References: <20260528064546.23362-1-tomasz.wolski@fujitsu.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260528064546.23362-1-tomasz.wolski@fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 5/27/26 11:45 PM, Tomasz Wolski wrote:
> The dax_region resource conflict in alloc_dax_region() indicates a
> serious configuration problem — two subsystems (e.g. dax_hmem and
> dax_cxl) are attempting to register overlapping address ranges. This is
> not a transient or debug-level condition; it represents a genuine
> resource conflict that an administrator needs to be aware of.
> 
> Promote the log level from dev_dbg() to dev_err() so that the conflict
> is visible by default without requiring dynamic debug to be enabled.
> 
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Link: https://lore.kernel.org/linux-cxl/69c1a8d1c0fa9_7ee3100a1@dwillia2-mobl4.notmuch/
> Signed-off-by: Tomasz Wolski <tomasz.wolski@fujitsu.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/dax/bus.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index 68437c05e21d..cd963eeeef7b 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -672,7 +672,7 @@ struct dax_region *alloc_dax_region(struct device *parent, int region_id,
>  
>  	rc = request_resource(&dax_regions, &dax_region->res);
>  	if (rc) {
> -		dev_dbg(parent, "dax_region resource conflict for %pR\n",
> +		dev_err(parent, "dax_region resource conflict for %pR\n",
>  			&dax_region->res);
>  		goto err_res;
>  	}

