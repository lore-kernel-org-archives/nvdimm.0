Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5215628AAE0
	for <nvdimm@lists.linux.dev>; Thu, 26 Jun 2025 13:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750944009; cv=none; b=HZ8+hybzogZ3uQxDpohOzyP7Llu6ArD6uOyZ2XEdkx9qGkdvo4pz9CzOUVVgoARWh+lsY3d1+9zbTMHIIQ9GoxPVsUFg3kGSvOT38EKvXlL0oWjPvqMAmQQY8UNwrQnytUMpx25plfLLY3mJ3k1swoue47/BShsdXrjPnfxP+Ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750944009; c=relaxed/simple;
	bh=/IE0+ifdz/3NrJF66/a1x4+PKSE8+uAT4MhvIvQqXyQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=PW6D8f6PPR700w2Aal+SHrODTJ9UR9TdjQypsvx7yWK7q6QY7nt2twbar+M2MetKHb7q8IC+vmOW1ggI+FRW4r6RnL7UcHooxYnUPbFxF4lyLFLPfGmdiQSgxwFP9+xmUSsLl4jnFNukTqre8GDGcogGRhsbQwd10AU6Qm3iprQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ilP0YvcR; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ilP0YvcR"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250626132003epoutp040b57d3add3b83fe665f21c7025fbfbc8~MmktJVoev2388223882epoutp04m
	for <nvdimm@lists.linux.dev>; Thu, 26 Jun 2025 13:20:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250626132003epoutp040b57d3add3b83fe665f21c7025fbfbc8~MmktJVoev2388223882epoutp04m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1750944003;
	bh=I5JcAEe/4zceVbGhUwD2L0e4zZHqXUfFE2RobDr4pR4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ilP0YvcRTCLwWulMhztIZio0BYW9SAucGRpSG0YrRrlCVK2RynOIEO5QKXF3k5Jc2
	 BAPsqiWUVyfMomijeMB8+zf5cyy9mEPbn+mYYQD5AdFmKr6qyXtaghzfUmQrNQ6dHO
	 ibrixVZOJgkukGoPzhUSCOQUCukXXdtVoSYzL26Y=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20250626132002epcas5p4bb42ba9de5d24bd201d87fb5d84b90ae~MmksklSoX2645726457epcas5p4d;
	Thu, 26 Jun 2025 13:20:02 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4bSfS24TWHz6B9m5; Thu, 26 Jun
	2025 13:20:02 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250626095541epcas5p4364426b84e7db8de6bee1eabf496fd17~MjyRCoaqi2940929409epcas5p4Q;
	Thu, 26 Jun 2025 09:55:41 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250626095538epsmtip2adc6a46116c34577557c4df4a4f65626~MjyOooTKp2490224902epsmtip2O;
	Thu, 26 Jun 2025 09:55:38 +0000 (GMT)
Date: Thu, 26 Jun 2025 15:25:32 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: dan.j.williams@intel.com, dave@stgolabs.net, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com,
	a.manzanares@samsung.com, nifan.cxl@gmail.com, anisa.su@samsung.com,
	vishak.g@samsung.com, krish.reddy@samsung.com, arun.george@samsung.com,
	alok.rathore@samsung.com, neeraj.kernel@gmail.com,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, gost.dev@samsung.com, cpgs@samsung.com
Subject: Re: [RFC PATCH 06/20] nvdimm/region_label: Add region label
 deletion routine
Message-ID: <1983025922.01750944002610.JavaMail.epsvc@epcpadp1new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250623100957.000032a2@huawei.com>
X-CMS-MailID: 20250626095541epcas5p4364426b84e7db8de6bee1eabf496fd17
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----h0bZ1fOXZXBKxlzn_9r8J_wZFA-mIVa_VlXZDLVzFug9RPyR=_cda86_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250617124022epcas5p2441d6c5dfaeceb744b5fc00add7ceae0
References: <20250617123944.78345-1-s.neeraj@samsung.com>
	<CGME20250617124022epcas5p2441d6c5dfaeceb744b5fc00add7ceae0@epcas5p2.samsung.com>
	<1256440269.161750165204630.JavaMail.epsvc@epcpadp1new>
	<20250623100957.000032a2@huawei.com>

------h0bZ1fOXZXBKxlzn_9r8J_wZFA-mIVa_VlXZDLVzFug9RPyR=_cda86_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 23/06/25 10:09AM, Jonathan Cameron wrote:
>On Tue, 17 Jun 2025 18:09:30 +0530
>Neeraj Kumar <s.neeraj@samsung.com> wrote:
>
>> Added cxl v2.1 format region label deletion routine. This function is
>> used to delete region label from LSA
>>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>> ---
>>  drivers/nvdimm/label.c          | 75 ++++++++++++++++++++++++++++++---
>>  drivers/nvdimm/label.h          |  6 +++
>>  drivers/nvdimm/namespace_devs.c | 12 ++++++
>>  drivers/nvdimm/nd.h             |  9 ++++
>>  include/linux/libnvdimm.h       |  1 +
>>  5 files changed, 98 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
>> index 7f33d14ce0ef..9381c50086fc 100644
>> --- a/drivers/nvdimm/label.c
>> +++ b/drivers/nvdimm/label.c
>> @@ -1034,7 +1034,8 @@ static int init_labels(struct nd_mapping *nd_mapping, int num_labels)
>>  	return max(num_labels, old_num_labels);
>>  }
>>
>> -static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
>> +static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid,
>> +		enum label_type ltype)
>>  {
>>  	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
>>  	struct nd_label_ent *label_ent, *e;
>> @@ -1058,8 +1059,18 @@ static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
>>  		if (!nd_label)
>>  			continue;
>>  		active++;
>> -		if (!nsl_uuid_equal(ndd, &nd_label->ns_label, uuid))
>> -			continue;
>> +
>> +		if (ltype == NS_LABEL_TYPE) {
>
>Perhaps a switch is more appropriate here.
>

Sure will update it in V1

>> +			if (!nsl_uuid_equal(ndd, &nd_label->ns_label, uuid))
>> +				continue;
>> +		} else if (ltype == RG_LABEL_TYPE) {
>> +			if (!nsl_uuid_equal(ndd, &nd_label->ns_label, uuid))
>> +				continue;
>> +		} else {
>> +			dev_err(ndd->dev, "Invalid label type\n");
>> +			return 0;
>> +		}
>> +
>>  		active--;
>>  		slot = to_slot(ndd, nd_label);
>>  		nd_label_free_slot(ndd, slot);
>
>> @@ -1259,6 +1271,59 @@ int nd_pmem_region_label_update(struct nd_region *nd_region)
>>  	return 0;
>>  }
>>
>> +int nd_pmem_region_label_delete(struct nd_region *nd_region)
>> +{
>> +	int i, rc;
>> +	struct nd_interleave_set *nd_set = nd_region->nd_set;
>> +	struct nd_label_ent *label_ent;
>> +	bool is_non_rgl = false;
>> +	int ns_region_cnt = 0;
>> +
>> +	for (i = 0; i < nd_region->ndr_mappings; i++) {
>> +		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
>> +		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
>> +
>> +		/* Find non cxl format supported ndr_mappings */
>> +		if (!ndd->cxl)
>> +			is_non_rgl = true;
>> +
>> +		/* Find if any NS label using this region */
>> +		mutex_lock(&nd_mapping->lock);
>> +		list_for_each_entry(label_ent, &nd_mapping->labels, list) {
>> +			if (!label_ent->label)
>> +				continue;
>> +
>> +			/* Check if any available NS labels has same
>
>Looks like wrong style for multiline comments in this file.
>
>			/*
>			 * Check ...
>

Thanks, Will update it accordingly in V1

>> +			 * region_uuid in LSA
>> +			 */
>> +			if (nsl_region_uuid_equal(&label_ent->label->ns_label,
>> +						  &nd_set->uuid))
>> +				ns_region_cnt++;
>> +		}
>> +		mutex_unlock(&nd_mapping->lock);
>> +	}
>> +
>> +	if (is_non_rgl) {
>> +		dev_dbg(&nd_region->dev, "Region label deletion unsupported\n");
>> +		return -EINVAL;
>
>Why not bail out where you originally detect that above?
>

Thanks, Will fix it in V1

>> +	}
>> +
>> +	if (ns_region_cnt) {
>> +		dev_dbg(&nd_region->dev, "Region/Namespace label in use\n");
>> +		return -EBUSY;
>> +	}
>> +
>> +	for (i = 0; i < nd_region->ndr_mappings; i++) {
>> +		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
>> +
>> +		rc = del_labels(nd_mapping, &nd_set->uuid, RG_LABEL_TYPE);
>> +		if (rc)
>> +			return rc;
>> +	}
>> +
>> +	return 0;
>> +}
>

------h0bZ1fOXZXBKxlzn_9r8J_wZFA-mIVa_VlXZDLVzFug9RPyR=_cda86_
Content-Type: text/plain; charset="utf-8"


------h0bZ1fOXZXBKxlzn_9r8J_wZFA-mIVa_VlXZDLVzFug9RPyR=_cda86_--

