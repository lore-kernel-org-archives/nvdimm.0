Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACFDD44C4F8
	for <nvdimm@lists.linux.dev>; Wed, 29 Jul 2026 10:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785322194; cv=none; b=agV7ZDmbGQUUOtpnDm3qObDEOEskCRuJ2t0NCqvvEhH5XSmsHA9cxsiF6Dz4wq1qgtjLbWjJABFGJ+BmWPYdXopAlJxtJDFo+pT5PebxXGw6rwA+YxEOs6NSLLodwjWkypZIwBAl7uKcBtxCEnUp+y3JoxoVxxO2LnAf9QU6+JY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785322194; c=relaxed/simple;
	bh=iNi2nFSA8g81W+/HnLXlWmnLlyUILEZvQTRGox6oYII=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E6SKdm/HWhATrdJZax/lFdBKCwa1NRKGKV6/kTef0RcOSK2TZuMS/rCOFhu+qUIPIx99zI0EvaxLnVIksSk18gi25FypFzXIb3NzPmzUejM7RAbg6sTiTY06TMhNbe3xI1Rqq956gxNMjo6Dp6Hofv4FNxl78LymU70oZ23lxnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bpMvpbHM; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bpMvpbHM"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c1c52d920b8so113189666b.2
        for <nvdimm@lists.linux.dev>; Wed, 29 Jul 2026 03:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785322187; x=1785926987; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3xVEH4RvIZup14rRYV4Zvxl83sd+HTGGj/jXhd9ySH0=;
        b=bpMvpbHM6fIQJk+mT29b3RgODD8UAO/tpKWP5yO5Ilp4ptxEI8jD5JjahXJuY86W8r
         f5FjNuRnHvLQOL7taH+ocux7Egv2XWjza0kqUq2Ptnb+PhtVmfhBvA+KKmS2gyFvxK7f
         u7B42cWpp3OISibLPXxH3HbY4Pn+qxC0+xrkJm6U5r2n8ScxzM5Y3ae/BZmrOcDyawpH
         wvxsW4qV5uLo7OfyBR4Fe6W1/7d6gkNFZW9DwqV46l+ckYRFTaLBMtGH1o6xjSlTx/w+
         yywY8PgUw2fuaO9LV96bIsypiIInHVR0X6XBy+KclvGvn2IfKs1WArFwTAYQwSKmbXH5
         fA/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785322187; x=1785926987;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3xVEH4RvIZup14rRYV4Zvxl83sd+HTGGj/jXhd9ySH0=;
        b=bKGVfiFUVQns41Eoahn1eH/jCSYcFWvAhz7GNWhfQ5eLfnNqUdveCP2VMvNfZx96lI
         6LFFvukum3pRJpqmHxnrz7lOjpeJ1Dm+h2LyBIzaboB00ooSMPbUdIeQt1M96S9URTBq
         gcrgQ8thsYxzVwN3MnHcIHrLpcEyYTiCwGdEkrHnPwQOjEwqS2nkPO37mY1ozanabPJk
         iFAkEs0UTYZ70rqbefqEXWTZJH6mBg6HN7u2UcLpkxRst06zwrV7hh57w7FQrQHQlh3Z
         5ffXnldQplz37md/Z/2z2GbvKSWhI+dkp4KfUaY0ord3repcJ0QEZSCh1hSFL83zlwQC
         TNGw==
X-Forwarded-Encrypted: i=1; AHgh+RoVtFyJt05UtBpUlTONmUQaCfBxslQWfjOW7xUysDkqAPQFM4EWiSRxVWj8gDfJA2iZ2oDooTo=@lists.linux.dev
X-Gm-Message-State: AOJu0YyAVzYYjWXyuEIBfKyo9mjBlv/VpQU26noZOKkaz0+LxtEBa/Hc
	CkLjwbKf7+TAGGlYATVqDbuIZ2Mm3SI0cnziZ4yNd3+qAovbUEA6HAxt
X-Gm-Gg: AR+sD10ejotnyegV3KaYYSJac3sbYjEwd0O4KmwWEkgy6xuYdkYPwR5jGexkdG26bfR
	g5CNEWmabwzpx6SL4cW5YdqxgJQ602fXMZ8ZJOLzEj2j9F4ITrFbZ1LO1T+OlZ35bqpxH+7BlCB
	atgITIpSNu7mbOPrBBtv5xpbVNxZ5riXSC2l7CBC301Cd8k1t9yAM0wqSWEsbeZnB2S7GYXOmQm
	Xw3x0fE8dftoBkd2mhRWfG+gQTsjnnIbKzS7Mn6H3HxbsMqm+eX0VYdK8zA1MexJEamYhY9okJa
	SqdLYAJdQapAoqSMVJ1bBmYHTiSxyX8SG1wqpGERzIpbNmwlYkbrp4UGnQ/UbjeQC99TFKtN2uo
	iZG1c5apv57gQsHRiMP96nPm77jdEEeKqevxUIuNoxkGiVkdphmzu7o6IeoR3qKJrSOHo92lSJr
	9H/yfxWvk3/WcHFruaUbbxIGK8u2Km9EPmk030ToOzOchSHc5wxSFgFyqv+qbWtO59PgIeGjwI4
	0l48tAUF5q3wjAwTnnx6zxbQdxt2PC4MGM6UXSs8nLXZjwbMXvF0+Diu9FC+W2xGaZysZ8z30vE
	/xw1wpgN1oI6O/vG3nNcYP8/aYg4EA==
X-Received: by 2002:a17:906:fe47:b0:c15:bea2:d209 with SMTP id a640c23a62f3a-c1f7215dee1mr299738366b.4.1785322187169;
        Wed, 29 Jul 2026 03:49:47 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:640])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1f83d27f47sm97965566b.26.2026.07.29.03.49.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2026 03:49:46 -0700 (PDT)
Message-ID: <c81be43c-2fe3-4403-b8a9-dd19855eeb58@gmail.com>
Date: Wed, 29 Jul 2026 11:49:36 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 08/14] nvme-pci: implement dma_token backed requests
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
 <19e5c945ea8114320c10f7951d19197d48b59249.1785274111.git.asml.silence@gmail.com>
 <20260729071048.GH9534@lst.de>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20260729071048.GH9534@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/29/26 08:10, Christoph Hellwig wrote:
>> +static int nvme_init_dma_buf_io_ctx(struct block_device *bdev,
>> +				    struct dma_buf_io_ctx *ctx)
> 
> Please stick to two-tab indents for function declaration continuation
> for the nvme code to keep the code easy to maintain.
> 
>> +#if defined(CONFIG_DMA_SHARED_BUFFER)
> 
> This should be good old #ifdef.  Same in a few other places over
> the series.

Going to apply both for v5, thanks.

> Modulo these minor nits the patch looks good.

-- 
Pavel Begunkov

