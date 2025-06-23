Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0EB13B58B
	for <nvdimm@lists.linux.dev>; Mon, 23 Jun 2025 10:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750676038; cv=none; b=QKi7iNXoA9PSfpc0yPO9F5gxANZRzVlcpec79drQvUi7OfJt1Ti1HcA4QPm4WuIc+Pfa5sk2hBtFB/ZTvdY7U8oMX60njbBxshL1WuBaV8yoUOJcAh7/OjPP0MmnU01++yGxStQQWLjIaY183UEdm4JR4M+fEzEItt1SxlVGHeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750676038; c=relaxed/simple;
	bh=zBO6MXFFmO5JL7G17t6OORmf8OccJRCcVgUVBPiXXX4=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nml5pupSh1NOiKdOlGS0jo2XvUpPklThltRAj71W3LRTaO5zSXtn+xkpHKG/OXhWzQslfHuxtnieE9//dnPOesHNmCG0FiGArMsSFN/RBzn0MxLn6f913L/ms0qKLWHEuKhLebBbX87ShrY1kV0/8nfBGb44xGWlDOs1X3/3EtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4bQlKz0zGMz6L757;
	Mon, 23 Jun 2025 18:53:11 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id AF30F1402E9;
	Mon, 23 Jun 2025 18:53:53 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Mon, 23 Jun
 2025 12:53:52 +0200
Date: Mon, 23 Jun 2025 11:53:51 +0100
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
Subject: Re: [RFC PATCH 02/20] nvdimm/label: Prep patch to accommodate cxl
 lsa 2.1 support
Message-ID: <20250623115351.00005312@huawei.com>
In-Reply-To: <700072760.81750165203833.JavaMail.epsvc@epcpadp1new>
References: <20250617123944.78345-1-s.neeraj@samsung.com>
	<CGME20250617124011epcas5p2264e30ec58977907f80d311083265641@epcas5p2.samsung.com>
	<700072760.81750165203833.JavaMail.epsvc@epcpadp1new>
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

On Tue, 17 Jun 2025 18:09:26 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

> In order to accommodate cxl lsa 2.1 format region label, renamed
> nd_namespace_label to nd_lsa_label.

I would add some more information on why.  I've no idea from this
description whether the issue is a naming clash or a need for a broader
name or something entirely different.

Most readers aren't going to be particular familiar with the lsa spec
version changes, so help them out with a little more detail.

The comment you have with the union is probably the right info
to duplicate here.

> 
> No functional change introduced.
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>

This is quite a lot of churn which, just looking at this patch, could
be avoided by just setting local variables to point at a particular
member of the union rather than the containing struct.
You already do this in a few places like nd_label_reserve_dpa().

Perhaps it will be come clearer why that doesn't make sense as
I ready later patches.

> diff --git a/drivers/nvdimm/label.h b/drivers/nvdimm/label.h
> index 0650fb4b9821..4883b3a1320f 100644
> --- a/drivers/nvdimm/label.h
> +++ b/drivers/nvdimm/label.h
> @@ -183,6 +183,16 @@ struct nd_namespace_label {
>  	};
>  };
>  
> +/*
> + * LSA 2.1 format introduces region label, which can also reside
> + * into LSA along with only namespace label as per v1.1 and v1.2
> + */
> +struct nd_lsa_label {
> +	union {
> +		struct nd_namespace_label ns_label;
> +	};
> +};

> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
> index 55cfbf1e0a95..f180f0068c15 100644
> --- a/drivers/nvdimm/namespace_devs.c
> +++ b/drivers/nvdimm/namespace_devs.c

> @@ -1595,7 +1596,8 @@ static bool has_uuid_at_pos(struct nd_region *nd_region, const uuid_t *uuid,
>  				return false;
>  			}
>  			found_uuid = true;
> -			if (!nsl_validate_nlabel(nd_region, ndd, nd_label))
> +			if (!nsl_validate_nlabel(nd_region,
> +						 ndd, &nd_label->ns_label))

Strange wrap.  I'd move ndd up a line.


>  				continue;
>  			if (position != pos)
>  				continue;
> @@ -1615,7 +1617,7 @@ static int select_pmem_id(struct nd_region *nd_region, const uuid_t *pmem_id)
>  	for (i = 0; i < nd_region->ndr_mappings; i++) {
>  		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
>  		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
> -		struct nd_namespace_label *nd_label = NULL;
> +		struct nd_lsa_label *nd_label = NULL;
>  		u64 hw_start, hw_end, pmem_start, pmem_end;
>  		struct nd_label_ent *label_ent;
>  


> @@ -1739,14 +1741,14 @@ static struct device *create_namespace_pmem(struct nd_region *nd_region,
>  	 * that position at labels[0], and NULL at labels[1].  In the process,
>  	 * check that the namespace aligns with interleave-set.
>  	 */
> -	nsl_get_uuid(ndd, nd_label, &uuid);
> +	nsl_get_uuid(ndd, &nd_label->ns_label, &uuid);
>  	rc = select_pmem_id(nd_region, &uuid);
>  	if (rc)
>  		goto err;
>  
>  	/* Calculate total size and populate namespace properties from label0 */
>  	for (i = 0; i < nd_region->ndr_mappings; i++) {
> -		struct nd_namespace_label *label0;
> +		struct nd_lsa_label *label0;

If you are only ever going to use one part of the union in a given
bit of code, why not use a struct of that type so you only need to change
the point where it is assigned rather that lots of places.

So keep this as struct nd_namespace_label *label0;

If that makes sense, check for other places where doing that will reduce the churn
and complexity of the code.



>  		struct nvdimm_drvdata *ndd;
>  
>  		nd_mapping = &nd_region->mapping[i];
> @@ -1760,17 +1762,17 @@ static struct device *create_namespace_pmem(struct nd_region *nd_region,
>  		}
>  
>  		ndd = to_ndd(nd_mapping);
> -		size += nsl_get_rawsize(ndd, label0);
> -		if (nsl_get_position(ndd, label0) != 0)
> +		size += nsl_get_rawsize(ndd, &label0->ns_label);
> +		if (nsl_get_position(ndd, &label0->ns_label) != 0)
>  			continue;
>  		WARN_ON(nspm->alt_name || nspm->uuid);
> -		nspm->alt_name = kmemdup(nsl_ref_name(ndd, label0),
> +		nspm->alt_name = kmemdup(nsl_ref_name(ndd, &label0->ns_label),
>  					 NSLABEL_NAME_LEN, GFP_KERNEL);
> -		nsl_get_uuid(ndd, label0, &uuid);
> +		nsl_get_uuid(ndd, &label0->ns_label, &uuid);
>  		nspm->uuid = kmemdup(&uuid, sizeof(uuid_t), GFP_KERNEL);
> -		nspm->lbasize = nsl_get_lbasize(ndd, label0);
> +		nspm->lbasize = nsl_get_lbasize(ndd, &label0->ns_label);
>  		nspm->nsio.common.claim_class =
> -			nsl_get_claim_class(ndd, label0);
> +			nsl_get_claim_class(ndd, &label0->ns_label);
>  	}

