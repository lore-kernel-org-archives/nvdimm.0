Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1820D2DC323;
	Wed, 18 Feb 2026 06:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771395181; cv=none; b=VKxGkVNnN/s6VvO1cDRaxa4JxhQnC//0ZToZ1zQu1f+lYm0akHWN6YBOSIsTogJQO84Pv8sUMpflXdlv4YyU3zD1DWAmDsDyB85tqlGuhxM8jeXW9r5ECDJ7/faRWIccp49Mch//c8U0bGV9CQfo6e9pBwky6aQRZLZR/ErbJrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771395181; c=relaxed/simple;
	bh=eQ7TulQemW8Au/QxyNVvoLzYZ0oqVwiqnFZtorAr7NM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l4myVAnMTWdVvfqUnYLkIzCvmBVEMpYPMwKUopUvL3CxMRPITpA3bzXisICQuGO7XQWho1ocp7kLAXJZhnemc/ttvxMHhrQxdDx8TBr0sTe9pwBypoTfyFH3vqa3w0jawqCi+RRK9zMIPBhzhFGUoYh98oOSmAFv8T2gmZdkhBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qnjY6Zxr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qnjY6Zxr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=cz1hAACT1iUdH/Kl5mAXeH4ICd5ZL7RNbUo9wOP+CWQ=; b=qnjY6ZxrXMO1dIZS2vFOQMcqGX
	QdeQNVnnWjEzcXu8Q2/Ns/2Npd+ynqoISBFVB60IW6hWPP+8e7LLqwuDnkR8/dpj3d8KHxdj9oe/R
	+9riCNsBitbg0hMPYAxrNGkkEf52Q8YszAx2VmkuLhFsVK9lFNMEJI4w9fTuw0uyGTaNgEibpmIon
	UhBXN3QYtJpGdnCpxAVNz9L9Vnl/xzu6xbFT5GimkyzdsGdixfc/PCuZgskRnl8vdlmOIUIooFwnn
	JPhnOssGOIQpn9UPfNm3s6V3oOs/0EGDtSbc4aKCI2pTAXY/ER4djv5qMVClhF4NSyfBmqwwOnDQU
	YMsUeGvg==;
Received: from [2001:4bb8:2dc:9863:1842:9381:9c0f:de32] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vsany-00000009LQz-3fd1;
	Wed, 18 Feb 2026 06:12:59 +0000
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
Date: Wed, 18 Feb 2026 07:11:57 +0100
Message-ID: <20260218061238.3317841-4-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260218061238.3317841-1-hch@lst.de>
References: <20260218061238.3317841-1-hch@lst.de>
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

