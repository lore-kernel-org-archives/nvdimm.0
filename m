Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7226730E0C6
	for <nvdimm@lists.linux.dev>; Mon, 22 Sep 2025 15:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758556388; cv=none; b=cMhz6dLQFrWGXLH8eg5rInlnjZ4a56n5mbiYloPRc+ujhtLW+XQysDeXzkevMws7dzaDML6rl6qqPyZAukhhop/jQvGbOuwTZZ9AQmIWQi20qipOZgF8FZ0G/UmK00tp0DzflRVIlCl0MZPDyt7GI2NFkt7rbJb5nOb1M1JS6zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758556388; c=relaxed/simple;
	bh=QRjXyQFSuI4J3thCUkXLzHQGmvtCQn/loIzOPpxNs+U=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=EbG1l/8xv9mHqR4N1WSgdD+jyndc3+YJe4G8UT1WeqwHEG495dFBqNje9YeIA4UXpP/UBwdaWoZeG5RU2/cVVbRq6p+dGSO/q0uQaBDcL0JNuxHD9rimOt/Nti3d5n14iLLEoIZ727IzxSN6TsJUiGyDuY3z9/tZF/ZtQ4/rcGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=FOpL3ggM; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="FOpL3ggM"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250922155303epoutp0451aa0c41f3a9e975563064be81f4f546~npbaUi1wI1922319223epoutp048
	for <nvdimm@lists.linux.dev>; Mon, 22 Sep 2025 15:53:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250922155303epoutp0451aa0c41f3a9e975563064be81f4f546~npbaUi1wI1922319223epoutp048
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1758556383;
	bh=W36mltLmev3mjFYBVD0fRRwSlXih6RCojOhs+gu7fi8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=FOpL3ggMOPi4XIp2KzM0JE08lppxWs+/eVihWJxxJof7waWHlazZ2YvIu+XRabnEL
	 mrsQdkgZAtpGfTpQepkVU7lSM4WMBXaFvDe0vvGKu1aeYRwugBhDFJ0gDYXxGBSaLM
	 KPQB4HB/idDbH73fQzjpAQRvnI63Cs2KxxLm4bWM=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20250922155302epcas5p451082652195f094bf46e43c816b5db81~npbZ_zdk91175111751epcas5p4z;
	Mon, 22 Sep 2025 15:53:02 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4cVngy5321z6B9m5; Mon, 22 Sep
	2025 15:53:02 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250922125700epcas5p4925f1a3a1b0773452a046964ffa4aac9~nnBtD4k3K2405124051epcas5p4Z;
	Mon, 22 Sep 2025 12:57:00 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250922125659epsmtip23d2e35208c7270805e984af5f39155cb~nnBr6JblQ0131301313epsmtip2z;
	Mon, 22 Sep 2025 12:56:59 +0000 (GMT)
Date: Mon, 22 Sep 2025 18:26:54 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Ira Weiny <ira.weiny@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V3 04/20] nvdimm/label: Update mutex_lock() with
 guard(mutex)()
Message-ID: <1931444790.41758556382694.JavaMail.epsvc@epcpadp2new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <68cdd157cf7be_1a2a17294f1@iweiny-mobl.notmuch>
X-CMS-MailID: 20250922125700epcas5p4925f1a3a1b0773452a046964ffa4aac9
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----.2eTkDb0Wtw7DpTqHNw2IdxlY1ZkgCZiGa8-Nl.IQwSrXKTD=_26e6e_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250917134136epcas5p118f18ce5139d489d90ac608e3887c1fc
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
	<CGME20250917134136epcas5p118f18ce5139d489d90ac608e3887c1fc@epcas5p1.samsung.com>
	<20250917134116.1623730-5-s.neeraj@samsung.com>
	<68cdd157cf7be_1a2a17294f1@iweiny-mobl.notmuch>

------.2eTkDb0Wtw7DpTqHNw2IdxlY1ZkgCZiGa8-Nl.IQwSrXKTD=_26e6e_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 19/09/25 04:55PM, Ira Weiny wrote:
>Neeraj Kumar wrote:
>> Updated mutex_lock() with guard(mutex)()
>
>You are missing the 'why' justification here.
>
>The detail is that __pmem_label_update() is getting more complex and this
>change helps to reduce the complexity later.
>
>However...
>
>[snip]
>
>> @@ -998,9 +998,8 @@ static int init_labels(struct nd_mapping *nd_mapping, int num_labels)
>>  		label_ent = kzalloc(sizeof(*label_ent), GFP_KERNEL);
>>  		if (!label_ent)
>>  			return -ENOMEM;
>> -		mutex_lock(&nd_mapping->lock);
>> +		guard(mutex)(&nd_mapping->lock);
>>  		list_add_tail(&label_ent->list, &nd_mapping->labels);
>> -		mutex_unlock(&nd_mapping->lock);
>
>... this change is of little value.  And...
>
>>  	}
>>
>>  	if (ndd->ns_current == -1 || ndd->ns_next == -1)
>> @@ -1039,7 +1038,7 @@ static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
>>  	if (!preamble_next(ndd, &nsindex, &free, &nslot))
>>  		return 0;
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
>
>... this technically changes the scope of the lock to include writing the
>index under the lock.
>
>It does not affect anything AFAICS but really these last two changes
>should be dropped from this patch.
>
>Ira

Sure Ira, I will drop the last two hunks and elaborate commit message.

Regards,
Neeraj

------.2eTkDb0Wtw7DpTqHNw2IdxlY1ZkgCZiGa8-Nl.IQwSrXKTD=_26e6e_
Content-Type: text/plain; charset="utf-8"


------.2eTkDb0Wtw7DpTqHNw2IdxlY1ZkgCZiGa8-Nl.IQwSrXKTD=_26e6e_--

