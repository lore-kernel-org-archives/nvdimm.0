Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.168
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792727204;
	b=Z/4tfls3r0EA0y6rEsQLhfXoo201lVL+I5RUX0kx/ViVagOcBXVxPdToQvdUwHchh98+
	 bvbp5i/kGsg7cvV/ViWZ48NffN9fni4sSEFtug3Xursil7/uvg6b/qUejLR3cDe+TLD3s
	 IqLG7qRQIVA4iaBHFsuJhsYb8lru3JcVzH07MUEwr59zte94zHi9AFzX6SqXsQPrb6rJ0
	 dpwCQ4YhBhT3fzEYFCv6k+BscTR9cntRhFCiDeCLxLBTmqg48zRztuMvVbuyz1meDT0Pg
	 29TGQjpQIZ9VICEmf24tFSCprVtNjW97H2W2x/VMX5fzgb5lmuDc5CdxRtqArKR5vug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792727204;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=ttIYp9SKvrIeTjMeme1a7v/1DuKF5crN8WKfQ1/zVqQ=;
	b=TO938r7MKOQRKnaGp35LRtnlZ0mUd7wzvm5m4dNg0jJitrTePX/7CbBhgTl493IolbtZ
	 DrRHPuzC0hEiYeqmXfIx+L3lXNtvS2IOJSTrN/uzU6A+n16BXOn6moAlBxeRyBiaGWOA3
	 ERLjT3tvC849ibZs5ve+Khpsdp5n02B1D7AliKnVhfI5jK74usNKtXLfBFhLYJy570TDn
	 wx8Pg+ZWhykOlM0UCqawL+HNY7ejoD7eesI1E2HaLGHEdT7f8Oe4EYbPALXd9VMrDM0Ux
	 XEim3tzog5/7Sgixi8Zkh7VLqaGxLfvVZaJ1fUPkT+RS01Kqv3aZDcp73JpKk3eUxGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=V9SxOFsb;
	arc=none smtp.remote-ip=95.215.58.168
Received: from mta1.migadu.com (out-168.mta1.migadu.com [95.215.58.168])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192F2606A319
	for <nvdimm@lists.linux.dev>; Fri, 23 Oct 2026 03:46:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 192F2606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=V9SxOFsb
X-Envelope-To: nvdimm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=Hm72Xfl6pvbKv+hg7yoR4S7LNRVKFxz7eQHzNV7biQo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792727201; v=1; x=1793332001;
 b=V9SxOFsbi2u9Uu+fiTkvQf06afGaagMarU08jGszLxPu/I6Na+u6nAq40izPufIN91vd04Dw
 IFzE0t9wZSNARZlpsgISwjRMup02OGVKwqkBP/JkA+CYQ8gjn6ts7vwq/9CNsbcG4MPSrShDpns
 II31xlaPTyn+qGAfS/TnnPc0=
X-Envelope-To: nvdimm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id c34def1092b89765;
	Fri, 23 Oct 2026 03:46:41 +0000
X-Mizu-Trace-ID: c34def1092b89765
X-Migadu-Flow: FLOW_OUT
Message-ID: <a3601418-7fac-4f8e-82b1-3aa9e731c822@linux.dev>
Date: Fri, 23 Oct 2026 11:46:36 +0800
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] dax/bus: fix Device DAX range alignment validation
To: Alison Schofield <alison.schofield@intel.com>,
 Muchun Song <songmuchun@bytedance.com>
Cc: Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
 Dave Jiang <dave.jiang@intel.com>, Andrew Morton
 <akpm@linux-foundation.org>, Joao Martins <joao.m.martins@oracle.com>,
 nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261016053944.2579541-1-songmuchun@bytedance.com>
 <atqk4GgaII0KQQnW@aschofie-mobl2.lan>
Content-Language: en-US
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <atqk4GgaII0KQQnW@aschofie-mobl2.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/10/23 08:05, Alison Schofield wrote:
> On Fri, Oct 16, 2026 at 01:39:44PM +0800, Muchun Song wrote:
>> Only range sizes are currently validated against dev_dax->align. A
>> dynamic device can therefore select a large-page alignment and allocate a
>> range whose start is not naturally aligned. The device binds successfully,
>> but a later write to a userspace mapping may trigger a kernel panic.
>>
>> The automatic resize path can also split a size-aligned request across
>> arbitrary free gaps. When devices with different alignments fragment a
>> region, this can extend a range by less than the device alignment. A later
>> allocation then fails, leaving the failed resize partially applied.
>>
>> Initialize the device alignment before its first allocation. Validate both
>> the start and size of allocated and adjusted ranges, account only for
>> aligned free space before changing ranges, skip unusable gaps, and
>> serialize size validation with alignment updates.
>>
>> Static Device DAX already has a pre-populated pgmap whose full range was
>> validated against memremap_compat_align(). Its usable data range may begin
>> after namespace metadata, so require only dev_dax->align for static
>> devices. Dynamic Device DAX builds its pgmap from the allocated ranges and
>> must continue to satisfy both alignments.
> Hi Muchun,

Hi,

>
> One commit message comment:
>
> Now that this is a standalone patch, some useful context from the original
> cover letter would be useful in this commit message.

OK, I'll add those info to commit message.

>
> The cover letter explained that Sashiko identified a path where
> `memmap_init_zone_device()` could initialize struct pages with a large-page
> order for a physical range that wasn't naturally aligned. You also mentioned
> that you reproduced the resulting kernel panic.
>
> That gives us both the failure mechanism and confirmation that this is a
> reproduced bug, rather than just a potential problem. Those details are worth
> keeping in the commit message.
>
> So I happened to hit this and the mapping_store() issue that was in the
> original patch 1/2. Both these fixes solved my problems.
>
> Below I do have some style and simplification feedback, and am also wondering
> about the gap handling logic.
>
>
>> Fixes: 6d82120f4156 ("device-dax: add an 'align' attribute")
>> Assisted-by: LLM
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>> v4:
>> - Use dev_dax->align alone for static Device DAX ranges to preserve
>>    older 4K namespaces (reported by Alison Schofield)
>> - Condense the commit message to the failure scenarios and required fixes
>>    (suggested by Alison Schofield)
>>
>> v3:
>> - Serialize size alignment validation with alignment updates to avoid a
>>    partial shrink after a concurrent alignment change (reported by Sashiko)
>> - Document the size validation serialization in the commit message
>>
>> v2:
>> - Keep the alloc_is_aligned() name to avoid unrelated helper renaming
>>    (suggested by Dave Jiang)
>> - Move this patch after the mapping error reporting fix for independent
>>    backports (suggested by Dave Jiang)
>> ---
>>   drivers/dax/bus.c | 152 +++++++++++++++++++++++++++++++++++-----------
>>   1 file changed, 117 insertions(+), 35 deletions(-)
>>
>> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
>> index b809e1a264af..b2c83a0e4ec5 100644
>> --- a/drivers/dax/bus.c
>> +++ b/drivers/dax/bus.c
>> @@ -848,6 +848,52 @@ static int devm_register_dax_mapping(struct dev_dax *dev_dax, int range_id)
>>   	return 0;
>>   }
>>   
>> +static inline unsigned long dev_dax_min_align(struct dev_dax *dev_dax)
> Why the static inline here and also why below do you change
> alloc_is_aligned() to static inline?

I thought it is a one-line code, inline is better, I usually do
this in MM area.

>
> coding-style.rst is against it in .c files and we don't do it in any
> other drivers/dax/*.c code.

Seems it is not a convention in DAX. I am not an expert in DAX.

>
>> +{
>> +	/*
>> +	 * A static device has a pre-populated pgmap whose range already
>> +	 * satisfies memremap_compat_align(). Its data range may start after
>> +	 * metadata at dev_dax->align granularity.
>> +	 */
>> +	if (static_dev_dax(dev_dax))
>> +		return dev_dax->align;
>> +
>> +	/*
>> +	 * The minimum mapping granularity for a dynamic device instance is a
>> +	 * single subsection, unless the arch says otherwise.
>> +	 */
>> +	return max_t(unsigned long, dev_dax->align, memremap_compat_align());
>> +}
>> +
>> +static inline bool alloc_is_aligned(struct dev_dax *dev_dax, resource_size_t size)
>> +{
>> +	return IS_ALIGNED(size, dev_dax_min_align(dev_dax));
>> +}
>> +
>> +static inline bool range_is_aligned(struct dev_dax *dev_dax, u64 start,
>> +				    resource_size_t size)
>> +{
>> +	return IS_ALIGNED(start | size, dev_dax_min_align(dev_dax));
>> +}
>> +
>> +static resource_size_t
>> +aligned_gap_size(struct dev_dax *dev_dax, resource_size_t *start,
>> +		 resource_size_t end)
>
> Please keep the return type on the same line as the function name, like
> rest of this file.
>
> Also a function comment like:
> /* Return usable aligned gap size and update *aligned_start */
>
> and a rename of *start to *aligned_start would make the contract clearer.

Will do.

>
>
>> +{
>> +	resource_size_t aligned_start = ALIGN(*start, dev_dax_min_align(dev_dax));
>> +	resource_size_t size;
>
> How about calculating dev_dax_min_align() once and keep it in a local variable?
> We use the same value again for ALIGN_DOWN().

Make sense.

>
>
>> +
>> +	if (aligned_start < *start || aligned_start > end)
>> +		return 0;
>> +
>> +	size = ALIGN_DOWN(end - aligned_start + 1, dev_dax_min_align(dev_dax));
>> +	if (!size)
>> +		return 0;
> The above early return looks needless given how callers use the result

Oh, yes.

>> +
>> +	*start = aligned_start;
>> +	return size;
>> +}
>> +
> snip
>
>>   
>> +static resource_size_t
>> +dax_region_aligned_avail_size(struct dax_region *dax_region,
>> +			      struct dev_dax *dev_dax)
> Same as previous, keep return type on the same line here.
>
> The dax_region argument looks needless as we can get it from
> dev-dax->region.

Right. My oversight.

>
>
> snip
>
>
>> @@ -1062,37 +1130,51 @@ static ssize_t dev_dax_resize(struct dax_region *dax_region,
>>   	 */
>>   retry:
>>   	first = region_res->child;
>> -	if (!first)
>> -		return alloc_dev_dax_range(dev_dax, dax_region->res.start, to_alloc);
>> +	if (!first) {
>> +		resource_size_t start = region_res->start;
>> +
>> +		alloc = aligned_gap_size(dev_dax, &start, region_res->end);
>> +		return alloc_dev_dax_range(dev_dax, start, min(alloc, to_alloc));
>> +	}
>>   
>>   	rc = -ENOSPC;
>>   	for (res = first; res; res = res->sibling) {
>>   		struct resource *next = res->sibling;
>> +		resource_size_t start, end;
>>   
>>   		/* space at the beginning of the region */
>>   		if (res == first && res->start > dax_region->res.start) {
>> -			alloc = min(res->start - dax_region->res.start, to_alloc);
>> -			rc = alloc_dev_dax_range(dev_dax, dax_region->res.start, alloc);
>> -			break;
>> +			start = dax_region->res.start;
>> +			end = res->start - 1;
>> +			alloc = min(aligned_gap_size(dev_dax, &start, end), to_alloc);
>> +			if (alloc) {
>> +				rc = alloc_dev_dax_range(dev_dax, start, alloc);
>> +				break;
>> +			}
>>   		}
>>   
>> -		alloc = 0;
>>   		/* space between allocations */
>> -		if (next && next->start > res->end + 1)
>> -			alloc = min(next->start - (res->end + 1), to_alloc);
>> -
>> -		/* space at the end of the region */
>> -		if (!alloc && !next && res->end < region_res->end)
>> -			alloc = min(region_res->end - res->end, to_alloc);
>> +		if (next) {
>> +			if (next->start <= res->end + 1)
>> +				continue;
>> +			end = next->start - 1;
>> +		} else {
>> +			/* space at the end of the region */
>> +			if (res->end >= region_res->end)
>> +				continue;
>> +			end = region_res->end;
>> +		}
>>   
>> +		start = res->end + 1;
>> +		alloc = min(aligned_gap_size(dev_dax, &start, end), to_alloc);
> We're walking the free gaps twice now. Once in dax_region_aligned_avail_size()
> and again here. It seems the 2 walks need to agree about which gaps
> are usable so that the pre check doesn't succeed and then the allocation
> loop cannot satify the request...which would get us right back to a
> partially applied resize.
>
> Please look at sharing the gap traversal.

Good point. I will factor the gap traversal into a common iterator used
by both the pre-check and the allocation path, so they share the same
gap selection rules. I will include this in the next revision.

Thanks for your review.

Thanks,
Muchun

>
> -- Alison
>
> snip

