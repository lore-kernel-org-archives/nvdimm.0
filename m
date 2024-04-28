Received: from mail-m25487.xmail.ntesmail.com (mail-m25487.xmail.ntesmail.com [103.129.254.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04ED0539A
	for <nvdimm@lists.linux.dev>; Sun, 28 Apr 2024 05:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.129.254.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714283298; cv=none; b=uvkfkyzRIHribRJYEV1Aij2hdqR814jLEBzG19BuwmF0YdFAeSsDCfM/M80bcRNecjJh4ecD/UojU0xWlOoLYyZFROC66nDulrqglyQvfus+6rrLM2SrFQoABGNMf0aE6x0Jst7ZUIcM7LYLDnfgTK1bJLc4ftapoeB9j2LAWhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714283298; c=relaxed/simple;
	bh=ij7cu/SamWdL5jSL1fvJ2OvFNNjuQdq94yrLrLdTk24=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=qblSB1NvTH4YDmm4zzdB8rC5e15ptcDeoeJdHcebyBinBFjt8cn6ctyzQkrNVlzzKlRSRXvGGEJyikxhIN/EYXYLfb1oBotUOZzN7H6J0n7t8gtSWhPYkNKMvkCuK++zmbUcNrCl6O8ZnmNrNs7w0NhMCvy3KNyrbhOd69SIje0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=easystack.cn; spf=pass smtp.mailfrom=easystack.cn; arc=none smtp.client-ip=103.129.254.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=easystack.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=easystack.cn
Received: from [192.168.122.189] (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTPA id 153748601AB;
	Sun, 28 Apr 2024 13:47:31 +0800 (CST)
Subject: Re: [PATCH RFC 0/7] block: Introduce CBD (CXL Block Device)
To: Gregory Price <gregory.price@memverge.com>,
 Dan Williams <dan.j.williams@intel.com>, John Groves <John@groves.net>
Cc: axboe@kernel.dk, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev
References: <20240422071606.52637-1-dongsheng.yang@easystack.cn>
 <66288ac38b770_a96f294c6@dwillia2-mobl3.amr.corp.intel.com.notmuch>
 <ef34808b-d25d-c953-3407-aa833ad58e61@easystack.cn>
 <ZikhwAAIGFG0UU23@memverge.com>
 <bbf692ec-2109-baf2-aaae-7859a8315025@easystack.cn>
 <ZiuwyIVaKJq8aC6g@memverge.com>
 <98ae27ff-b01a-761d-c1c6-39911a000268@easystack.cn>
 <ZivS86BrfPHopkru@memverge.com>
From: Dongsheng Yang <dongsheng.yang@easystack.cn>
Message-ID: <8f373165-dd2b-906f-96da-41be9f27c208@easystack.cn>
Date: Sun, 28 Apr 2024 13:47:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <ZivS86BrfPHopkru@memverge.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkZTUNCVkoeTk0fSh5KH09KH1UZERMWGhIXJBQOD1
	lXWRgSC1lBWUlKQ1VCT1VKSkNVQktZV1kWGg8SFR0UWUFZT0tIVUpNT0lMTlVKS0tVSkJLS1kG
X-HM-Tid: 0a8f233e86d4023ckunm153748601ab
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6ORA6EBw5PDc#NwsISxADSgNM
	GU4aCk1VSlVKTEpPSUNISU5KTE5LVTMWGhIXVR8UFRwIEx4VHFUCGhUcOx4aCAIIDxoYEFUYFUVZ
	V1kSC1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBT0JDTjcG



在 2024/4/27 星期六 上午 12:14, Gregory Price 写道:
> On Fri, Apr 26, 2024 at 10:53:43PM +0800, Dongsheng Yang wrote:
>>
>>
>> 在 2024/4/26 星期五 下午 9:48, Gregory Price 写道:
>>>
>>
>> In (5) of the cover letter, I mentioned that cbd addresses cache coherence
>> at the software level:
>>
>> (5) How do blkdev and backend interact through the channel?
>> 	a) For reader side, before reading the data, if the data in this channel
>> may be modified by the other party, then I need to flush the cache before
>> reading to ensure that I get the latest data. For example, the blkdev needs
>> to flush the cache before obtaining compr_head because compr_head will be
>> updated by the backend handler.
>> 	b) For writter side, if the written information will be read by others,
>> then after writing, I need to flush the cache to let the other party see it
>> immediately. For example, after blkdev submits cbd_se, it needs to update
>> cmd_head to let the handler have a new cbd_se. Therefore, after updating
>> cmd_head, I need to flush the cache to let the backend see it.
>>
> 
> Flushing the cache is insufficient.  All that cache flushing guarantees
> is that the memory has left the writer's CPU cache.  There are potentially
> many write buffers between the CPU and the actual backing media that the
> CPU has no visibility of and cannot pierce through to force a full
> guaranteed flush back to the media.
> 
> for example:
> 
> memcpy(some_cacheline, data, 64);
> mfence();
> 
> Will not guarantee that after mfence() completes that the remote host
> will have visibility of the data.  mfence() does not guarantee a full
> flush back down to the device, it only guarantees it has been pushed out
> of the CPU's cache.
> 
> similarly:
> 
> memcpy(some_cacheline, data, 64);
> mfence();
> memcpy(some_other_cacheline, data, 64);
> mfence()
> 
> Will not guarantee that some_cacheline reaches the backing media prior
> to some_other_cacheline, as there is no guarantee of write-ordering in
> CXL controllers (with the exception of writes to the same cacheline).
> 
> So this statement:
> 
>> I need to flush the cache to let the other party see it immediately.
> 
> Is misleading.  They will not see is "immediately", they will see it
> "eventually at some completely unknowable time in the future".

This is indeed one of the issues I wanted to discuss at the RFC stage. 
Thank you for pointing it out.

In my opinion, using "nvdimm_flush" might be one way to address this 
issue, but it seems to flush the entire nd_region, which might be too 
heavy. Moreover, it only applies to non-volatile memory.

This should be a general problem for cxl shared memory. In theory, FAMFS 
should also encounter this issue.

Gregory, John, and Dan, Any suggestion about it?

Thanx a lot
> 
> ~Gregory
> 
