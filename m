Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7703F24338F
	for <nvdimm@lists.linux.dev>; Mon,  6 Oct 2025 04:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759726506; cv=none; b=lLTdx9ckbunuIV+B2Uh/csJEpk4vdhB4JLrWdLJMF1OWmMXYOLVzeOt7lpgDY8+wNKuyD4Nosx1IJvCNBMyXn77IjeHeeQHjj+T2X9bdvkD23A6qLt8tmfFbYW5srZfCkOQ/EsKZhnLKXcfTXSpXeAES59BMgqMbigfzj6njI2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759726506; c=relaxed/simple;
	bh=MKALniklbjQIocFCA57F3nu6eiXvymrCYPcaLd8sC4I=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=ArLL3N+bXMm0GNVOMZWTsIAyeA0dcMN3Ww004ouRZ9m/aDSgU3LiW/+kASeojzi81aVbbLL0Q9ditdnpDovVpXmX2bJzCxxv2e5rDvCgUNSNpPzSjzZC1TL/oi7ZNf+P/OtwCNJdyqMboI4bk/k9YddH63AeUbkCAse1U9yllao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=WAaorx8w; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="WAaorx8w"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20251006045502epoutp01d430c3bc64047a6a087954943ea6b639~rze465c591733617336epoutp01n
	for <nvdimm@lists.linux.dev>; Mon,  6 Oct 2025 04:55:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20251006045502epoutp01d430c3bc64047a6a087954943ea6b639~rze465c591733617336epoutp01n
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1759726502;
	bh=PCOjeKOKq4wxWMpLXXZiAxcmwm9HhVz+6b9LjvlRY50=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=WAaorx8wVBS4B5BhbRLYjxy2rVi0UR7HVtiWNLKql70ZU3Ypf0yv8lbK9Ved/CX/Y
	 ZPSbRFYIJeHB7hilnOfCA7IYE5jykWlSVT0Yj6CfWYW8NMXKHesbgxgPrugZcf2MKg
	 JyfAFkmTO/04XR4JpBSv1Ny5D0mHdqcT/D6CpYbE=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20251006045502epcas5p37cf5a6205e8131722d8efb9a77eac21a~rze4l9_A-0897408974epcas5p3P;
	Mon,  6 Oct 2025 04:55:02 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4cg6QG0m9wz2SSKZ; Mon,  6 Oct
	2025 04:55:02 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250929132812epcas5p31fb057eacb430527a75b55e392e23a43~pw98SWmkQ0800708007epcas5p31;
	Mon, 29 Sep 2025 13:28:12 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250929132809epsmtip2ca45d493073e84cfdeddb4df4320b6b7~pw96Eulyg2379723797epsmtip2x;
	Mon, 29 Sep 2025 13:28:09 +0000 (GMT)
Date: Mon, 29 Sep 2025 18:58:05 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V3 05/20] nvdimm/namespace_label: Add namespace label
 changes as per CXL LSA v2.1
Message-ID: <1983025922.01759726502090.JavaMail.epsvc@epcpadp1new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <aaccf5c7-b9e8-4b27-8464-09ef3732c0c1@intel.com>
X-CMS-MailID: 20250929132812epcas5p31fb057eacb430527a75b55e392e23a43
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----fevm_dXp0U54qslEOU8oiqO.VnigTQz743t4hqwhjBnK2JlQ=_7417_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250917134138epcas5p2b02390404681df79c26f7a1a0f0262b8
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
	<CGME20250917134138epcas5p2b02390404681df79c26f7a1a0f0262b8@epcas5p2.samsung.com>
	<20250917134116.1623730-6-s.neeraj@samsung.com>
	<aaccf5c7-b9e8-4b27-8464-09ef3732c0c1@intel.com>

------fevm_dXp0U54qslEOU8oiqO.VnigTQz743t4hqwhjBnK2JlQ=_7417_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 23/09/25 02:48PM, Dave Jiang wrote:
>> +static inline void nsl_set_type(struct nvdimm_drvdata *ndd,
>> +				struct nd_namespace_label *ns_label)
>> +{
>> +	if (ndd->cxl && ns_label)
>> +		uuid_parse(CXL_NAMESPACE_UUID, (uuid_t *) ns_label->cxl.type);
>
>You can do:
>uuid_copy(ns_label->cxl.type, cxl_namespace_uuid);
>
>All the constant UUIDs are preparsed by nd_label_init(). For the entire series you can use those pre-parsed uuid_t and just use uuid_copy() instead of having to do string to uuid_t conversions.
>
>DJ
>

Yes using preparsed UUID's will help to avoid extra uuid_parse() usage.
Sure, I will fix it accordingly


Regards,
Neeraj


------fevm_dXp0U54qslEOU8oiqO.VnigTQz743t4hqwhjBnK2JlQ=_7417_
Content-Type: text/plain; charset="utf-8"


------fevm_dXp0U54qslEOU8oiqO.VnigTQz743t4hqwhjBnK2JlQ=_7417_--

