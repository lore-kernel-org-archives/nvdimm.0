Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F6E8243371
	for <nvdimm@lists.linux.dev>; Mon,  6 Oct 2025 04:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759726506; cv=none; b=IfhNP34vomjSrffE8NRUTTZIOlxO/DNHI3mKPFwpR4zRpT1bKgfpQeqqE0s6lekevq8Kxuld0WXSRHvMd1XnUUTA7pTX0XNjzL0XqHW/vNmu2ov87ACVoxr+6CI7eQydUtxPRE+OyWU0kkvqFhY9g3HPtOM/B9wzFjRTxoa2gE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759726506; c=relaxed/simple;
	bh=DKU28B+/WjX4w+CMrSwaFs4Rp+lzGbVv7IqWeGOeiog=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=IWzhKjVjnU4Xvzt/kT/lk3e+10NOkCt7/pxRlcCWNPoICle7XUEYze8jFXwvxD1e65+X3g1Um64fDeC1o0E3GFE8epRb+RWCoBYX8vHfZyHzoZKKU2b+zutnVwals2zwIC90vi3vTSM7dJusbCHxQ7NWTSOtfCDMWJ7HxwkdToI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=aBOCXBY5; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="aBOCXBY5"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20251006045502epoutp03d4a548d70c5259929958968d73bb4226~rze5Hc7BF1934019340epoutp03b
	for <nvdimm@lists.linux.dev>; Mon,  6 Oct 2025 04:55:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20251006045502epoutp03d4a548d70c5259929958968d73bb4226~rze5Hc7BF1934019340epoutp03b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1759726502;
	bh=fjLhaWamRPh5gBXF3MRUevGTJ7eSPdiTSpInpVK3mCk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=aBOCXBY5R88heo8ppdBi9BLGK5S/7h2EKApLXwMSmIaMYwI1OSdvSg56tfRqIaRd3
	 JCYceOqCyuW16FRgrSmwQUFHmTv0eHuj4TRdBCeccIl+rNq4/a8oLVTxDvw8QwX7s7
	 2WvqplZLAz9gYunjDHf7sVwNA+4mIDRFtuPb82Tg=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20251006045502epcas5p3896b06cef2dd8c5096b9dd66cf0c7cd8~rze4zEbOd0897408974epcas5p3T;
	Mon,  6 Oct 2025 04:55:02 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4cg6QG2L2bz6B9m8; Mon,  6 Oct
	2025 04:55:02 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250929133109epcas5p2488fa4c42ce0d77a9d0370fa2466b71a~pxAhoS2cT2725427254epcas5p2j;
	Mon, 29 Sep 2025 13:31:09 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250929133107epsmtip294f6c9ace51791cc7f26e853cb553f0a~pxAfIeSEu2881328813epsmtip2K;
	Mon, 29 Sep 2025 13:31:06 +0000 (GMT)
Date: Mon, 29 Sep 2025 19:00:59 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V3 13/20] cxl/mem: Refactor cxl pmem region
 auto-assembling
Message-ID: <1296674576.21759726502325.JavaMail.epsvc@epcpadp1new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <c7b41eb6-b946-4ac0-9ddd-e75ba4ceb636@intel.com>
X-CMS-MailID: 20250929133109epcas5p2488fa4c42ce0d77a9d0370fa2466b71a
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----xsJXu.fD5V5xDhddWNWtQINaZQo.kzBR_hLvg.7oVeVxw7Lp=_7371_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250917134157epcas5p1b30306bc8596b7b50548ddf3683c3b97
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
	<CGME20250917134157epcas5p1b30306bc8596b7b50548ddf3683c3b97@epcas5p1.samsung.com>
	<20250917134116.1623730-14-s.neeraj@samsung.com>
	<c7b41eb6-b946-4ac0-9ddd-e75ba4ceb636@intel.com>

------xsJXu.fD5V5xDhddWNWtQINaZQo.kzBR_hLvg.7oVeVxw7Lp=_7371_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 23/09/25 03:37PM, Dave Jiang wrote:
>
>
>On 9/17/25 6:41 AM, Neeraj Kumar wrote:
>> In 84ec985944ef3, devm_cxl_add_nvdimm() sequence was changed and called
>> before devm_cxl_add_endpoint(). It's because cxl pmem region auto-assembly
>> used to get called at last in cxl_endpoint_port_probe(), which requires
>> cxl_nvd presence.
>>
>> For cxl region persistency, region creation happens during nvdimm_probe
>> which need the completion of endpoint probe.
>>
>> In order to accommodate both cxl pmem region auto-assembly and cxl region
>> persistency, refactored following
>>
>> 1. Re-Sequence devm_cxl_add_nvdimm() after devm_cxl_add_endpoint(). This
>>    will be called only after successful completion of endpoint probe.
>>
>> 2. Moved cxl pmem region auto-assembly from cxl_endpoint_port_probe() to
>>    cxl_mem_probe() after devm_cxl_add_nvdimm(). It gurantees both the
>>    completion of endpoint probe and cxl_nvd presence before its call.
>
>Given that we are going forward with this implementation [1] from Dan and drivers like the type2 enabling are going to be using it as well, can you please consider converting this change to Dan's mechanism instead of creating a whole new one?
>
>I think the region discovery can be done via the ops->probe() callback. Thanks.
>
>[1]: https://git.kernel.org/pub/scm/linux/kernel/git/cxl/cxl.git/commit/?h=for-6.18/cxl-probe-order&id=88aec5ea7a24da00dc92c7778df4851fe4fd3ec6
>
>DJ
>

Sure, Let me revisit this.
It seems [1] is there in seperate branch "for-6.18/cxl-probe-order", and not yet merged into next, right?


Regards,
Neeraj

------xsJXu.fD5V5xDhddWNWtQINaZQo.kzBR_hLvg.7oVeVxw7Lp=_7371_
Content-Type: text/plain; charset="utf-8"


------xsJXu.fD5V5xDhddWNWtQINaZQo.kzBR_hLvg.7oVeVxw7Lp=_7371_--

