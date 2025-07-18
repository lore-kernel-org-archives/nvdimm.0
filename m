Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A070122F76F
	for <nvdimm@lists.linux.dev>; Sat, 19 Jul 2025 07:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752909488; cv=none; b=O9gEhroeixkokBTbKiQCdRylruVNmRBr0lQbcwghRPCEwSHRppO2yvVSd6HzV4puywbIYsHNjLZyF6HqdwM9+2cKySdtVHUOrKr3ITk0Dc7VxTTZlAzguUjfGJvsAnr/ms7N/AFTnLw89ec+4hrtwKC4dWSrKf4XviA9EMGr+ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752909488; c=relaxed/simple;
	bh=V5LeZX7GBpeK1fduiolD72aQcoOdAUsXHzO8NnSn02E=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=Mm5Wee5juBy9VYuYnxAnC/ulDNbinqezHS9pT6NxIyUs8sq0aLJxGcWHDb+F+BbOs7h5E2v9IG8BgLXYUwwN47LEa8GrXBt64I9DVRvhbQcSLtD4L5JPsccQFVgb0Yx0AVI8quswNXAzetnlW9Y6AbEghjdMJv/gclwGrgG2dFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=favm5Diu; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="favm5Diu"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250719071804epoutp041ace205b9b07e688bc36e6ae7cd68622~TleOCONzI1502115021epoutp04c
	for <nvdimm@lists.linux.dev>; Sat, 19 Jul 2025 07:18:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250719071804epoutp041ace205b9b07e688bc36e6ae7cd68622~TleOCONzI1502115021epoutp04c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1752909484;
	bh=Tu1pU/LmV2E/Sss50NLp9yByiy/EOODZOb/CvHE6V0Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=favm5Diuisb0mSEhqaXsp2JvznSp3ypjHd0gJrKrDJYGvGKIVJ0vu3gaMNBhZ33Wd
	 oBi1ZGo5Fb8/vUsx+Rh+Ll+P+PCtM1mRdTk6+syQ/vRCT+fy7fVZ9U1PWeeM0/iFmr
	 Y7A2HQ6SBJtwTU6RF9lu6hUfmedXQt6o2zRpYM64=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250719071803epcas5p3e817608789023a504d43492cb01d4c73~TleM-PxWg3120731207epcas5p3N;
	Sat, 19 Jul 2025 07:18:03 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4bkdKl1NBtz6B9m5; Sat, 19 Jul
	2025 07:18:03 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250718125156epcas5p2f713f8e7b42d8c5ba9802a8c26c6aa95~TWYb0cRRV0774907749epcas5p23;
	Fri, 18 Jul 2025 12:51:56 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250718125153epsmtip1df4df811e1e1bc892f721f756417a327~TWYZbaUH41558315583epsmtip1v;
	Fri, 18 Jul 2025 12:51:53 +0000 (GMT)
Date: Fri, 18 Jul 2025 18:21:48 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: dan.j.williams@intel.com, dave@stgolabs.net,
	jonathan.cameron@huawei.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com, a.manzanares@samsung.com,
	nifan.cxl@gmail.com, anisa.su@samsung.com, vishak.g@samsung.com,
	krish.reddy@samsung.com, arun.george@samsung.com, alok.rathore@samsung.com,
	neeraj.kernel@gmail.com, linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, gost.dev@samsung.com,
	cpgs@samsung.com
Subject: Re: [RFC PATCH 18/20] cxl/pmem: Add support of cxl lsa 2.1 support
 in cxl pmem
Message-ID: <700072760.81752909483184.JavaMail.epsvc@epcpadp2new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <45c254fe-fd74-46e7-bf06-5614810f7193@intel.com>
X-CMS-MailID: 20250718125156epcas5p2f713f8e7b42d8c5ba9802a8c26c6aa95
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----OUxkrUiS_5tNAtfPKy2OQMQtEkPPDXVoOsIej.5k6A4J0mxM=_23611_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250617124058epcas5p2324bd3b1bf95d47f553d90fdc727e50d
References: <20250617123944.78345-1-s.neeraj@samsung.com>
	<CGME20250617124058epcas5p2324bd3b1bf95d47f553d90fdc727e50d@epcas5p2.samsung.com>
	<592959754.121750165383213.JavaMail.epsvc@epcpadp2new>
	<45c254fe-fd74-46e7-bf06-5614810f7193@intel.com>

------OUxkrUiS_5tNAtfPKy2OQMQtEkPPDXVoOsIej.5k6A4J0mxM=_23611_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 10/07/25 10:18AM, Dave Jiang wrote:
>
>
>On 6/17/25 5:39 AM, Neeraj Kumar wrote:
>> Add support of cxl lsa 2.1 using NDD_CXL_LABEL flag. It also creates cxl
>> region based on region information parsed from LSA.
>>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>> ---
>>  drivers/cxl/pmem.c | 59 ++++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 59 insertions(+)
>>
>> diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
>> index ffcebb8d382f..2733d79b32d5 100644
>> --- a/drivers/cxl/pmem.c
>> +++ b/drivers/cxl/pmem.c
>> @@ -58,6 +58,63 @@ static const struct attribute_group *cxl_dimm_attribute_groups[] = {
>>  	NULL
>>  };
>>
>> +static int match_ep_decoder(struct device *dev, void *data)
>> +{
>> +	struct cxl_decoder *cxld = to_cxl_decoder(dev);
>> +
>> +	if (!cxld->region)
>> +		return 1;
>> +	else
>> +		return 0;
>> +}
>
>return !cxld->region;
>

Thanks, I will fix it in next patch-set

>
>> +
>> +static struct cxl_decoder *cxl_find_free_decoder(struct cxl_port *port)
>> +{
>> +	struct device *dev;
>> +
>> +	dev = device_find_child(&port->dev, NULL, match_ep_decoder);
>> +	if (!dev)
>> +		return NULL;
>> +
>> +	return to_cxl_decoder(dev);
>> +}
>> +
>> +static int create_pmem_region(struct nvdimm *nvdimm)
>> +{
>> +	struct cxl_nvdimm *cxl_nvd;
>> +	struct cxl_memdev *cxlmd;
>> +	struct cxl_nvdimm_bridge *cxl_nvb;
>> +	struct cxl_pmem_region_params *params;
>> +	struct cxl_root_decoder *cxlrd;
>> +	struct cxl_decoder *cxld;
>> +	struct cxl_region *cxlr;
>> +
>
>probably need a lockdep_assert_held(&cxl_region_rwsem).
>

Thanks Dave, Sure i will fix it with V2

>> +	if (!nvdimm)
>> +		return -ENOTTY;
>
>-ENODEV?

Sure I will fix it with V2

>
>> +
>> +	if (!nvdimm_has_cxl_region(nvdimm))
>> +		return 0;
>> +
>> +	cxl_nvd = nvdimm_provider_data(nvdimm);
>> +	params = nvdimm_get_cxl_region_param(nvdimm);
>> +	cxlmd = cxl_nvd->cxlmd;
>> +	cxl_nvb = cxlmd->cxl_nvb;
>> +	cxlrd = cxlmd->cxlrd;
>> +
>> +	/* FIXME: Limitation: Region creation only when interleave way == 1 */
>> +	if (params->nlabel == 1) {
>> +		cxld = cxl_find_free_decoder(cxlmd->endpoint);
>> +		cxlr = cxl_create_pmem_region(cxlrd, cxld, params,
>> +				atomic_read(&cxlrd->region_id));
>> +		if (IS_ERR(cxlr))
>> +			dev_dbg(&cxlmd->dev, "Region Creation failed\n");
>
>return PTR_ERR(cxlr); ?
>

Thanks, I will fix it in next patch-set

>> +	} else {
>> +		dev_dbg(&cxlmd->dev, "Region Creation is not supported with iw > 1\n");
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>  static int cxl_nvdimm_probe(struct device *dev)
>>  {
>>  	struct cxl_nvdimm *cxl_nvd = to_cxl_nvdimm(dev);
>> @@ -74,6 +131,7 @@ static int cxl_nvdimm_probe(struct device *dev)
>>  		return rc;
>>
>>  	set_bit(NDD_LABELING, &flags);
>> +	set_bit(NDD_CXL_LABEL, &flags);
>
>Ok here's the NDD_CXL_LABEL set. I think the driver should be probing the label index block and retrieve the label version and determine how to support from there instead of hard coding a flag.

Hi Dave,

We actually write label index information into LSA during namespace/region label updation.
During that time we update its major/minor.

So during first time updation of LSA we must need some way to inform nvdimm about LSA versioning.


Regards,
Neeraj

------OUxkrUiS_5tNAtfPKy2OQMQtEkPPDXVoOsIej.5k6A4J0mxM=_23611_
Content-Type: text/plain; charset="utf-8"


------OUxkrUiS_5tNAtfPKy2OQMQtEkPPDXVoOsIej.5k6A4J0mxM=_23611_--

