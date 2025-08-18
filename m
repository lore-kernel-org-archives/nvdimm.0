Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB8A1DDC2C
	for <nvdimm@lists.linux.dev>; Mon, 18 Aug 2025 21:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755553701; cv=none; b=F+mRPgZvbyrhYttvive96DTclDFNbK1P/F+4EXT4jdxu4c3xZuoUWf6aNT5bnXod7Mogx/lAIbu1TXUaWrRr+Y2Qkbhzz+Eieu+X7fFsFWD2JDmLEWBD3bnUS9lPBvwegtOSQdfrMv8LVOxRYyqE4tgzlTfXYBxJqdfO1LUvsS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755553701; c=relaxed/simple;
	bh=+XGp83OEOVEbMOfmz+WvGkuETiOBs9pPS+A3PfIJvz0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WERZWuMYfpYJ9t4q2YJe0HmC2B2sCKWw0torDE3HrqK3hjLyeS8fCzBVOetDCgwuz2F2sXZae4oMK3x4BqlxjqlA/cfoY3ommmLaeJllH34oUBwsb7Wli3XuFltQlBQfl5OnfjOAUQIbMg2rZzjm1sFKbQaxB0bERSz3QIbenBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mvDN1AKN; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mvDN1AKN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755553699; x=1787089699;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+XGp83OEOVEbMOfmz+WvGkuETiOBs9pPS+A3PfIJvz0=;
  b=mvDN1AKNCAtIWlyibcDsQoTK5/LDwpNXdj+cpwczrdujCNm8Jphm7hqG
   sW81KGWCXzGxqYcw39YV9HB2L7HFHoHIe6erZdK0tRr2wC6+kdu2XsUOJ
   h79OjS3oq35XFL6bFWjmd4ZogesImis8qZ5+K3hyFS7IvM1rnogDX8BXp
   zBALOyZSllk82WvVBkHSOjsJYffyOV5PTqSym/kKGAAmlj3R4jzZ+js1v
   q3YuFgOmp0pHvc8AwD788JfKA+pZTVFQdUwvwO53MzesXYSvfXlUz4CwH
   9AOUGNpSFhjSG6FYiBX1ovuNCWw5JUaCBV+HmtpREJ0HGLHi1+SegTxkR
   g==;
X-CSE-ConnectionGUID: i5U5HLXLSMiUG+uyQgygcg==
X-CSE-MsgGUID: IMuny2FEQ8KLVMY2mfArcw==
X-IronPort-AV: E=McAfee;i="6800,10657,11526"; a="57860613"
X-IronPort-AV: E=Sophos;i="6.17,300,1747724400"; 
   d="scan'208";a="57860613"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2025 14:48:17 -0700
X-CSE-ConnectionGUID: /BQu7J0pSWe7V+MK57FT1g==
X-CSE-MsgGUID: p+BGS0cRTo+d5K6+A0rdyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,300,1747724400"; 
   d="scan'208";a="168492686"
Received: from bvivekan-mobl2.gar.corp.intel.com (HELO [10.247.119.196]) ([10.247.119.196])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2025 14:48:12 -0700
Message-ID: <22727c86-fa5a-416c-a02a-e6be581c748c@intel.com>
Date: Mon, 18 Aug 2025 14:48:07 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 02/20] nvdimm/label: Prep patch to accommodate cxl lsa
 2.1 support
To: Neeraj Kumar <s.neeraj@samsung.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com
References: <20250730121209.303202-1-s.neeraj@samsung.com>
 <CGME20250730121224epcas5p3c3a6563ce186d2fdb9c3ff5f66e37f3e@epcas5p3.samsung.com>
 <20250730121209.303202-3-s.neeraj@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20250730121209.303202-3-s.neeraj@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/30/25 5:11 AM, Neeraj Kumar wrote:
> LSA 2.1 format introduces region label, which can also reside
> into LSA along with only namespace label as per v1.1 and v1.2
> 
> As both namespace and region labels are of same size of 256 bytes.
> Thus renamed "struct nd_namespace_label" to "struct nd_lsa_label",
> where both namespace label and region label can stay as union.
> 
> No functional change introduced.
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
> ---
>  drivers/nvdimm/label.c          | 58 +++++++++++++++++++--------------
>  drivers/nvdimm/label.h          | 12 ++++++-
>  drivers/nvdimm/namespace_devs.c | 33 +++++++++++++------
>  drivers/nvdimm/nd.h             |  2 +-
>  4 files changed, 68 insertions(+), 37 deletions(-)
> 
> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index 7a011ee02d79..75bc11da4c11 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c
> @@ -271,7 +271,7 @@ static void nd_label_copy(struct nvdimm_drvdata *ndd,
>  	memcpy(dst, src, sizeof_namespace_index(ndd));
>  }
>  
> -static struct nd_namespace_label *nd_label_base(struct nvdimm_drvdata *ndd)
> +static struct nd_lsa_label *nd_label_base(struct nvdimm_drvdata *ndd)

This function caught my eye. I think that given the way it's being used, maybe it should be returning 'unsigned long' instead of a struct given every instance it's being used, it gets converted back to 'unsigned long'.

$ git grep -n nd_label_base
label.c:274:static struct nd_lsa_label *nd_label_base(struct nvdimm_drvdata *ndd)
label.c:287:    base = (unsigned long) nd_label_base(ndd);
label.c:296:    base = (unsigned long) nd_label_base(ndd);
label.c:782:    offset = (unsigned long) nd_label_base(ndd)

>  {
>  	void *base = to_namespace_index(ndd, 0);
>  
> @@ -279,7 +279,7 @@ static struct nd_namespace_label *nd_label_base(struct nvdimm_drvdata *ndd)
>  }
>  
>  static int to_slot(struct nvdimm_drvdata *ndd,
> -		struct nd_namespace_label *nd_label)
> +		struct nd_lsa_label *nd_label)
>  {
>  	unsigned long label, base;
>  
> @@ -289,14 +289,14 @@ static int to_slot(struct nvdimm_drvdata *ndd,
>  	return (label - base) / sizeof_namespace_label(ndd);
>  }
>  
> -static struct nd_namespace_label *to_label(struct nvdimm_drvdata *ndd, int slot)
> +static struct nd_lsa_label *to_label(struct nvdimm_drvdata *ndd, int slot)
>  {
>  	unsigned long label, base;
>  
>  	base = (unsigned long) nd_label_base(ndd);
>  	label = base + sizeof_namespace_label(ndd) * slot;
>  
> -	return (struct nd_namespace_label *) label;
> +	return (struct nd_lsa_label *) label;
>  }
>  
>  #define for_each_clear_bit_le(bit, addr, size) \
> @@ -382,9 +382,10 @@ static void nsl_calculate_checksum(struct nvdimm_drvdata *ndd,
>  }
>  
>  static bool slot_valid(struct nvdimm_drvdata *ndd,
> -		struct nd_namespace_label *nd_label, u32 slot)
> +		struct nd_lsa_label *lsa_label, u32 slot)
>  {
>  	bool valid;
> +	struct nd_namespace_label *nd_label = &lsa_label->ns_label;
>  
>  	/* check that we are written where we expect to be written */
>  	if (slot != nsl_get_slot(ndd, nd_label))
> @@ -405,6 +406,7 @@ int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
>  		return 0; /* no label, nothing to reserve */
>  
>  	for_each_clear_bit_le(slot, free, nslot) {
> +		struct nd_lsa_label *lsa_label;
>  		struct nd_namespace_label *nd_label;
>  		struct nd_region *nd_region = NULL;
>  		struct nd_label_id label_id;
> @@ -412,9 +414,10 @@ int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
>  		uuid_t label_uuid;
>  		u32 flags;
>  
> -		nd_label = to_label(ndd, slot);
> +		lsa_label = to_label(ndd, slot);
> +		nd_label = &lsa_label->ns_label;
>  
> -		if (!slot_valid(ndd, nd_label, slot))
> +		if (!slot_valid(ndd, lsa_label, slot))
>  			continue;
>  
>  		nsl_get_uuid(ndd, nd_label, &label_uuid);
> @@ -565,11 +568,13 @@ int nd_label_active_count(struct nvdimm_drvdata *ndd)
>  		return 0;
>  
>  	for_each_clear_bit_le(slot, free, nslot) {
> +		struct nd_lsa_label *lsa_label;
>  		struct nd_namespace_label *nd_label;
>  
> -		nd_label = to_label(ndd, slot);
> +		lsa_label = to_label(ndd, slot);
> +		nd_label = &lsa_label->ns_label;
>  
> -		if (!slot_valid(ndd, nd_label, slot)) {
> +		if (!slot_valid(ndd, lsa_label, slot)) {
>  			u32 label_slot = nsl_get_slot(ndd, nd_label);
>  			u64 size = nsl_get_rawsize(ndd, nd_label);
>  			u64 dpa = nsl_get_dpa(ndd, nd_label);
> @@ -584,7 +589,7 @@ int nd_label_active_count(struct nvdimm_drvdata *ndd)
>  	return count;
>  }
>  
> -struct nd_namespace_label *nd_label_active(struct nvdimm_drvdata *ndd, int n)
> +struct nd_lsa_label *nd_label_active(struct nvdimm_drvdata *ndd, int n)
>  {
>  	struct nd_namespace_index *nsindex;
>  	unsigned long *free;
> @@ -594,10 +599,10 @@ struct nd_namespace_label *nd_label_active(struct nvdimm_drvdata *ndd, int n)
>  		return NULL;
>  
>  	for_each_clear_bit_le(slot, free, nslot) {
> -		struct nd_namespace_label *nd_label;
> +		struct nd_lsa_label *lsa_label;
>  
> -		nd_label = to_label(ndd, slot);
> -		if (!slot_valid(ndd, nd_label, slot))
> +		lsa_label = to_label(ndd, slot);
> +		if (!slot_valid(ndd, lsa_label, slot))
>  			continue;
>  
>  		if (n-- == 0)
> @@ -738,7 +743,7 @@ static int nd_label_write_index(struct nvdimm_drvdata *ndd, int index, u32 seq,
>  }
>  
>  static unsigned long nd_label_offset(struct nvdimm_drvdata *ndd,
> -		struct nd_namespace_label *nd_label)
> +		struct nd_lsa_label *nd_label)
>  {
>  	return (unsigned long) nd_label
>  		- (unsigned long) to_namespace_index(ndd, 0);
> @@ -892,6 +897,7 @@ static int __pmem_label_update(struct nd_region *nd_region,
>  	struct nd_namespace_common *ndns = &nspm->nsio.common;
>  	struct nd_interleave_set *nd_set = nd_region->nd_set;
>  	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
> +	struct nd_lsa_label *lsa_label;
>  	struct nd_namespace_label *nd_label;
>  	struct nd_namespace_index *nsindex;
>  	struct nd_label_ent *label_ent;
> @@ -923,8 +929,10 @@ static int __pmem_label_update(struct nd_region *nd_region,
>  		return -ENXIO;
>  	dev_dbg(ndd->dev, "allocated: %d\n", slot);
>  
> -	nd_label = to_label(ndd, slot);
> -	memset(nd_label, 0, sizeof_namespace_label(ndd));
> +	lsa_label = to_label(ndd, slot);
> +	memset(lsa_label, 0, sizeof_namespace_label(ndd));
> +
> +	nd_label = &lsa_label->ns_label;
>  	nsl_set_uuid(ndd, nd_label, nspm->uuid);
>  	nsl_set_name(ndd, nd_label, nspm->alt_name);
>  	nsl_set_flags(ndd, nd_label, flags);
> @@ -942,7 +950,7 @@ static int __pmem_label_update(struct nd_region *nd_region,
>  	nd_dbg_dpa(nd_region, ndd, res, "\n");
>  
>  	/* update label */
> -	offset = nd_label_offset(ndd, nd_label);
> +	offset = nd_label_offset(ndd, lsa_label);
>  	rc = nvdimm_set_config_data(ndd, offset, nd_label,
>  			sizeof_namespace_label(ndd));
>  	if (rc < 0)
> @@ -954,7 +962,7 @@ static int __pmem_label_update(struct nd_region *nd_region,
>  		if (!label_ent->label)
>  			continue;
>  		if (test_and_clear_bit(ND_LABEL_REAP, &label_ent->flags) ||
> -		    nsl_uuid_equal(ndd, label_ent->label, nspm->uuid))
> +		    nsl_uuid_equal(ndd, &label_ent->label->ns_label, nspm->uuid))
>  			reap_victim(nd_mapping, label_ent);
>  	}
>  
> @@ -964,14 +972,14 @@ static int __pmem_label_update(struct nd_region *nd_region,
>  	if (rc == 0) {
>  		list_for_each_entry(label_ent, &nd_mapping->labels, list)
>  			if (!label_ent->label) {
> -				label_ent->label = nd_label;
> -				nd_label = NULL;
> +				label_ent->label = lsa_label;
> +				lsa_label = NULL;
>  				break;
>  			}
> -		dev_WARN_ONCE(&nspm->nsio.common.dev, nd_label,
> +		dev_WARN_ONCE(&nspm->nsio.common.dev, lsa_label,
>  				"failed to track label: %d\n",
> -				to_slot(ndd, nd_label));
> -		if (nd_label)
> +				to_slot(ndd, lsa_label));
> +		if (lsa_label)
>  			rc = -ENXIO;
>  	}
>  	mutex_unlock(&nd_mapping->lock);
> @@ -1042,12 +1050,12 @@ static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
>  
>  	mutex_lock(&nd_mapping->lock);
>  	list_for_each_entry_safe(label_ent, e, &nd_mapping->labels, list) {
> -		struct nd_namespace_label *nd_label = label_ent->label;
> +		struct nd_lsa_label *nd_label = label_ent->label;
>  
>  		if (!nd_label)
>  			continue;
>  		active++;
> -		if (!nsl_uuid_equal(ndd, nd_label, uuid))
> +		if (!nsl_uuid_equal(ndd, &nd_label->ns_label, uuid))
>  			continue;
>  		active--;
>  		slot = to_slot(ndd, nd_label);
> diff --git a/drivers/nvdimm/label.h b/drivers/nvdimm/label.h
> index 0650fb4b9821..4883b3a1320f 100644
> --- a/drivers/nvdimm/label.h
> +++ b/drivers/nvdimm/label.h
> @@ -183,6 +183,16 @@ struct nd_namespace_label {
>  	};
>  };
>  
> +/*
> + * LSA 2.1 format introduces region label, which can also reside
> + * into LSA along with only namespace label as per v1.1 and v1.2
> + */
> +struct nd_lsa_label {
> +	union {
> +		struct nd_namespace_label ns_label;
> +	};
> +};
> +
>  #define NVDIMM_BTT_GUID "8aed63a2-29a2-4c66-8b12-f05d15d3922a"
>  #define NVDIMM_BTT2_GUID "18633bfc-1735-4217-8ac9-17239282d3f8"
>  #define NVDIMM_PFN_GUID "266400ba-fb9f-4677-bcb0-968f11d0d225"
> @@ -215,7 +225,7 @@ struct nvdimm_drvdata;
>  int nd_label_data_init(struct nvdimm_drvdata *ndd);
>  size_t sizeof_namespace_index(struct nvdimm_drvdata *ndd);
>  int nd_label_active_count(struct nvdimm_drvdata *ndd);
> -struct nd_namespace_label *nd_label_active(struct nvdimm_drvdata *ndd, int n);
> +struct nd_lsa_label *nd_label_active(struct nvdimm_drvdata *ndd, int n);
>  u32 nd_label_alloc_slot(struct nvdimm_drvdata *ndd);
>  bool nd_label_free_slot(struct nvdimm_drvdata *ndd, u32 slot);
>  u32 nd_label_nfree(struct nvdimm_drvdata *ndd);
> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
> index 55cfbf1e0a95..bdf1ed6f23d8 100644
> --- a/drivers/nvdimm/namespace_devs.c
> +++ b/drivers/nvdimm/namespace_devs.c
> @@ -1009,10 +1009,11 @@ static int namespace_update_uuid(struct nd_region *nd_region,
>  
>  		mutex_lock(&nd_mapping->lock);
>  		list_for_each_entry(label_ent, &nd_mapping->labels, list) {
> -			struct nd_namespace_label *nd_label = label_ent->label;
> +			struct nd_namespace_label *nd_label;
>  			struct nd_label_id label_id;
>  			uuid_t uuid;
>  
> +			nd_label = &label_ent->label->ns_label;
>  			if (!nd_label)
>  				continue;
>  			nsl_get_uuid(ndd, nd_label, &uuid);
> @@ -1573,11 +1574,14 @@ static bool has_uuid_at_pos(struct nd_region *nd_region, const uuid_t *uuid,
>  		bool found_uuid = false;
>  
>  		list_for_each_entry(label_ent, &nd_mapping->labels, list) {
> -			struct nd_namespace_label *nd_label = label_ent->label;
> +			struct nd_lsa_label *lsa_label = label_ent->label;
> +			struct nd_namespace_label *nd_label;
>  			u16 position;
>  
> -			if (!nd_label)
> +			if (!lsa_label)
>  				continue;
> +
> +			nd_label = &lsa_label->ns_label;
>  			position = nsl_get_position(ndd, nd_label);
>  
>  			if (!nsl_validate_isetcookie(ndd, nd_label, cookie))
> @@ -1615,17 +1619,21 @@ static int select_pmem_id(struct nd_region *nd_region, const uuid_t *pmem_id)
>  	for (i = 0; i < nd_region->ndr_mappings; i++) {
>  		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
>  		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
> +		struct nd_lsa_label *lsa_label = NULL;
>  		struct nd_namespace_label *nd_label = NULL;
>  		u64 hw_start, hw_end, pmem_start, pmem_end;
>  		struct nd_label_ent *label_ent;
>  
>  		lockdep_assert_held(&nd_mapping->lock);
>  		list_for_each_entry(label_ent, &nd_mapping->labels, list) {
> -			nd_label = label_ent->label;
> -			if (!nd_label)
> +			lsa_label = label_ent->label;
> +			if (!lsa_label)
>  				continue;
> +
> +			nd_label = &lsa_label->ns_label;
>  			if (nsl_uuid_equal(ndd, nd_label, pmem_id))
>  				break;
> +			lsa_label = NULL;
>  			nd_label = NULL;
>  		}
>  
> @@ -1746,19 +1754,21 @@ static struct device *create_namespace_pmem(struct nd_region *nd_region,
>  
>  	/* Calculate total size and populate namespace properties from label0 */
>  	for (i = 0; i < nd_region->ndr_mappings; i++) {
> +		struct nd_lsa_label *lsa_label;
>  		struct nd_namespace_label *label0;
>  		struct nvdimm_drvdata *ndd;
>  
>  		nd_mapping = &nd_region->mapping[i];
>  		label_ent = list_first_entry_or_null(&nd_mapping->labels,
>  				typeof(*label_ent), list);
> -		label0 = label_ent ? label_ent->label : NULL;
> +		lsa_label = label_ent ? label_ent->label : NULL;
>  
> -		if (!label0) {
> +		if (!lsa_label) {
>  			WARN_ON(1);
>  			continue;
>  		}
>  
> +		label0 = &lsa_label->ns_label;
>  		ndd = to_ndd(nd_mapping);
>  		size += nsl_get_rawsize(ndd, label0);
>  		if (nsl_get_position(ndd, label0) != 0)
> @@ -1943,12 +1953,15 @@ static struct device **scan_labels(struct nd_region *nd_region)
>  
>  	/* "safe" because create_namespace_pmem() might list_move() label_ent */
>  	list_for_each_entry_safe(label_ent, e, &nd_mapping->labels, list) {
> -		struct nd_namespace_label *nd_label = label_ent->label;
> +		struct nd_lsa_label *lsa_label = label_ent->label;
> +		struct nd_namespace_label *nd_label;
>  		struct device **__devs;
>  
> -		if (!nd_label)
> +		if (!lsa_label)
>  			continue;
>  
> +		nd_label = &lsa_label->ns_label;
> +
>  		/* skip labels that describe extents outside of the region */
>  		if (nsl_get_dpa(ndd, nd_label) < nd_mapping->start ||
>  		    nsl_get_dpa(ndd, nd_label) > map_end)
> @@ -2122,7 +2135,7 @@ static int init_active_labels(struct nd_region *nd_region)
>  		if (!count)
>  			continue;
>  		for (j = 0; j < count; j++) {
> -			struct nd_namespace_label *label;
> +			struct nd_lsa_label *label;
>  
>  			label_ent = kzalloc(sizeof(*label_ent), GFP_KERNEL);
>  			if (!label_ent)
> diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
> index 1cc06cc58d14..61348dee687d 100644
> --- a/drivers/nvdimm/nd.h
> +++ b/drivers/nvdimm/nd.h
> @@ -376,7 +376,7 @@ enum nd_label_flags {
>  struct nd_label_ent {
>  	struct list_head list;
>  	unsigned long flags;
> -	struct nd_namespace_label *label;
> +	struct nd_lsa_label *label;

Looking at the series a bit more, I don't think creating 'struct nd_lsa_label' and making all the changes in this patch is necessary. I think an unamed union here of 'struct nd_namespace_label' and 'struct cxl_region_label' should be fine. Most of the CXL region handling should be quite different than namespace handling that the code paths will diverge. Adding a few helper functions should address some of the common code paths or creating separate cxl region based helpers to deal with the rest. i.e. slot_valid() can take a slot number rather than a label type. Being intentional in handling sepcific labeling may be better than trying to force a union between region and namespace labeling.    

>  };
>  
>  enum nd_mapping_lock_class {

