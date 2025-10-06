Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF5D2367AC
	for <nvdimm@lists.linux.dev>; Mon,  6 Oct 2025 16:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759769809; cv=none; b=Obn9BulwIknFXhjGbvngeBIiXcX9X4Rv1fYJQa+QnIsr2N/ZhjpqY0j3xB4s3uh0pIK3NKJ2TUwalOksFpmPpC3cQComvg2E2eL4Y2GxaWvVA3uKCFD9k+GUh7UJhE5K2QdB/SPCNdj8dIEGMCVo1YW5ZpsN3Mrvb2nnMwZ8pVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759769809; c=relaxed/simple;
	bh=QJU/UtH5xrCu9jsZ4rAYDOaOlH+AhiX7cWVng/BGDLA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lFMOUaoASxn2uhzfKOE9w4wJJ6vYL1jNzGjMWIYZGcsYIs8l9RRTW3f2JEDb3ItVtyFwSJYInpc79ccLTs5oQTAmW3Ftf0AhSQB8/0+bUPbWna/m8JhrFLnF2lZYH8qXGhbLl4OHfao8EgdEGuZbBt+49nplUu52l6/B4HrX5q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WLBbqp04; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WLBbqp04"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759769808; x=1791305808;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=QJU/UtH5xrCu9jsZ4rAYDOaOlH+AhiX7cWVng/BGDLA=;
  b=WLBbqp04E1iA5bk8THkj0NHiJPIEu7Wii70EGe7abFJcT+UEzFDTXLZz
   Xcf7XuVqgF0wNYnbb3Al9xvreKhMzpHR++O24XYlQb07q5wC9bzVDYwDq
   xERytysX1nEMk/85W+zJ74bXdI2RlJlsUyvsRCLgt3g1aB3wWLI6ahOnW
   9HE7L698utINt9g8KzXX7p+zs6gWFNwQry5Psw6ivvfPoPTOcp3XIM1+N
   tKb2bx1MrPsPDhi2t6xB2KUB3f1Vr9PhnVoafhS6DyZ2OBhal4bir2jLV
   AsUV8q6f7QgOJFRrUUyLDZbBfw1YXMCAeuaznVjtDKvQ7qx+WlfVkKJMl
   A==;
X-CSE-ConnectionGUID: x7DL8An/TZ6IcjCjdTPvUw==
X-CSE-MsgGUID: iMjSf0doSnCYkNBW0yEX1g==
X-IronPort-AV: E=McAfee;i="6800,10657,11574"; a="87412857"
X-IronPort-AV: E=Sophos;i="6.18,320,1751266800"; 
   d="scan'208";a="87412857"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 09:56:46 -0700
X-CSE-ConnectionGUID: dE9UqcJsSS6PN1phIal72A==
X-CSE-MsgGUID: ENHuj3HmRqSFc+kt1nn/3g==
X-ExtLoop1: 1
Received: from cmdeoliv-mobl4.amr.corp.intel.com (HELO [10.125.110.110]) ([10.125.110.110])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 09:56:45 -0700
Message-ID: <9cee8f36-8e25-4301-9fbd-f5aa3d543c39@intel.com>
Date: Mon, 6 Oct 2025 09:56:44 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 06/20] nvdimm/region_label: Add region label update
 support
To: Jonathan Cameron <jonathan.cameron@huawei.com>,
 Neeraj Kumar <s.neeraj@samsung.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org, gost.dev@samsung.com,
 a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
 cpgs@samsung.com
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
 <CGME20250917134140epcas5p23c007dab49ed7e98726b0dd9a2ce077a@epcas5p2.samsung.com>
 <20250917134116.1623730-7-s.neeraj@samsung.com>
 <20250917163623.00004a3c@huawei.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20250917163623.00004a3c@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/17/25 8:36 AM, Jonathan Cameron wrote:
> On Wed, 17 Sep 2025 19:11:02 +0530
> Neeraj Kumar <s.neeraj@samsung.com> wrote:
> 
>> Modified __pmem_label_update() to update region labels into LSA
>>
> I'm struggling to follow the use of the union for the two label types
> in much of this code.  To me if feels like that should only be a thing
> at the init_labels() point on the basis I think it's only there that
> we need to handle both in the same storage.
> 
> For the rest I'd just pay the small price of duplication that will
> occur if you just split he functions up.
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
>> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
>> index 182f8c9a01bf..209c73f6b7e7 100644
>> --- a/drivers/nvdimm/label.c
>> +++ b/drivers/nvdimm/label.c
>> @@ -381,6 +381,16 @@ static void nsl_calculate_checksum(struct nvdimm_drvdata *ndd,
>>  	nsl_set_checksum(ndd, nd_label, sum);
>>  }
> 
>> +static bool is_label_reapable(struct nd_interleave_set *nd_set,
>> +			       struct nd_namespace_pmem *nspm,
>> +			       struct nvdimm_drvdata *ndd,
>> +			       union nd_lsa_label *label,
>> +			       enum label_type ltype,
>> +			       unsigned long *flags)
>> +{
>> +	switch (ltype) {
>> +	case NS_LABEL_TYPE:
>> +		if (test_and_clear_bit(ND_LABEL_REAP, flags) ||
>> +		    nsl_uuid_equal(ndd, &label->ns_label, nspm->uuid))
>> +			return true;
>> +
>> +		break;
>> +	case RG_LABEL_TYPE:
>> +		if (region_label_uuid_equal(&label->region_label,
>> +		    &nd_set->uuid))
>> +			return true;
>> +
>> +		break;
>> +	}
>> +
>> +	return false;
>> +}
>> +
>> +static int __pmem_label_update(struct nd_region *nd_region,
>> +			       struct nd_mapping *nd_mapping,
>> +			       struct nd_namespace_pmem *nspm,
>> +			       int pos, unsigned long flags,
>> +			       enum label_type ltype)
>> +{
>> +	struct nd_interleave_set *nd_set = nd_region->nd_set;
>> +	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
>> +	struct nd_namespace_index *nsindex;
>> +	struct nd_label_ent *label_ent;
>> +	union nd_lsa_label *lsa_label;
>> +	unsigned long *free;
>> +	struct device *dev;
>> +	u32 nslot, slot;
>> +	size_t offset;
>> +	int rc;
>> +
>> +	if (!preamble_next(ndd, &nsindex, &free, &nslot))
>> +		return -ENXIO;
>> +
>>  	/* allocate and write the label to the staging (next) index */
>>  	slot = nd_label_alloc_slot(ndd);
>>  	if (slot == UINT_MAX)
>>  		return -ENXIO;
>>  	dev_dbg(ndd->dev, "allocated: %d\n", slot);
>>  
>> -	nd_label = to_label(ndd, slot);
>> -	memset(nd_label, 0, sizeof_namespace_label(ndd));
>> -	nsl_set_type(ndd, nd_label);
>> -	nsl_set_uuid(ndd, nd_label, nspm->uuid);
>> -	nsl_set_name(ndd, nd_label, nspm->alt_name);
>> -	nsl_set_flags(ndd, nd_label, flags);
>> -	nsl_set_nlabel(ndd, nd_label, nd_region->ndr_mappings);
>> -	nsl_set_nrange(ndd, nd_label, 1);
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
> This cast feels rather dubious.
> 
> If the union makes sense in general, then this should be changed
> to return the union.
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
> This doesn't make sense as the type might be either an ns_label or a region_label.
> If there is a generic header (I'm guessing there is) then define that as part of the
> union with just the shared parts and use that to avoid any implication of what the type
> is in calls like this.  Also make nd_label_offset() take the union not the specific bit.
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
> If we are going with the union that label_ent->label should be a union that
> we don't need to cast.
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
> This flow change is unrelated to the rest here. I'd push it back
> to the simpler patch that change the locking. Make sure to call it out there
> though.  Or just don't do it and keep this patch a little more readable!
> 
>>  
>> -	return rc;
>> +		label_ent->label = &lsa_label->ns_label;
>> +		lsa_label = NULL;
>> +		break;
>> +	}
>> +	dev_WARN_ONCE(dev, lsa_label, "failed to track label: %d\n",
>> +		      to_slot(ndd, &lsa_label->ns_label));
>> +	if (lsa_label)
>> +		return -ENXIO;
>> +
>> +	return 0;
>>  }
>>  
>>  static int init_labels(struct nd_mapping *nd_mapping, int num_labels)
>> @@ -1068,6 +1170,21 @@ static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
>>  			nd_inc_seq(__le32_to_cpu(nsindex->seq)), 0);
>>  }
>>  
>> +static int find_region_label_count(struct nvdimm_drvdata *ndd,
>> +				   struct nd_mapping *nd_mapping)
>> +{
>> +	struct nd_label_ent *label_ent;
>> +	int region_label_cnt = 0;
>> +
>> +	guard(mutex)(&nd_mapping->lock);
>> +	list_for_each_entry(label_ent, &nd_mapping->labels, list)
>> +		if (is_region_label(ndd,
>> +		    (union nd_lsa_label *) label_ent->label))
> 
> As above. If it's a union make label_ent->label that union type.
> 
>> +			region_label_cnt++;
>> +
>> +	return region_label_cnt;
>> +}
>> +
>>  int nd_pmem_namespace_label_update(struct nd_region *nd_region,
>>  		struct nd_namespace_pmem *nspm, resource_size_t size)
>>  {
>> @@ -1076,6 +1193,7 @@ int nd_pmem_namespace_label_update(struct nd_region *nd_region,
>>  	for (i = 0; i < nd_region->ndr_mappings; i++) {
>>  		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
>>  		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
>> +		int region_label_cnt = 0;
>>  		struct resource *res;
>>  		int count = 0;
>>  
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
> The amount of shared code in __pmem_label_update() across the two types in
> the union isn't that high.  I'd be tempted to just split it for simplicity.
> 
>>  		if (rc)
>>  			return rc;
>>  	}
>> @@ -1108,7 +1233,47 @@ int nd_pmem_namespace_label_update(struct nd_region *nd_region,
>>  	for (i = 0; i < nd_region->ndr_mappings; i++) {
>>  		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
>>  
>> -		rc = __pmem_label_update(nd_region, nd_mapping, nspm, i, 0);
>> +		rc = __pmem_label_update(nd_region, nd_mapping, nspm, i, 0,
>> +				NS_LABEL_TYPE);
>> +		if (rc)
>> +			return rc;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +int nd_pmem_region_label_update(struct nd_region *nd_region)
>> +{
>> +	int i, rc;
>> +
>> +	for (i = 0; i < nd_region->ndr_mappings; i++) {
>> +		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
>> +		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
>> +		int region_label_cnt = 0;
>> +
>> +		/* No need to update region label for non cxl format */
>> +		if (!ndd->cxl)
>> +			return 0;
>> +
>> +		region_label_cnt = find_region_label_count(ndd, nd_mapping);
>> +		rc = init_labels(nd_mapping, region_label_cnt + 1);
>> +		if (rc < 0)
>> +			return rc;
>> +
>> +		rc = __pmem_label_update(nd_region, nd_mapping, NULL, i,
>> +				NSLABEL_FLAG_UPDATING, RG_LABEL_TYPE);
>> +		if (rc)
>> +			return rc;
>> +	}
>> +
>> +	/* Clear the UPDATING flag per UEFI 2.7 expectations */
>> +	for (i = 0; i < nd_region->ndr_mappings; i++) {
>> +		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
>> +		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
>> +
>> +		WARN_ON_ONCE(!ndd->cxl);
>> +		rc = __pmem_label_update(nd_region, nd_mapping, NULL, i, 0,
>> +				RG_LABEL_TYPE);
>>  		if (rc)
>>  			return rc;
>>  	}
>> diff --git a/drivers/nvdimm/label.h b/drivers/nvdimm/label.h
>> index 0650fb4b9821..284e2a763b49 100644
>> --- a/drivers/nvdimm/label.h
>> +++ b/drivers/nvdimm/label.h
>> @@ -30,6 +30,11 @@ enum {
>>  	ND_NSINDEX_INIT = 0x1,
>>  };
>>  
>> +enum label_type {
>> +	RG_LABEL_TYPE,
>> +	NS_LABEL_TYPE,
>> +};
>> +
>>  /**
>>   * struct nd_namespace_index - label set superblock
>>   * @sig: NAMESPACE_INDEX\0
>> @@ -183,6 +188,15 @@ struct nd_namespace_label {
>>  	};
>>  };
>>  
>> +/*
>> + * LSA 2.1 format introduces region label, which can also reside
>> + * into LSA along with only namespace label as per v1.1 and v1.2
>> + */
>> +union nd_lsa_label {
>> +	struct nd_namespace_label ns_label;
>> +	struct cxl_region_label region_label;
>> +};
> 
>> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
>> index 3271b1c8569a..559f822ef24f 100644
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
> Looks like it would be worth introducing a
> DEFINE_GUARD() for this lock.
> 
> Not necessarily in this series however.

https://lore.kernel.org/nvdimm/20250923174013.3319780-1-dave.jiang@intel.com/T/#t
Merged in nvdimm/next for 6.18.

DJ

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
> It is a bit odd to have a union above of the two types in
> here but then union the pointers here.
> 
> I'm also failing to find where region_label is used in this patch.
> 
> 
>> +	};
>>  };
>>  
>>  enum nd_mapping_lock_class {
> _rc)
> 
> 

