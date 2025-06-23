Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5E51531E3
	for <nvdimm@lists.linux.dev>; Mon, 23 Jun 2025 09:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750672425; cv=none; b=RFLE/3jlDOd2tjtd1pZL5BMxHb09lKGsKs0qYEqtTgXFKbV3fTZQUb1uUTyfiqfDfdGFSqjstwjOeJ6d80gDWMwTA1obSmYQojZFly8okEhZKHbGXImy1BdE0s8m6/ZI46GyoeANCg98VNCgNgt0Da0JA1YTsRhKSpvXh8LOwWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750672425; c=relaxed/simple;
	bh=yZ4aShi2PgqttO51YDngWhE0TfGZrUMxSGZEgqbAZ4E=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BoR/vNF3rqEu6D40cMXj3NwQx7sVigLAKSJcQNwkkd6xOI/ExVhhQXe2b3kZTgdXQO0fPi0xR5C5JY8PqmPIKfXftqBls5Cri1XFSKrshOmtIsNjzZAaKFmaLU/Hw24/iFOkl9Iwrt/zZ7/0hOo3VDuX+LHqAezBV01MJleKbIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4bQk0T46T3z6M4vR;
	Mon, 23 Jun 2025 17:52:57 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 160F21402EF;
	Mon, 23 Jun 2025 17:53:40 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Mon, 23 Jun
 2025 11:53:39 +0200
Date: Mon, 23 Jun 2025 10:53:37 +0100
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
Subject: Re: [RFC PATCH 19/20] cxl/pmem_region: Prep patch to accommodate
 pmem_region attributes
Message-ID: <20250623105337.000028c6@huawei.com>
In-Reply-To: <1997287019.101750165383025.JavaMail.epsvc@epcpadp2new>
References: <20250617123944.78345-1-s.neeraj@samsung.com>
	<CGME20250617124101epcas5p4d54f34ebc5161b7cb816e352d144d9a1@epcas5p4.samsung.com>
	<1997287019.101750165383025.JavaMail.epsvc@epcpadp2new>
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

On Tue, 17 Jun 2025 18:09:43 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

> Created a separate file core/pmem_region.c along with CONFIG_PMEM_REGION
> Moved pmem_region related code from core/region.c to core/pmem_region.c
> For region label update, need to create device attribute, which calls
> nvdimm exported function thus making pmem_region dependent on libnvdimm.
> Because of this dependency of pmem region on libnvdimm, segregated pmem

segregate

> region related code from core/region.c
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
> ---
>  drivers/cxl/Kconfig            |  12 ++
>  drivers/cxl/core/Makefile      |   1 +
>  drivers/cxl/core/core.h        |   8 +-
>  drivers/cxl/core/pmem_region.c | 222 +++++++++++++++++++++++++++++++++
>  drivers/cxl/core/port.c        |   2 +-
>  drivers/cxl/core/region.c      | 217 ++------------------------------
>  drivers/cxl/cxl.h              |  42 +++++--
>  tools/testing/cxl/Kbuild       |   1 +
>  8 files changed, 283 insertions(+), 222 deletions(-)
>  create mode 100644 drivers/cxl/core/pmem_region.c
> 
> diff --git a/drivers/cxl/Kconfig b/drivers/cxl/Kconfig
> index 876469e23f7a..f0cbb096bfe7 100644
> --- a/drivers/cxl/Kconfig
> +++ b/drivers/cxl/Kconfig
> @@ -128,6 +128,18 @@ config CXL_REGION
>  
>  	  If unsure say 'y'
>  
> +config CXL_PMEM_REGION
> +	bool "CXL: Pmem Region Support"
> +	default CXL_BUS
> +	depends on CXL_REGION
> +	select LIBNVDIMM if CXL_BUS = y

This is in the block covered by if CXL_BUS so I think you can simplify this check.

> +	help
> +	  Enable the CXL core to enumerate and provision CXL pmem regions.
> +	  A CXL pmem region need to update region label into LSA. For LSA
> +	  updation/deletion libnvdimm is required.
> +
> +	  If unsure say 'y'
> +
>  config CXL_REGION_INVALIDATION_TEST
>  	bool "CXL: Region Cache Management Bypass (TEST)"
>  	depends on CXL_REGION

> diff --git a/drivers/cxl/core/pmem_region.c b/drivers/cxl/core/pmem_region.c
> new file mode 100644
> index 000000000000..a29526c27d40
> --- /dev/null
> +++ b/drivers/cxl/core/pmem_region.c
> @@ -0,0 +1,222 @@

> @@ -3273,92 +3155,6 @@ static struct cxl_dax_region *cxl_dax_region_alloc(struct cxl_region *cxlr)
>  	return cxlr_dax;
>  }

>  static void cxlr_dax_unregister(void *_cxlr_dax)
>  {
>  	struct cxl_dax_region *cxlr_dax = _cxlr_dax;
> @@ -3646,7 +3442,10 @@ static int cxl_region_probe(struct device *dev)
>  
>  	switch (cxlr->mode) {
>  	case CXL_DECODER_PMEM:
> -		return devm_cxl_add_pmem_region(cxlr);
> +		if (IS_ENABLED(CONFIG_CXL_PMEM_REGION))
> +			return devm_cxl_add_pmem_region(cxlr);
> +		else
> +			return -EINVAL;
		if (!IS_ENABLED(CONFIG_CXL_PMEM_REGION))
			return -EINVAL;

		return devm_cxl_add_pmem_region()

Where ever possible keep the error conditions as the out of line ones.
That generally improves code readability and is common practice in the kernel.

>  	case CXL_DECODER_RAM:
>  		/*
>  		 * The region can not be manged by CXL if any portion of


