Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967CD6A035
	for <nvdimm@lists.linux.dev>; Tue, 20 Feb 2024 13:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708435325; cv=none; b=KMEa2d284Vgt99SxJZylBMnczi2z12/ufy4atU24X/WzGJyZB5VO9fRph6sqA9yrc5nJy5WDCRgQ8ID22vf6xS36d/L/i7X/N7hz/JLS39h51f38feXnkYvL3rISRrXuZt/JOIPl1k/2EwhQjgX33giKnn/nHHAT9z+wVj77tcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708435325; c=relaxed/simple;
	bh=3q84UebxO+IhnMV8qY+OCVsLMfCwqQIckMDPCnOjIso=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=h4ZaKy2DT28CfZOPNIN8PzToscJBGf8AcEX4HV4XcCerMEpbcL5CDqBB5kgdbYM5uJMPr/MMIPaD35/rVL+Qjcmw0PK/2LOVoLYblK7wCMfsjkunB07ay2aMc8/hSE0fw9n+Aw+nJzKnJHgOyEWAkGe/RMX64uPj/U/KA23SYPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=vXdfL1Oy; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="vXdfL1Oy"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1db8f32cae5so7457185ad.1
        for <nvdimm@lists.linux.dev>; Tue, 20 Feb 2024 05:22:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708435321; x=1709040121; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HEAQQIO5cXmeHaxWtI/kIw0AxsNxruezROUdauKPKd8=;
        b=vXdfL1OywB58wucz78Zqlv6l7d7jNeJHQRNNaO05k5z2p816TR80PiqQkoxTMfpx66
         x1xSZ3X2HvVYPNO2J3p3nw6quLTkh+ASpMoTm/clpUvEdObmPkusGFETqTWOli6PKH4w
         TUutg/1NbTG6JDg0G9hlU8sdkD06DbBvynjq9OoNOap1RfleKdD2yxNb5K912rTJA16K
         eEddL+kDKCLu9iyTqWlpms9ksQ8KktDi93CNwcOarrTogcR+gn/lSQoppUmQRkAOasEe
         lKiyaW17n7kj4uHGuY4C8wU8lcsMyZlu2DJpaSVnXvxyeGlydz6j4J0Wy+4BsAg18x5+
         4tng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708435321; x=1709040121;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HEAQQIO5cXmeHaxWtI/kIw0AxsNxruezROUdauKPKd8=;
        b=RnV8MW1UVjADAkHVlkKERz+tFCgfpUilGvFL4q3jDHs78iZp8lQlrOB9ffBY57+KCO
         08fHnDIXRnQ42oxeZYvUqOJLNWpL9B0r4VYcFB3eCBdV/wowiH/9S7ReEFt1/kkSHlxF
         sShdIRPISwUBVNBlJe11dHyWQmWNgv76R5ovW5X+gpg04CuOZrw7EOg0mpJBFhwqalQa
         eRV8UX9VAsIIwKmOL2KQ6E5ftj1nkCMY11FZxJL135Z7sbW6PKFkoSA7izB3oRmHZxzT
         LycgykQ3aE/c8RjK7s05qjZQglsN4nejl7m+RnbpGmNXXvNFd5WZIa20RRqz3hZEZJUL
         Y3lg==
X-Forwarded-Encrypted: i=1; AJvYcCWE8fV1eihlGXxXhdbytK+vHOgns2NnbzRxPaWwYK82Q5128uF+M6AfozOinmt5h4G2y1CbK4+ppjaTwCAsKyxQm9dmRUV6
X-Gm-Message-State: AOJu0YzPc0c8rfWVOybEP2aRTKqkXq7b9h4w8LbjkXgG+vsd+STk727D
	9DlRQ+8PYR9BZdlBrL3reI0a7nwxGgJgQlTUyLxTpSjUwdJBs0sZgQTl4SW/tPY=
X-Google-Smtp-Source: AGHT+IEMwWNUM0V6Qdc3mCEsLOi+xgsjqIc+o1/9KK8l9wrn0nGXqQ1ot4iyhmAMYT1vnSnW2SKzWg==
X-Received: by 2002:a17:902:8681:b0:1db:55c2:4a3a with SMTP id g1-20020a170902868100b001db55c24a3amr13335822plo.6.1708435321497;
        Tue, 20 Feb 2024 05:22:01 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id iw11-20020a170903044b00b001db5e807cd2sm6188911plb.82.2024.02.20.05.22.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Feb 2024 05:22:00 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@lst.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, 
 Minchan Kim <minchan@kernel.org>, 
 Sergey Senozhatsky <senozhatsky@chromium.org>, Coly Li <colyli@suse.de>, 
 Vishal Verma <vishal.l.verma@intel.com>, 
 Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
 Ira Weiny <ira.weiny@intel.com>, linux-m68k@lists.linux-m68k.org, 
 linux-bcache@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-block@vger.kernel.org
In-Reply-To: <20240215071055.2201424-1-hch@lst.de>
References: <20240215071055.2201424-1-hch@lst.de>
Subject: Re: pass queue_limits to blk_alloc_disk for simple drivers
Message-Id: <170843532016.4095460.3703902225081924718.b4-ty@kernel.dk>
Date: Tue, 20 Feb 2024 06:22:00 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Thu, 15 Feb 2024 08:10:46 +0100, Christoph Hellwig wrote:
> this series converts all "simple" bio based drivers that don't have
> complex internal layering or other oddities to pass the queue_limits to
> blk_mq_alloc_disk.  None of these drivers updates the limits at runtime.
> 
> Diffstat:
>  arch/m68k/emu/nfblock.c             |   10 ++++---
>  arch/xtensa/platforms/iss/simdisk.c |    8 +++--
>  block/genhd.c                       |   11 ++++---
>  drivers/block/brd.c                 |   26 +++++++++---------
>  drivers/block/drbd/drbd_main.c      |    6 ++--
>  drivers/block/n64cart.c             |   12 +++++---
>  drivers/block/null_blk/main.c       |    7 ++--
>  drivers/block/pktcdvd.c             |    7 ++--
>  drivers/block/ps3vram.c             |    6 ++--
>  drivers/block/zram/zram_drv.c       |   51 +++++++++++++++++-------------------
>  drivers/md/bcache/super.c           |   48 +++++++++++++++++----------------
>  drivers/md/dm.c                     |    4 +-
>  drivers/md/md.c                     |    7 ++--
>  drivers/nvdimm/btt.c                |   14 +++++----
>  drivers/nvdimm/pmem.c               |   14 +++++----
>  drivers/nvme/host/multipath.c       |    6 ++--
>  drivers/s390/block/dcssblk.c        |   10 ++++---
>  include/linux/blkdev.h              |   10 ++++---
>  18 files changed, 143 insertions(+), 114 deletions(-)
> 
> [...]

Applied, thanks!

[1/9] block: pass a queue_limits argument to blk_alloc_disk
      commit: 74fa8f9c553f7b5ccab7d103acae63cc2e080465
[2/9] nfblock: pass queue_limits to blk_mq_alloc_disk
      commit: 2cfe0104bc1b4a94f81e386f5ff11041f39c1882
[3/9] brd: pass queue_limits to blk_mq_alloc_disk
      commit: b5baaba4ce5c8a0e36b5232b16c0731e3eb0d939
[4/9] n64cart: pass queue_limits to blk_mq_alloc_disk
      commit: cc7f05c7ec0b26e1eda8ec7a99452032d08d305e
[5/9] zram: pass queue_limits to blk_mq_alloc_disk
      commit: 4190b3f291d9563a438bf32424a3f049442fc3a5
[6/9] bcache: pass queue_limits to blk_mq_alloc_disk
      commit: b3f0846e720ee59291e3c5235f8a46e70dbc652c
[7/9] btt: pass queue_limits to blk_mq_alloc_disk
      commit: 77c059222c31b0480c61964f361b28a4ce111e52
[8/9] pmem: pass queue_limits to blk_mq_alloc_disk
      commit: c3d9c3031e18f145d8a12026d4d704125fe901ac
[9/9] dcssblk: pass queue_limits to blk_mq_alloc_disk
      commit: af190c53c995bf7c742c3387f6537534f8b92322

Best regards,
-- 
Jens Axboe



