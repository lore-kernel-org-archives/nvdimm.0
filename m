Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4C0244690
	for <nvdimm@lists.linux.dev>; Fri, 15 Aug 2025 22:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755296561; cv=none; b=QhvWhld2nZ5d9mWdEwZSZMYCRKTqIXb2O8ZKH2N4rTbSuNuV2IcMncDpQi5E90rCdssq/pS1qIdZ9YCs0JosmfUK3e4N8JzRM10e1xHwsQWnt85ByQToSMErTqwiklqV+9dUtzsOz0mtY1TzEIfSstUVkvGwKAF+5pmaYNIwwcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755296561; c=relaxed/simple;
	bh=aXCY1lGZXU4wb1kzg6itn4oaYVR+j3HG37VQ140BkI8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KQLFCpCcf9TPqc3B58Jufk8y6Aui9qgM/DVd9aPseYFwXnr8Q29j2yVG8wYjlkCXZv3oBRpEXZVZQZYlBzNroY3/xgiX4h3zBZEwNYCUUKuArZJqcP/RBGDpAJLv9fn1nvFGkzb3uNK0134dL2FaUk691MHJsAVvuz4Nya2kT1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ESstAl4r; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ESstAl4r"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755296560; x=1786832560;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=aXCY1lGZXU4wb1kzg6itn4oaYVR+j3HG37VQ140BkI8=;
  b=ESstAl4rs+wTIXyFNDaQ3EoVGaKhhY/urfgyWOIRcw5sK+Jz+0kJhcMr
   83psQm/GLCZNmDykaUMi8i+g1+IKa6NgkG9c3yAXYmdFc9FURbvQJUQHz
   Bt8bZ9kmwG5Ft1dI1eDjgyVaonZBmFbl5f5RRdf3VCu27oLFAszkHmPop
   2lw1w1OAsg+d283ono5Iq5/ZL3HY1aiynFgtzXmcTtTq7OI1Yrd8ta8tb
   2pgJXnNLezVBpPMzYzTvupzSaBWJfnzYtu74e6SoQp24kb6HdNA7A371c
   2OVCXuy4FJuDJlneSastiWiO4MhXNyIwIEPUETLSVhQ8MahLRSZtsk/yu
   Q==;
X-CSE-ConnectionGUID: b6UhfHTIT7axMNrKuf9RHQ==
X-CSE-MsgGUID: i9ZpECE5SJa6sv1YLXy5Hg==
X-IronPort-AV: E=McAfee;i="6800,10657,11523"; a="45192251"
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="45192251"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2025 15:22:39 -0700
X-CSE-ConnectionGUID: kzZFNrRPQceQ4XFlQ/kU9A==
X-CSE-MsgGUID: 9MCNFcF7QwCnmGGPX3jotQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="166598725"
Received: from anmitta2-mobl4.gar.corp.intel.com (HELO [10.247.119.183]) ([10.247.119.183])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2025 15:22:34 -0700
Message-ID: <4de40bdd-4ef3-4eea-8f11-43d71a6369cc@intel.com>
Date: Fri, 15 Aug 2025 15:22:29 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 06/20] nvdimm/region_label: Add region label deletion
 routine
To: Neeraj Kumar <s.neeraj@samsung.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com
References: <20250730121209.303202-1-s.neeraj@samsung.com>
 <CGME20250730121230epcas5p11650f090de55d0a2db541ee32e9a6fee@epcas5p1.samsung.com>
 <20250730121209.303202-7-s.neeraj@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20250730121209.303202-7-s.neeraj@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/30/25 5:11 AM, Neeraj Kumar wrote:
> Added cxl v2.1 format region label deletion routine. This function is
> used to delete region label from LSA
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
> ---
>  drivers/nvdimm/label.c          | 77 ++++++++++++++++++++++++++++++---
>  drivers/nvdimm/label.h          |  6 +++
>  drivers/nvdimm/namespace_devs.c | 12 +++++
>  drivers/nvdimm/nd.h             |  9 ++++
>  include/linux/libnvdimm.h       |  1 +
>  5 files changed, 100 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index 94f2d0ba7aca..be18278d6cea 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c
> @@ -1044,7 +1044,8 @@ static int init_labels(struct nd_mapping *nd_mapping, int num_labels)
>  	return max(num_labels, old_num_labels);
>  }
>  
> -static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
> +static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid,
> +		enum label_type ltype)
>  {
>  	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
>  	struct nd_label_ent *label_ent, *e;
> @@ -1068,8 +1069,23 @@ static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
>  		if (!nd_label)
>  			continue;
>  		active++;
> -		if (!nsl_uuid_equal(ndd, &nd_label->ns_label, uuid))
> -			continue;
> +
> +		switch (ltype) {
> +		case NS_LABEL_TYPE:
> +			if (!nsl_uuid_equal(ndd, &nd_label->ns_label, uuid))
> +				continue;
> +
> +			break;
> +		case RG_LABEL_TYPE:
> +			if (!rgl_uuid_equal(&nd_label->rg_label, uuid))
> +				continue;
> +
> +			break;
> +		default:
> +			dev_err(ndd->dev, "Invalid label type\n");
> +			return 0;
> +		}
> +
>  		active--;
>  		slot = to_slot(ndd, nd_label);
>  		nd_label_free_slot(ndd, slot);
> @@ -1079,7 +1095,7 @@ static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
>  	}
>  	list_splice_tail_init(&list, &nd_mapping->labels);
>  
> -	if (active == 0) {
> +	if ((ltype == NS_LABEL_TYPE) && (active == 0)) {
>  		nd_mapping_free_labels(nd_mapping);
>  		dev_dbg(ndd->dev, "no more active labels\n");
>  	}
> @@ -1101,7 +1117,8 @@ int nd_pmem_namespace_label_update(struct nd_region *nd_region,
>  		int count = 0;
>  
>  		if (size == 0) {
> -			rc = del_labels(nd_mapping, nspm->uuid);
> +			rc = del_labels(nd_mapping, nspm->uuid,
> +					NS_LABEL_TYPE);
>  			if (rc)
>  				return rc;
>  			continue;
> @@ -1268,6 +1285,56 @@ int nd_pmem_region_label_update(struct nd_region *nd_region)
>  	return 0;
>  }
>  
> +int nd_pmem_region_label_delete(struct nd_region *nd_region)
> +{
> +	int i, rc;
> +	struct nd_interleave_set *nd_set = nd_region->nd_set;
> +	struct nd_label_ent *label_ent;
> +	int ns_region_cnt = 0;

reverse xmas tree pls

> +
> +	for (i = 0; i < nd_region->ndr_mappings; i++) {
> +		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
> +		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
> +
> +		/* Find non cxl format supported ndr_mappings */
> +		if (!ndd->cxl) {
> +			dev_info(&nd_region->dev, "Region label unsupported\n");
> +			return -EINVAL;
> +		}
> +
> +		/* Find if any NS label using this region */
> +		mutex_lock(&nd_mapping->lock);
> +		list_for_each_entry(label_ent, &nd_mapping->labels, list) {
> +			if (!label_ent->label)
> +				continue;
> +
> +			/*
> +			 * Check if any available NS labels has same
> +			 * region_uuid in LSA
> +			 */
> +			if (nsl_region_uuid_equal(&label_ent->label->ns_label,
> +						  &nd_set->uuid))
> +				ns_region_cnt++;
> +		}
> +		mutex_unlock(&nd_mapping->lock);
> +	}
> +
> +	if (ns_region_cnt) {
> +		dev_dbg(&nd_region->dev, "Region/Namespace label in use\n");
> +		return -EBUSY;
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
> index 0f428695017d..cc14068511cf 100644
> --- a/drivers/nvdimm/label.h
> +++ b/drivers/nvdimm/label.h
> @@ -30,6 +30,11 @@ enum {
>  	ND_NSINDEX_INIT = 0x1,
>  };
>  
> +enum label_type {
> +	RG_LABEL_TYPE,

REGION_LABEL_TYPE preferred

> +	NS_LABEL_TYPE,
> +};
> +
>  /**
>   * struct nd_namespace_index - label set superblock
>   * @sig: NAMESPACE_INDEX\0
> @@ -235,4 +240,5 @@ struct nd_namespace_pmem;
>  int nd_pmem_namespace_label_update(struct nd_region *nd_region,
>  		struct nd_namespace_pmem *nspm, resource_size_t size);
>  int nd_pmem_region_label_update(struct nd_region *nd_region);
> +int nd_pmem_region_label_delete(struct nd_region *nd_region);
>  #endif /* __LABEL_H__ */
> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
> index 02ae8162566c..e5c2f78ca7dd 100644
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
> index 15d94e3937f0..6585747154c2 100644
> --- a/drivers/nvdimm/nd.h
> +++ b/drivers/nvdimm/nd.h
> @@ -322,6 +322,15 @@ static inline void nsl_set_region_uuid(struct nvdimm_drvdata *ndd,
>  		export_uuid(ns_label->cxl.region_uuid, uuid);
>  }
>  
> +static inline bool nsl_region_uuid_equal(struct nd_namespace_label *ns_label,
> +				  const uuid_t *uuid)
> +{
> +	uuid_t tmp;

s/tmp/uuid/

> +
> +	import_uuid(&tmp, ns_label->cxl.region_uuid);
> +	return uuid_equal(&tmp, uuid);
> +}
> +
>  static inline bool rgl_uuid_equal(struct cxl_region_label *rg_label,
>  				  const uuid_t *uuid)
>  {
> diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
> index b06bd45373f4..b2e16914ab52 100644
> --- a/include/linux/libnvdimm.h
> +++ b/include/linux/libnvdimm.h
> @@ -310,6 +310,7 @@ int nvdimm_has_cache(struct nd_region *nd_region);
>  int nvdimm_in_overwrite(struct nvdimm *nvdimm);
>  bool is_nvdimm_sync(struct nd_region *nd_region);
>  int nd_region_label_update(struct nd_region *nd_region);
> +int nd_region_label_delete(struct nd_region *nd_region);
>  
>  static inline int nvdimm_ctl(struct nvdimm *nvdimm, unsigned int cmd, void *buf,
>  		unsigned int buf_len, int *cmd_rc)

