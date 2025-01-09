Received: from sender4-pp-o94.zoho.com (sender4-pp-o94.zoho.com [136.143.188.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7DC539AEB
	for <nvdimm@lists.linux.dev>; Thu,  9 Jan 2025 00:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.94
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736384317; cv=pass; b=c4PmSxRKsH163RJMuFUJcwGCvCwsg9WhvX6iScRHuiQqsnQ69RQPin7D6cs9hYRCUzsmkzn7tNL4yy7aKDMEaDGv2CDZsMfxPNM4MJFgDDo7c8upAuuL6QPRVpu7M0GvDlHR0g+gwCKl97JW0aiVglQ23D7NmM0iqYPKdiLaheg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736384317; c=relaxed/simple;
	bh=/TYQCMuhNpNmY7Jmn2Dyw3suiRRM6Y3wjkq4jDSdBkc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Kf5h50epzDf6b9rBSdrCD0BBKfls7e0d8HZPGLW47cX4LnfEfe5f2HB1+50HifbkszonbKjbXYIWQ4+z4jvYQ0V+REk6W9c0CU3G4EjuNTTnrX10ajjn2q+j0VsSzpAwl/TNfaJc77KEcIO4mrKE2UvvyyP/TVQmlIDuH17h7Z0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zohomail.com; spf=pass smtp.mailfrom=zohomail.com; dkim=pass (1024-bit key) header.d=zohomail.com header.i=ming.li@zohomail.com header.b=cyDMUeNv; arc=pass smtp.client-ip=136.143.188.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zohomail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zohomail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zohomail.com header.i=ming.li@zohomail.com header.b="cyDMUeNv"
ARC-Seal: i=1; a=rsa-sha256; t=1736384313; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=j7Yy0s9IlG+Nfl/4hYpfRrOp6KKALz8Z45VLN2PQuFXzwNbiJPV7EiY0rAOlue0vx9vRmxQtw5q7KwxG9XHQHr7pV8xTOz2717hZGgm+d5EYQr/fU2asK6BVxsp52p8WeO8llIGYmftmU9zxDAESsULUiTc6g4VWMWZB0Yr0yUI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1736384313; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=aKa6rQqaPFvNMh/MgURifh8UHjcbzUazkpWIkxmu57s=; 
	b=SE6DoXhm/1S94mHDBMsVs7aR8bJZcifSxntmoih1RJqLJZjk8aYL+oEYaptL6xSB7N3hKcatmmHBfKm0N8an5WTvkhN8F3pVijylFN1Uqo+YAj+rMvo5cw2ac0Drbw63B/eft1j3sPoH2AZCtmsUG/vM5YR/5bTrtS/QP5sYwys=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=zohomail.com;
	spf=pass  smtp.mailfrom=ming.li@zohomail.com;
	dmarc=pass header.from=<ming.li@zohomail.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1736384313;
	s=zm2022; d=zohomail.com; i=ming.li@zohomail.com;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Feedback-ID:Message-Id:Reply-To;
	bh=aKa6rQqaPFvNMh/MgURifh8UHjcbzUazkpWIkxmu57s=;
	b=cyDMUeNvCWdjdd03BQYV1NAOkLPn3+4Ujf5nS/llA+yRnJR5+Fsxofm65QUzQ5x8
	eDwRC1r+cfpDAoR4zP61uz7+AdVODP4dxU0zdkSRO6RE02BXDPYbc4oCG4EwtdDIoUf
	j3ZMVlMuefvzcMlyCOr2cPtBx6dD6rbmwhfHDCMY=
Received: by mx.zohomail.com with SMTPS id 1736384312518991.4523598795774;
	Wed, 8 Jan 2025 16:58:32 -0800 (PST)
Message-ID: <0ced507d-1b07-43ac-9cc3-28e651e2aa26@zohomail.com>
Date: Thu, 9 Jan 2025 08:58:30 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH 1/1] daxctl: Output more information if memblock is
 unremovable
To: Dave Jiang <dave.jiang@intel.com>,
 Alison Schofield <alison.schofield@intel.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
References: <20241204161457.1113419-1-ming.li@zohomail.com>
 <Z1JO7WUKwTcBVIYA@aschofie-mobl2.lan>
 <742c568a-1f78-4325-9521-852900098903@intel.com>
From: Li Ming <ming.li@zohomail.com>
In-Reply-To: <742c568a-1f78-4325-9521-852900098903@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Feedback-ID: rr080112279b846af5a15d3e859284fb2100004d85c93998fb0829bc59b063bbb74911938cfc5a7e0a6b1cb9:zu08011227a4782e5a22df2e2f27fe4ecf0000301166e91159a02b1de19df415eb91080e66908ce5e5fa9fd6:rf0801122dce3f082b1079d6d627155ac90000d3a215002ae126538011bbfe076412e36b452c448576490b14911036a091cd:ZohoMail
X-ZohoMailClient: External

On 1/9/2025 12:46 AM, Dave Jiang wrote:
>
> On 12/5/24 6:10 PM, Alison Schofield wrote:
>> On Thu, Dec 05, 2024 at 12:14:56AM +0800, Li Ming wrote:
>>> If CONFIG_MEMORY_HOTREMOVE is disabled by kernel, memblocks will not be
>>> removed, so 'dax offline-memory all' will output below error logs:
>>>
>>>   libdaxctl: offline_one_memblock: dax0.0: Failed to offline /sys/devices/system/node/node6/memory371/state: Invalid argument
>>>   dax0.0: failed to offline memory: Invalid argument
>>>   error offlining memory: Invalid argument
>>>   offlined memory for 0 devices
>>>
>>> The log does not clearly show why the command failed. So checking if the
>>> target memblock is removable before offlining it by querying
>>> '/sys/devices/system/node/nodeX/memoryY/removable', then output specific
>>> logs if the memblock is unremovable, output will be:
>>>
>>>   libdaxctl: offline_one_memblock: dax0.0: memory371 is unremovable
>>>   dax0.0: failed to offline memory: Operation not supported
>>>   error offlining memory: Operation not supported
>>>   offlined memory for 0 devices
>>>
>> Hi Ming,
>>
>> This led me to catch up on movable and removable in DAX context.
>> Not all 'Movable' DAX memory is 'Removable' right?
>>
>> Would it be useful to add 'removable' to the daxctl list json:
>>
>> # daxctl list
>> [
>>   {
>>     "chardev":"dax0.0",
>>     "size":536870912,
>>     "target_node":0,
>>     "align":2097152,
>>     "mode":"system-ram",
>>     "online_memblocks":4,
>>     "total_memblocks":4,
>>     "movable":true
>>     "removable":false  <----
> Maybe adding some documentation and explaining the two fields? Otherwise it may get confusing.
>
> DJ

Hi Dave,


Thanks for your review, As my latest comment,

if no "movable" in daxctl list, that means the kernel not supported MEMORY_HOTREMOVE, the meanning is the same as "removable: false".

if a "movable" in daxctl list, that means the kernel supporting MEMORY_HOTREMOVE, and the value of "movable" decides whether the memory block can be removed.

My feeling is that "movable" is enough, may I know if it still is worth to add a new "removable"?


Ming


>
>>   }
>> ]
>>
>> You've already added the helper to discover removable.
>>
>> Otherwise, LGTM,
>> Reviewed-by: Alison Schofield <alison.schofield@intel.com>
>>
>>
>>> Besides, delay to set up string 'path' for offlining memblock operation,
>>> because string 'path' is stored in 'mem->mem_buf' which is a shared
>>> buffer, it will be used in memblock_is_removable().
>>>
>>> Signed-off-by: Li Ming <ming.li@zohomail.com>
>>> ---
>>>  daxctl/lib/libdaxctl.c | 52 ++++++++++++++++++++++++++++++++++++------
>>>  1 file changed, 45 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
>>> index 9fbefe2e8329..b7fa0de0b73d 100644
>>> --- a/daxctl/lib/libdaxctl.c
>>> +++ b/daxctl/lib/libdaxctl.c
>>> @@ -1310,6 +1310,37 @@ static int memblock_is_online(struct daxctl_memory *mem, char *memblock)
>>>  	return 0;
>>>  }
>>>  
>>> +static int memblock_is_removable(struct daxctl_memory *mem, char *memblock)
>>> +{
>>> +	struct daxctl_dev *dev = daxctl_memory_get_dev(mem);
>>> +	const char *devname = daxctl_dev_get_devname(dev);
>>> +	struct daxctl_ctx *ctx = daxctl_dev_get_ctx(dev);
>>> +	int len = mem->buf_len, rc;
>>> +	char buf[SYSFS_ATTR_SIZE];
>>> +	char *path = mem->mem_buf;
>>> +	const char *node_path;
>>> +
>>> +	node_path = daxctl_memory_get_node_path(mem);
>>> +	if (!node_path)
>>> +		return -ENXIO;
>>> +
>>> +	rc = snprintf(path, len, "%s/%s/removable", node_path, memblock);
>>> +	if (rc < 0)
>>> +		return -ENOMEM;
>>> +
>>> +	rc = sysfs_read_attr(ctx, path, buf);
>>> +	if (rc) {
>>> +		err(ctx, "%s: Failed to read %s: %s\n",
>>> +			devname, path, strerror(-rc));
>>> +		return rc;
>>> +	}
>>> +
>>> +	if (strtoul(buf, NULL, 0) == 0)
>>> +		return -EOPNOTSUPP;
>>> +
>>> +	return 0;
>>> +}
>>> +
>>>  static int online_one_memblock(struct daxctl_memory *mem, char *memblock,
>>>  		enum memory_zones zone, int *status)
>>>  {
>>> @@ -1362,6 +1393,20 @@ static int offline_one_memblock(struct daxctl_memory *mem, char *memblock)
>>>  	char *path = mem->mem_buf;
>>>  	const char *node_path;
>>>  
>>> +	/* if already offline, there is nothing to do */
>>> +	rc = memblock_is_online(mem, memblock);
>>> +	if (rc < 0)
>>> +		return rc;
>>> +	if (!rc)
>>> +		return 1;
>>> +
>>> +	rc = memblock_is_removable(mem, memblock);
>>> +	if (rc) {
>>> +		if (rc == -EOPNOTSUPP)
>>> +			err(ctx, "%s: %s is unremovable\n", devname, memblock);
>>> +		return rc;
>>> +	}
>>> +
>>>  	node_path = daxctl_memory_get_node_path(mem);
>>>  	if (!node_path)
>>>  		return -ENXIO;
>>> @@ -1370,13 +1415,6 @@ static int offline_one_memblock(struct daxctl_memory *mem, char *memblock)
>>>  	if (rc < 0)
>>>  		return -ENOMEM;
>>>  
>>> -	/* if already offline, there is nothing to do */
>>> -	rc = memblock_is_online(mem, memblock);
>>> -	if (rc < 0)
>>> -		return rc;
>>> -	if (!rc)
>>> -		return 1;
>>> -
>>>  	rc = sysfs_write_attr_quiet(ctx, path, mode);
>>>  	if (rc) {
>>>  		/* check if something raced us to offline (unlikely) */
>>> -- 
>>> 2.34.1
>>>
>>>

