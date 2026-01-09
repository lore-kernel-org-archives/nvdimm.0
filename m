Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17D6359F98
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 12:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960563; cv=none; b=NmKF2AxyqoPCEiHHM9x0NxTESoWxZRMLzg4lDitO1lt0MAKBAwzSdG/XSQyA+OKkgs8S3J0l1l1YgEJ5uDhdNv1TUJUh6wZIaqIl9L7HD4uXKFFjiJkmNHyX4f6X2NHodd5cuNwVbivXzoKtq5bpqFHqT/AOiMu+wREqNmE8ePw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960563; c=relaxed/simple;
	bh=bIqXdY3QBYUyMWR05ie827CK9US/Y127RlSDbqOvc3A=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=BZQPGwtilDdoji5IqlGhiij/zidb1DaRAHx8oGv5lZa6lCH5OjsHfbfS77MF6/EVBUk7yW5EieaC+hlKTuVRo5kPyo3iD0DzNWU4kCvFtTp5ShWpEC81al4WsCqyIde0EiY0XrVd0TqMowVgcSysxVV74X7WZI9C//SgXl4suYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=td6tEflS; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="td6tEflS"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260109120919epoutp044135aa09801abdfe995986a531068498~JDsMdwrZP0738807388epoutp04d
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 12:09:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260109120919epoutp044135aa09801abdfe995986a531068498~JDsMdwrZP0738807388epoutp04d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1767960559;
	bh=Tk4P4Uvhw4wfUi0S2BJrUG2NoPnKPZgLLdAVIffSwpQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=td6tEflSFETNgVQAGY1p3pHgeT3G3PO5GmArANtmsKU1xmNKPveQPbv8W5Jy1ogPT
	 5So/KW4U371mmd929GT4p23gAcoWEyh9AqHsz0he53hEL37mmQnuAcAoY/ZjUXsUqK
	 k7uUusGBpJW5BiRqsRFuxWfRlPuHtFIRHvuHQNww=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20260109120919epcas5p1aac328d6afa91b7e73d290b074055b47~JDsLxuLuQ3021630216epcas5p10;
	Fri,  9 Jan 2026 12:09:19 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.94]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4dngYV1P0pz6B9m5; Fri,  9 Jan
	2026 12:09:18 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260109120917epcas5p2b5751da2f0aa9b8d66977562491a3e08~JDsKIzOuY2344323443epcas5p2e;
	Fri,  9 Jan 2026 12:09:17 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260109120916epsmtip2d30ec722d10680888ba9972b2b45cbe6~JDsI81lwh2844628446epsmtip2T;
	Fri,  9 Jan 2026 12:09:16 +0000 (GMT)
Date: Fri, 9 Jan 2026 17:39:06 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V4 09/17] nvdimm/label: Export routine to fetch region
 information
Message-ID: <20260109120906.ixjmmqezw6uf2ijj@test-PowerEdge-R740xd>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20251217151230.000048c3@huawei.com>
X-CMS-MailID: 20260109120917epcas5p2b5751da2f0aa9b8d66977562491a3e08
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----dZkOkAIazzHoUX-2rQXwJ8woeHD-_lbejx.E5KOGiu3cq0eS=_e54da_"
CMS-TYPE: 105P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251119075323epcas5p369dea15a390bea0b3690e2a19533f956
References: <20251119075255.2637388-1-s.neeraj@samsung.com>
	<CGME20251119075323epcas5p369dea15a390bea0b3690e2a19533f956@epcas5p3.samsung.com>
	<20251119075255.2637388-10-s.neeraj@samsung.com>
	<20251217151230.000048c3@huawei.com>

------dZkOkAIazzHoUX-2rQXwJ8woeHD-_lbejx.E5KOGiu3cq0eS=_e54da_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 17/12/25 03:12PM, Jonathan Cameron wrote:
>On Wed, 19 Nov 2025 13:22:47 +0530
>Neeraj Kumar <s.neeraj@samsung.com> wrote:
>
>> CXL region information preserved from the LSA needs to be exported for
>> use by the CXL driver for CXL region re-creation.
>To me it feels like the !nvdimm checks may be excessive in an interface
>that makes no sense if NULL is passed in.
>Perhaps drop those?
>
>>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>> ---
>>  drivers/nvdimm/dimm_devs.c | 18 ++++++++++++++++++
>>  include/linux/libnvdimm.h  |  2 ++
>>  2 files changed, 20 insertions(+)
>>
>> diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
>> index 3363a97cc5b5..1474b4e45fcc 100644
>> --- a/drivers/nvdimm/dimm_devs.c
>> +++ b/drivers/nvdimm/dimm_devs.c
>> @@ -280,6 +280,24 @@ void *nvdimm_provider_data(struct nvdimm *nvdimm)
>>  }
>>  EXPORT_SYMBOL_GPL(nvdimm_provider_data);
>>
>> +bool nvdimm_has_cxl_region(struct nvdimm *nvdimm)
>> +{
>> +	if (!nvdimm)
>> +		return false;
>
>Seems a bit odd that this would ever get called on !nvdimm.
>Is that protection worth adding?
>
>> +
>> +	return nvdimm->is_region_label;
>> +}
>> +EXPORT_SYMBOL_GPL(nvdimm_has_cxl_region);
>> +
>> +void *nvdimm_get_cxl_region_param(struct nvdimm *nvdimm)
>> +{
>> +	if (!nvdimm)
>
>This feels a little more plausible as defense but is this
>needed?

Yes we can avoid this check, I have fixed it in V5.


Regards,
Neeraj

------dZkOkAIazzHoUX-2rQXwJ8woeHD-_lbejx.E5KOGiu3cq0eS=_e54da_
Content-Type: text/plain; charset="utf-8"


------dZkOkAIazzHoUX-2rQXwJ8woeHD-_lbejx.E5KOGiu3cq0eS=_e54da_--
