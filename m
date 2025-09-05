Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6982D4801
	for <nvdimm@lists.linux.dev>; Fri,  5 Sep 2025 07:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757055790; cv=none; b=ujdQ2S54iyu+bZh/1QJKG6VwY0SEggq63VG/Pvd9ye5xn91TOAnwJlB+DHpq2tekd7tcWd8H71EZpdHKM9VpV2KJtUP7uzS/kdkai2OqQbdDougFKVXsQ2AKuqlndGzsIqjSa4ujB01GwODaGoZKk+S8hbRBeg1TJ/w9LEuNbXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757055790; c=relaxed/simple;
	bh=jchyXFL4b6m82FIFxOBZ1/11T2qKNuFR30e60F+Z5V0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=hwinWYWgC3yBUf01lz54vbWuzrWJdB1emb+Be7dDiZn0mzbI6D8ToUQfj0pQwNL+9GlejQnUP0VcZmPeb/vJXbDqLYDWpPTRME/NkpyVuVqpXaR/DOtWAi9dEgMMliZakbwnfe7HrqBkqDz8PnUBmHCPFR83vKuGCSV2Xl4rHiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=bXCyCKCz; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="bXCyCKCz"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250905070305epoutp031d6d3cc166ff1becf4f1abebfbfc517a~iUO12Zmdy2973829738epoutp03T
	for <nvdimm@lists.linux.dev>; Fri,  5 Sep 2025 07:03:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250905070305epoutp031d6d3cc166ff1becf4f1abebfbfc517a~iUO12Zmdy2973829738epoutp03T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1757055785;
	bh=EiP0xiXkEL+7H93+oPzbZOsrHTsDfxC/2+bFhvmZINA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=bXCyCKCzFP1/YuBeZcXPgP+6TfVuCh0Vgf1hKtRGD5kGMMacawr+2eF2Sg2BPC3OR
	 QfTNTNfmebe5BeALrlSSBqbsF9y1TgJT57dZDel7tjrrWuDdyfhN/KRQAXEKfz7KZT
	 aZJ70IS3w6MXkuUf/9LLOX6z3S7nsAanxK0s3lIM=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20250905070304epcas5p12c2680e0cad7618c7352f913c9b9ccb3~iUO1YrRKj3181831818epcas5p1H;
	Fri,  5 Sep 2025 07:03:04 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4cJ6kJ6XT3z2SSKf; Fri,  5 Sep
	2025 07:03:04 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250905053421epcas5p4d650ac1c432ae1595614b89992631a18~iTBXsbvs-2772427724epcas5p4v;
	Fri,  5 Sep 2025 05:34:21 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250905053420epsmtip2004d0f3768d8e968ff1e1ceb151532c8~iTBWZ-VhX0633506335epsmtip2w;
	Fri,  5 Sep 2025 05:34:20 +0000 (GMT)
Date: Fri, 5 Sep 2025 11:04:14 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Ira Weiny <ira.weiny@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V2 03/20] nvdimm/namespace_label: Add namespace label
 changes as per CXL LSA v2.1
Message-ID: <680779399.221757055784911.JavaMail.epsvc@epcpadp2new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <68a4d250ee63e_281ac7294fe@iweiny-mobl.notmuch>
X-CMS-MailID: 20250905053421epcas5p4d650ac1c432ae1595614b89992631a18
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----OUxkrUiS_5tNAtfPKy2OQMQtEkPPDXVoOsIej.5k6A4J0mxM=_ed55e_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250730121225epcas5p2742d108bd0c52c8d7d46b655892c5c19
References: <20250730121209.303202-1-s.neeraj@samsung.com>
	<CGME20250730121225epcas5p2742d108bd0c52c8d7d46b655892c5c19@epcas5p2.samsung.com>
	<20250730121209.303202-4-s.neeraj@samsung.com>
	<68a4d250ee63e_281ac7294fe@iweiny-mobl.notmuch>

------OUxkrUiS_5tNAtfPKy2OQMQtEkPPDXVoOsIej.5k6A4J0mxM=_ed55e_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 19/08/25 02:36PM, Ira Weiny wrote:
>Neeraj Kumar wrote:
>> CXL 3.2 Spec mentions CXL LSA 2.1 Namespace Labels at section 9.13.2.5
>> Modified __pmem_label_update function using setter functions to update
>> namespace label as per CXL LSA 2.1
>>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>
>[snip]
>
>>
>> +static inline void nsl_set_type(struct nvdimm_drvdata *ndd,
>> +				struct nd_namespace_label *ns_label)
>> +{
>> +	uuid_t tmp;
>> +
>> +	if (ndd->cxl) {
>> +		uuid_parse(CXL_NAMESPACE_UUID, &tmp);
>> +		export_uuid(ns_label->cxl.type, &tmp);
>
>One more thing why can't uuid_parse put the UUID directly into type?

Thanks Ira for your suggestion. I have used because of uuid_parse() and
export_uuid() signature difference.
But yes we can only use uuid_parse() using typecasting. I will modify it
in next patch-set.

>
>I think this is done at least 1 other place.
>
>Ira

Sure, I will fix it at the other place as well.


Regards,
Neeraj

------OUxkrUiS_5tNAtfPKy2OQMQtEkPPDXVoOsIej.5k6A4J0mxM=_ed55e_
Content-Type: text/plain; charset="utf-8"


------OUxkrUiS_5tNAtfPKy2OQMQtEkPPDXVoOsIej.5k6A4J0mxM=_ed55e_--

