Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B988B30E0E6
	for <nvdimm@lists.linux.dev>; Mon, 22 Sep 2025 15:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758556388; cv=none; b=jCOH3o9cH4fh6fhxRjoIERJk7TCSDTft9uTs8y6/xjcsWmMXxfgc8mmBD5eWT/BR6bfBC440+EbL7+kuNfBpo6GWZk3KS4Nz8PL1q07QcRBLQEtZHUdEweJLaXPe0F+usk1LUp0YvBhB/jlxbGoVzy43aHN8tHcHit/Ip6fMjGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758556388; c=relaxed/simple;
	bh=a0VM598UmrtwlhEnoREdw/eGGyyu2lW3+nizfHZq7Vw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=PTQh/ipL6J+Z71ihAZmdOr9Mme2LtGPuuNJRObJLC+PDjJhjogJGpPvg6STIsdBW9mB4DZDP0KdRK9eC2KyJkIyoCQpCpdhAlkGescSPy2bXOth/nfcw7uPVsQPfwdIUBrgxZl9nY/KOvj89UW8ptFTm4vzcXQCWex0pi5jAO0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Ml1utP8k; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Ml1utP8k"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250922155303epoutp02de51b8c3397b5d0188311e1d5ab39612~npbamf8J_2556925569epoutp02a
	for <nvdimm@lists.linux.dev>; Mon, 22 Sep 2025 15:53:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250922155303epoutp02de51b8c3397b5d0188311e1d5ab39612~npbamf8J_2556925569epoutp02a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1758556383;
	bh=vQZ4r71Cb4s5PLW+U6pVlKP0LhcG2XqBbROkB8bQCy4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Ml1utP8kGRZuMvSxGUAIGkJl5TmuN9q62qHlFb2ewmDR9KBqxZi2TiMweyOaZUSPc
	 jMToSCMZ7mkhJjZpV4XnQqjge31W9Z+gVFW9C/SUUT9tx5Xoiy1r46EpCjJQirwO3e
	 UyOqR2QINj412RtOR0vJFYkiHQgM6K/exISlVkmI=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20250922155302epcas5p4483db74191ac63160995d0bfcc33eb50~npbaJogbs0767807678epcas5p4F;
	Mon, 22 Sep 2025 15:53:02 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4cVngy6L7gz3hhT3; Mon, 22 Sep
	2025 15:53:02 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250922130121epcas5p1e5708a72f32d70655808270e7ad0adf8~nnFgHTssN0654806548epcas5p1D;
	Mon, 22 Sep 2025 13:01:21 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250922130119epsmtip2858063a29a6239a486d3d124fe6ab444~nnFeLP4Wo0544205442epsmtip2R;
	Mon, 22 Sep 2025 13:01:19 +0000 (GMT)
Date: Mon, 22 Sep 2025 18:31:13 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Ira Weiny <ira.weiny@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V3 04/20] nvdimm/label: Update mutex_lock() with
 guard(mutex)()
Message-ID: <158453976.61758556382881.JavaMail.epsvc@epcpadp2new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <68cee7e7a00f5_1c391729430@iweiny-mobl.notmuch>
X-CMS-MailID: 20250922130121epcas5p1e5708a72f32d70655808270e7ad0adf8
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----ZIrY0_0zhFg6fYJHUyNEB7j3gF23gHMfocaodaZuRcC4aiL3=_26e47_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250917134136epcas5p118f18ce5139d489d90ac608e3887c1fc
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
	<CGME20250917134136epcas5p118f18ce5139d489d90ac608e3887c1fc@epcas5p1.samsung.com>
	<20250917134116.1623730-5-s.neeraj@samsung.com>
	<b66e4c0b-a82f-4c18-8e8b-ba37b6551964@intel.com>
	<68cee7e7a00f5_1c391729430@iweiny-mobl.notmuch>

------ZIrY0_0zhFg6fYJHUyNEB7j3gF23gHMfocaodaZuRcC4aiL3=_26e47_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 20/09/25 12:44PM, Ira Weiny wrote:
>Dave Jiang wrote:
>
>[snip]
>
>> > @@ -998,9 +998,8 @@ static int init_labels(struct nd_mapping *nd_mapping, int num_labels)
>> >  		label_ent = kzalloc(sizeof(*label_ent), GFP_KERNEL);
>> >  		if (!label_ent)
>> >  			return -ENOMEM;
>> > -		mutex_lock(&nd_mapping->lock);
>> > +		guard(mutex)(&nd_mapping->lock);
>> >  		list_add_tail(&label_ent->list, &nd_mapping->labels);
>> > -		mutex_unlock(&nd_mapping->lock);
>>
>> I would not mix and match old and new locking flow in a function. If you are going to convert, then do the whole function. I think earlier in this function you may need a scoped_guard() call.
>>
>
>FWIW I would limit the changes to __pmem_label_update() because that is
>the function which benefits from these changes.
>
>> >  	}
>> >
>> >  	if (ndd->ns_current == -1 || ndd->ns_next == -1)
>> > @@ -1039,7 +1038,7 @@ static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
>> >  	if (!preamble_next(ndd, &nsindex, &free, &nslot))
>> >  		return 0;
>> >
>> > -	mutex_lock(&nd_mapping->lock);
>> > +	guard(mutex)(&nd_mapping->lock);
>>
>> So this change now includes nd_label_write_index() in the lock context as well compare to the old code. So either you should use a scoped_guard() or create a helper function and move the block of code being locked to the helper function with guard() to avoid changing the original code flow.
>>
>
>Sure you could do this but again I don't think these updates are worth
>this amount of work right now.
>

Yes Ira,

Adding change as per Dave's suggestion would require some extra code change which may not be required here.
I will fix the locking in __pmem_label_update() only.


Regards,
Neeraj

------ZIrY0_0zhFg6fYJHUyNEB7j3gF23gHMfocaodaZuRcC4aiL3=_26e47_
Content-Type: text/plain; charset="utf-8"


------ZIrY0_0zhFg6fYJHUyNEB7j3gF23gHMfocaodaZuRcC4aiL3=_26e47_--

