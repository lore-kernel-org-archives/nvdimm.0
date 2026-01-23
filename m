Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC37212548
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769167085; cv=none; b=dPiz9jO8WJKOkMKWdkriQQkIPqEMVBX2Grl/KbsWhmgshM189aBJpXIhUmGYWwBNJmVkS93PyWrti5UGroz8xNMo0NXYqdZoUtJXnA3TYbPf/VcFa3AcIVnNP3h51b/rb0Wn5R764y9uxMFdgPUQipeZBHH0ln6N+sAXkMAnxeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769167085; c=relaxed/simple;
	bh=r7qscFluQgZeFGXHdkjbcjtanaiyAew8r8We96L6/Ic=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=mcNX7LcLL3yZBzHv4IyBdNNs9dco7i0NrHeD+d1DLdwT76ETJgO0IPDYl01q4vaSHJWHGBi/RwiXTdZGyEHCdK4HNfSJsxC69EsFkry83G5MYku3x36LIYPJiR9fLzqdoDSfE0fuJbrnhQ22HDDFnL/F473k9ws18X4JILJh7aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=gQ/9lSdh; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="gQ/9lSdh"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260123111802epoutp024fa951821ebf50751d6288a46cba4cdd~NWBaRA0Tw1850418504epoutp02_
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:18:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260123111802epoutp024fa951821ebf50751d6288a46cba4cdd~NWBaRA0Tw1850418504epoutp02_
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1769167082;
	bh=go2+U4RP90DRFbF5Az++z8+CrgRRu6tsJZzCEyVb/1U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=gQ/9lSdh03YKnnVD5trrg65rotuQUTWUixo/uiDAyAgUCVDfVtYelTPEOHFefD8rZ
	 iqOZGKt48U4rxBtNQ+GaBKRTNj+g1LE/AoAuK3ddQn5IVpTNN3m3B11H2yud5mRyEM
	 +MJ7iOVgP3sqcVDhthFRI/Xt5AuN/+gqzM8m7XWk=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20260123111802epcas5p4b4400a849d18ec6b8c9653bce5598773~NWBaArAUl0751607516epcas5p41;
	Fri, 23 Jan 2026 11:18:02 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4dyFlt1Pr2z3hhT7; Fri, 23 Jan
	2026 11:18:02 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20260123110237epcas5p32d224ce4c78d0e4922584601ce4b959a~NVz8gCNQD0749807498epcas5p3R;
	Fri, 23 Jan 2026 11:02:37 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260123110234epsmtip24f3a8b3bbadf6cfa420368d088a2879d~NVz6WOaxv0825308253epsmtip2f;
	Fri, 23 Jan 2026 11:02:34 +0000 (GMT)
Date: Fri, 23 Jan 2026 16:32:26 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Ira Weiny <ira.weiny@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V5 04/17] nvdimm/label: Include region label in slot
 validation
Message-ID: <1983025922.01769167082186.JavaMail.epsvc@epcpadp2new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <69680889b4a78_1183cf100e@iweiny-mobl.notmuch>
X-CMS-MailID: 20260123110237epcas5p32d224ce4c78d0e4922584601ce4b959a
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----Rvty6Ov.E7w8fqTiecbGSIlWaDZOz3Joz9WFZpHBwcJNCC2Q=_11f213_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20260109124512epcas5p4a6d8c2b9c6cf7cf794d1a477eaee7865
References: <20260109124437.4025893-1-s.neeraj@samsung.com>
	<CGME20260109124512epcas5p4a6d8c2b9c6cf7cf794d1a477eaee7865@epcas5p4.samsung.com>
	<20260109124437.4025893-5-s.neeraj@samsung.com>
	<69680889b4a78_1183cf100e@iweiny-mobl.notmuch>

------Rvty6Ov.E7w8fqTiecbGSIlWaDZOz3Joz9WFZpHBwcJNCC2Q=_11f213_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 14/01/26 03:20PM, Ira Weiny wrote:
>Neeraj Kumar wrote:
>> Prior to LSA 2.1 Support, label in slot means only namespace
>> label. But with LSA 2.1 a label can be either namespace or
>> region label.
>>
>> Slot validation routine validates label slot by calculating
>> label checksum. It was only validating namespace label.
>> This changeset also validates region label if present.
>>
>> In previous patch to_lsa_label() was introduced along with
>> to_label(). to_label() returns only namespace label whereas
>> to_lsa_label() returns union nd_lsa_label*
>>
>> In this patch We have converted all usage of to_label()
>
>NIT: don't use 'We'

Fixed it in V6

>
>> to to_lsa_label()
>>
>> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
>> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>> ---
>>  drivers/nvdimm/label.c | 94 ++++++++++++++++++++++++++++--------------
>>  1 file changed, 64 insertions(+), 30 deletions(-)
>>
>> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
>> index 17e2a1f5a6da..9854cb45fb62 100644
>> --- a/drivers/nvdimm/label.c
>> +++ b/drivers/nvdimm/label.c
>> @@ -312,16 +312,6 @@ static union nd_lsa_label *to_lsa_label(struct nvdimm_drvdata *ndd, int slot)
>>  	return (union nd_lsa_label *) label;
>>  }
>>
>> -static struct nd_namespace_label *to_label(struct nvdimm_drvdata *ndd, int slot)
>> -{
>> -	unsigned long label, base;
>> -
>> -	base = (unsigned long) nd_label_base(ndd);
>> -	label = base + sizeof_namespace_label(ndd) * slot;
>> -
>> -	return (struct nd_namespace_label *) label;
>> -}
>> -
>>  #define for_each_clear_bit_le(bit, addr, size) \
>>  	for ((bit) = find_next_zero_bit_le((addr), (size), 0);  \
>>  	     (bit) < (size);                                    \
>> @@ -382,7 +372,7 @@ static bool nsl_validate_checksum(struct nvdimm_drvdata *ndd,
>>  {
>>  	u64 sum, sum_save;
>>
>> -	if (!ndd->cxl && !efi_namespace_label_has(ndd, checksum))
>> +	if (!efi_namespace_label_has(ndd, checksum))
>
>What does this change have to do with region label validation during slot
>validation?
>
>>  		return true;
>>
>>  	sum_save = nsl_get_checksum(ndd, nd_label);
>> @@ -397,13 +387,25 @@ static void nsl_calculate_checksum(struct nvdimm_drvdata *ndd,
>>  {
>>  	u64 sum;
>>
>> -	if (!ndd->cxl && !efi_namespace_label_has(ndd, checksum))
>> +	if (!efi_namespace_label_has(ndd, checksum))
>
>This and the above seem like cleanups because efi_namespace_label_has()
>already checks !ndd->cxl?  Was that the intent?  Perhaps as a separate
>cleanup?

Hi Ira,

Actually above is required changes and not the cleanup. 
Earlier condition (!ndd->cxl && !efi_namespace_label_has(ndd, checksum))
was getting true (no further processing) in first case only if its a
region label which we don't want in current case.

And this condition (!efi_namespace_label_has(ndd, checksum)) returns false
(means proceed further) in case if its a region label (!!ndd->cxl).



Regards,
Neeraj

------Rvty6Ov.E7w8fqTiecbGSIlWaDZOz3Joz9WFZpHBwcJNCC2Q=_11f213_
Content-Type: text/plain; charset="utf-8"


------Rvty6Ov.E7w8fqTiecbGSIlWaDZOz3Joz9WFZpHBwcJNCC2Q=_11f213_--

