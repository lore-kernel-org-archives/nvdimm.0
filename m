Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 298311A2282
 for <linux-nvdimm@lists.01.org>; Mon, 18 Apr 2016 14:35:53 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 14/18] dax: Define DAX lock bit for radix tree exceptional
 entry
Date: Mon, 18 Apr 2016 23:35:37 +0200
Message-Id: <1461015341-20153-15-git-send-email-jack@suse.cz>
In-Reply-To: <1461015341-20153-1-git-send-email-jack@suse.cz>
References: <1461015341-20153-1-git-send-email-jack@suse.cz>
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
To: linux-fsdevel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

We will use lowest available bit in the radix tree exceptional entry for
locking of the entry. Define it. Also clean up definitions of DAX entry
type bits in DAX exceptional entries to use defined constants instead of
hardcoding numbers and cleanup checking of these bits to not rely on how
other bits in the entry are set.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c            | 17 +++++++++++------
 include/linux/dax.h |  3 +++
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 388327f56fa8..3e491eb37bc4 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -32,14 +32,19 @@
 #include <linux/pfn_t.h>
 #include <linux/sizes.h>
 
-#define RADIX_DAX_MASK	0xf
-#define RADIX_DAX_SHIFT	4
-#define RADIX_DAX_PTE  (0x4 | RADIX_TREE_EXCEPTIONAL_ENTRY)
-#define RADIX_DAX_PMD  (0x8 | RADIX_TREE_EXCEPTIONAL_ENTRY)
-#define RADIX_DAX_TYPE(entry) ((unsigned long)entry & RADIX_DAX_MASK)
+/*
+ * We use lowest available bit in exceptional entry for locking, other two
+ * bits to determine entry type. In total 3 special bits.
+ */
+#define RADIX_DAX_SHIFT	(RADIX_TREE_EXCEPTIONAL_SHIFT + 3)
+#define RADIX_DAX_PTE (1 << (RADIX_TREE_EXCEPTIONAL_SHIFT + 1))
+#define RADIX_DAX_PMD (1 << (RADIX_TREE_EXCEPTIONAL_SHIFT + 2))
+#define RADIX_DAX_TYPE_MASK (RADIX_DAX_PTE | RADIX_DAX_PMD)
+#define RADIX_DAX_TYPE(entry) ((unsigned long)entry & RADIX_DAX_TYPE_MASK)
 #define RADIX_DAX_SECTOR(entry) (((unsigned long)entry >> RADIX_DAX_SHIFT))
 #define RADIX_DAX_ENTRY(sector, pmd) ((void *)((unsigned long)sector << \
-		RADIX_DAX_SHIFT | (pmd ? RADIX_DAX_PMD : RADIX_DAX_PTE)))
+		RADIX_DAX_SHIFT | (pmd ? RADIX_DAX_PMD : RADIX_DAX_PTE) | \
+		RADIX_TREE_EXCEPTIONAL_ENTRY))
 
 static long dax_map_atomic(struct block_device *bdev, struct blk_dax_ctl *dax)
 {
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 0591f4853228..bef5c44f71b3 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -5,6 +5,9 @@
 #include <linux/mm.h>
 #include <asm/pgtable.h>
 
+/* We use lowest available exceptional entry bit for locking */
+#define RADIX_DAX_ENTRY_LOCK (1 << RADIX_TREE_EXCEPTIONAL_SHIFT)
+
 ssize_t dax_do_io(struct kiocb *, struct inode *, struct iov_iter *, loff_t,
 		  get_block_t, dio_iodone_t, int flags);
 int dax_clear_sectors(struct block_device *bdev, sector_t _sector, long _size);
-- 
2.6.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
