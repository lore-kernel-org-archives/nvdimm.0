Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D90EE358D30
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 12:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961991; cv=none; b=uYBbKUmAroVqCJ4wWic9H0fk1JkmZQxdxUtUV0iGTD8JTRYblRFWO/URO7+x45V2vwyva9DBwgZVO/djoiW0SZXxJZOgse+Hb+1ZbUv5n4UVrglJIh3/snJ0BADMnLgWPD7daEyT7UDsq56ZZ2wj0ZCJG/XgjNiNleGFXqgorLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961991; c=relaxed/simple;
	bh=VorqR7wPuY0wZ2VZADnIOIbyg7Sm15qL9koyoM6NqRA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=TtYK1GtHak6PXMU541GmPVbS73kexl3lV0XDZVWKYea59aP3RlEUxcmcqUhMs3A3Em9+3f5KHcGukpdBvuOXHA95KmYph8Yy1WHvGBWLZvKQKGVWN0hK7W+k5B0pkMoCjsssZDfJmQgSet4RQIUF+W2Gk5sVzIhCGITmC8M3ymI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=FzsPR1QS; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="FzsPR1QS"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260109123307epoutp01b0111fa7acb2f230c232f8f584e7e99b~JEA_aO4_E3029230292epoutp01p
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 12:33:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260109123307epoutp01b0111fa7acb2f230c232f8f584e7e99b~JEA_aO4_E3029230292epoutp01p
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1767961987;
	bh=DaDHOj3/znmKfjU5hi3u6I3lXUKy66vQWlyrvO8qc+Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=FzsPR1QSQWyHfy6J6krGd5RdxTb05SnvGQm5U5+Cj7K6yY7EAKo8yUElDzk7khcss
	 CzDbp6ajBzEjExvdNtitB67AB/uD9E3DtgVmlDI8hfThQh2/yK/ki1+oKjHgqNZIHF
	 Y0up0fxFhH7ACOGt99Q5voUDMULw3hivHc7AVz7Y=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20260109123307epcas5p360a722ae7e0333f8934980bfcc897df7~JEA9_34CI1602016020epcas5p3c;
	Fri,  9 Jan 2026 12:33:07 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.88]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4dnh4y3rzZz6B9m7; Fri,  9 Jan
	2026 12:33:06 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260109123306epcas5p29d9d5a9249c003fa727c05e4f04bb77b~JEA8x-WKv2341723417epcas5p2N;
	Fri,  9 Jan 2026 12:33:06 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260109123302epsmtip2aad8e5f95fc22d2f6a78518186b221a3~JEA5w-_GW1084810848epsmtip2L;
	Fri,  9 Jan 2026 12:33:02 +0000 (GMT)
Date: Fri, 9 Jan 2026 18:02:58 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V4 15/17] cxl/pmem_region: Add sysfs attribute cxl
 region label updation/deletion
Message-ID: <20260109123258.nnqfe6pywc2me4ff@test-PowerEdge-R740xd>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20251217154050.00003293@huawei.com>
X-CMS-MailID: 20260109123306epcas5p29d9d5a9249c003fa727c05e4f04bb77b
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----Rvty6Ov.E7w8fqTiecbGSIlWaDZOz3Joz9WFZpHBwcJNCC2Q=_e58db_"
CMS-TYPE: 105P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251119075337epcas5p2cb576137ca33d6304add4e1ba0b2bdc1
References: <20251119075255.2637388-1-s.neeraj@samsung.com>
	<CGME20251119075337epcas5p2cb576137ca33d6304add4e1ba0b2bdc1@epcas5p2.samsung.com>
	<20251119075255.2637388-16-s.neeraj@samsung.com>
	<20251217154050.00003293@huawei.com>

------Rvty6Ov.E7w8fqTiecbGSIlWaDZOz3Joz9WFZpHBwcJNCC2Q=_e58db_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 17/12/25 03:40PM, Jonathan Cameron wrote:
>On Wed, 19 Nov 2025 13:22:53 +0530
>Neeraj Kumar <s.neeraj@samsung.com> wrote:
>
>> Using these attributes region label is added/deleted into LSA. These
>> attributes are called from userspace (ndctl) after region creation.
>>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>One quick addition to what Dave called out.
>
>Thanks,
>
>Jonathan
>
>> diff --git a/drivers/cxl/core/pmem_region.c b/drivers/cxl/core/pmem_region.c
>> index b45e60f04ff4..be4feb73aafc 100644
>> --- a/drivers/cxl/core/pmem_region.c
>> +++ b/drivers/cxl/core/pmem_region.c
>> @@ -30,9 +30,100 @@ static void cxl_pmem_region_release(struct device *dev)
>>  	kfree(cxlr_pmem);
>>  }
>>
>> +static ssize_t region_label_update_store(struct device *dev,
>> +					 struct device_attribute *attr,
>> +					 const char *buf, size_t len)
>> +{
>> +	struct cxl_pmem_region *cxlr_pmem = to_cxl_pmem_region(dev);
>> +	struct cxl_region *cxlr = cxlr_pmem->cxlr;
>> +	ssize_t rc;
>> +	bool update;
>> +
>> +	rc = kstrtobool(buf, &update);
>> +	if (rc)
>> +		return rc;
>> +
>> +	ACQUIRE(rwsem_write_kill, rwsem)(&cxl_rwsem.region);
>> +	rc = ACQUIRE_ERR(rwsem_write_kill, &rwsem);
>> +	if (rc)
>I'd stick to one style for these.  Elsewhere you have
>	if ((rc = ACQUIRE_ERR())
>

Fixed it accordingly in V5


Regards,
Neeraj

------Rvty6Ov.E7w8fqTiecbGSIlWaDZOz3Joz9WFZpHBwcJNCC2Q=_e58db_
Content-Type: text/plain; charset="utf-8"


------Rvty6Ov.E7w8fqTiecbGSIlWaDZOz3Joz9WFZpHBwcJNCC2Q=_e58db_--
