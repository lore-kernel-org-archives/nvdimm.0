Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBFBA2D46B4
	for <nvdimm@lists.linux.dev>; Fri,  5 Sep 2025 07:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757055789; cv=none; b=ARQWcZ/bA0uKPg5xoOlBbekeAd1eFKBMDt251DHDSpyWcEdsIeCkcOLdwCXassyr4wX/J0HYC3W35cgz8qVH8lBOViyZQK0xF2aPyYqO3jWXVRcnde8BaRM0eD8ylXvuqOC466KNMsHP+7wqA8f0LHCPDxMj+HtSj4uuNCaP+Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757055789; c=relaxed/simple;
	bh=XMJVFVxRmh3peicYbuF2su+FZK1Muiig8ssiRVbYBOs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=VPiTaIhbDHzTUicHOGITzkcspn87dEfC+/dgdAcP+cluqWJ2RywUxD/86ULgDnk9v5sEEKwbu6D7oSnMKq9kPVoAA8Pa5R8OmtqMMfKHMMSbUd9h9LIVwTorULwxrItvQdLkmAJnSn9KpwE/BUikBU5N515plglnvELZGNXxqHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=eDgvczZg; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="eDgvczZg"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250905070304epoutp04a6cc41d191c5f7d9dd5b88e64e9f9a3a~iUO1Ujhfc2251722517epoutp04a
	for <nvdimm@lists.linux.dev>; Fri,  5 Sep 2025 07:03:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250905070304epoutp04a6cc41d191c5f7d9dd5b88e64e9f9a3a~iUO1Ujhfc2251722517epoutp04a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1757055784;
	bh=DAf7IFgHBvJDfZgahFooC6ZDHHY5mojc5Pt4LAfJBqI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=eDgvczZgIORsWJwp3BltKDN6mX593KLO3a4NUZlRR5+HO7pLzp2/mdben03Edh3rc
	 ego4yKyv4GJ36XkIzjNYoORvfwJ2T7KSFm5FOkFS+a6q8KpDilB/guio5ssZBtBblc
	 NZfN/0LRSN6qc1aKBD2dYQ3Coa5JaBlQzs/aAktE=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250905070304epcas5p39c0032908b488c386cbe535766d8e214~iUO03IwUR3104231042epcas5p3E;
	Fri,  5 Sep 2025 07:03:04 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4cJ6kJ2XsWz2SSKv; Fri,  5 Sep
	2025 07:03:04 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250904143941epcas5p3bf2c74895a2fc6b54606dcd189bc9fc5~iG0N0S1192088120881epcas5p3Q;
	Thu,  4 Sep 2025 14:39:41 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250904143939epsmtip15e39fdf391bd9e426d283533cfe902f9~iG0Mr1S470742607426epsmtip1z;
	Thu,  4 Sep 2025 14:39:39 +0000 (GMT)
Date: Thu, 4 Sep 2025 20:09:33 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V2 13/20] cxl/mem: Refactor cxl pmem region
 auto-assembling
Message-ID: <1256440269.161757055784348.JavaMail.epsvc@epcpadp2new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <c22affa9-1dad-4a66-8db8-8e268806e0a1@intel.com>
X-CMS-MailID: 20250904143941epcas5p3bf2c74895a2fc6b54606dcd189bc9fc5
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----AO5Z5CA5q82FpJQJAbIGDvoW6m12ppu.cCYhbwpEEtg295OJ=_eadef_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250730121239epcas5p37956b2999f61e17e8dbfbde7972cef35
References: <20250730121209.303202-1-s.neeraj@samsung.com>
	<CGME20250730121239epcas5p37956b2999f61e17e8dbfbde7972cef35@epcas5p3.samsung.com>
	<20250730121209.303202-14-s.neeraj@samsung.com>
	<c22affa9-1dad-4a66-8db8-8e268806e0a1@intel.com>

------AO5Z5CA5q82FpJQJAbIGDvoW6m12ppu.cCYhbwpEEtg295OJ=_eadef_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 20/08/25 09:41AM, Dave Jiang wrote:
>
>
>On 7/30/25 5:12 AM, Neeraj Kumar wrote:
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
>> 2. Moved cxl pmem region auto-assembly from cxl_endpoint_port_probe() to
>>    cxl_mem_probe() after devm_cxl_add_nvdimm(). It gurantees both the
>>    completion of endpoint probe and cxl_nvd presence before its call.
>
>So there are a few issues with doing this. If cxl_endpoint_port_probe() fails, you won't know that while running in cxl_mem_probe(). So you may need to do something similar to here [1] in order to make the probe synchronous with the add endpoint and make sure that the port driver attached successfully.

Hi Dave,
devm_cxl_add_endpoint() makes sure cxl_endpoint_port_probe() has
completed successfully, as per below check in devm_cxl_add_endpoint()

	if (!endpoint->dev.driver) {
		dev_err(&cxlmd->dev, "%s failed probe\n", dev_name(&endpoint->dev));
		return -ENXIO;
	}

Above check confirms synchronous probe completion of cxl_endpoint_port_probe() and port
driver attachment.

> Specifically see changes to devm_cxl_add_memdev().
>
>Also, in endpoint port probe you are holding the device lock and therefore is protected from port removals (endpoint and parents) while you are trying to scan for regions. That is not the case on the memdev probe side if you aren't holding that port lock.
>
>[1]: https://git.kernel.org/pub/scm/linux/kernel/git/cxl/cxl.git/commit/?h=for-6.18/cxl-probe-order&id=88aec5ea7a24da00dc92c7778df4851fe4fd3ec6
>
>DJ

Sure, I will go through [1] and its devm_cxl_add_memdev() implementation.
And see if any changes required as per your suggestion.


Regards,
Neeraj

------AO5Z5CA5q82FpJQJAbIGDvoW6m12ppu.cCYhbwpEEtg295OJ=_eadef_
Content-Type: text/plain; charset="utf-8"


------AO5Z5CA5q82FpJQJAbIGDvoW6m12ppu.cCYhbwpEEtg295OJ=_eadef_--

