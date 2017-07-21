Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B993F2193B83E
 for <linux-nvdimm@lists.01.org>; Fri, 21 Jul 2017 15:38:14 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v4 5/5] dax: move all DAX radix tree defs to fs/dax.c
Date: Fri, 21 Jul 2017 16:39:55 -0600
Message-Id: <20170721223956.29485-6-ross.zwisler@linux.intel.com>
In-Reply-To: <20170721223956.29485-1-ross.zwisler@linux.intel.com>
References: <20170721223956.29485-1-ross.zwisler@linux.intel.com>
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
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, linux-doc@vger.kernel.org, David Airlie <airlied@linux.ie>, Dave Chinner <david@fromorbit.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, Christoph Hellwig <hch@lst.de>, linux-samsung-soc@vger.kernel.org, Joonyoung Shim <jy0922.shim@samsung.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Tomi Valkeinen <tomi.valkeinen@ti.com>, Kyungmin Park <kyungmin.park@samsung.com>, Krzysztof Kozlowski <krzk@kernel.org>, Ingo Molnar <mingo@redhat.com>, linux-ext4@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, linux-arm-msm@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, Inki Dae <inki.dae@samsung.com>, linux-nvdimm@lists.01.org, Alexander Viro <viro@zeniv.linux.org.uk>, linux-arm-kernel@lists.infradead.org, Theodore Ts'o <tytso@mit.edu>, Jonathan Corbet <corbet@lwn.net>, Seung-Woo Kim <sw0312.kim@samsung.com>, linux-xfs@vger.kernel.org, Rob Clark <robdclark@gmail.com>, Kukjin Kim <kgene@kernel.org>, linux-fsdevel@vger.kernel.org, freedreno@lists.freedesktop.org
List-ID: <linux-nvdimm@lists.01.org>

Now that we no longer insert struct page pointers in DAX radix trees the
page cache code no longer needs to know anything about DAX exceptional
entries.  Move all the DAX exceptional entry definitions from dax.h to
fs/dax.c.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Suggested-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c            | 34 ++++++++++++++++++++++++++++++++++
 include/linux/dax.h | 41 -----------------------------------------
 2 files changed, 34 insertions(+), 41 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 0e27d90..e7acc45 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -54,6 +54,40 @@ static int __init init_dax_wait_table(void)
 }
 fs_initcall(init_dax_wait_table);
 
+/*
+ * We use lowest available bit in exceptional entry for locking, one bit for
+ * the entry size (PMD) and two more to tell us if the entry is a zero page or
+ * an empty entry that is just used for locking.  In total four special bits.
+ *
+ * If the PMD bit isn't set the entry has size PAGE_SIZE, and if the ZERO_PAGE
+ * and EMPTY bits aren't set the entry is a normal DAX entry with a filesystem
+ * block allocation.
+ */
+#define RADIX_DAX_SHIFT		(RADIX_TREE_EXCEPTIONAL_SHIFT + 4)
+#define RADIX_DAX_ENTRY_LOCK	(1 << RADIX_TREE_EXCEPTIONAL_SHIFT)
+#define RADIX_DAX_PMD		(1 << (RADIX_TREE_EXCEPTIONAL_SHIFT + 1))
+#define RADIX_DAX_ZERO_PAGE	(1 << (RADIX_TREE_EXCEPTIONAL_SHIFT + 2))
+#define RADIX_DAX_EMPTY		(1 << (RADIX_TREE_EXCEPTIONAL_SHIFT + 3))
+
+static unsigned long dax_radix_sector(void *entry)
+{
+	return (unsigned long)entry >> RADIX_DAX_SHIFT;
+}
+
+static void *dax_radix_locked_entry(sector_t sector, unsigned long flags)
+{
+	return (void *)(RADIX_TREE_EXCEPTIONAL_ENTRY | flags |
+			((unsigned long)sector << RADIX_DAX_SHIFT) |
+			RADIX_DAX_ENTRY_LOCK);
+}
+
+static unsigned int dax_radix_order(void *entry)
+{
+	if ((unsigned long)entry & RADIX_DAX_PMD)
+		return PMD_SHIFT - PAGE_SHIFT;
+	return 0;
+}
+
 static int dax_is_pmd_entry(void *entry)
 {
 	return (unsigned long)entry & RADIX_DAX_PMD;
diff --git a/include/linux/dax.h b/include/linux/dax.h
index afa99bb..d0e3272 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -88,33 +88,6 @@ void dax_flush(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
 		size_t size);
 void dax_write_cache(struct dax_device *dax_dev, bool wc);
 
-/*
- * We use lowest available bit in exceptional entry for locking, one bit for
- * the entry size (PMD) and two more to tell us if the entry is a zero page or
- * an empty entry that is just used for locking.  In total four special bits.
- *
- * If the PMD bit isn't set the entry has size PAGE_SIZE, and if the ZERO_PAGE
- * and EMPTY bits aren't set the entry is a normal DAX entry with a filesystem
- * block allocation.
- */
-#define RADIX_DAX_SHIFT	(RADIX_TREE_EXCEPTIONAL_SHIFT + 4)
-#define RADIX_DAX_ENTRY_LOCK (1 << RADIX_TREE_EXCEPTIONAL_SHIFT)
-#define RADIX_DAX_PMD (1 << (RADIX_TREE_EXCEPTIONAL_SHIFT + 1))
-#define RADIX_DAX_ZERO_PAGE (1 << (RADIX_TREE_EXCEPTIONAL_SHIFT + 2))
-#define RADIX_DAX_EMPTY (1 << (RADIX_TREE_EXCEPTIONAL_SHIFT + 3))
-
-static inline unsigned long dax_radix_sector(void *entry)
-{
-	return (unsigned long)entry >> RADIX_DAX_SHIFT;
-}
-
-static inline void *dax_radix_locked_entry(sector_t sector, unsigned long flags)
-{
-	return (void *)(RADIX_TREE_EXCEPTIONAL_ENTRY | flags |
-			((unsigned long)sector << RADIX_DAX_SHIFT) |
-			RADIX_DAX_ENTRY_LOCK);
-}
-
 ssize_t dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
 		const struct iomap_ops *ops);
 int dax_iomap_fault(struct vm_fault *vmf, enum page_entry_size pe_size,
@@ -136,20 +109,6 @@ static inline int __dax_zero_page_range(struct block_device *bdev,
 }
 #endif
 
-#ifdef CONFIG_FS_DAX_PMD
-static inline unsigned int dax_radix_order(void *entry)
-{
-	if ((unsigned long)entry & RADIX_DAX_PMD)
-		return PMD_SHIFT - PAGE_SHIFT;
-	return 0;
-}
-#else
-static inline unsigned int dax_radix_order(void *entry)
-{
-	return 0;
-}
-#endif
-
 static inline bool dax_mapping(struct address_space *mapping)
 {
 	return mapping->host && IS_DAX(mapping->host);
-- 
2.9.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
