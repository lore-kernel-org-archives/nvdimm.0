Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA6463A9
	for <nvdimm@lists.linux.dev>; Mon, 23 Jun 2025 09:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750670034; cv=none; b=oTlIVw8TKP1p45hRUJd+yfuyPjUb3pq05APQ0Q+rRzKj5/pUQ1S6BOZIB5VBIPDBKu5NiwDMHBv6cjqOWg1UmXJKTWbZ6Fu5ZelqMVE1AiOKN61eTyEgCKSZKRppjVnamR4qxOVpcOgJ03E76AAmuooDUYP2QbBipWYNm3j0Uek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750670034; c=relaxed/simple;
	bh=JysO40ZAFUS1sTNcaKwvVhL7fQmMi1O3qbD6rXGu7e8=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JUk6KXha2ODAjTvRjGQdvcfnmns1TweJ9poX/CYMGG5Wt5Y5WWr3LqXLmrr1SYQGG0JsvmOfES1uErq+gPprxVQEVRRJvBSuv/6ABYAVAupKc2fX7SJDfm0DXbnnsFIQwWesrEWoAQL2956NROsA320j3QsKg5kJDn6tpbHJw9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4bQj1f45p1z6L5WZ;
	Mon, 23 Jun 2025 17:08:54 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 3579A140446;
	Mon, 23 Jun 2025 17:13:50 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Mon, 23 Jun
 2025 11:13:49 +0200
Date: Mon, 23 Jun 2025 10:13:47 +0100
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
Subject: Re: [RFC PATCH 08/20] nvdimm/label: Include region label in slot
 validation
Message-ID: <20250623101347.00003d7a@huawei.com>
In-Reply-To: <148912029.181750165204802.JavaMail.epsvc@epcpadp1new>
References: <20250617123944.78345-1-s.neeraj@samsung.com>
	<CGME20250617124028epcas5p2bb45182c91359a16efc5b1561927abce@epcas5p2.samsung.com>
	<148912029.181750165204802.JavaMail.epsvc@epcpadp1new>
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

On Tue, 17 Jun 2025 18:09:32 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

> slot validation routine validates label slot by calculating label
> checksum. It was only validating namespace label. This changeset also
> validates region label if present.
> 
> Also validate and calculate lsa v2.1 namespace label checksum
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>



> diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
> index 1e5a68013735..ca8256b31472 100644
> --- a/drivers/nvdimm/nd.h
> +++ b/drivers/nvdimm/nd.h
> @@ -331,6 +331,22 @@ static inline bool nsl_region_uuid_equal(struct nd_namespace_label *ns_label,
>  	return uuid_equal(&tmp, uuid);
>  }
>  
> +static inline bool is_region_label(struct nvdimm_drvdata *ndd,
> +				   struct nd_lsa_label *nd_label)
> +{
> +	uuid_t ns_type, region_type;
> +
> +	if (ndd->cxl) {
> +		uuid_parse(CXL_REGION_UUID, &region_type);
> +		import_uuid(&ns_type, nd_label->ns_label.cxl.type);
> +		if (uuid_equal(&region_type, &ns_type))
> +			return true;
> +		else
> +			return false;

		return uuid_equal(&reg_type, &ns_type);

> +	} else
{}
for all legs if one needs it.

However, if you aren't going to add more code here later, just flip the condition
and exit early.

	if (!ndd->cxl)
		return false;

	uuid_parse...

> +		return false;
> +}
> +
>  static inline bool rgl_uuid_equal(struct cxl_region_label *rg_label,
>  				  const uuid_t *uuid)
>  {
> @@ -340,6 +356,11 @@ static inline bool rgl_uuid_equal(struct cxl_region_label *rg_label,
>  	return uuid_equal(&tmp, uuid);
>  }
>  
> +static inline u32 rgl_get_slot(struct cxl_region_label *rg_label)
> +{
> +	return __le32_to_cpu(rg_label->slot);
> +}
> +
>  static inline u64 rgl_get_checksum(struct cxl_region_label *rg_label)
>  {
>  	return __le64_to_cpu(rg_label->checksum);

