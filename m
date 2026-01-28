Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B2F83093A8;
	Wed, 28 Jan 2026 16:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769617000; cv=none; b=eUJG2ZyatENBU8sRGrP077IErInOHVfPgcZe1xwuLS5MXDFwUlzlI0ZqgxJCxq1v0RQzl80lUss+N+sKpu3lliXBVubv4keS3LDq0rR5Q8nWndgmOMzAXwxzVJozYyfAT66WZMm2NJwtzvKENRgtzr+ER2YA9UMv9X3nbvF2aL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769617000; c=relaxed/simple;
	bh=lt3dmbXpfjH4n1aNfuSrJRnjeFiY2orc2LRKIeFLKAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hlteHbEsgIK52hhy7N7y+sT1mpPkCMH28lEl/FnrPEoBSS3+kCh9Mb4xU5pYQwAqNs5PUNUYDaEWX2GpZuI5vW5vxKM0xGAqGx2PqC6UBT7heVNmKoXMMF+imCzNscjyRVovkgXtqDiEiMem1OiiWwRB9p99K6Z9o7wq/F8EKVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jz+61AWe; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jz+61AWe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=RKp/vVKe1yui9ya66tywBY5U9+2Sciyx/n7UsG1ph/U=; b=jz+61AWe/JCGf0Zb+aTwsbMCSs
	+UmDCzBWg+lioVPmhzZmkhB6Abd5OEOWhRA9Sq4ueQxjhykLkCj5oO2BWYYSEGhSKcPDAUwA85gu8
	xNfjMWR+p9FciLN54dFSqu1akLmpaeBNGQbbRv+YH2pkAWAiIlgBivv378+LIwz/kp+sSC187PO6p
	i0/5dzaVJRcVXPtiZuxRJflI/Vekj2fHHZSRd3p+o9oO6JAmU+HN6sG0p4qoKPcnY21QNMWx7TdYz
	DgpnAVpPBRkpnLNbS1eHwbL4U9qjjoGXN2Gs0K6+nsTPNNjj2HRVqLgAFTx6hZBIUxBdJ1a4LY5uJ
	WfxnjwBg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vl8Da-0000000GN2F-49yc;
	Wed, 28 Jan 2026 16:16:35 +0000
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
Subject: [PATCH 12/15] iomap: add a bioset pointer to iomap_read_folio_ops
Date: Wed, 28 Jan 2026 17:15:07 +0100
Message-ID: <20260128161517.666412-13-hch@lst.de>
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

Optionally allocate the bio from the bioset provided in
iomap_read_folio_ops.  If no bioset is provided, fs_bio_set is still
used, which is the standard bioset for file systems.

Based on a patch from Goldwyn Rodrigues <rgoldwyn@suse.com>.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Tested-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/iomap/bio.c        | 14 ++++++++++++--
 include/linux/iomap.h |  6 ++++++
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/fs/iomap/bio.c b/fs/iomap/bio.c
index 903cb9fe759e..259a2bf95a43 100644
--- a/fs/iomap/bio.c
+++ b/fs/iomap/bio.c
@@ -24,11 +24,19 @@ static void iomap_bio_submit_read(const struct iomap_iter *iter,
 	submit_bio(ctx->read_ctx);
 }
 
+static struct bio_set *iomap_read_bio_set(struct iomap_read_folio_ctx *ctx)
+{
+	if (ctx->ops && ctx->ops->bio_set)
+		return ctx->ops->bio_set;
+	return &fs_bio_set;
+}
+
 static void iomap_read_alloc_bio(const struct iomap_iter *iter,
 		struct iomap_read_folio_ctx *ctx, size_t plen)
 {
 	const struct iomap *iomap = &iter->iomap;
 	unsigned int nr_vecs = DIV_ROUND_UP(iomap_length(iter), PAGE_SIZE);
+	struct bio_set *bio_set = iomap_read_bio_set(ctx);
 	struct folio *folio = ctx->cur_folio;
 	gfp_t gfp = mapping_gfp_constraint(folio->mapping, GFP_KERNEL);
 	gfp_t orig_gfp = gfp;
@@ -47,9 +55,11 @@ static void iomap_read_alloc_bio(const struct iomap_iter *iter,
 	 * having to deal with partial page reads.  This emulates what
 	 * do_mpage_read_folio does.
 	 */
-	bio = bio_alloc(iomap->bdev, bio_max_segs(nr_vecs), REQ_OP_READ, gfp);
+	bio = bio_alloc_bioset(iomap->bdev, bio_max_segs(nr_vecs), REQ_OP_READ,
+			gfp, bio_set);
 	if (!bio)
-		bio = bio_alloc(iomap->bdev, 1, REQ_OP_READ, orig_gfp);
+		bio = bio_alloc_bioset(iomap->bdev, 1, REQ_OP_READ, orig_gfp,
+				bio_set);
 	if (ctx->rac)
 		bio->bi_opf |= REQ_RAHEAD;
 	bio->bi_iter.bi_sector = iomap_sector(iomap, iter->pos);
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 42d562e55d3d..de730970998f 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -511,6 +511,12 @@ struct iomap_read_ops {
 	 */
 	void (*submit_read)(const struct iomap_iter *iter,
 			struct iomap_read_folio_ctx *ctx);
+
+	/*
+	 * Optional, allows filesystem to specify own bio_set, so new bio's
+	 * can be allocated from the provided bio_set.
+	 */
+	struct bio_set *bio_set;
 };
 
 /*
-- 
2.47.3

