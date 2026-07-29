Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 123D44749EF
	for <nvdimm@lists.linux.dev>; Wed, 29 Jul 2026 11:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785324524; cv=none; b=eIrwYxWq8VH4bapHa+Q3/czXUPPjyhpw40OxmqP5oYwnymj8N72rFjDJLuGE+L15V30HBzuTe1r/etIs81CCsktBXq8CyHoo2NlF4kDINgQ11lvK42Z5FEKPeYcOYobiPA+L1DwYG83nqDhmnu9peSZaidLUcggsPpoJfUHNnvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785324524; c=relaxed/simple;
	bh=c8bXkSao9MJ4kDOqs6oXQ3HhNP8HUICfRxyNML/BlEo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hnzOQVwAiPxX5vYiBYDRxjw6+Qqj37WJ7nW+W3M4v2xRMO+cJyuvzBb4+tBBaNrCJKc/KGEg/KBd2f0vwu0Q04+nhaSJ3Dpp0kCFpZYTsydR8tmNSdzKlQiKNXUafxLGFRtkObnwiww0Cuo29QB2x6orDoQndZ60hSuu+n0LzQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OBRTp4T3; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OBRTp4T3"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-698ae09e356so1136024a12.2
        for <nvdimm@lists.linux.dev>; Wed, 29 Jul 2026 04:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785324520; x=1785929320; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LDeRfN9blSLpZUyGDvy3JYR8gWm0jeyVXT2Ay7oVK6c=;
        b=OBRTp4T35oJT+EZuWASBhbe4X9rN68BAHnQamavLCELvkY/Gck2IXjA+NNz0190S57
         U6tvtN/p3w0Ih4RvUNWmi5LtABMrhsGteQo2XGUhxhfH6BkYXC/lMa9qsuQukkFZa7C9
         HHWL5LaRIkC2UR88IQjOGTfKmUeW0leEabQVWvKFVGgKqgurjL9VxlFq0hC4eqAnYRVK
         uG4pi9BCjorEEEVgnAivI5Sv3H/xKef3/kUNebcheG/69tiRSGG4A7XoQ2Aev6gretN3
         PW70YFKZa1jJSCBZt2Vt72Ea7Fol9L7rUk4Sj2wOAKtMyg2qO8QXj7Z1JwI2mM1NaMJc
         zeFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785324520; x=1785929320;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LDeRfN9blSLpZUyGDvy3JYR8gWm0jeyVXT2Ay7oVK6c=;
        b=Sa7nEpxVO9gAS/fPLhBqu+E3jzOfKO9H6Tq9382r6ml4Jz3OyJxAdVGq91Pcyaf9rd
         ImcbEeY/IiHVb/WqXhvBygGAULW37mlVPfs6hd+cxkeWsl8pImYvfoWUxiuJqjnlzOOT
         n16FBbY3+53jS+/guRcyTTag2Gk6CxDUGqZENWyQsqJ3DwwW0b09wJocRFklbPVT85qC
         OyT9LdQdrFT5cc1nbPvpetrP4Phhm44gC6tIDD7ugjqyXb6XGcX2yC0ymAwO7qwDodGf
         zCjux/DQ0/IJO0hsOBYTA4CmBL+BIbWaXDpTSNr7Rms2snkak51wSh87dQegICYGCYlq
         LViQ==
X-Forwarded-Encrypted: i=1; AHgh+Rqka1xMk7+5wtdvdJo4fzUCRrlM+sEnPiICTjRh6rPJVjbGx7BayfOg4/U+0xFAv3Na2Kpk0G4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxuHQnYTGN1BhIqZt4Z8Jv7E9liMujPzyj3K4Ma7QwdS+EBWRSH
	e2/EslV+g1DTvNkw2CJv3UMFczfhIy32fNF64SLezo8TJhlpqmo8D0iN
X-Gm-Gg: AR+sD13SyFgPC7AlhJOg/a+qYKLcQE3sU2LuaEq/KKqfMvTZb4ypbX4K7WyvIv1lQhH
	TVwUgUT25MydHJSuBNRxEzohI0t2wew0EMdMqT7UKqa7fAPr4OTJVzipYQik9lKJuaQXtec5mH8
	vKip1U+/G3LKXrS0aZ+agZsCylv249kwCQtqz3rUoRulhijeM5HJe0Gonrrdt8L0dJ5Sn4AMkWj
	WkRBRmsGZ0mi3b35hDi+sILRDfRniUlEdIkYKC3M3flEpJcPTtnllNAZPDcqWRFqKdnMKPLfnHd
	509L8biH3kgHHADpjmCORBGF3H+hrH5djKoMonRwmO1Ggtc5ARsGXl+BMK81CKc/ATtdu3WElt/
	xIhQ8hRamORo1bSllGEKe5N8aoZTqPeQG06VkRm8sqY6V8krnBbrUA6mH7cV+EPL1H9/AiyJ0LU
	V/PFBhKLS1vel24ke0HM1Ld8JkHAZR5bxpmx+WC7KNZOETOteyGxHMD0tQ3YGpSrxsvN7usdXUL
	DR3XcPDpYzo7xu6/Soh72nYQCPE6VaYGdlVCmOUgR/55ZPnq+zYwSgXuEuODNCOD7mQ7foBiHB4
	0Jz1
X-Received: by 2002:a17:907:842:b0:c16:5b3f:52e0 with SMTP id a640c23a62f3a-c1f72147104mr346195966b.38.1785324520387;
        Wed, 29 Jul 2026 04:28:40 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:640])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1f83cea5f8sm100629666b.24.2026.07.29.04.28.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2026 04:28:39 -0700 (PDT)
Message-ID: <872e7a5e-011e-4415-98dc-96c9066b0614@gmail.com>
Date: Wed, 29 Jul 2026 12:28:30 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/14] Add dmabuf read/write via io_uring
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
 <20260729065421.GA9468@lst.de>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20260729065421.GA9468@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/29/26 07:54, Christoph Hellwig wrote:
> Might help to say this applies to Jens' for-next branch for those trying
> to apply the patches..

Ah yes, and there is a branch as well:
git: https://github.com/isilence/linux.git rw-dmabuf-v4
url: https://github.com/isilence/linux/tree/rw-dmabuf-v4

-- 
Pavel Begunkov

