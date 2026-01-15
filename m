Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2303527BF7D
	for <nvdimm@lists.linux.dev>; Thu, 15 Jan 2026 18:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768500543; cv=none; b=nvWQCVyEiS/KnGh2WnlSWYKAQCry5GZ/TB0eZQm/V+BFY/+xY8Qy976jQoYHm79tDeBcNtw6LDWxXwEE4BqPDGxptNDgmnG+XGOg1e8sexaqLx5JNQ8+chptI77sn+adJ4qSLBFLauXyOE2mRP0wU0hsYU/nKRzI2jCZYunPvH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768500543; c=relaxed/simple;
	bh=VI/4ituoS59Y396+g+Y2K0iewMI4PGUdjMWStIlGP2U=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SCtOVHoTaIpVc8zAHO7fofbWPNSxlT8T9ZCGsxavFUVAcVpCPqft5QWbBz4KsFSvCBILj5DZX+V94I3FblFSVbp5etU+UZ1TbXVHLccU7bN+Qle/oaA2b5JN39RfFByZXXbwnmojldgRWjidsOPj6nmta4w40OEyWincetL0YGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dsWFJ48t5zHnGd2;
	Fri, 16 Jan 2026 02:08:36 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id E561940539;
	Fri, 16 Jan 2026 02:08:58 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 15 Jan
 2026 18:08:58 +0000
Date: Thu, 15 Jan 2026 18:08:57 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Neeraj Kumar <s.neeraj@samsung.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <gost.dev@samsung.com>,
	<a.manzanares@samsung.com>, <vishak.g@samsung.com>, <neeraj.kernel@gmail.com>
Subject: Re: [PATCH V5 10/17] cxl/mem: Refactor cxl pmem region
 auto-assembling
Message-ID: <20260115180857.00001476@huawei.com>
In-Reply-To: <20260109124437.4025893-11-s.neeraj@samsung.com>
References: <20260109124437.4025893-1-s.neeraj@samsung.com>
	<CGME20260109124524epcas5p11435563cce6dc392c06951bb07c8bfc3@epcas5p1.samsung.com>
	<20260109124437.4025893-11-s.neeraj@samsung.com>
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

On Fri,  9 Jan 2026 18:14:30 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

> In 84ec985944ef3, devm_cxl_add_nvdimm() sequence was changed and called
> before devm_cxl_add_endpoint(). It's because cxl pmem region auto-assembly
> used to get called at last in cxl_endpoint_port_probe(), which requires
> cxl_nvd presence.
> 
> For cxl region persistency, region creation happens during nvdimm_probe
> which need the completion of endpoint probe.
> 
> In order to accommodate both cxl pmem region auto-assembly and cxl region
> persistency, refactored following
> 
> 1. Re-Sequence devm_cxl_add_nvdimm() after devm_cxl_add_endpoint(). This
>    will be called only after successful completion of endpoint probe.
> 
> 2. Create cxl_region_discovery() which performs pmem region
>    auto-assembly and remove cxl pmem region auto-assembly from
>    cxl_endpoint_port_probe()
> 
> 3. Register cxl_region_discovery() with devm_cxl_add_memdev() which gets
>    called during cxl_pci_probe() in context of cxl_mem_probe()
> 
> 4. As cxlmd->ops->probe() calls registered cxl_region_discovery(), so
>    move devm_cxl_add_nvdimm() before cxlmd->ops->probe(). It guarantees
>    both the completion of endpoint probe and cxl_nvd presence before
>    calling cxlmd->ops->probe().
> 
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>

One thing below. With that fixes,
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>


> diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> index e21051d79b25..d56fdfe4b43b 100644
> --- a/drivers/cxl/pci.c
> +++ b/drivers/cxl/pci.c
> @@ -907,6 +907,7 @@ static int cxl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	struct cxl_memdev_state *mds;
>  	struct cxl_dev_state *cxlds;
>  	struct cxl_register_map map;
> +	struct cxl_memdev_ops ops;

Needs init, as there might be other stuff in there.
	struct cxl_memdev_ops ops = {};

>  	struct cxl_memdev *cxlmd;
>  	int rc, pmu_count;
>  	unsigned int i;
> @@ -1006,7 +1007,8 @@ static int cxl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	if (rc)
>  		dev_dbg(&pdev->dev, "No CXL Features discovered\n");
>  
> -	cxlmd = devm_cxl_add_memdev(&pdev->dev, cxlds, NULL);
> +	ops.probe = cxl_region_discovery;
> +	cxlmd = devm_cxl_add_memdev(&pdev->dev, cxlds, &ops);
>  	if (IS_ERR(cxlmd))
>  		return PTR_ERR(cxlmd);
>  


