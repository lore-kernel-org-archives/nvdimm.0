Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2263B362149
	for <nvdimm@lists.linux.dev>; Wed, 17 Dec 2025 15:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765984155; cv=none; b=ssQ6K6KOK8y409yZvZWBuk/mFJmWyzhfRAHiKy8t1+2HMh6Hk9k/xvFPYhoRUxQJm45W1aEuXOdsadUy20cqN4tXBPczk1Is5FSbDYdCXy17ZOjBuLf3QX0STRG45lT3yqXpZX6uSre+I7B5/FsR3nRZL3k6O30R1pFGu1Ge6QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765984155; c=relaxed/simple;
	bh=wc0Tq+BZWG2QLkF0p4q/HHVN2nw2/Ec79W93o5eSAe4=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kgxTdhZqN8AXxDEH/dM1K+9SXSQkfrOaRlOZmfNHZwA+sfl/NldoGO5Q+08bfyz6Q5NqTi9oPQ04CywmOIiqWvV0/c++8Mvd8dqVOEbCYoIhmnEFI2mfbCm/qUsll8JS4hmuNsgHNJewSZhO4MQStNnL8KTRSlDENXkLqnJSyBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dWcd93G6MzHnGj3;
	Wed, 17 Dec 2025 23:08:45 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id D30604056A;
	Wed, 17 Dec 2025 23:09:10 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 17 Dec
 2025 15:09:10 +0000
Date: Wed, 17 Dec 2025 15:09:09 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Neeraj Kumar <s.neeraj@samsung.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <gost.dev@samsung.com>,
	<a.manzanares@samsung.com>, <vishak.g@samsung.com>, <neeraj.kernel@gmail.com>
Subject: Re: [PATCH V4 08/17] nvdimm/label: Preserve cxl region information
 from region label
Message-ID: <20251217150909.00003f98@huawei.com>
In-Reply-To: <20251119075255.2637388-9-s.neeraj@samsung.com>
References: <20251119075255.2637388-1-s.neeraj@samsung.com>
	<CGME20251119075321epcas5p19665a54028ce13d8c1af3f00c0834fc7@epcas5p1.samsung.com>
	<20251119075255.2637388-9-s.neeraj@samsung.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500010.china.huawei.com (7.191.174.240) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Wed, 19 Nov 2025 13:22:46 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

> Preserve region information from region label during nvdimm_probe. This
> preserved region information is used for creating cxl region to achieve
> region persistency across reboot.
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
Trivial comments inline.  As Dave asked, what's the plan for multiple?
Add some brief notes to the patch description on this.

Thanks,

Jonathan

> ---
>  drivers/nvdimm/dimm.c     |  4 ++++
>  drivers/nvdimm/label.c    | 40 +++++++++++++++++++++++++++++++++++++++
>  drivers/nvdimm/nd-core.h  |  2 ++
>  drivers/nvdimm/nd.h       |  1 +
>  include/linux/libnvdimm.h | 14 ++++++++++++++
>  5 files changed, 61 insertions(+)
> 
> diff --git a/drivers/nvdimm/dimm.c b/drivers/nvdimm/dimm.c
> index 07f5c5d5e537..590ec883903d 100644
> --- a/drivers/nvdimm/dimm.c
> +++ b/drivers/nvdimm/dimm.c
> @@ -107,6 +107,10 @@ static int nvdimm_probe(struct device *dev)
>  	if (rc)
>  		goto err;
>  
> +	/* Preserve cxl region info if available */
> +	if (ndd->cxl)
> +		nvdimm_cxl_region_preserve(ndd);
> +
>  	return 0;
>  
>   err:
> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index da55ecd95e2f..0f8aea61b504 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c
> @@ -490,6 +490,46 @@ int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
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
> +		union nd_lsa_label *lsa_label;
> +		struct cxl_region_label *region_label;
> +		uuid_t *region_uuid;
> +
> +		lsa_label = to_lsa_label(ndd, slot);
> +		region_label = &lsa_label->region_label;
> +		region_uuid = (uuid_t *) &region_label->type;
> +
		union nd_lsa_label *lsa_label = to_lsa_label(ndd, slot);
		struct cxl_region_label *region_label = &lsa_label->region_label;
//I'd go long on thi sone as only just over 80 and helps readability.
		uuid_t *region_uuid = (uuid_t *)&region_label->type;

Saves a fine lines and there doesn't seem to be an obvious reason
not to do so.

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
