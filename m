Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575C2C2FB
	for <nvdimm@lists.linux.dev>; Thu,  4 Sep 2025 14:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756996240; cv=none; b=YlNoXZCB9HS+IjPSKDeyTj00l/XCAgTySLnWMeXJa0NNDDHQsQuk6oc0TtJ6b0L9wgUB25YMAyFfvcx66RguoxiWJ6bIOFjpT8+MfD1IhZDgc4xX1D5GdIy0BtCjzo9RWe6SPPnkcc2v36Weq15eC3g1zuTjgso/2wJVOkpL3uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756996240; c=relaxed/simple;
	bh=HzVN/FWIYFA0LAumW0vBstspHi6NMIxiu3xoBHSm194=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=fdxATwUA0tt6xanrS+DQMDDogm9qu9Lyern9agfDfOdujvnJkyMXAxqVCm5/LmddWb7Qcs2TUfOGZCO+CTfZ9FzKlgqLVUe3Lqgs2GYbEN5v8rmJHeeF9E7ZBJR+IeVUtU3FBAlDCoKpIlHiZFx8twRJJVeKEesWIQsJoFDRn/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=b4wex0b6; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="b4wex0b6"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250904143036epoutp0191af72a8c4510b0188c1885f50fcd51d~iGsSjVbX70994109941epoutp01a
	for <nvdimm@lists.linux.dev>; Thu,  4 Sep 2025 14:30:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250904143036epoutp0191af72a8c4510b0188c1885f50fcd51d~iGsSjVbX70994109941epoutp01a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1756996236;
	bh=HzVN/FWIYFA0LAumW0vBstspHi6NMIxiu3xoBHSm194=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=b4wex0b6n4XOZFNNUnEMFbtq4IgdiO1dP/8PMm05b7MRhILRFHTuel3mviGiWy8ft
	 pR7TuCrgielKYY0VT9DqbjeKlG4XNgm7cG6iHfQYNPYweeIJU8JuzgsmBhDlOpG690
	 +S60ap66mXIAQEwxo0oeep8s1Rwk2xXstFGx72J8=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20250904143035epcas5p4e338770b44f01f8c4b52b2f41815e116~iGsSCKzjK0749207492epcas5p40;
	Thu,  4 Sep 2025 14:30:35 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.89]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4cHhj66gWJz6B9mD; Thu,  4 Sep
	2025 14:30:34 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250904143034epcas5p2fa47cdab5bc240ed5e197985bbcc3183~iGsQsGMRe3194431944epcas5p2X;
	Thu,  4 Sep 2025 14:30:34 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250904143033epsmtip2f28a528501ae15ec1443c060153d865c~iGsPUa7Jq1342413424epsmtip20;
	Thu,  4 Sep 2025 14:30:32 +0000 (GMT)
Date: Thu, 4 Sep 2025 20:00:28 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V2 08/20] nvdimm/label: Include region label in slot
 validation
Message-ID: <20250904143028.edliocds7u7lwgmj@test-PowerEdge-R740xd>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250813160740.00001ed2@huawei.com>
X-CMS-MailID: 20250904143034epcas5p2fa47cdab5bc240ed5e197985bbcc3183
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----OUxkrUiS_5tNAtfPKy2OQMQtEkPPDXVoOsIej.5k6A4J0mxM=_ead27_"
CMS-TYPE: 105P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250730121232epcas5p4cd632fe09d1bc51499d9e3ac3c2633b3
References: <20250730121209.303202-1-s.neeraj@samsung.com>
	<CGME20250730121232epcas5p4cd632fe09d1bc51499d9e3ac3c2633b3@epcas5p4.samsung.com>
	<20250730121209.303202-9-s.neeraj@samsung.com>
	<20250813160740.00001ed2@huawei.com>

------OUxkrUiS_5tNAtfPKy2OQMQtEkPPDXVoOsIej.5k6A4J0mxM=_ead27_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 13/08/25 04:07PM, Jonathan Cameron wrote:
>On Wed, 30 Jul 2025 17:41:57 +0530
>Neeraj Kumar <s.neeraj@samsung.com> wrote:
>
>> slot validation routine validates label slot by calculating label
>
>Slot validation ... or
>The slot validation routing ...

Sure, I will fix it in next patch-set

>
>
>> checksum. It was only validating namespace label. This changeset also
>> validates region label if present.
>>
>> Also validate and calculate lsa v2.1 namespace label checksum
>
>LSA v2.1 ...

Sure, I will fix it in next patch-set

>
>
>>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>Otherwise LGTM
>
>Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

Thanks Jonathan for your review and RB tag.

Regards,
Neeraj

------OUxkrUiS_5tNAtfPKy2OQMQtEkPPDXVoOsIej.5k6A4J0mxM=_ead27_
Content-Type: text/plain; charset="utf-8"


------OUxkrUiS_5tNAtfPKy2OQMQtEkPPDXVoOsIej.5k6A4J0mxM=_ead27_--
