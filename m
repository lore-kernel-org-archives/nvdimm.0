Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D2F142E83
	for <nvdimm@lists.linux.dev>; Thu, 26 Jun 2025 13:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750943887; cv=none; b=Miz4z6opOvy1pLVQKBiOHNtMFLrOAHdE3YmblpXyklmEJn7RlJYJfZtmXKP2bgOVa2H0kolN+/o4g/f1UY9bQoEUeYQTxKJvEc/GjFbl0ZmZDnxgHGDzY7bzspoC8mCCfGwbqtcZxhDnfOPGJz6tk/aaZQmmejWS4FX+rVMV2P0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750943887; c=relaxed/simple;
	bh=gdHRAPCR2r4khXIU/2+b0agzD87RBrgBe2cwJNDm0og=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=BAq9KVbcVk7NS1xwiAS4XwMdZo/lbdLAmLw51AUceX39LDRIVgye6o4CfTqzBwSLu8lFP1PELfD7MH4xbELxWCITsP8nHVGlgP+xRvo71vOR53Ay76jtQrS64040J+Ha1Gfsja2c9IBK7q7aNf7J7jAZHm5jTa/j6lFT1hfPOA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=OKf+7O9h; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="OKf+7O9h"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250626131803epoutp03319581a2f9f0f5cf3cca10a7412b02c9~Mmi9PCDKm1797517975epoutp03C
	for <nvdimm@lists.linux.dev>; Thu, 26 Jun 2025 13:18:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250626131803epoutp03319581a2f9f0f5cf3cca10a7412b02c9~Mmi9PCDKm1797517975epoutp03C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1750943883;
	bh=ythS3sbNf2mknAFjxNnd+FScRcLh2N9GtIXEqTszrus=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=OKf+7O9hPVsTLaoXlBec6djHDHIuNHI1w9xI+tiX1bEkkXOKpva1PgkGToqUfE5qv
	 IcGtSDjePPyvYuPUrDDlbfRWjFmADQUz06RneuFyhd3vhmtXCkguKD+8RZEAmgPzMv
	 joTsrDEK8A6PGKEbOcVwKZOa92OQGOhREmLFmER0=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250626131802epcas5p362264936fdc7c86ecdf7b0be52b02338~Mmi8ezFj40321203212epcas5p30;
	Thu, 26 Jun 2025 13:18:02 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4bSfPk1wG7z2SSKd; Thu, 26 Jun
	2025 13:18:02 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250626095415epcas5p115fda1fb35f95dfc96172f4b98634b36~MjxBfsbXD2328523285epcas5p1s;
	Thu, 26 Jun 2025 09:54:15 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250626095413epsmtip1ee663fd5599060a3321ad9ce8f18d7d4~Mjw-F1S031620116201epsmtip1U;
	Thu, 26 Jun 2025 09:54:12 +0000 (GMT)
Date: Thu, 26 Jun 2025 15:24:07 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: dan.j.williams@intel.com, dave@stgolabs.net, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com,
	a.manzanares@samsung.com, nifan.cxl@gmail.com, anisa.su@samsung.com,
	vishak.g@samsung.com, krish.reddy@samsung.com, arun.george@samsung.com,
	alok.rathore@samsung.com, neeraj.kernel@gmail.com,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, gost.dev@samsung.com, cpgs@samsung.com
Subject: Re: [RFC PATCH 05/20] nvdimm/region_label: Add region label
 updation routine
Message-ID: <1983025922.01750943882252.JavaMail.epsvc@epcpadp2new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250623100520.00003f34@huawei.com>
X-CMS-MailID: 20250626095415epcas5p115fda1fb35f95dfc96172f4b98634b36
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----K5ZVV-zrPS8y8iJelFUsagW7KEVVNg7wn3oh2ZJRPRpX678s=_cd465_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250617124019epcas5p39815cc0f2b175aee40c194625166695c
References: <20250617123944.78345-1-s.neeraj@samsung.com>
	<CGME20250617124019epcas5p39815cc0f2b175aee40c194625166695c@epcas5p3.samsung.com>
	<1690859824.141750165204442.JavaMail.epsvc@epcpadp1new>
	<20250623100520.00003f34@huawei.com>

------K5ZVV-zrPS8y8iJelFUsagW7KEVVNg7wn3oh2ZJRPRpX678s=_cd465_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 23/06/25 10:05AM, Jonathan Cameron wrote:
>On Tue, 17 Jun 2025 18:09:29 +0530
>Neeraj Kumar <s.neeraj@samsung.com> wrote:
>
>Add region label update routine
>
>
>> Added __pmem_region_label_update region label update routine to update
>> region label
>>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>A few trivial comments inline.
>
>Jonathan
>
>> ---
>>  drivers/nvdimm/label.c          | 142 ++++++++++++++++++++++++++++++++
>>  drivers/nvdimm/label.h          |   2 +
>>  drivers/nvdimm/namespace_devs.c |  12 +++
>>  drivers/nvdimm/nd.h             |  20 +++++
>>  include/linux/libnvdimm.h       |   8 ++
>>  5 files changed, 184 insertions(+)
>>
>> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
>> index d5cfaa99f976..7f33d14ce0ef 100644
>> --- a/drivers/nvdimm/label.c
>> +++ b/drivers/nvdimm/label.c
>> @@ -381,6 +381,16 @@ static void nsl_calculate_checksum(struct nvdimm_drvdata *ndd,
>>  	nsl_set_checksum(ndd, nd_label, sum);
>>  }
>>
>> +static void rgl_calculate_checksum(struct nvdimm_drvdata *ndd,
>> +				   struct cxl_region_label *rg_label)
>> +{
>> +	u64 sum;
>> +
>> +	rgl_set_checksum(rg_label, 0);
>> +	sum = nd_fletcher64(rg_label, sizeof_namespace_label(ndd), 1);
>> +	rgl_set_checksum(rg_label, sum);
>> +}
>> +
>>  static bool slot_valid(struct nvdimm_drvdata *ndd,
>>  		struct nd_lsa_label *nd_label, u32 slot)
>>  {
>> @@ -1117,6 +1127,138 @@ int nd_pmem_namespace_label_update(struct nd_region *nd_region,
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
>> +	mutex_lock(&nd_mapping->lock);
>
>Perhaps use
>
>	guard(mutex)(&nd_mapping->lock);
>
>so you can directly return in the error path below and simplify the flow
>a tiny bit.
>

Sure, Let me look at the gaurd(mutex). I will update it in V1

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
>> +
>With guard this can be
>	if (rc)
>		return rec;
>
>	list_for_each...
>

Sure, I will update it in V1

>> +	if (rc == 0) {
>> +		list_for_each_entry(label_ent, &nd_mapping->labels, list)
>> +			if (!label_ent->label) {
>> +				label_ent->label = nd_label;
>> +				nd_label = NULL;
>> +				break;
>> +			}
>> +		dev_WARN_ONCE(&nd_region->dev, nd_label,
>> +				"failed to track label: %d\n",
>> +				to_slot(ndd, nd_label));
>> +		if (nd_label)
>> +			rc = -ENXIO;
>> +	}
>> +	mutex_unlock(&nd_mapping->lock);
>> +
>> +	return rc;
>> +}
>

------K5ZVV-zrPS8y8iJelFUsagW7KEVVNg7wn3oh2ZJRPRpX678s=_cd465_
Content-Type: text/plain; charset="utf-8"


------K5ZVV-zrPS8y8iJelFUsagW7KEVVNg7wn3oh2ZJRPRpX678s=_cd465_--

