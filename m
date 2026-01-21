Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434DE44CF4E;
	Wed, 21 Jan 2026 06:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768977875; cv=none; b=u8nL335tqwOLfKEtJuNL23n/vtvdvwH5M/+Kfi5U1+Xa7LZDb13gjwzUIQDa82ht+x7Gi8kjMn079Sw41THUD+GCrapi4npCWgMZ8H8voC/G/IppB6tybROCGOs5maPUaFhAEZbSMM+fv3pkAu5TEDtvKMTWqWmbntT7hIGn2bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768977875; c=relaxed/simple;
	bh=RRhsO1eo6ZwZLwTH4y6AnxSU+XkUmgjMy/N+bKt+Qag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bb1CBHMamk4TybYSbmGcI2hFYW4vf6WJVTF9bwHr2Bncnc78IP1em2qGSaClP65EHaSPPDlTL4GNnzLg+fBH0HxwJboS4fylisMAwU75sICbXji5JVIkN8Xp9myzAvitF0O8floPA0QIEW7TSTDmu7iZaLTgLw+3yCMILCYI92w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=m7O4shH5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="m7O4shH5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=EwWDcL7mNg0ZRQDmr7tn0j/EoTiOI1Cu3DzRGdKaxsY=; b=m7O4shH5S9knB0U+xi1AkXF61u
	kR0JMLzt3z+bnFE96ocNdskq2Pqk9hXwvutm78JdFhKn8fHi9o6tJ25mjFh9ENMly9IPIDM6z/Uyq
	wTZwA4toxi1msIhPWsqlLHZ8iu5iRKhCbp7hoYpdTXK0BaTDm4SHnpZ2w2kABmg3NRX8RSXA20gUB
	SQ52r3MsbW0gKbS91WeWupf/mdMaDcBEt7mR9cCWhyL41PB5kQU6PjC5+7QXV6WMhjyeWhiJIOrCa
	NlRs+llV8iA1H5RRfKN1qKQPOHtEeaYroubPYN/o9vg4Q/8YkUPrD0RLs3qQuPPkkWBfSsTH+ysro
	Bb2KXvoQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1viRxA-00000004xax-3BYB;
	Wed, 21 Jan 2026 06:44:33 +0000
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
Subject: [PATCH 10/15] iomap: only call into ->submit_read when there is a read_ctx
Date: Wed, 21 Jan 2026 07:43:18 +0100
Message-ID: <20260121064339.206019-11-hch@lst.de>
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

Move the NULL check into the callers to simplify the callees.  Not sure
how fuse worked before, given that it was missing the NULL check.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/bio.c         | 5 +----
 fs/iomap/buffered-io.c | 4 ++--
 2 files changed, 3 insertions(+), 6 deletions(-)

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
index 4a15c6c153c4..6367f7f38f0c 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -572,7 +572,7 @@ void iomap_read_folio(const struct iomap_ops *ops,
 		iter.status = iomap_read_folio_iter(&iter, ctx,
 				&bytes_submitted);
 
-	if (ctx->ops->submit_read)
+	if (ctx->read_ctx && ctx->ops->submit_read)
 		ctx->ops->submit_read(&iter, ctx);
 
 	iomap_read_end(folio, bytes_submitted);
@@ -636,7 +636,7 @@ void iomap_readahead(const struct iomap_ops *ops,
 		iter.status = iomap_readahead_iter(&iter, ctx,
 					&cur_bytes_submitted);
 
-	if (ctx->ops->submit_read)
+	if (ctx->read_ctx && ctx->ops->submit_read)
 		ctx->ops->submit_read(&iter, ctx);
 
 	if (ctx->cur_folio)
-- 
2.47.3

