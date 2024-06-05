Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37621187BD0;
	Wed,  5 Jun 2024 06:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717569074; cv=none; b=NMF2T5b3er3UrkvZpAHnEAEZf8JzveUAR6ywCLE6jYfmMBFshxzHOgSTrxMZske6r2iIjEJ7lxJTzAoU1S++PRDpD9DF4KpIr0Tq3mSJaorDYKwIhf5TCLwtRzKQhi+gDASRdFONYVCs2sfjDKIwbhGItmSAGU4sjwd69oVQwBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717569074; c=relaxed/simple;
	bh=SwSZuCZY/YK2FDvB1hfziVZNiI0pp2MUHlJz2qHPn/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iDZXIwqlx92xZ/ZpTVupGUiVzrJrzE8jaP/UjwPX/TtN6AykK3PWAgvrc/enpVneQH9o9c0Nytgl30pTL8zLTsKPI/T/LwPDMnNzztC/MYbiA0rH27zDBtFE2t3He2ARIEsYrnYTyt+9nVKcwx3qxCpcQ/EnEOdnYUUa0RgalTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GtwcVusn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GtwcVusn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ZJ4E8GVXPKO+rXrJ94W+wcv31e2ieM2Sf//qMa2btyE=; b=GtwcVusnx+193Y/w7eqSam52vD
	l244unBtWcBKlatNPSdVVqttMM8cCY4XZ+RhzIsQQiOtzkXYvLUZWx2MvjsqGFLiV7VjxJwy8HFLx
	HxJ7ZORhgiJTDdWTN9lyjeeFWeaXaqYv94qlWrRsGkKIW2TNX2MuwmwSDUod1up0VO27k3LCQmBv8
	yFSKefnRevMCfliuIO/xOed8zNzlZRd/x+l6I9FmBfgWlb/VG31aSt6JH7Ls6viXTUhao02XbqrUb
	SoDRdbu6XC9okW+fmuVZNhFm2t2OKt805DfaE0Ag0mxfrZAgDsogvp6GhvSfZ1ZOGBukrtzH/ekZu
	IY/VhuJw==;
Received: from 2a02-8389-2341-5b80-5bcb-678a-c0a8-08fe.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:5bcb:678a:c0a8:8fe] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sEkAt-00000004mra-1A2w;
	Wed, 05 Jun 2024 06:31:08 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org
Subject: [PATCH 10/12] block: bypass the STABLE_WRITES flag for protection information
Date: Wed,  5 Jun 2024 08:28:39 +0200
Message-ID: <20240605063031.3286655-11-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240605063031.3286655-1-hch@lst.de>
References: <20240605063031.3286655-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Currently registering a checksum-enabled (aka PI) integrity profile sets
the QUEUE_FLAG_STABLE_WRITE flag, and unregistering it clears the flag.
This can incorrectly clear the flag when the driver requires stable
writes even without PI, e.g. in case of iSCSI or NVMe/TCP with data
digest enabled.

Fix this by looking at the csum_type directly in bdev_stable_writes and
not setting the queue flag.  Also remove the blk_queue_stable_writes
helper as the only user in nvme wants to only look at the actual
QUEUE_FLAG_STABLE_WRITE flag as it inherits the integrity configuration
by other means.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-integrity.c         |  6 ------
 drivers/nvme/host/multipath.c |  3 ++-
 include/linux/blkdev.h        | 12 ++++++++----
 3 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index f07d44be6b2236..fbb0bd467eedbf 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -381,9 +381,6 @@ void blk_integrity_register(struct gendisk *disk, struct blk_integrity *template
 	bi->tag_size = template->tag_size;
 	bi->pi_offset = template->pi_offset;
 
-	if (bi->csum_type != BLK_INTEGRITY_CSUM_NONE)
-		blk_queue_flag_set(QUEUE_FLAG_STABLE_WRITES, disk->queue);
-
 #ifdef CONFIG_BLK_INLINE_ENCRYPTION
 	if (disk->queue->crypto_profile) {
 		pr_warn("blk-integrity: Integrity and hardware inline encryption are not supported together. Disabling hardware inline encryption.\n");
@@ -406,9 +403,6 @@ void blk_integrity_unregister(struct gendisk *disk)
 
 	if (!bi->tuple_size)
 		return;
-
-	if (bi->csum_type != BLK_INTEGRITY_CSUM_NONE)
-		blk_queue_flag_clear(QUEUE_FLAG_STABLE_WRITES, disk->queue);
 	memset(bi, 0, sizeof(*bi));
 }
 EXPORT_SYMBOL(blk_integrity_unregister);
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index d8b6b4648eaff9..12c59db02539e5 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -875,7 +875,8 @@ void nvme_mpath_add_disk(struct nvme_ns *ns, __le32 anagrpid)
 		nvme_mpath_set_live(ns);
 	}
 
-	if (blk_queue_stable_writes(ns->queue) && ns->head->disk)
+	if (test_bit(QUEUE_FLAG_STABLE_WRITES, &ns->queue->queue_flags) &&
+	    ns->head->disk)
 		blk_queue_flag_set(QUEUE_FLAG_STABLE_WRITES,
 				   ns->head->disk->queue);
 #ifdef CONFIG_BLK_DEV_ZONED
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f5b0911eed55c6..150910a4d4e6ae 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -564,8 +564,6 @@ bool blk_queue_flag_test_and_set(unsigned int flag, struct request_queue *q);
 #define blk_queue_noxmerges(q)	\
 	test_bit(QUEUE_FLAG_NOXMERGES, &(q)->queue_flags)
 #define blk_queue_nonrot(q)	test_bit(QUEUE_FLAG_NONROT, &(q)->queue_flags)
-#define blk_queue_stable_writes(q) \
-	test_bit(QUEUE_FLAG_STABLE_WRITES, &(q)->queue_flags)
 #define blk_queue_io_stat(q)	test_bit(QUEUE_FLAG_IO_STAT, &(q)->queue_flags)
 #define blk_queue_add_random(q)	test_bit(QUEUE_FLAG_ADD_RANDOM, &(q)->queue_flags)
 #define blk_queue_zone_resetall(q)	\
@@ -1293,8 +1291,14 @@ static inline bool bdev_synchronous(struct block_device *bdev)
 
 static inline bool bdev_stable_writes(struct block_device *bdev)
 {
-	return test_bit(QUEUE_FLAG_STABLE_WRITES,
-			&bdev_get_queue(bdev)->queue_flags);
+	struct request_queue *q = bdev_get_queue(bdev);
+
+#ifdef CONFIG_BLK_DEV_INTEGRITY
+	/* BLK_INTEGRITY_CSUM_NONE is not available in blkdev.h */
+	if (q->integrity.csum_type != 0)
+		return true;
+#endif
+	return test_bit(QUEUE_FLAG_STABLE_WRITES, &q->queue_flags);
 }
 
 static inline bool bdev_write_cache(struct block_device *bdev)
-- 
2.43.0

