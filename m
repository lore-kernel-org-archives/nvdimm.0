Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827372F43
	for <nvdimm@lists.linux.dev>; Wed, 25 Jan 2023 14:32:09 +0000 (UTC)
Received: by mail-pj1-f50.google.com with SMTP id o13so18720673pjg.2
        for <nvdimm@lists.linux.dev>; Wed, 25 Jan 2023 06:32:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TSv8WpaqrU88nGheGtiai7Y/5wRVY8MkM9KRN4G+ukg=;
        b=6TUazUJSiXGMCc9BZgnJ+ncR58zGFe+HwYOk/rr3xHuxMwoEBSZXgJ8YDUrwx+QrDs
         0yoqVhDUylo/qQV9t9vD7a48v/MA1BWUmvM1KIIeVhk9zteWjxsufEqEqKwKSefrLD53
         rSSTFz/23fiMM4UZHT7qYjhZz0GkfpM88GDQ7GMPWjY7hn8sbVgZTMjZHU1pL4UXDB98
         mK4uNvSGO4tCZYMv3DSy8Y3aHSj87MDVVD6wat1ztVKQ+06I9/6tzukHWdAci17SsAz8
         ApNiiBU/qtAwtuPS0o1YadtuehG3+LqSVZvQM9bAhT/U2JtZKE9mLtINVYY4tX9+UwFG
         PNHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TSv8WpaqrU88nGheGtiai7Y/5wRVY8MkM9KRN4G+ukg=;
        b=bQGYLvCr0dwhbLM7yhMqf3FwNLW8+6Lz3y3xInWZBciTd2jaPY2UTumiAyLVdXi1oI
         2qnYJ+utH/py6fABgI8hTiZP3IFnOIh77oft5voUb2m29zN3aAjJ7oi5nT0pmjLWi0Wm
         LvX4Prap+o39eP1wG9cQwjSgxxyOm8bJaC2XlazH7XO3+9dfKug8wlSXybwP5/hme4ku
         PcFhlIYT5R5k5xq33DhzxKOuZPAceG9L9UUZ+BadCSQZPD/KM6MkU2Fh1HnfLuttEp71
         vdKFYoCfv3b2/BmK1eRUD1dVTG4Ras+YGQVQSlpy05n2fEsqUvj6njAqPWY91Uy2IreP
         rEWA==
X-Gm-Message-State: AFqh2kqtj5gu5O4w/dUmLygH1a3ttoNg0D1dFEgx7QhTcyp+cINlM5Yq
	paCu0krp15LJQVUteT5MXOuSUg==
X-Google-Smtp-Source: AMrXdXtSjhgXq/ti77BjIjNmng+Rkvj5Dbfyvd4sgmo3FggcVSTo6y9uVmruhdChTgf8/MyBasa0Dw==
X-Received: by 2002:a17:902:b591:b0:18f:a0de:6ac8 with SMTP id a17-20020a170902b59100b0018fa0de6ac8mr7903292pls.2.1674657128759;
        Wed, 25 Jan 2023 06:32:08 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id bb2-20020a170902bc8200b0018bc4493005sm3664530plb.269.2023.01.25.06.32.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Jan 2023 06:32:08 -0800 (PST)
Message-ID: <aa5ca868-d8ca-8278-509a-dd511ffdb4a8@kernel.dk>
Date: Wed, 25 Jan 2023 07:32:06 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: remove ->rw_page
To: Christoph Hellwig <hch@lst.de>, Minchan Kim <minchan@kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Ira Weiny <ira.weiny@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-block@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20230125133436.447864-1-hch@lst.de>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230125133436.447864-1-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 1/25/23 6:34 AM, Christoph Hellwig wrote:
> Hi all,
> 
> this series removes the ->rw_page block_device_operation, which is an old
> and clumsy attempt at a simple read/write fast path for the block layer.
> It isn't actually used by the fastest block layer operations that we
> support (polled I/O through io_uring), but only used by the mpage buffered
> I/O helpers which are some of the slowest I/O we have and do not make any
> difference there at all, and zram which is a block device abused to
> duplicate the zram functionality.  Given that zram is heavily used we
> need to make sure there is a good replacement for synchronous I/O, so
> this series adds a new flag for drivers that complete I/O synchronously
> and uses that flag to use on-stack bios and synchronous submission for
> them in the swap code.

This is great, thanks for doing it. There's no reason for this weird
rw_page interface to exist.

-- 
Jens Axboe


