Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4B51A3BD7
	for <nvdimm@lists.linux.dev>; Thu, 26 Jun 2025 13:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750943709; cv=none; b=APMoI52DtrpFrYhffP4kXfyjyLGDMlNYB+Pn+o22BQnwGLsZzHPoKtI62HN0kMwi1lyUvIbw6vgCEbr6vt3BktY3VohwT1hAjwbqeBJwycxfjymGtSpuiDq9m+JXanL7Y0Uh/sXReDTKgUwOM/srNm+hQEjJFtPFraBm5sTEvHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750943709; c=relaxed/simple;
	bh=ZSgIbHV65OUjPWW+R9rf5sLnxci+8B31HhmlhWW0ph8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=ZP9iJ94KLGS33ZqkERmoZUMXEf50Zm1+oXSnDsZfH4UK2CG1XcdhbOthfQRF5ukmPQOzBEY8Tp76SFAGACbFYk3OeX6Yf7mV/8TXzclitM8AHWcrEv4+3JbT/dw9WJybmNHJIlbQ0Y2fjdfZbSTx0Qw00/8BDMvqEGa5vF4qVB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=rbOnsG5a; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="rbOnsG5a"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250626131504epoutp038a85ba4b150c288ae863dcb6b0fcafae~MmgW3eGmT1339313393epoutp03i
	for <nvdimm@lists.linux.dev>; Thu, 26 Jun 2025 13:15:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250626131504epoutp038a85ba4b150c288ae863dcb6b0fcafae~MmgW3eGmT1339313393epoutp03i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1750943704;
	bh=4evuVLG5EGfIhYC9BEuNbIbuPuG4yhtuxXDxWAZbR2E=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=rbOnsG5aWQf34l17odf8u/vR3bEILpkYixJ0zFtfR/5ziXEGG+AMGWWW1KTByuqtc
	 ZFnDGCyQZA9o9l6Jk30+2+hM70K+1PNcSBb55d5A4Z+ugj9kqBubXXpVxD5cRaQ35m
	 4VyQ5t4VdNjSVOxTUOWE5crY0b2SOoTHO5w/GcuE=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20250626131503epcas5p196400b03aea1d442e9af83bb8c8447a6~MmgVuBBvE1928319283epcas5p1E;
	Thu, 26 Jun 2025 13:15:03 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4bSfLH1gPZz3hhT9; Thu, 26 Jun
	2025 13:15:03 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250626095207epcas5p1139365aff279eebb8d10728d9853feb5~MjvKOJhdL2808428084epcas5p1N;
	Thu, 26 Jun 2025 09:52:07 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250626095204epsmtip2975a762943c55430affa21662dba40fa~MjvHy0kpd2251522515epsmtip2d;
	Thu, 26 Jun 2025 09:52:04 +0000 (GMT)
Date: Thu, 26 Jun 2025 15:21:58 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: dan.j.williams@intel.com, dave@stgolabs.net, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com,
	a.manzanares@samsung.com, nifan.cxl@gmail.com, anisa.su@samsung.com,
	vishak.g@samsung.com, krish.reddy@samsung.com, arun.george@samsung.com,
	alok.rathore@samsung.com, neeraj.kernel@gmail.com,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, gost.dev@samsung.com, cpgs@samsung.com
Subject: Re: [RFC PATCH 02/20] nvdimm/label: Prep patch to accommodate cxl
 lsa 2.1 support
Message-ID: <1296674576.21750943703230.JavaMail.epsvc@epcpadp1new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250623115351.00005312@huawei.com>
X-CMS-MailID: 20250626095207epcas5p1139365aff279eebb8d10728d9853feb5
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----nR.o9xAt.CKA9Q2_7V_sz8FZ15p3Iy14m0uxA3-zFK6OxaPG=_cd11d_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250617124011epcas5p2264e30ec58977907f80d311083265641
References: <20250617123944.78345-1-s.neeraj@samsung.com>
	<CGME20250617124011epcas5p2264e30ec58977907f80d311083265641@epcas5p2.samsung.com>
	<700072760.81750165203833.JavaMail.epsvc@epcpadp1new>
	<20250623115351.00005312@huawei.com>

------nR.o9xAt.CKA9Q2_7V_sz8FZ15p3Iy14m0uxA3-zFK6OxaPG=_cd11d_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 23/06/25 11:53AM, Jonathan Cameron wrote:
>On Tue, 17 Jun 2025 18:09:26 +0530
>Neeraj Kumar <s.neeraj@samsung.com> wrote:
>
>> In order to accommodate cxl lsa 2.1 format region label, renamed
>> nd_namespace_label to nd_lsa_label.
>
>I would add some more information on why.  I've no idea from this
>description whether the issue is a naming clash or a need for a broader
>name or something entirely different.
>
>Most readers aren't going to be particular familiar with the lsa spec
>version changes, so help them out with a little more detail.
>
>The comment you have with the union is probably the right info
>to duplicate here.
>

Thanks Jonathan, I will elaborate commit message with more information.

>>
>> No functional change introduced.
>>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>
>This is quite a lot of churn which, just looking at this patch, could
>be avoided by just setting local variables to point at a particular
>member of the union rather than the containing struct.
>You already do this in a few places like nd_label_reserve_dpa().
>
>Perhaps it will be come clearer why that doesn't make sense as
>I ready later patches.
>

Sure, I will try to minimize wherever its possible.

>> diff --git a/drivers/nvdimm/label.h b/drivers/nvdimm/label.h
>> index 0650fb4b9821..4883b3a1320f 100644
>> --- a/drivers/nvdimm/label.h
>> +++ b/drivers/nvdimm/label.h
>> @@ -183,6 +183,16 @@ struct nd_namespace_label {
>>  	};
>>  };
>>
>> +/*
>> + * LSA 2.1 format introduces region label, which can also reside
>> + * into LSA along with only namespace label as per v1.1 and v1.2
>> + */
>> +struct nd_lsa_label {
>> +	union {
>> +		struct nd_namespace_label ns_label;
>> +	};
>> +};
>
>> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
>> index 55cfbf1e0a95..f180f0068c15 100644
>> --- a/drivers/nvdimm/namespace_devs.c
>> +++ b/drivers/nvdimm/namespace_devs.c
>
>> @@ -1595,7 +1596,8 @@ static bool has_uuid_at_pos(struct nd_region *nd_region, const uuid_t *uuid,
>>  				return false;
>>  			}
>>  			found_uuid = true;
>> -			if (!nsl_validate_nlabel(nd_region, ndd, nd_label))
>> +			if (!nsl_validate_nlabel(nd_region,
>> +						 ndd, &nd_label->ns_label))
>
>Strange wrap.  I'd move ndd up a line.
>
>

Sure, I will fix it in V1

>>  				continue;
>>  			if (position != pos)
>>  				continue;
>> @@ -1615,7 +1617,7 @@ static int select_pmem_id(struct nd_region *nd_region, const uuid_t *pmem_id)
>>  	for (i = 0; i < nd_region->ndr_mappings; i++) {
>>  		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
>>  		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
>> -		struct nd_namespace_label *nd_label = NULL;
>> +		struct nd_lsa_label *nd_label = NULL;
>>  		u64 hw_start, hw_end, pmem_start, pmem_end;
>>  		struct nd_label_ent *label_ent;
>>
>
>
>> @@ -1739,14 +1741,14 @@ static struct device *create_namespace_pmem(struct nd_region *nd_region,
>>  	 * that position at labels[0], and NULL at labels[1].  In the process,
>>  	 * check that the namespace aligns with interleave-set.
>>  	 */
>> -	nsl_get_uuid(ndd, nd_label, &uuid);
>> +	nsl_get_uuid(ndd, &nd_label->ns_label, &uuid);
>>  	rc = select_pmem_id(nd_region, &uuid);
>>  	if (rc)
>>  		goto err;
>>
>>  	/* Calculate total size and populate namespace properties from label0 */
>>  	for (i = 0; i < nd_region->ndr_mappings; i++) {
>> -		struct nd_namespace_label *label0;
>> +		struct nd_lsa_label *label0;
>
>If you are only ever going to use one part of the union in a given
>bit of code, why not use a struct of that type so you only need to change
>the point where it is assigned rather that lots of places.
>
>So keep this as struct nd_namespace_label *label0;
>
>If that makes sense, check for other places where doing that will reduce the churn
>and complexity of the code.
>

Sure, Let me revisit these. Thanks

>
>
>>  		struct nvdimm_drvdata *ndd;
>>
>>  		nd_mapping = &nd_region->mapping[i];
>> @@ -1760,17 +1762,17 @@ static struct device *create_namespace_pmem(struct nd_region *nd_region,
>>  		}
>>
>>  		ndd = to_ndd(nd_mapping);
>> -		size += nsl_get_rawsize(ndd, label0);
>> -		if (nsl_get_position(ndd, label0) != 0)
>> +		size += nsl_get_rawsize(ndd, &label0->ns_label);
>> +		if (nsl_get_position(ndd, &label0->ns_label) != 0)
>>  			continue;
>>  		WARN_ON(nspm->alt_name || nspm->uuid);
>> -		nspm->alt_name = kmemdup(nsl_ref_name(ndd, label0),
>> +		nspm->alt_name = kmemdup(nsl_ref_name(ndd, &label0->ns_label),
>>  					 NSLABEL_NAME_LEN, GFP_KERNEL);
>> -		nsl_get_uuid(ndd, label0, &uuid);
>> +		nsl_get_uuid(ndd, &label0->ns_label, &uuid);
>>  		nspm->uuid = kmemdup(&uuid, sizeof(uuid_t), GFP_KERNEL);
>> -		nspm->lbasize = nsl_get_lbasize(ndd, label0);
>> +		nspm->lbasize = nsl_get_lbasize(ndd, &label0->ns_label);
>>  		nspm->nsio.common.claim_class =
>> -			nsl_get_claim_class(ndd, label0);
>> +			nsl_get_claim_class(ndd, &label0->ns_label);
>>  	}
>

------nR.o9xAt.CKA9Q2_7V_sz8FZ15p3Iy14m0uxA3-zFK6OxaPG=_cd11d_
Content-Type: text/plain; charset="utf-8"


------nR.o9xAt.CKA9Q2_7V_sz8FZ15p3Iy14m0uxA3-zFK6OxaPG=_cd11d_--

