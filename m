Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7BDB1C3BEB
	for <nvdimm@lists.linux.dev>; Sat, 19 Jul 2025 07:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752909488; cv=none; b=llYyqUA76hZqmDrTLwgmipiv0ylX2NRs792j0UkAIlSMIOdytKqdRQ3+GlFJ4sHS7LWgUxPzgMO7vy2nDMUfmN/EIpMNBwz2JTEgxQUmVf7+5tHoi958JA9PcD2/yZ53hu7p1ogSjgZ0a9xiS0CRr+g8dQjMLENO28kj0bWSjRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752909488; c=relaxed/simple;
	bh=aQwqn852ez4VSZnU4yg3Uq3Q3reU50ORuomePn2f2MY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=DOOVgD110H39hnBPuDjdy7aOyzxDjQMLpOO3AaITT7KMSYxzqHI3+SeBQWOlvCe3wCTObTQfQ6G6AWnlz7kj7DBUkio2hng3aZo0h8f+TwAoA9HRlbQJhCOJl82hAw3l4Fy+kW4u47k2uagP0Vly9Fn7AhZ1LajkrM8xcCa5Jbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=RtmWv7wF; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="RtmWv7wF"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250719071804epoutp04df0c8bbd62bea9962a68548293e8d97e~TleN3CmFE1293812938epoutp04H
	for <nvdimm@lists.linux.dev>; Sat, 19 Jul 2025 07:18:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250719071804epoutp04df0c8bbd62bea9962a68548293e8d97e~TleN3CmFE1293812938epoutp04H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1752909484;
	bh=UudTUHuSBSXOz6BPd7gqcDNPQ4zU70lFCIesGgqDksY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=RtmWv7wF+301P7dwxFef8w0FIO4ih7k6qW3n90sqmtskidCflVkvc8/8KHMY3gNGh
	 c70wt49G/hBAbCCy5Pdp6SCktirzHZ/QDdXXojNkh1iWQGiNAljBNdmY+XtfzP4K9c
	 Nv0vmBulZ/OlSsgQ5aIJAUhLNymz74JY4N027euE=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20250719071803epcas5p4d42a42d05e0cc180a61163f6d69942ff~TleM08fUo0565305653epcas5p4u;
	Sat, 19 Jul 2025 07:18:03 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4bkdKl082mz2SSKX; Sat, 19 Jul
	2025 07:18:03 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250718130021epcas5p22a6d36cbef9d0520eb16462bf875e8f2~TWfys0Ovy1715917159epcas5p24;
	Fri, 18 Jul 2025 13:00:21 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250718130019epsmtip1d471c4cbd9a0d5c9df54f8969451565a~TWfwNZj992028620286epsmtip1i;
	Fri, 18 Jul 2025 13:00:18 +0000 (GMT)
Date: Fri, 18 Jul 2025 18:30:13 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: "Fabio M. De Francesco" <fabio.m.de.francesco@linux.intel.com>
Cc: dan.j.williams@intel.com, dave@stgolabs.net,
	jonathan.cameron@huawei.com, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com,
	a.manzanares@samsung.com, nifan.cxl@gmail.com, anisa.su@samsung.com,
	vishak.g@samsung.com, krish.reddy@samsung.com, arun.george@samsung.com,
	alok.rathore@samsung.com, neeraj.kernel@gmail.com,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, gost.dev@samsung.com, cpgs@samsung.com
Subject: Re: [RFC PATCH 05/20] nvdimm/region_label: Add region label
 updation routine
Message-ID: <158453976.61752909483013.JavaMail.epsvc@epcpadp2new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <2354653.gBsaNRSFpC@fdefranc-mobl3>
X-CMS-MailID: 20250718130021epcas5p22a6d36cbef9d0520eb16462bf875e8f2
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----kMDsK0IEhKoUUkzyxABlnve5J-Otg2bCPR2yRM97vA1oUAWq=_23520_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250617124019epcas5p39815cc0f2b175aee40c194625166695c
References: <20250617123944.78345-1-s.neeraj@samsung.com>
	<CGME20250617124019epcas5p39815cc0f2b175aee40c194625166695c@epcas5p3.samsung.com>
	<1690859824.141750165204442.JavaMail.epsvc@epcpadp1new>
	<2354653.gBsaNRSFpC@fdefranc-mobl3>

------kMDsK0IEhKoUUkzyxABlnve5J-Otg2bCPR2yRM97vA1oUAWq=_23520_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

On 18/07/25 12:53AM, Fabio M. De Francesco wrote:
>On Tuesday, June 17, 2025 2:39:29 PM Central European Summer Time Neeraj Kumar wrote:
>> Added __pmem_region_label_update region label update routine to update
>> region label
>>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
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
>
>Hi Neeraj,
>
>I've noticed that __pmem_region_label_update() shares many similarities
>with the existing __pmem_label_update().

Hi Fabio,

Yes these functions looks similar, as one is updating namespace label
and other (__pmem_region_label_update) is updating region label. But
they don't use much duplicated code.

May be I will try refactoring to avoid any duplicate code.

>
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
>> +
>> +int nd_pmem_region_label_update(struct nd_region *nd_region)
>
>Same here. nd_pmem_region_label_update() is almost identical to the
>existing nd_pmem_namespace_label_update.

Sure, I will try refactoring these in next patch-set.

>
>Although I'm not familiar with drivers/nvdimm, it seems preferable to
>reuse and adapt the existing functions to reduce redundancy and simplify
>future maintenance, unless there are specific reasons for not doing so
>that I'm unaware of.
>
>Thanks,
>
>Fabio

Thanks Fabio for your feedback.

Regards,
Neeraj

------kMDsK0IEhKoUUkzyxABlnve5J-Otg2bCPR2yRM97vA1oUAWq=_23520_
Content-Type: text/plain; charset="utf-8"


------kMDsK0IEhKoUUkzyxABlnve5J-Otg2bCPR2yRM97vA1oUAWq=_23520_--

