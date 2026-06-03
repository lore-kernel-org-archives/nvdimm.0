Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C633B3BE7
	for <nvdimm@lists.linux.dev>; Wed,  3 Jun 2026 23:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780528060; cv=none; b=Dt5ggidElqk6kgm1yQWYmPV+LYt0ygxtvgz0o1gi5Vc6oMzKAuWDwGlRjLPwmLRmzB2ZlzbHbfIM1U17JvbTxeY15ASJtdAqJe1aZYKswEwtyoGlyNGVORxqx+/iva3FwluXwyjEuDBKnwQaPv1Eq1umNNEFsGZ/LR6WIotCIsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780528060; c=relaxed/simple;
	bh=bhyl+Ajbr28WxhXEGBrhy4nFysfcdjKDurnstTUhQTg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aApCSsg6HPmdMO/HBMs1yGQ0UpmmcAfZZl3Xq6bS9vpsR3vaGjKxkgtP2iDODSJTf75rGVyAkIIKEjNWP9X5Suhd3MfHs295wm3L1RscyyAeBkTR0xbJc2yd/u7WloXF41GzBxoCowozEHlh0NJ7csUEDthqth9pLFeGQQC4C4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PH01pWna; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PH01pWna"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780528060; x=1812064060;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=bhyl+Ajbr28WxhXEGBrhy4nFysfcdjKDurnstTUhQTg=;
  b=PH01pWnaF4LA21/1Vp0lMOKHu+7TWvTznXo56Zay51VmEtkjkicleb1S
   wjGXc9y4+L+U/vk22+XxnRr/LJThc4R1CQ8PyIsbds1qXPlfMEQiAHNj2
   pf+fHK+QPMAgJJNbkPykk/kzQmBbtev04Zctp2u7Hx1yRbRiqJftYQHyJ
   F0BOF4tStKIw1SagSF1O+qa8Feew9Sb4hbGCd63nhN4G+0Jv3cSEkMUdH
   BluukQkgDjDwRFsVteQS58zG3/MRhNKKoaEmu+AbT3G0SET1fmcdMW1WI
   J7lsbDcC2kwf31YONp6KmHXBGHkrFw6wb3PP3/BT1ke52XMUanD1ZilJ3
   Q==;
X-CSE-ConnectionGUID: 8YUFbkz3Tv2m4/C4WnlSJA==
X-CSE-MsgGUID: EQGcVWt3RzKbcrxK+31ZAQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11806"; a="92835031"
X-IronPort-AV: E=Sophos;i="6.24,186,1774335600"; 
   d="scan'208";a="92835031"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2026 16:07:40 -0700
X-CSE-ConnectionGUID: YYKj5LuERKKKBTqU/vayWg==
X-CSE-MsgGUID: GI7BVHURQRKkZmFD9aizDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,186,1774335600"; 
   d="scan'208";a="244457813"
Received: from dnelso2-mobl.amr.corp.intel.com (HELO [10.125.108.116]) ([10.125.108.116])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2026 16:07:37 -0700
Message-ID: <1909af0f-8f06-4555-a5f5-f309ee60fcfa@intel.com>
Date: Wed, 3 Jun 2026 16:07:35 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] ACPI: NFIT: core: Eliminate redundant local
 variable
To: "Rafael J. Wysocki" <rafael@kernel.org>,
 Linux ACPI <linux-acpi@vger.kernel.org>
Cc: Dan Williams <djbw@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev,
 Alison Schofield <alison.schofield@intel.com>,
 Xiang Chen <chenxiang66@hisilicon.com>
References: <5110904.31r3eYUQgx@rafael.j.wysocki>
 <14028918.uLZWGnKmhe@rafael.j.wysocki>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <14028918.uLZWGnKmhe@rafael.j.wysocki>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/3/26 10:57 AM, Rafael J. Wysocki wrote:
> From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
> 
> Eliminate local variable acpi_desc from __acpi_nvdimm_notify() because it
> is redundant (its value is only checked against NULL once and the value
> assigned to it may be checked directly instead) and update the subsequent
> comment to reflect the code change.
> 
> No functional impact.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>


> ---
>  drivers/acpi/nfit/core.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index 01c73be0bd00..aaa84ae7a20e 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -1680,7 +1680,6 @@ static struct nvdimm *acpi_nfit_dimm_by_handle(struct acpi_nfit_desc *acpi_desc,
>  void __acpi_nvdimm_notify(struct device *dev, u32 event)
>  {
>  	struct nfit_mem *nfit_mem;
> -	struct acpi_nfit_desc *acpi_desc;
>  
>  	dev_dbg(dev->parent, "%s: event: %d\n", dev_name(dev),
>  			event);
> @@ -1691,12 +1690,11 @@ void __acpi_nvdimm_notify(struct device *dev, u32 event)
>  		return;
>  	}
>  
> -	acpi_desc = dev_get_drvdata(dev->parent);
> -	if (!acpi_desc)
> +	if (!dev_get_drvdata(dev->parent))
>  		return;
>  
>  	/*
> -	 * If we successfully retrieved acpi_desc, then we know nfit_mem data
> +	 * If the parent's driver data pointer is not NULL, then nfit_mem data
>  	 * is still valid.
>  	 */
>  	nfit_mem = dev_get_drvdata(dev);

