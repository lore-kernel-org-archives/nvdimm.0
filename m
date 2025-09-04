Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61CC2D372E
	for <nvdimm@lists.linux.dev>; Fri,  5 Sep 2025 07:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757055789; cv=none; b=OnZPah/ApehxOAY9KXQyK7Trojy3fFWz1A1AuldjLxoovBGV3xRFoBg57umQfSnBcFaGbn+DmK6vDNJDs0iWwbRBe+wH1uM6qAFy2UhEGq3CrY76xX83+N6oyfkPeSdyRScnuGJKTEE9t3KOKq4RDetnleCUbg+1/sY5rG6N+Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757055789; c=relaxed/simple;
	bh=+fq3Erfz06JRPTfmgjoWB9Cuhs9eyh91027A/nDT/qQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=pxc4HpPrNdtr9Y3C646ZCb1u8A/QUjS8OqwiQgoB7zv0YpLi5qmtd4bmLcCIiQ/UFHEZOeuVXTw0vzk0TQc4Gt68/Kpp6WigWZhQ/KJSn3aCQJkouQHbp4DA55+01KtZhPkeoux9PCiimiRbdZ9p+IkLe5Ccd5WcLLFscLLa/0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=NZ53kPw2; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="NZ53kPw2"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250905070303epoutp019143feb5d5a5a21f9c63eca6796d43ea~iUO0QDiFj0784007840epoutp01T
	for <nvdimm@lists.linux.dev>; Fri,  5 Sep 2025 07:03:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250905070303epoutp019143feb5d5a5a21f9c63eca6796d43ea~iUO0QDiFj0784007840epoutp01T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1757055783;
	bh=HlzlzRPZH83wC/RKTuXoHYOpt7ekgr2+Fd1wmfGvj54=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=NZ53kPw2AaGgwo8e9T7NBpbcHWR6EPeDKxpJ3W1BZaebIiUlTorqwyN0u0vEtomQr
	 4mdWhwsWs1j135f92plOsPiAXPRxEu/ALoMVEKCHLePK7kJeLv2JdVWOlTO6bMruyW
	 0ZMBuHjpEa31VRystnQ/rmFi0W9b+dzW373qGS1s=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20250905070303epcas5p456269f75097d9509ef75a8eab2836829~iUOz0etkp1157611576epcas5p4K;
	Fri,  5 Sep 2025 07:03:03 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4cJ6kH1hm5z6B9mJ; Fri,  5 Sep
	2025 07:03:03 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250904141238epcas5p1a72030f918fd6fe376f97e8f626486f7~iGcmtiV-y0242202422epcas5p1O;
	Thu,  4 Sep 2025 14:12:38 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250904141237epsmtip183c64ff5b9abc065cfe732871b6a01af~iGclkqbI12518725187epsmtip1c;
	Thu,  4 Sep 2025 14:12:37 +0000 (GMT)
Date: Thu, 4 Sep 2025 19:42:31 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V2 05/20] nvdimm/region_label: Add region label updation
 routine
Message-ID: <158453976.61757055783236.JavaMail.epsvc@epcpadp2new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <534936cc-4ecc-46e5-8196-bc3992e086ab@intel.com>
X-CMS-MailID: 20250904141238epcas5p1a72030f918fd6fe376f97e8f626486f7
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----AO5Z5CA5q82FpJQJAbIGDvoW6m12ppu.cCYhbwpEEtg295OJ=_ead75_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250730121228epcas5p411e5cc6d29fb9417178dbd07a1d8f02d
References: <20250730121209.303202-1-s.neeraj@samsung.com>
	<CGME20250730121228epcas5p411e5cc6d29fb9417178dbd07a1d8f02d@epcas5p4.samsung.com>
	<20250730121209.303202-6-s.neeraj@samsung.com>
	<534936cc-4ecc-46e5-8196-bc3992e086ab@intel.com>

------AO5Z5CA5q82FpJQJAbIGDvoW6m12ppu.cCYhbwpEEtg295OJ=_ead75_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 15/08/25 02:55PM, Dave Jiang wrote:
>
>
>On 7/30/25 5:11 AM, Neeraj Kumar wrote:
>> Added __pmem_region_label_update region label update routine to update
>> region label.
>>
>> Also used guard(mutex)(&nd_mapping->lock) in place of mutex_lock() and
>> mutex_unlock()
>>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>
>Subject, s/updation/update/ ?

Thanks Dave, Sure. Will fix it in next patch-set

>
>> ---
>>  drivers/nvdimm/label.c          | 171 +++++++++++++++++++++++++++++---
>>  drivers/nvdimm/label.h          |   2 +
>>  drivers/nvdimm/namespace_devs.c |  12 +++
>>  drivers/nvdimm/nd.h             |  20 ++++
>>  include/linux/libnvdimm.h       |   8 ++
>>  5 files changed, 198 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
>> index 3f8a6bdb77c7..94f2d0ba7aca 100644
>> --- a/drivers/nvdimm/label.c
>> +++ b/drivers/nvdimm/label.c
>> @@ -381,6 +381,16 @@ static void nsl_calculate_checksum(struct nvdimm_drvdata *ndd,
>>  	nsl_set_checksum(ndd, nd_label, sum);
>>  }
>>
>> +static void rgl_calculate_checksum(struct nvdimm_drvdata *ndd,
>
>region_label_checksum()? rgl/rg is just a bit jarring to read even though I get nvdimm already has nd and nsl etc.
>
>> +				   struct cxl_region_label *rg_label)
>
>Prefer just spell out region_label

Sure Dave, I will fix it wherever its rgl/rg to region_label

>
>> +{
>> +	u64 sum;
>> +
>> +	rgl_set_checksum(rg_label, 0);
>> +	sum = nd_fletcher64(rg_label, sizeof_namespace_label(ndd), 1);
>> +	rgl_set_checksum(rg_label, sum);
>> +}
>> +
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
>
>Would've preferred the original code to look like:
>
>list_for_each_entry(label_ent, &nd_mapping->labels, list) {
>	if (label_ent->label)
>		continue;
>
>	label_ent->label = lsa_label;
>	lsa_label = NULL;
>	break;
>}
>
>But ah well....

Thanks, I will fix it here

>
>> +	dev_WARN_ONCE(&nspm->nsio.common.dev, lsa_label,> +			"failed to track label: %d\n",
>> +			to_slot(ndd, lsa_label));
>> +	if (lsa_label)
>> +		rc = -ENXIO;
>
>Just return here as Jonathan already mentioned. guard() helps with cleaning that up.

Sure, Will fix it in next patch-set

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
>> +	struct nd_namespace_index *nsindex;> +	struct nd_label_ent *label_ent;
>> +	unsigned long *free;
>> +	u32 nslot, slot;
>> +	size_t offset;
>> +	int rc;
>> +	uuid_t tmp;
>
>uuid instead of tmp would make the variable clearer to read
>
>Also please arrange variable ordering in reverse xmas tree.

Sure Dave, I will fix it in next patch-set

>
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
>> +
>> +	/* Set Current Region Label UUID */
>> +	export_uuid(nd_label->rg_label.uuid, &nd_set->uuid);
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
>just return here

Sure, Will fix it

>
>> +
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
>
>Would there be a mix of different nd mappings? I wonder if you can just 'return 0' if you find ndd->cxl on the first one and just skip everything.

When we create cxl region with two mem device, then we will have two separate
nd_mapping for both mem devices. But Yes, I don't see difference in both device
nd_mapping characters. So instead of "continue", I will just "return 0".

>
>> +
>> +		/* Init labels to include region label */
>> +		rc = init_labels(nd_mapping, 1);
>> +
>> +		if (rc < 0)
>> +			return rc;
>> +
>> +		rc = __pmem_region_label_update(nd_region, nd_mapping, i,
>> +					NSLABEL_FLAG_UPDATING);
>> +
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
>> +> +		rc = __pmem_region_label_update(nd_region, nd_mapping, i, 0);
>> +
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
>>  	union {
>>  		struct nd_namespace_label ns_label;
>> +		struct cxl_region_label rg_label;
>>  	};
>>  };
>>
>> @@ -233,4 +234,5 @@ struct nd_region;
>>  struct nd_namespace_pmem;
>>  int nd_pmem_namespace_label_update(struct nd_region *nd_region,
>>  		struct nd_namespace_pmem *nspm, resource_size_t size);
>> +int nd_pmem_region_label_update(struct nd_region *nd_region);
>>  #endif /* __LABEL_H__ */
>> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
>> index 5b73119dc8fd..02ae8162566c 100644
>> --- a/drivers/nvdimm/namespace_devs.c
>> +++ b/drivers/nvdimm/namespace_devs.c
>> @@ -232,6 +232,18 @@ static ssize_t __alt_name_store(struct device *dev, const char *buf,
>>  	return rc;
>>  }
>>
>> +int nd_region_label_update(struct nd_region *nd_region)
>> +{
>> +	int rc;
>> +
>> +	nvdimm_bus_lock(&nd_region->dev);
>> +	rc = nd_pmem_region_label_update(nd_region);
>> +	nvdimm_bus_unlock(&nd_region->dev);
>> +
>> +	return rc;
>> +}
>> +EXPORT_SYMBOL_GPL(nd_region_label_update);
>> +
>>  static int nd_namespace_label_update(struct nd_region *nd_region,
>>  		struct device *dev)
>>  {
>> diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
>> index 651847f1bbf9..15d94e3937f0 100644
>> --- a/drivers/nvdimm/nd.h
>> +++ b/drivers/nvdimm/nd.h
>> @@ -322,6 +322,26 @@ static inline void nsl_set_region_uuid(struct nvdimm_drvdata *ndd,
>>  		export_uuid(ns_label->cxl.region_uuid, uuid);
>>  }
>>
>> +static inline bool rgl_uuid_equal(struct cxl_region_label *rg_label,
>> +				  const uuid_t *uuid)
>
>region_label_uuid_equal() and region_label
>
>> +{
>> +	uuid_t tmp;
>
>tmp_uuid
>
>> +
>> +	import_uuid(&tmp, rg_label->uuid);
>> +	return uuid_equal(&tmp, uuid);
>> +}
>> +
>> +static inline u64 rgl_get_checksum(struct cxl_region_label *rg_label)
>
>region_label_get_checksum()
>
>> +{
>> +	return __le64_to_cpu(rg_label->checksum);
>> +}
>> +
>> +static inline void rgl_set_checksum(struct cxl_region_label *rg_label,
>region_label_set_checksum()

Sure, I will fix them in next patch-set


Regards,
Neeraj

------AO5Z5CA5q82FpJQJAbIGDvoW6m12ppu.cCYhbwpEEtg295OJ=_ead75_
Content-Type: text/plain; charset="utf-8"


------AO5Z5CA5q82FpJQJAbIGDvoW6m12ppu.cCYhbwpEEtg295OJ=_ead75_--

