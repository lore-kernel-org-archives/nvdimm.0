Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8F72F6183
	for <nvdimm@lists.linux.dev>; Fri, 31 Oct 2025 19:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761937970; cv=none; b=cw9MtlMrpNWOoPP8NdOpKPUROniNQIXVDVIqZb9oTUgpUwJtK46L9XfU99OIQ/3riJQozB0yQ9wECc9H1usgOHSBp/DgGoQLLmM35AQB8Rt1NWlv7wwXEXIsFvhjiVZN0aD0PtRWEDbEQiJbou/5a4n11fsxo6aD/hRd81OjGd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761937970; c=relaxed/simple;
	bh=LX5p3woLzMcUgFCZNWnFvWK4ckTrzIKT2P3boAHSCHQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UlwlSemz5J29oXGNkT4GxDgHLD1swncywQwzhDTMcNe9M9X0wOvWVFfLPf/7x8PKPV0UteucbQsC3n816vPleunfdbmMqHC01fr5v8im/QgOFSW0TXc0fQ9BDoQSD+3JvN6PeaCzVB1mRE4thLhc2Sjlo+45u0vsUSzSh7R/C6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LygK5zJC; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LygK5zJC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761937968; x=1793473968;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LX5p3woLzMcUgFCZNWnFvWK4ckTrzIKT2P3boAHSCHQ=;
  b=LygK5zJCqnMwES0Bgv6h1Mlqf7qRYEvodU4SpwjoFgQMhB2mTazjy2Re
   EohoEgPWdazS+B8YLeGbsaXS13pnDmMcCK9fvCaGtUSBxyUsOfLpD3UWi
   5tNz0rpi9lA8Wd1NAYr1PfexYNxuBGcmjlJQNxMKAAj9ydz74VbGC1F9O
   FXRc5T3VYyvczEtdWTYqn51lZC6LyhP1Z+lE4vSgx2YNpDHnp+TMZoBNd
   7tFA0RMDjLPrC0nSEj+7ofM93dE37m1L0XaXYc/UgVmrh08Qn+pjUCPLw
   j8UViQlfJ25hq2zMxpiiQRWmaZSNqNi9qkGudpWhDSoFOC9l/onTcBkZg
   A==;
X-CSE-ConnectionGUID: LrCgVfQXQeO4b+mTWuIp8A==
X-CSE-MsgGUID: 2sNfCDogRa+FUsLgpSffvA==
X-IronPort-AV: E=McAfee;i="6800,10657,11599"; a="63309890"
X-IronPort-AV: E=Sophos;i="6.19,270,1754982000"; 
   d="scan'208";a="63309890"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 12:12:47 -0700
X-CSE-ConnectionGUID: 38UhnxzhRSS3Y8t8wfSPZw==
X-CSE-MsgGUID: 1YZ6zaFiRgOPRvN8aXiNRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,270,1754982000"; 
   d="scan'208";a="187049397"
Received: from rchatre-mobl4.amr.corp.intel.com (HELO [10.125.110.49]) ([10.125.110.49])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 12:12:47 -0700
Message-ID: <db69dfe3-3488-4f84-8530-ae694356de38@intel.com>
Date: Fri, 31 Oct 2025 12:12:46 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] tools/testing/nvdimm: Stop read past end of global handle
 array
To: Alison Schofield <alison.schofield@intel.com>,
 Ira Weiny <ira.weiny@intel.com>, Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>
Cc: nvdimm@lists.linux.dev, stable@vger.kernel.org
References: <20251030004222.1245986-1-alison.schofield@intel.com>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20251030004222.1245986-1-alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/29/25 5:42 PM, Alison Schofield wrote:
> KASAN reports a global-out-of-bounds access when running these nfit
> tests: clear.sh, pmem-errors, pfn-meta-errors.sh, btt-errors.sh,
> daxdev-errors.sh, and inject-error.sh.
> 
> [] BUG: KASAN: global-out-of-bounds in nfit_test_ctl+0x769f/0x7840 [nfit_test]
> [] Read of size 4 at addr ffffffffc03ea01c by task ndctl/1215
> [] The buggy address belongs to the variable:
> [] handle+0x1c/0x1df4 [nfit_test]
> 
> The nfit_test mock platform defines a static table of 7 NFIT DIMM
> handles, but nfit_test.0 builds 8 mock DIMMs total (5 DCR + 3 PM).
> When the final DIMM (id == 7) is selected, this code:
>     spa->devices[0].nfit_device_handle = handle[nvdimm->id];
> indexes past the end of the 7-entry table, triggering KASAN.
> 
> Fix this by adding an eighth entry to the handle[] table and a
> defensive bounds check so the test fails cleanly instead of
> dereferencing out-of-bounds memory.
> 
> To generate a unique handle, the new entry sets the 'imc' field rather
> than the 'chan' field. This matches the pattern of earlier entries
> and avoids introducing a non-zero 'chan' which is never used in the
> table. Computing the new handle shows no collision.
> 
> Notes from spelunkering for a Fixes Tag:
> 
> Commit 209851649dc4 ("acpi: nfit: Add support for hot-add") increased
> the mock DIMMs to eight yet kept the handle[] array at seven.
> 
> Commit 10246dc84dfc ("acpi nfit: nfit_test supports translate SPA")
> began using the last mock DIMM, triggering the KASAN.
> 
> Commit af31b04b67f4 ("tools/testing/nvdimm: Fix the array size for
> dimm devices.") addressed a related KASAN warning but not the actual
> handle array length.
> 
> Fixes: 209851649dc4 ("acpi: nfit: Add support for hot-add")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>> ---
>  tools/testing/nvdimm/test/nfit.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
> index cfd4378e2129..cdbf9e8ee80a 100644
> --- a/tools/testing/nvdimm/test/nfit.c
> +++ b/tools/testing/nvdimm/test/nfit.c
> @@ -129,6 +129,7 @@ static u32 handle[] = {
>  	[4] = NFIT_DIMM_HANDLE(0, 1, 0, 0, 0),
>  	[5] = NFIT_DIMM_HANDLE(1, 0, 0, 0, 0),
>  	[6] = NFIT_DIMM_HANDLE(1, 0, 0, 0, 1),
> +	[7] = NFIT_DIMM_HANDLE(1, 0, 1, 0, 1),
>  };
>  
>  static unsigned long dimm_fail_cmd_flags[ARRAY_SIZE(handle)];
> @@ -688,6 +689,13 @@ static int nfit_test_search_spa(struct nvdimm_bus *bus,
>  	nd_mapping = &nd_region->mapping[nd_region->ndr_mappings - 1];
>  	nvdimm = nd_mapping->nvdimm;
>  
> +	if (WARN_ON_ONCE(nvdimm->id >= ARRAY_SIZE(handle))) {
> +		dev_err(&bus->dev,
> +			"invalid nvdimm->id %u >= handle array size %zu\n",
> +			nvdimm->id, ARRAY_SIZE(handle));
> +		return -EINVAL;
> +	}
> +
>  	spa->devices[0].nfit_device_handle = handle[nvdimm->id];
>  	spa->num_nvdimms = 1;
>  	spa->devices[0].dpa = dpa;
> 
> base-commit: 211ddde0823f1442e4ad052a2f30f050145ccada

