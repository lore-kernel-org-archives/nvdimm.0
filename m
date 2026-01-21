Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A7B44D682;
	Wed, 21 Jan 2026 06:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768977880; cv=none; b=J6MK/8FVXgTpMs5KG++038jfHEdKL3HfpMB7/FLvHhuCtapYv5GA/8dOA2eJPxMMl3KiqwCgtnZ4Q4lrxfBKeZkF5887xWp+zwW7yXNaiMxGLgJuRMkWJfGQ+eMHZKjE3ILu3WqAK3PeztODvRDGft7s3fyS2pKc3tzu0+Yk22s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768977880; c=relaxed/simple;
	bh=3xv4bV7ISpiO/Y0jMRNQ0jwEuTg/SFNQUXPmLiILx1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AeHDXbzePMIi+DdBpT/IPAw6NkbaVIJuEF50iAujQQ0xWRHdWHncQawbvXD7lUbeKjQ1t0lv35YuK75HeO24KI+hxh/h6osZDR3c6e9lljXs/MdnCDWujCGQ9ipvaCSMZiROslip6mRR0LdPQMJcii2HCsMyvPy6eXFjaqaXOkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=46DSs2m3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="46DSs2m3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=KllBfFyWg6nkUBJF7GOd0VXgS2L4/C3pLTk+9JJDfuc=; b=46DSs2m3A3svAik/K4sHDHQNup
	LSecPrJJcnX5D/OemJOlpBN0xaA9VrPUkA5lFaF6v3g4EbzXodwKTy6cnMZE5ukjNxaCI1sv1jjzv
	bbuBynFkCkk1iRrlfiOCNImqJxaxP4gMOnlJSa6UN7kF85F+L6mlKv2+PrQTnNXGSzYawrQapKYXr
	EeEU9mg0ruwKSluHCzGbeeVXk59GI0nm2JLfGjj7jDhzpD2C7LYES6FasiljBCwGHNxzBqCwyRTR/
	7kZSgYu4Gv8tWWCL63K9v9pMBuaIv4wFevIvpFgECR3PmE8QKSxX03pbFi51yFxPFLCgBwnnrZJGX
	ZlrRI9QA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1viRxF-00000004xbd-191U;
	Wed, 21 Jan 2026 06:44:37 +0000
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
Subject: [PATCH 11/15] iomap: allow file systems to hook into buffered read bio submission
Date: Wed, 21 Jan 2026 07:43:19 +0100
Message-ID: <20260121064339.206019-12-hch@lst.de>
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

Files ystems such as btrfs have additional operations with bios such as
verifying data checksums.  Allow file systems to hook into submission
of the bio to allow for this processing by replacing the direct
submit_bio call in iomap_read_alloc_bio with a call into ->submit_read
and exporting iomap_read_alloc_bio.  Also add a new field to
struct iomap_read_folio_ctx to track the file logic offset of the current
read context.

Based on a patch from Goldwyn Rodrigues <rgoldwyn@suse.com>.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/bio.c        | 15 +++++++++------
 include/linux/iomap.h |  4 ++++
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/iomap/bio.c b/fs/iomap/bio.c
index 80bbd328bd3c..903cb9fe759e 100644
--- a/fs/iomap/bio.c
+++ b/fs/iomap/bio.c
@@ -32,10 +32,11 @@ static void iomap_read_alloc_bio(const struct iomap_iter *iter,
 	struct folio *folio = ctx->cur_folio;
 	gfp_t gfp = mapping_gfp_constraint(folio->mapping, GFP_KERNEL);
 	gfp_t orig_gfp = gfp;
-	struct bio *bio = ctx->read_ctx;
+	struct bio *bio;
 
-	if (bio)
-		submit_bio(bio);
+	/* Submit the existing range if there was one. */
+	if (ctx->read_ctx)
+		ctx->ops->submit_read(iter, ctx);
 
 	/* Same as readahead_gfp_mask: */
 	if (ctx->rac)
@@ -56,9 +57,10 @@ static void iomap_read_alloc_bio(const struct iomap_iter *iter,
 	bio_add_folio_nofail(bio, folio, plen,
 			offset_in_folio(folio, iter->pos));
 	ctx->read_ctx = bio;
+	ctx->read_ctx_file_offset = iter->pos;
 }
 
-static int iomap_bio_read_folio_range(const struct iomap_iter *iter,
+int iomap_bio_read_folio_range(const struct iomap_iter *iter,
 		struct iomap_read_folio_ctx *ctx, size_t plen)
 {
 	struct folio *folio = ctx->cur_folio;
@@ -70,10 +72,11 @@ static int iomap_bio_read_folio_range(const struct iomap_iter *iter,
 		iomap_read_alloc_bio(iter, ctx, plen);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(iomap_bio_read_folio_range);
 
 const struct iomap_read_ops iomap_bio_read_ops = {
-	.read_folio_range = iomap_bio_read_folio_range,
-	.submit_read = iomap_bio_submit_read,
+	.read_folio_range	= iomap_bio_read_folio_range,
+	.submit_read		= iomap_bio_submit_read,
 };
 EXPORT_SYMBOL_GPL(iomap_bio_read_ops);
 
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index bf6280fc51af..b3f545d41720 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -493,6 +493,7 @@ struct iomap_read_folio_ctx {
 	struct folio		*cur_folio;
 	struct readahead_control *rac;
 	void			*read_ctx;
+	loff_t			read_ctx_file_offset;
 };
 
 struct iomap_read_ops {
@@ -599,6 +600,9 @@ int iomap_swapfile_activate(struct swap_info_struct *sis,
 extern struct bio_set iomap_ioend_bioset;
 
 #ifdef CONFIG_BLOCK
+int iomap_bio_read_folio_range(const struct iomap_iter *iter,
+		struct iomap_read_folio_ctx *ctx, size_t plen);
+
 extern const struct iomap_read_ops iomap_bio_read_ops;
 
 static inline void iomap_bio_read_folio(struct folio *folio,
-- 
2.47.3

