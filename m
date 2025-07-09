Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9E223A9BD
	for <nvdimm@lists.linux.dev>; Wed,  9 Jul 2025 22:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752101882; cv=none; b=IGXSDuuZU8psUxTVNpg2ApHA1KpfaFarDq5pRy/m674oCR89efc1poiNDNswEu9GdRfW4KjZ22f0/PTPzk75psw3X7gGptpXSvXojOaxlTpQwOuazQxpzlIFL3qleq69WU9icGuUZIpDz7ja7ytq/tcLJarDkK/hl/LXXyT2qqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752101882; c=relaxed/simple;
	bh=uk4Ygi3xRp5yMXcD0rsVfOaHfe6B37s589dGCGzojNU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MYm5dsY5N8cyfEP7CDesw1tn8RMg1zJ5XL9c29lY8OJrUtmMpY8RIn9303sI74as5fIoL6gkljWQ3dOJjEakLBtmU8tWaiiwdSmObXJ7jEJGLLzIbgGUk9wH9p8mHEBZH332GDnVV6H7Uj56/IUo5Oxw0nIM+OFGOsCv9Xv+48Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bNG1DTvK; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bNG1DTvK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752101880; x=1783637880;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=uk4Ygi3xRp5yMXcD0rsVfOaHfe6B37s589dGCGzojNU=;
  b=bNG1DTvKSBPqILk2wdfOtosA5gf42xw4zxhuQde97xGEsm6AqFI1+/v4
   nsWen0PsjpTcYn8VRQGum68Z/QtvwvM7t+tuOrkCNZdKnTDveadBpmW3V
   con9+LzuxHc2YSd+Zfv7GZwjhFUJMClP01oKtaHE2ZQQiicZs7cd+gxKz
   no2OJYvu1p9G182kP6NYTtjc2vssSNCmcsXULsppVPHRzc4DisDxj3dYR
   Ku4TW+fJxD3DWmlFXwiCnlo5t9L636RCZPtpEO3J3OKLCX+FAyym2V6qy
   ZIcStK2qEaQxNim7T/Us4f0Uge3Uu1Y2EopSTDddpM3SRHHaaFYFiH3vt
   g==;
X-CSE-ConnectionGUID: tRnTGZkgRKSiiOuOfWyBQQ==
X-CSE-MsgGUID: 9SSOQJCtSCG+7FxaS1CM2g==
X-IronPort-AV: E=McAfee;i="6800,10657,11489"; a="53591169"
X-IronPort-AV: E=Sophos;i="6.16,299,1744095600"; 
   d="scan'208";a="53591169"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 15:57:59 -0700
X-CSE-ConnectionGUID: ygFa/YscT5WobKlvzD5YRw==
X-CSE-MsgGUID: I8fMGIQ7T5ya811xsoR2AA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,299,1744095600"; 
   d="scan'208";a="161558024"
Received: from inaky-mobl1.amr.corp.intel.com (HELO [10.125.110.203]) ([10.125.110.203])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 15:57:58 -0700
Message-ID: <624c255d-d7e2-4ea3-9186-b435499838a7@intel.com>
Date: Wed, 9 Jul 2025 15:57:57 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 01/20] nvdimm/label: Introduce NDD_CXL_LABEL flag to
 set cxl label format
To: Neeraj Kumar <s.neeraj@samsung.com>, dan.j.williams@intel.com,
 dave@stgolabs.net, jonathan.cameron@huawei.com, alison.schofield@intel.com,
 vishal.l.verma@intel.com, ira.weiny@intel.com
Cc: a.manzanares@samsung.com, nifan.cxl@gmail.com, anisa.su@samsung.com,
 vishak.g@samsung.com, krish.reddy@samsung.com, arun.george@samsung.com,
 alok.rathore@samsung.com, neeraj.kernel@gmail.com,
 linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, gost.dev@samsung.com, cpgs@samsung.com
References: <20250617123944.78345-1-s.neeraj@samsung.com>
 <CGME20250617124008epcas5p2e702f786645d44ceb1cdd980a914ce8e@epcas5p2.samsung.com>
 <158453976.61750165203630.JavaMail.epsvc@epcpadp1new>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <158453976.61750165203630.JavaMail.epsvc@epcpadp1new>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/17/25 5:39 AM, Neeraj Kumar wrote:
> NDD_CXL_LABEL is introduced to set cxl LSA 2.1 label format
> Accordingly updated label index version

Maybe add the spec reference that defines label 2.1 format
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
> ---
>  drivers/nvdimm/dimm.c      |  1 +
>  drivers/nvdimm/dimm_devs.c | 10 ++++++++++
>  drivers/nvdimm/label.c     | 16 ++++++++++++----
>  drivers/nvdimm/nd.h        |  1 +
>  include/linux/libnvdimm.h  |  3 +++
>  5 files changed, 27 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/nvdimm/dimm.c b/drivers/nvdimm/dimm.c
> index 91d9163ee303..8753b5cd91cc 100644
> --- a/drivers/nvdimm/dimm.c
> +++ b/drivers/nvdimm/dimm.c
> @@ -62,6 +62,7 @@ static int nvdimm_probe(struct device *dev)
>  	if (rc < 0)
>  		dev_dbg(dev, "failed to unlock dimm: %d\n", rc);
>  
> +	ndd->cxl = nvdimm_check_cxl_label_format(ndd->dev);
>  
>  	/*
>  	 * EACCES failures reading the namespace label-area-properties
> diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
> index 21498d461fde..e8f545f889fd 100644
> --- a/drivers/nvdimm/dimm_devs.c
> +++ b/drivers/nvdimm/dimm_devs.c
> @@ -18,6 +18,16 @@
>  
>  static DEFINE_IDA(dimm_ida);
>  
> +bool nvdimm_check_cxl_label_format(struct device *dev)
> +{
> +	struct nvdimm *nvdimm = to_nvdimm(dev);
> +
> +	if (test_bit(NDD_CXL_LABEL, &nvdimm->flags))
> +		return true;
> +
> +	return false;
> +}

I think we may want to move the checking of the flag to where the patch also set the flag in order to provide a more coherent review experience. Given that I haven't read the rest of the patchset and don't know how NDD_CXL_LABEL is set, I really can't comment on whether there's a better way to detect LSA 2.1 labels. Is there a generic way to determine label versions without the implication of this is CXL device?

> +
>  /*
>   * Retrieve bus and dimm handle and return if this bus supports
>   * get_config_data commands
> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index 082253a3a956..48b5ba90216d 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c
> @@ -687,11 +687,19 @@ static int nd_label_write_index(struct nvdimm_drvdata *ndd, int index, u32 seq,
>  		- (unsigned long) to_namespace_index(ndd, 0);
>  	nsindex->labeloff = __cpu_to_le64(offset);
>  	nsindex->nslot = __cpu_to_le32(nslot);
> -	nsindex->major = __cpu_to_le16(1);
> -	if (sizeof_namespace_label(ndd) < 256)
> +
> +	/* Support CXL LSA 2.1 label format */
> +	if (ndd->cxl) {
> +		nsindex->major = __cpu_to_le16(2);
>  		nsindex->minor = __cpu_to_le16(1);
> -	else
> -		nsindex->minor = __cpu_to_le16(2);
> +	} else {
> +		nsindex->major = __cpu_to_le16(1);
> +		if (sizeof_namespace_label(ndd) < 256)
> +			nsindex->minor = __cpu_to_le16(1);
> +		else
> +			nsindex->minor = __cpu_to_le16(2);
> +	}

Would like to see a more coherent way of detecting label versioning. What happens when there are newer versions introduced later on? This currently feels very disjointed.

> +
>  	nsindex->checksum = __cpu_to_le64(0);
>  	if (flags & ND_NSINDEX_INIT) {
>  		unsigned long *free = (unsigned long *) nsindex->free;
> diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
> index 5ca06e9a2d29..304f0e9904f1 100644
> --- a/drivers/nvdimm/nd.h
> +++ b/drivers/nvdimm/nd.h
> @@ -522,6 +522,7 @@ void nvdimm_set_labeling(struct device *dev);
>  void nvdimm_set_locked(struct device *dev);
>  void nvdimm_clear_locked(struct device *dev);
>  int nvdimm_security_setup_events(struct device *dev);
> +bool nvdimm_check_cxl_label_format(struct device *dev);
>  #if IS_ENABLED(CONFIG_NVDIMM_KEYS)
>  int nvdimm_security_unlock(struct device *dev);
>  #else
> diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
> index e772aae71843..0a55900842c8 100644
> --- a/include/linux/libnvdimm.h
> +++ b/include/linux/libnvdimm.h
> @@ -44,6 +44,9 @@ enum {
>  	/* dimm provider wants synchronous registration by __nvdimm_create() */
>  	NDD_REGISTER_SYNC = 8,
>  
> +	/* dimm supports region labels (LSA Format 2.1) */
> +	NDD_CXL_LABEL = 9,

While 2.1 is defined by the CXL spec, is there anything declared by the CXL spec that makes 2.1 exclusive to CXL? Maybe the focus should be to support LSA 2.1 and avoid dragging naming CXL into the conversation at this point. It can be made more generic right? I'm concerned about dragging CXL into nvdimm when it isn't necessary. Maybe introduce a label cap field where when an nvdimm device is registered, the caller can pass in that it's capable of supporting up to a certain version of labeling? Just throwing ideas out to see if it's feasible.

> +
>  	/* need to set a limit somewhere, but yes, this is likely overkill */
>  	ND_IOCTL_MAX_BUFLEN = SZ_4M,
>  	ND_CMD_MAX_ELEM = 5,

