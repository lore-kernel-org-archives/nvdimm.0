Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1552D3A80
	for <nvdimm@lists.linux.dev>; Fri,  5 Sep 2025 07:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757055789; cv=none; b=KEoisBR89L95KaA61V406AOU7Tl02uvNHS2UE1yCbLXtQVBAPFcFAWAfkYAenmL7Ptm0u4APcfKZR8G+vGnHvF0ExzhWp73HAMPPm7MKgmlQeB4PnNuKTWIGROPlO7a4TUVPJZp0A8csWUe9InzXxpzGOO049uzvKnp/rzDe/JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757055789; c=relaxed/simple;
	bh=dOfpsIAhUOtMRab1Awwq5/KwLpctA8yxxOhdk2/ax18=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=GH0knUtPm6xRUZmwcazELl/AAwi9XlX0NZR9kCgKcAx2knWKaytzS0ituhXPXaTkjeSAtwaCJCT1YPM5TLM2wDmh78Ru/mobpJym39/Ay/fIDCUFJ3zsfzDuwhFUPayC2XcSEMS5jeut2qyTMEef4zS4z0qHLRL6/CoR8VBFcWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=cQV7xdUM; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="cQV7xdUM"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250905070303epoutp02e7155d75b98d19a62be9baf11b23c6f5~iUO0eNWBY3181731817epoutp02b
	for <nvdimm@lists.linux.dev>; Fri,  5 Sep 2025 07:03:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250905070303epoutp02e7155d75b98d19a62be9baf11b23c6f5~iUO0eNWBY3181731817epoutp02b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1757055784;
	bh=RtUacEzIo4KPpynQl+ohz+dT9VtPS9oHDasFUEPMRpU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=cQV7xdUMaaUdv6eR7M9LhPprXkv/e3ESuNkyJzMQePc11ICnTNeIr3ECgTeHokagK
	 GYwHNwU9ER7InG5AohbWiP/jNPxiXZnHSDpPmo/NpgHyMyC+dUsZQuw+kDy55klkRO
	 3cg1cOJQX+JddLtZon0J4I5/lqzDL0b0O5ySGA84=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20250905070303epcas5p27dfa47e7b64350282ba567212d592329~iUO0OyFZV0211902119epcas5p2s;
	Fri,  5 Sep 2025 07:03:03 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4cJ6kH4rXMz6B9m8; Fri,  5 Sep
	2025 07:03:03 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250904141829epcas5p2829b463e4898f478d54615ed0c115544~iGhtL9Xrh2864428644epcas5p2Y;
	Thu,  4 Sep 2025 14:18:29 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250904141827epsmtip1a61940aee76ccf4886d48f01af8eab9f~iGhr77-jY3139931399epsmtip1B;
	Thu,  4 Sep 2025 14:18:27 +0000 (GMT)
Date: Thu, 4 Sep 2025 19:48:21 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Ira Weiny <ira.weiny@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V2 05/20] nvdimm/region_label: Add region label updation
 routine
Message-ID: <439928219.101757055783676.JavaMail.epsvc@epcpadp2new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <68a4bf6b747e2_27db9529461@iweiny-mobl.notmuch>
X-CMS-MailID: 20250904141829epcas5p2829b463e4898f478d54615ed0c115544
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----At96h8_oYHqdM-HzD.Qv-z6Hqrsj5DpI3AOnKMLFsbTdazMP=_ead6b_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250730121228epcas5p411e5cc6d29fb9417178dbd07a1d8f02d
References: <20250730121209.303202-1-s.neeraj@samsung.com>
	<CGME20250730121228epcas5p411e5cc6d29fb9417178dbd07a1d8f02d@epcas5p4.samsung.com>
	<20250730121209.303202-6-s.neeraj@samsung.com>
	<68a4bf6b747e2_27db9529461@iweiny-mobl.notmuch>

------At96h8_oYHqdM-HzD.Qv-z6Hqrsj5DpI3AOnKMLFsbTdazMP=_ead6b_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 19/08/25 01:16PM, Ira Weiny wrote:
>RE Subject: [PATCH V2 05/20] nvdimm/region_label: Add region label updation routine
>                                                                   ^^^^^^^
>								   update

Sure, I will fix it in next patch-set

>
>Neeraj Kumar wrote:
>> Added __pmem_region_label_update region label update routine to update
>  ^^^
>  Add

Sure, I will fix it in next patch-set

>
>> region label.
>
>How about:
>
>Add __pmem_region_label_update to update region labels.  ???

May be I will re-use __pmem_label_update() for region label also.

>
>But is that really what this patch is doing?  And why do we need such a
>function?
>
>Why is __pmem_label_update changing?

__pmem_label_update() is changing because modification of mutex locking.
Yes, Its not really related hunk, So I will handle it in separate
patch-set.

>
>>
>> Also used guard(mutex)(&nd_mapping->lock) in place of mutex_lock() and
>> mutex_unlock()
>
>Why?

As per Jonathan's comment on V1 have modified it, and added it in commit
message. seems its not required in commit message. I will remove it

>
>I'm not full out naking the patch but I think its purpose needs to be
>clear.
>
>More below...
>
>[snip]
>
>>  static bool slot_valid(struct nvdimm_drvdata *ndd,
>>  		struct nd_lsa_label *lsa_label, u32 slot)
>>  {
>> @@ -960,7 +970,7 @@ static int __pmem_label_update(struct nd_region *nd_region,
>>  		return rc;
>>
>>  	/* Garbage collect the previous label */
>> -	mutex_lock(&nd_mapping->lock);
>> +	guard(mutex)(&nd_mapping->lock);
>
>This, and the following hunks, looks like a completely separate change and
>should be in it's own pre-patch with a justification of the change.

Yes this hunk is not related, So I will create a separate patch for this change

>
>>  	list_for_each_entry(label_ent, &nd_mapping->labels, list) {
>>  		if (!label_ent->label)
>>  			continue;
>> @@ -972,20 +982,20 @@ static int __pmem_label_update(struct nd_region *nd_region,
>>  	/* update index */
>>  	rc = nd_label_write_index(ndd, ndd->ns_next,
>>  			nd_inc_seq(__le32_to_cpu(nsindex->seq)), 0);
>> -	if (rc == 0) {
>> -		list_for_each_entry(label_ent, &nd_mapping->labels, list)
>> -			if (!label_ent->label) {
>> -				label_ent->label = lsa_label;
>> -				lsa_label = NULL;
>> -				break;
>> -			}
>> -		dev_WARN_ONCE(&nspm->nsio.common.dev, lsa_label,
>> -				"failed to track label: %d\n",
>> -				to_slot(ndd, lsa_label));
>> -		if (lsa_label)
>> -			rc = -ENXIO;
>> -	}
>> -	mutex_unlock(&nd_mapping->lock);
>> +	if (rc)
>> +		return rc;
>> +
>> +	list_for_each_entry(label_ent, &nd_mapping->labels, list)
>> +		if (!label_ent->label) {
>> +			label_ent->label = lsa_label;
>> +			lsa_label = NULL;
>> +			break;
>> +		}
>> +	dev_WARN_ONCE(&nspm->nsio.common.dev, lsa_label,
>> +			"failed to track label: %d\n",
>> +			to_slot(ndd, lsa_label));
>> +	if (lsa_label)
>> +		rc = -ENXIO;
>>
>>  	return rc;
>>  }
>> @@ -1127,6 +1137,137 @@ int nd_pmem_namespace_label_update(struct nd_region *nd_region,
>>  	return 0;
>>  }
>>
>
>[snip]
>
>> diff --git a/drivers/nvdimm/label.h b/drivers/nvdimm/label.h
>> index 4883b3a1320f..0f428695017d 100644
>> --- a/drivers/nvdimm/label.h
>> +++ b/drivers/nvdimm/label.h
>> @@ -190,6 +190,7 @@ struct nd_namespace_label {
>>  struct nd_lsa_label {
>>  	union {
>>  		struct nd_namespace_label ns_label;
>> +		struct cxl_region_label rg_label;
>
>Why can't struct cxl_region_label be it's own structure?  Or just be part
>of the nd_namespace_label union?

Thanks Ira for your suggestion. I will revisit this change and try using
region label handling separately instead of using union.

>
>>  	};
>>  };
>>
>> @@ -233,4 +234,5 @@ struct nd_region;
>>  struct nd_namespace_pmem;
>>  int nd_pmem_namespace_label_update(struct nd_region *nd_region,
>>  		struct nd_namespace_pmem *nspm, resource_size_t size);
>> +int nd_pmem_region_label_update(struct nd_region *nd_region);
>>  #endif /* __LABEL_H__ */
>> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
>> index 5b73119dc8fd..02ae8162566c 100644
>> --- a/drivers/nvdimm/namespace_devs.c
>> +++ b/drivers/nvdimm/namespace_devs.c
>> @@ -232,6 +232,18 @@ static ssize_t __alt_name_store(struct device *dev, const char *buf,
>>  	return rc;
>>  }
>>
>> +int nd_region_label_update(struct nd_region *nd_region)
>
>Is this called in a later patch?
>
>Ira

Yes its called from patch 20 (cxl/core/pmem_region.c) by region_label_update_store()


Regards,
Neeraj

------At96h8_oYHqdM-HzD.Qv-z6Hqrsj5DpI3AOnKMLFsbTdazMP=_ead6b_
Content-Type: text/plain; charset="utf-8"


------At96h8_oYHqdM-HzD.Qv-z6Hqrsj5DpI3AOnKMLFsbTdazMP=_ead6b_--

