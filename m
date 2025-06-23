Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8292192E1
	for <nvdimm@lists.linux.dev>; Mon, 23 Jun 2025 09:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750672624; cv=none; b=hAV5sQqaWeeDJPoPfHWZv6TRESfOmsnxjuL9Y+VzvR8bDpp9anghuGG00ZtSwkZBrMA54rKDyjkq/05ZHl2KslyTYWy02ZtIWLGbUDEmi44y2hQCrASUIlxVvP1Du2yJiRe+cyv763ll9hBS9W9CHRpt3SfSFxcqP/hfsV4XJNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750672624; c=relaxed/simple;
	bh=gl/PweAvp6KAO6MlCGfgQFmI+Q7GuzLeGH3327OmQxU=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O1iWaqZ4OD6M77Sgvc+L4Zgoc527PMN4vVht4fpqD9DAwS0fk0qHkMYAKS1PQaV7ttu/X8NuN0Edsa5S0mhfrhUinmIKayPLg0XX7jYpg5YKCv4iXIy+DiSky5RbdjJ6FdbXtN2X+CeqfpC6Ii/AmsAa4VbbESuFhMT2vTgitac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4bQk2K17nCz6HJrm;
	Mon, 23 Jun 2025 17:54:33 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id D7A9D1402F6;
	Mon, 23 Jun 2025 17:56:59 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Mon, 23 Jun
 2025 11:56:59 +0200
Date: Mon, 23 Jun 2025 10:56:57 +0100
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
Subject: Re: [RFC PATCH 20/20] cxl/pmem_region: Add cxl region label
 updation and deletion device attributes
Message-ID: <20250623105657.00003996@huawei.com>
In-Reply-To: <1371006431.81750165382853.JavaMail.epsvc@epcpadp2new>
References: <20250617123944.78345-1-s.neeraj@samsung.com>
	<CGME20250617124104epcas5p41105ad63af456b5cdb041e174a99925e@epcas5p4.samsung.com>
	<1371006431.81750165382853.JavaMail.epsvc@epcpadp2new>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100011.china.huawei.com (7.191.174.247) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Tue, 17 Jun 2025 18:09:44 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

> Using these attributes region label is added/deleted into LSA. These
> attributes are called from userspace (ndctl) after region creation.

These need documentation. Documentation/ABI/testing/sysfs-bus-cxl
is probably the right place.


> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
> ---
>  drivers/cxl/core/pmem_region.c | 103 +++++++++++++++++++++++++++++++++
>  drivers/cxl/cxl.h              |   1 +
>  2 files changed, 104 insertions(+)
> 
> diff --git a/drivers/cxl/core/pmem_region.c b/drivers/cxl/core/pmem_region.c
> index a29526c27d40..f582d796c21b 100644
> --- a/drivers/cxl/core/pmem_region.c
> +++ b/drivers/cxl/core/pmem_region.c
> @@ -45,8 +45,111 @@ static void cxl_pmem_region_release(struct device *dev)
>  	kfree(cxlr_pmem);
>  }
>  
> +static ssize_t region_label_update_store(struct device *dev,
> +					 struct device_attribute *attr,
> +					 const char *buf, size_t len)
> +{
> +	struct cxl_pmem_region *cxlr_pmem = to_cxl_pmem_region(dev);
> +	struct cxl_region *cxlr = cxlr_pmem->cxlr;
> +	struct cxl_region_params *p = &cxlr->params;
> +	ssize_t rc;
> +	bool update;
> +
> +	rc = kstrtobool(buf, &update);
> +	if (rc)
> +		return rc;
> +
> +	rc = down_write_killable(&cxl_region_rwsem);

Another use case for ACQUIRE()

> +	if (rc)
> +		return rc;
> +
> +	/* Region not yet committed */
> +	if (update && p->state != CXL_CONFIG_COMMIT) {
> +		dev_dbg(dev, "region not committed, can't update into LSA\n");
> +		rc = -ENXIO;
> +		goto out;
> +	}
> +
> +	if (cxlr && cxlr->cxlr_pmem && cxlr->cxlr_pmem->nd_region) {
> +		rc = nd_region_label_update(cxlr->cxlr_pmem->nd_region);
> +
> +		if (!rc)
> +			p->region_label_state = 1;
> +	}
> +
> +out:
> +	up_write(&cxl_region_rwsem);
> +
> +	if (rc)
> +		return rc;
> +
> +	return len;
> +}

> +
> +static struct attribute *cxl_pmem_region_attrs[] = {
> +	&dev_attr_region_label_update.attr,
> +	&dev_attr_region_label_delete.attr,
> +	NULL,
No need for trailing commas on terminating entries as we don't want it to be easy
to put something after them.

> +};
> +
> +struct attribute_group cxl_pmem_region_group = {
> +	.attrs = cxl_pmem_region_attrs,
> +};
> +
>  static const struct attribute_group *cxl_pmem_region_attribute_groups[] = {
>  	&cxl_base_attribute_group,
> +	&cxl_pmem_region_group,
>  	NULL,
Hmm. Drop this trailing comma perhaps whilst here.
>  };


