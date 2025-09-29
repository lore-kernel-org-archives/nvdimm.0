Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54FB924677C
	for <nvdimm@lists.linux.dev>; Mon,  6 Oct 2025 04:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759726508; cv=none; b=F4nZ5/0K60Ax8fiBOb1JPnyBL2QLpw13sNoNp+v2TpleeV1RrOXYFQbYktKD9mi74qgzhWtgkrDcJ8ZI1pFtlPBMYseiewiLOjIPaM4BMX/XbJnzXk1VH+063W8XGXgbvUf1DPf+VQxQeTOIZxOZ2I33Jbgcpd9IXRtNYzygcKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759726508; c=relaxed/simple;
	bh=7IUKhhQfrmUStPe2BFnnFuJeL/6GSXfsOBRijU49pn8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=Bj56GblXr5Pt3HgsUH0TVH41nEQuhhM8+T9rrLVF3GOd3t/o6fxmG5RFbr2yEi5y1Ie7hT8w1CppzxD0IHoyutNrEaeCyXRVCfJ+qNM0NQmsdD7ooud1WjzKPIC4cH2uBESaySk2De0/0R+ZF5zobJDGjCHzZG68VpMGMEaPvJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=K6zagfCY; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="K6zagfCY"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20251006045504epoutp0240b5a5f217c3736c3a08c38262a7d9a0~rze6qw75K1094510945epoutp02Y
	for <nvdimm@lists.linux.dev>; Mon,  6 Oct 2025 04:55:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20251006045504epoutp0240b5a5f217c3736c3a08c38262a7d9a0~rze6qw75K1094510945epoutp02Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1759726504;
	bh=mHZspbyZ3CgV/1kS8ww8PQgLxySKK9TDZD1wFY1rlyc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=K6zagfCYXDwRPX9C8jx7a2Fg8pR9zLdvu1qzfMKWxxGvq2KCE5YaEbBheEcBjyF5D
	 e0/1sjAKw9r3A9HMAmrXHfyUR2i21kFys/UbwRzaRl/sI77dSFh3t722iUR1mYo/MW
	 oqyGXsPwZkEQ+P4UtcsDnuaQgPx3LvVRkN8s0rS4=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20251006045504epcas5p253359a7aad67528167e5a6894f8253c2~rze6ZtDa40104001040epcas5p2F;
	Mon,  6 Oct 2025 04:55:04 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4cg6QJ0MYyz6B9m5; Mon,  6 Oct
	2025 04:55:04 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250929134031epcas5p31d80b8afa19a9f2846f391ee1b89615e~pxIsavwjF1297212972epcas5p3m;
	Mon, 29 Sep 2025 13:40:31 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250929134029epsmtip24775047a76ddf2056a3fdcf5d33c9208~pxIqgRtMy0108201082epsmtip2S;
	Mon, 29 Sep 2025 13:40:28 +0000 (GMT)
Date: Mon, 29 Sep 2025 19:10:24 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V3 15/20] cxl: Add a routine to find cxl root decoder on
 cxl bus using cxl port
Message-ID: <700072760.81759726504033.JavaMail.epsvc@epcpadp1new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <43772918-1911-46a5-8165-bf612056a8e6@intel.com>
X-CMS-MailID: 20250929134031epcas5p31d80b8afa19a9f2846f391ee1b89615e
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----fevm_dXp0U54qslEOU8oiqO.VnigTQz743t4hqwhjBnK2JlQ=_7431_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250917134202epcas5p23f718742c74c5b519ecbbc1e04840c03
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
	<CGME20250917134202epcas5p23f718742c74c5b519ecbbc1e04840c03@epcas5p2.samsung.com>
	<20250917134116.1623730-16-s.neeraj@samsung.com>
	<43772918-1911-46a5-8165-bf612056a8e6@intel.com>

------fevm_dXp0U54qslEOU8oiqO.VnigTQz743t4hqwhjBnK2JlQ=_7431_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 24/09/25 11:11AM, Dave Jiang wrote:
>
>> +struct cxl_root_decoder *cxl_find_root_decoder_by_port(struct cxl_port *port)
>> +{
>> +	struct cxl_root *cxl_root __free(put_cxl_root) = find_cxl_root(port);
>> +	struct device *dev;
>> +
>> +	if (!cxl_root)
>> +		return NULL;
>> +
>> +	dev = device_find_child(&cxl_root->port.dev, NULL, match_root_decoder);
>> +	if (!dev)
>> +		return NULL;
>> +
>> +	/* Release device ref taken via device_find_child() */
>> +	put_device(dev);
>
>Should the caller release the device reference instead?
>
>DJ

Actually caller of this function wants to find root decoder information from cxl_port.
So in order to find root decoder we have used device_find_child() which internally
takes device ref. Therefore, just after finding the appropriate dev, I am releasing
device ref.
Its like taking device ref temporarly and releasing it then and there after finding
proper root decoder.
I believe, Releasing device ref from caller would make it look little out of context.


Regards,
Neeraj

------fevm_dXp0U54qslEOU8oiqO.VnigTQz743t4hqwhjBnK2JlQ=_7431_
Content-Type: text/plain; charset="utf-8"


------fevm_dXp0U54qslEOU8oiqO.VnigTQz743t4hqwhjBnK2JlQ=_7431_--

