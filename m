Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6121E22D4F1
	for <nvdimm@lists.linux.dev>; Mon, 23 Jun 2025 09:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750672102; cv=none; b=tG3pys7Wt5ujxS2j7//SUjH+KNtRo4a9ldBz5l06cYZLxHFvVr0N90ytM4Wpv0wH3LrFx3i4lmI1dMRLG8J180ekToqaULXyDC9A01feUlYv2xGKvO7UfK1XTZB5hVVkFrtPxo9sZQ1K1V6t3KZ5q03K1yDQQYAzfJLtZqUm7nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750672102; c=relaxed/simple;
	bh=CxIboCksDcTzApmteruO0n3a8XWrSEfoEtGyzoxxwew=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fz3I1tnvC7DOLTBmD3hcdfW8r5Y9m+4Fgsr++czWs0I0hnRG3r9CiPQN8u1FhzhZue64S5Gkt+wk1aVxrPobyM7NdcdEEsqa+zB+JZzL9ssyUmOfm8PvC2EZGt+nD0CA3X2YosNtmlNkHcq33lXyWX6RoSX0OJOo+BEPnoX2egY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4bQjnQ5p01z6L5jB;
	Mon, 23 Jun 2025 17:43:22 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 877431402EA;
	Mon, 23 Jun 2025 17:48:18 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Mon, 23 Jun
 2025 11:48:17 +0200
Date: Mon, 23 Jun 2025 10:48:16 +0100
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
Subject: Re: [RFC PATCH 18/20] cxl/pmem: Add support of cxl lsa 2.1 support
 in cxl pmem
Message-ID: <20250623104816.00005075@huawei.com>
In-Reply-To: <592959754.121750165383213.JavaMail.epsvc@epcpadp2new>
References: <20250617123944.78345-1-s.neeraj@samsung.com>
	<CGME20250617124058epcas5p2324bd3b1bf95d47f553d90fdc727e50d@epcas5p2.samsung.com>
	<592959754.121750165383213.JavaMail.epsvc@epcpadp2new>
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

On Tue, 17 Jun 2025 18:09:42 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

> Add support of cxl lsa 2.1 using NDD_CXL_LABEL flag. It also creates cxl
> region based on region information parsed from LSA.
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
> ---
>  drivers/cxl/pmem.c | 59 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 59 insertions(+)
> 
> diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
> index ffcebb8d382f..2733d79b32d5 100644
> --- a/drivers/cxl/pmem.c
> +++ b/drivers/cxl/pmem.c
> @@ -58,6 +58,63 @@ static const struct attribute_group *cxl_dimm_attribute_groups[] = {
>  	NULL
>  };
>  
> +static int match_ep_decoder(struct device *dev, void *data)
> +{
> +	struct cxl_decoder *cxld = to_cxl_decoder(dev);
> +
> +	if (!cxld->region)
> +		return 1;
> +	else
> +		return 0;
> +}
> +
> +static struct cxl_decoder *cxl_find_free_decoder(struct cxl_port *port)
> +{
> +	struct device *dev;
> +
> +	dev = device_find_child(&port->dev, NULL, match_ep_decoder);
> +	if (!dev)
> +		return NULL;
> +
> +	return to_cxl_decoder(dev);
> +}
> +
> +static int create_pmem_region(struct nvdimm *nvdimm)
> +{
> +	struct cxl_nvdimm *cxl_nvd;
> +	struct cxl_memdev *cxlmd;
> +	struct cxl_nvdimm_bridge *cxl_nvb;
> +	struct cxl_pmem_region_params *params;
> +	struct cxl_root_decoder *cxlrd;
> +	struct cxl_decoder *cxld;
> +	struct cxl_region *cxlr;
> +
> +	if (!nvdimm)
> +		return -ENOTTY;

As with other checks like this, it is useful to add a comment on when you can
call this function with a null parameter.

> +
> +	if (!nvdimm_has_cxl_region(nvdimm))
> +		return 0;
> +
> +	cxl_nvd = nvdimm_provider_data(nvdimm);
> +	params = nvdimm_get_cxl_region_param(nvdimm);
> +	cxlmd = cxl_nvd->cxlmd;
> +	cxl_nvb = cxlmd->cxl_nvb;
> +	cxlrd = cxlmd->cxlrd;
> +
> +	/* FIXME: Limitation: Region creation only when interleave way == 1 */
> +	if (params->nlabel == 1) {
> +		cxld = cxl_find_free_decoder(cxlmd->endpoint);
> +		cxlr = cxl_create_pmem_region(cxlrd, cxld, params,
> +				atomic_read(&cxlrd->region_id));
> +		if (IS_ERR(cxlr))
> +			dev_dbg(&cxlmd->dev, "Region Creation failed\n");
> +	} else {
> +		dev_dbg(&cxlmd->dev, "Region Creation is not supported with iw > 1\n");
> +	}

Flip logic to check for unhandled case first and also return an error if this happens
rather than silently carrying on. dev_info() is appropriate here.

> +
> +	return 0;
> +}
> +
>  static int cxl_nvdimm_probe(struct device *dev)
>  {
>  	struct cxl_nvdimm *cxl_nvd = to_cxl_nvdimm(dev);
> @@ -74,6 +131,7 @@ static int cxl_nvdimm_probe(struct device *dev)
>  		return rc;
>  
>  	set_bit(NDD_LABELING, &flags);
> +	set_bit(NDD_CXL_LABEL, &flags);
>  	set_bit(NDD_REGISTER_SYNC, &flags);
>  	set_bit(ND_CMD_GET_CONFIG_SIZE, &cmd_mask);
>  	set_bit(ND_CMD_GET_CONFIG_DATA, &cmd_mask);
> @@ -86,6 +144,7 @@ static int cxl_nvdimm_probe(struct device *dev)
>  		return -ENOMEM;
>  
>  	dev_set_drvdata(dev, nvdimm);
> +	create_pmem_region(nvdimm);
>  	return devm_add_action_or_reset(dev, unregister_nvdimm, nvdimm);
>  }
>  

