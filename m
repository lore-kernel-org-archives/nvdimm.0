Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9131647A87A
	for <nvdimm@lists.linux.dev>; Sat, 12 Sep 2026 12:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217867; cv=none; b=EzY9/qkTMpYuCnTxqUWBizQkKwRykmXPP7+mn8PZVP9J1qVXQsKARTwjyCGa7FceEYQLnRO6i/tIpmqnam5TggGzyQrfNSA3VUP0fULsGbP+2I0vD8arj8ewGJpWuanzJqpZ8nQZEabIAEf8GwZ7heJnbgea9oAL0Sd6Gi2Wzco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217867; c=relaxed/simple;
	bh=6N0ifHQ8O4u0BOZ6EF0w79HnCW/yPo/3nI3uyCXuO9A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UlpBQ8cj8bVrKfXHUyp0gbnY8Lbhmg/E8qRQFSg9Wn4zH69IpPFUyBc//TyZMW5Btb6AIQ4Mz/SFyYxSC7v7jfUQcpXq8LCDEeCZuDZuVxNvjIX9yZOZVYVOBSbhJ5Pap9NoRPm91lt/mdsP312Bt3TXHhra1Ph2MGc56jhL2JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZFoxWQka; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZFoxWQka"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49ccf3ca94bso2009335e9.3
        for <nvdimm@lists.linux.dev>; Sat, 12 Sep 2026 05:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789217863; x=1789822663; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fAOw7eoVc0zYvL/f6e+XZRwdegk97u7KcjQYPN92otE=;
        b=ZFoxWQkamFhrFXp7jZ4mhdRb1Rk7TaFuq3SG1J1lngZToCMRgrm0o7s6uPfRljivY5
         EwN1mCxNUqN6CjflZRTfhdpd/J0N1FJXEiakTrFY1p9dgL5Vd7q568P6i2DLQM6WLUHi
         RwpJfamHx7Z9YT0y3/PXG8tZoyYvBLSHVE0SUDMvB3xG1AEdgDvxgre8xGWdYpoKDa39
         LYexEo9Zc3jGustipLJCdxo4LVH6omH+qqLtTUprTobuMTK7IGjTL2tMoT8atQKUjsk8
         TLoCfSYHPjvNB1PbLQxQpEPApkhL+b5dmYcgoi6Neh4X1TNe803Yd86HWjbZh0P+4l6C
         p03w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789217863; x=1789822663;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fAOw7eoVc0zYvL/f6e+XZRwdegk97u7KcjQYPN92otE=;
        b=lARQtB48njVKcQWv2RodhAoK/zVsjF0Z14yNq5DL3bhoFf4svxBG+8Nnjz2f2sV+oe
         rOcbqDetYueT6lhhUyzrfLst+8DKJheRMo2rheRIpfpNL3afqLuB2lquyiKIg/IZTx9y
         lmHwLRIqDwGI+WZuP2hS+prLo8bu/dU9YHXfXaqDjQZfMXj6lU5E0iaeFqVo07okqr0C
         ox38LScrlMWXx8xNjd2HLKIk7vU7JoB6ngYPY9IA33Mp7srENf+9SzdtyozXbC9/8DkP
         V9rN3iknVeFmBrQJX1+8b+gdslkjP6WGB7rZ52h5Kx4LhWOVi85vqvJOiBtwa7FsdScP
         +JqQ==
X-Forwarded-Encrypted: i=1; AKwUvBy0wrJm2IA0hb/zXs9LCPv+yHRXhD+rL8DI9zCm+0PR9PFizx5YdqPaJpCXsJZVdPEy5abfgsY=@lists.linux.dev
X-Gm-Message-State: AFuF++mu8LV5gY58/QwHJIv2VM1knL1idSre8SxQv2xdfX/kLPQIAgsP
	Hw32Flk+x3Ul0FpRGX1sX2nSZx2rfwdZjE1J/lMtPapAN2Qute8gSWeM
X-Gm-Gg: AYBFou3uPsxiH4MKi+Ntm3HV35eMRAWAxZOYY1yv0o2sw7mEaIEQZTOufoNffy6eQyM
	IYSbDDYWN9GxtUcv3EGJOOjNBTmMduTLfa+IUjmGjjpoqD9mKQxyWhPxp8XB/v5kbNuK2KBJRmN
	J0Whwm5lZAbTtyvRs0A3bfA4NcFcwpadLvuQ/s92twgRj+hgRLO/8FI5DJWgAtqNLOrV4CK1VZ2
	ZkGapR81LiuG+ZMgbRr3mzQDTZxoZzkoaQa9gVOG0ts5yvZRzHzvWXG5rd4uxOOKABO223pKdP/
	lVrEGQN18WCU7ETZ3+G7WynV4zPYGsX5woq9+38vvcJIHjSIhQVq227o3slXOKG5oIcRp6rqlc9
	4AzO4M8CvlFOVRKOtf64h08n6Q8++dTMHmCgw/5z0VGxG5WQ5BOewWoHH72FZTA1xmjLi68kS6i
	TqpfpZWLt/zeJm/o7LC5AYQeNpQjZH9yfWcy8kdOtWFvVPBTIAU1zQGwTxjTI8kqScCPyLdwaAH
	VN5pV/Qbsbfo5FBG8K8d9tIoKlIfsAMdSv33/WH9qN2rwIG+95XuKkN7SxN+fsoMLhPUqDIIiuG
	m9FGZwAMxNp9C64TTQMnOwRBrGo=
X-Received: by 2002:a05:600c:6812:b0:49d:1d7e:4085 with SMTP id 5b1f17b1804b1-49e6cbec30dmr21535245e9.22.1789217862965;
        Sat, 12 Sep 2026 05:57:42 -0700 (PDT)
Received: from [10.192.161.217] (82-132-213-27.dab.02.net. [82.132.213.27])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-486eb32e7f5sm12751635f8f.9.2026.09.12.05.57.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Sep 2026 05:57:42 -0700 (PDT)
Message-ID: <0c787163-dd07-4389-b9d5-916b8753f388@gmail.com>
Date: Sat, 12 Sep 2026 13:57:37 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/16] Add dmabuf read/write via io_uring
To: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
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
 Anuj Gupta <anuj20.g@samsung.com>, Tushar Gohad <tushar.gohad@intel.com>,
 William Power <william.power@intel.com>, Phil Cayton
 <phil.cayton@intel.com>, Damien Le Moal <dlemoal@kernel.org>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Vishal Verma <vishal.l.verma@intel.com>, David Sterba <dsterba@suse.com>,
 Ilya Dryomov <idryomov@gmail.com>, dm-devel@lists.linux.dev,
 nvdimm@lists.linux.dev, linux-btrfs@vger.kernel.org,
 ceph-devel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>
References: <cover.1785596451.git.asml.silence@gmail.com>
 <178907372259.484803.15807864431748251506.b4-ty@b4>
 <eb469580-509a-4895-a819-e7f3e4fa0b0a@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <eb469580-509a-4895-a819-e7f3e4fa0b0a@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/10/26 21:58, Jens Axboe wrote:
> On 9/10/26 2:55 PM, Jens Axboe wrote:
>>
>> On Sat, 01 Aug 2026 16:46:12 +0100, Pavel Begunkov wrote:
>>> The patch set allows to register a dmabuf to an io_uring instance for
>>> a specified file and use it with io_uring read / write requests. The
>>> infrastructure is not tied to io_uring and there could be more users
>>> in the future. A similar idea was attempted some years ago by Keith [1]
>>> (from where I borrowed a good number of changes). Later it was brough
>>> back up to life by Tushar and Vishal.
>>>
>>> [...]
>>
>> Applied, thanks!
> 
> Eh no it is not applied, was just looking at the series locally and I
> guess it got added to the b4 ty pile.
> 
> I am, however, wondering if we'll see a v6 of this soon? I had some
> comments on the nvme dma mapping, that can be improved, but I'd rather
> defer that to post getting this included.

Working on it

-- 
Pavel Begunkov

