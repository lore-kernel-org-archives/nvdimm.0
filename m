Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D3222D78A
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769166863; cv=none; b=GaEdDOSj1GEwjRdYgvNvUSHgLwgvxxJjNlqy60E9ljFaq/iLd/GWm9yQz9FAxqVnRwX1RlZ/BWOaXO+M9KudqZNFNamLow8IM/jA0WXb0g7mjdqOuo5i6NQwBj0XaTkMv5IU4nRezvWm2NYyZz2LLrE3ymHU1QDRp3mOJ2cOWeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769166863; c=relaxed/simple;
	bh=d/eveDxbocbEWGccxCTRgbIwvntn58p8F0usj4/gJ9g=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=fvUWJNmT72oytMP+54AGQj9YJB+SnJiJ7Y8fLRunxAXlbUnGUOMnlsQaR5YBE6O7YhBSN3zTXa+BgHwjIQWV5VFOTFvzb5r4bYPuRp+/a38L7FQfU5BxeEth/3m6GbhhqWuxBCbeY2bTk4i7dtzpywaMezSKclaw/HDQB9JsInY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=hq8dWILv; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="hq8dWILv"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260123111418epoutp01aea4cd372e98d86de62f30c729ab958d~NV_JJxu6y0425004250epoutp01N
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:14:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260123111418epoutp01aea4cd372e98d86de62f30c729ab958d~NV_JJxu6y0425004250epoutp01N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1769166858;
	bh=gbqeVNCtbNmpJnQQNrcAeMjM1Ie256PmRcAowgX7Ii8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=hq8dWILv0aOnfwE8qP3fXJeUChud2IX0tg720ASv7tqT5tPU6eRSzUujV2ALVuTWL
	 93mCw+gHwtv+mIYB3rzJLQStlrQdJFIe0Fc9hSa5UMceH2zdE2R6nWQcDEHI3vchtk
	 8uoubcpMOZ8sZIxOj2lbhZT/8VbP0aout431H1OY=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20260123111417epcas5p190ebca088c907fbce3e7e9f919b671af~NV_IYzonG1528215282epcas5p1k;
	Fri, 23 Jan 2026 11:14:17 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.95]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4dyFgX3HG1z6B9m5; Fri, 23 Jan
	2026 11:14:16 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20260123111415epcas5p363671a0ab6a6596f546021c3e00e071f~NV_HKTFPb0726507265epcas5p3e;
	Fri, 23 Jan 2026 11:14:15 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260123111412epsmtip19077bc2baa50ce3bcba0833a5245d4d8~NV_DoqHJR0758107581epsmtip1B;
	Fri, 23 Jan 2026 11:14:11 +0000 (GMT)
Date: Fri, 23 Jan 2026 16:44:06 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V5 10/17] cxl/mem: Refactor cxl pmem region
 auto-assembling
Message-ID: <20260123111406.jjhnppsfaazoogyk@test-PowerEdge-R740xd>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260115180857.00001476@huawei.com>
X-CMS-MailID: 20260123111415epcas5p363671a0ab6a6596f546021c3e00e071f
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----IrfruICR4kMULzJWPGPqiSt5VhS9eUGYkVmPB-DHhmy0YhYM=_11f089_"
CMS-TYPE: 105P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260109124524epcas5p11435563cce6dc392c06951bb07c8bfc3
References: <20260109124437.4025893-1-s.neeraj@samsung.com>
	<CGME20260109124524epcas5p11435563cce6dc392c06951bb07c8bfc3@epcas5p1.samsung.com>
	<20260109124437.4025893-11-s.neeraj@samsung.com>
	<20260115180857.00001476@huawei.com>

------IrfruICR4kMULzJWPGPqiSt5VhS9eUGYkVmPB-DHhmy0YhYM=_11f089_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 15/01/26 06:08PM, Jonathan Cameron wrote:
>On Fri,  9 Jan 2026 18:14:30 +0530
>Neeraj Kumar <s.neeraj@samsung.com> wrote:
>
>> In 84ec985944ef3, devm_cxl_add_nvdimm() sequence was changed and called
>> before devm_cxl_add_endpoint(). It's because cxl pmem region auto-assembly
>> used to get called at last in cxl_endpoint_port_probe(), which requires
>> cxl_nvd presence.
>>
>> For cxl region persistency, region creation happens during nvdimm_probe
>> which need the completion of endpoint probe.
>>
>> In order to accommodate both cxl pmem region auto-assembly and cxl region
>> persistency, refactored following
>>
>> 1. Re-Sequence devm_cxl_add_nvdimm() after devm_cxl_add_endpoint(). This
>>    will be called only after successful completion of endpoint probe.
>>
>> 2. Create cxl_region_discovery() which performs pmem region
>>    auto-assembly and remove cxl pmem region auto-assembly from
>>    cxl_endpoint_port_probe()
>>
>> 3. Register cxl_region_discovery() with devm_cxl_add_memdev() which gets
>>    called during cxl_pci_probe() in context of cxl_mem_probe()
>>
>> 4. As cxlmd->ops->probe() calls registered cxl_region_discovery(), so
>>    move devm_cxl_add_nvdimm() before cxlmd->ops->probe(). It guarantees
>>    both the completion of endpoint probe and cxl_nvd presence before
>>    calling cxlmd->ops->probe().
>>
>> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>
>One thing below. With that fixes,
>Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

Thanks Jonathan for RB tag

>
>
>> diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
>> index e21051d79b25..d56fdfe4b43b 100644
>> --- a/drivers/cxl/pci.c
>> +++ b/drivers/cxl/pci.c
>> @@ -907,6 +907,7 @@ static int cxl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>>  	struct cxl_memdev_state *mds;
>>  	struct cxl_dev_state *cxlds;
>>  	struct cxl_register_map map;
>> +	struct cxl_memdev_ops ops;
>
>Needs init, as there might be other stuff in there.
>	struct cxl_memdev_ops ops = {};

Now cxl_memdev_ops is changed with cxl_memdev_attach.
I have initialized it accordingly.


Regards,
Neeraj

------IrfruICR4kMULzJWPGPqiSt5VhS9eUGYkVmPB-DHhmy0YhYM=_11f089_
Content-Type: text/plain; charset="utf-8"


------IrfruICR4kMULzJWPGPqiSt5VhS9eUGYkVmPB-DHhmy0YhYM=_11f089_--
