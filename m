Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08DF33C00AE
	for <nvdimm@lists.linux.dev>; Thu, 15 Jan 2026 17:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499758; cv=none; b=aS2XazIWj5UDxYuqbQVUlybYyVLcBuAGH2bD9G+RToXQo5RFdOHxjOrmpZXKWPCWhtsGEPNFyYr3rpC3bQCxXz/xVIGn29KglbrFgoodhdHhH52/CkGA1of3iDQgawAc6YJc9NVcmIIFPOEIsvIB2wzzO9XACoXsK9a7cZXc400=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499758; c=relaxed/simple;
	bh=XpzRVkb4qa4eg7wxYhPfLMTZA/8/oQX+R6MRfhJyB0Q=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NllPLnPHC+yyVKnAxp/CAKT/cqJjNTn300AwFtmA5wT14d7K2L0WuFw7NMUx7ECGUQIT/qQahj5vm8wTyjo3Ca0iqCQ2QSqEUp0GuudSMilu1iFEm3X3JzJI7QrGGtn7EWek7h/gMNbX+mE+Bkn7P1+llpa3uhXbz6XQaeAV3qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dsVy92QZrzHnGcl;
	Fri, 16 Jan 2026 01:55:29 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id A5AC640572;
	Fri, 16 Jan 2026 01:55:51 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 15 Jan
 2026 17:55:51 +0000
Date: Thu, 15 Jan 2026 17:55:49 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Neeraj Kumar <s.neeraj@samsung.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <gost.dev@samsung.com>,
	<a.manzanares@samsung.com>, <vishak.g@samsung.com>, <neeraj.kernel@gmail.com>
Subject: Re: [PATCH V5 04/17] nvdimm/label: Include region label in slot
 validation
Message-ID: <20260115175549.000031bd@huawei.com>
In-Reply-To: <20260109124437.4025893-5-s.neeraj@samsung.com>
References: <20260109124437.4025893-1-s.neeraj@samsung.com>
	<CGME20260109124512epcas5p4a6d8c2b9c6cf7cf794d1a477eaee7865@epcas5p4.samsung.com>
	<20260109124437.4025893-5-s.neeraj@samsung.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100009.china.huawei.com (7.191.174.83) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Fri,  9 Jan 2026 18:14:24 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

> Prior to LSA 2.1 Support, label in slot means only namespace
> label. But with LSA 2.1 a label can be either namespace or
> region label.
> 
> Slot validation routine validates label slot by calculating
> label checksum. It was only validating namespace label.
> This changeset also validates region label if present.
> 
> In previous patch to_lsa_label() was introduced along with
> to_label(). to_label() returns only namespace label whereas
> to_lsa_label() returns union nd_lsa_label*
> 
> In this patch We have converted all usage of to_label()
> to to_lsa_label()
> 
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
Hi

A few more things given you are going around again!

Jonathan

> ---
>  drivers/nvdimm/label.c | 94 ++++++++++++++++++++++++++++--------------
>  1 file changed, 64 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index 17e2a1f5a6da..9854cb45fb62 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c
> @@ -312,16 +312,6 @@ static union nd_lsa_label *to_lsa_label(struct nvdimm_drvdata *ndd, int slot)

> +
>  static void region_label_calculate_checksum(struct nvdimm_drvdata *ndd,
>  				   struct cxl_region_label *region_label)
>  {
> @@ -415,16 +417,34 @@ static void region_label_calculate_checksum(struct nvdimm_drvdata *ndd,
>  }
>  
>  static bool slot_valid(struct nvdimm_drvdata *ndd,
> -		struct nd_namespace_label *nd_label, u32 slot)
> +		       union nd_lsa_label *lsa_label, u32 slot)
>  {
> +	struct cxl_region_label *region_label = &lsa_label->region_label;
> +	struct nd_namespace_label *nd_label = &lsa_label->ns_label;

Move the assignments of these so we only do them if they are relevant.
That should make the code more resilient as any use outside those scopes
will fire compiler warnings.

> +	enum label_type type;
>  	bool valid;
> +	static const char * const label_name[] = {
> +		[RG_LABEL_TYPE] = "region",
> +		[NS_LABEL_TYPE] = "namespace",
> +	};
>  
>  	/* check that we are written where we expect to be written */
> -	if (slot != nsl_get_slot(ndd, nd_label))
> -		return false;
> -	valid = nsl_validate_checksum(ndd, nd_label);
> +	if (is_region_label(ndd, lsa_label)) {
> +		type = RG_LABEL_TYPE;
> +		if (slot != __le32_to_cpu(region_label->slot))
> +			return false;
> +		valid = region_label_validate_checksum(ndd, region_label);
> +	} else {
> +		type = NS_LABEL_TYPE;
> +		if (slot != nsl_get_slot(ndd, nd_label))
> +			return false;
> +		valid = nsl_validate_checksum(ndd, nd_label);
> +	}


> @@ -598,18 +620,30 @@ int nd_label_active_count(struct nvdimm_drvdata *ndd)
>  		return 0;
>  
>  	for_each_clear_bit_le(slot, free, nslot) {
> +		struct cxl_region_label *region_label;
>  		struct nd_namespace_label *nd_label;
> -
> -		nd_label = to_label(ndd, slot);
> -
> -		if (!slot_valid(ndd, nd_label, slot)) {
> -			u32 label_slot = nsl_get_slot(ndd, nd_label);
> -			u64 size = nsl_get_rawsize(ndd, nd_label);
> -			u64 dpa = nsl_get_dpa(ndd, nd_label);
> +		union nd_lsa_label *lsa_label;
> +		u32 lslot;

Trivial but if you keep the label_slot naming, then the diff gets a little
smaller, and it's easier to see where the code moved.  Don't worry about going just
over 80 chars. We are more relaxed these days as long as it helps readability.

> +		u64 size, dpa;
> +
> +		lsa_label = to_lsa_label(ndd, slot);
> +		nd_label = &lsa_label->ns_label;

Move this

> +		region_label = &lsa_label->region_label;

and this down to the scopes where they are meaningful.
So under if (is_region_label() and the else.

> +
> +		if (!slot_valid(ndd, lsa_label, slot)) {
> +			if (is_region_label(ndd, lsa_label)) {
> +				lslot = __le32_to_cpu(region_label->slot);
> +				size = __le64_to_cpu(region_label->rawsize);
> +				dpa = __le64_to_cpu(region_label->dpa);
> +			} else {
> +				lslot = nsl_get_slot(ndd, nd_label);
> +				size = nsl_get_rawsize(ndd, nd_label);
> +				dpa = nsl_get_dpa(ndd, nd_label);
> +			}
>  
>  			dev_dbg(ndd->dev,
>  				"slot%d invalid slot: %d dpa: %llx size: %llx\n",
> -					slot, label_slot, dpa, size);
> +					slot, lslot, dpa, size);
>  			continue;
>  		}
>  		count++;
=

