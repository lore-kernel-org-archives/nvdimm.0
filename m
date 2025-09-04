Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D32C31F4174
	for <nvdimm@lists.linux.dev>; Thu,  4 Sep 2025 14:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756996398; cv=none; b=oFXce6QVV32X2Apdww3NUi3/ZSWhJoeVUZf1APmRf01VgdDJKzU8xc7Eb2toQtyZODl/lpwlUr4xCNHQZjmvVBzQClLkHj7BD8o6vrN48GjZU8ifIhwvxoSkxojRurNjYcsUW0tEgPm3tEIZe1WCUHDX34RaMqcRu3DZV3zIwhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756996398; c=relaxed/simple;
	bh=vnRpksgHDra3aFjpAq8lvuZTA4gqo3GRgDjM2B/DuKs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=YEUa373k634OlmsP17VA9RdTz2wsGXl5d4yd5xvjP7eSXudLZffj/oR1Ujw4K+d2XzNokJapiYZW7w/S9CBzBQqnvLuc5MWYsDOFV+8Kb0BjcMAT9ikgo6nmUl7rq/oF/vQ9quaKG4AKI1Zgu5uFGexr7AX0AWKffXbhaQ1eUYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=oOY+GfeX; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="oOY+GfeX"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250904143314epoutp03d00dd8b65d75008f50f80fe199fe7f26~iGumA4NS70054500545epoutp03C
	for <nvdimm@lists.linux.dev>; Thu,  4 Sep 2025 14:33:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250904143314epoutp03d00dd8b65d75008f50f80fe199fe7f26~iGumA4NS70054500545epoutp03C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1756996394;
	bh=vEI3EFqpSL/FIn9LeCFRV4ETWOeFp+v55xbZpeQTFFo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=oOY+GfeXG/CxzZlIA6SP8l2g5qfMBwAxtuM3ANf+uFI2I7vrrDWA+7mx2QTWeEqeW
	 /D8NJuHVzdyMM3wZNhXjFqS1DH5L5Q2Co1Em+aGY+BgVCSjpBFHgKGtjBHuHMUo6+E
	 wYXP6Z2iqkGYMLDlGLXLHuNOUVF0MT/d7s+w9lRU=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250904143314epcas5p3a49e50668d3ff90489caa834a9affa59~iGulwPdKs0983109831epcas5p3z;
	Thu,  4 Sep 2025 14:33:14 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.93]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4cHhm94Djzz3hhT4; Thu,  4 Sep
	2025 14:33:13 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250904143312epcas5p464dd524fcc0d351fb6588ba6b4443b31~iGuj7L-Nc3176231762epcas5p4i;
	Thu,  4 Sep 2025 14:33:12 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250904143311epsmtip17c4b757c8b3220abaa2347c915c6484a~iGuiySKLe0814508145epsmtip1I;
	Thu,  4 Sep 2025 14:33:11 +0000 (GMT)
Date: Thu, 4 Sep 2025 20:03:06 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V2 10/20] nvdimm/region_label: Preserve cxl region
 information from region label
Message-ID: <20250904143306.kdchc4yw7cf2j7qu@test-PowerEdge-R740xd>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250813161151.00006d59@huawei.com>
X-CMS-MailID: 20250904143312epcas5p464dd524fcc0d351fb6588ba6b4443b31
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----kMDsK0IEhKoUUkzyxABlnve5J-Otg2bCPR2yRM97vA1oUAWq=_ea89d_"
CMS-TYPE: 105P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250730121235epcas5p4494147524e77e99bc16d9b510e8971a4
References: <20250730121209.303202-1-s.neeraj@samsung.com>
	<CGME20250730121235epcas5p4494147524e77e99bc16d9b510e8971a4@epcas5p4.samsung.com>
	<20250730121209.303202-11-s.neeraj@samsung.com>
	<20250813161151.00006d59@huawei.com>

------kMDsK0IEhKoUUkzyxABlnve5J-Otg2bCPR2yRM97vA1oUAWq=_ea89d_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 13/08/25 04:11PM, Jonathan Cameron wrote:
>On Wed, 30 Jul 2025 17:41:59 +0530
>Neeraj Kumar <s.neeraj@samsung.com> wrote:
>
>> Preserve region information from region label during nvdimm_probe. This
>> preserved region information is used for creating cxl region to achieve
>> region persistency across reboot.
>>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>
>See below.
>
>> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
>> index 064a945dcdd1..bcac05371f87 100644
>> --- a/drivers/nvdimm/label.c
>> +++ b/drivers/nvdimm/label.c
>> @@ -473,6 +473,47 @@ int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
>>  	return 0;
>>  }
>>
>> +int nvdimm_cxl_region_preserve(struct nvdimm_drvdata *ndd)
>> +{
>> +	struct nvdimm *nvdimm = to_nvdimm(ndd->dev);
>> +	struct cxl_pmem_region_params *params = &nvdimm->cxl_region_params;
>> +	struct nd_namespace_index *nsindex;
>> +	unsigned long *free;
>> +	u32 nslot, slot;
>> +
>> +	if (!preamble_current(ndd, &nsindex, &free, &nslot))
>> +		return 0; /* no label, nothing to preserve */
>> +
>> +	for_each_clear_bit_le(slot, free, nslot) {
>> +		struct nd_lsa_label *nd_label;
>> +		struct cxl_region_label *rg_label;
>> +		uuid_t rg_type, region_type;
>> +
>> +		nd_label = to_label(ndd, slot);
>> +		rg_label = &nd_label->rg_label;
>> +		uuid_parse(CXL_REGION_UUID, &region_type);
>> +		import_uuid(&rg_type, nd_label->rg_label.type);
>> +
>> +		/* REVISIT: Currently preserving only one region */
>
>In practice, is this a significant issue or not?  I.e. should we not
>merge this series until this has been revisited?

As currently we have support of Interleave way == 1, thats why this
REVISIST. I will remove this, as its not significant issue for merging this series


Regards,
Neeraj

------kMDsK0IEhKoUUkzyxABlnve5J-Otg2bCPR2yRM97vA1oUAWq=_ea89d_
Content-Type: text/plain; charset="utf-8"


------kMDsK0IEhKoUUkzyxABlnve5J-Otg2bCPR2yRM97vA1oUAWq=_ea89d_--
