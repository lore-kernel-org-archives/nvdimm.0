Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221451D90DF
	for <nvdimm@lists.linux.dev>; Fri,  5 Sep 2025 07:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757055787; cv=none; b=YPCs5cicrZkfJDUUazNZcVL8k9R2VUozwPCdgA/rGcKSX23Xg2DoRfoD9BQLrD9oP/i77CEPUs/wKdCyCef34Az3L0dDAqJrRsZIG8wESE0tI+xrjbRd82JU26cJWUyHidE1/7hc8UNusoTIh2ohlCSWSe2p0I6dHsy7PlzK0Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757055787; c=relaxed/simple;
	bh=M0kgVMJ5M8ah0syzCnzrBsACqouPGlm+i84IeJsH2nk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=SL/VV9dzGS1vYqnympqMoWSjMFCdn7etIWa/BRzf+4O1t1vrbZsVFHAYciMJ5aog1Q7ZlktM7hE/lgFHiVu/Nf6N+q6ghZ0BKDCsnjmdU1xG9EXUqqhO7BjiVHzWU+VxyAqy9w5tJBCR1viKJwAGTolfTn96UyJpakp5KLBf6yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=LanMLjyt; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="LanMLjyt"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250905070303epoutp0163ef90f9427996069286e86e23b16ec8~iUOz2nCzR0784007840epoutp01Q
	for <nvdimm@lists.linux.dev>; Fri,  5 Sep 2025 07:03:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250905070303epoutp0163ef90f9427996069286e86e23b16ec8~iUOz2nCzR0784007840epoutp01Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1757055783;
	bh=OAAOXwu6dxhlhz8ZeLKplpuPuUMZ/fENswb8u8XzY4I=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=LanMLjyt7o+oqdO1YVm5iowAelwUR7ZEg4s5w/ENmE+JzJw1FO1z8YOM99c4FxoZw
	 sbF98vqYRC2QvK9yLq9B+4Ux3Z+7ztB6CSDAIkq3tPhIMLzOeCVF+PBQsSOWx8gkgm
	 vhrelRdRJQIWQ9OLlPNh/+xWU58Hv89MAjRurqlU=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250905070302epcas5p3cd95bb191c8188ebc06bfbcda0f61cc9~iUOzd2o0F1224012240epcas5p3F;
	Fri,  5 Sep 2025 07:03:02 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4cJ6kG66FGz2SSKd; Fri,  5 Sep
	2025 07:03:02 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250904140124epcas5p35f8c2e657d953b841f10dab10c8c8b30~iGSzTRCj62082920829epcas5p3P;
	Thu,  4 Sep 2025 14:01:24 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250904140123epsmtip1b8caab67b020ff0c5c6315fb4a4fa10f~iGSyEvKf22159221592epsmtip1N;
	Thu,  4 Sep 2025 14:01:23 +0000 (GMT)
Date: Thu, 4 Sep 2025 19:31:18 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V2 04/20] nvdimm/label: CXL labels skip the need for
 'interleave-set cookie'
Message-ID: <1296674576.21757055782845.JavaMail.epsvc@epcpadp2new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <a05bbfe7-dec6-4858-8f9f-9f80deda48ae@intel.com>
X-CMS-MailID: 20250904140124epcas5p35f8c2e657d953b841f10dab10c8c8b30
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----6Bw0j5KOoRaxZeQKOp2dAcC2OKT3No9WZFWhMG37wfGsvvbi=_ea9e8_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250730121227epcas5p4675fdb3130de49cd99351c5efd09e29e
References: <20250730121209.303202-1-s.neeraj@samsung.com>
	<CGME20250730121227epcas5p4675fdb3130de49cd99351c5efd09e29e@epcas5p4.samsung.com>
	<20250730121209.303202-5-s.neeraj@samsung.com>
	<a05bbfe7-dec6-4858-8f9f-9f80deda48ae@intel.com>

------6Bw0j5KOoRaxZeQKOp2dAcC2OKT3No9WZFWhMG37wfGsvvbi=_ea9e8_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 15/08/25 02:02PM, Dave Jiang wrote:
>
>
>On 7/30/25 5:11 AM, Neeraj Kumar wrote:
>> CXL LSA v2.1 utilizes the region labels stored in the LSA for interleave
>> set configuration instead of interleave-set cookie used in previous LSA
>> versions. As interleave-set cookie is not required for CXL LSA v2.1 format
>> so skip its usage for CXL LSA 2.1 format
>>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>> ---
>>  drivers/nvdimm/namespace_devs.c | 3 ++-
>>  drivers/nvdimm/region_devs.c    | 5 +++++
>>  2 files changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
>> index bdf1ed6f23d8..5b73119dc8fd 100644
>> --- a/drivers/nvdimm/namespace_devs.c
>> +++ b/drivers/nvdimm/namespace_devs.c
>> @@ -1692,7 +1692,8 @@ static struct device *create_namespace_pmem(struct nd_region *nd_region,
>>  	int rc = 0;
>>  	u16 i;
>>
>> -	if (cookie == 0) {
>> +	/* CXL labels skip the need for 'interleave-set cookie' */
>
>This comment doesn't make sense to me. If it's a CXL label, we continue to execute. There's no skipping. Or are you trying to say if it's CXL label, then checking of cookie value is unnecessary? But the cookie value still is being used later on. Maybe a bit more comments on what's going on here would be helpful.
>
>DJ

Yes Dave, For CXL label cookie value is not required. Its being used for
non CXL labels only. Sure, I will elaborate the comments in next patch-set.


Regards,
Neeraj

------6Bw0j5KOoRaxZeQKOp2dAcC2OKT3No9WZFWhMG37wfGsvvbi=_ea9e8_
Content-Type: text/plain; charset="utf-8"


------6Bw0j5KOoRaxZeQKOp2dAcC2OKT3No9WZFWhMG37wfGsvvbi=_ea9e8_--

