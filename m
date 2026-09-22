Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86083560ADD
	for <nvdimm@lists.linux.dev>; Tue, 22 Sep 2026 17:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790098121; cv=none; b=hQDxzJu20V+aCDLiRxwCp5IWl/cK02vaSevkO5VEzMcBtVjj8ZGVcRngctiOMA1nA601yjgwzlJ6jfJYR1p8qWKwjqhwVNVtgoAVeyJiwS9QOG6oPDNFSxzGhDYq+6XxQCYQxnJdHy8GDjyWxeIm6q6UFwaSzoY8R/DXWz1ehz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790098121; c=relaxed/simple;
	bh=sykwAUjfH/+0gLVEjN37IzgGmxNEUOl0jd4VRWhhmOk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LSCeaCs9Wn5jeTsJE2VKcYHVbU/QhYpjoimM+hgkXhROVNxL5Q3aZdsaFDHAhzPF8J/Ip2UJtM/8VA9PNylwEbboDU3EiFWpWgvUHmdXZKX7/iZmzxRRCrdUHpe86rFwGgC4j7y3f4ajAYMWd2cE1kKf7PCMSds0UmXgDWDnY6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gTyZsSNR; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gTyZsSNR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790098119; x=1821634119;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=sykwAUjfH/+0gLVEjN37IzgGmxNEUOl0jd4VRWhhmOk=;
  b=gTyZsSNRm1ZxnuwNdoRhieF/1D91zovDOBxCdVBtn3ed14wXmxYTCmC8
   aV7yHdFCPWHAW8wgWKcSQKeZv6/IaOtILNAHVSy7dH2LOoW5ymnyUG4HP
   bHHloJYYYxaR5mghgQFfHMkKSYKoblf0SLMPoIuUEKytuCOPZp36AZaAK
   /uPxnxo6Oro41EglVCJZNJB7Ob/uQEQSGGRB/oH1tEGbNRke4yeyiC04S
   dVp0Jmo/vRaCR0KLBfhmElCdmZR3uEsn3ANMOHfdEyewwJtBLVXmtxqlg
   2HEz+bntQ9BAnKBI2t+CW5w5r4XZyEiWCml14NJFWLr+Ujwp0k+vO4vW7
   w==;
X-CSE-ConnectionGUID: qNH+AalzQG2dwNcw7vqf+Q==
X-CSE-MsgGUID: +Lxyw/MPTcGTICb0tN6fWg==
X-IronPort-AV: E=McAfee;i="6800,10657,11913"; a="89642746"
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="89642746"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 10:28:36 -0700
X-CSE-ConnectionGUID: GIFsa5c4TQaPmNkGoM6/fA==
X-CSE-MsgGUID: XnPyavsZTiGampxTdtcGWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="301128999"
Received: from bradocaj-mobl.ger.corp.intel.com (HELO [10.125.110.50]) ([10.125.110.50])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 10:28:35 -0700
Message-ID: <af3edb82-5247-461e-a5c4-e63476e69e25@intel.com>
Date: Tue, 22 Sep 2026 10:28:33 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] dax/bus: fix mapping attribute error reporting
To: Muchun Song <songmuchun@bytedance.com>, Dan Williams <djbw@kernel.org>,
 Vishal Verma <vishal.l.verma@intel.com>,
 Alison Schofield <alison.schofield@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Joao Martins <joao.m.martins@oracle.com>, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
 muchun.song@linux.dev
References: <20260922082551.874901-1-songmuchun@bytedance.com>
 <20260922082551.874901-2-songmuchun@bytedance.com>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20260922082551.874901-2-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/22/26 1:25 AM, Muchun Song wrote:
> After the DAX configuration locking was converted to rwsems, successful
> lock acquisition leaves rc set to zero in mapping_store(). Two error
> paths can return this stale value: an unbound region driver and a
> misaligned range size. The sysfs write therefore reports success without
> allocating the requested range.
> 
> Return -ENXIO when the region driver is not bound and -EINVAL when the
> range size is misaligned.
> 
> Fixes: c05ae9d85b47 ("dax/bus.c: replace driver-core lock usage by a local rwsem")
> Assisted-by: LLM
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
> v2:
> - Return explicit errors before Device DAX range allocation
>   (suggested by Dave Jiang)
> - Move the patch before range alignment validation for independent
>   backports (suggested by Dave Jiang)
> ---
>  drivers/dax/bus.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index b809e1a264af..e40c25401cf0 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -1192,7 +1192,7 @@ static ssize_t mapping_store(struct device *dev, struct device_attribute *attr,
>  		return rc;
>  	if (!dax_region->dev->driver) {
>  		up_write(&dax_region_rwsem);
> -		return rc;
> +		return -ENXIO;
>  	}
>  	rc = down_write_killable(&dax_dev_rwsem);
>  	if (rc) {
> @@ -1201,8 +1201,12 @@ static ssize_t mapping_store(struct device *dev, struct device_attribute *attr,
>  	}
>  
>  	to_alloc = range_len(&r);
> -	if (alloc_is_aligned(dev_dax, to_alloc))
> +	if (!alloc_is_aligned(dev_dax, to_alloc)) {
> +		dev_dbg(dev, "%s: size: %zu misaligned\n", __func__, to_alloc);
> +		rc = -EINVAL;
> +	} else {
>  		rc = alloc_dev_dax_range(dev_dax, r.start, to_alloc);
> +	}
>  	up_write(&dax_dev_rwsem);
>  	up_write(&dax_region_rwsem);
>  

