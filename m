Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1EC2773D5
	for <nvdimm@lists.linux.dev>; Wed, 27 Aug 2025 18:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756318154; cv=none; b=SygJSZLSno+V4g/jkoSDrUiBy7cFQYbUSLbUbp3+o/cIJbEI6vx9JeFWfK9/COQqAUz1Iib+CHGYJ0gkZH8BrhvozwDEPES6PPtus1xT6XfC1IMAHE0wLGYx7/lePHQBnqU6wSGVQoOtBT/rN2KiRjPop7H/aNVt0qNJWM2bnyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756318154; c=relaxed/simple;
	bh=xXLFaEOa7kNU5nCuyofgXlecYFrck7qrhKPmkUvct2k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cWYh/kGJVFFLkYmSiLAaxXTA4NPCIR89Znvn+eVT7g/6IAAfGuMYDP/VuYtE48aaAyj0xDzy+x4LSN/TIQXd49LWBuUu9M0hIwyeCOJh0LknarM/+VHCxxXJluZyX1E/+jdLEuR5e1exihwUvLNw3Ohpso28GyqE7qDjZO+Bj3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L0BWlagE; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L0BWlagE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756318153; x=1787854153;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xXLFaEOa7kNU5nCuyofgXlecYFrck7qrhKPmkUvct2k=;
  b=L0BWlagEYMSp2XQuDAT1N0iLQ+dcvMphBaYjb8AHpOYPYsi/dVeoBwzG
   HMrIQOf672couu79Ek3YStdU1jrb3sWaaJMcHv/Fh0pYQd82T3Gc4DLSc
   XfvKDg+L8Er+nlDO8GFkzAHfV7yBhOnlwbkuuvSnrlR//9TWD2TXuz3Lc
   Ag2Rnz63dej4znp7qi3n0gMvG64tlEBig6r07SNq8xEnttwDfWj3sCrBo
   KM9nvv2fc9DDsC008h7b7sTKtihxVp++jPZ3HGFM9MoXzuM1EGzTpNm5/
   FAUu9v5nnxx5QuZXjHlakX7fPLmGbn2pvOrEPIVFIJYyWGo1Ty3CSqFpK
   w==;
X-CSE-ConnectionGUID: 2PmOwpD8Qfe7AqYX83WfsA==
X-CSE-MsgGUID: 1y8VImkkSI2gNZmiOp0Tyg==
X-IronPort-AV: E=McAfee;i="6800,10657,11535"; a="58645699"
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="58645699"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 11:09:12 -0700
X-CSE-ConnectionGUID: jZEGCfkbTk+hVnHXSxvFfg==
X-CSE-MsgGUID: 1RzOjyvXRqiP48PSA+9qAw==
X-ExtLoop1: 1
Received: from anmitta2-mobl4.gar.corp.intel.com (HELO [10.247.118.29]) ([10.247.118.29])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 11:09:08 -0700
Message-ID: <d3cd8520-4727-4275-8a61-0dc631109378@intel.com>
Date: Wed, 27 Aug 2025 11:09:03 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] nvdimm: Use str_plural() to simplify the code
To: Xichao Zhao <zhao.xichao@vivo.com>, dan.j.williams@intel.com,
 vishal.l.verma@intel.com, ira.weiny@intel.com
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20250827021325.61145-1-zhao.xichao@vivo.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20250827021325.61145-1-zhao.xichao@vivo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/26/25 7:13 PM, Xichao Zhao wrote:
> Use the string choice helper function str_plural() to simplify the code.
> 
> Signed-off-by: Xichao Zhao <zhao.xichao@vivo.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/nvdimm/namespace_devs.c | 2 +-
>  drivers/nvdimm/region.c         | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
> index 55cfbf1e0a95..507dcae9dac0 100644
> --- a/drivers/nvdimm/namespace_devs.c
> +++ b/drivers/nvdimm/namespace_devs.c
> @@ -1983,7 +1983,7 @@ static struct device **scan_labels(struct nd_region *nd_region)
>  	}
>  
>  	dev_dbg(&nd_region->dev, "discovered %d namespace%s\n", count,
> -		count == 1 ? "" : "s");
> +		str_plural(count));
>  
>  	if (count == 0) {
>  		struct nd_namespace_pmem *nspm;
> diff --git a/drivers/nvdimm/region.c b/drivers/nvdimm/region.c
> index 88dc062af5f8..68a26002f8b9 100644
> --- a/drivers/nvdimm/region.c
> +++ b/drivers/nvdimm/region.c
> @@ -70,7 +70,7 @@ static int nd_region_probe(struct device *dev)
>  	 * "<async-registered>/<total>" namespace count.
>  	 */
>  	dev_err(dev, "failed to register %d namespace%s, continuing...\n",
> -			err, err == 1 ? "" : "s");
> +			err, str_plural(err));
>  	return 0;
>  }
>  

