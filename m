Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50C128DEE0
	for <nvdimm@lists.linux.dev>; Thu, 26 Jun 2025 13:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750944308; cv=none; b=DO6lkaFb+A730fn0ubA25jfapT7QwUx2yaASLlHqoDX4CMf5iFda1HZWzIS/Ez9wZYLZvNsPKcBYB3sJnLpbH8Oupv+hsBnmY5B/bcOkeqKpS+SCv866sUWr4IN7eSwExwdMaYwd/7BTr8qzeljEaTE7twiAdFSfvwghmkfze4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750944308; c=relaxed/simple;
	bh=O4KYtnDmniONwkTdhfVH9U+a1o+pSCQe54UOG+2tBiE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=IIZ2T0xeD63Ns86x5DxHcN76WYAmvt/phvb5zF8XBLta90WsxZkEy3UyRGheBkWWDvxIgePzR7EOlFdhLQYQ0AwanSZdTeUO0Gkc2jaZ0XUUz/6aO8ErY0wPxFd0LsEesnbd17sh6bIPJni/B28jNBWkhxjJLxyVvPS/I7er3pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=UaB6U8dC; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="UaB6U8dC"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250626132504epoutp02289c123ca0799af41d4e8921f25deecf~MmpFRsNLO2033320333epoutp02C
	for <nvdimm@lists.linux.dev>; Thu, 26 Jun 2025 13:25:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250626132504epoutp02289c123ca0799af41d4e8921f25deecf~MmpFRsNLO2033320333epoutp02C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1750944304;
	bh=BZravr6m8BwxDQ2S15yIrqtjocRrXzncjfWcHqXaNWU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=UaB6U8dCBzTuMggMVm82jzvAigHaUp5A1fE0MAv7dPAr0WSCwbiCRmhL3E6Sq1yae
	 l2L/b31zA57uMDDSnCFtFyGa+oJFB+SrjTS+MAbm8DAMKYdWniGrVWXdUxDaN0+kBr
	 KI0K6U+aLdy5KmRMV9gCRDE93EbrZ3ibn+HUlTZc=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250626132503epcas5p38b58c5a252de9529e19ea5d0cdb55382~MmpEYv_gW2725427254epcas5p3o;
	Thu, 26 Jun 2025 13:25:03 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4bSfYq0Yy0z6B9m5; Thu, 26 Jun
	2025 13:25:03 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250626104134epcas5p27b6a8dee21a1412ec167038fc99efa9d~MkaVtJxSR2696726967epcas5p23;
	Thu, 26 Jun 2025 10:41:34 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250626104132epsmtip2189feedbbc357813ae1f8562773c6756~MkaTFUtLG2065120651epsmtip2b;
	Thu, 26 Jun 2025 10:41:31 +0000 (GMT)
Date: Thu, 26 Jun 2025 16:11:27 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: dan.j.williams@intel.com, dave@stgolabs.net, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com,
	a.manzanares@samsung.com, nifan.cxl@gmail.com, anisa.su@samsung.com,
	vishak.g@samsung.com, krish.reddy@samsung.com, arun.george@samsung.com,
	alok.rathore@samsung.com, neeraj.kernel@gmail.com,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, gost.dev@samsung.com, cpgs@samsung.com
Subject: Re: [RFC PATCH 18/20] cxl/pmem: Add support of cxl lsa 2.1 support
 in cxl pmem
Message-ID: <1983025922.01750944303051.JavaMail.epsvc@epcpadp1new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250623104816.00005075@huawei.com>
X-CMS-MailID: 20250626104134epcas5p27b6a8dee21a1412ec167038fc99efa9d
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----khSVV-i..9Pu.R11es4dz00o5VXKnjNJAECuEWvD2h73785l=_6a2d8_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250617124058epcas5p2324bd3b1bf95d47f553d90fdc727e50d
References: <20250617123944.78345-1-s.neeraj@samsung.com>
	<CGME20250617124058epcas5p2324bd3b1bf95d47f553d90fdc727e50d@epcas5p2.samsung.com>
	<592959754.121750165383213.JavaMail.epsvc@epcpadp2new>
	<20250623104816.00005075@huawei.com>

------khSVV-i..9Pu.R11es4dz00o5VXKnjNJAECuEWvD2h73785l=_6a2d8_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 23/06/25 10:48AM, Jonathan Cameron wrote:
>On Tue, 17 Jun 2025 18:09:42 +0530
>Neeraj Kumar <s.neeraj@samsung.com> wrote:
>
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
>> +	if (!nvdimm)
>> +		return -ENOTTY;
>
>As with other checks like this, it is useful to add a comment on when you can
>call this function with a null parameter.
>

Sure, Will fix it accordingly

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
>> +	} else {
>> +		dev_dbg(&cxlmd->dev, "Region Creation is not supported with iw > 1\n");
>> +	}
>
>Flip logic to check for unhandled case first and also return an error if this happens
>rather than silently carrying on. dev_info() is appropriate here.
>

Thanks, Will fix it in V1

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
>>  	set_bit(NDD_REGISTER_SYNC, &flags);
>>  	set_bit(ND_CMD_GET_CONFIG_SIZE, &cmd_mask);
>>  	set_bit(ND_CMD_GET_CONFIG_DATA, &cmd_mask);
>> @@ -86,6 +144,7 @@ static int cxl_nvdimm_probe(struct device *dev)
>>  		return -ENOMEM;
>>
>>  	dev_set_drvdata(dev, nvdimm);
>> +	create_pmem_region(nvdimm);
>>  	return devm_add_action_or_reset(dev, unregister_nvdimm, nvdimm);
>>  }
>>
>

------khSVV-i..9Pu.R11es4dz00o5VXKnjNJAECuEWvD2h73785l=_6a2d8_
Content-Type: text/plain; charset="utf-8"


------khSVV-i..9Pu.R11es4dz00o5VXKnjNJAECuEWvD2h73785l=_6a2d8_--

