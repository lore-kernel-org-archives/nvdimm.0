Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5597302CA5
	for <nvdimm@lists.linux.dev>; Thu,  4 Sep 2025 13:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756992476; cv=none; b=PlGB2//CLFMeARy1PHfLCww6aNlauamfjJ1S+fdb0mmeRSBDoXdZskpd/vNp4NHh4ThMPewMqI97WH697eABjIQyxG0X9vl6Yn8JocbdGOscDOdUvA2wbfY409jXkZsOa8cr70wBgV+7cxAbwnaq4px99uhQ+Q4tFQwxuuWCz3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756992476; c=relaxed/simple;
	bh=XIaYkp2Nabj8KeoFRekkVslBUKQFHWPznLqeMdwxPEE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=n4QZ4VIDs6ozQ93HW1sqlmESRJh3eD1pd+hxH4NUi/qheEs0Cps+dMHLoJ7D6KZbWQWyfN8kaviCczXo1zqEtqp5s/WKB2OaHLXrDvrSQ2sdpytA8i7b67ExTjVb4gm1ASsCA5A8mcj4jpOpEIjtntTlf8SwqMKKnofoAW71KbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=cVxRy02c; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="cVxRy02c"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250904132752epoutp03494d092de759cccf9d9342e22e438dbd~iF1hOiXFI1078810788epoutp03Z
	for <nvdimm@lists.linux.dev>; Thu,  4 Sep 2025 13:27:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250904132752epoutp03494d092de759cccf9d9342e22e438dbd~iF1hOiXFI1078810788epoutp03Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1756992472;
	bh=eyrpwi3oLSt9Eb3tzU8NOFFzEAFyZWmRa3YR3jeIKqU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=cVxRy02ckJjjESCXWf93EzXvSvQdpAsdJfZnifP1w9SBtN+1XK3evzdpbkfAtfhcB
	 +38aBlwSgeLiWrX5p5DP+N0rIrwMnE39qEpGORoUMo7fiOFPaoTvSWpjTRR1KiDXy+
	 AM8eZRyTXGTAKskf/T1UojEhaz+/91zCCegYndqw=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20250904132751epcas5p23a7c55eddcfa228edf50ea294b761fbf~iF1gSgn2I3240432404epcas5p2f;
	Thu,  4 Sep 2025 13:27:51 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.91]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4cHgJk57sGz2SSKY; Thu,  4 Sep
	2025 13:27:50 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250904132750epcas5p156537476d841f76b095bc4ba85ef62cd~iF1fAr_9B1674716747epcas5p1L;
	Thu,  4 Sep 2025 13:27:50 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250904132749epsmtip154c80c7dc159b92be16239138fc2f3ac~iF1d3mWlu3151031510epsmtip1x;
	Thu,  4 Sep 2025 13:27:48 +0000 (GMT)
Date: Thu, 4 Sep 2025 18:57:43 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V2 02/20] nvdimm/label: Prep patch to accommodate cxl
 lsa 2.1 support
Message-ID: <20250904132743.qhagt7jonhyjggmn@test-PowerEdge-R740xd>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250813142349.000032a4@huawei.com>
X-CMS-MailID: 20250904132750epcas5p156537476d841f76b095bc4ba85ef62cd
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----kMDsK0IEhKoUUkzyxABlnve5J-Otg2bCPR2yRM97vA1oUAWq=_ea658_"
CMS-TYPE: 105P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250730121224epcas5p3c3a6563ce186d2fdb9c3ff5f66e37f3e
References: <20250730121209.303202-1-s.neeraj@samsung.com>
	<CGME20250730121224epcas5p3c3a6563ce186d2fdb9c3ff5f66e37f3e@epcas5p3.samsung.com>
	<20250730121209.303202-3-s.neeraj@samsung.com>
	<20250813142349.000032a4@huawei.com>

------kMDsK0IEhKoUUkzyxABlnve5J-Otg2bCPR2yRM97vA1oUAWq=_ea658_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 13/08/25 02:23PM, Jonathan Cameron wrote:
>On Wed, 30 Jul 2025 17:41:51 +0530
>Neeraj Kumar <s.neeraj@samsung.com> wrote:
>
>> LSA 2.1 format introduces region label, which can also reside
>> into LSA along with only namespace label as per v1.1 and v1.2
>>
>> As both namespace and region labels are of same size of 256 bytes.
>> Thus renamed "struct nd_namespace_label" to "struct nd_lsa_label",
>> where both namespace label and region label can stay as union.
>
>Maybe add something on why it makes sense to use a union rather than
>new handling.

Currently we have support of LSA v1.1 and v1.2 in Linux, Where LSA can
only accommodate only one type of labels, which is namespace label.

But as per LSA 2.1, LSA can accommodate both namespace and region
labels.

As v1.1 and v1.2 only namespace label therefore we have "struct
nd_namespace_label"

As this patch-set supports LSA 2.1, where an LSA can have any of
namespace or region label.
It is therefore, introduced "struct nd_lsa_label" in-place of "struct
nd_namespace_label"

I understand that this renaming has created some extra noise in existing
code. May be I will revisit this change and try using region label handling
separately instead of using union.

>
>>
>> No functional change introduced.
>>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>> ---
>A few minor comments inline.
>
>
>> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
>> index 55cfbf1e0a95..bdf1ed6f23d8 100644
>> --- a/drivers/nvdimm/namespace_devs.c
>> +++ b/drivers/nvdimm/namespace_devs.c
>> @@ -1615,17 +1619,21 @@ static int select_pmem_id(struct nd_region *nd_region, const uuid_t *pmem_id)
>>  	for (i = 0; i < nd_region->ndr_mappings; i++) {
>>  		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
>>  		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
>> +		struct nd_lsa_label *lsa_label = NULL;
>Why not pull this into the scope below.
>
>>  		struct nd_namespace_label *nd_label = NULL;
>>  		u64 hw_start, hw_end, pmem_start, pmem_end;
>>  		struct nd_label_ent *label_ent;
>>
>>  		lockdep_assert_held(&nd_mapping->lock);
>>  		list_for_each_entry(label_ent, &nd_mapping->labels, list) {
>e.g.
>			struct nd_lsa_label *lsa_label = label_ent->label;
>
>then no need to set it to NULL later.

Thanks Jonathan, I will fix it in next patch-set

Regards,
Neeraj

------kMDsK0IEhKoUUkzyxABlnve5J-Otg2bCPR2yRM97vA1oUAWq=_ea658_
Content-Type: text/plain; charset="utf-8"


------kMDsK0IEhKoUUkzyxABlnve5J-Otg2bCPR2yRM97vA1oUAWq=_ea658_--
