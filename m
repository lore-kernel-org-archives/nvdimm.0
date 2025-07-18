Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91791D63D8
	for <nvdimm@lists.linux.dev>; Sat, 19 Jul 2025 07:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752909488; cv=none; b=pwwK7f78ZehOA1BjMaw+Q89n0y6kevA/xAUbh1A5NX0Z6oBhi1zGDGK3lJvlJDFU5ODiKOsdP6DQEhRdxFVkpMw3mz7JOACKCnk06geiHFjovfTew2gTRykEjs5p1/pX1U8jEvw2AFqnyvRU433vWVKgk2QJo9iTXHzIoSnZdhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752909488; c=relaxed/simple;
	bh=jNYmGlfM3PO40rAxO79BRxgt/OlGDr361/KyPdo76QA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=Pypn30/aNq+nL5QKnWYceJLTWBEtPGSxM4FZ7Wqme7gDB5/8JRKIXmuLUrR+cAXGmGhPWwKaw29qIokRdgskDgI7YN9rIIiejAKCxmvzeHY96m5F2Rs3FHVaZgGrS/c1rJw8VkD43RxgTbdN5RC4wSndf34k/+/TF2/fGGZz4ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=THdAJj63; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="THdAJj63"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250719071804epoutp0432f4c3c29aa5b6c21541f2c1acc0c98c~TleN92-mn1484314843epoutp04x
	for <nvdimm@lists.linux.dev>; Sat, 19 Jul 2025 07:18:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250719071804epoutp0432f4c3c29aa5b6c21541f2c1acc0c98c~TleN92-mn1484314843epoutp04x
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1752909484;
	bh=BV5NwJZ301VpEAHTsZrMy/+/o3tq6lxSpQ1yGSfvrzM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=THdAJj63lO7kmRwN7pkZ51QVum4jOZaiQ5Qr1PrCPufalURQVfhDV+Dl2UYPQ+EEr
	 1Mdgvljsm7W0cFv83j++EFLKOC2ZJ5Ynxx/Eq8An7cfKlSN16kUJWNaeSqvCiKZZv9
	 3j77dPgLAaAGL3q8vbWrFXNyYbB739bLoM50IrWc=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20250719071803epcas5p297ad09c6e6c11325bd8a8e473a81b211~TleNIm0M_3167331673epcas5p2u;
	Sat, 19 Jul 2025 07:18:03 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4bkdKl2V3Kz6B9m8; Sat, 19 Jul
	2025 07:18:03 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250718124814epcas5p131953c4dfe5e9fb84e51635e6d6c71f6~TWVM_e6Th0618706187epcas5p1X;
	Fri, 18 Jul 2025 12:48:14 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250718124811epsmtip27c49fe2c2a4a7625524d4d09031e2163~TWVKkf0W11950019500epsmtip2J;
	Fri, 18 Jul 2025 12:48:11 +0000 (GMT)
Date: Fri, 18 Jul 2025 18:18:05 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: dan.j.williams@intel.com, dave@stgolabs.net,
	jonathan.cameron@huawei.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com, a.manzanares@samsung.com,
	nifan.cxl@gmail.com, anisa.su@samsung.com, vishak.g@samsung.com,
	krish.reddy@samsung.com, arun.george@samsung.com, alok.rathore@samsung.com,
	neeraj.kernel@gmail.com, linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, gost.dev@samsung.com,
	cpgs@samsung.com
Subject: Re: [RFC PATCH 15/20] cxl: Add a routine to find cxl root decoder
 on cxl bus
Message-ID: <439928219.101752909483341.JavaMail.epsvc@epcpadp2new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <29487b27-ad1a-4c6d-a1a7-26eb97e77663@intel.com>
X-CMS-MailID: 20250718124814epcas5p131953c4dfe5e9fb84e51635e6d6c71f6
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----CDBSwZz52MZUMeM1Rx6lI.cEW_5b_YZAAzr3v09AM7rvldzc=_232af_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250617124049epcas5p1de7eeee3b5ddd12ea221ca3ebf22f6e8
References: <20250617123944.78345-1-s.neeraj@samsung.com>
	<CGME20250617124049epcas5p1de7eeee3b5ddd12ea221ca3ebf22f6e8@epcas5p1.samsung.com>
	<1295226194.21750165382072.JavaMail.epsvc@epcpadp2new>
	<29487b27-ad1a-4c6d-a1a7-26eb97e77663@intel.com>

------CDBSwZz52MZUMeM1Rx6lI.cEW_5b_YZAAzr3v09AM7rvldzc=_232af_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 10/07/25 09:23AM, Dave Jiang wrote:
>
>
>On 6/17/25 5:39 AM, Neeraj Kumar wrote:
>> Add cxl_find_root_decoder to find root decoder on cxl bus. It is used to
>> find root decoder during region creation
>>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>> ---
>>  drivers/cxl/core/port.c | 26 ++++++++++++++++++++++++++
>>  drivers/cxl/cxl.h       |  1 +
>>  2 files changed, 27 insertions(+)
>>
>> diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
>> index 2452f7c15b2d..94d9322b8e38 100644
>> --- a/drivers/cxl/core/port.c
>> +++ b/drivers/cxl/core/port.c
>> @@ -513,6 +513,32 @@ struct cxl_switch_decoder *to_cxl_switch_decoder(struct device *dev)
>>  }
>>  EXPORT_SYMBOL_NS_GPL(to_cxl_switch_decoder, "CXL");
>>
>> +static int match_root_decoder(struct device *dev, void *data)
>> +{
>> +	return is_root_decoder(dev);
>> +}
>> +
>> +/**
>> + * cxl_find_root_decoder() - find a cxl root decoder on cxl bus
>> + * @port: any descendant port in root-cxl-port topology
>
>s/root-cxl-port/CXL port/
>
>Please add a comment noting that the caller of this function must call put_device() when done as a device ref is taken via device_find_child().
>

Thanks Dave for pointing this, Sure I will update it accordingly.


>> + */
>> +struct cxl_root_decoder *cxl_find_root_decoder(struct cxl_port *port)
>
>cxl_port_find_root_decoder(). There is a cxl_find_root_decoder() already in core/region.c and could cause potential symbol clash.
>
>DJ
>

Sure Dave, I will rename it while rebasing for next patch-set


Regards,
Neeraj

------CDBSwZz52MZUMeM1Rx6lI.cEW_5b_YZAAzr3v09AM7rvldzc=_232af_
Content-Type: text/plain; charset="utf-8"


------CDBSwZz52MZUMeM1Rx6lI.cEW_5b_YZAAzr3v09AM7rvldzc=_232af_--

