Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B86552D46B2
	for <nvdimm@lists.linux.dev>; Fri,  5 Sep 2025 07:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757055789; cv=none; b=UCUMHePsx5FW66xe0+RBMs9U/1bJA8BL/4fimhWdPtP9OkF65DtfgBHb9NMXZfsM/AkbTTW1A3av8tY1enT9Zm9LYVk3C5lt2fDlJU5riZkLO/oFX4JU6jmrpfwKZqmF8/tgvW/LnXQcZUMpO6pDt9PW7ktMenY+7VZesWqlZzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757055789; c=relaxed/simple;
	bh=Sb80DWZvVVE9lINnYWF2KhnelCHKZ1SZNyBzzmRwAIY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=aQHRZ+/69FK0a5feH2VzkziyHRnWVeOj0YwGZMPP/NtNnVig3jG3KbNULSvLYNS6nxv6YyCSeF094UWYNPqh7Cn+KrWZm3SbBKgonIt9V6DpP/FY1lnsSOIP0qDHF7GoGp1XgsNC9le77W52Ajl905QXllRqbqE9PkACREn+i8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=JGbeRP10; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="JGbeRP10"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250905070304epoutp03d19a6d56bc37f5f63895dd86361dd3e9~iUO0sqayK2972529725epoutp03k
	for <nvdimm@lists.linux.dev>; Fri,  5 Sep 2025 07:03:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250905070304epoutp03d19a6d56bc37f5f63895dd86361dd3e9~iUO0sqayK2972529725epoutp03k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1757055784;
	bh=IYo/FsTGGAlJmlDG+nLj61S/oUqgyV4j2hSisPtI2B0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=JGbeRP10HdUHhC0nL7Fe3lhHtpp3lQvniyJlyr2GYMJwwCotX/N6gttFLYjbwmzcA
	 Li1puYKQDF0G8To2HQHppPGllvwvZ1WoJSyX1b4tELXwK0L2KGBxrwEMV4REVwlTbO
	 IulUA0+rMhfH+UJcbIQLGxGoacfOFiW6dBxvsknM=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20250905070303epcas5p2799fbf478b3998cc1ad120107ad6a82d~iUO0bIiHw0641706417epcas5p2M;
	Fri,  5 Sep 2025 07:03:03 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4cJ6kH6JtVz6B9mC; Fri,  5 Sep
	2025 07:03:03 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250904142320epcas5p23f4593e3f90585836b32701dcec82b41~iGl8v-R2t1736917369epcas5p2y;
	Thu,  4 Sep 2025 14:23:20 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250904142319epsmtip1676a8dab4be72a80ca9b8f1331ecfe38~iGl7mDt1O0166101661epsmtip1G;
	Thu,  4 Sep 2025 14:23:19 +0000 (GMT)
Date: Thu, 4 Sep 2025 19:53:14 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V2 06/20] nvdimm/region_label: Add region label deletion
 routine
Message-ID: <1279309678.121757055783864.JavaMail.epsvc@epcpadp2new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <4de40bdd-4ef3-4eea-8f11-43d71a6369cc@intel.com>
X-CMS-MailID: 20250904142320epcas5p23f4593e3f90585836b32701dcec82b41
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----6Bw0j5KOoRaxZeQKOp2dAcC2OKT3No9WZFWhMG37wfGsvvbi=_eab06_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250730121230epcas5p11650f090de55d0a2db541ee32e9a6fee
References: <20250730121209.303202-1-s.neeraj@samsung.com>
	<CGME20250730121230epcas5p11650f090de55d0a2db541ee32e9a6fee@epcas5p1.samsung.com>
	<20250730121209.303202-7-s.neeraj@samsung.com>
	<4de40bdd-4ef3-4eea-8f11-43d71a6369cc@intel.com>

------6Bw0j5KOoRaxZeQKOp2dAcC2OKT3No9WZFWhMG37wfGsvvbi=_eab06_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 15/08/25 03:22PM, Dave Jiang wrote:
>
>
>On 7/30/25 5:11 AM, Neeraj Kumar wrote:
>> Added cxl v2.1 format region label deletion routine. This function is
>> used to delete region label from LSA
>>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>> ---
>>  drivers/nvdimm/label.c          | 77 ++++++++++++++++++++++++++++++---
>>  drivers/nvdimm/label.h          |  6 +++
>>  drivers/nvdimm/namespace_devs.c | 12 +++++
>>  drivers/nvdimm/nd.h             |  9 ++++
>>  include/linux/libnvdimm.h       |  1 +
>>  5 files changed, 100 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
>> index 94f2d0ba7aca..be18278d6cea 100644
>> --- a/drivers/nvdimm/label.c
>> +++ b/drivers/nvdimm/label.c
>> @@ -1044,7 +1044,8 @@ static int init_labels(struct nd_mapping *nd_mapping, int num_labels)
>>  	return max(num_labels, old_num_labels);
>>  }
>>
>> -static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
>> +static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid,
>> +		enum label_type ltype)
>>  {
>>  	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
>>  	struct nd_label_ent *label_ent, *e;
>> @@ -1068,8 +1069,23 @@ static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
>>  		if (!nd_label)
>>  			continue;
>>  		active++;
>> -		if (!nsl_uuid_equal(ndd, &nd_label->ns_label, uuid))
>> -			continue;
>> +
>> +		switch (ltype) {
>> +		case NS_LABEL_TYPE:
>> +			if (!nsl_uuid_equal(ndd, &nd_label->ns_label, uuid))
>> +				continue;
>> +
>> +			break;
>> +		case RG_LABEL_TYPE:
>> +			if (!rgl_uuid_equal(&nd_label->rg_label, uuid))
>> +				continue;
>> +
>> +			break;
>> +		default:
>> +			dev_err(ndd->dev, "Invalid label type\n");
>> +			return 0;
>> +		}
>> +
>>  		active--;
>>  		slot = to_slot(ndd, nd_label);
>>  		nd_label_free_slot(ndd, slot);
>> @@ -1079,7 +1095,7 @@ static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
>>  	}
>>  	list_splice_tail_init(&list, &nd_mapping->labels);
>>
>> -	if (active == 0) {
>> +	if ((ltype == NS_LABEL_TYPE) && (active == 0)) {
>>  		nd_mapping_free_labels(nd_mapping);
>>  		dev_dbg(ndd->dev, "no more active labels\n");
>>  	}
>> @@ -1101,7 +1117,8 @@ int nd_pmem_namespace_label_update(struct nd_region *nd_region,
>>  		int count = 0;
>>
>>  		if (size == 0) {
>> -			rc = del_labels(nd_mapping, nspm->uuid);
>> +			rc = del_labels(nd_mapping, nspm->uuid,
>> +					NS_LABEL_TYPE);
>>  			if (rc)
>>  				return rc;
>>  			continue;
>> @@ -1268,6 +1285,56 @@ int nd_pmem_region_label_update(struct nd_region *nd_region)
>>  	return 0;
>>  }
>>
>> +int nd_pmem_region_label_delete(struct nd_region *nd_region)
>> +{
>> +	int i, rc;
>> +	struct nd_interleave_set *nd_set = nd_region->nd_set;
>> +	struct nd_label_ent *label_ent;
>> +	int ns_region_cnt = 0;
>
>reverse xmas tree pls

Sure Dave, I will arrange them in reverse xmas tree format.

>
>> +
>> +	for (i = 0; i < nd_region->ndr_mappings; i++) {
>> +		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
>> +		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
>> +
>> +		/* Find non cxl format supported ndr_mappings */
>> +		if (!ndd->cxl) {
>> +			dev_info(&nd_region->dev, "Region label unsupported\n");
>> +			return -EINVAL;
>> +		}
>> +
>> +		/* Find if any NS label using this region */
>> +		mutex_lock(&nd_mapping->lock);
>> +		list_for_each_entry(label_ent, &nd_mapping->labels, list) {
>> +			if (!label_ent->label)
>> +				continue;
>> +
>> +			/*
>> +			 * Check if any available NS labels has same
>> +			 * region_uuid in LSA
>> +			 */
>> +			if (nsl_region_uuid_equal(&label_ent->label->ns_label,
>> +						  &nd_set->uuid))
>> +				ns_region_cnt++;
>> +		}
>> +		mutex_unlock(&nd_mapping->lock);
>> +	}
>> +
>> +	if (ns_region_cnt) {
>> +		dev_dbg(&nd_region->dev, "Region/Namespace label in use\n");
>> +		return -EBUSY;
>> +	}
>> +
>> +	for (i = 0; i < nd_region->ndr_mappings; i++) {
>> +		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
>> +
>> +		rc = del_labels(nd_mapping, &nd_set->uuid, RG_LABEL_TYPE);
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
>> index 0f428695017d..cc14068511cf 100644
>> --- a/drivers/nvdimm/label.h
>> +++ b/drivers/nvdimm/label.h
>> @@ -30,6 +30,11 @@ enum {
>>  	ND_NSINDEX_INIT = 0x1,
>>  };
>>
>> +enum label_type {
>> +	RG_LABEL_TYPE,
>
>REGION_LABEL_TYPE preferred

Sure, I will rename it as REGION_LABEL_TYPE

>
>> +	NS_LABEL_TYPE,
>> +};
>> +
>>  /**
>>   * struct nd_namespace_index - label set superblock
>>   * @sig: NAMESPACE_INDEX\0
>> @@ -235,4 +240,5 @@ struct nd_namespace_pmem;
>>  int nd_pmem_namespace_label_update(struct nd_region *nd_region,
>>  		struct nd_namespace_pmem *nspm, resource_size_t size);
>>  int nd_pmem_region_label_update(struct nd_region *nd_region);
>> +int nd_pmem_region_label_delete(struct nd_region *nd_region);
>>  #endif /* __LABEL_H__ */
>> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
>> index 02ae8162566c..e5c2f78ca7dd 100644
>> --- a/drivers/nvdimm/namespace_devs.c
>> +++ b/drivers/nvdimm/namespace_devs.c
>> @@ -244,6 +244,18 @@ int nd_region_label_update(struct nd_region *nd_region)
>>  }
>>  EXPORT_SYMBOL_GPL(nd_region_label_update);
>>
>> +int nd_region_label_delete(struct nd_region *nd_region)
>> +{
>> +	int rc;
>> +
>> +	nvdimm_bus_lock(&nd_region->dev);
>> +	rc = nd_pmem_region_label_delete(nd_region);
>> +	nvdimm_bus_unlock(&nd_region->dev);
>> +
>> +	return rc;
>> +}
>> +EXPORT_SYMBOL_GPL(nd_region_label_delete);
>> +
>>  static int nd_namespace_label_update(struct nd_region *nd_region,
>>  		struct device *dev)
>>  {
>> diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
>> index 15d94e3937f0..6585747154c2 100644
>> --- a/drivers/nvdimm/nd.h
>> +++ b/drivers/nvdimm/nd.h
>> @@ -322,6 +322,15 @@ static inline void nsl_set_region_uuid(struct nvdimm_drvdata *ndd,
>>  		export_uuid(ns_label->cxl.region_uuid, uuid);
>>  }
>>
>> +static inline bool nsl_region_uuid_equal(struct nd_namespace_label *ns_label,
>> +				  const uuid_t *uuid)
>> +{
>> +	uuid_t tmp;
>
>s/tmp/uuid/

Sure, I will fix it in next patch-set


Regards,
Neeraj

------6Bw0j5KOoRaxZeQKOp2dAcC2OKT3No9WZFWhMG37wfGsvvbi=_eab06_
Content-Type: text/plain; charset="utf-8"


------6Bw0j5KOoRaxZeQKOp2dAcC2OKT3No9WZFWhMG37wfGsvvbi=_eab06_--

