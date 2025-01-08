Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0966A1FECC1
	for <nvdimm@lists.linux.dev>; Wed,  8 Jan 2025 16:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736354820; cv=none; b=acK/AGC/3pUUjMRMu6kx7sZaI45R4CH/4m40oTpQi8k7Hnf877eGnoCg5u2ouF+67+4kCphlULmkvIFv1bI2+ergKlFTcqDCEm9RtPZ/PAePgr95bmwNPLI6tb+AQTYdV0wjiIuWb5tCEgNW7NXQ8zIu8owXMAI9EmnXHhBrark=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736354820; c=relaxed/simple;
	bh=t1bbQi9bKaMjwAo5kThcpRZNncOMaXl1Pc21IQmyVCg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kQ/OssJHFJHM2vLtt+mIcv2D8UVy/4vYJI1FwLx4J28RKaW78oIFiTOrfZyd4UegA4XlutPJuD3JGAu9C5f4XMhDvkDhzQLKrlmunbjRhSJinXyyLesVVda1BQA8xEXwpdv6Bj5IsqDiDrp5qAGZ7O0p+jcN1VCjoDQUSLZjfYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a5j2Nr+x; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a5j2Nr+x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736354818; x=1767890818;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=t1bbQi9bKaMjwAo5kThcpRZNncOMaXl1Pc21IQmyVCg=;
  b=a5j2Nr+xLPEkiZmKRaWJbSWSwpg5328fBoK+bKK3mzJpmIv1BLyQBLDk
   H6h83+QqrB8ITChlfFA47i2LlLDHX/1JQ9R3LCiGAeL+Y74vFYoW4r2jN
   ui02LmrYnHDeS0UTSRwHMIzF5Iz0591OapWza6t+kdcfpABS754ztl+82
   lvFv6miMTuWp/y7BfUjTypnG7uDbgSnLXkpsVrltbHkidFtC2CyCzJz+d
   Th2JdvFVdl3S6QEOiUpQlGbVrBHt7bOmpM0C/KXM/rt5wG0VpiPqiWsSF
   b2W79e+IJT1W2pnrsn+iinK+BIeiGyda9muy/Xd9AJ55O0+9GcLfzuG26
   w==;
X-CSE-ConnectionGUID: HIjBc+SFRl+JuW0EgX1R6g==
X-CSE-MsgGUID: jL5dazdVThCox4LGa6aYqg==
X-IronPort-AV: E=McAfee;i="6700,10204,11309"; a="36705325"
X-IronPort-AV: E=Sophos;i="6.12,298,1728975600"; 
   d="scan'208";a="36705325"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2025 08:46:58 -0800
X-CSE-ConnectionGUID: 1CaF9pD3ThaKC8cvuz+OZQ==
X-CSE-MsgGUID: 1O4+a+gkRGmTM98xKygE2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="134033657"
Received: from mgoodin-mobl2.amr.corp.intel.com (HELO [10.125.111.11]) ([10.125.111.11])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2025 08:46:57 -0800
Message-ID: <742c568a-1f78-4325-9521-852900098903@intel.com>
Date: Wed, 8 Jan 2025 09:46:56 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH 1/1] daxctl: Output more information if memblock is
 unremovable
To: Alison Schofield <alison.schofield@intel.com>,
 Li Ming <ming.li@zohomail.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
References: <20241204161457.1113419-1-ming.li@zohomail.com>
 <Z1JO7WUKwTcBVIYA@aschofie-mobl2.lan>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <Z1JO7WUKwTcBVIYA@aschofie-mobl2.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12/5/24 6:10 PM, Alison Schofield wrote:
> On Thu, Dec 05, 2024 at 12:14:56AM +0800, Li Ming wrote:
>> If CONFIG_MEMORY_HOTREMOVE is disabled by kernel, memblocks will not be
>> removed, so 'dax offline-memory all' will output below error logs:
>>
>>   libdaxctl: offline_one_memblock: dax0.0: Failed to offline /sys/devices/system/node/node6/memory371/state: Invalid argument
>>   dax0.0: failed to offline memory: Invalid argument
>>   error offlining memory: Invalid argument
>>   offlined memory for 0 devices
>>
>> The log does not clearly show why the command failed. So checking if the
>> target memblock is removable before offlining it by querying
>> '/sys/devices/system/node/nodeX/memoryY/removable', then output specific
>> logs if the memblock is unremovable, output will be:
>>
>>   libdaxctl: offline_one_memblock: dax0.0: memory371 is unremovable
>>   dax0.0: failed to offline memory: Operation not supported
>>   error offlining memory: Operation not supported
>>   offlined memory for 0 devices
>>
> 
> Hi Ming,
> 
> This led me to catch up on movable and removable in DAX context.
> Not all 'Movable' DAX memory is 'Removable' right?
> 
> Would it be useful to add 'removable' to the daxctl list json:
> 
> # daxctl list
> [
>   {
>     "chardev":"dax0.0",
>     "size":536870912,
>     "target_node":0,
>     "align":2097152,
>     "mode":"system-ram",
>     "online_memblocks":4,
>     "total_memblocks":4,
>     "movable":true
>     "removable":false  <----

Maybe adding some documentation and explaining the two fields? Otherwise it may get confusing.

DJ

>   }
> ]
> 
> You've already added the helper to discover removable.
> 
> Otherwise, LGTM,
> Reviewed-by: Alison Schofield <alison.schofield@intel.com>
> 
> 
>> Besides, delay to set up string 'path' for offlining memblock operation,
>> because string 'path' is stored in 'mem->mem_buf' which is a shared
>> buffer, it will be used in memblock_is_removable().
>>
>> Signed-off-by: Li Ming <ming.li@zohomail.com>
>> ---
>>  daxctl/lib/libdaxctl.c | 52 ++++++++++++++++++++++++++++++++++++------
>>  1 file changed, 45 insertions(+), 7 deletions(-)
>>
>> diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
>> index 9fbefe2e8329..b7fa0de0b73d 100644
>> --- a/daxctl/lib/libdaxctl.c
>> +++ b/daxctl/lib/libdaxctl.c
>> @@ -1310,6 +1310,37 @@ static int memblock_is_online(struct daxctl_memory *mem, char *memblock)
>>  	return 0;
>>  }
>>  
>> +static int memblock_is_removable(struct daxctl_memory *mem, char *memblock)
>> +{
>> +	struct daxctl_dev *dev = daxctl_memory_get_dev(mem);
>> +	const char *devname = daxctl_dev_get_devname(dev);
>> +	struct daxctl_ctx *ctx = daxctl_dev_get_ctx(dev);
>> +	int len = mem->buf_len, rc;
>> +	char buf[SYSFS_ATTR_SIZE];
>> +	char *path = mem->mem_buf;
>> +	const char *node_path;
>> +
>> +	node_path = daxctl_memory_get_node_path(mem);
>> +	if (!node_path)
>> +		return -ENXIO;
>> +
>> +	rc = snprintf(path, len, "%s/%s/removable", node_path, memblock);
>> +	if (rc < 0)
>> +		return -ENOMEM;
>> +
>> +	rc = sysfs_read_attr(ctx, path, buf);
>> +	if (rc) {
>> +		err(ctx, "%s: Failed to read %s: %s\n",
>> +			devname, path, strerror(-rc));
>> +		return rc;
>> +	}
>> +
>> +	if (strtoul(buf, NULL, 0) == 0)
>> +		return -EOPNOTSUPP;
>> +
>> +	return 0;
>> +}
>> +
>>  static int online_one_memblock(struct daxctl_memory *mem, char *memblock,
>>  		enum memory_zones zone, int *status)
>>  {
>> @@ -1362,6 +1393,20 @@ static int offline_one_memblock(struct daxctl_memory *mem, char *memblock)
>>  	char *path = mem->mem_buf;
>>  	const char *node_path;
>>  
>> +	/* if already offline, there is nothing to do */
>> +	rc = memblock_is_online(mem, memblock);
>> +	if (rc < 0)
>> +		return rc;
>> +	if (!rc)
>> +		return 1;
>> +
>> +	rc = memblock_is_removable(mem, memblock);
>> +	if (rc) {
>> +		if (rc == -EOPNOTSUPP)
>> +			err(ctx, "%s: %s is unremovable\n", devname, memblock);
>> +		return rc;
>> +	}
>> +
>>  	node_path = daxctl_memory_get_node_path(mem);
>>  	if (!node_path)
>>  		return -ENXIO;
>> @@ -1370,13 +1415,6 @@ static int offline_one_memblock(struct daxctl_memory *mem, char *memblock)
>>  	if (rc < 0)
>>  		return -ENOMEM;
>>  
>> -	/* if already offline, there is nothing to do */
>> -	rc = memblock_is_online(mem, memblock);
>> -	if (rc < 0)
>> -		return rc;
>> -	if (!rc)
>> -		return 1;
>> -
>>  	rc = sysfs_write_attr_quiet(ctx, path, mode);
>>  	if (rc) {
>>  		/* check if something raced us to offline (unlikely) */
>> -- 
>> 2.34.1
>>
>>
> 

