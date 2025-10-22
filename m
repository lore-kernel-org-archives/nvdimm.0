Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918F031A7FE
	for <nvdimm@lists.linux.dev>; Wed, 22 Oct 2025 15:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761145497; cv=none; b=pelvCYEIH3cCwUwcs2xvddUVK+EtROWtuawJcRZZJHQmqdntTwO+L3jkWMOW9oBafnjl+orQJurj5clXJ1nNi4/lNKCwDUG67kW9AAX3wNTcwEj2NTQjy5VsOuJeKpALbJ+8m/vwdcE3AceSzOjSykrtOsyeVRqg3j6/IqTD1vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761145497; c=relaxed/simple;
	bh=iW+FTqaMo0YUZ/DdwuMszfMWV+XVQ+AxrUIygW4bQy0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qgAnxX3j5nuvusU9gK6duJVmD5RRlxCUgMut+tKKBXOl6/zu4KmLabtQ1uzrnB/t2YoY3sbFnHA+o39pSERo1F+6aJKPLij9aI0C3m734ZP9nZYmMcQpNyHTuUB1c03EQc4igWLoD1weEZm6r28Q5YfiB/3eBxojNlHG05/2JEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ebctZrqT; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ebctZrqT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761145496; x=1792681496;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=iW+FTqaMo0YUZ/DdwuMszfMWV+XVQ+AxrUIygW4bQy0=;
  b=ebctZrqTSIxFqS7l6SttBulw8En8ucnHiDG9BOzJe45K02EHVyGv+MfC
   Ecq8V3GHOmt2+8GNqOqR88ClyZMB/TF9jbhQHdRTchu5wCoQ/0zE8b0cZ
   V12zoMAyhFyRj1AOXyJWmThKxKkcmVGaYI/mfY9Sx8gTG47i2lTtU4zvF
   xjrpiPxZmM99zkPleL70VaNN8UbuYzstpJRUgu2jdc9YXRhoC7bwrVWiM
   QY1+51lsEfF0t21Vq8FkOUVeXkY/+2juZQtndmilQO97pc8IEde4p+URA
   /ZPLlVE2DtAbtj1WAG81gd63xAdB+4WG1k7UF01E6qmDh4lthu8H5RpnA
   w==;
X-CSE-ConnectionGUID: UnL9iLHyQ8m9q8wyP3nM2Q==
X-CSE-MsgGUID: BnLwhA0tSayG+IyXAC2zmA==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="74736188"
X-IronPort-AV: E=Sophos;i="6.19,247,1754982000"; 
   d="scan'208";a="74736188"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 08:04:55 -0700
X-CSE-ConnectionGUID: hU43e6DZRce/ZChq5nN8kQ==
X-CSE-MsgGUID: 0P0qhWFcT+GUNYTCsHCiOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,247,1754982000"; 
   d="scan'208";a="183485278"
Received: from cmdeoliv-mobl4.amr.corp.intel.com (HELO [10.125.108.213]) ([10.125.108.213])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 08:04:55 -0700
Message-ID: <7687ba73-0f8f-4cf1-b6e5-8525e8fbadec@intel.com>
Date: Wed, 22 Oct 2025 08:04:54 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH] ndctl/test: fully reset nfit_test in pmem_ns unit
 test
To: Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev
Cc: Marc Herbert <marc.herbert@intel.com>
References: <20251021212648.997901-1-alison.schofield@intel.com>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20251021212648.997901-1-alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/21/25 2:26 PM, Alison Schofield wrote:
> The pmem_ns unit test frequently fails when run as part of the full
> suite, yet passes when executed alone.
> 
> The test first looks for an ACPI.NFIT bus with a usable region, and if
> none is found, falls back to using the nfit_test bus. However, that
> fallback consistently fails with errors such as:
> 
> path: /sys/devices/platform/nfit_test.0/ndbus2/region7/namespace7.0/uuid
> libndctl: write_attr: failed to open /sys/devices/platform/nfit_test.0/ndbus2/region7/namespace7.0/uuid: No such file or directory
> /root/ndctl/build/test/pmem-ns: failed to create PMEM namespace
> 
> This occurs because calling ndctl_test_init() with a NULL context only
> unloads and reloads the nfit_test module, but does not invalidate and
> reinitialize the libndctl context or sysfs view from previous runs.
> The resulting stale state prevents the pmem_ns test from creating a
> new namespace cleanly.
> 
> Replace the NULL context parameter when calling ndctl_test_init()
> with the available ndctl_ctx to ensure pmem_ns can find usable PMEM
> regions.
> 
> Reported-by: Marc Herbert <marc.herbert@intel.com>
> Closes: https://github.com/pmem/ndctl/issues/290
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>> ---
>  test/pmem_namespaces.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/test/pmem_namespaces.c b/test/pmem_namespaces.c
> index 4bafff5164c8..7b8de9dcb61d 100644
> --- a/test/pmem_namespaces.c
> +++ b/test/pmem_namespaces.c
> @@ -191,7 +191,7 @@ int test_pmem_namespaces(int log_level, struct ndctl_test *test,
>  
>  	if (!bus) {
>  		fprintf(stderr, "ACPI.NFIT unavailable falling back to nfit_test\n");
> -		rc = ndctl_test_init(&kmod_ctx, &mod, NULL, log_level, test);
> +		rc = ndctl_test_init(&kmod_ctx, &mod, ctx, log_level, test);
>  		ndctl_invalidate(ctx);
>  		bus = ndctl_bus_get_by_provider(ctx, "nfit_test.0");
>  		if (rc < 0 || !bus) {

