Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F1726982C
	for <nvdimm@lists.linux.dev>; Wed, 22 Apr 2026 14:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776869559; cv=none; b=XYB5Ak7w2iHj4YidT+F7V89gcizNDHXa9H+fQkejf44trUiuqaNP5tXrbqtHz2yFr8SEpDnKladI4gY9JDhGR3KaOhztHPevPpLvtzAKUVZ55MAjcRoihEGZTTG7J0Hc5XURiQp6pFkqGYuvRGg8a72AcAIbTiJ7UyoCPcMoRos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776869559; c=relaxed/simple;
	bh=9POO/x0VfL63iKkVn4iXRczR0qsJ4xsTjBpObnePjPk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ciz+63KJMCmhbAKWW6vofj9TW8P/NFHlF4NSXCeO9/tHMKHsi84gWmxjYLMMj5XO6ov5YTyXxBma10XT/f/ayWGOU8vfxZjkn0Qz47Y+U3TNsDLseTZHS1E7hGqCz8CE0Ue7M9GP0SvxF8S9VDITwRXcviYwIPaR+/U1cPdn89w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CSevka53; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CSevka53"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776869557; x=1808405557;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9POO/x0VfL63iKkVn4iXRczR0qsJ4xsTjBpObnePjPk=;
  b=CSevka53QNxIG4wx+OzFzqMenBM36PBJ58jyCci5sbyd1yvfsQIo5uNV
   pqcaY35sriCNWHBsiCiWFzOon5Wh984AqorTZg42cgrYCuwIt7kwB5cvz
   JQ4teOtHCW5ha8WD0WzfeVY7hdZLAU3s2yiW2S47yTFbSy49muCw/sRXq
   ypBYR5lw/bxZ8rxFF0mWUvdjaIXBxFbze3Bjc2xCZ5hxYrD37X2ba6uc/
   Asm2uhl1k61sJ9oT+d8aEEjNz79zRuKKsFx2V8LJluUTHP/QMRG8+L58E
   a9NHaCU68jzXbDWxOls6NFF3sBbLmA2vBIuLBrdKdn440XsRnAqZRp+82
   Q==;
X-CSE-ConnectionGUID: uXPOSQ9HTxi6UQB956jdhA==
X-CSE-MsgGUID: gWb45EXpQ4m2iFcRdNlr+Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11764"; a="81434578"
X-IronPort-AV: E=Sophos;i="6.23,193,1770624000"; 
   d="scan'208";a="81434578"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2026 07:52:36 -0700
X-CSE-ConnectionGUID: UWoPUBgrRharWIGOpcI7pw==
X-CSE-MsgGUID: ltYWA/tkQle0ObgyP26+PQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,193,1770624000"; 
   d="scan'208";a="227790161"
Received: from dwoodwor-mobl2.amr.corp.intel.com (HELO [10.125.111.207]) ([10.125.111.207])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2026 07:52:35 -0700
Message-ID: <3295ea6a-f177-4a34-bdf6-6a4cf7731972@intel.com>
Date: Wed, 22 Apr 2026 07:52:34 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] cxl/dax: assign target node to cxl memdev during dax
 region probe
To: liuqiqi@kylinos.cn, Dan Williams <djbw@kernel.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260422060353.200821-1-liuqiqi@kylinos.cn>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260422060353.200821-1-liuqiqi@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/21/26 11:03 PM, liuqiqi@kylinos.cn wrote:
> From: liuqiqi <liuqiqi@kylinos.cn>
> 
> When a cxl_dax_region is probed, set the numa_node of associated
> cxl_memdev devices to match the target node derived from the region's
> address range.
> The cxl_dax_region_probe function computes the correct target node (nid)
> via phys_to_target_node() but does not propagate this information to
> the underlying cxl_memdev devices. This can cause memory allocations
> to use an incorrect NUMA node.
> 
> Environment: node0/node1 = DRAM, node2 = CXL memory.
> Before this fix:
>   # cat /sys/bus/cxl/devices/mem0/numa_node
>   1
> After this fix:
>   # cat /sys/bus/cxl/devices/mem0/numa_node
>   2
> 
> Signed-off-by: liuqiqi <liuqiqi@kylinos.cn>

Thank you for the patch but NAK. The memdev numa node reflects the same numa node that is set for the parent 'struct pci_dev'. It's where the physical location of the device slot is NUMA wise. It may not be the same NUMA node compare to the region where it is based on the host physical address of the region.

DJ

> ---
>  drivers/dax/cxl.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
> index 3ab39b77843d..a62af46ec31e 100644
> --- a/drivers/dax/cxl.c
> +++ b/drivers/dax/cxl.c
> @@ -4,8 +4,27 @@
>  #include <linux/dax.h>
>  
>  #include "../cxl/cxl.h"
> +#include "../cxl/cxlmem.h"
>  #include "bus.h"
>  
> +static void cxl_dax_set_numa_node(struct cxl_region *cxlr, int nid)
> +{
> +	struct cxl_region_params *p;
> +	struct cxl_endpoint_decoder *cxled;
> +	struct cxl_memdev *cxlmd;
> +	int i;
> +
> +	p = &cxlr->params;
> +	for (i = 0; i < p->nr_targets; i++) {
> +		cxled = p->targets[i];
> +		if (!cxled)
> +			continue;
> +
> +		cxlmd = cxled_to_memdev(cxled);
> +		set_dev_node(&cxlmd->dev, nid);
> +	}
> +}
> +
>  static int cxl_dax_region_probe(struct device *dev)
>  {
>  	struct cxl_dax_region *cxlr_dax = to_cxl_dax_region(dev);
> @@ -28,6 +47,7 @@ static int cxl_dax_region_probe(struct device *dev)
>  		.size = range_len(&cxlr_dax->hpa_range),
>  		.memmap_on_memory = true,
>  	};
> +	cxl_dax_set_numa_node(cxlr, nid);
>  
>  	return PTR_ERR_OR_ZERO(devm_create_dev_dax(&data));
>  }

