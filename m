Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4135F1F4730
	for <nvdimm@lists.linux.dev>; Wed, 30 Oct 2024 14:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730298760; cv=none; b=nfDCYKHB2DhnNW7+XR8zHasz/0gPqzuES8HizMTMkg/uA8NDIAfG2+Xe5Ak182ka8cShaNMU5q5E1H+JhWXGdhq25gdnPsnb3glkxemwAUgEMzj0/ItHP16mykuUVj4Yg2htwyQeWng+EfCh5Ju3poOxMAO+BUYAPfOYzRNe1zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730298760; c=relaxed/simple;
	bh=v3iv01fkiGERUMvGlov6KCBtyaQUwrAGSlj+FhqRSrQ=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l+58vWepbuszHu1xD25pNS/UkvfTxb9f2YEqqMd1Sa5oH0+9dv6E76ciuvSFEUbOG9GyVhr3zuoiwNFC4FU4b/fF5RNNdmJRmwowkLDO6DlV/gyDve5gqYNBXcFAAUg+wd7gMFYSV0xPauNT1IVZBXdX2div6JWSyctGBU+MxUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XdqLX3xMcz6HJcw;
	Wed, 30 Oct 2024 22:31:16 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id CC49B1401F3;
	Wed, 30 Oct 2024 22:32:34 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 30 Oct
 2024 15:32:34 +0100
Date: Wed, 30 Oct 2024 14:32:32 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: <ira.weiny@intel.com>
CC: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, "Navneet
 Singh" <navneet.singh@intel.com>, Jonathan Corbet <corbet@lwn.net>, "Andrew
 Morton" <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>, "Alison Schofield"
	<alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>,
	<linux-cxl@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 20/27] cxl/extent: Process DCD events and realize
 region extents
Message-ID: <20241030143232.000013b8@Huawei.com>
In-Reply-To: <20241029-dcd-type2-upstream-v5-20-8739cb67c374@intel.com>
References: <20241029-dcd-type2-upstream-v5-0-8739cb67c374@intel.com>
	<20241029-dcd-type2-upstream-v5-20-8739cb67c374@intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100006.china.huawei.com (7.191.160.224) To
 frapeml500008.china.huawei.com (7.182.85.71)

A few minor things inline from a fresh read.

Other than maybe a missing header, the others are all trivial
and you can make your own minds up.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huwei.com>

>  #endif /* __CXL_CORE_H__ */
> diff --git a/drivers/cxl/core/extent.c b/drivers/cxl/core/extent.c
> new file mode 100644
> index 0000000000000000000000000000000000000000..315aa46252c15dcefe175da87522505f8ecf537c
> --- /dev/null
> +++ b/drivers/cxl/core/extent.c
> @@ -0,0 +1,372 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*  Copyright(c) 2024 Intel Corporation. All rights reserved. */
> +
> +#include <linux/device.h>
> +#include <cxl.h>


> +static bool extents_contain(struct cxl_dax_region *cxlr_dax,
> +			    struct cxl_endpoint_decoder *cxled,
> +			    struct range *new_range)
> +{
> +	struct match_data md = {
> +		.cxled = cxled,
> +		.new_range = new_range,
> +	};
> +
> +	struct device *extent_device __free(put_device)
> +			= device_find_child(&cxlr_dax->dev, &md, match_contains);
> +	if (!extent_device)
> +		return false;
> +
> +	return true;
trivial but could do.

	return extent_device != NULL;

> +}

> +static bool extents_overlap(struct cxl_dax_region *cxlr_dax,
> +			    struct cxl_endpoint_decoder *cxled,
> +			    struct range *new_range)
> +{
> +	struct match_data md = {
> +		.cxled = cxled,
> +		.new_range = new_range,
> +	};
> +
> +	struct device *extent_device __free(put_device)
> +			= device_find_child(&cxlr_dax->dev, &md, match_overlaps);
> +	if (!extent_device)
> +		return false;
> +
> +	return true;
As above.

> +}

> +static int cxlr_rm_extent(struct device *dev, void *data)
> +{
> +	struct region_extent *region_extent = to_region_extent(dev);
> +	struct range *region_hpa_range = data;
> +
> +	if (!region_extent)
> +		return 0;
> +
> +	/*
> +	 * Any extent which 'touches' the released range is removed.

Maybe single line comment syntax is fine here.

> +	 */
> +	if (range_overlaps(region_hpa_range, &region_extent->hpa_range)) {
> +		dev_dbg(dev, "Remove region extent HPA [range 0x%016llx-0x%016llx]\n",
> +			region_extent->hpa_range.start, region_extent->hpa_range.end);
> +		region_rm_extent(region_extent);
> +	}
> +	return 0;
> +}


> +/* Callers are expected to ensure cxled has been attached to a region */
> +int cxl_add_extent(struct cxl_memdev_state *mds, struct cxl_extent *extent)
> +{
> +	u64 start_dpa = le64_to_cpu(extent->start_dpa);
> +	struct cxl_memdev *cxlmd = mds->cxlds.cxlmd;
> +	struct cxl_endpoint_decoder *cxled;
> +	struct range ed_range, ext_range;
> +	struct cxl_dax_region *cxlr_dax;
> +	struct cxled_extent *ed_extent;
> +	struct cxl_region *cxlr;
> +	struct device *dev;
> +
> +	ext_range = (struct range) {
> +		.start = start_dpa,
> +		.end = start_dpa + le64_to_cpu(extent->length) - 1,
> +	};
> +
>


> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index 16e06b59d7f04762ca73a81740b0d6b2487301af..85b30a74a6fa5de1dd99c08c8318edd204e3e19d 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h

Is the xarray header included in here already?
If not it should be.

> @@ -506,6 +506,7 @@ static inline struct cxl_dev_state *mbox_to_cxlds(struct cxl_mailbox *cxl_mbox)
>   * @pmem_perf: performance data entry matched to PMEM partition
>   * @nr_dc_region: number of DC regions implemented in the memory device
>   * @dc_region: array containing info about the DC regions
