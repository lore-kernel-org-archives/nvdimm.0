Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B35E28C5A9
	for <nvdimm@lists.linux.dev>; Thu, 26 Jun 2025 13:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750944308; cv=none; b=UjK7qcDK2wpfFwdSxD0IBODeHZCGvBfWam6QDWobuMcVCKp7RT5/TjjUuOdNW1Ah3plkQzojs9EXF09NLlzzQCV+93NtvCwrIO54BPVvTMJ4eBlKNvCQpGp6asokPjWtyNVLmYSoxIIzZaOx+nqWt5ia8enTeEwE7h4szAnTXDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750944308; c=relaxed/simple;
	bh=y8V/+SYgiP6HF/AZLEKhiz3pD0KnTWZT9QR77yuM3YU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=FvNlBc5EoUsPcIL2JiYJMSJdKGmvyNNiTnvXjuRISR7GQdOqRBSRd+d+Kp4Ho7uu7oD+n5WdUlrOhO/ZF+7Z+gpY+iEDZhLoMlPWXA/yr6uEQu4USQm2/i8SZLYYLEr7ZOBcWtLl2pMR2c8KpJaD1yzNCzqNMHVwkRFIbb0ZRIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=uE10nL3l; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="uE10nL3l"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250626132504epoutp02c8e1d5907f57c2519b8941bda130a32a~MmpFi9y202033720337epoutp02V
	for <nvdimm@lists.linux.dev>; Thu, 26 Jun 2025 13:25:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250626132504epoutp02c8e1d5907f57c2519b8941bda130a32a~MmpFi9y202033720337epoutp02V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1750944304;
	bh=+ph+U1fBwvQsndceK1N5+3MC5CHOtis81gbQQkTGUDM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=uE10nL3lE9rbtRgj+JMt+l53MVN0p97FssxmUMT2/+3VPZ5z6LaTRfAIHMOgIM4dV
	 LFBxAZVi1So7hJTJ+QYsUjw98xlmIiFShE1zE2H2bArCaCKl2/TVEXoYuQLijiZOi8
	 riqhmm+Qyai6nrFetDfwzQzuWYRgsFn9kDww/+Wg=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20250626132503epcas5p49f39df328c193477cfff9ea156e610ca~MmpE3BYEc3076730767epcas5p4A;
	Thu, 26 Jun 2025 13:25:03 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4bSfYq4BQgz3hhT4; Thu, 26 Jun
	2025 13:25:03 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250626104841epcas5p35730336ccb6738138568912d1d558b69~Mkgi8fmRy0479104791epcas5p3p;
	Thu, 26 Jun 2025 10:48:41 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250626104838epsmtip2d6d14f8ebd578264596fcb53eb8ca459~MkggjnBuk2350623506epsmtip2U;
	Thu, 26 Jun 2025 10:48:38 +0000 (GMT)
Date: Thu, 26 Jun 2025 16:18:34 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: dan.j.williams@intel.com, dave@stgolabs.net, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com,
	a.manzanares@samsung.com, nifan.cxl@gmail.com, anisa.su@samsung.com,
	vishak.g@samsung.com, krish.reddy@samsung.com, arun.george@samsung.com,
	alok.rathore@samsung.com, neeraj.kernel@gmail.com,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, gost.dev@samsung.com, cpgs@samsung.com
Subject: Re: [RFC PATCH 20/20] cxl/pmem_region: Add cxl region label
 updation and deletion device attributes
Message-ID: <1931444790.41750944303583.JavaMail.epsvc@epcpadp1new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250623105657.00003996@huawei.com>
X-CMS-MailID: 20250626104841epcas5p35730336ccb6738138568912d1d558b69
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----nR.o9xAt.CKA9Q2_7V_sz8FZ15p3Iy14m0uxA3-zFK6OxaPG=_cd49d_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250617124104epcas5p41105ad63af456b5cdb041e174a99925e
References: <20250617123944.78345-1-s.neeraj@samsung.com>
	<CGME20250617124104epcas5p41105ad63af456b5cdb041e174a99925e@epcas5p4.samsung.com>
	<1371006431.81750165382853.JavaMail.epsvc@epcpadp2new>
	<20250623105657.00003996@huawei.com>

------nR.o9xAt.CKA9Q2_7V_sz8FZ15p3Iy14m0uxA3-zFK6OxaPG=_cd49d_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 23/06/25 10:56AM, Jonathan Cameron wrote:
>On Tue, 17 Jun 2025 18:09:44 +0530
>Neeraj Kumar <s.neeraj@samsung.com> wrote:
>
>> Using these attributes region label is added/deleted into LSA. These
>> attributes are called from userspace (ndctl) after region creation.
>
>These need documentation. Documentation/ABI/testing/sysfs-bus-cxl
>is probably the right place.
>

Sure, Will update this in Documentation as well as update it in commit
message

>
>>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>> ---
>>  drivers/cxl/core/pmem_region.c | 103 +++++++++++++++++++++++++++++++++
>>  drivers/cxl/cxl.h              |   1 +
>>  2 files changed, 104 insertions(+)
>>
>> diff --git a/drivers/cxl/core/pmem_region.c b/drivers/cxl/core/pmem_region.c
>> index a29526c27d40..f582d796c21b 100644
>> --- a/drivers/cxl/core/pmem_region.c
>> +++ b/drivers/cxl/core/pmem_region.c
>> @@ -45,8 +45,111 @@ static void cxl_pmem_region_release(struct device *dev)
>>  	kfree(cxlr_pmem);
>>  }
>>
>> +static ssize_t region_label_update_store(struct device *dev,
>> +					 struct device_attribute *attr,
>> +					 const char *buf, size_t len)
>> +{
>> +	struct cxl_pmem_region *cxlr_pmem = to_cxl_pmem_region(dev);
>> +	struct cxl_region *cxlr = cxlr_pmem->cxlr;
>> +	struct cxl_region_params *p = &cxlr->params;
>> +	ssize_t rc;
>> +	bool update;
>> +
>> +	rc = kstrtobool(buf, &update);
>> +	if (rc)
>> +		return rc;
>> +
>> +	rc = down_write_killable(&cxl_region_rwsem);
>
>Another use case for ACQUIRE()
>

Sure, I will look at Dan's new ACQUIRE() series. I will update it in V1

>> +	if (rc)
>> +		return rc;
>> +
>> +	/* Region not yet committed */
>> +	if (update && p->state != CXL_CONFIG_COMMIT) {
>> +		dev_dbg(dev, "region not committed, can't update into LSA\n");
>> +		rc = -ENXIO;
>> +		goto out;
>> +	}
>> +
>> +	if (cxlr && cxlr->cxlr_pmem && cxlr->cxlr_pmem->nd_region) {
>> +		rc = nd_region_label_update(cxlr->cxlr_pmem->nd_region);
>> +
>> +		if (!rc)
>> +			p->region_label_state = 1;
>> +	}
>> +
>> +out:
>> +	up_write(&cxl_region_rwsem);
>> +
>> +	if (rc)
>> +		return rc;
>> +
>> +	return len;
>> +}
>
>> +
>> +static struct attribute *cxl_pmem_region_attrs[] = {
>> +	&dev_attr_region_label_update.attr,
>> +	&dev_attr_region_label_delete.attr,
>> +	NULL,
>No need for trailing commas on terminating entries as we don't want it to be easy
>to put something after them.
>

Sure, Will fix it in V1

>> +};
>> +
>> +struct attribute_group cxl_pmem_region_group = {
>> +	.attrs = cxl_pmem_region_attrs,
>> +};
>> +
>>  static const struct attribute_group *cxl_pmem_region_attribute_groups[] = {
>>  	&cxl_base_attribute_group,
>> +	&cxl_pmem_region_group,
>>  	NULL,
>Hmm. Drop this trailing comma perhaps whilst here.
>>  };
>

Sure, I will update it in V1

>

------nR.o9xAt.CKA9Q2_7V_sz8FZ15p3Iy14m0uxA3-zFK6OxaPG=_cd49d_
Content-Type: text/plain; charset="utf-8"


------nR.o9xAt.CKA9Q2_7V_sz8FZ15p3Iy14m0uxA3-zFK6OxaPG=_cd49d_--

