Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1189F244687
	for <nvdimm@lists.linux.dev>; Mon,  6 Oct 2025 04:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759726508; cv=none; b=ZBwvgTrgc0G2aM0VqrLrKcQoZifrsLMYyn4Mn8XuvgMRbP177goIOAcfRuwoXQf82Cxjgdn6LCI29o7Pn3hs4ZEIQOG9Pg/fXIcWl6YdSCch0UHtw51krhvQCnqDGcciTFzkqg+VJwFwOqwNe4tg24zVSQeb9unkOW+29V3GpGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759726508; c=relaxed/simple;
	bh=Qr9zGvdO4PlbqFn746b0W/DAWOB7+6pJvZx4tvVZ3jE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=SHX+qf/BiB6JrGJB59bcTGQK9FoO1vzgV6d7R843pduSIg25g2NI86TpWrWUoJw6PfWkaY+LYKIvcO1iDENtfCbd2ghcTqlD+r6b5tvKyQD3BVrfoKVsq0G4oDsg/He1qw+WFCfjpErRHbY0mHcBhvkRqKHv6oh+C/GG5ApHMfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=SnvOZpXP; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="SnvOZpXP"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20251006045504epoutp03054a0e6f093a41d34a90d695e09599a3~rze6f68p61644716447epoutp03f
	for <nvdimm@lists.linux.dev>; Mon,  6 Oct 2025 04:55:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20251006045504epoutp03054a0e6f093a41d34a90d695e09599a3~rze6f68p61644716447epoutp03f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1759726504;
	bh=U8dlAdmtPzF87WeFnnaVwlI8AEiVJZciGI1QWwAvOGQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=SnvOZpXPXSV5CtKzUuSO3Eyup3d05E8EH+0tbHPeyXwpS/Ci9pnTG1bZtw4lmp+C0
	 Ym0cmi71kdqV5VZzd8x78A0tCyAiwy8E6k3pRS0SPMACwNWr7waZat33KfUCQfHUcQ
	 daj2wuD2y8SIyLprRAKjHhgGJF07ysonG/MWy7Do=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20251006045503epcas5p27ab74ec0628129229cb84ef206707e6a~rze6ROEQE0103601036epcas5p2_;
	Mon,  6 Oct 2025 04:55:03 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4cg6QH6SPbz6B9m8; Mon,  6 Oct
	2025 04:55:03 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250929133743epcas5p4a7ee95c50e609af4dc546a0e8bc95851~pxGQK9H1q2579725797epcas5p4U;
	Mon, 29 Sep 2025 13:37:43 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250929133742epsmtip23a54121a7d449a5514cb6744641cf82e~pxGPAO5VC3101831018epsmtip2I;
	Mon, 29 Sep 2025 13:37:42 +0000 (GMT)
Date: Mon, 29 Sep 2025 19:07:38 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V3 14/20] cxl/region: Add devm_cxl_pmem_add_region() for
 pmem region creation
Message-ID: <158453976.61759726503893.JavaMail.epsvc@epcpadp1new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <e45d7687-fb93-4d2e-8cb4-e84c5a7ce782@intel.com>
X-CMS-MailID: 20250929133743epcas5p4a7ee95c50e609af4dc546a0e8bc95851
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----DpLuDkH5jVwtRmV_no6S5rPRFid5ecuUEflgz2nUXUkLddKC=_74a9_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250917134159epcas5p37716c48d36c07aaffe70dafca2fa207b
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
	<CGME20250917134159epcas5p37716c48d36c07aaffe70dafca2fa207b@epcas5p3.samsung.com>
	<20250917134116.1623730-15-s.neeraj@samsung.com>
	<e45d7687-fb93-4d2e-8cb4-e84c5a7ce782@intel.com>

------DpLuDkH5jVwtRmV_no6S5rPRFid5ecuUEflgz2nUXUkLddKC=_74a9_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 23/09/25 04:50PM, Dave Jiang wrote:
>
>> +static ssize_t alloc_region_hpa(struct cxl_region *cxlr, u64 size)
>> +{
>> +	int rc;
>> +
>> +	ACQUIRE(rwsem_write_kill, rwsem)(&cxl_rwsem.region);
>> +	rc = ACQUIRE_ERR(rwsem_write_kill, &rwsem);
>> +	if (rc)
>> +		return rc;
>
>Just a nit. Please conform to existing style in the subsystem for this new usage.
>
>  +	ACQUIRE(rwsem_write_kill, rwsem)(&cxl_rwsem.region);
>  +	if ((rc = ACQUIRE_ERR(rwsem_write_kill, &rwsem))))
>  +		return rc;
>

Actually because of checkpatch.pl error, it is different from existing
style. But recent fix by Alison at [1] will allow to fix it as per others.
Sure, I will fix it in next patch-set
[1]: https://lore.kernel.org/linux-cxl/20250815010645.2980846-1-alison.schofield@intel.com/

>> +
>> +	if (!size)
>> +		return -EINVAL;
>> +
>> +	return alloc_hpa(cxlr, size);
>> +}
>
>I think you can create another helper free_region_hpa() and call them in size_store() function to remove the duplicate code.

Sure Dave, I will fix it in next patch-set

>> +
>> +static ssize_t alloc_region_dpa(struct cxl_endpoint_decoder *cxled, u64 size)
>> +{
>> +	int rc;
>> +
>> +	if (!size)
>> +		return -EINVAL;
>> +
>> +	if (!IS_ALIGNED(size, SZ_256M))
>> +		return -EINVAL;
>> +
>> +	rc = cxl_dpa_free(cxled);
>> +	if (rc)
>> +		return rc;
>> +
>> +	return cxl_dpa_alloc(cxled, size);
>> +}
>> +
>> +static struct cxl_region *
>> +devm_cxl_pmem_add_region(struct cxl_root_decoder *cxlrd, int id,
>> +			 enum cxl_partition_mode mode,
>
>Wouldn't this not needed since it would be CXL_PARTMODE_PMEM always? I also wonder if we need to rename devm_cxl_add_region() to devm_cxl_add_ram_region() to be explicit.
>

Yes devm_cxl_pmem_add_region() always need CXL_PARTMODE_PMEM, So I will
modify it accordingly. Also I will rename devm_cxl_add_region() to
devm_cxl_add_ram_region().

>> +			 enum cxl_decoder_type type,
>> +			 struct cxl_pmem_region_params *params,
>> +			 struct cxl_decoder *cxld)
>> +{
>> +	struct cxl_endpoint_decoder *cxled;
>> +	struct cxl_region_params *p;
>> +	struct cxl_port *root_port;
>> +	struct device *dev;
>> +	int rc;
>> +

<snip>

>> +	rc = alloc_region_dpa(cxled, params->rawsize);
>> +	if (rc)
>> +		return ERR_PTR(rc);
>> +
>> +	/*
>> +	 * TODO: Currently we have support of interleave_way == 1, where
>> +	 * we can only have one region per mem device. It means mem device
>> +	 * position (params->position) will always be 0. It is therefore
>> +	 * attaching only one target at params->position
>> +	 */
>> +	if (params->position)
>> +		return ERR_PTR(-EINVAL);
>
>EOPNOTSUPP?

Yes, EOPNOTSUPP would be more appropriate than EINVAL. I will fix it in
next patch-set

>
>Speaking of which, are there plans to support interleave in the near future?
>
>DJ

My current focus is to get this upstreamed and after that will focus on
multi-interleave support. Multi-interleave support will require some more
efforts on top of this change. So will take it in another series.


Regards,
Neeraj

------DpLuDkH5jVwtRmV_no6S5rPRFid5ecuUEflgz2nUXUkLddKC=_74a9_
Content-Type: text/plain; charset="utf-8"


------DpLuDkH5jVwtRmV_no6S5rPRFid5ecuUEflgz2nUXUkLddKC=_74a9_--

