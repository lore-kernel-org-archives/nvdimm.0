Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 14CD41A1E3E
 for <linux-nvdimm@lists.01.org>; Thu, 29 Sep 2016 15:49:35 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v4 01/12] ext4: allow DAX writeback for hole punch
Date: Thu, 29 Sep 2016 16:49:19 -0600
Message-Id: <1475189370-31634-2-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1475189370-31634-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1475189370-31634-1-git-send-email-ross.zwisler@linux.intel.com>
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
Cc: Theodore Ts'o <tytso@mit.edu>, Matthew Wilcox <mawilcox@microsoft.com>, Dave Chinner <david@fromorbit.com>, linux-nvdimm@lists.01.org, stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

Currently when doing a DAX hole punch with ext4 we fail to do a writeback.
This is because the logic around filemap_write_and_wait_range() in
ext4_punch_hole() only looks for dirty page cache pages in the radix tree,
not for dirty DAX exceptional entries.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: <stable@vger.kernel.org>
---
 fs/ext4/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3131747..0900cb4 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3890,7 +3890,7 @@ int ext4_update_disksize_before_punch(struct inode *inode, loff_t offset,
 }
 
 /*
- * ext4_punch_hole: punches a hole in a file by releaseing the blocks
+ * ext4_punch_hole: punches a hole in a file by releasing the blocks
  * associated with the given offset and length
  *
  * @inode:  File inode
@@ -3919,7 +3919,7 @@ int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
 	 * Write out all dirty pages to avoid race conditions
 	 * Then release them.
 	 */
-	if (mapping->nrpages && mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
+	if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
 		ret = filemap_write_and_wait_range(mapping, offset,
 						   offset + length - 1);
 		if (ret)
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
