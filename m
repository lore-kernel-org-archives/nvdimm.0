Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE5D4756CB
	for <nvdimm@lists.linux.dev>; Tue, 28 Jul 2026 21:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785274194; cv=none; b=ffjRrz2k0IB/zWgBoZVYabzQ/pqqMpzxxdlx5RBpCPvL8/yPF81jxiiqbjxbALe0JdMuyKcYaK8XrQp66RJDUdhpQPOefmK0bqah7movhtdtlJZHX+5taNpAGk5HBlnA9eOcR8qXGC9/0B8A2tzZp/sB1OJdBPcuKmlHZdk38lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785274194; c=relaxed/simple;
	bh=8xr8MwL4FN52J9Jpo5i7viXCOQG0jJEsaEIs2M6dEzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cEc13VzD6Uz2vTH/rwXg4fH4WRnQd+IkGa9tNooAocwLDBT5/O5CyUaVPZu4xDS4IeP5lmKNT6DMlHnGhmFeJUuVguUYSflJKIrrsAUMsZFNcuhyoMrCWgsv2JGRC23jJhaTHM9UjSA9SxgO49U96/xCy6/3WEmHvgpFH3hok5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=olqmZrcA; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="olqmZrcA"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-47f703a9d05so213531f8f.0
        for <nvdimm@lists.linux.dev>; Tue, 28 Jul 2026 14:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785274190; x=1785878990; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9CVR7oFwap/NcOYCsrr92EnvOtaWQ9jX22O00IMi0SM=;
        b=olqmZrcA0EYYNOSj2whmjGlLg4zN59FwksnXLFsPDu84NABj+qI50thPxxgw2vEnIA
         TKJ6eqYT9FTxszV54AoYnU2aVivNX8ndBtB3b0g+bU4eZA0MvrpkYRu9fHAKeYzERwcS
         r6SMvr4HdJQthM95O8hYD8oWqg00aWEUQViNztqTSXYJE/uDD9QuKYdHw/clH8yoiENZ
         h50OKML+OEFx2BCLIzd73lv8tEYdzbbOO6uKwjpg5phE+7AYpHB7VnEHYpBMV2G/Qj9P
         HSqJ8ab1QFyaB1K7vfA9i8m3YfjocdDJqdQwtPY0xDYfrOVeO/lyloRD13kYUm2JXeMF
         B3nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785274190; x=1785878990;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9CVR7oFwap/NcOYCsrr92EnvOtaWQ9jX22O00IMi0SM=;
        b=hn5EJiBEwLMEPPdziqNRGn68O6ZCb2hnr9zXJsxjdaTzI/BSeqdQYQSXSzGx5LnnPE
         fklx4G9B/Hh+Zh0PLH+sFnE4mmEV9vlb05+3W/CmRKJfG+eUTFaySiAwS3Qa9bP9hnYz
         mgB+B/wvVfRAYDDPUeVc6wxxY146rakMk1UEMVUGV+i4bi4RPseW3vgpyP5+qWjNgrUO
         xyZkMXI6eGFSsfqVTBFhuHDmu9Vg3T1dPf7lfTa3jrS7SjE+8d+4urqUjLDGGfIhE/B5
         FwjAEZ3NN34eHFqBrtB359LE6Juo2kZ5EwL5uY2jgWMBzw5xv4t3IeS6gxQD3DaTt2+6
         ESGQ==
X-Forwarded-Encrypted: i=1; AHgh+RrYiMTkxskLccRWOeQART5htFkctQEniBEV6jGtQCvEqD9aVjfeLTZ1KSbSmALrsG/8r/rjCVs=@lists.linux.dev
X-Gm-Message-State: AOJu0YzTTxg7DUK+28MSP3igfOzgxImVqWWK70oRikdWZVh2rd3UVc1S
	OnogO1b7c5cpcoW0WDY9eTn5RiLzkam7VZFwfJE+vcI1nx8tIkHjhJ6S
X-Gm-Gg: AR+sD10VsNtYm1GS2lNHlQgsBUPorYxHaLyotLYJWUId9iZu6momAXBRtyb5OAA+4Kk
	R0AeaRyGQPbvBi7U5mlvdQAX5eEONJFCLCqkcYx0r10YvWHlv2TqiQoDKw2t+159ML9QIKeNOt4
	DnsyYs8IdJJA8VmwAyFy1AsTmsITm/x3oeuYIJsUnzNAv69hOdbh+usqe4hVze3cBh/fdGqerSt
	0DM9uuQ42GDSsUOtMmU7bSMHarIzCe+YYvytUcKDPCAtR+pZ817+dWUWIXe3PXysvIzlS2lk+8q
	DKmNHYHqaymzMvInHRFvInf56c5AZokZoVQQkEMVF40zjhSE0xpafrz1xpXE2/XL5nR3chDO5eq
	h93Zku3LuSznD57sj8UGBBCmc/8NjZdI3bcWsz6fJoOk+h2W+lhO3LKZLC3Q3yPTOMc+a6B1n6k
	5a4QD5l1UNn7AX2Ha31E8y4XaI5QJmrP5hBmR3mhQSjt/IjAa3OGWLK1g5sz+zmGP5hNDeG5sq4
	zgGy6J6
X-Received: by 2002:a5d:584e:0:b0:47f:95ec:a49b with SMTP id ffacd0b85a97d-47fb1ea7d64mr4772853f8f.34.1785274190146;
        Tue, 28 Jul 2026 14:29:50 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fb6ac44bcsm2245329f8f.11.2026.07.28.14.29.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 14:29:48 -0700 (PDT)
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
Subject: [PATCH v4 04/14] block: always adjust bi_offset on bio_advance_iter
Date: Tue, 28 Jul 2026 22:29:16 +0100
Message-ID: <8d4f786e3cb9ac6002bde5f3271dcb6d22c498b0.1785274111.git.asml.silence@gmail.com>
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

Extend bio_no_advance_iter() iteration to also increment the offset.
It's not currently needed because the currently listed request types
don't have a buffer, but will be useful once we add bios backed by
dma-buf, which don't have a bvec but work with a single range.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/md/dm-io-rewind.c |  6 ++++--
 include/linux/bio.h       | 12 ++++++++----
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-io-rewind.c b/drivers/md/dm-io-rewind.c
index 04f3fc8aeb6f..b22719c6411c 100644
--- a/drivers/md/dm-io-rewind.c
+++ b/drivers/md/dm-io-rewind.c
@@ -113,10 +113,12 @@ static inline void dm_bio_rewind_iter(const struct bio *bio,
 	iter->bi_sector -= bytes >> 9;
 
 	/* No advance means no rewind */
-	if (bio_no_advance_iter(bio))
+	if (bio_no_advance_iter(bio)) {
 		iter->bi_size += bytes;
-	else
+		iter->bi_offset -= bytes;
+	} else {
 		dm_bvec_iter_rewind(bio->bi_io_vec, iter, bytes);
+	}
 }
 
 /**
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 8f33f717b14f..dea9f567379d 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -113,11 +113,13 @@ static inline void bio_advance_iter(const struct bio *bio,
 {
 	iter->bi_sector += bytes >> 9;
 
-	if (bio_no_advance_iter(bio))
+	if (bio_no_advance_iter(bio)) {
 		iter->bi_size -= bytes;
-	else
+		iter->bi_offset += bytes;
+	} else {
 		bvec_iter_advance(bio->bi_io_vec, iter, bytes);
 		/* TODO: It is reasonable to complete bio with error here. */
+	}
 }
 
 /* @bytes should be less or equal to bvec[i->bi_idx].bv_len */
@@ -127,10 +129,12 @@ static inline void bio_advance_iter_single(const struct bio *bio,
 {
 	iter->bi_sector += bytes >> 9;
 
-	if (bio_no_advance_iter(bio))
+	if (bio_no_advance_iter(bio)) {
 		iter->bi_size -= bytes;
-	else
+		iter->bi_offset += bytes;
+	} else {
 		bvec_iter_advance_single(bio->bi_io_vec, iter, bytes);
+	}
 }
 
 void __bio_advance(struct bio *, unsigned bytes);
-- 
2.54.0

