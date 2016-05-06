Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id 612C81A1EE5
 for <linux-nvdimm@lists.01.org>; Fri,  6 May 2016 14:53:55 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v5 3/5] dax: use sb_issue_zerout instead of calling
 dax_clear_sectors
Date: Fri,  6 May 2016 15:53:09 -0600
Message-Id: <1462571591-3361-4-git-send-email-vishal.l.verma@intel.com>
In-Reply-To: <1462571591-3361-1-git-send-email-vishal.l.verma@intel.com>
References: <1462571591-3361-1-git-send-email-vishal.l.verma@intel.com>
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
Cc: Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-block@vger.kernel.org, linux-mm@kvack.org, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

From: Matthew Wilcox <matthew.r.wilcox@intel.com>

dax_clear_sectors() cannot handle poisoned blocks.  These must be
zeroed using the BIO interface instead.  Convert ext2 and XFS to use
only sb_issue_zerout().

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
[vishal: Also remove the dax_clear_sectors function entirely]
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 fs/dax.c               | 32 --------------------------------
 fs/ext2/inode.c        |  7 +++----
 fs/xfs/xfs_bmap_util.c | 15 ++++-----------
 include/linux/dax.h    |  1 -
 4 files changed, 7 insertions(+), 48 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 52f0044..5948d9b 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -116,38 +116,6 @@ struct page *read_dax_sector(struct block_device *bdev, sector_t n)
 	return page;
 }
 
-/*
- * dax_clear_sectors() is called from within transaction context from XFS,
- * and hence this means the stack from this point must follow GFP_NOFS
- * semantics for all operations.
- */
-int dax_clear_sectors(struct block_device *bdev, sector_t _sector, long _size)
-{
-	struct blk_dax_ctl dax = {
-		.sector = _sector,
-		.size = _size,
-	};
-
-	might_sleep();
-	do {
-		long count, sz;
-
-		count = dax_map_atomic(bdev, &dax);
-		if (count < 0)
-			return count;
-		sz = min_t(long, count, SZ_128K);
-		clear_pmem(dax.addr, sz);
-		dax.size -= sz;
-		dax.sector += sz / 512;
-		dax_unmap_atomic(bdev, &dax);
-		cond_resched();
-	} while (dax.size);
-
-	wmb_pmem();
-	return 0;
-}
-EXPORT_SYMBOL_GPL(dax_clear_sectors);
-
 static bool buffer_written(struct buffer_head *bh)
 {
 	return buffer_mapped(bh) && !buffer_unwritten(bh);
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 1f07b75..35f2b0bf 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -26,6 +26,7 @@
 #include <linux/highuid.h>
 #include <linux/pagemap.h>
 #include <linux/dax.h>
+#include <linux/blkdev.h>
 #include <linux/quotaops.h>
 #include <linux/writeback.h>
 #include <linux/buffer_head.h>
@@ -737,10 +738,8 @@ static int ext2_get_blocks(struct inode *inode,
 		 * so that it's not found by another thread before it's
 		 * initialised
 		 */
-		err = dax_clear_sectors(inode->i_sb->s_bdev,
-				le32_to_cpu(chain[depth-1].key) <<
-				(inode->i_blkbits - 9),
-				1 << inode->i_blkbits);
+		err = sb_issue_zeroout(inode->i_sb,
+				le32_to_cpu(chain[depth-1].key), 1, GFP_NOFS);
 		if (err) {
 			mutex_unlock(&ei->truncate_mutex);
 			goto cleanup;
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 3b63098..930ac6a 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -72,18 +72,11 @@ xfs_zero_extent(
 	struct xfs_mount *mp = ip->i_mount;
 	xfs_daddr_t	sector = xfs_fsb_to_db(ip, start_fsb);
 	sector_t	block = XFS_BB_TO_FSBT(mp, sector);
-	ssize_t		size = XFS_FSB_TO_B(mp, count_fsb);
-
-	if (IS_DAX(VFS_I(ip)))
-		return dax_clear_sectors(xfs_find_bdev_for_inode(VFS_I(ip)),
-				sector, size);
-
-	/*
-	 * let the block layer decide on the fastest method of
-	 * implementing the zeroing.
-	 */
-	return sb_issue_zeroout(mp->m_super, block, count_fsb, GFP_NOFS);
 
+	return blkdev_issue_zeroout(xfs_find_bdev_for_inode(VFS_I(ip)),
+		block << (mp->m_super->s_blocksize_bits - 9),
+		count_fsb << (mp->m_super->s_blocksize_bits - 9),
+		GFP_NOFS, true);
 }
 
 /*
diff --git a/include/linux/dax.h b/include/linux/dax.h
index ef94fa7..426841a 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -11,7 +11,6 @@
 
 ssize_t dax_do_io(struct kiocb *, struct inode *, struct iov_iter *, loff_t,
 		  get_block_t, dio_iodone_t, int flags);
-int dax_clear_sectors(struct block_device *bdev, sector_t _sector, long _size);
 int dax_zero_page_range(struct inode *, loff_t from, unsigned len, get_block_t);
 int dax_truncate_page(struct inode *, loff_t from, get_block_t);
 int dax_fault(struct vm_area_struct *, struct vm_fault *, get_block_t);
-- 
2.5.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
