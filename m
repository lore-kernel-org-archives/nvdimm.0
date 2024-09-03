Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB881E492
	for <nvdimm@lists.linux.dev>; Tue,  3 Sep 2024 15:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725378390; cv=none; b=TGsO3zBIoQkHZ0hKSXyI5v/mQj/9nt1oG3F1W6wN+SUtKRGAT7qNAw8DLJyweCNYIbKxm/295xQqPzbFF3KsyU9keM06KscEL7hDTgAoXVmaXvH6Rq4r/RFViampn3J8bdCXmlrlpI3TARjvN9P+lhassEVAGfgOZQ6zk4+OwJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725378390; c=relaxed/simple;
	bh=C9QFPPdIe0/A9Nl9yes6HEH+0w7oqNWy/evt8YjnvHw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bUmcfnOxTc7Yoqeclniu4JiTwvnlT8shbqElNOrdr529SsmBDGf72w2/CG7AZPaI7J9T0GaayjiMiJI8PTXq0CTiJZ9gSw0x2UjHbq+oZtRoTbQ0IutEUfeo808IQLQDtj4SfdI4A0EMfoN81lD+JyN/OCaYBZums74JTR3qqZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JQKZvyn0; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JQKZvyn0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725378388; x=1756914388;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=C9QFPPdIe0/A9Nl9yes6HEH+0w7oqNWy/evt8YjnvHw=;
  b=JQKZvyn0r7/Rc+nRzitJM8pO2cP/ZASmHufE4N8Pl3Qr+oz9yHtkhdmv
   N/0CGVbaZmYZog7Emvexu95KLIR3Lo65QVoMAn+55BsxTlNFJEeo8yNOi
   OdIktj32JSljzKjeW/iiApBC47YGB7RGUMaYU9Wh290RO0P0puA85ihhM
   AOxN/dPIWtNXyueDVIfxNA+kfk++Jg4BW+NEZEb6q7XyjtlXjzDWU+Mvt
   vkqXoNnw76acKcdMay+5RfF3kSBYokAj0e3bJMO+y5F0ne1h2gq3h7oLx
   k0+v1CarLo+LFYYkjku3HqMQ/aIrU1WgxgGF9FSOKiSIm2ue0IFxABFsq
   Q==;
X-CSE-ConnectionGUID: qEW5BKN3SGyVrXE66zGcwA==
X-CSE-MsgGUID: YQG4nFgMTXq/dIVaZQw1tg==
X-IronPort-AV: E=McAfee;i="6700,10204,11184"; a="34596777"
X-IronPort-AV: E=Sophos;i="6.10,199,1719903600"; 
   d="scan'208";a="34596777"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 08:46:26 -0700
X-CSE-ConnectionGUID: hjWXfrmxTAKgaWjjAMGWEQ==
X-CSE-MsgGUID: lYpTn/+1QzC85oitwHVQQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,199,1719903600"; 
   d="scan'208";a="69102429"
Received: from iherna2-mobl4.amr.corp.intel.com (HELO [10.125.109.10]) ([10.125.109.10])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 08:46:26 -0700
Message-ID: <d4de1aae-d622-4041-9b1e-4af039242b14@intel.com>
Date: Tue, 3 Sep 2024 08:46:25 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next] nvdimm: Remove redundant null pointer checks
To: Li Zetao <lizetao1@huawei.com>, dan.j.williams@intel.com,
 vishal.l.verma@intel.com, ira.weiny@intel.com
Cc: nvdimm@lists.linux.dev
References: <20240903143911.2005193-1-lizetao1@huawei.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20240903143911.2005193-1-lizetao1@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/3/24 7:39 AM, Li Zetao wrote:
> Since the debugfs_create_dir() never returns a null pointer, checking
> the return value for a null pointer is redundant, and using IS_ERR is
> safe enough.
> 
> Signed-off-by: Li Zetao <lizetao1@huawei.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/nvdimm/btt.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
> index 423dcd190906..4592c86d5eac 100644
> --- a/drivers/nvdimm/btt.c
> +++ b/drivers/nvdimm/btt.c
> @@ -227,7 +227,7 @@ static void arena_debugfs_init(struct arena_info *a, struct dentry *parent,
>  
>  	snprintf(dirname, 32, "arena%d", idx);
>  	d = debugfs_create_dir(dirname, parent);
> -	if (IS_ERR_OR_NULL(d))
> +	if (IS_ERR(d))
>  		return;
>  	a->debugfs_dir = d;
>  
> @@ -1703,7 +1703,7 @@ static int __init nd_btt_init(void)
>  	int rc = 0;
>  
>  	debugfs_root = debugfs_create_dir("btt", NULL);
> -	if (IS_ERR_OR_NULL(debugfs_root))
> +	if (IS_ERR(debugfs_root))
>  		rc = -ENXIO;
>  
>  	return rc;
