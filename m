Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04A1243954
	for <nvdimm@lists.linux.dev>; Mon,  6 Oct 2025 04:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759726392; cv=none; b=u9vOflS972t0DTumq2zpkvesdYBagM18CT1srPH0Yx/3h8BSj1nUNFb4ysShsiBEYGBR0PXr0HGW5cCjUPIj7BtkUNVglY5euCesJ9uc7+/hHudfcNAZxWX2LR7gal1Hf5O5mHE9zxNf8TDyJaYbCb8b+ItIWTXeJx9h/xS9Vd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759726392; c=relaxed/simple;
	bh=bB8lXHtxqfS+fdpFNaWAp+DJiVW2XoK5tnn7M+B86sg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=KuqoRPYWEkrnX0tHeuVSgo9jKJ7WYQTVOeBPfdZpgJ1bTxzNbNkP0dXqwEjAvKg3JUhXKFdCQVpsRpNYLwKmv4yC7qBkFXGZUF9ELd6RBH094xu10F0VxPUz3VjjiwA6xk+D+Q4QC2DomqqmDv+mtODkCWGrAdXVSv/CK78RF58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ewwXeYac; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ewwXeYac"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20251006045302epoutp01723ff9294604fed5f33552e78d76986b~rzdJOrjqJ1645516455epoutp01n
	for <nvdimm@lists.linux.dev>; Mon,  6 Oct 2025 04:53:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20251006045302epoutp01723ff9294604fed5f33552e78d76986b~rzdJOrjqJ1645516455epoutp01n
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1759726382;
	bh=P8Ap2nenQD/ZlTmI7JEx6gWSeN93yDfxYIpIXIUq7G8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ewwXeYacqHIA7pNa2CUuMfE/LdLjn9KXSAyl5bFfBMt9mAip7A7kN32Gt25YJWEPS
	 /KW3octGZamaMsWguUHsYBT+n0mdPQkEUhl4MRTZXYIcjTYm66MAf5YUj3ElrGYhzP
	 +RPKxOqojn+Q5AsRZnzzQzFlok7EIph3X3H0S5B8=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20251006045301epcas5p21033f129ba94673059bf9de1d69d1e5d~rzdIs2yuA2735427354epcas5p21;
	Mon,  6 Oct 2025 04:53:01 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4cg6Mx6s2Qz3hhT8; Mon,  6 Oct
	2025 04:53:01 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250929131803epcas5p27baf405afe5d27dc0ce7747e448cd260~pw1FuHfUY1664816648epcas5p2i;
	Mon, 29 Sep 2025 13:18:03 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250929131802epsmtip2b28658157e12f8d0997d2ad8166dbec1~pw1EbwW491869118691epsmtip2B;
	Mon, 29 Sep 2025 13:18:02 +0000 (GMT)
Date: Mon, 29 Sep 2025 18:47:56 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com, Jonathan Cameron <jonathan.cameron@huawei.com>
Subject: Re: [PATCH V3 08/20] nvdimm/label: Include region label in slot
 validation
Message-ID: <1296674576.21759726381948.JavaMail.epsvc@epcpadp2new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <12f7fbd9-c35f-4ebf-809f-43f8ab240413@intel.com>
X-CMS-MailID: 20250929131803epcas5p27baf405afe5d27dc0ce7747e448cd260
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----fevm_dXp0U54qslEOU8oiqO.VnigTQz743t4hqwhjBnK2JlQ=_735e_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250917134144epcas5p498fb4b005516fca56e68533ce017fba0
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
	<CGME20250917134144epcas5p498fb4b005516fca56e68533ce017fba0@epcas5p4.samsung.com>
	<20250917134116.1623730-9-s.neeraj@samsung.com>
	<12f7fbd9-c35f-4ebf-809f-43f8ab240413@intel.com>

------fevm_dXp0U54qslEOU8oiqO.VnigTQz743t4hqwhjBnK2JlQ=_735e_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 22/09/25 03:17PM, Dave Jiang wrote:
>>  static void region_label_calculate_checksum(struct nvdimm_drvdata *ndd,
>>  				   struct cxl_region_label *region_label)
>>  {
>> @@ -392,16 +404,30 @@ static void region_label_calculate_checksum(struct nvdimm_drvdata *ndd,
>>  }
>>
>>  static bool slot_valid(struct nvdimm_drvdata *ndd,
>> -		struct nd_namespace_label *nd_label, u32 slot)
>> +		       union nd_lsa_label *lsa_label, u32 slot)
>>  {
>> +	struct cxl_region_label *region_label = &lsa_label->region_label;
>> +	struct nd_namespace_label *nd_label = &lsa_label->ns_label;
>> +	char *label_name;
>>  	bool valid;
>>
>>  	/* check that we are written where we expect to be written */
>> -	if (slot != nsl_get_slot(ndd, nd_label))
>> -		return false;
>> -	valid = nsl_validate_checksum(ndd, nd_label);
>> +	if (is_region_label(ndd, lsa_label)) {
>> +		label_name = "rg";
>
>I suggest create a static string table enumerated by 'enum label_type'. That way you can directly address it by 'label_name[ltype]' when being used instead of assigning at run time. And maybe just use "region" and "namespace" since it's for debug output and we don't need to shorten it.
>
>DJ

Sure Dave, Thanks for your suggestion. I will fix it accordingly

Regards,
Neeraj

------fevm_dXp0U54qslEOU8oiqO.VnigTQz743t4hqwhjBnK2JlQ=_735e_
Content-Type: text/plain; charset="utf-8"


------fevm_dXp0U54qslEOU8oiqO.VnigTQz743t4hqwhjBnK2JlQ=_735e_--

