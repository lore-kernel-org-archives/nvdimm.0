Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1AEC243958
	for <nvdimm@lists.linux.dev>; Mon,  6 Oct 2025 04:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759726392; cv=none; b=d3r4x72IBdSJ8MktAnOTpyEZMa+uGGIoC1Swmv0APy4SZ1mYYE2AXkx/9Qx+MnFARe6iBhPvnp25tQiQXLTC1B0hWVC3HCdVjUf7RO4b3M8JEswwNXg1JeKoavgdhsuxRF9cmV89K5a3TSY+7sh+epiirbsyDhqzKFRGdp/kD94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759726392; c=relaxed/simple;
	bh=sGSDfyrLHX/ORp1k9Hn0dLzDv7OYfmDBNqEalyBOapw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=n6UcLmwTrD7wEnWoyWSPHj9SBR8D5JBJWQhvns1v2REx4FybqbJpwmrKchFr5yKHrrAykw4/u/KjIjsRjPmlMmZcebYJQ850rDgBdph1eOVnmfsX2wmngnhahUNQpIaDrcrnRPVflt831losS2nCbUBzVWOZhMPxNNsFf4DwZaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=B7iA4fk6; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="B7iA4fk6"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20251006045302epoutp01adad5b5ea46f4b6e41aed2fc0b336503~rzdJNGjIx1590815908epoutp01J
	for <nvdimm@lists.linux.dev>; Mon,  6 Oct 2025 04:53:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20251006045302epoutp01adad5b5ea46f4b6e41aed2fc0b336503~rzdJNGjIx1590815908epoutp01J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1759726382;
	bh=ljQwjAPpFplu64VEbVhcdW8SJG06I2gvcvkEKRwd9S8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=B7iA4fk6a+lCkvjnMi3UDQvP+NLGy9/r42/c0f7yOAb1a5K17Lk1/e8cV5cd5XMq2
	 mgLozzwsLOe1UzO8rK7qRG/aSgS6MEa9Kt2l8flFVxc5x1jXKssWAdMxQMDEa49nMh
	 iiPa0ajLbj/Lx3/R/Xc48Zrta0WAEs7K3/wPh9ug=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20251006045302epcas5p12eeb2e226c96b0e6158e85743a6addd1~rzdI3tdsP3136831368epcas5p1o;
	Mon,  6 Oct 2025 04:53:02 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4cg6My12YFz2SSKY; Mon,  6 Oct
	2025 04:53:02 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250929132418epcas5p4d2b45aa62e3f7abe35921b79d0192b61~pw6il-t6o2533625336epcas5p4P;
	Mon, 29 Sep 2025 13:24:18 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250929132417epsmtip1715b846028fe1616a97732f0bac42d70~pw6haIBxp2638126381epsmtip1X;
	Mon, 29 Sep 2025 13:24:16 +0000 (GMT)
Date: Mon, 29 Sep 2025 18:54:06 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V3 06/20] nvdimm/region_label: Add region label update
 support
Message-ID: <1931444790.41759726382136.JavaMail.epsvc@epcpadp2new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <b8361ada-8d99-4e07-b5a3-6cc43dae07f7@intel.com>
X-CMS-MailID: 20250929132418epcas5p4d2b45aa62e3f7abe35921b79d0192b61
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----fevm_dXp0U54qslEOU8oiqO.VnigTQz743t4hqwhjBnK2JlQ=_739c_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250917134140epcas5p23c007dab49ed7e98726b0dd9a2ce077a
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
	<CGME20250917134140epcas5p23c007dab49ed7e98726b0dd9a2ce077a@epcas5p2.samsung.com>
	<20250917134116.1623730-7-s.neeraj@samsung.com>
	<b8361ada-8d99-4e07-b5a3-6cc43dae07f7@intel.com>

------fevm_dXp0U54qslEOU8oiqO.VnigTQz743t4hqwhjBnK2JlQ=_739c_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 22/09/25 04:11PM, Dave Jiang wrote:
>> +static inline bool is_region_label(struct nvdimm_drvdata *ndd,
>> +				   union nd_lsa_label *nd_label)
>> +{
>> +	uuid_t region_type, *ns_type;
>> +
>> +	if (!ndd->cxl || !nd_label)
>> +		return false;
>> +
>> +	uuid_parse(CXL_REGION_UUID, &region_type);
>> +	ns_type = (uuid_t *) nd_label->ns_label.cxl.type;
>
>So in addition to Jonathan's comments, I think we should consider utilizing the common field (UUID) of all the labels. i.e. if you are to use a union, you can also include 'uuid_t label_type' as a member. Perhaps this function can just pass in a UUID rather than a label struct. And we can probably skip passing in 'ndd' and not bother with ndd->cxl check. This function can just rely on checking the UUID and see if it's the expected region label UUID. Just thinking of the places we can maybe avoid doing casting if possible.
>
>DJ

Thanks Dave for detailed suggestion. I will handle this in next
patch-set


Regards,
Neeraj


------fevm_dXp0U54qslEOU8oiqO.VnigTQz743t4hqwhjBnK2JlQ=_739c_
Content-Type: text/plain; charset="utf-8"


------fevm_dXp0U54qslEOU8oiqO.VnigTQz743t4hqwhjBnK2JlQ=_739c_--

