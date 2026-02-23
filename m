Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA32018787A;
	Mon, 23 Feb 2026 13:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771852875; cv=none; b=kYN+ft1yJC98CNmkp9m3GogPKeHMT12k43p4+OGcP3M/eJycZuYE+0GTTgtmLVN8yTmq6rmPAUKavCDyUg2epQ3IGR7lUsqUM2a+EgGktllcixMs5ANIMSMhxNBAzAAPWAUrJ3YX4+mSDHaCS7DXA6YCyTsGJ6IXej4MtM0fcYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771852875; c=relaxed/simple;
	bh=eQ7TulQemW8Au/QxyNVvoLzYZ0oqVwiqnFZtorAr7NM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fyrwybSQ+Te9AalIPR0FVsq5P6+1B2HShzJ4GdnQmb7rXtq/1HVXH2BG5C6mGTx1Vot36PpjaA/rAOiUKBaqq2KbpgRO8LDX9H7k6hAQ+4eXMDyVDl9G58W5V5sOppZ+SKH5YFRV1kFMOU2VMGWqaTh/rpzaesqxeSy/LDqalNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lj+ugYJa; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lj+ugYJa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=cz1hAACT1iUdH/Kl5mAXeH4ICd5ZL7RNbUo9wOP+CWQ=; b=lj+ugYJazC0ozAFbbuEe7rS3hG
	GyQrfzkrdeyu0cejvPXCopSc2SyhXnNUBbtWWgadqTDo0KdmdVXDlKzy2LVqP4PMppv6+82iiWVXk
	dxuRNHkqu3288adom6UalcT5IsGcnhAg5MTC4Vlek90UjvlrgWeUMYEOrMaPFAA5aJG0Z4XXTe49o
	/0YBpG3uxo1o2/xwmocvtDwCOzFyeBZmBDn+ZlF8I4IhF/vlLF7NCmreeELUai9+e1+qQ9I5VQs+C
	9FUNBDG6EgYNsqHPV2dtR+cM79FfRBYY7TW0xpX4NTHRkIYZ17YAK2euQ3+nnreSjA1AlI7CLqNll
	V39SZASg==;
Received: from [94.156.175.41] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vuVs7-00000000LuI-1Rt7;
	Mon, 23 Feb 2026 13:21:12 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	ntfs3@lists.linux.dev,
	linux-block@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 03/16] block: add a bdev_has_integrity_csum helper
Date: Mon, 23 Feb 2026 05:20:03 -0800
Message-ID: <20260223132021.292832-4-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260223132021.292832-1-hch@lst.de>
References: <20260223132021.292832-1-hch@lst.de>
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
index d463b9b5a0a5..dec0acaed6e6 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1477,14 +1477,18 @@ static inline bool bdev_synchronous(struct block_device *bdev)
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

