Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55EF617F
	for <nvdimm@lists.linux.dev>; Mon,  9 Aug 2021 06:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=AMNmifYmAMSDpJFQ74sQWL+WsEz1AvrROlbIBmbutsk=; b=QIgKN4H4oULgL+SAtv3vLRDPrK
	R3xRiV2WiMG/z5ziQ6uDSD3FXlcyaeiPyhGFiLOjS61HRmZ3yPjdX5B6SjQXiyeOUdZJSb6K/3/wV
	cIk5ZP9LD3WHCg/tHz+O+V/kXDT+UNPJ8hj5OMDmF6lSWZOkFlqHYSv4c8BAbKXBdSZW3RIVIN3Nb
	DzLqfnwWc9KrOeMgUT3uocxZN58oAskUYozcU1ju5bGTG2zakyHZ+4AxnYgYFvQqO9DAS6JirCuZD
	X5SkY3uY1nOM/RZ6hPA6xJIQASWvM6EpsafZMeD3COCFXTD2sKFQ3GqkFGlGS+2rLW8qOQcfiNsLs
	NggFqphQ==;
Received: from [2a02:1205:5023:1f80:c068:bd3d:78b3:7d37] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mCydq-00Agp4-Mz; Mon, 09 Aug 2021 06:20:19 +0000
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
Subject: [PATCH 10/30] iomap: fix the iomap_readpage_actor return value for inline data
Date: Mon,  9 Aug 2021 08:12:24 +0200
Message-Id: <20210809061244.1196573-11-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210809061244.1196573-1-hch@lst.de>
References: <20210809061244.1196573-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

The actor should never return a larger value than the length that was
passed in.  The current code handles this gracefully, but the opcoming
iter model will be more picky.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/buffered-io.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 44587209e6d7c7..26e16cc9d44931 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -205,7 +205,7 @@ struct iomap_readpage_ctx {
 	struct readahead_control *rac;
 };
 
-static int iomap_read_inline_data(struct inode *inode, struct page *page,
+static loff_t iomap_read_inline_data(struct inode *inode, struct page *page,
 		const struct iomap *iomap)
 {
 	size_t size = i_size_read(inode) - iomap->offset;
@@ -253,7 +253,7 @@ iomap_readpage_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 	sector_t sector;
 
 	if (iomap->type == IOMAP_INLINE)
-		return iomap_read_inline_data(inode, page, iomap);
+		return min(iomap_read_inline_data(inode, page, iomap), length);
 
 	/* zero post-eof blocks as the page may be mapped */
 	iop = iomap_page_create(inode, page);
-- 
2.30.2

