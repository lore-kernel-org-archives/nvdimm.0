Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6B227A906
	for <nvdimm@lists.linux.dev>; Mon, 22 Sep 2025 22:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758579469; cv=none; b=QOr9XUXAXioAMw8TuCZQH8cFhgJ2i3OoDW9n8kyYTjnaiR95qMmBpcgugFjCbqwh+LvTubdE+oo0kuj40YQ5NbdaXGdvpG3JfVHPSes+qRqJFRUV51jOMvyFrvMrATmPa0A2hRkiP/GzSnAnxe6wCSTlu1RQDJ0kUSf8RNSUv9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758579469; c=relaxed/simple;
	bh=JR86t5gMqZoGcwbU+6O/bTJorJB8iMgsyOH04HDXylc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hm6O54MYebnJi/vH/QSv5Koz99tyyl7zT8dpCBv5Xy3Rc39fvbONBYdVNMWTqRdS5c2h9gCmbUociRjl/9t5ETchlPmumAx8tBAAs7YLS+KhWrTl1vapNE3+o8r3vcgwYK82rTJOhowqgnBnNAO702XmD1rSQ1i2z8zM01OAZxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T6Fi3uKp; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T6Fi3uKp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758579467; x=1790115467;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=JR86t5gMqZoGcwbU+6O/bTJorJB8iMgsyOH04HDXylc=;
  b=T6Fi3uKpR2dwJTOHiQ6P+/+0fPLjsS9kN7JL6VkPNjxj7VRAr3Fic5oe
   3ugJ/aGJ8R87fuZc6R9jtHoM3HPuBz2b3wxQ8WPrHVv9NjsPQktmkVVIr
   Okqy2rK4Xx4FYuxzGrfdNLNmoW2iyFvoWSFXJvc/2IxjtGHfWt7dxJnqR
   f7i96dNNGUiqCKmQ+HimP8qeZFW9PcstSokzaPKBjx9FzO0IIjR5AfcyD
   PmCco2lYOS1zH0HDcLwb8X1JLivl62TCHzNxBKiKiOzQWOtgCwIKgpgjP
   yDORBRzobgAkUDa0lZwO6KdjfHqnxyuJMM45m8yP47OkSE6UcbiOtrPWv
   w==;
X-CSE-ConnectionGUID: Cdy4eL7JRhqM3LFqqefnsg==
X-CSE-MsgGUID: e6VBdFStQOGHA+TZd2PMTw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="60791214"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="60791214"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 15:17:46 -0700
X-CSE-ConnectionGUID: qJP5Ld6HSlaIUd7Nb61SKQ==
X-CSE-MsgGUID: XYQkxJBGRNC3m8m5Y9TBbA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,286,1751266800"; 
   d="scan'208";a="213742857"
Received: from dwoodwor-mobl2.amr.corp.intel.com (HELO [10.125.108.132]) ([10.125.108.132])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 15:17:46 -0700
Message-ID: <12f7fbd9-c35f-4ebf-809f-43f8ab240413@intel.com>
Date: Mon, 22 Sep 2025 15:17:44 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 08/20] nvdimm/label: Include region label in slot
 validation
To: Neeraj Kumar <s.neeraj@samsung.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
 cpgs@samsung.com, Jonathan Cameron <jonathan.cameron@huawei.com>
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
 <CGME20250917134144epcas5p498fb4b005516fca56e68533ce017fba0@epcas5p4.samsung.com>
 <20250917134116.1623730-9-s.neeraj@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20250917134116.1623730-9-s.neeraj@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/17/25 6:41 AM, Neeraj Kumar wrote:
> Slot validation routine validates label slot by calculating label
> checksum. It was only validating namespace label. This changeset also
> validates region label if present.
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> ---
>  drivers/nvdimm/label.c | 72 ++++++++++++++++++++++++++++++++----------
>  drivers/nvdimm/nd.h    |  5 +++
>  2 files changed, 60 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index d33db96ba8ba..5e476154cf81 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c
> @@ -359,7 +359,7 @@ static bool nsl_validate_checksum(struct nvdimm_drvdata *ndd,
>  {
>  	u64 sum, sum_save;
>  
> -	if (!ndd->cxl && !efi_namespace_label_has(ndd, checksum))
> +	if (!efi_namespace_label_has(ndd, checksum))
>  		return true;
>  
>  	sum_save = nsl_get_checksum(ndd, nd_label);
> @@ -374,13 +374,25 @@ static void nsl_calculate_checksum(struct nvdimm_drvdata *ndd,
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
> @@ -392,16 +404,30 @@ static void region_label_calculate_checksum(struct nvdimm_drvdata *ndd,
>  }
>  
>  static bool slot_valid(struct nvdimm_drvdata *ndd,
> -		struct nd_namespace_label *nd_label, u32 slot)
> +		       union nd_lsa_label *lsa_label, u32 slot)
>  {
> +	struct cxl_region_label *region_label = &lsa_label->region_label;
> +	struct nd_namespace_label *nd_label = &lsa_label->ns_label;
> +	char *label_name;
>  	bool valid;
>  
>  	/* check that we are written where we expect to be written */
> -	if (slot != nsl_get_slot(ndd, nd_label))
> -		return false;
> -	valid = nsl_validate_checksum(ndd, nd_label);
> +	if (is_region_label(ndd, lsa_label)) {
> +		label_name = "rg";

I suggest create a static string table enumerated by 'enum label_type'. That way you can directly address it by 'label_name[ltype]' when being used instead of assigning at run time. And maybe just use "region" and "namespace" since it's for debug output and we don't need to shorten it. 

DJ

> +		if (slot != region_label_get_slot(region_label))
> +			return false;
> +		valid = region_label_validate_checksum(ndd, region_label);
> +	} else {
> +		label_name = "ns";
> +		if (slot != nsl_get_slot(ndd, nd_label))
> +			return false;
> +		valid = nsl_validate_checksum(ndd, nd_label);
> +	}
> +
>  	if (!valid)
> -		dev_dbg(ndd->dev, "fail checksum. slot: %d\n", slot);
> +		dev_dbg(ndd->dev, "%s label checksum fail. slot: %d\n",
> +			label_name, slot);
> +
>  	return valid;
>  }
>  
> @@ -424,7 +450,7 @@ int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
>  
>  		nd_label = to_label(ndd, slot);
>  
> -		if (!slot_valid(ndd, nd_label, slot))
> +		if (!slot_valid(ndd, (union nd_lsa_label *) nd_label, slot))
>  			continue;
>  
>  		nsl_get_uuid(ndd, nd_label, &label_uuid);
> @@ -575,18 +601,30 @@ int nd_label_active_count(struct nvdimm_drvdata *ndd)
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
> +		lsa_label = (union nd_lsa_label *) to_label(ndd, slot);
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
> @@ -607,7 +645,7 @@ struct nd_namespace_label *nd_label_active(struct nvdimm_drvdata *ndd, int n)
>  		struct nd_namespace_label *nd_label;
>  
>  		nd_label = to_label(ndd, slot);
> -		if (!slot_valid(ndd, nd_label, slot))
> +		if (!slot_valid(ndd, (union nd_lsa_label *) nd_label, slot))
>  			continue;
>  
>  		if (n-- == 0)
> diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
> index 046063ea08b6..c985f91728dd 100644
> --- a/drivers/nvdimm/nd.h
> +++ b/drivers/nvdimm/nd.h
> @@ -344,6 +344,11 @@ region_label_uuid_equal(struct cxl_region_label *region_label,
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

