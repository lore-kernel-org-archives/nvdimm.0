Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9FD2D3EDB
	for <nvdimm@lists.linux.dev>; Fri,  5 Sep 2025 07:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757055617; cv=none; b=LZdJExmgBHZ4dVL0de9DAHAFgQxZOoThxh3xhYy1iLoUqNyNu/thF8/h86YCYbF9QSLMFv0SVpnk5uUotXodX0YeBIMBao35a++SPvb6tmA7yaNdMNOYhsQgJNTwfXc3vAYDtNQJ+S18AvBXNr4ulaz9rkiNGzAtBfKiwo3EZaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757055617; c=relaxed/simple;
	bh=l3KnqaB0M2j0UmNc6t7mk+FOUMRtIFQrORQWjl3osgA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=safHx6946MBi9EMPjbNkzXkqvd8fJyGfhCfmBWXTDuW8fU8vcpxbXMTMa1eHMJ2iJIGTO+i/4A/jjYGpmwugGZm0fR6s6k12bsUzs2sryvFpfvuXQp3GBm5yOpWxLT7FEdnVPgWlqE9/749oFzaR2QYbyvrndbDt4qXXfm630Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=YSrU2kLc; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="YSrU2kLc"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250905070004epoutp03aafebed07b2503d69e91dcee4f3423fa~iUMM6U5pC2589125891epoutp03o
	for <nvdimm@lists.linux.dev>; Fri,  5 Sep 2025 07:00:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250905070004epoutp03aafebed07b2503d69e91dcee4f3423fa~iUMM6U5pC2589125891epoutp03o
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1757055604;
	bh=h4INDyhFjcSpltNPzDpZnG1HrUtc84FD4H4sHXn+1no=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=YSrU2kLcSQGuTsW4Fj5t0keZiFlaBt02HQgDn26dMMzI951+XTOMLpVBroaPeH9RM
	 Mk4rs6H551IXMeD1ePA1eX94vcMy4C62cP+6z7VZA8vHfzmytplVWmOyNOPR3PwHe8
	 /QsCRM9ZiEKhaXuIu+jVAdEUKitnAkcDbtqIcMxo=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250905070003epcas5p3483f0101e4eb3ede6bf38b0ee52e05ac~iUMMk9DZt2257122571epcas5p33;
	Fri,  5 Sep 2025 07:00:03 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4cJ6fq4k1Tz6B9mF; Fri,  5 Sep
	2025 07:00:03 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250904133130epcas5p33295624f445e07f8c8292c57e7b4f33f~iF4sZOnRk3106431064epcas5p35;
	Thu,  4 Sep 2025 13:31:30 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250904133129epsmtip1535d80366a28402e97dd12e3a86d47cc~iF4rQaXpv0149801498epsmtip1J;
	Thu,  4 Sep 2025 13:31:29 +0000 (GMT)
Date: Thu, 4 Sep 2025 19:01:22 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V2 02/20] nvdimm/label: Prep patch to accommodate cxl
 lsa 2.1 support
Message-ID: <1296674576.21757055603660.JavaMail.epsvc@epcpadp1new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <cf66eadc-baf2-4962-a9c4-2a6205b5233b@intel.com>
X-CMS-MailID: 20250904133130epcas5p33295624f445e07f8c8292c57e7b4f33f
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----CDBSwZz52MZUMeM1Rx6lI.cEW_5b_YZAAzr3v09AM7rvldzc=_ea573_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250730121224epcas5p3c3a6563ce186d2fdb9c3ff5f66e37f3e
References: <20250730121209.303202-1-s.neeraj@samsung.com>
	<CGME20250730121224epcas5p3c3a6563ce186d2fdb9c3ff5f66e37f3e@epcas5p3.samsung.com>
	<20250730121209.303202-3-s.neeraj@samsung.com>
	<cf66eadc-baf2-4962-a9c4-2a6205b5233b@intel.com>

------CDBSwZz52MZUMeM1Rx6lI.cEW_5b_YZAAzr3v09AM7rvldzc=_ea573_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 15/08/25 03:02PM, Dave Jiang wrote:
>
>
>On 7/30/25 5:11 AM, Neeraj Kumar wrote:
>> LSA 2.1 format introduces region label, which can also reside
>> into LSA along with only namespace label as per v1.1 and v1.2
>>
>> As both namespace and region labels are of same size of 256 bytes.
>> Thus renamed "struct nd_namespace_label" to "struct nd_lsa_label",
>> where both namespace label and region label can stay as union.
>>
>> No functional change introduced.
>>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>> ---
>>  drivers/nvdimm/label.c          | 58 +++++++++++++++++++--------------
>>  drivers/nvdimm/label.h          | 12 ++++++-
>>  drivers/nvdimm/namespace_devs.c | 33 +++++++++++++------
>>  drivers/nvdimm/nd.h             |  2 +-
>>  4 files changed, 68 insertions(+), 37 deletions(-)
>>
>> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
>> index 7a011ee02d79..75bc11da4c11 100644
>> --- a/drivers/nvdimm/label.c
>> +++ b/drivers/nvdimm/label.c
>> @@ -271,7 +271,7 @@ static void nd_label_copy(struct nvdimm_drvdata *ndd,
>>  	memcpy(dst, src, sizeof_namespace_index(ndd));
>>  }
>>
>> -static struct nd_namespace_label *nd_label_base(struct nvdimm_drvdata *ndd)
>> +static struct nd_lsa_label *nd_label_base(struct nvdimm_drvdata *ndd)
>>  {
>>  	void *base = to_namespace_index(ndd, 0);
>>
>> @@ -279,7 +279,7 @@ static struct nd_namespace_label *nd_label_base(struct nvdimm_drvdata *ndd)
>>  }
>>
>>  static int to_slot(struct nvdimm_drvdata *ndd,
>> -		struct nd_namespace_label *nd_label)
>> +		struct nd_lsa_label *nd_label)
>>  {
>>  	unsigned long label, base;
>>
>> @@ -289,14 +289,14 @@ static int to_slot(struct nvdimm_drvdata *ndd,
>>  	return (label - base) / sizeof_namespace_label(ndd);
>>  }
>>
>> -static struct nd_namespace_label *to_label(struct nvdimm_drvdata *ndd, int slot)
>> +static struct nd_lsa_label *to_label(struct nvdimm_drvdata *ndd, int slot)
>>  {
>>  	unsigned long label, base;
>>
>>  	base = (unsigned long) nd_label_base(ndd);
>>  	label = base + sizeof_namespace_label(ndd) * slot;
>>
>> -	return (struct nd_namespace_label *) label;
>> +	return (struct nd_lsa_label *) label;
>>  }
>>
>>  #define for_each_clear_bit_le(bit, addr, size) \
>> @@ -382,9 +382,10 @@ static void nsl_calculate_checksum(struct nvdimm_drvdata *ndd,
>>  }
>>
>>  static bool slot_valid(struct nvdimm_drvdata *ndd,
>> -		struct nd_namespace_label *nd_label, u32 slot)
>> +		struct nd_lsa_label *lsa_label, u32 slot)
>>  {
>>  	bool valid;
>> +	struct nd_namespace_label *nd_label = &lsa_label->ns_label;
>>
>>  	/* check that we are written where we expect to be written */
>>  	if (slot != nsl_get_slot(ndd, nd_label))
>> @@ -405,6 +406,7 @@ int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
>>  		return 0; /* no label, nothing to reserve */
>>
>>  	for_each_clear_bit_le(slot, free, nslot) {
>> +		struct nd_lsa_label *lsa_label;
>>  		struct nd_namespace_label *nd_label;
>>  		struct nd_region *nd_region = NULL;
>>  		struct nd_label_id label_id;
>> @@ -412,9 +414,10 @@ int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
>>  		uuid_t label_uuid;
>>  		u32 flags;
>>
>> -		nd_label = to_label(ndd, slot);
>> +		lsa_label = to_label(ndd, slot);
>> +		nd_label = &lsa_label->ns_label;
>>
>> -		if (!slot_valid(ndd, nd_label, slot))
>> +		if (!slot_valid(ndd, lsa_label, slot))
>>  			continue;
>>
>>  		nsl_get_uuid(ndd, nd_label, &label_uuid);
>> @@ -565,11 +568,13 @@ int nd_label_active_count(struct nvdimm_drvdata *ndd)
>>  		return 0;
>>
>>  	for_each_clear_bit_le(slot, free, nslot) {
>> +		struct nd_lsa_label *lsa_label;
>>  		struct nd_namespace_label *nd_label;
>>
>> -		nd_label = to_label(ndd, slot);
>> +		lsa_label = to_label(ndd, slot);
>> +		nd_label = &lsa_label->ns_label;
>>
>> -		if (!slot_valid(ndd, nd_label, slot)) {
>> +		if (!slot_valid(ndd, lsa_label, slot)) {
>>  			u32 label_slot = nsl_get_slot(ndd, nd_label);
>>  			u64 size = nsl_get_rawsize(ndd, nd_label);
>>  			u64 dpa = nsl_get_dpa(ndd, nd_label);
>> @@ -584,7 +589,7 @@ int nd_label_active_count(struct nvdimm_drvdata *ndd)
>>  	return count;
>>  }
>>
>> -struct nd_namespace_label *nd_label_active(struct nvdimm_drvdata *ndd, int n)
>> +struct nd_lsa_label *nd_label_active(struct nvdimm_drvdata *ndd, int n)
>>  {
>>  	struct nd_namespace_index *nsindex;
>>  	unsigned long *free;
>> @@ -594,10 +599,10 @@ struct nd_namespace_label *nd_label_active(struct nvdimm_drvdata *ndd, int n)
>>  		return NULL;
>>
>>  	for_each_clear_bit_le(slot, free, nslot) {
>> -		struct nd_namespace_label *nd_label;
>> +		struct nd_lsa_label *lsa_label;
>>
>> -		nd_label = to_label(ndd, slot);
>> -		if (!slot_valid(ndd, nd_label, slot))
>> +		lsa_label = to_label(ndd, slot);
>> +		if (!slot_valid(ndd, lsa_label, slot))
>>  			continue;
>>
>>  		if (n-- == 0)
>> @@ -738,7 +743,7 @@ static int nd_label_write_index(struct nvdimm_drvdata *ndd, int index, u32 seq,
>>  }
>>
>>  static unsigned long nd_label_offset(struct nvdimm_drvdata *ndd,
>> -		struct nd_namespace_label *nd_label)
>> +		struct nd_lsa_label *nd_label)
>>  {
>>  	return (unsigned long) nd_label
>>  		- (unsigned long) to_namespace_index(ndd, 0);
>> @@ -892,6 +897,7 @@ static int __pmem_label_update(struct nd_region *nd_region,
>>  	struct nd_namespace_common *ndns = &nspm->nsio.common;
>>  	struct nd_interleave_set *nd_set = nd_region->nd_set;
>>  	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
>> +	struct nd_lsa_label *lsa_label;
>>  	struct nd_namespace_label *nd_label;
>>  	struct nd_namespace_index *nsindex;
>>  	struct nd_label_ent *label_ent;
>> @@ -923,8 +929,10 @@ static int __pmem_label_update(struct nd_region *nd_region,
>>  		return -ENXIO;
>>  	dev_dbg(ndd->dev, "allocated: %d\n", slot);
>>
>> -	nd_label = to_label(ndd, slot);
>> -	memset(nd_label, 0, sizeof_namespace_label(ndd));
>> +	lsa_label = to_label(ndd, slot);
>> +	memset(lsa_label, 0, sizeof_namespace_label(ndd));
>> +
>> +	nd_label = &lsa_label->ns_label;
>>  	nsl_set_uuid(ndd, nd_label, nspm->uuid);
>>  	nsl_set_name(ndd, nd_label, nspm->alt_name);
>>  	nsl_set_flags(ndd, nd_label, flags);
>> @@ -942,7 +950,7 @@ static int __pmem_label_update(struct nd_region *nd_region,
>>  	nd_dbg_dpa(nd_region, ndd, res, "\n");
>>
>>  	/* update label */
>> -	offset = nd_label_offset(ndd, nd_label);
>> +	offset = nd_label_offset(ndd, lsa_label);
>>  	rc = nvdimm_set_config_data(ndd, offset, nd_label,
>>  			sizeof_namespace_label(ndd));
>>  	if (rc < 0)
>> @@ -954,7 +962,7 @@ static int __pmem_label_update(struct nd_region *nd_region,
>>  		if (!label_ent->label)
>>  			continue;
>>  		if (test_and_clear_bit(ND_LABEL_REAP, &label_ent->flags) ||
>> -		    nsl_uuid_equal(ndd, label_ent->label, nspm->uuid))
>> +		    nsl_uuid_equal(ndd, &label_ent->label->ns_label, nspm->uuid))
>>  			reap_victim(nd_mapping, label_ent);
>>  	}
>>
>> @@ -964,14 +972,14 @@ static int __pmem_label_update(struct nd_region *nd_region,
>>  	if (rc == 0) {
>>  		list_for_each_entry(label_ent, &nd_mapping->labels, list)
>>  			if (!label_ent->label) {
>> -				label_ent->label = nd_label;
>> -				nd_label = NULL;
>> +				label_ent->label = lsa_label;
>> +				lsa_label = NULL;
>>  				break;
>>  			}
>> -		dev_WARN_ONCE(&nspm->nsio.common.dev, nd_label,
>> +		dev_WARN_ONCE(&nspm->nsio.common.dev, lsa_label,
>>  				"failed to track label: %d\n",
>> -				to_slot(ndd, nd_label));
>> -		if (nd_label)
>> +				to_slot(ndd, lsa_label));
>> +		if (lsa_label)
>>  			rc = -ENXIO;
>>  	}
>>  	mutex_unlock(&nd_mapping->lock);
>> @@ -1042,12 +1050,12 @@ static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
>>
>>  	mutex_lock(&nd_mapping->lock);
>>  	list_for_each_entry_safe(label_ent, e, &nd_mapping->labels, list) {
>> -		struct nd_namespace_label *nd_label = label_ent->label;
>> +		struct nd_lsa_label *nd_label = label_ent->label;
>>
>>  		if (!nd_label)
>>  			continue;
>>  		active++;
>> -		if (!nsl_uuid_equal(ndd, nd_label, uuid))
>> +		if (!nsl_uuid_equal(ndd, &nd_label->ns_label, uuid))
>>  			continue;
>>  		active--;
>>  		slot = to_slot(ndd, nd_label);
>> diff --git a/drivers/nvdimm/label.h b/drivers/nvdimm/label.h
>> index 0650fb4b9821..4883b3a1320f 100644
>> --- a/drivers/nvdimm/label.h
>> +++ b/drivers/nvdimm/label.h
>> @@ -183,6 +183,16 @@ struct nd_namespace_label {
>>  	};
>>  };
>>
>> +/*
>> + * LSA 2.1 format introduces region label, which can also reside
>> + * into LSA along with only namespace label as per v1.1 and v1.2
>> + */
>> +struct nd_lsa_label {
>> +	union {
>> +		struct nd_namespace_label ns_label;
>> +	};
>> +};
>
>I think originally 'struct nd_namespace_label' wrapped a union to avoid changing code that already has 'struct nd_namespace_label' in the function. But since you are creating a whole new thing, maybe just create a union directly since you end up touching all the function parameters in this patch anyways.
>
>union nd_lsa_label {
>	struct nd_namespace_label ns_label;
>	struct cxl_region_label region_label;
>};
>
>DJ

Thanks Dave for your suggestion. Yes I have wrapped a union here to
avoid changing existing code which may create more noise.

I think changing "struct nd_lsa_label" to "union nd_lsa_label" will be
kind of same. Only diff will be usage of "union" in place of "struct",
wherever I use nd_lsa_label.

I understand that this renaming has created some extra noise in existing
code. May be I will revisit this change and try using region label handling
separately instead of using union.


Regards,
Neeraj

------CDBSwZz52MZUMeM1Rx6lI.cEW_5b_YZAAzr3v09AM7rvldzc=_ea573_
Content-Type: text/plain; charset="utf-8"


------CDBSwZz52MZUMeM1Rx6lI.cEW_5b_YZAAzr3v09AM7rvldzc=_ea573_--

