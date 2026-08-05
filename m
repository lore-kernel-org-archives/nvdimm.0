Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2EEC42982C
	for <nvdimm@lists.linux.dev>; Wed,  5 Aug 2026 10:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785927553; cv=none; b=lFLLukEvZ9ROYMZTvX3x9AgrLGvgmFfMq7SnucjTy1j52TslCLk1EYtBqoE2qMJkljTc7lQHaOmbMh6qSIj9bpF69tpBYGkRbMInefBNZXJ0iU8B4yUq1WOlANHMiXlv3/dnny85F3RyJBDzfacCf9Zg8DR8ai+VFdtgPFj4DDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785927553; c=relaxed/simple;
	bh=/1dtEFjUK+P0pvRVxCDasuHqjQBqBeraGQRhegPMj5o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ISFVpk6tSRrQNTrZEZrEyfKE/DDCpJbyQXmzvIQ4+1PjUX8PpXbuk5JwNCDLLdcfiKLZT+/vk/TGR/3+ZbinfpZKpHJH7GrR5WMoXU8ROepsPas7WYbRtIVyuTK8Aue/3LuDPKnFndoJaRom7dPIIH0nZo/2YJvmWLz6deou9IY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TdAZsF3X; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TdAZsF3X"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-4799b3f7c83so500558f8f.2
        for <nvdimm@lists.linux.dev>; Wed, 05 Aug 2026 03:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785927546; x=1786532346; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qChqnXEV/RUrII3F6FtB3OpL17H6S0GQj9i1G4DFOPk=;
        b=TdAZsF3X16CzHI2ZKpHT0XPrzYQ1GZfqcQ1TkeLIzR5oEHUCzryNC6tTR/pA0jCgzO
         VxdUUmCjpBwlPcLmvzwxRdR5ls9EwTPslP6IlKVGid96Pu+/AO9L4IJiUthEvlj5ioDI
         Ssa9Npk+sWhLC5tg38QIxVei/RoqiE7VzIIhwcbTPVNbsLBHZrHag5yihkrUky4L0Egl
         e8oYH5MGWDPitqoF8iazl4o5B0BzfA8dH3qnt6RtK2WTRau2C5TbgBrklHomu6Ved5w1
         KVjd6tPJzqwgql1JxfmVQXAbQ3RZ3iMnkVX4/P0PNVsVvznSjutfX5g2JLro1HlqmxlO
         md3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785927546; x=1786532346;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qChqnXEV/RUrII3F6FtB3OpL17H6S0GQj9i1G4DFOPk=;
        b=jB2EwpASXYfqx036swDKTeeK8RGkZkwS0rZyGKHCZyn+3RwfTUTu3ik0zVMoNcXnc2
         kYdscMbBYtJzcotz+S8mcTfoq22CkKaxkuhxs84KbZhgNIxufVhqo+bIbpQjZ36Hgz1k
         U6JhRsfY26vk8moSLXzpOW6z/ZL0TFSuKYz9ijITA9/tTZwLVgqd5ELtaQIZ40sbjmLN
         VLmkVDCoRpgMSK/9gcxlk40jPm2PXRXqfS3saP4Ej17HBKcaXYEP33x2+EFFTFWRlLYb
         9KPuJm6sV9551WRnwnto347GvjOD+3WXmaIO0rjyaC9Fkr318qfwcTi2LHoiClKa6Qld
         5gfw==
X-Forwarded-Encrypted: i=1; AHgh+Rqk0xh+uvYah+fnq3SkYCBGb+1/gRJI6ShVvF9svslNmAvDlzegwZOvHACm7OPQcCtBJQl/1lo=@lists.linux.dev
X-Gm-Message-State: AOJu0YxQZREgCzoK17dbp1cQCOHGrMiCMlFM1OBJs+fd+BheSyQRDtVQ
	JlYbL0Lv5/aKwAqospb5ns5SlBBRFQVLwPUX4I0XzCXi30aUIhSw1neq
X-Gm-Gg: AR+sD11lXUuHBFUxzpm9xPo4fKWwXwNWFcKquBRHnztZT26IQKf7B+qupmIe7j3WCci
	+20dSHukj1Pe01+rb38MOOaU74t038BKh4USIe6uap2m/SPnkRqWDGybtB/cOKjoSP+4NST5oWJ
	d+902cM9UsB1N6BXh2c8PSnaLwCT7u30+JKbylkkK0FidmqyCWekJDlsyXVoIN3g6u5nkt9Qh/A
	P3kKQW1XhZics47XMF5hunt6+uKduNBjRE8ksNgFwK3m0SdRVli6dvSNZslWQGdmplzFFaBydIn
	x2E9fONJZyHOIr/YXXtfLaupCIfsBbDQF4ExaXd/2Rn/sKoTtJZAgA4NuXKD/BZJVzzwtGgyiN0
	cqE3yoCUHp/COhjob6xB/DjsF1e/lry59b6J2XgF3FpHjX0Yj/0BUcBVuVDn3kGn5utVfPN8PtN
	U2BHzqMLcwieApWaKr5bU7C65oP2lGxXNx2H4lkW8m0yTY69KN4Ma/p76xw/zGG08bNIFh3JUYD
	en9tjXWYo0egrhLMCf79GKWzOIpq87Zifw8doA5wpWdMntiG5lqtOD1poNNEl2M4pDuK3uH5Ed3
	NUhYi0l2NKnBIQiIbnoOEUxKUMnbOXTpfWkhXz3ILdWD93Ut
X-Received: by 2002:a05:600c:4e94:b0:497:ff73:68d5 with SMTP id 5b1f17b1804b1-4994e6c5eafmr60022735e9.0.1785927545848;
        Wed, 05 Aug 2026 03:59:05 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4994e035900sm80665575e9.11.2026.08.05.03.59.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2026 03:59:05 -0700 (PDT)
Message-ID: <8285ede8-bebb-403a-8a37-b9987cd37a8f@gmail.com>
Date: Wed, 5 Aug 2026 11:59:10 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/14] dma-buf: introduce initial file I/O
 infrastructure
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Sumit Semwal <sumit.semwal@linaro.org>, Nitesh Shetty
 <nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>,
 Anuj Gupta <anuj20.g@samsung.com>, Tushar Gohad <tushar.gohad@intel.com>,
 William Power <william.power@intel.com>, Phil Cayton
 <phil.cayton@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Damien Le Moal <dlemoal@kernel.org>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Vishal Verma <vishal.l.verma@intel.com>, David Sterba <dsterba@suse.com>,
 Ilya Dryomov <idryomov@gmail.com>, dm-devel@lists.linux.dev,
 nvdimm@lists.linux.dev, linux-btrfs@vger.kernel.org,
 ceph-devel@vger.kernel.org
References: <cover.1785274111.git.asml.silence@gmail.com>
 <bc20381e8daf85ac58811c344325d8192cde9d1e.1785274111.git.asml.silence@gmail.com>
 <181b08be-04bc-4ae9-bb88-15321a82440f@amd.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <181b08be-04bc-4ae9-bb88-15321a82440f@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/5/26 09:27, Christian König wrote:
...>> +struct dma_buf_io_fence {
>> +	struct dma_fence base;
>> +	spinlock_t lock;
>> +};
> 
> Upstream has change to allow embedding the spinlock into the dma_fence, so this structure here is most likely not necessary any more.

ok

>> +static const char *dma_buf_io_fence_drv_name(struct dma_fence *fence)
>> +{
>> +	/* default fence release kfree's the base pointer */
>> +	BUILD_BUG_ON(offsetof(struct dma_buf_io_fence, base));
>> +
>> +	return "dma-buf-io-ctx";
>> +}
...>> +static void dma_buf_io_map_release_work(struct work_struct *work)
>> +{
>> +	struct dma_buf_io_map *map = container_of(work, struct dma_buf_io_map,
>> +						  release_work);
>> +	struct dma_buf_io_fence *fence = map->fence;
>> +	struct dma_buf_io_ctx *ctx = map->ctx;
>> +	struct dma_buf *dmabuf = ctx->dmabuf;
>> +
>> +	/* the release path must wait for fences */
>> +	if (WARN_ON_ONCE(refcount_read(&ctx->refs) == 0))
>> +		return;
> 
> Stuff like that is usually illegal.

Should be fine, it's just a warning. The map holds a ctx
reference so can't be 0. IIRC, it was synchronised a bit
differently before. I can kill it, refcount_inc() has the
same warning anyway.

> And why are you using refcount directly instead of kref?

Not sure it'd make much difference here.

> 
>> +
>> +	/* Prevent from destoying the ctx while unmapping */
>> +	refcount_inc(&ctx->refs);
> 
>> +
>> +	/*
>> +	 * There are no more requests using the map, we can signal the fence.
>> +	 * It should be done before taking the resv lock as someone could be
>> +	 * waiting for the fence while holding the lock.
>> +	 */
>> +	dma_fence_signal(&fence->base);
> 
> Signaling fences has a whole bunch of very strict rules associated with it. E.g. you can't alocate memory for example.
> 
> Are you sure you actually need and want a dma_fence here?

Waiting for potentially a ton of IO synchronously on invalidate
sounds like a bad idea though. Hmm.

>> +
>> +	dma_resv_lock(dmabuf->resv, NULL);
>> +	ctx->dev_ops->unmap(ctx, map);
>> +	dma_resv_unlock(dmabuf->resv);
>> +
>> +	dma_fence_put(&fence->base);
> 
> You should probably set map->fence to NULL after that.

The map is freed two lines below, but I can add it as
a defensive measure.

>> +	percpu_ref_exit(&map->refs);
>> +	kfree(map);

...>> +struct dma_buf_io_map *dma_buf_io_create_map(struct dma_buf_io_ctx *ctx)
>> +{
>> +	struct dma_buf *dmabuf = ctx->dmabuf;
>> +	struct dma_buf_io_map *map;
>> +	long ret;
>> +
>> +retry:
>> +	/*
>> +	 * ->dmabuf_map() will be calling dma_buf_map_attachment(), for which
>> +	 * we'll need to wait for fences. Do a bit nicer and try to wait
>> +	 * without the resv lock first.
>> +	 */
> 
> Clear NAK to that. Always wait while holding the resv lock if you can!
> 
> It is absolutely not beneficial to do this outside of the lock and usually just hides problems instead and prevent fixing them.

Ok

...
>> +	ret = dma_resv_reserve_fences(dmabuf->resv, 1);
>> +	if (WARN_ON_ONCE(ret)) {
>> +		struct dma_fence *fence = &map->fence->base;
>> +
>> +		dma_fence_get(fence);
>> +		percpu_ref_kill(&map->refs);
>> +		dma_fence_wait(fence, false);
>> +		dma_fence_put(fence);
>> +		return;
>> +	}
>> +
>> +	dma_resv_add_fence(dmabuf->resv, &map->fence->base,
>> +			   DMA_RESV_USAGE_KERNEL);
> 
> That sequence is clearly incorrect!
> 
> The fence must be created after dma_resv_reserve_fences(), otherwise you definately have an illegal memory operation here.

I'm not sure what you mean, can you elaborate? I only cared about
pre-allocating it to avoid allocations here. We add / signal the fence
only once, no reuse. The map is going to be killed here, and if we
create a new map, it'll have its own fence.

I can move the dma_fence_init() call here if that makes a difference?

-- 
Pavel Begunkov

