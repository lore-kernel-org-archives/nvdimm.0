Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF352F5313
	for <nvdimm@lists.linux.dev>; Mon,  8 Jun 2026 23:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780960685; cv=none; b=FqFmw+zfQ91Z4HsAmAZsarsOGIISFqRaQghLb87we3Yj71WV0IGZ2ChjNLuq13APHTwnSAD7omiI9+hG1Xq2YVLDxfj+yXnumNHsBTw7wdQB8zLK1OJ/PD8ajkLGwrkJAltDIf1u9q0C7GPKujylJ2sXtjM5XWvrYHKYeAQtX34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780960685; c=relaxed/simple;
	bh=5ylPIsMklYen/0GNNM4NaqqCpIPlXonB5UhyBxWjFeI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gEl09hlIJs7HL/3wrKlSyd+1g0mWU+kKitmMV8R9ffylnuKEM61jPqinlNomCUrjTdN3uWpM5K7Iwu8PZBHMgBqANBIwdsHQewaOJHDYzgdPJ7/fmUnJB/FaATRLSatNr+6GZhnSw89U4gsVyiMDL7CTBsEdELA6pqAjYUcYKmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MgEN3H5A; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MgEN3H5A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780960685; x=1812496685;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5ylPIsMklYen/0GNNM4NaqqCpIPlXonB5UhyBxWjFeI=;
  b=MgEN3H5A3lQbQiX95pARPhYq9KzeT2CLEvaOMjQHO9v2u4XQyoXuAlkm
   K73r03Yq0Ky3+zKgmgUTAu2lSlba2RRTU5SRkyuiHwfPaP0OYrCnBvQPU
   ghSrrc8Urx7d8QkymuhP7pICn8YRZUE4C4v7w4tGIDEtGU2i4db4l4NkQ
   GpnfJCks/KVpUQ9Zv5jSPclcjOJM0jqt2GOozHgNynkUGn4ieiwU1+/fd
   oRkE1COVZ2uFFs9NM6juJQ/vVYAKRjgNb0tE6JcIGWoarLkIH98bO/hwl
   c07xutXfqy1b1N7HSPHMDcBAcBU5qU6Edi7lpLcthJYGyYnIRbLB5GLh+
   A==;
X-CSE-ConnectionGUID: n0TuH08BR1eeSuPF7hTWUQ==
X-CSE-MsgGUID: Fuba3Uu7RwieH7/m8DV+bA==
X-IronPort-AV: E=McAfee;i="6800,10657,11811"; a="80845200"
X-IronPort-AV: E=Sophos;i="6.24,195,1774335600"; 
   d="scan'208";a="80845200"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2026 16:18:04 -0700
X-CSE-ConnectionGUID: oR5/CAqsQd62nS9MHlizIQ==
X-CSE-MsgGUID: 3snTDnR8QAm4AiQHmobVtw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,195,1774335600"; 
   d="scan'208";a="249606888"
Received: from bradocaj-mobl.ger.corp.intel.com (HELO [10.125.109.162]) ([10.125.109.162])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2026 16:18:03 -0700
Message-ID: <e4e51537-73f8-4a41-a7bc-b0b72b817b7b@intel.com>
Date: Mon, 8 Jun 2026 16:18:01 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/7] ndctl: Dynamic Capacity additions for cxl-cli
To: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Dan Williams <djbw@kernel.org>,
 Jonathan Cameron <jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
 Ira Weiny <iweiny@kernel.org>, Alison Schofield
 <alison.schofield@intel.com>, John Groves <John@Groves.net>,
 Gregory Price <gourry@gourry.net>, Ira Weiny <ira.weiny@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>,
 Jonathan Cameron <jonathan.cameron@Huawei.com>, Fan Ni <fan.ni@samsung.com>,
 Sushant1 Kumar <sushant1.kumar@intel.com>,
 Dan Williams <dan.j.williams@intel.com>
References: <20260523095043.471098-1-anisa.su@samsung.com>
 <20260523095043.471098-2-anisa.su@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260523095043.471098-2-anisa.su@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/23/26 2:50 AM, Anisa Su wrote:
> From: Ira Weiny <ira.weiny@intel.com>
> 
> This series can be found here:
> 
> 	https://github.com/weiny2/ndctl/tree/dcd-region3-2025-04-13
> 
> CXL Dynamic Capacity Device (DCD) support is being discussed in the
> upstream kernel.  cxl-cli requires modifications to interact with those
> devices.
> 
> A new partition type 'dynamic_ram_a' has been added which cxl-cli
> needs to know about.  Add support for the new decoder type.
> 
> With DCD regions may, or may not, have capacity.  The capacity is
> communicated via extents.  Add region extent query capabilities.
> 
> Add cxl-test support.  cxl-testing allows for quick regression testing
> as well as helping to design the cxl-cli interfaces.
> 
> 
> To: "Alison Schofield" <alison.schofield@intel.com>
> Cc: "Vishal Verma" <vishal.l.verma@intel.com>
> Cc: "Jonathan Cameron" <jonathan.cameron@Huawei.com>
> Cc: "Fan Ni" <fan.ni@samsung.com>
> Cc: "Sushant1 Kumar" <sushant1.kumar@intel.com>
> Cc: "Dan Williams" <dan.j.williams@intel.com>
> Cc: "Dave Jiang" <dave.jiang@intel.com>
> Cc: <linux-cxl@vger.kernel.org>
> Cc: <nvdimm@lists.linux.dev>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>

Drop this? Seems b4 metadata and not a patch.


> 
> ---
> Changes in v5:
> - iweiny: Adjust all code to view only the dynamic RAM A partition
> - Alison: s/tag/uuid/ in region query extent output
> - Link to v4: https://patch.msgid.link/20241214-dcd-region2-v4-0-36550a97f8e2@intel.com
> 
> --- b4-submit-tracking ---
> # This section is used internally by b4 prep for tracking purposes.
> {
>   "series": {
>     "revision": 5,
>     "change-id": "20241030-dcd-region2-2d0149eb8efd",
>     "prefixes": [],
>     "history": {
>       "v1": [
>         "20241030-dcd-region2-v1-0-04600ba2b48e@intel.com"
>       ],
>       "v2": [
>         "20241104-dcd-region2-v2-0-be057b479eeb@intel.com"
>       ],
>       "v3": [
>         "20241115-dcd-region2-v3-0-585d480ccdab@intel.com"
>       ],
>       "v4": [
>         "20241214-dcd-region2-v4-0-36550a97f8e2@intel.com"
>       ]
>     }
>   }
> }

