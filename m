Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB32932F76C
	for <nvdimm@lists.linux.dev>; Fri,  5 Sep 2025 07:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757055787; cv=none; b=LBYA34yUzi3asAfA3Y6nVXPMDWyPmsjwrebrckq7y/PyxnapfzIEu5gQuLH35N7XW8ihpCn8PJW1eDBmqP/hcbqSXN9LL9xZ1pzQu3allwJS54uxh1ti6/OHlCKxKfpLLGrurTnHO03qwwoK1cEDqppjzYi4lOvCPZYD7pG/cKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757055787; c=relaxed/simple;
	bh=ySAcZ1O/HhEcGZRIBV0cJ92Y3epxlMYYFyZcNDCI64w=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=CIPPRuWHz4ModVVm5MKvhIu0vEMRKGF7zd27h1IU/UlPcNjT12JQ5L9qfHptBfCHCuw+PQHDkwCiAKeiemoNc6N0EYWqXB18oFohpGUEWQSfbbKsJeiTG+EbEdPsZ3+YIUOc8YxSCQlu7xT539FcJCpaIVPZ9ks4bqmG97vcDQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=OuPE5FxJ; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="OuPE5FxJ"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250905070303epoutp044fc539ebe198c963cb1c3c219698ef10~iUOzrZgTe2251422514epoutp04b
	for <nvdimm@lists.linux.dev>; Fri,  5 Sep 2025 07:03:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250905070303epoutp044fc539ebe198c963cb1c3c219698ef10~iUOzrZgTe2251422514epoutp04b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1757055783;
	bh=m5ajDjZHfTK0j0ELw07lpV62uDlapjh3L7Yy9igxN/M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=OuPE5FxJ6YqR/WIPsWHyGLqQ7VNetr60VJeIWd+h7PA8pd/dGVIV1eAuK/AbErRge
	 QsVmHxuocsuJhD7iCAXLN+i9OzWeKv7K8NYeiDiaizYXPw1d3vZde14LEywQLT+5cM
	 0G4Uh0VANRnrAXTW3R9OSp3T0AxgA72O1TKT+1rE=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20250905070302epcas5p4817339b46a5fcfddcd437067d15f36c4~iUOzQUoq30936809368epcas5p4D;
	Fri,  5 Sep 2025 07:03:02 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4cJ6kG4VFvz2SSKn; Fri,  5 Sep
	2025 07:03:02 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250904135119epcas5p22c5d58686c2548fdb3b73f7c2ef4c7c3~iGJ-k9W611055510555epcas5p24;
	Thu,  4 Sep 2025 13:51:19 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250904135118epsmtip2e516b66588de5af08905596e6b730f79~iGJ_VppIy2271922719epsmtip2V;
	Thu,  4 Sep 2025 13:51:18 +0000 (GMT)
Date: Thu, 4 Sep 2025 19:21:13 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Ira Weiny <ira.weiny@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V2 03/20] nvdimm/namespace_label: Add namespace label
 changes as per CXL LSA v2.1
Message-ID: <1983025922.01757055782611.JavaMail.epsvc@epcpadp2new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <68a49f05796ef_27db95294cf@iweiny-mobl.notmuch>
X-CMS-MailID: 20250904135119epcas5p22c5d58686c2548fdb3b73f7c2ef4c7c3
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----OUxkrUiS_5tNAtfPKy2OQMQtEkPPDXVoOsIej.5k6A4J0mxM=_eabc3_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250730121225epcas5p2742d108bd0c52c8d7d46b655892c5c19
References: <20250730121209.303202-1-s.neeraj@samsung.com>
	<CGME20250730121225epcas5p2742d108bd0c52c8d7d46b655892c5c19@epcas5p2.samsung.com>
	<20250730121209.303202-4-s.neeraj@samsung.com>
	<68a49f05796ef_27db95294cf@iweiny-mobl.notmuch>

------OUxkrUiS_5tNAtfPKy2OQMQtEkPPDXVoOsIej.5k6A4J0mxM=_eabc3_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

On 19/08/25 10:57AM, Ira Weiny wrote:
>Neeraj Kumar wrote:
>> CXL 3.2 Spec mentions CXL LSA 2.1 Namespace Labels at section 9.13.2.5
>> Modified __pmem_label_update function using setter functions to update
>> namespace label as per CXL LSA 2.1
>
>But why?  And didn't we just remove nd_namespace_label in patch 2?
>
>Why are we now defining accessor functions for it?
>

Hi Ira,

No we haven't removed nd_namespace_label in patch 2. In patch 2, we have
introduced
lsa_label which contains nd_namespace_label as well as cxl_region_label
under union.

Actually, LSA 2.1 spec introduced new region label along with existing
(v1.1 & v1.2) namespace label
But in v2.1 namespace label members are also modified compared to v1.1 &
v1.2.

New members introduced in namespace label are following

	struct nvdimm_cxl_label {
		u8 type[NSLABEL_UUID_LEN];	--> Filling it with nsl_set_type()
		u8 uuid[NSLABEL_UUID_LEN];
		u8 name[NSLABEL_NAME_LEN];
		__le32 flags;
		__le16 nrange;
		__le16 position;
		__le64 dpa;
		__le64 rawsize;
		__le32 slot;
		__le32 align;			--> Filling it with
		nsl_set_alignment()
		u8 region_uuid[16];		--> Filling it with
		nsl_set_region_uuid()
		u8 abstraction_uuid[16];
		__le16 lbasize;
		u8 reserved[0x56];
		__le64 checksum;
	};

Therefore this patch-set address this modification in namespace label as per v2.1

>>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>> ---
>>  drivers/nvdimm/label.c |  3 +++
>>  drivers/nvdimm/nd.h    | 27 +++++++++++++++++++++++++++
>>  2 files changed, 30 insertions(+)
>>
>> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
>> index 75bc11da4c11..3f8a6bdb77c7 100644
>> --- a/drivers/nvdimm/label.c
>> +++ b/drivers/nvdimm/label.c
>> @@ -933,6 +933,7 @@ static int __pmem_label_update(struct nd_region *nd_region,
>>  	memset(lsa_label, 0, sizeof_namespace_label(ndd));
>>
>>  	nd_label = &lsa_label->ns_label;
>> +	nsl_set_type(ndd, nd_label);
>>  	nsl_set_uuid(ndd, nd_label, nspm->uuid);
>>  	nsl_set_name(ndd, nd_label, nspm->alt_name);
>>  	nsl_set_flags(ndd, nd_label, flags);
>> @@ -944,7 +945,9 @@ static int __pmem_label_update(struct nd_region *nd_region,
>>  	nsl_set_lbasize(ndd, nd_label, nspm->lbasize);
>>  	nsl_set_dpa(ndd, nd_label, res->start);
>>  	nsl_set_slot(ndd, nd_label, slot);
>> +	nsl_set_alignment(ndd, nd_label, 0);
>>  	nsl_set_type_guid(ndd, nd_label, &nd_set->type_guid);
>> +	nsl_set_region_uuid(ndd, nd_label, NULL);
>>  	nsl_set_claim_class(ndd, nd_label, ndns->claim_class);
>>  	nsl_calculate_checksum(ndd, nd_label);
>>  	nd_dbg_dpa(nd_region, ndd, res, "\n");
>> diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
>> index 61348dee687d..651847f1bbf9 100644
>> --- a/drivers/nvdimm/nd.h
>> +++ b/drivers/nvdimm/nd.h
>> @@ -295,6 +295,33 @@ static inline const u8 *nsl_uuid_raw(struct nvdimm_drvdata *ndd,
>>  	return nd_label->efi.uuid;
>>  }
>>
>> +static inline void nsl_set_type(struct nvdimm_drvdata *ndd,
>> +				struct nd_namespace_label *ns_label)
>
>Set type to what?
>

LSA 2.1 spec mentions seperate UUID for namespace label and region
label.

#define CXL_REGION_UUID "529d7c61-da07-47c4-a93f-ecdf2c06f444"
#define CXL_NAMESPACE_UUID "68bb2c0a-5a77-4937-9f85-3caf41a0f93c"
Here we are setting label->type with CXL_NAMESPACE_UUID

In following patch, accordingly we are setting region label->type with
CXL_REGION_UUID

May be I will rename it to nsl_set_type_uuid() in next patch-set.

>Why is driver data passed here?

ndd->cxl is used to segregate between EFI labels (v1.1 & v1.2) and CXL
Labels (v2.1). It was introduced in 5af96835e4daf

>
>This reads as an accessor function for some sort of label class but seems
>to do some back checking into ndd to set the uuid of the label?
>
>At a minimum this should be *_set_uuid(..., uuid_t uuid)  But I'm not
>following this chunk of changes so don't just change it without more
>explaination.

I have created setter function taking inspiration from other members
setter helpers introduced in 8176f14789125

>
>> +{
>> +	uuid_t tmp;
>> +
>> +	if (ndd->cxl) {
>> +		uuid_parse(CXL_NAMESPACE_UUID, &tmp);
>> +		export_uuid(ns_label->cxl.type, &tmp);
>> +	}
>> +}
>> +
>> +static inline void nsl_set_alignment(struct nvdimm_drvdata *ndd,
>> +				     struct nd_namespace_label *ns_label,
>> +				     u32 align)
>
>Why is this needed?

As per CXL spec 3.2 Table - 9-11. Namespace Label Layout
The desired region alignment in multiples of 256 MB:
• 0 = No desired alignment
• 1 = 256-MB desired alignment
• 2 = 512-MB desired alignment
• etc.

In this patch-set we are using 0.

>
>> +{
>> +	if (ndd->cxl)
>> +		ns_label->cxl.align = __cpu_to_le16(align);
>> +}
>> +
>> +static inline void nsl_set_region_uuid(struct nvdimm_drvdata *ndd,
>> +				       struct nd_namespace_label *ns_label,
>> +				       const uuid_t *uuid)
>
>Again why?

This field is used to track namespace label associated with perticular
region label. It stores the region label's UUID

>
>> +{
>> +	if (ndd->cxl)
>> +		export_uuid(ns_label->cxl.region_uuid, uuid);
>
>export does a memcpy() and you are passing it NULL.  Is that safe?
>
>Ira

Thanks Ira for pointing this, Yes it will not be safe with NULL.
Sure I will fix this in next patch-set.


Regards,
Neeraj

------OUxkrUiS_5tNAtfPKy2OQMQtEkPPDXVoOsIej.5k6A4J0mxM=_eabc3_
Content-Type: text/plain; charset="utf-8"


------OUxkrUiS_5tNAtfPKy2OQMQtEkPPDXVoOsIej.5k6A4J0mxM=_eabc3_--

