Received: from mail-m17232.xmail.ntesmail.com (mail-m17232.xmail.ntesmail.com [45.195.17.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B17131196
	for <nvdimm@lists.linux.dev>; Thu,  9 May 2024 13:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.195.17.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715260980; cv=none; b=m0PUEGDrkRA4/hFwjJElFk4vzN0AJURoM7xwL/5BxOg1lUgo/3JxRXkYUjM7xRd3G10zEd/JbmvNQxp7SBVcagHfewe751jwa1hMruthhJ1xTVaHhbIx1D8SbAA5CbK8r3BoUAbTmXNNA9QKincNArw6/nZ7w6qpZ0P1Pe5QGj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715260980; c=relaxed/simple;
	bh=4XnBz2lh+7YxriUGIom+RcfBIR64ijJxolblnDjagBQ=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=aZ/vEGzCUSVrFjqS5ZSETosbHEO/LQxI1MUuwVMLNQofzYqxwZ7Gii6tvvTU7oo/ZWDeSNN8DsvGnWBLa5fC++OrLIcO+OBILdUyudf3Rnilcg81QAvbgPAFLyHZ6dKUOgQHUzFM7Q5U9PqewJaM5p9KSTjFiiA4ShM7Z2sfHyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=easystack.cn; spf=pass smtp.mailfrom=easystack.cn; arc=none smtp.client-ip=45.195.17.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=easystack.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=easystack.cn
Received: from [192.168.122.189] (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTPA id 0F263860417;
	Thu,  9 May 2024 21:03:43 +0800 (CST)
Subject: Re: [PATCH RFC 0/7] block: Introduce CBD (CXL Block Device)
To: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
Cc: John Groves <John@groves.net>, Dan Williams <dan.j.williams@intel.com>,
 Gregory Price <gregory.price@memverge.com>, axboe@kernel.dk,
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
 <5b7f3700-aeee-15af-59a7-8e271a89c850@easystack.cn>
 <20240508131125.00003d2b@Huawei.com>
 <ef0ee621-a2d2-e59a-f601-e072e8790f06@easystack.cn>
 <20240508164417.00006c69@Huawei.com>
 <3d547577-e8f2-8765-0f63-07d1700fcefc@easystack.cn>
 <20240509132134.00000ae9@Huawei.com>
From: Dongsheng Yang <dongsheng.yang@easystack.cn>
Message-ID: <a571be12-2fd3-e0ee-a914-0a6e2c46bdbc@easystack.cn>
Date: Thu, 9 May 2024 21:03:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240509132134.00000ae9@Huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVlDGUNNVh1KTB0eSx8ZS0wZSFUZERMWGhIXJBQOD1
	lXWRgSC1lBWUlKQ1VCT1VKSkNVQktZV1kWGg8SFR0UWUFZT0tIVUpNT0lMTlVKS0tVSkJLS1kG
X-HM-Tid: 0a8f5d73d560023ckunm0f263860417
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Ngg6Fjo*FDc*EUo6Aj1JLj5J
	GggwC0JVSlVKTEpOSU5CQ0lIQ0xIVTMWGhIXVR8UFRwIEx4VHFUCGhUcOx4aCAIIDxoYEFUYFUVZ
	V1kSC1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBTE5JTjcG



在 2024/5/9 星期四 下午 8:21, Jonathan Cameron 写道:
> On Thu, 9 May 2024 19:24:28 +0800
> Dongsheng Yang <dongsheng.yang@easystack.cn> wrote:
> 
...
>>> Yes. I think we are going to have to wait on architecture specific clarifications
>>> before any software coherent use case can be guaranteed to work beyond the 3.1 ones
>>> for temporal sharing (only one accessing host at a time) and read only sharing where
>>> writes are dropped anyway so clean write back is irrelevant beyond some noise in
>>> logs possibly (if they do get logged it is considered so rare we don't care!).
>>
>> Hi Jonathan,
>> 	Allow me to discuss further. As described in CXL 3.1:
>> ```
>> Software-managed coherency schemes are complicated by any host or device
>> whose caching agents generate clean writebacks. A “No Clean Writebacks”
>> capability bit is available for a host in the CXL System Description
>> Structure (CSDS; see Section 9.18.1.6) or for a device in the DVSEC CXL
>> Capability2 register (see Section 8.1.3.7).
>> ```
>>
>> If we check and find that the "No clean writeback" bit in both CSDS and
>> DVSEC is set, can we then assume that software cache-coherency is
>> feasible, as outlined below:
>>
>> (1) Both the writer and reader ensure cache flushes. Since there are no
>> clean writebacks, there will be no background data writes.
>>
>> (2) The writer writes data to shared memory and then executes a cache
>> flush. If we trust the "No clean writeback" bit, we can assume that the
>> data in shared memory is coherent.
>>
>> (3) Before reading the data, the reader performs cache invalidation.
>> Since there are no clean writebacks, this invalidation operation will
>> not destroy the data written by the writer. Therefore, the data read by
>> the reader should be the data written by the writer, and since the
>> writer's cache is clean, it will not write data to shared memory during
>> the reader's reading process. Additionally, data integrity can be ensured.
>>
>> The first step for CBD should depend on hardware cache coherence, which
>> is clearer and more feasible. Here, I am just exploring the possibility
>> of software cache coherence, not insisting on implementing software
>> cache-coherency right away. :)
> 
> Yes, if a platform sets that bit, you 'should' be fine.  What exact flush
> is needed is architecture specific however and the DMA related ones
> may not be sufficient. I'd keep an eye open for arch doc update from the
> various vendors.
> 
> Also, the architecture that motivated that bit existing is a 'moderately
> large' chip vendor so I'd go so far as to say adoption will be limited
> unless they resolve that in a future implementation :)

Great, I think we've had a good discussion and reached a consensus on 
this issue. The remaining aspect will depend on hardware updates. Thank 
you for the information, that helps a lot.

Thanx
> 
> Jonathan
> 
>>
>> Thanx
>>>    
>>>>>       
>>>>>>
>>>>>> CBD can initially support (3), and then transition to (1) when hardware
>>>>>> supports cache-coherency. If there's sufficient market demand, we can
>>>>>> also consider supporting (2).
>>>>> I'd assume only (3) works.  The others rely on assumptions I don't think
>>>>
>>>> I guess you mean (1), the hardware cache-coherency way, right?
>>>
>>> Indeed - oops!
>>> Hardware coherency is the way to go, or a well defined and clearly document
>>> description of how to play with the various host architectures.
>>>
>>> Jonathan
>>>
>>>    
>>>>
>>>> :)
>>>> Thanx
>>>>   
>>>>> you can rely on.
>>>>>
>>>>> Fun fun fun,
>>>>>
>>>>> Jonathan
>>>>>       
>>>>>>
>>>>>> How does this approach sound?
>>>>>>
>>>>>> Thanx
>>>>>>>
>>>>>>> J
>>>>>>>          
>>>>>>>>
>>>>>>>> Keep in mind that I don't think anybody has cxl 3 devices or CPUs yet, and
>>>>>>>> shared memory is not explicitly legal in cxl 2, so there are things a cpu
>>>>>>>> could do (or not do) in a cxl 2 environment that are not illegal because
>>>>>>>> they should not be observable in a no-shared-memory environment.
>>>>>>>>
>>>>>>>> CBD is interesting work, though for some of the reasons above I'm somewhat
>>>>>>>> skeptical of shared memory as an IPC mechanism.
>>>>>>>>
>>>>>>>> Regards,
>>>>>>>> John
>>>>>>>>
>>>>>>>>
>>>>>>>>         
>>>>>>>
>>>>>>> .
>>>>>>>          
>>>>>
>>>>> .
>>>>>       
>>>
>>>    
> 
