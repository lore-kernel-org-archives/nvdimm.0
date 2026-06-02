Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BCBF20B80B
	for <nvdimm@lists.linux.dev>; Tue,  2 Jun 2026 18:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780426241; cv=none; b=uDeIZzGxIhfFzT/oVtEp73+6T+qE+NO+DQLNeoCc4DGoot5k3ZVhLIfLVKnsb+jf6GnShyqrzxbEytkPK2BbR8j7MIZsEwaVIC1nbqR68zyZmBfAb5akkIFiVsKTrbExRkVv85/iA6ZlqQg5yyS2lGJwDqTiXi2j8fRqFnOj+ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780426241; c=relaxed/simple;
	bh=PmutC6JkH/lQ8EeKfTtTKfkKtIh4rHn5IvZM7YiI2A8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PL+UBdv29REkaquTg5WHF/EUwzd+KcLbwJYrmRjMfAkL1haaWV4rgoyTT6k+ispiULJ7BxIiTVI6yMci9/LuNOJdwE4esNGVqWDWqif4XZzT/oPU1rwYqGAg2LwbtePDAguK1tZ//W82FUzzOnbNxWWMM12X7Po9CRSdw1GT/Jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oHPlP3cK; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oHPlP3cK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780426240; x=1811962240;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=PmutC6JkH/lQ8EeKfTtTKfkKtIh4rHn5IvZM7YiI2A8=;
  b=oHPlP3cK1HI4a85tkDRz+a0b1leD6LN1F3afg5FRl0gzfdWHP+Zio8q5
   zTbqTl98c6eQ4nAfvW61N1KbG/CsaQRXUdb03CtYutrHHXNx849498N3S
   psTz617YY+JIqr9z4G1DLjmwIhiieEN+cwlvpLfkfe7YUwSqAy0dqVRMg
   Z9AeFMJ0IaOdUnXaaKwBm+0I5ktenhYszO1WK/TugZVNIAf9DIQwhUS9r
   MB2kunD5vqQO/4n2ij1FP3O5YK+a1LnOwblDav2OZ4kYEj46g+QtT659T
   CdYKPFiyl+PBsVfjVkJOoiQVXmV8eZTtzsYMvszR4O4v1Shc8mcEFqqQG
   w==;
X-CSE-ConnectionGUID: Jzn4HBxmQZawwcaZSzzA6g==
X-CSE-MsgGUID: NI8U1bINRru+/6FelVBixg==
X-IronPort-AV: E=McAfee;i="6800,10657,11805"; a="81284773"
X-IronPort-AV: E=Sophos;i="6.24,183,1774335600"; 
   d="scan'208";a="81284773"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 11:50:40 -0700
X-CSE-ConnectionGUID: 9/QpMjIfQ42OTWs87qpMiQ==
X-CSE-MsgGUID: NJBuOAYWQu+ikxvpV0f7Nw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,183,1774335600"; 
   d="scan'208";a="248279711"
Received: from mkosciow-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.245.229])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 11:50:36 -0700
Date: Tue, 2 Jun 2026 21:50:34 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Linux ACPI <linux-acpi@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Hans de Goede <hansg@kernel.org>, Armin Wolf <w_armin@gmx.de>,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	nvdimm@lists.linux.dev
Subject: Re: [PATCH v1 01/17] ACPI: bus: Introduce
 devm_acpi_install_notify_handler()
Message-ID: <ah8l-p0Ih9tzu0G1@ashevche-desk.local>
References: <4739447.LvFx2qVVIh@rafael.j.wysocki>
 <2268031.irdbgypaU6@rafael.j.wysocki>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2268031.irdbgypaU6@rafael.j.wysocki>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Thu, May 21, 2026 at 03:59:50PM +0200, Rafael J. Wysocki wrote:

> Introduce devm_acpi_install_notify_handler() for installing an ACPI
> notify handler managed by devres that will be removed automatically on
> driver detach.
> 
> It installs the notify handler on the device object in the ACPI
> namespace that corresponds to the owner device's ACPI companion, if
> present (an error is returned if the owner device doesn't have an ACPI
> companion).
> 
> Currently, there is no way to manually remove the notify handler
> installed by it because none of its users brought on subsequently
> will need to do that.

...

> +static void devm_acpi_notify_handler_release(struct device *dev, void *res)
> +{
> +	struct acpi_notify_handler_devres *dr = res;

'dr' is usually associated with internal devres structures and might be
misleading in here, I would rename to something like handler_devres.

> +	acpi_dev_remove_notify_handler(ACPI_COMPANION(dev), dr->handler_type,

acpi_dev might be also part of the same data structure, so you won't need to
take dev again and derive adev from it.

> +				       dr->handler);
> +}

...

> +/**
> + * devm_acpi_install_notify_handler - Install an ACPI notify handler for a
> + * 				      managed device

There is a stray space just after asterisk.

> + * @dev: Device to install a notify handler for
> + * @handler_type: Type of the notify handler
> + * @handler: Handler function to install
> + * @context: Data passed back to the handler function
> + *
> + * This function performs the same function as acpi_dev_install_notify_handler()
> + * called for the ACPI companion of @dev with the same @handler_type, @handler,
> + * and @context arguments, but the ACPI notify handler installed by it will be
> + * automatically removed on driver detach.
> + *
> + * Callers should ensure that all resources used by @handler have been allocated
> + * prior to invoking this function, in which case those resources should be
> + * devres-managed so that they won't be released before the notify handler
> + * removal.  Otherwise, special synchronization between @handler and the
> + * management of those resources is required.
> + *
> + * When the request fails, an error message is printed with contextual
> + * information (device name, handler function and error code).  Don't add extra

This "handler function" points to __func__? If so, it seems misleading.

> + * error messages at the call sites.
> + *
> + * Return: 0 on success or a negative error number.
> + */
> +int devm_acpi_install_notify_handler(struct device *dev, u32 handler_type,
> +				     acpi_notify_handler handler, void *context)
> +{
> +	struct acpi_notify_handler_devres *dr;
> +	struct acpi_device *adev;
> +	int ret;
> +
> +	adev = ACPI_COMPANION(dev);
> +	if (!adev)
> +		return dev_err_probe(dev, -ENODEV, "No ACPI companion in %s()\n", __func__);

Not sure how __func__ may help here. We will have a device instance to be
printed. It's obvious then how to find the culprit call.

> +	dr = devres_alloc(devm_acpi_notify_handler_release, sizeof(*dr), GFP_KERNEL);
> +	if (!dr)
> +		return -ENOMEM;
> +
> +	ret = acpi_dev_install_notify_handler(adev, handler_type, handler, context);
> +	if (ret) {
> +		devres_free(dr);
> +		return dev_err_probe(dev, ret, "Failed to install an ACPI notify handler\n");
> +	}
> +
> +	dr->handler = handler;
> +	dr->handler_type = handler_type;
> +	devres_add(dev, dr);

> +	return 0;
> +}

-- 
With Best Regards,
Andy Shevchenko


