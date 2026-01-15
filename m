Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66623BF2FA
	for <nvdimm@lists.linux.dev>; Thu, 15 Jan 2026 17:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499141; cv=none; b=LEDhdPGYg63bEaWQ2QRHhciQQ2vQb/ktz5K3KUqAM6aY9c/gGWIyf/Cg8Ipu5o3PpEyJm3L1qcMqdPLTPcUle2yXpegAc0GcW4enYw1lyDTyHJ5uPPu8MA8fjzAgQxQeeyVQAD64vM4wxQrjXYhViNqg44vFaFeAAVx9ZEvrrDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499141; c=relaxed/simple;
	bh=FSGxAuXzZc5fALWXLLwr7rj7QV/DJT3OjJDwYtD6eZk=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GTcO4zeGX/6g7ziTg/bfCC44M9XOebPySRoxNqwf1z7Dt8Kdu+5uhWwJMrCFmThlTJ5Ag2CIjpmIeT5G4ZSmLtlORvuSNBt9MtC3aPEBPESk+ssEM+Zad31mjnxdKFybdBwqcC/IWcHcVvNdKTC0GfXjulEqvHHxndCjF4mAT6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dsVkQ2DfMzJ468k;
	Fri, 16 Jan 2026 01:45:18 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id E739F40539;
	Fri, 16 Jan 2026 01:45:34 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 15 Jan
 2026 17:45:34 +0000
Date: Thu, 15 Jan 2026 17:45:32 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Neeraj Kumar <s.neeraj@samsung.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <gost.dev@samsung.com>,
	<a.manzanares@samsung.com>, <vishak.g@samsung.com>, <neeraj.kernel@gmail.com>
Subject: Re: [PATCH V5 03/17] nvdimm/label: Add namespace/region label
 support as per LSA 2.1
Message-ID: <20260115174532.0000716e@huawei.com>
In-Reply-To: <20260109124437.4025893-4-s.neeraj@samsung.com>
References: <20260109124437.4025893-1-s.neeraj@samsung.com>
	<CGME20260109124503epcas5p27010aaf98c7c3735852cbb18bd68458e@epcas5p2.samsung.com>
	<20260109124437.4025893-4-s.neeraj@samsung.com>
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

On Fri,  9 Jan 2026 18:14:23 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

> Modify __pmem_label_update() to update region labels into LSA
> 
> CXL 3.2 Spec mentions CXL LSA 2.1 Namespace Labels at section 9.13.2.5
> Modified __pmem_label_update() using setter functions to update
> namespace label as per CXL LSA 2.1
> 
> Create export routine nd_region_label_update() used for creating
> region label into LSA. It will be used later from CXL subsystem
> 
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>

Hi Neeraj,

There are a few more instances of copying in and out of UUIDs that
should be using the import and export functions.

With those fixed up,
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

> ---
>  drivers/nvdimm/label.c          | 360 ++++++++++++++++++++++++++------
>  drivers/nvdimm/label.h          |  17 +-
>  drivers/nvdimm/namespace_devs.c |  20 +-
>  drivers/nvdimm/nd.h             |  51 +++++
>  include/linux/libnvdimm.h       |   8 +
>  5 files changed, 386 insertions(+), 70 deletions(-)
> 
> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index 0a9b6c5cb2c3..17e2a1f5a6da 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c


> +static void region_label_update(struct nd_region *nd_region,
> +				struct cxl_region_label *region_label,
> +				struct nd_mapping *nd_mapping,
> +				int pos, u64 flags, u32 slot)
> +{
> +	struct nd_interleave_set *nd_set = nd_region->nd_set;
> +	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
> +
> +	/* Set Region Label Format identification UUID */
> +	uuid_copy((uuid_t *)region_label->type, &cxl_region_uuid);


Why is this one not an export_uuid()?


> +
> +	/* Set Current Region Label UUID */
> +	export_uuid(region_label->uuid, &nd_set->uuid);
> +
> +	region_label->flags = __cpu_to_le32(flags);
> +	region_label->nlabel = __cpu_to_le16(nd_region->ndr_mappings);
> +	region_label->position = __cpu_to_le16(pos);
> +	region_label->dpa = __cpu_to_le64(nd_mapping->start);
> +	region_label->rawsize = __cpu_to_le64(nd_mapping->size);
> +	region_label->hpa = __cpu_to_le64(nd_set->res->start);
> +	region_label->slot = __cpu_to_le32(slot);
> +	region_label->ig = __cpu_to_le32(nd_set->interleave_granularity);
> +	region_label->align = __cpu_to_le32(0);
> +
> +	/* Update fletcher64 Checksum */
> +	region_label_calculate_checksum(ndd, region_label);
> +}

> diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
> index f631bd84d6f0..1b31eee3028e 100644
> --- a/drivers/nvdimm/nd.h
> +++ b/drivers/nvdimm/nd.h

...

> +}
> +
> +static inline bool is_region_label(struct nvdimm_drvdata *ndd,
> +				   union nd_lsa_label *lsa_label)
> +{
> +	if (!ndd->cxl)
> +		return false;
> +
> +	return uuid_equal(&cxl_region_uuid,
> +			  (uuid_t *)lsa_label->region_label.type);
As below.
> +}
> +
> +static inline bool
> +region_label_uuid_equal(struct cxl_region_label *region_label,
> +			const uuid_t *uuid)
> +{
> +	return uuid_equal((uuid_t *)region_label->uuid, uuid);

Not appropriate to do an import_uuid() for this and similar cases?
In general I don't think we should see any casts to uuid_t *

There are 3 instances of this in the kernel and we should probably clean
all those up.  There are a lot more doing the import!

Jonathan


> +}


