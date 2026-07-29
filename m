Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7081147CA93
	for <nvdimm@lists.linux.dev>; Wed, 29 Jul 2026 13:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785330552; cv=none; b=mqMjpnf1cc65XOYIkFOyedrv88dYqj6MRwsnRttSlzvZfsedHYWjbrvDbNKHAE26esVGhrm6BmOtdmV+oTnCCMvkf6HTm/8ywFeCfJ3in99SmkY83fTmELNNA0XIX0wixuQu+J6WbEAqMMP1JjT0umkL9K78JlyTRK0tMkFSOf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785330552; c=relaxed/simple;
	bh=RMWSxEPwnyLa/061OQ95QqTIugHWJGG2wh5+43JQ5dE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j3ac5Bg72JP5W+pjmb0cXnWjOVrHzCJxyGcMxVSrlCLNadc8r5DlynaUv8uWG9E10eXkgpE0O/FDGy0QNyz4ojqNL9jeC41Q3IxQ99IoOaV4phfzF5hfx5KHwvskg2gH/pPiwoYfwrhzbekXFfk4FqcKu4bDwsXYWO90mJbUgVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JvkXZH9Q; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JvkXZH9Q"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4955aa106b1so9240945e9.0
        for <nvdimm@lists.linux.dev>; Wed, 29 Jul 2026 06:09:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785330547; x=1785935347; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YUW97RbS/cuxZAvn9F7FgEb6B/w45ofSr5IJCTvWkgY=;
        b=JvkXZH9QZScenf2ybSwPl1XBo5LnQm/aWcNCTIK1cUXKHyAPO+lW7b3juwnuIMfvS6
         8YbvrRchE9ejwog6npFBGVVn7HFYZOEX04DeVcAaNPm/xC/5/BntvvWgz7WS6auXbT+l
         LQyeW7C4xcy19NQYF2XYqaAWfjTomy7NUmamXzt3fdYhJkKqJDbZVJaPBoXHlhxAnjCt
         n+x3hoYucHqyBiS/0su0Mp/YWgqTOIS2Ih0JEIw1MD+M3/PteyZXp8hsDG9Sx8QULOa6
         RYCoblJBXigXmh65oTlAY+3AMLBvzENJxyzFjbkkEQ3X0m1tAd5sme++uxABWJ3Si9FZ
         T7AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785330547; x=1785935347;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YUW97RbS/cuxZAvn9F7FgEb6B/w45ofSr5IJCTvWkgY=;
        b=YHBv5MyDgyP7WZWiOTGTVJ/7C0V9K5gEtFQsNIfvG36rxYaxd6E8jEnKekg0sXsg3i
         hivSboqT/K2lBiBu7mKlHctE9GhH1dwse3319Ktas34GjMGtVDgAaS6DJ8Il2rFzJjm5
         +lqZEF2crlVOB9/j3FFrk8gaVa/z/Tcr0/Zl5WvRByGv0YCvwJvTZ+Eclb70jbC+8uhO
         ozZqo81fbjFCL9jNZ2r4r87YpV1yPE04aaANlKpS71pq/iQ/4jqRlmxtS69U1lXwOZDJ
         vHg5aslcHEayQRG7Wr9XQ2y1dmHDtrblX6JdKOFftz2toPWm8CaIYov7zYb+HiJqTGXF
         qSAw==
X-Forwarded-Encrypted: i=1; AHgh+RoKTb/rEvF2l+ld+GCiawEO2PFVP5qVS4Y7YVk6AP6jy+9ac/P2K9cEOHy0Tq/938OAGDg5fik=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw5lwFAyUtag8SehJf/fZua7rq2aWBZJeb6UbPYtseJw+QJJHhd
	D6QwQ0p7xgEj29qTc6Xrp3PiRifK9S+/0TFROgJYeacg4wf7oykeNzUF
X-Gm-Gg: AR+sD124DLlD0/vGzCJUXjD9uZ1Ga8l05lfZMQF9U2X2QNMT666k01uEmrfD8rlISNH
	21TjKFobfZN8Rp8nk8v/h9CED37lTAb5i/u6Ni7eXoxyEAsnLykHYu4ihnmVIf7O9s+Z/X6XhIY
	36hWYTT82+8EzqoPMvLNAuv9SBOoS/KJzryDK/F4BRVaaOQkULMz8wR1D7goM8FMhwc7zjA8Oph
	6Si5opJOjFjxLf1rnnqV6CeMqU9lxbO7S2/yySd2Nl8x5qGYEwKW5uvSp7FDMq5D7T4QiodEdsY
	DKljMbtYWXjMB0xyQKhRXgmF9JsT58j9c+McjPRLYvLPERQYTy1685xOF+dI/KhgTG8F7oXky3z
	fHkXe15RFAr3iJBPRRlJ6zPvRo4iGzzYln2+r0n39ASzt8sugAZXCIucBdOCA+vERcbVZcuueK2
	wQai1BvWZViWBZXIdUmmcYcPFdGJ9DYyx3I3v3LaUCFAkV7uRljLYRGS6shmxDp2F6RtW3LIbR/
	m8RQGZuyYzS9R0KpKGm5qwvdlqjyjsFYG4wv0LVAQEydLSu1UMp/Py4n/1rO8NiAs3CqT18p1us
	mzOny5NQgcR4tW3RZCc=
X-Received: by 2002:a05:600c:348c:b0:495:4fd4:f7b6 with SMTP id 5b1f17b1804b1-496c659f7e1mr79358045e9.37.1785330546620;
        Wed, 29 Jul 2026 06:09:06 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:640])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49764d70014sm93438595e9.3.2026.07.29.06.08.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2026 06:09:05 -0700 (PDT)
Message-ID: <8160ce17-6f14-4946-9146-3d261e8398d3@gmail.com>
Date: Wed, 29 Jul 2026 14:08:50 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 09/14] nvme-pci: add SGL support for the dmabuf path
To: Christoph Hellwig <hch@lst.de>
Cc: Anuj Gupta/Anuj Gupta <anuj20.g@samsung.com>, Jens Axboe
 <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
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
 Tushar Gohad <tushar.gohad@intel.com>,
 William Power <william.power@intel.com>, Phil Cayton
 <phil.cayton@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Damien Le Moal <dlemoal@kernel.org>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Vishal Verma <vishal.l.verma@intel.com>, David Sterba <dsterba@suse.com>,
 Ilya Dryomov <idryomov@gmail.com>, dm-devel@lists.linux.dev,
 nvdimm@lists.linux.dev, linux-btrfs@vger.kernel.org,
 ceph-devel@vger.kernel.org, cpgs@samsung.com
References: <cover.1785274111.git.asml.silence@gmail.com>
 <5c2e9c3bdd3e87c0c9a6e4395ea199002b83fd36.1785274111.git.asml.silence@gmail.com>
 <CGME20260729072126epcas5p3ad4422a45f1274b71f15dec8bf487fcc@epcas5p3.samsung.com>
 <20260729072117.GI9534@lst.de>
 <81412691.21785320403945.JavaMail.epsvc@epcpadp1new>
 <20260729113108.GA31120@lst.de>
 <b03bba6f-0a8f-41fc-af59-2a69d271f28b@gmail.com>
 <20260729115540.GA32573@lst.de>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20260729115540.GA32573@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/29/26 12:55, Christoph Hellwig wrote:
> On Wed, Jul 29, 2026 at 12:45:47PM +0100, Pavel Begunkov wrote:
>> It was exposed in early version as I was passing a [{dma,len}, ...]
>> array, but we moved from that. Maybe I should put the minimum
>> segment size in the map structure, and (possibly over) split using
>> that for now? Keith had this chunk in his patches:
>>
>> +		int offset = offset_in_page(bio->bi_iter.bi_bvec_done);
>> +
>> +		nsegs = ALIGN(bio->bi_iter.bi_size + offset, PAGE_SIZE) >>
>> +								PAGE_SHIFT;
>> +		if (bio->bi_iter.bi_size > max_bytes) {
>> +			bytes = max_bytes;
>> +			nsegs = (bytes + offset) >> PAGE_SHIFT;
>> +		} else if (nsegs > lim->max_segments) {
>> +			nsegs = lim->max_segments;
>> +			bytes = PAGE_SIZE * nsegs - offset;
>> +		} else {
>> +			*segs = nsegs;
>> +			return NULL;
>> +		}
> 
> This seems very pessimistic, especially for the case of the registration
> only having a single segment, which I'd expect to be fairly common due
> to P2P bar mappings, huge pages or IOMMU coalescing.  So at very least

Agree that PAGE_SIZE is too pessimistic, but I'd calculate it from
the sg table on registration and use here. Not ideal but should cover
most common cases like huge pages.

> we'd want to special case that, but in an idea world the caller would
> be required to provide a useful nr_segments for the I/O.

Not sure we can do it in the straightforward way from the abstraction
perspective, mapping are hidden from io_uring, and there could be
multi-device files with differently shaped IOMMU mappings at some
point. We'll surely need readv/writev support later, so maybe we can
improve while doing that as it'd mean passing a {off,len} of some
sort from io_uring.

-- 
Pavel Begunkov

