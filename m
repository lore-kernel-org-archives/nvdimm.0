Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96E037D526
	for <nvdimm@lists.linux.dev>; Wed, 17 Dec 2025 15:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765985344; cv=none; b=nbE6vMyDacvjUC/KtmIqxWAysTucT1SOCo+azZF0tTtPyPWJNdggEwU6bre9nBnlFUTV2vguuckgo43jkQl5fSFQ3F56mN1t4Qqir3v3zU+zMaOSFB8q2yGX8emrg/Xb5mR2jZK4AyjBQJulbkSRzNJGYQZx7Eb8kWKpkQnyf08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765985344; c=relaxed/simple;
	bh=/PEhF6zGUKpc/wZOaT0HdmRWnSHP7UBO9stThP+aqcA=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Md427PNpzFCrP6Yiuso98JjMeqtybE24FS8fuhPSwlxpw2Lw/X/crTNU6nYDyj/idPLAIQNe6Mg3pjAtBIhSz5Xc+Zv6PpsMwnkwAwz6vMt0fgXGX6IIj5l/DYa/F2bZEATFAtcu5Vc4pSltiWwkkbsRBPDNe9DX+cmTO5IaD2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dWd412NVPzHnGj0;
	Wed, 17 Dec 2025 23:28:33 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id B9CAB40565;
	Wed, 17 Dec 2025 23:28:58 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 17 Dec
 2025 15:28:58 +0000
Date: Wed, 17 Dec 2025 15:28:56 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Neeraj Kumar <s.neeraj@samsung.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <gost.dev@samsung.com>,
	<a.manzanares@samsung.com>, <vishak.g@samsung.com>, <neeraj.kernel@gmail.com>
Subject: Re: [PATCH V4 11/17] cxl/region: Add devm_cxl_pmem_add_region() for
 pmem region creation
Message-ID: <20251217152856.00003c17@huawei.com>
In-Reply-To: <20251119075255.2637388-12-s.neeraj@samsung.com>
References: <20251119075255.2637388-1-s.neeraj@samsung.com>
	<CGME20251119075327epcas5p29991fec95ca8a26503f457a30bb2429a@epcas5p2.samsung.com>
	<20251119075255.2637388-12-s.neeraj@samsung.com>
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

On Wed, 19 Nov 2025 13:22:49 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

> devm_cxl_pmem_add_region() is used to create cxl region based on region
> information scanned from LSA.
> 
> devm_cxl_add_region() is used to just allocate cxlr and its fields are
> filled later by userspace tool using device attributes (*_store()).
> 
> Inspiration for devm_cxl_pmem_add_region() is taken from these device
> attributes (_store*) calls. It allocates cxlr and fills information
> parsed from LSA and calls device_add(&cxlr->dev) to initiate further
> region creation porbes
> 
> Rename __create_region() to cxl_create_region(), which will be used
> in later patch to create cxl region after fetching region information
> from LSA.
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>

I think there is an underflow of the device reference count in an error
path. See below.  

Jonathan

> +static struct cxl_region *
> +devm_cxl_pmem_add_region(struct cxl_root_decoder *cxlrd, int id,
> +			 struct cxl_pmem_region_params *params,
> +			 struct cxl_decoder *cxld,
> +			 enum cxl_decoder_type type)
> +{
> +	struct cxl_endpoint_decoder *cxled;
> +	struct cxl_region_params *p;
> +	struct cxl_port *root_port;
> +	struct device *dev;
> +	int rc;
> +
> +	struct cxl_region *cxlr __free(put_cxl_region) =
> +		cxl_region_alloc(cxlrd, id);
It can be tricky to get the use of __free() when related
to devices that are being registered right.  I'm not sure it
is quite correct here.

> +	if (IS_ERR(cxlr))
> +		return cxlr;
> +
> +	cxlr->mode = CXL_PARTMODE_PMEM;
> +	cxlr->type = type;
> +
> +	dev = &cxlr->dev;
> +	rc = dev_set_name(dev, "region%d", id);
> +	if (rc)
> +		return ERR_PTR(rc);
> +
> +	p = &cxlr->params;
> +	p->uuid = params->uuid;
> +	p->interleave_ways = params->nlabel;
> +	p->interleave_granularity = params->ig;
> +
> +	rc = alloc_region_hpa(cxlr, params->rawsize);
> +	if (rc)
> +		return ERR_PTR(rc);
> +
> +	cxled = to_cxl_endpoint_decoder(&cxld->dev);
> +
> +	rc = cxl_dpa_set_part(cxled, CXL_PARTMODE_PMEM);
> +	if (rc)
> +		return ERR_PTR(rc);
> +
> +	rc = alloc_region_dpa(cxled, params->rawsize);
> +	if (rc)
> +		return ERR_PTR(rc);
> +
> +	/*
> +	 * TODO: Currently we have support of interleave_way == 1, where
> +	 * we can only have one region per mem device. It means mem device
> +	 * position (params->position) will always be 0. It is therefore
> +	 * attaching only one target at params->position
> +	 */
> +	if (params->position)
> +		return ERR_PTR(-EOPNOTSUPP);
> +
> +	rc = attach_target(cxlr, cxled, params->position, TASK_INTERRUPTIBLE);
> +	if (rc)
> +		return ERR_PTR(rc);
> +
> +	rc = __commit(cxlr);
> +	if (rc)
> +		return ERR_PTR(rc);
> +
> +	rc = device_add(dev);
> +	if (rc)
> +		return ERR_PTR(rc);
> +
> +	root_port = to_cxl_port(cxlrd->cxlsd.cxld.dev.parent);
> +	rc = devm_add_action_or_reset(root_port->uport_dev,
> +			unregister_region, cxlr);
> +	if (rc)
In this path the __free(put_cxl_region) will put once.
The unregister_region will both unregister and put.  The
dev_add_action_or_reset() will have called unregister_region()
Which does both device_del() and a put on cxlr->dev. 

I might have missed another reference but at first glance at least
this underflows.

Note the different error path for the devm_add_action_or_reset
in current devm_cxl_add_region() which is there because there isn't
another reference count to decrement.

Various ways to solve this.  A common one is to separate the
allocation and adding stuff into another function (with __free as
you have here) and call that from here, leaving this outer wrapper
just doing the devm_add_action_or_reset() if everything else
has succeeded and hence no need for the outer function to do any
other reference coutn handling.  Or just don't use __free() as
is done in devm_cxl_add_region()


> +		return ERR_PTR(rc);
> +
> +	dev_dbg(root_port->uport_dev, "%s: created %s\n",
> +		dev_name(&cxlrd->cxlsd.cxld.dev), dev_name(dev));
> +
> +	return no_free_ptr(cxlr);
> +}

