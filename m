Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B00D18D658;
	Mon, 23 Feb 2026 13:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771852863; cv=none; b=s0WLbDS6sUG8s3fkbzdB1iYPV/ZOYXLkfvYyLhYApYvxPQyQKlQbMTL/9QsPydPSltdiXgFwCuh7PfoLoruBp5yx0rTudtDISuTin2pXsr3RQPDhOWcEbIcbS41SmtfzHQKUe9ayCmAM6/C3LToaZVSx/6JMKye0EFjHkCW27TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771852863; c=relaxed/simple;
	bh=7OGEtgfKRKRhSV3ZyBVR6x0Tbx/bFCKe5qIfkdFFNng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kjvZbDKzxGk9lvR5FbIG4pI+4BM88IN+h0qNwvjss5nxVFf1gzNa2iabYDCbcmZFN/4qHhA0If57mF5tHLhrrRrB8uvSlXkag7RkCglohwzG+oS5CAsho62hl5KKeDdm9dT8CruldJed8M3age3Dk45hZ6kP+DfNbVkj9HqKaY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rIdpjoGk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rIdpjoGk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=K/HW9ps9ZUCZHk26rQ+3zN1JwWPM9XZbQ+Ny9TDHe6Q=; b=rIdpjoGkjMlgzu5dqkjEjQQJCu
	fA+PY2iWqupvdFWwuVlNTfAsXudUvm22qgMzA1audoB6AYqH0gN2hnW+MpHHAKzbq/xhi/aR0M1GC
	sFXzBz6kFu+ePTByKGQ8pmw6axyDvetRqwxRUiMlKlwT+Lia1dvt66Gn56IgUHxCXV4ssTFbaM09v
	MDPKLp+YXHKjxOC4K6LRQPKRig5tU1N39xGLemwHJPouQyQBTdl6vt1aLCmIq1F5HDc82IOGg/wBT
	VsrwYRclQEqlpq08dn5mJdVfRbHeMcepd6IHTo16M6lJHcrGJgJlVUIlo7mfE08cHo+nbLUUYFwST
	Qr+nRj5w==;
Received: from [94.156.175.41] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vuVrv-00000000LtU-0KET;
	Mon, 23 Feb 2026 13:21:00 +0000
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
Subject: [PATCH 02/16] block: factor out a bio_integrity_setup_default helper
Date: Mon, 23 Feb 2026 05:20:02 -0800
Message-ID: <20260223132021.292832-3-hch@lst.de>
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

Add a helper to set the seed and check flag based on useful defaults
from the profile.

Note that this includes a small behavior change, as we now only set the
seed if any action is set, which is fine as nothing will look at it
otherwise.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Tested-by: Anuj Gupta <anuj20.g@samsung.com>
---
 block/bio-integrity-auto.c    | 14 ++------------
 block/bio-integrity.c         | 16 ++++++++++++++++
 include/linux/bio-integrity.h |  1 +
 3 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/block/bio-integrity-auto.c b/block/bio-integrity-auto.c
index e16f669dbf1e..b64c71a7fc82 100644
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
index 0955be90038b..e79eaf047794 100644
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

