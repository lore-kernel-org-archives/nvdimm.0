Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E598835B120
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 12:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961799; cv=none; b=PZW8ST3LZOyWUIUkecM4+kMaYW81tsHajUmwOYQeuB+ccCuxQLsLbagq0p749AHCsBlX7/lOB3aq/gQqKwV/bVY5VempM2eg0Pi+IuTgEzfkKrKLX2yILkiQTMq5E8TKeP7Ku/LutUuo5+rohcKYAOGE21a227VmCK8pDOEWKqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961799; c=relaxed/simple;
	bh=atJDgOF48BVIJuPb+gibdhLArrYx4W81Dv7cSLBybes=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=a7CbgEjdIAK0x9PjvWEFKfGu+dosAPsoXtpHKIHeP1pQJMxI5JCKXFbfxoAyMS8lCaKk0jw1KnbrB2p9KsJ+IFdVnhiOM4QgjJSblj5LuJYmRe11LDAGj87QD85tvFn+EihdTCZNFkSEI13NeskF/iXbTWlf9WKqjl5+XFCglF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=TsfLyrCC; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="TsfLyrCC"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260109122954epoutp01455876ea2b20570cf461a30898bb4b19~JD_Kr3JXp2780827808epoutp01m
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 12:29:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260109122954epoutp01455876ea2b20570cf461a30898bb4b19~JD_Kr3JXp2780827808epoutp01m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1767961794;
	bh=CDZrUdXczNEhAyd+6zBNSavkfuZuvV0KueIWowIAQjI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=TsfLyrCC42qYDLeieaFi4JZMk0qiF+mXIp4wl8jtoIlDtdG7Xa9567X7kw+tZEc4V
	 OVLgY9qUqKgdCK6WW49E4PtZhp7WYuo0OHTXxdmxqlkDXBxSl18iaU6jkvmh5gLEo3
	 XO+yuaArrHSkaJOYAhKkSoZJE1PcHtA6lpSCQSGs=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20260109122954epcas5p31bed7ca62a3f71889b5a64ffe20521fa~JD_KYqa0T1104511045epcas5p3H;
	Fri,  9 Jan 2026 12:29:54 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.91]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4dnh1F4x4sz2SSKX; Fri,  9 Jan
	2026 12:29:53 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260109122953epcas5p2106600bcba874ea07971dd97fdb9eb2d~JD_JA5l1f0870708707epcas5p2z;
	Fri,  9 Jan 2026 12:29:53 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260109122948epsmtip1791dfe25a485d0e96846c0594184bdae~JD_E8tjwv3245632456epsmtip1B;
	Fri,  9 Jan 2026 12:29:48 +0000 (GMT)
Date: Fri, 9 Jan 2026 17:59:41 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V4 14/17] cxl/pmem_region: Introduce
 CONFIG_CXL_PMEM_REGION for core/pmem_region.c
Message-ID: <20260109122941.rjbs3in6mxipbfpt@test-PowerEdge-R740xd>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20251217153847.00001e63@huawei.com>
X-CMS-MailID: 20260109122953epcas5p2106600bcba874ea07971dd97fdb9eb2d
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----bVwHse4Nykw-L2c5iRRXKf-G.8k0lxUwrpcTFjGaDb9lfltx=_e5a08_"
CMS-TYPE: 105P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251119075335epcas5p3a8fdc68301233f899d9041a300309fa2
References: <20251119075255.2637388-1-s.neeraj@samsung.com>
	<CGME20251119075335epcas5p3a8fdc68301233f899d9041a300309fa2@epcas5p3.samsung.com>
	<20251119075255.2637388-15-s.neeraj@samsung.com>
	<20251217153847.00001e63@huawei.com>

------bVwHse4Nykw-L2c5iRRXKf-G.8k0lxUwrpcTFjGaDb9lfltx=_e5a08_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 17/12/25 03:38PM, Jonathan Cameron wrote:
>On Wed, 19 Nov 2025 13:22:52 +0530
>Neeraj Kumar <s.neeraj@samsung.com> wrote:
>
>> As pmem region label update/delete has hard dependency on libnvdimm.
>> It is therefore put core/pmem_region.c under CONFIG_CXL_PMEM_REGION
>> control. It handles the dependency by selecting CONFIG_LIBNVDIMM
>> if not enabled.
>>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>
>
>> diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
>> index 5ebbc3d3dde5..beeb9b7527b8 100644
>> --- a/drivers/cxl/core/core.h
>> +++ b/drivers/cxl/core/core.h
>> @@ -89,17 +88,23 @@ static inline struct cxl_region *to_cxl_region(struct device *dev)
>>  {
>>  	return NULL;
>>  }
>> -static inline int devm_cxl_add_pmem_region(struct cxl_region *cxlr)
>> -{
>> -	return 0;
>> -}
>> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
>> index 9798120b208e..408e139718f1 100644
>> --- a/drivers/cxl/core/region.c
>> +++ b/drivers/cxl/core/region.c
>> @@ -3918,6 +3918,8 @@ static int cxl_region_probe(struct device *dev)
>>  			dev_dbg(&cxlr->dev, "CXL EDAC registration for region_id=%d failed\n",
>>  				cxlr->id);
>>
>> +		if (!IS_ENABLED(CONFIG_CXL_PMEM_REGION))
>> +			return -EINVAL;
>>  		return devm_cxl_add_pmem_region(cxlr);
>
>Why not have the stub return -EINVAL if it never makes sense to call without
>the CONFIG being enabled?

I have removed this config check and handled it in
devm_cxl_add_pmem_region() itself.



Regards,
Neeraj

------bVwHse4Nykw-L2c5iRRXKf-G.8k0lxUwrpcTFjGaDb9lfltx=_e5a08_
Content-Type: text/plain; charset="utf-8"


------bVwHse4Nykw-L2c5iRRXKf-G.8k0lxUwrpcTFjGaDb9lfltx=_e5a08_--
