Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26AFF477993
	for <nvdimm@lists.linux.dev>; Tue, 28 Jul 2026 21:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785274196; cv=none; b=l8g1OGB9crIgVpEhwvx3J3HqjYWTc4oB99hCnv1AM9R3EjjLVgUmnupO2Z0h8f1voBoRTS4hZP72ZRTho2dTXArl78nkBznYLSFjenE90LiH9GoJkTxgovrZ9X1wf+MGs9/Fv3za8qOT7Jd+NCv3F2+8s18w5g+OaD4PxhdP2Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785274196; c=relaxed/simple;
	bh=ouxAbpVq3eLeqOZuflcAiBfEtTkTCcnamxD+XK6c374=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=icNHYpvV6w+LgmhHq0lxqbpX9eVTzSKM0PLci/KwjdXHVVrRc1ocvrHSuGZ0JFBo7qwTdT5pcGc8pMihJMSnSVBxv5JWUTi/Llw/xsVANoDWwUlQgSVkZ3qdXCbh87Fc2uykgRNrHOTon54kFM3972bL1+jhKX5sZLXVgskHu9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZptgMb/c; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZptgMb/c"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-47f703a9d05so213549f8f.0
        for <nvdimm@lists.linux.dev>; Tue, 28 Jul 2026 14:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785274192; x=1785878992; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3L2paztWhQuVkOkPSkB4LVS1c8WWkooOhtLcip+4H4Q=;
        b=ZptgMb/cooJgciTPJ68X6/nfQ/LQGoAQyR0Y3jMYs0hDBaFD1Tn4I0E0JSYJVvpHaW
         t9wS9P0CFaCNz06+JJXhtq0h+ERXUoYgiz10zdEe61RnnbARXyA3C1zpMdPQkZmrljdR
         aXsyyZwrGsKr2g1Wyck8ZfwF4H5xAt8pI+DGXoFakLXpVX8FK3wV5o917U3GYXpHXHZA
         OTcsqK8YxUSauTtk2tcpCi7LXvomoo6ml9Xm1p6vhjs8Uc/m4+FeQfUPrHuvSXnTBZ/t
         VKMPOZxcPSZMMVJynW4wNIB3G8KqjO81Ygyr+eb94oG135VmS38PmG04Fo8wz1qgKQF+
         TC7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785274192; x=1785878992;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3L2paztWhQuVkOkPSkB4LVS1c8WWkooOhtLcip+4H4Q=;
        b=USYMF1zZEGgGhgw40XmWReD1NOsm8lLuV/Y84cXmI2++lZRyykw9IzXHe8sbgSbKFC
         slrTBILqX1d1wl3WJ6l2b2Qxqtpzo8aPqLXDlEbgPxufIDqX5dh4TgmL4o7BMerdlcT5
         EjvfYZZ7XkySzKrBXBJtKebBhM3yoR7NlAN8WqUQXNWAtIH+yAgHHc/IybQdVETOL5D5
         chO9f59NbHBNN5D3YYmhhzO12tPWV4GY23m4Ko+WAD2cnwcynuR6dI3eCD2ce9tsSXzO
         fB7MhIx1dfD95Uwsoib/t2LxgLCUVdDmOkNtoaenFDGk9ZZ3uKLOpCNT0a1A6rZ2+WM6
         bCng==
X-Forwarded-Encrypted: i=1; AHgh+RobJe18BIig0r73T01CayiZbn9lwYkFOp0pecEowb7MgFfcrw+G39ex1K+l6t7BOjzs22QuDgc=@lists.linux.dev
X-Gm-Message-State: AOJu0YyxDd2FXGUWEOWPMY3JNXmTjloAfLuvaUzQeRxDWcb1Oe38ArG7
	1oOVxRCwB36ESJX8XXr5Bxt8el/uoteGYx9HYgF2Qd2oGPJ68jXHl2TP
X-Gm-Gg: AR+sD11CXvYSv61UZLt9VyRBluTurGBLUUBf4JQnlARail/bogGITmWR7qUfEageZ9z
	/H+Jci3/4B1sqVm75h3LoD3LkhOLfiNuS3f6+hG8lTT+6EAUUUYNqSA7r+5vKg6f6pTQEBxaYMf
	zYD+ZwOp+KTzTV2fe42alu0xD/e2v7pY6UPJOnO/xqgvjisEl9qTQHWUY+zf/QQxuZX1eLxKJOd
	TKFqJl0FN7cgKxGWsAf+QAG5t64F4b3f1w13b75YOhYBYlO05piopvs/eoKTVLwj/WRB6HhyoVM
	T03N4xJSehKrNzJCMaHgPwh4LQ/E8Br2y62IZDAVnsC16zfEEtWShFrPGo5Swq48JmtUGciY01M
	+CV6cquvLVfSxBiiROL7Zz3yE8pe3CnCSqQFOXI0ELjXqXjYeBbLLryNiLOB05QoizBMeGiLYnT
	NzApFAIb+Q50B7o95JixGvWD8TFTX68C0DWbNOWnwMkxjk0heCABP+ep64c1w5Ccu0aeAH7NbnN
	7rR1Flp
X-Received: by 2002:a5d:5d06:0:b0:47f:947a:9dba with SMTP id ffacd0b85a97d-47fb1e5ce09mr5390953f8f.6.1785274191852;
        Tue, 28 Jul 2026 14:29:51 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fb6ac44bcsm2245329f8f.11.2026.07.28.14.29.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 14:29:50 -0700 (PDT)
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
Subject: [PATCH v4 05/14] block: move bvec init into __bio_clone
Date: Tue, 28 Jul 2026 22:29:17 +0100
Message-ID: <7423d294c6184c683d7b2ccddf060b4a308e0316.1785274111.git.asml.silence@gmail.com>
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

Consolidate bi_io_vec assignment for cloning in __bio_clone to keep any
further changes in one place.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 block/bio.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index bfaede30a54f..57c127aee116 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -860,6 +860,7 @@ static int __bio_clone(struct bio *bio, struct bio *bio_src, gfp_t gfp)
 	bio->bi_write_hint = bio_src->bi_write_hint;
 	bio->bi_write_stream = bio_src->bi_write_stream;
 	bio->bi_iter = bio_src->bi_iter;
+	bio->bi_io_vec = bio_src->bi_io_vec;
 
 	if (bio->bi_bdev) {
 		if (bio->bi_bdev == bio_src->bi_bdev &&
@@ -902,8 +903,6 @@ struct bio *bio_alloc_clone(struct block_device *bdev, struct bio *bio_src,
 		bio_put(bio);
 		return NULL;
 	}
-	bio->bi_io_vec = bio_src->bi_io_vec;
-
 	return bio;
 }
 EXPORT_SYMBOL(bio_alloc_clone);
@@ -923,7 +922,7 @@ int bio_init_clone(struct block_device *bdev, struct bio *bio,
 {
 	int ret;
 
-	bio_init(bio, bdev, bio_src->bi_io_vec, 0, bio_src->bi_opf);
+	bio_init(bio, bdev, NULL, 0, bio_src->bi_opf);
 	ret = __bio_clone(bio, bio_src, gfp);
 	if (ret)
 		bio_uninit(bio);
-- 
2.54.0

