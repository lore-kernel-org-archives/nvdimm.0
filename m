Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F76F1C84BB
	for <nvdimm@lists.linux.dev>; Wed, 17 Dec 2025 15:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765984356; cv=none; b=jazXZBc1Tz/7gIuzCgEvmaC1Ha7+U06dcpqOJmScQrjPWsdMp7GRP/TjG7BJhOKJ3YdAhp4qlk0kH7BPKX2V2LGMLJTj18kNz4rSDAq76b9L7oV4z3SLX6Iw5POiQwmmqPhgV3hdCBHaa3Ooi+zbZaV5J6Jf1Bwlf6sAemOrxJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765984356; c=relaxed/simple;
	bh=gPyrpppdKKS3nMlAn0OEw11y7fZCSZ0MzbEsS8P3IyM=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BtJKmrAwuZY4Ut6ekuOZsaYI54+BrnbEwYobSZit5WivzP+tko/XYkuTSuqqgsq0cc0yD1cvF0v0/8neb7vOMdG59NJECLUuv/mC4FHV/94d3oAUVDnT/cEDeBXFIeieHD2VXYlVwDcPCJ6A8YkbIrLsN2UM97L+dWjP0OHFHGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dWcj26h93zHnGhY;
	Wed, 17 Dec 2025 23:12:06 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 55C4E40577;
	Wed, 17 Dec 2025 23:12:32 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 17 Dec
 2025 15:12:31 +0000
Date: Wed, 17 Dec 2025 15:12:30 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Neeraj Kumar <s.neeraj@samsung.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <gost.dev@samsung.com>,
	<a.manzanares@samsung.com>, <vishak.g@samsung.com>, <neeraj.kernel@gmail.com>
Subject: Re: [PATCH V4 09/17] nvdimm/label: Export routine to fetch region
 information
Message-ID: <20251217151230.000048c3@huawei.com>
In-Reply-To: <20251119075255.2637388-10-s.neeraj@samsung.com>
References: <20251119075255.2637388-1-s.neeraj@samsung.com>
	<CGME20251119075323epcas5p369dea15a390bea0b3690e2a19533f956@epcas5p3.samsung.com>
	<20251119075255.2637388-10-s.neeraj@samsung.com>
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

On Wed, 19 Nov 2025 13:22:47 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

> CXL region information preserved from the LSA needs to be exported for
> use by the CXL driver for CXL region re-creation.
To me it feels like the !nvdimm checks may be excessive in an interface
that makes no sense if NULL is passed in.
Perhaps drop those?

> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
> ---
>  drivers/nvdimm/dimm_devs.c | 18 ++++++++++++++++++
>  include/linux/libnvdimm.h  |  2 ++
>  2 files changed, 20 insertions(+)
> 
> diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
> index 3363a97cc5b5..1474b4e45fcc 100644
> --- a/drivers/nvdimm/dimm_devs.c
> +++ b/drivers/nvdimm/dimm_devs.c
> @@ -280,6 +280,24 @@ void *nvdimm_provider_data(struct nvdimm *nvdimm)
>  }
>  EXPORT_SYMBOL_GPL(nvdimm_provider_data);
>  
> +bool nvdimm_has_cxl_region(struct nvdimm *nvdimm)
> +{
> +	if (!nvdimm)
> +		return false;

Seems a bit odd that this would ever get called on !nvdimm.
Is that protection worth adding?

> +
> +	return nvdimm->is_region_label;
> +}
> +EXPORT_SYMBOL_GPL(nvdimm_has_cxl_region);
> +
> +void *nvdimm_get_cxl_region_param(struct nvdimm *nvdimm)
> +{
> +	if (!nvdimm)

This feels a little more plausible as defense but is this
needed?

> +		return NULL;
> +
> +	return &nvdimm->cxl_region_params;
> +}
> +EXPORT_SYMBOL_GPL(nvdimm_get_cxl_region_param);
> +
>  static ssize_t commands_show(struct device *dev,
>  		struct device_attribute *attr, char *buf)
>  {
> diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
> index 07ea2e3f821a..3ffd50ab6ac4 100644
> --- a/include/linux/libnvdimm.h
> +++ b/include/linux/libnvdimm.h
> @@ -330,6 +330,8 @@ int nvdimm_in_overwrite(struct nvdimm *nvdimm);
>  bool is_nvdimm_sync(struct nd_region *nd_region);
>  int nd_region_label_update(struct nd_region *nd_region);
>  int nd_region_label_delete(struct nd_region *nd_region);
> +bool nvdimm_has_cxl_region(struct nvdimm *nvdimm);
> +void *nvdimm_get_cxl_region_param(struct nvdimm *nvdimm);
>  
>  static inline int nvdimm_ctl(struct nvdimm *nvdimm, unsigned int cmd, void *buf,
>  		unsigned int buf_len, int *cmd_rc)

