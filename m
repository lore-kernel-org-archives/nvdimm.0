Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3FA33A1D2;
	Mon, 23 Feb 2026 13:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771852947; cv=none; b=s53WKrxU803N656jehH9EUCLzBnZt5bvFwGhL8tl9bouey2ADB1F4jsZPk0+Qs38wXpKernHyzLqr3Ja5R8sElwQlg4OjmgTVYI6kEdpzqaxAjOSOYD8iAQv6iwMDCnoOE0Q7WsOJ3AgmxhkYueP/qdJnjGWJPnW/umNxs8AdWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771852947; c=relaxed/simple;
	bh=TgAzADZp942m/mNiT4xiZi4r6ouZ08ZoS6D5f8QsyUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QFiiPgMXFBdLltqm1e6Tg2CaQ+5Rq/TWM3FjPrS5E9BYJwXZts8vkS7i/O6aQt90VPH4Xo1QFNTq6DXVfGt/x6tl1BaTRn4wFxTKIMrEeOrtXSHORFtKG5zhuTNWK7dzuEuHIwN/RiN7ZCRd6XabiARmHqc9KXYfsBjdyKiuSk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NV5h+gPr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NV5h+gPr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=DydYmsKAy3ZaEmi3TYqqUoWHFPE3MKeudE4M0b4BKkA=; b=NV5h+gPrmQ4RkWmVm/4t3Q+4LL
	pkPuUwJCSLRYTe17OFd5YenZ5LAdYKs/AVN3DMWFxEQdXnj4mD25W4iiZnvyxLFid66pBcVVGIRox
	cQet/0IEXDNVPGBrgSYx8LtuJyCMvXeR+6/f9wAtEcahYVe0vCUHBBczxBYRg+KlrGDc/K9oFSvRZ
	bhnvKzTDg3AK+PdEimca+2gokDYkQng1shCVUXe1II82e8OUEor5BDMRE2ndw0oZ9sXFIo+XWTnlJ
	xAy5qLhFZ6mbTam5pHRs8lIuPrO1NVbyaAUV/JCLHF4OP+sG2j0EhDhJHhz8stdGPWUKoU21rLPou
	Q7AgO+Ww==;
Received: from [94.156.175.41] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vuVtI-00000000M0P-2hEq;
	Mon, 23 Feb 2026 13:22:25 +0000
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
Subject: [PATCH 09/16] iomap: pass the iomap_iter to ->submit_read
Date: Mon, 23 Feb 2026 05:20:09 -0800
Message-ID: <20260223132021.292832-10-hch@lst.de>
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

This provides additional context for file systems.

Rename the fuse instance to match the method name while we're at it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Tested-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/fuse/file.c         | 5 +++--
 fs/iomap/bio.c         | 3 ++-
 fs/iomap/buffered-io.c | 4 ++--
 fs/ntfs3/inode.c       | 3 ++-
 include/linux/iomap.h  | 3 ++-
 5 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index b1bb7153cb78..a9c836d7f586 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -947,7 +947,8 @@ static int fuse_iomap_read_folio_range_async(const struct iomap_iter *iter,
 	return ret;
 }
 
-static void fuse_iomap_read_submit(struct iomap_read_folio_ctx *ctx)
+static void fuse_iomap_submit_read(const struct iomap_iter *iter,
+		struct iomap_read_folio_ctx *ctx)
 {
 	struct fuse_fill_read_data *data = ctx->read_ctx;
 
@@ -958,7 +959,7 @@ static void fuse_iomap_read_submit(struct iomap_read_folio_ctx *ctx)
 
 static const struct iomap_read_ops fuse_iomap_read_ops = {
 	.read_folio_range = fuse_iomap_read_folio_range_async,
-	.submit_read = fuse_iomap_read_submit,
+	.submit_read = fuse_iomap_submit_read,
 };
 
 static int fuse_read_folio(struct file *file, struct folio *folio)
diff --git a/fs/iomap/bio.c b/fs/iomap/bio.c
index 578b1202e037..cb60d1facb5a 100644
--- a/fs/iomap/bio.c
+++ b/fs/iomap/bio.c
@@ -18,7 +18,8 @@ static void iomap_read_end_io(struct bio *bio)
 	bio_put(bio);
 }
 
-static void iomap_bio_submit_read(struct iomap_read_folio_ctx *ctx)
+static void iomap_bio_submit_read(const struct iomap_iter *iter,
+		struct iomap_read_folio_ctx *ctx)
 {
 	struct bio *bio = ctx->read_ctx;
 
diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index a0c46aadb97d..763b266f38c5 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -588,7 +588,7 @@ void iomap_read_folio(const struct iomap_ops *ops,
 				&bytes_submitted);
 
 	if (ctx->ops->submit_read)
-		ctx->ops->submit_read(ctx);
+		ctx->ops->submit_read(&iter, ctx);
 
 	if (ctx->cur_folio)
 		iomap_read_end(ctx->cur_folio, bytes_submitted);
@@ -654,7 +654,7 @@ void iomap_readahead(const struct iomap_ops *ops,
 					&cur_bytes_submitted);
 
 	if (ctx->ops->submit_read)
-		ctx->ops->submit_read(ctx);
+		ctx->ops->submit_read(&iter, ctx);
 
 	if (ctx->cur_folio)
 		iomap_read_end(ctx->cur_folio, cur_bytes_submitted);
diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 6e65066ebcc1..511967ef7ec9 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -651,7 +651,8 @@ static int ntfs_iomap_bio_read_folio_range(const struct iomap_iter *iter,
 	return 0;
 }
 
-static void ntfs_iomap_bio_submit_read(struct iomap_read_folio_ctx *ctx)
+static void ntfs_iomap_bio_submit_read(const struct iomap_iter *iter,
+		struct iomap_read_folio_ctx *ctx)
 {
 	struct bio *bio = ctx->read_ctx;
 
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 99b7209dabd7..6fbe121e2adf 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -512,7 +512,8 @@ struct iomap_read_ops {
 	 *
 	 * This is optional.
 	 */
-	void (*submit_read)(struct iomap_read_folio_ctx *ctx);
+	void (*submit_read)(const struct iomap_iter *iter,
+			struct iomap_read_folio_ctx *ctx);
 };
 
 /*
-- 
2.47.3

