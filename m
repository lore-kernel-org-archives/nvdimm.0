Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F692248A4
	for <nvdimm@lists.linux.dev>; Wed, 24 Sep 2025 18:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758738234; cv=none; b=GuzzWdGxlwMz327zn0d1WE7OxuaDJXHqj7ieVsp6ekEiMPLUFGwzWIG6OIcfMMTAPCak+UgC2khL13ptpKF5dtY4nzoxQPMwSp1BCnLg6U16mBuAM5dvqZbTicb/uoB2a0J1OZE7YdT3vF80pD1fLi+owBchQr00KTpcmHIfBwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758738234; c=relaxed/simple;
	bh=oNVDqanX5WdUO+OP2LCxi19ptR9qwxjEMdMa02OPxcA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G9EzoE4cy5rRziRE7mkky2mj5HKxWL7Vo/7Ye9hwZPmJF6lObsiGBWbxyVaZEXftLpdz2Xbi1GoPGS4dAMG1S+bpOMktnhsdINJsmRDiE+IFWAf0YlGBf24Z3NWl9e4TFcBhp3KYh/dhQeocPf+ZH6JH94KfdUAa2dlI6+UDgtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kL0Q3C1P; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kL0Q3C1P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758738234; x=1790274234;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=oNVDqanX5WdUO+OP2LCxi19ptR9qwxjEMdMa02OPxcA=;
  b=kL0Q3C1Pz6xLgLlCrVUF1vi8WiMC7OsxYx03TPFjoR5TTXLN2r/KlUnD
   krmM4rg4BtFXfPUmFiuanPjJSCfQovt/pJSoHe6L3Ynq7pb9sPGbedKhP
   7U9eBQhu8Lv/h3fnDoImHk3o6IiJCY3+uL/BZAD9bXQv41lc812A7Jd41
   u5KYkScTH4IoNMnBq/iAX8Qn4NrwXFhO748BzLkZORZLk2ga4QM9LUvLO
   /lFZmed9EkrZ5imPsuGG6mnEdKm0gvL0jfTW3SdPIrfNyteIkP6AFl10k
   tJH2KQtK44cwUxYqMnUQiREMILtdYh9cig3ykKUtCb4O/J9uc89rEx+Bm
   w==;
X-CSE-ConnectionGUID: I4LrPXNBSvK8qBSJYsTiKg==
X-CSE-MsgGUID: 6MPzmdg3S8qEx5zbp2IPmA==
X-IronPort-AV: E=McAfee;i="6800,10657,11563"; a="72470096"
X-IronPort-AV: E=Sophos;i="6.18,291,1751266800"; 
   d="scan'208";a="72470096"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 11:23:53 -0700
X-CSE-ConnectionGUID: HWYp6wAmScmPXdUk4orb9w==
X-CSE-MsgGUID: 5g5gUoHJS0iFDjVulBGY2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,291,1751266800"; 
   d="scan'208";a="176396186"
Received: from gabaabhi-mobl2.amr.corp.intel.com (HELO [10.125.108.218]) ([10.125.108.218])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 11:23:52 -0700
Message-ID: <0bcc237d-08ba-4909-8ad2-748570cbc1db@intel.com>
Date: Wed, 24 Sep 2025 11:23:51 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 16/20] cxl/mem: Preserve cxl root decoder during mem
 probe
To: Neeraj Kumar <s.neeraj@samsung.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
 cpgs@samsung.com
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
 <CGME20250917134203epcas5p3819aee1deecdeaed95bd92d19d3b1910@epcas5p3.samsung.com>
 <20250917134116.1623730-17-s.neeraj@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20250917134116.1623730-17-s.neeraj@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/17/25 6:41 AM, Neeraj Kumar wrote:
> Saved root decoder info is required for cxl region persistency

Should squash this patch into the previous patch. It's small enough that the usage and the implementation can be in the same patch.

> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
> ---
>  drivers/cxl/cxlmem.h | 1 +
>  drivers/cxl/mem.c    | 2 ++
>  2 files changed, 3 insertions(+)
> 
> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index 434031a0c1f7..25cb115b72bd 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h
> @@ -59,6 +59,7 @@ struct cxl_memdev {
>  	struct cxl_nvdimm_bridge *cxl_nvb;
>  	struct cxl_nvdimm *cxl_nvd;
>  	struct cxl_port *endpoint;
> +	struct cxl_root_decoder *cxlrd;
>  	int id;
>  	int depth;
>  	u8 scrub_cycle;
> diff --git a/drivers/cxl/mem.c b/drivers/cxl/mem.c
> index 54501616ff09..1a0da7253a24 100644
> --- a/drivers/cxl/mem.c
> +++ b/drivers/cxl/mem.c
> @@ -152,6 +152,8 @@ static int cxl_mem_probe(struct device *dev)
>  		return -ENXIO;
>  	}
>  
> +	cxlmd->cxlrd = cxl_find_root_decoder_by_port(parent_port);
> +
>  	if (dport->rch)
>  		endpoint_parent = parent_port->uport_dev;
>  	else

