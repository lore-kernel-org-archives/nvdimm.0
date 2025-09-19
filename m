Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D958A29CB4D
	for <nvdimm@lists.linux.dev>; Fri, 19 Sep 2025 23:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758325866; cv=none; b=oxTqndZi7v3aFEuNT6jCF7snDp3BlibwofhKwMh7KqT4dj9oyuv+tXmIg/TZuJveou7v+e35R6WpLli+tAJCedvUDS6/IOhjXb5i6ENDGItrn7wsDnxaH6RdjkqZAwS8SfudGtDy0tE0gdVZV3U0OJPlgc7yz8kpWYkouht+i30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758325866; c=relaxed/simple;
	bh=+uc6yA/HzcBIcjnVnLYIsqOuoDvWyZ47/cbbT6/vcl0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f9VsAwi044XzRvbZCwzrHT78yhuK37/yZd8wrB4bVSn1h61OvXDkAql7qF6JTfh5yVfaou0UWqS2RC1QPTzo3/VlHgbfTDpOCIKrqHgzkPdEHYX6K6/22PYm4T1iTadzfSqbvWFKPoED/C4TlFgcw2r6mGW61kjBgWhKazMtxjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kKya3Mr5; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kKya3Mr5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758325862; x=1789861862;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+uc6yA/HzcBIcjnVnLYIsqOuoDvWyZ47/cbbT6/vcl0=;
  b=kKya3Mr5BqeN/BojMJ23wxNwpQRGqpJ3sn9jj9iP/lzpKEFizLF5CbH+
   UzQYMJ5JqDWgDOkmmWJRaEKWe2psqnkBXJs6DfiE/CSdxS11Wnvu6Zm6j
   XObFZvn/UttWgXsLVYPawAXIbebfR4JQBXUoxIFT801D6zVHOT4XD5O78
   bj228cLiaMrnm2ADVEZoAp5aopx29pnUyV9Hq6tHiACTJtkBib+lxGgHQ
   pZNRoQWi/HX6t1VinLXhu8ews7prcXlAasNr1M/bexfw7QiLBD5mGv7sB
   Nc070/pu/tk8MU7tvYUXgGwSsHEAHB97RRM1w3beiiiJh6OArVVLWE2vY
   w==;
X-CSE-ConnectionGUID: uftHefqyQWqHK5fZo0v0Mg==
X-CSE-MsgGUID: aRnf9JlWS0Gbqw8IPD1nWw==
X-IronPort-AV: E=McAfee;i="6800,10657,11558"; a="71356880"
X-IronPort-AV: E=Sophos;i="6.18,279,1751266800"; 
   d="scan'208";a="71356880"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 16:51:01 -0700
X-CSE-ConnectionGUID: G/Ju8dwGQ1mh5l1NHByw3Q==
X-CSE-MsgGUID: zp+VozEzRFmCCyQIm0BA6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,279,1751266800"; 
   d="scan'208";a="179975589"
Received: from dnelso2-mobl.amr.corp.intel.com (HELO [10.125.108.58]) ([10.125.108.58])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 16:51:01 -0700
Message-ID: <b66e4c0b-a82f-4c18-8e8b-ba37b6551964@intel.com>
Date: Fri, 19 Sep 2025 16:50:59 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 04/20] nvdimm/label: Update mutex_lock() with
 guard(mutex)()
To: Neeraj Kumar <s.neeraj@samsung.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
 cpgs@samsung.com
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
 <CGME20250917134136epcas5p118f18ce5139d489d90ac608e3887c1fc@epcas5p1.samsung.com>
 <20250917134116.1623730-5-s.neeraj@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20250917134116.1623730-5-s.neeraj@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/17/25 6:41 AM, Neeraj Kumar wrote:
> Updated mutex_lock() with guard(mutex)()

Need a bit more in the commit log on why the change so whomever reads the commit later on has an idea what is happening. 
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
> ---
>  drivers/nvdimm/label.c | 36 +++++++++++++++++-------------------
>  1 file changed, 17 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index 668e1e146229..3235562d0e1c 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c
> @@ -948,7 +948,7 @@ static int __pmem_label_update(struct nd_region *nd_region,
>  		return rc;
>  
>  	/* Garbage collect the previous label */
> -	mutex_lock(&nd_mapping->lock);
> +	guard(mutex)(&nd_mapping->lock);
>  	list_for_each_entry(label_ent, &nd_mapping->labels, list) {
>  		if (!label_ent->label)
>  			continue;
> @@ -960,20 +960,20 @@ static int __pmem_label_update(struct nd_region *nd_region,
>  	/* update index */
>  	rc = nd_label_write_index(ndd, ndd->ns_next,
>  			nd_inc_seq(__le32_to_cpu(nsindex->seq)), 0);
> -	if (rc == 0) {
> -		list_for_each_entry(label_ent, &nd_mapping->labels, list)
> -			if (!label_ent->label) {
> -				label_ent->label = nd_label;
> -				nd_label = NULL;
> -				break;
> -			}
> -		dev_WARN_ONCE(&nspm->nsio.common.dev, nd_label,
> -				"failed to track label: %d\n",
> -				to_slot(ndd, nd_label));
> -		if (nd_label)
> -			rc = -ENXIO;
> -	}
> -	mutex_unlock(&nd_mapping->lock);
> +	if (rc)
> +		return rc;
> +
> +	list_for_each_entry(label_ent, &nd_mapping->labels, list)
> +		if (!label_ent->label) {
> +			label_ent->label = nd_label;
> +			nd_label = NULL;
> +			break;
> +		}
> +	dev_WARN_ONCE(&nspm->nsio.common.dev, nd_label,
> +			"failed to track label: %d\n",
> +			to_slot(ndd, nd_label));
> +	if (nd_label)
> +		rc = -ENXIO;
>  
>  	return rc;
>  }
> @@ -998,9 +998,8 @@ static int init_labels(struct nd_mapping *nd_mapping, int num_labels)
>  		label_ent = kzalloc(sizeof(*label_ent), GFP_KERNEL);
>  		if (!label_ent)
>  			return -ENOMEM;
> -		mutex_lock(&nd_mapping->lock);
> +		guard(mutex)(&nd_mapping->lock);
>  		list_add_tail(&label_ent->list, &nd_mapping->labels);
> -		mutex_unlock(&nd_mapping->lock);

I would not mix and match old and new locking flow in a function. If you are going to convert, then do the whole function. I think earlier in this function you may need a scoped_guard() call.

>  	}
>  
>  	if (ndd->ns_current == -1 || ndd->ns_next == -1)
> @@ -1039,7 +1038,7 @@ static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
>  	if (!preamble_next(ndd, &nsindex, &free, &nslot))
>  		return 0;
>  
> -	mutex_lock(&nd_mapping->lock);
> +	guard(mutex)(&nd_mapping->lock);

So this change now includes nd_label_write_index() in the lock context as well compare to the old code. So either you should use a scoped_guard() or create a helper function and move the block of code being locked to the helper function with guard() to avoid changing the original code flow.

DJ

>  	list_for_each_entry_safe(label_ent, e, &nd_mapping->labels, list) {
>  		struct nd_namespace_label *nd_label = label_ent->label;
>  
> @@ -1061,7 +1060,6 @@ static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
>  		nd_mapping_free_labels(nd_mapping);
>  		dev_dbg(ndd->dev, "no more active labels\n");
>  	}
> -	mutex_unlock(&nd_mapping->lock);
>  
>  	return nd_label_write_index(ndd, ndd->ns_next,
>  			nd_inc_seq(__le32_to_cpu(nsindex->seq)), 0);

