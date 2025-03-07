Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11EDC183CB0
	for <nvdimm@lists.linux.dev>; Fri,  7 Mar 2025 19:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741376082; cv=none; b=uTNRaL01CP3lUJJ/6KjWhlf0OkP9YyMkng0IL6Qd1fdhHTLFp/H+Va9RYQKmz9jS0UVXp0A3FZelesov6ZrLbQA7QziGgiW0Gy6CgcysGgqmn4WNe+YhPDqEoO7s9IncPrnEY154GILbrU0uRGxW30/2EwTJd0JVf9/B30LP7zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741376082; c=relaxed/simple;
	bh=NS3+qwkRqQGih47wxvEpGp/XIBdosnSvkbSWoPDoXqc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=odnSkTxffa95aFu8bKTG3M5Mv/WFxp8HqClQZiaOMAl3cs+uRxH54yfi/WPfL/03LuRdbN0LLrRVvOXi5SnxmuA621wypmURBEawH7Fa+T+ZWoxdzE+x0c1/htqmOB99YY7asrRb15UZpsPHTlR5VmKoth4FuM2mQLnjjU/vXIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V+AzunfN; arc=none smtp.client-ip=209.85.221.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V+AzunfN"
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-51eb1a714bfso2070015e0c.3
        for <nvdimm@lists.linux.dev>; Fri, 07 Mar 2025 11:34:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741376080; x=1741980880; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fsLIF0KuSa0+9gIStTKUSkGySCuhFSqgeXthFQ3bTsE=;
        b=V+AzunfNLQVaio3uAnCtvIa4dfJxj3olfIm7p1Idq/pKJAB8CUlQ1iPew2Y30Sbx7f
         Q0X5H2cQe0WLBiwz21kdsz6aARX9eqqAaKPuP79ftjAIlGkig3aagkgRai/L2XgMuJ7k
         YtHuju7mdpJHMzsUWRVYxwYRFg0srjiawAyfst4Fp9Q1k8nIQx6fRMX3+d/9lX6nNjc4
         CguxBtj3RcT6LI0yayIUTEauuB7p7YUPCLOqhrAdC5zw8QOPriLJ58gfhxgumnZRLpB8
         L1tJX2/AKKkVuezn6pItDXnwbOAk8F4f48U9IhLaxYqoKmoTg9m/RoAO2shindd3erMm
         W0dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741376080; x=1741980880;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fsLIF0KuSa0+9gIStTKUSkGySCuhFSqgeXthFQ3bTsE=;
        b=HidwFb9NUlKV2hWbdEkk4eALniCZH+7cL0inwVv2osPeXg/o7aKbA13dCHATDodGmn
         M3wnke7CqKUwjUfcq95sjC+ScaDRWONdayaEU6IETVI4A8402MfN31yQ5Zu2QgYxARz4
         rPJeS3nG6pr2zMY7P0Th1SmXAxMzyuWHo6yv79LSu6/E0hVwHjSg7TjXE5zmpyqiAqT0
         KFdsRx5Dbe2gFt2mycZG7MImhTVPB8OlItVcRz2l02EOtRFrtzzQdAEjcFS1qN7cwgdd
         ghZKvY5NlxM8bN6h1+C633gvBNkB8K5KynxhNUa8x+eXVDJhUJ4s7o/AxHFqiuzcxHWx
         0VJw==
X-Forwarded-Encrypted: i=1; AJvYcCVjFZcjT32r7F5GSnzn1XluQvrt8TgDsrq27Wohk/U8t17jiLZyhH5HvY14D/fqLG/X0nGc5iQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YzB7Dv/KXYdsV5PciRzGnpogHJjIjbQmojotTi8IaLyjrXnGShv
	4v6u6SXt7FmqENZhWKtshLm4oJ7ToDKRsq5abGwccGehttWZM5UNScNyGH1lVFwD+wUcryOeaba
	52WDsE2fkjjDqdYf1by2ST99afEtABXPEstc=
X-Gm-Gg: ASbGncsrTF+7TCA2oCGFQZm1CNo5p+EeLq400rRhoAeR6W30gScvfDa2zT4gf0eJFIs
	Eziq5sY7CokggEyQ4um1pdmr+gVyGRs94idP5ceSvBW79uEXTOKBEVoLFb3HUN2F/O4NI61v07h
	EXCb8t4cCQyNQz4vxzavkRdDHk6g==
X-Google-Smtp-Source: AGHT+IFgqqDqQofofV/JVROxQO86oLW8odJwAWvtAGFI3OGLPlYXWCYP7AEGD+cKOelEyOiLNufTRKzO83KiF2eNeL0=
X-Received: by 2002:a05:6102:cd3:b0:4bb:e1c9:80b4 with SMTP id
 ada2fe7eead31-4c30a36790dmr4084956137.0.1741376069586; Fri, 07 Mar 2025
 11:34:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250307120141.1566673-1-qun-wei.lin@mediatek.com>
In-Reply-To: <20250307120141.1566673-1-qun-wei.lin@mediatek.com>
From: Barry Song <21cnbao@gmail.com>
Date: Sat, 8 Mar 2025 08:34:17 +1300
X-Gm-Features: AQ5f1JpJm8Pz4qzzGj-4qBmXe9E99kwhewd_E_rbXmfvrZ8eGN5IKtbpRd0ER-s
Message-ID: <CAGsJ_4z4yKRQiqMtGRr2bjvgVY6mmujdqyKyVgid=RUXr_9TbQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] Improve Zram by separating compression context from kswapd
To: Qun-Wei Lin <qun-wei.lin@mediatek.com>
Cc: Jens Axboe <axboe@kernel.dk>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, Chris Li <chrisl@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, "Huang, Ying" <ying.huang@intel.com>, 
	Kairui Song <kasong@tencent.com>, Dan Schatzberg <schatzberg.dan@gmail.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org, 
	linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, 
	Casper Li <casper.li@mediatek.com>, Chinwen Chang <chinwen.chang@mediatek.com>, 
	Andrew Yang <andrew.yang@mediatek.com>, James Hsu <james.hsu@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 8, 2025 at 1:02=E2=80=AFAM Qun-Wei Lin <qun-wei.lin@mediatek.co=
m> wrote:
>
> This patch series introduces a new mechanism called kcompressd to
> improve the efficiency of memory reclaiming in the operating system. The
> main goal is to separate the tasks of page scanning and page compression
> into distinct processes or threads, thereby reducing the load on the
> kswapd thread and enhancing overall system performance under high memory
> pressure conditions.
>
> Problem:
>  In the current system, the kswapd thread is responsible for both
>  scanning the LRU pages and compressing pages into the ZRAM. This
>  combined responsibility can lead to significant performance bottlenecks,
>  especially under high memory pressure. The kswapd thread becomes a
>  single point of contention, causing delays in memory reclaiming and
>  overall system performance degradation.
>
> Target:
>  The target of this invention is to improve the efficiency of memory
>  reclaiming. By separating the tasks of page scanning and page
>  compression into distinct processes or threads, the system can handle
>  memory pressure more effectively.

Sounds great. However, we also have a time window where folios under
writeback are kept, whereas previously, writeback was done synchronously
without your patch. This may temporarily increase memory usage until the
kept folios are re-scanned.

So, you=E2=80=99ve observed that folio_rotate_reclaimable() runs shortly wh=
ile the
async thread completes compression? Then the kept folios are shortly
re-scanned?

>
> Patch 1:
> - Introduces 2 new feature flags, BLK_FEAT_READ_SYNCHRONOUS and
>   SWP_READ_SYNCHRONOUS_IO.
>
> Patch 2:
> - Implemented the core functionality of Kcompressd and made necessary
>   modifications to the zram driver to support it.
>
> In our handheld devices, we found that applying this mechanism under high
> memory pressure scenarios can increase the rate of pgsteal_anon per secon=
d
> by over 260% compared to the situation with only kswapd.

Sounds really great.

What compression algorithm is being used? I assume that after switching to =
a
different compression algorithms, the benefits will change significantly. F=
or
example, Zstd might not show as much improvement.
How was the CPU usage ratio between page scan/unmap and compression
observed before applying this patch?

>
> Qun-Wei Lin (2):
>   mm: Split BLK_FEAT_SYNCHRONOUS and SWP_SYNCHRONOUS_IO into separate
>     read and write flags
>   kcompressd: Add Kcompressd for accelerated zram compression
>
>  drivers/block/brd.c             |   3 +-
>  drivers/block/zram/Kconfig      |  11 ++
>  drivers/block/zram/Makefile     |   3 +-
>  drivers/block/zram/kcompressd.c | 340 ++++++++++++++++++++++++++++++++
>  drivers/block/zram/kcompressd.h |  25 +++
>  drivers/block/zram/zram_drv.c   |  21 +-
>  drivers/nvdimm/btt.c            |   3 +-
>  drivers/nvdimm/pmem.c           |   5 +-
>  include/linux/blkdev.h          |  24 ++-
>  include/linux/swap.h            |  31 +--
>  mm/memory.c                     |   4 +-
>  mm/page_io.c                    |   6 +-
>  mm/swapfile.c                   |   7 +-
>  13 files changed, 446 insertions(+), 37 deletions(-)
>  create mode 100644 drivers/block/zram/kcompressd.c
>  create mode 100644 drivers/block/zram/kcompressd.h
>
> --
> 2.45.2
>

Thanks
Barry
