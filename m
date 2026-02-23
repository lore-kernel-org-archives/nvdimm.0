Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90EE913DDAE;
	Mon, 23 Feb 2026 13:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771852996; cv=none; b=g5Oek/9eFBfEm+h0asSbM0d9CGOsKgsIOFHUgyiCC1iLjTeMQ3Q3YDfFHuPH4+jEYcdT3J0PUnU5FcJCJcpjUj8tUcYnW1ItViKlta7smgPsVuaLxmW98KnYAaJ9k/y2an48Qd6OgMdf/4bDSslNiOawk5fJASU3JwzugJvWsnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771852996; c=relaxed/simple;
	bh=g3WqADB/CtExA+D419i+LM5gXM7TVsAHM55P1gOYsHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FW44GT613dOLR5I/waJnOTjV04lZwr2ft6kNASuqBbeshG2Jn/XOHyCQb5DK44KRtZ8ex2JOYeNty0Phrb2T7MwNwcnRNTNaCC68ou/xb9FeREZgEKrk9km9nD0zwY2uKG1yOifNDsmNI+8UsQBYbBcgMl7dHKPFRuT8aToTE3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Jd1ckYD3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Jd1ckYD3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=6XrF7L7e7P5ijb0BotJj+nUuBpyobj5B8774xq21L6A=; b=Jd1ckYD38Ls42dHkm+MukFvT1p
	BwuPWkEeKAH7dp8Y4uh4SSxxdhiHKYspL44ApjgKo9pnr5+kZpcGZAR2XwB7h12XrjJmwBtjRP5Fj
	1QI+5SpisV/5fA424bOEq7OANEqbZwqMtp7RRmG6pPxRBbs2kYQamuJc8UzkJHsGtW4IvP37pzpna
	1ZHEyrtEIe+SnFhjRflxQ5BAGqX6MpWDLq8D/U07MNyM1v/4R+02iA6822URtWemtx1D0KnZxHLNg
	Bu6EzDhEq7KGMI/E/pzx/LggcTqqOADdJiNj8kSS0Lo2x5QQ7JLNuP9BtjDBRjwkuh1zMsXaCjL2G
	emJHf9Og==;
Received: from [94.156.175.41] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vuVu5-00000000M63-0mSX;
	Mon, 23 Feb 2026 13:23:14 +0000
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
Subject: [PATCH 13/16] iomap: add a bioset pointer to iomap_read_folio_ops
Date: Mon, 23 Feb 2026 05:20:13 -0800
Message-ID: <20260223132021.292832-14-hch@lst.de>
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
index b2b9e649a3b8..387a1174522f 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -515,6 +515,12 @@ struct iomap_read_ops {
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

