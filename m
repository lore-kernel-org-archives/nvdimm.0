Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7843A3F09
	for <nvdimm@lists.linux.dev>; Wed, 17 Dec 2025 14:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765981901; cv=none; b=flAR5drqQJ4i2gU2JJj/XOMPK5JLugj8zjjEsve4Q46mP/nzPT4vwEQ/ezb+XuwCMIdB4HwuiTZsLwtvN7hOB8IlegPo5cJ8yl71CvWl8I1u7bN2fA1HyKM9GGdHQYSXuu7b0lBRY4nXUaSI6kZwocho1Re2+wgJ6Eapw71cewM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765981901; c=relaxed/simple;
	bh=a66rKQ9Iz3JERQ7jJa5b2/oBz7TesvgqfSJe/vTvL+M=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=du90KxDjG/dk9Yg4S7ZnFuLjv8XRZRckhSjZURHKBG82M5k/zKSlIUPcstnah4m3Avw+GAS1qqfcWBOoT9t+fW9ssM7PBGXTjSEi5RZSZrT/+JN+RPRNtq0BBQ53TU5RVc1dBFkNNfESO8WAN2zCwRVhJe9Ly90pGCz9d5EwmXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dWbnk285yzJ469G;
	Wed, 17 Dec 2025 22:31:06 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id C02EA4056B;
	Wed, 17 Dec 2025 22:31:35 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 17 Dec
 2025 14:31:35 +0000
Date: Wed, 17 Dec 2025 14:31:33 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Neeraj Kumar <s.neeraj@samsung.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <gost.dev@samsung.com>,
	<a.manzanares@samsung.com>, <vishak.g@samsung.com>, <neeraj.kernel@gmail.com>
Subject: Re: [PATCH V4 03/17] nvdimm/label: Add namespace/region label
 support as per LSA 2.1
Message-ID: <20251217143133.00003109@huawei.com>
In-Reply-To: <20251119075255.2637388-4-s.neeraj@samsung.com>
References: <20251119075255.2637388-1-s.neeraj@samsung.com>
	<CGME20251119075311epcas5p1af6f86ca65fd4a8452979e861b87a841@epcas5p1.samsung.com>
	<20251119075255.2637388-4-s.neeraj@samsung.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100009.china.huawei.com (7.191.174.83) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Wed, 19 Nov 2025 13:22:41 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

> Modify __pmem_label_update() to update region labels into LSA
> 
> CXL 3.2 Spec mentions CXL LSA 2.1 Namespace Labels at section 9.13.2.5
> Modified __pmem_label_update() using setter functions to update
> namespace label as per CXL LSA 2.1
> 
> Create export routine nd_region_label_update() used for creating
> region label into LSA. It will be used later from CXL subsystem
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
Hi Neeraj,

A few things inline from a fresh read.

Thanks,

Jonathan

> ---
>  drivers/nvdimm/label.c          | 360 ++++++++++++++++++++++++++------
>  drivers/nvdimm/label.h          |  17 +-
>  drivers/nvdimm/namespace_devs.c |  25 ++-
>  drivers/nvdimm/nd.h             |  66 ++++++
>  include/linux/libnvdimm.h       |   8 +
>  5 files changed, 406 insertions(+), 70 deletions(-)
> 
> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index 0a9b6c5cb2c3..0d587a5b9f7e 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c




> @@ -978,7 +1132,8 @@ static int __pmem_label_update(struct nd_region *nd_region,
>  	return rc;
>  }

>  int nd_pmem_namespace_label_update(struct nd_region *nd_region,
>  		struct nd_namespace_pmem *nspm, resource_size_t size)
>  {
> @@ -1075,6 +1253,7 @@ int nd_pmem_namespace_label_update(struct nd_region *nd_region,
>  	for (i = 0; i < nd_region->ndr_mappings; i++) {
>  		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
>  		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
> +		int region_label_cnt = 0;

Always initialized anyway before use I think. So no need to do it here.

>  		struct resource *res;
>  		int count = 0;
>  
> @@ -1090,12 +1269,20 @@ int nd_pmem_namespace_label_update(struct nd_region *nd_region,
>  				count++;
>  		WARN_ON_ONCE(!count);
>  
> -		rc = init_labels(nd_mapping, count);
> +		region_label_cnt = find_region_label_count(nd_mapping);
> +		/*
> +		 * init_labels() scan labels and allocate new label based
> +		 * on its second parameter (num_labels). Therefore to
> +		 * allocate new namespace label also include previously
> +		 * added region label
> +		 */
> +		rc = init_labels(nd_mapping, count + region_label_cnt,
> +				 NS_LABEL_TYPE);
>  		if (rc < 0)
>  			return rc;
>  
>  		rc = __pmem_label_update(nd_region, nd_mapping, nspm, i,
> -				NSLABEL_FLAG_UPDATING);
> +				NSLABEL_FLAG_UPDATING, NS_LABEL_TYPE);
>  		if (rc)
>  			return rc;
>  	}

> +int nd_pmem_region_label_update(struct nd_region *nd_region)
> +{
> +	int i, rc;
> +
> +	for (i = 0; i < nd_region->ndr_mappings; i++) {
> +		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
> +		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
> +		int region_label_cnt = 0;

Seems to always be initialized before use anyway so no need to do it here.

> +
> +		/* No need to update region label for non cxl format */
> +		if (!ndd->cxl)
> +			return 0;
> +
> +		region_label_cnt = find_region_label_count(nd_mapping);
> +		rc = init_labels(nd_mapping, region_label_cnt + 1,
> +				 RG_LABEL_TYPE);
> +		if (rc < 0)
> +			return rc;
> +
> +		rc = __pmem_label_update(nd_region, nd_mapping, NULL, i,
> +				NSLABEL_FLAG_UPDATING, RG_LABEL_TYPE);
> +		if (rc)
> +			return rc;
> +	}
> +
> +	/* Clear the UPDATING flag per UEFI 2.7 expectations */
> +	for (i = 0; i < nd_region->ndr_mappings; i++) {
> +		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
> +		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
> +
> +		WARN_ON_ONCE(!ndd->cxl);
> +		rc = __pmem_label_update(nd_region, nd_mapping, NULL, i, 0,
> +				RG_LABEL_TYPE);
>  		if (rc)
>  			return rc;
>  	}

> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
> index 43fdb806532e..b1abbe602a5e 100644
> --- a/drivers/nvdimm/namespace_devs.c
> +++ b/drivers/nvdimm/namespace_devs.c
> @@ -232,6 +232,18 @@ static ssize_t __alt_name_store(struct device *dev, const char *buf,
>  	return rc;
>  }
>  
> +int nd_region_label_update(struct nd_region *nd_region)
> +{
> +	int rc;
> +
> +	nvdimm_bus_lock(&nd_region->dev);
> +	rc = nd_pmem_region_label_update(nd_region);
> +	nvdimm_bus_unlock(&nd_region->dev);

In line with much of the nvdimm stuff I'd use guard and save a couple of lines.

	guard(nvdimm_bus)(&nd_region->dev);
	return nd_pmem_region_label_update(nd_region);

> +
> +	return rc;
> +}
> +EXPORT_SYMBOL_GPL(nd_region_label_update);

> diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
> index f631bd84d6f0..5fd69c28ffe7 100644
> --- a/drivers/nvdimm/nd.h
> +++ b/drivers/nvdimm/nd.h
> @@ -14,6 +14,9 @@
>  #include <linux/nd.h>
>  #include "label.h"
>  
> +extern uuid_t cxl_namespace_uuid;
> +extern uuid_t cxl_region_uuid;
> +
>  enum {
>  	/*
>  	 * Limits the maximum number of block apertures a dimm can
> @@ -295,6 +298,67 @@ static inline const u8 *nsl_uuid_raw(struct nvdimm_drvdata *ndd,
>  	return nd_label->efi.uuid;
>  }
>  
> +static inline void nsl_set_type(struct nvdimm_drvdata *ndd,
> +				struct nd_namespace_label *ns_label)
> +{
> +	if (!(ndd->cxl && ns_label))
> +		return;
> +
> +	uuid_copy((uuid_t *)ns_label->cxl.type, &cxl_namespace_uuid);

uuid_import() perhaps more appropriate given it is coming(I think)
from a __u8 &.

> +}
> +


> +
> +static inline bool is_region_label(struct nvdimm_drvdata *ndd,
> +				   union nd_lsa_label *lsa_label)
> +{
> +	uuid_t *region_type;
> +
> +	if (!ndd->cxl)
> +		return false;
> +
> +	region_type = (uuid_t *) lsa_label->region_label.type;
> +	return uuid_equal(&cxl_region_uuid, region_type)

I'd match style of next function and not have the local variable.

	return uuid_equal(&cxl_region_uuid,
			  (uuid_t *)lsa_label->region_label.type);
> +}
> +
> +static inline bool
> +region_label_uuid_equal(struct cxl_region_label *region_label,
> +			const uuid_t *uuid)
> +{
> +	return uuid_equal((uuid_t *) region_label->uuid, uuid);

Dave pointed out that there shouldn't be a space after the cast.
Make sure you catch all of these.

> +}
> +
> +static inline u64
> +region_label_get_checksum(struct cxl_region_label *region_label)
> +{
> +	return __le64_to_cpu(region_label->checksum);
> +}
> +
> +static inline void
> +region_label_set_checksum(struct cxl_region_label *region_label,
> +			  u64 checksum)
> +{
> +	region_label->checksum = __cpu_to_le64(checksum);
> +}

Perhaps add a little justification to the patch description on why these
get/set are helpful? Seems like just setting them directly would perhaps
be fine as all call sites can see the structure definition anyway?

> +
>  bool nsl_validate_type_guid(struct nvdimm_drvdata *ndd,
>  			    struct nd_namespace_label *nd_label, guid_t *guid);
>  enum nvdimm_claim_class nsl_get_claim_class(struct nvdimm_drvdata *ndd,
> @@ -376,7 +440,9 @@ enum nd_label_flags {
>  struct nd_label_ent {
>  	struct list_head list;
>  	unsigned long flags;
> +	uuid_t label_uuid;
>  	struct nd_namespace_label *label;
> +	struct cxl_region_label *region_label;
>  };
>  
>  enum nd_mapping_lock_class {
> diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
> index 5696715c33bb..2c213b9dac66 100644
> --- a/include/linux/libnvdimm.h
> +++ b/include/linux/libnvdimm.h
> @@ -117,6 +117,13 @@ struct nd_interleave_set {
>  	u64 altcookie;
>  
>  	guid_t type_guid;
> +
> +	/* v2.1 region label info */
> +	uuid_t uuid;
> +	int interleave_ways;
> +	int interleave_granularity;
> +	struct resource *res;
> +	int nr_targets;
>  };
>  
>  struct nd_mapping_desc {
> @@ -307,6 +314,7 @@ int nvdimm_has_flush(struct nd_region *nd_region);
>  int nvdimm_has_cache(struct nd_region *nd_region);
>  int nvdimm_in_overwrite(struct nvdimm *nvdimm);
>  bool is_nvdimm_sync(struct nd_region *nd_region);
> +int nd_region_label_update(struct nd_region *nd_region);
>  
>  static inline int nvdimm_ctl(struct nvdimm *nvdimm, unsigned int cmd, void *buf,
>  		unsigned int buf_len, int *cmd_rc)

