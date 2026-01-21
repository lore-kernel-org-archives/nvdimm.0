Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9D244BCBA;
	Wed, 21 Jan 2026 06:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768977844; cv=none; b=cPIx7K4MsA2H/SlsElvpfU3HPfS4sz5u+7wuFhiLquYpwRtCa8Q5hTJ7giPtAsUvBMZqMR7120dJdK/da4spSipkbbb786SVUM2wIFTKm35WM+7LT9kF0mkMaQVMilRmU0mi9hTk91fcgqo1BBjL9HVVgf3rth1X5cSKsA5ci0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768977844; c=relaxed/simple;
	bh=3LUGM/5+G+t6skALuCtZ2dp1h7iokzDfk636qTUhr9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uhn2uu4ekcGgtZvU6MknTCUQ/tMuqA6V+u2BaahzRFk0b9kJutY0x3gzYORqo8kZCFPF0w9O/gkzAuNazONqWPpGE4sjmtz0/lds//cJs2DYuP880qQBLo85mtmbpReWFKS5+Py3UFWz/Mfw/g4+hR2CyVbmZJyKxs0YWASjRQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pjgH7E2w; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pjgH7E2w"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=wev1Jw9CBSGeKswkzPuHEROPjVwtbhqdC7VkrAxa5Ss=; b=pjgH7E2w9plKw1NwDDYhXlb6h4
	5bUFhKRR9f0pxLDlaCD8UGsBAz+y/31PZ5W4/0q3A1N1NsZMYG+8WIFZk2wMklhCp5L84XAb5OprX
	ZeITXioGIADHwdgPgtvneK0kb1dg4SAOa5AkD82TpErZlxtD49+Q+A00G6e3AA8gmzB6SAWiE/hZq
	4ZRpoyTNOujojfTh50O0ibyuLiCpXw7PrPu5gg2UQtgaIEfVr0WsbLjLEF+aOMxfn59oMdUBlB1gd
	HY7crysAFoXRqas3w1A7Rtpka7fOOjh3l/mqGPSC1RtlNkFTbyYgCTOxThYjgUKCi7+Mz+2JmhPZ0
	z5lkHULg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1viRwf-00000004xYz-0Rpp;
	Wed, 21 Jan 2026 06:44:01 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	linux-block@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 03/15] block: add a bdev_has_integrity_csum helper
Date: Wed, 21 Jan 2026 07:43:11 +0100
Message-ID: <20260121064339.206019-4-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260121064339.206019-1-hch@lst.de>
References: <20260121064339.206019-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Factor out a helper to see if the block device has an integrity checksum
from bdev_stable_writes so that it can be reused for other checks.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/blkdev.h | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 438c4946b6e5..c1f3e6bcc217 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1472,14 +1472,18 @@ static inline bool bdev_synchronous(struct block_device *bdev)
 	return bdev->bd_disk->queue->limits.features & BLK_FEAT_SYNCHRONOUS;
 }
 
-static inline bool bdev_stable_writes(struct block_device *bdev)
+static inline bool bdev_has_integrity_csum(struct block_device *bdev)
 {
-	struct request_queue *q = bdev_get_queue(bdev);
+	struct queue_limits *lim = bdev_limits(bdev);
 
-	if (IS_ENABLED(CONFIG_BLK_DEV_INTEGRITY) &&
-	    q->limits.integrity.csum_type != BLK_INTEGRITY_CSUM_NONE)
-		return true;
-	return q->limits.features & BLK_FEAT_STABLE_WRITES;
+	return IS_ENABLED(CONFIG_BLK_DEV_INTEGRITY) &&
+		lim->integrity.csum_type != BLK_INTEGRITY_CSUM_NONE;
+}
+
+static inline bool bdev_stable_writes(struct block_device *bdev)
+{
+	return bdev_has_integrity_csum(bdev) ||
+		(bdev_limits(bdev)->features & BLK_FEAT_STABLE_WRITES);
 }
 
 static inline bool blk_queue_write_cache(struct request_queue *q)
-- 
2.47.3

