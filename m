Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686784C6D
	for <nvdimm@lists.linux.dev>; Wed, 25 Jan 2023 13:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=TjTCQ4W/29YQuTOitm932bfpCXinG0reI1NrYTz/RJs=; b=Qa7NsUs+tvjV6sn3Kr0WIEmeG9
	geCnOc/IfyJxD9jHyWR/aN/A+TdXVZUfPy08CvfCxirk0mn9RmZVet9GdDBUb+pZ15qgVGPBGtzso
	QHEZQzT6kWyev3o6cAh6dAdjgTHxhev/QUsLJgkklZ0nXSKrdnTAlRntR9SiFK1438rz6lAE2Hpri
	h6CQfd/Z3iewk34wp9Lp40RKfXjVgKdofOMupCfP8jC+sr9umVu4jN3RDTewqJq03Y6kYUhiohgiI
	c7CoSzjjxFRQfN6MC3tuXDmzqdxnv2m5DTBHHzUWYe4RaojFo0cRMQ1D8vXnpnI6y8MLcrcx2vNri
	ukqR28IQ==;
Received: from [2001:4bb8:19a:27af:c78f:9b0d:b95c:d248] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1pKfvW-007P4q-JB; Wed, 25 Jan 2023 13:34:59 +0000
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
Subject: [PATCH 5/7] mm: remove the __swap_writepage return value
Date: Wed, 25 Jan 2023 14:34:34 +0100
Message-Id: <20230125133436.447864-6-hch@lst.de>
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

__swap_writepage always returns 0.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/page_io.c | 23 +++++++++--------------
 mm/swap.h    |  2 +-
 2 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index 21ce4505f00607..c373d5694cdffd 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -178,11 +178,11 @@ int generic_swapfile_activate(struct swap_info_struct *sis,
 int swap_writepage(struct page *page, struct writeback_control *wbc)
 {
 	struct folio *folio = page_folio(page);
-	int ret = 0;
+	int ret;
 
 	if (folio_free_swap(folio)) {
 		folio_unlock(folio);
-		goto out;
+		return 0;
 	}
 	/*
 	 * Arch code may have to preserve more data than just the page
@@ -192,17 +192,16 @@ int swap_writepage(struct page *page, struct writeback_control *wbc)
 	if (ret) {
 		folio_mark_dirty(folio);
 		folio_unlock(folio);
-		goto out;
+		return ret;
 	}
 	if (frontswap_store(&folio->page) == 0) {
 		folio_start_writeback(folio);
 		folio_unlock(folio);
 		folio_end_writeback(folio);
-		goto out;
+		return 0;
 	}
-	ret = __swap_writepage(&folio->page, wbc);
-out:
-	return ret;
+	__swap_writepage(&folio->page, wbc);
+	return 0;
 }
 
 static inline void count_swpout_vm_event(struct page *page)
@@ -289,7 +288,7 @@ static void sio_write_complete(struct kiocb *iocb, long ret)
 	mempool_free(sio, sio_pool);
 }
 
-static int swap_writepage_fs(struct page *page, struct writeback_control *wbc)
+static void swap_writepage_fs(struct page *page, struct writeback_control *wbc)
 {
 	struct swap_iocb *sio = NULL;
 	struct swap_info_struct *sis = page_swap_info(page);
@@ -326,11 +325,9 @@ static int swap_writepage_fs(struct page *page, struct writeback_control *wbc)
 	}
 	if (wbc->swap_plug)
 		*wbc->swap_plug = sio;
-
-	return 0;
 }
 
-int __swap_writepage(struct page *page, struct writeback_control *wbc)
+void __swap_writepage(struct page *page, struct writeback_control *wbc)
 {
 	struct bio *bio;
 	int ret;
@@ -348,7 +345,7 @@ int __swap_writepage(struct page *page, struct writeback_control *wbc)
 	ret = bdev_write_page(sis->bdev, swap_page_sector(page), page, wbc);
 	if (!ret) {
 		count_swpout_vm_event(page);
-		return 0;
+		return;
 	}
 
 	bio = bio_alloc(sis->bdev, 1,
@@ -363,8 +360,6 @@ int __swap_writepage(struct page *page, struct writeback_control *wbc)
 	set_page_writeback(page);
 	unlock_page(page);
 	submit_bio(bio);
-
-	return 0;
 }
 
 void swap_write_unplug(struct swap_iocb *sio)
diff --git a/mm/swap.h b/mm/swap.h
index f5eb5069d28c2e..28be6cb3277fa4 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -17,7 +17,7 @@ static inline void swap_read_unplug(struct swap_iocb *plug)
 }
 void swap_write_unplug(struct swap_iocb *sio);
 int swap_writepage(struct page *page, struct writeback_control *wbc);
-int __swap_writepage(struct page *page, struct writeback_control *wbc);
+void __swap_writepage(struct page *page, struct writeback_control *wbc);
 
 /* linux/mm/swap_state.c */
 /* One swap address space for each 64M swap space */
-- 
2.39.0

