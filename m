Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B912417C6;
	Wed, 28 Jan 2026 16:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769616942; cv=none; b=h8TlM+zv0ja5XH0JsX+4z8fotJTGNGxNJI+gqQfv8R9VJvX3Eqro30UzUUmlIb+PwtOeTj3iUTnJ/6DzjElCduAiu0BrmZjih9+NrIolv+LD+rtApC1baXV7wT6ITOP+6bTUd0WqoVgbpf3lcea05k27RYcPtj3sLXW+AJBonbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769616942; c=relaxed/simple;
	bh=EHsX6hjDcgHcf/T2pcNkF5ZOr1F9oglo4CDjdYXgF00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bSg8t5eVgG1kjkXTmFzMVt+Gzs8ogPoNzHVf+beFjvJxpVaSUkUmRicrK6qCPpfSOz2RuHfYDLPAYtyMpD0MK6aysAL0Ll1vAnG9vl84DjqNI1qu/OGjsTnUsQLPFkIA4aFIq0QCjLriVuggQSVy8Q2YNKKWe6Naw2h93SpAGSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=aA8g1kYZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aA8g1kYZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=uQabXXfyxT75SiQSbhbpKal3ZRJ5Fz117Pw8XD9a9Bw=; b=aA8g1kYZfk5CZBmqOqJvPvK4dz
	4O6tlDeOzgVHBWAsR+VKbj99ZhS3UQFVTBh/Ez1mQW9Jpf8OasbZ2qKCsqKimo62dDnzu2ueHPfRQ
	Y7V8h+u5uvzmD7Ck17yyWH/r8PBeua9DCiarGj4uIWqZ5QLfAOBZXGY31HoGg7mULTj4YOcrfZvGO
	EauFztaFTl/M1qHmNbSS3ou77+F0UWyYpLUwT7ZPATmV7e1yyUVZhBFPv0LgYu+7fxSDIA/TjlzdD
	0+H80pS0X19fUiIGsa8kAxw/Hrsld7hqNzxz/nOOs7aV+RoUYjcmIPx9sA7vtMlrCA+soM80IY3SJ
	R6pkfTgA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vl8Ci-0000000GMyo-0YSC;
	Wed, 28 Jan 2026 16:15:40 +0000
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
Date: Wed, 28 Jan 2026 17:14:58 +0100
Message-ID: <20260128161517.666412-4-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260128161517.666412-1-hch@lst.de>
References: <20260128161517.666412-1-hch@lst.de>
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
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Tested-by: Anuj Gupta <anuj20.g@samsung.com>
---
 include/linux/blkdev.h | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 251e0f538c4c..ed9b3777df9e 100644
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

