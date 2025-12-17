Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B19347BC1
	for <nvdimm@lists.linux.dev>; Wed, 17 Dec 2025 15:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765985933; cv=none; b=CvluCbKalTO7o3Zgd4iSicN1MbZ0jbUQzXx5WhT6GKUq7PcDLGIr/m2j3JY/shRZAHx/scq8uR1m6VFujDR7Bh2eU7pX1xB2nZAZsbkurhXhyJbnDv1MdHQm525ne8Yy8GU3Xc5a1BYK9Z2ZEI5WHjTPAQLlPIKEIvIHPmLaUIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765985933; c=relaxed/simple;
	bh=Yzf1k0g34SbKTHZ/F93GLeG6K7bipob3YAai0LnTeAg=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lMLaEI1+7SueHVUF6/LeVdUsdcHzAC6FpnAZnoB3rFaG/SpaOuYFzkbSaozH6Py//AdcBsL/olgVuQ/5ZYBl1V5dDo/D8INUu2XudslTpnfDPMxvb0ojFbkM07fWDp8tBnM//IcprKTPb7joHNbCQfqiyCRlymZPtAZo+y6Xuh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dWdHN2NGNzHnGfD;
	Wed, 17 Dec 2025 23:38:24 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id BD5AD40565;
	Wed, 17 Dec 2025 23:38:49 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 17 Dec
 2025 15:38:49 +0000
Date: Wed, 17 Dec 2025 15:38:47 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Neeraj Kumar <s.neeraj@samsung.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <gost.dev@samsung.com>,
	<a.manzanares@samsung.com>, <vishak.g@samsung.com>, <neeraj.kernel@gmail.com>
Subject: Re: [PATCH V4 14/17] cxl/pmem_region: Introduce
 CONFIG_CXL_PMEM_REGION for core/pmem_region.c
Message-ID: <20251217153847.00001e63@huawei.com>
In-Reply-To: <20251119075255.2637388-15-s.neeraj@samsung.com>
References: <20251119075255.2637388-1-s.neeraj@samsung.com>
	<CGME20251119075335epcas5p3a8fdc68301233f899d9041a300309fa2@epcas5p3.samsung.com>
	<20251119075255.2637388-15-s.neeraj@samsung.com>
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

On Wed, 19 Nov 2025 13:22:52 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

> As pmem region label update/delete has hard dependency on libnvdimm.
> It is therefore put core/pmem_region.c under CONFIG_CXL_PMEM_REGION
> control. It handles the dependency by selecting CONFIG_LIBNVDIMM
> if not enabled.
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>


> diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
> index 5ebbc3d3dde5..beeb9b7527b8 100644
> --- a/drivers/cxl/core/core.h
> +++ b/drivers/cxl/core/core.h
> @@ -34,7 +34,6 @@ int cxl_decoder_detach(struct cxl_region *cxlr,
>  #define CXL_REGION_ATTR(x) (&dev_attr_##x.attr)
>  #define CXL_REGION_TYPE(x) (&cxl_region_type)
>  #define SET_CXL_REGION_ATTR(x) (&dev_attr_##x.attr),
> -#define CXL_PMEM_REGION_TYPE(x) (&cxl_pmem_region_type)
>  #define CXL_DAX_REGION_TYPE(x) (&cxl_dax_region_type)
>  int cxl_region_init(void);
>  void cxl_region_exit(void);
> @@ -89,17 +88,23 @@ static inline struct cxl_region *to_cxl_region(struct device *dev)
>  {
>  	return NULL;
>  }
> -static inline int devm_cxl_add_pmem_region(struct cxl_region *cxlr)
> -{
> -	return 0;
> -}
>  #define CXL_REGION_ATTR(x) NULL
>  #define CXL_REGION_TYPE(x) NULL
>  #define SET_CXL_REGION_ATTR(x)
> -#define CXL_PMEM_REGION_TYPE(x) NULL
>  #define CXL_DAX_REGION_TYPE(x) NULL
>  #endif
>  
> +#ifdef CONFIG_CXL_PMEM_REGION
> +#define CXL_PMEM_REGION_TYPE(x) (&cxl_pmem_region_type)
> +int devm_cxl_add_pmem_region(struct cxl_region *cxlr);
> +#else
> +#define CXL_PMEM_REGION_TYPE(x) NULL
> +static inline int devm_cxl_add_pmem_region(struct cxl_region *cxlr)
> +{
> +	return 0;
> +}
> +#endif
> +
>  struct cxl_send_command;
>  struct cxl_mem_query_commands;
>  int cxl_query_cmd(struct cxl_mailbox *cxl_mbox,
> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index 9798120b208e..408e139718f1 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -3918,6 +3918,8 @@ static int cxl_region_probe(struct device *dev)
>  			dev_dbg(&cxlr->dev, "CXL EDAC registration for region_id=%d failed\n",
>  				cxlr->id);
>  
> +		if (!IS_ENABLED(CONFIG_CXL_PMEM_REGION))
> +			return -EINVAL;
>  		return devm_cxl_add_pmem_region(cxlr);

Why not have the stub return -EINVAL if it never makes sense to call without
the CONFIG being enabled?

>  	case CXL_PARTMODE_RAM:
>  		rc = devm_cxl_region_edac_register(cxlr);


