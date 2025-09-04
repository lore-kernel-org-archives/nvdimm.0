Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794B22ECEB8
	for <nvdimm@lists.linux.dev>; Thu,  4 Sep 2025 13:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756992037; cv=none; b=pk2bzjyB2ZZ7b2f3kxFLt3J2yUlVpB75Yj5kPwTOAZ8RjtUloKBmgGLHO0wiSM0rkLxSmFeTgIK0YYsbwnza7wD2lChg8viHLZRZGMcRNiGaaUsXt2rNqnOgqmG3JfAlXiYAZEyjoFEGFbTdQ7aE/ppop1df3LM8tat03ZpE7Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756992037; c=relaxed/simple;
	bh=5AKbQwsUPncT3DyHFx9ce2mjPef1ad44qvZo8cC5+Q8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=usJg2W/6sr9vwJC8B9kDuInpYDXF/F7pJusjdeN1jPWFr8VQaBx1RVhGsbtTboGTz9fDYRNL1vuJ0rAQcXUEt6yT15p1GqrMQ9REnJOInAjUhEHVrIfUDksW9M5SQNlnXnyES0NyH5YSR+kAxsHZWDXR9vpRkh6mv6MdWrYOEsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=KNz+Q+YD; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="KNz+Q+YD"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250904132032epoutp01b250b06fd2e978be3adee4ccfcd737be~iFvHbNF8M1725917259epoutp01d
	for <nvdimm@lists.linux.dev>; Thu,  4 Sep 2025 13:20:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250904132032epoutp01b250b06fd2e978be3adee4ccfcd737be~iFvHbNF8M1725917259epoutp01d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1756992032;
	bh=KECRwdTHVQgFJej4QtU1rPSiDdLIC54bdM0+YJwpqdA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=KNz+Q+YDnCkgEo9uQ9BIglaHVIkiR1yR0FxHikpm1OmnLnhxpPxhf6tZ/Rw6LCQJ+
	 /6UYvTB6Neho6WskCQopimGak4wppj2GVMgceUyQQ5N0YKyAiJgIgKqGnYujzpYSbP
	 WrnXq2gGKQycg7AR7cLDc5Sw0V2UXbLacjCAu7nE=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20250904132032epcas5p20d5f2e1f991ac641e1dbd23a5cee3f2d~iFvHFzX8i2921829218epcas5p2b;
	Thu,  4 Sep 2025 13:20:32 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.95]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4cHg8H2Dlgz2SSKZ; Thu,  4 Sep
	2025 13:20:31 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250904132030epcas5p26dacc2b33189a6af5cebd4c1820e0e40~iFvFUQjfD2207022070epcas5p26;
	Thu,  4 Sep 2025 13:20:30 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250904132029epsmtip168ec6a5905233e2c8703797b32f2376c~iFvELStrL2710027100epsmtip1h;
	Thu,  4 Sep 2025 13:20:29 +0000 (GMT)
Date: Thu, 4 Sep 2025 18:50:23 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V2 01/20] nvdimm/label: Introduce NDD_CXL_LABEL flag to
 set cxl label format
Message-ID: <20250904131929.rcithhcixbwqxyss@test-PowerEdge-R740xd>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250813141218.0000091f@huawei.com>
X-CMS-MailID: 20250904132030epcas5p26dacc2b33189a6af5cebd4c1820e0e40
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----NUum2bl.CiaUPDLBlJLeOFPEqthXJjtuaYQe8aeKsoDg0nUl=_e248e_"
CMS-TYPE: 105P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250730121223epcas5p1386bdf99a0af820dd4411fbdbd413cd5
References: <20250730121209.303202-1-s.neeraj@samsung.com>
	<CGME20250730121223epcas5p1386bdf99a0af820dd4411fbdbd413cd5@epcas5p1.samsung.com>
	<20250730121209.303202-2-s.neeraj@samsung.com>
	<20250813141218.0000091f@huawei.com>

------NUum2bl.CiaUPDLBlJLeOFPEqthXJjtuaYQe8aeKsoDg0nUl=_e248e_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 13/08/25 02:12PM, Jonathan Cameron wrote:
>On Wed, 30 Jul 2025 17:41:50 +0530
>Neeraj Kumar <s.neeraj@samsung.com> wrote:
>
>> Prior to LSA 2.1 version, LSA contain only namespace labels. LSA 2.1
>> introduced in CXL 2.0 Spec, which contain region label along with
>> namespace label.
>>
>> NDD_LABELING flag is used for namespace. Introduced NDD_CXL_LABEL
>> flag for region label. Based on these flags nvdimm driver performs
>> operation on namespace label or region label.
>>
>> NDD_CXL_LABEL will be utilized by cxl driver to enable LSA2.1 region
>> label support
>>
>> Accordingly updated label index version
>>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>Hi Neeraj,
>
>A few comments inline.
>
>> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
>> index 04f4a049599a..7a011ee02d79 100644
>> --- a/drivers/nvdimm/label.c
>> +++ b/drivers/nvdimm/label.c
>> @@ -688,11 +688,25 @@ static int nd_label_write_index(struct nvdimm_drvdata *ndd, int index, u32 seq,
>>  		- (unsigned long) to_namespace_index(ndd, 0);
>>  	nsindex->labeloff = __cpu_to_le64(offset);
>>  	nsindex->nslot = __cpu_to_le32(nslot);
>> -	nsindex->major = __cpu_to_le16(1);
>> -	if (sizeof_namespace_label(ndd) < 256)
>> +
>> +	/* Set LSA Label Index Version */
>> +	if (ndd->cxl) {
>> +		/* CXL r3.2 Spec: Table 9-9 Label Index Block Layout */
>> +		nsindex->major = __cpu_to_le16(2);
>>  		nsindex->minor = __cpu_to_le16(1);
>> -	else
>> -		nsindex->minor = __cpu_to_le16(2);
>> +	} else {
>> +		nsindex->major = __cpu_to_le16(1);
>> +		/*
>> +		 * NVDIMM Namespace Specification
>> +		 * Table 2: Namespace Label Index Block Fields
>> +		 */
>> +		if (sizeof_namespace_label(ndd) < 256)
>> +			nsindex->minor = __cpu_to_le16(1);
>> +		else
>> +		 /* UEFI Specification 2.7: Label Index Block Definitions */
>
>Odd comment alignment. Either put it on the else so
>		else /* UEFI 2.7: Label Index Block Defintions */
>
>or indent it an extra tab
>
>		else
>			/* UEFI 2.7: Label Index Block Definitions */
>			

Thanks Jonathan, I will fix it in next patch-set

>> +			nsindex->minor = __cpu_to_le16(2);
>> +	}
>> +
>>  	nsindex->checksum = __cpu_to_le64(0);
>>  	if (flags & ND_NSINDEX_INIT) {
>>  		unsigned long *free = (unsigned long *) nsindex->free;
>
>> diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
>> index e772aae71843..0a55900842c8 100644
>> --- a/include/linux/libnvdimm.h
>> +++ b/include/linux/libnvdimm.h
>> @@ -44,6 +44,9 @@ enum {
>>  	/* dimm provider wants synchronous registration by __nvdimm_create() */
>>  	NDD_REGISTER_SYNC = 8,
>>
>> +	/* dimm supports region labels (LSA Format 2.1) */
>> +	NDD_CXL_LABEL = 9,
>
>This enum is 'curious'.  It combined flags from a bunch of different
>flags fields and some stuff that are nothing to do with flags.
>
>Anyhow, putting that aside I'd either rename it to something like
>NDD_REGION_LABELING (similar to NDD_LABELING that is there for namespace labels
>or just have it a meaning it is LSA Format 2.1 and drop the fact htat
>also means region labels are supported.
>
>Combination of a comment that talks about one thing and a definition name
>that doesn't associate with it seems confusing to me.
>
>Jonathan
>

Sure, I will rename it in next patch-set

Regards,
Neeraj

>
>> +
>>  	/* need to set a limit somewhere, but yes, this is likely overkill */
>>  	ND_IOCTL_MAX_BUFLEN = SZ_4M,
>>  	ND_CMD_MAX_ELEM = 5,
>

------NUum2bl.CiaUPDLBlJLeOFPEqthXJjtuaYQe8aeKsoDg0nUl=_e248e_
Content-Type: text/plain; charset="utf-8"


------NUum2bl.CiaUPDLBlJLeOFPEqthXJjtuaYQe8aeKsoDg0nUl=_e248e_--
