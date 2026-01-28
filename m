Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6717630F53B;
	Wed, 28 Jan 2026 16:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769616988; cv=none; b=jS7FifJRwYW0UTL0jzAjEGjQEf8iJ3g4DujPvfzA4SDA0RDgfPOwfSchwpdLNk3IL1zEiHh0PYhPvLlQh8X9cyrXMlxIQVkMpc60+nV5kr0PNvIpwEv4PUzku6Tv2v1lEZblkhcJWcZ1c0kutTxccuX9Z06JHVRWbejs7ngONO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769616988; c=relaxed/simple;
	bh=9vL3zbovJ3YynWArD5k5R/HL6A8+fPirk30gkc0V9Zg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jMo/Jhe/yU6u7jBuuIrfYEQiTjRutkmG2dlc0ymPFejhLV0rAx1rrieJEfl6ay+J9wtLtFwhnWTwwOq9vnvLZ0CsZdVZaLitJSiuqIiAhEeBHzjgZQCPYrLbCUaoU6PWk2qqrA6dnQTSvOW8PLjr3xY8fVEAhf0wCx1nAKp8YWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XiGA30Te; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XiGA30Te"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=s3+dPyTJnMRFW1/3WFlfMjjhVsyxtcfrsvZiMonhyOI=; b=XiGA30TeciRAl9r72/0Huzl2MP
	em+7pbkgczAfk63N/cHdSoPF7RauwWt0PkmtAakH1hXEbGemQlruf1e2V7JHchYyuv9G3vDvnBIC6
	klWghoRCwmeClAV4RUgO8S2e1BoXWqDIeW/NnevCx5RSpzGF1hcW7/CCfz7QcWJRbeqajapfN2fE3
	d6HzFnu7dynXFGXzkp1T9ufyj07YiFaX7c/b01bIBTX2+lh8bDJuFwFVs0EpdQ0T/kPpRH8kg8QMW
	c+nWFkoXdnKTmrJklki+Q2iZUIQt925xyFpre8V96uQKacw1fN6RyRPmtCRUxSRf5q0V1dch0bM4i
	WRuaS6FA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vl8DR-0000000GN1V-3nAJ;
	Wed, 28 Jan 2026 16:16:26 +0000
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
Date: Wed, 28 Jan 2026 17:15:05 +0100
Message-ID: <20260128161517.666412-11-hch@lst.de>
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

Move the NULL check into the callers to simplify the callees.

Fuse was missing this before, but has a constant read_ctx that is
never NULL or changed, so no change here either.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Tested-by: Anuj Gupta <anuj20.g@samsung.com>
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
index 6640614262c9..ee7b845f5bc8 100644
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

