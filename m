Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41CB622DF85
	for <nvdimm@lists.linux.dev>; Mon, 23 Jun 2025 09:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750669536; cv=none; b=UaUjZtlcwZCeZ5srA+To95bGL1QCRPJEmt32B4S0TKUvrDstxQThW6/AJL3SVjYWCEa89D0hqoYPmGLa8k7EepCTy3QaYIbvdpjXNHLDH/IBVJf2BEZk1le6ctFc8BRBnsqr2ynhfGKBXlwTH9d+dutXIWguRyziE8cYaV3GC30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750669536; c=relaxed/simple;
	bh=RWuS71A2QsnVIVDB4RKGk4iONoi5tzTDwm8Np/A6zUs=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PgJZgfY0LyCoBKX+H/RpDqTCbVafjnXa9H9C6ftKsk+2hVUzClZtWC8NRKC3YvdAEBta4LzTEi3zC6ZPNmZCuYkomon6GyFVEgQvzwOudN7FQvBvqZCbg8N8gOL3pLAJPEiCpqdQuAOw0stzcQb498tBkW+cCoNy1fj1PHkDeIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4bQhtm4tCFz6HJqB;
	Mon, 23 Jun 2025 17:02:56 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 4C11F1402F4;
	Mon, 23 Jun 2025 17:05:23 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Mon, 23 Jun
 2025 11:05:22 +0200
Date: Mon, 23 Jun 2025 10:05:20 +0100
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
Subject: Re: [RFC PATCH 05/20] nvdimm/region_label: Add region label
 updation routine
Message-ID: <20250623100520.00003f34@huawei.com>
In-Reply-To: <1690859824.141750165204442.JavaMail.epsvc@epcpadp1new>
References: <20250617123944.78345-1-s.neeraj@samsung.com>
	<CGME20250617124019epcas5p39815cc0f2b175aee40c194625166695c@epcas5p3.samsung.com>
	<1690859824.141750165204442.JavaMail.epsvc@epcpadp1new>
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

On Tue, 17 Jun 2025 18:09:29 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

Add region label update routine


> Added __pmem_region_label_update region label update routine to update
> region label
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
A few trivial comments inline. 

Jonathan

> ---
>  drivers/nvdimm/label.c          | 142 ++++++++++++++++++++++++++++++++
>  drivers/nvdimm/label.h          |   2 +
>  drivers/nvdimm/namespace_devs.c |  12 +++
>  drivers/nvdimm/nd.h             |  20 +++++
>  include/linux/libnvdimm.h       |   8 ++
>  5 files changed, 184 insertions(+)
> 
> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index d5cfaa99f976..7f33d14ce0ef 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c
> @@ -381,6 +381,16 @@ static void nsl_calculate_checksum(struct nvdimm_drvdata *ndd,
>  	nsl_set_checksum(ndd, nd_label, sum);
>  }
>  
> +static void rgl_calculate_checksum(struct nvdimm_drvdata *ndd,
> +				   struct cxl_region_label *rg_label)
> +{
> +	u64 sum;
> +
> +	rgl_set_checksum(rg_label, 0);
> +	sum = nd_fletcher64(rg_label, sizeof_namespace_label(ndd), 1);
> +	rgl_set_checksum(rg_label, sum);
> +}
> +
>  static bool slot_valid(struct nvdimm_drvdata *ndd,
>  		struct nd_lsa_label *nd_label, u32 slot)
>  {
> @@ -1117,6 +1127,138 @@ int nd_pmem_namespace_label_update(struct nd_region *nd_region,
>  	return 0;
>  }
>  
> +static int __pmem_region_label_update(struct nd_region *nd_region,
> +		struct nd_mapping *nd_mapping, int pos, unsigned long flags)
> +{
> +	struct nd_interleave_set *nd_set = nd_region->nd_set;
> +	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
> +	struct nd_lsa_label *nd_label;
> +	struct cxl_region_label *rg_label;
> +	struct nd_namespace_index *nsindex;
> +	struct nd_label_ent *label_ent;
> +	unsigned long *free;
> +	u32 nslot, slot;
> +	size_t offset;
> +	int rc;
> +	uuid_t tmp;
> +
> +	if (!preamble_next(ndd, &nsindex, &free, &nslot))
> +		return -ENXIO;
> +
> +	/* allocate and write the label to the staging (next) index */
> +	slot = nd_label_alloc_slot(ndd);
> +	if (slot == UINT_MAX)
> +		return -ENXIO;
> +	dev_dbg(ndd->dev, "allocated: %d\n", slot);
> +
> +	nd_label = to_label(ndd, slot);
> +
> +	memset(nd_label, 0, sizeof_namespace_label(ndd));
> +	rg_label = &nd_label->rg_label;
> +
> +	/* Set Region Label Format identification UUID */
> +	uuid_parse(CXL_REGION_UUID, &tmp);
> +	export_uuid(nd_label->rg_label.type, &tmp);
> +
> +	/* Set Current Region Label UUID */
> +	export_uuid(nd_label->rg_label.uuid, &nd_set->uuid);
> +
> +	rg_label->flags = __cpu_to_le32(flags);
> +	rg_label->nlabel = __cpu_to_le16(nd_region->ndr_mappings);
> +	rg_label->position = __cpu_to_le16(pos);
> +	rg_label->dpa = __cpu_to_le64(nd_mapping->start);
> +	rg_label->rawsize = __cpu_to_le64(nd_mapping->size);
> +	rg_label->hpa = __cpu_to_le64(nd_set->res->start);
> +	rg_label->slot = __cpu_to_le32(slot);
> +	rg_label->ig = __cpu_to_le32(nd_set->interleave_granularity);
> +	rg_label->align = __cpu_to_le16(0);
> +
> +	/* Update fletcher64 Checksum */
> +	rgl_calculate_checksum(ndd, rg_label);
> +
> +	/* update label */
> +	offset = nd_label_offset(ndd, nd_label);
> +	rc = nvdimm_set_config_data(ndd, offset, nd_label,
> +			sizeof_namespace_label(ndd));
> +	if (rc < 0) {
> +		nd_label_free_slot(ndd, slot);
> +		return rc;
> +	}
> +
> +	/* Garbage collect the previous label */
> +	mutex_lock(&nd_mapping->lock);

Perhaps use

	guard(mutex)(&nd_mapping->lock);

so you can directly return in the error path below and simplify the flow
a tiny bit.

> +	list_for_each_entry(label_ent, &nd_mapping->labels, list) {
> +		if (!label_ent->label)
> +			continue;
> +		if (rgl_uuid_equal(&label_ent->label->rg_label, &nd_set->uuid))
> +			reap_victim(nd_mapping, label_ent);
> +	}
> +
> +	/* update index */
> +	rc = nd_label_write_index(ndd, ndd->ns_next,
> +			nd_inc_seq(__le32_to_cpu(nsindex->seq)), 0);
> +
With guard this can be 
	if (rc)
		return rec;

	list_for_each...

> +	if (rc == 0) {
> +		list_for_each_entry(label_ent, &nd_mapping->labels, list)
> +			if (!label_ent->label) {
> +				label_ent->label = nd_label;
> +				nd_label = NULL;
> +				break;
> +			}
> +		dev_WARN_ONCE(&nd_region->dev, nd_label,
> +				"failed to track label: %d\n",
> +				to_slot(ndd, nd_label));
> +		if (nd_label)
> +			rc = -ENXIO;
> +	}
> +	mutex_unlock(&nd_mapping->lock);
> +
> +	return rc;
> +}

