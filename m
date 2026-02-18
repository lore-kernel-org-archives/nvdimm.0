Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7CA12DC323;
	Wed, 18 Feb 2026 06:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771395231; cv=none; b=GFnKNucEkyxBNxdhVna7Go3QCYFdfcvDuxgBE4XuCvhEzOZTHwJ48Y8Cb2R0K7gvhfvDq4BUX/sESB9qri7+ZawM6rtdnyfwWjYhITqbQ2v7YQrIR6wzYaGQKmoO4w1ot7B6vyfb28LT4XqXxaLaEtBE+OuCcRT8WlgMVA2EXG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771395231; c=relaxed/simple;
	bh=OQabbqWhjC9e55rpxrMhHPgQR6QrNg8bPq/NfmF3dMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bz90KY7fqhOWRlisvODA8mcrclaErilqH69D9ukYbQhBwo0BSmzQN2PFHF7m56mkqGSCMfEunTx2m1quzWIxpwWsRXKyD890g4p4iCyye1LVizVWi9uGM7PTYjEyS3MDXqIOL/n4vkR98/5ds+u7qB12WxK6no2a0fUFqqFOyAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=u3qsr8rx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="u3qsr8rx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Q9SWKGikV9J4BIuZzTfJI/5QtAsEWKOEmo9u48iCeeI=; b=u3qsr8rxGFThLFTjfEHcDx87ew
	6XixHP/NRdDgwKLGAr/BwhgFdI6liy6UPNLhbkKsnVqbDCMDQuB6nMn9IjiFOAVU7/DHhuBZy3Rlv
	8FdJw7nvfY1OvERrKVtR52hf1O/qAU2CFTeBxvzh/0ql9YLLn/Ymg79rWCmJ7yzaOc6NMj1xgJ5Q1
	XYg5ZRPFyEevft9wHzT3S167PEQI59SN+lxz9WIWdCes2/fgtYkTJiAANhSaqxD/YB+QT+pbLbHs7
	kyyxgYuJjI1r+bvStHCSdqTQeaSFsyvoRRP1ioSW9fRDx6qRSGiF9FiL6vyEMAVAkFkemW1PLsfPq
	OSsrm/xQ==;
Received: from [2001:4bb8:2dc:9863:1842:9381:9c0f:de32] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vsaon-00000009LVO-1vzX;
	Wed, 18 Feb 2026 06:13:49 +0000
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
Subject: [PATCH 13/15] iomap: support ioends for buffered reads
Date: Wed, 18 Feb 2026 07:12:07 +0100
Message-ID: <20260218061238.3317841-14-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260218061238.3317841-1-hch@lst.de>
References: <20260218061238.3317841-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Support using the ioend structure to defer I/O completion for
buffered reads by calling into the buffered read I/O completion
handler from iomap_finish_ioend.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Tested-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/iomap/bio.c      | 19 ++++++++++++++++---
 fs/iomap/internal.h |  1 +
 fs/iomap/ioend.c    |  8 +++++---
 3 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/fs/iomap/bio.c b/fs/iomap/bio.c
index 259a2bf95a43..b4de67bdd513 100644
--- a/fs/iomap/bio.c
+++ b/fs/iomap/bio.c
@@ -8,14 +8,27 @@
 #include "internal.h"
 #include "trace.h"
 
-static void iomap_read_end_io(struct bio *bio)
+static u32 __iomap_read_end_io(struct bio *bio, int error)
 {
-	int error = blk_status_to_errno(bio->bi_status);
 	struct folio_iter fi;
+	u32 folio_count = 0;
 
-	bio_for_each_folio_all(fi, bio)
+	bio_for_each_folio_all(fi, bio) {
 		iomap_finish_folio_read(fi.folio, fi.offset, fi.length, error);
+		folio_count++;
+	}
 	bio_put(bio);
+	return folio_count;
+}
+
+static void iomap_read_end_io(struct bio *bio)
+{
+	__iomap_read_end_io(bio, blk_status_to_errno(bio->bi_status));
+}
+
+u32 iomap_finish_ioend_buffered_read(struct iomap_ioend *ioend)
+{
+	return __iomap_read_end_io(&ioend->io_bio, ioend->io_error);
 }
 
 static void iomap_bio_submit_read(const struct iomap_iter *iter,
diff --git a/fs/iomap/internal.h b/fs/iomap/internal.h
index 3a4e4aad2bd1..b39dbc17e3f0 100644
--- a/fs/iomap/internal.h
+++ b/fs/iomap/internal.h
@@ -4,6 +4,7 @@
 
 #define IOEND_BATCH_SIZE	4096
 
+u32 iomap_finish_ioend_buffered_read(struct iomap_ioend *ioend);
 u32 iomap_finish_ioend_direct(struct iomap_ioend *ioend);
 
 #ifdef CONFIG_BLOCK
diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
index e4d57cb969f1..c6b6cd0f2fdd 100644
--- a/fs/iomap/ioend.c
+++ b/fs/iomap/ioend.c
@@ -37,7 +37,7 @@ EXPORT_SYMBOL_GPL(iomap_init_ioend);
  * state, release holds on bios, and finally free up memory.  Do not use the
  * ioend after this.
  */
-static u32 iomap_finish_ioend_buffered(struct iomap_ioend *ioend)
+static u32 iomap_finish_ioend_buffered_write(struct iomap_ioend *ioend)
 {
 	struct inode *inode = ioend->io_inode;
 	struct bio *bio = &ioend->io_bio;
@@ -74,7 +74,7 @@ static void ioend_writeback_end_bio(struct bio *bio)
 	struct iomap_ioend *ioend = iomap_ioend_from_bio(bio);
 
 	ioend->io_error = blk_status_to_errno(bio->bi_status);
-	iomap_finish_ioend_buffered(ioend);
+	iomap_finish_ioend_buffered_write(ioend);
 }
 
 /*
@@ -266,7 +266,9 @@ static u32 iomap_finish_ioend(struct iomap_ioend *ioend, int error)
 		return 0;
 	if (ioend->io_flags & IOMAP_IOEND_DIRECT)
 		return iomap_finish_ioend_direct(ioend);
-	return iomap_finish_ioend_buffered(ioend);
+	if (bio_op(&ioend->io_bio) == REQ_OP_READ)
+		return iomap_finish_ioend_buffered_read(ioend);
+	return iomap_finish_ioend_buffered_write(ioend);
 }
 
 /*
-- 
2.47.3

