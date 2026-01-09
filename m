Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97ED532BF21
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 11:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959889; cv=none; b=o62KDOPNapUR/eLCJM0Lpj26NbfwwEovN4l+a4iuQjPqGyGoXo/u0b/61qBpmxsJRh41IzqylcSZFWh6BK8REQEwDtuJlpsDVPywWssgn04ktpGE5F7omKCxilfcDLjSOaFjqX/EuiyfNimhjVq2ofOkhQSqRIHikjctb+owxIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959889; c=relaxed/simple;
	bh=Rnar/ArkqK5EjDJjADbYoTJfOQhrovDfFUmvtgrwlT0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=iKVehBu+XiHyk4T66iAmotmonz/kpzqbouVgkh+9sW4jJT715avFpziyxxMJ/Hy7BIAG7mQYHKLY/E6vGgcCloiOk+Mva+7kr+uEhA8EEHUas4AlLxlYHvsNFzusvo+5sRD42+k0fU2k3M7V+O8HJIEZs+b5xDCn3v5ZuoiPz7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=pykTwgv2; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="pykTwgv2"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260109115142epoutp01ecb08edbde2295c8d70792ef5aa2169f~JDczeE0G32863528635epoutp01Y
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 11:51:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260109115142epoutp01ecb08edbde2295c8d70792ef5aa2169f~JDczeE0G32863528635epoutp01Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1767959502;
	bh=VTRkzQCUA0Hf7+12lfUcuxF6wocsSSxGk+fpxOh9HMI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=pykTwgv2mms1ESS4rro1MtnZDqLzJ2fStgJ4ViNWQUgwYXlZKAVa1Vte0y51GX5hx
	 tW+rs0EEZUsE113/n4oQoOf6f+slZySkMHQtt86CUavEu0Dw1lqlZ8KRj5pkUf3Nql
	 N+WbfDdLUJWAaViYuGp+yTFtfiGEJOk7Vmeurkko=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20260109115141epcas5p3e6bb67f7559c4727c4b5d77ae61afe71~JDcy2teuO0218102181epcas5p3E;
	Fri,  9 Jan 2026 11:51:41 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.92]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4dng984kltz6B9m4; Fri,  9 Jan
	2026 11:51:40 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20260109115140epcas5p4ab2dbba60ea90dde5ab279f17d77a8ba~JDcxnMg2t1197711977epcas5p48;
	Fri,  9 Jan 2026 11:51:40 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260109115135epsmtip2df8171a7ec1d0f426a4e367361fd217e~JDctV_Yjv1550815508epsmtip21;
	Fri,  9 Jan 2026 11:51:35 +0000 (GMT)
Date: Fri, 9 Jan 2026 17:21:28 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V4 03/17] nvdimm/label: Add namespace/region label
 support as per LSA 2.1
Message-ID: <20260109115128.sgu2x2537jno7tug@test-PowerEdge-R740xd>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20251217143133.00003109@huawei.com>
X-CMS-MailID: 20260109115140epcas5p4ab2dbba60ea90dde5ab279f17d77a8ba
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----bVwHse4Nykw-L2c5iRRXKf-G.8k0lxUwrpcTFjGaDb9lfltx=_e57f3_"
CMS-TYPE: 105P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251119075311epcas5p1af6f86ca65fd4a8452979e861b87a841
References: <20251119075255.2637388-1-s.neeraj@samsung.com>
	<CGME20251119075311epcas5p1af6f86ca65fd4a8452979e861b87a841@epcas5p1.samsung.com>
	<20251119075255.2637388-4-s.neeraj@samsung.com>
	<20251217143133.00003109@huawei.com>

------bVwHse4Nykw-L2c5iRRXKf-G.8k0lxUwrpcTFjGaDb9lfltx=_e57f3_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 17/12/25 02:31PM, Jonathan Cameron wrote:
>On Wed, 19 Nov 2025 13:22:41 +0530
>Neeraj Kumar <s.neeraj@samsung.com> wrote:
>
>> Modify __pmem_label_update() to update region labels into LSA
>>
>> CXL 3.2 Spec mentions CXL LSA 2.1 Namespace Labels at section 9.13.2.5
>> Modified __pmem_label_update() using setter functions to update
>> namespace label as per CXL LSA 2.1
>>
>> Create export routine nd_region_label_update() used for creating
>> region label into LSA. It will be used later from CXL subsystem
>>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>Hi Neeraj,
>
>A few things inline from a fresh read.
>
>Thanks,
>
>Jonathan
>
>> ---
>>  drivers/nvdimm/label.c          | 360 ++++++++++++++++++++++++++------
>>  drivers/nvdimm/label.h          |  17 +-
>>  drivers/nvdimm/namespace_devs.c |  25 ++-
>>  drivers/nvdimm/nd.h             |  66 ++++++
>>  include/linux/libnvdimm.h       |   8 +
>>  5 files changed, 406 insertions(+), 70 deletions(-)
>>
>> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
>> index 0a9b6c5cb2c3..0d587a5b9f7e 100644
>> --- a/drivers/nvdimm/label.c
>> +++ b/drivers/nvdimm/label.c
>
>
>
>
>> @@ -978,7 +1132,8 @@ static int __pmem_label_update(struct nd_region *nd_region,
>>  	return rc;
>>  }
>
>>  int nd_pmem_namespace_label_update(struct nd_region *nd_region,
>>  		struct nd_namespace_pmem *nspm, resource_size_t size)
>>  {
>> @@ -1075,6 +1253,7 @@ int nd_pmem_namespace_label_update(struct nd_region *nd_region,
>>  	for (i = 0; i < nd_region->ndr_mappings; i++) {
>>  		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
>>  		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
>> +		int region_label_cnt = 0;
>
>Always initialized anyway before use I think. So no need to do it here.

Fixed it in V5

>
>>  		struct resource *res;
>>  		int count = 0;
>>
>> @@ -1090,12 +1269,20 @@ int nd_pmem_namespace_label_update(struct nd_region *nd_region,
>>  				count++;
>>  		WARN_ON_ONCE(!count);
>>
>> -		rc = init_labels(nd_mapping, count);
>> +		region_label_cnt = find_region_label_count(nd_mapping);
>> +		/*
>> +		 * init_labels() scan labels and allocate new label based
>> +		 * on its second parameter (num_labels). Therefore to
>> +		 * allocate new namespace label also include previously
>> +		 * added region label
>> +		 */
>> +		rc = init_labels(nd_mapping, count + region_label_cnt,
>> +				 NS_LABEL_TYPE);
>>  		if (rc < 0)
>>  			return rc;
>>
>>  		rc = __pmem_label_update(nd_region, nd_mapping, nspm, i,
>> -				NSLABEL_FLAG_UPDATING);
>> +				NSLABEL_FLAG_UPDATING, NS_LABEL_TYPE);
>>  		if (rc)
>>  			return rc;
>>  	}
>
>> +int nd_pmem_region_label_update(struct nd_region *nd_region)
>> +{
>> +	int i, rc;
>> +
>> +	for (i = 0; i < nd_region->ndr_mappings; i++) {
>> +		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
>> +		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
>> +		int region_label_cnt = 0;
>
>Seems to always be initialized before use anyway so no need to do it here.

Fixed it in V5

>
>> +
>> +		/* No need to update region label for non cxl format */
>> +		if (!ndd->cxl)
>> +			return 0;
>> +
>> +		region_label_cnt = find_region_label_count(nd_mapping);
>> +		rc = init_labels(nd_mapping, region_label_cnt + 1,
>> +				 RG_LABEL_TYPE);
>> +		if (rc < 0)
>> +			return rc;
>> +
>> +		rc = __pmem_label_update(nd_region, nd_mapping, NULL, i,
>> +				NSLABEL_FLAG_UPDATING, RG_LABEL_TYPE);
>> +		if (rc)
>> +			return rc;
>> +	}
>> +
>> +	/* Clear the UPDATING flag per UEFI 2.7 expectations */
>> +	for (i = 0; i < nd_region->ndr_mappings; i++) {
>> +		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
>> +		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
>> +
>> +		WARN_ON_ONCE(!ndd->cxl);
>> +		rc = __pmem_label_update(nd_region, nd_mapping, NULL, i, 0,
>> +				RG_LABEL_TYPE);
>>  		if (rc)
>>  			return rc;
>>  	}
>
>> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
>> index 43fdb806532e..b1abbe602a5e 100644
>> --- a/drivers/nvdimm/namespace_devs.c
>> +++ b/drivers/nvdimm/namespace_devs.c
>> @@ -232,6 +232,18 @@ static ssize_t __alt_name_store(struct device *dev, const char *buf,
>>  	return rc;
>>  }
>>
>> +int nd_region_label_update(struct nd_region *nd_region)
>> +{
>> +	int rc;
>> +
>> +	nvdimm_bus_lock(&nd_region->dev);
>> +	rc = nd_pmem_region_label_update(nd_region);
>> +	nvdimm_bus_unlock(&nd_region->dev);
>
>In line with much of the nvdimm stuff I'd use guard and save a couple of lines.
>
>	guard(nvdimm_bus)(&nd_region->dev);
>	return nd_pmem_region_label_update(nd_region);
>

Fixed it in V5

>> +
>> +	return rc;
>> +}
>> +EXPORT_SYMBOL_GPL(nd_region_label_update);
>
>> diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
>> index f631bd84d6f0..5fd69c28ffe7 100644
>> --- a/drivers/nvdimm/nd.h
>> +++ b/drivers/nvdimm/nd.h
>> @@ -14,6 +14,9 @@
>>  #include <linux/nd.h>
>>  #include "label.h"
>>
>> +extern uuid_t cxl_namespace_uuid;
>> +extern uuid_t cxl_region_uuid;
>> +
>>  enum {
>>  	/*
>>  	 * Limits the maximum number of block apertures a dimm can
>> @@ -295,6 +298,67 @@ static inline const u8 *nsl_uuid_raw(struct nvdimm_drvdata *ndd,
>>  	return nd_label->efi.uuid;
>>  }
>>
>> +static inline void nsl_set_type(struct nvdimm_drvdata *ndd,
>> +				struct nd_namespace_label *ns_label)
>> +{
>> +	if (!(ndd->cxl && ns_label))
>> +		return;
>> +
>> +	uuid_copy((uuid_t *)ns_label->cxl.type, &cxl_namespace_uuid);
>
>uuid_import() perhaps more appropriate given it is coming(I think)
>from a __u8 &.
>

Yes we can avoid extra typecasting in uuid_copy using uuid_export().
Actually cxl_namespace_uuid is of type uuid_t and ns_label->cxl.type is of type __u8
So export_uuid() is appropriate here than uuid_inport()
I have fixed it in V5

>> +}
>> +
>
>
>> +
>> +static inline bool is_region_label(struct nvdimm_drvdata *ndd,
>> +				   union nd_lsa_label *lsa_label)
>> +{
>> +	uuid_t *region_type;
>> +
>> +	if (!ndd->cxl)
>> +		return false;
>> +
>> +	region_type = (uuid_t *) lsa_label->region_label.type;
>> +	return uuid_equal(&cxl_region_uuid, region_type)
>
>I'd match style of next function and not have the local variable.
>
>	return uuid_equal(&cxl_region_uuid,
>			  (uuid_t *)lsa_label->region_label.type);

Fixed it in V5

>> +}
>> +
>> +static inline bool
>> +region_label_uuid_equal(struct cxl_region_label *region_label,
>> +			const uuid_t *uuid)
>> +{
>> +	return uuid_equal((uuid_t *) region_label->uuid, uuid);
>
>Dave pointed out that there shouldn't be a space after the cast.
>Make sure you catch all of these.
>

Fixed it in V5

>> +}
>> +
>> +static inline u64
>> +region_label_get_checksum(struct cxl_region_label *region_label)
>> +{
>> +	return __le64_to_cpu(region_label->checksum);
>> +}
>> +
>> +static inline void
>> +region_label_set_checksum(struct cxl_region_label *region_label,
>> +			  u64 checksum)
>> +{
>> +	region_label->checksum = __cpu_to_le64(checksum);
>> +}
>
>Perhaps add a little justification to the patch description on why these
>get/set are helpful? Seems like just setting them directly would perhaps
>be fine as all call sites can see the structure definition anyway?
>

Thanks Jonathan, I have used them directly instead of extra setter function in V5



Regards,
Neeraj

------bVwHse4Nykw-L2c5iRRXKf-G.8k0lxUwrpcTFjGaDb9lfltx=_e57f3_
Content-Type: text/plain; charset="utf-8"


------bVwHse4Nykw-L2c5iRRXKf-G.8k0lxUwrpcTFjGaDb9lfltx=_e57f3_--
