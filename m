Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0F13090CD
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 10:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769165876; cv=none; b=teyuk3QbQ2b/OSmvB31E+NL82U6Z7BSt+iWgU1mRjnxKpCKA48o2jqkSGY4eFGwwxg/t7SBrUPsqyAsnwNSa7Hl0G468uu3P2zN+aYFJWT5eB8UegB/6hGJKKIbjc2DyOE20QkAOWSZAI/K9yEL9LVWhnM7cUyu9OMI0WqnUlCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769165876; c=relaxed/simple;
	bh=WquwEY0A0DKnPjd9UYvoC1FPmFP7rI1RH/fZd+Drw0Q=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=Mhx4EfWMCNeAcgmfNpWlNl4ZFfQejHjculs5SIng6FAAKHOi56+Os6I9WKI37RIQ2epm1F2MWSVQVC+nmLsFZTstA8v/20toF9nMk5wlFVEafV9OWBbSp/MF7yHWVye8RMmSNYPyjBWb+mxDisqyws81iXS6Iz8YYLJcdClEsiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=pDNN++r/; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="pDNN++r/"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260123105744epoutp01b4a59343ba21880c2ec376c6acf8d9ba~NVvsNU4PW1921719217epoutp012
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 10:57:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260123105744epoutp01b4a59343ba21880c2ec376c6acf8d9ba~NVvsNU4PW1921719217epoutp012
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1769165864;
	bh=tyXyGUueOthGAt4VqN+mO/e0xyfnLDxdd+HuNJtSid0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=pDNN++r/qSnM0rJn8JHNEu07W3VYLr5XqzALQ9l6cPdwyY7m2Z+xLLYbc7+xj6fLH
	 n1UazxsSHaMEWqpViPayxTSc9NQIx5FTP1qsxOoEBy4DReNqZMUplDzEPJDIRmXMYI
	 6SpBYezu1CxSY2iJRfTTtcSLqacd3sDZks7mDd1w=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20260123105744epcas5p1b00cb259748ae361ddf939c37b11ee14~NVvr7AxI61322113221epcas5p16;
	Fri, 23 Jan 2026 10:57:44 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.90]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4dyFJR6HPyz6B9m8; Fri, 23 Jan
	2026 10:57:43 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20260123105743epcas5p3e0e2bb1ec28789a3a49b21b4fa9a42d5~NVvqu7pa61077510775epcas5p38;
	Fri, 23 Jan 2026 10:57:43 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260123105741epsmtip1aab19e574ed4c8883fbd00620ef443a1~NVvozRnS82834128341epsmtip19;
	Fri, 23 Jan 2026 10:57:41 +0000 (GMT)
Date: Fri, 23 Jan 2026 16:27:35 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V5 03/17] nvdimm/label: Add namespace/region label
 support as per LSA 2.1
Message-ID: <20260123105735.xttty5ol3ltet4vy@test-PowerEdge-R740xd>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260115174532.0000716e@huawei.com>
X-CMS-MailID: 20260123105743epcas5p3e0e2bb1ec28789a3a49b21b4fa9a42d5
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----IrfruICR4kMULzJWPGPqiSt5VhS9eUGYkVmPB-DHhmy0YhYM=_11ef45_"
CMS-TYPE: 105P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260109124503epcas5p27010aaf98c7c3735852cbb18bd68458e
References: <20260109124437.4025893-1-s.neeraj@samsung.com>
	<CGME20260109124503epcas5p27010aaf98c7c3735852cbb18bd68458e@epcas5p2.samsung.com>
	<20260109124437.4025893-4-s.neeraj@samsung.com>
	<20260115174532.0000716e@huawei.com>

------IrfruICR4kMULzJWPGPqiSt5VhS9eUGYkVmPB-DHhmy0YhYM=_11ef45_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 15/01/26 05:45PM, Jonathan Cameron wrote:
>On Fri,  9 Jan 2026 18:14:23 +0530
>Neeraj Kumar <s.neeraj@samsung.com> wrote:
>
>> Modify __pmem_label_update() to update region labels into LSA
>>
>> CXL 3.2 Spec mentions CXL LSA 2.1 Namespace Labels at section 9.13.2.5
>> Modified __pmem_label_update() using setter functions to update
>> namespace label as per CXL LSA 2.1
>>
>> Create export routine nd_region_label_update() used for creating
>> region label into LSA. It will be used later from CXL subsystem
>>
>> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>
>Hi Neeraj,
>
>There are a few more instances of copying in and out of UUIDs that
>should be using the import and export functions.
>
>With those fixed up,
>Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
>
>> ---
>>  drivers/nvdimm/label.c          | 360 ++++++++++++++++++++++++++------
>>  drivers/nvdimm/label.h          |  17 +-
>>  drivers/nvdimm/namespace_devs.c |  20 +-
>>  drivers/nvdimm/nd.h             |  51 +++++
>>  include/linux/libnvdimm.h       |   8 +
>>  5 files changed, 386 insertions(+), 70 deletions(-)
>>
>> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
>> index 0a9b6c5cb2c3..17e2a1f5a6da 100644
>> --- a/drivers/nvdimm/label.c
>> +++ b/drivers/nvdimm/label.c
>
>
>> +static void region_label_update(struct nd_region *nd_region,
>> +				struct cxl_region_label *region_label,
>> +				struct nd_mapping *nd_mapping,
>> +				int pos, u64 flags, u32 slot)
>> +{
>> +	struct nd_interleave_set *nd_set = nd_region->nd_set;
>> +	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
>> +
>> +	/* Set Region Label Format identification UUID */
>> +	uuid_copy((uuid_t *)region_label->type, &cxl_region_uuid);
>
>
>Why is this one not an export_uuid()?

Yes I have used it to avoid extra typecasting in v6

>
>
>> +
>> +static inline bool is_region_label(struct nvdimm_drvdata *ndd,
>> +				   union nd_lsa_label *lsa_label)
>> +{
>> +	if (!ndd->cxl)
>> +		return false;
>> +
>> +	return uuid_equal(&cxl_region_uuid,
>> +			  (uuid_t *)lsa_label->region_label.type);
>As below.
>> +}
>> +
>> +static inline bool
>> +region_label_uuid_equal(struct cxl_region_label *region_label,
>> +			const uuid_t *uuid)
>> +{
>> +	return uuid_equal((uuid_t *)region_label->uuid, uuid);
>
>Not appropriate to do an import_uuid() for this and similar cases?
>In general I don't think we should see any casts to uuid_t *
>
>There are 3 instances of this in the kernel and we should probably clean
>all those up.  There are a lot more doing the import!

I have used import_uuid() accordingly in v6 and will be sending it soon



Regards,
Neeraj

------IrfruICR4kMULzJWPGPqiSt5VhS9eUGYkVmPB-DHhmy0YhYM=_11ef45_
Content-Type: text/plain; charset="utf-8"


------IrfruICR4kMULzJWPGPqiSt5VhS9eUGYkVmPB-DHhmy0YhYM=_11ef45_--
