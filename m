Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD821D54FA
	for <nvdimm@lists.linux.dev>; Thu, 23 Jan 2025 23:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737675806; cv=none; b=WEWKG3ufpP3SDhJVSYzM/DNGZKb+VAlkMYAD2AeeO/gqC8mTjLvIl11FSaBH8YGtkP/hO/6CsDRk3P2vtCET8naTh86XPifTJFBZfC7RtbokdU9bSS0BJPBStT8RAWh1Fag4d2PF0u1h+LcK+ZUCQSqB3bifZDIdLN9jgcmmYn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737675806; c=relaxed/simple;
	bh=pd8v4DJXn+nrkFcg3+sLe00ManGxlnYRoHhRl4IITgs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gjrdksXMyREvZenCYkH+oiX4xSODIJ+5JXWA5V2jN8kmu7++JFLBtMHazabx/qcIJhw4i0fJk7cwibpX+pNmtA0DqgNYAZKIms67k6ljjEQ5P25BDmVE1aBUkpgRX/ovhfZ9IbJPnIaRbFcoVd6n+zfbyYC5+rtEppG/EEZsZiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UPKMXy4K; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UPKMXy4K"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737675804; x=1769211804;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=pd8v4DJXn+nrkFcg3+sLe00ManGxlnYRoHhRl4IITgs=;
  b=UPKMXy4Kk632SRXwhGJSYEDV9+xmDDNcvazIXjRvraU+xRyClO71wLIe
   Fi1aqE73GvKgWnhU0CHUlx48DA0EgAdwhXM4BtUaFuz9/DeQmVQopKBZY
   IYRfxAtkdarxtHeOAJwRw2TDpi5DEUGu9LbZPm9NdltR6F2L3NJTzCQhR
   fFVJhXS1M8GuxzZu6Cjw9I6zXj6PaiVTJ7TheG3CbOB9kXlsLvzWpTgHB
   LxjAiN7PAzHS1ZmMNw2fvb/jqZ8tJqTq5xnofi7F720Zc0HZbGSKBjkLF
   hTw0kqVvatenCbKOU7M31oqHyOITbLAnAOP8QMcia5xDjPDfHhdkjJK0y
   w==;
X-CSE-ConnectionGUID: ZnfocR2ETFm1xdIA+EXhcg==
X-CSE-MsgGUID: 9as6i+CGRnGpoh+RbS0CBA==
X-IronPort-AV: E=McAfee;i="6700,10204,11324"; a="41869752"
X-IronPort-AV: E=Sophos;i="6.13,229,1732608000"; 
   d="scan'208";a="41869752"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2025 15:43:24 -0800
X-CSE-ConnectionGUID: JJN88XbhS7G6dqcCUx695g==
X-CSE-MsgGUID: J+j8P9r4TLy8qsDDg4I4zA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,229,1732608000"; 
   d="scan'208";a="107426311"
Received: from agladkov-desk.ger.corp.intel.com (HELO [10.125.110.229]) ([10.125.110.229])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2025 15:43:23 -0800
Message-ID: <649ed1bb-0686-42f0-802f-9f1909aeed8c@intel.com>
Date: Thu, 23 Jan 2025 16:43:21 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] acpi: nfit: fix narrowing conversion in acpi_nfit_ctl
To: Murad Masimov <m.masimov@mt-integration.ru>,
 Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Len Brown <lenb@kernel.org>,
 nvdimm@lists.linux.dev, linux-acpi@vger.kernel.org,
 linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org,
 stable@vger.kernel.org, syzbot+c80d8dc0d9fa81a3cd8c@syzkaller.appspotmail.com
References: <20250123163945.251-1-m.masimov@mt-integration.ru>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20250123163945.251-1-m.masimov@mt-integration.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/23/25 9:39 AM, Murad Masimov wrote:
> Syzkaller has reported a warning in to_nfit_bus_uuid(): "only secondary
> bus families can be translated". This warning is emited if the argument
> is equal to NVDIMM_BUS_FAMILY_NFIT == 0. Function acpi_nfit_ctl() first
> verifies that a user-provided value call_pkg->nd_family of type u64 is
> not equal to 0. Then the value is converted to int, and only after that
> is compared to NVDIMM_BUS_FAMILY_MAX. This can lead to passing an invalid
> argument to acpi_nfit_ctl(), if call_pkg->nd_family is non-zero, while
> the lower 32 bits are zero.
> 
> All checks of the input value should be applied to the original variable
> call_pkg->nd_family.
> 
> Found by Linux Verification Center (linuxtesting.org) with Syzkaller.
> 
> Fixes: 6450ddbd5d8e ("ACPI: NFIT: Define runtime firmware activation commands")
> Cc: stable@vger.kernel.org
> Reported-by: syzbot+c80d8dc0d9fa81a3cd8c@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=c80d8dc0d9fa81a3cd8c
> Signed-off-by: Murad Masimov <m.masimov@mt-integration.ru>

While the change logically makes sense, the likelihood of nd_family > int_size is not ever likely. Given that NVDIMM_BUS_FAMILY_MAX is defined as 1, I don't think we care about values greater than that regardless of what is set in the upper 32bit of the u64. I'm leaning towards the fix is unnecessary.   

> ---
>  drivers/acpi/nfit/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index a5d47819b3a4..ae035b93da08 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -485,7 +485,7 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
>  		cmd_mask = nd_desc->cmd_mask;
>  		if (cmd == ND_CMD_CALL && call_pkg->nd_family) {
>  			family = call_pkg->nd_family;
> -			if (family > NVDIMM_BUS_FAMILY_MAX ||
> +			if (call_pkg->nd_family > NVDIMM_BUS_FAMILY_MAX ||
>  			    !test_bit(family, &nd_desc->bus_family_mask))
>  				return -EINVAL;
>  			family = array_index_nospec(family,
> --
> 2.39.2
> 

