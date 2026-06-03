Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0109B4D90A4
	for <nvdimm@lists.linux.dev>; Wed,  3 Jun 2026 23:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780528231; cv=none; b=B9XT/JK26cOgWr5rshVMm35t9USA+ohl9K3aRqwfmVLlnfYbKz+tWZKR7QAtQSo5amyRYKrHchUTYW/WHYZPXpfQixKKPWCgL7uRfsyd6WzGOQGpYpMze0fcmR3HdNGq2PbSxVOB2+jNbIOZHeT3vE7qavQDwsJQkhgyYBHHVY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780528231; c=relaxed/simple;
	bh=VS5BCt4yguPLceqyOrD8+a51wXyF39nlVQWCu6iemvE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=imBEieEQrN+3pSF8amPv6+RLzcNTwG+Ii1rfWVhTtxnXO5dAWKrUO6XcmlmDAG+aJYI9BafH5EicsXTuNqE4GF3C9TA7CeOjOm7smCDNUx+5498CPSzvcbBdLTjq5SIk0O6VPjFuxkkgg+NejQQ9zWy9d+tAdPN+yY+xFo56hAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Zw1mw2XJ; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Zw1mw2XJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780528230; x=1812064230;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=VS5BCt4yguPLceqyOrD8+a51wXyF39nlVQWCu6iemvE=;
  b=Zw1mw2XJUuyb8yQGFtKCVmthh35xCaXzZRXFENSFeOME9LLBhIeeKo61
   5oKRLsYLZrsP/oWVnP2/lQGD1Jy8qPfuUTV4pO1CU7AidxlymfscS2x4u
   6CaiXJk4XxuNFrswj7bV591Ph133aKF2VNZfuV1oVi91yOBBheNtqL4v+
   iJjSr8rD3MLPhxwlc12y5r3S6dF/BJ54ute1nNzYDuwI+Mdjj96YtC6ID
   m5hzfW2Uuh+0SogrTREFyIGd4nIRimCN/9aUbMwKPgXFy+lhgCg5mLdKR
   J/1pnzEGPepB2O5wQdqIFz1tA1ptZ4BkGzaSJwU7dXN4S4CbzIa3sazXR
   g==;
X-CSE-ConnectionGUID: KLkQyrupT1CpX9+3QrzFUw==
X-CSE-MsgGUID: tUE/L/5lTnesLvMxksBSsA==
X-IronPort-AV: E=McAfee;i="6800,10657,11806"; a="81414159"
X-IronPort-AV: E=Sophos;i="6.24,186,1774335600"; 
   d="scan'208";a="81414159"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2026 16:10:29 -0700
X-CSE-ConnectionGUID: DiwDODWaS5y8Aa4wmlsKyw==
X-CSE-MsgGUID: ySqe2+TFSIiaFK8qJ/gooQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,186,1774335600"; 
   d="scan'208";a="241879362"
Received: from dnelso2-mobl.amr.corp.intel.com (HELO [10.125.108.116]) ([10.125.108.116])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2026 16:10:28 -0700
Message-ID: <ed208654-0fb4-49c1-a559-8aaa530a2a36@intel.com>
Date: Wed, 3 Jun 2026 16:10:26 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] ACPI: NFIT: core: Fix possible deadlock and
 missing notifications
To: "Rafael J. Wysocki" <rafael@kernel.org>,
 Linux ACPI <linux-acpi@vger.kernel.org>
Cc: Dan Williams <djbw@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev,
 Alison Schofield <alison.schofield@intel.com>,
 Xiang Chen <chenxiang66@hisilicon.com>
References: <5110904.31r3eYUQgx@rafael.j.wysocki>
 <3420096.aeNJFYEL58@rafael.j.wysocki>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <3420096.aeNJFYEL58@rafael.j.wysocki>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/3/26 10:58 AM, Rafael J. Wysocki wrote:
> From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
> 
> After commit 9b311b7313d6 ("ACPI: NFIT: Install Notify() handler before
> getting NFIT table"), ACPI NFIT driver removal may deadlock if an ACPI
> notify on the NFIT device is triggered concurrently.  A similar deadlock
> may occur if an ACPI notify on the NFIT device is triggered during a
> failing driver probe.
> 
> The deadlock is possible because acpi_dev_remove_notify_handler() calls
> acpi_os_wait_events_complete() after removing the notify handler and the
> driver core invokes it under the NFIT platform device lock which is also
> acquired by acpi_nfit_notify().  Thus acpi_os_wait_events_complete() may
> be waiting for acpi_nfit_notify() to complete, but the latter may not be
> able to acquire the device lock which is being held by the driver core
> while the former is being executed.
> 
> Moreover, after commit 03667e146f81 ("ACPI: NFIT: core: Convert the
> driver to a platform one"), there are no sysfs notifications regarding
> NVDIMM devices because __acpi_nvdimm_notify() always bails out after
> checking the driver data pointer of the device's parent.  That parent
> is the ACPI companion of the platform device used for driver binding,
> so its driver data pointer is always NULL after the commit in question
> which was overlooked by it.
> 
> A remedy for the deadlock is to use a special separate lock for ACPI
> notify synchronization with driver probe and removal instead of the
> device lock of the NFIT device, while a remedy for the second issue
> is to populate the driver data pointer of the NFIT device's ACPI
> companion when the driver is ready to operate, so do both these things.
> However, since the new lock is not held across the entire teardown and
> acpi_nfit_notify() should do nothing when teardown is in progress, make
> it check the driver data pointer of the NFIT device's ACPI companion, in
> analogy with the existing check in __acpi_nvdimm_notify(), and bail out
> if that pointer is NULL.
> 
> Fixes: 9b311b7313d6 ("ACPI: NFIT: Install Notify() handler before getting NFIT table")
> Fixes: 03667e146f81 ("ACPI: NFIT: core: Convert the driver to a platform one")
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Cc: All applicable <stable@vger.kernel.org>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>


> ---
>  drivers/acpi/nfit/core.c | 63 ++++++++++++++++++++++++++++++++--------
>  1 file changed, 51 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index aaa84ae7a20e..cb771d9cadb2 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -56,6 +56,8 @@ MODULE_PARM_DESC(force_labels, "Opt-in to labels despite missing methods");
>  LIST_HEAD(acpi_descs);
>  DEFINE_MUTEX(acpi_desc_lock);
>  
> +DEFINE_MUTEX(acpi_notify_lock);
> +
>  static struct workqueue_struct *nfit_wq;
>  
>  struct nfit_table_prev {
> @@ -1708,9 +1710,15 @@ static void acpi_nvdimm_notify(acpi_handle handle, u32 event, void *data)
>  	struct acpi_device *adev = data;
>  	struct device *dev = &adev->dev;
>  
> -	device_lock(dev->parent);
> +	/*
> +	 * Locking is needed here for synchronization with driver probe and
> +	 * removal and the parent's driver data pointer is NULL when teardown
> +	 * is in progress (while the parent here is expected to be the ACPI
> +	 * companion of the platform device used for driver binding).
> +	 */
> +	guard(mutex)(&acpi_notify_lock);
> +
>  	__acpi_nvdimm_notify(dev, event);
> -	device_unlock(dev->parent);
>  }
>  
>  static bool acpi_nvdimm_has_method(struct acpi_device *adev, char *method)
> @@ -3156,11 +3164,10 @@ EXPORT_SYMBOL_GPL(acpi_nfit_init);
>  static int acpi_nfit_flush_probe(struct nvdimm_bus_descriptor *nd_desc)
>  {
>  	struct acpi_nfit_desc *acpi_desc = to_acpi_desc(nd_desc);
> -	struct device *dev = acpi_desc->dev;
>  
> -	/* Bounce the device lock to flush acpi_nfit_add / acpi_nfit_notify */
> -	device_lock(dev);
> -	device_unlock(dev);
> +	/* Bounce the notify lock to flush acpi_nfit_probe / acpi_nfit_notify */
> +	mutex_lock(&acpi_notify_lock);
> +	mutex_unlock(&acpi_notify_lock);
>  
>  	/* Bounce the init_mutex to complete initial registration */
>  	mutex_lock(&acpi_desc->init_mutex);
> @@ -3292,10 +3299,17 @@ static void acpi_nfit_put_table(void *table)
>  static void acpi_nfit_notify(acpi_handle handle, u32 event, void *data)
>  {
>  	struct device *dev = data;
> +	struct acpi_device *adev = ACPI_COMPANION(dev);
>  
> -	device_lock(dev);
> -	__acpi_nfit_notify(dev, handle, event);
> -	device_unlock(dev);
> +	/*
> +	 * Locking is needed here for synchronization with driver probe and
> +	 * removal and the ACPI companion's driver data pointer is NULL when
> +	 * teardown is in progress.
> +	 */
> +	guard(mutex)(&acpi_notify_lock);
> +
> +	if (dev_get_drvdata(&adev->dev))
> +		__acpi_nfit_notify(dev, handle, event);
>  }
>  
>  void acpi_nfit_shutdown(void *data)
> @@ -3337,11 +3351,18 @@ static int acpi_nfit_probe(struct platform_device *pdev)
>  	struct acpi_buffer buf = { ACPI_ALLOCATE_BUFFER, NULL };
>  	struct acpi_nfit_desc *acpi_desc;
>  	struct device *dev = &pdev->dev;
> +	struct acpi_device *adev = ACPI_COMPANION(dev);
>  	struct acpi_table_header *tbl;
>  	acpi_status status = AE_OK;
>  	acpi_size sz;
>  	int rc = 0;
>  
> +	/*
> +	 * Prevent acpi_nfit_notify() from progressing until the probe is
> +	 * complete in case there is a concurrent event to process.
> +	 */
> +	guard(mutex)(&acpi_notify_lock);
> +
>  	rc = devm_acpi_install_notify_handler(dev, ACPI_DEVICE_NOTIFY,
>  					      acpi_nfit_notify, dev);
>  	if (rc)
> @@ -3357,6 +3378,11 @@ static int acpi_nfit_probe(struct platform_device *pdev)
>  		 * data in the format of a series of NFIT Structures.
>  		 */
>  		dev_dbg(dev, "failed to find NFIT at startup\n");
> +		/*
> +		 * Let acpi_nfit_update_notify() run in case it will need to
> +		 * allocate the acpi_desc object.
> +		 */
> +		dev_set_drvdata(&adev->dev, dev);
>  		return 0;
>  	}
>  
> @@ -3374,7 +3400,7 @@ static int acpi_nfit_probe(struct platform_device *pdev)
>  	acpi_desc->acpi_header = *tbl;
>  
>  	/* Evaluate _FIT and override with that if present */
> -	status = acpi_evaluate_object(ACPI_HANDLE(dev), "_FIT", NULL, &buf);
> +	status = acpi_evaluate_object(adev->handle, "_FIT", NULL, &buf);
>  	if (ACPI_SUCCESS(status) && buf.length > 0) {
>  		union acpi_object *obj = buf.pointer;
>  
> @@ -3391,14 +3417,27 @@ static int acpi_nfit_probe(struct platform_device *pdev)
>  				+ sizeof(struct acpi_table_nfit),
>  				sz - sizeof(struct acpi_table_nfit));
>  
> -	if (rc)
> +	if (rc) {
>  		acpi_nfit_shutdown(acpi_desc);
> +		return rc;
> +	}
>  
> -	return rc;
> +	/*
> +	 * Let notify handlers operate (the actual value of the ACPI companion's
> +	 * driver data pointer does not matter here so long as it is not NULL).
> +	 */
> +	dev_set_drvdata(&adev->dev, dev);
> +	return 0;
>  }
>  
>  static void acpi_nfit_remove(struct platform_device *pdev)
>  {
> +	struct acpi_device *adev = ACPI_COMPANION(&pdev->dev);
> +
> +	guard(mutex)(&acpi_notify_lock);
> +
> +	/* Make notify handlers bail out early going forward. */
> +	dev_set_drvdata(&adev->dev, NULL);
>  	acpi_nfit_shutdown(platform_get_drvdata(pdev));
>  }
>  

