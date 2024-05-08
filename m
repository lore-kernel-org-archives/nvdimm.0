Received: from mail-m6034.netease.com (mail-m6034.netease.com [210.79.60.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922F93D96D
	for <nvdimm@lists.linux.dev>; Wed,  8 May 2024 12:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.79.60.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715170678; cv=none; b=uau5jM7x+exkW7/w3e4sBGdOfk0ofSQhmSE0OrM/y7N+Ku1hFLNT3VGGPRwX4pa5GUIZiKvHQinLTvLf664uQ5qzwBSIxYCGv/rE/vtOc3Pqh0HA/5Lca6fbP3vIcOu2FTeExzVyQLxCC6UNCYP0MpAHbnJp22Urlf3CK+yPii8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715170678; c=relaxed/simple;
	bh=kFTbKS5YwZsDZpNSHWZMmIkt1or1OsHs+bPArAcbNNY=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=ImDU5WIDJwFK773oYzNqqRujkC8OIvuet6JxBAR0twkb/rtnegnyxnPThhiddE36tWG9viMiAtySPd+B9+quSqaLsLgMKD32PeFUVL76yXhJfXk5+ZMMtvFdJdva5AD5rjosWG816NFuaLY0GTVo2zacQ7hA/AWmaJZgqseG9X4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=easystack.cn; spf=none smtp.mailfrom=easystack.cn; arc=none smtp.client-ip=210.79.60.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=easystack.cn
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=easystack.cn
Received: from [192.168.122.189] (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTPA id A6C0F8601DE;
	Wed,  8 May 2024 19:39:24 +0800 (CST)
Subject: Re: [PATCH RFC 0/7] block: Introduce CBD (CXL Block Device)
To: Jonathan Cameron <Jonathan.Cameron@Huawei.com>,
 John Groves <John@groves.net>, Dan Williams <dan.j.williams@intel.com>,
 Gregory Price <gregory.price@memverge.com>
Cc: Gregory Price <gregory.price@memverge.com>,
 Dan Williams <dan.j.williams@intel.com>, axboe@kernel.dk,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
References: <20240422071606.52637-1-dongsheng.yang@easystack.cn>
 <66288ac38b770_a96f294c6@dwillia2-mobl3.amr.corp.intel.com.notmuch>
 <ef34808b-d25d-c953-3407-aa833ad58e61@easystack.cn>
 <ZikhwAAIGFG0UU23@memverge.com>
 <bbf692ec-2109-baf2-aaae-7859a8315025@easystack.cn>
 <ZiuwyIVaKJq8aC6g@memverge.com>
 <98ae27ff-b01a-761d-c1c6-39911a000268@easystack.cn>
 <ZivS86BrfPHopkru@memverge.com>
 <8f373165-dd2b-906f-96da-41be9f27c208@easystack.cn>
 <wold3g5ww63cwqo7rlwevqcpmlen3fl3lbtbq3qrmveoh2hale@e7carkmumnub>
 <20240503105245.00003676@Huawei.com>
From: Dongsheng Yang <dongsheng.yang@easystack.cn>
Message-ID: <5b7f3700-aeee-15af-59a7-8e271a89c850@easystack.cn>
Date: Wed, 8 May 2024 19:39:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240503105245.00003676@Huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVlDQk0YVh5LTRhDSBpNQx1OT1UZERMWGhIXJBQOD1
	lXWRgSC1lBWUlKQ1VCT1VKSkNVQktZV1kWGg8SFR0UWUFZT0tIVUpNT0lMTlVKS0tVSkJLS1kG
X-HM-Tid: 0a8f58004a36023ckunma6c0f8601de
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PDI6ESo*EzcwQlYBUU4tSyw4
	Hy1PCRlVSlVKTEpOSk1DSE1OT0lMVTMWGhIXVR8UFRwIEx4VHFUCGhUcOx4aCAIIDxoYEFUYFUVZ
	V1kSC1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBTUlKSDcG



在 2024/5/3 星期五 下午 5:52, Jonathan Cameron 写道:
> On Sun, 28 Apr 2024 11:55:10 -0500
> John Groves <John@groves.net> wrote:
> 
>> On 24/04/28 01:47PM, Dongsheng Yang wrote:
>>>
>>>
>>> 在 2024/4/27 星期六 上午 12:14, Gregory Price 写道:
>>>> On Fri, Apr 26, 2024 at 10:53:43PM +0800, Dongsheng Yang wrote:
>>>>>
>>>>>
>>>>> 在 2024/4/26 星期五 下午 9:48, Gregory Price 写道:
>>>>>>    
>>>>>

...
>>
>> Just to make things slightly gnarlier, the MESI cache coherency protocol
>> allows a CPU to speculatively convert a line from exclusive to modified,
>> meaning it's not clear as of now whether "occasional" clean write-backs
>> can be avoided. Meaning those read-only mappings may be more important
>> than one might think. (Clean write-backs basically make it
>> impossible for software to manage cache coherency.)
> 
> My understanding is that clean write backs are an implementation specific
> issue that came as a surprise to some CPU arch folk I spoke to, we will
> need some path for a host to say if they can ever do that.
> 
> Given this definitely effects one CPU vendor, maybe solutions that
> rely on this not happening are not suitable for upstream.
> 
> Maybe this market will be important enough for that CPU vendor to stop
> doing it but if they do it will take a while...
> 
> Flushing in general is as CPU architecture problem where each of the
> architectures needs to be clear what they do / specify that their
> licensees do.
> 
> I'm with Dan on encouraging all memory vendors to do hardware coherence!

Hi Gregory, John, Jonathan and Dan:
	Thanx for your information, they help a lot, and sorry for the late reply.

After some internal discussions, I think we can design it as follows:

(1) If the hardware implements cache coherence, then the software layer 
doesn't need to consider this issue, and can perform read and write 
operations directly.

(2) If the hardware doesn't implement cache coherence, we can consider a 
DMA-like approach, where we check architectural features to determine if 
cache coherence is supported. This could be similar to 
`dev_is_dma_coherent`.

Additionally, if the architecture supports flushing and invalidating CPU 
caches (`CONFIG_ARCH_HAS_SYNC_DMA_FOR_DEVICE`, 
`CONFIG_ARCH_HAS_SYNC_DMA_FOR_CPU`, 
`CONFIG_ARCH_HAS_SYNC_DMA_FOR_CPU_ALL`),

then we can handle cache coherence at the software layer.
(For the clean writeback issue, I think it may also require 
clarification from the architecture, and how DMA handles the clean 
writeback problem, which I haven't further checked.)

(3) If the hardware doesn't implement cache coherence and the cpu 
doesn't support the required CPU cache operations, then we can run in 
nocache mode.

CBD can initially support (3), and then transition to (1) when hardware 
supports cache-coherency. If there's sufficient market demand, we can 
also consider supporting (2).

How does this approach sound?

Thanx
> 
> J
> 
>>
>> Keep in mind that I don't think anybody has cxl 3 devices or CPUs yet, and
>> shared memory is not explicitly legal in cxl 2, so there are things a cpu
>> could do (or not do) in a cxl 2 environment that are not illegal because
>> they should not be observable in a no-shared-memory environment.
>>
>> CBD is interesting work, though for some of the reasons above I'm somewhat
>> skeptical of shared memory as an IPC mechanism.
>>
>> Regards,
>> John
>>
>>
>>
> 
> .
> 
