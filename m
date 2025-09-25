Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5FE2F616B
	for <nvdimm@lists.linux.dev>; Thu, 25 Sep 2025 15:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758814960; cv=none; b=ELZR13AsMnYyBvamgKpnnOXe4QR9XOVtepuzOsOD3JXp1dl7j+hDgPnlWZtAHAT7WEOOGx8YmYno30iG7TrHNWIh1nglFjBz1vat++pGYZL1tw5YD3EFwVQj/JxIrqEZpXEaNQeKzskiwuoKuCMdnq5CDcP6F+wsJRixs9JRDaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758814960; c=relaxed/simple;
	bh=zAshN5MQhCfCiqJfQH/7+ldxT+9aJlQx1Yjp0SzcDrc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Bf6zHkQe479KoO06Q/Tbt7yZJRhmbV97qFTSS8bBUsDAdH3Zwj8uncarPTW6I1PwEt56MSnuH9nkteVnE5TmeJoizuWj6/yHE7Cn4XqcPVdUwS/gHFfZLH0lulCuYB9/9Bzj8THG0/sSp3jgG/O2IMsoX3VHMqHStb+8HU87AAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cq2+nm14; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cq2+nm14"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758814957; x=1790350957;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zAshN5MQhCfCiqJfQH/7+ldxT+9aJlQx1Yjp0SzcDrc=;
  b=cq2+nm14C+06FYOyDUvPcNUBDIQePEbVjloaFFuA8jUPHpivCHH8gFIp
   0iayHPdhGFpqm3r6bdJxofWz0vvJmGCxLbp3koP1URmZvYoTCoZhfpMY5
   pO4CJBs9DLaS/7lvlIGz3RRByqd0HroV0RT5mMQ67mRavGZ+SIGE2hcda
   KPbXNb4Gkqbr0vqTaNxrio7dOyb4xR1L7DxdH8QRNhk6bxg7rg2U82Z2w
   pYFoZClnbRGYPV2Pta8DBl/JjOU6PVblQ/+Uw+HsUKSY8Ei3GgWkaGpXP
   5RGuq4wwAIuH1pvkgnx6nOQt/gMyDuxWQIipKECxONlSybeDIUfBsQiU2
   g==;
X-CSE-ConnectionGUID: OmLkiFo3SvW8yIyfmlv62A==
X-CSE-MsgGUID: UsoXcyriQnuAPqLb+aUqHQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11564"; a="72497646"
X-IronPort-AV: E=Sophos;i="6.18,292,1751266800"; 
   d="scan'208";a="72497646"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 08:42:37 -0700
X-CSE-ConnectionGUID: 4KT5oj8URKqBC9x+Zusp4w==
X-CSE-MsgGUID: eioQlEVTQyecGRlQ8I911A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,292,1751266800"; 
   d="scan'208";a="176943380"
Received: from gabaabhi-mobl2.amr.corp.intel.com (HELO [10.125.109.4]) ([10.125.109.4])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 08:42:35 -0700
Message-ID: <80ece48b-9cc9-4043-a466-fce1796c1946@intel.com>
Date: Thu, 25 Sep 2025 08:42:34 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] nvdimm: ndtest: Return -ENOMEM if devm_kcalloc() fails
 in ndtest_probe()
To: Guangshuo Li <lgs201920130244@gmail.com>,
 Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
 Santosh Sivaraj <santosh@fossix.org>, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
References: <20250925064448.1908583-1-lgs201920130244@gmail.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20250925064448.1908583-1-lgs201920130244@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/24/25 11:44 PM, Guangshuo Li wrote:
> devm_kcalloc() may fail. ndtest_probe() allocates three DMA address
> arrays (dcr_dma, label_dma, dimm_dma) and later unconditionally uses
> them in ndtest_nvdimm_init(), which can lead to a NULL pointer
> dereference under low-memory conditions.
> 
> Check all three allocations and return -ENOMEM if any allocation fails,
> jumping to the common error path. Do not emit an extra error message
> since the allocator already warns on allocation failure.
> 
> Fixes: 9399ab61ad82 ("ndtest: Add dimms to the two buses")
> Cc: stable@vger.kernel.org
> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
> changelog:
> v3:
> - Add NULL checks for all three devm_kcalloc() calls and goto the common
>   error label on failure.
> 
> v2:
> - Drop pr_err() on allocation failure; only NULL-check and return -ENOMEM.
> - No other changes.
> ---
>  tools/testing/nvdimm/test/ndtest.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/nvdimm/test/ndtest.c b/tools/testing/nvdimm/test/ndtest.c
> index 68a064ce598c..8e3b6be53839 100644
> --- a/tools/testing/nvdimm/test/ndtest.c
> +++ b/tools/testing/nvdimm/test/ndtest.c
> @@ -850,11 +850,22 @@ static int ndtest_probe(struct platform_device *pdev)
>  
>  	p->dcr_dma = devm_kcalloc(&p->pdev.dev, NUM_DCR,
>  				 sizeof(dma_addr_t), GFP_KERNEL);
> +	if (!p->dcr_dma) {
> +		rc = -ENOMEM;
> +		goto err;
> +	}
>  	p->label_dma = devm_kcalloc(&p->pdev.dev, NUM_DCR,
>  				   sizeof(dma_addr_t), GFP_KERNEL);
> +	if (!p->label_dma) {
> +		rc = -ENOMEM;
> +		goto err;
> +	}
>  	p->dimm_dma = devm_kcalloc(&p->pdev.dev, NUM_DCR,
>  				  sizeof(dma_addr_t), GFP_KERNEL);
> -
> +	if (!p->dimm_dma) {
> +		rc = -ENOMEM;
> +		goto err;
> +	}
>  	rc = ndtest_nvdimm_init(p);
>  	if (rc)
>  		goto err;

