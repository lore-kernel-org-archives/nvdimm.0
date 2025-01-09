Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA22B433C4
	for <nvdimm@lists.linux.dev>; Thu,  9 Jan 2025 15:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736435197; cv=none; b=Teqgc6KNVLHx7AFieK8dkLqhKWAucqlVc4UXUFMaztPkoSKCfaXyhVKMNdLh3hOeVw9n+rnjWUFWUPcpwyjRwUcPlzKcHOrRwTe1mwVZcm3sQI9Vv8bWAFR+GqE/18VAbotv5a7bLk3fLPf9ZCCgRv/AqXbX3NXs+NtvbuEYYeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736435197; c=relaxed/simple;
	bh=jA4Yiiq6qWErSPEid33gIzFHmCmRTsjJmwWwDusdy6c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oSjW/Qa1SW4ygCchnEbhnSXLXXoWZaTB9pdGQgq9m8t96OjxzS9ZPeqBChYbrHFWPtvfPH2eSpsTTiaWCwAtFGBjASbOkH/JDuuAJ3M3mOTtHH/5L4+Dmb/neXxUG+GNSdc+PxLOKPem9x3zsVq0ShAY6SWhPdUlF3w+/sKSQms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MzcPwquT; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MzcPwquT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736435196; x=1767971196;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=jA4Yiiq6qWErSPEid33gIzFHmCmRTsjJmwWwDusdy6c=;
  b=MzcPwquTojaQAd6194Zw5HwKSjUfHaPctpj4tycIC5qYUypDBIUUBsfy
   W1mLISe0wHRoG5IAyAZrQM0sEGUuVX3pH3I5Iw6ivqFyw+Q+77ND8vu2B
   AGZRRkffQ018emxRy8oKpO4YOJAkC/wM3pOTSXBbYwbk7Jr4PL9fqZYWY
   RYXH575B30pTV9V3a/GH346IO0gvO7U2EdIgPy8A2SKVIL0P1aGbWrua9
   l79NBG+LFGDUocuBz6VYf/rzjqMLIiGtmU4hGxeYI0qubd4oE+PyWBnQw
   yjCt2aIOfT2OoWiCXkIOrwJYQgasJAObUHURX/32bBo1qayPMq1nclmsr
   g==;
X-CSE-ConnectionGUID: WA3Ep5AgSMiO2U6rX9zgPA==
X-CSE-MsgGUID: EKOBVhQ5QuC6D+RLfw8HIA==
X-IronPort-AV: E=McAfee;i="6700,10204,11310"; a="54244070"
X-IronPort-AV: E=Sophos;i="6.12,301,1728975600"; 
   d="scan'208";a="54244070"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2025 07:06:34 -0800
X-CSE-ConnectionGUID: LHlCbrCcS8yPMPXlKtMPsw==
X-CSE-MsgGUID: 5P2wOC31QFKaWddb+y1Eaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="108484765"
Received: from puneetse-mobl.amr.corp.intel.com (HELO [10.125.111.99]) ([10.125.111.99])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2025 07:06:34 -0800
Message-ID: <878e7d99-6755-463c-9932-93ffebff1573@intel.com>
Date: Thu, 9 Jan 2025 08:06:32 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH 1/1] daxctl: Output more information if memblock is
 unremovable
To: Li Ming <ming.li@zohomail.com>,
 Alison Schofield <alison.schofield@intel.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
References: <20241204161457.1113419-1-ming.li@zohomail.com>
 <Z1JO7WUKwTcBVIYA@aschofie-mobl2.lan>
 <742c568a-1f78-4325-9521-852900098903@intel.com>
 <0ced507d-1b07-43ac-9cc3-28e651e2aa26@zohomail.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <0ced507d-1b07-43ac-9cc3-28e651e2aa26@zohomail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/8/25 5:58 PM, Li Ming wrote:
> On 1/9/2025 12:46 AM, Dave Jiang wrote:
>>
>> On 12/5/24 6:10 PM, Alison Schofield wrote:
>>> On Thu, Dec 05, 2024 at 12:14:56AM +0800, Li Ming wrote:
>>>> If CONFIG_MEMORY_HOTREMOVE is disabled by kernel, memblocks will not be
>>>> removed, so 'dax offline-memory all' will output below error logs:
>>>>
>>>>   libdaxctl: offline_one_memblock: dax0.0: Failed to offline /sys/devices/system/node/node6/memory371/state: Invalid argument
>>>>   dax0.0: failed to offline memory: Invalid argument
>>>>   error offlining memory: Invalid argument
>>>>   offlined memory for 0 devices
>>>>
>>>> The log does not clearly show why the command failed. So checking if the
>>>> target memblock is removable before offlining it by querying
>>>> '/sys/devices/system/node/nodeX/memoryY/removable', then output specific
>>>> logs if the memblock is unremovable, output will be:
>>>>
>>>>   libdaxctl: offline_one_memblock: dax0.0: memory371 is unremovable
>>>>   dax0.0: failed to offline memory: Operation not supported
>>>>   error offlining memory: Operation not supported
>>>>   offlined memory for 0 devices
>>>>
>>> Hi Ming,
>>>
>>> This led me to catch up on movable and removable in DAX context.
>>> Not all 'Movable' DAX memory is 'Removable' right?
>>>
>>> Would it be useful to add 'removable' to the daxctl list json:
>>>
>>> # daxctl list
>>> [
>>>   {
>>>     "chardev":"dax0.0",
>>>     "size":536870912,
>>>     "target_node":0,
>>>     "align":2097152,
>>>     "mode":"system-ram",
>>>     "online_memblocks":4,
>>>     "total_memblocks":4,
>>>     "movable":true
>>>     "removable":false  <----
>> Maybe adding some documentation and explaining the two fields? Otherwise it may get confusing.
>>
>> DJ
> 
> Hi Dave,
> 
> 
> Thanks for your review, As my latest comment,
> 
> if no "movable" in daxctl list, that means the kernel not supported MEMORY_HOTREMOVE, the meanning is the same as "removable: false".
> 
> if a "movable" in daxctl list, that means the kernel supporting MEMORY_HOTREMOVE, and the value of "movable" decides whether the memory block can be removed.
> 
> My feeling is that "movable" is enough, may I know if it still is worth to add a new "removable"?

Yes "movable" is sufficient. No need to over complicate things. 

DJ

> 
> 
> Ming
> 
> 
>>
>>>   }
>>> ]
>>>
>>> You've already added the helper to discover removable.
>>>
>>> Otherwise, LGTM,
>>> Reviewed-by: Alison Schofield <alison.schofield@intel.com>
>>>
>>>
>>>> Besides, delay to set up string 'path' for offlining memblock operation,
>>>> because string 'path' is stored in 'mem->mem_buf' which is a shared
>>>> buffer, it will be used in memblock_is_removable().
>>>>
>>>> Signed-off-by: Li Ming <ming.li@zohomail.com>
>>>> ---
>>>>  daxctl/lib/libdaxctl.c | 52 ++++++++++++++++++++++++++++++++++++------
>>>>  1 file changed, 45 insertions(+), 7 deletions(-)
>>>>
>>>> diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
>>>> index 9fbefe2e8329..b7fa0de0b73d 100644
>>>> --- a/daxctl/lib/libdaxctl.c
>>>> +++ b/daxctl/lib/libdaxctl.c
>>>> @@ -1310,6 +1310,37 @@ static int memblock_is_online(struct daxctl_memory *mem, char *memblock)
>>>>  	return 0;
>>>>  }
>>>>  
>>>> +static int memblock_is_removable(struct daxctl_memory *mem, char *memblock)
>>>> +{
>>>> +	struct daxctl_dev *dev = daxctl_memory_get_dev(mem);
>>>> +	const char *devname = daxctl_dev_get_devname(dev);
>>>> +	struct daxctl_ctx *ctx = daxctl_dev_get_ctx(dev);
>>>> +	int len = mem->buf_len, rc;
>>>> +	char buf[SYSFS_ATTR_SIZE];
>>>> +	char *path = mem->mem_buf;
>>>> +	const char *node_path;
>>>> +
>>>> +	node_path = daxctl_memory_get_node_path(mem);
>>>> +	if (!node_path)
>>>> +		return -ENXIO;
>>>> +
>>>> +	rc = snprintf(path, len, "%s/%s/removable", node_path, memblock);
>>>> +	if (rc < 0)
>>>> +		return -ENOMEM;
>>>> +
>>>> +	rc = sysfs_read_attr(ctx, path, buf);
>>>> +	if (rc) {
>>>> +		err(ctx, "%s: Failed to read %s: %s\n",
>>>> +			devname, path, strerror(-rc));
>>>> +		return rc;
>>>> +	}
>>>> +
>>>> +	if (strtoul(buf, NULL, 0) == 0)
>>>> +		return -EOPNOTSUPP;
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>>  static int online_one_memblock(struct daxctl_memory *mem, char *memblock,
>>>>  		enum memory_zones zone, int *status)
>>>>  {
>>>> @@ -1362,6 +1393,20 @@ static int offline_one_memblock(struct daxctl_memory *mem, char *memblock)
>>>>  	char *path = mem->mem_buf;
>>>>  	const char *node_path;
>>>>  
>>>> +	/* if already offline, there is nothing to do */
>>>> +	rc = memblock_is_online(mem, memblock);
>>>> +	if (rc < 0)
>>>> +		return rc;
>>>> +	if (!rc)
>>>> +		return 1;
>>>> +
>>>> +	rc = memblock_is_removable(mem, memblock);
>>>> +	if (rc) {
>>>> +		if (rc == -EOPNOTSUPP)
>>>> +			err(ctx, "%s: %s is unremovable\n", devname, memblock);
>>>> +		return rc;
>>>> +	}
>>>> +
>>>>  	node_path = daxctl_memory_get_node_path(mem);
>>>>  	if (!node_path)
>>>>  		return -ENXIO;
>>>> @@ -1370,13 +1415,6 @@ static int offline_one_memblock(struct daxctl_memory *mem, char *memblock)
>>>>  	if (rc < 0)
>>>>  		return -ENOMEM;
>>>>  
>>>> -	/* if already offline, there is nothing to do */
>>>> -	rc = memblock_is_online(mem, memblock);
>>>> -	if (rc < 0)
>>>> -		return rc;
>>>> -	if (!rc)
>>>> -		return 1;
>>>> -
>>>>  	rc = sysfs_write_attr_quiet(ctx, path, mode);
>>>>  	if (rc) {
>>>>  		/* check if something raced us to offline (unlikely) */
>>>> -- 
>>>> 2.34.1
>>>>
>>>>
> 

