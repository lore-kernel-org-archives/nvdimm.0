Received: from mail-m92252.xmail.ntesmail.com (mail-m92252.xmail.ntesmail.com [103.126.92.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DEA91311AC
	for <nvdimm@lists.linux.dev>; Thu,  9 May 2024 11:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.126.92.252
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715254377; cv=none; b=ncvHbc6d7MCtJClAX02K55UfXTqPJ2lBL2VD/2NSCh6MZOKErbZ/Q0OaP6CarfzFSNjFY3f7sPBEQ8F8JxqgSVHQO9o49VCLz5ytdT0XG5EamXIIkiHULjayVz7Ss+AHVpuX/Z/IH3vCcPeYwTEkJR5vqrBGrKUpPYFCxVdbthY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715254377; c=relaxed/simple;
	bh=KnUfaCc3MpuPBR3EdwXghR15Y3buYrD1ThIZlSRopRE=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=TvYuydrB/Qei+JygqqED39O/UwaD9uKsEEbty0oTcsITPhY0r3v1F4dQWoDiUCxBkAcjH6xImJHdRzoOHJ35vITVjuHnIfu+7EfAi/Z4+YeAk7d3kNrFJmCSYqJJbcWql47+l5re3ObQLnG9BI4pb8BRnSmuv8xgas8VIVCuRH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=easystack.cn; spf=pass smtp.mailfrom=easystack.cn; arc=none smtp.client-ip=103.126.92.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=easystack.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=easystack.cn
Received: from [192.168.122.189] (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTPA id D7F2986021B;
	Thu,  9 May 2024 19:24:29 +0800 (CST)
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
From: Dongsheng Yang <dongsheng.yang@easystack.cn>
Message-ID: <3d547577-e8f2-8765-0f63-07d1700fcefc@easystack.cn>
Date: Thu, 9 May 2024 19:24:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240508164417.00006c69@Huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVlDHh4YVkxKHRpMGUtLSUxCTVUZERMWGhIXJBQOD1
	lXWRgSC1lBWUlKQ1VCT1VKSkNVQktZV1kWGg8SFR0UWUFZT0tIVUpNT0lMTlVKS0tVSkJLS1kG
X-HM-Tid: 0a8f5d18fe9a023ckunmd7f2986021b
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PBw6Dhw5Qzc1EUouDEoKEw8j
	LjhPFA5VSlVKTEpOSU5IQ0xLTUJCVTMWGhIXVR8UFRwIEx4VHFUCGhUcOx4aCAIIDxoYEFUYFUVZ
	V1kSC1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBSklDTk03Bg++



在 2024/5/8 星期三 下午 11:44, Jonathan Cameron 写道:
> On Wed, 8 May 2024 21:03:54 +0800
> Dongsheng Yang <dongsheng.yang@easystack.cn> wrote:
> 
>> 在 2024/5/8 星期三 下午 8:11, Jonathan Cameron 写道:
>>> On Wed, 8 May 2024 19:39:23 +0800
>>> Dongsheng Yang <dongsheng.yang@easystack.cn> wrote:
>>>    
>>>> 在 2024/5/3 星期五 下午 5:52, Jonathan Cameron 写道:
>>>>> On Sun, 28 Apr 2024 11:55:10 -0500
>>>>> John Groves <John@groves.net> wrote:
>>>>>       
>>>>>> On 24/04/28 01:47PM, Dongsheng Yang wrote:
>>>>>>>
>>>>>>>
>>>>>>> 在 2024/4/27 星期六 上午 12:14, Gregory Price 写道:
>>>>>>>> On Fri, Apr 26, 2024 at 10:53:43PM +0800, Dongsheng Yang wrote:
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> 在 2024/4/26 星期五 下午 9:48, Gregory Price 写道:
>>>>>>>>>>          
>>>>>>>>>      
>>>>
>>>> ...
>>>>>>
>>>>>> Just to make things slightly gnarlier, the MESI cache coherency protocol
>>>>>> allows a CPU to speculatively convert a line from exclusive to modified,
>>>>>> meaning it's not clear as of now whether "occasional" clean write-backs
>>>>>> can be avoided. Meaning those read-only mappings may be more important
>>>>>> than one might think. (Clean write-backs basically make it
>>>>>> impossible for software to manage cache coherency.)
>>>>>
>>>>> My understanding is that clean write backs are an implementation specific
>>>>> issue that came as a surprise to some CPU arch folk I spoke to, we will
>>>>> need some path for a host to say if they can ever do that.
>>>>>
>>>>> Given this definitely effects one CPU vendor, maybe solutions that
>>>>> rely on this not happening are not suitable for upstream.
>>>>>
>>>>> Maybe this market will be important enough for that CPU vendor to stop
>>>>> doing it but if they do it will take a while...
>>>>>
>>>>> Flushing in general is as CPU architecture problem where each of the
>>>>> architectures needs to be clear what they do / specify that their
>>>>> licensees do.
>>>>>
>>>>> I'm with Dan on encouraging all memory vendors to do hardware coherence!
>>>>
>>>> Hi Gregory, John, Jonathan and Dan:
>>>> 	Thanx for your information, they help a lot, and sorry for the late reply.
>>>>
>>>> After some internal discussions, I think we can design it as follows:
>>>>
>>>> (1) If the hardware implements cache coherence, then the software layer
>>>> doesn't need to consider this issue, and can perform read and write
>>>> operations directly.
>>>
>>> Agreed - this is one easier case.
>>>    
>>>>
>>>> (2) If the hardware doesn't implement cache coherence, we can consider a
>>>> DMA-like approach, where we check architectural features to determine if
>>>> cache coherence is supported. This could be similar to
>>>> `dev_is_dma_coherent`.
>>>
>>> Ok. So this would combine host support checks with checking if the shared
>>> memory on the device is multi host cache coherent (it will be single host
>>> cache coherent which is what makes this messy)
>>>>
>>>> Additionally, if the architecture supports flushing and invalidating CPU
>>>> caches (`CONFIG_ARCH_HAS_SYNC_DMA_FOR_DEVICE`,
>>>> `CONFIG_ARCH_HAS_SYNC_DMA_FOR_CPU`,
>>>> `CONFIG_ARCH_HAS_SYNC_DMA_FOR_CPU_ALL`),
>>>
>>> Those particular calls won't tell you much at all. They indicate that a flush
>>> can happen as far as a common point for DMA engines in the system. No
>>> information on whether there are caches beyond that point.
>>>    
>>>>
>>>> then we can handle cache coherence at the software layer.
>>>> (For the clean writeback issue, I think it may also require
>>>> clarification from the architecture, and how DMA handles the clean
>>>> writeback problem, which I haven't further checked.)
>>>
>>> I believe the relevant architecture only does IO coherent DMA so it is
>>> never a problem (unlike with multihost cache coherence).Hi Jonathan,
>>
>> let me provide an example,
>> In nvmeof-rdma, the `nvme_rdma_queue_rq` function places a request into
>> `req->sqe.dma`.
>>
>> (1) First, it calls `ib_dma_sync_single_for_cpu()`, which invalidates
>> the CPU cache:
>>
>>
>> ib_dma_sync_single_for_cpu(dev, sqe->dma,
>>                               sizeof(struct nvme_command), DMA_TO_DEVICE);
>>
>>
>> For example, on ARM64, this would call `arch_sync_dma_for_cpu`, followed
>> by `dcache_inval_poc(start, start + size)`.
> 
> Key here is the POC. It's a flush to the point of coherence of the local
> system.  It has no idea about interhost coherency and is not necessarily
> the DRAM (in CXL or otherwise).
> 
> If you are doing software coherence, those devices will plug into today's
> hosts and they have no idea that such a flush means pushing out into
> the CXL fabric and to the type 3 device.
> 
>>
>> (2) Setting up data related to the NVMe request.
>>
>> (3) then Calls `ib_dma_sync_single_for_device` to flush the CPU cache to
>> DMA memory:
>>
>> ib_dma_sync_single_for_device(dev, sqe->dma,
>>                                   sizeof(struct nvme_command),
>> DMA_TO_DEVICE);
>>
>> Of course, if the hardware ensures cache coherency, the above operations
>> are skipped. However, if the hardware does not guarantee cache
>> coherency, RDMA appears to ensure cache coherency through this method.
>>
>> In the RDMA scenario, we also face the issue of multi-host cache
>> coherence. so I'm thinking, can we adopt a similar approach in CXL
>> shared memory to achieve data sharing?
> 
> You don't face the same coherence issues, or at least not in the same way.
> In that case the coherence guarantees are actually to the RDMA NIC.
> It is guaranteed to see the clean data by the host - that may involve
> flushes to PoC.  A one time snapshot is then sent to readers on other
> hosts. If writes occur they are also guarantee to replace cached copies
> on this host - because there is well define guarantee of IO coherence
> or explicit cache maintenance to the PoC
right, the PoC is not point of cohenrence with other host. it sounds 
correct. thanx.
> 
>   
>>
>>>>
>>>> (3) If the hardware doesn't implement cache coherence and the cpu
>>>> doesn't support the required CPU cache operations, then we can run in
>>>> nocache mode.
>>>
>>> I suspect that gets you no where either.  Never believe an architecture
>>> that provides a flag that says not to cache something.  That just means
>>> you should not be able to tell that it is cached - many many implementations
>>> actually cache such accesses.
>>
>> Sigh, then that really makes thing difficult.
> 
> Yes. I think we are going to have to wait on architecture specific clarifications
> before any software coherent use case can be guaranteed to work beyond the 3.1 ones
> for temporal sharing (only one accessing host at a time) and read only sharing where
> writes are dropped anyway so clean write back is irrelevant beyond some noise in
> logs possibly (if they do get logged it is considered so rare we don't care!).

Hi Jonathan,
	Allow me to discuss further. As described in CXL 3.1:
```
Software-managed coherency schemes are complicated by any host or device 
whose caching agents generate clean writebacks. A “No Clean Writebacks” 
capability bit is available for a host in the CXL System Description 
Structure (CSDS; see Section 9.18.1.6) or for a device in the DVSEC CXL 
Capability2 register (see Section 8.1.3.7).
```

If we check and find that the "No clean writeback" bit in both CSDS and 
DVSEC is set, can we then assume that software cache-coherency is 
feasible, as outlined below:

(1) Both the writer and reader ensure cache flushes. Since there are no 
clean writebacks, there will be no background data writes.

(2) The writer writes data to shared memory and then executes a cache 
flush. If we trust the "No clean writeback" bit, we can assume that the 
data in shared memory is coherent.

(3) Before reading the data, the reader performs cache invalidation. 
Since there are no clean writebacks, this invalidation operation will 
not destroy the data written by the writer. Therefore, the data read by 
the reader should be the data written by the writer, and since the 
writer's cache is clean, it will not write data to shared memory during 
the reader's reading process. Additionally, data integrity can be ensured.

The first step for CBD should depend on hardware cache coherence, which 
is clearer and more feasible. Here, I am just exploring the possibility 
of software cache coherence, not insisting on implementing software 
cache-coherency right away. :)

Thanx
> 
>>>    
>>>>
>>>> CBD can initially support (3), and then transition to (1) when hardware
>>>> supports cache-coherency. If there's sufficient market demand, we can
>>>> also consider supporting (2).
>>> I'd assume only (3) works.  The others rely on assumptions I don't think
>>
>> I guess you mean (1), the hardware cache-coherency way, right?
> 
> Indeed - oops!
> Hardware coherency is the way to go, or a well defined and clearly document
> description of how to play with the various host architectures.
> 
> Jonathan
> 
> 
>>
>> :)
>> Thanx
>>
>>> you can rely on.
>>>
>>> Fun fun fun,
>>>
>>> Jonathan
>>>    
>>>>
>>>> How does this approach sound?
>>>>
>>>> Thanx
>>>>>
>>>>> J
>>>>>       
>>>>>>
>>>>>> Keep in mind that I don't think anybody has cxl 3 devices or CPUs yet, and
>>>>>> shared memory is not explicitly legal in cxl 2, so there are things a cpu
>>>>>> could do (or not do) in a cxl 2 environment that are not illegal because
>>>>>> they should not be observable in a no-shared-memory environment.
>>>>>>
>>>>>> CBD is interesting work, though for some of the reasons above I'm somewhat
>>>>>> skeptical of shared memory as an IPC mechanism.
>>>>>>
>>>>>> Regards,
>>>>>> John
>>>>>>
>>>>>>
>>>>>>      
>>>>>
>>>>> .
>>>>>       
>>>
>>> .
>>>    
> 
> 
