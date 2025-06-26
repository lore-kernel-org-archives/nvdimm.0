Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC3528D8FB
	for <nvdimm@lists.linux.dev>; Thu, 26 Jun 2025 13:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750944188; cv=none; b=XXfXoTIYI4XxaMCTSqgqOKmFOeZTRwm3HyyIn1wuU6K20XcfGhK5ZS3xpFS6oehjv/xllRb0YAPx2r+T7XOmPTikj1c/PI4XCIP/tR4L5GJs3EkcwYdk7JVA/k0YDYBPYzmI7FCO+hn3Y0IYF8eqIfCdCC6bG287NNRgYLkAdKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750944188; c=relaxed/simple;
	bh=2mRpECO56y8vNkUsBcAQD/gSP2nf0+jp4U5rAuItZUg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=B+vfJorNo3OjprqpIiIjzwyy4HQW/azBexM02wQ7pHQpBclng3Bh4VY5dD852dEMx1sU97IjdpiXq44pnemThQF90wKZLIO1oobY7K9R0DDk7b8R77jtBJDZROgjQV+WGSvjKz+u6KEZwurL6SXva+4iL9rEsYcXBL8xgraWS3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=uCDddB9L; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="uCDddB9L"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250626132303epoutp018115621b28c9e854d860520f934988de~MmnVJoTGs2105921059epoutp01d
	for <nvdimm@lists.linux.dev>; Thu, 26 Jun 2025 13:23:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250626132303epoutp018115621b28c9e854d860520f934988de~MmnVJoTGs2105921059epoutp01d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1750944183;
	bh=AJM3Gd34LwRGPxKuzq0z/eWtuzzF8VcgX7+SbEn6Q6c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=uCDddB9LlD2lEicUgYJUtjluVAOZqw7bxGzJ4uFd/Dzym9fAaTRONdDiz/LtMlPlR
	 5YyBMgCocuMep+y/HzjAUrwz9hwXRPK/8ZOOT/PhOvdpB7b1SDFQKfCi3eGWMpI1YU
	 fbddHK0UUm94w15sDjdmDjP4Oo9Gd9phDJ907KzU=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20250626132302epcas5p2b797df993f4819ecfe713c6c392e44aa~MmnUg12dN2644726447epcas5p2M;
	Thu, 26 Jun 2025 13:23:02 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4bSfWV6pkWz2SSKZ; Thu, 26 Jun
	2025 13:23:02 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250626100014epcas5p2aaefffe228fb4d905b3d639fab65866a~Mj2QLX0co2322923229epcas5p2l;
	Thu, 26 Jun 2025 10:00:14 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250626100012epsmtip2af682217dfe863bc5cadf499632c3f0c~Mj2NwqMMF2790027900epsmtip2H;
	Thu, 26 Jun 2025 10:00:12 +0000 (GMT)
Date: Thu, 26 Jun 2025 15:30:06 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: dan.j.williams@intel.com, dave@stgolabs.net, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com,
	a.manzanares@samsung.com, nifan.cxl@gmail.com, anisa.su@samsung.com,
	vishak.g@samsung.com, krish.reddy@samsung.com, arun.george@samsung.com,
	alok.rathore@samsung.com, neeraj.kernel@gmail.com,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, gost.dev@samsung.com, cpgs@samsung.com
Subject: Re: [RFC PATCH 08/20] nvdimm/label: Include region label in slot
 validation
Message-ID: <1296674576.21750944182952.JavaMail.epsvc@epcpadp2new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250623101347.00003d7a@huawei.com>
X-CMS-MailID: 20250626100014epcas5p2aaefffe228fb4d905b3d639fab65866a
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----K5ZVV-zrPS8y8iJelFUsagW7KEVVNg7wn3oh2ZJRPRpX678s=_cd4bd_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250617124028epcas5p2bb45182c91359a16efc5b1561927abce
References: <20250617123944.78345-1-s.neeraj@samsung.com>
	<CGME20250617124028epcas5p2bb45182c91359a16efc5b1561927abce@epcas5p2.samsung.com>
	<148912029.181750165204802.JavaMail.epsvc@epcpadp1new>
	<20250623101347.00003d7a@huawei.com>

------K5ZVV-zrPS8y8iJelFUsagW7KEVVNg7wn3oh2ZJRPRpX678s=_cd4bd_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 23/06/25 10:13AM, Jonathan Cameron wrote:
>On Tue, 17 Jun 2025 18:09:32 +0530
>Neeraj Kumar <s.neeraj@samsung.com> wrote:
>
>> slot validation routine validates label slot by calculating label
>> checksum. It was only validating namespace label. This changeset also
>> validates region label if present.
>>
>> Also validate and calculate lsa v2.1 namespace label checksum
>>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>
>
>
>> diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
>> index 1e5a68013735..ca8256b31472 100644
>> --- a/drivers/nvdimm/nd.h
>> +++ b/drivers/nvdimm/nd.h
>> @@ -331,6 +331,22 @@ static inline bool nsl_region_uuid_equal(struct nd_namespace_label *ns_label,
>>  	return uuid_equal(&tmp, uuid);
>>  }
>>
>> +static inline bool is_region_label(struct nvdimm_drvdata *ndd,
>> +				   struct nd_lsa_label *nd_label)
>> +{
>> +	uuid_t ns_type, region_type;
>> +
>> +	if (ndd->cxl) {
>> +		uuid_parse(CXL_REGION_UUID, &region_type);
>> +		import_uuid(&ns_type, nd_label->ns_label.cxl.type);
>> +		if (uuid_equal(&region_type, &ns_type))
>> +			return true;
>> +		else
>> +			return false;
>
>		return uuid_equal(&reg_type, &ns_type);
>

Sure, Will fix it in V1

>> +	} else
>{}
>for all legs if one needs it.
>
>However, if you aren't going to add more code here later, just flip the condition
>and exit early.
>
>	if (!ndd->cxl)
>		return false;
>
>	uuid_parse...
>

Thanks, Will fix it in V1

>> +		return false;
>> +}
>> +
>>  static inline bool rgl_uuid_equal(struct cxl_region_label *rg_label,
>>  				  const uuid_t *uuid)
>>  {
>> @@ -340,6 +356,11 @@ static inline bool rgl_uuid_equal(struct cxl_region_label *rg_label,
>>  	return uuid_equal(&tmp, uuid);
>>  }
>>
>> +static inline u32 rgl_get_slot(struct cxl_region_label *rg_label)
>> +{
>> +	return __le32_to_cpu(rg_label->slot);
>> +}
>> +
>>  static inline u64 rgl_get_checksum(struct cxl_region_label *rg_label)
>>  {
>>  	return __le64_to_cpu(rg_label->checksum);
>

------K5ZVV-zrPS8y8iJelFUsagW7KEVVNg7wn3oh2ZJRPRpX678s=_cd4bd_
Content-Type: text/plain; charset="utf-8"


------K5ZVV-zrPS8y8iJelFUsagW7KEVVNg7wn3oh2ZJRPRpX678s=_cd4bd_--

