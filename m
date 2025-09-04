Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3232F0C43
	for <nvdimm@lists.linux.dev>; Thu,  4 Sep 2025 14:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756994815; cv=none; b=B6hXfq7kCDTtNBSjgJibzw0tWFNotDdryb8+Kblz7jnbapiLuhOukkDUI3tPrUR/panOLr+CJufkoOzuJijtX9uKo66kk83JyOF2i4wvsuBmPmtG0LMjbZdrhdrPDHkEIaHWlpDU3mF9iP0PUi0I4dcWgUkx1zGRgswz4FJNaZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756994815; c=relaxed/simple;
	bh=LN4trsiwqoatuevDhzEjiLUvZjNbhPE4QwBE1fJYgCg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=pNqBp6Rj6AOtEYoAUPISChoi7CaQckPtl2UHXcdlp6/LQzt9p1UshgZQdOjq4+th/wqvJLdi/KkOL2XH5cGyECwzFCDbb7IMsVAAIwZFZkUJHLJ7rnC2OF2Ti0+383mM6g9cXeOVBOPrt4ktrxV7trTH0okptb7V3XRCx635RuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=BjTqFkaH; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="BjTqFkaH"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250904140640epoutp0295f2881e64c810b5c9457c57468687d2~iGXY2Zmuc3255332553epoutp02Z
	for <nvdimm@lists.linux.dev>; Thu,  4 Sep 2025 14:06:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250904140640epoutp0295f2881e64c810b5c9457c57468687d2~iGXY2Zmuc3255332553epoutp02Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1756994800;
	bh=QpNFk0B54CNxrWdHDWbagQbykXx8/dneb8A2T1Ez0II=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=BjTqFkaHe5+jxDyukPgA1cr4TeZhdCXIoaGcblqMlwWt+gjCHO2KDz7ayJM/yG8/X
	 mLTNXCdDElWzRwFMGxtBFqss1FgEp2h1tAfKP9NfA9b8gPweqG18sia8YjJ1bUnW0F
	 AEvXtUyRssycfxb2MsH41JYpEJVt06cwfmycg4DA=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20250904140639epcas5p1a63069d5f87812190ec42e111cb1deb9~iGXYiEyHz0163401634epcas5p1t;
	Thu,  4 Sep 2025 14:06:39 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.95]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4cHh9V62x4z6B9m4; Thu,  4 Sep
	2025 14:06:38 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250904140638epcas5p192ce129faa78534b83c3807a9a03ad24~iGXXQrfSO3106931069epcas5p1X;
	Thu,  4 Sep 2025 14:06:38 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250904140637epsmtip1520d3794f03cc6cd959d7d3c5b0b0f31~iGXWHREpO2360223602epsmtip1x;
	Thu,  4 Sep 2025 14:06:37 +0000 (GMT)
Date: Thu, 4 Sep 2025 19:36:31 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V2 05/20] nvdimm/region_label: Add region label updation
 routine
Message-ID: <20250904140631.gxhaxwjjmexexj4t@test-PowerEdge-R740xd>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250813154811.00000257@huawei.com>
X-CMS-MailID: 20250904140638epcas5p192ce129faa78534b83c3807a9a03ad24
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----NUum2bl.CiaUPDLBlJLeOFPEqthXJjtuaYQe8aeKsoDg0nUl=_e261b_"
CMS-TYPE: 105P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250730121228epcas5p411e5cc6d29fb9417178dbd07a1d8f02d
References: <20250730121209.303202-1-s.neeraj@samsung.com>
	<CGME20250730121228epcas5p411e5cc6d29fb9417178dbd07a1d8f02d@epcas5p4.samsung.com>
	<20250730121209.303202-6-s.neeraj@samsung.com>
	<20250813154811.00000257@huawei.com>

------NUum2bl.CiaUPDLBlJLeOFPEqthXJjtuaYQe8aeKsoDg0nUl=_e261b_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 13/08/25 03:48PM, Jonathan Cameron wrote:
>On Wed, 30 Jul 2025 17:41:54 +0530
>Neeraj Kumar <s.neeraj@samsung.com> wrote:
>
>> Added __pmem_region_label_update region label update routine to update
>> region label.
>>
>> Also used guard(mutex)(&nd_mapping->lock) in place of mutex_lock() and
>> mutex_unlock()
>>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>
>A few comments inline,
>
>Thanks,
>
>Jonathan
>
>
>>  static bool slot_valid(struct nvdimm_drvdata *ndd,
>>  		struct nd_lsa_label *lsa_label, u32 slot)
>>  {
>> @@ -960,7 +970,7 @@ static int __pmem_label_update(struct nd_region *nd_region,
>>  		return rc;
>>
>>  	/* Garbage collect the previous label */
>> -	mutex_lock(&nd_mapping->lock);
>> +	guard(mutex)(&nd_mapping->lock);
>>  	list_for_each_entry(label_ent, &nd_mapping->labels, list) {
>>  		if (!label_ent->label)
>>  			continue;
>> @@ -972,20 +982,20 @@ static int __pmem_label_update(struct nd_region *nd_region,
>>  	/* update index */
>>  	rc = nd_label_write_index(ndd, ndd->ns_next,
>>  			nd_inc_seq(__le32_to_cpu(nsindex->seq)), 0);
>> -	if (rc == 0) {
>> -		list_for_each_entry(label_ent, &nd_mapping->labels, list)
>> -			if (!label_ent->label) {
>> -				label_ent->label = lsa_label;
>> -				lsa_label = NULL;
>> -				break;
>> -			}
>> -		dev_WARN_ONCE(&nspm->nsio.common.dev, lsa_label,
>> -				"failed to track label: %d\n",
>> -				to_slot(ndd, lsa_label));
>> -		if (lsa_label)
>> -			rc = -ENXIO;
>> -	}
>> -	mutex_unlock(&nd_mapping->lock);
>> +	if (rc)
>> +		return rc;
>> +
>> +	list_for_each_entry(label_ent, &nd_mapping->labels, list)
>> +		if (!label_ent->label) {
>> +			label_ent->label = lsa_label;
>> +			lsa_label = NULL;
>> +			break;
>> +		}
>> +	dev_WARN_ONCE(&nspm->nsio.common.dev, lsa_label,
>> +			"failed to track label: %d\n",
>> +			to_slot(ndd, lsa_label));
>> +	if (lsa_label)
>> +		rc = -ENXIO;
>	if (lsa_label)
>		return -ENXIO;
>
>	return 0;
>
>is a little clearer.

Sure, I will fix it in next patch-set

>
>>
>>  	return rc;
>>  }
>> @@ -1127,6 +1137,137 @@ int nd_pmem_namespace_label_update(struct nd_region *nd_region,
>>  	return 0;
>>  }
>>
>> +static int __pmem_region_label_update(struct nd_region *nd_region,
>> +		struct nd_mapping *nd_mapping, int pos, unsigned long flags)
>> +{
>> +	struct nd_interleave_set *nd_set = nd_region->nd_set;
>> +	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
>> +	struct nd_lsa_label *nd_label;
>> +	struct cxl_region_label *rg_label;
>> +	struct nd_namespace_index *nsindex;
>> +	struct nd_label_ent *label_ent;
>> +	unsigned long *free;
>> +	u32 nslot, slot;
>> +	size_t offset;
>> +	int rc;
>> +	uuid_t tmp;
>> +
>> +	if (!preamble_next(ndd, &nsindex, &free, &nslot))
>> +		return -ENXIO;
>> +
>> +	/* allocate and write the label to the staging (next) index */
>> +	slot = nd_label_alloc_slot(ndd);
>> +	if (slot == UINT_MAX)
>> +		return -ENXIO;
>> +	dev_dbg(ndd->dev, "allocated: %d\n", slot);
>> +
>> +	nd_label = to_label(ndd, slot);
>> +
>> +	memset(nd_label, 0, sizeof_namespace_label(ndd));
>> +	rg_label = &nd_label->rg_label;
>> +
>> +	/* Set Region Label Format identification UUID */
>> +	uuid_parse(CXL_REGION_UUID, &tmp);
>> +	export_uuid(nd_label->rg_label.type, &tmp);
>
>	export_uuid(rg_label->type, &tmp);

Thanks Jonathan, I will fix it in next patch-set

>
>> +
>> +	/* Set Current Region Label UUID */
>> +	export_uuid(nd_label->rg_label.uuid, &nd_set->uuid);
>
>	export_uuid(rg_label->uuid, &nd_set->uuid);

Sure, I will fix it in next patch-set

>
>
>> +
>> +	rg_label->flags = __cpu_to_le32(flags);
>> +	rg_label->nlabel = __cpu_to_le16(nd_region->ndr_mappings);
>> +	rg_label->position = __cpu_to_le16(pos);
>> +	rg_label->dpa = __cpu_to_le64(nd_mapping->start);
>> +	rg_label->rawsize = __cpu_to_le64(nd_mapping->size);
>> +	rg_label->hpa = __cpu_to_le64(nd_set->res->start);
>> +	rg_label->slot = __cpu_to_le32(slot);
>> +	rg_label->ig = __cpu_to_le32(nd_set->interleave_granularity);
>> +	rg_label->align = __cpu_to_le16(0);
>
>As the bot complained... It's le32

Yes, I will fix it in next patch-set

>
>> +
>> +	/* Update fletcher64 Checksum */
>> +	rgl_calculate_checksum(ndd, rg_label);
>> +
>> +	/* update label */
>> +	offset = nd_label_offset(ndd, nd_label);
>> +	rc = nvdimm_set_config_data(ndd, offset, nd_label,
>> +			sizeof_namespace_label(ndd));
>> +	if (rc < 0) {
>> +		nd_label_free_slot(ndd, slot);
>> +		return rc;
>> +	}
>> +
>> +	/* Garbage collect the previous label */
>> +	guard(mutex)(&nd_mapping->lock);
>> +	list_for_each_entry(label_ent, &nd_mapping->labels, list) {
>> +		if (!label_ent->label)
>> +			continue;
>> +		if (rgl_uuid_equal(&label_ent->label->rg_label, &nd_set->uuid))
>> +			reap_victim(nd_mapping, label_ent);
>> +	}
>> +
>> +	/* update index */
>> +	rc = nd_label_write_index(ndd, ndd->ns_next,
>> +			nd_inc_seq(__le32_to_cpu(nsindex->seq)), 0);
>> +	if (rc)
>> +		return rc;
>> +
>> +	list_for_each_entry(label_ent, &nd_mapping->labels, list)
>> +		if (!label_ent->label) {
>> +			label_ent->label = nd_label;
>> +			nd_label = NULL;
>> +			break;
>> +		}
>> +	dev_WARN_ONCE(&nd_region->dev, nd_label,
>> +			"failed to track label: %d\n",
>> +			to_slot(ndd, nd_label));
>> +	if (nd_label)
>> +		rc = -ENXIO;
>
>		return -ENXIO;
>
>> +
>
>	return 0;
>
>is clearer.

Sure, I will fix it in next patch-set

>
>> +	return rc;
>> +}
>> +
>> +int nd_pmem_region_label_update(struct nd_region *nd_region)
>> +{
>> +	int i, rc;
>> +
>> +	for (i = 0; i < nd_region->ndr_mappings; i++) {
>> +		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
>> +		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
>> +
>> +		/* No need to update region label for non cxl format */
>> +		if (!ndd->cxl)
>> +			continue;
>> +
>> +		/* Init labels to include region label */
>> +		rc = init_labels(nd_mapping, 1);
>> +
>
>No blank line here - keep the error check closely associated with the
>thing that it is checking.

Sure, I will fix it in next patch-set

>
>> +		if (rc < 0)
>> +			return rc;
>> +
>> +		rc = __pmem_region_label_update(nd_region, nd_mapping, i,
>> +					NSLABEL_FLAG_UPDATING);
>> +
>
>Same here.

Sure, I will fix it in next patch-set

>
>> +		if (rc)
>> +			return rc;
>> +	}
>> +
>> +	/* Clear the UPDATING flag per UEFI 2.7 expectations */
>> +	for (i = 0; i < nd_region->ndr_mappings; i++) {
>> +		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
>> +		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
>> +
>> +		/* No need to update region label for non cxl format */
>> +		if (!ndd->cxl)
>> +			continue;
>> +
>> +		rc = __pmem_region_label_update(nd_region, nd_mapping, i, 0);
>> +
>
>and here.

Sure, I will fix it in next patch-set

>
>> +		if (rc)
>> +			return rc;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>  int __init nd_label_init(void)
>>  {
>>  	WARN_ON(guid_parse(NVDIMM_BTT_GUID, &nvdimm_btt_guid));
>> diff --git a/drivers/nvdimm/label.h b/drivers/nvdimm/label.h
>> index 4883b3a1320f..0f428695017d 100644
>> --- a/drivers/nvdimm/label.h
>> +++ b/drivers/nvdimm/label.h
>> @@ -190,6 +190,7 @@ struct nd_namespace_label {
>>  struct nd_lsa_label {
>
>Would be better to have this explicitly as a union
>unless later patches add more elements.  That way it'll
>be obvious at all sites where it is used that it can be one
>of several things.
>
>>  	union {
>>  		struct nd_namespace_label ns_label;
>> +		struct cxl_region_label rg_label;
>>  	};
>>  };

Thanks Jonathan for your suggestion. I will revisit this change and try
using region label handling separately instead of using union.


Regards,
Neeraj

------NUum2bl.CiaUPDLBlJLeOFPEqthXJjtuaYQe8aeKsoDg0nUl=_e261b_
Content-Type: text/plain; charset="utf-8"


------NUum2bl.CiaUPDLBlJLeOFPEqthXJjtuaYQe8aeKsoDg0nUl=_e261b_--
