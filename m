Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DBD2D595B
	for <nvdimm@lists.linux.dev>; Thu, 15 Jan 2026 18:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768501282; cv=none; b=fHpLyHEhz5B/F84UriXfh6lzIsbXS2R5NCN3GDmYUEZ0QSMHNvj7a22oM2M2IFWoFXnX3B+mZBJEpx0dUmHcKyMDAPKfsfDnWGxG/OePX01fzhtOh07Fatv918SqrsFC8viYqwaqO73tF3D/fKX2TTWjO9CvfKFQGrziI6yNqic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768501282; c=relaxed/simple;
	bh=8rddKG3aVEReTljgO0XfO/gclNrK3UrkmYfV/oadmps=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sPEcMBhzOHe/gy26qflrHdYq1SYucGuRncAIr4pHuayblDLRdpuOwBO3txtbRcOuh3zyfLB+YdtCfywz3X8SlTZhobj69CqdyBjfLfcJ/UCLb8bmTcL0jE2VwjGMZN97iyspByCGALBN+7whe0H5qy8y30VlGWEaZ+op2AYqk3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dsWWX06VxzHnGdj;
	Fri, 16 Jan 2026 02:20:56 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 5EE8E40563;
	Fri, 16 Jan 2026 02:21:18 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 15 Jan
 2026 18:21:17 +0000
Date: Thu, 15 Jan 2026 18:21:16 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Neeraj Kumar <s.neeraj@samsung.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <gost.dev@samsung.com>,
	<a.manzanares@samsung.com>, <vishak.g@samsung.com>, <neeraj.kernel@gmail.com>
Subject: Re: [PATCH V5 15/17] cxl/pmem_region: Add sysfs attribute cxl
 region label updation/deletion
Message-ID: <20260115182116.000057b9@huawei.com>
In-Reply-To: <20260109124437.4025893-16-s.neeraj@samsung.com>
References: <20260109124437.4025893-1-s.neeraj@samsung.com>
	<CGME20260109124531epcas5p118e7306860bcd57a0106948375df5c9c@epcas5p1.samsung.com>
	<20260109124437.4025893-16-s.neeraj@samsung.com>
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

On Fri,  9 Jan 2026 18:14:35 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

> Using these attributes region label is added/deleted into LSA. These
> attributes are called from userspace (ndctl) after region creation.
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
One wrong field name.

With that and the version number updated as Dave pointed out
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>


> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index 6ac3b40cb5ff..8c76c4a981bf 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h

>  /**
>   * struct cxl_region_params - region settings
>   * @state: allow the driver to lockdown further parameter changes
> + * @state: region label state

wrong name.

Run scripts/kernel-doc over files you add documentation to and it'll
tell you when you get anything like this wrong.

>   * @uuid: unique id for persistent regions
>   * @interleave_ways: number of endpoints in the region
>   * @interleave_granularity: capacity each endpoint contributes to a stripe
> @@ -488,6 +494,7 @@ enum cxl_config_state {
>   */
>  struct cxl_region_params {
>  	enum cxl_config_state state;
> +	enum region_label_state state_region_label;
>  	uuid_t uuid;
>  	int interleave_ways;
>  	int interleave_granularity;

