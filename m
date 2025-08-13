Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9771B2F067A
	for <nvdimm@lists.linux.dev>; Wed, 13 Aug 2025 15:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755097917; cv=none; b=Yf631rZqrSu1NzzGsF9w9R6oiUy1Fevo6BWBRXvJLQ1HANZaojkv/SQ5GMqfUvUuO5VmcWtXgGAsZIrfLEljbmqCflrrf5qEd8hBslC5EryAvmEgyfmbu5iiO5JueeqCRj4nNAsO6AfZVpmhbWAwYqcwhBlFUh2TtsxEEA4nuYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755097917; c=relaxed/simple;
	bh=egebn/Z7HfdZN+dJPK5iK0KCklzEXZlmgN5eWex9MhU=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p9BDUMshjosInL0BWBQyow91nS/t7aTg84IBrsL9+qLTr5QZ3FSwf0xXI4H7UGEeWCMfBa5NX6Lb5W7BV3pvTe4aIWhwcdvtP7TymbkgNRZwuhcbUFMcGgtlnkfsp35fVOOk7gSscUqQEa9djA5B9q/G8whG9YGrz7H0J3T3lTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4c2Bbr3D8mz6L53R;
	Wed, 13 Aug 2025 23:09:12 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 8F22B1404C4;
	Wed, 13 Aug 2025 23:11:53 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 13 Aug
 2025 17:11:53 +0200
Date: Wed, 13 Aug 2025 16:11:51 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Neeraj Kumar <s.neeraj@samsung.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <gost.dev@samsung.com>,
	<a.manzanares@samsung.com>, <vishak.g@samsung.com>, <neeraj.kernel@gmail.com>
Subject: Re: [PATCH V2 10/20] nvdimm/region_label: Preserve cxl region
 information from region label
Message-ID: <20250813161151.00006d59@huawei.com>
In-Reply-To: <20250730121209.303202-11-s.neeraj@samsung.com>
References: <20250730121209.303202-1-s.neeraj@samsung.com>
	<CGME20250730121235epcas5p4494147524e77e99bc16d9b510e8971a4@epcas5p4.samsung.com>
	<20250730121209.303202-11-s.neeraj@samsung.com>
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

On Wed, 30 Jul 2025 17:41:59 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

> Preserve region information from region label during nvdimm_probe. This
> preserved region information is used for creating cxl region to achieve
> region persistency across reboot.
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>

See below.

> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index 064a945dcdd1..bcac05371f87 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c
> @@ -473,6 +473,47 @@ int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
>  	return 0;
>  }
>  
> +int nvdimm_cxl_region_preserve(struct nvdimm_drvdata *ndd)
> +{
> +	struct nvdimm *nvdimm = to_nvdimm(ndd->dev);
> +	struct cxl_pmem_region_params *params = &nvdimm->cxl_region_params;
> +	struct nd_namespace_index *nsindex;
> +	unsigned long *free;
> +	u32 nslot, slot;
> +
> +	if (!preamble_current(ndd, &nsindex, &free, &nslot))
> +		return 0; /* no label, nothing to preserve */
> +
> +	for_each_clear_bit_le(slot, free, nslot) {
> +		struct nd_lsa_label *nd_label;
> +		struct cxl_region_label *rg_label;
> +		uuid_t rg_type, region_type;
> +
> +		nd_label = to_label(ndd, slot);
> +		rg_label = &nd_label->rg_label;
> +		uuid_parse(CXL_REGION_UUID, &region_type);
> +		import_uuid(&rg_type, nd_label->rg_label.type);
> +
> +		/* REVISIT: Currently preserving only one region */

In practice, is this a significant issue or not?  I.e. should we not
merge this series until this has been revisited?

> +		if (uuid_equal(&region_type, &rg_type)) {
> +			nvdimm->is_region_label = true;
> +			import_uuid(&params->uuid, rg_label->uuid);
> +			params->flags = __le32_to_cpu(rg_label->flags);
> +			params->nlabel = __le16_to_cpu(rg_label->nlabel);
> +			params->position = __le16_to_cpu(rg_label->position);
> +			params->dpa = __le64_to_cpu(rg_label->dpa);
> +			params->rawsize = __le64_to_cpu(rg_label->rawsize);
> +			params->hpa = __le64_to_cpu(rg_label->hpa);
> +			params->slot = __le32_to_cpu(rg_label->slot);
> +			params->ig = __le32_to_cpu(rg_label->ig);
> +			params->align = __le32_to_cpu(rg_label->align);
> +			break;
> +		}
> +	}
> +
> +	return 0;
> +}

