Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7237C3D8906
	for <nvdimm@lists.linux.dev>; Wed, 29 Jul 2026 13:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785330693; cv=none; b=JeYGjBPpkd5k2Kold+ta7pG3AKOSXpH3oMQNFt37GBSBd6NjQnKr3BVQNRYauCBTx1Krq2qxIOwXnV+odILL+3zoLuFMr3uCpcUNLNsVIXdE0JeGEECBOXgVEqiR5Tg1aA689rOMsRgglnmha+fUiXABgEV6rpUzOttzm1ZP7UA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785330693; c=relaxed/simple;
	bh=iCKby9e1qhvE8ns2sICVS+CCbRWmXfOjz3bB7l8ahOg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SHH13oW/JYlPRPwIp2gZ1ZJK48JRYN45pWc6O1l6c+Brk4zyuil8C2USDWYqrlS6Bl4vER4LXX0k8kR+37CJxqIgbdaQHXw+v88fUkZAiuaQV6cnDugQ8a9EJ3O5HnpvLb/bjYww7CayVRLYDO8rDKPqSt7igK16lH3DTsVHuhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pZrLflBw; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pZrLflBw"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-496bb7cdf51so9691055e9.2
        for <nvdimm@lists.linux.dev>; Wed, 29 Jul 2026 06:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785330690; x=1785935490; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QlPatibx3g8XfK6S5eprVRseiFbSJCNNQ3hXCye36cc=;
        b=pZrLflBwuBYmiDCpBsPNEewBKqXo8EIbrPYHFKsMY9HSjUyHT1XiHxQC0+0OqqnsHU
         SIeNOO9nVgH2NYZwO2A2QQm0ABRet2h6AJ1zE959cGfaHD0b98E7AmPHBVMZL9WRaEpz
         Q2uROfuM70a8+Irgu48ZC6G5BGaPcJh9gnvR5LhUzd4YKwF55XZgYZGOU7WSmT2p0V7e
         5Fv3Co2ZtCCGNmO4yGu/9AvxzpAqSyMJKoqTCx5spuHTftQHX8lUM4U1KpKifsKR0hmP
         hDgl7+KnpWOjUfeflsU50TKoHEKOfrpKhcrq2ixa/FcYcQRYdO2rISIrckN2AbgVfOTS
         /HaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785330690; x=1785935490;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QlPatibx3g8XfK6S5eprVRseiFbSJCNNQ3hXCye36cc=;
        b=mmv8/0euw+ygFbabPSCcw7fz+MSNC38GAY0vTxAD3KtkQtUkEkvZ3NVDQroofOMaVw
         H8VK5FKAPxZJUyZy9CLdIxzsGMj4953lvfnUu+GGkuLcmOWsShPuG8wyonbjWzU//L0J
         wqbwSCoxFOchiatjAo2SQWwAoH2OGuZ6t8ACqkKFRoxKvRbQQ4e0YpYyftG9j2noUxse
         ZqrbFn88fF0g4gNpatqswcmaobKy0jwQHF5HpZ652It/sA+o07HnzjUze7d5eietq5gD
         TLo7DSE8CLXqfNpYJkxUCYKafanjUin85fzgTr5/4vmnGfhxHzK3RRFX2PXjGbfRC9F4
         4TkA==
X-Forwarded-Encrypted: i=1; AHgh+Rp7eqb0jM4VIpc48a6Qb4lhccCqedPT0bFkCcMAFIzkUSKhtkk08OQlukINBhM/Cn0zy63JFN0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxXzdchn2hEH6xEMyHLE5dOAytZK+55IYycbixzjnNUNZS0JskI
	mQJ6QLEG/9Chg+XQbEMsjtVU8uLVkS/kQfBymZFpv+vj735k5vKlXUh9
X-Gm-Gg: AR+sD1066mnjkdBcFtQPQB7w9XR6bODiuygJGPRTMGpfpX7s/43oC97gTzm07Tc90FZ
	Xc44+smO6+tTxjtw+hgRwJ1ysWhni4jCVDx1aa5wUtLNhEMOnqHcesp3DN+WMPunahWSMmeakAC
	eI39L6Yg+yrx699IhwEehzqYGK9bsz9TKE5ro/S5pVt1WMs2F8ZinIntnmaZc6ROrdBTj8Jx9zJ
	oyDdyZ70AIDgpjZP4zHrcmQTlw6yHo0F2/VdJmz5j49GNKoZhkhSkYcP1Kk39QNpn/VNM8tNjiK
	ahgPYmLbaL9s3sD6DtucuCYyPeHZLwj1UOBiHahDpYuy9cu0U381KpLKd7syGUMm+L2ZH5x4jZX
	G/BGWsw8AXGYYa38N7SEq3HYqwaG2srwQu1xJOAXSzN2L9lvgxg2pkX4kCrlUv7rsJrvY8yog4w
	6elKzUSEIjuM97AhoTAQjYxa+3M3GVwbbY3nLNQpx3i+cRMQd2bualjKAQLf0ud9T5ie17JAHQq
	TF8NnAy81nHsxEhDnbcwC3LX36q+Vo4yjMefGeryZUlYvbDeXV5LwYX04xmNLH0KLkZtHd/cM2A
	XorbfTcEB5AdVDLMznA=
X-Received: by 2002:a05:600c:3485:b0:493:b243:8ffc with SMTP id 5b1f17b1804b1-496c6586bbcmr69846215e9.35.1785330689440;
        Wed, 29 Jul 2026 06:11:29 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:640])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496c45c338fsm157280305e9.8.2026.07.29.06.11.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2026 06:11:28 -0700 (PDT)
Message-ID: <60df6af0-3bf0-4954-8181-a0acca7c21c4@gmail.com>
Date: Wed, 29 Jul 2026 14:11:16 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/14] dma-buf: introduce initial file I/O
 infrastructure
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
 <bc20381e8daf85ac58811c344325d8192cde9d1e.1785274111.git.asml.silence@gmail.com>
 <20260729065927.GA9534@lst.de>
 <340dd033-2a45-49e7-afd6-95dbbbf624da@gmail.com>
 <20260729112808.GA30851@lst.de>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20260729112808.GA30851@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/29/26 12:28, Christoph Hellwig wrote:
> On Wed, Jul 29, 2026 at 11:37:19AM +0100, Pavel Begunkov wrote:
>> On 7/29/26 07:59, Christoph Hellwig wrote:
>>> The method name feels a bit convoluted, but given all the
>>> previous discussions I don't care too strongly.  I'll leave
>>> the dma-buf side review to those who understand it.
>>
>> I assume you mean this:
> 
> Yes.
> 
>>
>> +	int (*init_dma_buf_io_ctx)(struct file *, struct dma_buf_io_ctx *);
>>
>> I agree, and all dma_buf_io_[ctx,map] look clunky, but I don't
>> see what I can drop out of the name. Suggestions? Maybe I at least
>> should make the fs op sth like "register_dma_buf".
> 
> I just remember scares from the last discussion :)
> 
> register_dma_buf sounds fine to be, but unless I misremember there
> were objections to that before.
I'm going to respin the set in a couple of days, just going to
leave it as is unless we find better options.

-- 
Pavel Begunkov

