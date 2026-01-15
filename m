Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F01B83BC4D8
	for <nvdimm@lists.linux.dev>; Thu, 15 Jan 2026 18:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768500202; cv=none; b=ItmLUXBTXyQcwx4rL07p6U5BhLbZfaK9wMvTbHqPL58ZhiIagz5IPUH7NLm7vi/HaNlypjzabSAdoBXp74JjFbi6CutV64fkJ5nMZd7mzRvjYwos0Bq+QqFC/g8wFe8egwJLL1Md5ECPrDpKE49HiM61dAbf8WaaPmV4YX3KtYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768500202; c=relaxed/simple;
	bh=z4tasWrH0jwSkkCfk+0JnKnbW4KVq3UV5jQoaKPlOGA=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hp9dW8azYHwLKDEYEGzL3iTcsa10dRq93S9vLLwgLb+Z/ju+vthW4/YT8qsJZC22XZp9Nd54hM+2y6SIZf9aTQ/yG8VwEOdtk4RJVKJRsBjLOdho9aVOJ93oHQ6wPEK0uvVMxvmE076GoXMhZ+NQWdMxkPN/GfVPUVmLAjMYH5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dsW6m5FYMzHnGgv;
	Fri, 16 Jan 2026 02:02:56 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 1508A40570;
	Fri, 16 Jan 2026 02:03:19 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 15 Jan
 2026 18:03:18 +0000
Date: Thu, 15 Jan 2026 18:03:16 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Neeraj Kumar <s.neeraj@samsung.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <gost.dev@samsung.com>,
	<a.manzanares@samsung.com>, <vishak.g@samsung.com>, <neeraj.kernel@gmail.com>
Subject: Re: [PATCH V5 08/17] nvdimm/label: Preserve cxl region information
 from region label
Message-ID: <20260115180316.000023fe@huawei.com>
In-Reply-To: <20260109124437.4025893-9-s.neeraj@samsung.com>
References: <20260109124437.4025893-1-s.neeraj@samsung.com>
	<CGME20260109124521epcas5p299cea0eaef023816e18f5fd32d053224@epcas5p2.samsung.com>
	<20260109124437.4025893-9-s.neeraj@samsung.com>
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

On Fri,  9 Jan 2026 18:14:28 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

> Preserve region information from region label during nvdimm_probe. This
> preserved region information is used for creating cxl region to achieve
> region persistency across reboot.
> This patch supports interleave way == 1, it is therefore it preserves
> only one region into LSA
> 
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>

With change to import for getting the region uuid,
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index 2ad148bfe40b..7adb415f0926 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c
> @@ -494,6 +494,42 @@ int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
>  	return 0;
>  }
>  
> +int nvdimm_cxl_region_preserve(struct nvdimm_drvdata *ndd)
> +{
> +	struct nvdimm *nvdimm = to_nvdimm(ndd->dev);
> +	struct cxl_pmem_region_params *p = &nvdimm->cxl_region_params;
> +	struct nd_namespace_index *nsindex;
> +	unsigned long *free;
> +	u32 nslot, slot;
> +
> +	if (!preamble_current(ndd, &nsindex, &free, &nslot))
> +		return 0; /* no label, nothing to preserve */
> +
> +	for_each_clear_bit_le(slot, free, nslot) {
> +		union nd_lsa_label *lsa_label = to_lsa_label(ndd, slot);
> +		struct cxl_region_label *region_label = &lsa_label->region_label;
> +		uuid_t *region_uuid = (uuid_t *)&region_label->type;

Another case where I think we should be importing.
I'm not entirely sure why that's the convention for these but we
should probably stick to it anyway.

> +
> +		/* TODO: Currently preserving only one region */
> +		if (uuid_equal(&cxl_region_uuid, region_uuid)) {
> +			nvdimm->is_region_label = true;
> +			import_uuid(&p->uuid, region_label->uuid);
> +			p->flags = __le32_to_cpu(region_label->flags);
> +			p->nlabel = __le16_to_cpu(region_label->nlabel);
> +			p->position = __le16_to_cpu(region_label->position);
> +			p->dpa = __le64_to_cpu(region_label->dpa);
> +			p->rawsize = __le64_to_cpu(region_label->rawsize);
> +			p->hpa = __le64_to_cpu(region_label->hpa);
> +			p->slot = __le32_to_cpu(region_label->slot);
> +			p->ig = __le32_to_cpu(region_label->ig);
> +			p->align = __le32_to_cpu(region_label->align);
> +			break;
> +		}
> +	}
> +
> +	return 0;
> +}

