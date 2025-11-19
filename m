Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D989310627
	for <nvdimm@lists.linux.dev>; Wed, 19 Nov 2025 18:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763575678; cv=none; b=IzYGxID/xglGt3Mdzpbos7vIImiRF3VzrrGBBDyf10+2J6SSvg0AxicNOIfTAf2kY3RoENT9mQPL4C07j867YDXShamqlC25p8fXMlaVbdA4K79rqcmtMVT2KmcuxW6sdHDOhj5KRxQIZYAEBWxdLMLbJo9uPzTLElosl1aoUs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763575678; c=relaxed/simple;
	bh=iVnurEK4tlJP5d2sydcB0iuk0LtCz7Ez2SxTrxeNHOw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iMXwGsjSFiNIIZXBtacjZ5TPHAp4jBJy327vGk1PrXGjEYNhSF26qeZ+EeOH3fc25Rrv8xwPaQGrYxg6Dv47tNuEFUhtKJ7m3PO2EztZh37AThmoRSlIVo3nye+IMpQpinwwlKujKH50leeHsvCsr+St8TVThSX3tpjvxmaOgwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L5NLuEDM; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L5NLuEDM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763575672; x=1795111672;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=iVnurEK4tlJP5d2sydcB0iuk0LtCz7Ez2SxTrxeNHOw=;
  b=L5NLuEDMcrM51U2/Z0LbDjOKGzBsK8AIZag3wfQtySLv93UpMUM73J0S
   Dk7GZQWPjezSk6TOz16m2r/JEi04ONqgUpLv4mUhnMpgB6Go9xjMjuIt9
   FgqO0auIShLGrB9Sw5rxx6gbXyRhWQsoegyfQ5tGT/6Npt0zDnAJLjY6R
   7z/Oz6ls8grSa4OnTMLqluRuD9b59otVQw1q+HnluNRjWnXgcxzJoyvNC
   M4GcWgRg20BiPanb4CyiQT79SQCevjZDbAXzJ4LdWkQxVM660jFqZKw+t
   7TeQ8LxhYCpxUsv2K4WRIZk9/E2n5qx5iP4IVuUEcGS2JyZUa84Vw9V+/
   A==;
X-CSE-ConnectionGUID: KJt6WTR7SDWF6mGLBsH1Pg==
X-CSE-MsgGUID: FvqpmqmjSkG7Wyk8+kyZRg==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="91105351"
X-IronPort-AV: E=Sophos;i="6.19,316,1754982000"; 
   d="scan'208";a="91105351"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 10:07:47 -0800
X-CSE-ConnectionGUID: SPIG1fiaT/qw+RNSoVtpIA==
X-CSE-MsgGUID: V3cboUR7RyO/rQAsZ8dp4Q==
X-ExtLoop1: 1
Received: from cmdeoliv-mobl4.amr.corp.intel.com (HELO [10.125.109.179]) ([10.125.109.179])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 10:07:46 -0800
Message-ID: <56d29b15-ce74-4205-824d-229a73724706@intel.com>
Date: Wed, 19 Nov 2025 11:07:45 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 06/17] nvdimm/label: Preserve region label during
 namespace creation
To: Neeraj Kumar <s.neeraj@samsung.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com
References: <20251119075255.2637388-1-s.neeraj@samsung.com>
 <CGME20251119075317epcas5p41468e3c1602d89e634f48a7b67454663@epcas5p4.samsung.com>
 <20251119075255.2637388-7-s.neeraj@samsung.com>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20251119075255.2637388-7-s.neeraj@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/19/25 12:52 AM, Neeraj Kumar wrote:
> During namespace creation we scan labels present in LSA using
> scan_labels(). Currently scan_labels() is only preserving
> namespace labels into label_ent list.
> 
> In this patch we also preserve region label into label_ent list
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/nvdimm/namespace_devs.c | 47 +++++++++++++++++++++++++++++----
>  1 file changed, 42 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
> index b1abbe602a5e..9450200b4470 100644
> --- a/drivers/nvdimm/namespace_devs.c
> +++ b/drivers/nvdimm/namespace_devs.c
> @@ -1999,9 +1999,32 @@ static struct device **scan_labels(struct nd_region *nd_region)
>  
>  	if (count == 0) {
>  		struct nd_namespace_pmem *nspm;
> +		for (i = 0; i < nd_region->ndr_mappings; i++) {
> +			struct cxl_region_label *region_label;
> +			struct nd_label_ent *le, *e;
> +			LIST_HEAD(list);
>  
> -		/* Publish a zero-sized namespace for userspace to configure. */
> -		nd_mapping_free_labels(nd_mapping);
> +			nd_mapping = &nd_region->mapping[i];
> +			if (list_empty(&nd_mapping->labels))
> +				continue;
> +
> +			list_for_each_entry_safe(le, e, &nd_mapping->labels,
> +						 list) {
> +				region_label = le->region_label;
> +				if (!region_label)
> +					continue;
> +
> +				/* Preserve region labels if present */
> +				list_move_tail(&le->list, &list);
> +			}
> +
> +			/*
> +			 * Publish a zero-sized namespace for userspace
> +			 * to configure.
> +			 */
> +			nd_mapping_free_labels(nd_mapping);
> +			list_splice_init(&list, &nd_mapping->labels);
> +		}
>  		nspm = kzalloc(sizeof(*nspm), GFP_KERNEL);
>  		if (!nspm)
>  			goto err;
> @@ -2013,7 +2036,7 @@ static struct device **scan_labels(struct nd_region *nd_region)
>  	} else if (is_memory(&nd_region->dev)) {
>  		/* clean unselected labels */
>  		for (i = 0; i < nd_region->ndr_mappings; i++) {
> -			struct list_head *l, *e;
> +			struct nd_label_ent *le, *e;
>  			LIST_HEAD(list);
>  			int j;
>  
> @@ -2024,10 +2047,24 @@ static struct device **scan_labels(struct nd_region *nd_region)
>  			}
>  
>  			j = count;
> -			list_for_each_safe(l, e, &nd_mapping->labels) {
> +			list_for_each_entry_safe(le, e, &nd_mapping->labels,
> +						 list) {
> +				/* Preserve region labels */
> +				if (uuid_equal(&le->label_uuid,
> +					       &cxl_region_uuid)) {
> +					list_move_tail(&le->list, &list);
> +					continue;
> +				}
> +
> +				/*
> +				 * Once preserving selected ns label done
> +				 * break out of loop
> +				 */
>  				if (!j--)
>  					break;
> -				list_move_tail(l, &list);
> +
> +				/* Preserve selected ns label */
> +				list_move_tail(&le->list, &list);
>  			}
>  			nd_mapping_free_labels(nd_mapping);
>  			list_splice_init(&list, &nd_mapping->labels);

