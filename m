Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6E445BF3
	for <nvdimm@lists.linux.dev>; Mon, 12 Feb 2024 16:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707756153; cv=none; b=ETitBSo3hdf0791gpjNU8dTM/gYkf0wFmE+VGsaT0kyNwijVVbxMrIbfDx5VX7WxjpdMd3sluarpY66txJTkjPvyGJfDS0wuTn4AWgdA7z0xKHsnaJVljY14hC5iRLZIgN0VwE0XmqB+25FwFs3KYOHQlzw9bzjsnmnOIfaiDII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707756153; c=relaxed/simple;
	bh=xWu8Ts79oCegqLP29lx5JJyYqTZoINAb7MnXNROppnE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=AZnDi7e6L7pds4KbOIVwyaEupJr9HJQUl3FV4ZWd32LIZUf9712sgY+ia6K9Zad0vqs/G4PmrmdanfDsu+Do+KBW7Sa7kaDiC7JkYGK9sQR4ijj3JTdLUM6H4xoXa2MfCsuzuH6GpaVkHHx+Wk5Yu/IR5tDcOMGeMAv0LeYSIpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iVjXNg8S; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iVjXNg8S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707756152; x=1739292152;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=xWu8Ts79oCegqLP29lx5JJyYqTZoINAb7MnXNROppnE=;
  b=iVjXNg8SlSpIfzbGoQNKChwfNsfbL0QdQEtxGkMqZtSy98PUJrdZjA8G
   1gb1OsZ/Y0NLdGAXrWiUt9IJMT+xkPJTuQKH106lYbqLxVYg4/YJonFI5
   ny+d9A6vTr5bSsIuDtFclNP9+B1pcbUrkWaX3iueWvlji1ALFbDrN5rw5
   sj50IRhbvln44T5Ko5r+AB+Ykra7xuMjzJkzzrUODJ8Ug//czE9TU3vFV
   Wyqbu4bYq09q8A+FendginWX3L8SFA2f0mtKineL4SG2EeKuqwm9H4e2c
   5Mu4OGd1FAY/C0oR/wFXWo9uknN6iWR8RldlLH7erfey+LW0Sg81QTEzO
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10982"; a="5514397"
X-IronPort-AV: E=Sophos;i="6.06,264,1705392000"; 
   d="scan'208";a="5514397"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2024 08:42:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10982"; a="825853451"
X-IronPort-AV: E=Sophos;i="6.06,264,1705392000"; 
   d="scan'208";a="825853451"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.246.113.42]) ([10.246.113.42])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2024 08:42:18 -0800
Message-ID: <5eb8e451-1d07-440e-943c-795b30621b5f@intel.com>
Date: Mon, 12 Feb 2024 09:42:17 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] libnvdimm: Fix ACPI_NFIT in BLK_DEV_PMEM help
Content-Language: en-US
To: Peter Robinson <pbrobinson@gmail.com>,
 Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
 nvdimm@lists.linux.dev
References: <20240212123716.795996-1-pbrobinson@gmail.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20240212123716.795996-1-pbrobinson@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2/12/24 5:37 AM, Peter Robinson wrote:
> The ACPI_NFIT config option is described incorrectly as the
> inverse NFIT_ACPI, which doesn't exist, so update the help
> to the actual config option.
> 
> Fixes: 18da2c9ee41a0 ("libnvdimm, pmem: move pmem to drivers/nvdimm/")

Given this is only text correction and not a code bug, there's no need to backport the change with a Fixes tag. Otherwise looks good. 

> Signed-off-by: Peter Robinson <pbrobinson@gmail.com>
> ---
>  drivers/nvdimm/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/nvdimm/Kconfig b/drivers/nvdimm/Kconfig
> index 77b06d54cc62e..fde3e17c836c8 100644
> --- a/drivers/nvdimm/Kconfig
> +++ b/drivers/nvdimm/Kconfig
> @@ -24,7 +24,7 @@ config BLK_DEV_PMEM
>  	select ND_PFN if NVDIMM_PFN
>  	help
>  	  Memory ranges for PMEM are described by either an NFIT
> -	  (NVDIMM Firmware Interface Table, see CONFIG_NFIT_ACPI), a
> +	  (NVDIMM Firmware Interface Table, see CONFIG_ACPI_NFIT), a
>  	  non-standard OEM-specific E820 memory type (type-12, see
>  	  CONFIG_X86_PMEM_LEGACY), or it is manually specified by the
>  	  'memmap=nn[KMG]!ss[KMG]' kernel command line (see
