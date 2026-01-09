Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C6835A940
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 12:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960431; cv=none; b=tmbcSNSlE+sX4bQZemcd2+l5vZASPIvj+z3fQpKxd8qkFgwwKA+3L8okxQUu7p/JjLQrf3XIc9lbjKaQXQRbF8Hf2m1B9BTys2jQGtctjmgcDn7GVBJJA1XG7M5kUvLPTI/c+cskOLuTHdcV8P6E7kYaaBeHrU8WIxykuUi2/jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960431; c=relaxed/simple;
	bh=uRexJN5m+iTwYKQ0aoLN4VCCdmfOutsrO1Xo2sUeej4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=AT+p9zqW4LrBm+xbSrQVrhjFdCEHQhAqRQ6JS5PApWLwF1U9IaAKcsYcZQCXAhs7ZDxH2OcSM5YhTUMCDx760uOWV5F+oRLi5B5HWO/Cx6YhE+V97/ttPrDijajab7B6tm0rw89okWNVcDaI0jlaN8Vxv8WgwZeHJax3nKiEAw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=edfvnjO3; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="edfvnjO3"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260109120701epoutp04d10b5a708b16ae0a0d9579f34c7b23d6~JDqL5c_RR0738807388epoutp04y
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 12:07:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260109120701epoutp04d10b5a708b16ae0a0d9579f34c7b23d6~JDqL5c_RR0738807388epoutp04y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1767960421;
	bh=rdevTLyaG7/FSHr/LXRGbGj1KmSWqm9J8zjckSLzDXM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=edfvnjO38SgdQ/2a6kAsYLSP3il6Nbwz/ePjXJG3wDqTiD6t8Y4QbwrrtfTYFj6iF
	 ObBYwaDPEo1F9FbBYA9bv2e6MOtfjeZN3/0rggZHe4cdrP9I8HiHp7yU/cs9QAy4gv
	 gJ/b7Qjvbz/oOpH9IhJiaTnMWZGHgS7WxYWCL05c=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20260109120701epcas5p4eae33d4cd33c1b3bf28b5856b629adb9~JDqLdnHJh0968809688epcas5p4Z;
	Fri,  9 Jan 2026 12:07:01 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.91]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4dngVr1sl4z3hhT4; Fri,  9 Jan
	2026 12:07:00 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260109120659epcas5p25e986e06608466d2b4f99a055295ff55~JDqJ5Y21F0344903449epcas5p2G;
	Fri,  9 Jan 2026 12:06:59 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260109120656epsmtip2d5b0c17b84697dc15b18d868b54ff8d2~JDqHLGonJ2728727287epsmtip2V;
	Fri,  9 Jan 2026 12:06:56 +0000 (GMT)
Date: Fri, 9 Jan 2026 17:36:48 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V4 08/17] nvdimm/label: Preserve cxl region information
 from region label
Message-ID: <20260109120648.ndlr3qdzzqku3dzc@test-PowerEdge-R740xd>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20251217150909.00003f98@huawei.com>
X-CMS-MailID: 20260109120659epcas5p25e986e06608466d2b4f99a055295ff55
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----IrfruICR4kMULzJWPGPqiSt5VhS9eUGYkVmPB-DHhmy0YhYM=_e5cb4_"
CMS-TYPE: 105P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251119075321epcas5p19665a54028ce13d8c1af3f00c0834fc7
References: <20251119075255.2637388-1-s.neeraj@samsung.com>
	<CGME20251119075321epcas5p19665a54028ce13d8c1af3f00c0834fc7@epcas5p1.samsung.com>
	<20251119075255.2637388-9-s.neeraj@samsung.com>
	<20251217150909.00003f98@huawei.com>

------IrfruICR4kMULzJWPGPqiSt5VhS9eUGYkVmPB-DHhmy0YhYM=_e5cb4_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 17/12/25 03:09PM, Jonathan Cameron wrote:
>On Wed, 19 Nov 2025 13:22:46 +0530
>Neeraj Kumar <s.neeraj@samsung.com> wrote:
>
>> Preserve region information from region label during nvdimm_probe. This
>> preserved region information is used for creating cxl region to achieve
>> region persistency across reboot.
>>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>Trivial comments inline.  As Dave asked, what's the plan for multiple?

Multi-interleave support will require some more efforts on top of this change
So will take it in another series.
Yes, I will prepare in next patch series


>Add some brief notes to the patch description on this.

Yes, I have updated it in commit description

>
>Thanks,
>
>Jonathan
>
>> ---
>>  drivers/nvdimm/dimm.c     |  4 ++++
>>  drivers/nvdimm/label.c    | 40 +++++++++++++++++++++++++++++++++++++++
>>  drivers/nvdimm/nd-core.h  |  2 ++
>>  drivers/nvdimm/nd.h       |  1 +
>>  include/linux/libnvdimm.h | 14 ++++++++++++++
>>  5 files changed, 61 insertions(+)
>>
>>

<snip>

>> +int nvdimm_cxl_region_preserve(struct nvdimm_drvdata *ndd)
>> +{
>> +	struct nvdimm *nvdimm = to_nvdimm(ndd->dev);
>> +	struct cxl_pmem_region_params *p = &nvdimm->cxl_region_params;
>> +	struct nd_namespace_index *nsindex;
>> +	unsigned long *free;
>> +	u32 nslot, slot;
>> +
>> +	if (!preamble_current(ndd, &nsindex, &free, &nslot))
>> +		return 0; /* no label, nothing to preserve */
>> +
>> +	for_each_clear_bit_le(slot, free, nslot) {
>> +		union nd_lsa_label *lsa_label;
>> +		struct cxl_region_label *region_label;
>> +		uuid_t *region_uuid;
>> +
>> +		lsa_label = to_lsa_label(ndd, slot);
>> +		region_label = &lsa_label->region_label;
>> +		region_uuid = (uuid_t *) &region_label->type;
>> +
>		union nd_lsa_label *lsa_label = to_lsa_label(ndd, slot);
>		struct cxl_region_label *region_label = &lsa_label->region_label;
>//I'd go long on thi sone as only just over 80 and helps readability.
>		uuid_t *region_uuid = (uuid_t *)&region_label->type;
>
>Saves a fine lines and there doesn't seem to be an obvious reason
>not to do so.

I have fixed in V5, Will be sending it soon.


Regards,
Neeraj

------IrfruICR4kMULzJWPGPqiSt5VhS9eUGYkVmPB-DHhmy0YhYM=_e5cb4_
Content-Type: text/plain; charset="utf-8"


------IrfruICR4kMULzJWPGPqiSt5VhS9eUGYkVmPB-DHhmy0YhYM=_e5cb4_--
