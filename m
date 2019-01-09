Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from sender-pp-092.zoho.com (sender-pp-092.zoho.com [135.84.80.237])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F1198211B506F
 for <linux-nvdimm@lists.01.org>; Tue,  8 Jan 2019 21:32:07 -0800 (PST)
From: Huaisheng Ye <yehs2007@zoho.com>
Subject: [RFC PATCH v2 1/4] dm-writecache: remove unused size to
 writecache_flush_region
Date: Wed,  9 Jan 2019 13:31:24 +0800
Message-Id: <20190109053127.8128-2-yehs2007@zoho.com>
In-Reply-To: <20190109053127.8128-1-yehs2007@zoho.com>
References: <20190109053127.8128-1-yehs2007@zoho.com>
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
To: snitzer@redhat.com, agk@redhat.com
Cc: jack@suse.cz, corbet@lwn.net, chengnt@lenovo.com, linux-nvdimm@lists.01.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

From: Huaisheng Ye <yehs1@lenovo.com>

writecache_flush_region doesn't use size to calculate flush region.
That uses _set_bits to mark the region in dirty_bitmap directly.

Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>
---
 drivers/md/dm-writecache.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 2d50eec..2d8e0c0 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -418,7 +418,7 @@ static void writecache_flush_all_metadata(struct dm_writecache *wc)
 		memset(wc->dirty_bitmap, -1, wc->dirty_bitmap_size);
 }
 
-static void writecache_flush_region(struct dm_writecache *wc, void *ptr, size_t size)
+static void writecache_flush_region(struct dm_writecache *wc, void *ptr)
 {
 	if (!WC_MODE_PMEM(wc))
 		__set_bit(((char *)ptr - (char *)wc->memory_map) / BITMAP_GRANULARITY,
@@ -657,7 +657,7 @@ static void writecache_free_entry(struct dm_writecache *wc, struct wc_entry *e)
 	writecache_unlink(wc, e);
 	writecache_add_to_freelist(wc, e);
 	clear_seq_count(wc, e);
-	writecache_flush_region(wc, memory_entry(wc, e), sizeof(struct wc_memory_entry));
+	writecache_flush_region(wc, memory_entry(wc, e));
 	if (unlikely(waitqueue_active(&wc->freelist_wait)))
 		wake_up(&wc->freelist_wait);
 }
@@ -687,9 +687,9 @@ static void writecache_poison_lists(struct dm_writecache *wc)
 
 static void writecache_flush_entry(struct dm_writecache *wc, struct wc_entry *e)
 {
-	writecache_flush_region(wc, memory_entry(wc, e), sizeof(struct wc_memory_entry));
+	writecache_flush_region(wc, memory_entry(wc, e));
 	if (WC_MODE_PMEM(wc))
-		writecache_flush_region(wc, memory_data(wc, e), wc->block_size);
+		writecache_flush_region(wc, memory_data(wc, e));
 }
 
 static bool writecache_entry_is_committed(struct dm_writecache *wc, struct wc_entry *e)
@@ -733,7 +733,7 @@ static void writecache_flush(struct dm_writecache *wc)
 
 	wc->seq_count++;
 	pmem_assign(sb(wc)->seq_count, cpu_to_le64(wc->seq_count));
-	writecache_flush_region(wc, &sb(wc)->seq_count, sizeof sb(wc)->seq_count);
+	writecache_flush_region(wc, &sb(wc)->seq_count);
 	writecache_commit_flushed(wc);
 
 	wc->overwrote_committed = false;
@@ -1757,7 +1757,7 @@ static int init_memory(struct dm_writecache *wc)
 	writecache_flush_all_metadata(wc);
 	writecache_commit_flushed(wc);
 	pmem_assign(sb(wc)->magic, cpu_to_le32(MEMORY_SUPERBLOCK_MAGIC));
-	writecache_flush_region(wc, &sb(wc)->magic, sizeof sb(wc)->magic);
+	writecache_flush_region(wc, &sb(wc)->magic);
 	writecache_commit_flushed(wc);
 
 	return 0;
-- 
1.8.3.1


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
