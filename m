Received: from esa3.hc1455-7.c3s2.iphmx.com (esa3.hc1455-7.c3s2.iphmx.com [207.54.90.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9DAFBEB
	for <nvdimm@lists.linux.dev>; Mon, 29 Jan 2024 02:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.54.90.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706494945; cv=none; b=Z7okudQtPaBNLvByA+McKoL+ukNsH6Zs1+WTuyzqqaLy3RiyaG288Y6aOCs6uRqNj5QXKSPH/N5Gzm0hhFi50eMUsBhpLB96WZirMc1mX/RdA3I4WpE+TzBoINkAK4FRJo2ogB4XonujpxLt30Fe/gMOi/gbUdL99tbQwpiWxRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706494945; c=relaxed/simple;
	bh=CKlhhtba3CD0STspJc7Cx2a94utzUV/y2NqjDJ1/Wzo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=koqnOcrR7UwzlF16gME8WMCOX9HFCiz9vh4nMj6bS/3admVQqrvaSgMIOjB2QbVAFCEz6zrkD8sWWLPQL9/fvCwXLq2zPKmNmeu7b72/bI2H5THXjp+7yV/HkwJcWy63RZFuyCXtK1aTvqZd5YmsxcZaR9CP4oO3Smg3o+76PsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=HXCctTcn; arc=none smtp.client-ip=207.54.90.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="HXCctTcn"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1706494943; x=1738030943;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CKlhhtba3CD0STspJc7Cx2a94utzUV/y2NqjDJ1/Wzo=;
  b=HXCctTcnCVYlINKhT37osZ9qlKztbTUVC8awaW5M1saqxEhRF2eQ8W4X
   ongMcigX9d8/bqJf2b7RlROPAL3iNPDwUtmwPFxz538pWdOMebJkqzSIy
   EpM0Gl+8XIjGZEvF+8CyuW0jYPnpjmMjDxw/sFujrPeHOQeyh5+oCNM11
   ETGhzGjFDgFGb55BIGtrnrQTVeCYxg8yuFw6jFkPRElT86GvvSVV25DU/
   r07gbpHG8UGmrYv/kvKTny5fulQn6+ze/efujeJoZu24izErONtvj+Nuu
   2PR9eXi7w7SCg/Cp9hu0bCgps4RUimIXQDyaAF//BtzH3+LGvjFwvhfxq
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10967"; a="147567434"
X-IronPort-AV: E=Sophos;i="6.05,226,1701097200"; 
   d="scan'208";a="147567434"
Received: from unknown (HELO oym-r3.gw.nic.fujitsu.com) ([210.162.30.91])
  by esa3.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2024 11:22:14 +0900
Received: from oym-m4.gw.nic.fujitsu.com (oym-nat-oym-m4.gw.nic.fujitsu.com [192.168.87.61])
	by oym-r3.gw.nic.fujitsu.com (Postfix) with ESMTP id 8258030732
	for <nvdimm@lists.linux.dev>; Mon, 29 Jan 2024 11:22:11 +0900 (JST)
Received: from kws-ab3.gw.nic.fujitsu.com (kws-ab3.gw.nic.fujitsu.com [192.51.206.21])
	by oym-m4.gw.nic.fujitsu.com (Postfix) with ESMTP id B511423F989
	for <nvdimm@lists.linux.dev>; Mon, 29 Jan 2024 11:22:10 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab3.gw.nic.fujitsu.com (Postfix) with ESMTP id 483FC2007B725
	for <nvdimm@lists.linux.dev>; Mon, 29 Jan 2024 11:22:10 +0900 (JST)
Received: from [10.167.220.145] (unknown [10.167.220.145])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id 45B121A006A;
	Mon, 29 Jan 2024 10:22:09 +0800 (CST)
Message-ID: <64d4a375-ddca-18bf-8532-f730632534b7@fujitsu.com>
Date: Mon, 29 Jan 2024 10:22:08 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: =?UTF-8?Q?Re=3a_=5bPATCH=5d_cxl/region=ef=bc=9aFix_overflow_issue_i?=
 =?UTF-8?Q?n_alloc=5fhpa=28=29?=
To: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
Cc: dave.jiang@intel.com, vishal.l.verma@intel.com,
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
References: <20240124091527.8469-1-caoqq@fujitsu.com>
 <20240126174223.00005736@Huawei.com>
From: =?UTF-8?B?Q2FvLCBRdWFucXVhbi/mm7kg5YWo5YWo?= <caoqq@fujitsu.com>
In-Reply-To: <20240126174223.00005736@Huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-28148.004
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-28148.004
X-TMASE-Result: 10--8.148700-10.000000
X-TMASE-MatchedRID: mZljRXDwq+6PvrMjLFD6eKpLARk+zpBZ2q80vLACqaeqvcIF1TcLYGfo
	kmkn+GKT5TwyRv/sPZaBTisMRWo71i9Yu0mNbmByAD5jSg1rFtDKrKWVfpQki14a0aNSuN1VXcM
	Ef3Bp/ti5iEI90L56oZJTeWTYf8Y24OhwfKpL0fBO5y1KmK5bJRSLgSFq3TnjoxCLfriDzzgTgt
	4grpaSCgck6AzfHUrUGQhUUzPq97nlFpsfMgM6DJ4CIKY/Hg3AWQy9YC5qGvwCwwGD+AF1Ue52O
	dZcC6tPJ0RPnyOnrZJ3pVBy2wMQd62spm70ENSYSSKyOaBXUW9K5ws+QNVNuYQE/NtwblrbJYkf
	AuWGOfvPSFc5scb3CUp6IHVxSn0AJM53v5HcfHNlJCOsB4awXOVV62x4Nv+CWHt/4pqKiNrUEwC
	0VA4Efc/9za0y1DHl
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0



在 2024/1/27 1:42, Jonathan Cameron 写道:
> On Wed, 24 Jan 2024 17:15:26 +0800
> Quanquan Cao <caoqq@fujitsu.com> wrote:
> 
>> Creating a region with 16 memory devices caused a problem. The div_u64_rem
>> function, used for dividing an unsigned 64-bit number by a 32-bit one,
>> faced an issue when SZ_256M * p->interleave_ways. The result surpassed
>> the maximum limit of the 32-bit divisor (4G), leading to an overflow
>> and a remainder of 0.
>> note: At this point, p->interleave_ways is 16, meaning 16 * 256M = 4G
>>
>> To fix this issue, I replaced the div_u64_rem function with div64_u64_rem
>> and adjusted the type of the remainder.
>>
>> Signed-off-by: Quanquan Cao <caoqq@fujitsu.com>
> Good find, though now I'm curious on whether you have a real system doing
> 16 way interleave :)

Yes, currently the specification is 8, and 16 will be the maximum value.

> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
>> ---
>>   drivers/cxl/core/region.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
>> index 0f05692bfec3..ce0e2d82bb2b 100644
>> --- a/drivers/cxl/core/region.c
>> +++ b/drivers/cxl/core/region.c
>> @@ -525,7 +525,7 @@ static int alloc_hpa(struct cxl_region *cxlr, resource_size_t size)
>>   	struct cxl_root_decoder *cxlrd = to_cxl_root_decoder(cxlr->dev.parent);
>>   	struct cxl_region_params *p = &cxlr->params;
>>   	struct resource *res;
>> -	u32 remainder = 0;
>> +	u64 remainder = 0;
>>   
>>   	lockdep_assert_held_write(&cxl_region_rwsem);
>>   
>> @@ -545,7 +545,7 @@ static int alloc_hpa(struct cxl_region *cxlr, resource_size_t size)
>>   	    (cxlr->mode == CXL_DECODER_PMEM && uuid_is_null(&p->uuid)))
>>   		return -ENXIO;
>>   
>> -	div_u64_rem(size, SZ_256M * p->interleave_ways, &remainder);
>> +	div64_u64_rem(size, (u64)SZ_256M * p->interleave_ways, &remainder);
>>   	if (remainder)
>>   		return -EINVAL;
>>   
> 
