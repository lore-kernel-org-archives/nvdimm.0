Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040BD168
	for <nvdimm@lists.linux.dev>; Mon, 19 Jul 2021 10:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=FqjtGxykPysD9B+kaXYjfcu/sPVaRHQd21+uD3O8ue0=; b=Gh90E4cILqoFBujZjDE06QNLY+
	41+ia8+McOtaB5QkX20myiO9kW0RmgBIZ7+w6YUPsuEX0aUafEno8z3eox86FurfjgbcS6CQHXVVh
	bWm0x4w9WiHPdY/lu9Osx5eZtXqMibx6D8vQm4LewrAlbtYvBD4Ogo5MVZQA1mZsPhVxLYf8npabd
	pFL78taF1XwHCDo2drtdfVHQPtYz28tjOvo2EYrQ+FqstpqD2lH6nQwOsSEKCciiqIxATBQgHmfvy
	MsCoeOaFtYFJWsbuJxyzddWukE2oO136yUDdyKxx6G1zz+WsTPvU4oZc+LmnZF+tSzA/FPp30JitR
	1TJJD03w==;
Received: from [2001:4bb8:193:7660:d2a4:8d57:2e55:21d0] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1m5QmT-006l6w-Dn; Mon, 19 Jul 2021 10:46:42 +0000
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	nvdimm@lists.linux.dev,
	cluster-devel@redhat.com
Subject: [PATCH 10/27] iomap: switch iomap_file_buffered_write to use iomap_iter
Date: Mon, 19 Jul 2021 12:35:03 +0200
Message-Id: <20210719103520.495450-11-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210719103520.495450-1-hch@lst.de>
References: <20210719103520.495450-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

Switch iomap_file_buffered_write to use iomap_iter.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/buffered-io.c | 49 +++++++++++++++++++++---------------------
 1 file changed, 25 insertions(+), 24 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 3b18cafa72bec6..7195e82d15775e 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -715,13 +715,14 @@ static size_t iomap_write_end(struct inode *inode, loff_t pos, size_t len,
 	return ret;
 }
 
-static loff_t
-iomap_write_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
-		struct iomap *iomap, struct iomap *srcmap)
+static loff_t iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
 {
-	struct iov_iter *i = data;
-	long status = 0;
+	struct iomap *srcmap = iomap_iter_srcmap(iter);
+	struct iomap *iomap = &iter->iomap;
+	loff_t length = iomap_length(iter);
+	loff_t pos = iter->pos;
 	ssize_t written = 0;
+	long status = 0;
 
 	do {
 		struct page *page;
@@ -747,18 +748,18 @@ iomap_write_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 			break;
 		}
 
-		status = iomap_write_begin(inode, pos, bytes, 0, &page, iomap,
-				srcmap);
+		status = iomap_write_begin(iter->inode, pos, bytes, 0, &page,
+					   iomap, srcmap);
 		if (unlikely(status))
 			break;
 
-		if (mapping_writably_mapped(inode->i_mapping))
+		if (mapping_writably_mapped(iter->inode->i_mapping))
 			flush_dcache_page(page);
 
 		copied = copy_page_from_iter_atomic(page, offset, bytes, i);
 
-		status = iomap_write_end(inode, pos, bytes, copied, page, iomap,
-				srcmap);
+		status = iomap_write_end(iter->inode, pos, bytes, copied, page,
+					 iomap, srcmap);
 
 		if (unlikely(copied != status))
 			iov_iter_revert(i, copied - status);
@@ -779,29 +780,29 @@ iomap_write_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 		written += status;
 		length -= status;
 
-		balance_dirty_pages_ratelimited(inode->i_mapping);
+		balance_dirty_pages_ratelimited(iter->inode->i_mapping);
 	} while (iov_iter_count(i) && length);
 
 	return written ? written : status;
 }
 
 ssize_t
-iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *iter,
+iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *i,
 		const struct iomap_ops *ops)
 {
-	struct inode *inode = iocb->ki_filp->f_mapping->host;
-	loff_t pos = iocb->ki_pos, ret = 0, written = 0;
-
-	while (iov_iter_count(iter)) {
-		ret = iomap_apply(inode, pos, iov_iter_count(iter),
-				IOMAP_WRITE, ops, iter, iomap_write_actor);
-		if (ret <= 0)
-			break;
-		pos += ret;
-		written += ret;
-	}
+	struct iomap_iter iter = {
+		.inode		= iocb->ki_filp->f_mapping->host,
+		.pos		= iocb->ki_pos,
+		.len		= iov_iter_count(i),
+		.flags		= IOMAP_WRITE,
+	};
+	int ret;
 
-	return written ? written : ret;
+	while ((ret = iomap_iter(&iter, ops)) > 0)
+		iter.processed = iomap_write_iter(&iter, i);
+	if (iter.pos == iocb->ki_pos)
+		return ret;
+	return iter.pos - iocb->ki_pos;
 }
 EXPORT_SYMBOL_GPL(iomap_file_buffered_write);
 
-- 
2.30.2

