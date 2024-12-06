Received: from sender4-pp-o94.zoho.com (sender4-pp-o94.zoho.com [136.143.188.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3397BE46
	for <nvdimm@lists.linux.dev>; Fri,  6 Dec 2024 07:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.94
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733468773; cv=pass; b=OhUa5I4ymXufgE3ZJ8rXxkwzSnnI5dM1ZzovOW0fzhWsZQJ7PaDU9ZJoGljhaAdumCrJML5WYewzvwdiJMnZzo8ZDIIBpuacVY1WBB9ffy/K9+0W/biylKUJyMuSolp2ZouSXLYFjXb00cWmbmNFGy7JXzyw28+ZN4sZCYVX3k0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733468773; c=relaxed/simple;
	bh=EgyuMN0JMqxOkgSlQr2K47B1XHD5rXpffqThCsm3cw8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qer5LXKDinPcoGoIszhXx/p3b3p7K+4eZKfYmQHWnMzwDVjJYH/EsIoja1iSsRvnBW8DCi7Z/MNnrrBKyGjLoNAYTkqnP2ONr+bvwMxPPoMK2w8v0sAhjhJ0rODekMwA/T9C+zl+m8NzO4sf/4VG9Gvv805bQ2U6PByGbCcjmbg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zohomail.com; spf=pass smtp.mailfrom=zohomail.com; dkim=pass (1024-bit key) header.d=zohomail.com header.i=ming.li@zohomail.com header.b=VB53qvGi; arc=pass smtp.client-ip=136.143.188.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zohomail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zohomail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zohomail.com header.i=ming.li@zohomail.com header.b="VB53qvGi"
ARC-Seal: i=1; a=rsa-sha256; t=1733468770; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=kQsDf8ZYV+o3rcl2C4nvB1/InOT6ER6jBau+GJGDvtQ62KXbo5dm6+duQKtphkqbcnxLxQRcxnq7BPHHlcWWAbq2Mr1FO9D+L/uTKH8P/RN6uPJIh/6dJhFPAyAP3ckmdKne1JZFRyuOTbJlYuzlOlbLeDhGQqKgN/76JKJ7EbE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1733468770; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=cU1dRQ2npBrJhAAxBJnesrSNYbvapYa2xf4HtQKvKrE=; 
	b=gLAiFKOa3cspGP1KkbEsVTLm9hMb/AJfwsryej56CiYvFlbXwr+4ZDZ7h8CJ54gcy8arVmqkaG4W4RITxlpqagcpVF8aTi0HgUOaHOA7SD30DpXktZ3dprU2rWHqwqW/r0+UKjytI8dZHaYxhBr5/GrnZNk6zkbat6yAUzVA2Mg=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=zohomail.com;
	spf=pass  smtp.mailfrom=ming.li@zohomail.com;
	dmarc=pass header.from=<ming.li@zohomail.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1733468770;
	s=zm2022; d=zohomail.com; i=ming.li@zohomail.com;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Feedback-ID:Message-Id:Reply-To;
	bh=cU1dRQ2npBrJhAAxBJnesrSNYbvapYa2xf4HtQKvKrE=;
	b=VB53qvGiAgnb2brEdiJBb2L4JP/jiLhE2go064OOaze8GYRIwSzwyE2kYtNqCqeH
	f7ldhYSb3SteEFZMPlixpVWNJzJd+gdL74dbIzboopLFA1MKtKqD7ikQ1JCCXxqUXc8
	ovXcj8BgFWGvqQdWXEcnJ2AzJnVcXjlyBrA7cUpM=
Received: by mx.zohomail.com with SMTPS id 1733468768142589.5010478681276;
	Thu, 5 Dec 2024 23:06:08 -0800 (PST)
Message-ID: <7a3f0b80-dc2d-4a84-9117-80055ef6b972@zohomail.com>
Date: Fri, 6 Dec 2024 15:06:06 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH 1/1] daxctl: Output more information if memblock is
 unremovable
To: Alison Schofield <alison.schofield@intel.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
References: <20241204161457.1113419-1-ming.li@zohomail.com>
 <Z1JO7WUKwTcBVIYA@aschofie-mobl2.lan>
From: Li Ming <ming.li@zohomail.com>
In-Reply-To: <Z1JO7WUKwTcBVIYA@aschofie-mobl2.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Feedback-ID: rr08011227482c3feaa51be2e34b40a610000075f6d2720e8168bffb76e60494afbc2d70f3d1575fe7c562b5:zu08011227cba7652ff0279364edacb9920000cc8d05b5f459a482305fc9a886a2c6059689551cb92f0e53c3:rf08011226429233ea65342d71d5eabd380000d7d973fbdf7627510d23a0d930d80cf8da1e1100c5a338dc:ZohoMail
X-ZohoMailClient: External


On 12/6/2024 9:10 AM, Alison Schofield wrote:
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
> Hi Ming,
>
> This led me to catch up on movable and removable in DAX context.
> Not all 'Movable' DAX memory is 'Removable' right?

Hi Alison,


After investigation, I noticed if memblock is unremovable, will not have "movable" field in the output of "daxctl list" because memblock can be only attached as ZONE_NORMAL.

If memblock is removable, "movable" will be showed up by "daxctl list", because memblock can be attached as ZONE_NORMAL or ZONE_MOVABLE. 

So seems like "movable" field in daxctl list implying that the dax device is removable or not. if there is a "movable" field in the output of "daxctl list", that means the DAX device is removable.

But I think it is a hint, user cannot know such details, adding a "removable" field in daxctl list json is worth as you mentioned.


Thanks

Ming

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
