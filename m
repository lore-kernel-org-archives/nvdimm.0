Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0772E3B8948
	for <nvdimm@lists.linux.dev>; Thu, 10 Sep 2026 20:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789073926; cv=none; b=MoHAPcXeS7eixvRm7hSzUerg17CIPwQ/ctWySqi0isSSF2NExhzQ6xZxRZsHbzOxaKLEW5pn2VlzWXjG2u2MER8mp8QKoxbyVnvLYy6B/0sIr86x71DsQkIMgo59WujAvbDaV4wM1MQyYz6tehrc2ole83YfuvwzsdqjgMeCZyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789073926; c=relaxed/simple;
	bh=ylWdr8yhyOUHr5p7rV7V/FTvMFhwSjE7Fa4ndWREMxM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Rq3Hiz+RZQgp5Wp33NqlVRIhyrc6pqkxorYRzpzs77F0dv3Nb7ODo1pD2iwjDJUiX6R6wQ34QUYSv9U7BkgNegfbsGdCHUjKuiYZCT7+j/J/AwJGJ4NxKWva9mwpVqeU/+IXDgZqVYv1ih/mb4deVlNhvFrMt1j71LD7YIQlcNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=uSlXPRuU; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="uSlXPRuU"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7f4f824de5dso111401a34.2
        for <nvdimm@lists.linux.dev>; Thu, 10 Sep 2026 13:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1789073919; x=1789678719; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=227EuAsNywH5Ru6uyjfcvigTr1soLZnaZRqqI+5pgxA=;
        b=uSlXPRuUorlD5sAy3Y+CvP9FzZIzk54OeIrkAWO3+legjN1LHODEUl825Yg0oaQ4sD
         m4FBfC3d0V/qS2uRNL3wQAv5JxG2s5r60yLqH/9XVLGaVKhn+QjLyVuSwHhTl0+sMgYv
         fp3JwjQJER3DOv2kTI4IT23LhjW7H0wVNJ8IdUvIVCa0lgt6faqCVG74l3mHqwz8FuT6
         eqaCVYAgft55v79CD0y1yaHEgMZQI2QUYmAnFh6NTn1lBWrC02guGOfmAOJOKhWkNpk+
         291XEEuKU+6z/1yIsmAOzm8/kKkjJpmr80fLISWsim/I4RxzolNmtQrNzPOr8issbhhT
         7yxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789073919; x=1789678719;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=227EuAsNywH5Ru6uyjfcvigTr1soLZnaZRqqI+5pgxA=;
        b=Sx2uoBS7gwjMZmnjm5v/VTGzmGFRxbfV160ZN9L9qoK5ef7cvNg4U2PINInAwXxtXz
         5PnoGTIuYNO3mBzeeY8gpcP/Fzihs2Gy3BxIS0NhNCN+b8D6Ru0AeNppk/zLU3dRmjAd
         CKMv1NsnfhhhxKbhJhBTkwZDzsIJp0FqzS8hFNixGZw1R0trXnzKDXnL4G92zfCFI3N/
         2zMVMP1BXJMjCfSSuD9XhBvfx2df2cvAf/CSnSbKPh9JN9xeouMUD2104rhMGfBHtnMk
         95oHVULsuM1PbBdMlvgPfnp2N1V/eaHjjGNPHr/g8XNmWgb8DNKcjfeg/YxoGDIshb5m
         fT3A==
X-Forwarded-Encrypted: i=1; AKwUvBxrY1Mds3vu7LVjtZG+GRvzcBKiaDVXWeIZpzuJkLY+SJ3TMbA3dw33NgAvgUlpblsZLba4zTo=@lists.linux.dev
X-Gm-Message-State: AFuF++lmQZCiGRzwlY2kIjqMjsG1NELeBKItiPmSEym48co8Ct/qhvWl
	+FsvaIW/wB7bH/JJBi8aeMPk/96na35gQQXiOK8uIGD5d3SJ4DszHqy1zR8aiKy1Rsk=
X-Gm-Gg: AYBFou30Erayw0ebu25sd2pBeenRH9tiFeDKLINVHE2hLHSp0ZdZwrY/p8pu8fohn0y
	xNjcuc32xQUYBzH+KOjaCMmpLuaRfCxYdJkNKRcxI3uuBdZRoelt7ecS0K+UZ7Ned8gMZflWZ2l
	rYduDNqjF7M/sEpAgsHsYCJ2lVW42mC7rOkZL+pIuyiX4EpgXWoZ30mzHzxRslVtXqSucNx7/fq
	/5XYlIBZlLAaR8gY3erZyul2kYLN1AjRzt2l37k0YLEOi1cN6MGqj6WDwqHzYoZbD/UTxGnb0A0
	2Z4l0eN4aL6B5pCuiT/cGYCoS+IrmKP//XFFnEl6k5hCA0fpgDDysQgcjUtXTvIuAlR489YpNIU
	+iA5XtVSFAZkqYMZI0wqi7s5bPJxOvSHwKRUcJtSY5N4t0WXUGIJXyMtpTiUEZVdpaQmW/ijAfU
	7zHoTHU58N6baA3fD+6Ef7RO9wfH78JoU0UW6Q9B4EFKHFiP8VOQd2We7CACVajo50m5sPtqbvW
	DjE/A/AbkjnzK2kiIDbTJ+qpnnjBGtLJzYe+UTraVEKiwBktVnerEaj
X-Received: by 2002:a05:6820:3411:20b0:6c0:5630:bdef with SMTP id 006d021491bc7-6c0bd97850emr353461eaf.67.1789073919642;
        Thu, 10 Sep 2026 13:58:39 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6c09a122443sm1108879eaf.9.2026.09.10.13.58.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Sep 2026 13:58:38 -0700 (PDT)
Message-ID: <eb469580-509a-4895-a819-e7f3e4fa0b0a@kernel.dk>
Date: Thu, 10 Sep 2026 14:58:36 -0600
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/16] Add dmabuf read/write via io_uring
From: Jens Axboe <axboe@kernel.dk>
To: Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, Pavel Begunkov <asml.silence@gmail.com>
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
Content-Language: en-US
In-Reply-To: <178907372259.484803.15807864431748251506.b4-ty@b4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/10/26 2:55 PM, Jens Axboe wrote:
> 
> On Sat, 01 Aug 2026 16:46:12 +0100, Pavel Begunkov wrote:
>> The patch set allows to register a dmabuf to an io_uring instance for
>> a specified file and use it with io_uring read / write requests. The
>> infrastructure is not tied to io_uring and there could be more users
>> in the future. A similar idea was attempted some years ago by Keith [1]
>> (from where I borrowed a good number of changes). Later it was brough
>> back up to life by Tushar and Vishal.
>>
>> [...]
> 
> Applied, thanks!

Eh no it is not applied, was just looking at the series locally and I
guess it got added to the b4 ty pile.

I am, however, wondering if we'll see a v6 of this soon? I had some
comments on the nvme dma mapping, that can be improved, but I'd rather
defer that to post getting this included.

If the series is dormant, just let us know, and we can pick up the bits
and pieces.

-- 
Jens Axboe
