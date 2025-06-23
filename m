Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3FF122DFB5
	for <nvdimm@lists.linux.dev>; Mon, 23 Jun 2025 09:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750669870; cv=none; b=HMp5hEUzT8gFwzmcSLChgWbp5D3zuTC0RaOW4ALKWv/Dt8Gcmu+31SBj0BE5M5bOosEwRAkpjowcxru+KnJALuom6GLBilTMRxHm8QtDuaJrota0OMWtaGoo5phFhCmMEib6g2FhAqLvCb4q0gXCkaAeY6g83xS69hq38ogiO+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750669870; c=relaxed/simple;
	bh=o569LL4BEBDrc3m63XJIygE9Fr1C6eR3/WlRs2aoNLY=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q/BfQUxJFcdU92VSBqY+YjopBnrbQz6VKoDw2sEcW9Qmj1QDo3D2uJYAav6d1U0IYZxU9iNbV6TxoNPFFE1q1QptVoOvKQ4UQXpeXwImb0385vWeqJb/Hq54SstDulr9F4F0AfvFI4Fu6kx4FoiaHPAKyWMdUZL1BZMUfqyZbYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4bQj1M3qsqz6HJqS;
	Mon, 23 Jun 2025 17:08:39 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 29A941402F6;
	Mon, 23 Jun 2025 17:11:06 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Mon, 23 Jun
 2025 11:11:05 +0200
Date: Mon, 23 Jun 2025 10:11:04 +0100
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
Subject: Re: [RFC PATCH 07/20] nvdimm/namespace_label: Update namespace
 init_labels and its region_uuid
Message-ID: <20250623101104.00001ca4@huawei.com>
In-Reply-To: <720167805.241750165205630.JavaMail.epsvc@epcpadp1new>
References: <20250617123944.78345-1-s.neeraj@samsung.com>
	<CGME20250617124025epcas5p1ce6656fed9ef1175812f80574048cd7a@epcas5p1.samsung.com>
	<720167805.241750165205630.JavaMail.epsvc@epcpadp1new>
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
 frapeml500008.china.huawei.com (7.182.85.71)

On Tue, 17 Jun 2025 18:09:31 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

> nd_mapping->labels maintains the list of labels present into LSA.
> init_labels function prepares this list while adding new label

init_labels() prepares


> into LSA and updates nd_mapping->labels accordingly. During cxl
> region creation nd_mapping->labels list and LSA was updated with
> one region label. Therefore during new namespace label creation
> pre-include the previously created region label, so increase
> num_labels count by 1.
> 
> Also updated nsl_set_region_uuid with region uuid with which
> namespace is associated with.
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
> ---
>  drivers/nvdimm/label.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index 9381c50086fc..108100c4bf44 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c
> @@ -947,7 +947,7 @@ static int __pmem_label_update(struct nd_region *nd_region,
>  	nsl_set_slot(ndd, ns_label, slot);
>  	nsl_set_alignment(ndd, ns_label, 0);
>  	nsl_set_type_guid(ndd, ns_label, &nd_set->type_guid);
> -	nsl_set_region_uuid(ndd, ns_label, NULL);
> +	nsl_set_region_uuid(ndd, ns_label, &nd_set->uuid);
>  	nsl_set_claim_class(ndd, ns_label, ndns->claim_class);
>  	nsl_calculate_checksum(ndd, ns_label);
>  	nd_dbg_dpa(nd_region, ndd, res, "\n");
> @@ -1114,7 +1114,8 @@ int nd_pmem_namespace_label_update(struct nd_region *nd_region,
>  				count++;
>  		WARN_ON_ONCE(!count);
>  
> -		rc = init_labels(nd_mapping, count);
> +		/* Adding 1 to pre include the already added region label */
> +		rc = init_labels(nd_mapping, count + 1);
>  		if (rc < 0)
>  			return rc;
>  

