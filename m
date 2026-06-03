Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F5B4E3765
	for <nvdimm@lists.linux.dev>; Wed,  3 Jun 2026 23:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780528053; cv=none; b=B1LiqIa5n87Hd65alO46HTLUKXHP9nQCG7jMK6d1O0wU2FwTWv9DIopqBMMK1aZ/cE938p/RREu8JD8cPvOtW3cObvYWFpYHde5oxuBsvIGhiu0fyOIt+vcSjojN7/ugARLEs+PZF6iHTZCOCJUH/k0qcakxZ5fFTSYMYcFceKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780528053; c=relaxed/simple;
	bh=5+Av5pTq7geA62ja0qraoZ8OX8KS7EKJ/We01guOduY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hzOVaR8u7jG/dcrSyoLzNCbV818PYFkDb4zXqX2GxAXQoFZVav3XtH2HgdPyKZ/8POEJYnvXq5cR81DXBWJkS53oY8Ykh+4kH/U4/o91pulmMHQzx57zIW74HH4P/LQKclmm/kD7Qx3CydD1lrbe/2z0IAIqLMcSvCHWNhkcSQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OESLXeF1; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OESLXeF1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780528052; x=1812064052;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5+Av5pTq7geA62ja0qraoZ8OX8KS7EKJ/We01guOduY=;
  b=OESLXeF1iLCbFBa4lzdK46HEFRWK9L8DdwnaH15sGIorzP04/4oghc+X
   0/iDQD0K2P+/6XDuDAyHHvflLWZ7IBLErpHXGc9vW2KKCtclP6MzyLRHY
   sv7ZVmb1wlyZDwUMYD3KpqggrExyo0AdbBtKHwfKsOHvuWz4z2Opc44it
   Q3kmtUyGcFq6Jv6w5rZ0A+7XmLJOVWvzKnXTNdnFBjKuRm558jR1feNtL
   kqjorWHtpxey8NLf0Ko8JHteWq0CtGzCV1FQEcY9i2oRlG9ikiiDdX45Q
   Srzqqv2hFZofdag27eUjtPK9ZDSJsXh+P1v43pRKJlfZzCipuUJjivs7V
   g==;
X-CSE-ConnectionGUID: bF4P86d5SBCQS55KkuI5YA==
X-CSE-MsgGUID: srGLtxmWRgq6JHvtrcX8xA==
X-IronPort-AV: E=McAfee;i="6800,10657,11806"; a="92835008"
X-IronPort-AV: E=Sophos;i="6.24,186,1774335600"; 
   d="scan'208";a="92835008"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2026 16:07:32 -0700
X-CSE-ConnectionGUID: iVIJ4gqwS5qp/BCEZQEjzQ==
X-CSE-MsgGUID: JBgwn1RORdiwKAUpffh1JA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,186,1774335600"; 
   d="scan'208";a="244457786"
Received: from dnelso2-mobl.amr.corp.intel.com (HELO [10.125.108.116]) ([10.125.108.116])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2026 16:06:27 -0700
Message-ID: <f3fff3f8-89e3-496f-9af5-868ef329d137@intel.com>
Date: Wed, 3 Jun 2026 16:06:25 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] ACPI: NFIT: core: Fix acpi_nfit_init() error
 cleanup
To: "Rafael J. Wysocki" <rafael@kernel.org>,
 Linux ACPI <linux-acpi@vger.kernel.org>
Cc: Dan Williams <djbw@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev,
 Alison Schofield <alison.schofield@intel.com>,
 Xiang Chen <chenxiang66@hisilicon.com>
References: <5110904.31r3eYUQgx@rafael.j.wysocki>
 <1963615.tdWV9SEqCh@rafael.j.wysocki>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <1963615.tdWV9SEqCh@rafael.j.wysocki>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/3/26 10:57 AM, Rafael J. Wysocki wrote:
> From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
> 
> If acpi_nfit_init() fails after adding the acpi_desc object to the
> acpi_descs list, that object is never removed from that list because
> the acpi_nfit_shutdown() devm action is not added for the NFIT device
> in that case.  Next, the acpi_nfit_init() failure causes
> acpi_nfit_probe() to fail, the acpi_desc object is freed, and a
> dangling pointer is left behind in the acpi_descs.  Any subsequent
> ACPI Machine Check Exception will trigger nfit_handle_mce() which
> iterates over acpi_descs and so a use-after-free will occur.
> 
> Moreover, if acpi_nfit_probe() returns 0 after installing a notify
> handler for the NFIT device and without allocating the acpi_desc
> object and setting the NFIT device's driver data pointer, the
> acpi_desc object will be allocated by acpi_nfit_update_notify()
> and acpi_nfit_init() will be called to initialize it.  Regardless
> of whether or not acpi_nfit_init() fails in that case, the
> acpi_nfit_shutdown() devm action is not added for the NFIT device
> and acpi_desc is never removed from the acpi_descs list.  If the
> acpi_desc object is freed subsequently on driver removal, any
> subsequent ACPI MCE will lead to a use-after-free like in the
> previous case.
> 
> To address the first issue mentioned above, make acpi_nfit_probe()
> call acpi_nfit_shutdown() directly on acpi_nfit_init() failures and
> to address the other one, add a remove callback to the driver and
> make it call acpi_nfit_shutdown().  Also, since it is now possible to
> pass NULL to acpi_nfit_shutdown() or the acpi_desc object passed to it
> may not have been initialized, add checks against NULL for acpi_desc and
> its nvdimm_bus field to that function and make acpi_nfit_unregister()
> clear the latter after unregistering the NVDIMM bus.
> 
> Fixes: a61fe6f7902e ("nfit, tools/testing/nvdimm: unify common init for acpi_nfit_desc")
> Fixes: fbabd829fe76 ("acpi, nfit: fix module unload vs workqueue shutdown race")
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Cc: All applicable <stable@vger.kernel.org>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>


> ---
>  drivers/acpi/nfit/core.c | 18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index 8024cd3cad14..01c73be0bd00 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -3069,6 +3069,8 @@ static void acpi_nfit_unregister(void *data)
>  	struct acpi_nfit_desc *acpi_desc = data;
>  
>  	nvdimm_bus_unregister(acpi_desc->nvdimm_bus);
> +	/* The nvdimm_bus object may have been freed, so clear the pointer. */
> +	acpi_desc->nvdimm_bus = NULL;
>  }
>  
>  int acpi_nfit_init(struct acpi_nfit_desc *acpi_desc, void *data, acpi_size sz)
> @@ -3301,7 +3303,10 @@ static void acpi_nfit_notify(acpi_handle handle, u32 event, void *data)
>  void acpi_nfit_shutdown(void *data)
>  {
>  	struct acpi_nfit_desc *acpi_desc = data;
> -	struct device *bus_dev = to_nvdimm_bus_dev(acpi_desc->nvdimm_bus);
> +	struct device *bus_dev;
> +
> +	if (!acpi_desc || !acpi_desc->nvdimm_bus)
> +		return;
>  
>  	/*
>  	 * Destruct under acpi_desc_lock so that nfit_handle_mce does not
> @@ -3316,6 +3321,7 @@ void acpi_nfit_shutdown(void *data)
>  	mutex_unlock(&acpi_desc->init_mutex);
>  	cancel_delayed_work_sync(&acpi_desc->dwork);
>  
> +	bus_dev = to_nvdimm_bus_dev(acpi_desc->nvdimm_bus);
>  	/*
>  	 * Bounce the nvdimm bus lock to make sure any in-flight
>  	 * acpi_nfit_ars_rescan() submissions have had a chance to
> @@ -3388,9 +3394,14 @@ static int acpi_nfit_probe(struct platform_device *pdev)
>  				sz - sizeof(struct acpi_table_nfit));
>  
>  	if (rc)
> -		return rc;
> +		acpi_nfit_shutdown(acpi_desc);
>  
> -	return devm_add_action_or_reset(dev, acpi_nfit_shutdown, acpi_desc);
> +	return rc;
> +}
> +
> +static void acpi_nfit_remove(struct platform_device *pdev)
> +{
> +	acpi_nfit_shutdown(platform_get_drvdata(pdev));
>  }
>  
>  static void acpi_nfit_update_notify(struct device *dev, acpi_handle handle)
> @@ -3474,6 +3485,7 @@ MODULE_DEVICE_TABLE(acpi, acpi_nfit_ids);
>  
>  static struct platform_driver acpi_nfit_driver = {
>  	.probe = acpi_nfit_probe,
> +	.remove = acpi_nfit_remove,
>  	.driver = {
>  		.name = "acpi-nfit",
>  		.acpi_match_table = acpi_nfit_ids,

