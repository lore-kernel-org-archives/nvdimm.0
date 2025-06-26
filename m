Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3EF92E543C
	for <nvdimm@lists.linux.dev>; Thu, 26 Jun 2025 13:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750944308; cv=none; b=rpaGC1XXJZLl2jNaoPvcIYwaOYhPsiTYYI3CFrVlGOmEMgvNW4YjGRObImpx8rKPgnefBaS/y+H2Baz7jqYQSTO9h63h35+Yks8g44Rb6BpzCExrNObIg9kbWFwkiNmnyrRwrp7IupD/93ozVpWaQbLpqAzmTiJVsVu9YF4TeWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750944308; c=relaxed/simple;
	bh=6bAsWv5N6Y3p0sd0C1G3Dxekr3+LRotoC+pAjpqfdpk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=WjVLvTHc57d28i09utWKOMpLinFKW1VXVdKS54gIZQs+HcUXYWC15SKUm1glDM16l19VRxzNA4XNd+KQyd6HIIFoYBmiu2zL9Wy8B6+SOjS7au6DGAnaBrAALIqbZAJcUmW088YyGZS12me6FFtuHpSX9fv7TXkz4mUUHoK0TVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Ll5NUs+O; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Ll5NUs+O"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250626132503epoutp012d3ff1979b9cb1e35f16c3b181d6a4f7~MmpFMRf6w2271422714epoutp01d
	for <nvdimm@lists.linux.dev>; Thu, 26 Jun 2025 13:25:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250626132503epoutp012d3ff1979b9cb1e35f16c3b181d6a4f7~MmpFMRf6w2271422714epoutp01d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1750944304;
	bh=50S/mYxuhjZKsvbB7nGmHrgCA/TG29pVI1CLj9OyuvQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Ll5NUs+OO1stbHM2xEoVvn7nhYJ8tI/ueoLS6aqSFIlHyvTd/ab+cDwvRuPnrgJqh
	 X0OT+LjIv1NpBlFMoqXaGo9tuqau7zsGut6zrrzptHOPMSmSjLbi8wyleYOWs7+Uic
	 SuoOL7Ps+4n3Ofl69XOz+bmA8Rl5hivicTfrL9w8=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250626132503epcas5p3eaa9974bdfcb56990e34ba91e6ae1b7e~MmpErVTEn2718927189epcas5p3p;
	Thu, 26 Jun 2025 13:25:03 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4bSfYq2mvpz6B9m5; Thu, 26 Jun
	2025 13:25:03 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250626104537epcas5p248aa564f3c002ce6e3e532edbffcbb75~Mkd330oy91316013160epcas5p2O;
	Thu, 26 Jun 2025 10:45:37 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250626104535epsmtip2e53f5f49ba915a23417be6a216bed7d0~Mkd1ctdQ02206722067epsmtip2M;
	Thu, 26 Jun 2025 10:45:34 +0000 (GMT)
Date: Thu, 26 Jun 2025 16:15:28 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: dan.j.williams@intel.com, dave@stgolabs.net, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com,
	a.manzanares@samsung.com, nifan.cxl@gmail.com, anisa.su@samsung.com,
	vishak.g@samsung.com, krish.reddy@samsung.com, arun.george@samsung.com,
	alok.rathore@samsung.com, neeraj.kernel@gmail.com,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, gost.dev@samsung.com, cpgs@samsung.com
Subject: Re: [RFC PATCH 19/20] cxl/pmem_region: Prep patch to accommodate
 pmem_region attributes
Message-ID: <1296674576.21750944303379.JavaMail.epsvc@epcpadp1new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250623105337.000028c6@huawei.com>
X-CMS-MailID: 20250626104537epcas5p248aa564f3c002ce6e3e532edbffcbb75
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----ccPbqUR1b2FiTe9wDLZ4x.aheQWUm9HBntMNkAPxEtPuJZ0j=_6a498_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250617124101epcas5p4d54f34ebc5161b7cb816e352d144d9a1
References: <20250617123944.78345-1-s.neeraj@samsung.com>
	<CGME20250617124101epcas5p4d54f34ebc5161b7cb816e352d144d9a1@epcas5p4.samsung.com>
	<1997287019.101750165383025.JavaMail.epsvc@epcpadp2new>
	<20250623105337.000028c6@huawei.com>

------ccPbqUR1b2FiTe9wDLZ4x.aheQWUm9HBntMNkAPxEtPuJZ0j=_6a498_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 23/06/25 10:53AM, Jonathan Cameron wrote:
>On Tue, 17 Jun 2025 18:09:43 +0530
>Neeraj Kumar <s.neeraj@samsung.com> wrote:
>
>> Created a separate file core/pmem_region.c along with CONFIG_PMEM_REGION
>> Moved pmem_region related code from core/region.c to core/pmem_region.c
>> For region label update, need to create device attribute, which calls
>> nvdimm exported function thus making pmem_region dependent on libnvdimm.
>> Because of this dependency of pmem region on libnvdimm, segregated pmem
>
>segregate
>

Thanks, Will fix the commit message.

>> region related code from core/region.c
>>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>> ---
>>  drivers/cxl/Kconfig            |  12 ++
>>  drivers/cxl/core/Makefile      |   1 +
>>  drivers/cxl/core/core.h        |   8 +-
>>  drivers/cxl/core/pmem_region.c | 222 +++++++++++++++++++++++++++++++++
>>  drivers/cxl/core/port.c        |   2 +-
>>  drivers/cxl/core/region.c      | 217 ++------------------------------
>>  drivers/cxl/cxl.h              |  42 +++++--
>>  tools/testing/cxl/Kbuild       |   1 +
>>  8 files changed, 283 insertions(+), 222 deletions(-)
>>  create mode 100644 drivers/cxl/core/pmem_region.c
>>
>> diff --git a/drivers/cxl/Kconfig b/drivers/cxl/Kconfig
>> index 876469e23f7a..f0cbb096bfe7 100644
>> --- a/drivers/cxl/Kconfig
>> +++ b/drivers/cxl/Kconfig
>> @@ -128,6 +128,18 @@ config CXL_REGION
>>
>>  	  If unsure say 'y'
>>
>> +config CXL_PMEM_REGION
>> +	bool "CXL: Pmem Region Support"
>> +	default CXL_BUS
>> +	depends on CXL_REGION
>> +	select LIBNVDIMM if CXL_BUS = y
>
>This is in the block covered by if CXL_BUS so I think you can simplify this check.
>

yes, its part of CXL_BUS block. I will update it as "select LIBNVDIMM".
Actually for CONFIG_CXL_PMEM_REGION=y we have dependency on CONFIG_LIBNVDIMM.

>> +	help
>> +	  Enable the CXL core to enumerate and provision CXL pmem regions.
>> +	  A CXL pmem region need to update region label into LSA. For LSA
>> +	  updation/deletion libnvdimm is required.
>> +
>> +	  If unsure say 'y'
>> +
>>  config CXL_REGION_INVALIDATION_TEST
>>  	bool "CXL: Region Cache Management Bypass (TEST)"
>>  	depends on CXL_REGION
>
>> diff --git a/drivers/cxl/core/pmem_region.c b/drivers/cxl/core/pmem_region.c
>> new file mode 100644
>> index 000000000000..a29526c27d40
>> --- /dev/null
>> +++ b/drivers/cxl/core/pmem_region.c
>> @@ -0,0 +1,222 @@
>
>> @@ -3273,92 +3155,6 @@ static struct cxl_dax_region *cxl_dax_region_alloc(struct cxl_region *cxlr)
>>  	return cxlr_dax;
>>  }
>
>>  static void cxlr_dax_unregister(void *_cxlr_dax)
>>  {
>>  	struct cxl_dax_region *cxlr_dax = _cxlr_dax;
>> @@ -3646,7 +3442,10 @@ static int cxl_region_probe(struct device *dev)
>>
>>  	switch (cxlr->mode) {
>>  	case CXL_DECODER_PMEM:
>> -		return devm_cxl_add_pmem_region(cxlr);
>> +		if (IS_ENABLED(CONFIG_CXL_PMEM_REGION))
>> +			return devm_cxl_add_pmem_region(cxlr);
>> +		else
>> +			return -EINVAL;
>		if (!IS_ENABLED(CONFIG_CXL_PMEM_REGION))
>			return -EINVAL;
>
>		return devm_cxl_add_pmem_region()
>
>Where ever possible keep the error conditions as the out of line ones.
>That generally improves code readability and is common practice in the kernel.
>

Thanks for suggestion Jonathan. Sure will fix it in V1

>>  	case CXL_DECODER_RAM:
>>  		/*
>>  		 * The region can not be manged by CXL if any portion of
>
>

------ccPbqUR1b2FiTe9wDLZ4x.aheQWUm9HBntMNkAPxEtPuJZ0j=_6a498_
Content-Type: text/plain; charset="utf-8"


------ccPbqUR1b2FiTe9wDLZ4x.aheQWUm9HBntMNkAPxEtPuJZ0j=_6a498_--

