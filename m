Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D663548B37B
	for <nvdimm@lists.linux.dev>; Tue,  4 Aug 2026 17:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785863960; cv=none; b=EM+YFDFEeSxq+3HjexG2fLNN+++EP9MEJkay2aF7ShjuV1Qmpi/uwh+/CR0Mrme/3ykVbujSKhhJMD8UD2YK5+XPwW9NT4GQ6cKJLqoQm5txB8cbgZlehGiaREsSJzMlG60FaFQRpuK/GMeZI+HCi9VxiNdNRMbcj0MQ1GoGmz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785863960; c=relaxed/simple;
	bh=fiynAW9WpUzgt3N4BHN/WeqgVQsTYwv6Egh7edSdGZk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WlbwYLrfsmTvzKqopMJslqFanwXp3E46YDXZXhzySfAbCmd23nvHnVEozJ0Fr2xjmDhfUnqM1IGnejV/DtjvaJLd+KWcDQCrPgD9/6ZoRbo8MEUE7GIbziu3qicxJ7wBmlApKPhkHh5dW4MNdFVH1m3HoCnGaq1sLB61PkpPWvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AGxGwy4d; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AGxGwy4d"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-47f92e3c14bso54061f8f.0
        for <nvdimm@lists.linux.dev>; Tue, 04 Aug 2026 10:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785863949; x=1786468749; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kJpsobbV6cDtzB2hYIU7sj8yXmkuFvAex2Z4hVps0ns=;
        b=AGxGwy4dfrI1cN+ezzNAe+E7ix9SVbKzUWy+ec2YqukczbXL85mSrjwNB8CnqjW2xO
         bvd7n2C9g0/Y615hXolwx62WJye7SiwAkpGdJkORfR4xZbYx9tl4VMHa0wkLHD1LbGBe
         /ik+9bWUG3J+eEaJLAD8CCh3jfPyHNym96dRz3Zanc7D012kJPuMCwOUCWBQdGE9Gxgw
         Ym+sGPCia7l9GDl8iO7Bj/Tx+V76Eskb6UIu4WAT2MmQ49fi9pz/OxSeuKtGqse4f2N4
         gIv8jtV6fy+pc607uQPG7UMm4MO7c3Cy5BVHWbfM83AUfyGsCqEalu/Ogvajp0VJySu1
         YR1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785863949; x=1786468749;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kJpsobbV6cDtzB2hYIU7sj8yXmkuFvAex2Z4hVps0ns=;
        b=qiuWuk2WZe0KkGU1Vz+DJVpptUAgISrKXDSE9QfqoPCODBVyYgl4I2Qb1w/xqQLHnu
         JGwZWlV0XwQvrEPkO8PA44gnKp/esONEI6iDzLQsyUJVd7tNnODqjotDQgez3mYtJp7f
         28O+ushNuwE+O4+VxPe9w/Gb4CHS3LaYNV/Zcgd1fFet2Hp+5Zg+2yevVwwhmnXeLa76
         01VAsZ9UwArFsR0Ixc+uZPeW65nJ9dchC5rUXu/q+OfVBP55/Dk+mTz1Teh1gfdjlrJI
         er+nhOIZlUjtXMO6wvTYNrfaB6+MGK325/ry3OjQczSb73kvl16VAg12hiNmPhNw998J
         8Okg==
X-Forwarded-Encrypted: i=1; AHgh+RpJb/eYM6QLt8+080gyHVSLWO7CLQZ9tVIXygsJ1LwzUwHeRp25TewAwqEgsZgUqkOX8wS49PY=@lists.linux.dev
X-Gm-Message-State: AOJu0YxPf7wGhBZjKBhT9jJBo5urnHKGQyyzDbKHUL+/io23J+44h6Zo
	rlnhYJoMOclnqjPWvs1kPtn7jl9VFE7eoTrWh9hJXQl50ZTV0G5kZ29W
X-Gm-Gg: AR+sD10/jS7rmmO+cC/KONiFQuqQLnQgXaSY8OOZAc9/TFhZhnvwC38whLxScZX/VER
	UNhhXfIzwvZokaCO4gxAbvQQQ3fLbERc0m/zP5b01ekqbUwnCitNFJoADSjsQlZVONN0oKjpb0s
	wcKqdTRfuVBKczm1ZELCAK6QrCfWSi2lK1g4siwfEewryisd+RPfsLvtP1r2ZjqkBplySE7T/yn
	NDY6KgIxkBS9zEhlKf/Kk/7diMjQ3A9nkgITGRWRzUKh0pxNqOMeEAvU9beW3v7MxcmNbY8WUYs
	b9vvHUmtORF+vZyfxAmkhrWzOPY/id3yJE1lRQi/2S8M+2jv+fSLfKhu/70u5SUzL86gAJmcz8V
	YcqSOoje3eZLVG4lf0JWBlriFf6l08JfDAL5wdv/eZ1poGnk24GmIFApIDCu7XozgOnjZv6gy8C
	9cO5TuM/HiMB085qJAjHt/ra4gi+vV/JP4PZgmVlLgjh6aX4d66cFYdTcY6hm9Lqex5fD2AqBf6
	88IMBnnrsVavTZUeVEM85fbDF51tPgMsHf8vpbDXEcDRs1bXWyX6ABe5tizgAWKCfguc7pECjUg
	hp1YCQgQ5+yP5K8vUwT2k3aXN57WSMzDaIov1/g=
X-Received: by 2002:adf:fe49:0:b0:47f:941a:796d with SMTP id ffacd0b85a97d-47fec4fa3admr1381301f8f.12.1785863948785;
        Tue, 04 Aug 2026 10:19:08 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47febfda6afsm1357370f8f.3.2026.08.04.10.19.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2026 10:19:07 -0700 (PDT)
Message-ID: <38163009-770f-4596-abe2-249efc113f59@gmail.com>
Date: Tue, 4 Aug 2026 18:19:02 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/16] block: introduce dma map backed bio type
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Nitesh Shetty <nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>,
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
References: <cover.1785596451.git.asml.silence@gmail.com>
 <e26aefbcb383be7092dc76343ce745013e671334.1785596451.git.asml.silence@gmail.com>
 <20260804162440.GB12292@lst.de>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20260804162440.GB12292@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/4/26 17:24, Christoph Hellwig wrote:
> On Sat, Aug 01, 2026 at 04:46:19PM +0100, Pavel Begunkov wrote:
>> Premapped buffers don't require a generic bio_vec since these have
>> already been dma mapped. Repurpose the bi_io_vec space to strore dmabuf
>> maps as they are mutually exclusive.
>>
>> Suggested-by: Keith Busch <kbusch@kernel.org>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
...>>   
>> +static inline int bio_split_io_at_dmabuf(struct bio *bio,
>> +		const struct queue_limits *lim, unsigned *segs,
>> +		unsigned max_bytes, unsigned len_align_mask,
>> +		unsigned start_align_mask)
>> +{
>> +	unsigned bytes = min(bio->bi_iter.bi_size, max_bytes);
>> +	unsigned seg_shift = bio->bi_dmabuf_map->seg_shift;
>> +	unsigned offset = bio->bi_iter.bi_offset & ((1U << seg_shift) - 1);
>> +
>> +	if ((bio->bi_iter.bi_offset & start_align_mask) ||
>> +	    (bio->bi_iter.bi_size & len_align_mask))
>> +		return -EINVAL;
>> +
>> +	/* single contiguous range into the dma-buf */
>> +	*segs = 1;
>> +
>> +	bytes = min(bytes, ((unsigned)lim->max_segments << seg_shift) - offset);
> 
> I guess ->seg_shift is some sort of encoding of a max
> segment size?

I'll add a comment.

We rather need the minimum segment size, you can always split large
ones. I calculated it even stricter as the least common multiple
pow2 to avoid divs here.

If the device supports N segments and we know that each segment is
at least M bytes, then we should be able to issue IO of size N*M
of full segments. The line above truncates the bio size using
that + offset adjustments.

I guess it might be more straightforward to calculate the worst
case number of segments and then adjust the splitting size, but
since we don't return the number of segments it's more
computations. E.g.

seg_size = 1U << seg_shift;
nsegs = (bio->bi_iter.bi_size + offset + seg_size - 1) / seg_size;

if (nsegs > lim->max_segments) {
	nsegs = lim->max_segments; // unused after the block
	bytes = seg_size * nsegs - offset;
}

-- 
Pavel Begunkov

