Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4833933A6E5
	for <nvdimm@lists.linux.dev>; Wed, 17 Dec 2025 15:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765983911; cv=none; b=IFOKskE7OV+YmZzS0U5wPlbWLsbvLSKz3HeBhZuDPUvaFkwp9bRHsxGWNElyJWDRWc1lW62k7KplMT/LGpZG4oAW+Spwm4k9Z1mXfAVNhkFkv8WVmyb8JyKs9xNTrfUPiU1H8KCX4ADm2Fi8SHCBUj5rWyJ1HnHXuPCp/jYTZyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765983911; c=relaxed/simple;
	bh=BxLHy4cHoCXjUHBBSAsKpNSy3cSHHiIJ7LWhe92ZvNg=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nI/dvVs+AMpk/C4MyZGS6uOb3lge9EBsUGwCb70svYpjGGnNNOqRdK8rUQ9/PxnLyDkm69dZ/gfRqkGji6u01jKri6/yNFANO0xxf2nf1MJRWsid9ZJoPqtK0w0jVSg+e1/bqezYu4XV3CVYE3YCYnWnquMShJeUaJ4Gph07nIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dWcXS1yJvzHnH5X;
	Wed, 17 Dec 2025 23:04:40 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id A388A40576;
	Wed, 17 Dec 2025 23:05:05 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 17 Dec
 2025 15:05:04 +0000
Date: Wed, 17 Dec 2025 15:05:02 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Neeraj Kumar <s.neeraj@samsung.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <gost.dev@samsung.com>,
	<a.manzanares@samsung.com>, <vishak.g@samsung.com>, <neeraj.kernel@gmail.com>
Subject: Re: [PATCH V4 07/17] nvdimm/label: Add region label delete support
Message-ID: <20251217150502.000018fa@huawei.com>
In-Reply-To: <20251119075255.2637388-8-s.neeraj@samsung.com>
References: <20251119075255.2637388-1-s.neeraj@samsung.com>
	<CGME20251119075319epcas5p2374c721a42a68cfb6f2b17b17c51c0ea@epcas5p2.samsung.com>
	<20251119075255.2637388-8-s.neeraj@samsung.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500010.china.huawei.com (7.191.174.240) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Wed, 19 Nov 2025 13:22:45 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

> Create export routine nd_region_label_delete() used for deleting
> region label from LSA. It will be used later from CXL subsystem
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
A few minor things inline.

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

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

Align after equal( or just go a bit long on this line to improve readability.

> +				continue;
> +
> +			break;
> +		}
> +

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
Unless this gets more complex later, I'd not bother with this local variable.

> +
> +		rc = del_labels(nd_mapping, &nd_set->uuid, RG_LABEL_TYPE);
> +		if (rc)
> +			return rc;
> +	}
> +
> +	return 0;
> +}

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

Similar to earlier. Use the guard() for this to simplify things a little.

> +	rc = nd_pmem_region_label_delete(nd_region);
> +	nvdimm_bus_unlock(&nd_region->dev);
> +
> +	return rc;
> +}
> +EXPORT_SYMBOL_GPL(nd_region_label_delete);
