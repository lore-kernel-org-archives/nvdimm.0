Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03FAC43CE61
	for <nvdimm@lists.linux.dev>; Tue,  4 Aug 2026 08:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785832928; cv=none; b=H/Dqj4HMHOLDdaMeT/XlV+DPB1FYrTVBnlMOXa+WnMmBqIegtj+3IbYBROm1PpH5Hw+kDJxAkes7nF/rZU5XD2NUhrKRMD0sdfoEsShsk1w/tLk5Cqilh5xmUmuZMAawJV1sbvgmNCd70CJZRtfYOzE9C9+4lOpynpeYf4eebDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785832928; c=relaxed/simple;
	bh=SD2jpuPrRshOPjZPDhOULtKF/IyS30DOHYKRJQ1eYRs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dByDcOCCtsKdQiy4BGPsEQaflsMRCJ0Fzje4oK3bQz6OJ4tK3WlSDalDlQ3+vg3cSsSCz2ta2TemZvqIJrEuU71h7qo9Z8Y8XNefxI/jelgod0LkPCaarDhNhQdiK/e7vQik4KicWIMBD28oKPL2pUIT1YdvCeil0VAjQ6N72uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a0kzZUnV; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a0kzZUnV"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-ca80d708489so532471a12.1
        for <nvdimm@lists.linux.dev>; Tue, 04 Aug 2026 01:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785832926; x=1786437726; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=U2I8sdYMfYJjOc8dSgSE9HfEVezQOKs2ggEWu0ibP00=;
        b=a0kzZUnVT1PfVHZqXXovMfZQa6ehVBNdgai+Us4KzLbh24hugR6VGvTBj9y1IHsdJv
         l3weKSYESxYQwfrZU6HS2BG8yv98dEc3Jw0ZkPM7wYocJwkcNw2JdejbqRHOjyWgVeZq
         fWJnOFeSO6DuDjGp5jR3v6neFx4gtc61Xu4e3bKRTwAP+VGPOq6X0ZQQa9GKatoszHr0
         SbzxUPsmCZ2qlOAMeEFd/lI/jb2cU1X4nWUUYLbgQ5THq5tPrHCWAL4h6KcsGeCP9jdX
         cgz658G0abpTvdomRUkWF5PivtsCDhVePafnF4Ws/uwGZyiielndby9dzyFjPOpv0TN5
         28ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785832926; x=1786437726;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=U2I8sdYMfYJjOc8dSgSE9HfEVezQOKs2ggEWu0ibP00=;
        b=cQpJU0CxVOvD0JFbvYcY4F9xmFAmHhkXGCRNaFDP+BxBwxONvZJpkRPukMObLiBmG6
         fTwv4Ratar+hMqEgxf04WDH46S2evM77CUQpVdQwhXtscjph2XZY36awSubgVmrZt4mf
         kvaYC3P4HAwtr5Qvzqvuq6LS9HUKbANoH50ysB6VSjtlFiSBZVkn0s1qLrARBnah3tQc
         BfdEbcrAxIaiGlta/ZYt3zIsl/tYRJsJYiimnoQPra5XaxfDkKULg48p8YrMZbxG9LKM
         14T2mxBqIUsYJucBJh6v9ecwNEd4gR4edV5bVqExSG6QnhxaRXiI89KUtYYDtpV7QjDf
         arlg==
X-Forwarded-Encrypted: i=1; AHgh+RqNDzU8447J8fml2Iy8rwrJ3hreUTm+JK0olZnqiuYXjDtojxfLxff4LnFZt1L0e4mF6r3ZTKw=@lists.linux.dev
X-Gm-Message-State: AOJu0YwVBeQuhcwBGzWXzCL+/BDFXLblRq22e8jT2tezu31hOU8OECQf
	zMsuEzJyHm5CZOZ5FHmoBqhS4DslG3dyEZ4sb0pyy+L75Rb+a6FWVEb7
X-Gm-Gg: AR+sD119Ka+2njHJ6RxRmI3tnJahWpBUqRMpt2KKDzhpaTFuISVPUnQW7GBicH/8+SK
	v2FN4kR5c+pXaXxmafrZ5r4l6AoTeb+wA1WXuFVub0w00RIbEv9IaiqXRoJrikAR83+BeIdz1Je
	SOf6yxOh6kXzMpY7lPuQQexOBtCz9DW1TRYU0cxJW1je3U8hujz0+eMp0gk7CWnGkGiBcIlPxbS
	0anZp1FInpXqXmKgqDtX5QyNKsH8ix7FfM245HXdUpVlKXMiEy4/jDQknRBggHNbkIL0ImpKdf8
	qTQmmSvpr0N0EpUIP2Pl75zXz+BNzQ48CmtOYvj7uFx21+ol4+wyKEHb9A5MtKo+8+Gu/PUSrAu
	D21ofZE3X19Tl9NUN+MHC5q7rfk+4QW5M6VD9KD3LAHQy3oh8B0EKw6PmjVdgvBnJCLkLVbhVaY
	dwzulYx/QxW4Cp+28gAbz7PlXdh2znhUyHHYExGIY0y2RyaYuwaKE1shuIwLhm8XCpUUA1grsra
	rI0eTHO6UG5wz9mXzdCu3Rj66nyKJP6B3Uarq1D66o80EtobRt6nZAXviT4i964dzAd6HrDtbWy
	jAIwmte4uh0+0gJir7Iq
X-Received: by 2002:a05:6a20:9188:b0:3bf:6c27:38b with SMTP id adf61e73a8af0-3cb6c937c3amr2601207637.29.1785832926102;
        Tue, 04 Aug 2026 01:42:06 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:541b])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbe39ea0a73sm4753273a12.23.2026.08.04.01.41.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2026 01:42:05 -0700 (PDT)
Message-ID: <53c9cf90-4284-4b6a-ab2f-1686c7461bf8@gmail.com>
Date: Tue, 4 Aug 2026 09:41:47 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 09/16] nvme-pci: implement dma-buf backed requests
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
References: <cover.1785596451.git.asml.silence@gmail.com>
 <CGME20260801155005epcas5p4ecdcdf532aa2c2ff4e94638eedaa435b@epcas5p4.samsung.com>
 <9e3dd1b2d71dc0f9bd556b6a6d6e48fb6a8d727b.1785596451.git.asml.silence@gmail.com>
 <c4cec417-24b8-428a-853f-4e1ff1e29a6a@samsung.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <c4cec417-24b8-428a-853f-4e1ff1e29a6a@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/4/26 08:29, Anuj Gupta/Anuj Gupta wrote:
> On 8/1/2026 9:16 PM, Pavel Begunkov wrote:
...>> +	if (WARN_ON_ONCE(seg_shift < NVME_CTRL_PAGE_SHIFT))
>> +		return ERR_PTR(-EFAULT);
> 
> This should be 'goto err;' instead of a direct return. If this ever
> triggers, it leaks the map and already established sgt mapping.

I can change it as I'm going to respin the series anyway,
but it doesn't really matter here as it's a warning and
shouldn't happen.

-- 
Pavel Begunkov

