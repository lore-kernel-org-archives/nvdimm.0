Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E649B29CA
	for <nvdimm@lists.linux.dev>; Mon,  9 Aug 2021 06:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=pIweo/AL/gcZqzgCAsUa+XaqbXIAEc0CYS2F7Cx/rGI=; b=JRbW7pvPCgOnlXjYzyUB9nCvFr
	DwBTMasgOuoV4MaPJ6TeBkC/f2j7jcpzDWrPT52kWlSXsoNDWIZY9boCcYoTc/LrBgZwNCG64nEhd
	fl/UEsY4mGb34ANHrxdrTAhgizpn1/NSwaH/cddp7MVXTh3MZ/0gHd/h2DnoymE3Du2KlPQwCRKuS
	8rxgerMHCH/nEcFHDiHMcEE2CCG+EaxE+81E6hYZt85TLCX0C2aJnNVXXfLJ8C0puPBWmgwaYQMdX
	eje1sjIa/mS8zmYyI6F3g8gg7BYSaQ/eGmcyS5plYa75Vd7wYwNEbUYJFcK1VJCreB3c9FRRkEsJ4
	i+uPfo7g==;
Received: from [2a02:1205:5023:1f80:c068:bd3d:78b3:7d37] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mCylY-00AhU4-TN; Mon, 09 Aug 2021 06:28:18 +0000
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
Subject: [PATCH 19/30] iomap: switch iomap_bmap to use iomap_iter
Date: Mon,  9 Aug 2021 08:12:33 +0200
Message-Id: <20210809061244.1196573-20-hch@lst.de>
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

Rewrite the ->bmap implementation based on iomap_iter.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/fiemap.c | 31 +++++++++++++------------------
 1 file changed, 13 insertions(+), 18 deletions(-)

diff --git a/fs/iomap/fiemap.c b/fs/iomap/fiemap.c
index acad09a8c188df..60daadba16c149 100644
--- a/fs/iomap/fiemap.c
+++ b/fs/iomap/fiemap.c
@@ -92,35 +92,30 @@ int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fi,
 }
 EXPORT_SYMBOL_GPL(iomap_fiemap);
 
-static loff_t
-iomap_bmap_actor(struct inode *inode, loff_t pos, loff_t length,
-		void *data, struct iomap *iomap, struct iomap *srcmap)
-{
-	sector_t *bno = data, addr;
-
-	if (iomap->type == IOMAP_MAPPED) {
-		addr = (pos - iomap->offset + iomap->addr) >> inode->i_blkbits;
-		*bno = addr;
-	}
-	return 0;
-}
-
 /* legacy ->bmap interface.  0 is the error return (!) */
 sector_t
 iomap_bmap(struct address_space *mapping, sector_t bno,
 		const struct iomap_ops *ops)
 {
-	struct inode *inode = mapping->host;
-	loff_t pos = bno << inode->i_blkbits;
-	unsigned blocksize = i_blocksize(inode);
+	struct iomap_iter iter = {
+		.inode	= mapping->host,
+		.pos	= (loff_t)bno << mapping->host->i_blkbits,
+		.len	= i_blocksize(mapping->host),
+		.flags	= IOMAP_REPORT,
+	};
 	int ret;
 
 	if (filemap_write_and_wait(mapping))
 		return 0;
 
 	bno = 0;
-	ret = iomap_apply(inode, pos, blocksize, 0, ops, &bno,
-			  iomap_bmap_actor);
+	while ((ret = iomap_iter(&iter, ops)) > 0) {
+		if (iter.iomap.type != IOMAP_MAPPED)
+			continue;
+		bno = (iter.pos - iter.iomap.offset + iter.iomap.addr) >>
+				mapping->host->i_blkbits;
+	}
+
 	if (ret)
 		return 0;
 	return bno;
-- 
2.30.2

