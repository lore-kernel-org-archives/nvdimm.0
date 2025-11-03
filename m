Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0DA12FBE0A
	for <nvdimm@lists.linux.dev>; Mon,  3 Nov 2025 15:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762183932; cv=none; b=WrLLh/iIZnzEfdnWm7nrsDjcH/Hc3ylzuSwm/V3DNRPGGlWxo7OLaDFV4VePbhtLKCPvgESRrgeljmVi5WFxh4r0NrxNlVpdICDjIMWLNpxyGIIbnSPaQHDNcJ7k+nOtK8iydynmpw/Y5g7TX6XAaPz/Ue3VtsVRlPfgEk/I2Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762183932; c=relaxed/simple;
	bh=CLjvPQOnyGhackzsm+kh8BLXHz1of9cY4P8NRMpf1J8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tnNvETWeQ9nwcbukZjJfg/9595GVn1RgE1erJoVafM6WVEdpHrrHPaKGyCzot6ox+nGM7ZpeCHOfQe1wQ/GiBCvjewHSMMhwSqZ3FZVfGwFxl62lzB22KIyU4/YMIqxac6Qm8DtWOJw1/CrXYtWzJizf3KNvSk0VlEgqKgl/UzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GHtM8ecX; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GHtM8ecX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762183931; x=1793719931;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CLjvPQOnyGhackzsm+kh8BLXHz1of9cY4P8NRMpf1J8=;
  b=GHtM8ecXAO0WXBIHRghPWDtvVIqlMiFAKEhtz4wJ3WH4E80M8cGDkNpJ
   dZRYHZp0kXk9UKV9Un2HlX9f15DxNPHXtX06GvbYeW7qthw/cpKxZTW5i
   1MMYxeWnVQtwRSlHE9EiNO/LrsV1JrYzUMEQF1ROKSYe86EtOc26Axe/G
   ftOqYnFzEFnCNxqXSCxIBC6XSvLm20Q1b9S+xnO8u8IlqIHo3KpI3fHrq
   uYzvPeWIAqoiS6xv3MUm25Nez3gfRvjKd2Sejq2VZJ5QEIlMtUzBEK7Om
   HAV5dfZy8lSPKzNWsH7DoEJEcoU0QZQRLFtEEUMi+YlnP5DzZpOPPNnZb
   w==;
X-CSE-ConnectionGUID: AmhuWGMUQsO6eYxt2Zdq4g==
X-CSE-MsgGUID: WIVaBHgOQLqkHd+bpOs+qQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="74864166"
X-IronPort-AV: E=Sophos;i="6.19,276,1754982000"; 
   d="scan'208";a="74864166"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 07:32:10 -0800
X-CSE-ConnectionGUID: 8ZxUf6WtTUaf5Xr0cVyDyg==
X-CSE-MsgGUID: 59IB1wMIR5mNfT/itbLbIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,276,1754982000"; 
   d="scan'208";a="186569918"
Received: from dwesterg-mobl1.amr.corp.intel.com (HELO [10.125.110.133]) ([10.125.110.133])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 07:32:10 -0800
Message-ID: <01e17cd1-a48d-4bf5-8ec7-4c858d3d0f71@intel.com>
Date: Mon, 3 Nov 2025 08:32:08 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] tools/testing/nvdimm: Use per-DIMM device handle
To: Alison Schofield <alison.schofield@intel.com>,
 Ira Weiny <ira.weiny@intel.com>, Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>
Cc: nvdimm@lists.linux.dev, stable@vger.kernel.org
References: <20251031234227.1303113-1-alison.schofield@intel.com>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20251031234227.1303113-1-alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/31/25 4:42 PM, Alison Schofield wrote:
> KASAN reports a global-out-of-bounds access when running these nfit
> tests: clear.sh, pmem-errors.sh, pfn-meta-errors.sh, btt-errors.sh,
> daxdev-errors.sh, and inject-error.sh.
> 
> [] BUG: KASAN: global-out-of-bounds in nfit_test_ctl+0x769f/0x7840 [nfit_test]
> [] Read of size 4 at addr ffffffffc03ea01c by task ndctl/1215
> [] The buggy address belongs to the variable:
> [] handle+0x1c/0x1df4 [nfit_test]
> 
> nfit_test_search_spa() uses handle[nvdimm->id] to retrieve a device
> handle and triggers a KASAN error when it reads past the end of the
> handle array. It should not be indexing the handle array at all.
> 
> The correct device handle is stored in per-DIMM test data. Each DIMM
> has a struct nfit_mem that embeds a struct acpi_nfit_memdev that
> describes the NFIT device handle. Use that device handle here. 
> 
> Fixes: 10246dc84dfc ("acpi nfit: nfit_test supports translate SPA")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>> ---
> 
> Changes in v2:
> - Use the correct handle in per-DIMM test data (Dan)
> - Update commit message and log
> - Update Fixes Tag
> 
> 
>  tools/testing/nvdimm/test/nfit.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
> index cfd4378e2129..f87e9f251d13 100644
> --- a/tools/testing/nvdimm/test/nfit.c
> +++ b/tools/testing/nvdimm/test/nfit.c
> @@ -670,6 +670,7 @@ static int nfit_test_search_spa(struct nvdimm_bus *bus,
>  		.addr = spa->spa,
>  		.region = NULL,
>  	};
> +	struct nfit_mem *nfit_mem;
>  	u64 dpa;
>  
>  	ret = device_for_each_child(&bus->dev, &ctx,
> @@ -687,8 +688,12 @@ static int nfit_test_search_spa(struct nvdimm_bus *bus,
>  	 */
>  	nd_mapping = &nd_region->mapping[nd_region->ndr_mappings - 1];
>  	nvdimm = nd_mapping->nvdimm;
> +	nfit_mem = nvdimm_provider_data(nvdimm);
> +	if (!nfit_mem)
> +		return -EINVAL;
>  
> -	spa->devices[0].nfit_device_handle = handle[nvdimm->id];
> +	spa->devices[0].nfit_device_handle =
> +		__to_nfit_memdev(nfit_mem)->device_handle;
>  	spa->num_nvdimms = 1;
>  	spa->devices[0].dpa = dpa;
>  
> 
> base-commit: 211ddde0823f1442e4ad052a2f30f050145ccada

