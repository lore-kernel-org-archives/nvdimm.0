Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77099382394
	for <nvdimm@lists.linux.dev>; Mon, 21 Sep 2026 19:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790018587; cv=none; b=Y8INEWbofDcT5XQrnpXVvOCtLeR4rzfxqBZ4zkHrmyuAKRrXoX+1dLhHzyfgMz9z82RAAiapGiVAsqszURWuzkaWBdZB+1gtehZ1MkrhshFpZoFbmU5F7lIoSQBcTPCJJMz8FWoFqAjziYbA4r6VrZgL/hirKmcIbfKDtyVRyTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790018587; c=relaxed/simple;
	bh=DNC+Il0AkMXko37Uh06NOWpHEz0/nN0JeHGmGrcFMuw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m4xfpB14DuX5T8KRXXK5p89DZ/QJ0OJGUzKikcBQHmPzXGnMHAjeumzqIWjxOQRg8jtbk1DxbCGj9ERaa9vWbkvV+eVHZ3Tcg2DFVFv6rb+WetBJbZINkd3L+/CK7mW0C77h+dHyLlWYdoF6fD4nNtjP6vo2an7qg06u7OTjICc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TF0N0o3n; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TF0N0o3n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790018585; x=1821554585;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=DNC+Il0AkMXko37Uh06NOWpHEz0/nN0JeHGmGrcFMuw=;
  b=TF0N0o3nWmCqaJySeD80l4qd7lewYKnIoggl5DI2xIWygs8XeZE2OjL+
   1chavaT+KzcKFHv5FuxRprD2R2wFeD8Lt6ZxzoRY7WiROGlgGk7/YgK6B
   R799tyvITL/rw/sOCC9a6eHs05p5EpxJ5q1Ir+e3jJAvKJ2BYw8i+p5Km
   urFE46c/9uEYgQF1tcXo8o+mnCdW+/JGvl47yCSwCH4NVt08iLLxcMj/7
   AdFRMRUnq+ze8jbF3gP6byTWnBvOayZBYP1mVcC/dzFO49XVl3moIEuEd
   PX6cWMMoB/hQn/esmPRqFLDOUoOVa2biQI35wFDN1UzCaNvFl+G2rafzt
   g==;
X-CSE-ConnectionGUID: 9tCfmN8YSG2VRtDDItUGPw==
X-CSE-MsgGUID: J0D0R7YJR6Gr3gEQDPDHnw==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="108062237"
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="108062237"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 12:23:04 -0700
X-CSE-ConnectionGUID: LdXRakwwSOiAZXLt6v7iiA==
X-CSE-MsgGUID: 8/8hjT/bRZWiK8KSIfLyLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="280872416"
Received: from aschende-mobl.amr.corp.intel.com (HELO [10.125.109.234]) ([10.125.109.234])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 12:23:03 -0700
Message-ID: <7619863e-0690-4f45-ae99-c75ad7573c61@intel.com>
Date: Mon, 21 Sep 2026 12:23:02 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] dax/bus: fix mapping attribute error reporting
To: Muchun Song <songmuchun@bytedance.com>, Dan Williams <djbw@kernel.org>,
 Vishal Verma <vishal.l.verma@intel.com>,
 Alison Schofield <alison.schofield@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Joao Martins <joao.m.martins@oracle.com>, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
 muchun.song@linux.dev
References: <20260915095621.3744167-1-songmuchun@bytedance.com>
 <20260915095621.3744167-3-songmuchun@bytedance.com>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20260915095621.3744167-3-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/15/26 2:56 AM, Muchun Song wrote:
> After the DAX configuration locking was converted to rwsems, successful
> lock acquisition leaves rc set to zero in mapping_store(). If the requested
> range size is misaligned, the allocation is skipped and the zero rc is
> converted to len. The sysfs write therefore reports success without
> allocating the requested range.
> 
> Call alloc_dev_dax_range() unconditionally and let its full range
> validation return -EINVAL for a misaligned start or size.
> 
> Fixes: c05ae9d85b47 ("dax/bus.c: replace driver-core lock usage by a local rwsem")
> Assisted-by: LLM
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>  drivers/dax/bus.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index 54e4bbc98218..f232001ff5b7 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -1276,8 +1276,7 @@ static ssize_t mapping_store(struct device *dev, struct device_attribute *attr,
>  	}
>  
>  	to_alloc = range_len(&r);
> -	if (size_is_aligned(dev_dax, to_alloc))
> -		rc = alloc_dev_dax_range(dev_dax, r.start, to_alloc);
> +	rc = alloc_dev_dax_range(dev_dax, r.start, to_alloc);
>  	up_write(&dax_dev_rwsem);
>  	up_write(&dax_region_rwsem);
>  

So this patch becomes somewhat of a backport issue as it depends on patch 1. Please consider swap the ordering of your patch series and fix this issue first. Maybe something like so the fix can be independently backported:

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index b809e1a264af..e40c25401cf0 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -1192,7 +1192,7 @@ static ssize_t mapping_store(struct device *dev, struct de
vice_attribute *attr,
                return rc;
        if (!dax_region->dev->driver) {
                up_write(&dax_region_rwsem);
-               return rc;
+               return -ENXIO;
        }
        rc = down_write_killable(&dax_dev_rwsem);
        if (rc) {
@@ -1201,8 +1201,12 @@ static ssize_t mapping_store(struct device *dev, struct d
evice_attribute *attr,
        }

        to_alloc = range_len(&r);
-       if (alloc_is_aligned(dev_dax, to_alloc))
+       if (!alloc_is_aligned(dev_dax, to_alloc)) {
+               dev_dbg(dev, "%s: size: %zu misaligned\n", __func__, to_alloc);
+               rc = -EINVAL;
+       } else {
                rc = alloc_dev_dax_range(dev_dax, r.start, to_alloc);
+       }
        up_write(&dax_dev_rwsem);
        up_write(&dax_region_rwsem);


