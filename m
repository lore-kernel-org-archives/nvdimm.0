Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3F533C511
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 11:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959949; cv=none; b=RNOUBm1EIUUDiGqS4SLXqIT62INPFbDTDlG2EO5EWFFx2HQaYNCxh4GjcWj75CqbTRoLd+tv+qT9Qk6T/eb4JYXIw24GcHtkf1PwfUZc+V6YK9142JLhlfwi+ygVQHGBg3NyKxCB9j96jS2eVuOQQLKi+HG+oL5YmTav6/f68IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959949; c=relaxed/simple;
	bh=tvHR0TrBfU72RIjYQ0jMLyco0+xG1E9Wz+oNoTjHLSw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=EdvPPcB9KBRt77Q1VoF+MDJXpb3dyn/IE4xefuhdWzg+pU56wDrI+iUNHs2ZaTTGCqKYhyQsuJ5kQfGe1L85WKBvc4PkgFT+5r4HPHFW/Yb23ZLePF3dsz6X5Aiop+ai6SMjFVY/Sv48D2SG+SBXYea7PI1BlHuDaFGutx3Or50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Sq6/+j9n; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Sq6/+j9n"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260109115906epoutp01605775acacea72896f95ab82e524b19c~JDjRD6QKz3079930799epoutp01P
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 11:59:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260109115906epoutp01605775acacea72896f95ab82e524b19c~JDjRD6QKz3079930799epoutp01P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1767959946;
	bh=Dim+rG+crhCFX8CneU2+TscMrof200uhdZT8B8wcoAQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Sq6/+j9nFHNGOjBWt48Me6ci/WNquK4G3kxLvm+LFcOa1PVPXzTvZMKPZpmui6Xe3
	 7n/AqvN13zx0c6eVT8Wkwlfqq20wCOrMh47DkwgyXc8DMuYwL1AtI8a8wX4wQqJ5LG
	 MN/lbikySmss2szN0f8oC938c3lzndlbhWmrqNgY=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20260109115906epcas5p4b58227d0f3e9611d29220ceb6f7e13e1~JDjQvmp3b0608006080epcas5p47;
	Fri,  9 Jan 2026 11:59:06 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.86]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4dngKj0ckXz3hhT3; Fri,  9 Jan
	2026 11:59:05 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20260109115903epcas5p146b29970c34a5d297f059ef81f1b1a85~JDjOudRxR1218212182epcas5p1u;
	Fri,  9 Jan 2026 11:59:03 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260109115902epsmtip184d36bdecb2b4e01ca80b96a23f92681~JDjNSsElL1378813788epsmtip1G;
	Fri,  9 Jan 2026 11:59:02 +0000 (GMT)
Date: Fri, 9 Jan 2026 17:28:54 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V4 07/17] nvdimm/label: Add region label delete support
Message-ID: <20260109115854.mjzewc5qau3bcuvu@test-PowerEdge-R740xd>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20251217150502.000018fa@huawei.com>
X-CMS-MailID: 20260109115903epcas5p146b29970c34a5d297f059ef81f1b1a85
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----bVwHse4Nykw-L2c5iRRXKf-G.8k0lxUwrpcTFjGaDb9lfltx=_e58a8_"
CMS-TYPE: 105P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251119075319epcas5p2374c721a42a68cfb6f2b17b17c51c0ea
References: <20251119075255.2637388-1-s.neeraj@samsung.com>
	<CGME20251119075319epcas5p2374c721a42a68cfb6f2b17b17c51c0ea@epcas5p2.samsung.com>
	<20251119075255.2637388-8-s.neeraj@samsung.com>
	<20251217150502.000018fa@huawei.com>

------bVwHse4Nykw-L2c5iRRXKf-G.8k0lxUwrpcTFjGaDb9lfltx=_e58a8_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 17/12/25 03:05PM, Jonathan Cameron wrote:
>On Wed, 19 Nov 2025 13:22:45 +0530
>Neeraj Kumar <s.neeraj@samsung.com> wrote:
>
>> Create export routine nd_region_label_delete() used for deleting
>> region label from LSA. It will be used later from CXL subsystem
>>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>A few minor things inline.
>
>Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
>
>> ---
>>  drivers/nvdimm/label.c          | 76 ++++++++++++++++++++++++++++++---
>>  drivers/nvdimm/label.h          |  1 +
>>  drivers/nvdimm/namespace_devs.c | 12 ++++++
>>  drivers/nvdimm/nd.h             |  6 +++
>>  include/linux/libnvdimm.h       |  1 +
>>  5 files changed, 90 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
>> index e90e48672da3..da55ecd95e2f 100644
>> --- a/drivers/nvdimm/label.c
>> +++ b/drivers/nvdimm/label.c
>> @@ -1225,7 +1225,8 @@ static int init_labels(struct nd_mapping *nd_mapping, int num_labels,
>>  	return max(num_labels, old_num_labels);
>>  }
>>
>> -static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
>> +static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid,
>> +		      enum label_type ltype)
>>  {
>>  	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
>>  	struct nd_label_ent *label_ent, *e;
>> @@ -1244,11 +1245,25 @@ static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
>>
>>  	mutex_lock(&nd_mapping->lock);
>>  	list_for_each_entry_safe(label_ent, e, &nd_mapping->labels, list) {
>> -		if (label_ent->label)
>> +		if ((ltype == NS_LABEL_TYPE && !label_ent->label) ||
>> +		    (ltype == RG_LABEL_TYPE && !label_ent->region_label))
>>  			continue;
>>  		active++;
>> -		if (!nsl_uuid_equal(ndd, label_ent->label, uuid))
>> -			continue;
>> +
>> +		switch (ltype) {
>> +		case NS_LABEL_TYPE:
>> +			if (!nsl_uuid_equal(ndd, label_ent->label, uuid))
>> +				continue;
>> +
>> +			break;
>> +		case RG_LABEL_TYPE:
>> +			if (!region_label_uuid_equal(label_ent->region_label,
>> +			    uuid))
>
>Align after equal( or just go a bit long on this line to improve readability.

Fixed it in V5

>
>> +				continue;
>> +
>> +			break;
>> +		}
>> +
>
>> @@ -1381,6 +1399,52 @@ int nd_pmem_region_label_update(struct nd_region *nd_region)
>>  	return 0;
>>  }
>>
>> +int nd_pmem_region_label_delete(struct nd_region *nd_region)
>> +{
>> +	struct nd_interleave_set *nd_set = nd_region->nd_set;
>> +	struct nd_label_ent *label_ent;
>> +	int i, rc;
>> +
>> +	for (i = 0; i < nd_region->ndr_mappings; i++) {
>> +		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
>> +		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
>> +
>> +		/* Find non cxl format supported ndr_mappings */
>> +		if (!ndd->cxl) {
>> +			dev_info(&nd_region->dev, "Unsupported region label\n");
>> +			return -EINVAL;
>> +		}
>> +
>> +		/* Find if any NS label using this region */
>> +		guard(mutex)(&nd_mapping->lock);
>> +		list_for_each_entry(label_ent, &nd_mapping->labels, list) {
>> +			if (!label_ent->label)
>> +				continue;
>> +
>> +			/*
>> +			 * Check if any available NS labels has same
>> +			 * region_uuid in LSA
>> +			 */
>> +			if (nsl_region_uuid_equal(label_ent->label,
>> +						&nd_set->uuid)) {
>> +				dev_dbg(&nd_region->dev,
>> +					"Region/Namespace label in use\n");
>> +				return -EBUSY;
>> +			}
>> +		}
>> +	}
>> +
>> +	for (i = 0; i < nd_region->ndr_mappings; i++) {
>> +		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
>Unless this gets more complex later, I'd not bother with this local variable.

Thanks Jonathan for review, i have fixed it in V5.


Regards,
Neeraj

------bVwHse4Nykw-L2c5iRRXKf-G.8k0lxUwrpcTFjGaDb9lfltx=_e58a8_
Content-Type: text/plain; charset="utf-8"


------bVwHse4Nykw-L2c5iRRXKf-G.8k0lxUwrpcTFjGaDb9lfltx=_e58a8_--
