Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E5E386567
	for <nvdimm@lists.linux.dev>; Mon,  6 Apr 2026 15:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775488988; cv=none; b=KiUPN5s0pEcQ7pLkH469xaz3wPmxma3STbyvqie0EIHNZxDv+R2oMNN0jeiL53+ZtKrsYtQO2sQjFjLV0jH1DM1miKh5w8mRUO4UO1x3iVOsSVaXo80UkI7Wf/9peUBvxuks9q1b7qnFzvHmnLDOiG/HtIwzEWgaqr9kKVtBjFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775488988; c=relaxed/simple;
	bh=OF3T7kOHsAv+/pqgPJGjBB6vE6drDLM1ebeXZGmLODs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FKaFh/Z9pHfkfNiy7ASuWrkJGxV2uedKnSVLh8hoBffxMQfNwbbeZ7/fbdghYVPU24RPSo10Qu8e2BUl+B8/i7OnIz/5OACSo06kzsBUJHFJlXTluJmufHjTlkLrZ3IqBAPRjNHgA7FhSAWBoruI1UI40LzJcIlC1hs52JmNiww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TeCqJYom; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TeCqJYom"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775488986; x=1807024986;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OF3T7kOHsAv+/pqgPJGjBB6vE6drDLM1ebeXZGmLODs=;
  b=TeCqJYomED/2iDCCTXsMtlF7eeeU/2q+YookymnNY8eM/W9ZTiwUkHvE
   Ii0rDmbNL/ccxNe8MmnRnc9gG5fw+IA8mBZ05ldl/afZCzhRS/ojWiq/l
   LpKO9mndUBGJl8SAnullgYK2q3HvPY3GtvuVME97N9N7fjwTNqr/lSOJj
   O+wFr6r12KQTifjG9+xLX0hA/mWqMnKHZHvP8OwUDg/1TWc3zwyWWYmm8
   O70di5JwaIZB1VOWEMsNcDnYyHTuft1NGhGyQ/M3CKLdjSr7GycICz470
   cRAUxHr/vSNslq+Q0FmW+Q8unGq3yV5bEKC+umDjTpgkEOIs2bpy5rZc5
   g==;
X-CSE-ConnectionGUID: xSRNLhGuSuie+xv1OAvsoQ==
X-CSE-MsgGUID: pfaY7qFQQzi5zVrcOgfLuQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11750"; a="99060188"
X-IronPort-AV: E=Sophos;i="6.23,163,1770624000"; 
   d="scan'208";a="99060188"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2026 08:23:05 -0700
X-CSE-ConnectionGUID: gt7bWEVLRBO7z21KnWycJQ==
X-CSE-MsgGUID: bIcbSnfFRdqzfZTRwUBcUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,163,1770624000"; 
   d="scan'208";a="251180919"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO [10.125.108.81]) ([10.125.108.81])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2026 08:23:04 -0700
Message-ID: <fb8dbdce-36a3-40a3-8f01-09e59b4fbfc2@intel.com>
Date: Mon, 6 Apr 2026 08:23:03 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] drivers/dax: Fix typo in comment
To: Yahu YH12 Gao <gaoyh12@lenovo.com>,
 Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
References: <OSNPR03MB95389421960C592713DD923FDF5CA@OSNPR03MB9538.apcprd03.prod.outlook.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <OSNPR03MB95389421960C592713DD923FDF5CA@OSNPR03MB9538.apcprd03.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/4/26 8:19 PM, Yahu YH12 Gao wrote:
> Fix a typo in dax_copy_to_iter where "vfs_red" should be "vfs_read".
> 
> Signed-off-by: Yahu Gao mailto:gaoyh12@lenovo.com

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> 
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index c00b9dff4a06..e32db0eba9c1 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -192,7 +192,7 @@ size_t dax_copy_to_iter(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
> 
>         /*
>          * The userspace address for the memory copy has already been validated
> -        * via access_ok() in vfs_red, so use the 'no check' version to bypass
> +        * via access_ok() in vfs_read, so use the 'no check' version to bypass
>          * the HARDENED_USERCOPY overhead.
>          */
>         if (test_bit(DAXDEV_NOMC, &dax_dev->flags))
> --
> 2.47.3
> 

