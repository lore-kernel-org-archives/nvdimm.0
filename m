Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CDBB359FA0
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 12:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961376; cv=none; b=hH+D/ZVdhxlSOc00+w5L1Y1VZ4Lo4UXYULKijXD84HIoHBgtUcI4ptfIMqKtf32hlIIFzJIgFCS0psuQdehe4u+iU0TZ6ZasyHLHdHLjc4Qkce5HhBdA19Q5/mPUD/vNcX4AGMbxtZsJvgXu8nG0xiMo/zCx3QIDBESFnxxXcQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961376; c=relaxed/simple;
	bh=EbGVi6Tn5nJBmw7R/hyfRwJTWH2nRBMzA+GXd3kynH0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=oVY32sjjF4HlctMjuGl8ve7kFwvftL9wZ7bMiwhds0GGI4bvT4NKSQiHXBhaRIOMwJHELgy2MlzbB3RTa5RrFflDxeIdHI+U2G4j+QHTjSpOXwFC/XOM7X4ZctcOGkfHZP73AR0y285ehXMw5AZ5N6oib73nLU8xLEdUTW9Cfg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=fsoSz/3h; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="fsoSz/3h"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260109122251epoutp01a97bde23fb38d8849fe7d94bd97316df~JD4AdizDY2178021780epoutp01s
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 12:22:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260109122251epoutp01a97bde23fb38d8849fe7d94bd97316df~JD4AdizDY2178021780epoutp01s
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1767961371;
	bh=h7z3j0DHDPo78MUbRVa2QyuOhzGwx2M7bXKx+1ANtSI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=fsoSz/3hZrbu6T9JTKUni9TLKRV7O6xAgN6du7j1FUcW/QBdRXzSuAmAR73LJ1QaT
	 ONewHTw39NdlE3A7YyDJl/4wwGJx0HA3lmBVhN45CbbhAcgSJLbeNQ10pTVHBBqp10
	 QpRIBvT9bUh0AotLcArrSEaH3d4HOgdfKR/5KH3I=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20260109122251epcas5p34c2db9e4bd6c44e908f0ca734efd20b9~JD4ACZR503211332113epcas5p3F;
	Fri,  9 Jan 2026 12:22:51 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.91]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4dngs61mKRz6B9m5; Fri,  9 Jan
	2026 12:22:50 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20260109122249epcas5p170c781b071dcc4ae1b5ae55e7c394859~JD3_XwCS-2134221342epcas5p1-;
	Fri,  9 Jan 2026 12:22:49 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260109122248epsmtip2a0b280640958663acd3bf3557e11a931~JD39KbUim0336403364epsmtip2N;
	Fri,  9 Jan 2026 12:22:47 +0000 (GMT)
Date: Fri, 9 Jan 2026 17:52:41 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V4 11/17] cxl/region: Add devm_cxl_pmem_add_region() for
 pmem region creation
Message-ID: <20260109122241.xpt5jygycisiueaw@test-PowerEdge-R740xd>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20251217152856.00003c17@huawei.com>
X-CMS-MailID: 20260109122249epcas5p170c781b071dcc4ae1b5ae55e7c394859
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----bVwHse4Nykw-L2c5iRRXKf-G.8k0lxUwrpcTFjGaDb9lfltx=_e5998_"
CMS-TYPE: 105P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251119075327epcas5p29991fec95ca8a26503f457a30bb2429a
References: <20251119075255.2637388-1-s.neeraj@samsung.com>
	<CGME20251119075327epcas5p29991fec95ca8a26503f457a30bb2429a@epcas5p2.samsung.com>
	<20251119075255.2637388-12-s.neeraj@samsung.com>
	<20251217152856.00003c17@huawei.com>

------bVwHse4Nykw-L2c5iRRXKf-G.8k0lxUwrpcTFjGaDb9lfltx=_e5998_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 17/12/25 03:28PM, Jonathan Cameron wrote:
>On Wed, 19 Nov 2025 13:22:49 +0530
>Neeraj Kumar <s.neeraj@samsung.com> wrote:
>
>> devm_cxl_pmem_add_region() is used to create cxl region based on region
>> information scanned from LSA.
>>
>> devm_cxl_add_region() is used to just allocate cxlr and its fields are
>> filled later by userspace tool using device attributes (*_store()).
>>
>> Inspiration for devm_cxl_pmem_add_region() is taken from these device
>> attributes (_store*) calls. It allocates cxlr and fills information
>> parsed from LSA and calls device_add(&cxlr->dev) to initiate further
>> region creation porbes
>>
>> Rename __create_region() to cxl_create_region(), which will be used
>> in later patch to create cxl region after fetching region information
>> from LSA.
>>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>
>I think there is an underflow of the device reference count in an error
>path. See below.
>
>Jonathan
>
>> +static struct cxl_region *
>> +devm_cxl_pmem_add_region(struct cxl_root_decoder *cxlrd, int id,
>> +			 struct cxl_pmem_region_params *params,
>> +			 struct cxl_decoder *cxld,
>> +			 enum cxl_decoder_type type)
>> +{
>> +	struct cxl_endpoint_decoder *cxled;
>> +	struct cxl_region_params *p;
>> +	struct cxl_port *root_port;
>> +	struct device *dev;
>> +	int rc;
>> +
>> +	struct cxl_region *cxlr __free(put_cxl_region) =
>> +		cxl_region_alloc(cxlrd, id);
>It can be tricky to get the use of __free() when related
>to devices that are being registered right.  I'm not sure it
>is quite correct here.
>
>> +	if (IS_ERR(cxlr))
>> +		return cxlr;
>> +
>> +	cxlr->mode = CXL_PARTMODE_PMEM;
>> +	cxlr->type = type;
>> +
>> +	dev = &cxlr->dev;
>> +	rc = dev_set_name(dev, "region%d", id);
>> +	if (rc)
>> +		return ERR_PTR(rc);
>> +
>> +	p = &cxlr->params;
>> +	p->uuid = params->uuid;
>> +	p->interleave_ways = params->nlabel;
>> +	p->interleave_granularity = params->ig;
>> +
>> +	rc = alloc_region_hpa(cxlr, params->rawsize);
>> +	if (rc)
>> +		return ERR_PTR(rc);
>> +
>> +	cxled = to_cxl_endpoint_decoder(&cxld->dev);
>> +
>> +	rc = cxl_dpa_set_part(cxled, CXL_PARTMODE_PMEM);
>> +	if (rc)
>> +		return ERR_PTR(rc);
>> +
>> +	rc = alloc_region_dpa(cxled, params->rawsize);
>> +	if (rc)
>> +		return ERR_PTR(rc);
>> +
>> +	/*
>> +	 * TODO: Currently we have support of interleave_way == 1, where
>> +	 * we can only have one region per mem device. It means mem device
>> +	 * position (params->position) will always be 0. It is therefore
>> +	 * attaching only one target at params->position
>> +	 */
>> +	if (params->position)
>> +		return ERR_PTR(-EOPNOTSUPP);
>> +
>> +	rc = attach_target(cxlr, cxled, params->position, TASK_INTERRUPTIBLE);
>> +	if (rc)
>> +		return ERR_PTR(rc);
>> +
>> +	rc = __commit(cxlr);
>> +	if (rc)
>> +		return ERR_PTR(rc);
>> +
>> +	rc = device_add(dev);
>> +	if (rc)
>> +		return ERR_PTR(rc);
>> +
>> +	root_port = to_cxl_port(cxlrd->cxlsd.cxld.dev.parent);
>> +	rc = devm_add_action_or_reset(root_port->uport_dev,
>> +			unregister_region, cxlr);
>> +	if (rc)
>In this path the __free(put_cxl_region) will put once.
>The unregister_region will both unregister and put.  The
>dev_add_action_or_reset() will have called unregister_region()
>Which does both device_del() and a put on cxlr->dev.
>
>I might have missed another reference but at first glance at least
>this underflows.
>
>Note the different error path for the devm_add_action_or_reset
>in current devm_cxl_add_region() which is there because there isn't
>another reference count to decrement.
>
>Various ways to solve this.  A common one is to separate the
>allocation and adding stuff into another function (with __free as
>you have here) and call that from here, leaving this outer wrapper
>just doing the devm_add_action_or_reset() if everything else
>has succeeded and hence no need for the outer function to do any
>other reference coutn handling.  Or just don't use __free() as
>is done in devm_cxl_add_region()
>

I have used __free() based on Dave's review comment in V2[1] to
avoid extra gotos. Thanks for catching this reference underflow.

I have fixed it in V5 as per your suggestion.
I have used separate routine cxl_pmem_region_prep() where i have used __free().

[1]: https://lore.kernel.org/linux-cxl/148912029.181757055784505.JavaMail.epsvc@epcpadp2new/



Regards,
Neeraj

------bVwHse4Nykw-L2c5iRRXKf-G.8k0lxUwrpcTFjGaDb9lfltx=_e5998_
Content-Type: text/plain; charset="utf-8"


------bVwHse4Nykw-L2c5iRRXKf-G.8k0lxUwrpcTFjGaDb9lfltx=_e5998_--
