Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D439306D54
	for <nvdimm@lists.linux.dev>; Thu,  4 Sep 2025 13:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756994109; cv=none; b=Oa8zvpdxtvJarTN0dTyrYGoAXaKVaJZRmGU1lHfL3mpWSVbVR0rEc+74FaF4sgegzZB99uMZcPBedD4SEJlEFbnY86Bl2eheIFwoufviqYbZUGHFhLjLKFSL25GR/Fu0zVVRNhhrN3/WdXDEwzhWJ0zMNR0rgoUmmC97c/Mx3cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756994109; c=relaxed/simple;
	bh=5AuHor2gjdBQMSXf29j05gf0MvYmzK8kAiB5uy6SZCM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=fZCP74rYE/nprOsoA0bhp4q5LGXec1ZkvghYPDYqR6aJ4gBtcw2qjrux/JrwFQMXI8O9gvf85BDqhc9MbwsBOGayZy6X/RvytiRwrzmp+SoZy9Hj+9AroSHqR29HYvw7x8YMqRDoTN++zE7s0eViU/CRdkMxalrFUz+wtj11gso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=LD0Y8KMg; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="LD0Y8KMg"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250904135505epoutp03c6c782b4090a211569d74c48eb0059f9~iGNRmptpo3125531255epoutp03H
	for <nvdimm@lists.linux.dev>; Thu,  4 Sep 2025 13:55:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250904135505epoutp03c6c782b4090a211569d74c48eb0059f9~iGNRmptpo3125531255epoutp03H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1756994105;
	bh=5AuHor2gjdBQMSXf29j05gf0MvYmzK8kAiB5uy6SZCM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=LD0Y8KMgyO20yOAnIERcfDeETGHFzzwUp5BfcRKox4NtcwDsNb7fJPhZAXte7/V+e
	 aDDRuzpjrQ1guZEnjm4E6acEYumUaglKLc0gpZLIZgIgDkhoVZ3qwCpkLcZ1M9kM6A
	 vtRdahKnKxzqcO/XttgG0OILM0Z8WK3tMN6lDP/s=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20250904135504epcas5p1c4da8380378cf269976e47fcda76b024~iGNRGXL4z1524715247epcas5p1b;
	Thu,  4 Sep 2025 13:55:04 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.91]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4cHgw74hfFz2SSKZ; Thu,  4 Sep
	2025 13:55:03 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250904135502epcas5p28479f68a04427e46e862eba17069900e~iGNPZRlbO2098820988epcas5p2Z;
	Thu,  4 Sep 2025 13:55:02 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250904135501epsmtip106bef041e084fa4f3ee6b5c04265dfc7~iGNOQGiDw1697616976epsmtip1f;
	Thu,  4 Sep 2025 13:55:01 +0000 (GMT)
Date: Thu, 4 Sep 2025 19:24:56 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V2 04/20] nvdimm/label: CXL labels skip the need for
 'interleave-set cookie'
Message-ID: <20250904135456.aqt2yndnmfdeowux@test-PowerEdge-R740xd>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250813144401.00004fee@huawei.com>
X-CMS-MailID: 20250904135502epcas5p28479f68a04427e46e862eba17069900e
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----At96h8_oYHqdM-HzD.Qv-z6Hqrsj5DpI3AOnKMLFsbTdazMP=_eac47_"
CMS-TYPE: 105P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250730121227epcas5p4675fdb3130de49cd99351c5efd09e29e
References: <20250730121209.303202-1-s.neeraj@samsung.com>
	<CGME20250730121227epcas5p4675fdb3130de49cd99351c5efd09e29e@epcas5p4.samsung.com>
	<20250730121209.303202-5-s.neeraj@samsung.com>
	<20250813144401.00004fee@huawei.com>

------At96h8_oYHqdM-HzD.Qv-z6Hqrsj5DpI3AOnKMLFsbTdazMP=_eac47_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 13/08/25 02:44PM, Jonathan Cameron wrote:
>On Wed, 30 Jul 2025 17:41:53 +0530
>Neeraj Kumar <s.neeraj@samsung.com> wrote:
>
>> CXL LSA v2.1 utilizes the region labels stored in the LSA for interleave
>> set configuration instead of interleave-set cookie used in previous LSA
>> versions. As interleave-set cookie is not required for CXL LSA v2.1 format
>> so skip its usage for CXL LSA 2.1 format
>>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>
>Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

Thanks Jonathan for review and your RB tag


Regards,
Neeraj

------At96h8_oYHqdM-HzD.Qv-z6Hqrsj5DpI3AOnKMLFsbTdazMP=_eac47_
Content-Type: text/plain; charset="utf-8"


------At96h8_oYHqdM-HzD.Qv-z6Hqrsj5DpI3AOnKMLFsbTdazMP=_eac47_--
