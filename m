Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from sender-pp-092.zoho.com (sender-pp-092.zoho.com [135.84.80.237])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D6E16211B5A4C
 for <linux-nvdimm@lists.01.org>; Wed, 30 Jan 2019 18:31:51 -0800 (PST)
From: Huaisheng Ye <yehs2007@zoho.com>
Subject: [PATCH v3 2/5] dm-writecache: get rid of memory_data flush to
 writecache_flush_entry
Date: Thu, 31 Jan 2019 10:29:52 +0800
Message-Id: <20190131022955.9920-3-yehs2007@zoho.com>
In-Reply-To: <20190131022955.9920-1-yehs2007@zoho.com>
References: <20190131022955.9920-1-yehs2007@zoho.com>
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
To: mpatocka@redhat.com, snitzer@redhat.com, agk@redhat.com
Cc: jack@suse.cz, corbet@lwn.net, linux-nvdimm@lists.01.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

From: Huaisheng Ye <yehs1@lenovo.com>

writecache_flush_region only works when SSD mode.
If wc->pmem_mode sets, writecache_flush_region doesn't need to be called in
writecache_flush_entry.

Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>
---
 drivers/md/dm-writecache.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 2d8e0c0..c69317c 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -688,8 +688,6 @@ static void writecache_poison_lists(struct dm_writecache *wc)
 static void writecache_flush_entry(struct dm_writecache *wc, struct wc_entry *e)
 {
 	writecache_flush_region(wc, memory_entry(wc, e));
-	if (WC_MODE_PMEM(wc))
-		writecache_flush_region(wc, memory_data(wc, e));
 }
 
 static bool writecache_entry_is_committed(struct dm_writecache *wc, struct wc_entry *e)
-- 
1.8.3.1


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
