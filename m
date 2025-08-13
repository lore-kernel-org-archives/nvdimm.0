Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73FE71DD0C7
	for <nvdimm@lists.linux.dev>; Wed, 13 Aug 2025 14:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755096504; cv=none; b=kWTdHn3LGLbMetowYo+7jZgC9HgYJ5IlkHVmUw+0vY0By158dt9e/7WVhJTQCpGM3tUm/5FmT77Rljb2Wl1FDffq772KxqpD9CxJhj81t0iP9ViRe62WxDM6jbFc12aG+qJVeqa5R1QiThc1mu7dckNdVp4hsREK8Chb0C5q+Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755096504; c=relaxed/simple;
	bh=VGZQcknWMnrx0fAlesqHrCNEIJdNyf1Sx92w8cBhl2w=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dD6G9Mq2SE9W2woJruv8atZ+mNWTy02lKEhocJtTcFo9ZEdANHBhqKpaR/C9gwHmQ5Vk7sBO2gTKRSVT6P43SpSV8sW/zrdO8Q48AgVx6YMm9QKR1KPKx6BOmOtVvFlfbi8opbWVn8xQ91l9wyx1y1NPtrj6LS1F0TdvhLSwQds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4c2B4X60fRz67H47;
	Wed, 13 Aug 2025 22:45:32 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id D5F9F140121;
	Wed, 13 Aug 2025 22:48:13 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 13 Aug
 2025 16:48:13 +0200
Date: Wed, 13 Aug 2025 15:48:11 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Neeraj Kumar <s.neeraj@samsung.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <gost.dev@samsung.com>,
	<a.manzanares@samsung.com>, <vishak.g@samsung.com>, <neeraj.kernel@gmail.com>
Subject: Re: [PATCH V2 05/20] nvdimm/region_label: Add region label updation
 routine
Message-ID: <20250813154811.00000257@huawei.com>
In-Reply-To: <20250730121209.303202-6-s.neeraj@samsung.com>
References: <20250730121209.303202-1-s.neeraj@samsung.com>
	<CGME20250730121228epcas5p411e5cc6d29fb9417178dbd07a1d8f02d@epcas5p4.samsung.com>
	<20250730121209.303202-6-s.neeraj@samsung.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100005.china.huawei.com (7.191.160.25) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Wed, 30 Jul 2025 17:41:54 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

> Added __pmem_region_label_update region label update routine to update
> region label.
> 
> Also used guard(mutex)(&nd_mapping->lock) in place of mutex_lock() and
> mutex_unlock()
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>

A few comments inline,

Thanks,

Jonathan


>  static bool slot_valid(struct nvdimm_drvdata *ndd,
>  		struct nd_lsa_label *lsa_label, u32 slot)
>  {
> @@ -960,7 +970,7 @@ static int __pmem_label_update(struct nd_region *nd_region,
>  		return rc;
>  
>  	/* Garbage collect the previous label */
> -	mutex_lock(&nd_mapping->lock);
> +	guard(mutex)(&nd_mapping->lock);
>  	list_for_each_entry(label_ent, &nd_mapping->labels, list) {
>  		if (!label_ent->label)
>  			continue;
> @@ -972,20 +982,20 @@ static int __pmem_label_update(struct nd_region *nd_region,
>  	/* update index */
>  	rc = nd_label_write_index(ndd, ndd->ns_next,
>  			nd_inc_seq(__le32_to_cpu(nsindex->seq)), 0);
> -	if (rc == 0) {
> -		list_for_each_entry(label_ent, &nd_mapping->labels, list)
> -			if (!label_ent->label) {
> -				label_ent->label = lsa_label;
> -				lsa_label = NULL;
> -				break;
> -			}
> -		dev_WARN_ONCE(&nspm->nsio.common.dev, lsa_label,
> -				"failed to track label: %d\n",
> -				to_slot(ndd, lsa_label));
> -		if (lsa_label)
> -			rc = -ENXIO;
> -	}
> -	mutex_unlock(&nd_mapping->lock);
> +	if (rc)
> +		return rc;
> +
> +	list_for_each_entry(label_ent, &nd_mapping->labels, list)
> +		if (!label_ent->label) {
> +			label_ent->label = lsa_label;
> +			lsa_label = NULL;
> +			break;
> +		}
> +	dev_WARN_ONCE(&nspm->nsio.common.dev, lsa_label,
> +			"failed to track label: %d\n",
> +			to_slot(ndd, lsa_label));
> +	if (lsa_label)
> +		rc = -ENXIO;
	if (lsa_label)
		return -ENXIO;

	return 0;

is a little clearer.

>  
>  	return rc;
>  }
> @@ -1127,6 +1137,137 @@ int nd_pmem_namespace_label_update(struct nd_region *nd_region,
>  	return 0;
>  }
>  
> +static int __pmem_region_label_update(struct nd_region *nd_region,
> +		struct nd_mapping *nd_mapping, int pos, unsigned long flags)
> +{
> +	struct nd_interleave_set *nd_set = nd_region->nd_set;
> +	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
> +	struct nd_lsa_label *nd_label;
> +	struct cxl_region_label *rg_label;
> +	struct nd_namespace_index *nsindex;
> +	struct nd_label_ent *label_ent;
> +	unsigned long *free;
> +	u32 nslot, slot;
> +	size_t offset;
> +	int rc;
> +	uuid_t tmp;
> +
> +	if (!preamble_next(ndd, &nsindex, &free, &nslot))
> +		return -ENXIO;
> +
> +	/* allocate and write the label to the staging (next) index */
> +	slot = nd_label_alloc_slot(ndd);
> +	if (slot == UINT_MAX)
> +		return -ENXIO;
> +	dev_dbg(ndd->dev, "allocated: %d\n", slot);
> +
> +	nd_label = to_label(ndd, slot);
> +
> +	memset(nd_label, 0, sizeof_namespace_label(ndd));
> +	rg_label = &nd_label->rg_label;
> +
> +	/* Set Region Label Format identification UUID */
> +	uuid_parse(CXL_REGION_UUID, &tmp);
> +	export_uuid(nd_label->rg_label.type, &tmp);

	export_uuid(rg_label->type, &tmp);

> +
> +	/* Set Current Region Label UUID */
> +	export_uuid(nd_label->rg_label.uuid, &nd_set->uuid);

	export_uuid(rg_label->uuid, &nd_set->uuid);


> +
> +	rg_label->flags = __cpu_to_le32(flags);
> +	rg_label->nlabel = __cpu_to_le16(nd_region->ndr_mappings);
> +	rg_label->position = __cpu_to_le16(pos);
> +	rg_label->dpa = __cpu_to_le64(nd_mapping->start);
> +	rg_label->rawsize = __cpu_to_le64(nd_mapping->size);
> +	rg_label->hpa = __cpu_to_le64(nd_set->res->start);
> +	rg_label->slot = __cpu_to_le32(slot);
> +	rg_label->ig = __cpu_to_le32(nd_set->interleave_granularity);
> +	rg_label->align = __cpu_to_le16(0);

As the bot complained... It's le32

> +
> +	/* Update fletcher64 Checksum */
> +	rgl_calculate_checksum(ndd, rg_label);
> +
> +	/* update label */
> +	offset = nd_label_offset(ndd, nd_label);
> +	rc = nvdimm_set_config_data(ndd, offset, nd_label,
> +			sizeof_namespace_label(ndd));
> +	if (rc < 0) {
> +		nd_label_free_slot(ndd, slot);
> +		return rc;
> +	}
> +
> +	/* Garbage collect the previous label */
> +	guard(mutex)(&nd_mapping->lock);
> +	list_for_each_entry(label_ent, &nd_mapping->labels, list) {
> +		if (!label_ent->label)
> +			continue;
> +		if (rgl_uuid_equal(&label_ent->label->rg_label, &nd_set->uuid))
> +			reap_victim(nd_mapping, label_ent);
> +	}
> +
> +	/* update index */
> +	rc = nd_label_write_index(ndd, ndd->ns_next,
> +			nd_inc_seq(__le32_to_cpu(nsindex->seq)), 0);
> +	if (rc)
> +		return rc;
> +
> +	list_for_each_entry(label_ent, &nd_mapping->labels, list)
> +		if (!label_ent->label) {
> +			label_ent->label = nd_label;
> +			nd_label = NULL;
> +			break;
> +		}
> +	dev_WARN_ONCE(&nd_region->dev, nd_label,
> +			"failed to track label: %d\n",
> +			to_slot(ndd, nd_label));
> +	if (nd_label)
> +		rc = -ENXIO;

		return -ENXIO;

> +

	return 0;

is clearer.

> +	return rc;
> +}
> +
> +int nd_pmem_region_label_update(struct nd_region *nd_region)
> +{
> +	int i, rc;
> +
> +	for (i = 0; i < nd_region->ndr_mappings; i++) {
> +		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
> +		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
> +
> +		/* No need to update region label for non cxl format */
> +		if (!ndd->cxl)
> +			continue;
> +
> +		/* Init labels to include region label */
> +		rc = init_labels(nd_mapping, 1);
> +

No blank line here - keep the error check closely associated with the
thing that it is checking.

> +		if (rc < 0)
> +			return rc;
> +
> +		rc = __pmem_region_label_update(nd_region, nd_mapping, i,
> +					NSLABEL_FLAG_UPDATING);
> +

Same here.

> +		if (rc)
> +			return rc;
> +	}
> +
> +	/* Clear the UPDATING flag per UEFI 2.7 expectations */
> +	for (i = 0; i < nd_region->ndr_mappings; i++) {
> +		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
> +		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
> +
> +		/* No need to update region label for non cxl format */
> +		if (!ndd->cxl)
> +			continue;
> +
> +		rc = __pmem_region_label_update(nd_region, nd_mapping, i, 0);
> +

and here.

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
> index 4883b3a1320f..0f428695017d 100644
> --- a/drivers/nvdimm/label.h
> +++ b/drivers/nvdimm/label.h
> @@ -190,6 +190,7 @@ struct nd_namespace_label {
>  struct nd_lsa_label {

Would be better to have this explicitly as a union
unless later patches add more elements.  That way it'll 
be obvious at all sites where it is used that it can be one
of several things.

>  	union {
>  		struct nd_namespace_label ns_label;
> +		struct cxl_region_label rg_label;
>  	};
>  };
>  
> @@ -233,4 +234,5 @@ struct nd_region;
>  struct nd_namespace_pmem;
>  int nd_pmem_namespace_label_update(struct nd_region *nd_region,
>  		struct nd_namespace_pmem *nspm, resource_size_t size);
> +int nd_pmem_region_label_update(struct nd_region *nd_region);
>  #endif /* __LABEL_H__ */


