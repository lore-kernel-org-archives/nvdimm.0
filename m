Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8174041C308;
	Wed, 21 Jan 2026 06:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768977840; cv=none; b=f+c8u4pmHDr53oOn6dVwPBNPvJ00hP3ualY1Cdok15bRyfPaR+vjLMbWtdWdlmmYbVsve2j79HlpPWzOgAGgJUVpqI2jW+GACEZw/acFAXGeJJXIAmU2P1Q/Os9ESPxWzE0rRYS+lTn9mxfiIsvd2MQD1oW49lZP/U2XVHkMiI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768977840; c=relaxed/simple;
	bh=N7X9ew+nev4LJsndIBlC5Ym1S2XVQAuNu5z8oVSoU20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X05xCnQK0S4COazJI32newDWV5hwqN/265AGA1oL7K1YUaLtdEwpAqcOgZMhysOdkobsnEAQ7nue2PERDTDYFCBpMy7S1flRDxsQ8aKu1/an0hUrlnZeEQGvOvUGUbmYU5mMJo6Ba/duEXVosj/WS9MIJvT+BexXK5D94zneAno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3QIg/Ok+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3QIg/Ok+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=LRqImKpOznPzP22J04AvRZ2JnYK6n021FN45zcyz6jw=; b=3QIg/Ok+vuiuH/nopIW4A4wG1y
	XC94QwV8bemwBT1yZOWysIj/l+qKTgctWSCBIJr9xNZas6P/TV4y+fMf+ZP24u4dnhyeKeG0ihj68
	d1ZknBlPxpn61l+aHe0EcgzXpMQsLP1RF7WjTscBsbrbX0vQJhYdNZdkKd2XPkxFm6YDnmYvkB3YP
	DMdcUeAdbFqlrX+mHcyZGTDFASUFZ47YhY+u8c/IChJ4hNxceiBSW0xUwx/9BRn5VL0rniL6PDbnE
	ArDvh6PrLgSvMTGUVzce33hMfFyba1Y3IfmzjE2TVUD5PFWOgWU2pM4jCzE+TE0usHYNbwDeKH6HR
	gw/oio0Q==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1viRwa-00000004xYg-4Bet;
	Wed, 21 Jan 2026 06:43:57 +0000
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
Subject: [PATCH 02/15] block: factor out a bio_integrity_setup_default helper
Date: Wed, 21 Jan 2026 07:43:10 +0100
Message-ID: <20260121064339.206019-3-hch@lst.de>
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

Add a helper to set the seed and check flag based on useful defaults
from the profile.

Note that this includes a small behavior change, as we ow only sets the
seed if any action is set, which is fine as nothing will look at it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio-integrity-auto.c    | 14 ++------------
 block/bio-integrity.c         | 16 ++++++++++++++++
 include/linux/bio-integrity.h |  1 +
 3 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/block/bio-integrity-auto.c b/block/bio-integrity-auto.c
index 3a4141a9de0c..5345d55b9998 100644
--- a/block/bio-integrity-auto.c
+++ b/block/bio-integrity-auto.c
@@ -88,7 +88,6 @@ bool __bio_integrity_endio(struct bio *bio)
  */
 void bio_integrity_prep(struct bio *bio, unsigned int action)
 {
-	struct blk_integrity *bi = blk_get_integrity(bio->bi_bdev->bd_disk);
 	struct bio_integrity_data *bid;
 
 	bid = mempool_alloc(&bid_pool, GFP_NOIO);
@@ -96,17 +95,8 @@ void bio_integrity_prep(struct bio *bio, unsigned int action)
 	bid->bio = bio;
 	bid->bip.bip_flags |= BIP_BLOCK_INTEGRITY;
 	bio_integrity_alloc_buf(bio, action & BI_ACT_ZERO);
-
-	bip_set_seed(&bid->bip, bio->bi_iter.bi_sector);
-
-	if (action & BI_ACT_CHECK) {
-		if (bi->csum_type == BLK_INTEGRITY_CSUM_IP)
-			bid->bip.bip_flags |= BIP_IP_CHECKSUM;
-		if (bi->csum_type)
-			bid->bip.bip_flags |= BIP_CHECK_GUARD;
-		if (bi->flags & BLK_INTEGRITY_REF_TAG)
-			bid->bip.bip_flags |= BIP_CHECK_REFTAG;
-	}
+	if (action & BI_ACT_CHECK)
+		bio_integrity_setup_default(bio);
 
 	/* Auto-generate integrity metadata if this is a write */
 	if (bio_data_dir(bio) == WRITE && bip_should_check(&bid->bip))
diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 6bdbb4ed2d1a..0e8ebe84846e 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -101,6 +101,22 @@ void bio_integrity_free_buf(struct bio_integrity_payload *bip)
 		kfree(bvec_virt(bv));
 }
 
+void bio_integrity_setup_default(struct bio *bio)
+{
+	struct blk_integrity *bi = blk_get_integrity(bio->bi_bdev->bd_disk);
+	struct bio_integrity_payload *bip = bio_integrity(bio);
+
+	bip_set_seed(bip, bio->bi_iter.bi_sector);
+
+	if (bi->csum_type) {
+		bip->bip_flags |= BIP_CHECK_GUARD;
+		if (bi->csum_type == BLK_INTEGRITY_CSUM_IP)
+			bip->bip_flags |= BIP_IP_CHECKSUM;
+	}
+	if (bi->flags & BLK_INTEGRITY_REF_TAG)
+		bip->bip_flags |= BIP_CHECK_REFTAG;
+}
+
 /**
  * bio_integrity_free - Free bio integrity payload
  * @bio:	bio containing bip to be freed
diff --git a/include/linux/bio-integrity.h b/include/linux/bio-integrity.h
index 276cbbdd2c9d..232b86b9bbcb 100644
--- a/include/linux/bio-integrity.h
+++ b/include/linux/bio-integrity.h
@@ -143,5 +143,6 @@ static inline int bio_integrity_add_page(struct bio *bio, struct page *page,
 
 void bio_integrity_alloc_buf(struct bio *bio, bool zero_buffer);
 void bio_integrity_free_buf(struct bio_integrity_payload *bip);
+void bio_integrity_setup_default(struct bio *bio);
 
 #endif /* _LINUX_BIO_INTEGRITY_H */
-- 
2.47.3

