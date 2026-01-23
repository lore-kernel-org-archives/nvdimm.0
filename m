Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88EA02EA168
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769168107; cv=none; b=ohCete0z2dKfKZBx1lDdC+Mx1okOA5VhNHcPAzPLSlgcukrDmmrjVjw+9owzA85wgcThD75exhTK+fgPvdVZCh4rWGolxJO6h9m8bqdmYctOunbxfd4dTgZVjRFhX33vXLCJ6W/eK6Om+BgS+QRZXmD7aJFZSFr4dRpsHQqhylk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769168107; c=relaxed/simple;
	bh=FLRKxUYEpO51jv4675iaEu60iBSwPtOTvlvzxKFTuP0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=sM+tTAufnNuvamvvdKPP8Tmr9V0rKeziBNB8rfE1qb0PCEENnZs6vtaiRAhXggD3nNNJjeGPsRGP3bscogWYzu80GOQ4ebDNxCBREZfv6QepyaSC/9A4rj8VeRcvyoZZLD22ghTeKHDSAVDCrKJxG6y5Di68snjbuMWqC0+5fWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=E0mRbhIX; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="E0mRbhIX"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260123113503epoutp02623b82cca306636a3a1de8fca86f37fb~NWQReokH90214002140epoutp02J
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:35:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260123113503epoutp02623b82cca306636a3a1de8fca86f37fb~NWQReokH90214002140epoutp02J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1769168103;
	bh=FLRKxUYEpO51jv4675iaEu60iBSwPtOTvlvzxKFTuP0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=E0mRbhIXZB4ahvnyhg6YNQ1KS7NKB0SuFFY8jyt1DV0DX5FtKVCNh1g0tZiaPGNjZ
	 PJ8e+JKTlMG3GeRKTyi+6xOD2aMQwqZbIGZ5rngSSXrLn7Co5m6zgexXcSGaac+R6A
	 MwzlilyqG4cxaGMkIyebMRrxWAwP7a47+3nwDWkA=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20260123113503epcas5p1d8e4140a5556d0ac447195825591e1c1~NWQQqzbH10055900559epcas5p1h;
	Fri, 23 Jan 2026 11:35:03 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4dyG7W0BXHz6B9m5; Fri, 23 Jan
	2026 11:35:03 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20260123112253epcas5p4cce3dfd18638aaf6f6bf81dbaffca4ff~NWFpja4GB0940109401epcas5p4Z;
	Fri, 23 Jan 2026 11:22:53 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260123112252epsmtip1ccb9ce6c2aef4b3e713114ad74c0f6bb~NWFoWs5An1105111051epsmtip1H;
	Fri, 23 Jan 2026 11:22:52 +0000 (GMT)
Date: Fri, 23 Jan 2026 16:52:47 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V5 15/17] cxl/pmem_region: Add sysfs attribute cxl
 region label updation/deletion
Message-ID: <626742236.41769168103022.JavaMail.epsvc@epcpadp1new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <c47b0eda-b3fe-442d-be11-f9fa02400915@intel.com>
X-CMS-MailID: 20260123112253epcas5p4cce3dfd18638aaf6f6bf81dbaffca4ff
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----bVwHse4Nykw-L2c5iRRXKf-G.8k0lxUwrpcTFjGaDb9lfltx=_11ecc6_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20260109124531epcas5p118e7306860bcd57a0106948375df5c9c
References: <20260109124437.4025893-1-s.neeraj@samsung.com>
	<CGME20260109124531epcas5p118e7306860bcd57a0106948375df5c9c@epcas5p1.samsung.com>
	<20260109124437.4025893-16-s.neeraj@samsung.com>
	<c47b0eda-b3fe-442d-be11-f9fa02400915@intel.com>

------bVwHse4Nykw-L2c5iRRXKf-G.8k0lxUwrpcTFjGaDb9lfltx=_11ecc6_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 14/01/26 10:00AM, Dave Jiang wrote:
>
>
>On 1/9/26 5:44 AM, Neeraj Kumar wrote:
>> Using these attributes region label is added/deleted into LSA. These
>> attributes are called from userspace (ndctl) after region creation.
>>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>
>Reviewed-by: Dave Jiang <dave.jiang@intel.com>

Thanks Dave for RB tag.

>
>You'll need to update the KernelVersion to v7.0.

Fixed it in V6.


Regards,
Neeraj

------bVwHse4Nykw-L2c5iRRXKf-G.8k0lxUwrpcTFjGaDb9lfltx=_11ecc6_
Content-Type: text/plain; charset="utf-8"


------bVwHse4Nykw-L2c5iRRXKf-G.8k0lxUwrpcTFjGaDb9lfltx=_11ecc6_--

