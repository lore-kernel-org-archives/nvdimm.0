Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 80D0F1A1F29
 for <linux-nvdimm@lists.01.org>; Wed, 11 May 2016 02:59:22 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/7] DAX: move RADIX_DAX_ definitions to dax.c
Date: Wed, 11 May 2016 11:58:47 +0200
Message-Id: <1462960733-29634-2-git-send-email-jack@suse.cz>
In-Reply-To: <1462960733-29634-1-git-send-email-jack@suse.cz>
References: <1462960733-29634-1-git-send-email-jack@suse.cz>
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
To: linux-nvdimm@lists.01.org
Cc: Ted Tso <tytso@mit.edu>, NeilBrown <neilb@suse.com>, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

From: NeilBrown <neilb@suse.com>

These don't belong in radix-tree.c any more than PAGECACHE_TAG_* do.
Let's try to maintain the idea that radix-tree simply implements an
abstract data type.

Acked-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: NeilBrown <neilb@suse.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c                   | 9 +++++++++
 include/linux/radix-tree.h | 9 ---------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 75ba46d82a76..08799a510b4d 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -32,6 +32,15 @@
 #include <linux/pfn_t.h>
 #include <linux/sizes.h>
 
+#define RADIX_DAX_MASK	0xf
+#define RADIX_DAX_SHIFT	4
+#define RADIX_DAX_PTE  (0x4 | RADIX_TREE_EXCEPTIONAL_ENTRY)
+#define RADIX_DAX_PMD  (0x8 | RADIX_TREE_EXCEPTIONAL_ENTRY)
+#define RADIX_DAX_TYPE(entry) ((unsigned long)entry & RADIX_DAX_MASK)
+#define RADIX_DAX_SECTOR(entry) (((unsigned long)entry >> RADIX_DAX_SHIFT))
+#define RADIX_DAX_ENTRY(sector, pmd) ((void *)((unsigned long)sector << \
+		RADIX_DAX_SHIFT | (pmd ? RADIX_DAX_PMD : RADIX_DAX_PTE)))
+
 static long dax_map_atomic(struct block_device *bdev, struct blk_dax_ctl *dax)
 {
 	struct request_queue *q = bdev->bd_queue;
diff --git a/include/linux/radix-tree.h b/include/linux/radix-tree.h
index 51a97ac8bfbf..d08d6ec3bf53 100644
--- a/include/linux/radix-tree.h
+++ b/include/linux/radix-tree.h
@@ -52,15 +52,6 @@
 #define RADIX_TREE_EXCEPTIONAL_ENTRY	2
 #define RADIX_TREE_EXCEPTIONAL_SHIFT	2
 
-#define RADIX_DAX_MASK	0xf
-#define RADIX_DAX_SHIFT	4
-#define RADIX_DAX_PTE  (0x4 | RADIX_TREE_EXCEPTIONAL_ENTRY)
-#define RADIX_DAX_PMD  (0x8 | RADIX_TREE_EXCEPTIONAL_ENTRY)
-#define RADIX_DAX_TYPE(entry) ((unsigned long)entry & RADIX_DAX_MASK)
-#define RADIX_DAX_SECTOR(entry) (((unsigned long)entry >> RADIX_DAX_SHIFT))
-#define RADIX_DAX_ENTRY(sector, pmd) ((void *)((unsigned long)sector << \
-		RADIX_DAX_SHIFT | (pmd ? RADIX_DAX_PMD : RADIX_DAX_PTE)))
-
 static inline int radix_tree_is_indirect_ptr(void *ptr)
 {
 	return (int)((unsigned long)ptr & RADIX_TREE_INDIRECT_PTR);
-- 
2.6.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
