Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C58D71A1E2F
 for <linux-nvdimm@lists.01.org>; Tue, 23 Aug 2016 15:04:32 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v2 4/9] dax: remove buffer_size_valid()
Date: Tue, 23 Aug 2016 16:04:14 -0600
Message-Id: <20160823220419.11717-5-ross.zwisler@linux.intel.com>
In-Reply-To: <20160823220419.11717-1-ross.zwisler@linux.intel.com>
References: <20160823220419.11717-1-ross.zwisler@linux.intel.com>
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
To: linux-kernel@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, linux-nvdimm@lists.01.org, Matthew Wilcox <mawilcox@microsoft.com>, Dave Chinner <david@fromorbit.com>, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Now that all our supported filesystems (ext2, ext4 and XFS) all properly
set bh.b_size when we call get_block() for a hole, rely on that value and
remove the buffer_size_valid() sanity check.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c | 22 +---------------------
 1 file changed, 1 insertion(+), 21 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 993dc6f..8030f93 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -121,19 +121,6 @@ static bool buffer_written(struct buffer_head *bh)
 	return buffer_mapped(bh) && !buffer_unwritten(bh);
 }
 
-/*
- * When ext4 encounters a hole, it returns without modifying the buffer_head
- * which means that we can't trust b_size.  To cope with this, we set b_state
- * to 0 before calling get_block and, if any bit is set, we know we can trust
- * b_size.  Unfortunate, really, since ext4 knows precisely how long a hole is
- * and would save us time calling get_block repeatedly.
- */
-static bool buffer_size_valid(struct buffer_head *bh)
-{
-	return bh->b_state != 0;
-}
-
-
 static sector_t to_sector(const struct buffer_head *bh,
 		const struct inode *inode)
 {
@@ -175,8 +162,6 @@ static ssize_t dax_io(struct inode *inode, struct iov_iter *iter,
 				rc = get_block(inode, block, bh, rw == WRITE);
 				if (rc)
 					break;
-				if (!buffer_size_valid(bh))
-					bh->b_size = 1 << blkbits;
 				bh_max = pos - first + bh->b_size;
 				bdev = bh->b_bdev;
 				/*
@@ -1010,12 +995,7 @@ int dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 
 	bdev = bh.b_bdev;
 
-	/*
-	 * If the filesystem isn't willing to tell us the length of a hole,
-	 * just fall back to PTEs.  Calling get_block 512 times in a loop
-	 * would be silly.
-	 */
-	if (!buffer_size_valid(&bh) || bh.b_size < PMD_SIZE) {
+	if (bh.b_size < PMD_SIZE) {
 		dax_pmd_dbg(&bh, address, "allocated block too small");
 		return VM_FAULT_FALLBACK;
 	}
-- 
2.9.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
