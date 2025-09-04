Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B636F28725F
	for <nvdimm@lists.linux.dev>; Fri,  5 Sep 2025 07:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757055789; cv=none; b=ToJs7tXO4MFGdnnaPlEnqF4ZDEl1TaEko9m9gLod9iO+wPIbK3GxoYlVzoVtBPnWgNgUFJcfKFKUS64A3rtIeVB/SYnvq7GnlH9nMYGDfpcTuSuCW7+TEaGV5L5GM48LJ9Woyvzh3qsEGGfMw1E5VR7AyI4UMuyurIOtcSqwcaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757055789; c=relaxed/simple;
	bh=75NL5cH0LeLk9wi2Qc92Emfy/KNLOWQ9lGN6IHi5R78=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=KbzuR8mq7S0OOgyTBA5UVtIbi0OzepE7/BAY1OxiUCP3JkSVbdMlXlxauHCh24OnxRGqlUFfigFOZwfP9khpHuRLGBTdShk6snQ0qawhoGQz3Z5f65RaHKDP+TxBHVqefjZqrvap1lIdiE1bo5rBgUjOefb0JdR2SSxa3GmYDiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=RTkYtWvE; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="RTkYtWvE"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250905070303epoutp0390a645427c25b21a556fee6ddac7a176~iUO0XqntF3166331663epoutp030
	for <nvdimm@lists.linux.dev>; Fri,  5 Sep 2025 07:03:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250905070303epoutp0390a645427c25b21a556fee6ddac7a176~iUO0XqntF3166331663epoutp030
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1757055783;
	bh=5BgyrUf28Vn9WZIbT1emfh2pb813YPmBNueJCOM+OYc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=RTkYtWvEDDvjmfWQFPmkiqi8KI7j7DnP/HxFHvxdic4Zz9v8+m7dxbYkIKOj124aK
	 O+smgyvpbYvvhFCCIknAfrScwrs+WtzRGmEq3VhiFBpq5uatJjSdIOngeTGNmlRW/G
	 nZaOVclkr5vqzyNZzQiljLKMaGZuJg0tzypRro5I=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20250905070303epcas5p45540ed8f5a418cce3df1b4051d557e7c~iUO0CiSL60935809358epcas5p4p;
	Fri,  5 Sep 2025 07:03:03 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4cJ6kH3Nbkz3hhT7; Fri,  5 Sep
	2025 07:03:03 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250904141346epcas5p2dc97826ecd00ac595db18c0c813ce49f~iGdlh9Z5R2866028660epcas5p2q;
	Thu,  4 Sep 2025 14:13:46 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250904141344epsmtip2fff19ebc173f7634f4cd549d26a1503b~iGdkZQ4sV0459204592epsmtip2e;
	Thu,  4 Sep 2025 14:13:44 +0000 (GMT)
Date: Thu, 4 Sep 2025 19:43:39 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V2 05/20] nvdimm/region_label: Add region label updation
 routine
Message-ID: <700072760.81757055783458.JavaMail.epsvc@epcpadp2new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <9966a586-8ad2-4724-a37b-298ac0257985@intel.com>
X-CMS-MailID: 20250904141346epcas5p2dc97826ecd00ac595db18c0c813ce49f
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----AO5Z5CA5q82FpJQJAbIGDvoW6m12ppu.cCYhbwpEEtg295OJ=_ead79_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250730121228epcas5p411e5cc6d29fb9417178dbd07a1d8f02d
References: <20250730121209.303202-1-s.neeraj@samsung.com>
	<CGME20250730121228epcas5p411e5cc6d29fb9417178dbd07a1d8f02d@epcas5p4.samsung.com>
	<20250730121209.303202-6-s.neeraj@samsung.com>
	<9966a586-8ad2-4724-a37b-298ac0257985@intel.com>

------AO5Z5CA5q82FpJQJAbIGDvoW6m12ppu.cCYhbwpEEtg295OJ=_ead79_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 15/08/25 04:12PM, Dave Jiang wrote:
>
>
>On 7/30/25 5:11 AM, Neeraj Kumar wrote:
><snip>
>
>> diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
>> index 651847f1bbf9..15d94e3937f0 100644
>> --- a/drivers/nvdimm/nd.h
>> +++ b/drivers/nvdimm/nd.h
>> @@ -322,6 +322,26 @@ static inline void nsl_set_region_uuid(struct nvdimm_drvdata *ndd,
>>  		export_uuid(ns_label->cxl.region_uuid, uuid);
>>  }
>>
>> +static inline bool rgl_uuid_equal(struct cxl_region_label *rg_label,
>> +				  const uuid_t *uuid)
>> +{
>> +	uuid_t tmp;
>> +
>> +	import_uuid(&tmp, rg_label->uuid);
>> +	return uuid_equal(&tmp, uuid);
>
>Why the extra copy via import_uuid() rather than directly compare rg_labe->uuid vs the uuid param?
>
>DJ

Thanks Dave for your suggestion. I have used because of import_uuid()
and uuid_equal() signature difference. Sure I will use uuid_equal()
directly using typecasting and will modify it in next patch-set.

Regards,
Neeraj

------AO5Z5CA5q82FpJQJAbIGDvoW6m12ppu.cCYhbwpEEtg295OJ=_ead79_
Content-Type: text/plain; charset="utf-8"


------AO5Z5CA5q82FpJQJAbIGDvoW6m12ppu.cCYhbwpEEtg295OJ=_ead79_--

