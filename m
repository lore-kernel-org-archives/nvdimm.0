Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B744246BA4
	for <nvdimm@lists.linux.dev>; Mon,  6 Oct 2025 04:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759726508; cv=none; b=Rc+do8l1mC43bIacsTMR7M0AaVRehhMwcNIwuI2ld51/s1CF4WWTXt/IREqL55jaCzWofDs/XpycwMoptSGYGVbP5BIolnuSpdpLbILRMXn8yc9khKiBpl9MNW0a7iGblx4CP1ikNpxLFr5u3CSDYcgH3T0Mr22JMhI1MaLM+ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759726508; c=relaxed/simple;
	bh=zx+X2uKCH9gsTRMNkm/Ang3LwNBMHw2CBcoJElwZB+o=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=HWi1vWCdHTuaf9cy7kTaAgAWLZE8gOrrCM/l+wo1UbzmHCIqopWTCEHFucLg7etYFn6aU+PLS1gI+DGwQ9cUOl8uQzYuYVvvF/n1EFBxMoXy8cQ5P64E3xM5JCAShKG0NK9ziiUqZCmoQlDuStrZ/B1gABdlQMlLolMqdbkPQn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=IBOCVdgl; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="IBOCVdgl"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20251006045504epoutp0362e47ba4d4b66b89fa8ff220131ded59~rze69oaGF1644716447epoutp03h
	for <nvdimm@lists.linux.dev>; Mon,  6 Oct 2025 04:55:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20251006045504epoutp0362e47ba4d4b66b89fa8ff220131ded59~rze69oaGF1644716447epoutp03h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1759726504;
	bh=8kU//sEdTmfs/g7gmk2VRKq+yGPO2U2Y0rl/ZofC0GM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=IBOCVdglQbTFA5Qs9WXLvLrySWqGN9+54Z7c0ryL1w2bdK4hy/nzFJatg5Y/c8IL0
	 6d3yCSW++L9hilv/8r7/A96EpU3u/+brnn+UPFyOutURE7eA11XG74IcLiNcvHiKKf
	 5uhWwPzal0Z6plF6z6ZdQVjNnB+7RMo7B2fX0ubI=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20251006045504epcas5p4d5c5d1119723e8ddffa1bbbbb47d120c~rze6rUB2-2409424094epcas5p4A;
	Mon,  6 Oct 2025 04:55:04 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4cg6QJ2T0Mz6B9m5; Mon,  6 Oct
	2025 04:55:04 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250929135753epcas5p3e4144310889019356bea550553520e29~pxX3Q77zQ3196531965epcas5p3N;
	Mon, 29 Sep 2025 13:57:53 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250929135750epsmtip25047e18f018a59fc329a3601ac3794b4~pxX0Ju10x1123911239epsmtip2C;
	Mon, 29 Sep 2025 13:57:50 +0000 (GMT)
Date: Mon, 29 Sep 2025 19:27:45 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V3 18/20] cxl/pmem_region: Prep patch to accommodate
 pmem_region attributes
Message-ID: <1279309678.121759726504330.JavaMail.epsvc@epcpadp1new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <147c4f1a-b8f6-4a99-8469-382b897f326d@intel.com>
X-CMS-MailID: 20250929135753epcas5p3e4144310889019356bea550553520e29
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----fevm_dXp0U54qslEOU8oiqO.VnigTQz743t4hqwhjBnK2JlQ=_7522_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250917134209epcas5p1b7f861dbd8299ec874ae44cbf63ce87c
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
	<CGME20250917134209epcas5p1b7f861dbd8299ec874ae44cbf63ce87c@epcas5p1.samsung.com>
	<20250917134116.1623730-19-s.neeraj@samsung.com>
	<147c4f1a-b8f6-4a99-8469-382b897f326d@intel.com>

------fevm_dXp0U54qslEOU8oiqO.VnigTQz743t4hqwhjBnK2JlQ=_7522_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 24/09/25 11:53AM, Dave Jiang wrote:
>
>
>On 9/17/25 6:41 AM, Neeraj Kumar wrote:
>> Created a separate file core/pmem_region.c along with CONFIG_PMEM_REGION
>> Moved pmem_region related code from core/region.c to core/pmem_region.c
>> For region label update, need to create device attribute, which calls
>> nvdimm exported function thus making pmem_region dependent on libnvdimm.
>> Because of this dependency of pmem region on libnvdimm, segregated pmem
>> region related code from core/region.c
>
>We can minimize the churn in this patch by introduce the new core/pmem_region.c and related bits in the beginning instead of introduce new functions and then move them over from region.c.

Hi Dave,

As per LSA 2.1, during region creation we need to intract with nvdimmm
driver to write region label into LSA.
This dependency of libnvdimm is only for PMEM region, therefore I have
created a seperate file core/pmem_region.c and copied pmem related functions
present in core/region.c into core/pmem_region.c.
Because of this movemement of code we have churn introduced in this patch.
Can you please suggest optimized way to handle dependency on libnvdimm
with minimum code changes.

>
>> diff --git a/drivers/cxl/Kconfig b/drivers/cxl/Kconfig
>> index 48b7314afdb8..532eaa1bbdd6 100644
>> --- a/drivers/cxl/Kconfig
>> +++ b/drivers/cxl/Kconfig
>> @@ -211,6 +211,20 @@ config CXL_REGION
>>
>>  	  If unsure say 'y'
>>
>> +config CXL_PMEM_REGION
>> +	bool "CXL: Pmem Region Support"
>> +	default CXL_BUS
>> +	depends on CXL_REGION
>
>> +	depends on PHYS_ADDR_T_64BIT
>> +	depends on BLK_DEV
>These 2 deps are odd. What are the actual dependencies?
>

We need to add these 2 deps to fix v2 0Day issue [1]
I have taken reference from bdf97013ced5f [2]
Seems, I also have to add depends on ARCH_HAS_PMEM_API. I will update it
in V3.

[1] https://lore.kernel.org/linux-cxl/202507311017.7ApKmtQc-lkp@intel.com/
[2] https://elixir.bootlin.com/linux/v6.13.7/source/drivers/acpi/nfit/Kconfig#L4

>
>> +	select LIBNVDIMM
>> +	help
>> +	  Enable the CXL core to enumerate and provision CXL pmem regions.
>> +	  A CXL pmem region need to update region label into LSA. For LSA
>> +	  updation/deletion libnvdimm is required.
>
>s/updation/update/
>

Sure, Will fix it

>> +
>> +	  If unsure say 'y'
>> +
>>  config CXL_REGION_INVALIDATION_TEST
>>  	bool "CXL: Region Cache Management Bypass (TEST)"
>>  	depends on CXL_REGION

<snip>

>> --- a/drivers/cxl/core/port.c
>> +++ b/drivers/cxl/core/port.c
>> @@ -53,7 +53,7 @@ static int cxl_device_id(const struct device *dev)
>>  		return CXL_DEVICE_NVDIMM_BRIDGE;
>>  	if (dev->type == &cxl_nvdimm_type)
>>  		return CXL_DEVICE_NVDIMM;
>> -	if (dev->type == CXL_PMEM_REGION_TYPE())
>> +	if (dev->type == CXL_PMEM_REGION_TYPE)
>
>Stray edit? I don't think anything changed in the declaration.
>

Sure, Will fix it

>>  		return CXL_DEVICE_PMEM_REGION;
>>  	if (dev->type == CXL_DAX_REGION_TYPE())
>>  		return CXL_DEVICE_DAX_REGION;

<snip>

>> @@ -2382,7 +2380,7 @@ bool is_cxl_region(struct device *dev)
>>  }
>>  EXPORT_SYMBOL_NS_GPL(is_cxl_region, "CXL");
>>
>> -static struct cxl_region *to_cxl_region(struct device *dev)
>> +struct cxl_region *to_cxl_region(struct device *dev)
>>  {
>>  	if (dev_WARN_ONCE(dev, dev->type != &cxl_region_type,
>>  			  "not a cxl_region device\n"))
>> @@ -2390,6 +2388,7 @@ static struct cxl_region *to_cxl_region(struct device *dev)
>>
>>  	return container_of(dev, struct cxl_region, dev);
>>  }
>> +EXPORT_SYMBOL_NS_GPL(to_cxl_region, "CXL");
>
>Maybe just move this into the header file instead.
>
>DJ

Actually to_cxl_region() is internal to cxl/core and especially to core/region.c
So, Its better to compeletly remove EXPORT_SYMBOL_NS_GPL(to_cxl_region, "CXL")

Even EXPORT_SYMBOL_NS_GPL(is_cxl_region, "CXL") is internal to cxl/core/region.c
Should I also remove it?

Even we can remove declaration of is_cxl_region() and to_cxl_region()
from drivers/cxl/cxl.h as these functions are internal to cxl/core/region.c


Regards,
Neeraj


------fevm_dXp0U54qslEOU8oiqO.VnigTQz743t4hqwhjBnK2JlQ=_7522_
Content-Type: text/plain; charset="utf-8"


------fevm_dXp0U54qslEOU8oiqO.VnigTQz743t4hqwhjBnK2JlQ=_7522_--

