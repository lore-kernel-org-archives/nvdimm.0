Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2A93AFD16
	for <nvdimm@lists.linux.dev>; Wed, 29 Jul 2026 11:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785323043; cv=none; b=bj/fTbAPDdtJP9UzvzGf4PBEgC7DE/M8IAy3bepYbMVjlIjMF4/6nxMR4FWrYrRivFcSnAXpBQjkt+ql52og9zDtooh5Qt4lMqkMiF1EwezaI2uupkuE5vgGYBARNozQvHincimnFd5+3Oml0hJ2fo9WgM6SVkNZRb+eg5fs1cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785323043; c=relaxed/simple;
	bh=udEcdzuH9IWqf5RctvY9uv48hr6A/o6aMv5KW839on8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sS1Xch6LB+28IfRyWQ8M1wb8Gj0GKSZ+BVQcq0/OvnHhWA+3GjG/oJb9zO2oaqUrsAgKfQHOGWE7/bE8Sns5x9XJHY1aLHASjPFdEcY7kkwG/GNCla7+EkSrK3XG9/+Yts6ORfKuMiDU2vi3/rYp3Kkt1EXY4jJd0mMG8bgGrkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iABWSSU/; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iABWSSU/"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c197f968b3cso120770966b.2
        for <nvdimm@lists.linux.dev>; Wed, 29 Jul 2026 04:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785323038; x=1785927838; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vraWe+r+JAvmwr9JBnRk+mSRMk+dBSFMePa2l4q/GaQ=;
        b=iABWSSU/REP1yFA6OjBjdXSu8QWrj58W4sMQEglZxHljfQTAxd9vqY69mKIu4IxA5X
         tYFEqZw5wb4XNgewuHwjD1lrmvyvMlz3wREW1s3BoRz2xoF+gVjMB7/5EThXz2yzTt8+
         LRk05G4xvU3vUnmdSmMwI8QQEl8GGPfRIxIt6NE3DwfTI4IuAs5tDhcMRp9XrTqCOSjb
         03WAMlyzrfdlAmELn2/6Bo6ACTXeprC2mooeybeRTS9ND5XsLlw0ZK4EJwchImpsjFag
         Fvp0p1BSgAcSoIA6tK8zEUvuPU3NmGhmzd/xGa5xW9IPA+a//cXRdgxPsR5SHKDuuusc
         J2CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785323038; x=1785927838;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vraWe+r+JAvmwr9JBnRk+mSRMk+dBSFMePa2l4q/GaQ=;
        b=cdmdLOzjl/iBrAwG7pclnZDxEbSynux3Na57/N1Qh9uwpvdY41gLtGG0pPnGLT7HQd
         3QtAEQiGtX+whZBqFvz15YzxY/weVSb1x6Nn/AUHpk63IyANv+9jP6+o5bgrv04/NdRR
         4xI+/S/ycRGOC1LEXK3pRQyAzV0wJxECYaBADkJajGl/QiEL6qfieUUXnUPwK8tfufLk
         xCbBqBcx1lsyyV7YoGthoxnxSoZKhIGKy/ESBvhuRelvrSl+8CheCcY130+7bVtFERNJ
         kHJ1Thzl+4y3dVQr7WNYVG9wOX8zIsw3ilYI1/zSYMospv4Q7pwRUqIPH5tj7sh+G8m1
         0mKA==
X-Forwarded-Encrypted: i=1; AHgh+RphSlKT/FHjhB2aGwKphVDLJ4Notb9w9M7kO8e0zxpNIlIyou4hURCgERVugKwjBlokP1Wabys=@lists.linux.dev
X-Gm-Message-State: AOJu0YxyHbVLB5f8NEpJsePLpQqw6B2xDDl54qo3RxWuPGOVJIAWbO44
	PR8qQqnpPh8zYx49/LP7K8G8UfG0n5czMJ+Im2rzkMGIKivl8Px3o3HZ
X-Gm-Gg: AR+sD12vJzkvkre1ztuW4jjiGG1d5c6FYHMJivNI7RBCNj1yMBVM78gF2/3sJ8Z91uZ
	wd/V1jz9FJTmTusgtgd5taeUO/Aua47HYOGiaTxlRmLUZ58mTkHBONoXimZwLRucxvvCLrfNbM/
	zMz6Bf0e98kf13gQgISGwyvUIYFzOgXmXb7hf2oz05xEIlvDLCjRDTa9vVy+kh2SzBKSWoVN3/0
	5rZXWmOhThbBHxE09rStLXhpyIRALo/e9+Sz12n5m2Ai0twcEqbHQvr4EKcPaOHjOeMJ9y3QQNP
	EssI5j7Nn90H0/meaOhj/qfz0MXVIp2oTpKihJGmPiRsTTKL827s7q2m2h3+EJcs9wfnS8NpBEy
	ZTeW/mX3YUZb0NcI+8f3DOxOAYjS09WYJV8Ra518nJTak2JNbQgyJl9JksghOCHrBD0epupYn16
	/yt5QtSqFncsavFumzndKp9dtLB0FgdQJPBKx6I/WKa8/3gnDtrZS1mbKwVZ+YWac2xsD25NGDD
	rGY2KvRpglxN+M7Lzm22+aeNkisUUy2tYhovYQJuc6Mw1zgdRoFnWePsAgN2rWsV6K8GgvkSmFb
	/fkma2FFVCPdkNP4FVM=
X-Received: by 2002:a17:907:5c5:b0:c12:8cbe:b897 with SMTP id a640c23a62f3a-c1f7209f906mr333725866b.15.1785323037380;
        Wed, 29 Jul 2026 04:03:57 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:640])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1f83c6858asm99322666b.10.2026.07.29.04.03.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2026 04:03:56 -0700 (PDT)
Message-ID: <e3dff1e5-8b66-49d7-9a47-88a9d26c5c10@gmail.com>
Date: Wed, 29 Jul 2026 12:03:46 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/14] block: introduce dma map backed bio type
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
References: <cover.1785274111.git.asml.silence@gmail.com>
 <f97985ac5cfff3d9f7777b93f11456af57e253e2.1785274111.git.asml.silence@gmail.com>
 <20260729070727.GF9534@lst.de>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20260729070727.GF9534@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/29/26 08:07, Christoph Hellwig wrote:
>> -	bio->bi_io_vec = bio_src->bi_io_vec;
>> +
>> +	if (op_is_dmabuf(bio->bi_opf)) {
>> +		bio->bi_dmabuf_map = bio_src->bi_dmabuf_map;
>> +	} else {
>> +		bio->bi_io_vec = bio_src->bi_io_vec;
>> +	}
> 
> No need for the braces.  

Got it,

But given that these are the fields why
> even bother doing both sides and not rely on the union?

Compiles into the same, but comparing to a comment makes
the compiler to check it for us if anything happens.

Noticed static_assert() below, that works as well, though I
think the current version is nicer b/c it preserves assignment
types for the compiler. Strict aliasing is obviously not a
thing, so don't have a strong opinion.

>> +void bio_dmabuf_map_set(struct bio *bio, struct iov_iter *iter)
>> +{
>> +	WARN_ON_ONCE(bio->bi_max_vecs);
>> +
>> +	bio->bi_dmabuf_map = iter->dmabuf_map;
>> +	bio->bi_vcnt = 0;
>> +	bio->bi_iter.bi_offset = iter->iov_offset;
>> +	bio->bi_iter.bi_size = iov_iter_count(iter);
>> +	bio->bi_opf |= REQ_NOMERGE | REQ_DMABUF;
> 
> This seems to be largely copied from bio_iov_bvec_set, but misses
> the REQ_CLONE there that we should probably set as well to indicate
> that the data descriptor is not owned (although not setting it is
> not really a bug).
> 
> What about merging these two into a single and easier to use interface
> like this:

No opinion on this, I can add it, probably as another prep patch.


> diff --git a/block/bio.c b/block/bio.c
> index cc2bb9183c1a..25393bdd119d 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -860,12 +860,9 @@ static int __bio_clone(struct bio *bio, struct bio *bio_src, gfp_t gfp)
>   	bio->bi_write_hint = bio_src->bi_write_hint;
>   	bio->bi_write_stream = bio_src->bi_write_stream;
>   	bio->bi_iter = bio_src->bi_iter;
> -
> -	if (op_is_dmabuf(bio->bi_opf)) {
> -		bio->bi_dmabuf_map = bio_src->bi_dmabuf_map;
> -	} else {
> -		bio->bi_io_vec = bio_src->bi_io_vec;
> -	}
> +	static_assert(offsetof(struct bio, bi_io_vec) ==
> +		      offsetof(struct bio, bi_dmabuf_map));
> +	bio->bi_io_vec = bio_src->bi_io_vec;
>   
>   	if (bio->bi_bdev) {
>   		if (bio->bi_bdev == bio_src->bi_bdev &&
> @@ -1186,26 +1183,21 @@ void __bio_release_pages(struct bio *bio, bool mark_dirty)
>   }
>   EXPORT_SYMBOL_GPL(__bio_release_pages);
>   
> -void bio_iov_bvec_set(struct bio *bio, const struct iov_iter *iter)
> +bool bio_iov_iter_set(struct bio *bio, const struct iov_iter *iter)
>   {
>   	WARN_ON_ONCE(bio->bi_max_vecs);
>   
> +	if (!iov_iter_is_bvec(iter) && !iov_iter_is_dmabuf_map(iter))
> +		return false;
> +
>   	bio->bi_io_vec = (struct bio_vec *)iter->bvec;
>   	bio->bi_iter.bi_idx = 0;
>   	bio->bi_iter.bi_offset = iter->iov_offset;
>   	bio->bi_iter.bi_size = iov_iter_count(iter);
>   	bio_set_flag(bio, BIO_CLONED);
> -}
> -
> -void bio_dmabuf_map_set(struct bio *bio, struct iov_iter *iter)
> -{
> -	WARN_ON_ONCE(bio->bi_max_vecs);
> -
> -	bio->bi_dmabuf_map = iter->dmabuf_map;
> -	bio->bi_vcnt = 0;
> -	bio->bi_iter.bi_offset = iter->iov_offset;
> -	bio->bi_iter.bi_size = iov_iter_count(iter);
> -	bio->bi_opf |= REQ_NOMERGE | REQ_DMABUF;
> +	if (iov_iter_is_dmabuf_map(iter))
> +		bio->bi_opf |= REQ_NOMERGE | REQ_DMABUF;
> +	return true;
>   }
>   
>   /*
> @@ -1265,13 +1257,7 @@ int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter,
>   	if (WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED)))
>   		return -EIO;
>   
> -	if (iov_iter_is_bvec(iter)) {
> -		bio_iov_bvec_set(bio, iter);
> -		iov_iter_advance(iter, bio->bi_iter.bi_size);
> -		return 0;
> -	}
> -	if (iov_iter_is_dmabuf_map(iter)) {
> -		bio_dmabuf_map_set(bio, iter);
> +	if (bio_iov_iter_set(bio, iter)) {
>   		iov_iter_advance(iter, bio->bi_iter.bi_size);
>   		return 0;
>   	}
> diff --git a/block/blk-map.c b/block/blk-map.c
> index d1d6bbe0ecf1..34816e6e64de 100644
> --- a/block/blk-map.c
> +++ b/block/blk-map.c
> @@ -473,7 +473,7 @@ static int blk_rq_map_user_bvec(struct request *rq, const struct iov_iter *iter)
>   	bio = blk_rq_map_bio_alloc(rq, 0, GFP_KERNEL);
>   	if (!bio)
>   		return -ENOMEM;
> -	bio_iov_bvec_set(bio, iter);
> +	bio_iov_iter_set(bio, iter);
>   
>   	ret = blk_rq_append_bio(rq, bio);
>   	if (ret)
> diff --git a/block/fops.c b/block/fops.c
> index d83cdbab65a6..97fb124a19b2 100644
> --- a/block/fops.c
> +++ b/block/fops.c
> @@ -340,17 +340,12 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
>   	bio->bi_end_io = blkdev_bio_end_io_async;
>   	bio->bi_ioprio = iocb->ki_ioprio;
>   
> -	if (iov_iter_is_bvec(iter)) {
> -		/*
> -		 * Users don't rely on the iterator being in any particular
> -		 * state for async I/O returning -EIOCBQUEUED, hence we can
> -		 * avoid expensive iov_iter_advance(). Bypass
> -		 * bio_iov_iter_get_pages() and set the bvec directly.
> -		 */
> -		bio_iov_bvec_set(bio, iter);
> -	} else if (iov_iter_is_dmabuf_map(iter)) {
> -		bio_dmabuf_map_set(bio, iter);
> -	} else {
> +	/*
> +	 * Users don't rely on the iterator being in any particular state for
> +	 * async I/O returning -EIOCBQUEUED, hence we can avoid the expensive
> +	 * iov_iter_advance() if we could set the bvec/dmabuf directly.
> +	 */
> +	if (!bio_iov_iter_set(bio, iter)) {
>   		ret = blkdev_iov_iter_get_pages(bio, iter, bdev);
>   		if (unlikely(ret))
>   			goto out_bio_put;
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index c053e9444514..1eff02a843ef 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -484,8 +484,7 @@ int bdev_rw_virt(struct block_device *bdev, sector_t sector, void *data,
>   int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter,
>   		unsigned len_align_mask);
>   
> -void bio_iov_bvec_set(struct bio *bio, const struct iov_iter *iter);
> -void bio_dmabuf_map_set(struct bio *bio, struct iov_iter *iter);
> +bool bio_iov_iter_set(struct bio *bio, const struct iov_iter *iter);
>   void __bio_release_pages(struct bio *bio, bool mark_dirty);
>   extern void bio_set_pages_dirty(struct bio *bio);
>   extern void bio_check_pages_dirty(struct bio *bio);

-- 
Pavel Begunkov

