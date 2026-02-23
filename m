Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D8B1E991B;
	Mon, 23 Feb 2026 13:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771852887; cv=none; b=F2j43oJDmLyBU+1ialKdZ+0h5nYSc5ewkwtCahE9Srty+IP7ykJCVocRGwlqMHgliWLTyKaJPChI6IkQqwp9Nz7T6JZwK2vRkjd2PQFgIywRHAipTKtZUVncmRHVOfUDHYUdzS+la47glC0A6jR/n05MbEq/QnPxCu7kDxryk6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771852887; c=relaxed/simple;
	bh=D6rOwegbMZ4s71Tnt4Al5P2kTIjmQ+Mz1FFVxE9C99E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kHfGwEU89VS4rvrOnQCo+txXLof7t3liyItugHksmsxve85QPVZ+G66fxrizXANqVPErBIiKManVGiLmERl03saAqXUDwmAekjIU5OE3hSTpnNmjVLxu5XyeXlqwbJaFNmD3zk0hY3jthbCysAEY7Ttu7+Elqq7yVONlJNU9H78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UdnhjvsW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UdnhjvsW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=If97NPopB2aA5criH9xk1y/Mr1JA79KNCx16/qAZARI=; b=UdnhjvsWz0QYx8nkKg1qqOaE4X
	3xqip7CH/E/cyC9iPBgQARJ6TywAmS4ubIlC8e3Jgo7VrRoHdUZ66sPSdsXgoESO4JeZTujKAK4ZK
	ozoTflf+Xm8vAPeWd7aRLGw+yxtnMFZOO1Vf0V74ObzQwJwrDT3RJ5B1aoRASPJNAPiDXDSWmwJ1b
	1FX9sWsGNE90Cr6lsdaCtmiadizeJHqcmS5LG0svbjV3Ms5yAJy6vBLaM0O1qsoEoeGxOIjmc4zDC
	MFOP4cViALKggo493OCiDFdkKK4hPSFMhAV/tljyvG/hCwMstXtZVcrZkHX++bEfOmTBvidR4hTNO
	xzGsU7FA==;
Received: from [94.156.175.41] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vuVsJ-00000000LvJ-2nFC;
	Mon, 23 Feb 2026 13:21:24 +0000
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
Subject: [PATCH 04/16] block: prepare generation / verification helpers for fs usage
Date: Mon, 23 Feb 2026 05:20:04 -0800
Message-ID: <20260223132021.292832-5-hch@lst.de>
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

Return the status from verify instead of directly stashing it in the bio,
and rename the helpers to use the usual bio_ prefix for things operating
on a bio.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Tested-by: Anuj Gupta <anuj20.g@samsung.com>
---
 block/bio-integrity-auto.c |  4 ++--
 block/blk.h                |  6 ++++--
 block/t10-pi.c             | 12 ++++++------
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/block/bio-integrity-auto.c b/block/bio-integrity-auto.c
index b64c71a7fc82..ebd17f47e0f9 100644
--- a/block/bio-integrity-auto.c
+++ b/block/bio-integrity-auto.c
@@ -39,7 +39,7 @@ static void bio_integrity_verify_fn(struct work_struct *work)
 		container_of(work, struct bio_integrity_data, work);
 	struct bio *bio = bid->bio;
 
-	blk_integrity_verify_iter(bio, &bid->saved_bio_iter);
+	bio->bi_status = bio_integrity_verify(bio, &bid->saved_bio_iter);
 	bio_integrity_finish(bid);
 	bio_endio(bio);
 }
@@ -100,7 +100,7 @@ void bio_integrity_prep(struct bio *bio, unsigned int action)
 
 	/* Auto-generate integrity metadata if this is a write */
 	if (bio_data_dir(bio) == WRITE && bip_should_check(&bid->bip))
-		blk_integrity_generate(bio);
+		bio_integrity_generate(bio);
 	else
 		bid->saved_bio_iter = bio->bi_iter;
 }
diff --git a/block/blk.h b/block/blk.h
index f6053e9dd2aa..c5b2115b9ea4 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -699,8 +699,10 @@ int bdev_open(struct block_device *bdev, blk_mode_t mode, void *holder,
 	      const struct blk_holder_ops *hops, struct file *bdev_file);
 int bdev_permission(dev_t dev, blk_mode_t mode, void *holder);
 
-void blk_integrity_generate(struct bio *bio);
-void blk_integrity_verify_iter(struct bio *bio, struct bvec_iter *saved_iter);
+void bio_integrity_generate(struct bio *bio);
+blk_status_t bio_integrity_verify(struct bio *bio,
+		struct bvec_iter *saved_iter);
+
 void blk_integrity_prepare(struct request *rq);
 void blk_integrity_complete(struct request *rq, unsigned int nr_bytes);
 
diff --git a/block/t10-pi.c b/block/t10-pi.c
index 0c4ed9702146..d27be6041fd3 100644
--- a/block/t10-pi.c
+++ b/block/t10-pi.c
@@ -372,7 +372,7 @@ static void ext_pi_type1_complete(struct request *rq, unsigned int nr_bytes)
 	}
 }
 
-void blk_integrity_generate(struct bio *bio)
+void bio_integrity_generate(struct bio *bio)
 {
 	struct blk_integrity *bi = blk_get_integrity(bio->bi_bdev->bd_disk);
 	struct bio_integrity_payload *bip = bio_integrity(bio);
@@ -404,7 +404,7 @@ void blk_integrity_generate(struct bio *bio)
 	}
 }
 
-void blk_integrity_verify_iter(struct bio *bio, struct bvec_iter *saved_iter)
+blk_status_t bio_integrity_verify(struct bio *bio, struct bvec_iter *saved_iter)
 {
 	struct blk_integrity *bi = blk_get_integrity(bio->bi_bdev->bd_disk);
 	struct bio_integrity_payload *bip = bio_integrity(bio);
@@ -439,11 +439,11 @@ void blk_integrity_verify_iter(struct bio *bio, struct bvec_iter *saved_iter)
 		}
 		kunmap_local(kaddr);
 
-		if (ret) {
-			bio->bi_status = ret;
-			return;
-		}
+		if (ret)
+			return ret;
 	}
+
+	return BLK_STS_OK;
 }
 
 void blk_integrity_prepare(struct request *rq)
-- 
2.47.3

