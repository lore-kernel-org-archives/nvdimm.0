Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from lgeamrelo11.lge.com (LGEAMRELO11.lge.com [156.147.23.51])
 by ml01.01.org (Postfix) with ESMTP id 61F2E21DFE928
 for <linux-nvdimm@lists.01.org>; Mon,  7 Aug 2017 23:48:16 -0700 (PDT)
From: Minchan Kim <minchan@kernel.org>
Subject: [PATCH v1 3/6] mm:swap: remove end_swap_bio_write argument
Date: Tue,  8 Aug 2017 15:50:21 +0900
Message-Id: <1502175024-28338-4-git-send-email-minchan@kernel.org>
In-Reply-To: <1502175024-28338-1-git-send-email-minchan@kernel.org>
References: <1502175024-28338-1-git-send-email-minchan@kernel.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, jack@suse.cz, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@lst.de>, linux-mm@kvack.org, kernel-team <kernel-team@lge.com>, seungho1.park@lge.com, "karam . lee" <karam.lee@lge.com>
List-ID: <linux-nvdimm@lists.01.org>

Every caller of __swap_writepage uses end_swap_bio_write as
end_write_func argument so the argument is pointless.
Remove it.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 include/linux/swap.h | 3 +--
 mm/page_io.c         | 7 +++----
 mm/zswap.c           | 2 +-
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 76f1632eea5a..ae3da979a7b7 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -336,8 +336,7 @@ extern void kswapd_stop(int nid);
 extern int swap_readpage(struct page *page, bool do_poll);
 extern int swap_writepage(struct page *page, struct writeback_control *wbc);
 extern void end_swap_bio_write(struct bio *bio);
-extern int __swap_writepage(struct page *page, struct writeback_control *wbc,
-	bio_end_io_t end_write_func);
+extern int __swap_writepage(struct page *page, struct writeback_control *wbc);
 extern int swap_set_page_dirty(struct page *page);
 
 int add_swap_extent(struct swap_info_struct *sis, unsigned long start_page,
diff --git a/mm/page_io.c b/mm/page_io.c
index 20139b90125a..3502a97f7c48 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -254,7 +254,7 @@ int swap_writepage(struct page *page, struct writeback_control *wbc)
 		end_page_writeback(page);
 		goto out;
 	}
-	ret = __swap_writepage(page, wbc, end_swap_bio_write);
+	ret = __swap_writepage(page, wbc);
 out:
 	return ret;
 }
@@ -273,8 +273,7 @@ static inline void count_swpout_vm_event(struct page *page)
 	count_vm_events(PSWPOUT, hpage_nr_pages(page));
 }
 
-int __swap_writepage(struct page *page, struct writeback_control *wbc,
-		bio_end_io_t end_write_func)
+int __swap_writepage(struct page *page, struct writeback_control *wbc)
 {
 	struct bio *bio;
 	int ret;
@@ -329,7 +328,7 @@ int __swap_writepage(struct page *page, struct writeback_control *wbc,
 	}
 
 	ret = 0;
-	bio = get_swap_bio(GFP_NOIO, page, end_write_func);
+	bio = get_swap_bio(GFP_NOIO, page, end_swap_bio_write);
 	if (bio == NULL) {
 		set_page_dirty(page);
 		unlock_page(page);
diff --git a/mm/zswap.c b/mm/zswap.c
index d39581a076c3..38db258515b5 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -900,7 +900,7 @@ static int zswap_writeback_entry(struct zpool *pool, unsigned long handle)
 	SetPageReclaim(page);
 
 	/* start writeback */
-	__swap_writepage(page, &wbc, end_swap_bio_write);
+	__swap_writepage(page, &wbc);
 	put_page(page);
 	zswap_written_back_pages++;
 
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
