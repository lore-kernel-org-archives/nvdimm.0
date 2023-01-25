Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39EB4C6D
	for <nvdimm@lists.linux.dev>; Wed, 25 Jan 2023 13:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=O8RUMOLSrBkE/AeLTaJ5NRi7CBbI3GgiJS4cpgVv33A=; b=FZLS7LERrZSdq80qX1+1MvYfm+
	tHSMY9a2OAXiuep3YUjzxChyTd7mWMpjgGGK1IWSZCHOrsBc4mYr9O0fcAuBRVeVf/HygYJyfUxBK
	6zaLL47c+sAcntjQ0kgrkDmgJ5LiUUvvcUQ8ROLe5lvCOY66Gmlpi0BFWsebpRD9KlaIh5wQ2fCMA
	jTDLpbWC61h8bEnaKdenCM22qooLGyurBJsPxnpvIj3NMRRDkq7+3Sqyzxa3wXqlXJiM1niLjZMZQ
	pM7HXBQ9xd74o4URQAYlOsC7tXJS0grlmJQts2LwPMdvETtcJh13rKH47OPAJQn7JzpP5EkFPeOgJ
	r5n6fmsg==;
Received: from [2001:4bb8:19a:27af:c78f:9b0d:b95c:d248] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1pKfvZ-007P6r-P0; Wed, 25 Jan 2023 13:35:02 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-block@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6/7] mm: factor out a swap_writepage_bdev helper
Date: Wed, 25 Jan 2023 14:34:35 +0100
Message-Id: <20230125133436.447864-7-hch@lst.de>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230125133436.447864-1-hch@lst.de>
References: <20230125133436.447864-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Split the block device case from swap_readpage into a separate helper,
following the abstraction for file based swap.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/page_io.c | 33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index c373d5694cdffd..2ee2bfe5de0386 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -327,23 +327,12 @@ static void swap_writepage_fs(struct page *page, struct writeback_control *wbc)
 		*wbc->swap_plug = sio;
 }
 
-void __swap_writepage(struct page *page, struct writeback_control *wbc)
+static void swap_writepage_bdev(struct page *page,
+		struct writeback_control *wbc, struct swap_info_struct *sis)
 {
 	struct bio *bio;
-	int ret;
-	struct swap_info_struct *sis = page_swap_info(page);
-
-	VM_BUG_ON_PAGE(!PageSwapCache(page), page);
-	/*
-	 * ->flags can be updated non-atomicially (scan_swap_map_slots),
-	 * but that will never affect SWP_FS_OPS, so the data_race
-	 * is safe.
-	 */
-	if (data_race(sis->flags & SWP_FS_OPS))
-		return swap_writepage_fs(page, wbc);
 
-	ret = bdev_write_page(sis->bdev, swap_page_sector(page), page, wbc);
-	if (!ret) {
+	if (!bdev_write_page(sis->bdev, swap_page_sector(page), page, wbc)) {
 		count_swpout_vm_event(page);
 		return;
 	}
@@ -362,6 +351,22 @@ void __swap_writepage(struct page *page, struct writeback_control *wbc)
 	submit_bio(bio);
 }
 
+void __swap_writepage(struct page *page, struct writeback_control *wbc)
+{
+	struct swap_info_struct *sis = page_swap_info(page);
+
+	VM_BUG_ON_PAGE(!PageSwapCache(page), page);
+	/*
+	 * ->flags can be updated non-atomicially (scan_swap_map_slots),
+	 * but that will never affect SWP_FS_OPS, so the data_race
+	 * is safe.
+	 */
+	if (data_race(sis->flags & SWP_FS_OPS))
+		swap_writepage_fs(page, wbc);
+	else
+		swap_writepage_bdev(page, wbc, sis);
+}
+
 void swap_write_unplug(struct swap_iocb *sio)
 {
 	struct iov_iter from;
-- 
2.39.0

