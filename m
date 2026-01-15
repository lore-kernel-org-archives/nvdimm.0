Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C13003C008A
	for <nvdimm@lists.linux.dev>; Thu, 15 Jan 2026 18:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768501047; cv=none; b=KknhgvEbF/t3wPSelWT9/Dn90OS/fs4lKXZrMUp1D4mIcEVlwgqBONVSOSiLWhQzAYEtKEI4RgDFxs03CHbofUWWIEloFhCakSkp4utOyqEIAEjbdR8pibkegHk30uVIbs2yH+qSRd/zbtpcvnm4B3K+tFo/Zg1PDtdr91ml2q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768501047; c=relaxed/simple;
	bh=0jJC0sEI0DaHYHVk1Kd3k16xZ4L/xBFr3o8zfIiiGgQ=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EniE80bRFT+DIKQYEqJevf8Pkuo6opZzOmpTEt/D3wJsM+OdNj1dqHQKo85RnzF9IInHm4SZ+af8YKPUOfaOGERVKF28AwwdnsqYNwyhzdOeFii7g453tja2uuYFB2POPakhWRC/daNfhyvoOEqUtLAIpCdoKsDRlj7bd6ewuX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dsWR12YsxzHnGdW;
	Fri, 16 Jan 2026 02:17:01 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id B06B540569;
	Fri, 16 Jan 2026 02:17:23 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 15 Jan
 2026 18:17:23 +0000
Date: Thu, 15 Jan 2026 18:17:21 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Neeraj Kumar <s.neeraj@samsung.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <gost.dev@samsung.com>,
	<a.manzanares@samsung.com>, <vishak.g@samsung.com>, <neeraj.kernel@gmail.com>
Subject: Re: [PATCH V5 11/17] cxl/region: Add devm_cxl_pmem_add_region() for
 pmem region creation
Message-ID: <20260115181721.00002668@huawei.com>
In-Reply-To: <20260109124437.4025893-12-s.neeraj@samsung.com>
References: <20260109124437.4025893-1-s.neeraj@samsung.com>
	<CGME20260109124525epcas5p103e2d6f32643e6cb07b7037155ef16e9@epcas5p1.samsung.com>
	<20260109124437.4025893-12-s.neeraj@samsung.com>
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
 dubpeml100005.china.huawei.com (7.214.146.113)

On Fri,  9 Jan 2026 18:14:31 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

> devm_cxl_pmem_add_region() is used to create cxl region based on region
> information scanned from LSA.
> 
> devm_cxl_add_region() is used to just allocate cxlr and its fields are
> filled later by userspace tool using device attributes (*_store()).
> 
> Inspiration for devm_cxl_pmem_add_region() is taken from these device
> attributes (_store*) calls. It allocates cxlr and fills information
> parsed from LSA and calls device_add(&cxlr->dev) to initiate further
> region creation porbes
> 
> Rename __create_region() to cxl_create_region(), which will be used
> in later patch to create cxl region after fetching region information
> from LSA.
You also add a couple of parameters. At very least say why here.

> 
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>

A few things inline.  

> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index 26238fb5e8cf..13779aeacd8e 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c


> +static ssize_t alloc_region_dpa(struct cxl_endpoint_decoder *cxled, u64 size)
> +{
> +	int rc;
> +
> +	if (!size)
> +		return -EINVAL;
> +
> +	if (!IS_ALIGNED(size, SZ_256M))
> +		return -EINVAL;
> +
> +	rc = cxl_dpa_free(cxled);

Add a comment on why this make sense.  What already allocated dpa that we need
to clean up?

> +	if (rc)
> +		return rc;
> +
> +	return cxl_dpa_alloc(cxled, size);
> +}


> -static struct cxl_region *__create_region(struct cxl_root_decoder *cxlrd,
> -					  enum cxl_partition_mode mode, int id)
> +struct cxl_region *cxl_create_region(struct cxl_root_decoder *cxlrd,
> +				     enum cxl_partition_mode mode, int id,
> +				     struct cxl_pmem_region_params *pmem_params,
> +				     struct cxl_endpoint_decoder *cxled)

I'm a little dubious that the extra parameters are buried in this patch rather than
where we first need them or a separate patch that makes it clear what they are for.

>  {

