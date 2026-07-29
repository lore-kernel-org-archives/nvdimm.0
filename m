Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F19D9446827
	for <nvdimm@lists.linux.dev>; Wed, 29 Jul 2026 10:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785321662; cv=none; b=rdUymjvcj/4HhpWpk8vamDB/GfhJcDqFDpz9WDjl9v3ZjcPiii7Nb+cEYI9Oih7VebHG4P7B1ssI+Yo5/vTEGhXqQt5ok5EpAkYZzJ4HCoUHuqxRUUa7mG62xtx00WK4BnqsliY1w3gPTggavMTMGumt1Bqdv+qyLGJTob7uNdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785321662; c=relaxed/simple;
	bh=BlIgo2y4Fy5hrKd1QKUkkESSegtx04afaFtVA1ds1gY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B0uE8pP8aN0/XXu7ZJ1dGrocb69aY+pc4TIMDA5DkhZwotjUYAqLsnfy0dPujszeIm2T5CUI6RITHNX1fYd+kCFyugUmViP2eizyRcZ33qHpY5vyFkXIhImMuNWEaySUiY/NKKZKO3ggpNDk38xWQgeAukXtVhAnVGRUEKSyv1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VOa8t/tn; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VOa8t/tn"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-698aa7ba3e6so1099764a12.1
        for <nvdimm@lists.linux.dev>; Wed, 29 Jul 2026 03:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785321658; x=1785926458; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vFsiSXVzFdxW/ZniSNP4YKGbRVTSiHE8ZZ1h1zgY8AQ=;
        b=VOa8t/tnNuv01Y96DYgjfkLijzNZRZWKz4xTKyDTzMKmZLI47zHNm4j5dj+iTe2f7N
         qtMVn0lk/C4iihWaJuFVO1+calHv3R4tY7ovVj4cQNli2Oae3YYJU8dt+b/6aaWXT8vb
         Qyqxx4Ef6+JZt0PxzYB9A2Ef1NAj2bOq1pw+LxGObHRhNbQrwPuIukT2m6zK+tOBgWWd
         kFDv8AIpkf65DVerptd07wMWcCq0IVjspEsYztBV/WzWuvBRTIfacUpO9cFtsAYTa4OB
         5gjTxq2s/fkJIo+XbcoEJ5Ne5OQmW1JEpIHaTSssJjuhKidG4RQLEGSmnzDv1HgPs+iK
         1m4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785321658; x=1785926458;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vFsiSXVzFdxW/ZniSNP4YKGbRVTSiHE8ZZ1h1zgY8AQ=;
        b=Z+fwvqdphBUGQRkqtknreptYq8KetCP/e42e1Jzg3VMM+qCrTpjGzb/wNLORS9yEx+
         LyTgO/LH0QK9V/1sLXS95I5EAdbQ26sfaEWRofftFYhYtayWQs+/f3XYkhhzb1ZjBdc1
         Ui6xrwywRKGusx3omgCROebFL3sX2oQ7aXvLPLX8HxKcYfupgqBaXwAfu7UJShC/8a7N
         B59/cXs9NDeq+Ui/45uxB4/jU+5lw6oAEYQ4UaWHO1KO49Z7wIwr0OCSGTacEApljQQO
         x7OvxVZdvvxGVMqWi1+OGmiDcY9Voi3bOh+ISoAxVtQIiCiJjG7+MyD7K6IZVr/Vhq0n
         FiBw==
X-Forwarded-Encrypted: i=1; AHgh+RoLpoHWZF3ztbOaTH3n591bFwf1LXXfXzwOc6ak4/b3jESpyK8c9Ge3dFSEUZ2uinJkDtySLjY=@lists.linux.dev
X-Gm-Message-State: AOJu0YxhbfSOXASfKAWqb/046H39CegPX8tFJDNgcTc08rOcshmANQTe
	4j4SglZ1eedeLz7n3XK7VDIpKongO2s1naRuZQ1qUMDhRgSHvXxNHT/T
X-Gm-Gg: AR+sD13o7Vic3eDeKrv4m9DzWHUX5wRy7X95AHhlqwtA0Bz9i4B0Uhcd3VyGw6H5Z62
	HajJrWUxr3nTGbrAV+SeNhYJhvt2c1nXl09eyO1NBf/Zd94q6ItzdxNLdrYNXFwfwUADbSlqaGA
	s9Jk7OqhTjhP8eiUcNedhDVXZFSsIXW2eM3Gqpo3HITwU8VEpHQ1Zi1+ywzdtTnlXmEdrP15wqw
	So3wbBoJc7HdqPDEPGWz2dtF93tTuVTfxBs6/8C5WbW4GEfcWtOvvjCEDMqEUWx+rviGGvN9rLj
	9pw2TEM0QU+2ZlHWDFZUwMjDqHhO9zbGDzb7Wjd4IuO487p+3424vrCq1C8CRazmU3EASFdtLbc
	1TJXbnwCnA6hSH3vSND6bf2Dp+1dGCymrTBhHpGfgeNlg5GuNsFMVyQQ0xXid/GU8EfzWmtaCwD
	L5CleeCajANhunXwDvrcmkXVx76Kt7Mi52DFWSxkjmwTTY3WCrZf/maOIE8gcuUn3OVDsdRmzaM
	vERsmoCPGx1RmTWOqh5Xhu4iNZvonO3AfJnNl2LUAVnhGP2J1/Uu1TeFwy/e59mklyrcyNReFHk
	PB28bWu9LSMZphSuXHc=
X-Received: by 2002:a05:6402:548e:b0:69a:596f:ba0d with SMTP id 4fb4d7f45d1cf-6a034a7f6camr3086746a12.33.1785321658080;
        Wed, 29 Jul 2026 03:40:58 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:640])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a050c5cf0bsm661299a12.23.2026.07.29.03.40.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2026 03:40:57 -0700 (PDT)
Message-ID: <7217c204-786f-4fb1-9c09-fc1ac7c8a249@gmail.com>
Date: Wed, 29 Jul 2026 11:40:48 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/14] iov_iter: add iterator type for dmabuf maps
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
 <132442812a40277a5904cb2a8ca1e02f4f6e82a2.1785274111.git.asml.silence@gmail.com>
 <20260729065953.GB9534@lst.de>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20260729065953.GB9534@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/29/26 07:59, Christoph Hellwig wrote:
> On Tue, Jul 28, 2026 at 10:29:14PM +0100, Pavel Begunkov wrote:
>> Introduce a new iterator type for dmabuf maps. The map in an opaque
>> object with internals and format specific to the subsystem / driver, and
>> only it can use that subsystem / driver for issuing IO. The task of the
>> middle layers is to pass the map / iterator further down, maybe doing
>> basic splitting and length checking. The iterator can only be used by
>> operations of the file the associated map was created for.
>>
>> Suggested-by: Keith Busch <kbusch@kernel.org>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> 
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks,

> I'm also pretty sure I reviewed this and vairous other patches
> before..

There was a lot of shuffling, so I dropped the tag after a 10th
amendment to the patch as I didn't know whether you want to keep it.
I'll keep it all for v5 unless anything conceptual changes.

-- 
Pavel Begunkov

