Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D346F3C196B
	for <nvdimm@lists.linux.dev>; Thu, 10 Sep 2026 20:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789073729; cv=none; b=V3SNQZ+42sEHG4nSuDzBjo2/356vse6xb8d0gEqVCNdnoZRYqAt4fUqy7txWXhAk4dG0AAzoJSgOyzzKkWzRt3w33D/ACSmZMxQWke2e/YM9Alkraqgu2FeJwonNtougQfreoat9SE+Rhna9CTHyH0557zOUeTlsuI4KCApmqZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789073729; c=relaxed/simple;
	bh=hFrf47wiCRa+Xp/RSbKkY05XcZwBmlybD2veRYYsg0I=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=lw+fb476xC+PywaWwvX3vZvvNToxzwEXql1D43bjN3TbjRMkvwng1mMwc7rhWXObGpPvGFBbE04F0pNfAUyz7dOI+ycpSGa2EX9L1D+s+hJgjXNfRw5/I8TMHJyTHzOWrRSbkgktOZHfs2RFdaoPF9js6QAWXAvP3hy/EIqx7o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=NC8MC8Yr; arc=none smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="NC8MC8Yr"
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-7f3f52143cdso214012a34.2
        for <nvdimm@lists.linux.dev>; Thu, 10 Sep 2026 13:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1789073725; x=1789678525; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pkbEmlLYOqHu2rT/pG1b8F4ZrumOvKHVAf/LIvXXM5Y=;
        b=NC8MC8YrWXVm6OvYPakfo0XLgjPJpuQ9f1DkwsOCM8NQ6WFvspW/KvI8xAHHsfnHVN
         aK3jcd9vFEiCq0DSsPIXM8IY1+pHj5klZhw0T+KZxt5SlM3dbGWLYZjF7S083UTHyG89
         ftfHIIU5ZjwAgQuc6NDTlWWWhFApFsVQG+IjyZhMYWsLi1upPWCK3C7Wn+TuNtmK47+f
         04QOTvlnskpj7inzTcKweiQPk+VwuRxnVvQqrMgJLpkgryUBAq/j8ydguvn+JIuw0Gos
         c+E+u0HL0kbrBSaW125lSsXQB07S5SXOgDjbdiZvpBPpYD9yvMnA4Mf93QmWihuTZJtw
         IHlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789073725; x=1789678525;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pkbEmlLYOqHu2rT/pG1b8F4ZrumOvKHVAf/LIvXXM5Y=;
        b=nUdPSCm2wayz5tTanqBvax3vISOgy1kpJwxDKhMyaSj9cCtQ0/G5h7NIsIYFjeUP7a
         9A5jX+zY7ZKrsVtXTUyKVxWJHzSLmNKsphcxJ8XV0gOeKoo9bAp/MFz2q6PIHbYB5VaY
         K4ZdrXp46Hsv5LqT/ME6WRJXmULthnUG/cheR/jX70k3+zJfo9EPB6i+vehtnHHNbX23
         8UTKa9Cp9RdvBudHrDT5x+nz/ExO9Xsd2rIog/XYJpTe4yFKFpxbqYNYUftWWzvoC0GX
         8lczmJmJKm9LrrjRRkrUMg+UAYALyzqQrEIFnP8F8aItc0YUccKI0tIqt8Bm9r84xEaF
         xbdg==
X-Forwarded-Encrypted: i=1; AKwUvByilPLiLVGzkmvuQspV6aqCeRDOjdGVlZ1OwZFKF1Ve3asX2hdRdQG5V1eZ5HDrV+CoCf6sdeQ=@lists.linux.dev
X-Gm-Message-State: AFuF++lckWmV2q57Z2mJS/K8aCnDUhYcSVnSljdfH9k7AcCYW00u/52t
	iKZbvHgruIjFEailJp3pulzVPBX1gOzZpPcJZWKTlCWs8Bd8lLvGO9nzg4Hjh+U1PR0=
X-Gm-Gg: AYBFou1+JkrWe/IeBdpW7QmGm+w28vXo+Jo12eF/BxL1jmY1Wh2PgI3KUpiydwgG0e7
	2Nry0wwoETnkvQQOVpYqHyvQOIJaVNVumNXYkWM0Ya2woW4vb5xz1jsa8r7XDqTnXhwOcEyJt15
	ev2YryO1sa1Cn47Gv6tIFrLbZHINkryy2lFhW4QEwPSbjiD5hgk4zHRaPMNkjIoZmEtdg28hhUR
	3vHVKsaZHrA+xGzE8Bxk6Q4rTapv6hqQIHw+QiPFpaf12qYYSyiwqm/mppc1wKMMBizxYTcVMfT
	vGyocigJLV5B+mAKjOEzC+2HHJmvh6m+3eBZ8fMMDvu1REdCM7nFwh6AGMqEG8vK/6BpbwF2cr1
	T33cSz49AnhHv6/mUw/8tzi/cZBTOLUbhgH+mYHE0J05GLjvLVNTK0Dgja0QjMPegDJxy7OmPnA
	si8em2dC8KN9lpbgynWSKisAijUY8ad/t//ynpKjuPQcyLCCkuUDYr+cw7cVF4Jb58uleMVwVC8
	f/9X//xUdHIinBqebvviTGiGxHgKTzkcYdc3xsK3mzNh1GkY2c=
X-Received: by 2002:a05:6830:2702:b0:800:d883:997f with SMTP id 46e09a7af769-803fec02e59mr471619a34.2.1789073724704;
        Thu, 10 Sep 2026 13:55:24 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-803f60fe54asm635779a34.15.2026.09.10.13.55.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 13:55:23 -0700 (PDT)
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
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Nitesh Shetty <nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>, 
 Anuj Gupta <anuj20.g@samsung.com>, Tushar Gohad <tushar.gohad@intel.com>, 
 William Power <william.power@intel.com>, 
 Phil Cayton <phil.cayton@intel.com>, Damien Le Moal <dlemoal@kernel.org>, 
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>, 
 Benjamin Marzinski <bmarzins@redhat.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, David Sterba <dsterba@suse.com>, 
 Ilya Dryomov <idryomov@gmail.com>, dm-devel@lists.linux.dev, 
 nvdimm@lists.linux.dev, linux-btrfs@vger.kernel.org, 
 ceph-devel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>
In-Reply-To: <cover.1785596451.git.asml.silence@gmail.com>
References: <cover.1785596451.git.asml.silence@gmail.com>
Subject: Re: [PATCH v5 00/16] Add dmabuf read/write via io_uring
Message-Id: <178907372259.484803.15807864431748251506.b4-ty@b4>
Date: Thu, 10 Sep 2026 14:55:22 -0600
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2


On Sat, 01 Aug 2026 16:46:12 +0100, Pavel Begunkov wrote:
> The patch set allows to register a dmabuf to an io_uring instance for
> a specified file and use it with io_uring read / write requests. The
> infrastructure is not tied to io_uring and there could be more users
> in the future. A similar idea was attempted some years ago by Keith [1]
> (from where I borrowed a good number of changes). Later it was brough
> back up to life by Tushar and Vishal.
> 
> [...]

Applied, thanks!

[01/16] dma-buf: introduce initial file I/O infrastructure
        (no commit info)
[02/16] iov_iter: add iterator type for dmabuf maps
        (no commit info)
[03/16] block: rename bi_bvec_done
        (no commit info)
[04/16] block: always adjust bi_offset on bio_advance_iter
        (no commit info)
[05/16] block: move bvec init into __bio_clone
        (no commit info)
[06/16] block: introduce bio_iov_iter_set()
        (no commit info)
[07/16] block: introduce dma map backed bio type
        (no commit info)
[08/16] block: add dma-buf support for raw bdev
        (no commit info)
[09/16] nvme-pci: implement dma-buf backed requests
        (no commit info)
[10/16] nvme-pci: rename nvme_pci_sgl_set_data to nvme_pci_dma_iter_set_sgl
        (no commit info)
[11/16] nvme-pci: add SGL support for the dmabuf path
        (no commit info)
[12/16] io_uring/rsrc: introduce buf registration structure
        (no commit info)
[13/16] io_uring/rsrc: extend buffer update
        (no commit info)
[14/16] io_uring/rsrc: add uncloneable regbuf flag
        (no commit info)
[15/16] io_uring/rsrc: add regbuf import flags
        (no commit info)
[16/16] io_uring/rsrc: add dmabuf backed registered buffers
        (no commit info)

Best regards,
-- 
Jens Axboe



