Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B19F73FFAA1
	for <nvdimm@lists.linux.dev>; Wed, 29 Jul 2026 10:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785321453; cv=none; b=h4T69Z3mVjoV6STm/uH/nxrmMqZK7TvPPWGq54TM9ZL0fLaehA3il2Qff5Z0bC1cZ8YTBKJ+v5lFGsVbQToVbjJJgl4u1rfK4VLUmZ3SbPmQxvijNDDc9X14YzJFdhxKXnSM4gzu73mBFrag6gX/0JvMLRelP+rCCo8H/PwmDD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785321453; c=relaxed/simple;
	bh=KMDBHWwtyZpTu40an4MnGq08B+PKsj/C5jew5swtPtE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jPtbFwG5JU6T3GwBqC2GKGuS7by4zZVu7QB5+HnhcRqrpDI2Ss/Hl+N7vaBMousDHpfOXvhXGvJzZ2Dt18nNst4IhkDT77sNjaDsVzVf3sKEt/N1CW8SDEhNkFkvqq6cyBQ9ZUHZ/zHg2hcvv29+kyIi8Df6/G/j9z80rsMDfoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lZQ+kMJe; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lZQ+kMJe"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c1712a04ddaso131902566b.2
        for <nvdimm@lists.linux.dev>; Wed, 29 Jul 2026 03:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785321450; x=1785926250; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=p8KbmJYcU1SAlCdU+OP1hBT5okmuW3fRl/0GYAxB+Rg=;
        b=lZQ+kMJeAg6CY46h4VnSr+KJe26e5ll+Y1i9V8CrkY/iq+/LgogBT8JEK0kMQyRqln
         P+i3jxFYmxQ8mlT+gUOkuAYoHltIZg/Ri/AFS8nTAGN84HbQZcfpsYQ8hZWuNKWmj4iZ
         +aUtG+1FYlMKkEPTT5vIuDs3TDkIqOSg8bRDQA5fCgps++VzgZOL7tqial3hYwgQMzQ+
         Q+Fr89hPCPs7Uwv6KMXNIfdK8merzMM70JSCEahtUy85O8NAO4Jdi9BPn5zS5ttrnbUJ
         6zPzaWxtPVb/ERuBlDPiQmO5f9VMQ4GmqIDJm6fEFs2IhgyC7CFRlwkYziIzfJQCa+sQ
         /gsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785321450; x=1785926250;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=p8KbmJYcU1SAlCdU+OP1hBT5okmuW3fRl/0GYAxB+Rg=;
        b=PJXE89gglE99oqgOwrgurZccI6Zo7SWIQwcZevM78mm9aSPM7OYOkhuzKCFHrAILBA
         lQ9qN9Gxk/9xk77O0p9exVRfq8L+H13BHHOo+7uxX/Y+PyP6yHXoOqLoB4hAVyFHkIQn
         DthcNBl4XvknEcanusDZ//yOn+FTS/OlV3yBrjUKYYtknuKd9sxtG/7GKSL0fvypII0+
         ic4RuKotVO5bZO0C+eKN+1784l8tK84qOtSHZuRqvYuOAot4Es5n2SpYGjAhanrWp5ue
         f6V1lH1MHs+/sZMaCIkegLM4WzL2xgfiyeNOprbfvlxPOy9O4BWgqtNOSVJoEC8N5qBf
         jH3g==
X-Forwarded-Encrypted: i=1; AHgh+Rp1wMAVNLhjD4mbyAneRIFRIWZtyLIKDfnOFaNHetSRm1kLxSz0DEm513PddgsuP2405ekQPWA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy3frY6c1mN8yfvIm9upDDIi9bUPgLRjxW+LX/C6vmIsj3P6Kdu
	17Om++lAjhr49Eh/mGqGDvLd07lOfClvT63iQ+i+LOszSWdhxy6xUdTB
X-Gm-Gg: AR+sD102HYezhcMYuEGc6nFoLeMbQOymrlNRCUffsujPocyKkNgf7Ay22MDuiToFBci
	ckX+xOwNGUFmagO/wBpQLITxE8VH6qxDFvtWbE09a3UncD4sL6+9+4/k9XCsPIq4nAZypbNykVt
	cdiyFlYn9mDp4b6mj5BiWQqY0ayO2EKBWN0Sutt9tGsTcjP+li4FLG21yrtM+3LqYV2MNVKv+i6
	tdpFiP0rZQF2hvsS1c+q+JREegparNyZQA4shkWlpu+c7bYFen79MPb8pFxEDH7Cyd5P6DgNzds
	t20yxcq36GaPJamtR6CBewxa5a17lCoR0VUAGpleCWLtew2gnaXDHgdB94xRjC50uBT/xhPc8Q/
	l/AJYzfFClS58B7uTyeKw9cPpWel4u7jTiFJNi6u/UX2LhBXbD9mMmO8RtQKXRxtL/46ExIeyw0
	N2bx0FFPdXIdK1vo0hwjRSDXCERppOw/6+9bXMhd59klWg9GlXWe9GRE/UmZb1OrwXDhQRKokzS
	zrG9aIWtul0NEHcEHe75p4XRr5ax0f3mr+dxTSSSS/cMjAMk18lkN+BM/t49/i62ghR7cR8tiJe
	OBbqeoXi0JpUltErv94=
X-Received: by 2002:a17:907:9617:b0:c1c:62b4:1ebf with SMTP id a640c23a62f3a-c1f721913ddmr365145166b.60.1785321449861;
        Wed, 29 Jul 2026 03:37:29 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:640])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1f84026c47sm93918766b.63.2026.07.29.03.37.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2026 03:37:28 -0700 (PDT)
Message-ID: <340dd033-2a45-49e7-afd6-95dbbbf624da@gmail.com>
Date: Wed, 29 Jul 2026 11:37:19 +0100
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
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20260729065927.GA9534@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/29/26 07:59, Christoph Hellwig wrote:
> The method name feels a bit convoluted, but given all the
> previous discussions I don't care too strongly.  I'll leave
> the dma-buf side review to those who understand it.

I assume you mean this:

+	int (*init_dma_buf_io_ctx)(struct file *, struct dma_buf_io_ctx *);

I agree, and all dma_buf_io_[ctx,map] look clunky, but I don't
see what I can drop out of the name. Suggestions? Maybe I at least
should make the fs op sth like "register_dma_buf".

-- 
Pavel Begunkov

