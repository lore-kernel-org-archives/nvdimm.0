Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577DF155CB3
	for <nvdimm@lists.linux.dev>; Sat, 19 Jul 2025 07:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752909487; cv=none; b=lArLpLMaRX9fcnnd7fP2XP+JVujV6G7j6/jvPGTCNwi306dF5WEuOgw2DbBSObuAZfylUcAR+/qLOnmoyFi+P3dHzEVuxMVdlZzKfzd1dQ7soJj9OuubPrOca3kyfS7JGF9DOG7Py3ZyoIQCr/RqxhLdkqDhMRaAspMNrqR0pYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752909487; c=relaxed/simple;
	bh=3cmT1pWAFDbE5NF6d1Wsm8iDto8df8XwxPMrpnoks6M=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=JftrWrjqLH/WXh0IfeL+LjWHvpqBQa7xZ4w6L5i7AUYSHMom2Cum4/tauAAmBExosPt8rgMdSfzmp2HVDvt9dhxKJdMI7ryn6tCn8ItLIn8qNk3cQtbZNmmOTxLWa2NSWnptQjHEDkAvdAOLL1mKXgWZ9/wDzEV/0h03vvUcX6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=UBLhA+gW; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="UBLhA+gW"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250719071803epoutp04a1f514a223c8b37e3d75946f62e07dad~TleNJ10N91411014110epoutp04q
	for <nvdimm@lists.linux.dev>; Sat, 19 Jul 2025 07:18:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250719071803epoutp04a1f514a223c8b37e3d75946f62e07dad~TleNJ10N91411014110epoutp04q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1752909483;
	bh=5VtKd5pTNoTFx35Tyb9Y/s5OVtWxj5VggDGtkYkWDEg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=UBLhA+gWUnEXw162rb14Juj6CWQ1jY0Ue/wvSQgcCo8axVBzh/AHW/z816NMImmL6
	 yxHbCugTofUJqullFKq0oMq/8Ol2NJbdfSi4RJAIL+k/w3O4LgVZosRux1R1ygIgrx
	 Qg8SUarHRdWV+NNc8q7M6Wajwico4gQVHSj8aDsU=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20250719071802epcas5p24e3bd11e8050a0fa267063423dc3c49e~TleMq9YeJ2908029080epcas5p2Q;
	Sat, 19 Jul 2025 07:18:02 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4bkdKk63w0z3hhT3; Sat, 19 Jul
	2025 07:18:02 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250718123059epcas5p43f7bd9372c65050f2da97880302d6b18~TWGJK0x3i2133321333epcas5p41;
	Fri, 18 Jul 2025 12:30:59 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250718123056epsmtip2c08bd22d75c4ede3df4b7d5c47fe4366~TWGGymS-m0816508165epsmtip29;
	Fri, 18 Jul 2025 12:30:56 +0000 (GMT)
Date: Fri, 18 Jul 2025 18:00:50 +0530
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
Subject: Re: [RFC PATCH 13/20] cxl/mem: Refactor cxl pmem region
 auto-assembling
Message-ID: <1931444790.41752909482841.JavaMail.epsvc@epcpadp2new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <3670eb1d-eaf5-4b8b-b3fe-1190724ee7d7@intel.com>
X-CMS-MailID: 20250718123059epcas5p43f7bd9372c65050f2da97880302d6b18
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----AO5Z5CA5q82FpJQJAbIGDvoW6m12ppu.cCYhbwpEEtg295OJ=_233c4_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250617124043epcas5p21e5b77aa3a6acfa7e01847ffd58350ed
References: <20250617123944.78345-1-s.neeraj@samsung.com>
	<CGME20250617124043epcas5p21e5b77aa3a6acfa7e01847ffd58350ed@epcas5p2.samsung.com>
	<1213349904.281750165205974.JavaMail.epsvc@epcpadp1new>
	<3670eb1d-eaf5-4b8b-b3fe-1190724ee7d7@intel.com>

------AO5Z5CA5q82FpJQJAbIGDvoW6m12ppu.cCYhbwpEEtg295OJ=_233c4_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 09/07/25 05:38PM, Dave Jiang wrote:
>
>
>On 6/17/25 5:39 AM, Neeraj Kumar wrote:
>> In 84ec985944ef3, For cxl pmem region auto-assembly after endpoint port
>> probing, cxl_nvd presence was required. And for cxl region persistency,
>> region creation happens during nvdimm_probe which need the completion
>> of endpoint probe.
>>
>> It is therefore refactored cxl pmem region auto-assembly after endpoint
>> probing to cxl mem probing
>
>The region auto-assembly is moved after the endpoint device is added. However, it's not guaranteed that the endpoint probe has completed and completed successfully. You are just getting lucky timing wise that endpoint probe is completed when the new region discovery is starting.

Hi Dave,

For region auto-assembly two things are required
  1. endpoint(s) decoder should be enumerated successfully
  2. As per fix in 84ec985944ef3, The cxl_nvd of the memdev needs to be available during the pmem region probe

Prior to current patch, region auto-assembly was happening from cxl_endpoint_port_probe() after endpoint decoder enumeration.
In 84ec985944ef3, sequence of devm_cxl_add_nvdimm() was moved before devm_cxl_add_endpoint() so as to meet region auto assembly dependency on cxl_nvd of the memdev.

Here, In this patch I have moved region auto-assembly after
  1. devm_cxl_add_endpoint(): This function makes sure cxl_endpoint_port_probe() has completed successfully, as per below check in devm_cxl_add_endpoint()
       if (!endpoint->dev.driver) {
            dev_err(&cxlmd->dev, "%s failed probe\n", dev_name(&endpoint->dev));
            return -ENXIO;
       }
       And successfull completion of cxl_endpoint_port_probe(), it must have enumerated endpoint(s) decoder successfully
  2. devm_cxl_add_nvdimm(): As you rightly said, this allocates "cxl_nvd" nvdimm device and triggers the async probe of nvdimm driver

Actually in this patch, from async probe function (cxl_nvdimm_probe()), I am creating "struct nvdimm" using __nvdimm_create()
This __nvdimm_create() ultimately scans LSA. If LSA finds region label into it then it saves region information into struct nvdimm
and then using create_pmem_region(nvdimm), I am re-creating cxl region for region persistency.

As for cxl region persistency (based on LSA 2.1 scanning - this patch)
following sequence should be required
  1. devm_cxl_add_endpoint(): endpoint probe completion - which is getting done by devm_cxl_add_endpoint()
  2. devm_cxl_add_nvdimm(): Here after nvdimm device creation, cxl region is being created

It is therefore re-sequencing of region-auto assembly is required to move from cxl_endpoint_port_probe() to after
devm_cxl_add_endpoint() and devm_cxl_add_nvdimm()

>Return of devm_cxl_add_nvdimm() only adds the nvdimm device and triggers the async probe of nvdimm driver. You have to take the endpoint port lock

I think we may not require endpoint port lock as auto-assembly and region persistency code sequence is always after successful completion of endpoint probe.

>and check if the driver is attached to be certain that endpoint probe is done and successful. Therefore moving the region discovery location probably does not do what you think it does.
>Maybe take a deeper look at the region discovery code and see how it does retry if things are not present and approach it from that angle?
>

Please let me know if my understanding is correct or am I missing something?

>>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>> ---
>>  drivers/cxl/core/port.c | 38 ++++++++++++++++++++++++++++++++++++++
>>  drivers/cxl/cxl.h       |  1 +
>>  drivers/cxl/mem.c       | 27 ++++++++++++++++++---------
>>  drivers/cxl/port.c      | 38 --------------------------------------
>>  4 files changed, 57 insertions(+), 47 deletions(-)
>>
>> diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
>> index 78a5c2c25982..bca668193c49 100644
>> --- a/drivers/cxl/core/port.c
>> +++ b/drivers/cxl/core/port.c
>> @@ -1038,6 +1038,44 @@ void put_cxl_root(struct cxl_root *cxl_root)
>>  }
>>  EXPORT_SYMBOL_NS_GPL(put_cxl_root, "CXL");
>>
>> +static int discover_region(struct device *dev, void *root)
>> +{
>> +	struct cxl_endpoint_decoder *cxled;
>> +	int rc;
>> +
>> +	if (!is_endpoint_decoder(dev))
>> +		return 0;
>> +
>> +	cxled = to_cxl_endpoint_decoder(dev);
>> +	if ((cxled->cxld.flags & CXL_DECODER_F_ENABLE) == 0)
>> +		return 0;
>> +
>> +	if (cxled->state != CXL_DECODER_STATE_AUTO)
>> +		return 0;
>> +
>> +	/*
>> +	 * Region enumeration is opportunistic, if this add-event fails,
>> +	 * continue to the next endpoint decoder.
>> +	 */
>> +	rc = cxl_add_to_region(root, cxled);
>> +	if (rc)
>> +		dev_dbg(dev, "failed to add to region: %#llx-%#llx\n",
>> +			cxled->cxld.hpa_range.start, cxled->cxld.hpa_range.end);
>> +
>> +	return 0;
>> +}
>> +
>> +void cxl_region_discovery(struct cxl_port *port)
>> +{
>> +	struct cxl_port *root;
>> +	struct cxl_root *cxl_root __free(put_cxl_root) = find_cxl_root(port);
>> +
>> +	root = &cxl_root->port;
>> +
>> +	device_for_each_child(&port->dev, root, discover_region);
>> +}
>> +EXPORT_SYMBOL_NS_GPL(cxl_region_discovery, "CXL");
>> +
>
>I have concerns about adding region related code in core/port.c while the rest of the region code is walled behind CONFIG_CXL_REGION. I think this change needs to go to core/region.c.
>
>DJ
>

Sure Dave, I will move it into core/region.c in next patch-set.

Regards,
Neeraj

------AO5Z5CA5q82FpJQJAbIGDvoW6m12ppu.cCYhbwpEEtg295OJ=_233c4_
Content-Type: text/plain; charset="utf-8"


------AO5Z5CA5q82FpJQJAbIGDvoW6m12ppu.cCYhbwpEEtg295OJ=_233c4_--

