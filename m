Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8415830AAC8
	for <nvdimm@lists.linux.dev>; Mon, 22 Sep 2025 13:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758546754; cv=none; b=Ofsdn2On23aCNL5u4HCxNY1CRiWcs8D7FBVnqk+R9JTJke1iKxce2l/5AIZJUfJFndtR3wETYOUJySbwWL2ZcMHaqb7j5XTsiBVbhZv2H5xtYt5VNDmBovMsnm/yNC/sYxlH1EOP6ORdbPvdz7uB/unV2xshLGcoC06Z6G9xjs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758546754; c=relaxed/simple;
	bh=ubfDsr5wHmbTbJYztTC9ipTrY9ZifsuTyetU8S7LzBg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=qxtkorK99xaG7Gb+fzCgPLKB0scihgJ3Zy9KrBGZWBgjI8jzrucK7EenKdqqggJJe9jtiKeM0/OPIFnIFzewpJ5ekoICh7dWYYW270Ob9ZwEXFB9Zc+9MG4xdeDkBK+6hNDDjpQl7+6y933iu7X1N27tZMisSRZLa7Hef4Jw8uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=mcw4kYDZ; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="mcw4kYDZ"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250922131229epoutp029937bf83560aa5fc20a2750ad67d0b97~nnPObIXtS2195521955epoutp02J
	for <nvdimm@lists.linux.dev>; Mon, 22 Sep 2025 13:12:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250922131229epoutp029937bf83560aa5fc20a2750ad67d0b97~nnPObIXtS2195521955epoutp02J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1758546749;
	bh=siwbjWOUumU054mtXxrmxl2EZDxnBQywCdeg7Bz8yYw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=mcw4kYDZLxFaksKyskzOjtqSTI9VTXkO216ss89Po06bY7flKS0+K9//0B0oqffn8
	 XTwLNfNl/e027H+6c0U3cjOVvgVd64Eg/zi1QfQI10lcz+Q0o437cz+lVcjr9yJIsT
	 D/DiX9V06BUQjWQMEG+sR8aJX6egcTq8+oIFLU34=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20250922131228epcas5p1577f1ff1d23cc45a46ed3c0110af5606~nnPNZeLwZ0247102471epcas5p1N;
	Mon, 22 Sep 2025 13:12:28 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.90]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4cVk6g3n2xz6B9m4; Mon, 22 Sep
	2025 13:12:27 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250922131227epcas5p29f5d697e81ff3ea7c361754bb175ce9f~nnPMG4mLq1044610446epcas5p2t;
	Mon, 22 Sep 2025 13:12:27 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250922131225epsmtip2dc1b7e38bde0d5897aa652ff9b836cbb~nnPKVSq2r1143711437epsmtip2g;
	Mon, 22 Sep 2025 13:12:25 +0000 (GMT)
Date: Mon, 22 Sep 2025 18:42:20 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V3 06/20] nvdimm/region_label: Add region label update
 support
Message-ID: <20250922131220.kgkaxyzopprwdi7t@test-PowerEdge-R740xd>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250917163623.00004a3c@huawei.com>
X-CMS-MailID: 20250922131227epcas5p29f5d697e81ff3ea7c361754bb175ce9f
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----M3TZWmnaQcCgpq3P2cdOV_lud716KtFuwxspURBH1dZsF.eH=_26e7b_"
CMS-TYPE: 105P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250917134140epcas5p23c007dab49ed7e98726b0dd9a2ce077a
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
	<CGME20250917134140epcas5p23c007dab49ed7e98726b0dd9a2ce077a@epcas5p2.samsung.com>
	<20250917134116.1623730-7-s.neeraj@samsung.com>
	<20250917163623.00004a3c@huawei.com>

------M3TZWmnaQcCgpq3P2cdOV_lud716KtFuwxspURBH1dZsF.eH=_26e7b_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 17/09/25 04:36PM, Jonathan Cameron wrote:
>On Wed, 17 Sep 2025 19:11:02 +0530
>Neeraj Kumar <s.neeraj@samsung.com> wrote:
>
>> Modified __pmem_label_update() to update region labels into LSA
>>
>I'm struggling to follow the use of the union for the two label types
>in much of this code.  To me if feels like that should only be a thing
>at the init_labels() point on the basis I think it's only there that
>we need to handle both in the same storage.
>
>For the rest I'd just pay the small price of duplication that will
>occur if you just split he functions up.

I got your point Jonathan, Let me revisit it again.

>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>> ---
>>  drivers/nvdimm/label.c          | 269 ++++++++++++++++++++++++++------
>>  drivers/nvdimm/label.h          |  15 ++
>>  drivers/nvdimm/namespace_devs.c |  12 ++
>>  drivers/nvdimm/nd.h             |  38 ++++-
>>  include/linux/libnvdimm.h       |   8 +
>>  5 files changed, 289 insertions(+), 53 deletions(-)
>>

[snip]

>> -	nsl_set_position(ndd, nd_label, pos);
>> -	nsl_set_isetcookie(ndd, nd_label, cookie);
>> -	nsl_set_rawsize(ndd, nd_label, resource_size(res));
>> -	nsl_set_lbasize(ndd, nd_label, nspm->lbasize);
>> -	nsl_set_dpa(ndd, nd_label, res->start);
>> -	nsl_set_slot(ndd, nd_label, slot);
>> -	nsl_set_alignment(ndd, nd_label, 0);
>> -	nsl_set_type_guid(ndd, nd_label, &nd_set->type_guid);
>> -	nsl_set_region_uuid(ndd, nd_label, NULL);
>> -	nsl_set_claim_class(ndd, nd_label, ndns->claim_class);
>> -	nsl_calculate_checksum(ndd, nd_label);
>> -	nd_dbg_dpa(nd_region, ndd, res, "\n");
>> +	lsa_label = (union nd_lsa_label *) to_label(ndd, slot);
>
>This cast feels rather dubious.
>
>If the union makes sense in general, then this should be changed
>to return the union.

Sure, I will fix it in next patch-set

>
>> +	memset(lsa_label, 0, sizeof_namespace_label(ndd));
>> +
>> +	switch (ltype) {
>> +	case NS_LABEL_TYPE:
>> +		dev = &nspm->nsio.common.dev;
>> +		rc = namespace_label_update(nd_region, nd_mapping,
>> +				nspm, pos, flags, &lsa_label->ns_label,
>> +				nsindex, slot);
>> +		if (rc)
>> +			return rc;
>> +
>> +		break;
>> +	case RG_LABEL_TYPE:
>> +		dev = &nd_region->dev;
>> +		region_label_update(nd_region, &lsa_label->region_label,
>> +				    nd_mapping, pos, flags, slot);
>> +
>> +		break;
>> +	}
>>
>>  	/* update label */
>> -	offset = nd_label_offset(ndd, nd_label);
>> -	rc = nvdimm_set_config_data(ndd, offset, nd_label,
>> +	offset = nd_label_offset(ndd, &lsa_label->ns_label);
>
>This doesn't make sense as the type might be either an ns_label or a region_label.
>If there is a generic header (I'm guessing there is) then define that as part of the
>union with just the shared parts and use that to avoid any implication of what the type
>is in calls like this.  Also make nd_label_offset() take the union not the specific bit.

Okay, I will update the signature of nd_label_offset() to use union and not the specific bit

>
>> +	rc = nvdimm_set_config_data(ndd, offset, lsa_label,
>>  			sizeof_namespace_label(ndd));
>>  	if (rc < 0)
>>  		return rc;
>> @@ -955,8 +1054,10 @@ static int __pmem_label_update(struct nd_region *nd_region,
>>  	list_for_each_entry(label_ent, &nd_mapping->labels, list) {
>>  		if (!label_ent->label)
>>  			continue;
>> -		if (test_and_clear_bit(ND_LABEL_REAP, &label_ent->flags) ||
>> -		    nsl_uuid_equal(ndd, label_ent->label, nspm->uuid))
>> +
>> +		if (is_label_reapable(nd_set, nspm, ndd,
>> +				      (union nd_lsa_label *) label_ent->label,
>
>If we are going with the union that label_ent->label should be a union that
>we don't need to cast.

Sure, I will fix this in next patch-set

>
>> +				      ltype, &label_ent->flags))
>>  			reap_victim(nd_mapping, label_ent);
>>  	}
>>
>> @@ -966,19 +1067,20 @@ static int __pmem_label_update(struct nd_region *nd_region,
>>  	if (rc)
>>  		return rc;
>>
>> -	list_for_each_entry(label_ent, &nd_mapping->labels, list)
>> -		if (!label_ent->label) {
>> -			label_ent->label = nd_label;
>> -			nd_label = NULL;
>> -			break;
>> -		}
>> -	dev_WARN_ONCE(&nspm->nsio.common.dev, nd_label,
>> -			"failed to track label: %d\n",
>> -			to_slot(ndd, nd_label));
>> -	if (nd_label)
>> -		rc = -ENXIO;
>> +	list_for_each_entry(label_ent, &nd_mapping->labels, list) {
>> +		if (label_ent->label)
>> +			continue;
>
>This flow change is unrelated to the rest here. I'd push it back
>to the simpler patch that change the locking. Make sure to call it out there
>though.  Or just don't do it and keep this patch a little more readable!

Yes, I will fix this in previous patch.

>> @@ -1091,12 +1209,19 @@ int nd_pmem_namespace_label_update(struct nd_region *nd_region,
>>  				count++;
>>  		WARN_ON_ONCE(!count);
>>
>> -		rc = init_labels(nd_mapping, count);
>> +		region_label_cnt = find_region_label_count(ndd, nd_mapping);
>> +		/*
>> +		 * init_labels() scan labels and allocate new label based
>> +		 * on its second parameter (num_labels). Therefore to
>> +		 * allocate new namespace label also include previously
>> +		 * added region label
>> +		 */
>> +		rc = init_labels(nd_mapping, count + region_label_cnt);
>>  		if (rc < 0)
>>  			return rc;
>>
>>  		rc = __pmem_label_update(nd_region, nd_mapping, nspm, i,
>> -				NSLABEL_FLAG_UPDATING);
>> +				NSLABEL_FLAG_UPDATING, NS_LABEL_TYPE);
>
>The amount of shared code in __pmem_label_update() across the two types in
>the union isn't that high.  I'd be tempted to just split it for simplicity.

Sure, I will split it out in next patch-set.

>
>>  		if (rc)
>>  			return rc;
>>  	}
>>
[snip]
>> +int nd_region_label_update(struct nd_region *nd_region)
>> +{
>> +	int rc;
>> +
>> +	nvdimm_bus_lock(&nd_region->dev);
>> +	rc = nd_pmem_region_label_update(nd_region);
>> +	nvdimm_bus_unlock(&nd_region->dev);
>Looks like it would be worth introducing a
>DEFINE_GUARD() for this lock.
>
>Not necessarily in this series however.

Yes, Fixing it here will add some extra change.

>> +
>> +	return rc;
>> +}
>> +EXPORT_SYMBOL_GPL(nd_region_label_update);
>> +
>>  static int nd_namespace_label_update(struct nd_region *nd_region,
>>  		struct device *dev)
>>  {
>> diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
>> index e362611d82cc..f04c042dcfa9 100644
>> --- a/drivers/nvdimm/nd.h
>> +++ b/drivers/nvdimm/nd.h
>
>>  bool nsl_validate_type_guid(struct nvdimm_drvdata *ndd,
>>  			    struct nd_namespace_label *nd_label, guid_t *guid);
>>  enum nvdimm_claim_class nsl_get_claim_class(struct nvdimm_drvdata *ndd,
>> @@ -399,7 +432,10 @@ enum nd_label_flags {
>>  struct nd_label_ent {
>>  	struct list_head list;
>>  	unsigned long flags;
>> -	struct nd_namespace_label *label;
>> +	union {
>> +		struct nd_namespace_label *label;
>> +		struct cxl_region_label *region_label;
>
>It is a bit odd to have a union above of the two types in
>here but then union the pointers here.

Yes Jonathan, I will replace this unnamed union with "union nd_lsa_label". I will
also help in avoid extra typecasting in is_region_label() and is_label_reapable()


Regards,
Neeraj

------M3TZWmnaQcCgpq3P2cdOV_lud716KtFuwxspURBH1dZsF.eH=_26e7b_
Content-Type: text/plain; charset="utf-8"


------M3TZWmnaQcCgpq3P2cdOV_lud716KtFuwxspURBH1dZsF.eH=_26e7b_--
