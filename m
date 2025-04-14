Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5735253950
	for <nvdimm@lists.linux.dev>; Mon, 14 Apr 2025 15:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744644765; cv=none; b=UJZlIjKDs4oAgg3SVzqg/DRtl6F1MUCnGXgTHh1mplvj2GpKWYMks2dVYETzjvqXuoes7BifQe9W8kfQsp9c0FuOMn6T5TKgF3GxhNEA/vyxaRICNmQqWqjiWg0EUabS6mzZfRvysqKMT/u/jejrxa3Mmho8+Jxq2rgAG9jf9p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744644765; c=relaxed/simple;
	bh=s7wgHwe8b+luo8ilUsW0R0Y8heg0xYnm90OWA4prcdM=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J6LuPA3+K7Zf2RkJjLEPRp/FP+ZZdgp1obJ5d4/Eq+eIeT2l4iXB1pRowHjPmRV1C4Em6TJWwwm9EtZKw7C3V2fO/EtV0PsjMq+2gVs2hkk7h/GntEeDBhtnKjDt1VYZLmI7N0DidRA6eBkTmQfte9zOAhx5YGamMIRMSq2PxRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Zbrlz2yVsz6K9fq;
	Mon, 14 Apr 2025 23:28:31 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 43E841402F0;
	Mon, 14 Apr 2025 23:32:40 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Mon, 14 Apr
 2025 17:32:39 +0200
Date: Mon, 14 Apr 2025 16:32:38 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Ira Weiny <ira.weiny@intel.com>
CC: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, "Dan
 Williams" <dan.j.williams@intel.com>, Davidlohr Bueso <dave@stgolabs.net>,
	Alison Schofield <alison.schofield@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 04/19] cxl/core: Enforce partition order/simplify
 partition calls
Message-ID: <20250414163238.00000fa4@huawei.com>
In-Reply-To: <20250413-dcd-type2-upstream-v9-4-1d4911a0b365@intel.com>
References: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
	<20250413-dcd-type2-upstream-v9-4-1d4911a0b365@intel.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500004.china.huawei.com (7.191.163.9) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Sun, 13 Apr 2025 17:52:12 -0500
Ira Weiny <ira.weiny@intel.com> wrote:

> Device partitions have an implied order which is made more complex by
> the addition of a dynamic partition.
> 
> Remove the ram special case information calls in favor of generic calls
> with a check ahead of time to ensure the preservation of the implied
> partition order.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
One trivial thing inline.

To me this patch stands on it's own irrespective of the rest of the
series. Maybe one to queue up early as a cleanup?

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

Jonathan

> ---
>  drivers/cxl/core/hdm.c    | 11 ++++++++++-
>  drivers/cxl/core/memdev.c | 32 +++++++++-----------------------
>  drivers/cxl/cxl.h         |  1 +
>  drivers/cxl/cxlmem.h      |  9 +++------
>  drivers/cxl/mem.c         |  2 +-
>  5 files changed, 24 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
> index c5f8a17d00f1..92e1a24e2109 100644
> --- a/drivers/cxl/core/hdm.c
> +++ b/drivers/cxl/core/hdm.c
> @@ -470,6 +470,7 @@ static const char *cxl_mode_name(enum cxl_partition_mode mode)
>  int cxl_dpa_setup(struct cxl_dev_state *cxlds, const struct cxl_dpa_info *info)
>  {
>  	struct device *dev = cxlds->dev;
> +	int i;
>  
>  	guard(rwsem_write)(&cxl_dpa_rwsem);
>  
> @@ -482,9 +483,17 @@ int cxl_dpa_setup(struct cxl_dev_state *cxlds, const struct cxl_dpa_info *info)
>  		return 0;
>  	}
>  
> +	/* Verify partitions are in expected order. */
> +	for (i = 1; i < info->nr_partitions; i++) {
> +		if (cxlds->part[i].mode < cxlds->part[i-1].mode) {

spaces around -

> +			dev_err(dev, "Partition order mismatch\n");
> +			return 0;
> +		}
> +	}
> +
>  	cxlds->dpa_res = DEFINE_RES_MEM(0, info->size);
>  
> -	for (int i = 0; i < info->nr_partitions; i++) {
> +	for (i = 0; i < info->nr_partitions; i++) {
>  		const struct cxl_dpa_part_info *part = &info->part[i];
>  		int rc;

