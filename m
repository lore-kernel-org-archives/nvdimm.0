Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A6E448B87
	for <nvdimm@lists.linux.dev>; Wed, 29 Jul 2026 11:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785325571; cv=none; b=CxlC9JfqoHAGeyYmTCZumqHM6NVBOb64lOSlNXq19wCUO9Q22uRXcPvzhv74LzknBBqxjCZwAlwksBt+kLB6Ui+b1pQEMYNrp6Szxn8iFZNCwFiM2WnqN9ePP4/1LImXVjbVF+qde8UDi97u9BnPZsmgZ6O8VPtFZpegge7Reg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785325571; c=relaxed/simple;
	bh=wYq/i9KhASJIbtNcdRJPIPtUhLDMmjpqz3feaFDSSx4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nRMWNsnyz+mKDSXu1+All/xGgIGQVqMgoSkHAw23MRoTYr05EyDY2AygdwBmYNLjVW0a00258iNOHQrg3aW3nK7dpVf/Bde1mwMdZXXJ+QOW2ZHewpnFQgR/ZI7tA3dMhUwyCyFiChnzvAf8v4kFi+4HlHiHJhfKKykrqho+Cxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NmKbHwcS; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NmKbHwcS"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-49545ba3d4eso3780555e9.3
        for <nvdimm@lists.linux.dev>; Wed, 29 Jul 2026 04:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785325568; x=1785930368; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=57DEPZ87ucJ5C9uIRumsuvToNlPqHFcS1ybRBzt41xg=;
        b=NmKbHwcSvit5u4sXcSDVqmiK5/MsoWcWBAGpfpCMcmiqZlPA3ltM8DBxrt8IazRLmS
         ZNO/OwAAV4l5PZ9MQB78ySUgmT2mPiNWVSEmShNS2LV2TXclzm7UFGc2Fj5A17uJIQ+I
         nTR+8YCzIwamTxogh0t79mhokSLDIlKLmvU+xCdV2Ev5ibZ7rXDPycO456FGuDBOItXO
         u+wSb8f9RRqH/FasI+tVTBfBLuFQg9TFQy6pmrUcbK03avOVQfRZMo1H8xwJI7TcOkGd
         Wd1vIQSGCEMrBaOvBArEZYrhh2/AMEx36x+GLVifStsR5QfUdd3sqnFLEJjp/GinXH3I
         fpJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785325568; x=1785930368;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=57DEPZ87ucJ5C9uIRumsuvToNlPqHFcS1ybRBzt41xg=;
        b=GNSqD+/gJdpEwQaz8rDMIJhLOy6fq2U5ePKTjhujQon1L2RlfngFjw5a1WdB3ibEm1
         FLIwDEXO8zntoRr90FDz9v7Gsqbtf7se7ocyuQio19V3AsGNSmk0vtmz6JjBJemVpeiy
         OqpqGVGLeBMf8yJoC7OsoSMW0LRPr34X9s86U+Rl542IcevXbll7XKw1JvNj/FJHroG7
         LvMbMGk85xQPi1/VwFNEXaa6QXmzr6O6cUGKn5gASZuOnXoz74EJL363FK3XiSTeY6TI
         iyRriUvVq5KDefxpkFyp97NuCuLzLr9Z0uLBj+09g3slsvxVLuIE3ew2fL/cgGvL3haX
         nuJA==
X-Forwarded-Encrypted: i=1; AHgh+RrCHhm3nYcGDftOFfbNQm+66uL2ibD6joWI78HuI0kDYU79s5TENr0Qruy+tuHfoLyZ3B7JWWU=@lists.linux.dev
X-Gm-Message-State: AOJu0YyCub9iv/ll3mVEDx7RQiCN9khDQgLgBnZqA3t7x6R0K33zePua
	/18VV9274jPhuu9KVsg0XSOymQ9PwoCnqPABwRwK0wo6Ic+Ej49FisM1
X-Gm-Gg: AR+sD10hn1JcCVSeCV3f8aJoTZkOb4OwMG9Kt2Rr0MQeQG58FsQazO67SbwejtihAxa
	oEb24xcTDFDMZK3jhmU/Z9ZknQ1G+wn/Z+/N0vjLtxOHr5w3/FdQ3AMCBdHqp4TrtYx/Iwdq5cE
	QQ9C9O4Y7BorS6/vugAmaCWCEfmV79ogtjM9mSr11gdnocnW0a1MING6nasoOhq9IfP5Fiw3Xwg
	6m83Ux593/6iFH1zvSLfzKGsMtGM2ivUaj/ejW8De/bLWcGE8zdPtJWK8944FGhLz09YoHq/6yV
	GICVvLwNWyIF5MRD8tRiCRpzrfgxnPoRliwS8WLtk6geKn3XsKAGkos/sTPsg9BU84XfTaILS2W
	g99A8uw3fScvwZ5IBIw6FruaVaEJoPyPYhQTrjXBOR8D7C+1+o7WWRAIBEsxn0pm0y9UR2XLCAu
	6cQSPl5kVP7kgPn8kTy25dHog6Al3y3NWqKCWlvnPRYikg9aedycHRBxcigj4BpphNTRAWxzX6R
	63c8OFcthXvysOj4ppAD/ABglMJQRGiy+XGBh0A4ObBWNds0QUZ3YEsKb748AlQQx1HzJAS42hX
	ARO36qNl+VKZfWQY4ObW8hFl7GzoPg==
X-Received: by 2002:a05:600c:470d:b0:493:e365:7630 with SMTP id 5b1f17b1804b1-496c6431d1fmr69913135e9.14.1785325567969;
        Wed, 29 Jul 2026 04:46:07 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:640])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-497fecfccc7sm26554895e9.12.2026.07.29.04.46.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2026 04:46:07 -0700 (PDT)
Message-ID: <b03bba6f-0a8f-41fc-af59-2a69d271f28b@gmail.com>
Date: Wed, 29 Jul 2026 12:45:47 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 09/14] nvme-pci: add SGL support for the dmabuf path
To: Christoph Hellwig <hch@lst.de>,
 Anuj Gupta/Anuj Gupta <anuj20.g@samsung.com>
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
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20260729113108.GA31120@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/29/26 12:31, Christoph Hellwig wrote:
> On Wed, Jul 29, 2026 at 03:47:23PM +0530, Anuj Gupta/Anuj Gupta wrote:
>>> But I also don't understand what the use case for this function
>>> is to start with.  struct sg_table tells us how many segments
>>> exist on the DMA side in the nents member, which should be just
>>> fine for the SGL threshold calculation.
>>
>> sg_table->nents covers the entire exported buffer (<=1GiB), while a
>> request only covers a subrange[bi_offset, bi_offset+payload). Using
>> nents would overcount the request's segments.
> 
> Urgg, yes.
> 
>>>> +	if (!entries)
>>>> +		return BLK_STS_IOERR;
>>>> +	if (entries > NVME_MAX_SEGS)
>>>> +		return BLK_STS_AGAIN;
>>>
>>> Given that the block layer enforced data in rw/command and the
>>> max_segments limit, why do we need the extra check here?
>>
>> A dmabuf bio reports nsegs=1 (bio_split_io_at) to the block layer, so
>> max_segments isn't enforced against the SG entries actually spanned by
>> the request. Hence the explicit check.
> 
> We'll need to expose the actual nsegs to the block layer and split
> based on that.  Otherwise I/O might work or fail based on the device
> capabilities.

It was exposed in early version as I was passing a [{dma,len}, ...]
array, but we moved from that. Maybe I should put the minimum
segment size in the map structure, and (possibly over) split using
that for now? Keith had this chunk in his patches:

+		int offset = offset_in_page(bio->bi_iter.bi_bvec_done);
+
+		nsegs = ALIGN(bio->bi_iter.bi_size + offset, PAGE_SIZE) >>
+								PAGE_SHIFT;
+		if (bio->bi_iter.bi_size > max_bytes) {
+			bytes = max_bytes;
+			nsegs = (bytes + offset) >> PAGE_SHIFT;
+		} else if (nsegs > lim->max_segments) {
+			nsegs = lim->max_segments;
+			bytes = PAGE_SIZE * nsegs - offset;
+		} else {
+			*segs = nsegs;
+			return NULL;
+		}

-- 
Pavel Begunkov

