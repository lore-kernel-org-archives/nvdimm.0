Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41C54437
	for <nvdimm@lists.linux.dev>; Wed, 25 Jan 2023 13:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ROS65tCompeGK2agNW/ZuvBq/QEcxYeTNpBB9DoF018=; b=d2zsfJpDRFFrzt10Ijye3rXQc2
	Gjn+l3XF0voJlrGvZJbRaoDc0JsfwL53ZGXWNBzJ6miUPcn0kp8xAKeRout6JP7hGUgUeBnU8SnCL
	ZwXxcM7tOQPx16uvKwZ1a7QYhmAyFXfhWMcHRZLzuQtiHmQQ2dJ1SFoxLWl1VG9hqGtiqbKNwbZ13
	az/1JlLHspaGSvs/82k74pRav2m9Z0bMZHevtFB7Ke82yYJE5KNarfHvapG+FrtjCXWOQUJII3U+0
	mhXAdCeOuBAczTry7ksQCAQEQQBQKsezhy8QB3hprWYOCwBFc+wH4SeUtfu/DXDkl/f2QTnVwuwAK
	psNJQ/uQ==;
Received: from [2001:4bb8:19a:27af:c78f:9b0d:b95c:d248] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1pKfvO-007P2P-RA; Wed, 25 Jan 2023 13:34:51 +0000
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
Subject: [PATCH 3/7] mm: factor out a swap_readpage_bdev helper
Date: Wed, 25 Jan 2023 14:34:32 +0100
Message-Id: <20230125133436.447864-4-hch@lst.de>
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
following the abstraction for file based swap and frontswap.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/page_io.c | 68 +++++++++++++++++++++++++++-------------------------
 1 file changed, 35 insertions(+), 33 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index 6f7166fdc4b2bb..ce0b3638094f85 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -445,44 +445,15 @@ static void swap_readpage_fs(struct page *page,
 		*plug = sio;
 }
 
-void swap_readpage(struct page *page, bool synchronous, struct swap_iocb **plug)
+static void swap_readpage_bdev(struct page *page, bool synchronous,
+		struct swap_info_struct *sis)
 {
 	struct bio *bio;
-	struct swap_info_struct *sis = page_swap_info(page);
-	bool workingset = PageWorkingset(page);
-	unsigned long pflags;
-	bool in_thrashing;
-
-	VM_BUG_ON_PAGE(!PageSwapCache(page) && !synchronous, page);
-	VM_BUG_ON_PAGE(!PageLocked(page), page);
-	VM_BUG_ON_PAGE(PageUptodate(page), page);
-
-	/*
-	 * Count submission time as memory stall and delay. When the device
-	 * is congested, or the submitting cgroup IO-throttled, submission
-	 * can be a significant part of overall IO time.
-	 */
-	if (workingset) {
-		delayacct_thrashing_start(&in_thrashing);
-		psi_memstall_enter(&pflags);
-	}
-	delayacct_swapin_start();
-
-	if (frontswap_load(page) == 0) {
-		SetPageUptodate(page);
-		unlock_page(page);
-		goto out;
-	}
-
-	if (data_race(sis->flags & SWP_FS_OPS)) {
-		swap_readpage_fs(page, plug);
-		goto out;
-	}
 
 	if ((sis->flags & SWP_SYNCHRONOUS_IO) &&
 	    !bdev_read_page(sis->bdev, swap_page_sector(page), page)) {
 		count_vm_event(PSWPIN);
-		goto out;
+		return;
 	}
 
 	bio = bio_alloc(sis->bdev, 1, REQ_OP_READ, GFP_KERNEL);
@@ -509,8 +480,39 @@ void swap_readpage(struct page *page, bool synchronous, struct swap_iocb **plug)
 	}
 	__set_current_state(TASK_RUNNING);
 	bio_put(bio);
+}
+
+void swap_readpage(struct page *page, bool synchronous, struct swap_iocb **plug)
+{
+	struct swap_info_struct *sis = page_swap_info(page);
+	bool workingset = PageWorkingset(page);
+	unsigned long pflags;
+	bool in_thrashing;
+
+	VM_BUG_ON_PAGE(!PageSwapCache(page) && !synchronous, page);
+	VM_BUG_ON_PAGE(!PageLocked(page), page);
+	VM_BUG_ON_PAGE(PageUptodate(page), page);
+
+	/*
+	 * Count submission time as memory stall and delay. When the device
+	 * is congested, or the submitting cgroup IO-throttled, submission
+	 * can be a significant part of overall IO time.
+	 */
+	if (workingset) {
+		delayacct_thrashing_start(&in_thrashing);
+		psi_memstall_enter(&pflags);
+	}
+	delayacct_swapin_start();
+
+	if (frontswap_load(page) == 0) {
+		SetPageUptodate(page);
+		unlock_page(page);
+	} else if (data_race(sis->flags & SWP_FS_OPS)) {
+		swap_readpage_fs(page, plug);
+	} else {
+		swap_readpage_bdev(page, synchronous, sis);
+	}
 
-out:
 	if (workingset) {
 		delayacct_thrashing_end(&in_thrashing);
 		psi_memstall_leave(&pflags);
-- 
2.39.0

