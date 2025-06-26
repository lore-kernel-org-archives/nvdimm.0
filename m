Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B67D2E5431
	for <nvdimm@lists.linux.dev>; Thu, 26 Jun 2025 13:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750944010; cv=none; b=NJC5mS0IuXOidVxTBcwPs+9VBDU2FHQDDEHGCYjwhi1L5rmDc6CoCmi71YDuEzpPX+zItkkSW7LGz+H5ABYR8jIdnlqdXMLmXDCEyoRlzUyAg4t0SdM/JL6ly4RpFocioL5qBWz52ZnkhTyhvDIM+ozmAWejcLn+Nmb4lrwpqo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750944010; c=relaxed/simple;
	bh=nTAcmkuNSsOsG0UMgcEAl/0QHbB0kfoR1wF8PdVKA4Y=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=VQbbCCtE/hYZtShn+GYCD2Ssvl+UI2rStGalqR4oRB4ydECUzYtFrSrfIEU4unCBLrTyuTLkwBj9/pHrMTTD6ri6NpIWHO95NITiKV8r8NPT6mmrHrCwqPTfOr4vKb2ULvSvYgRWz9eChwAddyN9UAEwHv8d7DMFSTN3pXU/Wy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=WVMl2rwF; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="WVMl2rwF"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250626132003epoutp040a85bcdb8f296a04d5419f22414a061f~MmktQZ7-r2561925619epoutp04U
	for <nvdimm@lists.linux.dev>; Thu, 26 Jun 2025 13:20:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250626132003epoutp040a85bcdb8f296a04d5419f22414a061f~MmktQZ7-r2561925619epoutp04U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1750944003;
	bh=4fUi/0sjNWRXt2jLqXYkkX00g95v9CpPtPL9v4x0ccI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=WVMl2rwFvSIvjJUkkpscvwf8pL/+zYLpQPR6ZUkDOlsF1H0BmslQSWtdyVdpY3Pfj
	 oNSmoabU0OP32mfwDOzqbX4wB04ijgFpKRCfSMGStJR5Bbeu6Vg6LqrZlZPHm9DBi5
	 z32k5Pao18nKQlRvgo2qjBw0z+5S3520Cm2MCZeM=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250626132003epcas5p3cef059dd1bec1b3788d8e74bf9a56f42~Mmks7CfyQ1619716197epcas5p3K;
	Thu, 26 Jun 2025 13:20:03 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4bSfS303nNz2SSKZ; Thu, 26 Jun
	2025 13:20:03 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250626095823epcas5p15a77ae68c5c7ca2c5659d9e3da16020c~Mj0oAlY3O0634906349epcas5p10;
	Thu, 26 Jun 2025 09:58:23 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250626095820epsmtip1335eb847d4c1d96f6c5b0ecd6dcce87a~Mj0ln-xxU1533815338epsmtip1M;
	Thu, 26 Jun 2025 09:58:20 +0000 (GMT)
Date: Thu, 26 Jun 2025 15:28:15 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: dan.j.williams@intel.com, dave@stgolabs.net, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com,
	a.manzanares@samsung.com, nifan.cxl@gmail.com, anisa.su@samsung.com,
	vishak.g@samsung.com, krish.reddy@samsung.com, arun.george@samsung.com,
	alok.rathore@samsung.com, neeraj.kernel@gmail.com,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, gost.dev@samsung.com, cpgs@samsung.com
Subject: Re: [RFC PATCH 07/20] nvdimm/namespace_label: Update namespace
 init_labels and its region_uuid
Message-ID: <1296674576.21750944003001.JavaMail.epsvc@epcpadp1new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250623101104.00001ca4@huawei.com>
X-CMS-MailID: 20250626095823epcas5p15a77ae68c5c7ca2c5659d9e3da16020c
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----h0bZ1fOXZXBKxlzn_9r8J_wZFA-mIVa_VlXZDLVzFug9RPyR=_cdaad_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250617124025epcas5p1ce6656fed9ef1175812f80574048cd7a
References: <20250617123944.78345-1-s.neeraj@samsung.com>
	<CGME20250617124025epcas5p1ce6656fed9ef1175812f80574048cd7a@epcas5p1.samsung.com>
	<720167805.241750165205630.JavaMail.epsvc@epcpadp1new>
	<20250623101104.00001ca4@huawei.com>

------h0bZ1fOXZXBKxlzn_9r8J_wZFA-mIVa_VlXZDLVzFug9RPyR=_cdaad_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 23/06/25 10:11AM, Jonathan Cameron wrote:
>On Tue, 17 Jun 2025 18:09:31 +0530
>Neeraj Kumar <s.neeraj@samsung.com> wrote:
>
>> nd_mapping->labels maintains the list of labels present into LSA.
>> init_labels function prepares this list while adding new label
>
>init_labels() prepares
>

Thanks, Will fix it up

>
>> into LSA and updates nd_mapping->labels accordingly. During cxl
>> region creation nd_mapping->labels list and LSA was updated with
>> one region label. Therefore during new namespace label creation
>> pre-include the previously created region label, so increase
>> num_labels count by 1.
>>
>> Also updated nsl_set_region_uuid with region uuid with which
>> namespace is associated with.
>>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>> ---
>>  drivers/nvdimm/label.c | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
>> index 9381c50086fc..108100c4bf44 100644
>> --- a/drivers/nvdimm/label.c
>> +++ b/drivers/nvdimm/label.c
>> @@ -947,7 +947,7 @@ static int __pmem_label_update(struct nd_region *nd_region,
>>  	nsl_set_slot(ndd, ns_label, slot);
>>  	nsl_set_alignment(ndd, ns_label, 0);
>>  	nsl_set_type_guid(ndd, ns_label, &nd_set->type_guid);
>> -	nsl_set_region_uuid(ndd, ns_label, NULL);
>> +	nsl_set_region_uuid(ndd, ns_label, &nd_set->uuid);
>>  	nsl_set_claim_class(ndd, ns_label, ndns->claim_class);
>>  	nsl_calculate_checksum(ndd, ns_label);
>>  	nd_dbg_dpa(nd_region, ndd, res, "\n");
>> @@ -1114,7 +1114,8 @@ int nd_pmem_namespace_label_update(struct nd_region *nd_region,
>>  				count++;
>>  		WARN_ON_ONCE(!count);
>>
>> -		rc = init_labels(nd_mapping, count);
>> +		/* Adding 1 to pre include the already added region label */
>> +		rc = init_labels(nd_mapping, count + 1);
>>  		if (rc < 0)
>>  			return rc;
>>
>

------h0bZ1fOXZXBKxlzn_9r8J_wZFA-mIVa_VlXZDLVzFug9RPyR=_cdaad_
Content-Type: text/plain; charset="utf-8"


------h0bZ1fOXZXBKxlzn_9r8J_wZFA-mIVa_VlXZDLVzFug9RPyR=_cdaad_--

