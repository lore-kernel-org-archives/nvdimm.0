Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B660451C331
	for <nvdimm@lists.linux.dev>; Tue, 13 Oct 2026 17:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791911416; cv=none; b=MTU7jJ7m8gE4MppEeW4yEOtZnyM6hRHKpK+b4Lj0ZyB5olU+zKZJQFDGhzJpB/fvT0etdruK1H3Usp3R/nNim0ZCFFnRUXN32nT4kFrsrQQgP1tpzDSk/SP/NpFNaq9lwGWpnZEwSruMzpQIM4NWKJOw2eB2T/nMPl0l8/3Tgvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791911416; c=relaxed/simple;
	bh=31wSxNICfkmal3vU/eprJthAv0OgifKabJQZRPNxV7k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jk2T28pEE7btCu0TH9kynzaIIC+ktSJe7N9kjqlmO4PeMf0sDwjlKUUYCAbCIOrPCp/o/GSF8E9HA3DYh1y9vdkImBpjuLagnJdZE8NQP5Vs76OMBFDp84gXGNyUcv709iEtyg396S1t6apdNVX50mSshStg0xTk0qM+VjlryM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OIW2VPXQ; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OIW2VPXQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791911416; x=1823447416;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=31wSxNICfkmal3vU/eprJthAv0OgifKabJQZRPNxV7k=;
  b=OIW2VPXQwRv0rlDyNyDJNswUyLSy7pd7Q9roc+QyRDCrjSdahYKVD0jN
   i5lNx8zlq+duIDgVqu/Lx3tvKO+XGaPH1OcBgnqOv0fe6iPmzErs7AfHC
   PhHv3Y+a4bNLtkZGu1cWk08rnNnPFpxIxr4ohObhKfezia23LMYujb+Pa
   yr7hsSbLKzCnFkW8nMi/YRVTuXFai3VuX+qD7Q+9JS7xetb7Lef6aPq2+
   vNFhwKFaioWonVElnSlob5Um6cLNKVvCEPaq0kbh8lfyjx6z/RfD/sNDu
   Qr4J4s/e6CVw+mcj8W+nydT2/uvG4MAygI6GZpBWR9TvNeEzuRrQRMyAW
   A==;
X-CSE-ConnectionGUID: 1ShVv6f7R8yaIpKC2Vgedg==
X-CSE-MsgGUID: 8pdYCyjXRlCe0pcDVozDkw==
X-IronPort-AV: E=McAfee;i="6800,10657,11934"; a="739436"
X-IronPort-AV: E=Sophos;i="6.27,156,1787036400"; 
   d="scan'208";a="739436"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2026 10:10:15 -0700
X-CSE-ConnectionGUID: +uj1hekMSVmlGCrwEtJFgA==
X-CSE-MsgGUID: cIZRl4ylRMqq5Fv/h+mL0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,156,1787036400"; 
   d="scan'208";a="1105737"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.109.235]) ([10.125.109.235])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2026 10:10:15 -0700
Message-ID: <e6d4933a-f448-450f-a85f-16d2bb459a50@intel.com>
Date: Tue, 13 Oct 2026 10:10:13 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] dax: fix dax_core_init error return code
To: jianyungao89@gmail.com, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, Dan Williams <djbw@kernel.org>,
 Vishal Verma <vishal.l.verma@intel.com>,
 Alison Schofield <alison.schofield@intel.com>,
 "open list:DEVICE DIRECT ACCESS (DAX)" <nvdimm@lists.linux.dev>,
 "open list:DEVICE DIRECT ACCESS (DAX)" <linux-cxl@vger.kernel.org>
References: <20261012151857.22534-1-jianyungao89@gmail.com>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20261012151857.22534-1-jianyungao89@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/12/26 8:18 AM, jianyungao89@gmail.com wrote:
> From: Jianyun Gao <jianyungao89@gmail.com>
> 
> dax_core_init() mistakenly returns 0 on error paths. Change the
> error return to use rc so the actual error code is propagated
> to the caller.
> 
> Fixes: 9567da0b408a ("device-dax: Introduce bus + driver model")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
> 
> Changes in v2:
> - Drop unnecessary goto label, keep direct return for dax_fs_init() error
> - Add Fixes tag and Cc stable
> 
> Link: https://lore.kernel.org/lkml/20261011132017.31131-1-jianyungao89@gmail.com/ # v1
> 
>  drivers/dax/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index 45f84b0eb909..210f4af479f0 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -738,7 +738,7 @@ static int __init dax_core_init(void)
>  	unregister_chrdev_region(dax_devt, MINORMASK+1);
>  err_chrdev:
>  	dax_fs_exit();
> -	return 0;
> +	return rc;
>  }
>  
>  static void __exit dax_core_exit(void)

