Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7EC33491D6
	for <nvdimm@lists.linux.dev>; Sun, 11 Jan 2026 15:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768145114; cv=none; b=UUtu2Hiq3sSjdB0NAjlkvZHGxK2UjkzSDxEu08lth95dB9obBiF0YYfj0s9fG6q2oHO4vJi7JA6ES+DtI6/6bwPbXBwtBJH3Io62BaVExF7D5gedpvIGKeCsYuWks/DRh7JOZhpI4f4F9xqMf2+tislqBcsy+6o9atC3YRxFc0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768145114; c=relaxed/simple;
	bh=ZGvv/jN2mnFSqyIQ6f3FBYUjMfKAEJzesX1oC4GOU4U=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=hHHGbYqS9sjh36lGDGFVzLrcMnB9eQwrQxDuvealkxNFyVUPkKnMX207KJ0zPkkx8lpKtoGaXBEr5IwlRwl/N5c7OqErVuDhnKtDllOshLkDDtS4CnF0led6q+w+mtecw/S9TSa8rKuwE9NM5A1pYmJEDFDc2LnZr1bAxN243hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ULFsvTHz; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ULFsvTHz"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260111152503epoutp04980beb565bbdbfae3cc46d5da8b78c89~Jtpp4KUm92110721107epoutp04d
	for <nvdimm@lists.linux.dev>; Sun, 11 Jan 2026 15:25:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260111152503epoutp04980beb565bbdbfae3cc46d5da8b78c89~Jtpp4KUm92110721107epoutp04d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1768145103;
	bh=mGhAxIIgLGqw1GI+bdorgcr2FRMWN12t/i7XuBasFoU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ULFsvTHzmiy59OuGi9mQ8WVcNcmNT/nkqf8nJkMeC5OHsLndnH3MD2sa19PLCzUt3
	 +LcFB5oWGyg+SmFWHDaG1Rcba8dP543hwrSl0LhOycwEIb+h4k0+y7uLrovve0+eF+
	 9kCML1II8oIwNcVP40JYvX4XEfANlYKzeG/Ss86w=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20260111152502epcas5p13b1a07595b910799c7083bdc4ca20075~JtppGts601468814688epcas5p15;
	Sun, 11 Jan 2026 15:25:02 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4dpzpQ2xcGz3hhT4; Sun, 11 Jan
	2026 15:25:02 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20260109114642epcas5p417f8dea12514b41f57ca09160a4814c7~JDYcNZhhn2049120491epcas5p4K;
	Fri,  9 Jan 2026 11:46:42 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260109114640epsmtip1f4ec738ce85ceb9ad974eea244e6669d~JDYaolq5M0462104621epsmtip1L;
	Fri,  9 Jan 2026 11:46:40 +0000 (GMT)
Date: Fri, 9 Jan 2026 17:16:32 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V4 03/17] nvdimm/label: Add namespace/region label
 support as per LSA 2.1
Message-ID: <1983025922.01768145102396.JavaMail.epsvc@epcpadp1new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <01438ef7-c97b-4a20-9b65-7ae0958db213@intel.com>
X-CMS-MailID: 20260109114642epcas5p417f8dea12514b41f57ca09160a4814c7
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----uUAw3F.Lk_UAUO08rJsbYBgyLSlm5c8z3L48n3TH2NgWyj3Z=_e544a_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20251119075311epcas5p1af6f86ca65fd4a8452979e861b87a841
References: <20251119075255.2637388-1-s.neeraj@samsung.com>
	<CGME20251119075311epcas5p1af6f86ca65fd4a8452979e861b87a841@epcas5p1.samsung.com>
	<20251119075255.2637388-4-s.neeraj@samsung.com>
	<01438ef7-c97b-4a20-9b65-7ae0958db213@intel.com>

------uUAw3F.Lk_UAUO08rJsbYBgyLSlm5c8z3L48n3TH2NgWyj3Z=_e544a_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 19/11/25 08:51AM, Dave Jiang wrote:
>
>
>On 11/19/25 12:52 AM, Neeraj Kumar wrote:
>> Modify __pmem_label_update() to update region labels into LSA
>>
>> CXL 3.2 Spec mentions CXL LSA 2.1 Namespace Labels at section 9.13.2.5
>> Modified __pmem_label_update() using setter functions to update
>> namespace label as per CXL LSA 2.1
>>
>> Create export routine nd_region_label_update() used for creating
>> region label into LSA. It will be used later from CXL subsystem
>>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>
>A few nits below, otherwise
>Reviewed-by: Dave Jiang <dave.jiang@intel.com>
>
>
>> ---
>>  drivers/nvdimm/label.c          | 360 ++++++++++++++++++++++++++------
>>  drivers/nvdimm/label.h          |  17 +-
>>  drivers/nvdimm/namespace_devs.c |  25 ++-
>>  drivers/nvdimm/nd.h             |  66 ++++++
>>  include/linux/libnvdimm.h       |   8 +
>>  5 files changed, 406 insertions(+), 70 deletions(-)
>>
>> +static unsigned long find_slot(struct nvdimm_drvdata *ndd,
>> +			       unsigned long label)
>> +{
>> +	unsigned long base;
>> +
>> +	base = (unsigned long) nd_label_base(ndd);
>
>No need for space after casting

Fixed it in V5

>
>> +	return (label - base) / sizeof_namespace_label(ndd);
>> +}

<snip>

>> +static int __pmem_label_update(struct nd_region *nd_region,
>> +			       struct nd_mapping *nd_mapping,
>> +			       struct nd_namespace_pmem *nspm,
>> +			       int pos, unsigned long flags,
>> +			       enum label_type ltype)
>> +{
>> +	struct nd_interleave_set *nd_set = nd_region->nd_set;
>> +	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
>> +	struct nd_namespace_index *nsindex;
>> +	struct nd_label_ent *label_ent;
>> +	union nd_lsa_label *lsa_label;
>> +	unsigned long *free;
>> +	struct device *dev;
>> +	u32 nslot, slot;
>> +	size_t offset;
>> +	int rc;
>> +
>> -	nd_dbg_dpa(nd_region, ndd, res, "\n");
>> +	lsa_label = to_lsa_label(ndd, slot);
>> +	memset(lsa_label, 0, sizeof_namespace_label(ndd));
>> +
>> +	switch (ltype) {
>> +	case NS_LABEL_TYPE:
>> +		dev = &nspm->nsio.common.dev;
>> +		rc = namespace_label_update(nd_region, nd_mapping,
>> +				nspm, pos, flags, &lsa_label->ns_label,
>> +				nsindex, slot);
>> +		if (rc)
>> +			return rc;
>> +
>> +		break;
>> +	case RG_LABEL_TYPE:
>> +		dev = &nd_region->dev;
>> +		region_label_update(nd_region, &lsa_label->region_label,
>> +				    nd_mapping, pos, flags, slot);
>
>inconsistent tabbing this one vs the case above. Should pick the one that conforms to the rest of this file. And yeah I get it. The tab formatting under nvdimm is different than CXL and it's a pain going between the two.
>
>DJ

Thanks Dave, I have fixed it in V5, Will be sending it soon


Regards,
Neeraj

------uUAw3F.Lk_UAUO08rJsbYBgyLSlm5c8z3L48n3TH2NgWyj3Z=_e544a_
Content-Type: text/plain; charset="utf-8"


------uUAw3F.Lk_UAUO08rJsbYBgyLSlm5c8z3L48n3TH2NgWyj3Z=_e544a_--

