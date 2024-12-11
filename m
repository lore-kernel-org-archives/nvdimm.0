Received: from sender4-pp-o94.zoho.com (sender4-pp-o94.zoho.com [136.143.188.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938A61C1F06
	for <nvdimm@lists.linux.dev>; Wed, 11 Dec 2024 07:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.94
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733902259; cv=pass; b=pVgsHLXku75EaSt8WPgKPHW3OO51Hsk3C9GGv80H9joFxQ2QLYKZukNWwLydRj3JUraYLZCiwEnveOGybgWuUYyDAlj1B7xhGP9FPcjnxWoMjXwv7Rk5oo9ZT+yLN087+rAa218gAO4VzplE8SUxR8FQZOFOVa0PUvlXyg5ZWE8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733902259; c=relaxed/simple;
	bh=GUPMk4lYiduxM+eyHe7NA4yek6I+hbGGl9YKw3YqnhU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GkrBhkb2vOENx/emdMGC64inD/gz08JNQhV/mOsKxp0ZHjzbe7RT+pGrgujGMpfokY4Cb/AeT5mxBvkDcm7S6vaOfD3zGtoK/Wk7szsS2GRTc+KvKP0pEJIEVCRe5Y1dphKlYT5SrKPHdfkiQ6sGvWWXj2P/GZSBayoDdwNG4Gc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zohomail.com; spf=pass smtp.mailfrom=zohomail.com; dkim=pass (1024-bit key) header.d=zohomail.com header.i=ming.li@zohomail.com header.b=I0uoGegW; arc=pass smtp.client-ip=136.143.188.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zohomail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zohomail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zohomail.com header.i=ming.li@zohomail.com header.b="I0uoGegW"
ARC-Seal: i=1; a=rsa-sha256; t=1733902255; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=SmNEgatPFrW5Zgmlhjz+TdKKKCWHaatCZlMLzXK02O4Wj6j0lQ66wDtBKwOc143PbmA1/8IDE98f9k/x8PA3Tu6JXYCj9TR9E9qi3hdoDm6S9odXqwmbsowGVlu/KP/+RA2nsE6OmhHzRC53X/poedFzgAjxYWjNZXmAXojvxkQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1733902255; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=e3VgLWgHelt0hGZEqrdW8n3JSJczgRnh9f4Z/ppWzb8=; 
	b=krk4u3Ypka/m/odiOVpbAyXe0mjSNMT6iy41020L9K+ttxu1LE+HUIGxi0KLl9XHZFI8hlUTjkEe1R6pzJgLEDh8H27F35Sa2Wlh6O1kuHOHvtQlgsmToRqzZH0q/WjxvxGC3uF9cGJwfcQSm6GHNZrWoYkxJBpP42oUrhqb1FI=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=zohomail.com;
	spf=pass  smtp.mailfrom=ming.li@zohomail.com;
	dmarc=pass header.from=<ming.li@zohomail.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1733902255;
	s=zm2022; d=zohomail.com; i=ming.li@zohomail.com;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Feedback-ID:Message-Id:Reply-To;
	bh=e3VgLWgHelt0hGZEqrdW8n3JSJczgRnh9f4Z/ppWzb8=;
	b=I0uoGegWOcVTJxmnZ3iDj1t2tI+2j3yo/LfKov8HaiqLI+gtJp5QKqI16GsTrmaX
	n57QaM77nVXT8uN/jkCqVo99ww9y+SSmRldWOMMDEXgVZwyAOLxLiw8j0EGW15jaQ2V
	mZ7oHS5Z6QUXIggeB0tWpmlbgXAS+xWd2+qBSerw=
Received: by mx.zohomail.com with SMTPS id 1733902253083255.86015563984415;
	Tue, 10 Dec 2024 23:30:53 -0800 (PST)
Message-ID: <22f74b5c-e781-4f82-8205-c1349095cd3a@zohomail.com>
Date: Wed, 11 Dec 2024 15:30:50 +0800
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
Content-Transfer-Encoding: 7bit
Feedback-ID: rr08011227dfbd7ab84a44d01a798b286200000a01be87ebf2a357c2a336777f8948b6d9938c9e9432217eb6:zu08011227ddb9e65d947d78b53e20ad2f0000c3b5e82edfc1f0414f8909ee65b52034b26e54cf55bbdc598b:rf080112260564dec55c858332151065490000242a7a8d1d9d4f5642e0f6b7b9493fc879bb9556c6a6321e:ZohoMail
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

Hi Alison,

After investigation, if there is no "movable" in dax list json, that means the kernel does not support MEMORY_HOTREMOVE.

if there is a "movable" in dax list json, that means the kernel supports MEMORY_HOTREMOVE and the value of "movable" decides if memblocks can be offlined. So user cannot offline the memblocks if "movable" is false and "removable" is true.

Feels like the "removable" field does not make much sense in kernel supporting MEMORY_HOTREMOVE case. user can use "movable" to check if memblocks can be offlined. do you think if it is still worth adding a "removable" in daxctl list json?


Thanks

Ming

