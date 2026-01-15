Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863FC3C0085
	for <nvdimm@lists.linux.dev>; Thu, 15 Jan 2026 18:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768501718; cv=none; b=Y9gy225JzAT+K6MfuAyWFaWkwBw5BoNHkTiXSXsdBIC2a6sN2fV5B8qhrgNLXTMRHd4L9/0tsCOgXS6YV8iyawinTNhy2ISIMEHX4jvSwpfgke9RHnyeMp0KLw/IynNyPMgLjEqOk+01+iFi5mfkRBeC+L/sCwGoyW5dVhTkSRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768501718; c=relaxed/simple;
	bh=lUkOZbqcwN76OE8s7EGnijanDpZ7sf5IJGDsr2Zkq20=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YsLQ/NxVq1aGkRqSVXzYbK4V8p/mWMWZPcPqH7x/j8RGp4jo0VajK7+8zsp0ALHsfpD0RZomDF5ug4mEn8kz9K+AmB3n6n1+Gr88pY5f6H+7BaOhkn/+SW8kJRmMbwhQv/TwPrLv4VJa21Pze1US0gwNwRIS4imn2k0ttW172cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dsWgv085yzHnGdQ;
	Fri, 16 Jan 2026 02:28:11 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 615F840584;
	Fri, 16 Jan 2026 02:28:33 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 15 Jan
 2026 18:28:32 +0000
Date: Thu, 15 Jan 2026 18:28:31 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Neeraj Kumar <s.neeraj@samsung.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <gost.dev@samsung.com>,
	<a.manzanares@samsung.com>, <vishak.g@samsung.com>, <neeraj.kernel@gmail.com>
Subject: Re: [PATCH V5 16/17] cxl/pmem_region: Create pmem region using
 information parsed from LSA
Message-ID: <20260115182831.0000722b@huawei.com>
In-Reply-To: <20260109124437.4025893-17-s.neeraj@samsung.com>
References: <20260109124437.4025893-1-s.neeraj@samsung.com>
	<CGME20260109124532epcas5p403ad41a20c916855bf3fea644ee6e5ec@epcas5p4.samsung.com>
	<20260109124437.4025893-17-s.neeraj@samsung.com>
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

On Fri,  9 Jan 2026 18:14:36 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

> create_pmem_region() creates CXL region based on region information
> parsed from the Label Storage Area (LSA). This routine requires cxl
> endpoint decoder and root decoder. Add cxl_find_root_decoder_by_port()
> and cxl_find_free_ep_decoder() to find the root decoder and a free
> endpoint decoder respectively.
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
Hi Neeraj,

Just a few minor things.

Jonathan

> diff --git a/drivers/cxl/core/pmem_region.c b/drivers/cxl/core/pmem_region.c
> index 53d3d81e9676..4a8cf8322cf0 100644
> --- a/drivers/cxl/core/pmem_region.c
> +++ b/drivers/cxl/core/pmem_region.c
> @@ -287,3 +287,139 @@ int devm_cxl_add_pmem_region(struct cxl_region *cxlr)
>  	cxlr->cxl_nvb = NULL;
>  	return rc;
>  }
> +
> +static int match_root_decoder_by_dport(struct device *dev, const void *data)
> +{
> +	const struct cxl_port *ep_port = data;
> +	struct cxl_root_decoder *cxlrd;
> +	struct cxl_port *root_port;
> +	struct cxl_decoder *cxld;
> +	struct cxl_dport *dport;
> +	bool dport_matched = false;
> +
> +	if (!is_root_decoder(dev))
> +		return 0;
> +
> +	cxld = to_cxl_decoder(dev);
> +	if (!(cxld->flags & CXL_DECODER_F_PMEM))
> +		return 0;
> +
> +	cxlrd = to_cxl_root_decoder(dev);
> +
> +	root_port = cxlrd_to_port(cxlrd);
> +	dport = cxl_find_dport_by_dev(root_port, ep_port->host_bridge);
> +	if (!dport)
> +		return 0;
> +
There is a fairly standard way to check if a loop matched without
needing a boolean. Just check if the exit condition was reached.

drop declaration of i out of here.
> +	for (int i = 0; i < cxlrd->cxlsd.nr_targets; i++) {
> +		if (dport == cxlrd->cxlsd.target[i]) {
> +			dport_matched = true;
No need for this.
> +			break;
> +		}
> +	}
> +
> +	if (!dport_matched)
	if (i == cxlrd->cxlsd.nr_targets)
		return 0;

> +		return 0;
> +
> +	return is_root_decoder(dev);
> +}
> +
> +/**
> + * cxl_find_root_decoder_by_port() - find a cxl root decoder on cxl bus
> + * @port: any descendant port in CXL port topology
> + * @cxled: endpoint decoder
> + *
> + * Caller of this function must call put_device() when done as a device ref
> + * is taken via device_find_child()
> + */
> +static struct cxl_root_decoder *
> +cxl_find_root_decoder_by_port(struct cxl_port *port,
> +			      struct cxl_endpoint_decoder *cxled)
> +{
> +	struct cxl_root *cxl_root __free(put_cxl_root) = find_cxl_root(port);
> +	struct cxl_port *ep_port = cxled_to_port(cxled);
> +	struct device *dev;
> +
> +	if (!cxl_root)
> +		return NULL;
> +
> +	dev = device_find_child(&cxl_root->port.dev, ep_port,
> +				match_root_decoder_by_dport);
> +	if (!dev)
> +		return NULL;
> +
> +	return to_cxl_root_decoder(dev);
> +}

> +void create_pmem_region(struct nvdimm *nvdimm)
> +{
> +	struct cxl_region *cxlr;
> +	struct cxl_memdev *cxlmd;
> +	struct cxl_nvdimm *cxl_nvd;
> +	struct cxl_endpoint_decoder *cxled;
> +	struct cxl_pmem_region_params *params;

CXL tends to be reverse xmas tree and good to stick to local style.

> +
> +	if (!nvdimm_has_cxl_region(nvdimm))
> +		return;
> +
> +	lockdep_assert_held(&cxl_rwsem.region);
> +	cxl_nvd = nvdimm_provider_data(nvdimm);
> +	params = nvdimm_get_cxl_region_param(nvdimm);
> +	cxlmd = cxl_nvd->cxlmd;
> +
> +	/* TODO: Region creation support only for interleave way == 1 */
> +	if (!(params->nlabel == 1)) {
> +		dev_dbg(&cxlmd->dev,
> +				"Region Creation is not supported with iw > 1\n");
> +		return;
> +	}
> +
> +	struct cxl_decoder *cxld __free(put_cxl_decoder) =
> +		cxl_find_free_ep_decoder(cxlmd->endpoint);
> +	if (!cxld) {
> +		dev_err(&cxlmd->dev, "CXL endpoint decoder not found\n");
> +		return;
> +	}
> +
> +	cxled = to_cxl_endpoint_decoder(&cxld->dev);
> +
> +	struct cxl_root_decoder *cxlrd __free(put_cxl_root_decoder) =
> +		cxl_find_root_decoder_by_port(cxlmd->endpoint, cxled);
> +	if (!cxlrd) {
> +		dev_err(&cxlmd->dev, "CXL root decoder not found\n");
> +		return;
> +	}
> +
> +	cxlr = cxl_create_region(cxlrd, CXL_PARTMODE_PMEM,
> +				 atomic_read(&cxlrd->region_id),
> +				 params, cxled);
> +	if (IS_ERR(cxlr))
> +		dev_warn(&cxlmd->dev, "Region Creation failed\n");
> +}
> +EXPORT_SYMBOL_NS_GPL(create_pmem_region, "CXL");


