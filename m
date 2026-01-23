Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8217D2EC55C
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769167040; cv=none; b=di5Ta4vrGRINsKGTRHKoyCF+01KsceyALVvRRLeTOQM/PH+Eszoiuhsd8wYOYaI9pCU6HyCceBkrt++wV98uUOKDpzfp0dAKTR3k2jY/8WjBm2fpRk4Hy5j0YbTChweoiKJE7yWG0DiP9l2L98JgegVIOpC/MGzsaJcEvn6gSIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769167040; c=relaxed/simple;
	bh=0tTOL4Rm+hlf+D36kRRGbK5zCtL4G+aXuZLmryoCRG0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=uTse9LhYtU3F/FCCy5HQkr4uHMC7KX9++D+gRoDNwqwVZ9hTx2mHfQE9pqdSmaOiN0ynWj5cIq6FGclmspTx0R625qM4sJdnAZouz3Ei1GB3DaL0k+18gtfmsA/jWs07SB7jWvIqhc+eEq2GZm8/G3DBV5cwW8j1gcJh8hKIoqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=OyC2MMQF; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="OyC2MMQF"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260123111715epoutp02aca2f06f9cc87fd128970064062084a8~NWAu0EFmc1864018640epoutp02z
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:17:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260123111715epoutp02aca2f06f9cc87fd128970064062084a8~NWAu0EFmc1864018640epoutp02z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1769167035;
	bh=4qIEoAXoqDJAq7+ErHUZLKGeYMXjvPV01ZGw7jiaEu4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=OyC2MMQFmnDFOFEicoOaXit62yCOc8/BeCd3+ZwUA3zFPDcClibPl9STTJdVTIRmw
	 5/cuP2oqNxQi4gXEFFz/64Qm3QsnWy/U5DS90fUqasTdhB9IjwnYeteDD+5HdyrDpy
	 CT6HdUw9L9C3WnXzjY+qTUuzxkjNxK/RDlOKy3mo=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20260123111715epcas5p457e8e204d696218038a7b6a14885ddce~NWAucv0Z30751607516epcas5p4a;
	Fri, 23 Jan 2026 11:17:15 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.95]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4dyFky5p3nz2SSKX; Fri, 23 Jan
	2026 11:17:14 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20260123111714epcas5p48cbb684922a981cb9639d6c7a0cb99c9~NWAtZxyTQ0751707517epcas5p4T;
	Fri, 23 Jan 2026 11:17:14 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260123111712epsmtip12c96b64aabaa2cffe32eaee4bf46b5d7~NWAr6O8x80833808338epsmtip1L;
	Fri, 23 Jan 2026 11:17:12 +0000 (GMT)
Date: Fri, 23 Jan 2026 16:47:08 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V5 11/17] cxl/region: Add devm_cxl_pmem_add_region() for
 pmem region creation
Message-ID: <20260123111638.6fv2ixs5e7rhomeg@test-PowerEdge-R740xd>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260115181721.00002668@huawei.com>
X-CMS-MailID: 20260123111714epcas5p48cbb684922a981cb9639d6c7a0cb99c9
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----HKC0oM6l2X7jDELFNxUL3gr1rNZobpnU9ZVzK0VPY15yFScq=_11f87d_"
CMS-TYPE: 105P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260109124525epcas5p103e2d6f32643e6cb07b7037155ef16e9
References: <20260109124437.4025893-1-s.neeraj@samsung.com>
	<CGME20260109124525epcas5p103e2d6f32643e6cb07b7037155ef16e9@epcas5p1.samsung.com>
	<20260109124437.4025893-12-s.neeraj@samsung.com>
	<20260115181721.00002668@huawei.com>

------HKC0oM6l2X7jDELFNxUL3gr1rNZobpnU9ZVzK0VPY15yFScq=_11f87d_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 15/01/26 06:17PM, Jonathan Cameron wrote:
>On Fri,  9 Jan 2026 18:14:31 +0530
>Neeraj Kumar <s.neeraj@samsung.com> wrote:
>
>> devm_cxl_pmem_add_region() is used to create cxl region based on region
>> information scanned from LSA.
>>
>> devm_cxl_add_region() is used to just allocate cxlr and its fields are
>> filled later by userspace tool using device attributes (*_store()).
>>
>> Inspiration for devm_cxl_pmem_add_region() is taken from these device
>> attributes (_store*) calls. It allocates cxlr and fills information
>> parsed from LSA and calls device_add(&cxlr->dev) to initiate further
>> region creation porbes
>>
>> Rename __create_region() to cxl_create_region(), which will be used
>> in later patch to create cxl region after fetching region information
>> from LSA.
>You also add a couple of parameters. At very least say why here.

Not required now, I have created a separate patch for this.

>
>>
>> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>
>A few things inline.
>
>> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
>> index 26238fb5e8cf..13779aeacd8e 100644
>> --- a/drivers/cxl/core/region.c
>> +++ b/drivers/cxl/core/region.c
>
>
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
>
>Add a comment on why this make sense.  What already allocated dpa that we need
>to clean up?

Inspiration of alloc_region_dpa() is taken from size_store(). But yes here its not
required. I have removed it accordingly in V6

>
>> +	if (rc)
>> +		return rc;
>> +
>> +	return cxl_dpa_alloc(cxled, size);
>> +}
>
>
>> -static struct cxl_region *__create_region(struct cxl_root_decoder *cxlrd,
>> -					  enum cxl_partition_mode mode, int id)
>> +struct cxl_region *cxl_create_region(struct cxl_root_decoder *cxlrd,
>> +				     enum cxl_partition_mode mode, int id,
>> +				     struct cxl_pmem_region_params *pmem_params,
>> +				     struct cxl_endpoint_decoder *cxled)
>
>I'm a little dubious that the extra parameters are buried in this patch rather than
>where we first need them or a separate patch that makes it clear what they are for.

Yes I have separated it out in V6.



Regards,
Neeraj

------HKC0oM6l2X7jDELFNxUL3gr1rNZobpnU9ZVzK0VPY15yFScq=_11f87d_
Content-Type: text/plain; charset="utf-8"


------HKC0oM6l2X7jDELFNxUL3gr1rNZobpnU9ZVzK0VPY15yFScq=_11f87d_--
