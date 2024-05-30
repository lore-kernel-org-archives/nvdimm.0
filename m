Received: from mail-m92253.xmail.ntesmail.com (mail-m92253.xmail.ntesmail.com [103.126.92.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D5E17C9E6
	for <nvdimm@lists.linux.dev>; Thu, 30 May 2024 12:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.126.92.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717073962; cv=none; b=kFXu+apn5+zSvN5hhfxAzQU6zROxZwsVMgWqzh0fqdz5MTmf5MWvZEqAVtF/9zo+ScZ/3q3Ry4jYvzURRwlVN0aonOSZu+n1655ZECRNUt1ajQY47BIceyRsskubLNvzzPJg5dpQHtQmQPQHo7Exkp06CJCP6yDThisxLmVY6Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717073962; c=relaxed/simple;
	bh=P2bO5JWCsGZMtS8zS4ZP9PbUQbMPfPvnLfoGhj5y2VA=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=ReDM/iYBWRX250VBpyslXaKzpBatQVdi955rOSJRShX5zAZCE8FuwRfdb/qc65xH4vZnjzmRFr0jXzpPFgnp+dcaaNvFrSkE2kEuAfvikLuVsySADKsxP+KcJREELmZ/pchgit5SXhw/wNLllegJLPkY3PNJWVGXj2Imi7NMyJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=easystack.cn; spf=pass smtp.mailfrom=easystack.cn; arc=none smtp.client-ip=103.126.92.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=easystack.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=easystack.cn
Received: from [192.168.122.189] (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTPA id 3882D860313;
	Thu, 30 May 2024 14:59:39 +0800 (CST)
Subject: Re: [PATCH RFC 0/7] block: Introduce CBD (CXL Block Device)
To: Gregory Price <gregory.price@memverge.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>, John Groves
 <John@groves.net>, axboe@kernel.dk, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev
References: <20240503105245.00003676@Huawei.com>
 <5b7f3700-aeee-15af-59a7-8e271a89c850@easystack.cn>
 <20240508131125.00003d2b@Huawei.com>
 <ef0ee621-a2d2-e59a-f601-e072e8790f06@easystack.cn>
 <20240508164417.00006c69@Huawei.com>
 <3d547577-e8f2-8765-0f63-07d1700fcefc@easystack.cn>
 <20240509132134.00000ae9@Huawei.com>
 <a571be12-2fd3-e0ee-a914-0a6e2c46bdbc@easystack.cn>
 <664cead8eb0b6_add32947d@dwillia2-mobl3.amr.corp.intel.com.notmuch>
 <8f161b2d-eacd-ad35-8959-0f44c8d132b3@easystack.cn>
 <ZldIzp0ncsRX5BZE@memverge.com>
From: Dongsheng Yang <dongsheng.yang@easystack.cn>
Message-ID: <5db870de-ecb3-f127-f31c-b59443b4fbb4@easystack.cn>
Date: Thu, 30 May 2024 14:59:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <ZldIzp0ncsRX5BZE@memverge.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkaThpMVkxDTENJTR5NQkNCTVUZERMWGhIXJBQOD1
	lXWRgSC1lBWUlKQ1VCT1VKSkNVQktZV1kWGg8SFR0UWUFZT0tIVUpNT0lMTlVKS0tVSkJLS1kG
X-HM-Tid: 0a8fc84c11d1023ckunm3882d860313
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OjY6DBw6MDcZPi8fExwQNy4S
	MQhPCx9VSlVKTEpMS05JSENLSEtLVTMWGhIXVR8UFRwIEx4VHFUCGhUcOx4aCAIIDxoYEFUYFUVZ
	V1kSC1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBTUlDTDcG



在 2024/5/29 星期三 下午 11:25, Gregory Price 写道:
> On Wed, May 22, 2024 at 02:17:38PM +0800, Dongsheng Yang wrote:
>>
>>
>> 在 2024/5/22 星期三 上午 2:41, Dan Williams 写道:
>>> Dongsheng Yang wrote:
>>>
>>> What guarantees this property? How does the reader know that its local
>>> cache invalidation is sufficient for reading data that has only reached
>>> global visibility on the remote peer? As far as I can see, there is
>>> nothing that guarantees that local global visibility translates to
>>> remote visibility. In fact, the GPF feature is counter-evidence of the
>>> fact that writes can be pending in buffers that are only flushed on a
>>> GPF event.
>>
>> Sounds correct. From what I learned from GPF, ADR, and eADR, there would
>> still be data in WPQ even though we perform a CPU cache line flush in the
>> OS.
>>
>> This means we don't have a explicit method to make data puncture all caches
>> and land in the media after writing. also it seems there isn't a explicit
>> method to invalidate all caches along the entire path.
>>
>>>
>>> I remain skeptical that a software managed inter-host cache-coherency
>>> scheme can be made reliable with current CXL defined mechanisms.
>>
>>
>> I got your point now, acorrding current CXL Spec, it seems software managed
>> cache-coherency for inter-host shared memory is not working. Will the next
>> version of CXL spec consider it?
>>>
> 
> Sorry for missing the conversation, have been out of office for a bit.
> 
> It's not just a CXL spec issue, though that is part of it. I think the
> CXL spec would have to expose some form of puncturing flush, and this
> makes the assumption that such a flush doesn't cause some kind of
> race/deadlock issue.  Certainly this needs to be discussed.
> 
> However, consider that the upstream processor actually has to generate
> this flush.  This means adding the flush to existing coherence protocols,
> or at the very least a new instruction to generate the flush explicitly.
> The latter seems more likely than the former.
> 
> This flush would need to ensure the data is forced out of the local WPQ
> AND all WPQs south of the PCIE complex - because what you really want to
> know is that the data has actually made it back to a place where remote
> viewers are capable of percieving the change.
> 
> So this means:
> 1) Spec revision with puncturing flush
> 2) Buy-in from CPU vendors to generate such a flush
> 3) A new instruction added to the architecture.
> 
> Call me in a decade or so.
> 
> 
> But really, I think it likely we see hardware-coherence well before this.
> For this reason, I have become skeptical of all but a few memory sharing
> use cases that depend on software-controlled cache-coherency.

Hi Gregory,

	From my understanding, we actually has the same idea here. What I am 
saying is that we need SPEC to consider this issue, meaning we need to 
describe how the entire software-coherency mechanism operates, which 
includes the necessary hardware support. Additionally, I agree that if 
software-coherency also requires hardware support, it seems that 
hardware-coherency is the better path.
> 
> There are some (FAMFS, for example). The coherence state of these
> systems tend to be less volatile (e.g. mappings are read-only), or
> they have inherent design limitations (cacheline-sized message passing
> via write-ahead logging only).

Can you explain more about this? I understand that if the reader in the 
writer-reader model is using a readonly mapping, the interaction will be 
much simpler. However, after the writer writes data, if we don't have a 
mechanism to flush and invalidate puncturing all caches, how can the 
readonly reader access the new data?
> 
> ~Gregory
> 
