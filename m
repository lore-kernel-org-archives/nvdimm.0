Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52FB53081DA
	for <nvdimm@lists.linux.dev>; Wed, 19 Nov 2025 16:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763571287; cv=none; b=sq+Ivxo5YrDlUg9P3iLyAreH7yuWOde9H4yhC6KTCtn4w2KMkTo+9YoaMyEx52e5SeIMn1gFZDZXRz/bIIIDchzZbu9R41IDPXNqzp2RMEZgU/rxVcArW6nYkT5a1yblEEyYrpiAzkIUpE/yVcnW18bq9wIKnEvxk1ims5bn1aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763571287; c=relaxed/simple;
	bh=MARkSsnAj5H9wp1FslSr9PE5IyNzHF4q9M83LRaUOzI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kSejjEZHpCessYKdWK+SAHZkwIqvDmrHI6BO+79lapn5XH1jLmyTe8vR2adakraTyZuKrosVazShQv9FiyXKryfnM/alIWdP8phDSZtkPQUgAQsfoE8k8Bmk0iBwrc7oeKlqzUC+RrNV7R3gJbqSsaBI247koHNFOMc5onfm6Co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RZP+rT7A; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RZP+rT7A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763571285; x=1795107285;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=MARkSsnAj5H9wp1FslSr9PE5IyNzHF4q9M83LRaUOzI=;
  b=RZP+rT7AsTI7wIuMP/QRe9LnaeLUUzZocDYzOqa1RmliMVPr4CaGidU4
   nCl6HOJSasknAUC3ostjWrIlUEBcFSVkD3veXjdr3xjkldNY5e8/sBeP1
   /KntSLV+FeXQrV7DeBAb0RJvgx9aGoAdPbHK/Gvij67RW16VdnQqMA22B
   sd545ErxZQ1c4U9GR2397po9HMvQe+lFMS/XqTABpjtj5ev3RHZl+Xd2g
   gryTT48I4M+FfrAlOIoyOB693hc3eJ88aku5wzIiRqWPxHqU80lEP0AVP
   RqrmS9kjvgNqvDQubF2/Qv/7FpOqRug7jXOYgXk3yyja3jpBKnqNZipID
   A==;
X-CSE-ConnectionGUID: 7gfOxJBiSkStRNCZmQLX4g==
X-CSE-MsgGUID: ld0nQbLGT0ybCBQ85VeTbQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="76977434"
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="76977434"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 08:54:45 -0800
X-CSE-ConnectionGUID: be50l+I2RgWEJLild2TX1A==
X-CSE-MsgGUID: iDmBYgCDTe+yI6KprJMnHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="191909260"
Received: from cmdeoliv-mobl4.amr.corp.intel.com (HELO [10.125.109.179]) ([10.125.109.179])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 08:54:44 -0800
Message-ID: <cf7d8fd8-e0b8-42cc-bfe4-f20fb0615b4f@intel.com>
Date: Wed, 19 Nov 2025 09:54:42 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 04/17] nvdimm/label: Include region label in slot
 validation
To: Neeraj Kumar <s.neeraj@samsung.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com
References: <20251119075255.2637388-1-s.neeraj@samsung.com>
 <CGME20251119075313epcas5p2db0de2ac270e4676b12730e10281ef83@epcas5p2.samsung.com>
 <20251119075255.2637388-5-s.neeraj@samsung.com>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20251119075255.2637388-5-s.neeraj@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/19/25 12:52 AM, Neeraj Kumar wrote:
> Prior to LSA 2.1 Support, label in slot means only namespace
> label. But with LSA 2.1 a label can be either namespace or
> region label.
> 
> Slot validation routine validates label slot by calculating
> label checksum. It was only validating namespace label.
> This changeset also validates region label if present.
> 
> In previous patch to_lsa_label() was introduced along with
> to_label(). to_label() returns only namespace label whereas
> to_lsa_label() returns union nd_lsa_label*
> 
> In this patch We have converted all usage of to_label()
> to to_lsa_label()
> 
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/nvdimm/label.c | 94 ++++++++++++++++++++++++++++--------------
>  drivers/nvdimm/nd.h    |  5 +++
>  2 files changed, 69 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index 0d587a5b9f7e..6ccc51552822 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c
> @@ -312,16 +312,6 @@ static union nd_lsa_label *to_lsa_label(struct nvdimm_drvdata *ndd, int slot)
>  	return (union nd_lsa_label *) label;
>  }
>  
> -static struct nd_namespace_label *to_label(struct nvdimm_drvdata *ndd, int slot)
> -{
> -	unsigned long label, base;
> -
> -	base = (unsigned long) nd_label_base(ndd);
> -	label = base + sizeof_namespace_label(ndd) * slot;
> -
> -	return (struct nd_namespace_label *) label;
> -}
> -
>  #define for_each_clear_bit_le(bit, addr, size) \
>  	for ((bit) = find_next_zero_bit_le((addr), (size), 0);  \
>  	     (bit) < (size);                                    \
> @@ -382,7 +372,7 @@ static bool nsl_validate_checksum(struct nvdimm_drvdata *ndd,
>  {
>  	u64 sum, sum_save;
>  
> -	if (!ndd->cxl && !efi_namespace_label_has(ndd, checksum))
> +	if (!efi_namespace_label_has(ndd, checksum))
>  		return true;
>  
>  	sum_save = nsl_get_checksum(ndd, nd_label);
> @@ -397,13 +387,25 @@ static void nsl_calculate_checksum(struct nvdimm_drvdata *ndd,
>  {
>  	u64 sum;
>  
> -	if (!ndd->cxl && !efi_namespace_label_has(ndd, checksum))
> +	if (!efi_namespace_label_has(ndd, checksum))
>  		return;
>  	nsl_set_checksum(ndd, nd_label, 0);
>  	sum = nd_fletcher64(nd_label, sizeof_namespace_label(ndd), 1);
>  	nsl_set_checksum(ndd, nd_label, sum);
>  }
>  
> +static bool region_label_validate_checksum(struct nvdimm_drvdata *ndd,
> +				struct cxl_region_label *region_label)
> +{
> +	u64 sum, sum_save;
> +
> +	sum_save = region_label_get_checksum(region_label);
> +	region_label_set_checksum(region_label, 0);
> +	sum = nd_fletcher64(region_label, sizeof_namespace_label(ndd), 1);
> +	region_label_set_checksum(region_label, sum_save);
> +	return sum == sum_save;
> +}
> +
>  static void region_label_calculate_checksum(struct nvdimm_drvdata *ndd,
>  				   struct cxl_region_label *region_label)
>  {
> @@ -415,16 +417,34 @@ static void region_label_calculate_checksum(struct nvdimm_drvdata *ndd,
>  }
>  
>  static bool slot_valid(struct nvdimm_drvdata *ndd,
> -		struct nd_namespace_label *nd_label, u32 slot)
> +		       union nd_lsa_label *lsa_label, u32 slot)
>  {
> +	struct cxl_region_label *region_label = &lsa_label->region_label;
> +	struct nd_namespace_label *nd_label = &lsa_label->ns_label;
> +	enum label_type type;
>  	bool valid;
> +	static const char * const label_name[] = {
> +		[RG_LABEL_TYPE] = "region",
> +		[NS_LABEL_TYPE] = "namespace",
> +	};
>  
>  	/* check that we are written where we expect to be written */
> -	if (slot != nsl_get_slot(ndd, nd_label))
> -		return false;
> -	valid = nsl_validate_checksum(ndd, nd_label);
> +	if (is_region_label(ndd, lsa_label)) {
> +		type = RG_LABEL_TYPE;
> +		if (slot != region_label_get_slot(region_label))
> +			return false;
> +		valid = region_label_validate_checksum(ndd, region_label);
> +	} else {
> +		type = NS_LABEL_TYPE;
> +		if (slot != nsl_get_slot(ndd, nd_label))
> +			return false;
> +		valid = nsl_validate_checksum(ndd, nd_label);
> +	}
> +
>  	if (!valid)
> -		dev_dbg(ndd->dev, "fail checksum. slot: %d\n", slot);
> +		dev_dbg(ndd->dev, "%s label checksum fail. slot: %d\n",
> +			label_name[type], slot);
> +
>  	return valid;
>  }
>  
> @@ -440,14 +460,16 @@ int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
>  	for_each_clear_bit_le(slot, free, nslot) {
>  		struct nd_namespace_label *nd_label;
>  		struct nd_region *nd_region = NULL;
> +		union nd_lsa_label *lsa_label;
>  		struct nd_label_id label_id;
>  		struct resource *res;
>  		uuid_t label_uuid;
>  		u32 flags;
>  
> -		nd_label = to_label(ndd, slot);
> +		lsa_label = to_lsa_label(ndd, slot);
> +		nd_label = &lsa_label->ns_label;
>  
> -		if (!slot_valid(ndd, nd_label, slot))
> +		if (!slot_valid(ndd, lsa_label, slot))
>  			continue;
>  
>  		nsl_get_uuid(ndd, nd_label, &label_uuid);
> @@ -598,18 +620,30 @@ int nd_label_active_count(struct nvdimm_drvdata *ndd)
>  		return 0;
>  
>  	for_each_clear_bit_le(slot, free, nslot) {
> +		struct cxl_region_label *region_label;
>  		struct nd_namespace_label *nd_label;
> -
> -		nd_label = to_label(ndd, slot);
> -
> -		if (!slot_valid(ndd, nd_label, slot)) {
> -			u32 label_slot = nsl_get_slot(ndd, nd_label);
> -			u64 size = nsl_get_rawsize(ndd, nd_label);
> -			u64 dpa = nsl_get_dpa(ndd, nd_label);
> +		union nd_lsa_label *lsa_label;
> +		u32 lslot;
> +		u64 size, dpa;
> +
> +		lsa_label = to_lsa_label(ndd, slot);
> +		nd_label = &lsa_label->ns_label;
> +		region_label = &lsa_label->region_label;
> +
> +		if (!slot_valid(ndd, lsa_label, slot)) {
> +			if (is_region_label(ndd, lsa_label)) {
> +				lslot = __le32_to_cpu(region_label->slot);
> +				size = __le64_to_cpu(region_label->rawsize);
> +				dpa = __le64_to_cpu(region_label->dpa);
> +			} else {
> +				lslot = nsl_get_slot(ndd, nd_label);
> +				size = nsl_get_rawsize(ndd, nd_label);
> +				dpa = nsl_get_dpa(ndd, nd_label);
> +			}
>  
>  			dev_dbg(ndd->dev,
>  				"slot%d invalid slot: %d dpa: %llx size: %llx\n",
> -					slot, label_slot, dpa, size);
> +					slot, lslot, dpa, size);
>  			continue;
>  		}
>  		count++;
> @@ -627,10 +661,10 @@ union nd_lsa_label *nd_label_active(struct nvdimm_drvdata *ndd, int n)
>  		return NULL;
>  
>  	for_each_clear_bit_le(slot, free, nslot) {
> -		struct nd_namespace_label *nd_label;
> +		union nd_lsa_label *lsa_label;
>  
> -		nd_label = to_label(ndd, slot);
> -		if (!slot_valid(ndd, nd_label, slot))
> +		lsa_label = to_lsa_label(ndd, slot);
> +		if (!slot_valid(ndd, lsa_label, slot))
>  			continue;
>  
>  		if (n-- == 0)
> diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
> index 5fd69c28ffe7..30c7262d8a26 100644
> --- a/drivers/nvdimm/nd.h
> +++ b/drivers/nvdimm/nd.h
> @@ -346,6 +346,11 @@ region_label_uuid_equal(struct cxl_region_label *region_label,
>  	return uuid_equal((uuid_t *) region_label->uuid, uuid);
>  }
>  
> +static inline u32 region_label_get_slot(struct cxl_region_label *region_label)
> +{
> +	return __le32_to_cpu(region_label->slot);
> +}
> +
>  static inline u64
>  region_label_get_checksum(struct cxl_region_label *region_label)
>  {

