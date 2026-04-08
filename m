Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2A327E076
	for <nvdimm@lists.linux.dev>; Wed,  8 Apr 2026 20:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775679539; cv=none; b=fqX5z9XtlmR7oWEZfg0BK8TsgSFBz0asSodejv34Z6bA2k24hqzPGWJbz3NcyJ34PXeHucN8hROOTq4GMmHJ51+hQOTK4zHAWzr41gYUebsbij40hXKhGc4uaRqyQaHN5KUkgcaTchCClhrUjFg9bVyPC3nTla8RTQdeZZyyQ10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775679539; c=relaxed/simple;
	bh=NsbyXZZjY+QaftE1GmT5nHh/RjH8hpkJmLSeXt7F4Go=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=MHCut3joEjrYuSpXoOHpec9+6ZAgAbJo02sKK6oITGqt//X354UrzkTp+MiP0rrH4r8FZSo4DZN7qHvlGl8Gt9JFlf6d/aUT1lLgeuk1rbtWxxuOvQvXW7/YII+d6PwTm47fg2Ro5hkgwudMdE26juD0A6KDtIY+SGt8RzIv8Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EkwPHqHM; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EkwPHqHM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775679537; x=1807215537;
  h=message-id:date:mime-version:subject:from:to:references:
   in-reply-to:content-transfer-encoding;
  bh=NsbyXZZjY+QaftE1GmT5nHh/RjH8hpkJmLSeXt7F4Go=;
  b=EkwPHqHMv4VriO1JXPW5Le0SXnYK5eTbwdwqlUbjI+7CS++XoC7EM3V/
   wzNzv9szokux9ct0sVOOmzAmovy0KPUgkluawSBVrbg7CinRUHLxrPtkX
   MCnuxvE7OjND/jiQnIGUP/n0PgfNgL1/kG1vV+OrbsP1KLuhdoeRmZpnZ
   V7fWpVTsy9oB67ibP0aYjLPJVjaxDdSC5+nxVlOZ6zrGWe1M+XoIWz09o
   opsGmTbUetWJBqkX++8ba48b5c2hlK7Gdkrg05P6BtJDmMI4iXTHCM/XA
   /EPFAOD9WF3znahedzZMLm4kgRUrQGYawy/8rrI+egu7l6F0BYmUlE+Td
   A==;
X-CSE-ConnectionGUID: HJPUGM8zS1aQuGAlXSgg4A==
X-CSE-MsgGUID: r0l5VUQmSEGOObJlj7jylg==
X-IronPort-AV: E=McAfee;i="6800,10657,11753"; a="87752630"
X-IronPort-AV: E=Sophos;i="6.23,168,1770624000"; 
   d="scan'208";a="87752630"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2026 13:18:57 -0700
X-CSE-ConnectionGUID: wMS3nQ2USXKdSvWOgCOdfA==
X-CSE-MsgGUID: 80MNFqz/R+aId60KVfEk/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,168,1770624000"; 
   d="scan'208";a="233451961"
Received: from aschende-mobl.amr.corp.intel.com (HELO [10.125.108.185]) ([10.125.108.185])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2026 13:18:57 -0700
Message-ID: <cade917d-637a-4a6f-bcbc-e258dbee3b67@intel.com>
Date: Wed, 8 Apr 2026 13:18:56 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH 3/3] test/mmap.sh: reduce fallocate size from 1GiB
 to 256MiB
From: Dave Jiang <dave.jiang@intel.com>
To: Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev
References: <09ef1cacb6dcb0accae1756561b0f761a764aaba.1775018517.git.alison.schofield@intel.com>
 <f2ab6877b5895a95e2f7eccaa452ab29e6bc3b9c.1775018517.git.alison.schofield@intel.com>
 <2b2e0fe8-d163-43f3-b1b7-71d134b86fb7@intel.com>
Content-Language: en-US
In-Reply-To: <2b2e0fe8-d163-43f3-b1b7-71d134b86fb7@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/1/26 3:53 PM, Dave Jiang wrote:
> 
> 
> On 3/31/26 9:49 PM, Alison Schofield wrote:
>> The mmap test allocates a 1 GiB file and exercises a matrix of mmap
>> flag combinations across ext4+dax and xfs+dax, performing multiple
>> full-range read and write passes for each case.
>>
>> The coverage of this test comes from the mmap modes and access
>> patterns it exercises (MAP_SHARED vs MAP_PRIVATE, MAP_POPULATE,
>> mlock/munlock, and read-only mappings), not from the size of the
>> mapping itself. These behaviors are not size-dependent, and no test
>> assertions rely on a 1 GiB mapping.
>>
>> Long CI runtimes prompted a closer look at this test, but the
>> reduction stands on its own merits: a 256 MiB mapping still spans many
>> PMD (2 MiB) DAX mappings and exercises the same access patterns, while
>> avoiding unnecessary work in each test case.
> 
> No excercise of tests against 1GB page?
> 
> DJ

Looking a bit more, fallocate() does not care about underneath page size. So this is probably ok.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>


> 
> 
>>
>> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
>> ---
>>  test/mmap.sh | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/test/mmap.sh b/test/mmap.sh
>> index 7d0053da0e1a..c517d5b0f50b 100755
>> --- a/test/mmap.sh
>> +++ b/test/mmap.sh
>> @@ -59,12 +59,12 @@ rc=1
>>  
>>  mkfs.ext4 $DEV
>>  mount $DEV $MNT -o dax
>> -fallocate -l 1GiB $MNT/$FILE
>> +fallocate -l 256MiB $MNT/$FILE
>>  test_mmap
>>  umount $MNT
>>  
>>  mkfs.xfs -f $DEV -m reflink=0
>>  mount $DEV $MNT -o dax
>> -fallocate -l 1GiB $MNT/$FILE
>> +fallocate -l 256MiB $MNT/$FILE
>>  test_mmap
>>  umount $MNT
> 
> 

