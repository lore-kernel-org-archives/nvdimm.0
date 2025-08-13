Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BBEA2F49EF
	for <nvdimm@lists.linux.dev>; Wed, 13 Aug 2025 14:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755096825; cv=none; b=MU4/2tjn8WzVsbV1OVs306FC0mxPRfegAvtz4F/Z4a++w1aV+n+fqx1DL4At/io8BvFr23gVtJ2qoC4Obcrukqk11N8ZU/eN41R4U32ZgiZhbaTYCsWoOCSILLSWazv6TUp33Dkkr8RP8ZLVSkNV8DnYZFb0GJd2UAsH6zx6bko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755096825; c=relaxed/simple;
	bh=x1AiFTgwENat1BilzwbyfhzOPWbflYUmMUfO6qWERLg=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mm4MOJ3zP1IYyQho3s8Jj75WzKUrqe7RMXux36CzdxJXqEpN1sBkuzTlVKVXBmstPFKFqVqFAy1mma5eQFYbKgjq4WBxzKHtybdjbfSu+qUf92KwakWj3Uz1T4Jw9T0SIiTtUMQo2lHqddkchj/9PdUIjEYYpokUA3GcGIKLFoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4c2BBq4X67z6GBch;
	Wed, 13 Aug 2025 22:50:59 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id AB11914025A;
	Wed, 13 Aug 2025 22:53:40 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 13 Aug
 2025 16:53:40 +0200
Date: Wed, 13 Aug 2025 15:53:38 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Neeraj Kumar <s.neeraj@samsung.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <gost.dev@samsung.com>,
	<a.manzanares@samsung.com>, <vishak.g@samsung.com>, <neeraj.kernel@gmail.com>
Subject: Re: [PATCH V2 06/20] nvdimm/region_label: Add region label deletion
 routine
Message-ID: <20250813155338.00007bcf@huawei.com>
In-Reply-To: <20250730121209.303202-7-s.neeraj@samsung.com>
References: <20250730121209.303202-1-s.neeraj@samsung.com>
	<CGME20250730121230epcas5p11650f090de55d0a2db541ee32e9a6fee@epcas5p1.samsung.com>
	<20250730121209.303202-7-s.neeraj@samsung.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100005.china.huawei.com (7.191.160.25) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Wed, 30 Jul 2025 17:41:55 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

> Added cxl v2.1 format region label deletion routine. This function is
> used to delete region label from LSA
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
> ---
>  drivers/nvdimm/label.c          | 77 ++++++++++++++++++++++++++++++---
>  drivers/nvdimm/label.h          |  6 +++
>  drivers/nvdimm/namespace_devs.c | 12 +++++
>  drivers/nvdimm/nd.h             |  9 ++++
>  include/linux/libnvdimm.h       |  1 +
>  5 files changed, 100 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index 94f2d0ba7aca..be18278d6cea 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c
> @@ -1044,7 +1044,8 @@ static int init_labels(struct nd_mapping *nd_mapping, int num_labels)
>  	return max(num_labels, old_num_labels);
>  }
>  
> -static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
> +static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid,
> +		enum label_type ltype)
>  {
>  	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
>  	struct nd_label_ent *label_ent, *e;
> @@ -1068,8 +1069,23 @@ static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
>  		if (!nd_label)
>  			continue;
>  		active++;
> -		if (!nsl_uuid_equal(ndd, &nd_label->ns_label, uuid))
> -			continue;
> +
> +		switch (ltype) {
> +		case NS_LABEL_TYPE:
> +			if (!nsl_uuid_equal(ndd, &nd_label->ns_label, uuid))
> +				continue;
> +
> +			break;
> +		case RG_LABEL_TYPE:
> +			if (!rgl_uuid_equal(&nd_label->rg_label, uuid))
> +				continue;
> +
> +			break;
> +		default:
> +			dev_err(ndd->dev, "Invalid label type\n");
> +			return 0;

Given you pass in an enum and both elements are covered by other cases
shouldn't need a default here.

> +		}
> +
>  		active--;
>  		slot = to_slot(ndd, nd_label);
>  		nd_label_free_slot(ndd, slot);



> @@ -1268,6 +1285,56 @@ int nd_pmem_region_label_update(struct nd_region *nd_region)
>  	return 0;
>  }
>  
> +int nd_pmem_region_label_delete(struct nd_region *nd_region)
> +{
> +	int i, rc;
> +	struct nd_interleave_set *nd_set = nd_region->nd_set;
> +	struct nd_label_ent *label_ent;
> +	int ns_region_cnt = 0;
> +
> +	for (i = 0; i < nd_region->ndr_mappings; i++) {
> +		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
> +		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
> +
> +		/* Find non cxl format supported ndr_mappings */
> +		if (!ndd->cxl) {
> +			dev_info(&nd_region->dev, "Region label unsupported\n");

I'd go with "Unsupported region label".  The other way around kind of implies
a deficiency in the code, whereas point here is that new stuff may be added to
the spec that we don't yet understand.

> +			return -EINVAL;
> +		}
> +
> +		/* Find if any NS label using this region */
> +		mutex_lock(&nd_mapping->lock);

I'd go for guard here probably as the scope will mean it gets unlocked
at end of this loop step.


		guard(mutex)(&nd_mapping->lock);
> +		list_for_each_entry(label_ent, &nd_mapping->labels, list) {
> +			if (!label_ent->label)
> +				continue;
> +
> +			/*
> +			 * Check if any available NS labels has same
> +			 * region_uuid in LSA
> +			 */
> +			if (nsl_region_uuid_equal(&label_ent->label->ns_label,
> +						  &nd_set->uuid))
> +				ns_region_cnt++;
> +		}
> +		mutex_unlock(&nd_mapping->lock);
> +	}
> +
> +	if (ns_region_cnt) {
> +		dev_dbg(&nd_region->dev, "Region/Namespace label in use\n");
> +		return -EBUSY;
> +	}
> +
> +	for (i = 0; i < nd_region->ndr_mappings; i++) {
> +		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
> +
> +		rc = del_labels(nd_mapping, &nd_set->uuid, RG_LABEL_TYPE);
> +		if (rc)
> +			return rc;
> +	}
> +
> +	return 0;
> +}
> +
>  int __init nd_label_init(void)
>  {
>  	WARN_ON(guid_parse(NVDIMM_BTT_GUID, &nvdimm_btt_guid));
>
> @@ -235,4 +240,5 @@ struct nd_namespace_pmem;
>  int nd_pmem_namespace_label_update(struct nd_region *nd_region,
>  		struct nd_namespace_pmem *nspm, resource_size_t size);
>  int nd_pmem_region_label_update(struct nd_region *nd_region);
> +int nd_pmem_region_label_delete(struct nd_region *nd_region);
>  #endif /* __LABEL_H__ */


