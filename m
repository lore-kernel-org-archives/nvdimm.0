Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB35F248898
	for <nvdimm@lists.linux.dev>; Mon,  6 Oct 2025 04:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759726510; cv=none; b=ZS+rLtBQQ57mEMgn9W/5SPi2z3AOp+25g8UP3eNmB9+OE89cC5e6h0euBOrHK/xCJ7gyZwUDEBa/J/4LScme4H8vReml2PasQLXutKtBfJFx2k7bgqFn4AWBtPyXNmRfpBUsWfkniC2xc/J/7lr35aj2VKbZGcQDaP+aysGYyAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759726510; c=relaxed/simple;
	bh=8EAJ8vay+2DUuI3NAgkhbUX2Sof31dSYp76My0hLXso=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=Yd40AAyPRjBESSbm4KV+u0oGw62NQ8cfxPh6b6BE4mGqwbwCECuiHCgtdAVpRzQLfgEgemp3O4SUYyBoqmOO8JWGEhSrS0TMERRmxnzKD7AXshhrteOOBvU5i2LEA0Y6FJ7OTo19JBqHYowP+TXLpoeuiJ5Dvpc1jRV+VqRPFWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=n1tkSp6d; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="n1tkSp6d"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20251006045505epoutp0143527402049c2d0e3111d7abd6b077bb~rze8EUUNG1805018050epoutp01Y
	for <nvdimm@lists.linux.dev>; Mon,  6 Oct 2025 04:55:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20251006045505epoutp0143527402049c2d0e3111d7abd6b077bb~rze8EUUNG1805018050epoutp01Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1759726505;
	bh=r9lhFdtvtHSUGUtk6iX8Rl6CN04u/DZX/3b/mKjaUaw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=n1tkSp6dr2B3KZPPSmjQGO7vDrihI3f6G+RDoaInEhcmth1dqwAbF0JOD22PRL9zE
	 N8DNd4lUaTTLJx/YxFoJ7Z65b1omKjVa39kGf5B72ycQrJjUP/Ua15DcONbIuy5pXj
	 Od6Z5dwFRHU2liW66FBQAVcOsiNXbWCZO/4JfsGA=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20251006045505epcas5p30966ee343fcea294d676dea0218dc23f~rze7kb1FD0897408974epcas5p3l;
	Mon,  6 Oct 2025 04:55:05 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4cg6QK290Vz2SSKY; Mon,  6 Oct
	2025 04:55:05 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250929141400epcas5p28196fd5d1b919926b274ce14c46031cd~pxl8IXBvX3203932039epcas5p2S;
	Mon, 29 Sep 2025 14:14:00 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250929141358epsmtip29c4e319e87980ff024d15c621c7715cc~pxl6BfSI01882218822epsmtip2A;
	Mon, 29 Sep 2025 14:13:57 +0000 (GMT)
Date: Mon, 29 Sep 2025 19:43:54 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Alison Schofield <alison.schofield@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V3 16/20] cxl/mem: Preserve cxl root decoder during mem
 probe
Message-ID: <680779399.221759726505299.JavaMail.epsvc@epcpadp1new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <aNRkzw5GrqyZjE6s@aschofie-mobl2.lan>
X-CMS-MailID: 20250929141400epcas5p28196fd5d1b919926b274ce14c46031cd
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----u9L2QgHoAwvmxKKc9G9JEwVzlbmkcdkJo4LdlrEXZ6gvS-I0=_75f6_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250917134203epcas5p3819aee1deecdeaed95bd92d19d3b1910
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
	<CGME20250917134203epcas5p3819aee1deecdeaed95bd92d19d3b1910@epcas5p3.samsung.com>
	<20250917134116.1623730-17-s.neeraj@samsung.com>
	<aNRkzw5GrqyZjE6s@aschofie-mobl2.lan>

------u9L2QgHoAwvmxKKc9G9JEwVzlbmkcdkJo4LdlrEXZ6gvS-I0=_75f6_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 24/09/25 02:38PM, Alison Schofield wrote:
>On Wed, Sep 17, 2025 at 07:11:12PM +0530, Neeraj Kumar wrote:
>> Saved root decoder info is required for cxl region persistency
>
>It seem there must be a more detailed story here.
>Saving the root decoder in struct cxl_memdev does not sound
>persistent. Please add more detail on how this step fits
>into the grander scheme.
>

Yes it has story. For region creation using cxl_create_region()
we need to know the root decoder. 

In current case cxl root decocer is provided from ndctl using device
attribute create_region_store(). And saving root decoder (cxlrd) in
cxl_memdev(cxlmd) helps to get root decoder during region creation.

Actually, cxl_memdev instance is saved in struct cxl_nvdimm(cxl_nvd). So
after parsing region information from nvdimm driver we recreate region
and thus cxlmd is available from cxl_nvd along with saved cxlrd

I will elaborate commit message with above information


Regards,
Neeraj


------u9L2QgHoAwvmxKKc9G9JEwVzlbmkcdkJo4LdlrEXZ6gvS-I0=_75f6_
Content-Type: text/plain; charset="utf-8"


------u9L2QgHoAwvmxKKc9G9JEwVzlbmkcdkJo4LdlrEXZ6gvS-I0=_75f6_--

