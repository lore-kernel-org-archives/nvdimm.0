Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6948A883F;
	Mon, 23 Feb 2026 13:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771852960; cv=none; b=TR2TAeJzIL8D1Top7GBt5rlyNekI4fMw74tYA7lydvuO+GICcDGoi2rlCIPP1Q/qSDFoGYBZATABHT2eoO/b3V/fDkNC0dA0ZCOH3zZvPOa02wAhtRoUH4QlAetARzrgUa7qPLIQN2cGkA0aRqWr27HFZ+vdqzHdwx5GUlPiJn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771852960; c=relaxed/simple;
	bh=SRiJxTF0KXB8zVoMjCae0WvBTPOf1DI3M1av5zDpoaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hPebJgjoFebEctesLdgKdo3C7dgo0R4Vd9YJYawFXRx7U2IcO5T1v75sxciFxflIuBU5KH2IM7J+gaym5EWhzAY6DnlOIkJf4WuCp+FfvZIpJnEhrhPOD7cI47clO+Pb6BaP+ddIGGkfxP+ospWNWHGWCxTy0ef/Cy/csfLte9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ETDS4Y0+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ETDS4Y0+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=FTU0G7ZtH6mtQ9DmUHbUKxiawQvJFfGUKyNJ+G3aGNQ=; b=ETDS4Y0+iw5zKqTgR2P4vne282
	0/oSCMiN0JLzhY+ZpXGkNx1OXbXmH/w3uky/zK7mAnhQY4NSicChlPVPl4ei5mbTebRc6Sm7xf3uI
	Qt5ly6iD+Ybu9/w4IsD9/yMRzkFf3JBF7l/DQmO7lbuobxjGoVlFdD4HJ5LdLjjCQrXRlT2v44dGk
	Aem+qL+LNyvurvyr4CJ0vCxkhH1hMhS+SaKHLNBrtVmfcu6ht2ocoW0p1KJgvNLBU66FibiSItkYu
	7Bc56rRLGMhhKIdutm8VPXHhrw8XgXUwabFLWldxN/saVNX3uSfey5HPvf2vtgwnKvASLSOYwt/6+
	RhkQsz3A==;
Received: from [94.156.175.41] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vuVtU-00000000M1X-44j0;
	Mon, 23 Feb 2026 13:22:37 +0000
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
Subject: [PATCH 10/16] iomap: only call into ->submit_read when there is a read_ctx
Date: Mon, 23 Feb 2026 05:20:10 -0800
Message-ID: <20260223132021.292832-11-hch@lst.de>
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

Move the NULL check into the callers to simplify the callees.

Fuse was missing this before, but has a constant read_ctx that is
never NULL or changed, so no change here either.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Tested-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/iomap/bio.c         | 5 +----
 fs/iomap/buffered-io.c | 4 ++--
 fs/ntfs3/inode.c       | 3 +--
 3 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/iomap/bio.c b/fs/iomap/bio.c
index cb60d1facb5a..80bbd328bd3c 100644
--- a/fs/iomap/bio.c
+++ b/fs/iomap/bio.c
@@ -21,10 +21,7 @@ static void iomap_read_end_io(struct bio *bio)
 static void iomap_bio_submit_read(const struct iomap_iter *iter,
 		struct iomap_read_folio_ctx *ctx)
 {
-	struct bio *bio = ctx->read_ctx;
-
-	if (bio)
-		submit_bio(bio);
+	submit_bio(ctx->read_ctx);
 }
 
 static void iomap_read_alloc_bio(const struct iomap_iter *iter,
diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 763b266f38c5..51a58a0bfe6c 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -587,7 +587,7 @@ void iomap_read_folio(const struct iomap_ops *ops,
 		iter.status = iomap_read_folio_iter(&iter, ctx,
 				&bytes_submitted);
 
-	if (ctx->ops->submit_read)
+	if (ctx->read_ctx && ctx->ops->submit_read)
 		ctx->ops->submit_read(&iter, ctx);
 
 	if (ctx->cur_folio)
@@ -653,7 +653,7 @@ void iomap_readahead(const struct iomap_ops *ops,
 		iter.status = iomap_readahead_iter(&iter, ctx,
 					&cur_bytes_submitted);
 
-	if (ctx->ops->submit_read)
+	if (ctx->read_ctx && ctx->ops->submit_read)
 		ctx->ops->submit_read(&iter, ctx);
 
 	if (ctx->cur_folio)
diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 511967ef7ec9..7ab4e18f8013 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -656,8 +656,7 @@ static void ntfs_iomap_bio_submit_read(const struct iomap_iter *iter,
 {
 	struct bio *bio = ctx->read_ctx;
 
-	if (bio)
-		submit_bio(bio);
+	submit_bio(bio);
 }
 
 static const struct iomap_read_ops ntfs_iomap_bio_read_ops = {
-- 
2.47.3

