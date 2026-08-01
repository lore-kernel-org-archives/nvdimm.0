Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08BBB30CD89
	for <nvdimm@lists.linux.dev>; Sat,  1 Aug 2026 15:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785599384; cv=none; b=oVx9pBmHfm30XgD0HnOBqmlN7pEbFE5SZ4pcg15Bn9z4sFnNtIWsA+RCs0t5mY5T4jMst2VitTWy4Utq7hy+4qcASRYIW/FzNEXUSOjxQIGfwaeoy8e0AkiZnAhhMqfeM5E0M5aYCt95OQ+gFuVPpKREIZBKQmQRkoiCb64/VzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785599384; c=relaxed/simple;
	bh=g0r+cM2oJU8p0aW6ejF1reDF155X4adWxCLLoLHu2uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eMycrzyJgmirUtBvRvKC4r6mR+7duIPoHf45eq/Hw6oDncyiaNHNi0pizbtnGw+/YS0MWmRo0u7s6gDZiwYH7PhGv2bUuoZHWvY7/7Uj2LFUAGlt2YUR0hL6VO4YdGbKTSNgaDNWsjOEgAvVWtS/m28wKEGJn/3QKHWYXnHS7DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=stDDuVVP; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="stDDuVVP"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2d049069377so14209165ad.0
        for <nvdimm@lists.linux.dev>; Sat, 01 Aug 2026 08:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785599381; x=1786204181; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XTGwQGVc0bqlcGV09Qbia8ah/Xj1ofLPkaifBOkmHiQ=;
        b=stDDuVVPlSk3XTqqq7SRYMSbxX9eOS94G8E93IEAYFcnxDwzG48zdhJvmy3zzYw97u
         vx0GuRTwT142G8BXVdEca7eB0P2KtTOmnvGQRmyHAUDPrBW9TsUbMS1TRoMv0ixUdB8D
         DfKOMd7+oVdkgEm0SYmCOF7YbIyKuLBOpW0d9SfnmOP69gjBjoyCNPlPQd4h1z42iV/y
         fx9F0yiZwSmeUuKNCMmjvCQrBNpSjfEVkyC9su3EJMjyx6qYIBGyDXP+58BQ7aCzgl1j
         J+Rkm+8tzPm8mdLPWD9hbJFzHjLi/HufjfqzGgEIIOU9JWjpRpYdL+naFuIYjBZIaXsM
         2DvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785599381; x=1786204181;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XTGwQGVc0bqlcGV09Qbia8ah/Xj1ofLPkaifBOkmHiQ=;
        b=K1hoAFCcN0V6PGa9h8P2IBRLJspOQ0ULD/U0LVLstyaFMPtePqA35J/FC0+yX75Q6+
         A+cbrO/qZL+j/Tcd8i25S2472/Bz4SbzB3a/dqjTKgq9gnnBMlS0DhS4x+I96nyWOeJB
         AZT9N3nfwvNW6qIuhnwqdzJ/J64qCgxmipseDCAc82oC1q4GAp2LQPOZ8E2MR6G5bhem
         m5dkA3Is+FXWWgnztBUDOqySL/r3McIkslf3Xp34GwLdhHdShGGev2yReCcgaVnfqqbK
         NvF3KEdQ+6LvSuhrGe2RP7V8lMphdylnWINeI1bP4ka5nHK818TBW7iCMaUjca80lRzn
         KUQw==
X-Forwarded-Encrypted: i=1; AHgh+RpBrmx+N9vKuoNNnBvUQDKp8Ibw6vYnIFXx3dBST5S/GvWkI65HkFR+d9V6MC/lZhCvMavxSA4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxGDLiZ675I0yA/H0QmbqnZiEjD3TqQN2Z/wGMbMKtpBof9Zfuv
	ndYfeUdc/BHkfP5ACCFtYrTlIe05r/+mS/kIcALhyBjCQ4q6dJ5/64jy
X-Gm-Gg: AR+sD10UUeqELmkk40qcxXQosgIgA/ec0GgB6dSOQ2pouOWhi6J0EWvOi5XAfT4mKi+
	SAfnhBWd63jAnK9dKNKKAORr/fkihIk2+0G4WSWRnu9EeBPCKHqLK/pS9+7DpyW9A9GLVfWPvtz
	PkVVIBBPPGb+9uLVXtK45QPuB0+dh3u+HihjGhWb+RURI7Uq8Hcq13w7DwoS1P55dsi+pXa76RB
	xo0TnJe2DiimDc+bbxutTrVPTJ4xlHRbNiljjaWRDkUGWA32hYrhnkYXrtD413NLfT90jlrphE2
	rXBnPFPzGY7eLYh/ts7jiA+xYBYXS09ocBQh7H4khiXIfEvUNKAKD1Yg5WMSrqlHyLNHbLm1Bxp
	1RrUqphEY69ooAhtXk0GcCF5qC7TevHJ5czKnUW370qHvW+p1hNyJlUHxW9D/gHVx0Oc9skVvHu
	+DZe725K9KRoVY61pNv++jza/rjvP7XT+Oz/NaeGBqgwPp2HDN7KcAPgwsIZfrmoQ2DyWPEqS7b
	2bFlskD9b6yZxQi4aGukTdw87BJ3aQPBidkp+XxzeW1skk=
X-Received: by 2002:a17:903:2450:b0:2cf:9347:f445 with SMTP id d9443c01a7336-2d05219f5c9mr36286255ad.10.1785599381195;
        Sat, 01 Aug 2026 08:49:41 -0700 (PDT)
Received: from 127.net ([2620:10d:c092:600::1:61d0])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04b12202bsm18287605ad.66.2026.08.01.08.49.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 08:49:40 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org
Cc: asml.silence@gmail.com,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Tushar Gohad <tushar.gohad@intel.com>,
	William Power <william.power@intel.com>,
	Phil Cayton <phil.cayton@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	David Sterba <dsterba@suse.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	dm-devel@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-btrfs@vger.kernel.org,
	ceph-devel@vger.kernel.org
Subject: [PATCH v5 08/16] block: add dma-buf support for raw bdev
Date: Sat,  1 Aug 2026 16:46:20 +0100
Message-ID: <b32dd786296e1683378c9e037e2b9f26ec24fee8.1785596451.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1785596451.git.asml.silence@gmail.com>
References: <cover.1785596451.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a simple proxy implementation of init_dma_buf_io_ctx() forwarding
the call to a new struct block_device_operations operation. Also reject
dma-buf backed iterators for buffered IO.

Reviewed-by: Christoph Hellwig <hch@lst.de>
[pavel: reject dma-buf without O_DIRECT]
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 block/fops.c           | 19 +++++++++++++++++++
 include/linux/blkdev.h |  2 ++
 2 files changed, 21 insertions(+)

diff --git a/block/fops.c b/block/fops.c
index 56bbacf6e317..3c403afb0f64 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -767,6 +767,9 @@ static ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
 			ret = direct_write_fallback(iocb, from, ret,
 					blkdev_buffered_write(iocb, from));
 	} else {
+		if (unlikely(iov_iter_is_dmabuf_map(from)))
+			return -EOPNOTSUPP;
+
 		/*
 		 * Take i_rwsem and invalidate_lock to avoid racing with
 		 * set_blocksize changing i_blkbits/folio order and punching
@@ -821,6 +824,8 @@ static ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		if (ret < 0 || !count)
 			goto reexpand;
 	}
+	if (unlikely(iov_iter_is_dmabuf_map(to)))
+		return -EOPNOTSUPP;
 
 	/*
 	 * Take i_rwsem and invalidate_lock to avoid racing with set_blocksize
@@ -924,6 +929,19 @@ static int blkdev_mmap_prepare(struct vm_area_desc *desc)
 	return generic_file_mmap_prepare(desc);
 }
 
+static int blkdev_init_dma_buf_io_ctx(struct file *file,
+				      struct dma_buf_io_ctx *ctx)
+{
+	struct block_device *bdev = file_bdev(file);
+	struct gendisk *disk = bdev->bd_disk;
+
+	if (!(file->f_flags & O_DIRECT))
+		return -EINVAL;
+	if (!disk->fops->init_dma_buf_io_ctx)
+		return -EINVAL;
+	return disk->fops->init_dma_buf_io_ctx(bdev, ctx);
+}
+
 const struct file_operations def_blk_fops = {
 	.open		= blkdev_open,
 	.release	= blkdev_release,
@@ -942,6 +960,7 @@ const struct file_operations def_blk_fops = {
 	.fallocate	= blkdev_fallocate,
 	.uring_cmd	= blkdev_uring_cmd,
 	.fop_flags	= FOP_BUFFER_RASYNC | FOP_DONTCACHE,
+	.init_dma_buf_io_ctx = blkdev_init_dma_buf_io_ctx,
 };
 
 static __init int blkdev_init(void)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 9213a5716f95..9f4c92e51dc9 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1682,6 +1682,8 @@ struct block_device_operations {
 	/* returns the length of the identifier or a negative errno: */
 	int (*get_unique_id)(struct gendisk *disk, u8 id[16],
 			enum blk_unique_id id_type);
+	int (*init_dma_buf_io_ctx)(struct block_device *,
+				   struct dma_buf_io_ctx *);
 	struct module *owner;
 	const struct pr_ops *pr_ops;
 
-- 
2.54.0

