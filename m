Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B182417FB
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769167558; cv=none; b=jEigUeqdlO9cIaJ+gSMUXWLbXGGXzf7KXLs6id1ybROwAFgz2rO2NT4kxo5+WyQroqfgKl8MLmYBZyp+TENEnv/2uXKyRj8HdCk/GgayRmWHC+zLyoGi97rY/epBg9lC7KsesxVIfiJJysmGmBedheKPhlzwcIxz+JicefCd460=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769167558; c=relaxed/simple;
	bh=a1ECuho7MxudhQw/1YZtdClJjzjXQgxB8FqE6MYSFdc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=ihW3+lsYrUNp3dRZ6TnNTH8sTg6BgSMUJDGGWWZPjS3zko+PhmJoIAgAiWQvnB3lZ9f2cxpTTSQjYFrTFMQbNcwTpidwpAJOp0+C8IirV9L9EfRtqF6kLCqvNtJx58V/kW34aN1Lxlb9kQh2ClcJBmiHPhP5GVJIv5Q9uf4hMS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=FxiYD6Hn; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="FxiYD6Hn"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260123112553epoutp0274ff4798fbba645346cd55d03df011ef~NWIQ1je2g2814428144epoutp02D
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:25:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260123112553epoutp0274ff4798fbba645346cd55d03df011ef~NWIQ1je2g2814428144epoutp02D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1769167553;
	bh=6m7c9/I/VAPM6ZEeaMrVLjmL2ha3ONPuyWLb96GiYVI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=FxiYD6HnXRQc58SuFAAk/Puz0qo3FxdzcpspAvoSRFhbu2qhjeWPyNhD9/kW2XOuO
	 UevvwlxfRkP2nrG64t+zcbnn/J2DaSl9vYz5NLjGsk+PoyZ/RVxAh+sX1PMp7O4U4S
	 EMJZzDthMwmHBL8Qchhlizo7piOeRM70AcN4KJns=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20260123112553epcas5p1bd3fefef7aaaf626a3d41083f498d91d~NWIQkvSxP3013530135epcas5p1t;
	Fri, 23 Jan 2026 11:25:53 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.95]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4dyFww3jFyz6B9m5; Fri, 23 Jan
	2026 11:25:52 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260123112552epcas5p20bdb1fdd98f5508df7de6d06bdf7e9b0~NWIPi8jtm2766527665epcas5p2V;
	Fri, 23 Jan 2026 11:25:52 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260123112550epsmtip2eaf93bbcd0da9c8ae141e5d36ebbb056~NWIOWnCkT2169221692epsmtip27;
	Fri, 23 Jan 2026 11:25:50 +0000 (GMT)
Date: Fri, 23 Jan 2026 16:55:46 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V5 15/17] cxl/pmem_region: Add sysfs attribute cxl
 region label updation/deletion
Message-ID: <20260123112546.izfi4e5lcbjdikmy@test-PowerEdge-R740xd>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260115182116.000057b9@huawei.com>
X-CMS-MailID: 20260123112552epcas5p20bdb1fdd98f5508df7de6d06bdf7e9b0
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----HKC0oM6l2X7jDELFNxUL3gr1rNZobpnU9ZVzK0VPY15yFScq=_11f8d9_"
CMS-TYPE: 105P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260109124531epcas5p118e7306860bcd57a0106948375df5c9c
References: <20260109124437.4025893-1-s.neeraj@samsung.com>
	<CGME20260109124531epcas5p118e7306860bcd57a0106948375df5c9c@epcas5p1.samsung.com>
	<20260109124437.4025893-16-s.neeraj@samsung.com>
	<20260115182116.000057b9@huawei.com>

------HKC0oM6l2X7jDELFNxUL3gr1rNZobpnU9ZVzK0VPY15yFScq=_11f8d9_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 15/01/26 06:21PM, Jonathan Cameron wrote:
>On Fri,  9 Jan 2026 18:14:35 +0530
>Neeraj Kumar <s.neeraj@samsung.com> wrote:
>
>> Using these attributes region label is added/deleted into LSA. These
>> attributes are called from userspace (ndctl) after region creation.
>>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>One wrong field name.
>
>With that and the version number updated as Dave pointed out
>Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

Thanks Jonathan for RB tag.

>
>
>> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
>> index 6ac3b40cb5ff..8c76c4a981bf 100644
>> --- a/drivers/cxl/cxl.h
>> +++ b/drivers/cxl/cxl.h
>
>>  /**
>>   * struct cxl_region_params - region settings
>>   * @state: allow the driver to lockdown further parameter changes
>> + * @state: region label state
>
>wrong name.

Fixed it in V6

>
>Run scripts/kernel-doc over files you add documentation to and it'll
>tell you when you get anything like this wrong.

I ran it but its not showing any error and displaying the wrong name
only.


Regards,
Neeraj

>
>>   * @uuid: unique id for persistent regions
>>   * @interleave_ways: number of endpoints in the region
>>   * @interleave_granularity: capacity each endpoint contributes to a stripe
>> @@ -488,6 +494,7 @@ enum cxl_config_state {
>>   */
>>  struct cxl_region_params {
>>  	enum cxl_config_state state;
>> +	enum region_label_state state_region_label;
>>  	uuid_t uuid;
>>  	int interleave_ways;
>>  	int interleave_granularity;
>

------HKC0oM6l2X7jDELFNxUL3gr1rNZobpnU9ZVzK0VPY15yFScq=_11f8d9_
Content-Type: text/plain; charset="utf-8"


------HKC0oM6l2X7jDELFNxUL3gr1rNZobpnU9ZVzK0VPY15yFScq=_11f8d9_--
