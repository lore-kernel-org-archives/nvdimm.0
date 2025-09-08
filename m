Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAAA97E107
	for <nvdimm@lists.linux.dev>; Mon,  8 Sep 2025 17:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757353682; cv=none; b=kZKfYmHK+nWdfAHYEpnpw+vIWNTOOLOVV09x04Wj7aNhav6m2dj0Psn64sy1qIPk3hOaQlbEi4nvOeL2DweTQKX9ZDJn+DyfmfjXzojAZU138UUnr7BpvOLwDuRFcbrHc53/gLy1Q0vp0uaIyp0hbsyksJf3C/k6ekCEY9FIl1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757353682; c=relaxed/simple;
	bh=P2T4j9MHYmvjZjVfLPw5l7tL8Soz3DvJFtuIN19StHM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PnO2HRvo3+ltSW8NhkqbC1aZBBlW8Qmc0CXvE/30PbVcQKbQycY1NyIWzmgA6R68ZbXRvXtSOv4ppqSR5VEUKZbnHt81n6J2Nlk3Mx40CT5sEQ452BFp/dpLOejNjaufzd9CM8AuEmgfd5djyP+FpeB0YPCras2xQoxHI20rRbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IuW02gwl; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IuW02gwl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757353681; x=1788889681;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=P2T4j9MHYmvjZjVfLPw5l7tL8Soz3DvJFtuIN19StHM=;
  b=IuW02gwlc96P4JIB6Hek8nbY6OEuBMLTU5svZyRSjKtGCUAs6u9CoIlc
   HTYrBPblO0Ggm1MjyIkaUMv5H9qeJJgMlBzjZFhNd9jjHufISlm/EIt2Z
   tbQfiZ8Qh/JLKM5E2RjnHdD/3pmsa0UIiitOhgYg3LEJ8q8zvbOODjU+U
   gj74M1fBDph+xaCpHWyxtZmHxo6GSMOH9RCTjPFw1CjWBbrRcU9TUGNUo
   82xYPeWoom560ajrxQ1X/bI1thCFXcW8ddZaFUV+iqI642/sTvuBgazVP
   MxVbLKpukKhQsc56jwbOEe34L5eVMpMOKKA5ki8H7xyKJW6NzCd6RFOrq
   g==;
X-CSE-ConnectionGUID: 1pH6NDH0Qp+8vehv0VEE4w==
X-CSE-MsgGUID: vIBMW08XSBCcG5+dpGYBYw==
X-IronPort-AV: E=McAfee;i="6800,10657,11547"; a="70719880"
X-IronPort-AV: E=Sophos;i="6.18,249,1751266800"; 
   d="scan'208";a="70719880"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2025 10:48:00 -0700
X-CSE-ConnectionGUID: 4/IJXoazQJGVgbzNIZL56w==
X-CSE-MsgGUID: 7K2zeK6GSS+MHIcdirOQNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,249,1751266800"; 
   d="scan'208";a="172021269"
Received: from vverma7-desk1.amr.corp.intel.com (HELO [10.125.110.113]) ([10.125.110.113])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2025 10:48:00 -0700
Message-ID: <46992d97-e803-4d7e-b951-1a2a9d1b6987@intel.com>
Date: Mon, 8 Sep 2025 10:47:59 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next] ndtest: Fix incorrect handling for return value of
 device_create_with_groups.
To: Lin Yujun <linyujun809@h-partners.com>, dan.j.williams@intel.com,
 vishal.l.verma@intel.com, ira.weiny@intel.com, santosh@fossix.org
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20250908122331.1315530-1-linyujun809@h-partners.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20250908122331.1315530-1-linyujun809@h-partners.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/8/25 5:23 AM, Lin Yujun wrote:
> The return value of device_create_with_groups will not
> be an null pointer, use IS_ERR() to fix incorrect handling
> return value of device_create_with_groups.
> 
> Fixes: 9399ab61ad82 ("ndtest: Add dimms to the two buses")
> Signed-off-by: Lin Yujun <linyujun809@h-partners.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  tools/testing/nvdimm/test/ndtest.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/nvdimm/test/ndtest.c b/tools/testing/nvdimm/test/ndtest.c
> index 68a064ce598c..7d722f2f7d62 100644
> --- a/tools/testing/nvdimm/test/ndtest.c
> +++ b/tools/testing/nvdimm/test/ndtest.c
> @@ -745,11 +745,11 @@ static int ndtest_dimm_register(struct ndtest_priv *priv,
>  
>  	dimm->dev = device_create_with_groups(&ndtest_dimm_class,
>  					     &priv->pdev.dev,
>  					     0, dimm, dimm_attribute_groups,
>  					     "test_dimm%d", id);
> -	if (!dimm->dev) {
> +	if (IS_ERR(dimm->dev)) {
>  		pr_err("Could not create dimm device attributes\n");
>  		return -ENOMEM;
>  	}
>  
>  	return 0;

