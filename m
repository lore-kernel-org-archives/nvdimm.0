Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C1C60DD7
	for <nvdimm@lists.linux.dev>; Wed, 14 Feb 2024 16:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707928623; cv=none; b=B3EA5ZQmP+SingAUQOgvQT4EMfG5QwSWWot1q4PHjgewCHjiVB/BEX0QaBxgSzmIYymKpMEbQPZ5KKfpBXlnv5X0QgXBwsAWxlUEzh1buM7JdsWyamICisryUWP3/zCSMSX5FLKeEMW3p71kNP81vWRWb8wNlRmTlnjjQe3xJ7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707928623; c=relaxed/simple;
	bh=OhKMZD2a2h/nw11ivtTk8EcVPQyj98aTaS09295naPA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hbaM/p78L8nvceTsK6EKaMbWV5nN3F0m/lqkwfL5pdUcvOR3aNGO0AvgjBejQj2Z97Q3xluJGWkw/Ltm9hlR3k+HDFz0WB1AJxyQ1ZAfUrc5mWqBRjVp7g2ZXxGGIp5PXJj3qowsSKwWVIV+J3Rw+FtyktkID6LXyOnpaTNg6aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MxA2EVXP; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MxA2EVXP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707928621; x=1739464621;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OhKMZD2a2h/nw11ivtTk8EcVPQyj98aTaS09295naPA=;
  b=MxA2EVXPtnyxYco6ir/cCKGn2HXFF8cq0feRl0B/LGczhc/oMBlqVbC7
   bljbQVyLOSt+7WvvHflFiPWRmSqB0xg87Yl9IivNiJO9COE5Of1VqqXXx
   C4Aga8Z3wwKT2N0ywWk2EAw22KWvzpPjtVi5L4ld1aWi3HZSJa0NnRFi5
   n005EMt9/opNdwwrEH1/anu60JDLLdTSQ3lcqrUcZdRf77nVdbFDimgys
   4BgCgoPrKqaxTWETvkoCQ/UdxIQPzMNySN8M1b4V38L9I1rRVRCkR+ZXw
   Cnz6fl+otJKshwBob0htnKDBkG8c9/HYMm/x+oSTu7oRy4R0F/t/91FlN
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10984"; a="1893452"
X-IronPort-AV: E=Sophos;i="6.06,159,1705392000"; 
   d="scan'208";a="1893452"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2024 08:37:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,159,1705392000"; 
   d="scan'208";a="3586654"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.246.112.59]) ([10.246.112.59])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2024 08:36:59 -0800
Message-ID: <d821fa6e-da62-4b37-891d-409416b8e999@intel.com>
Date: Wed, 14 Feb 2024 09:36:57 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [NDCTL PATCH] ndctl: cxl: Remove dependency for attributes
 derived from IDENTIFY command
To: wj28.lee@samsung.com
Cc: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
 "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
 Hojin Nam <hj96.nam@samsung.com>, KyungSan Kim <ks0204.kim@samsung.com>
References: <20240209213917.2288994-1-dave.jiang@intel.com>
 <CGME20240209213933epcas2p389a0083635fb54160d62a3405a19fd73@epcms2p4>
 <20240214080033epcms2p49e131a0012d95c99591b60f36d4cda35@epcms2p4>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20240214080033epcms2p49e131a0012d95c99591b60f36d4cda35@epcms2p4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2/14/24 1:00 AM, Wonjae Lee wrote:
> On Fri, Feb 09, 2024 at 02:39:17PM -0700, Dave Jiang wrote:
>> A memdev may optionally not host a mailbox and therefore not able to execute
>> the IDENTIFY command. Currently the kernel emits empty strings for some of
>> the attributes instead of making them invisible in order to keep backward
>> compatibility for CXL CLI. Remove dependency of CXL CLI on the existance of
>> these attributes and only expose them if they exist. Without the dependency
>> the kernel will be able to make the non-existant attributes invisible.
>>
>> Link: https://lore.kernel.org/all/20230606121534.00003870@Huawei.com/
>> Suggested-by: Dan Williams <dan.j.williams@intel.com>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> ---
>>  cxl/lib/libcxl.c | 48 ++++++++++++++++++++++++++----------------------
>>  cxl/memdev.c     | 15 ++++++++++-----
>>  2 files changed, 36 insertions(+), 27 deletions(-)
>>
> 
> [snip]
> 
>> diff --git a/cxl/memdev.c b/cxl/memdev.c
>> index 81f07991da06..feab7ea76e78 100644
>> --- a/cxl/memdev.c
>> +++ b/cxl/memdev.c
>> @@ -473,10 +473,13 @@ static int action_zero(struct cxl_memdev *memdev, struct action_context *actx)
>>   size_t size;
>>   int rc;
>>
>> - if (param.len)
>> + if (param.len) {
>>       size = param.len;
>> - else
>> + } else {
>>       size = cxl_memdev_get_label_size(memdev);
>> +     if (size == ULLONG_MAX)
>> +         return -EINVAL;
>> + }
> 
> Hello,
> 
> Doesn't action_write() also need to check the return value of
> cxl_memdev_get_label_size() like below?

Yes. I missed that one. Thank you!
> 
> diff --git a/cxl/memdev.c b/cxl/memdev.c
> index feab7ea..de46edc 100644
> --- a/cxl/memdev.c
> +++ b/cxl/memdev.c
> @@ -511,6 +511,8 @@ static int action_write(struct cxl_memdev *memdev, struct action_context *actx)
> 
>         if (!size) {
>                 size_t label_size = cxl_memdev_get_label_size(memdev);
> +               if (label_size == ULLONG_MAX)
> +                       return -EINVAL;
> 
>                 fseek(actx->f_in, 0L, SEEK_END);
>                 size = ftell(actx->f_in);
> 
> Thanks,
> Wonjae
