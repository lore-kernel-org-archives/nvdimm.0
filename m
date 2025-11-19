Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865C61DED57
	for <nvdimm@lists.linux.dev>; Wed, 19 Nov 2025 19:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763581855; cv=none; b=c2YxtFSCtmvuwq/ZDp6p94xpgpQXq5kgKliSzORxfE1WoDbgTaJUpYKgGOcTGGBuh9XtEtc/8cTsp0RFvtg5Bxo8uPy0cRyvJfw/nM27YM5n0pjbV71nw8DQNBeuXfEQMYr+KYVax12s4HYgfcPZxd6jbb2zO98xpsgulf3w+aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763581855; c=relaxed/simple;
	bh=4YLH0WPcpx/5e2KPSs8sAAHWClu9o3qOxTUBTK/dKC8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fila05XHr2D7wPekUpzf4Icods7fMshnjX0uxqpa9DdGfcmvbtDCRo/+BlhQRHLjj0YAvrqCQIGbtfAzdFm67Kvdie5tgVsuP6KNAdoTxC8d6MBxSZf8OrQx51dgOpmWVVdqV1bg2wbtfas93Llue02ntbpnMQrXPFTY8VBpKWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y2KGnp+C; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y2KGnp+C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763581852; x=1795117852;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4YLH0WPcpx/5e2KPSs8sAAHWClu9o3qOxTUBTK/dKC8=;
  b=Y2KGnp+Cx0BjEnweoYoWn0Z9wN3ZpTlH8sUTYo9tOyU3smmGJc4vp1en
   33VDWygpD/Jf1cng/Xp5T7AmoRFsszgWeOEettjUul7iUDC0x55C2rKgV
   r+KnbzNTWqpLiyYz97yruFqcSSqrTF1evYIOj2Qoqq1DosJTObBBwRhhe
   V4P5NQIZISHSU7ZYxqr6wIwV+VERDbfq4Cq3tbcYunXQDOfFdahpe+z0k
   bDpCWRixIL38J3fNBMpn0Gg1xShWnS7Ib9Hj4A6Khpllozm3JsLUoGT6o
   SOLx9W0gmqOwIp0b0HRWTM5oPLqSyL24Jdl4SZ2xpkom2iqPLDOQdyHsQ
   A==;
X-CSE-ConnectionGUID: fGeAj6iOQxGdGKe/0v0JHg==
X-CSE-MsgGUID: 9GbqtuYWTr+6O3FMVk+ReQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="65534345"
X-IronPort-AV: E=Sophos;i="6.19,316,1754982000"; 
   d="scan'208";a="65534345"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 11:50:51 -0800
X-CSE-ConnectionGUID: Wu4XhHqaSZWtzMJ4AfFIog==
X-CSE-MsgGUID: jceCuD1gRESffhcCPIADaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,316,1754982000"; 
   d="scan'208";a="195267068"
Received: from cmdeoliv-mobl4.amr.corp.intel.com (HELO [10.125.109.179]) ([10.125.109.179])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 11:50:51 -0800
Message-ID: <0df5e529-e9bf-4fd5-ac54-4d9853f8e79a@intel.com>
Date: Wed, 19 Nov 2025 12:50:49 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 07/17] nvdimm/label: Add region label delete support
To: Neeraj Kumar <s.neeraj@samsung.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com
References: <20251119075255.2637388-1-s.neeraj@samsung.com>
 <CGME20251119075319epcas5p2374c721a42a68cfb6f2b17b17c51c0ea@epcas5p2.samsung.com>
 <20251119075255.2637388-8-s.neeraj@samsung.com>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20251119075255.2637388-8-s.neeraj@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/19/25 12:52 AM, Neeraj Kumar wrote:
> Create export routine nd_region_label_delete() used for deleting
> region label from LSA. It will be used later from CXL subsystem
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>

Just one small thing below, otherwise
Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/nvdimm/label.c          | 76 ++++++++++++++++++++++++++++++---
>  drivers/nvdimm/label.h          |  1 +
>  drivers/nvdimm/namespace_devs.c | 12 ++++++
>  drivers/nvdimm/nd.h             |  6 +++
>  include/linux/libnvdimm.h       |  1 +
>  5 files changed, 90 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index e90e48672da3..da55ecd95e2f 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c
> @@ -1225,7 +1225,8 @@ static int init_labels(struct nd_mapping *nd_mapping, int num_labels,
>  	return max(num_labels, old_num_labels);
>  }
>  
> -static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
> +static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid,
> +		      enum label_type ltype)
>  {
>  	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
>  	struct nd_label_ent *label_ent, *e;
> @@ -1244,11 +1245,25 @@ static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
>  
>  	mutex_lock(&nd_mapping->lock);
>  	list_for_each_entry_safe(label_ent, e, &nd_mapping->labels, list) {
> -		if (label_ent->label)
> +		if ((ltype == NS_LABEL_TYPE && !label_ent->label) ||
> +		    (ltype == RG_LABEL_TYPE && !label_ent->region_label))
>  			continue;
>  		active++;
> -		if (!nsl_uuid_equal(ndd, label_ent->label, uuid))
> -			continue;
> +
> +		switch (ltype) {
> +		case NS_LABEL_TYPE:
> +			if (!nsl_uuid_equal(ndd, label_ent->label, uuid))
> +				continue;
> +
> +			break;
> +		case RG_LABEL_TYPE:
> +			if (!region_label_uuid_equal(label_ent->region_label,
> +			    uuid))
> +				continue;
> +
> +			break;
> +		}
> +
>  		active--;
>  		slot = to_slot(ndd, label_ent);
>  		nd_label_free_slot(ndd, slot);
> @@ -1257,10 +1272,12 @@ static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
>  
>  		if (uuid_equal(&cxl_namespace_uuid, &label_ent->label_uuid))
>  			label_ent->label = NULL;
> +		else
> +			label_ent->region_label = NULL;
>  	}
>  	list_splice_tail_init(&list, &nd_mapping->labels);
>  
> -	if (active == 0) {
> +	if ((ltype == NS_LABEL_TYPE) && (active == 0)) {
>  		nd_mapping_free_labels(nd_mapping);
>  		dev_dbg(ndd->dev, "no more active labels\n");
>  	}
> @@ -1296,7 +1313,8 @@ int nd_pmem_namespace_label_update(struct nd_region *nd_region,
>  		int count = 0;
>  
>  		if (size == 0) {
> -			rc = del_labels(nd_mapping, nspm->uuid);
> +			rc = del_labels(nd_mapping, nspm->uuid,
> +					NS_LABEL_TYPE);
>  			if (rc)
>  				return rc;
>  			continue;
> @@ -1381,6 +1399,52 @@ int nd_pmem_region_label_update(struct nd_region *nd_region)
>  	return 0;
>  }
>  
> +int nd_pmem_region_label_delete(struct nd_region *nd_region)
> +{
> +	struct nd_interleave_set *nd_set = nd_region->nd_set;
> +	struct nd_label_ent *label_ent;
> +	int i, rc;
> +
> +	for (i = 0; i < nd_region->ndr_mappings; i++) {
> +		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
> +		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
> +
> +		/* Find non cxl format supported ndr_mappings */
> +		if (!ndd->cxl) {
> +			dev_info(&nd_region->dev, "Unsupported region label\n");
> +			return -EINVAL;
> +		}
> +
> +		/* Find if any NS label using this region */
> +		guard(mutex)(&nd_mapping->lock);
> +		list_for_each_entry(label_ent, &nd_mapping->labels, list) {
> +			if (!label_ent->label)
> +				continue;
> +
> +			/*
> +			 * Check if any available NS labels has same
> +			 * region_uuid in LSA
> +			 */
> +			if (nsl_region_uuid_equal(label_ent->label,
> +						&nd_set->uuid)) {
> +				dev_dbg(&nd_region->dev,
> +					"Region/Namespace label in use\n");
> +				return -EBUSY;
> +			}
> +		}
> +	}
> +
> +	for (i = 0; i < nd_region->ndr_mappings; i++) {
> +		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
> +
> +		rc = del_labels(nd_mapping, &nd_set->uuid, RG_LABEL_TYPE);
> +		if (rc)
> +			return rc;
> +	}
> +
> +	return 0;
> +}
> +
>  int __init nd_label_init(void)
>  {
>  	WARN_ON(guid_parse(NVDIMM_BTT_GUID, &nvdimm_btt_guid));
> diff --git a/drivers/nvdimm/label.h b/drivers/nvdimm/label.h
> index f11f54056353..80a7f7dd8ba7 100644
> --- a/drivers/nvdimm/label.h
> +++ b/drivers/nvdimm/label.h
> @@ -238,4 +238,5 @@ struct nd_namespace_pmem;
>  int nd_pmem_namespace_label_update(struct nd_region *nd_region,
>  		struct nd_namespace_pmem *nspm, resource_size_t size);
>  int nd_pmem_region_label_update(struct nd_region *nd_region);
> +int nd_pmem_region_label_delete(struct nd_region *nd_region);
>  #endif /* __LABEL_H__ */
> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
> index 9450200b4470..9299a586bfce 100644
> --- a/drivers/nvdimm/namespace_devs.c
> +++ b/drivers/nvdimm/namespace_devs.c
> @@ -244,6 +244,18 @@ int nd_region_label_update(struct nd_region *nd_region)
>  }
>  EXPORT_SYMBOL_GPL(nd_region_label_update);
>  
> +int nd_region_label_delete(struct nd_region *nd_region)
> +{
> +	int rc;
> +
> +	nvdimm_bus_lock(&nd_region->dev);

You can use the new nvdimm_bus guard() now.

guard(nvdimm_bus)(&nd_region->dev);

DJ

> +	rc = nd_pmem_region_label_delete(nd_region);
> +	nvdimm_bus_unlock(&nd_region->dev);
> +
> +	return rc;
> +}
> +EXPORT_SYMBOL_GPL(nd_region_label_delete);
> +
>  static int nd_namespace_label_update(struct nd_region *nd_region,
>  		struct device *dev)
>  {
> diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
> index 30c7262d8a26..b241a0b2e314 100644
> --- a/drivers/nvdimm/nd.h
> +++ b/drivers/nvdimm/nd.h
> @@ -339,6 +339,12 @@ static inline bool is_region_label(struct nvdimm_drvdata *ndd,
>  	return uuid_equal(&cxl_region_uuid, region_type);
>  }
>  
> +static inline bool nsl_region_uuid_equal(struct nd_namespace_label *ns_label,
> +					 const uuid_t *uuid)
> +{
> +	return uuid_equal((uuid_t *) ns_label->cxl.region_uuid, uuid);
> +}
> +
>  static inline bool
>  region_label_uuid_equal(struct cxl_region_label *region_label,
>  			const uuid_t *uuid)
> diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
> index 2c213b9dac66..bbf14a260c93 100644
> --- a/include/linux/libnvdimm.h
> +++ b/include/linux/libnvdimm.h
> @@ -315,6 +315,7 @@ int nvdimm_has_cache(struct nd_region *nd_region);
>  int nvdimm_in_overwrite(struct nvdimm *nvdimm);
>  bool is_nvdimm_sync(struct nd_region *nd_region);
>  int nd_region_label_update(struct nd_region *nd_region);
> +int nd_region_label_delete(struct nd_region *nd_region);
>  
>  static inline int nvdimm_ctl(struct nvdimm *nvdimm, unsigned int cmd, void *buf,
>  		unsigned int buf_len, int *cmd_rc)


