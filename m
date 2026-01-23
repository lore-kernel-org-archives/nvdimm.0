Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B118A30214D
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769167086; cv=none; b=YFCsnLvtaiMJSOKehmJTxZuPpVrmtu6WX9t0a2wuwfDV/QS4wLRUMiZWqag9DYWNCwRlJ56heftDkNNvxhP/OmhsJ5CahpNVVGauJadaLBGUFA7sz7QCsr/PMK7ST4XGGXaaZU82xDqcxNx1VGTpYZr6sw34LbcVncuEPfhMA6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769167086; c=relaxed/simple;
	bh=FIBKskftsw1KQLtuNPlmWJzgjvQI69Zg7HK2NBu36t8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=bXrXQkwKiG7Ng621dmlMUVo+I+29rXFN6ie+YF3albuWcBgnLdiPfpH/u49ZswcnrPHdt1pecyfoElSuta6zQXGjGNlcsB6YLHFgNwMs6F0qMTu8bIOHetbBfxwDDBwXjYBBEpYDskbCrATEp7lgEs2IWX1NTV5rm+AQ4HuPpgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=hFgUzsLJ; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="hFgUzsLJ"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260123111803epoutp02effad406c6a82fa05e42ed44d4278d60~NWBa1EKlF1850418504epoutp02B
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:18:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260123111803epoutp02effad406c6a82fa05e42ed44d4278d60~NWBa1EKlF1850418504epoutp02B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1769167083;
	bh=0teDD1TQn0537TGVE88rA8r8HxAQhHnUZagpELXroYk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=hFgUzsLJScjfIa+MDaWqrPU5y4cUpz2AHD/xIW6Kl39YwklWHTinXmEFm1smQimva
	 a8H1bewpgWCIfEXzY63OSssxZJ7AavTw4eop4OSIIt32WcwVOGOPn1O7AyeKvCLh+r
	 R8tz2FxxmRKGXSwQwcA5vCIn24cqWivzzI/gZQb8=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20260123111802epcas5p4c0bc08c2828d3bb59d4cdf9b175ce2f6~NWBaIm4Cw0751707517epcas5p4w;
	Fri, 23 Jan 2026 11:18:02 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4dyFlt2qPRz2SSKX; Fri, 23 Jan
	2026 11:18:02 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260123110544epcas5p2d764024e614940d46829d86cc153b6d1~NV2rV47NM0461004610epcas5p2P;
	Fri, 23 Jan 2026 11:05:44 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260123110543epsmtip1c4ef553a89411eab677b4b277cb7862c~NV2p9vnSf0205302053epsmtip12;
	Fri, 23 Jan 2026 11:05:43 +0000 (GMT)
Date: Fri, 23 Jan 2026 16:35:37 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Ira Weiny <ira.weiny@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V5 05/17] nvdimm/label: Skip region label during ns
 label DPA reservation
Message-ID: <1296674576.21769167082389.JavaMail.epsvc@epcpadp2new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <697020c95d699_1a50d4100e9@iweiny-mobl.notmuch>
X-CMS-MailID: 20260123110544epcas5p2d764024e614940d46829d86cc153b6d1
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----on9-joxjuqL8vLZJsXK9p6vuNy0FCcc_Bo-VMubfWYorGk78=_11ed47_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20260109124517epcas5p3d11e7d0941bcf34c74a789917c8aa0d0
References: <20260109124437.4025893-1-s.neeraj@samsung.com>
	<CGME20260109124517epcas5p3d11e7d0941bcf34c74a789917c8aa0d0@epcas5p3.samsung.com>
	<20260109124437.4025893-6-s.neeraj@samsung.com>
	<697020c95d699_1a50d4100e9@iweiny-mobl.notmuch>

------on9-joxjuqL8vLZJsXK9p6vuNy0FCcc_Bo-VMubfWYorGk78=_11ed47_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 20/01/26 06:41PM, Ira Weiny wrote:
>Neeraj Kumar wrote:
>> CXL 3.2 Spec mentions CXL LSA 2.1 Namespace Labels at section
>> 9.13.2.5. If Namespace label is present in LSA during
>> nvdimm_probe() then dimm-physical-address(DPA) reservation is
>> required. But this reservation is not required by cxl region
>> label. Therefore if LSA scanning finds any region label, skip it.
>>
>> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>> ---
>>  drivers/nvdimm/label.c | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
>> index 9854cb45fb62..169692dfa12c 100644
>> --- a/drivers/nvdimm/label.c
>> +++ b/drivers/nvdimm/label.c
>> @@ -469,6 +469,14 @@ int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
>>  		lsa_label = to_lsa_label(ndd, slot);
>>  		nd_label = &lsa_label->ns_label;
>>
>> +		/*
>> +		 * Skip region label. If LSA label is region label
>                   ^^^^^^^^^^^^^^^^^^
>		   This is redundant
>> +		 * then it don't require dimm-physical-address(DPA)
>                           ^^^^^
>			   doesn't
>
>> +		 * reservation. Whereas its required for namespace label
>                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>				This is somewhat confusing and redundant
>				as well.
>
>Simply say.
>
>	/*
>	 * If the LSA label is a region label then it doesn't require a
>	 * dimm-physical-address(DPA) reservation.
>	 */
>
>With that.

Fixed it accordingly in V6

>
>Reviewed-by: Ira Weiny <ira.weiny@intel.com>

Thanks Ira.


Regards,
Neeraj

------on9-joxjuqL8vLZJsXK9p6vuNy0FCcc_Bo-VMubfWYorGk78=_11ed47_
Content-Type: text/plain; charset="utf-8"


------on9-joxjuqL8vLZJsXK9p6vuNy0FCcc_Bo-VMubfWYorGk78=_11ed47_--

