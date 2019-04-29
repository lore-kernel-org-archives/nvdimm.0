From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 15/18] btrfs: handle dax page zeroing
Date: Mon, 29 Apr 2019 12:26:46 -0500
Message-ID: <20190429172649.8288-16-rgoldwyn@suse.de>
References: <20190429172649.8288-1-rgoldwyn@suse.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20190429172649.8288-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
To: linux-btrfs@vger.kernel.org
Cc: kilobyte@angband.pl, linux-fsdevel@vger.kernel.org, jack@suse.cz, david@fromorbit.com, willy@infradead.org, hch@lst.de, darrick.wong@oracle.com, dsterba@suse.cz, nborisov@suse.com, linux-nvdimm@lists.01.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-nvdimm@lists.01.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

btrfs_dax_zero_block() zeros part of the page, either from the
front or the regular rest of the block.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/btrfs/ctree.h |  1 +
 fs/btrfs/dax.c   | 27 ++++++++++++++++++++++++++-
 fs/btrfs/inode.c |  4 ++++
 3 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index d3d044125619..ee1ed18f8b3c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3806,6 +3806,7 @@ vm_fault_t btrfs_dax_fault(struct vm_fault *vmf);
 int btrfs_dax_file_range_compare(struct inode *src, loff_t srcoff,
 		struct inode *dest, loff_t destoff, loff_t len,
 		bool *is_same);
+int btrfs_dax_zero_block(struct inode *inode, loff_t from, loff_t len, bool front);
 #else
 static inline ssize_t btrfs_file_dax_write(struct kiocb *iocb, struct iov_iter *from)
 {
diff --git a/fs/btrfs/dax.c b/fs/btrfs/dax.c
index af64696a5337..bf2ddac5b5a1 100644
--- a/fs/btrfs/dax.c
+++ b/fs/btrfs/dax.c
@@ -132,7 +132,8 @@ static int btrfs_iomap_begin(struct inode *inode, loff_t pos,
 	 * This will be true for reads only since we have already
 	 * allocated em
 	 */
-	if (em->block_start == EXTENT_MAP_HOLE) {
+	if (em->block_start == EXTENT_MAP_HOLE ||
+			em->flags == EXTENT_FLAG_FILLING) {
 		iomap->type = IOMAP_HOLE;
 		return 0;
 	}
@@ -235,4 +236,28 @@ int btrfs_dax_file_range_compare(struct inode *src, loff_t srcoff,
 	return dax_file_range_compare(src, srcoff, dest, destoff, len,
 				      is_same, &btrfs_iomap_ops);
 }
+
+/*
+ * zero a part of the page only. This should CoW (via iomap_begin) if required
+ */
+int btrfs_dax_zero_block(struct inode *inode, loff_t from, loff_t len, bool front)
+{
+	loff_t start = round_down(from, PAGE_SIZE);
+	loff_t end = round_up(from, PAGE_SIZE);
+	loff_t offset = from;
+	int ret = 0;
+
+	if (front) {
+		len = from - start;
+		offset = start;
+	} else	{
+		if (!len)
+			len = end - from;
+	}
+
+	if (len)
+		ret = iomap_zero_range(inode, offset, len, NULL, &btrfs_iomap_ops);
+
+	return (ret < 0) ? ret : 0;
+}
 #endif /* CONFIG_FS_DAX */
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 05714ffc4894..7e88280a2c3b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4833,6 +4833,10 @@ int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
 	    (!len || IS_ALIGNED(len, blocksize)))
 		goto out;
 
+#ifdef CONFIG_FS_DAX
+	if (IS_DAX(inode))
+		return btrfs_dax_zero_block(inode, from, len, front);
+#endif
 	block_start = round_down(from, blocksize);
 	block_end = block_start + blocksize - 1;
 
-- 
2.16.4
