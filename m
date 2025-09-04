Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F54308F1E
	for <nvdimm@lists.linux.dev>; Thu,  4 Sep 2025 14:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756995640; cv=none; b=ceHjh4YFhMXRiFr5NCWbXW8ejGMBeSYTXJxO/mCN2xssliQGEDFJ4MA04eJtT7EMdTYQEiGkUHcX3+BdnGP0wDJsPfVmdx2g41l6xaXGzyl34PruvHbTCx7Ga06jXh7o5xYEm5rsul85NNIOoTXGS7w0XsaL2aJ0MilYorIKaWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756995640; c=relaxed/simple;
	bh=XJ7qFF3YQtPOr+SxeuSlG0flr7ZR89PoYywxEklkAOA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=j267Ky3Y3ZzmHs3fDEyhfk60niZ3qCPAInOu4wn3uMvxFvdWmkFyhNUxlKoeyf64M2WhSU8hsLnkZ9P2j3e2jmQNCwlJyBD/16Vg39wGN7Yk8RWpmwvhR/01aQ9kozWPZz58stkuu4a8Nryci0FEla2iJtMxdkQ9vAmSiMY3Zoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=e2tERMA4; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="e2tERMA4"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250904142034epoutp0191de702f9962a7f0aca3905687d7d25e~iGjiL3rX03208932089epoutp01V
	for <nvdimm@lists.linux.dev>; Thu,  4 Sep 2025 14:20:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250904142034epoutp0191de702f9962a7f0aca3905687d7d25e~iGjiL3rX03208932089epoutp01V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1756995634;
	bh=CxfA4XyH6dw5hP4xxwzAOR6RtkETdna2VHZuH9Ub5AM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=e2tERMA4T9lNLyChiEz14eU2bJ7aQo2m6YhQ8gKQQLAkvcK2xk6yVWhSJPOU5Iimc
	 vp0J6qISHlI7TQKmF+NmcaGU6ou59R3D9XN6WwVwtbSt3ZZhL4veayxnFGV8p26CQv
	 eeygpcHH0ldinarWRATBj+8xl5YtXt2xt0csOC3c=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250904142034epcas5p31eebd69b25d09b92cfc0d6aab7b25ec9~iGjhlKpax2504725047epcas5p3E;
	Thu,  4 Sep 2025 14:20:34 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.88]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4cHhTY1BzSz2SSKX; Thu,  4 Sep
	2025 14:20:33 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250904142032epcas5p246cc9762014b89641568fd448ddd4356~iGjf14xEl2539225392epcas5p2e;
	Thu,  4 Sep 2025 14:20:32 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250904142031epsmtip1a82f3b5c8771f861e20eaf3845b22c6e~iGjesPMMV2731727317epsmtip1c;
	Thu,  4 Sep 2025 14:20:30 +0000 (GMT)
Date: Thu, 4 Sep 2025 19:50:23 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V2 06/20] nvdimm/region_label: Add region label deletion
 routine
Message-ID: <20250904142023.6zmgow6z5r6sjxcd@test-PowerEdge-R740xd>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250813155338.00007bcf@huawei.com>
X-CMS-MailID: 20250904142032epcas5p246cc9762014b89641568fd448ddd4356
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----At96h8_oYHqdM-HzD.Qv-z6Hqrsj5DpI3AOnKMLFsbTdazMP=_ead72_"
CMS-TYPE: 105P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250730121230epcas5p11650f090de55d0a2db541ee32e9a6fee
References: <20250730121209.303202-1-s.neeraj@samsung.com>
	<CGME20250730121230epcas5p11650f090de55d0a2db541ee32e9a6fee@epcas5p1.samsung.com>
	<20250730121209.303202-7-s.neeraj@samsung.com>
	<20250813155338.00007bcf@huawei.com>

------At96h8_oYHqdM-HzD.Qv-z6Hqrsj5DpI3AOnKMLFsbTdazMP=_ead72_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 13/08/25 03:53PM, Jonathan Cameron wrote:
>On Wed, 30 Jul 2025 17:41:55 +0530
>Neeraj Kumar <s.neeraj@samsung.com> wrote:
>
>> Added cxl v2.1 format region label deletion routine. This function is
>> used to delete region label from LSA
>>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>> ---
>>  drivers/nvdimm/label.c          | 77 ++++++++++++++++++++++++++++++---
>>  drivers/nvdimm/label.h          |  6 +++
>>  drivers/nvdimm/namespace_devs.c | 12 +++++
>>  drivers/nvdimm/nd.h             |  9 ++++
>>  include/linux/libnvdimm.h       |  1 +
>>  5 files changed, 100 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
>> index 94f2d0ba7aca..be18278d6cea 100644
>> --- a/drivers/nvdimm/label.c
>> +++ b/drivers/nvdimm/label.c
>> @@ -1044,7 +1044,8 @@ static int init_labels(struct nd_mapping *nd_mapping, int num_labels)
>>  	return max(num_labels, old_num_labels);
>>  }
>>
>> -static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
>> +static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid,
>> +		enum label_type ltype)
>>  {
>>  	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
>>  	struct nd_label_ent *label_ent, *e;
>> @@ -1068,8 +1069,23 @@ static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
>>  		if (!nd_label)
>>  			continue;
>>  		active++;
>> -		if (!nsl_uuid_equal(ndd, &nd_label->ns_label, uuid))
>> -			continue;
>> +
>> +		switch (ltype) {
>> +		case NS_LABEL_TYPE:
>> +			if (!nsl_uuid_equal(ndd, &nd_label->ns_label, uuid))
>> +				continue;
>> +
>> +			break;
>> +		case RG_LABEL_TYPE:
>> +			if (!rgl_uuid_equal(&nd_label->rg_label, uuid))
>> +				continue;
>> +
>> +			break;
>> +		default:
>> +			dev_err(ndd->dev, "Invalid label type\n");
>> +			return 0;
>
>Given you pass in an enum and both elements are covered by other cases
>shouldn't need a default here.

Thanks Jonathan, I will remove the default case in next patch-set

>
>> +		}
>> +
>>  		active--;
>>  		slot = to_slot(ndd, nd_label);
>>  		nd_label_free_slot(ndd, slot);
>
>
>
>> @@ -1268,6 +1285,56 @@ int nd_pmem_region_label_update(struct nd_region *nd_region)
>>  	return 0;
>>  }
>>
>> +int nd_pmem_region_label_delete(struct nd_region *nd_region)
>> +{
>> +	int i, rc;
>> +	struct nd_interleave_set *nd_set = nd_region->nd_set;
>> +	struct nd_label_ent *label_ent;
>> +	int ns_region_cnt = 0;
>> +
>> +	for (i = 0; i < nd_region->ndr_mappings; i++) {
>> +		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
>> +		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
>> +
>> +		/* Find non cxl format supported ndr_mappings */
>> +		if (!ndd->cxl) {
>> +			dev_info(&nd_region->dev, "Region label unsupported\n");
>
>I'd go with "Unsupported region label".  The other way around kind of implies
>a deficiency in the code, whereas point here is that new stuff may be added to
>the spec that we don't yet understand.

Sure, I will fix it in next patch-set

>
>> +			return -EINVAL;
>> +		}
>> +
>> +		/* Find if any NS label using this region */
>> +		mutex_lock(&nd_mapping->lock);
>
>I'd go for guard here probably as the scope will mean it gets unlocked
>at end of this loop step.
>
>
>		guard(mutex)(&nd_mapping->lock);

Sure Jonathan, I will fix it in next patch-set

Regards,
Neeraj

------At96h8_oYHqdM-HzD.Qv-z6Hqrsj5DpI3AOnKMLFsbTdazMP=_ead72_
Content-Type: text/plain; charset="utf-8"


------At96h8_oYHqdM-HzD.Qv-z6Hqrsj5DpI3AOnKMLFsbTdazMP=_ead72_--
