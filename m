Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8137A481A7
	for <nvdimm@lists.linux.dev>; Mon,  5 Feb 2024 17:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707153752; cv=none; b=mxlQEgrPmxAkFfQYaZvr5IdX6qV3c1z1uct2lDkiAjT2F9hiKcYRSJWAUQC8yQCbrwm1RxRxgoY8Zmf+T0BrWx7HL+Oh5tf92e9BTBvAmNSEvk65IsQCkqiLWofddvDtxNzdEsMnZZLoD0Os6D7p5WmjwMaldoFVEw3yKwaUYJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707153752; c=relaxed/simple;
	bh=QYfTzVh1GhDcNX1AdSswl+d4aBc6MuUiVyM01wBfWK4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jB9fDvtvi0o+kQmfSmh0xIDmbU4z+yOyBHQa6nhq3WAvClUoF4uOJjlqXsxcsJZteObu4Jn72RxTcIPASZ0MEX7jg0UxmVfM3QqNkpmAqdXnuQFFdf0ZC3MlOKKzjrkj0atbgz3+PdLGuTVBxXM+UhfGHYZK86Ykb4/AaZIKBr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JTtemAde; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JTtemAde"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707153751; x=1738689751;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=QYfTzVh1GhDcNX1AdSswl+d4aBc6MuUiVyM01wBfWK4=;
  b=JTtemAdeshg3R4feWm0FGdhPmqF69E3evjkjVVtfgus72Wq8rOExieOx
   0oFamP0fvlh1jwZ9XZjpY5vDVV1aNBELH3KmSUbr9MZKUAzI1AEu2m6RT
   yxrYLCrIrYa1tcQouPvkg6wkIvDOZ1qFQ8HgicRgvVnH3/kIvcHw5TLVC
   m82uHgPQhYQGANRMXjLeDt5w1JWtCYXVsf42IIUaxeWE27V/gdq/H/lqf
   V33H7KBsRJpzzEfVtdi9A11F0wWVVtwX9rZUFIRso3WOBke1sXK4SFqFU
   XGabhhZIg6kZpmFBqsrxd4STa+zASW95yRdj9hgzPle6YMlCa0ESTmjZp
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10975"; a="11303852"
X-IronPort-AV: E=Sophos;i="6.05,245,1701158400"; 
   d="scan'208";a="11303852"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2024 09:22:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,245,1701158400"; 
   d="scan'208";a="5390550"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.246.112.181]) ([10.246.112.181])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2024 09:22:28 -0800
Message-ID: <6cfd8171-a8c6-4433-8f4e-30f2ed156b0e@intel.com>
Date: Mon, 5 Feb 2024 10:22:27 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] nvdimm: make nvdimm_bus_type const
Content-Language: en-US
To: "Ricardo B. Marliere" <ricardo@marliere.net>,
 Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20240204-bus_cleanup-nvdimm-v1-1-77ae19fa3e3b@marliere.net>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20240204-bus_cleanup-nvdimm-v1-1-77ae19fa3e3b@marliere.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2/4/24 1:20 PM, Ricardo B. Marliere wrote:
> Now that the driver core can properly handle constant struct bus_type,
> move the nvdimm_bus_type variable to be a constant structure as well,
> placing it into read-only memory which can not be modified at runtime.
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Ricardo B. Marliere <ricardo@marliere.net>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/nvdimm/bus.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
> index ef3d0f83318b..508aed017ddc 100644
> --- a/drivers/nvdimm/bus.c
> +++ b/drivers/nvdimm/bus.c
> @@ -271,7 +271,7 @@ EXPORT_SYMBOL_GPL(nvdimm_clear_poison);
>  
>  static int nvdimm_bus_match(struct device *dev, struct device_driver *drv);
>  
> -static struct bus_type nvdimm_bus_type = {
> +static const struct bus_type nvdimm_bus_type = {
>  	.name = "nd",
>  	.uevent = nvdimm_bus_uevent,
>  	.match = nvdimm_bus_match,
> 
> ---
> base-commit: a085a5eb6594a3ebe5c275e9c2c2d341f686c23c
> change-id: 20240204-bus_cleanup-nvdimm-91771693bd4d
> 
> Best regards,
