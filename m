Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7669277013
	for <nvdimm@lists.linux.dev>; Mon,  7 Jul 2025 06:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751869494; cv=none; b=FScmaIibV9QIsgCpoAcSv4ARwzLba7D4+VVKFLsAU4xmXd5qObk2SS2wf45tMbo0U9zIroZb6TvhWs1HLVVaPfHUJBOzINIXq0yweMaHH0fDuGYq89ry0vDOkpEX82tPgDlCMR6F0VagAwWuvR0W9aRnF2AutP8cSn1fA8wY23k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751869494; c=relaxed/simple;
	bh=L9MOZhKG6b8EYegJSPVDZQYaJGvT/up6iHdbhWzRvSs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UeLD4YZQFNEOuoZvfxXM0cbXnrxVIyt+lpNZl9oW+w5kKmJujQqGdkvhyfrTroKKitB3IUfqrZ/ZAH7MWWRKNqOIMJRCmknnUONpDsVZdryXTRX8iijVU9YJAPapJxz5PdXG5JzPGZFWIIIcbEoq2+V6Tx8JTEx1Yc4noIN/XNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=R7VbQ8k2; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="R7VbQ8k2"
Message-ID: <6134aafc-d91d-46d8-ac6d-ef10ef459929@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751869491;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mCKKvbNBmu93XBKYP00Xkr5d+vwBwYFx9i2TAoKmHLs=;
	b=R7VbQ8k22nVEIPnOosPpVwWQ80dsUvoJsouKmHewWIR5bPrZkGJYRtHgdUJ9gEwilq0sNo
	xBMHfEtHwtf3K5Mw7oDPFeGRzjjiaRN4KLW4EXxtP7nf4q7mjFnm5IHg4XhTMglcnAJUHU
	f4k/kJnzE4Vku2Q1n1uWmBXt8WLLXY0=
Date: Mon, 7 Jul 2025 14:24:42 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH v1 04/11] dm-pcache: add segment layer
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: mpatocka@redhat.com, agk@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
 hch@lst.de, dan.j.williams@intel.com, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, dm-devel@lists.linux.dev
References: <20250624073359.2041340-1-dongsheng.yang@linux.dev>
 <20250624073359.2041340-5-dongsheng.yang@linux.dev>
 <20250701154659.000067f9@huawei.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Dongsheng Yang <dongsheng.yang@linux.dev>
In-Reply-To: <20250701154659.000067f9@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


在 7/1/2025 10:46 PM, Jonathan Cameron 写道:
> On Tue, 24 Jun 2025 07:33:51 +0000
> Dongsheng Yang <dongsheng.yang@linux.dev> wrote:
>
>> Introduce segment.{c,h}, an internal abstraction that encapsulates
>> everything related to a single pcache *segment* (the fixed-size
>> allocation unit stored on the cache-device).
>>
>> * On-disk metadata (`struct pcache_segment_info`)
>>    - Embedded `struct pcache_meta_header` for CRC/sequence handling.
>>    - `flags` field encodes a “has-next” bit and a 4-bit *type* class
>>      (`CACHE_DATA` added as the first type).
>>
>> * Initialisation
>>    - `pcache_segment_init()` populates the in-memory
>>      `struct pcache_segment` from a given segment id, data offset and
>>      metadata pointer, computing the usable `data_size` and virtual
>>      address within the DAX mapping.
>>
>> * IO helpers
>>    - `segment_copy_to_bio()` / `segment_copy_from_bio()` move data
>>      between pmem and a bio, using `_copy_mc_to_iter()` and
>>      `_copy_from_iter_flushcache()` to tolerate hw memory errors and
>>      ensure durability.
>>    - `segment_pos_advance()` advances an internal offset while staying
>>      inside the segment’s data area.
>>
>> These helpers allow upper layers (cache key management, write-back
>> logic, GC, etc.) to treat a segment as a contiguous byte array without
>> knowing about DAX mappings or persistence details.
>>
>> Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
> Hi
>
> Just one trivial comment.
>
>> diff --git a/drivers/md/dm-pcache/segment.h b/drivers/md/dm-pcache/segment.h
>> new file mode 100644
>> index 000000000000..9675951ffaf8
>> --- /dev/null
>> +++ b/drivers/md/dm-pcache/segment.h
>> @@ -0,0 +1,73 @@
>> +/* SPDX-License-Identifier: GPL-2.0-or-later */
>> +#ifndef _PCACHE_SEGMENT_H
>> +#define _PCACHE_SEGMENT_H
>> +
>> +#include <linux/bio.h>
>> +
>> +#include "pcache_internal.h"
>> +
>> +struct pcache_segment_info {
>> +	struct pcache_meta_header	header;	/* Metadata header for the segment */
> The comment is fairly obvious given the type of the field. I'd drop the comment.

Hi Jonathan,

Sounds not bad, will change it.

Thanx

>
>> +	__u32			flags;
>> +	__u32			next_seg;
>> +};
>
