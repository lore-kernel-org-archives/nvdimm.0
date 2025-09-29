Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD0724728F
	for <nvdimm@lists.linux.dev>; Mon,  6 Oct 2025 04:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759726510; cv=none; b=pOrBmjQkBa99YzM2Jzfwq96tqAW+fj5wGGQ74H1+beRVZ/ik7RGpEalkOT+48Bab82Mvz5vSSB8IKGbG+nGXOdsPYtrugzIPpnHjbvXgXs+GzyniKV9w5B6UsAL8ix+2ydVLmtuWs0XAxxUnOsyAUVipzz/qMwU+slPAoay5Xx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759726510; c=relaxed/simple;
	bh=ht/uvgPLPswP8wfkhMpSdAb8BnFOMhm4KRwpfjCzXl8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=CMBXVOV4eW3DF+wfinzHeC/RuLmEAQF3jGUUAsXZwWZFsnxxs8NVl9JR2Cd/sI7EnazHdcRODcP8CqMrQapWdqEzRl1QftDMsoawnUmppLRb7n5RREGe4wr7OgfiNBzG9nxG0CrCGcuM0Mo0F0snuvjfU9of9QbU70jkIxvd1as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=bmprNYUc; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="bmprNYUc"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20251006045504epoutp0458d9da3143c4985e36b53111a12a0255~rze7IvWVG0575205752epoutp04Z
	for <nvdimm@lists.linux.dev>; Mon,  6 Oct 2025 04:55:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20251006045504epoutp0458d9da3143c4985e36b53111a12a0255~rze7IvWVG0575205752epoutp04Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1759726504;
	bh=VeUpxL6s70se1NIT0/5kFQloqu8hf10UstyeCcyAsOc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=bmprNYUcVAPDf1NqSNw51n1ehXFJz+9eKWaAquMt34NWDmrG/tE0bpfV4CIdF+Uv9
	 mIZ9NAfsjKpYr2RXIzecLEhen38F9RNKcyHn4IkMscPHp8+pbsrR8m1YlKi/2ES/+Q
	 71CQyj6r3RHC97+eEwfWadHufdeHugHZD/oDJFFg=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20251006045504epcas5p47d50392b5705f634c0c0fd32bdcc753a~rze616YY42409424094epcas5p4C;
	Mon,  6 Oct 2025 04:55:04 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4cg6QJ3kWxz6B9m9; Mon,  6 Oct
	2025 04:55:04 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250929140029epcas5p1368952f3e4bab601c6be3a6dfa30430f~pxaIau5Ac2435724357epcas5p1h;
	Mon, 29 Sep 2025 14:00:29 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250929140027epsmtip2d2a18f5d5ac482dabab238e68b2eec9e~pxaG89UsW1219212192epsmtip2L;
	Mon, 29 Sep 2025 14:00:27 +0000 (GMT)
Date: Mon, 29 Sep 2025 19:30:24 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V3 19/20] cxl/pmem_region: Add sysfs attribute cxl
 region label updation/deletion
Message-ID: <1690859824.141759726504518.JavaMail.epsvc@epcpadp1new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <6734182c-579e-439c-906c-f3c053025ef0@intel.com>
X-CMS-MailID: 20250929140029epcas5p1368952f3e4bab601c6be3a6dfa30430f
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----u9L2QgHoAwvmxKKc9G9JEwVzlbmkcdkJo4LdlrEXZ6gvS-I0=_751f_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250917134211epcas5p17cf5e4052df126a67b27be971be82fe1
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
	<CGME20250917134211epcas5p17cf5e4052df126a67b27be971be82fe1@epcas5p1.samsung.com>
	<20250917134116.1623730-20-s.neeraj@samsung.com>
	<6734182c-579e-439c-906c-f3c053025ef0@intel.com>

------u9L2QgHoAwvmxKKc9G9JEwVzlbmkcdkJo4LdlrEXZ6gvS-I0=_751f_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 24/09/25 01:25PM, Dave Jiang wrote:
>
>

<snip>

>On 9/17/25 6:41 AM, Neeraj Kumar wrote:
>> Using these attributes region label is added/deleted into LSA. These
>> attributes are called from userspace (ndctl) after region creation.
>> +static ssize_t region_label_update_store(struct device *dev,
>> +					 struct device_attribute *attr,
>> +					 const char *buf, size_t len)
>> +{
>> +	struct cxl_pmem_region *cxlr_pmem = to_cxl_pmem_region(dev);
>> +	struct cxl_region *cxlr = cxlr_pmem->cxlr;
>> +	ssize_t rc;
>> +	bool update;
>> +
>> +	rc = kstrtobool(buf, &update);
>> +	if (rc)
>> +		return rc;
>> +
>> +	ACQUIRE(rwsem_write_kill, rwsem)(&cxl_rwsem.region);
>> +	rc = ACQUIRE_ERR(rwsem_write_kill, &rwsem);
>> +	if (rc)
>> +		return rc;
>> +
>> +	/* Region not yet committed */
>> +	if (update && cxlr && cxlr->params.state != CXL_CONFIG_COMMIT) {
>> +		dev_dbg(dev, "region not committed, can't update into LSA\n");
>> +		return -ENXIO;
>> +	}
>> +
>> +	if (cxlr && cxlr->cxlr_pmem && cxlr->cxlr_pmem->nd_region) {
>> +		rc = nd_region_label_update(cxlr->cxlr_pmem->nd_region);
>> +		if (!rc)
>> +			cxlr->params.region_label_state = 1;
>> +	}
>> +
>> +	if (rc)
>> +		return rc;
>
>Feels like this segment should look like
>
>if (!cxlr || !cxlr->cxlr_pmem || ! cxlr->cxlr_pmem->nd_region)
>	return 0;
>
>rc = nd_region_label_update(..);
>if (rc)
>	return rc;
>
>cxlr->params.region_label_state = 1;
>
>> +
>> +	return len;
>> +}
>> +

<snip>

>> +static ssize_t region_label_delete_store(struct device *dev,
>> +					 struct device_attribute *attr,
>> +					 const char *buf, size_t len)
>> +{
>> +	struct cxl_pmem_region *cxlr_pmem = to_cxl_pmem_region(dev);
>> +	struct cxl_region *cxlr = cxlr_pmem->cxlr;
>> +	ssize_t rc;
>> +
>> +	ACQUIRE(rwsem_write_kill, rwsem)(&cxl_rwsem.region);
>> +	rc = ACQUIRE_ERR(rwsem_write_kill, &rwsem);
>> +	if (rc)
>> +		return rc;
>> +
>> +	if (cxlr && cxlr->cxlr_pmem && cxlr->cxlr_pmem->nd_region) {
>> +		rc = nd_region_label_delete(cxlr->cxlr_pmem->nd_region);
>> +		if (rc)
>> +			return rc;
>> +		cxlr->params.region_label_state = 0;
>> +	}
>
>Similar to above. You can exit early and not have to indent.
>
>> +
>> +	return len;
>> +}

<snip>

>> --- a/drivers/cxl/cxl.h
>> +++ b/drivers/cxl/cxl.h
>> @@ -484,6 +484,7 @@ enum cxl_config_state {
>>   */
>>  struct cxl_region_params {
>>  	enum cxl_config_state state;
>> +	int region_label_state;
>
>Maybe a enum?
>

Thanks for you suggestion Dave, I will fix it accrodingly.


Regards,
Neeraj


------u9L2QgHoAwvmxKKc9G9JEwVzlbmkcdkJo4LdlrEXZ6gvS-I0=_751f_
Content-Type: text/plain; charset="utf-8"


------u9L2QgHoAwvmxKKc9G9JEwVzlbmkcdkJo4LdlrEXZ6gvS-I0=_751f_--

