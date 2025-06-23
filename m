Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F267230BC8
	for <nvdimm@lists.linux.dev>; Mon, 23 Jun 2025 09:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750669804; cv=none; b=itH+FhDCri4oKxzgzZ8tk5B0t+cEJtbDLeEA3hTYV/kO6x4V5KyIj2vCUWDqLkSvtrA9ew7OVMEypsiOZ9i6Q3/ASKlem6B+v3cIP35YOgP1AAlBvDqqLvv7B7YHw+jshq5qm6raHmUgAUqQOl+DpWmnLQD+T3f3MlS6EZ7h7FM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750669804; c=relaxed/simple;
	bh=+zBnHfXEZAo3hfysRCCYnWMP6NBVypQZJ+axJ70u0jQ=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bdrqsoo0Kldt6+NKhGvmEwKv237CrYS8sKdE+I97wTCEOM654CDgh1vZp3i9COSgMvD+GggNihQ8nzI9UEt8JVu4kTnAVcdUvapk+v95TDj6Nf91gmE4xhuV1ha31gj5J1gVlbDa6S2QvIIong+UcCV2/nGO1Au5EEFRW3FR0eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4bQj043sS6z6HJqB;
	Mon, 23 Jun 2025 17:07:32 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 2B7C21402E9;
	Mon, 23 Jun 2025 17:09:59 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Mon, 23 Jun
 2025 11:09:58 +0200
Date: Mon, 23 Jun 2025 10:09:57 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Neeraj Kumar <s.neeraj@samsung.com>
CC: <dan.j.williams@intel.com>, <dave@stgolabs.net>, <dave.jiang@intel.com>,
	<alison.schofield@intel.com>, <vishal.l.verma@intel.com>,
	<ira.weiny@intel.com>, <a.manzanares@samsung.com>, <nifan.cxl@gmail.com>,
	<anisa.su@samsung.com>, <vishak.g@samsung.com>, <krish.reddy@samsung.com>,
	<arun.george@samsung.com>, <alok.rathore@samsung.com>,
	<neeraj.kernel@gmail.com>, <linux-kernel@vger.kernel.org>,
	<linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<gost.dev@samsung.com>, <cpgs@samsung.com>
Subject: Re: [RFC PATCH 06/20] nvdimm/region_label: Add region label
 deletion routine
Message-ID: <20250623100957.000032a2@huawei.com>
In-Reply-To: <1256440269.161750165204630.JavaMail.epsvc@epcpadp1new>
References: <20250617123944.78345-1-s.neeraj@samsung.com>
	<CGME20250617124022epcas5p2441d6c5dfaeceb744b5fc00add7ceae0@epcas5p2.samsung.com>
	<1256440269.161750165204630.JavaMail.epsvc@epcpadp1new>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500011.china.huawei.com (7.191.174.215) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Tue, 17 Jun 2025 18:09:30 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

> Added cxl v2.1 format region label deletion routine. This function is
> used to delete region label from LSA
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
> ---
>  drivers/nvdimm/label.c          | 75 ++++++++++++++++++++++++++++++---
>  drivers/nvdimm/label.h          |  6 +++
>  drivers/nvdimm/namespace_devs.c | 12 ++++++
>  drivers/nvdimm/nd.h             |  9 ++++
>  include/linux/libnvdimm.h       |  1 +
>  5 files changed, 98 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index 7f33d14ce0ef..9381c50086fc 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c
> @@ -1034,7 +1034,8 @@ static int init_labels(struct nd_mapping *nd_mapping, int num_labels)
>  	return max(num_labels, old_num_labels);
>  }
>  
> -static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
> +static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid,
> +		enum label_type ltype)
>  {
>  	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
>  	struct nd_label_ent *label_ent, *e;
> @@ -1058,8 +1059,18 @@ static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
>  		if (!nd_label)
>  			continue;
>  		active++;
> -		if (!nsl_uuid_equal(ndd, &nd_label->ns_label, uuid))
> -			continue;
> +
> +		if (ltype == NS_LABEL_TYPE) {

Perhaps a switch is more appropriate here.

> +			if (!nsl_uuid_equal(ndd, &nd_label->ns_label, uuid))
> +				continue;
> +		} else if (ltype == RG_LABEL_TYPE) {
> +			if (!nsl_uuid_equal(ndd, &nd_label->ns_label, uuid))
> +				continue;
> +		} else {
> +			dev_err(ndd->dev, "Invalid label type\n");
> +			return 0;
> +		}
> +
>  		active--;
>  		slot = to_slot(ndd, nd_label);
>  		nd_label_free_slot(ndd, slot);

> @@ -1259,6 +1271,59 @@ int nd_pmem_region_label_update(struct nd_region *nd_region)
>  	return 0;
>  }
>  
> +int nd_pmem_region_label_delete(struct nd_region *nd_region)
> +{
> +	int i, rc;
> +	struct nd_interleave_set *nd_set = nd_region->nd_set;
> +	struct nd_label_ent *label_ent;
> +	bool is_non_rgl = false;
> +	int ns_region_cnt = 0;
> +
> +	for (i = 0; i < nd_region->ndr_mappings; i++) {
> +		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
> +		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
> +
> +		/* Find non cxl format supported ndr_mappings */
> +		if (!ndd->cxl)
> +			is_non_rgl = true;
> +
> +		/* Find if any NS label using this region */
> +		mutex_lock(&nd_mapping->lock);
> +		list_for_each_entry(label_ent, &nd_mapping->labels, list) {
> +			if (!label_ent->label)
> +				continue;
> +
> +			/* Check if any available NS labels has same

Looks like wrong style for multiline comments in this file.

			/*
			 * Check ...

> +			 * region_uuid in LSA
> +			 */
> +			if (nsl_region_uuid_equal(&label_ent->label->ns_label,
> +						  &nd_set->uuid))
> +				ns_region_cnt++;
> +		}
> +		mutex_unlock(&nd_mapping->lock);
> +	}
> +
> +	if (is_non_rgl) {
> +		dev_dbg(&nd_region->dev, "Region label deletion unsupported\n");
> +		return -EINVAL;

Why not bail out where you originally detect that above?

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

