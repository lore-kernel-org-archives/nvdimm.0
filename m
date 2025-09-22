Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF844267AF2
	for <nvdimm@lists.linux.dev>; Mon, 22 Sep 2025 12:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758545502; cv=none; b=mBaXuGZFn0XJMDAf7NrwMdVKbKXJVyUp7tUtciepl1nyC56CZoVh3jlTXalCUsD76RfK2CbAnJuxm8iHoE4aKU5pU5fAnctdJLY4XrC7FbEhs/o/VGyXfsS0zFN/3zRGY4Co6eOGm61VsuN3RRn29M+d/GT7l9F4gM+YiwHuhic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758545502; c=relaxed/simple;
	bh=ZQ5VUijvYpFvcyKNThwBlQAIlb7oH7NFolfh4z9Dr98=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=LxqISIs6T6N9loTIfH4Ki+++YkAQs5ECiqtfRn24Y7ul3jqeSeITn+YTPhTx6feCXJnx1ZotWzuFnmLsjaGR5M8+3fp/W6A7UGeFD7cVoXAERgr1pTcRYrYExJ6muLnHHf+J9AkrA6Bajf2Wxnk64Ua9ItoA0DpNYo7H0K9Y2EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=AX0tZCik; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="AX0tZCik"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250922125137epoutp0449edebf7f73fcf275928a91fd7fe7c4b~nm9AfT7fz2715527155epoutp04F
	for <nvdimm@lists.linux.dev>; Mon, 22 Sep 2025 12:51:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250922125137epoutp0449edebf7f73fcf275928a91fd7fe7c4b~nm9AfT7fz2715527155epoutp04F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1758545497;
	bh=HYKpfIouK921vQ6QGHevYxod5Jzj4y8Z8mu37Q92pkQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=AX0tZCik32940iGDLI1f49OSHAKkS2a5SUJ3wFKhIIa3Jv/io1GR2nT2sN4xtJbT7
	 dPS0FAlhERk5PoYMP45zSHyuPlkArcCeB71/nFEpxcpOiqloTwUmLrMLJzHXMf8JgK
	 rdbxW7wDrW/aJ6aCijLvwln+2kDNxVclVUvsOcRY=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250922125137epcas5p33b1bb74798ea240fe00b72dd28bdb560~nm9AQ_CM41720517205epcas5p3k;
	Mon, 22 Sep 2025 12:51:37 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.88]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4cVjfc3V7Xz6B9m5; Mon, 22 Sep
	2025 12:51:36 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250922125135epcas5p3ac2131266f68cc18eaed3921a42bdf9b~nm8_pSBu81431814318epcas5p3u;
	Mon, 22 Sep 2025 12:51:35 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250922125134epsmtip1cbbc4d374f9f2829a520f3f1670c2f7c~nm89m51rS0171401714epsmtip1K;
	Mon, 22 Sep 2025 12:51:34 +0000 (GMT)
Date: Mon, 22 Sep 2025 18:21:25 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com
Subject: Re: [PATCH V3 04/20] nvdimm/label: Update mutex_lock() with
 guard(mutex)()
Message-ID: <20250922125125.tm3yapxoxd5lhmat@test-PowerEdge-R740xd>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250917154656.00001c2f@huawei.com>
X-CMS-MailID: 20250922125135epcas5p3ac2131266f68cc18eaed3921a42bdf9b
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="-----ZxWg4Xdj5J3Rn97nhBblfMsRvMrJ.qI_ZCg1wtmDaptzyAW=_26db1_"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250917133034epcas5p2c9485e40fce4c3a5a826cc94d515b25d
References: <20250917132940.1566437-1-s.neeraj@samsung.com>
	<CGME20250917133034epcas5p2c9485e40fce4c3a5a826cc94d515b25d@epcas5p2.samsung.com>
	<20250917132940.1566437-5-s.neeraj@samsung.com>
	<20250917154656.00001c2f@huawei.com>

-------ZxWg4Xdj5J3Rn97nhBblfMsRvMrJ.qI_ZCg1wtmDaptzyAW=_26db1_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 17/09/25 03:46PM, Jonathan Cameron wrote:
>On Wed, 17 Sep 2025 18:59:24 +0530
>Neeraj Kumar <s.neeraj@samsung.com> wrote:
>
>> Updated mutex_lock() with guard(mutex)()
>
>Say why.

Sure, I will update it in next patch-set.

>>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>> ---
>>  drivers/nvdimm/label.c | 36 +++++++++++++++++-------------------
>>  1 file changed, 17 insertions(+), 19 deletions(-)
>>
>> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
>> index 668e1e146229..3235562d0e1c 100644
>> --- a/drivers/nvdimm/label.c
>> +++ b/drivers/nvdimm/label.c
>> @@ -948,7 +948,7 @@ static int __pmem_label_update(struct nd_region *nd_region,
>>  		return rc;
>> +	list_for_each_entry(label_ent, &nd_mapping->labels, list)
>> +		if (!label_ent->label) {
>> +			label_ent->label = nd_label;
>> +			nd_label = NULL;
>> +			break;
>
>Perhaps it will change in later patches, but you could have done
>		if (!label_ent->label) {
>			label_ent->label = nd_label;
>			return;
>		}
>as nothing else happens if we find a match.

Yes, I have updated it in later patch. I will update it here itself.

>
>> +		}
>> @@ -998,9 +998,8 @@ static int init_labels(struct nd_mapping *nd_mapping, int num_labels)
>>  		label_ent = kzalloc(sizeof(*label_ent), GFP_KERNEL);
>>  		if (!label_ent)
>>  			return -ENOMEM;
>> -		mutex_lock(&nd_mapping->lock);
>> +		guard(mutex)(&nd_mapping->lock);
>>  		list_add_tail(&label_ent->list, &nd_mapping->labels);
>> -		mutex_unlock(&nd_mapping->lock);
>
>Not sure I'd bother with cases like this but harmless.
>
>>  	}
>>
>> -	mutex_lock(&nd_mapping->lock);
>> +	guard(mutex)(&nd_mapping->lock);
>>  	list_for_each_entry_safe(label_ent, e, &nd_mapping->labels, list) {
>>  		struct nd_namespace_label *nd_label = label_ent->label;
>>
>> @@ -1061,7 +1060,6 @@ static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
>>  		nd_mapping_free_labels(nd_mapping);
>>  		dev_dbg(ndd->dev, "no more active labels\n");
>>  	}
>> -	mutex_unlock(&nd_mapping->lock);
>This is a potential functional change as the lock is held for longer than before.
>nd_label_write_index is not trivial so reviewing if that is safe is not trivial.
>
>The benefit is small so far (maybe that changes in later patches) so I would not
>make the change.

Sure, I will revert it back in next patch-set

Regards,
Neeraj

>
>
>
>>
>>  	return nd_label_write_index(ndd, ndd->ns_next,
>>  			nd_inc_seq(__le32_to_cpu(nsindex->seq)), 0);
>

-------ZxWg4Xdj5J3Rn97nhBblfMsRvMrJ.qI_ZCg1wtmDaptzyAW=_26db1_
Content-Type: text/plain; charset="utf-8"


-------ZxWg4Xdj5J3Rn97nhBblfMsRvMrJ.qI_ZCg1wtmDaptzyAW=_26db1_--
