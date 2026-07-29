Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5825048D87D
	for <nvdimm@lists.linux.dev>; Wed, 29 Jul 2026 13:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785332366; cv=none; b=J4lUoqxZI/cFrrXMzdBtjan0I3dUUWfMb8hSjsxORQqnjBFWeUxDZxTQwLP566LxMAOc9xk1K8kVb7LZjzKdHAazKoGNqvHLYLw4LAbJ4uchUNF/ZKafaozBKJhv3t7y4o4LWORRQwYF3AnFV8F+YdeLwOB+E8xIBkBObos7pws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785332366; c=relaxed/simple;
	bh=uY3sUepmqssMOr1jNQvyXWE6qqQrkaRqI5lsNd3E8OM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UXewnyWWKN1md3OJnrfVHTyXUCrw/k6Uztju6QjVbUumUTkeRAw3vsxpzn24EYxHvwpnVd0f73LlpKwa8a2ehWc/WM8Np7zlumQ/3EPE7gI/Gyom6NHC3/mkGIEmA2AWtQdJWpzGvrjSc9jKPvnsIZWuN0FyquzNPedZrpFQ9I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F33epD4L; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F33epD4L"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c15ba3a2b4bso116088866b.1
        for <nvdimm@lists.linux.dev>; Wed, 29 Jul 2026 06:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785332352; x=1785937152; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3aN3udKBcENjBD5UHxw3XhgPgHCGso1JhkYTFHwhTGI=;
        b=F33epD4LNjiDIwVPeq09mkFTLFZr7jTseFK+/hIVUR7hEdhXylwIIaAXO03Hse5uu5
         yYg809eoSjZR+x1jBNqtnU4Gs2In3YUCmwOx7IW7wdxYrSadf4h6/F5F40VLMwz17VkI
         +qhmtNSLODQpc451OeG0GDEQjfZTxT+RSjuNYhxz32/uIPTfu6RB30mIqldEw9XJcl4Y
         YGGG9EeLVnMC8CfTqUccVpiGRIBr7dJ4bZ4AOgQoIx3NqvyL/D+OGfDZ4GzpYwqJULRV
         vuZOWaOQZZf8nwXq2RpFOV2mPCNWHwiqp08hOebzwupF3hbZ1rbroISxTUiTdy/DpQPe
         PgkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785332352; x=1785937152;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3aN3udKBcENjBD5UHxw3XhgPgHCGso1JhkYTFHwhTGI=;
        b=WdEZFEnLZu8t7T7Nbr23PEknqaZTwS+rCr0/B5MPQKLvYIyXoIGYA9/pGtpUFWsTE0
         JZQqutwMFU7PjgjLjnZXO3zPQs350CvoKakByl5bpGIA0TQgvI4W3DG6eb/HY8p/gr8/
         mfXv15bmq6YyGGbrPtSPDylI6SgFGWrVQzZY5QOklLgFFJbkiUCJvpOfOK85dbjzDfq+
         MdbU4wSnzfMDd7gGQ/NGJExnVEyL40xlUKw04cG39eVG+iQeYKy72GyLLO+SOGQuzsg3
         oYuHKqcNBAqDIcO/cRj2slZ/pkzTFWzdBfbWXluqbCB/uDDt0SFHsge2xb6A/pU2WceZ
         UqDQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro9fgaXppIDufshqxKXUXlau/mJZkYYyzXvDvj1bPKLE+Vnp/Rl4RSwIjqyAQ+A/V2AaOKMKEM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxyxat7oGdehDqaaxHxcN0tjr0pL+0aJUJ868pHL8acA5XwzhiY
	eEbJnePDee035USQETHZqRrwwIjHQ3dB7SM4USrWaZio/ekQxLEv4fyb
X-Gm-Gg: AR+sD12VV2Gt7RMje3DF+pua60qvQAfsqISo0sHRLbZ4QDh5OCvVimDcPe0N0b6juMm
	FchQJNvjIrQWUuTT8U/PRX+7omuBuSoJlcHRs0ku7fdDRpKd1gNx4xmd+7l8l3Ik94qeuup9uIp
	P0CR31A4lHuyRAA9K2uXQRXiksj1wJ/tWaTWv5RO28QUXQ7fCUwyDEXdHH65WaAg/OZYGaTZ00M
	e4wGqOJ9UIpPLdwzOvMDWd1y9+XSk9P/3HoL2kSEbtgWxzDKynuQqu7NmkfitlSHk/GMuGEi9iO
	vFBEk3JHYZ73kLX85kfVt4NCkKGH9FJAZ/yMMSA+i54H42IwMlmfMKlZLhKoabCwhV0UyA56AY/
	sqTG0BNRse9ctstoo7EKPAeL5xgrmkqJ95qM+m/iUYYyIdEy7h299/ZSXS2lAVDQF/H7JIUQflf
	9R2VXjnRLLzPdbmcsDKolB4oZMnmAMManKOUE1Go3VkT8SUZQ+GhDcFA5yjn/YKrCsVhfqJlHyf
	60cqgueE4ue+JMoqpnpmzgBkHLYs7PiN6CPMM1Y7ddsYIb77D3cBdh7DkDFTPGa72zvOnADFa33
	fh9EKrLUrgHIh20G5Xo=
X-Received: by 2002:a17:906:f598:b0:c16:7b66:4932 with SMTP id a640c23a62f3a-c1f721bf58emr374209166b.64.1785332351629;
        Wed, 29 Jul 2026 06:39:11 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:640])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1f83f4de5bsm118685466b.29.2026.07.29.06.39.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2026 06:39:10 -0700 (PDT)
Message-ID: <dc72d46b-7b45-4beb-8e36-d810d2a94c28@gmail.com>
Date: Wed, 29 Jul 2026 14:39:01 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 11/14] io_uring/rsrc: extend buffer update
To: Anuj Gupta/Anuj Gupta <anuj20.g@samsung.com>, Jens Axboe
 <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Nitesh Shetty <nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Damien Le Moal <dlemoal@kernel.org>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>, David Sterba <dsterba@suse.com>,
 Ilya Dryomov <idryomov@gmail.com>, dm-devel@lists.linux.dev,
 nvdimm@lists.linux.dev, linux-btrfs@vger.kernel.org,
 ceph-devel@vger.kernel.org
References: <cover.1785274111.git.asml.silence@gmail.com>
 <CGME20260728213008epcas5p418dfc10b7ef786e162ade86d14430475@epcas5p4.samsung.com>
 <633d33d8e278999f55126794fce948343403494a.1785274111.git.asml.silence@gmail.com>
 <73317bf9-f7df-43f9-abc2-daa25a675485@samsung.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <73317bf9-f7df-43f9-abc2-daa25a675485@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/29/26 14:31, Anuj Gupta/Anuj Gupta wrote:
> On 7/29/2026 2:59 AM, Pavel Begunkov wrote:
>> @@ -882,8 +894,13 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
>>    	struct io_imu_folio_data data;
>>    	bool coalesced = false;
>>    
>> -	if (!uaddr) {
>> -		if (size)
>> +	if (desc->type >= __IO_REGBUF_TYPE_MAX)
>> +		return ERR_PTR(-EINVAL);
>> +	if (!mem_is_zero(&desc->__resv, sizeof(desc->__resv)))
>> +		return ERR_PTR(-EINVAL);
> 
> desc->flags  isn't validated here, unlike __resv. nonzero flags should
> be rejected too?

good catch

-- 
Pavel Begunkov

