Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0333747A0C7
	for <nvdimm@lists.linux.dev>; Tue, 28 Jul 2026 21:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785274200; cv=none; b=YdGN7dfleneTemUoYFXeP905XiJXz2CEht0fg8xSelaWGSNX9pj2zqJbcIGAdWni0JFdoKGcEvpjVOkm1DNQvlNKz0G1WL5g0blhexIJ38bnuETORCK8L4cDELSdibpyeKP+njBoD3x7u0mJgl8G22tEc2bj/fBGMkJME2dnU2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785274200; c=relaxed/simple;
	bh=XDQjNbbhKar8uY0avv/kD/aMx3Th5Bc2yUeUMO7wAXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fRvOhhvd6oRM3SNqLrvXn7H/xhvWQ6ZL7vDzavHnG/tRUZ61HEpDrCU8i5oCB6ENHeNXmptM+OCsD5aEsh+Aq5E898PFTa3QDhkycgud2749OgrYzDCZeOxfYDXIk4j34qZlvFUxhGeg8XjjZogbgqp0Gxuwc3ER48tizNy9tFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fnt5riJK; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fnt5riJK"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-47c2b362ee2so277013f8f.1
        for <nvdimm@lists.linux.dev>; Tue, 28 Jul 2026 14:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785274196; x=1785878996; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zGURBnMw6fzU2CZK+DQfnrMi2Ya0rXE6R9ZmtmaHTkk=;
        b=Fnt5riJKSgNjJ4bA7zETUN7hJIKoKOC1dKqJ88g8P+4TbLIYF2/DxcjXFNiQNJzHOf
         XQ993g+U06F2P2dmjY0sPWpDUg+KuDhC6Yr19KkQfl4AU7W2mVQZATA9EvQ4ItESkPQz
         f9lLS1F0xIEmsvtMfyTzww66N0tcSCsRjLPeQ87OpX2TGJo43EZFj2cz6tAsJTNjsdRC
         tWwAZ6xEIfXDV1X/IoTx84Eqqi8LXXboitd6YaRK0foWmWP9GiL/egcc0ajkN+rU4sI2
         /hOUzMN36BLyPtOJw3hsQH0PlclIE02CjVKpMMyMAZlkerJb4Kte2h9kXAPzcL8+xTR/
         8IoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785274196; x=1785878996;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zGURBnMw6fzU2CZK+DQfnrMi2Ya0rXE6R9ZmtmaHTkk=;
        b=YSqRvsl8CkSqcdERg+UBp/EAqCPMZGbMueHYdoHRypwutz7h9NkrWXDN4zsiX7zY/E
         LyZx4WKnycxSYbKwXoG7hOGvFYb3JOD+HKH/DD3NDIn/Tom0+qjJdqMTWujGcy8XKm49
         HKXz1Ln0Ghwu7aPf4O1UJkcsBuJt/+2i5pyRPoQ0xURAkMhgQ44m83/Yfqv3T3Cm4arw
         yrckVYK5/BZVZJYm4oa9oUGCN3gFeN+E5bZzePZz1b2Oj6ED7PWMOtw6hvxt3n+MHBJL
         4P5Kh7PhhW+WKH6xqsE/BEPcvcsyHttRpyUTzPj+Y5IdeXIehrWyXhJLtvIvv3HBw4Yr
         HW4w==
X-Forwarded-Encrypted: i=1; AHgh+RrhwJ1eSKTGpd9Is3Q/qCPuUIh79yM0NKVqVpDiVUlpz0bHgbYGhoP9oMxeTeM2VPAxcmuqyMI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw775QTOoOmI8vm740cqUb8hVAvdSHob0dew9ZELKpUAR/fNCJz
	cpViTN5qo8rLlRraN10TvUHSGDonN3+5n32NGO8FilHF7dXc9TZvJ429
X-Gm-Gg: AR+sD11mZI1sEBEPkiLJxMuPz8H9yJNqHU1GI2wtrgdvMNyA1JBHuOtnAYEKFCYhq6l
	9J1nO0U3Uwk3EdY5E40yFhPHzfsYt5stTz5Co7E0YTUXPigyOoz+kZ24zcKF72e5KmJKEyVOHYW
	r1y0MeY2IQLpbGABVbkYdsH7tNI4AbBNBCm+d7ZePHD5KQ2Btuxi6zotlY/7krt1baEGREYisMM
	hWS59r1jegXHKW+4jt62oT1sp84P3WPngh4VDC/d0NzpuMf3C3ixyQjGQkKM/4KtukaEr9wOlKg
	wdfJC1wN6SN/TNui4QA1zxWeKn7iAihEVM4LOy+DuySZpWMUu2ABI759ZMhW9/QuHVxGO45n0/d
	cNd8Eo6a4UnyvEvz6RLNEpgrtdEp0ESQewZD7M+WLyATUB2WsAAi0UIN2sOndrS8RWQet7NIlm2
	Gx77BPn6dRV8zBAjab4sMIPF59cMpaQI5V/gDQy2pNkLTqBfnep4YM4rgzMxzLxtAZUt+mNkdga
	7YAU/mO
X-Received: by 2002:a5d:5d09:0:b0:47f:94a8:d6db with SMTP id ffacd0b85a97d-47fb1f14a61mr4656094f8f.34.1785274196213;
        Tue, 28 Jul 2026 14:29:56 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fb6ac44bcsm2245329f8f.11.2026.07.28.14.29.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 14:29:54 -0700 (PDT)
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
Subject: [PATCH v4 07/14] block: forward init_dma_buf_io_ctx to drivers
Date: Tue, 28 Jul 2026 22:29:19 +0100
Message-ID: <e0cc82a15419ba7b38eb0bb00ae34cf3d0c3a938.1785274111.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1785274111.git.asml.silence@gmail.com>
References: <cover.1785274111.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a simple proxy implementation of init_dma_buf_io_ctx() forwarding
the call to a new struct block_device_operations operation.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 block/fops.c           | 14 ++++++++++++++
 include/linux/blkdev.h |  2 ++
 2 files changed, 16 insertions(+)

diff --git a/block/fops.c b/block/fops.c
index 37d491f45015..d83cdbab65a6 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -926,6 +926,19 @@ static int blkdev_mmap_prepare(struct vm_area_desc *desc)
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
@@ -944,6 +957,7 @@ const struct file_operations def_blk_fops = {
 	.fallocate	= blkdev_fallocate,
 	.uring_cmd	= blkdev_uring_cmd,
 	.fop_flags	= FOP_BUFFER_RASYNC,
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

