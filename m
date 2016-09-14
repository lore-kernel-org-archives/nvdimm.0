From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 11/12] ext2: stop passing buffer_head to ext2_get_blocks
Date: Wed, 14 Sep 2016 12:01:30 +0200
Message-ID: <1473847291-18913-12-git-send-email-hch@lst.de>
References: <1473847291-18913-1-git-send-email-hch@lst.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1473847291-18913-1-git-send-email-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org
Cc: ross.zwisler@linux.intel.com
List-Id: linux-nvdimm@lists.01.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/ext2/inode.c | 39 ++++++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 15 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index d5c7d09..2a69ab2 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -618,7 +618,7 @@ static void ext2_splice_branch(struct inode *inode,
  */
 static int ext2_get_blocks(struct inode *inode,
 			   sector_t iblock, unsigned long maxblocks,
-			   struct buffer_head *bh_result,
+			   u32 *bno, bool *new, bool *boundary,
 			   int create)
 {
 	int err = -EIO;
@@ -644,7 +644,6 @@ static int ext2_get_blocks(struct inode *inode,
 	/* Simplest case - block found, no allocation needed */
 	if (!partial) {
 		first_block = le32_to_cpu(chain[depth - 1].key);
-		clear_buffer_new(bh_result); /* What's this do? */
 		count++;
 		/*map more blocks*/
 		while (count < maxblocks && count <= blocks_to_boundary) {
@@ -699,7 +698,6 @@ static int ext2_get_blocks(struct inode *inode,
 			mutex_unlock(&ei->truncate_mutex);
 			if (err)
 				goto cleanup;
-			clear_buffer_new(bh_result);
 			goto got_it;
 		}
 	}
@@ -745,15 +743,16 @@ static int ext2_get_blocks(struct inode *inode,
 			mutex_unlock(&ei->truncate_mutex);
 			goto cleanup;
 		}
-	} else
-		set_buffer_new(bh_result);
+	} else {
+		*new = true;
+	}
 
 	ext2_splice_branch(inode, iblock, partial, indirect_blks, count);
 	mutex_unlock(&ei->truncate_mutex);
 got_it:
-	map_bh(bh_result, inode->i_sb, le32_to_cpu(chain[depth-1].key));
+	*bno = le32_to_cpu(chain[depth-1].key);
 	if (count > blocks_to_boundary)
-		set_buffer_boundary(bh_result);
+		*boundary = true;
 	err = count;
 	/* Clean up and exit */
 	partial = chain + depth - 1;	/* the whole chain */
@@ -765,16 +764,26 @@ cleanup:
 	return err;
 }
 
-int ext2_get_block(struct inode *inode, sector_t iblock, struct buffer_head *bh_result, int create)
+int ext2_get_block(struct inode *inode, sector_t iblock,
+		struct buffer_head *bh_result, int create)
 {
 	unsigned max_blocks = bh_result->b_size >> inode->i_blkbits;
-	int ret = ext2_get_blocks(inode, iblock, max_blocks,
-			      bh_result, create);
-	if (ret > 0) {
-		bh_result->b_size = (ret << inode->i_blkbits);
-		ret = 0;
-	}
-	return ret;
+	bool new = false, boundary = false;
+	u32 bno;
+	int ret;
+
+	ret = ext2_get_blocks(inode, iblock, max_blocks, &bno, &new, &boundary,
+			create);
+	if (ret <= 0)
+		return ret;
+
+	map_bh(bh_result, inode->i_sb, bno);
+	bh_result->b_size = (ret << inode->i_blkbits);
+	if (new)
+		set_buffer_new(bh_result);
+	if (boundary)
+		set_buffer_boundary(bh_result);
+	return 0;
 
 }
 
-- 
2.1.4

